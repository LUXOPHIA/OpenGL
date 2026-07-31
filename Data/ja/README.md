# LUX.Data
[English](../README.md) | [日本語](README.md)

`LUX.Data` は LUX ライブラリのデータ構造部門であり、汎用コンテナ・メッシュ・画像がそれぞれ専用のサブフォルダと README を持つ。ユニット `LUX.Data` 自体は、部門のファイル形式が共有する小さなストリーム補助 — UTF-8 行とテキストヘッダ — を提供する。

## 1. 概要

* [**Grid**](../Grid/ja/README.md) ：1次元の点グリッドと三角形の2次元グリッド
* [**Image**](../Image/ja/README.md) ：タイル＋縮小ピラミッドの超高解像度画像とリアルタイムビューア
* [**List**](../List/ja/README.md) ：逐次インデックス付きの侵入型双方向リスト（核＋型付け層）
* [**Model**](../Model/ja/README.md) ：コーナーテーブル式メッシュ — TriFlip（2次元）と TetraFlip（3次元）
* [**Tree**](../Tree/ja/README.md) ：リスト上の汎用木構造 — TTreeRoot / TTreeKnot / TTreeLeaf

コンテナは層構造で作られている。無型の核が実務を担い、その上の薄いジェネリック層が相互参照プロパティを利用側のクラスへ型付けし直すので、利用側のコードにダウンキャストは現れない。`List` が土台であり、`Tree` は `List` の上に築かれ、`Model` も同じ層構造の考え方をメッシュに再利用している。

## 2. 技術的背景

`LUX.Data` は、部門のバイナリファイル形式（`*.lxtf`・`*.lxtc`）が使うテキストヘッダの約束事を定める。

```
magic 行     ･･･ 形式を識別する。UTF-8・LF 終端
オプション行 ･･･ 0行以上の自由書式の行
空行         ･･･ 終端 — これより後ろはバイナリ
```

`WriteLine` / `ReadLine` は UTF-8 の1行を転送する。終端は素の LF であり、`ReadLine` は CR を黙って捨てるので、CRLF に変換されたファイルも往復できる。`WriteHead` は magic・オプション・空行を書き込み、`ReadHead` は magic を検証して — 不一致なら `EInOutError` を送出し — オプション行を返し、ストリームは最初のバイナリバイトの位置に置かれる。

## 3. アーキテクチャ

```
・Data/
  ┣・LUX.Data.pas ･･･ WriteLine / ReadLine / WriteHead / ReadHead
  ┣・Grid/        ･･･ LUX.Data.Grid.D1  LUX.Data.Grid.Tria.D2
  ┣・Image/       ･･･ LUX.Data.Image ( + .Files  .Viewer )
  ┣・List/        ･･･ LUX.Data.List.core  LUX.Data.List
  ┣・Model/       ･･･ LUX.Data.Model.*  ( TriFlip/  TetraFlip/ )
  ┗・Tree/        ･･･ LUX.Data.Tree
```

`LUX.Data` が依存するのは `System.Classes` と `System.SysUtils` のみ。各サブフォルダの依存関係はそれぞれの README に記す。

## 4. 使い方

```pascal
uses System.Classes, LUX.Data;

var
   S :TMemoryStream;
   O :TArray<String>;
begin
     S := TMemoryStream.Create;
     try
        ///// 書き込み：ヘッダを先に、続けてバイナリ本体
        WriteHead( S, 'MyFormat 1.0', [ 'Count=3' ] );
        // ... バイナリデータを書き込む ...

        ///// 読み込み：magic を検証し、オプションを集める
        S.Position := 0;
        O := ReadHead( S, 'MyFormat 1.0' );  // 不一致なら EInOutError
        // O = [ 'Count=3' ] で、S.Position はバイナリ本体の先頭にある
     finally
        S.Free;
     end;
end;
```

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
