unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  Winapi.OpenGL, Winapi.OpenGLext,
  LUX, LUX.D3,
  LUX.GPU.OpenGL,
  LUX.GPU.OpenGL.Viewer,
  LUX.GPU.OpenGL.Atom.Buffer,
  LUX.GPU.OpenGL.Atom.Buffer.VerBuf,
  LUX.GPU.OpenGL.Atom.Buffer.EleBuf;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
      GLViewer1: TGLViewer;
      GLViewer2: TGLViewer;
    Panel2: TPanel;
      GLViewer3: TGLViewer;
      GLViewer4: TGLViewer;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure GLViewer1DblClick(Sender: TObject);
    procedure GLViewer2DblClick(Sender: TObject);
    procedure GLViewer3DblClick(Sender: TObject);
    procedure GLViewer4DblClick(Sender: TObject);
  private
    { private 宣言 }
    _Angle :Single;
  public
    { public 宣言 }
    _VerBufP :TGLVerBufS<TSingle3D>;
    _VerBufC :TGLVerBufS<TAlphaColorF>;
    _EleBuf  :TGLEleBufFace32;
    ///// メソッド
    procedure InitViewer;
    procedure InitShaper;
    procedure DrawShaper;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.InitViewer;
const
     _N :Single = 0.1;
     _F :Single = 1000;
begin
     GLViewer1.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -2, +2, -2, +2, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( +90, 1, 0, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawShaper;
     end;

     GLViewer2.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -2, +2, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( +30, 1, 0, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawShaper;
     end;

     GLViewer3.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -1.5, +1.5, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawShaper;
     end;

     GLViewer4.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glFrustum( -4/4*_N, +4/4*_N,
                       -3/4*_N, +3/4*_N, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, +0.3, 0 );
            glTranslatef( 0, 0, -3 );
            glRotatef( +30, 1, 0, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawShaper;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitShaper;
const
     Ps :array [ 0..8-1 ] of TSingle3D
           = ( ( X:-1; Y:-1; Z:-1 ), ( X:+1; Y:-1; Z:-1 ),
               ( X:-1; Y:+1; Z:-1 ), ( X:+1; Y:+1; Z:-1 ),
               ( X:-1; Y:-1; Z:+1 ), ( X:+1; Y:-1; Z:+1 ),
               ( X:-1; Y:+1; Z:+1 ), ( X:+1; Y:+1; Z:+1 ) );
     Cs :array [ 0..8-1 ] of TAlphaColorF
           = ( ( R:0; G:0; B:0; A:1 ), ( R:1; G:0; B:0; A:1 ),
               ( R:0; G:1; B:0; A:1 ), ( R:1; G:1; B:0; A:1 ),
               ( R:0; G:0; B:1; A:1 ), ( R:1; G:0; B:1; A:1 ),
               ( R:0; G:1; B:1; A:1 ), ( R:1; G:1; B:1; A:1 ) );
     Es :array [ 0..12-1 ] of TCardinal3D
           = ( ( X:0; Y:4; Z:6 ), ( X:6; Y:2; Z:0 ), ( X:7; Y:5; Z:1 ), ( X:1; Y:3; Z:7 ),
               ( X:0; Y:1; Z:5 ), ( X:5; Y:4; Z:0 ), ( X:7; Y:3; Z:2 ), ( X:2; Y:6; Z:7 ),
               ( X:0; Y:2; Z:3 ), ( X:3; Y:1; Z:0 ), ( X:7; Y:6; Z:4 ), ( X:4; Y:5; Z:7 ) );
begin
     //    2-------3
     //   /|      /|
     //  6-------7 |
     //  | |     | |
     //  | 0-----|-1
     //  |/      |/
     //  4-------5

     _VerBufP.Import( Ps );
     _VerBufC.Import( Cs );
     _EleBuf .Import( Es );
end;

//------------------------------------------------------------------------------

procedure TForm1.DrawShaper;
begin
     glEnableClientState( GL_VERTEX_ARRAY );
     glEnableClientState( GL_COLOR_ARRAY  );

       with _VerBufP do
       begin
            Use;
              glVertexPointer( 3, GL_FLOAT, 0, nil );
            Unuse;
       end;

       with _VerBufC do
       begin
            Use;
              glColorPointer( 4, GL_FLOAT, 0, nil );
            Unuse;
       end;

       with _EleBuf do
       begin
            Use;
              glDrawElements( GL_TRIANGLES, 3{Poin} * 12{Face}, GL_UNSIGNED_INT, nil );
            Unuse;
       end;

     glDisableClientState( GL_VERTEX_ARRAY );
     glDisableClientState( GL_COLOR_ARRAY  );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _Angle := 0;

     _VerBufP := TGLVerBufS<TSingle3D>   .Create( GL_STATIC_DRAW );
     _VerBufC := TGLVerBufS<TAlphaColorF>.Create( GL_STATIC_DRAW );
     _EleBuf  := TGLEleBufFace32         .Create( GL_STATIC_DRAW );

     InitViewer;
     InitShaper;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _VerBufP.DisposeOf;
     _VerBufC.DisposeOf;
     _EleBuf .DisposeOf;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     _Angle := _Angle + 1;

     GLViewer1.Repaint;
     GLViewer2.Repaint;
     GLViewer3.Repaint;
     GLViewer4.Repaint;
end;

//------------------------------------------------------------------------------

procedure TForm1.GLViewer1DblClick(Sender: TObject);
begin
     with GLViewer1.MakeScreenShot do
     begin
          SaveToFile( 'Viewer1.png' );

          DisposeOf;
     end;
end;

procedure TForm1.GLViewer2DblClick(Sender: TObject);
begin
     with GLViewer2.MakeScreenShot do
     begin
          SaveToFile( 'Viewer2.png' );

          DisposeOf;
     end;
end;

procedure TForm1.GLViewer3DblClick(Sender: TObject);
begin
     with GLViewer3.MakeScreenShot do
     begin
          SaveToFile( 'Viewer3.png' );

          DisposeOf;
     end;
end;

procedure TForm1.GLViewer4DblClick(Sender: TObject);
begin
     with GLViewer4.MakeScreenShot do
     begin
          SaveToFile( 'Viewer4.png' );

          DisposeOf;
     end;
end;

end. //######################################################################### ■
