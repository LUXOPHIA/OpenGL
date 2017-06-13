unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.TabControl,
  Winapi.OpenGL, Winapi.OpenGLext,
  LUX, LUX.D1, LUX.D2, LUX.D3, LUX.M4,
  LUX.GPU.OpenGL,
  LUX.GPU.OpenGL.GLView,
  LUX.GPU.OpenGL.Buffer,
  LUX.GPU.OpenGL.Buffer.Unif,
  LUX.GPU.OpenGL.Buffer.Vert,
  LUX.GPU.OpenGL.Buffer.Elem,
  LUX.GPU.OpenGL.Imager,
  LUX.GPU.OpenGL.Imager.FMX,
  LUX.GPU.OpenGL.Shader,
  LUX.GPU.OpenGL.Engine,
  LUX.GPU.OpenGL.Geometry,
  LUX.GPU.OpenGL.Material,
  LUX.GPU.OpenGL.Material.FMX;

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
    _MouseS :TShiftState;
    _MouseP :TSingle2D;
    _MouseA :TSingle2D;
    ///// メソッド
    procedure EditShader( const Shader_:TGLShader; const Memo_:TMemo );
  public
    { public 宣言 }
    _World   :TGLWorld;
    _Shape   :TGLShape;
    _Materi  :TGLTexMateri;
    _Camera1 :TGLCamera;
    _Camera2 :TGLCamera;
    _Camera3 :TGLCamera;
    _Camera4 :TGLCamera;
    ///// メソッド
    procedure InitCamera;
    procedure InitEngine;
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

               with _Materi.Engine do
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
begin
     with _World.CameraUs do
     begin
          Count := 4;
     end;

     with _Camera1 do
     begin
          Proj := TSingleM4.ProjOrth( -2.5, +2.5, -2.5, +2.5, _N, _F );

          Move := TSingleM4.Translate( 0, +5, 0 )
                * TSingleM4.RotateX( DegToRad( -90 ) );
     end;

     with _Camera2 do
     begin
          Proj := TSingleM4.ProjOrth( -3, +3, -2, +2, _N, _F );

          Move := TSingleM4.RotateX( DegToRad( -45 ) )
                * TSingleM4.Translate( 0, 0, +5 );
     end;

     with _Camera3 do
     begin
          Proj := TSingleM4.ProjOrth( -3, +3, -1.5, +1.5, _N, _F );

          Move := TSingleM4.Translate( 0, 0, +5 );
     end;

     with _Camera4 do
     begin
          Proj := TSingleM4.ProjPers( -4/4*_N, +4/4*_N, -3/4*_N, +3/4*_N, _N, _F );

          Move := TSingleM4.RotateX( DegToRad( -45 ) )
                * TSingleM4.Translate( 0, -0.35, +3 );
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

//------------------------------------------------------------------------------

procedure TForm1.InitEngine;
begin
     with _Materi.Engine do
     begin
          with VerBufs do
          begin
               Add( 0{BinP}, '_Vertex_Pos'{Name}, 3{EleN}, GL_FLOAT{EleT} );
               Add( 1{BinP}, '_Vertex_Nor'{Name}, 3{EleN}, GL_FLOAT{EleT} );
               Add( 2{BinP}, '_Vertex_Tex'{Name}, 2{EleN}, GL_FLOAT{EleT} );
          end;

          with UniBufs do
          begin
               Add( 0{BinP}, 'TCamera'{Name} );
               Add( 1{BinP}, 'TGeomet'{Name} );
          end;

          with Imagers do
          begin
               Add( 0{BinP}, '_Imager'{Name} );
          end;

          with Framers do
          begin
               Add( 0{BinP}, '_Frag_Col'{Name} );
          end;

          OnLinked := procedure
          begin
               MemoSVE.Lines.Assign( _Materi.ShaderV.Errors );
               MemoSFE.Lines.Assign( _Materi.ShaderF.Errors );

               MemoP.Lines.Assign( Errors );
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _MouseS := [];
     _MouseP := TSingle2D.Create( 0, 0 );
     _MouseA := TSingle2D.Create( 0, 0 );

     _Materi := TGLTexMateri.Create;

     _Materi.Imager.LoadFromFile( '..\..\_DATA\Spherical_1024x1024.png' );

     _World := TGLWorld.Create;

     _World.GeometUs.Count := 5;

     _Shape := TGLShape.Create( _World );

     _Shape.Material := _Materi;

     _Shape.LoadFromFunc( BraidedTorus, 1300, 100 );

     _Camera1 := TGLCamera.Create( _World );  _Camera1._No := 0;
     _Camera2 := TGLCamera.Create( _World );  _Camera2._No := 1;
     _Camera3 := TGLCamera.Create( _World );  _Camera3._No := 2;
     _Camera4 := TGLCamera.Create( _World );  _Camera4._No := 3;

     GLView1.Camera := _Camera1;
     GLView2.Camera := _Camera2;
     GLView3.Camera := _Camera3;
     GLView4.Camera := _Camera4;

     //////////

     InitCamera;
     InitEngine;

     //////////

     with _Materi.ShaderV do
     begin
          Source.LoadFromFile( '..\..\_DATA\ShaderV.glsl' );

          MemoSVS.Lines.Assign( Source );
     end;

     with _Materi.ShaderF do
     begin
          Source.LoadFromFile( '..\..\_DATA\ShaderF.glsl' );

          MemoSFS.Lines.Assign( Source );
     end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _World.DisposeOf;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.MemoSVSChangeTracking(Sender: TObject);
begin
     EditShader( _Materi.ShaderV, MemoSVS );
end;

procedure TForm1.MemoSFSChangeTracking(Sender: TObject);
begin
     EditShader( _Materi.ShaderF, MemoSFS );
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

          _Shape.Move := TSingleM4.RotateX( DegToRad( _MouseA.Y ) )
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
