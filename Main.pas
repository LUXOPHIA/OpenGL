unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  Winapi.OpenGL,
  LUX, LUX.D3,
  LUX.GPU.OpenGL,
  LUX.GPU.OpenGL.Viewer;

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
    procedure Timer1Timer(Sender: TObject);
  private
    { private 宣言 }
    _Angle :Single;
  public
    { public 宣言 }
    ///// メソッド
    procedure DrawModel;
    procedure InitRender;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.DrawModel;
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
     Es :array [ 0..12-1, 0..3-1 ] of Cardinal
           = ( ( 0, 4, 6 ), ( 6, 2, 0 ), ( 7, 5, 1 ), ( 1, 3, 7 ),
               ( 0, 1, 5 ), ( 5, 4, 0 ), ( 7, 3, 2 ), ( 2, 6, 7 ),
               ( 0, 2, 3 ), ( 3, 1, 0 ), ( 7, 6, 4 ), ( 4, 5, 7 ) );
begin
     //    2-------3
     //   /|      /|
     //  6-------7 |
     //  | |     | |
     //  | 0-----|-1
     //  |/      |/
     //  4-------5

     glEnableClientState( GL_VERTEX_ARRAY );
     glEnableClientState( GL_COLOR_ARRAY  );

       glVertexPointer( 3, GL_FLOAT, 0, @Ps[ 0 ] );
       glColorPointer ( 4, GL_FLOAT, 0, @Cs[ 0 ] );

       glDrawElements( GL_TRIANGLES, 3{Poin} * 12{Face}, GL_UNSIGNED_INT, @Es[ 0, 0 ] );

     glDisableClientState( GL_VERTEX_ARRAY );
     glDisableClientState( GL_COLOR_ARRAY  );
end;

//------------------------------------------------------------------------------

procedure TForm1.InitRender;
const
     _N :Single = 0.1;
     _F :Single = 1000;
begin
     GLViewer1.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -3, +3, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( +90, 1, 0, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
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
            DrawModel;
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
            DrawModel;
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
            DrawModel;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     InitRender;

     _Angle := 0;
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

end. //######################################################################### ■
