# LUX.Curve.Data.Grid
[English](README.md) | [日本語](ja/README.md)

Curve classes over one-dimensional control-point grids. `TCurve<T>` evaluates a curve defined on a `TPoins<T>` grid from `LUX.Data.Grid.D1`, and `TPlots<T>` is itself such a grid, filled by resampling a curve at equal intervals of arc length.

## 1. Overview

Both classes are generic in the point type and abstract in exactly one method each: `TCurve<T>` leaves the evaluation of a single span (`Segment`) to a descendant, which is where a basis from `LUX.Curve.*` is applied to the control points; `TPlots<T>` leaves the metric (`Distance`) to a descendant. Change propagation is automatic — a grid raises `OnChange`, the curve listening to it raises its own, and the plots listening to that mark their caches stale, to be rebuilt lazily on the next read.

## 2. Technical Background

### 2.1 Parameterisation

A curve over a grid of `PoinsN` points has `CellsN = PoinsN − 1` spans and is parameterised by $X \in [\,0,\ \mathrm{CellsN}\,]$. `Value` splits the parameter into span index and local parameter,

```math
C(X) = \mathrm{Segment}\!\left( \lfloor X \rfloor,\ X - \lfloor X \rfloor \right) \qquad \text{(2.1)}
```

### 2.2 Arc length and equal-arc-length resampling

`TPlots` approximates the curve by $M$ = `EdgesN` chords (default 1024). With $t_j = j \cdot \mathrm{CellsN} / M$, the edge lengths and total arc length are

```math
e_j = \mathrm{Distance}\!\left( C(t_j),\ C(t_{j+1}) \right), \qquad L = \sum_{j=0}^{M-1} e_j \qquad \text{(2.2)}
```

The number of resampled points follows from the requested spacing `PlotGap`, $P = \mathrm{round}( L / \mathrm{PlotGap} ) + 1$, and point $i$ is placed at arc length $s_i = i \cdot L / (P-1)$ by walking the edge list and inverting the cumulative chord length linearly within the edge that contains $s_i$. The result is a grid of points spaced (approximately) `PlotGap` apart along the curve, however unevenly the source parameterisation moves.

## 3. Architecture

```
・LUX.Curve.Data.Grid.D1        ･･･ [ uses LUX.Data.Grid.D1, LUX.Curve ]
  ┗・TCurve<_TPoin_>           ･･･ a curve over a control-point grid
     ┣・Poins :TPoins<_TPoin_> ･･･ control points
     ┣・Segment                ･･･ abstract — evaluate one span
     ┣・Value                  ･･･ (2.1), the whole curve
     ┗・OnChange :TDelegates

・LUX.Curve.Data.Grid.D1.Plots
  ┗・TPlots<_TPoin_>           ･･･ ( TPoins ) equal-arc-length resampling
     ┣・Curve :TCurve<_TPoin_> ･･･ the curve to resample
     ┣・EdgesN  Edges  ArcLen  ･･･ chord approximation (2.2)
     ┣・PlotGap                ･･･ requested point spacing
     ┗・Distance               ･･･ abstract — the metric
```

```
・Curve/Data/Grid/
  ┣・LUX.Curve.Data.Grid.D1.pas       ･･･ TCurve<T>
  ┗・LUX.Curve.Data.Grid.D1.Plots.pas ･･･ TPlots<T>
```

## 4. Usage

```pascal
uses LUX.D3, LUX.D4, LUX.Curve.CatmullRom,
     LUX.Data.Grid.D1,
     LUX.Curve.Data.Grid.D1,
     LUX.Curve.Data.Grid.D1.Plots;

type
  TMyCurve = class( TCurve<TSingle3D> )
  protected
    function Segment( const I_:Integer; const T_:Double ) :TSingle3D; override;
  end;

  TMyPlots = class( TPlots<TSingle3D> )
  protected
    function Distance( const P0_,P1_:TSingle3D ) :Double; override;
  end;

function TMyCurve.Segment( const I_:Integer; const T_:Double ) :TSingle3D;
var
   W :TSingle4D;
begin
     W := CatmullRom( Single( T_ ) );

     Result := W[1] * Poins[ I_-1 ] + W[2] * Poins[ I_   ]
             + W[3] * Poins[ I_+1 ] + W[4] * Poins[ I_+2 ];
end;

function TMyPlots.Distance( const P0_,P1_:TSingle3D ) :Double;
begin
     Result := ( P1_ - P0_ ).Size;
end;
```

```pascal
     Plots         := TMyPlots.Create;
     Plots.Curve   := Curve;
     Plots.PlotGap := 0.1;

     for I := 0 to Plots.PoinsN-1 do P := Plots[ I ];
```

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
