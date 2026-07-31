# LUX.Data.Model.TriFlip
[English](README.md) | [日本語](ja/README.md)

A corner-table triangle mesh for Delphi. Faces are glued edge to edge by `Weld`, traversed by corner iterators, restructured by the diagonal exchange `FlipEdge`, and persisted with their complete connectivity in `*.lxtf` files. The layer is purely combinatorial — coordinates are a type parameter and enter no algorithm — and it is the mesh foundation of [LUX.Delaunay](https://github.com/LUXOPHIA/LUX.Delaunay)`.D2`.

## 1. Overview

The folder holds one structure in three layers:

| Unit | Layer |
|---|---|
| `LUX.Data.Model.TriFlip.core` | Implementation — all fields and algorithms, generic in the coordinate type `TPos_`. |
| `LUX.Data.Model.TriFlip` | Typing — retypes the mutual references to the user's derived classes. |
| `LUX.Data.Model.TriFlip.D2` | 2-D specialization — `TPos_` fixed to `TSingle2D`. |

A mesh is a face set `TTriFaceSet` (which owns a point set `TTriPoinSet`) of triangles `TTriFace`. Every face stores its three vertices `Poin[1..3]` (counter-clockwise by convention of the clients), its three neighbours `Face[1..3]`, and one packed byte `_Data` carrying the three 2-bit neighbour corner numbers `Corn[1..3]` together with the two flag bits `Flip` / `Flag`. Every vertex stores its coordinates `Pos` and an *anchor* — one face `Face` containing it and its corner number `Corn` in it — so a walk around the vertex starts in O(1). The base classes come from `LUX.Data.Model.Poins` / `.Faces` (see the [parent folder](../README.md)); each element therefore knows its `Parent` set and its persistent index `Order`.

## 2. Technical Background

### 2.1 The corner table

A *corner* is a pair $(f, k)$ of a face and a vertex slot $k \in \{1,2,3\}$. Rotation inside a face is the cyclic permutation

```math
\mathrm{next}(k) = k \bmod 3 + 1 ,
\qquad
\mathrm{prev}(k) = \mathrm{next}(\mathrm{next}(k)) ,
\qquad \text{(2.1)}
```

tabulated by the constants `VertTableInc[k] = ( L:next(k); R:prev(k) )` and `VertTableDec[k] = ( L:prev(k); R:next(k) )`. Crossing the edge opposite a corner is

```math
\mathrm{Flip}(f,k) = \bigl(\, \mathrm{Face}_f[k],\; \mathrm{Corn}_f[k] \,\bigr) ,
\qquad \text{(2.2)}
```

which `Weld` maintains as an involution: $\mathrm{Flip}^2 = \mathrm{id}$ on every welded edge. The record `TCornIter<_TPos_>` packages a corner with these moves, both as value-returning properties (`Flip`, `FaceNext`, `FacePrev`, …) and as in-place steps (`GoFlip`, `GoFaceNext`, …).

### 2.2 Vertex rings

Composing the two elementary moves walks around a vertex:

```math
\mathrm{VertNext} = \mathrm{FacePrev} \circ \mathrm{Flip} ,
\qquad
\mathrm{VertPrev} = \mathrm{Flip} \circ \mathrm{FaceNext} .
\qquad \text{(2.3)}
```

The ring of a vertex $v$ is represented by the corners that *follow* $v$ in each incident face: starting from `FaceNext` of the anchor corner of $v$, the orbit of $\mathrm{VertNext}$ visits exactly one corner per incident face, and `FacesN` is the orbit length — the number of faces around $v$. `BasteCorn` tacks a face into that ring provisionally and moves the anchor to it; `JoinOK` tests whether two corners meet along a common edge (`C1.FaceNext.Vert = C2.Vert`), and `JoinEdge` sews the fans tacked around the anchor vertex into rings by repeatedly joining such matching edges.

### 2.3 Welding

The edge opposite corner $K$ of face $f$ runs from $P_f[\mathrm{next}(K)]$ to $P_f[\mathrm{prev}(K)]$. Two faces can be glued along it iff the shared edge appears in *mirror* orientation from the two sides (`CanWeld`):

```math
P_f[\mathrm{next}(K)] = P_g[\mathrm{prev}(K')]
\;\;\wedge\;\;
P_f[\mathrm{prev}(K)] = P_g[\mathrm{next}(K')] .
\qquad \text{(2.4)}
```

`Weld` then writes the two symmetric links `Face` / `Corn` on both sides and changes nothing else. A freshly created face is born with placeholder self-links (`Face[K] = Self`), so the pointers are never `nil`; the integrity checks of §2.5 report such a face until it is actually welded.

### 2.4 The edge flip

`FlipEdge( Corn_ )` exchanges the diagonal of the quadrilateral formed by a face and the neighbour across the edge opposite `Corn_`:

```math
F = (P_a, P_b, P_d),\;\; G = (P_e, P_d, P_b)
\;\longmapsto\;
F = (P_a, P_b, P_e),\;\; G = (P_e, P_d, P_a) ,
\qquad \text{(2.5)}
```

the shared edge $(P_b, P_d)$ becoming $(P_a, P_e)$. The operation is constant-time — two vertex slots, four welds and the two possibly displaced anchors of $P_b$, $P_d$ are rewritten — and leaves the vertex count, face count and topology unchanged. Both faces must be welded on all their edges. The flip is the elementary move of Delaunay-type restructuring [2], which is where the folder's name comes from.

### 2.5 Integrity checks

`CheckEdges` returns the number of corners at which (2.2) fails to be a symmetric involution — a `nil` or one-sided neighbour, or a corner number of `0`. `CheckFaceLings` returns the number of vertices whose ring (2.3) does not close after `FacesN` steps. Both are `0` on a consistent closed mesh.

## 3. Architecture

### 3.1 Class diagram

```
Inheritance ( core layer → typing layer → 2-D specialization )

・TPoin<TPos_,TPoinSet_>                     ･･･ (LUX.Data.Model.Poins)
  ┗・TTriPoin<TPos_>                        ･･･ Face / Corn, FacesN, Join*
     ┗・TTriPoin<TPos_,TFace_>              ･･･ Face retyped to TFace_
        ┗・TTriPoin2D<TFace_>               ･･･ TPos_ = TSingle2D

・TPoinSet<TPos_,TPoin_>                     ･･･ (LUX.Data.Model.Poins)
  ┗・TTriPoinSet<TPos_>                     ･･･ LoadPoin, SaveToStream
     ┗・TTriPoinSet<TPos_,TPoin_>           ･･･ Childrs / enumeration retyped
        ┗・TTriPoinSet2D<TPoin_>            ･･･ TPos_ = TSingle2D

・TFace<TPos_,TFaceSet_>                     ･･･ (LUX.Data.Model.Faces)
  ┗・TTriFace<TPos_>                        ･･･ Poin/Face/Corn, Weld, FlipEdge
     ┗・TTriFace<TPos_,TPoin_,TFace_>       ･･･ Poin / Face retyped
        ┗・TTriFace2D<TPoin_,TFace_>        ･･･ TPos_ = TSingle2D

・TFaceSet<TPos_,TFace_>                     ･･･ (LUX.Data.Model.Faces)
  ┗・TTriFaceSet<TPos_>                     ･･･ PoinSet, checks, file I-O
     ┗・TTriFaceSet<TPos_,TFace_,TPoinSet_> ･･･ PoinSet / enum. retyped
        ┗・TTriFaceSet2D<TFace_,TPoinSet_>  ･･･ TPos_ = TSingle2D

Records and constants ( core layer )

・TVertLR                                    ･･･ row of corner cycling tables
・TCornIter<_TPos_>                          ･･･ corner iterator: Flip, *Next …
・VertTableInc / VertTableDec                ･･･ cyclic next/prev, corners 1..3
```

### 3.2 File layout

```
・TriFlip/
  ┣・LUX.Data.Model.TriFlip.core.pas ･･･ unit LUX.Data.Model.TriFlip.core
  ┣・LUX.Data.Model.TriFlip.pas      ･･･ unit LUX.Data.Model.TriFlip
  ┣・LUX.Data.Model.TriFlip.D2.pas   ･･･ unit LUX.Data.Model.TriFlip.D2
  ┣・README.md                       ･･･ this document
  ┗・ja/README.md                    ･･･ Japanese translation
```

### 3.3 Class reference — `LUX.Data.Model.TriFlip.core`

#### `TCornIter<_TPos_>` — corner iterator

| Member | Description |
|---|---|
| `Create( Face_, Corn_ )` | The corner `Corn_` of `Face_`. |
| `Face` / `Corn` | Current position. |
| `Vert :TTriPoin<_TPos_>` | The vertex at this corner. |
| `Flip` | The corner opposite across the edge (2.2); writable — assigning welds one direction. |
| `FaceNext` / `FacePrev` | Rotation inside the face (2.1). |
| `VertNext` / `VertPrev` | Rotation around the vertex (2.3); writable forms re-link the ring. |
| `GoFlip` / `GoFaceNext` / `GoFacePrev` / `GoVertNext` / `GoVertPrev` | The same moves in place. |
| `=` / `<>` | Equality of position (`Face` and `Corn`). |

#### `TTriPoin<TPos_>` — vertex

| Member | Description |
|---|---|
| `Create( Pos_ )` / `Create( Pos_, Parent_ )` | A vertex at `Pos_`, optionally added to a point set. *(inherited)* |
| `Pos :TPos_` | Coordinates. *(inherited)* |
| `Face :TTriFace<TPos_>` / `Corn :Byte` | Anchor: one face containing this vertex, and its corner number in it. |
| `FacesN :Integer` | Number of faces around the vertex — the length of the ring (2.3); `0` when unanchored. |
| `JoinOK( C1_,C2_ ) :Boolean` *(class)* | Whether the two corners meet along a common edge and can be joined there. |
| `JoinEdge` | Sew the fans tacked around this vertex (§2.2) into rings by joining matching edges. |

#### `TTriPoinSet<TPos_>` — point set

| Member | Description |
|---|---|
| `Childrs[I]` / `ChildrsN` / `Count` | The vertices, iterable and indexable. *(inherited)* |
| `LoadPoin( Pos_ )` *(protected)* | Factory for loaded points — `override` substitutes a derived point type. |
| `SaveToStream( Stream_ )` | Write the raw coordinates of all points, in `Order`. |
| `LoadFromStream( Stream_, PoinsN_ )` | Replace the points by ones generated from a coordinate sequence. *(inherited)* |

#### `TTriFace<TPos_>` — triangle

| Member | Description |
|---|---|
| `Poin[1..3] :TTriPoin<TPos_>` | Vertices. Assigning does not touch anchors — call `BindPoins`. |
| `Face[1..3]` / `Corn[1..3]` | Neighbour across the edge opposite corner `K`, and the shared edge's corner number in it. New faces carry placeholder self-links. |
| `Flip` / `Flag :Boolean` | Two per-face flag bits, packed into the same byte as `Corn[]` (defaults `True` / `False`); free for client algorithms and round-tripped by the file format. |
| `BasteCorn( Corn_ )` | Tack corner `Corn_` into the ring of its vertex and move the vertex's anchor here. |
| `CornOf( Poin_ ) :Byte` | Vertex → corner number; `0` = not contained. |
| `BindPoins` | Point the anchors of the three vertices at this face. |
| `CanWeld( K_, Face_, CornK_ ) :Boolean` | Whether edge `K_` can be glued to the neighbour's edge `CornK_` — the mirror condition (2.4). |
| `Weld( K_, Face_, CornK_ )` | Glue the two edges, symmetrically on both sides. |
| `FlipEdge( Corn_ )` | Diagonal exchange (2.5). Both faces must be welded on all edges. |
| `Destroy` | Un-hooks any vertex anchor pointing at this face before freeing. |

#### `TTriFaceSet<TPos_>` — the mesh

| Member | Description |
|---|---|
| `Create` / `Destroy` | Owns the point set; destruction frees the faces first (face destruction touches vertex anchors). |
| `PoinSet :TTriPoinSet<TPos_>` | The owned point set. |
| `NewPoinSet` *(protected)* | Factory for the point set — `override` substitutes a derived set type. |
| `PoinCode( Poin_ )` / `CodePoin( Code_ )` *(protected)* | Encode / decode points not belonging to the set as negative indices (default `-1` = `nil`; derived sets may assign codes to intrinsic points — LUX.Delaunay maps its point at infinity to `-2`). |
| `LoadFace` *(protected)* | Factory for loaded faces — `override` substitutes a derived face type. |
| `CheckEdges :Integer` | Number of adjacency breaks (§2.5). |
| `CheckFaceLings :Integer` | Number of vertices whose ring does not close (§2.5). |
| `SaveToFile( FileName_ )` | Save to a `*.lxtf` file (§3.5). |
| `LoadFromFile( FileName_ )` | Restore from a `*.lxtf` file — points and faces are replaced entirely, connectivity and anchors included. |

### 3.4 The typing layers

`LUX.Data.Model.TriFlip` re-parameterises the four classes so that every cross-reference has the *user's* type: `TTriPoin<TPos_;TFace_>` retypes `Face`, `TTriPoinSet<TPos_;TPoin_>` retypes `Childrs` and the enumerator, `TTriFace<TPos_;TPoin_,TFace_>` retypes `Poin` / `Face`, and `TTriFaceSet<TPos_;TFace_,TPoinSet_>` retypes the enumerator and `PoinSet`. The user simply passes the derived classes themselves as type arguments — self- and mutual recursion are allowed. `LUX.Data.Model.TriFlip.D2` additionally fixes `TPos_ = TSingle2D` (`TTriPoin2D<TFace_>` and so on).

Two implementation constraints are documented in the unit and must be preserved: the type arguments are not cast-compatible with the base types (class constraint), so all conversions go through a two-step cast via `TObject`; and the typed accessors are non-virtual (`reintroduce` only), because a virtual method returning a type argument inside the mutual-recursion loop does not compile.

### 3.5 File format `*.lxtf`

Radiance-HDR-style layout, written with the container helpers of `LUX.Data` (`WriteHead` / `ReadHead`). The file begins as UTF-8 text: the first line is the magic `LUXOPHIA TriFlip 1.0`, followed by `name=value` option lines — `PoinsN`, `FacesN`, `PosSize` (validated against `SizeOf(TPos_)`); unknown lines are skipped. A single blank line ends the header, and everything after it is binary: the point coordinates in `Order` (`PoinsN × PosSize` bytes), then per face its 3 vertex indices and 3 neighbour-face indices (`Int32`; negative = a point/face outside the set, via `PoinCode` / `CodePoin`) followed by the packed corner/flag byte `_Data`. Anchors are derived data — they are not stored and are rebuilt on load.

## 4. Usage

Derive the four classes through the 2-D typing layer, then build, weld and save:

```pascal
uses LUX, LUX.D2, LUX.Data.Model.TriFlip.D2;

type
     TMyPoin    = class;
     TMyPoinSet = class;
     TMyFace    = class;
     TMyFaceSet = class;

     TMyPoin    = class( TTriPoin2D<TMyFace> );
     TMyPoinSet = class( TTriPoinSet2D<TMyPoin> );
     TMyFace    = class( TTriFace2D<TMyPoin,TMyFace> );
     TMyFaceSet = class( TTriFaceSet2D<TMyFace,TMyPoinSet> );
```

```pascal
var
   M :TMyFaceSet;
   P1, P2, P3, P4 :TMyPoin;
   F, G :TMyFace;
begin
     M := TMyFaceSet.Create;

     P1 := TMyPoin.Create( TSingle2D.Create( 0, 0 ), M.PoinSet );
     P2 := TMyPoin.Create( TSingle2D.Create( 1, 0 ), M.PoinSet );
     P3 := TMyPoin.Create( TSingle2D.Create( 0, 1 ), M.PoinSet );
     P4 := TMyPoin.Create( TSingle2D.Create( 1, 1 ), M.PoinSet );

     F := TMyFace.Create( M );
     G := TMyFace.Create( M );

     F.Poin[1] := P1;  F.Poin[2] := P2;  F.Poin[3] := P3;  F.BindPoins;  // ( P1, P2, P3 ) CCW
     G.Poin[1] := P2;  G.Poin[2] := P4;  G.Poin[3] := P3;  G.BindPoins;  // ( P2, P4, P3 ) CCW

     if F.CanWeld( 1, G, 2 ) then F.Weld( 1, G, 2 );  // glue the shared edge ( P2, P3 )

     for F in M          do { each face   };  // typed enumeration
     for P1 in M.PoinSet do { each vertex };

     M.SaveToFile( 'mesh.lxtf' );

     M.Free;  // faces are freed before the point set — handled by the destructor
end;
```

`FlipEdge` is not shown above because the outer edges of the two faces are unwelded; on a closed mesh — every edge glued, `CheckEdges = 0` — `F.FlipEdge( 1 )` would exchange the diagonal `( P2, P3 )` for `( P1, P4 )` in place. For a complete client of this layer, see `LUX.Delaunay.D2`, which derives exactly as above and adds the Delaunay predicates on top.

## 5. References

1. Rossignac, J., Safonova, A., Szymczak, A., [*3D Compression Made Simple: Edgebreaker on a Corner-Table*](https://doi.org/10.1109/SMA.2001.923399), Proc. Shape Modeling International, 278–283, 2001.
2. Lawson, C. L., [*Transforming triangulations*](https://doi.org/10.1016/0012-365X(72)90093-3), Discrete Mathematics, 3(4), 365–372, 1972.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
