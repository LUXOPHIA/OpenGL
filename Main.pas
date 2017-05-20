unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.TabControl,
  Winapi.OpenGL, Winapi.OpenGLext,
  LUX, LUX.D3, LUX.M4,
  LUX.GPU.OpenGL,
  LUX.GPU.OpenGL.GLView,
  LUX.GPU.OpenGL.Buffer,
  LUX.GPU.OpenGL.Buffer.Unif,
  LUX.GPU.OpenGL.Buffer.Vert,
  LUX.GPU.OpenGL.Buffer.Elem,
  LUX.GPU.OpenGL.Pluger,
  LUX.GPU.OpenGL.Shader,
  LUX.GPU.OpenGL.Engine;

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
    procedure EditShader( const Shader_:TGLShader; const Memo_:TMemo );
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
    _GeometP  :TGLBufferVS<TSingle3D>;
    _GeometC  :TGLBufferVS<TAlphaColorF>;
    _GeometF  :TGLBufferI<TCardinal3D>;
    _GeometUs :TGLBufferU<TSingleM4>;
    _PlugerV  :TGLPlugerV;
    _PlugerU1 :TGLPlugerU;
    _PlugerU2 :TGLPlugerU;
    _PlugerU3 :TGLPlugerU;
    _PlugerU4 :TGLPlugerU;
    _ShaderV  :TGLShaderV;
    _ShaderF  :TGLShaderF;
    _Engine   :TGLEngine;
    ///// メソッド
    procedure InitCamera;
    procedure InitGeomet;
    procedure InitPluger;
    procedure InitShader;
    procedure InitEngine;
    procedure DrawModel;
    procedure InitRender;
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

               with _Engine do
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
   C :TCamera;
begin
     with _CameraUs do
     begin
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
          ( X:-1; Y:-1; Z:-1 ), ( X:+1; Y:-1; Z:-1 ),
          ( X:-1; Y:+1; Z:-1 ), ( X:+1; Y:+1; Z:-1 ),
          ( X:-1; Y:-1; Z:+1 ), ( X:+1; Y:-1; Z:+1 ),
          ( X:-1; Y:+1; Z:+1 ), ( X:+1; Y:+1; Z:+1 ) );
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
          Import( Ps );
     end;

     with _GeometC do
     begin
          Count := 8{Poin};

          Items[ 0 ] := TAlphaColorF.Create( 0, 0, 0 );
          Items[ 1 ] := TAlphaColorF.Create( 1, 0, 0 );
          Items[ 2 ] := TAlphaColorF.Create( 0, 1, 0 );
          Items[ 3 ] := TAlphaColorF.Create( 1, 1, 0 );
          Items[ 4 ] := TAlphaColorF.Create( 0, 0, 1 );
          Items[ 5 ] := TAlphaColorF.Create( 1, 0, 1 );
          Items[ 6 ] := TAlphaColorF.Create( 0, 1, 1 );
          Items[ 7 ] := TAlphaColorF.Create( 1, 1, 1 );
     end;

     with _GeometF do
     begin
          Count := 12{Face};

          with Map( GL_WRITE_ONLY ) do
          begin
               Items[  0 ] := TCardinal3D.Create( 0, 4, 6 );
               Items[  1 ] := TCardinal3D.Create( 6, 2, 0 );
               Items[  2 ] := TCardinal3D.Create( 0, 1, 5 );
               Items[  3 ] := TCardinal3D.Create( 5, 4, 0 );
               Items[  4 ] := TCardinal3D.Create( 0, 2, 3 );
               Items[  5 ] := TCardinal3D.Create( 3, 1, 0 );
               Items[  6 ] := TCardinal3D.Create( 7, 5, 1 );
               Items[  7 ] := TCardinal3D.Create( 1, 3, 7 );
               Items[  8 ] := TCardinal3D.Create( 7, 3, 2 );
               Items[  9 ] := TCardinal3D.Create( 2, 6, 7 );
               Items[ 10 ] := TCardinal3D.Create( 7, 6, 4 );
               Items[ 11 ] := TCardinal3D.Create( 4, 5, 7 );
          end;

          Unmap;
     end;

     with _GeometUs do
     begin
          Count := 1{Pose};
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitPluger;
begin
     with _PlugerV do
     begin
          Add( 0{Port}, _GeometP );
          Add( 1{Port}, _GeometC );
     end;

     with _PlugerU1 do
     begin
          Add( 0{Port}, _CameraUs, 0{Offs} );
          Add( 1{Port}, _GeometUs          );
     end;

     with _PlugerU2 do
     begin
          Add( 0{Port}, _CameraUs, 1{Offs} );
          Add( 1{Port}, _GeometUs          );
     end;

     with _PlugerU3 do
     begin
          Add( 0{Port}, _CameraUs, 2{Offs} );
          Add( 1{Port}, _GeometUs          );
     end;

     with _PlugerU4 do
     begin
          Add( 0{Port}, _CameraUs, 3{Offs} );
          Add( 1{Port}, _GeometUs          );
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitShader;
begin
     with _ShaderV do
     begin
          OnCompiled := procedure
          begin
               MemoSVE.Lines.Assign( Errors );

               _Engine.Link;
          end;
     end;

     with _ShaderF do
     begin
          OnCompiled := procedure
          begin
               MemoSFE.Lines.Assign( Errors );

               _Engine.Link;
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitEngine;
begin
     with _Engine do
     begin
          with Shaders do
          begin
               Add( _ShaderV );
               Add( _ShaderF );
          end;

          with VerPorts do
          begin
               Add( 0{Port}, '_Vertex_Pos', 3, GL_FLOAT, 0 );
               Add( 1{Port}, '_Vertex_Col', 4, GL_FLOAT, 0 );
          end;

          with UniPorts do
          begin
               Add( 0{Port}, 'TCamera' );
               Add( 1{Port}, 'TGeomet' );
          end;

          with FraPorts do
          begin
               Add( 0{Port}, '_FragColor' );
          end;

          OnLinked := procedure
          begin
               MemoP.Lines.Assign( Errors );
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.DrawModel;
begin
     with _Engine do
     begin
          Use;

          with _PlugerV do  // TGLEngine needs to be used before TGLPulgerV.
          begin
               Use;

                 _GeometF.Draw;

               Unuse;
          end;

          Unuse;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitRender;
begin
     GLView1.OnPaint := procedure
     begin
          with _PlugerU1 do
          begin
               Use;
                 DrawModel;
               Unuse;
          end;
     end;

     GLView2.OnPaint := procedure
     begin
          with _PlugerU2 do
          begin
               Use;
                 DrawModel;
               Unuse;
          end;
     end;

     GLView3.OnPaint := procedure
     begin
          with _PlugerU3 do
          begin
               Use;
                 DrawModel;
               Unuse;
          end;
     end;

     GLView4.OnPaint := procedure
     begin
          with _PlugerU4 do
          begin
               Use;
                 DrawModel;
               Unuse;
          end;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _CameraUs := TGLBufferU<TCamera>      .Create( GL_STATIC_DRAW  );

     _GeometP  := TGLBufferVS<TSingle3D>   .Create( GL_STATIC_DRAW  );
     _GeometC  := TGLBufferVS<TAlphaColorF>.Create( GL_STATIC_DRAW  );
     _GeometF  := TGLBufferI<TCardinal3D>  .Create( GL_STATIC_DRAW  );
     _GeometUs := TGLBufferU<TSingleM4>    .Create( GL_DYNAMIC_DRAW );

     _PlugerV  := TGLPlugerV               .Create;

     _PlugerU1 := TGLPlugerU               .Create;
     _PlugerU2 := TGLPlugerU               .Create;
     _PlugerU3 := TGLPlugerU               .Create;
     _PlugerU4 := TGLPlugerU               .Create;

     _ShaderV  := TGLShaderV               .Create;
     _ShaderF  := TGLShaderF               .Create;

     _Engine   := TGLEngine                .Create;

     //////////

     InitCamera;
     InitGeomet;
     InitPluger;
     InitShader;
     InitEngine;
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
     _Engine  .DisposeOf;

     _ShaderV .DisposeOf;
     _ShaderF .DisposeOf;

     _PlugerU1.DisposeOf;
     _PlugerU2.DisposeOf;
     _PlugerU3.DisposeOf;
     _PlugerU4.DisposeOf;

     _PlugerV .DisposeOf;

     _GeometP .DisposeOf;
     _GeometC .DisposeOf;
     _GeometF .DisposeOf;
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
     EditShader( _ShaderV, MemoSVS );
end;

procedure TForm1.MemoSFSChangeTracking(Sender: TObject);
begin
     EditShader( _ShaderF, MemoSFS );
end;

end. //######################################################################### ■
