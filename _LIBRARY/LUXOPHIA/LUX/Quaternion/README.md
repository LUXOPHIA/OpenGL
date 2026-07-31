# LUX.Quaternion
[English](README.md) | [日本語](ja/README.md)

Quaternions for the LUX library. `TSingleQ` and `TDoubleQ` are value-semantics records with the full operator set of the quaternion algebra, implicit casts to and from the homogeneous matrices of `LUX.D4x4`, rotation constructors, and an exponential family — `Ln`, `Exp`, `Pow` and the weighted blend `Pows` — from which spherical interpolation is composed.

## 1. Overview

A quaternion is stored as a scalar part `R` and a vector part `I` of type `TSingle3D` / `TDouble3D`, with `X`, `Y`, `Z` exposed as properties into `I`. Everything is a record: quaternions are copied by assignment, need no lifetime management, and compose with the `LUX.D3` vectors and `LUX.D4x4` matrices through operators and implicit casts. `TDoubleQ` additionally converts implicitly from `TSingleQ` and explicitly back.

## 2. Mathematical Background

### 2.1 Algebra

For $q = r + x\,i + y\,j + z\,k$, writing the vector part $\mathbf{v} = (x,y,z)$, the operators implement the Hamilton product

```math
q_1 q_2 = \left( r_1 r_2 - \mathbf{v}_1 \!\cdot\! \mathbf{v}_2 \right) + \left( r_1 \mathbf{v}_2 + r_2 \mathbf{v}_1 + \mathbf{v}_1 \!\times\! \mathbf{v}_2 \right) \qquad \text{(2.1)}
```

together with negation, addition, subtraction and scalar multiplication and division. The properties supply the conjugate, squared norm (`Siz2`), norm (`Size`), inverse and unit quaternion (`Unitor`):

```math
\bar{q} = r - \mathbf{v}, \qquad |q|^2 = r^2 + |\mathbf{v}|^2, \qquad q^{-1} = \frac{\bar{q}}{|q|^2} \qquad \text{(2.2)}
```

The quotient operator is the right division $q_1 / q_2 = q_1 \, q_2^{-1}$. `DotProduct` is the four-dimensional dot product, and `CrossProduct` of three quaternions is the generalised (four-dimensional) cross product — the vector orthogonal to all three arguments, expanded cofactor by cofactor. `Ave` returns the arithmetic mean of two, three or four quaternions.

### 2.2 Rotation

`Rotate` builds the unit quaternion of the rotation by angle $\theta$ about the unit axis $\mathbf{n}$,

```math
q = \cos\frac{\theta}{2} + \mathbf{n} \sin\frac{\theta}{2} \qquad \text{(2.3)}
```

and `Trans` applies it by conjugation, taking the vector part of the product [1]:

```math
\mathbf{v}' = q \, \mathbf{v} \, q^{-1} \qquad \text{(2.4)}
```

The two-vector overload `Rotate( V0, V1, T )` returns the rotation that carries `V0` onto `V1`, scaled to the fraction `T` of the full angle $\arccos( \hat{\mathbf{v}}_0 \!\cdot\! \hat{\mathbf{v}}_1 )$, with the axis $\widehat{\mathbf{v}_0 \!\times\! \mathbf{v}_1}$. Parallel vectors yield the identity; antiparallel vectors, whose axis is underdetermined, get one chosen by crossing `V0` with the coordinate axis of its smallest component, and the angle $T \pi$.

### 2.3 Matrix casts

The implicit cast to `TSingleM4` / `TDoubleM4` builds the homogeneous rotation matrix acting on column vectors,

```math
R(q) = \begin{pmatrix} r^2\!+\!x^2\!-\!y^2\!-\!z^2 & 2(xy-rz) & 2(zx+ry) \\ 2(xy+rz) & r^2\!-\!x^2\!+\!y^2\!-\!z^2 & 2(yz-rx) \\ 2(zx-ry) & 2(yz+rx) & r^2\!-\!x^2\!-\!y^2\!+\!z^2 \end{pmatrix} \qquad \text{(2.5)}
```

embedded in a 4 × 4 with the last row and column $(0,0,0,1)$. The reverse cast extracts $r = \sqrt{1 + \mathrm{tr}\,R}\,/\,2$ and the vector part from the antisymmetric differences when the trace allows, and otherwise branches to the largest diagonal element — the numerically stable extraction of Shepperd [2].

### 2.4 Exponential family

The logarithm and exponential are implemented for general (not necessarily unit) quaternions,

```math
\ln q = \ln |q| + \hat{\mathbf{v}} \, \operatorname{atan2}\!\left( |\mathbf{v}|,\ r \right) \qquad \text{(2.6)}
```

```math
e^{\,q} = e^{\,r} \left( \cos |\mathbf{v}| + \hat{\mathbf{v}} \sin |\mathbf{v}| \right) \qquad \text{(2.7)}
```

with the small-$|\mathbf{v}|$ branches taken from the series ($\cos|\mathbf{v}| \approx 1 - |\mathbf{v}|^2/2$, $\sin|\mathbf{v}|/|\mathbf{v}| \approx 1$) to avoid dividing by a vanishing norm. On these are built the power

```math
q^{\,n} = e^{\,n \ln q} \qquad \text{(2.8)}
```

and the weighted blend of an arbitrary number of quaternions,

```math
\mathrm{Pows}(q_i; t_i) = \exp\!\left( \sum_i t_i \ln q_i \right) \qquad \text{(2.9)}
```

Spherical linear interpolation [1] is the composition $\mathrm{slerp}(q_0, q_1, t) = q_0 \left( q_0^{-1} q_1 \right)^{t}$, expressed directly with (2.8) — see Usage.

## 3. Architecture

```
・LUX.Quaternion                        ･･･ [ uses LUX.D3, LUX.D4x4 ]
  ┣・TSingleQ                          ･･･ R :Single  I :TSingle3D
  ┃  ┣・X  Y  Z                       ･･･ component views into I
  ┃  ┣・Siz2  Size  Conj  Inv  Unitor ･･･ |q|² |q| conjugate inverse unit
  ┃  ┣・+  -  *  /                    ･･･ Hamilton product (2.1), right div
  ┃  ┣・Implicit                      ･･･ Single → q,  TSingleM4 ⇄ q (2.5)
  ┃  ┣・Rotate                        ･･･ axis–angle (2.3), vector-to-vector
  ┃  ┗・Trans  Normalize              ･･･ conjugation (2.4), unit-length guard
  ┗・TDoubleQ                          ･･･ R :Double  I :TDouble3D  ⇄ TSingleQ

[ routines ]

・DotProduct                            ･･･ four-dimensional dot product
・CrossProduct                          ･･･ ternary generalised cross product
・Ave                                   ･･･ arithmetic mean of 2..4 quaternions
・Ln  Exp  Pow  Pows                    ･･･ exponential family (2.6) – (2.9)
```

```
・Quaternion/
  ┗・LUX.Quaternion.pas ･･･ TSingleQ  TDoubleQ
```

## 4. Usage

```pascal
uses LUX, LUX.D3, LUX.D4x4, LUX.Quaternion;

procedure Sample;
var
   Q, Q0, Q1 :TSingleQ;
   V :TSingle3D;
   M :TSingleM4;
   T :Single;
begin
     ///// rotation by 90° about the Z axis
     Q := TSingleQ.Rotate( TSingle3D.IdentityZ, Pi/2 );

     ///// apply it:  ( 1, 0, 0 ) → ( 0, 1, 0 )
     V := Q.Trans( TSingle3D.IdentityX );

     ///// the rotation carrying one vector onto another
     Q := TSingleQ.Rotate( TSingle3D.IdentityX, TSingle3D.IdentityY );

     ///// to and from the homogeneous matrix
     M := Q;
     Q := M;

     ///// spherical linear interpolation, composed from Pow
     T := 0.5;
     Q := Q0 * Pow( Q0.Inv * Q1, T );

     ///// restore unit length after accumulated products
     Q.Normalize;
end;
```

## 5. References

1. K. Shoemake, [*Animating Rotation with Quaternion Curves*](https://doi.org/10.1145/325334.325242), Proceedings of SIGGRAPH '85, pp. 245–254, 1985.
2. S. W. Shepperd, [*Quaternion from Rotation Matrix*](https://doi.org/10.2514/3.55767b), Journal of Guidance and Control, vol. 1, no. 3, pp. 223–224, 1978.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
