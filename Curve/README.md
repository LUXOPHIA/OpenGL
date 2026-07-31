# LUX.Curve
[English](README.md) | [日本語](ja/README.md)

Interpolation bases and kernels for the LUX library. Every unit exports plain overloaded functions in both `Single` and `Double` precision — the Bernstein basis, the Cox–de Boor B-spline basis with two closed-form kernels, the uniform Catmull–Rom weights, the normalised sinc, and the `Lerp` family — returning basis values or weights and leaving the combination with control points to the caller.

## 1. Overview

`LUX.Curve` itself declares only the weighted-vector records `TSingleWector<T>` and `TDoubleWector<T>`; the actual mathematics lives in its sibling units, each devoted to one basis or kernel. None of them defines a curve object: a function such as `Bezier` or `CatmullRom` evaluates the weight of one control point at one parameter value, so the same units serve curve drawing, image resampling and filtering alike. Curve classes built on top of control-point grids live in the `Data/Grid` subfolder.

## 2. Mathematical Background

### 2.1 Bernstein basis

`LUX.Curve.Bezier` evaluates the Bernstein basis of a degree-$n$ Bezier curve directly,

```math
B^{n}_{i}(t) = \binom{n}{i} \, t^{\,i} \, (1-t)^{\,n-i} \qquad \text{(2.1)}
```

using the `Binomial32` helper from `LUX` and `IntPower` from `System.Math`. A Bezier curve is then $C(t) = \sum_i B^{n}_{i}(t)\,P_i$ over control points $P_i$ supplied by the caller.

### 2.2 B-spline basis

`LUX.Curve.BSpline` implements the Cox–de Boor recursion [1] over an explicit knot vector $k$,

```math
N_{i,0}(t) = \begin{cases} 1 & k_i \le t < k_{i+1} \\ 0 & \text{otherwise} \end{cases} \qquad \text{(2.2)}
```

```math
N_{i,n}(t) = \frac{t - k_i}{k_{i+n} - k_i} \, N_{i,n-1}(t) + \frac{k_{i+n+1} - t}{k_{i+n+1} - k_{i+1}} \, N_{i+1,n-1}(t) \qquad \text{(2.3)}
```

in two forms: `BSplineREC` is the recursion written out literally, and `BSpline` evaluates the same triangle bottom-up — it fills a row with the $n+1$ box functions (2.2) and then reduces it in place, level by level, applying (2.3) to neighbouring entries, so the exponential call tree of the recursion becomes an $O(n^2)$ loop. Overloads without a knot vector take the knots to be consecutive integers, giving the uniform basis whose support is $[\,I-n,\; I+1\,)$.

The uniform kernels of support width 3 and 4 are also provided in closed form — the digit names the width of the support in samples, so `BSpline3` is the quadratic and `BSpline4` the cubic uniform B-spline kernel:

```math
B_3(x) = \begin{cases} \dfrac{3}{4} - x^2 & |x| < \dfrac{1}{2} \\[1ex] \dfrac{1}{2} \left( |x| - \dfrac{3}{2} \right)^{\!2} & \dfrac{1}{2} \le |x| < \dfrac{3}{2} \\[1ex] 0 & \text{otherwise} \end{cases} \qquad \text{(2.4)}
```

```math
B_4(x) = \begin{cases} \dfrac{|x|^3}{2} - x^2 + \dfrac{2}{3} & |x| < 1 \\[1ex] -\dfrac{|x|^3}{6} + x^2 - 2\,|x| + \dfrac{4}{3} & 1 \le |x| < 2 \\[1ex] 0 & \text{otherwise} \end{cases} \qquad \text{(2.5)}
```

### 2.3 Catmull–Rom weights

`LUX.Curve.CatmullRom` returns the four weights of the uniform Catmull–Rom spline [2] as a `TSingle4D` / `TDouble4D`, evaluated in Horner form of

```math
\begin{pmatrix} w_1 \\ w_2 \\ w_3 \\ w_4 \end{pmatrix} = \frac{1}{2} \begin{pmatrix} 0 & -1 & 2 & -1 \\ 2 & 0 & -5 & 3 \\ 0 & 1 & 4 & -3 \\ 0 & 0 & -1 & 1 \end{pmatrix} \begin{pmatrix} 1 \\ t \\ t^{2} \\ t^{3} \end{pmatrix} \qquad \text{(2.6)}
```

At $t=0$ the weights are $(0,1,0,0)$ and at $t=1$ they are $(0,0,1,0)$: applied to four consecutive control points, the segment interpolates the middle two, and the outer two only shape its tangents.

### 2.4 Normalised sinc

`LUX.Curve.Lanczos` supplies the normalised sinc,

```math
\mathrm{sinc}(x) = \frac{\sin \pi x}{\pi x}, \qquad \mathrm{sinc}(0) = 1 \qquad \text{(2.7)}
```

guarded against the removable singularity at the origin by returning 1 when $|\pi x|$ falls below the machine threshold (`SINGLE_EPS3` / `DOUBLE_EPS3`). It is the building block of the Lanczos resampling kernel $L_a(x) = \mathrm{sinc}(x)\,\mathrm{sinc}(x/a)$ [3], which the caller forms as a product of two calls.

### 2.5 Linear interpolation

`LUX.Curve.Linear.D3` and `LUX.Curve.Linear.Q4` supply `Lerp` for `TSingle3D` / `TDouble3D` vectors and for `TSingleQ` / `TDoubleQ` quaternions, in up to four forms: the midpoint and centroid of two or three points, the parametric form

```math
\mathrm{Lerp}(v_1, v_2, t) = v_1 + \left( v_2 - v_1 \right) t \qquad \text{(2.8)}
```

and the weighted (barycentric) form

```math
\mathrm{Lerp}(v_1, v_2; w_1, w_2) = \frac{w_1 v_1 + w_2 v_2}{w_1 + w_2} \qquad \text{(2.9)}
```

with a three-point overload in the 3D unit. The quaternion version of (2.9) returns 0 when the weight sum vanishes. `LUX.Curve.Linear` itself is an empty namespace root.

### 2.6 Weighted vectors

`TSingleWector<_TVector_>` and `TDoubleWector<_TVector_>` in `LUX.Curve` pair an arbitrary vector `v` with a scalar weight `w` — a homogeneous control point, which is what turns the control points of a polynomial curve into those of a rational one.

## 3. Architecture

### 3.1 Units

```
・LUX.Curve                  ･･･ TSingleWector<T>  TDoubleWector<T>
  ┣・LUX.Curve.Bezier       ･･･ Bezier — Bernstein basis (2.1)
  ┣・LUX.Curve.BSpline      ･･･ BSplineREC  BSpline  BSpline3  BSpline4
  ┣・LUX.Curve.CatmullRom   ･･･ CatmullRom — the four weights (2.6)
  ┣・LUX.Curve.Lanczos      ･･･ Sinc (2.7)
  ┗・LUX.Curve.Linear       ･･･ ( namespace root, no declarations )
     ┣・LUX.Curve.Linear.D3 ･･･ Lerp for TSingle3D / TDouble3D
     ┗・LUX.Curve.Linear.Q4 ･･･ Lerp for TSingleQ / TDoubleQ
```

Every routine is overloaded for `Single` and `Double`. The subfolder builds curve classes on top of these bases:

* [**LUX.Curve.Data.Grid**](Data/Grid/README.md) ：curves over 1-D control-point grids, with equal arc-length resampling

### 3.2 File layout

```
・Curve/
  ┣・LUX.Curve.pas            ･･･ weighted-vector records
  ┣・LUX.Curve.Bezier.pas     ･･･ Bernstein basis
  ┣・LUX.Curve.BSpline.pas    ･･･ Cox–de Boor basis and closed-form kernels
  ┣・LUX.Curve.CatmullRom.pas ･･･ Catmull–Rom weights
  ┣・LUX.Curve.Lanczos.pas    ･･･ normalised sinc
  ┣・LUX.Curve.Linear.pas     ･･･ namespace root
  ┣・LUX.Curve.Linear.D3.pas  ･･･ Lerp in 3D
  ┣・LUX.Curve.Linear.Q4.pas  ･･･ Lerp for quaternions
  ┗・Data/Grid/               ･･･ curve classes over control-point grids
```

## 4. Usage

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

     ///// Bernstein basis  B³₁( T )
     B := Bezier( 3, 1, T );

     ///// cubic B-spline basis over the knot vector Ks
     Ks := [ -2, -1, 0, 1, 2 ];
     N  := BSpline( 3, 0, T, Ks );

     ///// the same, uniform integer knots, and the closed-form kernels
     N := BSpline( 3, 0, T );
     K := BSpline3( T );
     K := BSpline4( T );

     ///// Catmull–Rom: weights of P0 … P3 at parameter T
     Ws := CatmullRom( T );
     P  := Ws[1] * P0 + Ws[2] * P1 + Ws[3] * P2 + Ws[4] * P3;

     ///// normalised sinc
     K := Sinc( T );

     ///// linear interpolation
     P := Lerp( P0, P1, T );

     ///// a homogeneous ( weighted ) control point
     W := TSingleWector<TSingle3D>.Create( P0, 1 );
end;
```

## 5. References

1. C. de Boor, [*On calculating with B-splines*](https://doi.org/10.1016/0021-9045%2872%2990080-9), Journal of Approximation Theory, vol. 6, no. 1, pp. 50–62, 1972.
2. E. Catmull and R. Rom, [*A Class of Local Interpolating Splines*](https://doi.org/10.1016/B978-0-12-079050-0.50020-5), in Computer Aided Geometric Design, Academic Press, pp. 317–326, 1974.
3. C. E. Duchon, [*Lanczos Filtering in One and Two Dimensions*](https://doi.org/10.1175/1520-0450%281979%29018%3C1016%3ALFIOAT%3E2.0.CO%3B2), Journal of Applied Meteorology, vol. 18, no. 8, pp. 1016–1022, 1979.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
