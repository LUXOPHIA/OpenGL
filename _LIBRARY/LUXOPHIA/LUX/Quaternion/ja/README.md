# LUX.Quaternion
[English](../README.md) | [日本語](README.md)

LUX ライブラリの四元数。`TSingleQ` と `TDoubleQ` は値意味論のレコードであり、四元数代数の演算子一式、`LUX.D4x4` の同次行列との暗黙の相互変換、回転の構築子、そして指数関数系 — `Ln`・`Exp`・`Pow`・重み付き合成 `Pows` — を備える。球面補間はこれらの合成として表される。

## 1. 概要

四元数はスカラ部 `R` と `TSingle3D` / `TDouble3D` 型のベクトル部 `I` として格納され、`X`・`Y`・`Z` は `I` を覗くプロパティである。すべてがレコードなので、代入で複製され、寿命管理を要さず、演算子と暗黙変換を通じて `LUX.D3` のベクトルや `LUX.D4x4` の行列と組み合う。`TDoubleQ` はさらに `TSingleQ` からの暗黙変換と、逆向きの明示変換を持つ。

## 2. 数学的背景

### 2.1 代数

$q = r + x\,i + y\,j + z\,k$ について、ベクトル部を $\mathbf{v} = (x,y,z)$ と書くと、演算子は Hamilton 積

```math
q_1 q_2 = \left( r_1 r_2 - \mathbf{v}_1 \!\cdot\! \mathbf{v}_2 \right) + \left( r_1 \mathbf{v}_2 + r_2 \mathbf{v}_1 + \mathbf{v}_1 \!\times\! \mathbf{v}_2 \right) \qquad \text{(2.1)}
```

に加えて、符号反転・加減算・スカラ倍・スカラ除算を実装する。プロパティは共役・ノルムの2乗（`Siz2`）・ノルム（`Size`）・逆元・単位四元数（`Unitor`）を与える。

```math
\bar{q} = r - \mathbf{v}, \qquad |q|^2 = r^2 + |\mathbf{v}|^2, \qquad q^{-1} = \frac{\bar{q}}{|q|^2} \qquad \text{(2.2)}
```

商の演算子は右除算 $q_1 / q_2 = q_1 \, q_2^{-1}$ である。`DotProduct` は4次元の内積、3つの四元数の `CrossProduct` は一般化（4次元）外積 — 3つの引数すべてに直交するベクトルを余因子展開で求めるもの — である。`Ave` は2・3・4個の四元数の算術平均を返す。

### 2.2 回転

`Rotate` は単位軸 $\mathbf{n}$ のまわりの角 $\theta$ の回転を表す単位四元数

```math
q = \cos\frac{\theta}{2} + \mathbf{n} \sin\frac{\theta}{2} \qquad \text{(2.3)}
```

を構築し、`Trans` は共役による作用の積のベクトル部を取り出す [1]。

```math
\mathbf{v}' = q \, \mathbf{v} \, q^{-1} \qquad \text{(2.4)}
```

2ベクトル版の `Rotate( V0, V1, T )` は、`V0` を `V1` へ運ぶ回転を、全角 $\arccos( \hat{\mathbf{v}}_0 \!\cdot\! \hat{\mathbf{v}}_1 )$ の割合 `T` に縮めて返す。軸は $\widehat{\mathbf{v}_0 \!\times\! \mathbf{v}_1}$ である。平行なベクトルは恒等回転を与え、軸が定まらない反平行のベクトルには、`V0` と最小成分の座標軸との外積で軸を選び、角 $T \pi$ を用いる。

### 2.3 行列との相互変換

`TSingleM4` / `TDoubleM4` への暗黙変換は、列ベクトルに作用する同次回転行列

```math
R(q) = \begin{pmatrix} r^2\!+\!x^2\!-\!y^2\!-\!z^2 & 2(xy-rz) & 2(zx+ry) \\ 2(xy+rz) & r^2\!-\!x^2\!+\!y^2\!-\!z^2 & 2(yz-rx) \\ 2(zx-ry) & 2(yz+rx) & r^2\!-\!x^2\!-\!y^2\!+\!z^2 \end{pmatrix} \qquad \text{(2.5)}
```

を、最終行・最終列 $(0,0,0,1)$ の 4 × 4 に埋め込んで構築する。逆向きの変換は、トレースが許すときは $r = \sqrt{1 + \mathrm{tr}\,R}\,/\,2$ と反対称差分からベクトル部を取り出し、そうでなければ対角最大の要素へ分岐する — Shepperd の数値的に安定な抽出である [2]。

### 2.4 指数関数系

対数と指数は一般の（単位とは限らない）四元数に対して実装される。

```math
\ln q = \ln |q| + \hat{\mathbf{v}} \, \operatorname{atan2}\!\left( |\mathbf{v}|,\ r \right) \qquad \text{(2.6)}
```

```math
e^{\,q} = e^{\,r} \left( \cos |\mathbf{v}| + \hat{\mathbf{v}} \sin |\mathbf{v}| \right) \qquad \text{(2.7)}
```

$|\mathbf{v}|$ が小さいときは級数（$\cos|\mathbf{v}| \approx 1 - |\mathbf{v}|^2/2$、$\sin|\mathbf{v}|/|\mathbf{v}| \approx 1$）へ分岐して、消えゆくノルムでの除算を避ける。この上に冪

```math
q^{\,n} = e^{\,n \ln q} \qquad \text{(2.8)}
```

と、任意個の四元数の重み付き合成

```math
\mathrm{Pows}(q_i; t_i) = \exp\!\left( \sum_i t_i \ln q_i \right) \qquad \text{(2.9)}
```

が築かれる。球面線形補間 [1] は合成 $\mathrm{slerp}(q_0, q_1, t) = q_0 \left( q_0^{-1} q_1 \right)^{t}$ であり、(2.8) でそのまま書ける — 使い方を参照。

## 3. アーキテクチャ

```
・LUX.Quaternion                        ･･･ [ uses LUX.D3, LUX.D4x4 ]
  ┣・TSingleQ                          ･･･ R :Single  I :TSingle3D
  ┃  ┣・X  Y  Z                       ･･･ I の成分を覗くプロパティ
  ┃  ┣・Siz2  Size  Conj  Inv  Unitor ･･･ |q|²・|q|・共役・逆元・単位化
  ┃  ┣・+  -  *  /                    ･･･ Hamilton 積 (2.1)、右除算
  ┃  ┣・Implicit                      ･･･ Single → q,  TSingleM4 ⇄ q (2.5)
  ┃  ┣・Rotate                        ･･･ 軸と角 (2.3)、およびベクトル間
  ┃  ┗・Trans  Normalize              ･･･ 共役による作用 (2.4)、単位長の保証
  ┗・TDoubleQ                          ･･･ R :Double  I :TDouble3D  ⇄ TSingleQ

[ ルーチン ]

・DotProduct                            ･･･ 4次元の内積
・CrossProduct                          ･･･ 3つの四元数の一般化外積
・Ave                                   ･･･ 2・3・4個の四元数の算術平均
・Ln  Exp  Pow  Pows                    ･･･ 指数関数系 (2.6) – (2.9)
```

```
・Quaternion/
  ┗・LUX.Quaternion.pas ･･･ TSingleQ  TDoubleQ
```

## 4. 使い方

```pascal
uses LUX, LUX.D3, LUX.D4x4, LUX.Quaternion;

procedure Sample;
var
   Q, Q0, Q1 :TSingleQ;
   V :TSingle3D;
   M :TSingleM4;
   T :Single;
begin
     ///// Z 軸まわりの 90° 回転
     Q := TSingleQ.Rotate( TSingle3D.IdentityZ, Pi/2 );

     ///// 適用：( 1, 0, 0 ) → ( 0, 1, 0 )
     V := Q.Trans( TSingle3D.IdentityX );

     ///// あるベクトルを別のベクトルへ運ぶ回転
     Q := TSingleQ.Rotate( TSingle3D.IdentityX, TSingle3D.IdentityY );

     ///// 同次行列との相互変換
     M := Q;
     Q := M;

     ///// Pow の合成としての球面線形補間
     T := 0.5;
     Q := Q0 * Pow( Q0.Inv * Q1, T );

     ///// 積の累積のあとに単位長へ戻す
     Q.Normalize;
end;
```

## 5. 参考文献

1. K. Shoemake, [*Animating Rotation with Quaternion Curves*](https://doi.org/10.1145/325334.325242), Proceedings of SIGGRAPH '85, pp. 245–254, 1985.
2. S. W. Shepperd, [*Quaternion from Rotation Matrix*](https://doi.org/10.2514/3.55767b), Journal of Guidance and Control, vol. 1, no. 3, pp. 223–224, 1978.

## 💖 [Embarcadero](https://www.embarcadero.com/jp/) [**Delphi**](https://www.embarcadero.com/jp/products/delphi)
ネイティブなクロスプラットフォームアプリを開発するための統合開発環境（ＩＤＥ）。
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/jp/products/delphi/starter)
