# LUX.Curve
[English](../README.md) | [日本語](README.md)

LUX ライブラリの補間基底と核。各ユニットは `Single` と `Double` の両精度で多重定義された素朴な関数 — Bernstein 基底、Cox–de Boor の B スプライン基底と2つの閉じた形の核、一様 Catmull–Rom の重み、正規化 sinc、`Lerp` 一族 — を提供し、基底値や重みを返すだけで、制御点との結合は呼び出し側に委ねる。

## 1. 概要

`LUX.Curve` 自身は重み付きベクトルのレコード `TSingleWector<T>` と `TDoubleWector<T>` を宣言するのみで、数学の実体は基底・核ごとに分かれた兄弟ユニットにある。いずれも曲線オブジェクトを定義しない。`Bezier` や `CatmullRom` のような関数は、1つの媒介変数値における1つの制御点の重みを評価するだけなので、同じユニットが曲線の描画にも画像の再標本化・フィルタリングにも使える。制御点グリッドの上に構築される曲線クラスは子フォルダ `Data/Grid` にある。

## 2. 数学的背景

### 2.1 Bernstein 基底

`LUX.Curve.Bezier` は次数 $n$ の Bezier 曲線の Bernstein 基底

```math
B^{n}_{i}(t) = \binom{n}{i} \, t^{\,i} \, (1-t)^{\,n-i} \qquad \text{(2.1)}
```

を、`LUX` の `Binomial32` と `System.Math` の `IntPower` を用いて直接評価する。Bezier 曲線は呼び出し側の制御点 $P_i$ に対して $C(t) = \sum_i B^{n}_{i}(t)\,P_i$ である。

### 2.2 B スプライン基底

`LUX.Curve.BSpline` は明示的なノット列 $k$ に対する Cox–de Boor の漸化式 [1]

```math
N_{i,0}(t) = \begin{cases} 1 & k_i \le t < k_{i+1} \\ 0 & \text{それ以外} \end{cases} \qquad \text{(2.2)}
```

```math
N_{i,n}(t) = \frac{t - k_i}{k_{i+n} - k_i} \, N_{i,n-1}(t) + \frac{k_{i+n+1} - t}{k_{i+n+1} - k_{i+1}} \, N_{i+1,n-1}(t) \qquad \text{(2.3)}
```

を2つの形で実装する。`BSplineREC` は漸化式を字義通りに書き下した再帰であり、`BSpline` は同じ三角形を下から埋める。すなわち $n+1$ 個の箱型関数 (2.2) を1行に並べ、隣接する要素に (2.3) を適用しながら段ごとにその場で縮約するので、再帰の指数的な呼び出し木が $O(n^2)$ のループになる。ノット列を取らない多重定義は、ノットを連続する整数とみなした一様基底で、その台は $[\,I-n,\; I+1\,)$ である。

台の幅が3と4の一様核は閉じた形でも提供される。名前の数字は台の幅（標本数）を表し、`BSpline3` は2次、`BSpline4` は3次の一様 B スプライン核である。

```math
B_3(x) = \begin{cases} \dfrac{3}{4} - x^2 & |x| < \dfrac{1}{2} \\[1ex] \dfrac{1}{2} \left( |x| - \dfrac{3}{2} \right)^{\!2} & \dfrac{1}{2} \le |x| < \dfrac{3}{2} \\[1ex] 0 & \text{それ以外} \end{cases} \qquad \text{(2.4)}
```

```math
B_4(x) = \begin{cases} \dfrac{|x|^3}{2} - x^2 + \dfrac{2}{3} & |x| < 1 \\[1ex] -\dfrac{|x|^3}{6} + x^2 - 2\,|x| + \dfrac{4}{3} & 1 \le |x| < 2 \\[1ex] 0 & \text{それ以外} \end{cases} \qquad \text{(2.5)}
```

### 2.3 Catmull–Rom の重み

`LUX.Curve.CatmullRom` は一様 Catmull–Rom スプライン [2] の4つの重みを `TSingle4D` / `TDouble4D` として返す。実装は次式の Horner 形である。

```math
\begin{pmatrix} w_1 \\ w_2 \\ w_3 \\ w_4 \end{pmatrix} = \frac{1}{2} \begin{pmatrix} 0 & -1 & 2 & -1 \\ 2 & 0 & -5 & 3 \\ 0 & 1 & 4 & -3 \\ 0 & 0 & -1 & 1 \end{pmatrix} \begin{pmatrix} 1 \\ t \\ t^{2} \\ t^{3} \end{pmatrix} \qquad \text{(2.6)}
```

$t=0$ で重みは $(0,1,0,0)$、$t=1$ で $(0,0,1,0)$ となる。連続する4つの制御点に適用すると、セグメントは中央の2点を通り、外側の2点は接線の形だけを決める。

### 2.4 正規化 sinc

`LUX.Curve.Lanczos` は正規化 sinc

```math
\mathrm{sinc}(x) = \frac{\sin \pi x}{\pi x}, \qquad \mathrm{sinc}(0) = 1 \qquad \text{(2.7)}
```

を提供する。原点の除去可能な特異点は、$|\pi x|$ が機械精度の閾値（`SINGLE_EPS3` / `DOUBLE_EPS3`）を下回るとき 1 を返すことで回避される。これは Lanczos 再標本化核 $L_a(x) = \mathrm{sinc}(x)\,\mathrm{sinc}(x/a)$ [3] の構成要素であり、呼び出し側が2回の呼び出しの積として作る。

### 2.5 線形補間

`LUX.Curve.Linear.D3` と `LUX.Curve.Linear.Q4` は、`TSingle3D` / `TDouble3D` のベクトルと `TSingleQ` / `TDoubleQ` の四元数に対する `Lerp` を最大4つの形で提供する。2点・3点の中点（重心）、媒介変数形

```math
\mathrm{Lerp}(v_1, v_2, t) = v_1 + \left( v_2 - v_1 \right) t \qquad \text{(2.8)}
```

および重み付き（重心座標）形

```math
\mathrm{Lerp}(v_1, v_2; w_1, w_2) = \frac{w_1 v_1 + w_2 v_2}{w_1 + w_2} \qquad \text{(2.9)}
```

であり、3D ユニットには3点の多重定義もある。四元数版の (2.9) は重みの和が消えるとき 0 を返す。`LUX.Curve.Linear` 自身は宣言を持たない名前空間の根である。

### 2.6 重み付きベクトル

`LUX.Curve` の `TSingleWector<_TVector_>` と `TDoubleWector<_TVector_>` は、任意のベクトル `v` とスカラの重み `w` を組にする。これは同次座標の制御点であり、多項式曲線の制御点を有理曲線のそれに変えるものである。

## 3. アーキテクチャ

### 3.1 ユニット構成

```
・LUX.Curve                  ･･･ TSingleWector<T>  TDoubleWector<T>
  ┣・LUX.Curve.Bezier       ･･･ Bezier — Bernstein 基底 (2.1)
  ┣・LUX.Curve.BSpline      ･･･ BSplineREC  BSpline  BSpline3  BSpline4
  ┣・LUX.Curve.CatmullRom   ･･･ CatmullRom — 4つの重み (2.6)
  ┣・LUX.Curve.Lanczos      ･･･ Sinc (2.7)
  ┗・LUX.Curve.Linear       ･･･ （名前空間の根。宣言なし）
     ┣・LUX.Curve.Linear.D3 ･･･ TSingle3D / TDouble3D の Lerp
     ┗・LUX.Curve.Linear.Q4 ･･･ TSingleQ / TDoubleQ の Lerp
```

すべての関数は `Single` と `Double` で多重定義されている。子フォルダはこれらの基底の上に曲線クラスを構築する。

* [**LUX.Curve.Data.Grid**](Data/Grid/ja/README.md) ：1次元制御点グリッド上の曲線と弧長等間隔の再標本化

### 3.2 ファイル構成

```
・Curve/
  ┣・LUX.Curve.pas            ･･･ 重み付きベクトルのレコード
  ┣・LUX.Curve.Bezier.pas     ･･･ Bernstein 基底
  ┣・LUX.Curve.BSpline.pas    ･･･ Cox–de Boor 基底と閉じた形の核
  ┣・LUX.Curve.CatmullRom.pas ･･･ Catmull–Rom の重み
  ┣・LUX.Curve.Lanczos.pas    ･･･ 正規化 sinc
  ┣・LUX.Curve.Linear.pas     ･･･ 名前空間の根
  ┣・LUX.Curve.Linear.D3.pas  ･･･ 3D の Lerp
  ┣・LUX.Curve.Linear.Q4.pas  ･･･ 四元数の Lerp
  ┗・Data/Grid/               ･･･ 制御点グリッド上の曲線クラス
```

## 4. 使い方

```pascal
uses LUX, LUX.D3, LUX.D4,
     LUX.Curve,
     LUX.Curve.Bezier,
     LUX.Curve.BSpline,
     LUX.Curve.CatmullRom,
     LUX.Curve.Lanczos,
     LUX.Curve.Linear.D3;

procedure Sample;
var
   T, B, N, K :Single;
   Ks :TArray<Single>;
   Ws :TSingle4D;
   P0, P1, P2, P3, P :TSingle3D;
   W :TSingleWector<TSingle3D>;
begin
     T := 0.25;

     ///// Bernstein 基底  B³₁( T )
     B := Bezier( 3, 1, T );

     ///// ノット列 Ks 上の3次 B スプライン基底
     Ks := [ -2, -1, 0, 1, 2 ];
     N  := BSpline( 3, 0, T, Ks );

     ///// 同じものを一様整数ノットで。さらに閉じた形の核
     N := BSpline( 3, 0, T );
     K := BSpline3( T );
     K := BSpline4( T );

     ///// Catmull–Rom：媒介変数 T における P0 … P3 の重み
     Ws := CatmullRom( T );
     P  := Ws[1] * P0 + Ws[2] * P1 + Ws[3] * P2 + Ws[4] * P3;

     ///// 正規化 sinc
     K := Sinc( T );

     ///// 線形補間
     P := Lerp( P0, P1, T );

     ///// 同次（重み付き）制御点
     W := TSingleWector<TSingle3D>.Create( P0, 1 );
end;
```

## 5. 参考文献

1. C. de Boor, [*On calculating with B-splines*](https://doi.org/10.1016/0021-9045%2872%2990080-9), Journal of Approximation Theory, vol. 6, no. 1, pp. 50–62, 1972.
2. E. Catmull and R. Rom, [*A Class of Local Interpolating Splines*](https://doi.org/10.1016/B978-0-12-079050-0.50020-5), in Computer Aided Geometric Design, Academic Press, pp. 317–326, 1974.
3. C. E. Duchon, [*Lanczos Filtering in One and Two Dimensions*](https://doi.org/10.1175/1520-0450%281979%29018%3C1016%3ALFIOAT%3E2.0.CO%3B2), Journal of Applied Meteorology, vol. 18, no. 8, pp. 1016–1022, 1979.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
