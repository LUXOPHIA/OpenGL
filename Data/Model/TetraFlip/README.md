# LUX.Data.Model.TetraFlip
[English](README.md) | [日本語](ja/README.md)

A corner-table tetrahedral mesh for Delphi — the solid counterpart of [TriFlip](../TriFlip/README.md). Cells are glued face to face by `Weld`, which derives the rotation code of the gluing from the identity of the vertices, and the mesh is persisted with its complete connectivity in `*.lxtc` files. The layer is purely combinatorial — coordinates are a type parameter and enter no algorithm — and it is the mesh foundation of [LUX.Delaunay](https://github.com/LUXOPHIA/LUX.Delaunay)`.D3`.

## 1. Overview

The folder holds one structure in three layers:

| Unit | Layer |
|---|---|
| `LUX.Data.Model.TetraFlip.core` | Implementation — all fields and algorithms, generic in the coordinate type `TPos_`. |
| `LUX.Data.Model.TetraFlip` | Typing — retypes the mutual references to the user's derived classes. |
| `LUX.Data.Model.TetraFlip.D3` | 3-D specialization — `TPos_` fixed to `TSingle3D`. |

A mesh is a cell set `TTetraCellSet` (which owns a point set `TTetraPoinSet`) of tetrahedra `TTetraCell`. Every cell stores its four vertices `Poin[0..3]`, its four neighbours `Cell[0..3]`, and three packed bytes: `_Corn` and `_Bond` each hold four 2-bit values — the neighbour's opposite-corner number and the rotation code of the shared face — and `_Flag` is a free byte for search-state management. Every vertex stores its coordinates `Pos` and an *anchor* — one cell `Cell` containing it and its corner number `Corn` in it — so the traversal of a vertex's star starts in O(1). Face K of a cell means the face opposite vertex K; its three adjacency slots `Cell[K]` / `Corn[K]` / `Bond[K]` describe the gluing entirely, and gluing itself is the single move `Weld` — the caller never computes a rotation code by hand.

## 2. Technical Background

### 2.1 Corner frames — `VertTable`

Corners are numbered `0..3`. For each face $K$ (the face opposite vertex $K$), `VertTable[K]` lists the vertices in a *canonical frame*: position 0 is the apex $K$ itself, positions 1..3 are the vertices of the face. The four rows

```math
V_0 = e ,\quad
V_1 = (0\,1)(2\,3) ,\quad
V_2 = (0\,2)(1\,3) ,\quad
V_3 = (0\,3)(1\,2)
\qquad \text{(2.1)}
```

are exactly the double transpositions of $\{0,1,2,3\}$ (the Klein four-group). Every row is an *even* permutation, so the orientation of the cell looks the same from every face; and every row is an *involution* (its own inverse), so the same table converts both ways — frame position → corner number and corner number → frame position.

### 2.2 Face gluing — `BondTable` and `Join`

A shared triangle is seen with *opposite* orientation from its two cells, so a gluing is an orientation-reversing matching of the two frames that fixes the apex slot 0. There are exactly three, the transpositions

```math
B_1 = (2\,3) ,\qquad
B_2 = (1\,3) ,\qquad
B_3 = (1\,2) ,
\qquad \text{(2.2)}
```

stored as `BondTable[1..3]`, and this is the *rotation code* `Bond[K]` of a glued face. Transpositions are involutions, so the same code is stored on both sides of the face. The composition

```math
\mathrm{Join}_K \;=\; V_{\mathrm{Corn}[K]} \circ B_{\mathrm{Bond}[K]}
\qquad \text{(2.3)}
```

converts a frame position of face $K$ into a corner number of the neighbour, and the gluing is consistent iff the vertices agree through it (the condition counted by `CheckCells`):

```math
T'.\mathrm{Poin}\bigl[\, \mathrm{Join}_K(I) \,\bigr]
\;=\;
T.\mathrm{Poin}\bigl[\, V_K(I) \,\bigr] ,
\qquad I = 1..3 .
\qquad \text{(2.4)}
```

The tables — even permutations for `VertTable`, odd for `BondTable` — are inherited unchanged from the earlier implementation `LUX.Brep.Cell.TetraFlip`.

### 2.3 Welding

`BondOf( K_, Cell_, CornK_ )` derives the rotation code from vertex identity: it looks up where the first frame vertex of face `K_` appears in the neighbour's frame of face `CornK_`, then verifies that the remaining two vertices correspond through (2.4) as mirror images — the same vertex set glued with the *same* orientation is rejected, and the result `0` means "cannot be glued". `CanWeld` is `BondOf > 0`, and `Weld` stores the symmetric triple `Cell` / `Corn` / `Bond` on both sides, with the same code on each by the involution property. A freshly created cell is born with placeholder self-links (`Cell[I] = Self`, `Corn[I] = I`, `Bond[I] = 1`), so the pointers are never `nil`; `CheckCells` reports such a cell until it is actually welded.

### 2.4 Integrity check

`CheckCells` returns the number of face slots at which the structure is broken: a `nil` or self neighbour, an asymmetric `Cell` / `Corn` / `Bond` triple, or a vertex mismatch in (2.4). It is `0` on a consistent closed mesh.

## 3. Architecture

### 3.1 Class diagram

```
Inheritance ( core layer → typing layer → 3-D specialization )

・TPoin<TPos_,TPoinSet_>                       ･･･ (LUX.Data.Model.Poins)
  ┗・TTetraPoin<TPos_>                        ･･･ anchor Cell / Corn
     ┗・TTetraPoin<TPos_,TCell_>              ･･･ Cell retyped to TCell_
        ┗・TTetraPoin3D<TCell_>               ･･･ TPos_ = TSingle3D

・TPoinSet<TPos_,TPoin_>                       ･･･ (LUX.Data.Model.Poins)
  ┗・TTetraPoinSet<TPos_>                     ･･･ LoadPoin, SaveToStream
     ┗・TTetraPoinSet<TPos_,TPoin_>           ･･･ Childrs / enumeration retyped
        ┗・TTetraPoinSet3D<TPoin_>            ･･･ TPos_ = TSingle3D

・TCell<TPos_,TCellSet_>                       ･･･ (LUX.Data.Model.Cells)
  ┗・TTetraCell<TPos_>                        ･･･ Poin/Cell/Corn/Bond/Join/Weld
     ┗・TTetraCell<TPos_,TPoin_,TCell_>       ･･･ Poin / Cell retyped
        ┗・TTetraCell3D<TPoin_,TCell_>        ･･･ TPos_ = TSingle3D

・TCellSet<TPos_,TCell_>                       ･･･ (LUX.Data.Model.Cells)
  ┗・TTetraCellSet<TPos_>                     ･･･ PoinSet, CheckCells, file I-O
     ┗・TTetraCellSet<TPos_,TCell_,TPoinSet_> ･･･ PoinSet / enum. retyped
        ┗・TTetraCellSet3D<TCell_,TPoinSet_>  ･･･ TPos_ = TSingle3D

Records and constants ( core layer )

・TByteArray4                                  ･･･ row of the cycling tables
・VertTable                                    ･･･ canonical face frames (2.1)
・BondTable                                    ･･･ rotation codes 1..3 (2.2)
```

### 3.2 File layout

```
・TetraFlip/
  ┣・LUX.Data.Model.TetraFlip.core.pas ･･･ unit ….TetraFlip.core
  ┣・LUX.Data.Model.TetraFlip.pas      ･･･ unit LUX.Data.Model.TetraFlip
  ┣・LUX.Data.Model.TetraFlip.D3.pas   ･･･ unit ….TetraFlip.D3
  ┣・README.md                         ･･･ this document
  ┗・ja/README.md                      ･･･ Japanese translation
```

### 3.3 Class reference — `LUX.Data.Model.TetraFlip.core`

#### `TTetraPoin<TPos_>` — vertex

| Member | Description |
|---|---|
| `Create( Pos_ )` / `Create( Pos_, Parent_ )` | A vertex at `Pos_`, optionally added to a point set. *(inherited)* |
| `Pos :TPos_` | Coordinates. *(inherited)* |
| `Cell :TTetraCell<TPos_>` / `Corn :Byte` | Anchor: one cell containing this vertex, and its corner number in it. |

#### `TTetraPoinSet<TPos_>` — point set

| Member | Description |
|---|---|
| `Childrs[I]` / `ChildrsN` / `Count` | The vertices, iterable and indexable. *(inherited)* |
| `LoadPoin( Pos_ )` *(protected)* | Factory for loaded points — `override` substitutes a derived point type. |
| `SaveToStream( Stream_ )` | Write the raw coordinates of all points, in `Order`. |
| `LoadFromStream( Stream_, PoinsN_ )` | Replace the points by ones generated from a coordinate sequence. *(inherited)* |

#### `TTetraCell<TPos_>` — tetrahedron

| Member | Description |
|---|---|
| `Poin[0..3] :TTetraPoin<TPos_>` | Vertices. Assigning does not touch anchors — call `BindPoins`. |
| `Cell[0..3]` | Neighbour across face `I` (the face opposite vertex `I`). New cells carry placeholder self-links. |
| `Corn[0..3] :Byte` | The neighbour's opposite-corner number — 4 × 2 bits in one byte. |
| `Bond[0..3] :Byte` | Rotation code `1..3` of the shared face (2.2) — 4 × 2 bits in one byte. |
| `Join[K,I] :Byte` | Vertex correspondence (2.3): frame position `I` of face `K` → corner number in the neighbour. |
| `Flag :Byte` | Free byte for search-state management; round-tripped by the file format. |
| `CornOf( Poin_ ) :Shortint` | Vertex → corner number; `-1` = not contained. |
| `BindPoins` | Point the anchors of the four vertices at this cell. |
| `BondOf( K_, Cell_, CornK_ ) :Byte` | Rotation code of gluing face `K_` to the neighbour's face `CornK_`; `0` = cannot be glued. |
| `CanWeld( K_, Cell_, CornK_ ) :Boolean` | Whether the two faces can be glued — the vertices correspond as mirror images. |
| `Weld( K_, Cell_, CornK_ )` | Glue the two faces, symmetrically on both sides; the rotation code is derived, not supplied. |
| `Destroy` | Un-hooks any vertex anchor pointing at this cell before freeing. |

#### `TTetraCellSet<TPos_>` — the mesh

| Member | Description |
|---|---|
| `Create` / `Destroy` | Owns the point set; destruction frees the cells first (cell destruction touches vertex anchors). |
| `PoinSet :TTetraPoinSet<TPos_>` | The owned point set. |
| `NewPoinSet` *(protected)* | Factory for the point set — `override` substitutes a derived set type. |
| `PoinCode( Poin_ )` / `CodePoin( Code_ )` *(protected)* | Encode / decode points not belonging to the set as negative indices (default `-1` = `nil`; derived sets may assign codes to intrinsic points — LUX.Delaunay maps its point at infinity to `-2`). |
| `LoadCell` *(protected)* | Factory for loaded cells — `override` substitutes a derived cell type. |
| `CheckCells :Integer` | Number of broken face slots (§2.4). |
| `SaveToFile( FileName_ )` | Save to a `*.lxtc` file (§3.5). |
| `LoadFromFile( FileName_ )` | Restore from a `*.lxtc` file — points and cells are replaced entirely, connectivity and anchors included. |

### 3.4 The typing layers

`LUX.Data.Model.TetraFlip` re-parameterises the four classes so that every cross-reference has the *user's* type: `TTetraPoin<TPos_;TCell_>` retypes `Cell`, `TTetraPoinSet<TPos_;TPoin_>` retypes `Childrs` and the enumerator, `TTetraCell<TPos_;TPoin_,TCell_>` retypes `Poin` / `Cell`, and `TTetraCellSet<TPos_;TCell_,TPoinSet_>` retypes the enumerator and `PoinSet`. The user simply passes the derived classes themselves as type arguments — self- and mutual recursion are allowed. `LUX.Data.Model.TetraFlip.D3` additionally fixes `TPos_ = TSingle3D` (`TTetraPoin3D<TCell_>` and so on).

Two implementation constraints are documented in the unit and must be preserved: the type arguments are not cast-compatible with the base types (class constraint), so all conversions go through a two-step cast via `TObject`; and the typed accessors are non-virtual (`reintroduce` only), because a virtual method returning a type argument inside the mutual-recursion loop does not compile.

### 3.5 File format `*.lxtc`

Radiance-HDR-style layout, written with the container helpers of `LUX.Data` (`WriteHead` / `ReadHead`). The file begins as UTF-8 text: the first line is the magic `LUXOPHIA TetFlip 1.0`, followed by `name=value` option lines — `PoinsN`, `CellsN`, `PosSize` (validated against `SizeOf(TPos_)`); unknown lines are skipped. A single blank line ends the header, and everything after it is binary: the point coordinates in `Order` (`PoinsN × PosSize` bytes), then per cell its 4 vertex indices and 4 neighbour-cell indices (`Int32`; negative = a point/cell outside the set, via `PoinCode` / `CodePoin`) followed by the three bytes `_Corn` / `_Bond` / `_Flag`. Anchors are derived data — they are not stored and are rebuilt on load.

## 4. Usage

Derive the four classes through the 3-D typing layer, then build, weld and save:

```pascal
uses LUX, LUX.D3, LUX.Data.Model.TetraFlip.D3;

type
     TMyPoin    = class;
     TMyPoinSet = class;
     TMyCell    = class;
     TMyCellSet = class;

     TMyPoin    = class( TTetraPoin3D<TMyCell> );
     TMyPoinSet = class( TTetraPoinSet3D<TMyPoin> );
     TMyCell    = class( TTetraCell3D<TMyPoin,TMyCell> );
     TMyCellSet = class( TTetraCellSet3D<TMyCell,TMyPoinSet> );
```

```pascal
var
   M :TMyCellSet;
   P0, P1, P2, P3, P4 :TMyPoin;
   T1, T2 :TMyCell;
begin
     M := TMyCellSet.Create;

     P0 := TMyPoin.Create( TSingle3D.Create( 0, 0, 0 ), M.PoinSet );
     P1 := TMyPoin.Create( TSingle3D.Create( 1, 0, 0 ), M.PoinSet );
     P2 := TMyPoin.Create( TSingle3D.Create( 0, 1, 0 ), M.PoinSet );
     P3 := TMyPoin.Create( TSingle3D.Create( 0, 0, 1 ), M.PoinSet );
     P4 := TMyPoin.Create( TSingle3D.Create( 1, 1, 1 ), M.PoinSet );

     T1 := TMyCell.Create( M );
     T2 := TMyCell.Create( M );

     T1.Poin[0] := P0;  T1.Poin[1] := P1;  T1.Poin[2] := P2;  T1.Poin[3] := P3;
     T2.Poin[0] := P4;  T2.Poin[1] := P1;  T2.Poin[2] := P3;  T2.Poin[3] := P2;

     T1.BindPoins;
     T2.BindPoins;

     if T1.CanWeld( 0, T2, 0 ) then T1.Weld( 0, T2, 0 );  // glue the shared face ( P1, P2, P3 )

     // the frame vertices of T1's face 0 seen from T2:
     // T2.Poin[ T1.Join[ 0, I ] ] = T1.Poin[ VertTable[ 0 ]._[ I ] ]  for I = 1..3

     for T1 in M         do { each cell   };  // typed enumeration
     for P0 in M.PoinSet do { each vertex };

     M.SaveToFile( 'mesh.lxtc' );

     M.Free;  // cells are freed before the point set — handled by the destructor
end;
```

The faces on the boundary of this two-cell patch keep their placeholder self-links, so `CheckCells` counts them until the mesh is closed. For a complete client of this layer, see `LUX.Delaunay.D3`, which derives exactly as above, closes the mesh with a point at infinity and adds the Delaunay predicates on top.

## 5. References

1. Rossignac, J., Safonova, A., Szymczak, A., [*3D Compression Made Simple: Edgebreaker on a Corner-Table*](https://doi.org/10.1109/SMA.2001.923399), Proc. Shape Modeling International, 278–283, 2001.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
