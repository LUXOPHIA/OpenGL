# LUX.Data.Image

Ultra-high-resolution image library for Delphi / FireMonkey.

日本語版： [ja/README.md](ja/README.md)

---

## Overview

FireMonkey's `TBitmap` shares its storage with the GPU and therefore inherits the GPU's
texture size limit, which in practice caps it at about 8,192 × 8,192 pixels.

`TLuxImage` keeps every pixel in CPU memory, so the usable size is bounded by RAM rather
than by the GPU. Images of 100,000 × 100,000 pixels and beyond are supported, and the
accompanying viewer displays them in real time at a cost that depends on the size of the
window rather than the size of the image.

## Features

- **No GPU size limit.** Pixels live in CPU memory, in 256 × 256 tiles.
- **Four pixel formats**, each mapping one-to-one onto a native Skia colour type:
  8-bit and 16-bit unsigned integer, 16-bit and 32-bit floating point, all RGBA.
- **Built-in mip pyramid**, so a zoomed-out view costs the same as a zoomed-in one.
- **Real-time viewer** with smooth wheel zoom and drag scrolling, GPU tone mapping and
  gamma correction.
- **Asynchronous file I/O** with progress reporting and completion events.
- Depends only on the RTL, FireMonkey and Skia, all of which ship with RAD Studio.

## Requirements

- RAD Studio 12 or later (developed and tested on RAD Studio 13 / Delphi 37.0)
- Windows 64-bit
- Skia (bundled with RAD Studio); `sk4d.dll` must be deployed alongside the executable

---

## Units

| Unit | Contents |
|---|---|
| `LUX.Data.Image.pas` | `TLuxImage` and the four concrete image classes |
| `LUX.Data.Image.Files.pas` | file reading and writing |
| `LUX.Data.Image.Viewer.pas` | `TLuxImageViewer`, a `TFrame` that displays a `TLuxImage` |

The following units of the LUX standard library are also required:

| Unit | Contents |
|---|---|
| `LUX.pas` | base declarations |
| `LUX.Color.pas` | `TByteRGBA`, `TWordRGBA`, `TSingleRGBA`, … |
| `LUX.Color.Half.pas` | `THalfRGB`, `THalfRGBA` |
| `LUX.D1.Half.pas` | `THalf`, the half-precision scalar |
| `LUX.D1.Half.DIff.pas` | `TdHalf`, half-precision automatic differentiation |

`LUX.Data.Image.pas` uses neither FireMonkey nor Skia; those dependencies are confined to
the file and viewer units.

---

## Getting started

### Project setup

Enable the Skia canvas in the project source file, and include `FMX.Skia.Canvas.Vulkan` so
that the Vulkan backend registers itself:

```pascal
uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  FMX.Skia.Canvas.Vulkan,
  ...

begin
  GlobalUseSkia                    := True;
  GlobalUseSkiaRasterWhenAvailable := False;

  Application.Initialize;
  ...
```

With this in place the viewer draws straight into the window surface: there is no
intermediate raster surface and no per-frame texture upload of the whole window. Without it
the viewer still works — it renders through an intermediate raster bitmap instead — but that
costs a full-window blit every frame.

### Loading and displaying an image

```pascal
Image  := TLuxImageUInt08.Create;

Viewer        := TLuxImageViewer.Create( Self );
Viewer.Parent := Self;
Viewer.Align  := TAlignLayout.Client;
Viewer.Image  := Image;

Image.OnLoaded.Add( ImageLoaded );

Image.LoadFromFileAsync( 'huge.jpg' );
```

```pascal
procedure TForm1.ImageLoaded( Sender_:TObject );
begin
     Viewer.FitToWindow;
end;
```

---

## Pixel formats

| Class | Pixel record | Bytes / pixel | Skia colour type | Default display gamma |
|---|---|---|---|---|
| `TLuxImageUInt08` | `TByteRGBA` | 4 | `BGRA8888` | 1.0 |
| `TLuxImageUInt16` | `TWordRGBA` | 8 | `RGBA16161616` | 1.0 |
| `TLuxImageSFlo16` | `THalfRGBA` | 8 | `RGBAF16` | 2.2 |
| `TLuxImageSFlo32` | `TSingleRGBA` | 16 | `RGBAF32` | 2.2 |

Because each format matches a native Skia colour type, the viewer hands tiles to the GPU
without any pixel-format conversion.

Alpha is stored straight, that is, not premultiplied.

Integer formats are taken to hold display-encoded values — a JPEG is already sRGB — so their
default display gamma is 1.0. Floating-point formats are taken to hold linear values, so
their default gamma is 2.2 and tone mapping is enabled by default.

---

## API reference

### Storage model

Pixels are held in tiles of `LUXIMAGE_TILE` (256) square, each tile a separate heap block.
This avoids a single huge contiguous allocation, keeps bilinear sampling within one tile in
the common case, and leaves untouched regions unallocated.

Every image owns a pyramid of half-size levels. Level 0 is the original; each subsequent
level halves both dimensions, down to 1 × 1. Levels are built on demand by `NeedLevel`, and
writing pixels invalidates every level above 0.

### TLuxImage

```pascal
///// size
procedure SetSize( const W_,H_:Integer );
procedure Clear;
property  Width  :Integer;
property  Height :Integer;

///// format
class function PixelKind :TLuxPixel;    // bpUInt08 / bpUInt16 / bpSFlo16 / bpSFlo32
class function PixelSize :Integer;      // bytes per pixel
class function IsFloat :Boolean;
class function DefaultGamma :Single;

///// pixel access, format independent
property Colors[ const X_,Y_:Integer ] :TSingleRGBA; default;
procedure GetRow( const L_,X_,Y_,N_:Integer; const Dst_:PSingleRGBA );
procedure SetRow( const L_,X_,Y_,N_:Integer; const Src_:PSingleRGBA );

///// pixel access, typed  ( declared on each concrete class )
property Pixels[ const X_,Y_:Integer ] :TByteRGBA;    // TLuxImageUInt08
property Pixels[ const X_,Y_:Integer ] :TWordRGBA;    // TLuxImageUInt16
property Pixels[ const X_,Y_:Integer ] :THalfRGBA;    // TLuxImageSFlo16
property Pixels[ const X_,Y_:Integer ] :TSingleRGBA;  // TLuxImageSFlo32

///// raw access, crossing tile boundaries transparently
procedure GetRaws( const L_,X_,Y_,N_:Integer; const Dst_:Pointer );
procedure SetRaws( const L_,X_,Y_,N_:Integer; const Src_:Pointer );

///// levels and tiles
property LevelsN :Integer;
function LevelWidth ( const L_:Integer ) :Integer;
function LevelHeight( const L_:Integer ) :Integer;
function LevelTilesX( const L_:Integer ) :Integer;
function LevelTilesY( const L_:Integer ) :Integer;
function TileWidth  ( const L_,TX_:Integer ) :Integer;
function TileHeight ( const L_,TY_:Integer ) :Integer;
function TileData( const L_,TX_,TY_:Integer ) :Pointer;  // allocates on demand
function TilePeek( const L_,TX_,TY_:Integer ) :Pointer;  // nil when not allocated
procedure NeedLevel( const L_:Integer );                 // build levels up to L_

///// files, synchronous
procedure LoadFromFile( const FileName_:String );
procedure SaveToFile( const FileName_:String; const Quality_:Integer = 90 );

///// files, on a worker thread
procedure LoadFromFileAsync( const FileName_:String );
procedure SaveToFileAsync( const FileName_:String; const Quality_:Integer = 90 );
procedure WaitFor;
property  Busy     :Boolean;
property  Progress :Single;      // 0 … 1

///// notification
procedure Changed;
property  Version    :Cardinal;  // incremented on every change
property  OnChange   :TDelegates;
property  OnProgress :TDelegates;
property  OnLoaded   :TDelegates;
property  OnSaved    :TDelegates;
```

`SetRow` and `SetRaws` mark the mip levels stale but do not raise `OnChange`; call `Changed`
once after a batch of edits. The single-pixel property setters call `Changed` themselves.

Tiles carry no padding in storage. The viewer gathers the one-pixel apron it needs when it
builds its render cache.

### Asynchronous file I/O

`LoadFromFileAsync` and `SaveToFileAsync` run the ordinary loader on a `TTask` and deliver
every notification to the main thread through `TThread.Queue`, so handlers may touch the UI
directly.

`Busy` is raised before the worker starts and lowered immediately before `OnLoaded` or
`OnSaved` is raised. The viewer draws nothing while `Busy` is set, which is what allows the
worker to write pixels without any locking. The destructor waits for the worker and drains
any pending notification, so an image may be freed while a load is in flight.

Loading also builds the whole mip pyramid on the worker thread, using all available cores.
Were it left to the first repaint, that work would block the UI instead.

`Progress` runs from 0 to 1 over the entire operation, including the pyramid. It is reported
per row, so PNG advances smoothly; JPEG cannot, because Skia's decode is a single call with
no callback, and progress therefore stands still until the decode completes.

### File formats

| Format | Read | Write | Notes |
|---|---|---|---|
| PNG | ✔ | ✔ | Implemented directly on `System.ZLib`. Reads every variant the format defines; writes RGBA, 8 bit for `TLuxImageUInt08` and 16 bit otherwise. |
| JPEG | ✔ | ✔ | Uses the Skia codec. |

The PNG reader covers the whole format:

| | supported |
|---|---|
| Bit depths | 1, 2, 4, 8, 16 |
| Colour types | 0 grayscale, 2 truecolour, 3 palette, 4 grayscale + alpha, 6 truecolour + alpha |
| Transparency | `tRNS` in all three of its forms — palette alpha, grayscale colour key, RGB colour key |
| Interlacing | none, and Adam7 |

Non-interlaced images are decoded a row at a time and written straight into the tiles, so no
whole-image temporary is ever allocated regardless of the size of the file. Adam7 images are
decoded pass by pass and the pixels scattered to their final positions, which is slower but
equally free of a full-size buffer.

JPEG passes through Skia, which requires the whole image in one contiguous buffer, so
reading or writing a JPEG temporarily needs `width × height × 4` bytes in addition to the
image itself. The JPEG standard also caps dimensions at 65,535.

Saving a floating-point image to PNG clamps to 0…1 and quantises to 16 bit; saving to JPEG
clamps to 0…1 and quantises to 8 bit. Tone mapping is not applied when saving, as it is a
display setting.

`LUX.Data.Image.Files.pas` also exports:

```pascal
function LuxSkColorType( const Kind_:TLuxPixel ) :TSkColorType;
function LuxImageSize( const FileName_:String; out Width_,Height_:Integer ) :Boolean;
```

### TLuxImageViewer

```pascal
property Image      :TLuxImage;
property Gamma      :Single;       // out = in^(1/Gamma)
property ToneMap    :Boolean;      // Reinhard 2002
property White      :Single;       // tone mapping white point, default 1
property Background :TAlphaColor;
property Scale      :Single;       // screen pixels per image pixel
property Origin     :TPointF;      // image coordinate at the top left of the view
property MinScale   :Single;
property MaxScale   :Single;

procedure FitToWindow;
procedure ZoomAt( const P_:TPointF; const Factor_:Single );
procedure ZoomWheel( const WheelDelta_:Integer );
function  ViewToImage( const P_:TPointF ) :TPointF;
function  ImageToView( const P_:TPointF ) :TPointF;
procedure Redraw;
```

Assigning `Image` resets `Gamma` and `ToneMap` to that class's defaults and fits the image to
the window.

Setting `Scale` re-centres the image: the centre of the image is placed at the centre of the
view. `ZoomAt` instead holds a given point of the view still, which is what the wheel uses to
keep the pixel under the cursor in place.

Rolling the wheel towards you zooms in — four notches double the scale. Dragging with the
left button scrolls.

### How a frame is drawn

1. The level is chosen so that within it the image is always magnified by a factor in
   [1, 2). Minification never occurs inside a level, so minification aliasing cannot arise.
2. The visible tiles of that level are enumerated. For a 1920 × 1080 window this is at most
   about 9 × 6 = 54 tiles, whatever the size of the image.
3. Each tile becomes an `ISkImage` and is cached. The cached image carries a one-pixel apron
   gathered from the neighbouring tiles, so filtering at a tile boundary reads real
   neighbouring pixels instead of clamping, and no seams appear.
4. The tiles are drawn with `DrawImageRect`. At `Scale` ≥ 1 sampling is nearest neighbour, so
   magnifying past 1:1 shows pixels as squares; below 1:1 it is linear. Tone mapping and gamma
   are applied by an SkSL runtime colour filter on the GPU, so changing `Gamma`, `ToneMap` or
   `White` costs nothing and does not invalidate the cache.

Nothing is resampled on the CPU. The only per-frame CPU work is gathering the aprons of newly
exposed tiles, and only on a cache miss.

---

## Memory

| Size | UInt08 | UInt16 / SFlo16 | SFlo32 |
|---|---|---|---|
| 16,384 × 16,384 | 1 GB | 2 GB | 4 GB |
| 32,768 × 32,768 | 4 GB | 8 GB | 16 GB |
| 100,000 × 100,000 | 40 GB | 80 GB | 160 GB |

Add roughly 33 % once the mip pyramid has been built.

---

## Limitations

- There is no paging to disk. An image that does not fit in RAM cannot be opened.
- TIFF, OpenEXR and Radiance HDR are not implemented.
- Skia's codec converts reliably only to 8-bit, so a JPEG is always decoded as BGRA8888 and
  converted afterwards when the target class is wider. As JPEG is an 8-bit format, nothing is
  lost.

---

## Demo

`LuxImage.dproj` in the repository root loads `_DATA\Image 16384x16384.jpg`, displays it and
can save it again.

```
LuxImage.exe [ image file ] [ pixel format index 0..3 ]
```
