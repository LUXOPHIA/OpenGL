# LUX.Data.Tree
[English](../README.md) | [日本語](README.md)

`LUX.Data.List` の上に築かれた汎用の木構造。根・節・葉の3種のノードがひとつの基底クラスを共有するので木全体を一様に扱え、ジェネリック層が `Parent` と `Childrs` の相互参照を — 自己再帰型も含めて — 利用側のクラスへ型付けする。

## 1. 概要

ノードの種類は次のとおり。

```
・TTreeRoot<TChildr_>          ･･･ 親に所属できず、子を持てる
・TTreeKnot<TParent_,TChildr_> ･･･ 親に所属でき、子も持てる
・TTreeLeaf<TParent_>          ･･･ 親に所属でき、子リストの費用を一切払わない
```

3種はすべて `TTreeNode` の派生であり、`TTreeNode` として扱える — `Parent`・`Root`・`Level`・`Prev`・`Next`・`Childrs`・`for-in`・`All`。型引数の制約が `class` だけなのは、自分自身を親型や子型に指定する自己再帰型を許すためであり、より細かい要件（親は `TTreeStem` の、子は `TTreeNode` の派生であること）は実行時に `ETreeError` で強制される。

所有権はリストに従う。`Free` は部分木ごと解放し、`Remove` は切り離すだけであり（外れた部分木は呼び出し側の所有）、`Parent` への代入はノードを旧親から外して新親の末尾へ移す。子リストは最初の子が付くときに遅延生成される。

## 2. 技術的背景

### 2.1 平坦な先行順走査

`for N in Node.All do` は `Node` を頂点とする部分木を（`Node` 自身を含めて）先行順で歩く。再帰もスタックもヒープ確保も使わない。列挙子はポインタ2本のレコードであり、その後続関数は、子があれば最初の子へ降り、無ければ右の兄弟が現れるまで昇り、頂点で止まる。

```math
\mathrm{succ}(n) =
\begin{cases}
\mathrm{Header}(n) & \mathrm{Header}(n) \neq \mathrm{nil} \\[4pt]
\mathrm{Next}(m), \quad m = n \text{ 自身または最も近い、右の兄弟を持つ先祖} & \text{それ以外}
\end{cases} \qquad \text{(2.1)}
```

親子のリンクをまたぐのは下りに高々1回・上りに高々1回なので、$V$ 個のノードからなる部分木の全走査は

```math
T \le 2\,(V - 1) + V = O(V) \qquad \text{(2.2)}
```

リンクステップ・O(1) メモリで済む。`All` は先読みをしないため、走査中に木の構造を変更してはならない。いっぽう直下の子の列挙子（`for C in Node do`）は先読みをするので、列挙中の `Current` の削除は安全である。

### 2.2 不変条件・関所・通知

木を壊す操作 — 先祖（や自分自身）を子にする、`TTreeRoot` を親に所属させる、親が受け入れない子を挿す — は、Release ビルドでも `ETreeError` を送出する。すべての挿入は子リスト `TTreeChildrs` を通り、そこで親の `AcceptChildr`（型付け層の既定は `TChildr_` とその派生だけを受け入れる）に問い、続いて `OnInsertChildr` / `OnRemoveChildr` で親に通知する。3つとも仮想メソッドである。List 層由来の低水準操作 `InsertPrev` / `InsertNext` は循環と Root の検査を通らないので、木の操作は本ユニットの API — `Add`・`InsertHead`・`InsertTail`・`Parent`・`Create` — で行うこと。

`BeginUpdate` / `EndUpdate` は子を持てるノードすべてで変更を一括にできる。費用はノードあたり 1 Byte（255 段まで入れ子可）。派生クラスは通知処理の入口で `Updating` を検査して発火を止め、最外殻の `EndUpdate` は — 変更の有無に関わらず — `Updated` をちょうど1回呼ぶ。破棄は「終わらない一括更新」として扱われる。破棄中のノードは `Updating` になるため自身の通知は沈黙し、生き残る親には外れた部分木についてちょうど1回の通知が届く。

## 3. アーキテクチャ

### 3.1 クラス構成

```
・TTreeNode ( = TListChildr )                         ･･･ メンバは §1 のとおり
  ┣・TTreeStem                                       ･･･ 子を持てる
  ┃  ┗・TTreeStem<TChildr_>                         ･･･ 子を型付け
  ┃     ┣・TTreeRoot<TChildr_>                      ･･･ どの親への所属も拒む
  ┃     ┗・TTreeKnot<TParent_,TChildr_>             ･･･ Parent も型付け
  ┗・TTreeLeaf<TParent_>                             ･･･ Parent を型付け

・TTreeChildrs ( = TListParent<TTreeNode,TTreeNode> ) ･･･ 挿入の関所
・TTreeEnumer / TTreeEnumer<TChildr_>                 ･･･ 直下の子。先読みつき
・TTreeEnumerAll                                      ･･･ 部分木の先行順走査
```

`ForceChildrs` は子リストを必要時に生成する仮想メソッドであり、派生クラスは自前の `TTreeChildrs` 派生に差し替えられる。

### 3.2 ファイル構成

```
・Data/Tree/
  ┗・LUX.Data.Tree.pas ･･･ 上記のすべてを1ユニットに収める
```

依存は `System.SysUtils`・`LUX.Data.List.core`・`LUX.Data.List` のみ。

## 4. 使い方

```pascal
uses LUX.Data.Tree;

type
   TNode = class( TTreeKnot<TNode,TNode> )   // 自己再帰：自分自身を
   end;                                      // 親型・子型に指定する

   TRoot = class( TTreeRoot<TNode> )
   end;

var
   R    :TRoot;
   A, B :TNode;
   N    :TTreeNode;
begin
     R := TRoot.Create;
     try
        A := TNode.Create;  R.Add( A );      // 根に取り付ける
        B := TNode.Create( A );              // 生成と同時に A へ取り付ける

        B.Parent := nil;                     // 切り離す — B は呼び出し側の所有
        B.Parent := A;                       // 再び取り付ける（自動移籍）

        for N in R do { ... };               // 直下の子だけ
        for N in R.All do { ... };           // 部分木全体を先行順で

        R.BeginUpdate;
        try
           // 多数の変更。通知は沈黙する
        finally
           R.EndUpdate;                      // Updated がちょうど1回発火
        end;
     finally
        R.Free;                              // 部分木ごと解放する
     end;
end;
```

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
