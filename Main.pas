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
  LUX.GPU.OpenGL.Engine;

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
    _GeometN  :TGLBufferVS<TSingle3D>;
    _GeometT  :TGLBufferVS<TSingle2D>;
    _GeometE  :TGLBufferE32;
    _GeometUs :TGLBufferU<TSingleM4>;
    _Sample   :TGLSample;
    _Imager   :TGLImager2D_RGBA;
    _ShaderV  :TGLShaderV;
    _ShaderF  :TGLShaderF;
    _Engine   :TGLEngine;
    ///// メソッド
    procedure InitCamera;
    procedure InitGeomet;
    procedure InitImager;
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
               Proj := TSingleM4.ProjOrth( -2.5, +2.5, -2.5, +2.5, _N, _F );

               Move := TSingleM4.Translate( 0, +5, 0 )
                     * TSingleM4.RotateX( DegToRad( -90 ) );
          end;

          Items[ 0 ] := C;

          with C do
          begin
               Proj := TSingleM4.ProjOrth( -3, +3, -2, +2, _N, _F );

               Move := TSingleM4.RotateX( DegToRad( -45 ) )
                     * TSingleM4.Translate( 0, 0, +5 );
          end;

          Items[ 1 ] := C;

          with C do
          begin
               Proj := TSingleM4.ProjOrth( -3, +3, -1.5, +1.5, _N, _F );

               Move := TSingleM4.Translate( 0, 0, +5 );
          end;

          Items[ 2 ] := C;

          with C do
          begin
               Proj := TSingleM4.ProjPers( -4/4*_N, +4/4*_N, -3/4*_N, +3/4*_N, _N, _F );

               Move := TSingleM4.RotateX( DegToRad( -45 ) )
                     * TSingleM4.Translate( 0, -0.35, +3 );
          end;

          Items[ 3 ] := C;
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

procedure TForm1.InitGeomet;
const
     DivX :Integer = 1300;
     DivY :Integer =  100;
//·························
     function XYtoI( const X_,Y_:Integer ) :Integer;
     begin
          Result := ( DivX + 1 ) * Y_ + X_;
     end;
     //····················
     procedure MakeVerts;
     var
        C, X, Y, I :Integer;
        Ps, Ns :TGLBufferData<TSingle3D>;
        Ts :TGLBufferData<TSingle2D>;
        T :TSingle2D;
        M :TSingleM4;
     begin
          C := ( DivY + 1 ) * ( DivX + 1 );

          _GeometP.Count := C;
          _GeometN.Count := C;
          _GeometT.Count := C;

          Ps := _GeometP.Map( GL_WRITE_ONLY );
          Ns := _GeometN.Map( GL_WRITE_ONLY );
          Ts := _GeometT.Map( GL_WRITE_ONLY );

          for Y := 0 to DivY do
          begin
               T.V := Y / DivY;
               for X := 0 to DivX do
               begin
                    T.U := X / DivX;

                    I := XYtoI( X, Y );

                    Ts[ I ] := T;

                    M := Tensor( T, BraidedTorus );

                    Ps[ I ] := M.AxisP;
                    Ns[ I ] := M.AxisZ;
               end;
          end;

          _GeometP.Unmap;
          _GeometN.Unmap;
          _GeometT.Unmap;
     end;
     //····················
     procedure MakeElems;
     var
        X0, Y0, X1, Y1, I, I00, I01, I10, I11 :Integer;
        Es :TGLBufferData<TCardinal3D>;
     begin
          _GeometE.Count := 2 * DivY * DivX;

          Es := _GeometE.Map( GL_WRITE_ONLY );

          I := 0;
          for Y0 := 0 to DivY-1 do
          begin
               Y1 := Y0 + 1;
               for X0 := 0 to DivX-1 do
               begin
                    X1 := X0 + 1;

                    I00 := XYtoI( X0, Y0 );  I01 := XYtoI( X1, Y0 );
                    I10 := XYtoI( X0, Y1 );  I11 := XYtoI( X1, Y1 );

                    //  00───01
                    //  │      │
                    //  │      │
                    //  │      │
                    //  10───11

                    Es[ I ] := TCardinal3D.Create( I00, I10, I11 );  Inc( I );
                    Es[ I ] := TCardinal3D.Create( I11, I01, I00 );  Inc( I );
               end;
          end;

          _GeometE.Unmap;
     end;
//·························
begin
     MakeVerts;
     MakeElems;

     with _GeometUs do
     begin
          Count := 1{Pose};
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitImager;
begin
     _Imager.LoadFromFile( '..\..\_DATA\Spherical_1024x1024.png' );
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
               Add( _ShaderV{Shad} );
               Add( _ShaderF{Shad} );
          end;

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
               MemoP.Lines.Assign( Errors );
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.DrawModel;
begin
     _GeometUs.Use( 1{BinP}, 0{Offs} );

       _Sample.Use( 0{BinP} );
       _Imager.Use( 0{BinP} );

         _Engine.Use;

           _GeometP.Use( 0{BinP} );
           _GeometN.Use( 1{BinP} );
           _GeometT.Use( 2{BinP} );

             _GeometE.Draw;

           _GeometP.Unuse( 0{BinP} );
           _GeometN.Unuse( 1{BinP} );
           _GeometT.Unuse( 2{BinP} );

         _Engine.Unuse;

       _Sample.Unuse( 0{BinP} );
       _Imager.Unuse( 0{BinP} );

     _GeometUs.Unuse( 1{BinP} );
end;

//------------------------------------------------------------------------------

procedure TForm1.InitRender;
begin
     GLView1.OnPaint := procedure
     begin
          _CameraUs.Use( 0{BinP}, 0{Offs} );

            DrawModel;

          _CameraUs.Unuse( 0{BinP} );
     end;

     GLView2.OnPaint := procedure
     begin
          _CameraUs.Use( 0{BinP}, 1{Offs} );

            DrawModel;

          _CameraUs.Unuse( 0{BinP} );
     end;

     GLView3.OnPaint := procedure
     begin
          _CameraUs.Use( 0{BinP}, 2{Offs} );

            DrawModel;

          _CameraUs.Unuse( 0{BinP} );
     end;

     GLView4.OnPaint := procedure
     begin
          _CameraUs.Use( 0{BinP}, 3{Offs} );

            DrawModel;

          _CameraUs.Unuse( 0{BinP} );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _CameraUs := TGLBufferU<TCamera>   .Create( GL_STATIC_DRAW  );

     _GeometP  := TGLBufferVS<TSingle3D>.Create( GL_STATIC_DRAW  );
     _GeometN  := TGLBufferVS<TSingle3D>.Create( GL_STATIC_DRAW  );
     _GeometT  := TGLBufferVS<TSingle2D>.Create( GL_STATIC_DRAW  );
     _GeometE  := TGLBufferE32          .Create( GL_STATIC_DRAW  );
     _GeometUs := TGLBufferU<TSingleM4> .Create( GL_DYNAMIC_DRAW );

     _Sample   := TGLSample             .Create;
     _Imager   := TGLImager2D_RGBA      .Create;

     _ShaderV  := TGLShaderV            .Create;
     _ShaderF  := TGLShaderF            .Create;

     _Engine   := TGLEngine             .Create;

     //////////

     InitCamera;
     InitGeomet;
     InitImager;
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

     _Sample  .DisposeOf;
     _Imager  .DisposeOf;

     _GeometP .DisposeOf;
     _GeometN .DisposeOf;
     _GeometT .DisposeOf;
     _GeometE .DisposeOf;
     _GeometUs.DisposeOf;

     _CameraUs.DisposeOf;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     _Angle := _Angle + 1;

     _GeometUs[ 0 ] := TSingleM4.RotateY( DegToRad( _Angle ) );

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
