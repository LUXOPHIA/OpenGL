# OpenGL

[English](README.md) | [日本語](ja/README.md)

A live-coding OpenGL playground for Delphi / FireMonkey: it embeds native OpenGL 4.3 viewports as FMX components and renders a procedurally generated "braided torus" through a fully programmable vertex → geometry → fragment GLSL pipeline. Shader sources can be edited in `TMemo` controls at run time and are recompiled on the fly, with per-stage compile logs and the program link log displayed in the UI.

![Main window](--------/_SCREENSHOT/OpenGL.png)

## 利用ライブラリ

* [**LUX**](https://github.com/LUXOPHIA/LUX) ：Base mathematical utility library for Delphi.
* [**LUX.GPU.OpenGL**](https://github.com/LUXOPHIA/LUX.GPU.OpenGL) ：OpenGL wrapper library for Delphi.

## 1. Overview

* **OpenGL viewports as FMX components** — `TGLViewer` is an FMX frame that hosts a native child window with its own device context, so hardware-accelerated OpenGL runs inside an ordinary FireMonkey layout. Four viewports (three orthographic, one perspective) display the same scene simultaneously, all sharing a single WGL rendering context (`HGLRC`).
* **Live shader editing** — the vertex, geometry, and fragment shaders are loaded from `_DATA/*.glsl` into `TMemo` editors. Every edit is re-sent to the driver and recompiled; compile errors appear next to the source, and the `glLinkProgram` [4] log is shown on its own tab.
* **Procedural geometry** — the mesh is generated on the CPU by sampling a parametric function (`BraidedTorus`) on a 1300 × 100 grid (`TGLShaperFace.LoadFromFunc`).
* **Geometry-shader bevel effect** — each triangle is amplified into a smooth inset face plus three flat-shaded rim faces.
* **HDR environment reflection** — the fragment shader reflects the view ray and samples an equirectangular HDR environment map (`Luxo-Jr_2000x1000.hdr`), followed by tone mapping and gamma correction.
* **Off-screen rendering** — viewport 4 can be rendered off-screen at 3840 × 2160 via `TGLRender` and saved as a PNG.

### 1.1 Related branches and repositories

The branches of this repository re-implement the same demo API-generation by API-generation, so the structure of the pipeline can be understood by following how OpenGL evolved:

* [OpenGL 1.0](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-1.0) · [OpenGL 1.1](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-1.1) · [OpenGL 1.5](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-1.5) · [OpenGL 2.1](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-2.1) · [OpenGL 3.0](https://github.com/LUXOPHIA/OpenGL/tree/OpenGL-3.0)
* [simple](https://github.com/LUXOPHIA/OpenGL/tree/simple) — a minimally classed variant.
* [OpenGL_VCL](https://github.com/LUXOPHIA/OpenGL_VCL/) — the VCL edition of this project.

## 2. Technical Background

### 2.1 Programmable pipeline

The demo drives the modern programmable pipeline [2]: vertex data uploaded to buffer objects flows through a vertex shader, a geometry shader, rasterization, and a fragment shader, all written in GLSL `#version 430` [3]. Transformation matrices are passed as `std140` uniform blocks — `TViewerScal`, `TCameraProj`, `TCameraPose`, and `TShaperPose` — each backed on the CPU side by a `TGLUniBuf<TSingleM4>` uniform buffer object.

### 2.2 Transformation chain

The vertex shader (`ShaderV.glsl`) only lifts vertices into world space; projection is deferred to the geometry shader so that it can operate on world-space positions. With the model matrix $M$ (`_ShaperPose`):

```math
p_{\mathrm{world}} = M \, p_{\mathrm{model}} \qquad (1)
```

Normals are transformed by the inverse-transpose to stay perpendicular under non-uniform transforms:

```math
n_{\mathrm{world}} = \left( M^{-1} \right)^{\!\top} n_{\mathrm{model}} \qquad (2)
```

The geometry shader (`ShaderG.glsl`) then produces the clip-space position. Note that `_CameraPose` $V$ stores the camera's pose (camera-to-world), so the view matrix is its *inverse*, computed in-shader; $P$ is the projection matrix (`_CameraProj`, orthographic for `TGLCameraOrth`, perspective for `TGLCameraPers`), and $S$ (`_ViewerScal`) corrects for the viewport's aspect ratio:

```math
p_{\mathrm{clip}} = S \cdot P \cdot V^{-1} \cdot M \, p_{\mathrm{model}} \qquad (3)
```

### 2.3 Geometry amplification

For every input triangle $P_1 P_2 P_3$, the geometry shader (`layout( triangles ) in; layout( triangle_strip, max_vertices = 21 ) out;` [5]) builds three inset corner points $C_i$ as barycentric blends with weights $(0.1,\, 0.8,\, 0.1)$, slightly offset along the normal. It then emits one smooth-shaded center triangle $C_1 C_2 C_3$ and three flat-shaded rim quads ($P_1 P_2 C_2 C_1$, …), whose normals are recomputed per face — producing a paneled, beveled surface from plain input triangles.

### 2.4 Reflection mapping and tone reproduction

The fragment shader (`ShaderF.glsl`) computes the reflection of the view ray $\vec{V}$ about the surface normal, $\vec{R} = \mathrm{reflect}(\vec{V}, \vec{N})$, and converts it to equirectangular texture coordinates:

```math
u = \frac{\pi - \operatorname{atan2}(-R_x,\, -R_z)}{2\pi}, \qquad v = \frac{\arccos R_y}{\pi} \qquad (4)
```

The HDR radiance sampled from the environment map is compressed by an extended Reinhard tone-mapping operator with white point $W = 1$,

```math
C' = \operatorname{clamp}\!\left( \frac{C \left( 1 + C / W \right)}{1 + C},\ 0,\ 1 \right) \qquad (5)
```

and finally gamma-corrected with $C'' = C'^{\,1/\gamma}$, $\gamma = 2.2$.

## 3. Architecture

### 3.1 Class diagram

The application composes wrapper classes from the [LUX.GPU.OpenGL](https://github.com/LUXOPHIA/LUX.GPU.OpenGL) library (vendored under `_LIBRARY/`):

```
Ownership — what TForm1 (Main.pas) creates and owns

・TForm1 (Main.pas)
  ┣・GLViewer1..4 :TGLViewer             ･･･ FMX frame + native GL child window
  ┃  ┣・Camera                          ･･･ one of the TGLCamera objects below
  ┃  ┗・_Viewer :TGLUniBuf<TSingleM4>   ･･･ "TViewerScal" UBO
  ┣・_Scener :TGLScener                  ･･･ scene root (TTreeNode<TGLObject>)
  ┃  ┣・_Camera1..3 :TGLCameraOrth      ･･･ "TCameraProj" / "TCameraPose" UBOs
  ┃  ┣・_Camera4 :TGLCameraPers
  ┃  ┗・_Shaper :TGLShaperFace          ･･･ "TShaperPose" UBO + mesh buffers
  ┗・_Matery :TGLMateryImagG             ･･･ shaders + program + texture
     ┣・ShaderV :TGLShaderV              ･･･ (TGLShader: Source/Status/Errors)
     ┣・ShaderG :TGLShaderG
     ┣・ShaderF :TGLShaderF
     ┣・Engine :TGLEngine ( TGLProgra )
     ┃  ┣・VerBufs :TGLPorterV          ･･･ attribute ports
     ┃  ┣・UniBufs :TGLPorterU          ･･･ uniform-block ports
     ┃  ┣・Texturs :TGLPorterT          ･･･ sampler ports
     ┃  ┗・StoBufs :TGLPorterS          ･･･ storage-buffer ports
     ┗・Textur :TGLCelTex2D_TAlphaColorF ･･･ 2-D texture, fed by an HDR Imager

Camera reference — each viewer points at one camera of the scene graph

・GLViewer1..4 . Camera
  ┣・_Camera1..3 :TGLCameraOrth
  ┗・_Camera4 :TGLCameraPers

Material reference — the shaper points at the material

・_Shaper :TGLShaperFace . Matery
  ┗・_Matery :TGLMateryImagG

Shader attachment — the three shaders attach to the engine's program

・Engine :TGLEngine ( TGLProgra )
  ┣・ShaderV :TGLShaderV
  ┣・ShaderG :TGLShaderG
  ┗・ShaderF :TGLShaderF

Global singleton

・_OpenGL_ :IOpenGL ( TOpenGL )           ･･･ hidden window + DC, shared HGLRC
```

Data flows from the scene graph into uniform buffers: each `TGLViewer.Paint` makes the shared context current, uploads the viewer/camera/shaper matrices, and lets the material's `TGLEngine` bind buffers, textures, and the linked program before drawing. `TGLShader.Source` recompiles whenever its `TStringList` changes and reports through `OnCompiled` / `Errors`; `TGLEngine` relinks and reports through `OnLinked`.

### 3.2 File tree

```
・OpenGL/
  ┣・OpenGL.dpr / OpenGL.dproj ･･･ FMX application project (Win32 / Win64)
  ┣・Main.pas / Main.fmx       ･･･ main form: viewports, editors, scene setup
  ┣・_DATA/
  ┃  ┣・ShaderV.glsl          ･･･ vertex shader (model → world, eqs. 1–2)
  ┃  ┣・ShaderG.glsl          ･･･ geometry shader (bevel amplification, eq. 3)
  ┃  ┣・ShaderF.glsl          ･･･ fragment shader (reflection, eqs. 4–5)
  ┃  ┗・Luxo-Jr_2000x1000.hdr ･･･ equirectangular HDR environment map
  ┣・_LIBRARY/LUXOPHIA/
  ┃  ┣・LUX/                  ･･･ vectors/matrices, scene tree, color, curves
  ┃  ┗・LUX.GPU.OpenGL/       ･･･ OpenGL wrapper library (see § 3.1)
  ┗・--------/_SCREENSHOT/     ･･･ screenshots used in this README
```

## 4. Usage

| Operation | Where | Effect |
|---|---|---|
| Left-drag | Viewport 4 (perspective) | Rotate the model; all four viewports repaint |
| Double-click | Viewports 1–3 | Save that viewport as `Viewer1.png` … `Viewer3.png` |
| Double-click | Viewport 4 | Off-screen render at 3840 × 2160 via `TGLRender`, saved as `Viewer4.png` |
| Edit text | **Shader** tab › Vertex / Geometry / Fragment | Recompile the shader on idle; compile errors appear in the adjacent pane |
| — | **Program** tab | Shows the `glLinkProgram` log; on link failure the **View** tab is disabled |

The shader source can be rewritten live in the `TMemo` editors; it is compiled in real time and error messages are displayed as appropriate:

![Vertex-shader editor](--------/_SCREENSHOT/OpenGL-Shader-Vertex.png)

Link-time error messages from `glLinkProgram` [4] can likewise be checked on the **Program** tab:

![Program link log](--------/_SCREENSHOT/OpenGL-Program.png)

## 5. Building

* **IDE**: RAD Studio (Delphi); the project file is in `ProjectVersion` 20.4 format. The FireMonkey (FMX) framework is required.
* **Platforms**: Win32 and Win64 (the OpenGL context is created through WGL, so the project is Windows-only).
* **Dependencies**: none beyond the vendored `_LIBRARY/` sources; rendering goes through the system `opengl32.dll` plus a GPU driver exposing **OpenGL 4.3** (the shaders use `#version 430` and geometry shaders).
* **Run**: build and run from the IDE. The executable loads `..\..\_DATA\*.glsl` and the HDR map relative to the output directory (e.g. `Win64\Debug\`), so keep the default output layout or adjust the paths in `Main.pas`.

## 6. References

1. Khronos Group, [*OpenGL Registry*](https://registry.khronos.org/OpenGL/).
2. Khronos Group, [*Rendering Pipeline Overview*](https://www.khronos.org/opengl/wiki/Rendering_Pipeline_Overview), OpenGL Wiki.
3. J. Kessenich et al., [*The OpenGL Shading Language, Version 4.30*](https://registry.khronos.org/OpenGL/specs/gl/GLSLangSpec.4.30.pdf).
4. Khronos Group, [*glLinkProgram*](https://registry.khronos.org/OpenGL-Refpages/gl4/html/glLinkProgram.xhtml), OpenGL 4 Reference Pages.
5. Khronos Group, [*Geometry Shader*](https://www.khronos.org/opengl/wiki/Geometry_Shader), OpenGL Wiki.

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
