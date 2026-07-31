# LUX.Data
[English](README.md) | [日本語](ja/README.md)

`LUX.Data` is the data-structure branch of the LUX library: generic containers, meshes and images, each living in its own sub-folder with its own README. The unit `LUX.Data` itself contributes the small stream helpers — UTF-8 lines and text headers — that the branch's file formats share.

## 1. Overview

* [**Grid**](Grid/README.md) ：regular 1-D point grids and a triangular 2-D grid
* [**Image**](Image/README.md) ：ultra-high-resolution tiled mip-pyramid images with a real-time viewer
* [**List**](List/README.md) ：intrusive doubly linked list with an incremental index, core + typed layers
* [**Model**](Model/README.md) ：corner-table meshes — TriFlip ( 2-D ) and TetraFlip ( 3-D )
* [**Tree**](Tree/README.md) ：generic tree over the list — TTreeRoot / TTreeKnot / TTreeLeaf

The containers are built in layers: an untyped core does the work, and thin generic layers above it re-type the cross-reference properties onto the client's own classes, so client code never needs a downcast. `List` is the foundation, `Tree` is built on `List`, and `Model` re-uses the same layering idea for meshes.

## 2. Technical Background

`LUX.Data` defines the text-header convention used by the branch's binary file formats ( `*.lxtf`, `*.lxtc` ):

```
magic line  ･･･ identifies the format; UTF-8, LF-terminated
option line ･･･ zero or more free-form lines
blank line  ･･･ terminator — everything after it is binary
```

`WriteLine` / `ReadLine` transfer one UTF-8 line; the terminator is a bare LF, and `ReadLine` silently discards any CR, so files survive CRLF round trips. `WriteHead` writes the magic, the options and the blank line; `ReadHead` verifies the magic — raising `EInOutError` on mismatch — and returns the option lines, leaving the stream positioned at the first binary byte.

## 3. Architecture

```
・Data/
  ┣・LUX.Data.pas ･･･ WriteLine / ReadLine / WriteHead / ReadHead
  ┣・Grid/        ･･･ LUX.Data.Grid.D1  LUX.Data.Grid.Tria.D2
  ┣・Image/       ･･･ LUX.Data.Image ( + .Files  .Viewer )
  ┣・List/        ･･･ LUX.Data.List.core  LUX.Data.List
  ┣・Model/       ･･･ LUX.Data.Model.*  ( TriFlip/  TetraFlip/ )
  ┗・Tree/        ･･･ LUX.Data.Tree
```

`LUX.Data` depends only on `System.Classes` and `System.SysUtils`; the sub-folders state their own dependencies in their own READMEs.

## 4. Usage

```pascal
uses System.Classes, LUX.Data;

var
   S :TMemoryStream;
   O :TArray<String>;
begin
     S := TMemoryStream.Create;
     try
        ///// writing:  header first, then the binary payload
        WriteHead( S, 'MyFormat 1.0', [ 'Count=3' ] );
        // ... write binary data ...

        ///// reading:  verify the magic, collect the options
        S.Position := 0;
        O := ReadHead( S, 'MyFormat 1.0' );  // EInOutError on mismatch
        // O = [ 'Count=3' ] and S.Position is at the binary payload
     finally
        S.Free;
     end;
end;
```

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
