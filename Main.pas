﻿unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.TabControl,
  Winapi.OpenGL, Winapi.OpenGLext,
  LUX, LUX.D1, LUX.D2, LUX.D3, LUX.M4,
  LUX.GPU.OpenGL,
  LUX.GPU.OpenGL.GLView,
  LUX.GPU.OpenGL.Shader,
  LUX.GPU.OpenGL.Scener,
  LUX.GPU.OpenGL.Camera,
  LUX.GPU.OpenGL.Shaper,
  LUX.GPU.OpenGL.Matery.FMX;

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
    _Scener  :TGLScener;
    _Shaper  :TGLShaperPoly;
    _Matery  :IGLMateryImag;
    _Camera1 :TGLCameraOrth;
    _Camera2 :TGLCameraOrth;
    _Camera3 :TGLCameraOrth;
    _Camera4 :TGLCameraPers;
    ///// メソッド
    procedure MakeCamera;
    procedure MakeMatery;
    procedure MakeShaper;
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

procedure TForm1.MakeCamera;
begin
     _Camera1 := TGLCameraOrth.Create( _Scener );
     _Camera2 := TGLCameraOrth.Create( _Scener );
     _Camera3 := TGLCameraOrth.Create( _Scener );
     _Camera4 := TGLCameraPers.Create( _Scener );

     with _Camera1 do
     begin
          Size := 5;

          Pose := TSingleM4.Translate( 0, +5, 0 )
                * TSingleM4.RotateX( DegToRad( -90 ) );
     end;

     with _Camera2 do
     begin
          Size := 4;

          Pose := TSingleM4.RotateX( DegToRad( -45 ) )
                * TSingleM4.Translate( 0, 0, +5 );
     end;

     with _Camera3 do
     begin
          Size := 3;

          Pose := TSingleM4.Translate( 0, 0, +5 );
     end;

     with _Camera4 do
     begin
          Angl := DegToRad( 60{°} );

          Pose := TSingleM4.RotateX( DegToRad( -45 ) )
                * TSingleM4.Translate( 0, 0, +3 );
     end;

     GLView1.Camera := _Camera1;
     GLView2.Camera := _Camera2;
     GLView3.Camera := _Camera3;
     GLView4.Camera := _Camera4;
end;

//------------------------------------------------------------------------------

procedure TForm1.MakeMatery;
begin
     _Matery := TGLMateryImag.Create;

     with _Matery do
     begin
          with ShaderV do
          begin
               Source.LoadFromFile( '..\..\_DATA\ShaderV.glsl' );

               MemoSVS.Lines.Assign( Source );
          end;

          with ShaderF do
          begin
               Source.LoadFromFile( '..\..\_DATA\ShaderF.glsl' );

               MemoSFS.Lines.Assign( Source );
          end;

          Imager.LoadFromFile( '..\..\_DATA\Spherical_1024x1024.png' );

          OnBuilded := procedure
          begin
               MemoSVE.Lines.Assign( ShaderV.Errors );
               MemoSFE.Lines.Assign( ShaderF.Errors );
               MemoP  .Lines.Assign( Engine .Errors );
          end;
     end;
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

procedure TForm1.MakeShaper;
begin
     _Shaper := TGLShaperPoly.Create( _Scener );

     with _Shaper do
     begin
          LoadFromFunc( BraidedTorus, 1300, 100 );

          Matery := _Matery;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _MouseS := [];
     _MouseP := TSingle2D.Create( 0, 0 );
     _MouseA := TSingle2D.Create( 0, 0 );

     _Scener := TGLScener.Create;

     MakeCamera;
     MakeMatery;
     MakeShaper;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Scener.DisposeOf;
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
begin
     if ssLeft in _MouseS then
     begin
          P := TSingle2D.Create( X, Y );

          _MouseA := _MouseA + ( P - _MouseP );

          _Shaper.Pose := TSingleM4.RotateX( DegToRad( _MouseA.Y ) )
                        * TSingleM4.RotateY( DegToRad( _MouseA.X ) );

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
