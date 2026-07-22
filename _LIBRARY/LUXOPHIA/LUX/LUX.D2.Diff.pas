unit LUX.D2.Diff;

interface //#################################################################### ■

uses System.Types,
     LUX,
     LUX.D1.Diff,
     LUX.D2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle2D

     TdSingle2D = record
     private
       ///// A C C E S S O R
       function GetD1( const X_:Integer ) :TdSingle;
       procedure SetD1( const X_:Integer; const D1_:TdSingle );
       function Geto :TSingle2D;
       procedure Seto( const o_:TSingle2D );
       function Getd :TSingle2D;
       procedure Setd( const d_:TSingle2D );
       function GetSize2 :TdSingle;
       procedure SetSize2( const Size2_:TdSingle );
       function GetSize :TdSingle;
       procedure SetSize( const Size_:TdSingle );
       function GetUnitor :TdSingle2D;
       procedure SetUnitor( const Unitor_:TdSingle2D );
     public
       constructor Create( const V_:TdSingle ); overload;
       constructor Create( const X_,Y_:TdSingle ); overload;
       constructor Create( const o_,d_:TSingle2D ); overload;
       ///// P R O P E R T Y
       property D1[ const X_:Integer ] :TdSingle   read GetD1     write SetD1    ; default;
       property o                      :TSingle2D  read Geto      write Seto     ;
       property d                      :TSingle2D  read Getd      write Setd     ;
       property Size2                  :TdSingle   read GetSize2  write SetSize2 ;
       property Size                   :TdSingle   read GetSize   write SetSize  ;
       property Unitor                 :TdSingle2D read GetUnitor write SetUnitor;
       ///// O P E R A T O R
       class operator Positive( const V_:TdSingle2D ) :TdSingle2D;
       class operator Negative( const V_:TdSingle2D ) :TdSingle2D;
       class operator Add( const A_,B_:TdSingle2D ) :TdSingle2D;
       class operator Subtract( const A_,B_:TdSingle2D ) :TdSingle2D;
       class operator Multiply( const A_:TdSingle; const B_:TdSingle2D ) :TdSingle2D;
       class operator Multiply( const A_:TdSingle2D; const B_:TdSingle ) :TdSingle2D;
       class operator Divide( const A_:TdSingle2D; const B_:TdSingle ) :TdSingle2D;
       ///// C A S T
       class operator Implicit( const V_:Integer ) :TdSingle2D;
       class operator Implicit( const V_:Int64 ) :TdSingle2D;
       class operator Implicit( const V_:Single ) :TdSingle2D;
       class operator Implicit( const V_:TdSingle ) :TdSingle2D;
       class operator Implicit( const V_:TSingle2D ) :TdSingle2D;
       class operator Implicit( const V_:TPointF ) :TdSingle2D;
       class operator Explicit( const V_:TdSingle2D ) :TPointF;
       ///// C O N S T A N T
       class function IdentityX :TdSingle2D; static;
       class function IdentityY :TdSingle2D; static;
       ///// M E T H O D
       function VectorTo( const P_:TdSingle2D ) :TdSingle2D;
       function UnitorTo( const P_:TdSingle2D ) :TdSingle2D;
       function DistanTo( const P_:TdSingle2D ) :TdSingle;
       function RotL90 :TdSingle2D;
       function RotR90 :TdSingle2D;
       function RotAngleTo( const V_:TdSingle2D ) :TdSingle;
       class function RandG :TdSingle2D; static;
       class function RandBS1 :TdSingle2D; static;
       class function RandBS2 :TdSingle2D; static;
       class function RandBS4 :TdSingle2D; static;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..2-1 ] of TdSingle; );
      1:( _1  :TdSingle;
          _2  :TdSingle;                     );
      2:(  X  :TdSingle;
           Y  :TdSingle;                     );
      3:(  U  :TdSingle;
           V  :TdSingle;                     );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble2D

     TdDouble2D = record
     private
       ///// A C C E S S O R
       function GetD1( const X_:Integer ) :TdDouble;
       procedure SetD1( const X_:Integer; const D1_:TdDouble );
       function Geto :TDouble2D;
       procedure Seto( const o_:TDouble2D );
       function Getd :TDouble2D;
       procedure Setd( const d_:TDouble2D );
       function GetSize2 :TdDouble;
       procedure SetSize2( const Size2_:TdDouble );
       function GetSize :TdDouble;
       procedure SetSize( const Size_:TdDouble );
       function GetUnitor :TdDouble2D;
       procedure SetUnitor( const Unitor_:TdDouble2D );
     public
       constructor Create( const V_:TdDouble ); overload;
       constructor Create( const X_,Y_:TdDouble ); overload;
       constructor Create( const o_,d_:TDouble2D ); overload;
       ///// P R O P E R T Y
       property D1[ const X_:Integer ] :TdDouble   read GetD1     write SetD1    ; default;
       property o                      :TDouble2D  read Geto      write Seto     ;
       property d                      :TDouble2D  read Getd      write Setd     ;
       property Size2                  :TdDouble   read GetSize2  write SetSize2 ;
       property Size                   :TdDouble   read GetSize   write SetSize  ;
       property Unitor                 :TdDouble2D read GetUnitor write SetUnitor;
       ///// O P E R A T O R
       class operator Positive( const V_:TdDouble2D ) :TdDouble2D;
       class operator Negative( const V_:TdDouble2D ) :TdDouble2D;
       class operator Add( const A_,B_:TdDouble2D ) :TdDouble2D;
       class operator Subtract( const A_,B_:TdDouble2D ) :TdDouble2D;
       class operator Multiply( const A_:TdDouble; const B_:TdDouble2D ) :TdDouble2D;
       class operator Multiply( const A_:TdDouble2D; const B_:TdDouble ) :TdDouble2D;
       class operator Divide( const A_:TdDouble2D; const B_:TdDouble ) :TdDouble2D;
       ///// C A S T
       class operator Implicit( const V_:Integer ) :TdDouble2D;
       class operator Implicit( const V_:Int64 ) :TdDouble2D;
       class operator Implicit( const V_:Double ) :TdDouble2D;
       class operator Implicit( const V_:TdDouble ) :TdDouble2D;
       class operator Implicit( const V_:TDouble2D ) :TdDouble2D;
       class operator Implicit( const V_:TPointF ) :TdDouble2D;
       class operator Explicit( const V_:TdDouble2D ) :TPointF;
       class operator Implicit( const V_:TdSingle2D ) :TdDouble2D;
       class operator Explicit( const V_:TdDouble2D ) :TdSingle2D;
       ///// C O N S T A N T
       class function IdentityX :TdDouble2D; static;
       class function IdentityY :TdDouble2D; static;
       ///// M E T H O D
       function VectorTo( const P_:TdDouble2D ) :TdDouble2D;
       function UnitorTo( const P_:TdDouble2D ) :TdDouble2D;
       function DistanTo( const P_:TdDouble2D ) :TdDouble;
       function RotL90 :TdDouble2D;
       function RotR90 :TdDouble2D;
       function RotAngleTo( const V_:TdDouble2D ) :TdDouble;
       class function RandG :TdDouble2D; static;
       class function RandBS1 :TdDouble2D; static;
       class function RandBS2 :TdDouble2D; static;
       class function RandBS4 :TdDouble2D; static;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..2-1 ] of TdDouble; );
      1:( _1  :TdDouble;
          _2  :TdDouble;                     );
      2:(  X  :TdDouble;
           Y  :TdDouble;                     );
      3:(  U  :TdDouble;
           V  :TdDouble;                     );
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angle

function Angle( const V0_,V1_:TdSingle2D ) :TdSingle; overload;  //= 0..Pi
function Angle( const V0_,V1_:TdDouble2D ) :TdDouble; overload;  //= 0..Pi

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DotProduct

function DotProduct( const A_,B_:TdSingle2D ) :TdSingle; overload;
function DotProduct( const A_,B_:TdDouble2D ) :TdDouble; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CrossProduct

function CrossProduct( const A_,B_:TdSingle2D ) :TdSingle; overload;
function CrossProduct( const A_,B_:TdDouble2D ) :TdDouble; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distance

function Distance2( const A_,B_:TdSingle2D ) :TdSingle; overload;
function Distance2( const A_,B_:TdDouble2D ) :TdDouble; overload;

function Distance( const A_,B_:TdSingle2D ) :TdSingle; overload;
function Distance( const A_,B_:TdDouble2D ) :TdDouble; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ave

function Ave( const P1_,P2_:TdSingle2D ) :TdSingle2D; overload;
function Ave( const P1_,P2_:TdDouble2D ) :TdDouble2D; overload;

function Ave( const P1_,P2_,P3_:TdSingle2D ) :TdSingle2D; overload;
function Ave( const P1_,P2_,P3_:TdDouble2D ) :TdDouble2D; overload;

function Ave( const P1_,P2_,P3_,P4_:TdSingle2D ) :TdSingle2D; overload;
function Ave( const P1_,P2_,P3_,P4_:TdDouble2D ) :TdDouble2D; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle2D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdSingle2D.GetD1( const X_:Integer ) :TdSingle;
begin
     Result := _1D[ X_-1 ];
end;

procedure TdSingle2D.SetD1( const X_:Integer; const D1_:TdSingle );
begin
     _1D[ X_-1 ] := D1_;
end;

//------------------------------------------------------------------------------

function TdSingle2D.Geto :TSingle2D;
begin
     Result.X := X.o;
     Result.Y := Y.o;
end;

procedure TdSingle2D.Seto( const o_:TSingle2D );
begin
     X.o := o_.X;
     Y.o := o_.Y;
end;

function TdSingle2D.Getd :TSingle2D;
begin
     Result.X := X.d;
     Result.Y := Y.d;
end;

procedure TdSingle2D.Setd( const d_:TSingle2D );
begin
     X.d := d_.X;
     Y.d := d_.Y;
end;

//------------------------------------------------------------------------------

function TdSingle2D.GetSize2 :TdSingle;
begin
     Result := Pow2( X ) + Pow2( Y );
end;

procedure TdSingle2D.SetSize2( const Size2_:TdSingle );
begin
     Self := Roo2( Size2_ / Size2 ) * Self;
end;

function TdSingle2D.GetSize :TdSingle;
begin
     Result := Roo2( Size2 );
end;

procedure TdSingle2D.SetSize( const Size_:TdSingle );
begin
     Self := Size_ * Unitor;
end;

function TdSingle2D.GetUnitor :TdSingle2D;
begin
     Result := Self / Size;
end;

procedure TdSingle2D.SetUnitor( const Unitor_:TdSingle2D );
begin
     Self := Size * Unitor_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdSingle2D.Create( const V_:TdSingle );
begin
     X := V_;
     Y := V_;
end;

constructor TdSingle2D.Create( const X_,Y_:TdSingle );
begin
     X := X_;
     Y := Y_;
end;

constructor TdSingle2D.Create( const o_,d_:TSingle2D );
begin
     o := o_;
     d := d_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdSingle2D.Positive( const V_:TdSingle2D ) :TdSingle2D;
begin
     Result.X := +V_.X;
     Result.Y := +V_.Y;
end;

class operator TdSingle2D.Negative( const V_:TdSingle2D ) :TdSingle2D;
begin
     Result.X := -V_.X;
     Result.Y := -V_.Y;
end;

class operator TdSingle2D.Add( const A_,B_:TdSingle2D ) :TdSingle2D;
begin
     Result.X := A_.X + B_.X;
     Result.Y := A_.Y + B_.Y;
end;

class operator TdSingle2D.Subtract( const A_,B_:TdSingle2D ) :TdSingle2D;
begin
     Result.X := A_.X - B_.X;
     Result.Y := A_.Y - B_.Y;
end;

class operator TdSingle2D.Multiply( const A_:TdSingle; const B_:TdSingle2D ) :TdSingle2D;
begin
     Result.X := A_ * B_.X;
     Result.Y := A_ * B_.Y;
end;

class operator TdSingle2D.Multiply( const A_:TdSingle2D; const B_:TdSingle ) :TdSingle2D;
begin
     Result.X := A_.X * B_;
     Result.Y := A_.Y * B_;
end;

class operator TdSingle2D.Divide( const A_:TdSingle2D; const B_:TdSingle ) :TdSingle2D;
begin
     Result.X := A_.X / B_;
     Result.Y := A_.Y / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TdSingle2D.Implicit( const V_:Integer ) :TdSingle2D;
begin
     Result.X := V_;
     Result.Y := V_;
end;

class operator TdSingle2D.Implicit( const V_:Int64 ) :TdSingle2D;
begin
     Result.X := V_;
     Result.Y := V_;
end;

class operator TdSingle2D.Implicit( const V_:Single ) :TdSingle2D;
begin
     Result.X := V_;
     Result.Y := V_;
end;

class operator TdSingle2D.Implicit( const V_:TdSingle ) :TdSingle2D;
begin
     Result.X := V_;
     Result.Y := V_;
end;

//------------------------------------------------------------------------------

class operator TdSingle2D.Implicit( const V_:TSingle2D ) :TdSingle2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

class operator TdSingle2D.Implicit( const V_:TPointF ) :TdSingle2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

class operator TdSingle2D.Explicit( const V_:TdSingle2D ) :TPointF;
begin
     Result.X := V_.X.o;
     Result.Y := V_.Y.o;
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TdSingle2D.IdentityX :TdSingle2D;
begin
     Result.X := 1;
     Result.Y := 0;
end;

class function TdSingle2D.IdentityY :TdSingle2D;
begin
     Result.X := 0;
     Result.Y := 1;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TdSingle2D.VectorTo( const P_:TdSingle2D ) :TdSingle2D;
begin
     Result := P_ - Self;
end;

function TdSingle2D.UnitorTo( const P_:TdSingle2D ) :TdSingle2D;
begin
     Result := VectorTo( P_ ).Unitor;
end;

function TdSingle2D.DistanTo( const P_:TdSingle2D ) :TdSingle;
begin
     Result := VectorTo( P_ ).Size;
end;

//------------------------------------------------------------------------------

function TdSingle2D.RotL90 :TdSingle2D;
begin
     Result.X := -Y;
     Result.Y := +X;
end;

function TdSingle2D.RotR90 :TdSingle2D;
begin
     Result.X := +Y;
     Result.Y := -X;
end;

//------------------------------------------------------------------------------

function TdSingle2D.RotAngleTo( const V_:TdSingle2D ) :TdSingle;
begin
     Result := ArcTan2( X * V_.Y - Y * V_.X,
                        X * V_.X + Y * V_.Y );
end;

//------------------------------------------------------------------------------

class function TdSingle2D.RandG :TdSingle2D;
begin
     Result.X := TdSingle.RandG;
     Result.Y := TdSingle.RandG;
end;

//------------------------------------------------------------------------------

class function TdSingle2D.RandBS1 :TdSingle2D;
begin
     Result.X := TdSingle.RandBS1;
     Result.Y := TdSingle.RandBS1;
end;

class function TdSingle2D.RandBS2 :TdSingle2D;
begin
     Result.X := TdSingle.RandBS2;
     Result.Y := TdSingle.RandBS2;
end;

class function TdSingle2D.RandBS4 :TdSingle2D;
begin
     Result.X := TdSingle.RandBS4;
     Result.Y := TdSingle.RandBS4;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble2D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdDouble2D.GetD1( const X_:Integer ) :TdDouble;
begin
     Result := _1D[ X_-1 ];
end;

procedure TdDouble2D.SetD1( const X_:Integer; const D1_:TdDouble );
begin
     _1D[ X_-1 ] := D1_;
end;

//------------------------------------------------------------------------------

function TdDouble2D.Geto :TDouble2D;
begin
     Result.X := X.o;
     Result.Y := Y.o;
end;

procedure TdDouble2D.Seto( const o_:TDouble2D );
begin
     X.o := o_.X;
     Y.o := o_.Y;
end;

function TdDouble2D.Getd :TDouble2D;
begin
     Result.X := X.d;
     Result.Y := Y.d;
end;

procedure TdDouble2D.Setd( const d_:TDouble2D );
begin
     X.d := d_.X;
     Y.d := d_.Y;
end;

//------------------------------------------------------------------------------

function TdDouble2D.GetSize2 :TdDouble;
begin
     Result := Pow2( X ) + Pow2( Y );
end;

procedure TdDouble2D.SetSize2( const Size2_:TdDouble );
begin
     Self := Roo2( Size2_ / Size2 ) * Self;
end;

function TdDouble2D.GetSize :TdDouble;
begin
     Result := Roo2( Size2 );
end;

procedure TdDouble2D.SetSize( const Size_:TdDouble );
begin
     Self := Size_ * Unitor;
end;

function TdDouble2D.GetUnitor :TdDouble2D;
begin
     Result := Self / Size;
end;

procedure TdDouble2D.SetUnitor( const Unitor_:TdDouble2D );
begin
     Self := Size * Unitor_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdDouble2D.Create( const V_:TdDouble );
begin
     X := V_;
     Y := V_;
end;

constructor TdDouble2D.Create( const X_,Y_:TdDouble );
begin
     X := X_;
     Y := Y_;
end;

constructor TdDouble2D.Create( const o_,d_:TDouble2D );
begin
     o := o_;
     d := d_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdDouble2D.Positive( const V_:TdDouble2D ) :TdDouble2D;
begin
     Result.X := +V_.X;
     Result.Y := +V_.Y;
end;

class operator TdDouble2D.Negative( const V_:TdDouble2D ) :TdDouble2D;
begin
     Result.X := -V_.X;
     Result.Y := -V_.Y;
end;

class operator TdDouble2D.Add( const A_,B_:TdDouble2D ) :TdDouble2D;
begin
     Result.X := A_.X + B_.X;
     Result.Y := A_.Y + B_.Y;
end;

class operator TdDouble2D.Subtract( const A_,B_:TdDouble2D ) :TdDouble2D;
begin
     Result.X := A_.X - B_.X;
     Result.Y := A_.Y - B_.Y;
end;

class operator TdDouble2D.Multiply( const A_:TdDouble; const B_:TdDouble2D ) :TdDouble2D;
begin
     Result.X := A_ * B_.X;
     Result.Y := A_ * B_.Y;
end;

class operator TdDouble2D.Multiply( const A_:TdDouble2D; const B_:TdDouble ) :TdDouble2D;
begin
     Result.X := A_.X * B_;
     Result.Y := A_.Y * B_;
end;

class operator TdDouble2D.Divide( const A_:TdDouble2D; const B_:TdDouble ) :TdDouble2D;
begin
     Result.X := A_.X / B_;
     Result.Y := A_.Y / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TdDouble2D.Implicit( const V_:Integer ) :TdDouble2D;
begin
     Result.X := V_;
     Result.Y := V_;
end;

class operator TdDouble2D.Implicit( const V_:Int64 ) :TdDouble2D;
begin
     Result.X := V_;
     Result.Y := V_;
end;

class operator TdDouble2D.Implicit( const V_:Double ) :TdDouble2D;
begin
     Result.X := V_;
     Result.Y := V_;
end;

class operator TdDouble2D.Implicit( const V_:TdDouble ) :TdDouble2D;
begin
     Result.X := V_;
     Result.Y := V_;
end;

//------------------------------------------------------------------------------

class operator TdDouble2D.Implicit( const V_:TDouble2D ) :TdDouble2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

class operator TdDouble2D.Implicit( const V_:TPointF ) :TdDouble2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

class operator TdDouble2D.Explicit( const V_:TdDouble2D ) :TPointF;
begin
     Result.X := V_.X.o;
     Result.Y := V_.Y.o;
end;

//------------------------------------------------------------------------------

class operator TdDouble2D.Implicit( const V_:TdSingle2D ) :TdDouble2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

class operator TdDouble2D.Explicit( const V_:TdDouble2D ) :TdSingle2D;
begin
     Result.X := TdSingle( V_.X );
     Result.Y := TdSingle( V_.Y );
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TdDouble2D.IdentityX :TdDouble2D;
begin
     Result.X := 1;
     Result.Y := 0;
end;

class function TdDouble2D.IdentityY :TdDouble2D;
begin
     Result.X := 0;
     Result.Y := 1;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TdDouble2D.VectorTo( const P_:TdDouble2D ) :TdDouble2D;
begin
     Result := P_ - Self;
end;

function TdDouble2D.UnitorTo( const P_:TdDouble2D ) :TdDouble2D;
begin
     Result := VectorTo( P_ ).Unitor;
end;

function TdDouble2D.DistanTo( const P_:TdDouble2D ) :TdDouble;
begin
     Result := VectorTo( P_ ).Size;
end;

//------------------------------------------------------------------------------

function TdDouble2D.RotL90 :TdDouble2D;
begin
     Result.X := -Y;
     Result.Y := +X;
end;

function TdDouble2D.RotR90 :TdDouble2D;
begin
     Result.X := +Y;
     Result.Y := -X;
end;

//------------------------------------------------------------------------------

function TdDouble2D.RotAngleTo( const V_:TdDouble2D ) :TdDouble;
begin
     Result := ArcTan2( X * V_.Y - Y * V_.X,
                        X * V_.X + Y * V_.Y );
end;

//------------------------------------------------------------------------------

class function TdDouble2D.RandG :TdDouble2D;
begin
     Result.X := TdDouble.RandG;
     Result.Y := TdDouble.RandG;
end;

//------------------------------------------------------------------------------

class function TdDouble2D.RandBS1 :TdDouble2D;
begin
     Result.X := TdDouble.RandBS1;
     Result.Y := TdDouble.RandBS1;
end;

class function TdDouble2D.RandBS2 :TdDouble2D;
begin
     Result.X := TdDouble.RandBS2;
     Result.Y := TdDouble.RandBS2;
end;

class function TdDouble2D.RandBS4 :TdDouble2D;
begin
     Result.X := TdDouble.RandBS4;
     Result.Y := TdDouble.RandBS4;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angle

function Angle( const V0_,V1_:TdSingle2D ) :TdSingle;
begin
     Result := ArcCos( Min( Max( DotProduct( V0_, V1_ ), -1 ), +1 ) );
end;

function Angle( const V0_,V1_:TdDouble2D ) :TdDouble;
begin
     Result := ArcCos( Min( Max( DotProduct( V0_, V1_ ), -1 ), +1 ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DotProduct

function DotProduct( const A_,B_:TdSingle2D ) :TdSingle;
begin
     Result := A_.X * B_.X
             + A_.Y * B_.Y;
end;

function DotProduct( const A_,B_:TdDouble2D ) :TdDouble;
begin
     Result := A_.X * B_.X
             + A_.Y * B_.Y;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CrossProduct

function CrossProduct( const A_,B_:TdSingle2D ) :TdSingle;
begin
     Result := A_.X * B_.Y - A_.Y * B_.X;
end;

function CrossProduct( const A_,B_:TdDouble2D ) :TdDouble;
begin
     Result := A_.X * B_.Y - A_.Y * B_.X;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distance

function Distance2( const A_,B_:TdSingle2D ) :TdSingle;
begin
     Result := Pow2( B_.X - A_.X ) + Pow2( B_.Y - A_.Y );
end;

function Distance2( const A_,B_:TdDouble2D ) :TdDouble;
begin
     Result := Pow2( B_.X - A_.X ) + Pow2( B_.Y - A_.Y );
end;

function Distance( const A_,B_:TdSingle2D ) :TdSingle;
begin
     Result := Roo2( Distance2( A_, B_ ) );
end;

function Distance( const A_,B_:TdDouble2D ) :TdDouble;
begin
     Result := Roo2( Distance2( A_, B_ ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ave

function Ave( const P1_,P2_:TdSingle2D ) :TdSingle2D;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

function Ave( const P1_,P2_:TdDouble2D ) :TdDouble2D;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

//------------------------------------------------------------------------------

function Ave( const P1_,P2_,P3_:TdSingle2D ) :TdSingle2D;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

function Ave( const P1_,P2_,P3_:TdDouble2D ) :TdDouble2D;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

//------------------------------------------------------------------------------

function Ave( const P1_,P2_,P3_,P4_:TdSingle2D ) :TdSingle2D;
begin
     Result := ( P1_ + P2_ + P3_ + P4_ ) / 4;
end;

function Ave( const P1_,P2_,P3_,P4_:TdDouble2D ) :TdDouble2D;
begin
     Result := ( P1_ + P2_ + P3_ + P4_ ) / 4;
end;

end. //######################################################################### ■
