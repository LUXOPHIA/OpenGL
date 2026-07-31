# LUX.Complex
[English](../README.md) | [日本語](README.md)

`LUX.Complex` は複素数を Delphi の値レコード `TSingleC` / `TDoubleC` として提供する。その上の初等関数、複素平面上の矩形の定義域窓、そして `LUX.Complex.Diff` にはすべての演算を通して微分を運ぶ双対数の対型を備える。

## 1. 概要

複素数は2つのフィールド `R` と `I` を持ち演算子を多重定義した `record` であり、式は通常の算術として読め、値はスタックに置かれる。極形式はプロパティとして公開される。`Abs2`（絶対値の2乗）・`Abso`（絶対値）・`Angle`（偏角）・`Unitor`（方向）・`Conj`（共役）である。`Abso`・`Unitor`・`Conj` は書き込みも可能で、それぞれ相補的な量を保存する。クラスプロパティ `Imaginary` は虚数単位 $i$ を与え、実数は暗黙変換で複素型に持ち上がる。

演算子に加えて、精度ごとに多重定義された自由関数を輸出する。`Pow`・`Roo2`（平方根）・`Cos`・`Sin`・`Tan`・`Exp`・`Expi`・`Ln`・`ArcCos`・`ArcSin` である。`TSingleAreaC` / `TDoubleAreaC` は平面の軸平行矩形 `Min` … `Max` を表す。描画や標本化のための定義域窓であり、書き込み可能な `Center`・`CenterR/I`・`SizeR/I` のアクセサは窓を中心を基準に移動・伸縮する。`TSingleCFunc` / `TDoubleCFunc` は1複素変数関数の型である。

`LUX.Complex.Diff` は同じ構成を `TdSingleC` / `TdDoubleC` で繰り返す。その成分は `LUX.D1.Diff` の双対スカラ `TdSingle` / `TdDouble` であり、プロパティ `o` と `d` は値と微分を素の複素数として見せる。乱数生成（`RandG`・`RandBS1/2/4`）は各成分を対応するスカラ生成器から独立に引く。ガウス分布、あるいは $[-\tfrac{1}{2},\tfrac{1}{2})$ 上の一様変量1個・2個・4個の和である。

## 2. 数学的背景

### 2.1 算術

乗算と除算は成分ごとの式に従う。除算は共役を絶対値の2乗（`Abs2` として一度だけ計算）の上に展開する。

```math
(a + b i)(c + d i) = (ac - bd) + (ad + bc)\, i \qquad \text{(2.1)}
```

```math
\frac{a + b i}{c + d i} = \frac{ac + bd}{c^{2} + d^{2}} + \frac{bc - ad}{c^{2} + d^{2}}\, i \qquad \text{(2.2)}
```

### 2.2 極形式と主枝

偏角は `ArcTan2( I, R )` で計算されるため `Angle` $\in (-\pi, \pi]$ であり、以下の多価関数はすべてこれに基づく主枝を取る。`Ln` は

```math
\operatorname{Ln} z = \ln |z| + i \arg z \qquad \text{(2.3)}
```

`Pow` と `Roo2` は極形式で評価される。

```math
z^{n} = |z|^{n} \left( \cos n \arg z + i \sin n \arg z \right), \qquad \sqrt{z} = \sqrt{|z|} \left( \cos \tfrac{\arg z}{2} + i \sin \tfrac{\arg z}{2} \right) \qquad \text{(2.4)}
```

したがって3者の分岐切断はいずれも負の実軸に沿う。

### 2.3 初等関数

```math
e^{z} = e^{R} ( \cos I + i \sin I ), \qquad e^{i x} = \cos x + i \sin x \qquad \text{(2.5)}
```

`Expi` は右の形を実引数から `SinCos` で直接計算する。三角関数は双曲線関数との積に分解され、逆関数は対数を通して評価される。

```math
\cos z = \cos R \cosh I - i \sin R \sinh I, \qquad \sin z = \sin R \cosh I + i \cos R \sinh I \qquad \text{(2.6)}
```

```math
\arccos z = -i \operatorname{Ln}\!\left( z + i \sqrt{1 - z^{2}} \right), \qquad \arcsin z = -i \operatorname{Ln}\!\left( i z + \sqrt{1 - z^{2}} \right) \qquad \text{(2.7)}
```

`Tan` は商 `Sin / Cos` である。

### 2.4 微分の伝播

`LUX.Complex.Diff` では各成分が $\varepsilon^{2} = 0$ なる双対数 $a_o + a_d \varepsilon$ であり、すべての演算子と関数は刻み幅なしで微分を正確に伝播する。2.3節の関数群は双対算術そのものの上に書かれているため、`d` に実単位を種として与えれば、$f$ が正則である限り任意の式 $f(z)$ は対 $\left( f(z),\ f'(z) \right)$ になる。

## 3. アーキテクチャ

固有の README を持つ下位名前空間：

* [**FMX**](FMX/ja/README.md) ：`TComplex3D` — 複素関数の FireMonkey 曲面プロット
* [**Gamma**](Gamma/ja/README.md) ：複素ガンマ関数（ Lanczos / Ooura、各 `.Diff` 付き ）

### 3.1 型

```
・TSingleC                      ･･･ R,I :Single。Abs2/Abso/Angle/Unitor/Conj
・TDoubleC                      ･･･ R,I :Double。⇄ TSingleC
・TSingleCFunc / TDoubleCFunc   ･･･ C → C の関数参照型

・TSingleAreaC                  ･･･ Min,Max :TSingleC。Center* / Size*
・TDoubleAreaC                  ･･･ Min,Max :TDoubleC

・TdSingleC                     ･･･ R,I :TdSingle。o / d ビュー
・TdDoubleC                     ･･･ R,I :TdDouble。⇄ TdSingleC
・TdSingleCFunc / TdDoubleCFunc ･･･ 双対数上の関数参照型
・TdSingleAreaC / TdDoubleAreaC ･･･ 双対数上の定義域窓
```

### 3.2 ファイル構成

```
・Complex/
  ┣・LUX.Complex.pas      ･･･ T*C / T*AreaC ＋初等関数
  ┣・LUX.Complex.Diff.pas ･･･ 微分を運ぶ Td* の対型
  ┣・Gamma/               ･･･ 複素ガンマ — Gamma/ja/README.md を参照
  ┗・FMX/                 ･･･ TComplex3D — FMX/ja/README.md を参照
```

## 4. 使い方

```pascal
uses LUX.D1.Diff, LUX.Complex, LUX.Complex.Diff;

var
   Z, W :TDoubleC;
   A    :TDoubleAreaC;
   F    :TdDoubleC;
begin
     Z := TDoubleC.Create( 1, 2 );                 // 1 + 2i
     W := Exp( Z ) / ( 1 + Z * Z );
     W := Roo2( Z ) + 3 * TDoubleC.Imaginary;      // 主枝の平方根
     // W.Abso, W.Angle : 極形式

     A := TDoubleAreaC.Create( -2, -2, +2, +2 );   // 定義域窓
     A.SizeR := 3;                                 // 中心を保って伸縮

     ///// f(z) = z³ の z = 2 における自動微分
     F := TdDoubleC.Create( TdDouble.Create( 2, 1 ) );
     F := F * F * F;
     // F.o = 8 + 0i,  F.d = 12 + 0i  ( = 3 z² )
end;
```

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
