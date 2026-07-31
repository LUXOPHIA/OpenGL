# LUX.Data.Model
[English](../README.md) | [日本語](README.md)

LUX のメッシュモデル層。3つの小さなユニットが共通の語彙 — 点（`Poins`）・面（`Faces`）・胞（`Cells`）のジェネリックなリストコンテナ — を定義し、その上に2つのサブフォルダがコーナーテーブル方式のメッシュを構築する。

* [**TriFlip**](../TriFlip/ja/README.md) ：コーナーテーブル上の2次元三角形メッシュ — 貼り合わせ・頂点環・対角線交換・`*.lxtf`。
* [**TetraFlip**](../TetraFlip/ja/README.md) ：コーナーテーブル上の3次元四面体メッシュ — 回転コードによる面の貼り合わせ・`*.lxtc`。

## 1. 概要

*モデル*とは、点集合の上に要素 — 2次元では面、3次元では胞 — の集合を載せたものである。3つのユニットはその語彙のジェネリックなシグネチャを定める。

- **`LUX.Data.Model.Poins`** — `TPoin<TPos_;TPoinSet_>` は型 `TPos_` の座標 `Pos` を保持する。`TPoinSet<TPos_;TPoin_>` はそのコンテナであり、ストリーミングの型式を定める。`SaveToStream` は全ての点の生の座標を書き込み、`LoadFromStream` は座標列から生成した点で置き換える。具体的な点の型の知識は派生集合に委ねられており、`SaveToStream` と点のファクトリ `LoadPoin` は抽象である。
- **`LUX.Data.Model.Faces`** — `TFace<TPos_;TFaceSet_>` / `TFaceSet<TPos_;TFace_>`。2次元要素の空の基底対。
- **`LUX.Data.Model.Cells`** — `TCell<TPos_;TCellSet_>` / `TCellSet<TPos_;TCell_>`。3次元要素の同様の基底対。

6つのクラスはいずれも `LUX.Data.List` の双方向リストの薄い拡張である。各要素は所属先の `Parent` と順位 `Order` を知り、各集合は列挙可能なコンテナ（`Childrs[]` / `ChildrsN` / `Count`）である。サブフォルダのファイル形式が永続的な要素番号として用いるのが `Order` である。

座標はこのフォルダとサブフォルダのどのアルゴリズムにも登場しない。層全体が純粋に組合せ的であり、`TPos_` は保存とストリーミングの対象にすぎない。幾何学的な述語は利用側 — 例えば [LUX.Delaunay](https://github.com/LUXOPHIA/LUX.Delaunay) — に属する。

## 2. アーキテクチャ

### 2.1 クラス図

```
・TListChildr<TParent_>      ･･･ (LUX.Data.List)
  ┣・TPoin<TPos_,TPoinSet_> ･･･ Pos :TPos_
  ┣・TFace<TPos_,TFaceSet_> ･･･ 2次元要素の基底
  ┗・TCell<TPos_,TCellSet_> ･･･ 3次元要素の基底

・TListParent<TChildr_>      ･･･ (LUX.Data.List)
  ┣・TPoinSet<TPos_,TPoin_> ･･･ LoadPoin, SaveToStream, LoadFromStream
  ┣・TFaceSet<TPos_,TFace_> ･･･ 2次元コンテナの基底
  ┗・TCellSet<TPos_,TCell_> ･･･ 3次元コンテナの基底
```

### 2.2 ファイル構成

```
・Model/
  ┣・LUX.Data.Model.Poins.pas ･･･ unit LUX.Data.Model.Poins
  ┣・LUX.Data.Model.Faces.pas ･･･ unit LUX.Data.Model.Faces
  ┣・LUX.Data.Model.Cells.pas ･･･ unit LUX.Data.Model.Cells
  ┣・TriFlip/                 ･･･ TriFlip.* — 2次元三角形メッシュ
  ┣・TetraFlip/               ･･･ TetraFlip.* — 3次元四面体メッシュ
  ┣・README.md                ･･･ 本文書（英語版）
  ┗・ja/README.md             ･･･ 日本語版
```

## 3. 使用法

これらのユニットを直接使うことはない。具体的なメッシュがこれらから派生し、点のファクトリと座標のストリーミングを実装する。その型式のリポジトリ内の実例が `LUX.Data.Model.TriFlip.core` である。

```pascal
uses System.Classes, LUX.D2, LUX.Data.Model.Poins;

type
     TMyPoin    = class;
     TMyPoinSet = class;

     TMyPoin = class( TPoin<TSingle2D,TMyPoinSet> );

     TMyPoinSet = class( TPoinSet<TSingle2D,TMyPoin> )
     protected
       function LoadPoin( const Pos_:TSingle2D ) :TMyPoin; override;
     public
       procedure SaveToStream( const Stream_:TStream ); override;
     end;
```

それより先 — 接続構造・貼り合わせ・巡回・ファイル入出力 — はサブフォルダの文書 [TriFlip](../TriFlip/ja/README.md) と [TetraFlip](../TetraFlip/ja/README.md) を参照。

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
