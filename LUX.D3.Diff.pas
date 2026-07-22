unit LUX.D3.Diff;

interface //#################################################################### ■

uses System.Math.Vectors,
     LUX,
     LUX.D1.Diff,
     LUX.D2.Diff,
     LUX.D3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle3D

     TdSingle3D = record
     private
       ///// A C C E S S O R
       function GetD1( const X_:Integer ) :TdSingle;
       procedure SetD1( const X_:Integer; const D1_:TdSingle );
       function Geto :TSingle3D;
       procedure Seto( const o_:TSingle3D );
       function Getd :TSingle3D;
       procedure Setd( const d_:TSingle3D );
       function GetSize2 :TdSingle;
       procedure SetSize2( const Size2_:TdSingle );
       function GetSize :TdSingle;
       procedure SetSize( const Size_:TdSingle );
       function GetUnitor :TdSingle3D;
       procedure SetUnitor( const Unitor_:TdSingle3D );
       function GetProjXY :TdSingle2D;
       procedure SetProjXY( const ProjXY_:TdSingle2D );
       function GetProjYZ :TdSingle2D;
       procedure SetProjYZ( const ProjYZ_:TdSingle2D );
       function GetProjZX :TdSingle2D;
       procedure SetProjZX( const ProjZX_:TdSingle2D );
     public
       constructor Create( const V_:TdSingle ); overload;
       constructor Create( const X_,Y_,Z_:TdSingle ); overload;
       constructor Create( const o_,d_:TSingle3D ); overload;
       ///// P R O P E R T Y
       property D1[ const X_:Integer ] :TdSingle   read GetD1     write SetD1    ; default;
       property o                      :TSingle3D  read Geto      write Seto     ;
       property d                      :TSingle3D  read Getd      write Setd     ;
       property Size2                  :TdSingle   read GetSize2  write SetSize2 ;
       property Size                   :TdSingle   read GetSize   write SetSize  ;
       property Unitor                 :TdSingle3D read GetUnitor write SetUnitor;
       property ProjXY                 :TdSingle2D read GetProjXY write SetProjXY;
       property ProjYZ                 :TdSingle2D read GetProjYZ write SetProjYZ;
       property ProjZX                 :TdSingle2D read GetProjZX write SetProjZX;
       ///// O P E R A T O R
       class operator Positive( const V_:TdSingle3D ) :TdSingle3D;
       class operator Negative( const V_:TdSingle3D ) :TdSingle3D;
       class operator Add( const A_,B_:TdSingle3D ) :TdSingle3D;
       class operator Subtract( const A_,B_:TdSingle3D ) :TdSingle3D;
       class operator Multiply( const A_:TdSingle; const B_:TdSingle3D ) :TdSingle3D;
       class operator Multiply( const A_:TdSingle3D; const B_:TdSingle ) :TdSingle3D;
       class operator Divide( const A_:TdSingle3D; const B_:TdSingle ) :TdSingle3D;
       ///// C A S T
       class operator Implicit( const V_:Integer ) :TdSingle3D;
       class operator Implicit( const V_:Int64 ) :TdSingle3D;
       class operator Implicit( const V_:Single ) :TdSingle3D;
       class operator Implicit( const V_:TdSingle ) :TdSingle3D;
       class operator Implicit( const V_:TSingle3D ) :TdSingle3D;
       class operator Implicit( const V_:TdSingle2D ) :TdSingle3D;
       class operator Explicit( const V_:TdSingle3D ) :TdSingle2D;
       class operator Implicit( const V_:TPoint3D ) :TdSingle3D;
       class operator Explicit( const V_:TdSingle3D ) :TPoint3D;
       class operator Implicit( const V_:TVector3D ) :TdSingle3D;
       class operator Explicit( const V_:TdSingle3D ) :TVector3D;
       ///// C O N S T A N T
       class function IdentityX :TdSingle3D; static;
       class function IdentityY :TdSingle3D; static;
       class function IdentityZ :TdSingle3D; static;
       ///// M E T H O D
       function VectorTo( const P_:TdSingle3D ) :TdSingle3D;
       function UnitorTo( const P_:TdSingle3D ) :TdSingle3D;
       function DistanTo( const P_:TdSingle3D ) :TdSingle;
       class function RandG :TdSingle3D; static;
       class function RandBS1 :TdSingle3D; static;
       class function RandBS2 :TdSingle3D; static;
       class function RandBS4 :TdSingle3D; static;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..3-1 ] of TdSingle; );
      1:( _1  :TdSingle;
          _2  :TdSingle;
          _3  :TdSingle;                     );
      2:(  X  :TdSingle;
           Y  :TdSingle;
           Z  :TdSingle;                     );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble3D

     TdDouble3D = record
     private
       ///// A C C E S S O R
       function GetD1( const X_:Integer ) :TdDouble;
       procedure SetD1( const X_:Integer; const D1_:TdDouble );
       function Geto :TDouble3D;
       procedure Seto( const o_:TDouble3D );
       function Getd :TDouble3D;
       procedure Setd( const d_:TDouble3D );
       function GetSize2 :TdDouble;
       procedure SetSize2( const Size2_:TdDouble );
       function GetSize :TdDouble;
       procedure SetSize( const Size_:TdDouble );
       function GetUnitor :TdDouble3D;
       procedure SetUnitor( const Unitor_:TdDouble3D );
       function GetProjXY :TdDouble2D;
       procedure SetProjXY( const ProjXY_:TdDouble2D );
       function GetProjYZ :TdDouble2D;
       procedure SetProjYZ( const ProjYZ_:TdDouble2D );
       function GetProjZX :TdDouble2D;
       procedure SetProjZX( const ProjZX_:TdDouble2D );
     public
       constructor Create( const V_:TdDouble ); overload;
       constructor Create( const X_,Y_,Z_:TdDouble ); overload;
       constructor Create( const o_,d_:TDouble3D ); overload;
       ///// P R O P E R T Y
       property D1[ const X_:Integer ] :TdDouble   read GetD1     write SetD1    ; default;
       property o                      :TDouble3D  read Geto      write Seto     ;
       property d                      :TDouble3D  read Getd      write Setd     ;
       property Size2                  :TdDouble   read GetSize2  write SetSize2 ;
       property Size                   :TdDouble   read GetSize   write SetSize  ;
       property Unitor                 :TdDouble3D read GetUnitor write SetUnitor;
       property ProjXY                 :TdDouble2D read GetProjXY write SetProjXY;
       property ProjYZ                 :TdDouble2D read GetProjYZ write SetProjYZ;
       property ProjZX                 :TdDouble2D read GetProjZX write SetProjZX;
       ///// O P E R A T O R
       class operator Positive( const V_:TdDouble3D ) :TdDouble3D;
       class operator Negative( const V_:TdDouble3D ) :TdDouble3D;
       class operator Add( const A_,B_:TdDouble3D ) :TdDouble3D;
       class operator Subtract( const A_,B_:TdDouble3D ) :TdDouble3D;
       class operator Multiply( const A_:TdDouble; const B_:TdDouble3D ) :TdDouble3D;
       class operator Multiply( const A_:TdDouble3D; const B_:TdDouble ) :TdDouble3D;
       class operator Divide( const A_:TdDouble3D; const B_:TdDouble ) :TdDouble3D;
       ///// C A S T
       class operator Implicit( const V_:Integer ) :TdDouble3D;
       class operator Implicit( const V_:Int64 ) :TdDouble3D;
       class operator Implicit( const V_:Double ) :TdDouble3D;
       class operator Implicit( const V_:TdDouble ) :TdDouble3D;
       class operator Implicit( const V_:TDouble3D ) :TdDouble3D;
       class operator Implicit( const V_:TdDouble2D ) :TdDouble3D;
       class operator Explicit( const V_:TdDouble3D ) :TdDouble2D;
       class operator Implicit( const V_:TPoint3D ) :TdDouble3D;
       class operator Explicit( const V_:TdDouble3D ) :TPoint3D;
       class operator Implicit( const V_:TVector3D ) :TdDouble3D;
       class operator Explicit( const V_:TdDouble3D ) :TVector3D;
       class operator Implicit( const V_:TdSingle3D ) :TdDouble3D;
       class operator Explicit( const V_:TdDouble3D ) :TdSingle3D;
       ///// C O N S T A N T
       class function IdentityX :TdDouble3D; static;
       class function IdentityY :TdDouble3D; static;
       class function IdentityZ :TdDouble3D; static;
       ///// M E T H O D
       function VectorTo( const P_:TdDouble3D ) :TdDouble3D;
       function UnitorTo( const P_:TdDouble3D ) :TdDouble3D;
       function DistanTo( const P_:TdDouble3D ) :TdDouble;
       class function RandG :TdDouble3D; static;
       class function RandBS1 :TdDouble3D; static;
       class function RandBS2 :TdDouble3D; static;
       class function RandBS4 :TdDouble3D; static;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..3-1 ] of TdDouble; );
      1:( _1  :TdDouble;
          _2  :TdDouble;
          _3  :TdDouble;                     );
      2:(  X  :TdDouble;
           Y  :TdDouble;
           Z  :TdDouble;                     );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Td*Func2Dto3D

     TdSingleFunc2Dto3D = reference to function ( const P_:TdSingle2D ) :TdSingle3D;
     TdDoubleFunc2Dto3D = reference to function ( const P_:TdDouble2D ) :TdDouble3D;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angle

function Angle( const V0_,V1_:TdSingle3D ) :TdSingle; overload;  //= 0..Pi
function Angle( const V0_,V1_:TdDouble3D ) :TdDouble; overload;  //= 0..Pi

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DotProduct

function DotProduct( const A_,B_:TdSingle3D ) :TdSingle; overload;
function DotProduct( const A_,B_:TdDouble3D ) :TdDouble; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CrossProduct

function CrossProduct( const A_,B_:TdSingle3D ) :TdSingle3D; overload;
function CrossProduct( const A_,B_:TdDouble3D ) :TdDouble3D; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distance

function Distance2( const A_,B_:TdSingle3D ) :TdSingle; overload;
function Distance2( const A_,B_:TdDouble3D ) :TdDouble; overload;

function Distance( const A_,B_:TdSingle3D ) :TdSingle; overload;
function Distance( const A_,B_:TdDouble3D ) :TdDouble; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ave

function Ave( const P1_,P2_:TdSingle3D ) :TdSingle3D; overload;
function Ave( const P1_,P2_:TdDouble3D ) :TdDouble3D; overload;

function Ave( const P1_,P2_,P3_:TdSingle3D ) :TdSingle3D; overload;
function Ave( const P1_,P2_,P3_:TdDouble3D ) :TdDouble3D; overload;

function Ave( const P1_,P2_,P3_,P4_:TdSingle3D ) :TdSingle3D; overload;
function Ave( const P1_,P2_,P3_,P4_:TdDouble3D ) :TdDouble3D; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdSingle3D.GetD1( const X_:Integer ) :TdSingle;
begin
     Result := _1D[ X_-1 ];
end;

procedure TdSingle3D.SetD1( const X_:Integer; const D1_:TdSingle );
begin
     _1D[ X_-1 ] := D1_;
end;

//------------------------------------------------------------------------------

function TdSingle3D.Geto :TSingle3D;
begin
     Result.X := X.o;
     Result.Y := Y.o;
     Result.Z := Z.o;
end;

procedure TdSingle3D.Seto( const o_:TSingle3D );
begin
     X.o := o_.X;
     Y.o := o_.Y;
     Z.o := o_.Z;
end;

function TdSingle3D.Getd :TSingle3D;
begin
     Result.X := X.d;
     Result.Y := Y.d;
     Result.Z := Z.d;
end;

procedure TdSingle3D.Setd( const d_:TSingle3D );
begin
     X.d := d_.X;
     Y.d := d_.Y;
     Z.d := d_.Z;
end;

//------------------------------------------------------------------------------

function TdSingle3D.GetSize2 :TdSingle;
begin
     Result := Pow2( X ) + Pow2( Y ) + Pow2( Z );
end;

procedure TdSingle3D.SetSize2( const Size2_:TdSingle );
begin
     Self := Roo2( Size2_ / Size2 ) * Self;
end;

function TdSingle3D.GetSize :TdSingle;
begin
     Result := Roo2( Size2 );
end;

procedure TdSingle3D.SetSize( const Size_:TdSingle );
begin
     Self := Size_ * Unitor;
end;

function TdSingle3D.GetUnitor :TdSingle3D;
begin
     Result := Self / Size;
end;

procedure TdSingle3D.SetUnitor( const Unitor_:TdSingle3D );
begin
     Self := Size * Unitor_;
end;

//------------------------------------------------------------------------------

function TdSingle3D.GetProjXY :TdSingle2D;
begin
     Result.X := X;
     Result.Y := Y;
end;

procedure TdSingle3D.SetProjXY( const ProjXY_:TdSingle2D );
begin
     X := ProjXY_.X;
     Y := ProjXY_.Y;
end;

function TdSingle3D.GetProjYZ :TdSingle2D;
begin
     Result.X := Y;
     Result.Y := Z;
end;

procedure TdSingle3D.SetProjYZ( const ProjYZ_:TdSingle2D );
begin
     Y := ProjYZ_.X;
     Z := ProjYZ_.Y;
end;

function TdSingle3D.GetProjZX :TdSingle2D;
begin
     Result.X := Z;
     Result.Y := X;
end;

procedure TdSingle3D.SetProjZX( const ProjZX_:TdSingle2D );
begin
     Z := ProjZX_.X;
     X := ProjZX_.Y;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdSingle3D.Create( const V_:TdSingle );
begin
     X := V_;
     Y := V_;
     Z := V_;
end;

constructor TdSingle3D.Create( const X_,Y_,Z_:TdSingle );
begin
     X := X_;
     Y := Y_;
     Z := Z_;
end;

constructor TdSingle3D.Create( const o_,d_:TSingle3D );
begin
     o := o_;
     d := d_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdSingle3D.Positive( const V_:TdSingle3D ) :TdSingle3D;
begin
     Result.X := +V_.X;
     Result.Y := +V_.Y;
     Result.Z := +V_.Z;
end;

class operator TdSingle3D.Negative( const V_:TdSingle3D ) :TdSingle3D;
begin
     Result.X := -V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
end;

class operator TdSingle3D.Add( const A_,B_:TdSingle3D ) :TdSingle3D;
begin
     Result.X := A_.X + B_.X;
     Result.Y := A_.Y + B_.Y;
     Result.Z := A_.Z + B_.Z;
end;

class operator TdSingle3D.Subtract( const A_,B_:TdSingle3D ) :TdSingle3D;
begin
     Result.X := A_.X - B_.X;
     Result.Y := A_.Y - B_.Y;
     Result.Z := A_.Z - B_.Z;
end;

class operator TdSingle3D.Multiply( const A_:TdSingle; const B_:TdSingle3D ) :TdSingle3D;
begin
     Result.X := A_ * B_.X;
     Result.Y := A_ * B_.Y;
     Result.Z := A_ * B_.Z;
end;

class operator TdSingle3D.Multiply( const A_:TdSingle3D; const B_:TdSingle ) :TdSingle3D;
begin
     Result.X := A_.X * B_;
     Result.Y := A_.Y * B_;
     Result.Z := A_.Z * B_;
end;

class operator TdSingle3D.Divide( const A_:TdSingle3D; const B_:TdSingle ) :TdSingle3D;
begin
     Result.X := A_.X / B_;
     Result.Y := A_.Y / B_;
     Result.Z := A_.Z / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TdSingle3D.Implicit( const V_:Integer ) :TdSingle3D;
begin
     Result.X := V_;
     Result.Y := V_;
     Result.Z := V_;
end;

class operator TdSingle3D.Implicit( const V_:Int64 ) :TdSingle3D;
begin
     Result.X := V_;
     Result.Y := V_;
     Result.Z := V_;
end;

class operator TdSingle3D.Implicit( const V_:Single ) :TdSingle3D;
begin
     Result.X := V_;
     Result.Y := V_;
     Result.Z := V_;
end;

class operator TdSingle3D.Implicit( const V_:TdSingle ) :TdSingle3D;
begin
     Result.X := V_;
     Result.Y := V_;
     Result.Z := V_;
end;

//------------------------------------------------------------------------------

class operator TdSingle3D.Implicit( const V_:TSingle3D ) :TdSingle3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

//------------------------------------------------------------------------------

class operator TdSingle3D.Implicit( const V_:TdSingle2D ) :TdSingle3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z :=    0;
end;

class operator TdSingle3D.Explicit( const V_:TdSingle3D ) :TdSingle2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

//------------------------------------------------------------------------------

class operator TdSingle3D.Implicit( const V_:TPoint3D ) :TdSingle3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

class operator TdSingle3D.Explicit( const V_:TdSingle3D ) :TPoint3D;
begin
     Result.X := V_.X.o;
     Result.Y := V_.Y.o;
     Result.Z := V_.Z.o;
end;

class operator TdSingle3D.Implicit( const V_:TVector3D ) :TdSingle3D;
begin
     Result := TPoint3D( V_ );
end;

class operator TdSingle3D.Explicit( const V_:TdSingle3D ) :TVector3D;
begin
     Result := TPoint3D( V_ );
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TdSingle3D.IdentityX :TdSingle3D;
begin
     Result.X := 1;
     Result.Y := 0;
     Result.Z := 0;
end;

class function TdSingle3D.IdentityY :TdSingle3D;
begin
     Result.X := 0;
     Result.Y := 1;
     Result.Z := 0;
end;

class function TdSingle3D.IdentityZ :TdSingle3D;
begin
     Result.X := 0;
     Result.Y := 0;
     Result.Z := 1;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TdSingle3D.VectorTo( const P_:TdSingle3D ) :TdSingle3D;
begin
     Result := P_ - Self;
end;

function TdSingle3D.UnitorTo( const P_:TdSingle3D ) :TdSingle3D;
begin
     Result := VectorTo( P_ ).Unitor;
end;

function TdSingle3D.DistanTo( const P_:TdSingle3D ) :TdSingle;
begin
     Result := VectorTo( P_ ).Size;
end;

//------------------------------------------------------------------------------

class function TdSingle3D.RandG :TdSingle3D;
begin
     Result.X := TdSingle.RandG;
     Result.Y := TdSingle.RandG;
     Result.Z := TdSingle.RandG;
end;

//------------------------------------------------------------------------------

class function TdSingle3D.RandBS1 :TdSingle3D;
begin
     Result.X := TdSingle.RandBS1;
     Result.Y := TdSingle.RandBS1;
     Result.Z := TdSingle.RandBS1;
end;

class function TdSingle3D.RandBS2 :TdSingle3D;
begin
     Result.X := TdSingle.RandBS2;
     Result.Y := TdSingle.RandBS2;
     Result.Z := TdSingle.RandBS2;
end;

class function TdSingle3D.RandBS4 :TdSingle3D;
begin
     Result.X := TdSingle.RandBS4;
     Result.Y := TdSingle.RandBS4;
     Result.Z := TdSingle.RandBS4;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdDouble3D.GetD1( const X_:Integer ) :TdDouble;
begin
     Result := _1D[ X_-1 ];
end;

procedure TdDouble3D.SetD1( const X_:Integer; const D1_:TdDouble );
begin
     _1D[ X_-1 ] := D1_;
end;

//------------------------------------------------------------------------------

function TdDouble3D.Geto :TDouble3D;
begin
     Result.X := X.o;
     Result.Y := Y.o;
     Result.Z := Z.o;
end;

procedure TdDouble3D.Seto( const o_:TDouble3D );
begin
     X.o := o_.X;
     Y.o := o_.Y;
     Z.o := o_.Z;
end;

function TdDouble3D.Getd :TDouble3D;
begin
     Result.X := X.d;
     Result.Y := Y.d;
     Result.Z := Z.d;
end;

procedure TdDouble3D.Setd( const d_:TDouble3D );
begin
     X.d := d_.X;
     Y.d := d_.Y;
     Z.d := d_.Z;
end;

//------------------------------------------------------------------------------

function TdDouble3D.GetSize2 :TdDouble;
begin
     Result := Pow2( X ) + Pow2( Y ) + Pow2( Z );
end;

procedure TdDouble3D.SetSize2( const Size2_:TdDouble );
begin
     Self := Roo2( Size2_ / Size2 ) * Self;
end;

function TdDouble3D.GetSize :TdDouble;
begin
     Result := Roo2( Size2 );
end;

procedure TdDouble3D.SetSize( const Size_:TdDouble );
begin
     Self := Size_ * Unitor;
end;

function TdDouble3D.GetUnitor :TdDouble3D;
begin
     Result := Self / Size;
end;

procedure TdDouble3D.SetUnitor( const Unitor_:TdDouble3D );
begin
     Self := Size * Unitor_;
end;

//------------------------------------------------------------------------------

function TdDouble3D.GetProjXY :TdDouble2D;
begin
     Result.X := X;
     Result.Y := Y;
end;

procedure TdDouble3D.SetProjXY( const ProjXY_:TdDouble2D );
begin
     X := ProjXY_.X;
     Y := ProjXY_.Y;
end;

function TdDouble3D.GetProjYZ :TdDouble2D;
begin
     Result.X := Y;
     Result.Y := Z;
end;

procedure TdDouble3D.SetProjYZ( const ProjYZ_:TdDouble2D );
begin
     Y := ProjYZ_.X;
     Z := ProjYZ_.Y;
end;

function TdDouble3D.GetProjZX :TdDouble2D;
begin
     Result.X := Z;
     Result.Y := X;
end;

procedure TdDouble3D.SetProjZX( const ProjZX_:TdDouble2D );
begin
     Z := ProjZX_.X;
     X := ProjZX_.Y;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdDouble3D.Create( const V_:TdDouble );
begin
     X := V_;
     Y := V_;
     Z := V_;
end;

constructor TdDouble3D.Create( const X_,Y_,Z_:TdDouble );
begin
     X := X_;
     Y := Y_;
     Z := Z_;
end;

constructor TdDouble3D.Create( const o_,d_:TDouble3D );
begin
     o := o_;
     d := d_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdDouble3D.Positive( const V_:TdDouble3D ) :TdDouble3D;
begin
     Result.X := +V_.X;
     Result.Y := +V_.Y;
     Result.Z := +V_.Z;
end;

class operator TdDouble3D.Negative( const V_:TdDouble3D ) :TdDouble3D;
begin
     Result.X := -V_.X;
     Result.Y := -V_.Y;
     Result.Z := -V_.Z;
end;

class operator TdDouble3D.Add( const A_,B_:TdDouble3D ) :TdDouble3D;
begin
     Result.X := A_.X + B_.X;
     Result.Y := A_.Y + B_.Y;
     Result.Z := A_.Z + B_.Z;
end;

class operator TdDouble3D.Subtract( const A_,B_:TdDouble3D ) :TdDouble3D;
begin
     Result.X := A_.X - B_.X;
     Result.Y := A_.Y - B_.Y;
     Result.Z := A_.Z - B_.Z;
end;

class operator TdDouble3D.Multiply( const A_:TdDouble; const B_:TdDouble3D ) :TdDouble3D;
begin
     Result.X := A_ * B_.X;
     Result.Y := A_ * B_.Y;
     Result.Z := A_ * B_.Z;
end;

class operator TdDouble3D.Multiply( const A_:TdDouble3D; const B_:TdDouble ) :TdDouble3D;
begin
     Result.X := A_.X * B_;
     Result.Y := A_.Y * B_;
     Result.Z := A_.Z * B_;
end;

class operator TdDouble3D.Divide( const A_:TdDouble3D; const B_:TdDouble ) :TdDouble3D;
begin
     Result.X := A_.X / B_;
     Result.Y := A_.Y / B_;
     Result.Z := A_.Z / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TdDouble3D.Implicit( const V_:Integer ) :TdDouble3D;
begin
     Result.X := V_;
     Result.Y := V_;
     Result.Z := V_;
end;

class operator TdDouble3D.Implicit( const V_:Int64 ) :TdDouble3D;
begin
     Result.X := V_;
     Result.Y := V_;
     Result.Z := V_;
end;

class operator TdDouble3D.Implicit( const V_:Double ) :TdDouble3D;
begin
     Result.X := V_;
     Result.Y := V_;
     Result.Z := V_;
end;

class operator TdDouble3D.Implicit( const V_:TdDouble ) :TdDouble3D;
begin
     Result.X := V_;
     Result.Y := V_;
     Result.Z := V_;
end;

//------------------------------------------------------------------------------

class operator TdDouble3D.Implicit( const V_:TDouble3D ) :TdDouble3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

//------------------------------------------------------------------------------

class operator TdDouble3D.Implicit( const V_:TdDouble2D ) :TdDouble3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z :=    0;
end;

class operator TdDouble3D.Explicit( const V_:TdDouble3D ) :TdDouble2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

//------------------------------------------------------------------------------

class operator TdDouble3D.Implicit( const V_:TPoint3D ) :TdDouble3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

class operator TdDouble3D.Explicit( const V_:TdDouble3D ) :TPoint3D;
begin
     Result.X := V_.X.o;
     Result.Y := V_.Y.o;
     Result.Z := V_.Z.o;
end;

class operator TdDouble3D.Implicit( const V_:TVector3D ) :TdDouble3D;
begin
     Result := TPoint3D( V_ );
end;

class operator TdDouble3D.Explicit( const V_:TdDouble3D ) :TVector3D;
begin
     Result := TPoint3D( V_ );
end;

//------------------------------------------------------------------------------

class operator TdDouble3D.Implicit( const V_:TdSingle3D ) :TdDouble3D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
     Result.Z := V_.Z;
end;

class operator TdDouble3D.Explicit( const V_:TdDouble3D ) :TdSingle3D;
begin
     Result.X := TdSingle( V_.X );
     Result.Y := TdSingle( V_.Y );
     Result.Z := TdSingle( V_.Z );
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TdDouble3D.IdentityX :TdDouble3D;
begin
     Result.X := 1;
     Result.Y := 0;
     Result.Z := 0;
end;

class function TdDouble3D.IdentityY :TdDouble3D;
begin
     Result.X := 0;
     Result.Y := 1;
     Result.Z := 0;
end;

class function TdDouble3D.IdentityZ :TdDouble3D;
begin
     Result.X := 0;
     Result.Y := 0;
     Result.Z := 1;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TdDouble3D.VectorTo( const P_:TdDouble3D ) :TdDouble3D;
begin
     Result := P_ - Self;
end;

function TdDouble3D.UnitorTo( const P_:TdDouble3D ) :TdDouble3D;
begin
     Result := VectorTo( P_ ).Unitor;
end;

function TdDouble3D.DistanTo( const P_:TdDouble3D ) :TdDouble;
begin
     Result := VectorTo( P_ ).Size;
end;

//------------------------------------------------------------------------------

class function TdDouble3D.RandG :TdDouble3D;
begin
     Result.X := TdDouble.RandG;
     Result.Y := TdDouble.RandG;
     Result.Z := TdDouble.RandG;
end;

//------------------------------------------------------------------------------

class function TdDouble3D.RandBS1 :TdDouble3D;
begin
     Result.X := TdDouble.RandBS1;
     Result.Y := TdDouble.RandBS1;
     Result.Z := TdDouble.RandBS1;
end;

class function TdDouble3D.RandBS2 :TdDouble3D;
begin
     Result.X := TdDouble.RandBS2;
     Result.Y := TdDouble.RandBS2;
     Result.Z := TdDouble.RandBS2;
end;

class function TdDouble3D.RandBS4 :TdDouble3D;
begin
     Result.X := TdDouble.RandBS4;
     Result.Y := TdDouble.RandBS4;
     Result.Z := TdDouble.RandBS4;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angle

function Angle( const V0_,V1_:TdSingle3D ) :TdSingle;
begin
     Result := ArcCos( Min( Max( DotProduct( V0_, V1_ ), -1 ), +1 ) );
end;

function Angle( const V0_,V1_:TdDouble3D ) :TdDouble;
begin
     Result := ArcCos( Min( Max( DotProduct( V0_, V1_ ), -1 ), +1 ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DotProduct

function DotProduct( const A_,B_:TdSingle3D ) :TdSingle;
begin
     Result := A_.X * B_.X
             + A_.Y * B_.Y
             + A_.Z * B_.Z;
end;

function DotProduct( const A_,B_:TdDouble3D ) :TdDouble;
begin
     Result := A_.X * B_.X
             + A_.Y * B_.Y
             + A_.Z * B_.Z;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CrossProduct

function CrossProduct( const A_,B_:TdSingle3D ) :TdSingle3D;
begin
     Result.X := A_.Y * B_.Z - A_.Z * B_.Y;
     Result.Y := A_.Z * B_.X - A_.X * B_.Z;
     Result.Z := A_.X * B_.Y - A_.Y * B_.X;
end;

function CrossProduct( const A_,B_:TdDouble3D ) :TdDouble3D;
begin
     Result.X := A_.Y * B_.Z - A_.Z * B_.Y;
     Result.Y := A_.Z * B_.X - A_.X * B_.Z;
     Result.Z := A_.X * B_.Y - A_.Y * B_.X;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distance

function Distance2( const A_,B_:TdSingle3D ) :TdSingle;
begin
     Result := Pow2( B_.X - A_.X ) + Pow2( B_.Y - A_.Y ) + Pow2( B_.Z - A_.Z );
end;

function Distance2( const A_,B_:TdDouble3D ) :TdDouble;
begin
     Result := Pow2( B_.X - A_.X ) + Pow2( B_.Y - A_.Y ) + Pow2( B_.Z - A_.Z );
end;

function Distance( const A_,B_:TdSingle3D ) :TdSingle;
begin
     Result := Roo2( Distance2( A_, B_ ) );
end;

function Distance( const A_,B_:TdDouble3D ) :TdDouble;
begin
     Result := Roo2( Distance2( A_, B_ ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ave

function Ave( const P1_,P2_:TdSingle3D ) :TdSingle3D;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

function Ave( const P1_,P2_:TdDouble3D ) :TdDouble3D;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

//------------------------------------------------------------------------------

function Ave( const P1_,P2_,P3_:TdSingle3D ) :TdSingle3D;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

function Ave( const P1_,P2_,P3_:TdDouble3D ) :TdDouble3D;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

//------------------------------------------------------------------------------

function Ave( const P1_,P2_,P3_,P4_:TdSingle3D ) :TdSingle3D;
begin
     Result := ( P1_ + P2_ + P3_ + P4_ ) / 4;
end;

function Ave( const P1_,P2_,P3_,P4_:TdDouble3D ) :TdDouble3D;
begin
     Result := ( P1_ + P2_ + P3_ + P4_ ) / 4;
end;

end. //######################################################################### ■
