# LUX.D1.Legendre
[English](../README.md) | [日本語](README.md)

`LUX.D1.Legendre` は正規直交ルジャンドル多項式とその一階導関数を評価する。引数は $x$ そのもの（`NLegendre`・`dNLegendre`）でも、$x = \cos\theta$ とする極角 $\theta$（`NLegendreCos`・`dNLegendreCos`）でも与えられる。`LUX.D1.Legendre.Diff` は同じ4関数を双対数 `TdSingle` / `TdDouble` 用にオーバーロードする。

## 1. 概要

すべての関数は次数 `N_` を `Integer` で受け取り、`Single` と `Double` でオーバーロードされる。評価は有限の余弦級数によって行われ、その係数は下降型の漸化式で生成されるので、途中の値は常に有界に保たれ、素朴な階乗公式では高次で起こるオーバーフローを回避できる。`NLegendre` / `dNLegendre` は `ArcCos` を介して変換するだけなので、引数は $|x| \le 1$ を満たす必要がある。導関数の形には $x = \pm 1$ における通常の $1/\sqrt{1-x^2}$ の特異性がある。

## 2. 数学的背景

### 2.1 正規直交ルジャンドル多項式

次数 $n$ のルジャンドル多項式はロドリゲスの公式 [1]

```math
P_n(x) = \frac{1}{2^n n!} \, \frac{d^n}{dx^n} \left( x^2 - 1 \right)^n \qquad \text{(2.1)}
```

で与えられる。本ユニットは正規直交化した $\tilde P_n$（関数名の先頭の `N`）を返す。

```math
\tilde P_n(x) = \sqrt{\frac{2n+1}{2}} \; P_n(x), \qquad \int_{-1}^{1} \tilde P_n(x) \, \tilde P_m(x) \, dx = \delta_{nm} \qquad \text{(2.2)}
```

したがって、たとえば `NLegendre( X, 0 )` はすべての `X` に対して $1/\sqrt{2}$ である。

### 2.2 余弦級数による評価

$x = \cos\theta$ とすると、$\tilde P_n(\cos\theta)$ は $n$ と同じ偶奇の調波 $k = n, n-2, \dots$ にわたる有限の余弦級数になる。

```math
\tilde P_n(\cos\theta) = {\sum_{k}}' \, A^{(n)}_{k} \cos k\theta, \qquad k = n,\, n-2,\, \dots \qquad \text{(2.3)}
```

ここでプライムは、（$n$ が偶数のとき現れる）$k = 0$ の項が重み $\tfrac{1}{2}$ で入ることを表す。コードはまず先頭係数

```math
A^{(n)}_{n} = \sqrt{2} \, \prod_{m=1}^{n} \frac{\sqrt{(2m-1)(2m+1)}}{2m} \qquad \text{(2.4)}
```

を作り（局所関数 `FNN` / `ANN`）、次いで調波を2つずつ下降する（`FN20` / `AN20`）。

```math
A^{(n)}_{k} = \frac{(n-k-1)(n+k+2)}{(n-k)(n+k+1)} \; A^{(n)}_{k+2} \qquad \text{(2.5)}
```

(2.4) と (2.5) はいずれも1のオーダーに留まる比の積であり、これが、係数の閉じた階乗形ではオーバーフローするところでも評価を安定に保つ。

### 2.3 導関数

`dNLegendreCos` は (2.3) を $\theta$ について項別に微分する。

```math
\frac{d}{d\theta} \, \tilde P_n(\cos\theta) = - {\sum_{k}}' \, k \, A^{(n)}_{k} \sin k\theta \qquad \text{(2.6)}
```

`dNLegendre` は $\theta = \arccos x$ を通した連鎖律を適用する。

```math
\frac{d}{dx} \, \tilde P_n(x) = - \frac{1}{\sqrt{1-x^2}} \, \left. \frac{d}{d\theta} \, \tilde P_n(\cos\theta) \right|_{\theta = \arccos x} \qquad \text{(2.7)}
```

`.Diff` のオーバーロードは同じ級数を双対数の上で実行するので、引数に種として与えた微分係数は評価全体を通して厳密に伝播する。

## 3. アーキテクチャ

```
[ LUX.D1.Legendre ( + .Diff ) ]

・NLegendre( X, N )     ･･･ P̃_N(X)・|X| ≤ 1 が必要
・NLegendreCos( T, N )  ･･･ P̃_N(cos T)
・dNLegendre( X, N )    ･･･ d P̃_N / dX・X = ±1 で特異
・dNLegendreCos( T, N ) ･･･ d P̃_N(cos T) / dT
```

各名前は `Single` と `Double` でオーバーロードされ、`.Diff` ユニットは同じ名前を `LUX.D1.Diff` の `TdSingle` と `TdDouble` でオーバーロードする。

```
・Legendre/
  ┣・LUX.D1.Legendre.pas      ･･･ 正規直交ルジャンドル関数と導関数
  ┗・LUX.D1.Legendre.DIff.pas ･･･ 双対数版
```

## 4. 使い方

```pascal
uses LUX.D1.Legendre;

var
   X, T, P, D :Double;
begin
     X := 0.3;

     P := NLegendre( X, 5 );          // P̃₅(0.3)
     D := dNLegendre( X, 5 );         // x = 0.3 における d P̃₅/dx

     T := Pi / 3;
     P := NLegendreCos( T, 5 );       // P̃₅(cos 60°)・ArcCos の往復なし
end;
```

## 5. 参考文献

1. NIST, [*Digital Library of Mathematical Functions, Chapter 18: Orthogonal Polynomials*](https://dlmf.nist.gov/18), National Institute of Standards and Technology.
2. M. Abramowitz and I. A. Stegun, [*Handbook of Mathematical Functions*](https://personal.math.ubc.ca/~cbm/aands/), Dover, 1972.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
