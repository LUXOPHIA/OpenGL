# LUX.Data.Grid
[English](README.md) | [日本語](ja/README.md)

Generic point grids: a 1-D array of points with lazy rebuilding and change notification, a cyclic variant of it, and a 2-D triangular grid that enumerates its points and faces in integer barycentric coordinates.

## 1. Overview

`TPoins<_TPoin_>` stores a 1-D row of points of any type. Reading a point first calls `InitPoins`, which — only if the array has been marked stale — reallocates the storage and calls the virtual `MakePoins`; a derived class overrides `MakePoins` to compute its points, so the grid rebuilds itself lazily on first access. Every mutation raises the `OnChange` delegate list.

`TLoopPoins<_TPoin_>` is the cyclic variant: indices wrap modulo `PoinsN`, so the row closes into a loop and `CellsN = PoinsN`.

`TTriaGrid<_TPoin_>` is a triangular grid subdivided twice — into `CellsN` cells per side, each cell into `DivN` sub-edges — and walks its points and faces with `ForPoins` / `ParaForPoins` / `ForFaces` rather than exposing an index arithmetic to the caller.

## 2. Mathematical Background

### 2.1 The 1-D grids

An open row of $P$ points has $P-1$ cells between them; the loop variant identifies the two ends, so

```math
\mathrm{CellsN} = \mathrm{PoinsN} - 1 \quad \text{(open)}, \qquad \mathrm{CellsN} = \mathrm{PoinsN} \quad \text{(loop)} \qquad \text{(2.1)}
```

The loop grid maps an index $i$ onto storage as

```math
i \;\mapsto\; \left( 10\,N + i \right) \bmod N, \qquad N = \mathrm{PoinsN} \qquad \text{(2.2)}
```

the offset $10N$ keeping the argument of `mod` non-negative for moderately negative indices.

### 2.2 The triangular grid

The side of the triangle is divided into

```math
E = \mathrm{CellsN} \times \mathrm{DivN} \qquad \text{(2.3)}
```

edges (`EdgesN`). Points are addressed by integer barycentric coordinates $(X, Y, Z)$ on the plane

```math
X + Y + Z = E, \qquad X, Y, Z \ge 0 \qquad \text{(2.4)}
```

which `ForPoins` enumerates row by row ( `ParaForPoins` parallelises the rows with `TParallel.For` ). Counting the points of that simplex and the small triangles of the subdivision gives

```math
\mathrm{AllPoinsN} = \frac{(E+1)(E+2)}{2}, \qquad \mathrm{AllCellsN} = E^{2} \qquad \text{(2.5)}
```

`ForFaces` yields each of the $E^2$ faces as three `TInteger3D` corners: every row contributes its upward triangles and, between them, the downward ones, both wound in the same orientation.

## 3. Architecture

### 3.1 Class structure

```
・TPoins<_TPoin_>           ･･･ 1-D points; lazy MakePoins, OnChange delegates
  ┗・TLoopPoins<_TPoin_>   ･･･ cyclic variant; indices wrap modulo PoinsN

・TTriaGrid<_TPoin_:record> ･･･ triangular grid; ForPoins / ForFaces walks
```

### 3.2 File layout

```
・Data/Grid/
  ┣・LUX.Data.Grid.D1.pas      ･･･ TPoins<T>  TLoopPoins<T>
  ┗・LUX.Data.Grid.Tria.D2.pas ･･･ TTriaGrid<T>
```

Both units depend only on `LUX` ( and `LUX.D3` for `TInteger3D` ); nothing outside the RTL is used.

## 4. Usage

```pascal
uses LUX, LUX.D3, LUX.Data.Grid.Tria.D2;

var
   G :TTriaGrid<TSingle3D>;
begin
     G := TTriaGrid<TSingle3D>.Create;
     try
        G.CellsN := 2;
        G.DivN   := 3;   // E = 6 edges per side

        G.ForPoins( procedure( const X_,Y_,Z_:Integer )
        begin
             // X_ + Y_ + Z_ = 6 : integer barycentric coordinates
        end );

        G.ForFaces( procedure( const P0_,P1_,P2_:TInteger3D )
        begin
             // called 36 ( = 6² ) times, once per face
        end );
     finally
        G.Free;
     end;
end;
```

To fill a 1-D grid, derive from `TPoins<T>` ( or `TLoopPoins<T>` ) and override `MakePoins`; the override runs at most once per invalidation, on the first read.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
