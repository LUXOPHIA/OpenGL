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
  LUX.GPU.OpenGL.Viewer in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\FMX\LUX.GPU.OpenGL.Viewer.pas' {GLViewer: TFrame},
  LUX.GPU.OpenGL.FMX in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\FMX\LUX.GPU.OpenGL.FMX.pas',
  LUX.GPU.OpenGL.Imager.FMX in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\FMX\LUX.GPU.OpenGL.Imager.FMX.pas',
  LUX.GPU.OpenGL.Matery.FMX in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\FMX\LUX.GPU.OpenGL.Matery.FMX.pas',
  LUX.GPU.OpenGL.Buffer.Unifor in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\» OBJECT\LUX.GPU.OpenGL.Buffer.Unifor.pas',
  LUX.GPU.OpenGL.Buffer.Verter in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\» OBJECT\LUX.GPU.OpenGL.Buffer.Verter.pas',
  LUX.GPU.OpenGL.Engine in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\» OBJECT\LUX.GPU.OpenGL.Engine.pas',
  LUX.GPU.OpenGL.Imager in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\» OBJECT\LUX.GPU.OpenGL.Imager.pas',
  LUX.GPU.OpenGL.Progra in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\» OBJECT\LUX.GPU.OpenGL.Progra.pas',
  LUX.GPU.OpenGL.Shader in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\» OBJECT\LUX.GPU.OpenGL.Shader.pas',
  LUX.GPU.OpenGL.Buffer.Elemer in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\» OBJECT\LUX.GPU.OpenGL.Buffer.Elemer.pas',
  LUX.GPU.OpenGL.Buffer in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\» OBJECT\LUX.GPU.OpenGL.Buffer.pas',
  LUX.GPU.OpenGL in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.pas',
  LUX.GPU.OpenGL.Scener in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Scener.pas',
  LUX.GPU.OpenGL.Shaper in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Shaper.pas',
  LUX.GPU.OpenGL.Camera in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Camera.pas',
  LUX.GPU.OpenGL.Matery in '_LIBRARY\LUXOPHIA\LUX.GPU.OpenGL\LUX.GPU.OpenGL.Matery.pas',
  LUX.Tree in '_LIBRARY\LUXOPHIA\LUX\LUX.Tree.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
