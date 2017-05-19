unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  Winapi.OpenGL, Winapi.OpenGLext,
  LUX, LUX.D3, LUX.GPU.OpenGL.GLView;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
      GLView1: TGLView;
      GLView2: TGLView; 
    GLView3: TGLView;
    GLView4: TGLView;
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
     Ps :array [ 1..8 ] of TSingle3D = ( ( X:-1; Y:-1; Z:-1 ),
                                         ( X:+1; Y:-1; Z:-1 ),
                                         ( X:-1; Y:+1; Z:-1 ),
                                         ( X:+1; Y:+1; Z:-1 ),
                                         ( X:-1; Y:-1; Z:+1 ),
                                         ( X:+1; Y:-1; Z:+1 ),
                                         ( X:-1; Y:+1; Z:+1 ),
                                         ( X:+1; Y:+1; Z:+1 ) );
     Cs :array [ 1..8 ] of TAlphaColorF = ( ( R:0; G:0; B:0; A:1 ),
                                            ( R:1; G:0; B:0; A:1 ),
                                            ( R:0; G:1; B:0; A:1 ),
                                            ( R:1; G:1; B:0; A:1 ),
                                            ( R:0; G:0; B:1; A:1 ),
                                            ( R:1; G:0; B:1; A:1 ),
                                            ( R:0; G:1; B:1; A:1 ),
                                            ( R:1; G:1; B:1; A:1 ) );
     Fs :array [ 1..6, 1..4 ] of Integer = ( ( 1, 3, 4, 2 ),
                                             ( 1, 5, 7, 3 ),
                                             ( 1, 2, 6, 5 ),
                                             ( 8, 4, 3, 7 ),
                                             ( 8, 6, 2, 4 ),
                                             ( 8, 7, 5, 6 ) );
var
   N, K, I :Integer;
begin
     //    3-------4
     //   /|      /|
     //  7-------8 |
     //  | |     | |
     //  | 1-----|-2
     //  |/      |/
     //  5-------6

     glBegin( GL_QUADS );

       for N := 1 to 6 do
       begin
            for K := 1 to 4 do
            begin
                 I := Fs[ N, K ];

                 with Cs[ I ] do glColor3f( R, G, B );

                 with Ps[ I ] do glVertex3f( X, Y, Z );
            end;
       end;

     glEnd;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitRender;
const
     _N :Single = 0.1;
     _F :Single = 1000;
begin
     GLView1.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -2, +2, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( +90, 1, 0, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView2.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -4, +4, -2, +2, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( -90, 0, 1, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView3.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -3, +3, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView4.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glFrustum( -4/8*_N, +4/8*_N,
                       -3/8*_N, +3/8*_N, _N, _F );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -8 );
            glRotatef( +30, 1, 0, 0 );
            glRotatef( -30, 0, 1, 0 );
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

     GLView1.Repaint;
     GLView2.Repaint;
     GLView3.Repaint;
     GLView4.Repaint;
end;

end. //######################################################################### ■
