unit LUX.D3;

interface //#################################################################### ■

uses System.Math, System.Math.Vectors,
     LUX, LUX.D1, LUX.D2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TInteger3D

     TInteger3D = record
     private
     public
       constructor Create( const V_:Integer ); overload;
       constructor Create( const X_,Y_,Z_:Integer ); overload;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..3-1 ] of Integer; );
      1:( _1  :Integer;
          _2  :Integer;
          _3  :Integer;                     );
      2:(  X  :Integer;
           Y  :Integer;
           Z  :Integer;                     );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle3D

     TSingle3D = record
     private
       ///// A C C E S S O R
       function GetD1( const X_:Integer ) :Single;
       procedure SetD1( const X_:Integer; const V_:Single );
       function GetSize2 :Single;
       procedure SetSize2( const Size2_:Single );
       function GetSize :Single;
       procedure SetSize( const Size_:Single );
       function GetUnitor :TSingle3D;
       procedure SetUnitor( const Unitor_:TSingle3D );
       function GetOrthant :Byte;
       function GetProjXY :TSingle2D;
       procedure SetProjXY( const ProjXY_:TSingle2D );
       function GetProjYZ :TSingle2D;
       procedure SetProjYZ( const ProjYZ_:TSingle2D );
       function GetProjZX :TSingle2D;
       procedure SetProjZX( const ProjZX_:TSingle2D );
     public
       constructor Create( const V_:Single ); overload;
       constructor Create( const X_,Y_,Z_:Single ); overload;
       ///// P R O P E R T Y
       property D1[ const X_:Integer ] :Single    read GetD1      write SetD1    ; default;
       property Size2                  :Single    read GetSize2   write SetSize2 ;
       property Size                   :Single    read GetSize    write SetSize  ;
       property Unitor                 :TSingle3D read GetUnitor  write SetUnitor;
       property Orthant                :Byte      read GetOrthant                ;
       property ProjXY                 :TSingle2D read GetProjXY  write SetProjXY;
       property ProjYZ                 :TSingle2D read GetProjYZ  write SetProjYZ;
       property ProjZX                 :TSingle2D read GetProjZX  write SetProjZX;
       ///// O P E R A T O R
       class operator Negative( const V_:TSingle3D ) :TSingle3D;
       class operator Positive( const V_:TSingle3D ) :TSingle3D;
       class operator Add( const A_,B_:TSingle3D ) :TSingle3D;
       class operator Subtract( const A_,B_:TSingle3D ) :TSingle3D;
       class operator Multiply( const A_:TSingle3D; const B_:Single ) :TSingle3D;
       class operator Multiply( const A_:Single; const B_:TSingle3D ) :TSingle3D;
       class operator Divide( const A_:TSingle3D; const B_:Single ) :TSingle3D;
       ///// C A S T
       class operator Implicit( const V_:Single ) :TSingle3D;
       class operator Implicit( const V_:TSingle2D ) :TSingle3D;
       class operator Explicit( const V_:TSingle3D ) :TSingle2D;
       class operator Implicit( const V_:TPoint3D ) :TSingle3D;
       class operator Implicit( const V_:TSingle3D ) :TPoint3D;
       class operator Implicit( const V_:TVector3D ) :TSingle3D;
       class operator Implicit( const V_:TSingle3D ) :TVector3D;
       ///// C O N S T A N T
       class function IdentityX :TSingle3D; static;
       class function IdentityY :TSingle3D; static;
       class function IdentityZ :TSingle3D; static;
       ///// M E T H O D
       function VectorTo( const P_:TSingle3D ) :TSingle3D;
       function UnitorTo( const P_:TSingle3D ) :TSingle3D;
       function DistanTo( const P_:TSingle3D ) :Single;
       class function RandG :TSingle3D; static;
       class function RandBS1 :TSingle3D; static;
       class function RandBS2 :TSingle3D; static;
       class function RandBS4 :TSingle3D; static;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..3-1 ] of Single; );
      1:( _1  :Single;
          _2  :Single;
          _3  :Single;                     );
      2:(  X  :Single;
           Y  :Single;
           Z  :Single;                     );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble3D

     TDouble3D = record
     private
       ///// A C C E S S O R
       function GetD1( const X_:Integer ) :Double;
       procedure SetD1( const X_:Integer; const V_:Double );
       function GetSize2 :Double;
       procedure SetSize2( const Size2_:Double );
       function GetSize :Double;
       procedure SetSize( const Size_:Double );
       function GetUnitor :TDouble3D;
       procedure SetUnitor( const Unitor_:TDouble3D );
       function GetOrthant :Byte;
       function GetProjXY :TDouble2D;
       procedure SetProjXY( const ProjXY_:TDouble2D );
       function GetProjYZ :TDouble2D;
       procedure SetProjYZ( const ProjYZ_:TDouble2D );
       function GetProjZX :TDouble2D;
       procedure SetProjZX( const ProjZX_:TDouble2D );
     public
       constructor Create( const V_:Double ); overload;
       constructor Create( const X_,Y_,Z_:Double ); overload;
       ///// P R O P E R T Y
       property D1[ const X_:Integer ] :Double    read GetD1      write SetD1    ; default;
       property Size2                  :Double    read GetSize2   write SetSize2 ;
       property Size                   :Double    read GetSize    write SetSize  ;
       property Unitor                 :TDouble3D read GetUnitor  write SetUnitor;
       property Orthant                :Byte      read GetOrthant                ;
       property ProjXY                 :TDouble2D read GetProjXY  write SetProjXY;
       property ProjYZ                 :TDouble2D read GetProjYZ  write SetProjYZ;
       property ProjZX                 :TDouble2D read GetProjZX  write SetProjZX;
       ///// O P E R A T O R
       class operator Negative( const V_:TDouble3D ) :TDouble3D;
       class operator Positive( const V_:TDouble3D ) :TDouble3D;
       class operator Add( const A_,B_:TDouble3D ) :TDouble3D;
       class operator Subtract( const A_,B_:TDouble3D ) :TDouble3D;
       class operator Multiply( const A_:TDouble3D; const B_:Double ) :TDouble3D;
       class operator Multiply( const A_:Double; const B_:TDouble3D ) :TDouble3D;
       class operator Divide( const A_:TDouble3D; const B_:Double ) :TDouble3D;
       ///// C A S T
       class operator Implicit( const V_:Double ) :TDouble3D;
       class operator Implicit( const V_:TDouble2D ) :TDouble3D;
       class operator Explicit( const V_:TDouble3D ) :TDouble2D;
       class operator Implicit( const V_:TPoint3D ) :TDouble3D;
       class operator Explicit( const V_:TDouble3D ) :TPoint3D;
       class operator Implicit( const V_:TVector3D ) :TDouble3D;
       class operator Explicit( const V_:TDouble3D ) :TVector3D;
       class operator Implicit( const V_:TSingle3D ) :TDouble3D;
       class operator Explicit( const V_:TDouble3D ) :TSingle3D;
       ///// C O N S T A N T
       class function IdentityX :TDouble3D; static;
       class function IdentityY :TDouble3D; static;
       class function IdentityZ :TDouble3D; static;
       ///// M E T H O D
       function VectorTo( const P_:TDouble3D ) :TDouble3D;
       function UnitorTo( const P_:TDouble3D ) :TDouble3D;
       function DistanTo( const P_:TDouble3D ) :Double;
       class function RandG :TDouble3D; static;
       class function RandBS1 :TDouble3D; static;
       class function RandBS2 :TDouble3D; static;
       class function RandBS4 :TDouble3D; static;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..3-1 ] of Double; );
      1:( _1  :Double;
          _2  :Double;
          _3  :Double;                     );
      2:(  X  :Double;
           Y  :Double;
           Z  :Double;                     );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% T*Func2Dto3D

     TSingleFunc2Dto3D = reference to function ( const P_:TSingle2D ) :TSingle3D;
     TDoubleFunc2Dto3D = reference to function ( const P_:TDouble2D ) :TDouble3D;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angle

function Angle( const V0_,V1_:TSingle3D ) :Single; overload;  //= 0..Pi
function Angle( const V0_,V1_:TDouble3D ) :Double; overload;  //= 0..Pi

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DotProduct

function DotProduct( const A_,B_:TSingle3D ) :Single; overload;
function DotProduct( const A_,B_:TDouble3D ) :Double; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CrossProduct

function CrossProduct( const A_,B_:TSingle3D ) :TSingle3D; overload;
function CrossProduct( const A_,B_:TDouble3D ) :TDouble3D; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distance

function Distance2( const A_,B_:TSingle3D ) :Single; overload;
function Distance2( const A_,B_:TDouble3D ) :Double; overload;

function Distance( const A_,B_:TSingle3D ) :Single; overload;
function Distance( const A_,B_:TDouble3D ) :Double; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ave

function Ave( const P1_,P2_:TSingle3D ) :TSingle3D; overload;
function Ave( const P1_,P2_:TDouble3D ) :TDouble3D; overload;

function Ave( const P1_,P2_,P3_:TSingle3D ) :TSingle3D; overload;
function Ave( const P1_,P2_,P3_:TDouble3D ) :TDouble3D; overload;

function Ave( const P1_,P2_,P3_,P4_:TSingle3D ) :TSingle3D; overload;
function Ave( const P1_,P2_,P3_,P4_:TDouble3D ) :TDouble3D; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TInteger3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TInteger3D.Create( const V_:Integer );
begin
     X := V_;
     Y := V_;
     Z := V_;
end;

constructor TInteger3D.Create( const X_,Y_,Z_:Integer );
begin
     X := X_;
     Y := Y_;
     Z := Z_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TSingle3D.GetD1( const X_:Integer ) :Single;
begin
     Result := _1D[ X_-1 ];
end;

procedure TSingle3D.SetD1( const X_:Integer; const V_:Single );
begin
     _1D[ X_-1 ] := V_;
end;

//------------------------------------------------------------------------------

function TSingle3D.GetSize2 :Single;
begin
     Result := Pow2( X ) + Pow2( Y ) + Pow2( Z );
end;

procedure TSingle3D.SetSize2( const Size2_:Single );
begin
     Self := Roo2( Size2_ / Size2 ) * Self;
end;

function TSingle3D.GetSize :Single;
begin
     Result := Roo2( GetSize2 );
end;

procedure TSingle3D.SetSize( const Size_:Single );
begin
     Self := Size_ * Unitor;
end;

function TSingle3D.GetUnitor :TSingle3D;
begin
     Result := Self / Size;
end;

procedure TSingle3D.SetUnitor( const Unitor_:TSingle3D );
begin
     Self := Size * Unitor_;
end;

//------------------------------------------------------------------------------

function TSingle3D.GetOrthant :Byte;
begin
     Result := 0;
     if X >= 0 then Result := Result or 1;
     if Y >= 0 then Result := Result or 2;
     if Z >= 0 then Result := Result or 4;
end;

//------------------------------------------------------------------------------

function TSingle3D.GetProjXY :TSingle2D;
begin
     Result.X := X;
     Result.Y := Y;
end;

procedure TSingle3D.SetProjXY( const ProjXY_:TSingle2D );
begin
     X := ProjXY_.X;
     Y := ProjXY_.Y;
end;

function TSingle3D.GetProjYZ :TSingle2D;
begin
     Result.X := Y;
     Result.Y := Z;
end;

procedure TSingle3D.SetProjYZ( const ProjYZ_:TSingle2D );
begin
     Y := ProjYZ_.X;
     Z := ProjYZ_.Y;
end;

function TSingle3D.GetProjZX :TSingle2D;
begin
     Result.X := Z;
     Result.Y := X;
end;

procedure TSingle3D.SetProjZX( const ProjZX_:TSingle2D );
begin
     Z := ProjZX_.X;
     X := ProjZX_.Y;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingle3D.Create( const V_:Single );
begin
     X := V_;
     Y := V_;
     Z := V_;
end;

constructor TSingle3D.Create( const X_,Y_,Z_:Single );
begin
     X := X_;
     Y := Y_;
     Z := Z_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TSingle3D.Negative( const V_:TSingle3D ) :TSingle3D;
begin
     Result.X := -V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
end;

class operator TSingle3D.Positive( const V_:TSingle3D ) :TSingle3D;
begin
     Result.X := +V_.X;
     Result.Y := +V_.Y;
     Result.Z := +V_.Z;
end;

class operator TSingle3D.Add( const A_,B_:TSingle3D ) :TSingle3D;
begin
     Result.X := A_.X + B_.X;
     Result.Y := A_.Y + B_.Y;
     Result.Z := A_.Z + B_.Z;
end;

class operator TSingle3D.Subtract( const A_,B_:TSingle3D ) :TSingle3D;
begin
     Result.X := A_.X - B_.X;
     Result.Y := A_.Y - B_.Y;
     Result.Z := A_.Z - B_.Z;
end;

class operator TSingle3D.Multiply( const A_:TSingle3D; const B_:Single ) :TSingle3D;
begin
     Result.X := A_.X * B_;
     Result.Y := A_.Y * B_;
     Result.Z := A_.Z * B_;
end;

class operator TSingle3D.Multiply( const A_:Single; const B_:TSingle3D ) :TSingle3D;
begin
     Result.X := A_ * B_.X;
     Result.Y := A_ * B_.Y;
     Result.Z := A_ * B_.Z;
end;

class operator TSingle3D.Divide( const A_:TSingle3D; const B_:Single ) :TSingle3D;
begin
     Result.X := A_.X / B_;
     Result.Y := A_.Y / B_;
     Result.Z := A_.Z / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TSingle3D.Implicit( const V_:Single ) :TSingle3D;
begin
     Result.X := V_;
     Result.Y := V_;
     Result.Z := V_;
end;

class operator TSingle3D.Implicit( const V_:TSingle2D ) :TSingle3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z :=    0;
end;

class operator TSingle3D.Explicit( const V_:TSingle3D ) :TSingle2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

class operator TSingle3D.Implicit( const V_:TPoint3D ) :TSingle3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

class operator TSingle3D.Implicit( const V_:TSingle3D ) :TPoint3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

class operator TSingle3D.Implicit( const V_:TVector3D ) :TSingle3D;
begin
     Result := TPoint3D( V_ );
end;

class operator TSingle3D.Implicit( const V_:TSingle3D ) :TVector3D;
begin
     Result := TPoint3D( V_ );
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TSingle3D.IdentityX :TSingle3D;
begin
     Result.X := 1;
     Result.Y := 0;
     Result.Z := 0;
end;

class function TSingle3D.IdentityY :TSingle3D;
begin
     Result.X := 0;
     Result.Y := 1;
     Result.Z := 0;
end;

class function TSingle3D.IdentityZ :TSingle3D;
begin
     Result.X := 0;
     Result.Y := 0;
     Result.Z := 1;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TSingle3D.VectorTo( const P_:TSingle3D ) :TSingle3D;
begin
     Result := P_ - Self;
end;

function TSingle3D.UnitorTo( const P_:TSingle3D ) :TSingle3D;
begin
     Result := VectorTo( P_ ).Unitor;
end;

function TSingle3D.DistanTo( const P_:TSingle3D ) :Single;
begin
     Result := VectorTo( P_ ).Size;
end;

//------------------------------------------------------------------------------

class function TSingle3D.RandG :TSingle3D;
begin
     Result.X := TSingle.RandG;
     Result.Y := TSingle.RandG;
     Result.Z := TSingle.RandG;
end;

//------------------------------------------------------------------------------

class function TSingle3D.RandBS1 :TSingle3D;
begin
     Result.X := TSingle.RandBS1;
     Result.Y := TSingle.RandBS1;
     Result.Z := TSingle.RandBS1;
end;

class function TSingle3D.RandBS2 :TSingle3D;
begin
     Result.X := TSingle.RandBS2;
     Result.Y := TSingle.RandBS2;
     Result.Z := TSingle.RandBS2;
end;

class function TSingle3D.RandBS4 :TSingle3D;
begin
     Result.X := TSingle.RandBS4;
     Result.Y := TSingle.RandBS4;
     Result.Z := TSingle.RandBS4;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TDouble3D.GetD1( const X_:Integer ) :Double;
begin
     Result := _1D[ X_-1 ];
end;

procedure TDouble3D.SetD1( const X_:Integer; const V_:Double );
begin
     _1D[ X_-1 ] := V_;
end;

//------------------------------------------------------------------------------

function TDouble3D.GetSize2 :Double;
begin
     Result := Pow2( X ) + Pow2( Y ) + Pow2( Z );
end;

procedure TDouble3D.SetSize2( const Size2_:Double );
begin
     Self := Roo2( Size2_ / Size2 ) * Self;
end;

function TDouble3D.GetSize :Double;
begin
     Result := Roo2( GetSize2 );
end;

procedure TDouble3D.SetSize( const Size_:Double );
begin
     Self := Size_ * Unitor;
end;

function TDouble3D.GetUnitor :TDouble3D;
begin
     Result := Self / Size;
end;

procedure TDouble3D.SetUnitor( const Unitor_:TDouble3D );
begin
     Self := Size * Unitor_;
end;

//------------------------------------------------------------------------------

function TDouble3D.GetOrthant :Byte;
begin
     Result := 0;
     if X >= 0 then Result := Result or 1;
     if Y >= 0 then Result := Result or 2;
     if Z >= 0 then Result := Result or 4;
end;

//------------------------------------------------------------------------------

function TDouble3D.GetProjXY :TDouble2D;
begin
     Result.X := X;
     Result.Y := Y;
end;

procedure TDouble3D.SetProjXY( const ProjXY_:TDouble2D );
begin
     X := ProjXY_.X;
     Y := ProjXY_.Y;
end;

function TDouble3D.GetProjYZ :TDouble2D;
begin
     Result.X := Y;
     Result.Y := Z;
end;

procedure TDouble3D.SetProjYZ( const ProjYZ_:TDouble2D );
begin
     Y := ProjYZ_.X;
     Z := ProjYZ_.Y;
end;

function TDouble3D.GetProjZX :TDouble2D;
begin
     Result.X := Z;
     Result.Y := X;
end;

procedure TDouble3D.SetProjZX( const ProjZX_:TDouble2D );
begin
     Z := ProjZX_.X;
     X := ProjZX_.Y;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDouble3D.Create( const V_:Double );
begin
     X := V_;
     Y := V_;
     Z := V_;
end;

constructor TDouble3D.Create( const X_,Y_,Z_:Double );
begin
     X := X_;
     Y := Y_;
     Z := Z_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TDouble3D.Negative( const V_:TDouble3D ) :TDouble3D;
begin
     Result.X := -V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
end;

class operator TDouble3D.Positive( const V_:TDouble3D ) :TDouble3D;
begin
     Result.X := +V_.X;
     Result.Y := +V_.Y;
     Result.Z := +V_.Z;
end;

class operator TDouble3D.Add( const A_,B_:TDouble3D ) :TDouble3D;
begin
     Result.X := A_.X + B_.X;
     Result.Y := A_.Y + B_.Y;
     Result.Z := A_.Z + B_.Z;
end;

class operator TDouble3D.Subtract( const A_,B_:TDouble3D ) :TDouble3D;
begin
     Result.X := A_.X - B_.X;
     Result.Y := A_.Y - B_.Y;
     Result.Z := A_.Z - B_.Z;
end;

class operator TDouble3D.Multiply( const A_:TDouble3D; const B_:Double ) :TDouble3D;
begin
     Result.X := A_.X * B_;
     Result.Y := A_.Y * B_;
     Result.Z := A_.Z * B_;
end;

class operator TDouble3D.Multiply( const A_:Double; const B_:TDouble3D ) :TDouble3D;
begin
     Result.X := A_ * B_.X;
     Result.Y := A_ * B_.Y;
     Result.Z := A_ * B_.Z;
end;

class operator TDouble3D.Divide( const A_:TDouble3D; const B_:Double ) :TDouble3D;
begin
     Result.X := A_.X / B_;
     Result.Y := A_.Y / B_;
     Result.Z := A_.Z / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TDouble3D.Implicit( const V_:Double ) :TDouble3D;
begin
     Result.X := V_;
     Result.Y := V_;
     Result.Z := V_;
end;

class operator TDouble3D.Implicit( const V_:TDouble2D ) :TDouble3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z :=    0;
end;

class operator TDouble3D.Explicit( const V_:TDouble3D ) :TDouble2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

class operator TDouble3D.Implicit( const V_:TPoint3D ) :TDouble3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

class operator TDouble3D.Explicit( const V_:TDouble3D ) :TPoint3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

class operator TDouble3D.Implicit( const V_:TVector3D ) :TDouble3D;
begin
     Result := TPoint3D( V_ );
end;

class operator TDouble3D.Explicit( const V_:TDouble3D ) :TVector3D;
begin
     Result := TPoint3D( V_ );
end;

class operator TDouble3D.Implicit( const V_:TSingle3D ) :TDouble3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

class operator TDouble3D.Explicit( const V_:TDouble3D ) :TSingle3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TDouble3D.IdentityX :TDouble3D;
begin
     Result.X := 1;
     Result.Y := 0;
     Result.Z := 0;
end;

class function TDouble3D.IdentityY :TDouble3D;
begin
     Result.X := 0;
     Result.Y := 1;
     Result.Z := 0;
end;

class function TDouble3D.IdentityZ :TDouble3D;
begin
     Result.X := 0;
     Result.Y := 0;
     Result.Z := 1;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TDouble3D.VectorTo( const P_:TDouble3D ) :TDouble3D;
begin
     Result := P_ - Self;
end;

function TDouble3D.UnitorTo( const P_:TDouble3D ) :TDouble3D;
begin
     Result := VectorTo( P_ ).Unitor;
end;

function TDouble3D.DistanTo( const P_:TDouble3D ) :Double;
begin
     Result := VectorTo( P_ ).Size;
end;

//------------------------------------------------------------------------------

class function TDouble3D.RandG :TDouble3D;
begin
     Result.X := TDouble.RandG;
     Result.Y := TDouble.RandG;
     Result.Z := TDouble.RandG;
end;

//------------------------------------------------------------------------------

class function TDouble3D.RandBS1 :TDouble3D;
begin
     Result.X := TDouble.RandBS1;
     Result.Y := TDouble.RandBS1;
     Result.Z := TDouble.RandBS1;
end;

class function TDouble3D.RandBS2 :TDouble3D;
begin
     Result.X := TDouble.RandBS2;
     Result.Y := TDouble.RandBS2;
     Result.Z := TDouble.RandBS2;
end;

class function TDouble3D.RandBS4 :TDouble3D;
begin
     Result.X := TDouble.RandBS4;
     Result.Y := TDouble.RandBS4;
     Result.Z := TDouble.RandBS4;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angle

function Angle( const V0_,V1_:TSingle3D ) :Single;
begin
     Result := ArcCos( Clamp( DotProduct( V0_, V1_ ), -1, +1 ) );
end;

function Angle( const V0_,V1_:TDouble3D ) :Double;
begin
     Result := ArcCos( Clamp( DotProduct( V0_, V1_ ), -1, +1 ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DotProduct

function DotProduct( const A_,B_:TSingle3D ) :Single;
begin
     Result := A_.X * B_.X
             + A_.Y * B_.Y
             + A_.Z * B_.Z;
end;

function DotProduct( const A_,B_:TDouble3D ) :Double;
begin
     Result := A_.X * B_.X
             + A_.Y * B_.Y
             + A_.Z * B_.Z;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CrossProduct

function CrossProduct( const A_,B_:TSingle3D ) :TSingle3D;
begin
     Result.X := A_.Y * B_.Z - A_.Z * B_.Y;
     Result.Y := A_.Z * B_.X - A_.X * B_.Z;
     Result.Z := A_.X * B_.Y - A_.Y * B_.X;
end;

function CrossProduct( const A_,B_:TDouble3D ) :TDouble3D;
begin
     Result.X := A_.Y * B_.Z - A_.Z * B_.Y;
     Result.Y := A_.Z * B_.X - A_.X * B_.Z;
     Result.Z := A_.X * B_.Y - A_.Y * B_.X;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distance

function Distance2( const A_,B_:TSingle3D ) :Single;
begin
     Result := Pow2( B_.X - A_.X )
             + Pow2( B_.Y - A_.Y )
             + Pow2( B_.Z - A_.Z );
end;

function Distance2( const A_,B_:TDouble3D ) :Double;
begin
     Result := Pow2( B_.X - A_.X )
             + Pow2( B_.Y - A_.Y )
             + Pow2( B_.Z - A_.Z );
end;

function Distance( const A_,B_:TSingle3D ) :Single;
begin
     Result := Roo2( Distance2( A_, B_ ) );
end;

function Distance( const A_,B_:TDouble3D ) :Double;
begin
     Result := Roo2( Distance2( A_, B_ ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ave

function Ave( const P1_,P2_:TSingle3D ) :TSingle3D;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

function Ave( const P1_,P2_:TDouble3D ) :TDouble3D;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

function Ave( const P1_,P2_,P3_:TSingle3D ) :TSingle3D;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

function Ave( const P1_,P2_,P3_:TDouble3D ) :TDouble3D;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

function Ave( const P1_,P2_,P3_,P4_:TSingle3D ) :TSingle3D;
begin
     Result := ( P1_ + P2_ + P3_ + P4_ ) / 4;
end;

function Ave( const P1_,P2_,P3_,P4_:TDouble3D ) :TDouble3D;
begin
     Result := ( P1_ + P2_ + P3_ + P4_ ) / 4;
end;

end. //######################################################################### ■
