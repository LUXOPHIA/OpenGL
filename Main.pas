unit Main;

interface //#################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  Winapi.OpenGL, Winapi.OpenGLext,
  LUX, LUX.D3, LUX.GPU.OpenGL, LUX.GPU.OpenGL.GLView;

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
   Ps :array [ 0..7 ] of TSingle3D = ( ( X:-1; Y:-1; Z:-1 ),
                                       ( X:+1; Y:-1; Z:-1 ),
                                       ( X:-1; Y:+1; Z:-1 ),
                                       ( X:+1; Y:+1; Z:-1 ),
                                       ( X:-1; Y:-1; Z:+1 ),
                                       ( X:+1; Y:-1; Z:+1 ),
                                       ( X:-1; Y:+1; Z:+1 ),
                                       ( X:+1; Y:+1; Z:+1 ) );
   Cs :array [ 0..7 ] of TAlphaColorF = ( ( R:0; G:0; B:0; A:1 ),
                                          ( R:1; G:0; B:0; A:1 ),
                                          ( R:0; G:1; B:0; A:1 ),
                                          ( R:1; G:1; B:0; A:1 ),
                                          ( R:0; G:0; B:1; A:1 ),
                                          ( R:1; G:0; B:1; A:1 ),
                                          ( R:0; G:1; B:1; A:1 ),
                                          ( R:1; G:1; B:1; A:1 ) );
   Fs :array [ 1..6, 1..4 ] of Integer = ( ( 0, 2, 3, 1 ),
                                           ( 0, 4, 6, 2 ),
                                           ( 0, 1, 5, 4 ),
                                           ( 7, 3, 2, 6 ),
                                           ( 7, 5, 1, 3 ),
                                           ( 7, 6, 4, 5 ) );
var
   N, K, I :Integer;
begin
     //    2-------3
     //   /|      /|
     //  6-------7 |
     //  | |     | |
     //  | 0-----|-1
     //  |/      |/
     //  4-------5

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

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _Angle := 0;

     GLView1.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -2, +2, 0.1, 100 );
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
            glOrtho( -4, +4, -2, +2, 0.1, 100 );
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
            glOrtho( -3, +3, -3, +3, 0.1, 100 );
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
            glOrtho( -4, +4, -3, +3, 0.1, 100 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( +30, 1, 0, 0 );
            glRotatef( -30, 0, 1, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;
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
