unit LUX.D4;

interface //#################################################################### ■

uses System.Math.Vectors,
     LUX, LUX.D1, LUX.D3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TInteger4D

     TInteger4D = record
     private
     public
       constructor Create( const V_:Integer ); overload;
       constructor Create( const X_,Y_,Z_,W_:Integer ); overload;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..4-1 ] of Integer; );
      1:( _1  :Integer;
          _2  :Integer;
          _3  :Integer;
          _4  :Integer;                     );
      2:(  X  :Integer;
           Y  :Integer;
           Z  :Integer;
           W  :Integer;                     );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle4D

     TSingle4D = record
     private
       ///// A C C E S S O R
       function GetD1( const X_:Integer ) :Single;
       procedure SetD1( const X_:Integer; const D1_:Single );
       function GetSize2 :Single;
       procedure SetSize2( const Size2_:Single );
       function GetSize :Single;
       procedure SetSize( const Size_:Single );
       function GetUnitor :TSingle4D;
       procedure SetUnitor( const Unitor_:TSingle4D );
       function GetOrthant :Byte;
     public
       constructor Create( const V_:Single ); overload;
       constructor Create( const X_,Y_,Z_,W_:Single ); overload;
       constructor Create( const P_:TSingle3D; const W_:Single ); overload;
       ///// P R O P E R T Y
       property D1[ const X_:Integer ] :Single    read GetD1     write SetD1    ; default;
       property Size2                  :Single    read GetSize2  write SetSize2 ;
       property Size                   :Single    read GetSize   write SetSize  ;
       property Unitor                 :TSingle4D read GetUnitor write SetUnitor;
       property Orthant                :Byte      read GetOrthant               ;
       ///// O P E R A T O R
       class operator Negative( const V_:TSingle4D ) :TSingle4D;
       class operator Positive( const V_:TSingle4D ) :TSingle4D;
       class operator Add( const A_,B_:TSingle4D ) :TSingle4D;
       class operator Subtract( const A_,B_:TSingle4D ) :TSingle4D;
       class operator Multiply( const A_:TSingle4D; const B_:Single ) :TSingle4D;
       class operator Multiply( const A_:Single; const B_:TSingle4D ) :TSingle4D;
       class operator Divide( const A_:TSingle4D; const B_:Single ) :TSingle4D;
       ///// C A S T
       class operator Implicit( const V_:Single ) :TSingle4D;
       class operator Implicit( const V_:TSingle3D ) :TSingle4D;
       class operator Explicit( const V_:TSingle4D ) :TSingle3D;
       class operator Implicit( const V_:TPoint3D ) :TSingle4D;
       class operator Explicit( const V_:TSingle4D ) :TPoint3D;
       class operator Implicit( const V_:TVector3D ) :TSingle4D;
       class operator Explicit( const V_:TSingle4D ) :TVector3D;
       ///// C O N S T A N T
       class function IdentityX :TSingle4D; static;
       class function IdentityY :TSingle4D; static;
       class function IdentityZ :TSingle4D; static;
       class function IdentityW :TSingle4D; static;
       ///// M E T H O D
       function VectorTo( const P_:TSingle4D ) :TSingle4D;
       function UnitorTo( const P_:TSingle4D ) :TSingle4D;
       function DistanTo( const P_:TSingle4D ) :Single;
       function ToCart :TSingle3D;
       class function RandG :TSingle4D; static;
       class function RandBS1 :TSingle4D; static;
       class function RandBS2 :TSingle4D; static;
       class function RandBS4 :TSingle4D; static;
       ///// F I E L D
     case Integer of
      0:( _1D :array [ 0..4-1 ] of Single );
      1:( _1  :Single;
          _2  :Single;
          _3  :Single;
          _4  :Single;                    );
      2:(  X  :Single;
           Y  :Single;
           Z  :Single;
           W  :Single;                    );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble4D

     TDouble4D = record
     private
       ///// A C C E S S O R
       function GetD1( const X_:Integer ) :Double;
       procedure SetD1( const X_:Integer; const D1_:Double );
       function GetSize2 :Double;
       procedure SetSize2( const Size2_:Double );
       function GetSize :Double;
       procedure SetSize( const Size_:Double );
       function GetUnitor :TDouble4D;
       procedure SetUnitor( const Unitor_:TDouble4D );
       function GetOrthant :Byte;
     public
       constructor Create( const V_:Double ); overload;
       constructor Create( const X_,Y_,Z_,W_:Double ); overload;
       constructor Create( const P_:TDouble3D; const W_:Double ); overload;
       ///// P R O P E R T Y
       property D1[ const X_:Integer ] :Double    read GetD1     write SetD1    ; default;
       property Size2                  :Double    read GetSize2  write SetSize2 ;
       property Size                   :Double    read GetSize   write SetSize  ;
       property Unitor                 :TDouble4D read GetUnitor write SetUnitor;
       property Orthant                :Byte      read GetOrthant               ;
       ///// O P E R A T O R
       class operator Negative( const V_:TDouble4D ) :TDouble4D;
       class operator Positive( const V_:TDouble4D ) :TDouble4D;
       class operator Add( const A_,B_:TDouble4D ) :TDouble4D;
       class operator Subtract( const A_,B_:TDouble4D ) :TDouble4D;
       class operator Multiply( const A_:TDouble4D; const B_:Double ) :TDouble4D;
       class operator Multiply( const A_:Double; const B_:TDouble4D ) :TDouble4D;
       class operator Divide( const A_:TDouble4D; const B_:Double ) :TDouble4D;
       ///// C A S T
       class operator Implicit( const V_:Double ) :TDouble4D;
       class operator Implicit( const V_:TDouble3D ) :TDouble4D;
       class operator Explicit( const V_:TDouble4D ) :TDouble3D;
       class operator Implicit( const V_:TPoint3D ) :TDouble4D;
       class operator Explicit( const V_:TDouble4D ) :TPoint3D;
       class operator Implicit( const V_:TVector3D ) :TDouble4D;
       class operator Explicit( const V_:TDouble4D ) :TVector3D;
       class operator Implicit( const V_:TSingle4D ) :TDouble4D;
       class operator Explicit( const V_:TDouble4D ) :TSingle4D;
       ///// C O N S T A N T
       class function IdentityX :TDouble4D; static;
       class function IdentityY :TDouble4D; static;
       class function IdentityZ :TDouble4D; static;
       class function IdentityW :TDouble4D; static;
       ///// M E T H O D
       function VectorTo( const P_:TDouble4D ) :TDouble4D;
       function UnitorTo( const P_:TDouble4D ) :TDouble4D;
       function DistanTo( const P_:TDouble4D ) :Double;
       function ToCart :TDouble3D;
       class function RandG :TDouble4D; static;
       class function RandBS1 :TDouble4D; static;
       class function RandBS2 :TDouble4D; static;
       class function RandBS4 :TDouble4D; static;
       ///// F I E L D
     case Integer of
      0:( _1D :array [ 0..4-1 ] of Double );
      1:( _1  :Double;
          _2  :Double;
          _3  :Double;
          _4  :Double;                    );
      2:(  X  :Double;
           Y  :Double;
           Z  :Double;
           W  :Double;                    );
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angle

function Angle( const V0_,V1_:TSingle4D ) :Single; overload;  //= 0..Pi
function Angle( const V0_,V1_:TDouble4D ) :Double; overload;  //= 0..Pi

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DotProduct

function DotProduct( const A_,B_:TSingle4D ) :Single; overload;
function DotProduct( const A_,B_:TDouble4D ) :Double; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CrossProduct

function CrossProduct( const A_,B_,C_:TSingle4D ) :TSingle4D; overload;
function CrossProduct( const A_,B_,C_:TDouble4D ) :TDouble4D; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distance

function Distance2( const A_,B_:TSingle4D ) :Single; overload;
function Distance2( const A_,B_:TDouble4D ) :Double; overload;

function Distance( const A_,B_:TSingle4D ) :Single; overload;
function Distance( const A_,B_:TDouble4D ) :Double; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ave

function Ave( const P1_,P2_:TSingle4D ) :TSingle4D; overload;
function Ave( const P1_,P2_:TDouble4D ) :TDouble4D; overload;

function Ave( const P1_,P2_,P3_:TSingle4D ) :TSingle4D; overload;
function Ave( const P1_,P2_,P3_:TDouble4D ) :TDouble4D; overload;

function Ave( const P1_,P2_,P3_,P4_:TSingle4D ) :TSingle4D; overload;
function Ave( const P1_,P2_,P3_,P4_:TDouble4D ) :TDouble4D; overload;

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TInteger4D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TInteger4D.Create( const V_:Integer );
begin
     X := V_;
     Y := V_;
     Z := V_;
     W := V_;
end;

constructor TInteger4D.Create( const X_,Y_,Z_,W_:Integer );
begin
     X := X_;
     Y := Y_;
     Z := Z_;
     W := W_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle4D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TSingle4D.GetD1( const X_:Integer ) :Single;
begin
     Result := _1D[ X_-1 ];
end;

procedure TSingle4D.SetD1( const X_:Integer; const D1_:Single );
begin
     _1D[ X_-1 ] := D1_;
end;

//------------------------------------------------------------------------------

function TSingle4D.GetSize2 :Single;
begin
     Result := Pow2( X ) + Pow2( Y ) + Pow2( Z ) + Pow2( W );
end;

procedure TSingle4D.SetSize2( const Size2_:Single );
begin
     Self := Roo2( Size2_ / Size2 ) * Self;
end;

function TSingle4D.GetSize :Single;
begin
     Result := Roo2( GetSize2 );
end;

procedure TSingle4D.SetSize( const Size_:Single );
begin
     Self := Size_ * Unitor;
end;

function TSingle4D.GetUnitor :TSingle4D;
begin
     Result := Self / Size;
end;

procedure TSingle4D.SetUnitor( const Unitor_:TSingle4D );
begin
     Self := Size * Unitor_;
end;

//------------------------------------------------------------------------------

function TSingle4D.GetOrthant :Byte;
begin
     Result := 0;
     if X >= 0 then Result := Result or 1;
     if Y >= 0 then Result := Result or 2;
     if Z >= 0 then Result := Result or 4;
     if W >= 0 then Result := Result or 8;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingle4D.Create( const V_:Single );
begin
     X := V_;
     Y := V_;
     Z := V_;
     W := V_;
end;

constructor TSingle4D.Create( const X_,Y_,Z_,W_:Single );
begin
     X := X_;
     Y := Y_;
     Z := Z_;
     W := W_;
end;

constructor TSingle4D.Create( const P_:TSingle3D; const W_:Single );
begin
     X := P_.X ;
     Y := P_.Y ;
     Z := P_.Z ;
     W :=    W_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TSingle4D.Negative( const V_:TSingle4D ) :TSingle4D;
begin
     Result.X := -V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
     Result.W := -V_.W;
end;

class operator TSingle4D.Positive( const V_:TSingle4D ) :TSingle4D;
begin
     Result.X := +V_.X;
     Result.Y := +V_.Y;
     Result.Z := +V_.Z;
     Result.W := +V_.W;
end;

class operator TSingle4D.Add( const A_,B_:TSingle4D ) :TSingle4D;
begin
     Result.X := A_.X + B_.X;
     Result.Y := A_.Y + B_.Y;
     Result.Z := A_.Z + B_.Z;
     Result.W := A_.W + B_.W;
end;

class operator TSingle4D.Subtract( const A_,B_:TSingle4D ) :TSingle4D;
begin
     Result.X := A_.X - B_.X;
     Result.Y := A_.Y - B_.Y;
     Result.Z := A_.Z - B_.Z;
     Result.W := A_.W - B_.W;
end;

class operator TSingle4D.Multiply( const A_:TSingle4D; const B_:Single ) :TSingle4D;
begin
     Result.X := A_.X * B_;
     Result.Y := A_.Y * B_;
     Result.Z := A_.Z * B_;
     Result.W := A_.W * B_;
end;

class operator TSingle4D.Multiply( const A_:Single; const B_:TSingle4D ) :TSingle4D;
begin
     Result.X := A_ * B_.X;
     Result.Y := A_ * B_.Y;
     Result.Z := A_ * B_.Z;
     Result.W := A_ * B_.W;
end;

class operator TSingle4D.Divide( const A_:TSingle4D; const B_:Single ) :TSingle4D;
begin
     Result.X := A_.X / B_;
     Result.Y := A_.Y / B_;
     Result.Z := A_.Z / B_;
     Result.W := A_.W / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TSingle4D.Implicit( const V_:Single ) :TSingle4D;
begin
     Result.X := V_;
     Result.Y := V_;
     Result.Z := V_;
     Result.W := V_;
end;

class operator TSingle4D.Implicit( const V_:TSingle3D ) :TSingle4D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
     Result.W :=    0;
end;

class operator TSingle4D.Explicit( const V_:TSingle4D ) :TSingle3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

class operator TSingle4D.Implicit( const V_:TPoint3D ) :TSingle4D;
begin
     Result.X := +V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
     Result.W :=     0;
end;

class operator TSingle4D.Explicit( const V_:TSingle4D ) :TPoint3D;
begin
     Result.X := +V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
end;

class operator TSingle4D.Implicit( const V_:TVector3D ) :TSingle4D;
begin
     Result.X := +V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
     Result.W :=  V_.W;
end;

class operator TSingle4D.Explicit( const V_:TSingle4D ) :TVector3D;
begin
     Result.X := +V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
     Result.W :=  V_.W;
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TSingle4D.IdentityX :TSingle4D;
begin
     Result.X := 1;
     Result.Y := 0;
     Result.Z := 0;
     Result.W := 0;
end;

class function TSingle4D.IdentityY :TSingle4D;
begin
     Result.X := 0;
     Result.Y := 1;
     Result.Z := 0;
     Result.W := 0;
end;

class function TSingle4D.IdentityZ :TSingle4D;
begin
     Result.X := 0;
     Result.Y := 0;
     Result.Z := 1;
     Result.W := 0;
end;

class function TSingle4D.IdentityW :TSingle4D;
begin
     Result.X := 0;
     Result.Y := 0;
     Result.Z := 0;
     Result.W := 1;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TSingle4D.VectorTo( const P_:TSingle4D ) :TSingle4D;
begin
     Result := P_ - Self;
end;

function TSingle4D.UnitorTo( const P_:TSingle4D ) :TSingle4D;
begin
     Result := VectorTo( P_ ).Unitor;
end;

function TSingle4D.DistanTo( const P_:TSingle4D ) :Single;
begin
     Result := VectorTo( P_ ).Size;
end;

//------------------------------------------------------------------------------

function TSingle4D.ToCart :TSingle3D;
begin
     Result.X := X / W;
     Result.Y := Y / W;
     Result.Z := Z / W;
end;

//------------------------------------------------------------------------------

class function TSingle4D.RandG :TSingle4D;
begin
     Result.X := TSingle.RandG;
     Result.Y := TSingle.RandG;
     Result.Z := TSingle.RandG;
     Result.W := TSingle.RandG;
end;

//------------------------------------------------------------------------------

class function TSingle4D.RandBS1 :TSingle4D;
begin
     Result.X := TSingle.RandBS1;
     Result.Y := TSingle.RandBS1;
     Result.Z := TSingle.RandBS1;
     Result.W := TSingle.RandBS1;
end;

class function TSingle4D.RandBS2 :TSingle4D;
begin
     Result.X := TSingle.RandBS2;
     Result.Y := TSingle.RandBS2;
     Result.Z := TSingle.RandBS2;
     Result.W := TSingle.RandBS2;
end;

class function TSingle4D.RandBS4 :TSingle4D;
begin
     Result.X := TSingle.RandBS4;
     Result.Y := TSingle.RandBS4;
     Result.Z := TSingle.RandBS4;
     Result.W := TSingle.RandBS4;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble4D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TDouble4D.GetD1( const X_:Integer ) :Double;
begin
     Result := _1D[ X_-1 ];
end;

procedure TDouble4D.SetD1( const X_:Integer; const D1_:Double );
begin
     _1D[ X_-1 ] := D1_;
end;

//------------------------------------------------------------------------------

function TDouble4D.GetSize2 :Double;
begin
     Result := Pow2( X ) + Pow2( Y ) + Pow2( Z ) + Pow2( W );
end;

procedure TDouble4D.SetSize2( const Size2_:Double );
begin
     Self := Roo2( Size2_ / Size2 ) * Self;
end;

function TDouble4D.GetSize :Double;
begin
     Result := Roo2( GetSize2 );
end;

procedure TDouble4D.SetSize( const Size_:Double );
begin
     Self := Size_ * Unitor;
end;

function TDouble4D.GetUnitor :TDouble4D;
begin
     Result := Self / Size;
end;

procedure TDouble4D.SetUnitor( const Unitor_:TDouble4D );
begin
     Self := Size * Unitor_;
end;

//------------------------------------------------------------------------------

function TDouble4D.GetOrthant :Byte;
begin
     Result := 0;
     if X >= 0 then Result := Result or 1;
     if Y >= 0 then Result := Result or 2;
     if Z >= 0 then Result := Result or 4;
     if W >= 0 then Result := Result or 8;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDouble4D.Create( const V_:Double );
begin
     X := V_;
     Y := V_;
     Z := V_;
     W := V_;
end;

constructor TDouble4D.Create( const X_,Y_,Z_,W_:Double );
begin
     X := X_;
     Y := Y_;
     Z := Z_;
     W := W_;
end;

constructor TDouble4D.Create( const P_:TDouble3D; const W_:Double );
begin
     X := P_.X ;
     Y := P_.Y ;
     Z := P_.Z ;
     W :=    W_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TDouble4D.Negative( const V_:TDouble4D ) :TDouble4D;
begin
     Result.X := -V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
     Result.W := -V_.W;
end;

class operator TDouble4D.Positive( const V_:TDouble4D ) :TDouble4D;
begin
     Result.X := +V_.X;
     Result.Y := +V_.Y;
     Result.Z := +V_.Z;
     Result.W := +V_.W;
end;

class operator TDouble4D.Add( const A_,B_:TDouble4D ) :TDouble4D;
begin
     Result.X := A_.X + B_.X;
     Result.Y := A_.Y + B_.Y;
     Result.Z := A_.Z + B_.Z;
     Result.W := A_.W + B_.W;
end;

class operator TDouble4D.Subtract( const A_,B_:TDouble4D ) :TDouble4D;
begin
     Result.X := A_.X - B_.X;
     Result.Y := A_.Y - B_.Y;
     Result.Z := A_.Z - B_.Z;
     Result.W := A_.W - B_.W;
end;

class operator TDouble4D.Multiply( const A_:TDouble4D; const B_:Double ) :TDouble4D;
begin
     Result.X := A_.X * B_;
     Result.Y := A_.Y * B_;
     Result.Z := A_.Z * B_;
     Result.W := A_.W * B_;
end;

class operator TDouble4D.Multiply( const A_:Double; const B_:TDouble4D ) :TDouble4D;
begin
     Result.X := A_ * B_.X;
     Result.Y := A_ * B_.Y;
     Result.Z := A_ * B_.Z;
     Result.W := A_ * B_.W;
end;

class operator TDouble4D.Divide( const A_:TDouble4D; const B_:Double ) :TDouble4D;
begin
     Result.X := A_.X / B_;
     Result.Y := A_.Y / B_;
     Result.Z := A_.Z / B_;
     Result.W := A_.W / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TDouble4D.Implicit( const V_:Double ) :TDouble4D;
begin
     Result.X := V_;
     Result.Y := V_;
     Result.Z := V_;
     Result.W := V_;
end;

class operator TDouble4D.Implicit( const V_:TDouble3D ) :TDouble4D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
     Result.W :=    0;
end;

class operator TDouble4D.Explicit( const V_:TDouble4D ) :TDouble3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

class operator TDouble4D.Implicit( const V_:TPoint3D ) :TDouble4D;
begin
     Result.X := +V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
     Result.W :=     0;
end;

class operator TDouble4D.Explicit( const V_:TDouble4D ) :TPoint3D;
begin
     Result.X := +V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
end;

class operator TDouble4D.Implicit( const V_:TVector3D ) :TDouble4D;
begin
     Result.X := +V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
     Result.W :=  V_.W;
end;

class operator TDouble4D.Explicit( const V_:TDouble4D ) :TVector3D;
begin
     Result.X := +V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
     Result.W :=  V_.W;
end;

class operator TDouble4D.Implicit( const V_:TSingle4D ) :TDouble4D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
     Result.W := V_.W;
end;

class operator TDouble4D.Explicit( const V_:TDouble4D ) :TSingle4D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
     Result.W := V_.W;
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TDouble4D.IdentityX :TDouble4D;
begin
     Result.X := 1;
     Result.Y := 0;
     Result.Z := 0;
     Result.W := 0;
end;

class function TDouble4D.IdentityY :TDouble4D;
begin
     Result.X := 0;
     Result.Y := 1;
     Result.Z := 0;
     Result.W := 0;
end;

class function TDouble4D.IdentityZ :TDouble4D;
begin
     Result.X := 0;
     Result.Y := 0;
     Result.Z := 1;
     Result.W := 0;
end;

class function TDouble4D.IdentityW :TDouble4D;
begin
     Result.X := 0;
     Result.Y := 0;
     Result.Z := 0;
     Result.W := 1;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TDouble4D.VectorTo( const P_:TDouble4D ) :TDouble4D;
begin
     Result := P_ - Self;
end;

function TDouble4D.UnitorTo( const P_:TDouble4D ) :TDouble4D;
begin
     Result := VectorTo( P_ ).Unitor;
end;

function TDouble4D.DistanTo( const P_:TDouble4D ) :Double;
begin
     Result := VectorTo( P_ ).Size;
end;

//------------------------------------------------------------------------------

function TDouble4D.ToCart :TDouble3D;
begin
     Result.X := X / W;
     Result.Y := Y / W;
     Result.Z := Z / W;
end;

//------------------------------------------------------------------------------

class function TDouble4D.RandG :TDouble4D;
begin
     Result.X := TDouble.RandG;
     Result.Y := TDouble.RandG;
     Result.Z := TDouble.RandG;
     Result.W := TDouble.RandG;
end;

//------------------------------------------------------------------------------

class function TDouble4D.RandBS1 :TDouble4D;
begin
     Result.X := TDouble.RandBS1;
     Result.Y := TDouble.RandBS1;
     Result.Z := TDouble.RandBS1;
     Result.W := TDouble.RandBS1;
end;

class function TDouble4D.RandBS2 :TDouble4D;
begin
     Result.X := TDouble.RandBS2;
     Result.Y := TDouble.RandBS2;
     Result.Z := TDouble.RandBS2;
     Result.W := TDouble.RandBS2;
end;

class function TDouble4D.RandBS4 :TDouble4D;
begin
     Result.X := TDouble.RandBS4;
     Result.Y := TDouble.RandBS4;
     Result.Z := TDouble.RandBS4;
     Result.W := TDouble.RandBS4;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angle

function Angle( const V0_,V1_:TSingle4D ) :Single;
begin
     Result := ArcCos( Clamp( DotProduct( V0_, V1_ ), -1, +1 ) );
end;

function Angle( const V0_,V1_:TDouble4D ) :Double;
begin
     Result := ArcCos( Clamp( DotProduct( V0_, V1_ ), -1, +1 ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DotProduct

function DotProduct( const A_,B_:TSingle4D ) :Single;
begin
     Result := A_.X * B_.X
             + A_.Y * B_.Y
             + A_.Z * B_.Z
             + A_.W * B_.W;
end;

function DotProduct( const A_,B_:TDouble4D ) :Double;
begin
     Result := A_.X * B_.X
             + A_.Y * B_.Y
             + A_.Z * B_.Z
             + A_.W * B_.W;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CrossProduct

function CrossProduct( const A_,B_,C_:TSingle4D ) :TSingle4D;
begin
     Result.X := A_.Y * B_.Z * C_.W - A_.W * B_.Z * C_.Y
               + B_.Y * C_.Z * A_.W - B_.W * C_.Z * A_.Y
               + C_.Y * A_.Z * B_.W - C_.W * A_.Z * B_.Y;

     Result.Y := A_.X * B_.W * C_.Z - A_.Z * B_.W * C_.X
               + B_.X * C_.W * A_.Z - B_.Z * C_.W * A_.X
               + C_.X * A_.W * B_.Z - C_.Z * A_.W * B_.X;

     Result.Z := A_.W * B_.X * C_.Y - A_.Y * B_.X * C_.W
               + B_.W * C_.X * A_.Y - B_.Y * C_.X * A_.W
               + C_.W * A_.X * B_.Y - C_.Y * A_.X * B_.W;

     Result.W := A_.Z * B_.Y * C_.X - A_.X * B_.Y * C_.Z
               + B_.Z * C_.Y * A_.X - B_.X * C_.Y * A_.Z
               + C_.Z * A_.Y * B_.X - C_.X * A_.Y * B_.Z;
end;

function CrossProduct( const A_,B_,C_:TDouble4D ) :TDouble4D;
begin
     Result.X := A_.Y * B_.Z * C_.W - A_.W * B_.Z * C_.Y
               + B_.Y * C_.Z * A_.W - B_.W * C_.Z * A_.Y
               + C_.Y * A_.Z * B_.W - C_.W * A_.Z * B_.Y;

     Result.Y := A_.X * B_.W * C_.Z - A_.Z * B_.W * C_.X
               + B_.X * C_.W * A_.Z - B_.Z * C_.W * A_.X
               + C_.X * A_.W * B_.Z - C_.Z * A_.W * B_.X;

     Result.Z := A_.W * B_.X * C_.Y - A_.Y * B_.X * C_.W
               + B_.W * C_.X * A_.Y - B_.Y * C_.X * A_.W
               + C_.W * A_.X * B_.Y - C_.Y * A_.X * B_.W;

     Result.W := A_.Z * B_.Y * C_.X - A_.X * B_.Y * C_.Z
               + B_.Z * C_.Y * A_.X - B_.X * C_.Y * A_.Z
               + C_.Z * A_.Y * B_.X - C_.X * A_.Y * B_.Z;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distance

function Distance2( const A_,B_:TSingle4D ) :Single;
begin
     Result := Pow2( B_.X - A_.X )
             + Pow2( B_.Y - A_.Y )
             + Pow2( B_.Z - A_.Z )
             + Pow2( B_.W - A_.W );
end;

function Distance2( const A_,B_:TDouble4D ) :Double;
begin
     Result := Pow2( B_.X - A_.X )
             + Pow2( B_.Y - A_.Y )
             + Pow2( B_.Z - A_.Z )
             + Pow2( B_.W - A_.W );
end;

//------------------------------------------------------------------------------

function Distance( const A_,B_:TSingle4D ) :Single;
begin
     Result := Roo2( Distance2( A_, B_ ) );
end;

function Distance( const A_,B_:TDouble4D ) :Double;
begin
     Result := Roo2( Distance2( A_, B_ ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ave

function Ave( const P1_,P2_:TSingle4D ) :TSingle4D;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

function Ave( const P1_,P2_:TDouble4D ) :TDouble4D;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

//------------------------------------------------------------------------------

function Ave( const P1_,P2_,P3_:TSingle4D ) :TSingle4D;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

function Ave( const P1_,P2_,P3_:TDouble4D ) :TDouble4D;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

//------------------------------------------------------------------------------

function Ave( const P1_,P2_,P3_,P4_:TSingle4D ) :TSingle4D;
begin
     Result := ( P1_ + P2_ + P3_ + P4_ ) / 4;
end;

function Ave( const P1_,P2_,P3_,P4_:TDouble4D ) :TDouble4D;
begin
     Result := ( P1_ + P2_ + P3_ + P4_ ) / 4;
end;

end. //######################################################################### ■
