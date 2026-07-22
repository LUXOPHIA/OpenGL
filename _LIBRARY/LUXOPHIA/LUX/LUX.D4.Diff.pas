unit LUX.D4.Diff;

interface //#################################################################### ■

uses System.Math.Vectors,
     LUX, LUX.D4,
     LUX.D1.Diff, LUX.D3.Diff;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle4D

     TdSingle4D = record
     private
       ///// A C C E S S O R
       function GetD1( const X_:Integer ) :TdSingle;
       procedure SetD1( const X_:Integer; const D1_:TdSingle );
       function GetSize2 :TdSingle;
       procedure SetSize2( const Size2_:TdSingle );
       function GetSize :TdSingle;
       procedure SetSize( const Size_:TdSingle );
       function GetUnitor :TdSingle4D;
       procedure SetUnitor( const Unitor_:TdSingle4D );
     public
       constructor Create( const V_:TdSingle ); overload;
       constructor Create( const X_,Y_,Z_,W_:TdSingle ); overload;
       constructor Create( const P_:TdSingle3D; const W_:TdSingle ); overload;
       ///// P R O P E R T Y
       property D1[ const X_:Integer ] :TdSingle    read GetD1     write SetD1    ; default;
       property Size2                  :TdSingle    read GetSize2  write SetSize2 ;
       property Size                   :TdSingle    read GetSize   write SetSize  ;
       property Unitor                 :TdSingle4D read GetUnitor write SetUnitor;
       ///// O P E R A T O R
       class operator Negative( const V_:TdSingle4D ) :TdSingle4D;
       class operator Positive( const V_:TdSingle4D ) :TdSingle4D;
       class operator Add( const A_,B_:TdSingle4D ) :TdSingle4D;
       class operator Subtract( const A_,B_:TdSingle4D ) :TdSingle4D;
       class operator Multiply( const A_:TdSingle4D; const B_:TdSingle ) :TdSingle4D;
       class operator Multiply( const A_:TdSingle; const B_:TdSingle4D ) :TdSingle4D;
       class operator Divide( const A_:TdSingle4D; const B_:TdSingle ) :TdSingle4D;
       ///// C A S T
       class operator Implicit( const V_:Integer ) :TdSingle4D;
       class operator Implicit( const V_:Int64 ) :TdSingle4D;
       class operator Implicit( const V_:Single ) :TdSingle4D;
       class operator Implicit( const V_:TdSingle ) :TdSingle4D;
       class operator Implicit( const V_:TSingle4D ) :TdSingle4D;
       class operator Implicit( const V_:TdSingle3D ) :TdSingle4D;
       class operator Explicit( const V_:TdSingle4D ) :TdSingle3D;
       class operator Implicit( const V_:TPoint3D ) :TdSingle4D;
       class operator Explicit( const V_:TdSingle4D ) :TPoint3D;
       class operator Implicit( const V_:TVector3D ) :TdSingle4D;
       class operator Explicit( const V_:TdSingle4D ) :TVector3D;
       ///// C O N S T A N T
       class function IdentityX :TdSingle4D; static;
       class function IdentityY :TdSingle4D; static;
       class function IdentityZ :TdSingle4D; static;
       class function IdentityW :TdSingle4D; static;
       ///// M E T H O D
       function VectorTo( const P_:TdSingle4D ) :TdSingle4D;
       function UnitorTo( const P_:TdSingle4D ) :TdSingle4D;
       function DistanTo( const P_:TdSingle4D ) :TdSingle;
       function ToCart :TdSingle3D;
       class function RandG :TdSingle4D; static;
       class function RandBS1 :TdSingle4D; static;
       class function RandBS2 :TdSingle4D; static;
       class function RandBS4 :TdSingle4D; static;
       ///// F I E L D
     case Integer of
      0:( _1D :array [ 0..4-1 ] of TdSingle );
      1:( _1  :TdSingle;
          _2  :TdSingle;
          _3  :TdSingle;
          _4  :TdSingle;                    );
      2:(  X  :TdSingle;
           Y  :TdSingle;
           Z  :TdSingle;
           W  :TdSingle;                    );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble4D

     TdDouble4D = record
     private
       ///// A C C E S S O R
       function GetD1( const X_:Integer ) :TdDouble;
       procedure SetD1( const X_:Integer; const D1_:TdDouble );
       function GetSize2 :TdDouble;
       procedure SetSize2( const Size2_:TdDouble );
       function GetSize :TdDouble;
       procedure SetSize( const Size_:TdDouble );
       function GetUnitor :TdDouble4D;
       procedure SetUnitor( const Unitor_:TdDouble4D );
     public
       constructor Create( const V_:TdDouble ); overload;
       constructor Create( const X_,Y_,Z_,W_:TdDouble ); overload;
       constructor Create( const P_:TdDouble3D; const W_:TdDouble ); overload;
       ///// P R O P E R T Y
       property D1[ const X_:Integer ] :TdDouble    read GetD1     write SetD1    ; default;
       property Size2                  :TdDouble    read GetSize2  write SetSize2 ;
       property Size                   :TdDouble    read GetSize   write SetSize  ;
       property Unitor                 :TdDouble4D read GetUnitor write SetUnitor;
       ///// O P E R A T O R
       class operator Negative( const V_:TdDouble4D ) :TdDouble4D;
       class operator Positive( const V_:TdDouble4D ) :TdDouble4D;
       class operator Add( const A_,B_:TdDouble4D ) :TdDouble4D;
       class operator Subtract( const A_,B_:TdDouble4D ) :TdDouble4D;
       class operator Multiply( const A_:TdDouble4D; const B_:TdDouble ) :TdDouble4D;
       class operator Multiply( const A_:TdDouble; const B_:TdDouble4D ) :TdDouble4D;
       class operator Divide( const A_:TdDouble4D; const B_:TdDouble ) :TdDouble4D;
       ///// C A S T
       class operator Implicit( const V_:Integer ) :TdDouble4D;
       class operator Implicit( const V_:Int64 ) :TdDouble4D;
       class operator Implicit( const V_:Double ) :TdDouble4D;
       class operator Implicit( const V_:TdDouble ) :TdDouble4D;
       class operator Implicit( const V_:TDouble4D ) :TdDouble4D;
       class operator Implicit( const V_:TdDouble3D ) :TdDouble4D;
       class operator Explicit( const V_:TdDouble4D ) :TdDouble3D;
       class operator Implicit( const V_:TPoint3D ) :TdDouble4D;
       class operator Explicit( const V_:TdDouble4D ) :TPoint3D;
       class operator Implicit( const V_:TVector3D ) :TdDouble4D;
       class operator Explicit( const V_:TdDouble4D ) :TVector3D;
       class operator Implicit( const V_:TdSingle4D ) :TdDouble4D;
       class operator Explicit( const V_:TdDouble4D ) :TdSingle4D;
       ///// C O N S T A N T
       class function IdentityX :TdDouble4D; static;
       class function IdentityY :TdDouble4D; static;
       class function IdentityZ :TdDouble4D; static;
       class function IdentityW :TdDouble4D; static;
       ///// M E T H O D
       function VectorTo( const P_:TdDouble4D ) :TdDouble4D;
       function UnitorTo( const P_:TdDouble4D ) :TdDouble4D;
       function DistanTo( const P_:TdDouble4D ) :TdDouble;
       function ToCart :TdDouble3D;
       class function RandG :TdDouble4D; static;
       class function RandBS1 :TdDouble4D; static;
       class function RandBS2 :TdDouble4D; static;
       class function RandBS4 :TdDouble4D; static;
       ///// F I E L D
     case Integer of
      0:( _1D :array [ 0..4-1 ] of TdDouble );
      1:( _1  :TdDouble;
          _2  :TdDouble;
          _3  :TdDouble;
          _4  :TdDouble;                    );
      2:(  X  :TdDouble;
           Y  :TdDouble;
           Z  :TdDouble;
           W  :TdDouble;                    );
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angle

function Angle( const V0_,V1_:TdSingle4D ) :TdSingle; overload;  //= 0..Pi
function Angle( const V0_,V1_:TdDouble4D ) :TdDouble; overload;  //= 0..Pi

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DotProduct

function DotProduct( const A_,B_:TdSingle4D ) :TdSingle; overload;
function DotProduct( const A_,B_:TdDouble4D ) :TdDouble; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CrossProduct

function CrossProduct( const A_,B_,C_:TdSingle4D ) :TdSingle4D; overload;
function CrossProduct( const A_,B_,C_:TdDouble4D ) :TdDouble4D; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distance

function Distance2( const A_,B_:TdSingle4D ) :TdSingle; overload;
function Distance2( const A_,B_:TdDouble4D ) :TdDouble; overload;

function Distance( const A_,B_:TdSingle4D ) :TdSingle; overload;
function Distance( const A_,B_:TdDouble4D ) :TdDouble; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ave

function Ave( const P1_,P2_:TdSingle4D ) :TdSingle4D; overload;
function Ave( const P1_,P2_:TdDouble4D ) :TdDouble4D; overload;

function Ave( const P1_,P2_,P3_:TdSingle4D ) :TdSingle4D; overload;
function Ave( const P1_,P2_,P3_:TdDouble4D ) :TdDouble4D; overload;

function Ave( const P1_,P2_,P3_,P4_:TdSingle4D ) :TdSingle4D; overload;
function Ave( const P1_,P2_,P3_,P4_:TdDouble4D ) :TdDouble4D; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle4D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdSingle4D.GetD1( const X_:Integer ) :TdSingle;
begin
     Result := _1D[ X_-1 ];
end;

procedure TdSingle4D.SetD1( const X_:Integer; const D1_:TdSingle );
begin
     _1D[ X_-1 ] := D1_;
end;

//------------------------------------------------------------------------------

function TdSingle4D.GetSize2 :TdSingle;
begin
     Result := Pow2( X ) + Pow2( Y ) + Pow2( Z ) + Pow2( W );
end;

procedure TdSingle4D.SetSize2( const Size2_:TdSingle );
begin
     Self := Roo2( Size2_ / Size2 ) * Self;
end;

function TdSingle4D.GetSize :TdSingle;
begin
     Result := Roo2( GetSize2 );
end;

procedure TdSingle4D.SetSize( const Size_:TdSingle );
begin
     Self := Size_ * Unitor;
end;

function TdSingle4D.GetUnitor :TdSingle4D;
begin
     Result := Self / Size;
end;

procedure TdSingle4D.SetUnitor( const Unitor_:TdSingle4D );
begin
     Self := Size * Unitor_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdSingle4D.Create( const V_:TdSingle );
begin
     X := V_;
     Y := V_;
     Z := V_;
     W := V_;
end;

constructor TdSingle4D.Create( const X_,Y_,Z_,W_:TdSingle );
begin
     X := X_;
     Y := Y_;
     Z := Z_;
     W := W_;
end;

constructor TdSingle4D.Create( const P_:TdSingle3D; const W_:TdSingle );
begin
     X := P_.X ;
     Y := P_.Y ;
     Z := P_.Z ;
     W :=    W_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdSingle4D.Negative( const V_:TdSingle4D ) :TdSingle4D;
begin
     with Result do
     begin
          X := -V_.X;
          Y := -V_.Y;
          Z := -V_.Z;
          W := -V_.W;
     end;
end;

class operator TdSingle4D.Positive( const V_:TdSingle4D ) :TdSingle4D;
begin
     with Result do
     begin
          X := +V_.X;
          Y := +V_.Y;
          Z := +V_.Z;
          W := +V_.W;
     end;
end;

class operator TdSingle4D.Add( const A_,B_:TdSingle4D ) :TdSingle4D;
begin
     with Result do
     begin
          X := A_.X + B_.X;
          Y := A_.Y + B_.Y;
          Z := A_.Z + B_.Z;
          W := A_.W + B_.W;
     end;
end;

class operator TdSingle4D.Subtract( const A_,B_:TdSingle4D ) :TdSingle4D;
begin
     with Result do
     begin
          X := A_.X - B_.X;
          Y := A_.Y - B_.Y;
          Z := A_.Z - B_.Z;
          W := A_.W - B_.W;
     end;
end;

class operator TdSingle4D.Multiply( const A_:TdSingle4D; const B_:TdSingle ) :TdSingle4D;
begin
     with Result do
     begin
          X := A_.X * B_;
          Y := A_.Y * B_;
          Z := A_.Z * B_;
          W := A_.W * B_;
     end;
end;

class operator TdSingle4D.Multiply( const A_:TdSingle; const B_:TdSingle4D ) :TdSingle4D;
begin
     with Result do
     begin
          X := A_ * B_.X;
          Y := A_ * B_.Y;
          Z := A_ * B_.Z;
          W := A_ * B_.W;
     end;
end;

class operator TdSingle4D.Divide( const A_:TdSingle4D; const B_:TdSingle ) :TdSingle4D;
begin
     with Result do
     begin
          X := A_.X / B_;
          Y := A_.Y / B_;
          Z := A_.Z / B_;
          W := A_.W / B_;
     end;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TdSingle4D.Implicit( const V_:Integer ) :TdSingle4D;
begin
     with Result do
     begin
          X := V_;
          Y := V_;
          Z := V_;
          W := V_;
     end;
end;

class operator TdSingle4D.Implicit( const V_:Int64 ) :TdSingle4D;
begin
     with Result do
     begin
          X := V_;
          Y := V_;
          Z := V_;
          W := V_;
     end;
end;

class operator TdSingle4D.Implicit( const V_:Single ) :TdSingle4D;
begin
     with Result do
     begin
          X := V_;
          Y := V_;
          Z := V_;
          W := V_;
     end;
end;

class operator TdSingle4D.Implicit( const V_:TdSingle ) :TdSingle4D;
begin
     with Result do
     begin
          X := V_;
          Y := V_;
          Z := V_;
          W := V_;
     end;
end;

class operator TdSingle4D.Implicit( const V_:TSingle4D ) :TdSingle4D;
begin
     with Result do
     begin
          X := V_.X;
          Y := V_.Y;
          Z := V_.Z;
          W := V_.W;
     end;
end;

class operator TdSingle4D.Implicit( const V_:TdSingle3D ) :TdSingle4D;
begin
     with Result do
     begin
          X := V_.X;
          Y := V_.Y;
          Z := V_.Z;
          W :=    0;
     end;
end;

class operator TdSingle4D.Explicit( const V_:TdSingle4D ) :TdSingle3D;
begin
     with Result do
     begin
          X := V_.X;
          Y := V_.Y;
          Z := V_.Z;
     end;
end;

class operator TdSingle4D.Implicit( const V_:TPoint3D ) :TdSingle4D;
begin
     with Result do
     begin
          X := +V_.X;
          Y := -V_.Y;
          Z := -V_.Z;
          W :=     0;
     end;
end;

class operator TdSingle4D.Explicit( const V_:TdSingle4D ) :TPoint3D;
begin
     with Result do
     begin
          X := +V_.X.o;
          Y := -V_.Y.o;
          Z := -V_.Z.o;
     end;
end;

class operator TdSingle4D.Implicit( const V_:TVector3D ) :TdSingle4D;
begin
     with Result do
     begin
          X := +V_.X;
          Y := -V_.Y;
          Z := -V_.Z;
          W :=  V_.W;
     end;
end;

class operator TdSingle4D.Explicit( const V_:TdSingle4D ) :TVector3D;
begin
     with Result do
     begin
          X := +V_.X.o;
          Y := -V_.Y.o;
          Z := -V_.Z.o;
          W :=  V_.W.o;
     end;
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TdSingle4D.IdentityX :TdSingle4D;
begin
     with Result do
     begin
          X := 1;
          Y := 0;
          Z := 0;
          W := 0;
     end;
end;

class function TdSingle4D.IdentityY :TdSingle4D;
begin
     with Result do
     begin
          X := 0;
          Y := 1;
          Z := 0;
          W := 0;
     end;
end;

class function TdSingle4D.IdentityZ :TdSingle4D;
begin
     with Result do
     begin
          X := 0;
          Y := 0;
          Z := 1;
          W := 0;
     end;
end;

class function TdSingle4D.IdentityW :TdSingle4D;
begin
     with Result do
     begin
          X := 0;
          Y := 0;
          Z := 0;
          W := 1;
     end;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TdSingle4D.VectorTo( const P_:TdSingle4D ) :TdSingle4D;
begin
     Result := P_ - Self;
end;

function TdSingle4D.UnitorTo( const P_:TdSingle4D ) :TdSingle4D;
begin
     Result := VectorTo( P_ ).Unitor;
end;

function TdSingle4D.DistanTo( const P_:TdSingle4D ) :TdSingle;
begin
     Result := VectorTo( P_ ).Size;
end;

//------------------------------------------------------------------------------

function TdSingle4D.ToCart :TdSingle3D;
begin
     Result.X := X / W;
     Result.Y := Y / W;
     Result.Z := Z / W;
end;

//------------------------------------------------------------------------------

class function TdSingle4D.RandG :TdSingle4D;
begin
     with Result do
     begin
          X := TdSingle.RandG;
          Y := TdSingle.RandG;
          Z := TdSingle.RandG;
          W := TdSingle.RandG;
     end;
end;

//------------------------------------------------------------------------------

class function TdSingle4D.RandBS1 :TdSingle4D;
begin
     with Result do
     begin
          X := TdSingle.RandBS1;
          Y := TdSingle.RandBS1;
          Z := TdSingle.RandBS1;
          W := TdSingle.RandBS1;
     end;
end;

class function TdSingle4D.RandBS2 :TdSingle4D;
begin
     with Result do
     begin
          X := TdSingle.RandBS2;
          Y := TdSingle.RandBS2;
          Z := TdSingle.RandBS2;
          W := TdSingle.RandBS2;
     end;
end;

class function TdSingle4D.RandBS4 :TdSingle4D;
begin
     with Result do
     begin
          X := TdSingle.RandBS4;
          Y := TdSingle.RandBS4;
          Z := TdSingle.RandBS4;
          W := TdSingle.RandBS4;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble4D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdDouble4D.GetD1( const X_:Integer ) :TdDouble;
begin
     Result := _1D[ X_-1 ];
end;

procedure TdDouble4D.SetD1( const X_:Integer; const D1_:TdDouble );
begin
     _1D[ X_-1 ] := D1_;
end;

//------------------------------------------------------------------------------

function TdDouble4D.GetSize2 :TdDouble;
begin
     Result := Pow2( X ) + Pow2( Y ) + Pow2( Z ) + Pow2( W );
end;

procedure TdDouble4D.SetSize2( const Size2_:TdDouble );
begin
     Self := Roo2( Size2_ / Size2 ) * Self;
end;

function TdDouble4D.GetSize :TdDouble;
begin
     Result := Roo2( GetSize2 );
end;

procedure TdDouble4D.SetSize( const Size_:TdDouble );
begin
     Self := Size_ * Unitor;
end;

function TdDouble4D.GetUnitor :TdDouble4D;
begin
     Result := Self / Size;
end;

procedure TdDouble4D.SetUnitor( const Unitor_:TdDouble4D );
begin
     Self := Size * Unitor_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdDouble4D.Create( const V_:TdDouble );
begin
     X := V_;
     Y := V_;
     Z := V_;
     W := V_;
end;

constructor TdDouble4D.Create( const X_,Y_,Z_,W_:TdDouble );
begin
     X := X_;
     Y := Y_;
     Z := Z_;
     W := W_;
end;

constructor TdDouble4D.Create( const P_:TdDouble3D; const W_:TdDouble );
begin
     X := P_.X ;
     Y := P_.Y ;
     Z := P_.Z ;
     W :=    W_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdDouble4D.Negative( const V_:TdDouble4D ) :TdDouble4D;
begin
     with Result do
     begin
          X := -V_.X;
          Y := -V_.Y;
          Z := -V_.Z;
          W := -V_.W;
     end;
end;

class operator TdDouble4D.Positive( const V_:TdDouble4D ) :TdDouble4D;
begin
     with Result do
     begin
          X := +V_.X;
          Y := +V_.Y;
          Z := +V_.Z;
          W := +V_.W;
     end;
end;

class operator TdDouble4D.Add( const A_,B_:TdDouble4D ) :TdDouble4D;
begin
     with Result do
     begin
          X := A_.X + B_.X;
          Y := A_.Y + B_.Y;
          Z := A_.Z + B_.Z;
          W := A_.W + B_.W;
     end;
end;

class operator TdDouble4D.Subtract( const A_,B_:TdDouble4D ) :TdDouble4D;
begin
     with Result do
     begin
          X := A_.X - B_.X;
          Y := A_.Y - B_.Y;
          Z := A_.Z - B_.Z;
          W := A_.W - B_.W;
     end;
end;

class operator TdDouble4D.Multiply( const A_:TdDouble4D; const B_:TdDouble ) :TdDouble4D;
begin
     with Result do
     begin
          X := A_.X * B_;
          Y := A_.Y * B_;
          Z := A_.Z * B_;
          W := A_.W * B_;
     end;
end;

class operator TdDouble4D.Multiply( const A_:TdDouble; const B_:TdDouble4D ) :TdDouble4D;
begin
     with Result do
     begin
          X := A_ * B_.X;
          Y := A_ * B_.Y;
          Z := A_ * B_.Z;
          W := A_ * B_.W;
     end;
end;

class operator TdDouble4D.Divide( const A_:TdDouble4D; const B_:TdDouble ) :TdDouble4D;
begin
     with Result do
     begin
          X := A_.X / B_;
          Y := A_.Y / B_;
          Z := A_.Z / B_;
          W := A_.W / B_;
     end;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TdDouble4D.Implicit( const V_:Integer ) :TdDouble4D;
begin
     with Result do
     begin
          X := V_;
          Y := V_;
          Z := V_;
          W := V_;
     end;
end;

class operator TdDouble4D.Implicit( const V_:Int64 ) :TdDouble4D;
begin
     with Result do
     begin
          X := V_;
          Y := V_;
          Z := V_;
          W := V_;
     end;
end;

class operator TdDouble4D.Implicit( const V_:Double ) :TdDouble4D;
begin
     with Result do
     begin
          X := V_;
          Y := V_;
          Z := V_;
          W := V_;
     end;
end;

class operator TdDouble4D.Implicit( const V_:TdDouble ) :TdDouble4D;
begin
     with Result do
     begin
          X := V_;
          Y := V_;
          Z := V_;
          W := V_;
     end;
end;

class operator TdDouble4D.Implicit( const V_:TDouble4D ) :TdDouble4D;
begin
     with Result do
     begin
          X := V_.X;
          Y := V_.Y;
          Z := V_.Z;
          W := V_.W;
     end;
end;

class operator TdDouble4D.Implicit( const V_:TdDouble3D ) :TdDouble4D;
begin
     with Result do
     begin
          X := V_.X;
          Y := V_.Y;
          Z := V_.Z;
          W :=    0;
     end;
end;

class operator TdDouble4D.Explicit( const V_:TdDouble4D ) :TdDouble3D;
begin
     with Result do
     begin
          X := V_.X;
          Y := V_.Y;
          Z := V_.Z;
     end;
end;

class operator TdDouble4D.Implicit( const V_:TPoint3D ) :TdDouble4D;
begin
     with Result do
     begin
          X := +V_.X;
          Y := -V_.Y;
          Z := -V_.Z;
          W :=     0;
     end;
end;

class operator TdDouble4D.Explicit( const V_:TdDouble4D ) :TPoint3D;
begin
     with Result do
     begin
          X := +V_.X.o;
          Y := -V_.Y.o;
          Z := -V_.Z.o;
     end;
end;

class operator TdDouble4D.Implicit( const V_:TVector3D ) :TdDouble4D;
begin
     with Result do
     begin
          X := +V_.X;
          Y := -V_.Y;
          Z := -V_.Z;
          W :=  V_.W;
     end;
end;

class operator TdDouble4D.Explicit( const V_:TdDouble4D ) :TVector3D;
begin
     with Result do
     begin
          X := +V_.X.o;
          Y := -V_.Y.o;
          Z := -V_.Z.o;
          W :=  V_.W.o;
     end;
end;

class operator TdDouble4D.Implicit( const V_:TdSingle4D ) :TdDouble4D;
begin
     with Result do
     begin
          X := V_.X;
          Y := V_.Y;
          Z := V_.Z;
          W := V_.W;
     end;
end;

class operator TdDouble4D.Explicit( const V_:TdDouble4D ) :TdSingle4D;
begin
     with Result do
     begin
          X := TdSingle( V_.X );
          Y := TdSingle( V_.Y );
          Z := TdSingle( V_.Z );
          W := TdSingle( V_.W );
     end;
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TdDouble4D.IdentityX :TdDouble4D;
begin
     with Result do
     begin
          X := 1;
          Y := 0;
          Z := 0;
          W := 0;
     end;
end;

class function TdDouble4D.IdentityY :TdDouble4D;
begin
     with Result do
     begin
          X := 0;
          Y := 1;
          Z := 0;
          W := 0;
     end;
end;

class function TdDouble4D.IdentityZ :TdDouble4D;
begin
     with Result do
     begin
          X := 0;
          Y := 0;
          Z := 1;
          W := 0;
     end;
end;

class function TdDouble4D.IdentityW :TdDouble4D;
begin
     with Result do
     begin
          X := 0;
          Y := 0;
          Z := 0;
          W := 1;
     end;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TdDouble4D.VectorTo( const P_:TdDouble4D ) :TdDouble4D;
begin
     Result := P_ - Self;
end;

function TdDouble4D.UnitorTo( const P_:TdDouble4D ) :TdDouble4D;
begin
     Result := VectorTo( P_ ).Unitor;
end;

function TdDouble4D.DistanTo( const P_:TdDouble4D ) :TdDouble;
begin
     Result := VectorTo( P_ ).Size;
end;

//------------------------------------------------------------------------------

function TdDouble4D.ToCart :TdDouble3D;
begin
     Result.X := X / W;
     Result.Y := Y / W;
     Result.Z := Z / W;
end;

//------------------------------------------------------------------------------

class function TdDouble4D.RandG :TdDouble4D;
begin
     with Result do
     begin
          X := TdDouble.RandG;
          Y := TdDouble.RandG;
          Z := TdDouble.RandG;
          W := TdDouble.RandG;
     end;
end;

//------------------------------------------------------------------------------

class function TdDouble4D.RandBS1 :TdDouble4D;
begin
     with Result do
     begin
          X := TdDouble.RandBS1;
          Y := TdDouble.RandBS1;
          Z := TdDouble.RandBS1;
          W := TdDouble.RandBS1;
     end;
end;

class function TdDouble4D.RandBS2 :TdDouble4D;
begin
     with Result do
     begin
          X := TdDouble.RandBS2;
          Y := TdDouble.RandBS2;
          Z := TdDouble.RandBS2;
          W := TdDouble.RandBS2;
     end;
end;

class function TdDouble4D.RandBS4 :TdDouble4D;
begin
     with Result do
     begin
          X := TdDouble.RandBS4;
          Y := TdDouble.RandBS4;
          Z := TdDouble.RandBS4;
          W := TdDouble.RandBS4;
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angle

function Angle( const V0_,V1_:TdSingle4D ) :TdSingle;
begin
     Result := ArcCos( Min( Max( DotProduct( V0_, V1_ ), -1 ), +1 ) );
end;

function Angle( const V0_,V1_:TdDouble4D ) :TdDouble;
begin
     Result := ArcCos( Min( Max( DotProduct( V0_, V1_ ), -1 ), +1 ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DotProduct

function DotProduct( const A_,B_:TdSingle4D ) :TdSingle;
begin
     Result := A_.X * B_.X
             + A_.Y * B_.Y
             + A_.Z * B_.Z
             + A_.W * B_.W;
end;

function DotProduct( const A_,B_:TdDouble4D ) :TdDouble;
begin
     Result := A_.X * B_.X
             + A_.Y * B_.Y
             + A_.Z * B_.Z
             + A_.W * B_.W;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CrossProduct

function CrossProduct( const A_,B_,C_:TdSingle4D ) :TdSingle4D;
begin
     with Result do
     begin
          X := A_.Y * B_.Z * C_.W - A_.W * B_.Z * C_.Y
             + B_.Y * C_.Z * A_.W - B_.W * C_.Z * A_.Y
             + C_.Y * A_.Z * B_.W - C_.W * A_.Z * B_.Y;

          Y := A_.X * B_.W * C_.Z - A_.Z * B_.W * C_.X
             + B_.X * C_.W * A_.Z - B_.Z * C_.W * A_.X
             + C_.X * A_.W * B_.Z - C_.Z * A_.W * B_.X;

          Z := A_.W * B_.X * C_.Y - A_.Y * B_.X * C_.W
             + B_.W * C_.X * A_.Y - B_.Y * C_.X * A_.W
             + C_.W * A_.X * B_.Y - C_.Y * A_.X * B_.W;

          W := A_.Z * B_.Y * C_.X - A_.X * B_.Y * C_.Z
             + B_.Z * C_.Y * A_.X - B_.X * C_.Y * A_.Z
             + C_.Z * A_.Y * B_.X - C_.X * A_.Y * B_.Z;
     end;
end;

function CrossProduct( const A_,B_,C_:TdDouble4D ) :TdDouble4D;
begin
     with Result do
     begin
          X := A_.Y * B_.Z * C_.W - A_.W * B_.Z * C_.Y
             + B_.Y * C_.Z * A_.W - B_.W * C_.Z * A_.Y
             + C_.Y * A_.Z * B_.W - C_.W * A_.Z * B_.Y;

          Y := A_.X * B_.W * C_.Z - A_.Z * B_.W * C_.X
             + B_.X * C_.W * A_.Z - B_.Z * C_.W * A_.X
             + C_.X * A_.W * B_.Z - C_.Z * A_.W * B_.X;

          Z := A_.W * B_.X * C_.Y - A_.Y * B_.X * C_.W
             + B_.W * C_.X * A_.Y - B_.Y * C_.X * A_.W
             + C_.W * A_.X * B_.Y - C_.Y * A_.X * B_.W;

          W := A_.Z * B_.Y * C_.X - A_.X * B_.Y * C_.Z
             + B_.Z * C_.Y * A_.X - B_.X * C_.Y * A_.Z
             + C_.Z * A_.Y * B_.X - C_.X * A_.Y * B_.Z;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distance

function Distance2( const A_,B_:TdSingle4D ) :TdSingle;
begin
     Result := Pow2( B_.X - A_.X )
             + Pow2( B_.Y - A_.Y )
             + Pow2( B_.Z - A_.Z )
             + Pow2( B_.W - A_.W );
end;

function Distance2( const A_,B_:TdDouble4D ) :TdDouble;
begin
     Result := Pow2( B_.X - A_.X )
             + Pow2( B_.Y - A_.Y )
             + Pow2( B_.Z - A_.Z )
             + Pow2( B_.W - A_.W );
end;

//------------------------------------------------------------------------------

function Distance( const A_,B_:TdSingle4D ) :TdSingle;
begin
     Result := Roo2( Distance2( A_, B_ ) );
end;

function Distance( const A_,B_:TdDouble4D ) :TdDouble;
begin
     Result := Roo2( Distance2( A_, B_ ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ave

function Ave( const P1_,P2_:TdSingle4D ) :TdSingle4D;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

function Ave( const P1_,P2_:TdDouble4D ) :TdDouble4D;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

//------------------------------------------------------------------------------

function Ave( const P1_,P2_,P3_:TdSingle4D ) :TdSingle4D;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

function Ave( const P1_,P2_,P3_:TdDouble4D ) :TdDouble4D;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

//------------------------------------------------------------------------------

function Ave( const P1_,P2_,P3_,P4_:TdSingle4D ) :TdSingle4D;
begin
     Result := ( P1_ + P2_ + P3_ + P4_ ) / 4;
end;

function Ave( const P1_,P2_,P3_,P4_:TdDouble4D ) :TdDouble4D;
begin
     Result := ( P1_ + P2_ + P3_ + P4_ ) / 4;
end;

end. //######################################################################### ■
