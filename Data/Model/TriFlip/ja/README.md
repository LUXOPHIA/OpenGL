# LUX.Data.Model.TriFlip
[English](../README.md) | [日本語](README.md)

Delphi 向けのコーナーテーブル方式の三角形メッシュ。面は `Weld` で辺どうしを貼り合わせ、コーナー反復子で巡回し、対角線交換 `FlipEdge` で組み替え、接続構造ごと `*.lxtf` ファイルに永続化する。この層は純粋に組合せ的であり — 座標は型引数にすぎず、どのアルゴリズムにも登場しない — [LUX.Delaunay](https://github.com/LUXOPHIA/LUX.Delaunay)`.D2` のメッシュ基盤である。

## 1. 概要

このフォルダは1つの構造を3層に分けて保持する。

| ユニット | 層 |
|---|---|
| `LUX.Data.Model.TriFlip.core` | 実装層 — 全てのフィールドとアルゴリズム。座標型 `TPos_` についてジェネリック。 |
| `LUX.Data.Model.TriFlip` | 型付け層 — 相互参照を利用者の派生クラスの型へ付け替える。 |
| `LUX.Data.Model.TriFlip.D2` | 2次元特殊化 — `TPos_` を `TSingle2D` に固定。 |

メッシュとは、三角形 `TTriFace` の面集合 `TTriFaceSet`（点集合 `TTriPoinSet` を所有する）である。各面は3頂点 `Poin[1..3]`（利用側の慣例では反時計回り）と3つの隣接面 `Face[1..3]`、そして3つの2ビットの隣接角番号 `Corn[1..3]` と2つの旗ビット `Flip` / `Flag` を詰め込んだ1バイト `_Data` を保持する。各頂点は座標 `Pos` と*アンカー* — 自分を含む面 `Face` とその中での角番号 `Corn` — を保持するので、頂点周りの巡回は O(1) で始められる。基底クラスは `LUX.Data.Model.Poins` / `.Faces`（[親フォルダ](../../ja/README.md)参照）に由来し、各要素は所属先の `Parent` と永続的な番号 `Order` を知っている。

## 2. 技術的背景

### 2.1 コーナーテーブル

*コーナー*とは面と頂点席の対 $(f, k)$、$k \in \{1,2,3\}$ である。面の中の回転は巡回置換

```math
\mathrm{next}(k) = k \bmod 3 + 1 ,
\qquad
\mathrm{prev}(k) = \mathrm{next}(\mathrm{next}(k)) ,
\qquad \text{(2.1)}
```

であり、定数 `VertTableInc[k] = ( L:next(k); R:prev(k) )` と `VertTableDec[k] = ( L:prev(k); R:next(k) )` に表として持つ。コーナーの対辺を渡る移動は

```math
\mathrm{Flip}(f,k) = \bigl(\, \mathrm{Face}_f[k],\; \mathrm{Corn}_f[k] \,\bigr) ,
\qquad \text{(2.2)}
```

であり、`Weld` はこれを対合として維持する：貼り合わされた辺の上では $\mathrm{Flip}^2 = \mathrm{id}$。レコード `TCornIter<_TPos_>` はコーナーとこれらの移動を、値を返すプロパティ（`Flip`・`FaceNext`・`FacePrev`・…）とその場での移動（`GoFlip`・`GoFaceNext`・…）の両方の形で束ねる。

### 2.2 頂点環

2つの基本移動の合成が頂点の周りを歩く。

```math
\mathrm{VertNext} = \mathrm{FacePrev} \circ \mathrm{Flip} ,
\qquad
\mathrm{VertPrev} = \mathrm{Flip} \circ \mathrm{FaceNext} .
\qquad \text{(2.3)}
```

頂点 $v$ の環は、各面の中で $v$ の*次*に来るコーナーによって表現される。$v$ のアンカーコーナーの `FaceNext` から始めると、$\mathrm{VertNext}$ の軌道は接続する面をちょうど1つずつ巡り、`FacesN` はその軌道長 — $v$ の周りの面の数 — である。`BasteCorn` は面をこの環に仮縫いしてアンカーを自分に移し、`JoinOK` は2つのコーナーが共通の辺で出会えるか（`C1.FaceNext.Vert = C2.Vert`）を判定し、`JoinEdge` はアンカーの頂点の周りに仮縫いされた扇を、一致する辺を繰り返し接合して環に縫い上げる。

### 2.3 貼り合わせ

面 $f$ のコーナー $K$ の対辺は $P_f[\mathrm{next}(K)]$ から $P_f[\mathrm{prev}(K)]$ へ走る。2つの面をそこで貼り合わせられるのは、共有辺が両側から*鏡像*の向きに見えるとき、かつそのときに限る（`CanWeld`）。

```math
P_f[\mathrm{next}(K)] = P_g[\mathrm{prev}(K')]
\;\;\wedge\;\;
P_f[\mathrm{prev}(K)] = P_g[\mathrm{next}(K')] .
\qquad \text{(2.4)}
```

`Weld` は両側に対称な `Face` / `Corn` の対リンクを書き込み、それ以外には何も触れない。生成直後の面は自分自身への仮リンク（`Face[K] = Self`）を持って生まれるのでポインタが `nil` になることはないが、実際に貼り合わされるまでは §2.5 の整合性検査に破れとして数えられる。

### 2.4 対角線交換

`FlipEdge( Corn_ )` は、面と `Corn_` の対辺の向こうの隣接面が成す四辺形の対角線を交換する。

```math
F = (P_a, P_b, P_d),\;\; G = (P_e, P_d, P_b)
\;\longmapsto\;
F = (P_a, P_b, P_e),\;\; G = (P_e, P_d, P_a) ,
\qquad \text{(2.5)}
```

共有辺 $(P_b, P_d)$ が $(P_a, P_e)$ に張り替わる。操作は定数時間 — 2つの頂点席、4つの貼り合わせ、空いた席を指していた可能性のある $P_b$・$P_d$ のアンカーだけを書き換える — であり、頂点数・面数・位相を変えない。両面は全ての辺で貼り合わせ済みでなければならない。この交換はドロネー型の組み替えの基本手 [2] であり、フォルダ名の由来である。

### 2.5 整合性検査

`CheckEdges` は (2.2) が対称な対合になっていないコーナーの数 — `nil` や片方向だけの隣接、角番号 `0` — を返す。`CheckFaceLings` は環 (2.3) が `FacesN` 歩で閉じない頂点の数を返す。整合の取れた閉メッシュでは両方とも `0` である。

## 3. アーキテクチャ

### 3.1 クラス図

```
継承（実装層 → 型付け層 → 2次元特殊化）

・TPoin<TPos_,TPoinSet_>                     ･･･ (LUX.Data.Model.Poins)
  ┗・TTriPoin<TPos_>                        ･･･ Face / Corn、FacesN、Join*
     ┗・TTriPoin<TPos_,TFace_>              ･･･ Face を TFace_ に付け替え
        ┗・TTriPoin2D<TFace_>               ･･･ TPos_ = TSingle2D

・TPoinSet<TPos_,TPoin_>                     ･･･ (LUX.Data.Model.Poins)
  ┗・TTriPoinSet<TPos_>                     ･･･ LoadPoin、SaveToStream
     ┗・TTriPoinSet<TPos_,TPoin_>           ･･･ Childrs / 列挙を付け替え
        ┗・TTriPoinSet2D<TPoin_>            ･･･ TPos_ = TSingle2D

・TFace<TPos_,TFaceSet_>                     ･･･ (LUX.Data.Model.Faces)
  ┗・TTriFace<TPos_>                        ･･･ Poin/Face/Corn、Weld、FlipEdge
     ┗・TTriFace<TPos_,TPoin_,TFace_>       ･･･ Poin / Face を付け替え
        ┗・TTriFace2D<TPoin_,TFace_>        ･･･ TPos_ = TSingle2D

・TFaceSet<TPos_,TFace_>                     ･･･ (LUX.Data.Model.Faces)
  ┗・TTriFaceSet<TPos_>                     ･･･ PoinSet、検査、ファイル入出力
     ┗・TTriFaceSet<TPos_,TFace_,TPoinSet_> ･･･ PoinSet / 列挙を付け替え
        ┗・TTriFaceSet2D<TFace_,TPoinSet_>  ･･･ TPos_ = TSingle2D

レコードと定数（実装層）

・TVertLR                                    ･･･ コーナー巡回表の行
・TCornIter<_TPos_>                          ･･･ コーナー反復子：Flip、*Next、…
・VertTableInc / VertTableDec                ･･･ コーナー 1..3 の巡回的な次 / 前
```

### 3.2 ファイル構成

```
・TriFlip/
  ┣・LUX.Data.Model.TriFlip.core.pas ･･･ unit LUX.Data.Model.TriFlip.core
  ┣・LUX.Data.Model.TriFlip.pas      ･･･ unit LUX.Data.Model.TriFlip
  ┣・LUX.Data.Model.TriFlip.D2.pas   ･･･ unit LUX.Data.Model.TriFlip.D2
  ┣・README.md                       ･･･ 本文書（英語版）
  ┗・ja/README.md                    ･･･ 日本語版
```

### 3.3 クラス一覧 — `LUX.Data.Model.TriFlip.core`

#### `TCornIter<_TPos_>` — コーナー反復子

| メンバ | 説明 |
|---|---|
| `Create( Face_, Corn_ )` | `Face_` のコーナー `Corn_`。 |
| `Face` / `Corn` | 現在位置。 |
| `Vert :TTriPoin<_TPos_>` | このコーナーの頂点。 |
| `Flip` | 対辺の向こうのコーナー (2.2)。書き込み可 — 代入は片方向の貼り合わせ。 |
| `FaceNext` / `FacePrev` | 面の中の回転 (2.1)。 |
| `VertNext` / `VertPrev` | 頂点の周りの回転 (2.3)。書き込み形は環の繋ぎ替え。 |
| `GoFlip` / `GoFaceNext` / `GoFacePrev` / `GoVertNext` / `GoVertPrev` | 同じ移動をその場で行う。 |
| `=` / `<>` | 位置（`Face` と `Corn`）の等価。 |

#### `TTriPoin<TPos_>` — 頂点

| メンバ | 説明 |
|---|---|
| `Create( Pos_ )` / `Create( Pos_, Parent_ )` | 座標 `Pos_` の頂点。点集合への追加も同時に行える。*（継承）* |
| `Pos :TPos_` | 座標。*（継承）* |
| `Face :TTriFace<TPos_>` / `Corn :Byte` | アンカー：自分を含む面と、その中での角番号。 |
| `FacesN :Integer` | 頂点の周りの面の数 — 環 (2.3) の長さ。未接続なら `0`。 |
| `JoinOK( C1_,C2_ ) :Boolean` *（クラス）* | 2つのコーナーが共通の辺で出会い、そこで接合できるか。 |
| `JoinEdge` | この頂点の周りに仮縫いされた扇（§2.2）を、一致する辺の接合で環に縫い上げる。 |

#### `TTriPoinSet<TPos_>` — 点集合

| メンバ | 説明 |
|---|---|
| `Childrs[I]` / `ChildrsN` / `Count` | 頂点。列挙・添字アクセス可。*（継承）* |
| `LoadPoin( Pos_ )` *（protected）* | 読み込む点のファクトリ — `override` で派生の点型に差し替えられる。 |
| `SaveToStream( Stream_ )` | 全ての点の生の座標を `Order` 順に書き込む。 |
| `LoadFromStream( Stream_, PoinsN_ )` | 座標列から生成した点で置き換える。*（継承）* |

#### `TTriFace<TPos_>` — 三角形

| メンバ | 説明 |
|---|---|
| `Poin[1..3] :TTriPoin<TPos_>` | 頂点。代入はアンカーに触れない — `BindPoins` を呼ぶこと。 |
| `Face[1..3]` / `Corn[1..3]` | コーナー `K` の対辺の向こうの隣接面と、共有辺のその面での角番号。新しい面は自分自身への仮リンクを持つ。 |
| `Flip` / `Flag :Boolean` | 面ごとの2つの旗ビット。`Corn[]` と同じバイトに詰められ（既定 `True` / `False`）、利用側のアルゴリズムが自由に使える。ファイル形式で往復する。 |
| `BasteCorn( Corn_ )` | コーナー `Corn_` をその頂点の環に仮縫いし、頂点のアンカーをここへ移す。 |
| `CornOf( Poin_ ) :Byte` | 頂点 → 角番号。`0` = 含まない。 |
| `BindPoins` | 3頂点のアンカーをこの面に向ける。 |
| `CanWeld( K_, Face_, CornK_ ) :Boolean` | 辺 `K_` を相手の辺 `CornK_` と貼り合わせられるか — 鏡像条件 (2.4)。 |
| `Weld( K_, Face_, CornK_ )` | 2つの辺を両側対称に貼り合わせる。 |
| `FlipEdge( Corn_ )` | 対角線交換 (2.5)。両面は全ての辺で貼り合わせ済みであること。 |
| `Destroy` | 解放の前に、自分を指している頂点アンカーを外す。 |

#### `TTriFaceSet<TPos_>` — メッシュ

| メンバ | 説明 |
|---|---|
| `Create` / `Destroy` | 点集合を所有する。破棄は面が先（面の破棄は頂点のアンカーに触れる）。 |
| `PoinSet :TTriPoinSet<TPos_>` | 所有する点集合。 |
| `NewPoinSet` *（protected）* | 点集合のファクトリ — `override` で派生の集合型に差し替えられる。 |
| `PoinCode( Poin_ )` / `CodePoin( Code_ )` *（protected）* | 集合に属さない点を負の符号で符号化・復号する（既定 `-1` = `nil`。派生が固有の点に符号を割り当てる — LUX.Delaunay は無限遠点を `-2` に写す）。 |
| `LoadFace` *（protected）* | 読み込む面のファクトリ — `override` で派生の面型に差し替えられる。 |
| `CheckEdges :Integer` | 隣接の破れの数（§2.5）。 |
| `CheckFaceLings :Integer` | 環が閉じない頂点の数（§2.5）。 |
| `SaveToFile( FileName_ )` | `*.lxtf` ファイルへ保存（§3.5）。 |
| `LoadFromFile( FileName_ )` | `*.lxtf` ファイルから復元 — 点も面も、接続構造とアンカーごと全て置き換わる。 |

### 3.4 型付け層

`LUX.Data.Model.TriFlip` は4クラスを再パラメータ化し、全ての相互参照が*利用者の*型を持つようにする。`TTriPoin<TPos_;TFace_>` は `Face` を、`TTriPoinSet<TPos_;TPoin_>` は `Childrs` と列挙子を、`TTriFace<TPos_;TPoin_,TFace_>` は `Poin` / `Face` を、`TTriFaceSet<TPos_;TFace_,TPoinSet_>` は列挙子と `PoinSet` を付け替える。利用者は自分の派生クラスをそのまま型引数に与えればよい — 自己再帰・相互再帰可。`LUX.Data.Model.TriFlip.D2` はさらに `TPos_ = TSingle2D` に固定する（`TTriPoin2D<TFace_>` など）。

ユニットに明記された2つの実装上の制約は維持しなければならない。型引数は class 制約のため基底の型とキャスト互換ではなく、変換は全て `TObject` 経由の二段キャストで行うこと。また、型引数を返す仮想メソッドを相互再帰の輪の中に置くとコンパイルできないため、型付けアクセサは非仮想（`reintroduce` のみ）であること。

### 3.5 ファイル形式 `*.lxtf`

Radiance HDR 風のレイアウトで、`LUX.Data` のコンテナ補助（`WriteHead` / `ReadHead`）で書かれる。ファイルは UTF-8 テキストで始まる。1行目はマジック `LUXOPHIA TriFlip 1.0`、続いて `名前=値` のオプション行 — `PoinsN`・`FacesN`・`PosSize`（`SizeOf(TPos_)` と照合される）。知らない行は読み飛ばされる。1つの空行でヘッダが終わり、それより後は全てバイナリである。まず点の座標が `Order` 順に（`PoinsN × PosSize` バイト）、次に面ごとに3つの頂点番号と3つの隣接面番号（`Int32`。負 = 集合外の点・面、`PoinCode` / `CodePoin` 経由）、最後に角と旗を詰めた1バイト `_Data` が続く。アンカーは導出情報なので保存されず、読み込み時に張り直される。

## 4. 使用法

2次元の型付け層を通して4クラスを派生し、組み立て・貼り合わせ・保存する。

```pascal
uses LUX, LUX.D2, LUX.Data.Model.TriFlip.D2;

type
     TMyPoin    = class;
     TMyPoinSet = class;
     TMyFace    = class;
     TMyFaceSet = class;

     TMyPoin    = class( TTriPoin2D<TMyFace> );
     TMyPoinSet = class( TTriPoinSet2D<TMyPoin> );
     TMyFace    = class( TTriFace2D<TMyPoin,TMyFace> );
     TMyFaceSet = class( TTriFaceSet2D<TMyFace,TMyPoinSet> );
```

```pascal
var
   M :TMyFaceSet;
   P1, P2, P3, P4 :TMyPoin;
   F, G :TMyFace;
begin
     M := TMyFaceSet.Create;

     P1 := TMyPoin.Create( TSingle2D.Create( 0, 0 ), M.PoinSet );
     P2 := TMyPoin.Create( TSingle2D.Create( 1, 0 ), M.PoinSet );
     P3 := TMyPoin.Create( TSingle2D.Create( 0, 1 ), M.PoinSet );
     P4 := TMyPoin.Create( TSingle2D.Create( 1, 1 ), M.PoinSet );

     F := TMyFace.Create( M );
     G := TMyFace.Create( M );

     F.Poin[1] := P1;  F.Poin[2] := P2;  F.Poin[3] := P3;  F.BindPoins;  // ( P1, P2, P3 ) 反時計回り
     G.Poin[1] := P2;  G.Poin[2] := P4;  G.Poin[3] := P3;  G.BindPoins;  // ( P2, P4, P3 ) 反時計回り

     if F.CanWeld( 1, G, 2 ) then F.Weld( 1, G, 2 );  // 共有辺 ( P2, P3 ) を貼り合わせる

     for F in M          do { 各面   };  // 型付きの列挙
     for P1 in M.PoinSet do { 各頂点 };

     M.SaveToFile( 'mesh.lxtf' );

     M.Free;  // 面が点集合より先に解放される — デストラクタが受け持つ
end;
```

上の例で `FlipEdge` を示していないのは、2つの面の外周の辺が未接合だからである。閉じたメッシュ — 全ての辺が貼り合わされ `CheckEdges = 0` — の上では、`F.FlipEdge( 1 )` が対角線 `( P2, P3 )` をその場で `( P1, P4 )` に交換する。この層の完全な利用例としては、まさに上の形で派生してドロネーの述語を載せた `LUX.Delaunay.D2` を参照。

## 5. 参考文献

1. Rossignac, J., Safonova, A., Szymczak, A., [*3D Compression Made Simple: Edgebreaker on a Corner-Table*](https://doi.org/10.1109/SMA.2001.923399), Proc. Shape Modeling International, 278–283, 2001.
2. Lawson, C. L., [*Transforming triangulations*](https://doi.org/10.1016/0012-365X(72)90093-3), Discrete Mathematics, 3(4), 365–372, 1972.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
