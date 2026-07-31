# LUX.Data.List
[English](../README.md) | [日本語](README.md)

2層構造の侵入型双方向リスト。実務を担う無型の核（`LUX.Data.List.core`）と、相互参照プロパティ — `Parent`・`Childrs`・列挙子 — を利用側のクラスへ型付けし直すジェネリックの型付け層（`LUX.Data.List`）からなり、利用側のコードにダウンキャストは現れない。

## 1. 概要

このリストは侵入型である。ノード**が** `TListChildr` であり、リスト**が** `TListParent` であり、両者は `_Prev` / `_Next` のリンクを担う `TListObject` から派生する。要素ごとの包装オブジェクトは存在しないので、所属の費用はポインタ2本であり、挿抜は純粋なリンクの繋ぎ替えである。

所有権は明示的である。親は子を所有する：`Clear` とデストラクタは子を解放する。`Remove` は切り離すだけで — 外れたノードは呼び出し側の所有物になる — ノードの `Free` は切り離してから破棄する。`Parent` への代入は、ノードを旧リストから外して新リストの末尾へ移す。

リンク構造の上で親は逐次インデックスを維持しており、`Childrs[ I_ ]`（別名 `Items` / `Count` からも届く）は前進走査に対してアクセスごと O(n) ではなく償却 O(1) である。`for-in` は1要素の先読みで列挙するので、列挙中に現在の要素を削除しても安全である。

## 2. 技術的背景

### 2.1 番兵の輪

親と子はひとつの円環をなし、親自身が番兵（`Origin`）を務める。空リストは1個の輪であり、親のリンクは自分自身を指す。番兵が常に存在するため、`InsertHead`・`InsertTail`・`InsertPrev`・`InsertNext`・`Remove` は分岐のないリンクの繋ぎ替えとなり、すべて O(1) で、`Bind` 補助メソッドが実行する。

### 2.2 逐次インデックス

親は輪の先頭 $M+1$ 個のノードを配列（`_Indexes`）にキャッシュする。$M$ = `_MaxOrder` はこれまでにインデックス化された最大の位置である。`Childrs[ i ]` の読み出しが輪を歩くのは未インデックスの末尾

```math
C(i) = \max( 0, \; i - M ) \qquad \text{(2.1)}
```

リンク分だけであり、通過したノードをすべて記録するので、$N$ 個のリストの前進走査は合計で高々

```math
\sum_{i=0}^{N-1} C(i) \le N \qquad \text{(2.2)}
```

リンクステップ — アクセスあたり償却 O(1) — で済む。変更が無効化するのはインデックスの末尾だけである。先頭への挿入は $M$ を $-1$ に戻し、インデックス済みノードの削除は $M$ をその位置の1つ手前へ切り詰め、インデックス配列は要素数が容量の半分を割ると縮む。

`Order` は同じインデックスを通してノードの位置を読む。`Order` への代入はその位置にいるノードとの**交換**として定義され — 間のノードはシフトしない — `Swap` が実装し、両ノードのインデックス項目も修復する。

## 3. アーキテクチャ

### 3.1 クラス構成

```
・TListObject                               ･･･ 輪をなす _Prev / _Next リンク
  ┣・TListChildr                           ･･･ Parent・Order・Insert*・Remove
  ┃  ┗・TListChildr<TParent_>             ･･･ Parent を型付け
  ┃     ┗・TListChildr<TOwnere_,TParent_> ･･･ Ownere を追加
  ┗・TListParent                           ･･･ 番兵 Origin・インデックス・Clear
     ┗・TListParent<TChildr_>              ･･･ Childrs と挿抜イベント
        ┗・TListParent<TOwnere_,TChildr_>  ･･･ Ownere を追加

・TListEnumer                               ･･･ 先読みで Current の削除が安全
・TListEnumer<TChildr_>                     ･･･ 核のレコードへ転送する包み
```

親はすべての挿抜の前後で `OnInsertChildr` / `OnRemoveChildr` を、空リストへの最初のアクセスで `OnInit` を発火する。いずれも派生リストのための仮想フックである。`Ownere` 層は、ノードから自分のリストを所有するオブジェクトへ届く道を与える（`OwnereObject` は仮想メソッドなので、ジェネリックの実体をまたいで機能する）— `LUX.Data.Tree` はこの上に築かれている。

核に刻まれた命名上の注意：無型のアクセサが `GetParent0` / `SetParent0` と名乗るのは、型付け層が同名の型付きアクセサを素直に宣言できるようにするためである。同名のまま reintroduce すると、相互再帰するジェネリックの実体化で dcc64 がプロパティの読み取りを見失う（E2130）。

### 3.2 ファイル構成

```
・Data/List/
  ┣・LUX.Data.List.core.pas ･･･ 無型の核と TListEnumer
  ┗・LUX.Data.List.pas      ･･･ 核の上の型付け層
```

核の依存は `System.SysUtils` のみ。型付け層の依存は核のみ。

## 4. 使い方

`TChildr_` には `TListChildr` の**真の派生クラス**を指定すること — 基底そのものだと型付きの `overload` が無型のものと衝突する。

```pascal
uses LUX.Data.List.core, LUX.Data.List;

type
   TItem = class;

   TItems = class( TListParent<TItem> )
   end;

   TItem = class( TListChildr<TItems> )
   end;

var
   Items :TItems;
   I     :TItem;
begin
     Items := TItems.Create;
     try
        TItem.Create( Items );       // Create( Parent ) で末尾へ加わる
        TItem.Create( Items );
        TItem.Create( Items );

        for I in Items do { ... };   // 先読み：ここで I を Free しても安全

        Items[ 0 ].Order := 2;       // 順位 2 のノードと交換する

        I := Items.Header;
        I.Remove;                    // 切り離すのみ — I は呼び出し側の所有に
        I.Free;                      // ノードの Free も先に自分を切り離す
     finally
        Items.Free;                  // 残りの子をすべて解放する
     end;
end;
```

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
