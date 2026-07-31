# LUX
[English](../README.md) | [日本語](README.md)

LUX は LUXOPHIA コレクションの基盤ライブラリである。スカラ・ベクトル・行列・四元数・複素数・色といった値型の数値型を、それぞれの前進型自動微分の対型とともに提供し、併せて汎用のコンテナ・メッシュ・画像のデータ構造を備える。すべてのユニットは `LUX` という単一の名前空間に属し、明確に分離されたごく一部の描画系ユニットを除いて、Delphi の RTL 以外には一切依存しない。

## 利用ライブラリ

* [**LUX.FMX.Graphics.D3**](https://github.com/LUXOPHIA/LUX.FMX.Graphics.D3) ：描画系ユニット `LUX.Complex.FMX.D3`（`TComplex3D`）のみが使用する。

## 1. 概要

### 1.1 対象範囲

本ライブラリは先頭が常に `LUX` である平坦な名前空間として構成される。主たる関心事は次の4つである。

| 関心事 | 代表的なユニット | 代表的な型 |
|---|---|---|
| 線形代数 | `LUX.D1` 〜 `LUX.D4` ・ `LUX.D2x2` ・ `LUX.D3x3` ・ `LUX.D4x4` ・ `LUX.Quaternion` | `TSingle3D` ・ `TSingleM4` ・ `TSingleQ` |
| 数値計算 | `LUX.D*.Diff` ・ `LUX.D1.Half` ・ `LUX.Complex` ・ `LUX.D1.Gamma.*` ・ `LUX.D1.Legendre` | `TdSingle` ・ `THalf` ・ `TSingleC` |
| 色と曲線 | `LUX.Color` ・ `LUX.Color.Half` ・ `LUX.Curve.*` | `TSingleRGBA` ・ `THalfRGBA` ・ `TSingleWector<T>` |
| データ構造 | `LUX.Data.List` ・ `LUX.Data.Tree` ・ `LUX.Data.Grid.*` ・ `LUX.Data.Model.*` ・ `LUX.Data.Image` | `TTreeNode` ・ `TTriaGrid<T>` ・ `TLuxImage` |

数値型は演算子・コンストラクタ・プロパティ・暗黙変換を備えた Delphi の `record` である。したがってスタックに置かれ、値としてコピーされ、寿命管理を必要としない。コンテナ型はクラスであり、集合の層はジェネリックなので、相互参照プロパティには基底型ではなく利用側の派生クラスがそのまま現れる。

ほぼすべての数値型は `Single` 版と `Double` 版が同一ユニット内に並べて宣言されている。以下の表は簡潔さのため `Single` 版のみを挙げる。

### 1.2 命名規則

識別子は体系的であり、名前だけでライブラリ全体をたどれる。

| 要素 | 意味 | 例 |
|---|---|---|
| `TInteger…` ・ `TSingle…` ・ `TDouble…` | レコードの要素型 | `TSingle2D` |
| `THalf` ・ `TByte…` ・ `TWord…` ・ `TUInt32x…` | 狭い記憶形式、または累算用 | `TWordRGBA` |
| `Td…` | 値とその微分を併せ持つ | `TdSingle3D` |
| `…2D` ・ `…3D` ・ `…4D` | その次元のベクトル | `TSingle4D` |
| `…M2` ・ `…M3` ・ `…M4` | その次数の正方行列 | `TSingleM3` |
| `…Q` | 四元数 | `TDoubleQ` |
| `…C` | 複素数 | `TSingleC` |
| `…RGB` ・ `…RGBA` | 色（α はストレート、乗算前） | `TSingleRGBA` |

| ユニットの接尾辞 | 意味 |
|---|---|
| `.D1` 〜 `.D4` | そのユニットが扱う空間の次元 |
| `.D2x2` ・ `.D3x3` ・ `.D4x4` | その次数の行列 |
| `.Diff` | 対応するユニットの微分を伴う版 |
| `.core` | ジェネリックな型付け層が包む、型無しの核の層 |
| `.Half` | 半精度版 |

レコードのフィールドも同じ流儀に従う。座標は `X` ・ `Y` ・ `Z` ・ `W`、同じ記憶を序数で指す場合は `_1` ・ `_2` ・ `_3`、全体を配列として見る場合は `_1D`、値と微分は `o` と `d`、色成分は `R` ・ `G` ・ `B` ・ `A` である。ベクトルは可変レコードなので、`V.X` ・ `V._1` ・ `V._1D[0]` ・ `V[0]` はすべて同一の記憶を指す。

## 2. モジュール構成

各分野フォルダはそれぞれ README（`README.md`／`ja/README.md`）を持つ。以下のツリーからたどれる。

* [**LUX.Code**](../Code/ja/README.md) ：C ヘッダ転記のための C99 → Delphi 型別名（T_int・P_char など）
* [**LUX.Color**](../Color/ja/README.md) ：色の値レコード — Gamma / Reinhard ToneMap を備えた線形 RGB(A) と Byte / Word / RGBE / Half 形式
* [**LUX.Complex**](../Complex/ja/README.md) ：複素数 TSingleC / TDoubleC — 初等関数と .Diff の対型
  * [**LUX.Complex.FMX.D3**](../Complex/FMX/ja/README.md) ：TComplex3D — 複素関数の FireMonkey 曲面プロット
  * [**LUX.C2.Gamma**](../Complex/Gamma/ja/README.md) ：複素ガンマ関数 — Lanczos（N = 7 / 9 / 11 / 15）と大浦 cdgamma
* [**LUX.Curve**](../Curve/ja/README.md) ：補間の基底と核 — Bernstein・Cox–de Boor B スプライン・Catmull–Rom・sinc・Lerp
  * [**LUX.Curve.Data.Grid**](../Curve/Data/Grid/ja/README.md) ：1次元制御点グリッド上の曲線と弧長等間隔の再標本化
* [**LUX.D1**](../D1/ja/README.md) ：スカラー特殊関数 — Gamma・Half・Legendre を束ねるハブ
  * [**LUX.D1.Gamma**](../D1/Gamma/ja/README.md) ：実引数のガンマ関数 — Lanczos 近似と大浦 gamerf の移植(各 .Diff 付き)
  * [**LUX.D1.Half**](../D1/Half/ja/README.md) ：IEEE 754 binary16 の値レコード THalf と双対数の対型 TdHalf
  * [**LUX.D1.Legendre**](../D1/Legendre/ja/README.md) ：正規直交ルジャンドル多項式と導関数 — 安定な漸化式で評価
* [**LUX.Data**](../Data/ja/README.md) ：データ構造 — 汎用コンテナ・メッシュ・画像とストリーム補助
  * [**LUX.Data.Grid**](../Data/Grid/ja/README.md) ：1次元の点グリッドと、重心座標で歩く三角形の2次元グリッド
  * [**LUX.Data.Image**](../Data/Image/ja/README.md) ：タイルとミップピラミッドによる超高解像度画像と非同期ファイル入出力
  * [**LUX.Data.List**](../Data/List/ja/README.md) ：逐次インデックス付きの侵入型双方向リスト（核＋型付け層）
  * [**LUX.Data.Model**](../Data/Model/ja/README.md) ：メッシュモデル — 点・面・胞のコンテナとコーナーテーブルメッシュ
    * [**LUX.Data.Model.TriFlip**](../Data/Model/TriFlip/ja/README.md) ：2次元三角形メッシュ — 貼り合わせ・頂点環・対角線交換・`*.lxtf`
    * [**LUX.Data.Model.TetraFlip**](../Data/Model/TetraFlip/ja/README.md) ：3次元四面体メッシュ — 回転コードによる面の貼り合わせ・`*.lxtc`
  * [**LUX.Data.Tree**](../Data/Tree/ja/README.md) ：リスト上の汎用木構造 — TTreeRoot / TTreeKnot / TTreeLeaf と一括更新
* [**LUX.Quaternion**](../Quaternion/ja/README.md) ：四元数 TSingleQ / TDoubleQ — 回転・行列との相互変換・exp / ln / pow

## 3. 数学的背景


`.Diff` の付くユニットはいずれも、対応する基底ユニットを、値と「選んだ独立変数についての微分」の両方を運ぶ型で写したものである。`TdSingle` はフィールド `o`（値）と `d`（微分）を持ち、これは $\varepsilon^2 = 0$ とする二重数 $a_o + a_d \varepsilon$ そのものである。演算子は微分を厳密に伝播させ、刻み幅も打ち切り誤差も存在しない。

```math
(a_o + a_d \varepsilon)\,(b_o + b_d \varepsilon) = a_o b_o + \left( a_o b_d + a_d b_o \right) \varepsilon \qquad \text{(3.1)}
```

```math
\frac{a_o + a_d \varepsilon}{b_o + b_d \varepsilon} = \frac{a_o}{b_o} + \frac{a_d b_o - a_o b_d}{b_o^{\,2}} \, \varepsilon \qquad \text{(3.2)}
```

`Integer` ・ `Int64` ・ `Single` からの暗黙変換は `d` に 0 を与えるので、リテラル定数は自動的に微分 0 として扱われ、ふつうの式がそのままコンパイルできる。同じ構成はベクトル（`TdSingle2D` 〜 `TdSingle4D`）・行列（`LUX.D4x4.Diff`）・複素数（`TdSingleC`）・半精度（`TdHalf`）へも持ち上げられている。

## 4. アーキテクチャ

```
・LUX/
  ┣・LUX.pas             ･･･ TDelegates、手続き型、スカラ補助関数、EPS・Pi
  ┣・LUX.～.pas          ･･･ 空のユニット雛形（見出しの帯だけを持つ）
  ┣・LUX.D1.pas          ･･･ TSingle ・ TDouble ・ Gauss
  ┣・LUX.D1.DIff.pas     ･･･ TdSingle ・ TdDouble
  ┣・LUX.D2.pas          ･･･ LUX.D2.Diff.pas
  ┣・LUX.D3.pas          ･･･ LUX.D3.Diff.pas
  ┣・LUX.D4.pas          ･･･ LUX.D4.Diff.pas
  ┣・LUX.D2x2.pas        ･･･ LUX.D3x3.pas  LUX.D4x4.pas  LUX.D4x4.Diff.pas
  ┣・Quaternion/         ･･･ LUX.Quaternion.pas
  ┣・D1/
  ┃  ┣・Half/           ･･･ THalf とその微分の対型 TdHalf
  ┃  ┣・Gamma/          ･･･ 実ガンマ：Lanczos と Ooura、各々に .Diff
  ┃  ┗・Legendre/       ･･･ 正規化 Legendre 関数、.Diff 付き
  ┣・Complex/
  ┃  ┣・LUX.Complex.pas ･･･ LUX.Complex.Diff.pas
  ┃  ┣・Gamma/          ･･･ 複素ガンマ：Lanczos と Ooura、各々に .Diff
  ┃  ┗・FMX/            ･･･ TComplex3D（FireMonkey の3D形状）
  ┣・Color/              ･･･ LUX.Color.pas  LUX.Color.Half.pas
  ┣・Curve/
  ┃  ┣・LUX.Curve.pas   ･･･ 重み付きベクトルのレコード
  ┃  ┣・LUX.Curve.*.pas ･･･ Bezier・BSpline・CatmullRom・Lanczos・Linear
  ┃  ┗・Data/Grid/      ･･･ 曲線評価のための制御点グリッド
  ┣・Code/               ･･･ LUX.Code.C.pas — C99 の型とポインタの別名
  ┣・Data/
  ┃  ┣・LUX.Data.pas    ･･･ UTF-8 の行とテキストヘッダの入出力補助
  ┃  ┣・List/           ･･･ 侵入型双方向リスト、核と型付け層
  ┃  ┣・Tree/           ･･･ リストの上に構築した木、一括更新を備える
  ┃  ┣・Grid/           ･･･ 規則的な1次元グリッドと三角形の2次元グリッド
  ┃  ┣・Model/          ･･･ コーナーテーブルメッシュ：TriFlip 2D・TetraFlip 3D
  ┃  ┗・Image/          ･･･ 超高解像度画像 — 独自の README を持つ
  ┗・--------/2022/      ･･･ 凍結された旧い木。現在の名前空間には属さない
```

## 5. 使い方

リポジトリのルートと必要なサブフォルダをプロジェクトの検索パスに加え、あとはユニットを直接 `uses` するだけでよい。登録も初期化も要らない。

```pascal
uses LUX, LUX.D3, LUX.D4x4, LUX.Quaternion, LUX.D1.Diff, LUX.Color;

var
   P, Q :TSingle3D;
   M    :TSingleM4;
   R    :TSingleQ;
   F    :TdSingle;
   C    :TSingleRGB;
   D    :Single;
begin
     ///// ベクトル（値意味論・演算子多重定義）
     P := TSingle3D.Create( 1, 2, 3 );
     Q := P.Unitor;                              // 正規化した複製
     D := DotProduct( P, Q );                    // ＝ P.Size

     ///// 同次変換
     M := TSingleM4.Translate( 0, 0, -5 )
        * TSingleM4.RotateY( P4i );              // P4i ＝ Pi/4（LUX で宣言）
     P := M.MultPos( P );                        // 位置として（w = 1）
     Q := M.MultVec( Q );                        // 方向として（w = 0）

     ///// 四元数
     R := TSingleQ.Rotate( TSingle3D.IdentityZ, P3i );
     P := R.Trans( P );                          // v' = q v q⁻¹
     M := R;                                     // TSingleM4 へ暗黙変換

     ///// f(x) = x³ の x = 2 における前進型自動微分
     F := TdSingle.Create( 2, 1 );               // 値 2、微分の種 1
     F := F * F * F;
     // F.o =  8  （＝ 2³）
     // F.d = 12  （＝ 3·2²）

     ///// 色
     C := TSingleRGB.Create( 4.0, 2.0, 1.0 );    // リニア、白より明るい
     C := C.ToneMap( 1 ).Gamma( 2.2 );           // Reinhard ののち表示ガンマ
end;
```

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
