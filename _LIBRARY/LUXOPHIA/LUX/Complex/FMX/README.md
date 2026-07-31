# LUX.Complex.FMX.D3
[English](README.md) | [日本語](ja/README.md)

A single FireMonkey unit: `TComplex3D`, a 3-D control that draws the graph of a complex function $f : \mathbb{C} \to \mathbb{C}$ as a lit, textured surface over a rectangular domain.

## 1. Overview

`TComplex3D` derives from `TF3DShaper` (`LUX.FMX.Graphics.D3`) and owns a `TMeshData` rebuilt on demand. The function is supplied as a `TdDoubleCFunc` — the dual-number type of `LUX.Complex.Diff` — so the exact partial derivatives of the surface are available and the vertex normals come from automatic differentiation via `TexToMatrix` (`LUX.D4x4.Diff`) rather than from finite differences. Geometry is generated in parallel with `TParallel.For`; the domain is a `TDoubleAreaC` window, tessellated `DivX` × `DivY` with two triangles per cell.

## 2. Technical Background

For $z = x + i y$ ranging over `Area`, a vertex is placed at the modulus of the function value:

```math
\mathbf{p}(x, y) = \left(\, x,\ |f(z)|,\ y \,\right) \qquad \text{(2.1)}
```

The value itself is encoded in the texture coordinates. Its modulus is compressed by `Scale` $= s$, which maps the whole plane into the unit disc while preserving the argument, and the disc is placed in the unit texture square:

```math
w' = \frac{w}{s + |w|}, \qquad t = \left( \frac{1 + \operatorname{Re} w'}{2},\ \frac{1 + \operatorname{Im} w'}{2} \right), \qquad w = f(z) \qquad \text{(2.2)}
```

A texture assigned to `Material` therefore acts as a colour map of the function value — domain colouring, with the disc centre representing $0$ and the rim representing $\infty$.

## 3. Architecture

```
・TComplex3D ( TF3DShaper )          ･･･ surface graph of f : C → C
  ┣・Func :TdDoubleCFunc            ･･･ function to draw ( duals → normals )
  ┣・Area :TDoubleAreaC             ･･･ domain ( default -1-1i … +1+1i )
  ┣・DivX,DivY :Integer             ･･･ grid tessellation ( default 64 × 64 )
  ┣・Scale :Double                  ･･･ s of modulus compression ( default 1 )
  ┗・Material :TLightMaterialSource ･･･ lit material; texture = colour map
```

Setting any property marks the geometry (and, for `DivX` / `DivY`, the topology) dirty and repaints. When `Func` is `nil` the mesh is emptied.

## 4. Usage

```pascal
uses LUX.Complex, LUX.Complex.Diff, LUX.Complex.FMX.D3,
     LUX.C2.Gamma.Ooura.Diff;

var
   G :TComplex3D;
begin
     G := TComplex3D.Create( Viewport3D1 );
     G.Parent := Viewport3D1;

     G.Func := function( const C_:TdDoubleC ) :TdDoubleC
               begin
                    Result := Gamma( C_ );        // Γ(z), with derivative
               end;
     G.Area  := TDoubleAreaC.Create( -4, -4, +4, +4 );
     G.Scale := 2;
end;
```

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
