unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.TabControl,
  Winapi.OpenGL, Winapi.OpenGLext,
  LUX, LUX.D3, LUX.M4, LUX.GPU.OpenGL, LUX.GPU.OpenGL.GLView,
  LUX.GPU.OpenGL.Buffer, LUX.GPU.OpenGL.Shader, LUX.GPU.OpenGL.Progra;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
      TabItemV: TTabItem;
        Rectangle1: TRectangle;
          GLView1: TGLView;
          GLView2: TGLView;
        GLView3: TGLView;
        GLView4: TGLView;
        Timer1: TTimer;
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
    procedure Timer1Timer(Sender: TObject);
    procedure MemoSVSChangeTracking(Sender: TObject);
    procedure MemoSFSChangeTracking(Sender: TObject);
  private
    { private 宣言 }
    _Angle :Single;
    ///// メソッド
    procedure EditShader( const Proc_:TThreadProcedure );
  public type
    TCamera = record
    private
    public
      Proj :TSingleM4;
      Move :TSingleM4;
    end;
  public
    { public 宣言 }
    _CameraUs :TGLBufferU<TCamera>;
    _GeometUs :TGLBufferU<TSingleM4>;
    _GeometP  :TGLBufferVS<TSingle3D>;
    _GeometC  :TGLBufferVS<TAlphaColorF>;
    _GeometF  :TGLBufferI<TCardinal3D>;
    _GeometB  :TGLBinder;
    _ShaderV  :TGLShaderV;
    _ShaderF  :TGLShaderF;
    _Progra   :TGLProgra;
    ///// メソッド
    procedure InitCamera;
    procedure InitGeomet;
    procedure InitShader;
    procedure InitProgra;
    procedure DrawModel;
    procedure InitRender;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

uses System.Math;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

procedure TForm1.EditShader( const Proc_:TThreadProcedure );
begin
     TabItemV.Enabled := False;

     TIdleTask.Run( procedure
     begin
          Proc_;

          with _Progra do
          begin
               TabItemV.Enabled := Success;

               if not Success then TabControl1.TabIndex := 1;
          end;
     end );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.InitCamera;
const
     _N :Single = 0.1;
     _F :Single = 1000;
var
   C :TCamera;
begin
     with _CameraUs do
     begin
          Name  := 'TCamera';
          BindI := 0;
          Count := 4;

          with C do
          begin
               Proj := TSingleM4.ProjOrth( -3, +3, -2, +2, _N, _F );

               Move := TSingleM4.Translate( 0, +5, 0 )
                     * TSingleM4.RotateX( DegToRad( -90 ) );
          end;

          Items[ 0 ] := C;

          with C do
          begin
               Proj := TSingleM4.ProjOrth( -4, +4, -2, +2, _N, _F );

               Move := TSingleM4.Translate( 0, 0, +5 );
          end;

          Items[ 1 ] := C;

          with C do
          begin
               Proj := TSingleM4.ProjOrth( -3, +3, -3, +3, _N, _F );

               Move := TSingleM4.Translate( -5, 0, 0 )
                     * TSingleM4.RotateY( DegToRad( -90 ) );
          end;

          Items[ 2 ] := C;

          with C do
          begin
               Proj := TSingleM4.ProjPers( -4/8*_N, +4/8*_N, -3/8*_N, +3/8*_N, _N, _F );

               Move := TSingleM4.RotateY( DegToRad( +30 ) )
                     * TSingleM4.RotateX( DegToRad( -30 ) )
                     * TSingleM4.Translate( 0, 0, +8 );
          end;

          Items[ 3 ] := C;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitGeomet;
const
     Ps :array [ 0..8-1 ] of TSingle3D = (
          ( X:-1; Y:-1; Z:-1 ),
          ( X:+1; Y:-1; Z:-1 ),
          ( X:-1; Y:+1; Z:-1 ),
          ( X:+1; Y:+1; Z:-1 ),
          ( X:-1; Y:-1; Z:+1 ),
          ( X:+1; Y:-1; Z:+1 ),
          ( X:-1; Y:+1; Z:+1 ),
          ( X:+1; Y:+1; Z:+1 ) );
     Cs :array [ 0..8-1 ] of TAlphaColorF = (
          ( R:0; G:0; B:0; A:1 ),
          ( R:1; G:0; B:0; A:1 ),
          ( R:0; G:1; B:0; A:1 ),
          ( R:1; G:1; B:0; A:1 ),
          ( R:0; G:0; B:1; A:1 ),
          ( R:1; G:0; B:1; A:1 ),
          ( R:0; G:1; B:1; A:1 ),
          ( R:1; G:1; B:1; A:1 ) );
     Fs :array [ 0..12-1 ] of TCardinal3D = (
          ( A:0; B:4; C:6 ), ( A:6; B:2; C:0 ),
          ( A:0; B:1; C:5 ), ( A:5; B:4; C:0 ),
          ( A:0; B:2; C:3 ), ( A:3; B:1; C:0 ),
          ( A:7; B:5; C:1 ), ( A:1; B:3; C:7 ),
          ( A:7; B:3; C:2 ), ( A:2; B:6; C:7 ),
          ( A:7; B:6; C:4 ), ( A:4; B:5; C:7 ) );
begin
     //    2-------3
     //   /|      /|
     //  6-------7 |
     //  | |     | |
     //  | 0-----|-1
     //  |/      |/
     //  4-------5

     with _GeometP do
     begin
          Name  := '_Vertex_Pos';

          Import( Ps );
     end;

     with _GeometC do
     begin
          Name  := '_Vertex_Col';

          Import( Cs );
     end;

     with _GeometF do
     begin
          Import( Fs );
     end;

     with _GeometUs do
     begin
          Name  := 'TGeomet';
          BindI := 1;
          Count := 1;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitShader;
begin
     with _ShaderV do
     begin
          OnCompiled := procedure
          begin
               MemoSVE.Lines.Assign( Error );

               _Progra.Link;
          end;
     end;

     with _ShaderF do
     begin
          OnCompiled := procedure
          begin
               MemoSFE.Lines.Assign( Error );

               _Progra.Link;
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitProgra;
begin
     with _Progra do
     begin
          Frags.Add( 0, '_FragColor' );

          Attach( _ShaderV );
          Attach( _ShaderF );

          OnLinked := procedure
          begin
               MemoP.Lines.Assign( Error );

               Attach( _CameraUs );
               Attach( _GeometUs );

               Attach( _GeometP );
               Attach( _GeometC );

               with _GeometB do
               begin
                    Use;

                      _GeometP.Use;
                      _GeometC.Use;

                      _GeometF.Bind;

                    Unuse;
               end;
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.DrawModel;
begin
     _Progra.Use;

       _GeometUs.Use;

         _GeometB.Use;

           _GeometF.Draw;

         _GeometB.Unuse;

       _GeometUs.Unuse;

     _Progra.Unuse;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitRender;
begin
     GLView1.OnPaint := procedure
     begin
          with _CameraUs do
          begin
               Use( 0 );
                 DrawModel;
               Unuse;
          end;
     end;

     GLView2.OnPaint := procedure
     begin
          with _CameraUs do
          begin
               Use( 1 );
                 DrawModel;
               Unuse;
          end;
     end;

     GLView3.OnPaint := procedure
     begin
          with _CameraUs do
          begin
               Use( 2 );
                 DrawModel;
               Unuse;
          end;
     end;

     GLView4.OnPaint := procedure
     begin
          with _CameraUs do
          begin
               Use( 3 );
                 DrawModel;
               Unuse;
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _CameraUs := TGLBufferU<TCamera>      .Create( GL_STATIC_DRAW );

     _GeometUs := TGLBufferU<TSingleM4>    .Create( GL_DYNAMIC_DRAW );

     _GeometP  := TGLBufferVS<TSingle3D>   .Create( GL_STATIC_DRAW );
     _GeometC  := TGLBufferVS<TAlphaColorF>.Create( GL_STATIC_DRAW );
     _GeometF  := TGLBufferI<TCardinal3D>  .Create( GL_STATIC_DRAW );
     _GeometB  := TGLBinder                .Create;

     _ShaderV  := TGLShaderV               .Create;
     _ShaderF  := TGLShaderF               .Create;

     _Progra   := TGLProgra                .Create;

     //////////

     InitCamera;
     InitGeomet;
     InitShader;
     InitProgra;
     InitRender;

     //////////

     with _ShaderV do
     begin
          Source.LoadFromFile( '..\..\_DATA\ShaderV.glsl' );

          MemoSVS.Lines.Assign( Source );
     end;

     with _ShaderF do
     begin
          Source.LoadFromFile( '..\..\_DATA\ShaderF.glsl' );

          MemoSFS.Lines.Assign( Source );
     end;

     //////////

     _Angle := 0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Progra  .DisposeOf;

     _ShaderV .DisposeOf;
     _ShaderF .DisposeOf;

     _GeometP .DisposeOf;
     _GeometC .DisposeOf;
     _GeometF .DisposeOf;
     _GeometB .DisposeOf;

     _GeometUs.DisposeOf;

     _CameraUs.DisposeOf;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     _Angle := _Angle + 1;

     _GeometUs.Items[ 0 ] := TSingleM4.RotateY( DegToRad( _Angle ) );

     GLView1.Repaint;
     GLView2.Repaint;
     GLView3.Repaint;
     GLView4.Repaint;
end;

//------------------------------------------------------------------------------

procedure TForm1.MemoSVSChangeTracking(Sender: TObject);
begin
     EditShader( procedure
     begin
          _ShaderV.Source.Assign( MemoSVS.Lines );
     end );
end;

procedure TForm1.MemoSFSChangeTracking(Sender: TObject);
begin
     EditShader( procedure
     begin
          _ShaderF.Source.Assign( MemoSFS.Lines );
     end );
end;

end. //######################################################################### ■
