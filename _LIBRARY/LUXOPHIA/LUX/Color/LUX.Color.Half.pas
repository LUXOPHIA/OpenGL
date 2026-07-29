unit LUX.Color.Half;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Half,
     LUX.Color;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THalfRGB

     PHalfRGB = ^THalfRGB;

     THalfRGB = packed record  // 記憶順は R,G,B（Skia の RGBAF16 に一致）
     private
     public
       R :THalf;
       G :THalf;
       B :THalf;
       constructor Create( const L_:Single ); overload;
       constructor Create( const R_,G_,B_:Single ); overload;
       ///// C A S T
       class operator Implicit( const L_:Single ) :THalfRGB;
       class operator Implicit( const C_:THalfRGB ) :TSingleRGB;
       class operator Implicit( const C_:TSingleRGB ) :THalfRGB;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THalfRGBA

     PHalfRGBA = ^THalfRGBA;

     THalfRGBA = packed record  // 記憶順は R,G,B,A（Skia の RGBAF16 に一致）
     private
       ///// A C C E S S O R
       function GetR :THalf;
       procedure SetR( const R_:THalf );
       function GetG :THalf;
       procedure SetG( const G_:THalf );
       function GetB :THalf;
       procedure SetB( const B_:THalf );
     public
       C :THalfRGB;
       A :THalf;
       constructor Create( const L_:Single; const A_:Single = 1 ); overload;
       constructor Create( const R_,G_,B_:Single; const A_:Single = 1 ); overload;
       ///// P R O P E R T Y
       property R :THalf read GetR write SetR;
       property G :THalf read GetG write SetG;
       property B :THalf read GetB write SetB;
       ///// C A S T
       class operator Implicit( const L_:Single ) :THalfRGBA;
       class operator Implicit( const C_:THalfRGB ) :THalfRGBA;
       class operator Explicit( const C_:THalfRGBA ) :THalfRGB;
       class operator Implicit( const C_:THalfRGBA ) :TSingleRGBA;
       class operator Implicit( const C_:TSingleRGBA ) :THalfRGBA;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THalfRGB

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor THalfRGB.Create( const L_:Single );
begin
     R := L_;
     G := L_;
     B := L_;
end;

constructor THalfRGB.Create( const R_,G_,B_:Single );
begin
     R := R_;
     G := G_;
     B := B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator THalfRGB.Implicit( const L_:Single ) :THalfRGB;
begin
     Result := THalfRGB.Create( L_ );
end;

class operator THalfRGB.Implicit( const C_:THalfRGB ) :TSingleRGB;
begin
     with Result do
     begin
          R := C_.R;
          G := C_.G;
          B := C_.B;
     end;
end;

class operator THalfRGB.Implicit( const C_:TSingleRGB ) :THalfRGB;
begin
     with Result do
     begin
          R := C_.R;
          G := C_.G;
          B := C_.B;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THalfRGBA

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function THalfRGBA.GetR :THalf;
begin
     Result := C.R;
end;

procedure THalfRGBA.SetR( const R_:THalf );
begin
     C.R := R_;
end;

function THalfRGBA.GetG :THalf;
begin
     Result := C.G;
end;

procedure THalfRGBA.SetG( const G_:THalf );
begin
     C.G := G_;
end;

function THalfRGBA.GetB :THalf;
begin
     Result := C.B;
end;

procedure THalfRGBA.SetB( const B_:THalf );
begin
     C.B := B_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor THalfRGBA.Create( const L_:Single; const A_:Single );
begin
     C := L_;
     A := A_;
end;

constructor THalfRGBA.Create( const R_,G_,B_:Single; const A_:Single );
begin
     C := THalfRGB.Create( R_, G_, B_ );
     A := A_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator THalfRGBA.Implicit( const L_:Single ) :THalfRGBA;
begin
     Result := THalfRGBA.Create( L_ );
end;

class operator THalfRGBA.Implicit( const C_:THalfRGB ) :THalfRGBA;
begin
     with Result do
     begin
          C := C_;
          A := 1;
     end;
end;

class operator THalfRGBA.Explicit( const C_:THalfRGBA ) :THalfRGB;
begin
     Result := C_.C;
end;

class operator THalfRGBA.Implicit( const C_:THalfRGBA ) :TSingleRGBA;
begin
     with Result do
     begin
          C := C_.C;
          A := C_.A;
     end;
end;

class operator THalfRGBA.Implicit( const C_:TSingleRGBA ) :THalfRGBA;
begin
     with Result do
     begin
          C := C_.C;
          A := C_.A;
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
