# LUX.Data.Model
[English](README.md) | [日本語](ja/README.md)

The mesh-model layer of LUX. Three small units define the shared vocabulary — points (`Poins`), faces (`Faces`) and cells (`Cells`) as generic list-based containers — and two subfolders build corner-table meshes on top of it.

* [**TriFlip**](TriFlip/README.md) ：2-D triangle meshes on a corner table — welding, vertex rings, edge flips, `*.lxtf`.
* [**TetraFlip**](TetraFlip/README.md) ：3-D tetrahedral meshes on a corner table — face gluing by rotation codes, `*.lxtc`.

## 1. Overview

A *model* is a set of elements — faces in 2-D, cells in 3-D — over a set of points. The three units fix the generic signatures of that vocabulary:

- **`LUX.Data.Model.Poins`** — `TPoin<TPos_;TPoinSet_>` holds the coordinates `Pos` of type `TPos_`; `TPoinSet<TPos_;TPoin_>` is its container and defines the streaming pattern: `SaveToStream` writes the raw coordinates of all points, `LoadFromStream` replaces the points by ones generated from a coordinate sequence. Both defer knowledge of the concrete point type to derived sets — `SaveToStream` and the point factory `LoadPoin` are abstract.
- **`LUX.Data.Model.Faces`** — `TFace<TPos_;TFaceSet_>` / `TFaceSet<TPos_;TFace_>`, the empty base pair for 2-D elements.
- **`LUX.Data.Model.Cells`** — `TCell<TPos_;TCellSet_>` / `TCellSet<TPos_;TCell_>`, the same for 3-D elements.

All six classes are thin extensions of the doubly-linked lists of `LUX.Data.List`: every element knows its `Parent` set and its sequence number `Order`, and every set is an iterable container (`Childrs[]` / `ChildrsN` / `Count`). `Order` is what the file formats of the subfolders use as the persistent element index.

Coordinates never enter any algorithm in this folder or its subfolders — the whole layer is purely combinatorial, and `TPos_` is only stored and streamed. Geometric predicates belong to the client, e.g. [LUX.Delaunay](https://github.com/LUXOPHIA/LUX.Delaunay).

## 2. Architecture

### 2.1 Class diagram

```
・TListChildr<TParent_>      ･･･ (LUX.Data.List)
  ┣・TPoin<TPos_,TPoinSet_> ･･･ Pos :TPos_
  ┣・TFace<TPos_,TFaceSet_> ･･･ 2-D element base
  ┗・TCell<TPos_,TCellSet_> ･･･ 3-D element base

・TListParent<TChildr_>      ･･･ (LUX.Data.List)
  ┣・TPoinSet<TPos_,TPoin_> ･･･ LoadPoin, SaveToStream, LoadFromStream
  ┣・TFaceSet<TPos_,TFace_> ･･･ 2-D container base
  ┗・TCellSet<TPos_,TCell_> ･･･ 3-D container base
```

### 2.2 File layout

```
・Model/
  ┣・LUX.Data.Model.Poins.pas ･･･ unit LUX.Data.Model.Poins
  ┣・LUX.Data.Model.Faces.pas ･･･ unit LUX.Data.Model.Faces
  ┣・LUX.Data.Model.Cells.pas ･･･ unit LUX.Data.Model.Cells
  ┣・TriFlip/                 ･･･ TriFlip.* — 2-D triangle meshes
  ┣・TetraFlip/               ･･･ TetraFlip.* — 3-D tetrahedral meshes
  ┣・README.md                ･･･ this document
  ┗・ja/README.md             ･･･ Japanese translation
```

## 3. Usage

These units are not used directly; a concrete mesh derives from them, implementing the point factory and the coordinate streaming. `LUX.Data.Model.TriFlip.core` is the in-repository example of the pattern:

```pascal
uses System.Classes, LUX.D2, LUX.Data.Model.Poins;

type
     TMyPoin    = class;
     TMyPoinSet = class;

     TMyPoin = class( TPoin<TSingle2D,TMyPoinSet> );

     TMyPoinSet = class( TPoinSet<TSingle2D,TMyPoin> )
     protected
       function LoadPoin( const Pos_:TSingle2D ) :TMyPoin; override;
     public
       procedure SaveToStream( const Stream_:TStream ); override;
     end;
```

For everything beyond that — connectivity, welding, traversal and file I/O — see the subfolder documents [TriFlip](TriFlip/README.md) and [TetraFlip](TetraFlip/README.md).

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
