# LUX.Data.Model.TetraFlip
[English](../README.md) | [日本語](README.md)

Delphi 向けのコーナーテーブル方式の四面体メッシュ — [TriFlip](../../TriFlip/ja/README.md) の立体版。胞は `Weld` で面どうしを貼り合わせ、その貼り合わせの回転コードは頂点の同一性から導出される。メッシュは接続構造ごと `*.lxtc` ファイルに永続化される。この層は純粋に組合せ的であり — 座標は型引数にすぎず、どのアルゴリズムにも登場しない — [LUX.Delaunay](https://github.com/LUXOPHIA/LUX.Delaunay)`.D3` のメッシュ基盤である。

## 1. 概要

このフォルダは1つの構造を3層に分けて保持する。

| ユニット | 層 |
|---|---|
| `LUX.Data.Model.TetraFlip.core` | 実装層 — 全てのフィールドとアルゴリズム。座標型 `TPos_` についてジェネリック。 |
| `LUX.Data.Model.TetraFlip` | 型付け層 — 相互参照を利用者の派生クラスの型へ付け替える。 |
| `LUX.Data.Model.TetraFlip.D3` | 3次元特殊化 — `TPos_` を `TSingle3D` に固定。 |

メッシュとは、四面体 `TTetraCell` の胞集合 `TTetraCellSet`（点集合 `TTetraPoinSet` を所有する）である。各胞は4頂点 `Poin[0..3]` と4つの隣接胞 `Cell[0..3]`、そして3つの詰め込みバイトを保持する。`_Corn` と `_Bond` はそれぞれ 2 ビット × 4 の値 — 隣接胞から見た対頂点の番号と共有面の回転コード — を持ち、`_Flag` は探索の状態管理のための自由な1バイトである。各頂点は座標 `Pos` と*アンカー* — 自分を含む胞 `Cell` とその中での角番号 `Corn` — を保持するので、頂点の星（周囲の胞）の探索は O(1) で始められる。胞の面 K とは頂点 K の対面のことであり、その3つの隣接スロット `Cell[K]` / `Corn[K]` / `Bond[K]` が貼り合わせを完全に記述する。貼り合わせ自体は `Weld` の一手のみで、利用側が回転コードを手計算することはない。

## 2. 技術的背景

### 2.1 コーナーの枠 — `VertTable`

コーナーは `0..3` で番号付けられる。各面 $K$（頂点 $K$ の対面）について、`VertTable[K]` は頂点を*正準の枠*で並べる。枠番号 0 は対頂点 $K$ そのもの、枠番号 1..3 は面の頂点である。4つの行

```math
V_0 = e ,\quad
V_1 = (0\,1)(2\,3) ,\quad
V_2 = (0\,2)(1\,3) ,\quad
V_3 = (0\,3)(1\,2)
\qquad \text{(2.1)}
```

はちょうど $\{0,1,2,3\}$ の二重互換（クラインの四元群）である。各行は*偶*置換なので、どの面から見ても胞の向きは一致する。さらに各行は*対合*（自分自身が逆置換）なので、同じ表が両方向 — 枠番号 → 頂点番号と頂点番号 → 枠番号 — の変換に使える。

### 2.2 面の貼り合わせ — `BondTable` と `Join`

共有される三角形は、両側の胞から*逆*向きに見える。したがって貼り合わせとは、対頂点の枠番号 0 を固定する、向きを反転する枠どうしの対応である。それはちょうど3通り、互換

```math
B_1 = (2\,3) ,\qquad
B_2 = (1\,3) ,\qquad
B_3 = (1\,2)
\qquad \text{(2.2)}
```

であり、`BondTable[1..3]` に格納される。これが貼り合わされた面の*回転コード* `Bond[K]` である。互換は対合なので、同じコードが面の両側に格納される。合成

```math
\mathrm{Join}_K \;=\; V_{\mathrm{Corn}[K]} \circ B_{\mathrm{Bond}[K]}
\qquad \text{(2.3)}
```

は面 $K$ の枠番号を隣接胞の頂点番号へ変換し、貼り合わせが整合するのは、それを通して頂点が一致するとき、かつそのときに限る（`CheckCells` が数える条件）。

```math
T'.\mathrm{Poin}\bigl[\, \mathrm{Join}_K(I) \,\bigr]
\;=\;
T.\mathrm{Poin}\bigl[\, V_K(I) \,\bigr] ,
\qquad I = 1..3 .
\qquad \text{(2.4)}
```

これらの表 — `VertTable` は偶置換、`BondTable` は奇置換 — は、過去実装 `LUX.Brep.Cell.TetraFlip` の巡回表をそのまま継承したものである。

### 2.3 貼り合わせ

`BondOf( K_, Cell_, CornK_ )` は回転コードを頂点の同一性から導出する。面 `K_` の枠の先頭の頂点が相手の面 `CornK_` の枠のどこに見えるかを探し、残りの2頂点が (2.4) を通して鏡像で対応することを検証する — 同じ頂点集合でも同じ向きの面は拒否され、結果 `0` は「貼り合わせ不能」を意味する。`CanWeld` は `BondOf > 0` であり、`Weld` は対称な3つ組 `Cell` / `Corn` / `Bond` を両側に格納する。対合性により、コードは両側で同じ値になる。生成直後の胞は自分自身への仮リンク（`Cell[I] = Self`・`Corn[I] = I`・`Bond[I] = 1`）を持って生まれるのでポインタが `nil` になることはないが、実際に貼り合わされるまでは `CheckCells` に破れとして数えられる。

### 2.4 整合性検査

`CheckCells` は構造が破れている面スロットの数 — `nil` や自分自身の隣接、非対称な `Cell` / `Corn` / `Bond` の3つ組、(2.4) の頂点の不一致 — を返す。整合の取れた閉メッシュでは `0` である。

## 3. アーキテクチャ

### 3.1 クラス図

```
継承（実装層 → 型付け層 → 3次元特殊化）

・TPoin<TPos_,TPoinSet_>                       ･･･ (LUX.Data.Model.Poins)
  ┗・TTetraPoin<TPos_>                        ･･･ アンカー Cell / Corn
     ┗・TTetraPoin<TPos_,TCell_>              ･･･ Cell を TCell_ に付け替え
        ┗・TTetraPoin3D<TCell_>               ･･･ TPos_ = TSingle3D

・TPoinSet<TPos_,TPoin_>                       ･･･ (LUX.Data.Model.Poins)
  ┗・TTetraPoinSet<TPos_>                     ･･･ LoadPoin、SaveToStream
     ┗・TTetraPoinSet<TPos_,TPoin_>           ･･･ Childrs / 列挙を付け替え
        ┗・TTetraPoinSet3D<TPoin_>            ･･･ TPos_ = TSingle3D

・TCell<TPos_,TCellSet_>                       ･･･ (LUX.Data.Model.Cells)
  ┗・TTetraCell<TPos_>                        ･･･ Poin/Cell/Corn/Bond/Join/Weld
     ┗・TTetraCell<TPos_,TPoin_,TCell_>       ･･･ Poin / Cell を付け替え
        ┗・TTetraCell3D<TPoin_,TCell_>        ･･･ TPos_ = TSingle3D

・TCellSet<TPos_,TCell_>                       ･･･ (LUX.Data.Model.Cells)
  ┗・TTetraCellSet<TPos_>                     ･･･ PoinSet・CheckCells・入出力
     ┗・TTetraCellSet<TPos_,TCell_,TPoinSet_> ･･･ PoinSet / 列挙を付け替え
        ┗・TTetraCellSet3D<TCell_,TPoinSet_>  ･･･ TPos_ = TSingle3D

レコードと定数（実装層）

・TByteArray4                                  ･･･ 巡回表の行
・VertTable                                    ･･･ 各面の正準の枠 (2.1)
・BondTable                                    ･･･ 回転コード 1..3 (2.2)
```

### 3.2 ファイル構成

```
・TetraFlip/
  ┣・LUX.Data.Model.TetraFlip.core.pas ･･･ unit ….TetraFlip.core
  ┣・LUX.Data.Model.TetraFlip.pas      ･･･ unit LUX.Data.Model.TetraFlip
  ┣・LUX.Data.Model.TetraFlip.D3.pas   ･･･ unit ….TetraFlip.D3
  ┣・README.md                         ･･･ 本文書（英語版）
  ┗・ja/README.md                      ･･･ 日本語版
```

### 3.3 クラス一覧 — `LUX.Data.Model.TetraFlip.core`

#### `TTetraPoin<TPos_>` — 頂点

| メンバ | 説明 |
|---|---|
| `Create( Pos_ )` / `Create( Pos_, Parent_ )` | 座標 `Pos_` の頂点。点集合への追加も同時に行える。*（継承）* |
| `Pos :TPos_` | 座標。*（継承）* |
| `Cell :TTetraCell<TPos_>` / `Corn :Byte` | アンカー：自分を含む胞と、その中での角番号。 |

#### `TTetraPoinSet<TPos_>` — 点集合

| メンバ | 説明 |
|---|---|
| `Childrs[I]` / `ChildrsN` / `Count` | 頂点。列挙・添字アクセス可。*（継承）* |
| `LoadPoin( Pos_ )` *（protected）* | 読み込む点のファクトリ — `override` で派生の点型に差し替えられる。 |
| `SaveToStream( Stream_ )` | 全ての点の生の座標を `Order` 順に書き込む。 |
| `LoadFromStream( Stream_, PoinsN_ )` | 座標列から生成した点で置き換える。*（継承）* |

#### `TTetraCell<TPos_>` — 四面体

| メンバ | 説明 |
|---|---|
| `Poin[0..3] :TTetraPoin<TPos_>` | 頂点。代入はアンカーに触れない — `BindPoins` を呼ぶこと。 |
| `Cell[0..3]` | 面 `I`（頂点 `I` の対面）で接する隣接胞。新しい胞は自分自身への仮リンクを持つ。 |
| `Corn[0..3] :Byte` | 隣接胞から見た対頂点の番号 — 2 ビット × 4 を1バイトに詰める。 |
| `Bond[0..3] :Byte` | 共有面の回転コード `1..3`（2.2）— 2 ビット × 4 を1バイトに詰める。 |
| `Join[K,I] :Byte` | 頂点対応 (2.3)：面 `K` の枠番号 `I` → 隣接胞での頂点番号。 |
| `Flag :Byte` | 探索の状態管理のための自由な1バイト。ファイル形式で往復する。 |
| `CornOf( Poin_ ) :Shortint` | 頂点 → 角番号。`-1` = 含まない。 |
| `BindPoins` | 4頂点のアンカーをこの胞に向ける。 |
| `BondOf( K_, Cell_, CornK_ ) :Byte` | 面 `K_` を相手の面 `CornK_` に貼り合わせる回転コード。`0` = 貼り合わせ不能。 |
| `CanWeld( K_, Cell_, CornK_ ) :Boolean` | 2つの面を貼り合わせられるか — 頂点が鏡像で対応するか。 |
| `Weld( K_, Cell_, CornK_ )` | 2つの面を両側対称に貼り合わせる。回転コードは与えるのではなく導出される。 |
| `Destroy` | 解放の前に、自分を指している頂点アンカーを外す。 |

#### `TTetraCellSet<TPos_>` — メッシュ

| メンバ | 説明 |
|---|---|
| `Create` / `Destroy` | 点集合を所有する。破棄は胞が先（胞の破棄は頂点のアンカーに触れる）。 |
| `PoinSet :TTetraPoinSet<TPos_>` | 所有する点集合。 |
| `NewPoinSet` *（protected）* | 点集合のファクトリ — `override` で派生の集合型に差し替えられる。 |
| `PoinCode( Poin_ )` / `CodePoin( Code_ )` *（protected）* | 集合に属さない点を負の符号で符号化・復号する（既定 `-1` = `nil`。派生が固有の点に符号を割り当てる — LUX.Delaunay は無限遠点を `-2` に写す）。 |
| `LoadCell` *（protected）* | 読み込む胞のファクトリ — `override` で派生の胞型に差し替えられる。 |
| `CheckCells :Integer` | 破れている面スロットの数（§2.4）。 |
| `SaveToFile( FileName_ )` | `*.lxtc` ファイルへ保存（§3.5）。 |
| `LoadFromFile( FileName_ )` | `*.lxtc` ファイルから復元 — 点も胞も、接続構造とアンカーごと全て置き換わる。 |

### 3.4 型付け層

`LUX.Data.Model.TetraFlip` は4クラスを再パラメータ化し、全ての相互参照が*利用者の*型を持つようにする。`TTetraPoin<TPos_;TCell_>` は `Cell` を、`TTetraPoinSet<TPos_;TPoin_>` は `Childrs` と列挙子を、`TTetraCell<TPos_;TPoin_,TCell_>` は `Poin` / `Cell` を、`TTetraCellSet<TPos_;TCell_,TPoinSet_>` は列挙子と `PoinSet` を付け替える。利用者は自分の派生クラスをそのまま型引数に与えればよい — 自己再帰・相互再帰可。`LUX.Data.Model.TetraFlip.D3` はさらに `TPos_ = TSingle3D` に固定する（`TTetraPoin3D<TCell_>` など）。

ユニットに明記された2つの実装上の制約は維持しなければならない。型引数は class 制約のため基底の型とキャスト互換ではなく、変換は全て `TObject` 経由の二段キャストで行うこと。また、型引数を返す仮想メソッドを相互再帰の輪の中に置くとコンパイルできないため、型付けアクセサは非仮想（`reintroduce` のみ）であること。

### 3.5 ファイル形式 `*.lxtc`

Radiance HDR 風のレイアウトで、`LUX.Data` のコンテナ補助（`WriteHead` / `ReadHead`）で書かれる。ファイルは UTF-8 テキストで始まる。1行目はマジック `LUXOPHIA TetFlip 1.0`、続いて `名前=値` のオプション行 — `PoinsN`・`CellsN`・`PosSize`（`SizeOf(TPos_)` と照合される）。知らない行は読み飛ばされる。1つの空行でヘッダが終わり、それより後は全てバイナリである。まず点の座標が `Order` 順に（`PoinsN × PosSize` バイト）、次に胞ごとに4つの頂点番号と4つの隣接胞番号（`Int32`。負 = 集合外の点・胞、`PoinCode` / `CodePoin` 経由）、最後に3バイト `_Corn` / `_Bond` / `_Flag` が続く。アンカーは導出情報なので保存されず、読み込み時に張り直される。

## 4. 使用法

3次元の型付け層を通して4クラスを派生し、組み立て・貼り合わせ・保存する。

```pascal
uses LUX, LUX.D3, LUX.Data.Model.TetraFlip.D3;

type
     TMyPoin    = class;
     TMyPoinSet = class;
     TMyCell    = class;
     TMyCellSet = class;

     TMyPoin    = class( TTetraPoin3D<TMyCell> );
     TMyPoinSet = class( TTetraPoinSet3D<TMyPoin> );
     TMyCell    = class( TTetraCell3D<TMyPoin,TMyCell> );
     TMyCellSet = class( TTetraCellSet3D<TMyCell,TMyPoinSet> );
```

```pascal
var
   M :TMyCellSet;
   P0, P1, P2, P3, P4 :TMyPoin;
   T1, T2 :TMyCell;
begin
     M := TMyCellSet.Create;

     P0 := TMyPoin.Create( TSingle3D.Create( 0, 0, 0 ), M.PoinSet );
     P1 := TMyPoin.Create( TSingle3D.Create( 1, 0, 0 ), M.PoinSet );
     P2 := TMyPoin.Create( TSingle3D.Create( 0, 1, 0 ), M.PoinSet );
     P3 := TMyPoin.Create( TSingle3D.Create( 0, 0, 1 ), M.PoinSet );
     P4 := TMyPoin.Create( TSingle3D.Create( 1, 1, 1 ), M.PoinSet );

     T1 := TMyCell.Create( M );
     T2 := TMyCell.Create( M );

     T1.Poin[0] := P0;  T1.Poin[1] := P1;  T1.Poin[2] := P2;  T1.Poin[3] := P3;
     T2.Poin[0] := P4;  T2.Poin[1] := P1;  T2.Poin[2] := P3;  T2.Poin[3] := P2;

     T1.BindPoins;
     T2.BindPoins;

     if T1.CanWeld( 0, T2, 0 ) then T1.Weld( 0, T2, 0 );  // 共有面 ( P1, P2, P3 ) を貼り合わせる

     // T1 の面 0 の枠の頂点は、T2 からは次のように見える：
     // T2.Poin[ T1.Join[ 0, I ] ] = T1.Poin[ VertTable[ 0 ]._[ I ] ]  （I = 1..3）

     for T1 in M         do { 各胞   };  // 型付きの列挙
     for P0 in M.PoinSet do { 各頂点 };

     M.SaveToFile( 'mesh.lxtc' );

     M.Free;  // 胞が点集合より先に解放される — デストラクタが受け持つ
end;
```

この2胞のパッチの境界の面は自分自身への仮リンクのままなので、メッシュが閉じるまで `CheckCells` はそれらを数える。この層の完全な利用例としては、まさに上の形で派生し、無限遠点でメッシュを閉じ、その上にドロネーの述語を載せた `LUX.Delaunay.D3` を参照。

## 5. 参考文献

1. Rossignac, J., Safonova, A., Szymczak, A., [*3D Compression Made Simple: Edgebreaker on a Corner-Table*](https://doi.org/10.1109/SMA.2001.923399), Proc. Shape Modeling International, 278–283, 2001.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
