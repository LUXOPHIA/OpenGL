# LUX.C2.Gamma
[English](../README.md) | [日本語](README.md)

複素引数のガンマ関数。互いに独立な導出である Lanczos 近似と大浦氏の `cdgamma` の2系統で実装され、結果を相互検算できる。各実装には、双対数による自動微分で $\Gamma(z)$ と $\Gamma'(z)$ を同時に評価する `.Diff` の対型がある。

## 1. 概要

すべての関数は `TSingleC` / `TDoubleC`（`.Diff` ユニットでは `TdSingleC` / `TdDoubleC`）に多重定義された自由関数である。

| ユニット | 輸出する関数 |
|---|---|
| `LUX.C2.Gamma.Lanczos` | `LnGamma7/9/11/15`・`Gamma7/9/11/15` |
| `LUX.C2.Gamma.Lanczos.Diff` | 同上（双対複素数上） |
| `LUX.C2.Gamma.Ooura` | `Gamma` |
| `LUX.C2.Gamma.Ooura.Diff` | `Gamma`（双対複素数上） |

Lanczos の関数名の数字は係数の項数 $N$ であり、各係数列は固有の補助パラメータ $g$ と組になる。

| 関数 | $N$ | $g$ | 係数の出典 |
|---|---|---|---|
| `LnGamma7` / `Gamma7` | 7 | $5$ | Numerical Recipes [2] |
| `LnGamma9` / `Gamma9` | 9 | $7$ | |
| `LnGamma11` / `Gamma11` | 11 | $9$ | |
| `LnGamma15` / `Gamma15` | 15 | $607/128$ | Boost 系・最高精度 [3] |

## 2. 数学的背景

### 2.1 Lanczos 近似

$\operatorname{Re} z \ge \tfrac{1}{2}$ に対して、係数列 $c_k$ とそのパラメータ $g$ を用いて次を評価する [1]。

```math
\Gamma(z) \approx \sqrt{2\pi}\; \Big( z + g - \tfrac{1}{2} \Big)^{\,z - 1/2} \, e^{-\left( z + g - 1/2 \right)} \left[ c_0 + \sum_{k=1}^{N-1} \frac{c_k}{z - 1 + k} \right] \qquad \text{(2.1)}
```

`Gamma*` はこれを1回の複素 `Exp` を通して直接計算し、`LnGamma*` はその対数を項ごとに計算する。

### 2.2 反射公式

$\operatorname{Re} z < \tfrac{1}{2}$ では両系統とも反射公式に切り替える。

```math
\Gamma(z)\, \Gamma(1 - z) = \frac{\pi}{\sin \pi z} \qquad \text{(2.2)}
```

`Gamma*` はそのまま、`LnGamma*` は対数形で適用するため、近似はよく収束する半平面でのみ使われる。

### 2.3 対数の分岐

`LnGamma*` は $\exp( \mathrm{LnGamma}(z) ) = \Gamma(z)$ を満たすが、連続な主枝の log-gamma（`lgamma` 相当）**ではない**。各 `Ln` が主枝を取るため、結果は主値と $2\pi i$ の整数倍だけ異なる場合がある。

### 2.4 極

非正整数 $z = 0, -1, -2, \dots$ は $\Gamma$ の極であり、実装はそこで0除算を行う。浮動小数点例外がマスクされた既定環境（Delphi 12+ / FMX）では `INF` / `NaN` を返し、`SetExceptionMask` で例外を有効化した環境では `EZeroDivide` 等が発生する。

### 2.5 大浦氏の cdgamma

`LUX.C2.Gamma.Ooura` は大浦拓哉氏の `gamerf` パッケージ [4] の `cdgamma.c` の Delphi 移植である（ライセンスは自由な使用・複製・改変を許す）。次数の選択肢はなく、固定された有理式と指数の近似を1つ評価し、$\operatorname{Re} z < 0$ では $e^{\pm \pi \operatorname{Im} z}$ の項を用いて反射公式を同じ経路に畳み込む。`.Diff` ユニットは同一のアルゴリズムを双対型の上に書いたものであり、微分の種に実単位を与えれば、各段の正則性により $\Gamma(z)$ と併せて $\Gamma'(z)$ が得られる。

## 3. アーキテクチャ

```
・Gamma/
  ┣・LUX.C2.Gamma.Lanczos.pas      ･･･ LnGamma7/9/11/15・Gamma7/9/11/15
  ┣・LUX.C2.Gamma.Lanczos.Diff.pas ･･･ 同上を TdSingleC / TdDoubleC 上で
  ┣・LUX.C2.Gamma.Ooura.pas        ･･･ Gamma（ gamerf cdgamma.c の移植 ）
  ┗・LUX.C2.Gamma.Ooura.Diff.pas   ･･･ Gamma を TdSingleC / TdDoubleC 上で
```

実引数版は `D1/Gamma`（`LUX.D1.Gamma.*`）にあり、複素型は `LUX.Complex` / `LUX.Complex.Diff` に由来する。

## 4. 使い方

```pascal
uses LUX.D1.Diff, LUX.Complex, LUX.Complex.Diff,
     LUX.C2.Gamma.Lanczos, LUX.C2.Gamma.Lanczos.Diff;

var
   Z, G :TDoubleC;
   F    :TdDoubleC;
begin
     Z := TDoubleC.Create( 0.5, 14.134725 );
     G := Gamma15( Z );                       // Lanczos, N = 15

     ///// z = 2.5 における Γ と Γ′ の同時評価
     F := Gamma15( TdDoubleC.Create( TdDouble.Create( 2.5, 1 ) ) );
     // F.o = Γ(2.5),  F.d = Γ′(2.5)
end;
```

`LUX.C2.Gamma.Ooura` は素の `Gamma` を輸出し、同じ複素型で Lanczos の結果との検算に使える。

## 5. 参考文献

1. C. Lanczos, [*A Precision Approximation of the Gamma Function*](https://doi.org/10.1137/0701008), Journal of the Society for Industrial and Applied Mathematics, Series B: Numerical Analysis, vol. 1, no. 1, pp. 86–96, 1964.
2. W. H. Press, S. A. Teukolsky, W. T. Vetterling and B. P. Flannery, [*Numerical Recipes in C, 2nd Edition*](https://numerical.recipes/), Cambridge University Press, 1992.
3. Boost.Math, [*The Lanczos Approximation*](https://www.boost.org/doc/libs/release/libs/math/doc/html/math_toolkit/lanczos.html), Boost C++ Libraries.
4. T. Ooura, [*Gamma / Error Functions*](https://www.kurims.kyoto-u.ac.jp/~ooura/gamerf.html), Research Institute for Mathematical Sciences, Kyoto University, 1996.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
