# LUX.Data.Image
[English](README.md) | [日本語](ja/README.md)

An ultra-high-resolution image library for Delphi / FireMonkey. `TLuxImage` keeps every pixel in CPU memory as a tiled mip pyramid, so the usable size is not bounded by the GPU's texture limit — it is unlimited as far as RAM allows — and the accompanying viewer displays an image in real time at a cost that depends on the size of the window rather than the size of the image.

## 1. Overview

FireMonkey's `TBitmap` shares its storage with the GPU and therefore inherits the GPU's texture size limit, which in practice caps it at about 8,192 × 8,192 pixels. `TLuxImage` does not: pixels live in ordinary heap blocks, divided into 256 × 256 tiles, and no part of the image needs to be resident on the GPU at once.

### 1.1 Features

- **No GPU size limit.** Pixels live in CPU memory, in 256 × 256 tiles.
- **Four pixel formats**, each mapping one-to-one onto a native Skia colour type: 8-bit and 16-bit unsigned integer, 16-bit and 32-bit floating point, all RGBA.
- **Built-in mip pyramid**, so a zoomed-out view costs the same as a zoomed-in one.
- **Real-time viewer** with smooth wheel zoom and drag scrolling, GPU tone mapping and gamma correction.
- **Asynchronous file I/O** with progress reporting and completion events.
- Depends only on the RTL, FireMonkey and Skia, all of which ship with RAD Studio.

### 1.2 Requirements

- RAD Studio 12 or later (developed and tested on RAD Studio 13 / Delphi 37.0)
- Windows 64-bit
- Skia (bundled with RAD Studio); `sk4d.dll` must be deployed alongside the executable

## 2. Technical Background

### 2.1 Tiled storage and the mip pyramid

Pixels are held in tiles of `LUXIMAGE_TILE` (256) square, each tile a separate heap block. This avoids a single huge contiguous allocation, keeps bilinear sampling within one tile in the common case, and leaves untouched regions unallocated.

Every image owns a pyramid of half-size levels. Level 0 is the original; each subsequent level halves both dimensions, rounding up, down to 1 × 1:

```math
W_{\ell+1} = \max\!\left( 1, \left\lceil \frac{W_\ell}{2} \right\rceil \right), \qquad H_{\ell+1} = \max\!\left( 1, \left\lceil \frac{H_\ell}{2} \right\rceil \right) \qquad \text{(2.1)}
```

With $T$ = `LUXIMAGE_TILE`, level $\ell$ therefore holds

```math
\mathrm{TilesX}_\ell = \left\lceil \frac{W_\ell}{T} \right\rceil, \qquad \mathrm{TilesY}_\ell = \left\lceil \frac{H_\ell}{T} \right\rceil \qquad \text{(2.2)}
```

tiles, of which the ones on the right and bottom edges are partially filled. Levels are built on demand by `NeedLevel`, and writing pixels invalidates every level above 0.

The pyramid costs a bounded fraction of the base level, because each level holds a quarter of the pixels of the one below it:

```math
\sum_{\ell=1}^{\infty} \frac{1}{4^{\ell}} = \frac{1}{3} \qquad \text{(2.3)}
```

so a fully built pyramid adds roughly 33 % to the memory of level 0.

### 2.2 Level selection

For a display scale $s$ in screen pixels per image pixel, the viewer draws from level

```math
\ell = \min\!\left( \max\!\left( 0, \left\lceil -\log_2 s \right\rceil \right), \; \mathrm{LevelsN} - 1 \right) \qquad \text{(2.4)}
```

whose effective per-pixel scale is

```math
S = s \cdot 2^{\ell} \in [\,1, 2\,) \qquad \text{(2.5)}
```

Because $S \ge 1$ always, minification never occurs inside a level, and minification aliasing cannot arise. The number of visible tiles is then bounded by the window, not by the image:

```math
N_{\text{tiles}} \le \left( \left\lceil \frac{W_{\text{view}}}{S \cdot T} \right\rceil + 1 \right) \left( \left\lceil \frac{H_{\text{view}}}{S \cdot T} \right\rceil + 1 \right) \qquad \text{(2.6)}
```

For a 1920 × 1080 window this is at most about 9 × 6 = 54 tiles, whatever the size of the image.

### 2.3 Display transfer functions

The viewer applies gamma correction

```math
C' = C^{\,1/\gamma} \qquad \text{(2.7)}
```

and, optionally, the extended Reinhard tone-mapping operator [4] with white point $L_w$ (the `White` property, default 1):

```math
C' = \operatorname{clamp}\!\left( \frac{C \left( 1 + C / L_w^{\,2} \right)}{1 + C}, \; 0, \; 1 \right) \qquad \text{(2.8)}
```

Both are evaluated by an SkSL runtime colour filter on the GPU, so changing `Gamma`, `ToneMap` or `White` costs nothing and does not invalidate the tile cache.

## 3. Architecture

### 3.1 Module and class structure

```
[ units and what they declare ]

・LUX.Data.Image                      ･･･ RTL only
  ┣・TLuxPixel                       ･･･ ( bpUInt08 … bpSFlo32 )
  ┣・TLuxLevel                       ･･･ ( Width, Height, Tiles* )
  ┣・TLuxImage                       ･･･ ( see the class hierarchy below )
  ┣・LUX.Data.Image.Files            ･･･ [ Skia ]
  ┃  ┣・TLuxImageFiler
  ┃  ┃  ┣・LoadFromPng / SaveToPng ･･･ System.ZLib, streaming
  ┃  ┃  ┗・LoadFromJpg / SaveToJpg ･･･ Skia codec
  ┃  ┣・LuxSkColorType
  ┃  ┗・LuxImageSize
  ┗・LUX.Data.Image.Viewer           ･･･ [ FireMonkey + Skia ]
     ┗・TLuxImageViewer              ･･･ ( TFrame )
        ┣・TTileKey  TTileImg
        ┣・ISkImage cache + apron
        ┣・SkSL colour filter
        ┗・wheel zoom / drag scroll

[ class hierarchy ]

・TLuxImage
  ┣・TLuxImageUInt08                 ･･･ TByteRGBA
  ┣・TLuxImageUInt16                 ･･･ TWordRGBA
  ┣・TLuxImageSFlo16                 ･･･ THalfRGBA
  ┗・TLuxImageSFlo32                 ･･･ TSingleRGBA

[ pixel path ]  tiles → mip pyramid → Skia

・TLuxImage
  ┗・level 0                         ･･･ original pixels, 256 × 256 tiles
     ┗・mip pyramid                  ･･･ level ℓ+1 = half of ℓ ( NeedLevel )
        ┗・level chosen by (2.4)     ･･･ effective scale S ∈ [ 1, 2 )
           ┗・visible tiles of it    ･･･ bounded by (2.6), not by the image
              ┗・ISkImage + apron    ･･･ cached as TTileImg under TTileKey
                 ┗・DrawImageRect    ･･･ SkSL colour filter: tone map + gamma

[ supporting units of the LUX standard library ]

・LUX                                 ･･･ base declarations, TDelegates
  ┣・LUX.Color                       ･･･ TByteRGBA  TWordRGBA  TSingleRGBA
  ┃  ┗・LUX.Color.Half              ･･･ THalfRGB  THalfRGBA
  ┗・LUX.D1.Half                     ･･･ THalf, the half-precision scalar
     ┗・LUX.D1.Half.DIff             ･･･ TdHalf, automatic differentiation
```

`LUX.Data.Image.pas` uses neither FireMonkey nor Skia; those dependencies are confined to the file and viewer units.

### 3.2 File layout

```
・Data/Image/
  ┣・LUX.Data.Image.pas        ･･･ TLuxImage and the 4 concrete classes
  ┣・LUX.Data.Image.Files.pas  ･･･ file reading and writing
  ┗・LUX.Data.Image.Viewer.pas ･･･ TLuxImageViewer ( TFrame )
```

## 4. Usage

### 4.1 Project setup

Enable the Skia canvas in the project source file, and include `FMX.Skia.Canvas.Vulkan` so that the Vulkan backend registers itself:

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

With this in place the viewer draws straight into the window surface: there is no intermediate raster surface and no per-frame texture upload of the whole window. Without it the viewer still works — it renders through an intermediate raster bitmap instead — but that costs a full-window blit every frame.

### 4.2 Loading and displaying an image

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

## 5. Pixel Formats

| Class | Pixel record | Bytes / pixel | Skia colour type | Default display gamma |
|---|---|---|---|---|
| `TLuxImageUInt08` | `TByteRGBA` | 4 | `BGRA8888` | 1.0 |
| `TLuxImageUInt16` | `TWordRGBA` | 8 | `RGBA16161616` | 1.0 |
| `TLuxImageSFlo16` | `THalfRGBA` | 8 | `RGBAF16` | 2.2 |
| `TLuxImageSFlo32` | `TSingleRGBA` | 16 | `RGBAF32` | 2.2 |

Because each format matches a native Skia colour type, the viewer hands tiles to the GPU without any pixel-format conversion. The 16-bit floating-point format is IEEE 754 `binary16` [5].

Alpha is stored straight, that is, not premultiplied.

Integer formats are taken to hold display-encoded values — a JPEG is already sRGB — so their default display gamma is 1.0. Floating-point formats are taken to hold linear values, so their default gamma is 2.2 and tone mapping is enabled by default.

## 6. API Reference

### 6.1 TLuxImage

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

`SetRow` and `SetRaws` mark the mip levels stale but do not raise `OnChange`; call `Changed` once after a batch of edits. The single-pixel property setters call `Changed` themselves.

Tiles carry no padding in storage. The viewer gathers the one-pixel apron it needs when it builds its render cache.

### 6.2 Asynchronous file I/O

`LoadFromFileAsync` and `SaveToFileAsync` run the ordinary loader on a `TTask` and deliver every notification to the main thread through `TThread.Queue`, so handlers may touch the UI directly.

`Busy` is raised before the worker starts and lowered immediately before `OnLoaded` or `OnSaved` is raised. The viewer draws nothing while `Busy` is set, which is what allows the worker to write pixels without any locking. The destructor waits for the worker and drains any pending notification, so an image may be freed while a load is in flight.

Loading also builds the whole mip pyramid on the worker thread, using all available cores. Were it left to the first repaint, that work would block the UI instead.

`Progress` runs from 0 to 1 over the entire operation, including the pyramid. It is reported per row, so PNG advances smoothly; JPEG cannot, because Skia's decode is a single call with no callback, and progress therefore stands still until the decode completes.

### 6.3 File formats

| Format | Read | Write | Notes |
|---|---|---|---|
| PNG | ✔ | ✔ | Implemented directly on `System.ZLib`. Reads every variant the format defines; writes RGBA, 8 bit for `TLuxImageUInt08` and 16 bit otherwise. |
| JPEG | ✔ | ✔ | Uses the Skia codec. |

The PNG reader covers the whole of the format as specified in [1], whose compressed data stream is DEFLATE [2]:

| | supported |
|---|---|
| Bit depths | 1, 2, 4, 8, 16 |
| Colour types | 0 grayscale, 2 truecolour, 3 palette, 4 grayscale + alpha, 6 truecolour + alpha |
| Transparency | `tRNS` in all three of its forms — palette alpha, grayscale colour key, RGB colour key |
| Interlacing | none, and Adam7 |

Non-interlaced images are decoded a row at a time and written straight into the tiles, so no whole-image temporary is ever allocated regardless of the size of the file. Adam7 images are decoded pass by pass and the pixels scattered to their final positions, which is slower but equally free of a full-size buffer.

JPEG passes through Skia [6], which requires the whole image in one contiguous buffer, so reading or writing a JPEG temporarily needs `width × height × 4` bytes in addition to the image itself. The JPEG standard [3] also caps dimensions at 65,535.

Saving a floating-point image to PNG clamps to 0…1 and quantises to 16 bit; saving to JPEG clamps to 0…1 and quantises to 8 bit. Tone mapping is not applied when saving, as it is a display setting.

`LUX.Data.Image.Files.pas` also exports:

```pascal
function LuxSkColorType( const Kind_:TLuxPixel ) :TSkColorType;
function LuxImageSize( const FileName_:String; out Width_,Height_:Integer ) :Boolean;
```

### 6.4 TLuxImageViewer

```pascal
property Image      :TLuxImage;
property Gamma      :Single;       // out = in^(1/Gamma)
property ToneMap    :Boolean;      // Reinhard 2002
property White      :Single;       // tone mapping white point, default 1
property Background :TAlphaColor;
property Scale      :Single;       // screen pixels per image pixel
property Origin     :TPointF;      // image coordinate at the top left of the view
property MinScale   :Single;       // default 1/4096
property MaxScale   :Single;       // default 256

procedure FitToWindow;
procedure ZoomAt( const P_:TPointF; const Factor_:Single );
procedure ZoomWheel( const WheelDelta_:Integer );
function  ViewToImage( const P_:TPointF ) :TPointF;
function  ImageToView( const P_:TPointF ) :TPointF;
procedure Redraw;
```

Assigning `Image` resets `Gamma` and `ToneMap` to that class's defaults and fits the image to the window.

Setting `Scale` re-centres the image: the centre of the image is placed at the centre of the view. `ZoomAt` instead holds a given point of the view still, which is what the wheel uses to keep the pixel under the cursor in place.

Rolling the wheel towards you zooms in — the factor applied is $2^{-\Delta / 480}$, so four notches double the scale. Dragging with the left button scrolls.

### 6.5 How a frame is drawn

1. The level is chosen by (2.4) so that within it the image is always magnified by a factor in [1, 2). Minification never occurs inside a level, so minification aliasing cannot arise.
2. The visible tiles of that level are enumerated, at most the number bounded by (2.6).
3. Each tile becomes an `ISkImage` and is cached, keyed by `TTileKey` (level and tile indices). The cached image carries a one-pixel apron gathered from the neighbouring tiles, so filtering at a tile boundary reads real neighbouring pixels instead of clamping, and no seams appear.
4. The tiles are drawn with `DrawImageRect`. At `Scale` ≥ 1 sampling is nearest neighbour, so magnifying past 1:1 shows pixels as squares; below 1:1 it is linear. Tone mapping and gamma are applied by an SkSL runtime colour filter on the GPU, so changing `Gamma`, `ToneMap` or `White` costs nothing and does not invalidate the cache.

Nothing is resampled on the CPU. The only per-frame CPU work is gathering the aprons of newly exposed tiles, and only on a cache miss.

## 7. Limitations

- There is no paging to disk. An image that does not fit in RAM cannot be opened.
- TIFF, OpenEXR and Radiance HDR are not implemented.
- Skia's codec converts reliably only to 8-bit, so a JPEG is always decoded as BGRA8888 and converted afterwards when the target class is wider. As JPEG is an 8-bit format, nothing is lost.

## 8. Demo

`LuxImage.dproj` in the repository root loads `_DATA\Image 16384x16384.jpg`, displays it and can save it again.

```
LuxImage.exe [ image file ] [ pixel format index 0..3 ]
```

## 9. References

1. W3C, [*Portable Network Graphics (PNG) Specification (Third Edition)*](https://www.w3.org/TR/png-3/), W3C Recommendation, 2025.
2. P. Deutsch, [*DEFLATE Compressed Data Format Specification version 1.3*](https://www.rfc-editor.org/rfc/rfc1951), RFC 1951, IETF, 1996.
3. ITU-T, [*Recommendation T.81: Digital compression and coding of continuous-tone still images — Requirements and guidelines*](https://www.itu.int/rec/T-REC-T.81), ITU-T, 1992.
4. E. Reinhard, M. Stark, P. Shirley and J. Ferwerda, [*Photographic Tone Reproduction for Digital Images*](https://doi.org/10.1145/566570.566575), ACM Transactions on Graphics, vol. 21, no. 3, pp. 267–276, 2002.
5. IEEE, [*IEEE Standard for Floating-Point Arithmetic (IEEE Std 754-2019)*](https://doi.org/10.1109/IEEESTD.2019.8766229), IEEE, 2019.
6. [*Skia Graphics Library*](https://skia.org/), Google.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
