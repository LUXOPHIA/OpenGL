# LUX.D1.Gamma
[English](../README.md) | [日本語](README.md)

`LUX.D1.Gamma.*` は実引数のガンマ関数とその対数を、互いに独立な2通りの導出 — Lanczos 近似（`LUX.D1.Gamma.Lanczos`）と、大浦拓哉氏の `gamerf` パッケージの Delphi 移植（`LUX.D1.Gamma.Ooura`）— で評価し、結果を相互に照合できるようにする。各ユニットには、同一のアルゴリズムを双対数の上で実行し値と微分を同時に返す `.Diff` 版がある。

## 1. 概要

すべての関数は `Single` と `Double` で（`.Diff` ユニットでは `LUX.D1.Diff` の `TdSingle` と `TdDouble` で）オーバーロードされる。全体を通して次の2点に注意すること。

* 非正整数 $0, -1, -2, \dots$ は $\Gamma$ の極であり、内部で0除算が発生する。浮動小数点例外がマスクされた既定環境（Delphi 12+ / FMX）では INF/NaN を返し、`SetExceptionMask` で例外を有効化した環境では `EZeroDivide` 等が発生する。
* `RLnGamma*` は $\Gamma(x) < 0$ となる区間（$-1 < x < 0$・$-3 < x < -2$ …）では実数の対数が定義できず NaN を返す。$\ln|\Gamma(x)|$ が必要な場合は呼び出し側で処理すること。

## 2. 数学的背景

### 2.1 ガンマ関数

```math
\Gamma(x) = \int_0^{\infty} t^{\,x-1} e^{-t} \, dt \qquad \text{(2.1)}
```

は漸化式 $\Gamma(x+1) = x\,\Gamma(x)$ と相反公式

```math
\Gamma(x) \, \Gamma(1-x) = \frac{\pi}{\sin \pi x} \qquad \text{(2.2)}
```

を満たす。いずれの実装も右半直線上で近似し、$x < \tfrac{1}{2}$（Lanczos）または $x < 0$（Ooura）へは (2.2) を — `RLnGamma*` では対数の形で — 用いて到達する。

### 2.2 Lanczos 近似

$x \ge \tfrac{1}{2}$ に対し、$z = x - 1$・$B = z + g + \tfrac{1}{2}$ として、コードは

```math
\Gamma(x) \approx \sqrt{2\pi} \; B^{\,z+1/2} \, e^{-B} \left[ c_0 + \sum_{k=1}^{N-1} \frac{c_k}{z+k} \right] \qquad \text{(2.3)}
```

を評価する。`RLnGamma*` は (2.3) を直接対数の形で計算し、`RGamma*` は途中の $\ln\Gamma$ を指数関数に通すのではなく、指数部を1回の `Exp` 呼び出しにまとめる。関数名の数字は係数の項数 $N$ を表す。

| 関数 | $N$ | $g$ | 出典 |
|---|---|---|---|
| `RGamma7` / `RLnGamma7` | 7 | $5$ | Numerical Recipes [2] |
| `RGamma9` / `RLnGamma9` | 9 | $7$ | |
| `RGamma11` / `RLnGamma11` | 11 | $9$ | |
| `RGamma15` / `RLnGamma15` | 15 | $607/128$ | Boost 系・最高精度 [3] |

すべての係数は `Double` で格納され、`Single` オーバーロードと共有される。

### 2.3 大浦氏の gamerf 近似

`LUX.D1.Gamma.Ooura` は `gamerf` パッケージ [4] の `dgamma.c` / `dlgamma.c` の移植である（Copyright(C) 1996 Takuya OOURA・目的を問わず無償で利用可）。

`RGamma` は引数を $w = x - (N+2) \in [-\tfrac{1}{2}, \tfrac{1}{2}]$ へ縮約し、13次多項式 $Y(w) \approx 1/\Gamma(w+2)$ を評価したのち、漸化式 $\Gamma(x+1) = x\,\Gamma(x)$ を $N > 0$ なら上向きに、そうでなければ下向きに適用して元の引数へ戻す。

```math
\Gamma(x) = \frac{(x-1)(x-2)\cdots(x-N)}{Y(w)}, \qquad w = x - (N+2) \qquad \text{(2.4)}
```

`RLnGamma` は $w$（$x \ge 0$ なら $w = x$、$x < 0$ なら $w = 1 - x$ とし、最後に相反公式で仕上げる）に関する区分近似である。

* $w < \tfrac{1}{2}$ — $1/\Gamma(w)$ を近似する11項多項式（$w = \tfrac{1}{4}$ で分けた2組の係数）の対数の符号反転。先頭の係数には $1$ とオイラー・マスケローニ定数 $\gamma = 0.5772\dots$ が現れ、$w/\Gamma(1+w)$ のマクローリン級数に一致する。
* $\tfrac{1}{2} \le w < 3.5$ — 補助変数 $t = w - 4.5/(w + 0.5)$ で選択される、13次多項式の7区分。
* $3.5 \le w < 8$ — 単位小区間上の12次多項式の5区分。
* $w \ge 8$ — スターリング型の漸近級数

```math
\ln \Gamma(w) \approx \left( w - \tfrac{1}{2} \right) \ln w - w + \tfrac{1}{2} \ln 2\pi + \frac{d_1}{w} + \frac{d_2}{w^{3}} + \cdots + \frac{d_6}{w^{11}} \qquad \text{(2.5)}
```

この係数はスターリング級数のベルヌーイ数由来の値（$d_1 \approx \tfrac{1}{12}$・$d_2 \approx -\tfrac{1}{360}$ …）に近いが、数値的に調整されている。

### 2.4 自動微分

`.Diff` ユニットは同じアルゴリズムを双対数 `TdSingle` / `TdDouble` の上で繰り返す。その演算子は

```math
f( o + d \varepsilon ) = f(o) + f'(o) \, d \, \varepsilon \qquad \text{(2.6)}
```

を伝播するので、入力に $d = 1$ を種として与えれば、有限差分なしに $\Gamma'(x)$ が — さらに `RLnGamma*` を通せばディガンマ関数 $\psi(x) = \Gamma'(x)/\Gamma(x)$ が — 値と並んで得られる。分岐の判定（引数縮約の添字）は値部 `o` のみで行われる。

## 3. アーキテクチャ

```
[ LUX.D1.Gamma.Lanczos ( + .Diff ) ]

・RLnGamma7 / RLnGamma9 / RLnGamma11 / RLnGamma15 ･･･ ln Γ(x)・N 項の係数組
・RGamma7 / RGamma9 / RGamma11 / RGamma15         ･･･ Γ(x)

[ LUX.D1.Gamma.Ooura ( + .Diff ) ]

・RGamma                                          ･･･ Γ(x)・1/Γ 多項式 (2.4)
・RLnGamma                                        ･･･ ln Γ(x)・区分多項式 (2.5)
```

各名前は `Single` と `Double` でオーバーロードされ、`.Diff` ユニットは同じ名前を `TdSingle` と `TdDouble` でオーバーロードする。複素引数版は `Complex` フォルダ配下の `LUX.C2.Gamma.*` にある。

```
・Gamma/
  ┣・LUX.D1.Gamma.Lanczos.pas      ･･･ Lanczos 近似・4組の係数
  ┣・LUX.D1.Gamma.Lanczos.Diff.pas ･･･ 双対数版
  ┣・LUX.D1.Gamma.Ooura.pas        ･･･ gamerf の移植 ( dgamma.c / dlgamma.c )
  ┗・LUX.D1.Gamma.Ooura.Diff.pas   ･･･ 双対数版
```

## 4. 使い方

```pascal
uses LUX.D1.Diff,
     LUX.D1.Gamma.Lanczos,
     LUX.D1.Gamma.Ooura,
     LUX.D1.Gamma.Lanczos.Diff;

var
   X, G1, G2 :Double;
   D         :TdDouble;
begin
     X := 4.5;

     G1 := RGamma15( X );                    // Lanczos:  Γ(4.5) = 11.6317…
     G2 := LUX.D1.Gamma.Ooura.RGamma( X );   // 独立な実装による照合

     ///// 値と微分を同時に得る
     D := RLnGamma15( TdDouble.Create( 4.5, 1 ) );
     // D.o = ln Γ(4.5) = 2.4537…
     // D.d = ψ(4.5)    = 1.3888…      （ディガンマ）
end;
```

## 5. 参考文献

1. C. Lanczos, [*A Precision Approximation of the Gamma Function*](https://doi.org/10.1137/0701008), Journal of the Society for Industrial and Applied Mathematics, Series B: Numerical Analysis, vol. 1, no. 1, pp. 86–96, 1964.
2. W. H. Press, S. A. Teukolsky, W. T. Vetterling and B. P. Flannery, [*Numerical Recipes: The Art of Scientific Computing*](https://numerical.recipes/), 3rd ed., Cambridge University Press, 2007.
3. Boost C++ Libraries, [*The Lanczos Approximation — Boost Math Toolkit*](https://www.boost.org/doc/libs/release/libs/math/doc/html/math_toolkit/lanczos.html).
4. 大浦拓哉, [*Gamma / Error Functions*](https://www.kurims.kyoto-u.ac.jp/~ooura/gamerf.html), 京都大学数理解析研究所, 1996.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
