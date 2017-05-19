program OpenGL;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  LUX.D3.V4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D3.V4.pas',
  LUX.D4.M4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D4.M4.pas',
  LUX.D4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D4.pas',
  LUX.D4.V4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D4.V4.pas',
  LUX.D5 in '_LIBRARY\LUXOPHIA\LUX\LUX.D5.pas',
  LUX.Lattice.T1 in '_LIBRARY\LUXOPHIA\LUX\LUX.Lattice.T1.pas',
  LUX.Lattice.T2 in '_LIBRARY\LUXOPHIA\LUX\LUX.Lattice.T2.pas',
  LUX.Lattice.T3 in '_LIBRARY\LUXOPHIA\LUX\LUX.Lattice.T3.pas',
  LUX.M2 in '_LIBRARY\LUXOPHIA\LUX\LUX.M2.pas',
  LUX.M3 in '_LIBRARY\LUXOPHIA\LUX\LUX.M3.pas',
  LUX.M4 in '_LIBRARY\LUXOPHIA\LUX\LUX.M4.pas',
  LUX in '_LIBRARY\LUXOPHIA\LUX\LUX.pas',
  LUX.D1 in '_LIBRARY\LUXOPHIA\LUX\LUX.D1.pas',
  LUX.D2.M4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D2.M4.pas',
  LUX.D2 in '_LIBRARY\LUXOPHIA\LUX\LUX.D2.pas',
  LUX.D2.V4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D2.V4.pas',
  LUX.D3.M4 in '_LIBRARY\LUXOPHIA\LUX\LUX.D3.M4.pas',
  LUX.D3 in '_LIBRARY\LUXOPHIA\LUX\LUX.D3.pas',
  LUX.GPU.OpenGL.Geometry in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Geometry.pas',
  LUX.GPU.OpenGL.Material in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Material.pas',
  LUX.GPU.OpenGL.GLView in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\FMX\LUX.GPU.OpenGL.GLView.pas' {GLView: TFrame},
  LUX.GPU.OpenGL.Buffer.Vert in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Buffer.Vert.pas',
  LUX.GPU.OpenGL.Engine in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Engine.pas',
  LUX.GPU.OpenGL in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.pas',
  LUX.GPU.OpenGL.Pluger in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Pluger.pas',
  LUX.GPU.OpenGL.Progra in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Progra.pas',
  LUX.GPU.OpenGL.Shader in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Shader.pas',
  LUX.GPU.OpenGL.Buffer.Elem in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Buffer.Elem.pas',
  LUX.GPU.OpenGL.Buffer in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Buffer.pas',
  LUX.GPU.OpenGL.Buffer.Unif in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Buffer.Unif.pas',
  LUX.GPU.OpenGL.FMX in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\FMX\LUX.GPU.OpenGL.FMX.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
