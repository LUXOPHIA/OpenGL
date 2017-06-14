unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.TabControl,
  Winapi.OpenGL, Winapi.OpenGLext,
  LUX, LUX.D1, LUX.D2, LUX.D3, LUX.M4,
  LUX.GPU.OpenGL.GLView, LUX.GPU.OpenGL.Shader,
  MYX.Camera,
  MYX.Shaper,
  MYX.Matery;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
      TabItemV: TTabItem;
        Rectangle1: TRectangle;
          GLView1: TGLView;
          GLView2: TGLView;
        Rectangle2: TRectangle;
          GLView3: TGLView;
          GLView4: TGLView;
      TabItemS: TTabItem;
        TabControlS: TTabControl;
          TabItemSV: TTabItem;
            MemoSVS: TMemo;
            SplitterSV: TSplitter;
            MemoSVE: TMemo;
          TabItemSF: TTabItem;
            MemoSFS: TMemo;
            SplitterSF: TSplitter;
            MemoSFE: TMemo;
      TabItemP: TTabItem;
        MemoP: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MemoSVSChangeTracking(Sender: TObject);
    procedure MemoSFSChangeTracking(Sender: TObject);
    procedure GLView4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure GLView4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure GLView4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  private
    { private 宣言 }
    _MouseA :TSingle2D;
    _MouseS :TShiftState;
    _MouseP :TSingle2D;
    ///// メソッド
    procedure EditShader( const Shader_:TGLShader; const Memo_:TMemo );
  public
    { public 宣言 }
    _Camera1 :TMyCamera;
    _Camera2 :TMyCamera;
    _Camera3 :TMyCamera;
    _Camera4 :TMyCamera;
    _Shaper  :TMyShaper;
    _Matery  :TMyMatery;
    ///// メソッド
    procedure InitCamera;
    procedure InitShaper;
    procedure InitMatery;
    procedure InitViewer;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

uses System.Math;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.EditShader( const Shader_:TGLShader; const Memo_:TMemo );
begin
     if Memo_.IsFocused then
     begin
          TabItemV.Enabled := False;

          TIdleTask.Run( procedure
          begin
               Shader_.Source.Assign( Memo_.Lines );

               with _Matery.Engine do
               begin
                    TabItemV.Enabled := Status;

                    if not Status then TabControl1.TabIndex := 1;
               end;
          end );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.InitCamera;
const
     _N :Single = 0.1;
     _F :Single = 1000;
var
   C :TMyCameraData;
begin
     with C do
     begin
          Proj := TSingleM4.ProjOrth( -2.5, +2.5, -2.5, +2.5, _N, _F );

          Pose := TSingleM4.Translate( 0, +5, 0 )
                * TSingleM4.RotateX( DegToRad( -90 ) );
     end;

     _Camera1.Data := C;

     with C do
     begin
          Proj := TSingleM4.ProjOrth( -2, +2, -2, +2, _N, _F );

          Pose := TSingleM4.RotateX( DegToRad( -45 ) )
                * TSingleM4.Translate( 0, 0, +5 );
     end;

     _Camera2.Data := C;

     with C do
     begin
          Proj := TSingleM4.ProjOrth( -1.5, +1.5, -1.5, +1.5, _N, _F );

          Pose := TSingleM4.Translate( 0, 0, +5 );
     end;

     _Camera3.Data := C;

     with C do
     begin
          Proj := TSingleM4.ProjPers( -_N/2, +_N/2, -_N/2, +_N/2, _N, _F );

          Pose := TSingleM4.RotateX( DegToRad( -45 ) )
                * TSingleM4.Translate( 0, 0, +4 );
     end;

     _Camera4.Data := C;
end;

//------------------------------------------------------------------------------

function BraidedTorus( const T_:TdSingle2D ) :TdSingle3D;
const
     LoopR :Single = 1.0;  LoopN :Integer = 3; 
     TwisR :Single = 0.5;  TwisN :Integer = 5;
     PipeR :Single = 0.3;
var
   T :TdSingle2D;
   cL, cT, cP, TX, PX, R,
   sL, sT, sP, TY, PY, H :TdSingle;
begin
     T := Pi2 * T_;

     CosSin( LoopN * T.U, cL, sL );
     CosSin( TwisN * T.U, cT, sT );
     CosSin(         T.V, cP, sP );

     TX := TwisR * cT;  PX := PipeR * cP;
     TY := TwisR * sT;  PY := PipeR * sP;

     R := LoopR * ( 1 + TX ) + PX  ;
     H := LoopR * (     TY   + PY );

     with Result do
     begin
          X := R * cL;
          Y := H     ;
          Z := R * sL;
     end;
end;

procedure TForm1.InitShaper;
var
   S :TMyShaperData;
begin
     with _Shaper do
     begin
          LoadFormFunc( BraidedTorus, 1300, 100 );

          with S do
          begin
               Pose := TSingleM4.Identify;
          end;

          Data := S;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitMatery;
begin
     with _Matery do
     begin
          with ShaderV do
          begin
               OnCompiled := procedure
               begin
                    MemoSVE.Lines.Assign( Errors );

                    _Matery.Engine.Link;
               end;

               Source.LoadFromFile( '..\..\_DATA\ShaderV.glsl' );

               MemoSVS.Lines.Assign( Source );
          end;

          with ShaderF do
          begin
               OnCompiled := procedure
               begin
                    MemoSFE.Lines.Assign( Errors );

                    _Matery.Engine.Link;
               end;

               Source.LoadFromFile( '..\..\_DATA\ShaderF.glsl' );

               MemoSFS.Lines.Assign( Source );
          end;

          with Engine do
          begin
               OnLinked := procedure
               begin
                    MemoP.Lines.Assign( Errors );
               end;
          end;

          Imager.LoadFromFile( '..\..\_DATA\Spherical_1024x1024.png' );
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitViewer;
begin
     GLView1.OnPaint := procedure
     begin
          _Camera1.Use;
          _Matery .Use;
          _Shaper .Draw;
     end;

     GLView2.OnPaint := procedure
     begin
          _Camera2.Use;
          _Matery .Use;
          _Shaper .Draw;
     end;

     GLView3.OnPaint := procedure
     begin
          _Camera3.Use;
          _Matery .Use;
          _Shaper .Draw;
     end;

     GLView4.OnPaint := procedure
     begin
          _Camera4.Use;
          _Matery .Use;
          _Shaper .Draw;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _MouseA := TSingle2D.Create( 0, 0 );
     _MouseS := [];

     _Camera1 := TMyCamera.Create;
     _Camera2 := TMyCamera.Create;
     _Camera3 := TMyCamera.Create;
     _Camera4 := TMyCamera.Create;
     _Shaper  := TMyShaper.Create;
     _Matery  := TMyMatery.Create;

     InitCamera;
     InitShaper;
     InitMatery;
     InitViewer;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Camera1.DisposeOf;
     _Camera2.DisposeOf;
     _Camera3.DisposeOf;
     _Camera4.DisposeOf;
     _Shaper .DisposeOf;
     _Matery .DisposeOf;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.MemoSVSChangeTracking(Sender: TObject);
begin
     EditShader( _Matery.ShaderV, MemoSVS );
end;

procedure TForm1.MemoSFSChangeTracking(Sender: TObject);
begin
     EditShader( _Matery.ShaderF, MemoSFS );
end;

//------------------------------------------------------------------------------

procedure TForm1.GLView4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
     _MouseS := Shift;
     _MouseP := TSingle2D.Create( X, Y );
end;

procedure TForm1.GLView4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
var
   P :TSingle2D;
   S :TMyShaperData;
begin
     if ssLeft in _MouseS then
     begin
          P := TSingle2D.Create( X, Y );

          _MouseA := _MouseA + ( P - _MouseP );

          with S do
          begin
               Pose := TSingleM4.RotateX( DegToRad( _MouseA.Y ) )
                     * TSingleM4.RotateY( DegToRad( _MouseA.X ) );
          end;

          _Shaper.Data := S;

          GLView1.Repaint;
          GLView2.Repaint;
          GLView3.Repaint;
          GLView4.Repaint;

          _MouseP := P;
     end;
end;

procedure TForm1.GLView4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
     GLView4MouseMove( Sender, Shift, X, Y );

     _MouseS := [];
end;

end. //######################################################################### ■
