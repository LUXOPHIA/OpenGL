# LUX.GPU.OpenGL
[English](README.md) | [日本語](ja/README.md)

A **Delphi** library for [OpenGL](https://registry.khronos.org/OpenGL/index_gl.php) 4.3 core-profile rendering and GPU computation on Windows. It wraps the WGL context, GLSL programs, buffers, textures and framebuffers as objects, adds a scene graph of cameras, shapes and materials, and provides a `TGLViewer` frame so that an OpenGL viewport can be placed on an FMX or VCL form like any other GUI control.

----

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：The base library providing the math types `TSingle3D` / `TSingleM4`, tree and list containers, colors, and the FMX form helper.

## 1. Overview

The library is built in four layers:

| Layer | Folder / unit | Contents |
|:--|:--|:--|
| Context | `LUX.GPU.OpenGL.pas` | `IOpenGL` / `TOpenGL` — pixel format, device and rendering context (WGL) |
| Atom | `Atom/` | thin object wrappers over single GL objects: shaders, programs, buffers, textures, images, framebuffers |
| Scene | `LUX.GPU.OpenGL.{Scener,Camera,Shaper,Matery,Inform}.pas` | scene tree, cameras, geometry, materials, bounding-box overlay |
| Framework | `_FMX/`, `_VCL/` | `TGLViewer` frame, host window, offscreen renderer |

Only the framework layer is platform/framework specific; everything else is shared between FMX and VCL. Compute shaders are available through `LUX.GPU.OpenGL.Comput.pas` (`TGLComput`), independent of the scene graph.

| Framework | Units | Demo |
|:--|:--|:--|
| [FMX](https://www.wikiwand.com/en/FireMonkey) | `_FMX/LUX.GPU.OpenGL.{Window,Viewer,Render}.pas` | [LUXOPHIA/OpenGL](https://github.com/LUXOPHIA/OpenGL) [6] |
| VCL | `_VCL/LUX.GPU.OpenGL.{Window,Viewer,Render}.pas` | [LUXOPHIA/OpenGL_VCL](https://github.com/LUXOPHIA/OpenGL_VCL) [7] |

## 2. Technical Background

### 2.1 Context Creation (WGL)

On Windows an OpenGL rendering context (`HGLRC`) is bound to a device context (`HDC`) whose pixel format has been chosen in advance [3]. `TOpenGL` performs that sequence in its constructor: it creates a hidden window, obtains its `HDC`, validates a `TPixelFormatDescriptor` with `ChoosePixelFormat` / `DescribePixelFormat`, applies it with `SetPixelFormat` and creates the context with `wglCreateContext`. `TOpenGL.DefaultPFD` requests `PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER`, `PFD_TYPE_RGBA`, 24 colour bits and 32 depth bits.

Exactly one context exists per process. The framework-specific descendants — `TOepnGL_FMX` (spelling as in the source) and `TOpenGL_VCL` — are instantiated in the `initialization` section of `_FMX/`/`_VCL/LUX.GPU.OpenGL.Window.pas`, stored in the global `_OpenGL_ :IOpenGL`, and followed by `InitOpenGLext` so that the post-1.1 entry points become available. Every viewport then calls `wglMakeCurrent( its own DC, _OpenGL_.RC )`, so all viewports share one context and therefore one set of GL objects. `InitOpenGL` sets the initial state: `GL_DEPTH_TEST`, `GL_CULL_FACE`, `GL_BLEND` with `glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA )`, and `GL_PROGRAM_POINT_SIZE`.

### 2.2 The Transform Chain

A `TGLObject` stores its pose relative to its parent as $R$ (`RelaPose`) and caches the absolute pose

```math
M = M_{\text{parent}} R \tag{1}
```

in a uniform buffer (`AbsoPose`), recomputed lazily whenever an ancestor moves. A camera is itself a `TGLObject`, so its absolute pose $C$ is the camera-to-world matrix and the view matrix is $C^{-1}$. With the projection matrix $P$ (`TGLCamera.Proj`) and the viewport aspect-fit matrix $S$, the clip-space position of a model-space vertex is

```math
p_{\text{clip}} = S \, P \, C^{-1} M \, p_{\text{model}} \tag{2}
```

which is exactly the expression emitted into the vertex/geometry shaders, while normals use the inverse transpose

```math
n_{\text{world}} = \bigl( M^{-1} \bigr)^{\!\top} n_{\text{model}} . \tag{3}
```

$S$ letterboxes the square clip space into a non-square viewport of $w \times h$ pixels:

```math
S = \begin{cases}
\operatorname{Scale}( h/w,\; 1,\; 1 ) & h < w \\
\operatorname{Scale}( 1,\; w/h,\; 1 ) & w < h \\
I & \text{otherwise}
\end{cases} \tag{4}
```

The four matrices are supplied to GLSL as `std140` uniform blocks bound at fixed points, and the vertex attributes likewise:

| Binding | Uniform block | Written by |
|:--:|:--|:--|
| 0 | `TViewerScal` | `TGLViewer` / `TGL_Render` — $S$ |
| 1 | `TCameraProj` | `TGLCamera` — $P$ |
| 2 | `TCameraPose` | `TGLCamera` — $C$ |
| 3 | `TShaperPose` | `TGLObject` — $M$ |
| 4… | material-specific (`TMateryCol`, `TAmbient`, …) | `TGLMatery` descendants |

| Binding | Vertex attribute | Declared by |
|:--:|:--|:--|
| 0 | `_SenderPos` (`vec3`) | `TGLMatery` |
| 1 | `_SenderNor` (`vec3`) | `TGLMateryNor` |
| 2 | `_SenderTex` (`vec2`) | `TGLMateryNorTex` |

Both camera kinds build $P$ from an off-centre frustum with near $n = 0.1$ and far $f = 1000$. Writing $\mathbf{o}$ for the normalised lens shift `Offs`, the half-extent at the near plane is

```math
s_{\text{orth}} = \frac{\texttt{Size}}{2} , \qquad
s_{\text{pers}} = n \tan\!\frac{\texttt{Angl}}{2} \tag{5}
```

and the frustum is then $[\,c_x - s,\; c_x + s\,] \times [\,c_y - s,\; c_y + s\,]$ with $\mathbf{c} = s\,\mathbf{o}$, passed to `TSingleM4.ProjOrth` or `TSingleM4.ProjPers`. `TGLCameraPers` defaults to `Angl` $= 60°$, `TGLCameraOrth` to `Size` $= 10$.

Inverting (2) gives the picking ray. `TGLViewer.ShootRay` maps the pixel $(x, y)$ to normalised device coordinates $\mathbf{s}$ and unprojects the two points $s_z = \mp 1$ through

```math
\mathbf{p} = C \, P^{-1} S^{-1} \mathbf{s} \tag{6}
```

taking the near point as the ray origin and the difference as its direction. `PickObject` then walks the scene tree with `HitRay`, testing each object's bounding box in that object's local frame.

### 2.3 Programs, Shaders and Name-Based Binding

`TGLShader` and its kinds `TGLShaderV` / `TGLShaderG` / `TGLShaderF` / `TGLShaderC` (vertex, geometry, fragment, compute) hold GLSL source as a `TStrings`; assigning to `Source` recompiles, and `Status` / `Errors` expose the compile log. `TGLProgra` links attached shaders into a program object, and its descendant `TGLEngine` adds five *porters* — dictionaries that map a binding point to a GLSL name:

| Porter | Maps binding point to | Resolved with |
|:--|:--|:--|
| `TGLPorterV` (`VerBufs`) | vertex attribute | `glGetAttribLocation` |
| `TGLPorterU` (`UniBufs`) | uniform block | `glGetUniformBlockIndex` |
| `TGLPorterT` (`Texturs`) | sampler uniform | `glGetUniformLocation` |
| `TGLPorterS` (`StoBufs`) | shader storage block | `glGetProgramResourceIndex` |
| `TGLPorterF` (`Framers`) | fragment output | `glBindFragDataLocation` |

Because a material declares its ports once (`UniBufs.Add( 4, 'TMateryCol' )`), the draw path only has to call `Use` on the buffer at the matching binding point — the GLSL location lookup happens once, when the program is linked.

### 2.4 Rendering and Compute Dispatch

Drawing is a depth-first traversal of the scene tree. `TGLObject.Draw` calls `BeginDraw` (bind $M$ at 3), `DrawMain`, `EndDraw` (draw the bounding-box overlay, unbind), then recurses into the children; `TGLShaper` overrides `BeginDraw`/`EndDraw` to `Use`/`Unuse` its material, and `TGLShaperPoin` binds `PosBuf`/`NorBuf`/`TexBuf` at attribute bindings 0/1/2. `DrawMain` finally issues the GL draw call — `glDrawArrays( GL_POINTS, … )` for point shapes, or `EleBuf.Draw` (`glDrawElements`) for indexed lines and faces.

For offscreen and antialiased output, `TGL_Render` renders into a multisample framebuffer `TGLFramerN` and resolves it into `TGLFramer1` with `glBlitFramebuffer`.

`TGLComput` dispatches a compute shader. `GrupsX/Y/Z` are the work-group counts passed to `glDispatchCompute`, `ItemsX/Y/Z` the local work-group size, so the number of invocations is

```math
N = \prod_{d} \texttt{Grups}_d \cdot \texttt{Items}_d . \tag{7}
```

`Run` uses the size fixed in the shader by `layout( local_size_x = … ) in;`, while `RunARB` passes the size at dispatch time via `glDispatchComputeGroupSizeARB` (`GL_ARB_compute_variable_group_size`). Storage buffers and images given to `Buffers` / `Imagers` / `Texturs` by name are auto-registered into the engine's porters on first run.

## 3. Architecture

### 3.1 Class Hierarchy

```
・IOpenGL / TOpenGL                               ･･･ WGL context; _OpenGL_
  ┣・TOepnGL_FMX                                 ･･･ hidden FMX form [_FMX]
  ┗・TOpenGL_VCL                                 ･･･ hidden VCL form [_VCL]

・TGLAtomer                                       ･･･ common base of GL objects
  ┣・TGLVarray                                   ･･･ vertex array object
  ┣・TGLShader                                   ･･･ Source / Status / Errors
  ┃  ┗・TGLShaderV, TGLShaderG, TGLShaderF, TGLShaderC
  ┣・TGLProgra                                   ･･･ glCreateProgram / Link
  ┃  ┗・TGLEngine                               ･･･ + buffer / texture tables
  ┣・TGLBuffer<T,Iter>                           ･･･ glGenBuffers, Map / Unmap
  ┃  ┣・TGLVerBuf<T> — TGLVerBufI, TGLVerBufS  ･･･ vertex attributes
  ┃  ┣・TGLEleBuf<T> — TGLEleBufFace, TGLEleBufLine, TGLEleBufQuadLines
  ┃  ┣・TGLUniBuf<T>                            ･･･ uniform block storage
  ┃  ┣・TGLStoBuf<T>                            ･･･ shader storage block
  ┃  ┗・TGLPixBuf<T,Iter>                       ･･･ pixel buffer, 1D/2D/3D
  ┃     ┗・TGLPoiPix{1,2,3}D, TGLCelPix{1,2,3}D ･･･ point/cell-sampled grids
  ┣・TGLImager<T,Iter,Grid>                      ･･･ image level + pixel grid
  ┃  ┗・TGLImager{1,2,3}D — TGLPoiIma{1,2,3}D, TGLCelIma{1,2,3}D
  ┣・TGLSamplr                                   ･･･ glGenSamplers
  ┣・TGLChaner — TGLChaner1, TGLChanerN         ･･･ framebuffer attachment
  ┗・TGLFramer — TGLFramer1, TGLFramerN         ･･･ FBO + TGLColors table
・TGLTextur<T,Iter,Grid,Imager>                   ･･･ sampler + imager pair
  ┗・TGLPoiTex{1,2,3}D, TGLCelTex{1,2,3}D

・TGLObject ( TTreeNode<TGLObject>, IGLObject )   ･･･ scene node
  ┣・TGLScener                                   ･･･ root (pose = identity)
  ┣・TGLCamera                                   ･･･ Proj, Offs, Render
  ┃  ┣・TGLCameraOrth                           ･･･ Size
  ┃  ┗・TGLCameraPers                           ･･･ Angl
  ┗・TGLShaper                                   ･･･ shape; Matery :IGLMatery
     ┣・TGLShaperZeroPoins                       ･･･ PoinsN, no vertex buffer
     ┃  ┣・TMarcubes, TColorMarcubes            ･･･ marching cubes [5]
     ┃  ┗・( TGLShaperZeroLines, TGLShaperZeroTrias )
     ┗・TGLShaperPoin                            ･･･ PosBuf / NorBuf / TexBuf
        ┣・TGLShaperLine                         ･･･ TGLEleBufLine32, LineW
        ┃  ┗・TGLShaperLineCube
        ┣・TGLShaperQuadLine                     ･･･ TGLEleBufQuadLines32
        ┣・TGLShaperFace                         ･･･ EleBuf :TGLEleBufFace32
        ┃  ┣・TGLShaperOctree                   ･･･ Tree :TOctree3D, Collision
        ┃  ┗・TGLText                           ･･･ [_VCL]
        ┣・TGLShaperVoxels                       ･･･ Count, SizeX/Y/Z, Color
        ┗・TGLDotCube, TGLShaperCopy
・TGLInform                                       ･･･ bounding-box overlay

・IGLMatery / TGLMatery                           ･･･ owns TGLEngine + shaders
  ┣・TGLMateryNor                                ･･･ + normal attribute
  ┃  ┗・TGLMateryNorTex                         ･･･ + texcoord attribute
  ┃     ┗・TGLMateryNorTexG                     ･･･ + TGLShaderG
  ┣・TGLMateryG                                  ･･･ + TGLShaderG
  ┗・TGLMatery{Color,RGB,Diffuse,Imag,ImagG,Plastic,Mirror,Glass,BB,Voxels}

・TGLViewer ( TFrame )                            ･･･ on-screen [_FMX] [_VCL]
  ┣・FMX: hosts a child TGLViewerForm ( HWND ), as FMX controls are windowless
  ┗・VCL: renders directly on the frame's own HWND
・TGL_Render — TGLRender                         ･･･ offscreen rendering
・IGLComput / TGLComput                           ･･･ compute shader dispatch
```

Draw-time data flow of one frame:

```
Call tree of one frame  ( execution order, top to bottom )

・TGLViewer.Paint / TGLRender.Render
  ┣・BeginRender                     ･･･ wglMakeCurrent, glClear
  ┃  ┗・TViewerScal.Use( 0 )        ･･･ S
  ┣・TGLCamera.Render
  ┃  ┣・TCameraProj.Use( 1 )        ･･･ P
  ┃  ┗・TCameraPose.Use( 2 )        ･･･ C
  ┣・TGLScener.Draw
  ┃  ┗・TGLObject.Draw              ･･･ depth-first over the scene tree
  ┃     ┣・BeginDraw
  ┃     ┃  ┣・TShaperPose.Use( 3 ) ･･･ M
  ┃     ┃  ┗・Matery.Use
  ┃     ┃     ┗・TGLEngine.Use
  ┃     ┃        ┣・VerBufs        ･･･ glVertexAttribPointer
  ┃     ┃        ┣・UniBufs        ･･･ glBindBufferBase
  ┃     ┃        ┣・Texturs        ･･･ glBindTexture
  ┃     ┃        ┗・StoBufs        ･･･ glBindBufferBase
  ┃     ┣・DrawMain                 ･･･ glDrawArrays / EleBuf.Draw
  ┃     ┗・EndDraw                  ･･･ Inform.Draw, unbind
  ┗・EndRender                       ･･･ glFlush, SwapBuffers or blit
```

### 3.2 File Layout

```
・LUX.GPU.OpenGL/
  ┣・LUX.GPU.OpenGL.pas                   ･･･ IOpenGL / TOpenGL, _OpenGL_
  ┣・LUX.GPU.OpenGL.Scener.pas            ･･･ TGLObject / TGLScener
  ┣・LUX.GPU.OpenGL.Camera.pas            ･･･ TGLCamera{,Orth,Pers}
  ┣・LUX.GPU.OpenGL.Shaper.pas            ･･･ TGLShaper family, STL/OBJ loaders
  ┣・LUX.GPU.OpenGL.Matery.pas            ･･･ TGLMatery family, GLSL sources
  ┣・LUX.GPU.OpenGL.Inform.pas            ･･･ TGLInform — bounding-box overlay
  ┣・LUX.GPU.OpenGL.Comput.pas            ･･･ TGLComput — compute shaders
  ┣・LUX.GPU.OpenGL.Render_.pas           ･･･ TGL_Render — framework-neutral
  ┣・Atom/                                ･･･ one class per GL object
  ┃  ┣・LUX.GPU.OpenGL.Atom.pas          ･･･ TGLAtomer / TGLVarray
  ┃  ┣・LUX.GPU.OpenGL.Atom.Shader.pas   ･･･ TGLShader{,C,V,G,F}
  ┃  ┣・LUX.GPU.OpenGL.Atom.Progra.pas   ･･･ TGLProgra
  ┃  ┣・LUX.GPU.OpenGL.Atom.Engine.pas   ･･･ TGLEngine
  ┃  ┣・LUX.GPU.OpenGL.Atom.Porter.pas   ･･･ TGLPorter{F,V,U,T,S}
  ┃  ┣・LUX.GPU.OpenGL.Atom.Buffer.pas   ･･･ TGLBuffer / TGLBufferData
  ┃  ┣・Buffer/                          ･･･ one unit per buffer type
  ┃  ┣・LUX.GPU.OpenGL.Atom.Imager.pas   ･･･ TGLImager (+ Imager/ 1D/2D/3D)
  ┃  ┣・LUX.GPU.OpenGL.Atom.Textur.pas   ･･･ TGLSamplr / TGLTextur (+ Textur/)
  ┃  ┣・LUX.GPU.OpenGL.Atom.Chaner.pas   ･･･ TGLChaner{,1,N} — attachments
  ┃  ┗・LUX.GPU.OpenGL.Atom.Framer.pas   ･･･ TGLFramer{,1,N} — FBO
  ┣・Matery/                              ･･･ material presets
  ┃  ┣・LUX.GPU.OpenGL.Matery.Preset.pas ･･･ Color / RGB / Diffuse / …
  ┃  ┗・Textur/_FMX|_VCL/                ･･･ TGLMatery{Imag,ImagG,BB}
  ┣・Shaper/                              ･･･ geometry presets
  ┃  ┣・LUX.GPU.OpenGL.Shaper.Preset.pas ･･･ TGLShaperLineCube / TGLDotCube
  ┃  ┣・LUX.GPU.OpenGL.Shaper.Octree.pas ･･･ TGLShaperOctree — collision
  ┃  ┣・LUX.GPU.OpenGL.Shaper.Voxels.pas ･･･ TGLShaperVoxels/TGLMateryVoxels
  ┃  ┗・Preset/                          ･･･ TMarcubes etc. + *.glsl
  ┣・_FMX/                                ･･･ FMX binding
  ┃  ┣・LUX.GPU.OpenGL.Window.pas        ･･･ TGLViewerForm / TOepnGL_FMX
  ┃  ┣・LUX.GPU.OpenGL.Viewer.pas|fmx    ･･･ TGLViewer frame
  ┃  ┗・LUX.GPU.OpenGL.Render.pas        ･･･ TGLRender
  ┗・_VCL/                                ･･･ VCL binding
     ┣・LUX.GPU.OpenGL.Window.pas         ･･･ TOpenGL_VCL
     ┣・LUX.GPU.OpenGL.Viewer.pas|dfm     ･･･ TGLViewer frame
     ┗・LUX.GPU.OpenGL.Render.pas         ･･･ TGLRender
```

## 4. Usage

Add the folders of this library — the root, `Atom/` and its subfolders, `Matery/`, `Shaper/`, and exactly one of `_FMX/` or `_VCL/` — together with those of `LUX` to the project search path. Framework-specific folders must never both be on the path, since the two `LUX.GPU.OpenGL.Window.pas` / `.Viewer.pas` / `.Render.pas` pairs share unit names.

### 4.1 A Viewport on a Form

`TGLViewer` is a frame, so it is placed on a form with the IDE's *Use Frame* command, or created in code. The example below is the FMX variant; on VCL the same code applies with `Align := alClient` and without `BackColor`, whose clear colour is set by the VCL viewer itself:

```pascal
uses System.Math,
     LUX, LUX.D3, LUX.D4x4,
     LUX.GPU.OpenGL.Scener,
     LUX.GPU.OpenGL.Camera,
     LUX.GPU.OpenGL.Shaper,
     LUX.GPU.OpenGL.Viewer,
     LUX.GPU.OpenGL.Shaper.Preset,
     LUX.GPU.OpenGL.Matery.Preset;

procedure TForm1.FormCreate( Sender:TObject );
begin
     _Viewer := TGLViewer.Create( Self );
     _Viewer.Parent    := Self;
     _Viewer.Align     := TAlignLayout.Client;
     _Viewer.BackColor := TAlphaColorF.Create( 0.1, 0.1, 0.1, 1 );

     ///// scene tree: Scener → Camera, Scener → Shaper
     _Scener := TGLScener.Create;

     _Camera       := TGLCameraPers.Create;
     _Camera.Paren := _Scener;
     _Camera.Angl  := DegToRad( 45 );
     _Camera.Pose  := TSingleM4.Translate( 0, 0, 10 );

     _Shaper       := TGLShaperLineCube.Create;
     _Shaper.Paren := _Scener;

     _Viewer.Camera := _Camera;     // the viewport renders through this camera
end;
```

Every node is a `TGLObject`, so `Paren` builds the tree and `Pose` (`= RelaPose`) places the node relative to its parent; `AbsoPose` is derived by (1) and uploaded automatically. Redrawing is `_Viewer.Repaint`, and `_Viewer.OnPaint` is called after the scene, for overlays.

### 4.2 Shapes and Materials

A shape carries vertex data and a material:

```pascal
var
   S :TGLShaperFace;
   M :TGLMateryDiffuse;
begin
     S := TGLShaperFace.Create;
     S.Paren := _Scener;
     S.LoadFromFileSTL( 'Bunny.stl' );   // or LoadFromFileOBJ / LoadFromFunc
     S.CalcBouBox;                       // bounding box, used for picking

     M := TGLMateryDiffuse.Create;
     M.Ambient := TAlphaColorF.Create( 0.1, 0.1, 0.1 );
     M.Diffuse := TAlphaColorF.Create( 0.8, 0.7, 0.6 );

     S.Matery := M;                      // IGLMatery — reference counted
end;
```

A custom material replaces the shader source of the base class and declares the extra uniform blocks it needs, starting at binding point 4 (§2.2):

```pascal
constructor TMyMatery.Create;
begin
     inherited;                                  // gives Engine, ShaderV, ShaderF

     _Color := TGLUniBuf<TAlphaColorF>.Create( GL_STATIC_DRAW );

     with _ShaderF.Source do
     begin
          BeginUpdate;
            Clear;
            Add( '#version 430' );
            Add( 'layout( std140 ) uniform TMateryCol{ vec4 _MateryCol; };' );
            Add( 'in TSenderVF{ vec4 Pos; } _Sender;' );
            Add( 'out vec4 _ResultCol;' );
            Add( 'void main(){ _ResultCol = _MateryCol; }' );
          EndUpdate;
     end;
     Assert( _ShaderF.Status, _ShaderF.Errors.Text );

     _Engine.UniBufs.Add( 4{BinP}, 'TMateryCol'{Name} );
end;

procedure TMyMatery.Use;    begin inherited;  _Color.Use  ( 4 ); end;
procedure TMyMatery.Unuse;  begin _Color.Unuse( 4 );  inherited; end;
```

### 4.3 Picking

```pascal
procedure TForm1.ViewerMouseDown( Sender:TObject; Button:TMouseButton;
                                  Shift:TShiftState; X, Y:Single );
var
   O :TGLObject;
begin
     O := _Viewer.PickObject( X, Y );      // ray cast per (6), bounding-box test
     if Assigned( O ) then O.Inform.Visible := True;
end;
```

### 4.4 Unit Reference

Per-unit class and member listings:

* [**LUX.GPU.OpenGL**.pas](LUX.GPU.OpenGL.pas.md)
* [**LUX.GPU.OpenGL.Scener**.pas](LUX.GPU.OpenGL.Scener.pas.md)
* [**LUX.GPU.OpenGL.Camera**.pas](LUX.GPU.OpenGL.Camera.pas.md)
* [**LUX.GPU.OpenGL.Shaper**.pas](LUX.GPU.OpenGL.Shaper.pas.md)
* [**LUX.GPU.OpenGL.Matery**.pas](LUX.GPU.OpenGL.Matery.pas.md)
* [**LUX.GPU.OpenGL.Inform**.pas](LUX.GPU.OpenGL.Inform.pas.md)
* [**LUX.GPU.OpenGL.Matery.Preset**.pas](Matery/LUX.GPU.OpenGL.Matery.Preset.pas.md)
* [**LUX.GPU.OpenGL.Matery.Textur.Preset**.pas](Matery/Textur/_VCL/LUX.GPU.OpenGL.Matery.Textur.Preset.pas.md)
* [**LUX.GPU.OpenGL.Shaper.Preset**.pas](Shaper/LUX.GPU.OpenGL.Shaper.Preset.pas.md)
* [**LUX.GPU.OpenGL.Shaper.Octree**.pas](Shaper/LUX.GPU.OpenGL.Shaper.Octree.pas.md)
* [**LUX.GPU.OpenGL.Shaper.Voxels**.pas](Shaper/LUX.GPU.OpenGL.Shaper.Voxels.pas.md)
* [**LUX.GPU.OpenGL.Viewer**.pas](_VCL/LUX.GPU.OpenGL.Viewer.pas.md)
* [**LUX.GPU.OpenGL.Window**.pas](_VCL/LUX.GPU.OpenGL.Window.pas.md)

## 5. Requirements

* **Delphi** — Win32 / Win64, FMX or VCL. Generics and anonymous methods are used throughout.
* **Windows** — the context layer is WGL-based (`opengl32.dll`, `wglCreateContext`, `wglMakeCurrent` [3]); the FMX viewport additionally relies on a child `HWND`.
* **OpenGL 4.3 or later**, provided by the GPU driver (NVIDIA / AMD / Intel). All shipped GLSL is `#version 430`, and shader storage blocks, compute shaders and `glDispatchCompute` require 4.3. Entry points beyond OpenGL 1.1 are resolved by `Winapi.OpenGLext.InitOpenGLext`; `RunARB` additionally needs `GL_ARB_compute_variable_group_size`.
* **[LUXOPHIA/LUX](https://github.com/LUXOPHIA/LUX)** — the base library (math types `TSingle3D` / `TSingleM4`, tree and list containers, colours, and the FMX form helper `TLuxCommonCustomForm` used by the FMX window). This repository does not bundle it.

## 6. References

1. Khronos Group, [*The OpenGL Graphics System: A Specification (Version 4.6, Core Profile)*](https://registry.khronos.org/OpenGL/specs/gl/glspec46.core.pdf), 2019.
2. J. Kessenich, D. Baldwin and R. Rost, [*The OpenGL Shading Language, Version 4.60*](https://registry.khronos.org/OpenGL/specs/gl/GLSLangSpec.4.60.pdf), Khronos Group, 2019.
3. Microsoft, [*WGL Functions*](https://learn.microsoft.com/en-us/windows/win32/opengl/wgl-functions), Win32 API documentation.
4. Khronos Group, [*OpenGL Registry*](https://registry.khronos.org/OpenGL/index_gl.php) — including [`glcorearb.h`](https://registry.khronos.org/OpenGL/api/GL/glcorearb.h) and [`wglext.h`](https://registry.khronos.org/OpenGL/api/GL/wglext.h); source repository [KhronosGroup/OpenGL-Registry](https://github.com/KhronosGroup/OpenGL-Registry).
5. W. E. Lorensen and H. E. Cline, [*Marching cubes: A high resolution 3D surface construction algorithm*](https://doi.org/10.1145/37401.37422), ACM SIGGRAPH Computer Graphics, 21(4), pp. 163–169, 1987.
6. LUXOPHIA, [*OpenGL*](https://github.com/LUXOPHIA/OpenGL), GitHub repository — FMX demo.
7. LUXOPHIA, [*OpenGL_VCL*](https://github.com/LUXOPHIA/OpenGL_VCL), GitHub repository — VCL demo.
8. K. Tokoi, [*Delphiによる最低限のOpenGL制御*](https://tokoik.github.io/opengl/delphi.html).
9. neslib, [*DelphiLearnOpenGL*](https://github.com/neslib/DelphiLearnOpenGL), GitHub repository — Delphi port of the *Learn OpenGL* tutorials.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
