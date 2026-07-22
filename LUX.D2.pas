unit LUX.D2;

interface //#################################################################### ■

uses System.Types,
     LUX, LUX.D1;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TInteger2D

     TInteger2D = record
     private
     public
       constructor Create( const V_:Integer ); overload;
       constructor Create( const X_,Y_:Integer ); overload;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..2-1 ] of Integer; );
      1:( _1  :Integer;
          _2  :Integer;                     );
      2:(  X  :Integer;
           Y  :Integer;                     );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle2D

     TSingle2D = record
     private
       ///// A C C E S S O R
       function GetD1( const X_:Integer ) :Single; overload; inline;
       procedure SetD1( const X_:Integer; const D1_:Single ); overload; inline;
       function GetSize2 :Single; inline;
       procedure SetSize2( const Size2_:Single ); inline;
       function GetSize :Single; inline;
       procedure SetSize( const Size_:Single ); inline;
       function GetUnitor :TSingle2D; inline;
       procedure SetUnitor( const Unitor_:TSingle2D ); inline;
       function GetOrthant :Byte;
     public
       constructor Create( const V_:Single ); overload;
       constructor Create( const X_,Y_:Single ); overload;
       ///// P R O P E R T Y
       property D1[ const X_:Integer ] :Single    read GetD1      write SetD1    ; default;
       property Size2                  :Single    read GetSize2   write SetSize2 ;
       property Size                   :Single    read GetSize    write SetSize  ;
       property Unitor                 :TSingle2D read GetUnitor  write SetUnitor;
       property Orthant                :Byte      read GetOrthant                ;
       ///// O P E R A T O R
       class operator Negative( const V_:TSingle2D ) :TSingle2D; inline;
       class operator Positive( const V_:TSingle2D ) :TSingle2D; inline;
       class operator Add( const A_,B_:TSingle2D ) :TSingle2D; inline;
       class operator Subtract( const A_,B_:TSingle2D ) :TSingle2D; inline;
       class operator Multiply( const A_:TSingle2D; const B_:Single ) :TSingle2D; inline;
       class operator Multiply( const A_:Single; const B_:TSingle2D ) :TSingle2D; inline;
       class operator Divide( const A_:TSingle2D; const B_:Single ) :TSingle2D; inline;
       ///// C A S T
       class operator Implicit( const V_:Single ) :TSingle2D;
       class operator Implicit( const V_:TPointF ) :TSingle2D;
       class operator Implicit( const V_:TSingle2D ) :TPointF;
       ///// C O N S T A N T
       class function IdentityX :TSingle2D; inline; static;
       class function IdentityY :TSingle2D; inline; static;
       ///// M E T H O D
       function VectorTo( const P_:TSingle2D ) :TSingle2D;
       function UnitorTo( const P_:TSingle2D ) :TSingle2D;
       function DistanTo( const P_:TSingle2D ) :Single;
       function RotL90 :TSingle2D;
       function RotR90 :TSingle2D;
       function RotAngleTo( const V_:TSingle2D ) :Single;
       class function RandG :TSingle2D; static;
       class function RandBS1 :TSingle2D; static;
       class function RandBS2 :TSingle2D; static;
       class function RandBS4 :TSingle2D; static;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..2-1 ] of Single; );
      1:( _1  :Single;
          _2  :Single;                     );
      2:(  X  :Single;
           Y  :Single;                     );
      3:(  U  :Single;
           V  :Single;                     );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble2D

     TDouble2D = record
     private
       ///// A C C E S S O R
       function GetD1( const X_:Integer ) :Double; overload; inline;
       procedure SetD1( const X_:Integer; const D1_:Double ); overload; inline;
       function GetSize2 :Double; inline;
       procedure SetSize2( const Size2_:Double ); inline;
       function GetSize :Double; inline;
       procedure SetSize( const Size_:Double ); inline;
       function GetUnitor :TDouble2D; inline;
       procedure SetUnitor( const Unitor_:TDouble2D ); inline;
       function GetOrthant :Byte;
     public
       constructor Create( const V_:Double ); overload;
       constructor Create( const X_,Y_:Double ); overload;
       ///// P R O P E R T Y
       property D1[ const X_:Integer ] :Double    read GetD1      write SetD1    ; default;
       property Size2                  :Double    read GetSize2   write SetSize2 ;
       property Size                   :Double    read GetSize    write SetSize  ;
       property Unitor                 :TDouble2D read GetUnitor  write SetUnitor;
       property Orthant                :Byte      read GetOrthant                ;
       ///// O P E R A T O R
       class operator Negative( const V_:TDouble2D ) :TDouble2D; inline;
       class operator Positive( const V_:TDouble2D ) :TDouble2D; inline;
       class operator Add( const A_,B_:TDouble2D ) :TDouble2D; inline;
       class operator Subtract( const A_,B_:TDouble2D ) :TDouble2D; inline;
       class operator Multiply( const A_:TDouble2D; const B_:Double ) :TDouble2D; inline;
       class operator Multiply( const A_:Double; const B_:TDouble2D ) :TDouble2D; inline;
       class operator Divide( const A_:TDouble2D; const B_:Double ) :TDouble2D; inline;
       ///// C A S T
       class operator Implicit( const V_:Double ) :TDouble2D;
       class operator Implicit( const V_:TPointF ) :TDouble2D;
       class operator Explicit( const V_:TDouble2D ) :TPointF;
       class operator Implicit( const V_:TSingle2D ) :TDouble2D;
       class operator Explicit( const V_:TDouble2D ) :TSingle2D;
       ///// C O N S T A N T
       class function IdentityX :TDouble2D; inline; static;
       class function IdentityY :TDouble2D; inline; static;
       ///// M E T H O D
       function VectorTo( const P_:TDouble2D ) :TDouble2D;
       function UnitorTo( const P_:TDouble2D ) :TDouble2D;
       function DistanTo( const P_:TDouble2D ) :Double;
       function RotL90 :TDouble2D;
       function RotR90 :TDouble2D;
       function RotAngleTo( const V_:TDouble2D ) :Double;
       class function RandG :TDouble2D; static;
       class function RandBS1 :TDouble2D; static;
       class function RandBS2 :TDouble2D; static;
       class function RandBS4 :TDouble2D; static;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..2-1 ] of Double; );
      1:( _1  :Double;
          _2  :Double;                     );
      2:(  X  :Double;
           Y  :Double;                     );
      3:(  U  :Double;
           V  :Double;                     );
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angle

function Angle( const V0_,V1_:TSingle2D ) :Single; overload;  //= 0..Pi
function Angle( const V0_,V1_:TDouble2D ) :Double; overload;  //= 0..Pi

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DotProduct

function DotProduct( const A_,B_:TSingle2D ) :Single; inline; overload;
function DotProduct( const A_,B_:TDouble2D ) :Double; inline; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CrossProduct

function CrossProduct( const A_,B_:TSingle2D ) :Single; overload;
function CrossProduct( const A_,B_:TDouble2D ) :Double; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distance

function Distance2( const A_,B_:TSingle2D ) :Single; inline; overload;
function Distance2( const A_,B_:TDouble2D ) :Double; inline; overload;

function Distance( const A_,B_:TSingle2D ) :Single; inline; overload;
function Distance( const A_,B_:TDouble2D ) :Double; inline; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ave

function Ave( const P1_,P2_:TSingle2D ) :TSingle2D; inline; overload;
function Ave( const P1_,P2_:TDouble2D ) :TDouble2D; inline; overload;

function Ave( const P1_,P2_,P3_:TSingle2D ) :TSingle2D; inline; overload;
function Ave( const P1_,P2_,P3_:TDouble2D ) :TDouble2D; inline; overload;

function Ave( const P1_,P2_,P3_,P4_:TSingle2D ) :TSingle2D; inline; overload;
function Ave( const P1_,P2_,P3_,P4_:TDouble2D ) :TDouble2D; inline; overload;

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TInteger2D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TInteger2D.Create( const V_:Integer );
begin
     X := V_;
     Y := V_;
end;

constructor TInteger2D.Create( const X_,Y_:Integer );
begin
     X := X_;
     Y := Y_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle2D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TSingle2D.GetD1( const X_:Integer ) :Single;
begin
     Result := _1D[ X_-1 ];
end;

procedure TSingle2D.SetD1( const X_:Integer; const D1_:Single );
begin
     _1D[ X_-1 ] := D1_;
end;

//------------------------------------------------------------------------------

function TSingle2D.GetSize2 :Single;
begin
     Result := Pow2( X ) + Pow2( Y );
end;

procedure TSingle2D.SetSize2( const Size2_:Single );
begin
     Self := Roo2( Size2_ / Size2 ) * Self;
end;

function TSingle2D.GetSize :Single;
begin
     Result := Roo2( Size2 );
end;

procedure TSingle2D.SetSize( const Size_:Single );
begin
     Self := Size_ * Unitor;
end;

function TSingle2D.GetUnitor :TSingle2D;
begin
     Result := Self / Size;
end;

procedure TSingle2D.SetUnitor( const Unitor_:TSingle2D );
begin
     Self := Size * Unitor_;
end;

//------------------------------------------------------------------------------

function TSingle2D.GetOrthant :Byte;
begin
     Result := 0;
     if X >= 0 then Result := Result or 1;
     if Y >= 0 then Result := Result or 2;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingle2D.Create( const V_:Single );
begin
     X := V_;
     Y := V_;
end;

constructor TSingle2D.Create( const X_,Y_:Single );
begin
     X := X_;
     Y := Y_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TSingle2D.Negative( const V_:TSingle2D ) :TSingle2D;
begin
     Result.X := -V_.X;
     Result.Y := -V_.Y;
end;

class operator TSingle2D.Positive( const V_:TSingle2D ) :TSingle2D;
begin
     Result.X := +V_.X;
     Result.Y := +V_.Y;
end;

class operator TSingle2D.Add( const A_,B_:TSingle2D ) :TSingle2D;
begin
     Result.X := A_.X + B_.X;
     Result.Y := A_.Y + B_.Y;
end;

class operator TSingle2D.Subtract( const A_,B_:TSingle2D ) :TSingle2D;
begin
     Result.X := A_.X - B_.X;
     Result.Y := A_.Y - B_.Y;
end;

class operator TSingle2D.Multiply( const A_:TSingle2D; const B_:Single ) :TSingle2D;
begin
     Result.X := A_.X * B_;
     Result.Y := A_.Y * B_;
end;

class operator TSingle2D.Multiply( const A_:Single; const B_:TSingle2D ) :TSingle2D;
begin
     Result.X := A_ * B_.X;
     Result.Y := A_ * B_.Y;
end;

class operator TSingle2D.Divide( const A_:TSingle2D; const B_:Single ) :TSingle2D;
begin
     Result.X := A_.X / B_;
     Result.Y := A_.Y / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TSingle2D.Implicit( const V_:Single ) :TSingle2D;
begin
     Result.X := V_;
     Result.Y := V_;
end;

//------------------------------------------------------------------------------

class operator TSingle2D.Implicit( const V_:TPointF ) :TSingle2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

class operator TSingle2D.Implicit( const V_:TSingle2D ) :TPointF;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TSingle2D.IdentityX :TSingle2D;
begin
     Result.X := 1;
     Result.Y := 0;
end;

class function TSingle2D.IdentityY :TSingle2D;
begin
     Result.X := 0;
     Result.Y := 1;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TSingle2D.VectorTo( const P_:TSingle2D ) :TSingle2D;
begin
     Result := P_ - Self;
end;

function TSingle2D.UnitorTo( const P_:TSingle2D ) :TSingle2D;
begin
     Result := VectorTo( P_ ).Unitor;
end;

function TSingle2D.DistanTo( const P_:TSingle2D ) :Single;
begin
     Result := VectorTo( P_ ).Size;
end;

//------------------------------------------------------------------------------

function TSingle2D.RotL90 :TSingle2D;
begin
     Result.X := -Y;
     Result.Y := +X;
end;

function TSingle2D.RotR90 :TSingle2D;
begin
     Result.X := +Y;
     Result.Y := -X;
end;

//------------------------------------------------------------------------------

function TSingle2D.RotAngleTo( const V_:TSingle2D ) :Single;
begin
     Result := ArcTan2( X * V_.Y - Y * V_.X,
                        X * V_.X + Y * V_.Y );
end;

//------------------------------------------------------------------------------

class function TSingle2D.RandG :TSingle2D;
begin
     Result.X := TSingle.RandG;
     Result.Y := TSingle.RandG;
end;

//------------------------------------------------------------------------------

class function TSingle2D.RandBS1 :TSingle2D;
begin
     Result.X := TSingle.RandBS1;
     Result.Y := TSingle.RandBS1;
end;

class function TSingle2D.RandBS2 :TSingle2D;
begin
     Result.X := TSingle.RandBS2;
     Result.Y := TSingle.RandBS2;
end;

class function TSingle2D.RandBS4 :TSingle2D;
begin
     Result.X := TSingle.RandBS4;
     Result.Y := TSingle.RandBS4;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble2D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TDouble2D.GetD1( const X_:Integer ) :Double;
begin
     Result := _1D[ X_-1 ];
end;

procedure TDouble2D.SetD1( const X_:Integer; const D1_:Double );
begin
     _1D[ X_-1 ] := D1_;
end;

//------------------------------------------------------------------------------

function TDouble2D.GetSize2 :Double;
begin
     Result := Pow2( X ) + Pow2( Y );
end;

procedure TDouble2D.SetSize2( const Size2_:Double );
begin
     Self := Roo2( Size2_ / Size2 ) * Self;
end;

function TDouble2D.GetSize :Double;
begin
     Result := Roo2( Size2 );
end;

procedure TDouble2D.SetSize( const Size_:Double );
begin
     Self := Size_ * Unitor;
end;

function TDouble2D.GetUnitor :TDouble2D;
begin
     Result := Self / Size;
end;

procedure TDouble2D.SetUnitor( const Unitor_:TDouble2D );
begin
     Self := Size * Unitor_;
end;

//------------------------------------------------------------------------------

function TDouble2D.GetOrthant :Byte;
begin
     Result := 0;
     if X >= 0 then Result := Result or 1;
     if Y >= 0 then Result := Result or 2;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDouble2D.Create( const V_:Double );
begin
     X := V_;
     Y := V_;
end;

constructor TDouble2D.Create( const X_,Y_:Double );
begin
     X := X_;
     Y := Y_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TDouble2D.Negative( const V_:TDouble2D ) :TDouble2D;
begin
     Result.X := -V_.X;
     Result.Y := -V_.Y;
end;

class operator TDouble2D.Positive( const V_:TDouble2D ) :TDouble2D;
begin
     Result.X := +V_.X;
     Result.Y := +V_.Y;
end;

class operator TDouble2D.Add( const A_,B_:TDouble2D ) :TDouble2D;
begin
     Result.X := A_.X + B_.X;
     Result.Y := A_.Y + B_.Y;
end;

class operator TDouble2D.Subtract( const A_,B_:TDouble2D ) :TDouble2D;
begin
     Result.X := A_.X - B_.X;
     Result.Y := A_.Y - B_.Y;
end;

class operator TDouble2D.Multiply( const A_:TDouble2D; const B_:Double ) :TDouble2D;
begin
     Result.X := A_.X * B_;
     Result.Y := A_.Y * B_;
end;

class operator TDouble2D.Multiply( const A_:Double; const B_:TDouble2D ) :TDouble2D;
begin
     Result.X := A_ * B_.X;
     Result.Y := A_ * B_.Y;
end;

class operator TDouble2D.Divide( const A_:TDouble2D; const B_:Double ) :TDouble2D;
begin
     Result.X := A_.X / B_;
     Result.Y := A_.Y / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TDouble2D.Implicit( const V_:Double ) :TDouble2D;
begin
     Result.X := V_;
     Result.Y := V_;
end;

//------------------------------------------------------------------------------

class operator TDouble2D.Implicit( const V_:TPointF ) :TDouble2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

class operator TDouble2D.Explicit( const V_:TDouble2D ) :TPointF;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

//------------------------------------------------------------------------------

class operator TDouble2D.Implicit( const V_:TSingle2D ) :TDouble2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

class operator TDouble2D.Explicit( const V_:TDouble2D ) :TSingle2D;
begin
     Result.X := V_.X;
     Result.Y := V_.Y;
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TDouble2D.IdentityX :TDouble2D;
begin
     Result.X := 1;
     Result.Y := 0;
end;

class function TDouble2D.IdentityY :TDouble2D;
begin
     Result.X := 0;
     Result.Y := 1;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TDouble2D.VectorTo( const P_:TDouble2D ) :TDouble2D;
begin
     Result := P_ - Self;
end;

function TDouble2D.UnitorTo( const P_:TDouble2D ) :TDouble2D;
begin
     Result := VectorTo( P_ ).Unitor;
end;

function TDouble2D.DistanTo( const P_:TDouble2D ) :Double;
begin
     Result := VectorTo( P_ ).Size;
end;

//------------------------------------------------------------------------------

function TDouble2D.RotL90 :TDouble2D;
begin
     Result.X := -Y;
     Result.Y := +X;
end;

function TDouble2D.RotR90 :TDouble2D;
begin
     Result.X := +Y;
     Result.Y := -X;
end;

//------------------------------------------------------------------------------

function TDouble2D.RotAngleTo( const V_:TDouble2D ) :Double;
begin
     Result := ArcTan2( X * V_.Y - Y * V_.X,
                        X * V_.X + Y * V_.Y );
end;

//------------------------------------------------------------------------------

class function TDouble2D.RandG :TDouble2D;
begin
     Result.X := TDouble.RandG;
     Result.Y := TDouble.RandG;
end;

//------------------------------------------------------------------------------

class function TDouble2D.RandBS1 :TDouble2D;
begin
     Result.X := TDouble.RandBS1;
     Result.Y := TDouble.RandBS1;
end;

class function TDouble2D.RandBS2 :TDouble2D;
begin
     Result.X := TDouble.RandBS2;
     Result.Y := TDouble.RandBS2;
end;

class function TDouble2D.RandBS4 :TDouble2D;
begin
     Result.X := TDouble.RandBS4;
     Result.Y := TDouble.RandBS4;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Angle

function Angle( const V0_,V1_:TSingle2D ) :Single;
begin
     Result := ArcCos( Clamp( DotProduct( V0_, V1_ ), -1, +1 ) );
end;

function Angle( const V0_,V1_:TDouble2D ) :Double;
begin
     Result := ArcCos( Clamp( DotProduct( V0_, V1_ ), -1, +1 ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DotProduct

function DotProduct( const A_,B_:TSingle2D ) :Single;
begin
     Result := A_.X * B_.X
             + A_.Y * B_.Y;
end;

function DotProduct( const A_,B_:TDouble2D ) :Double;
begin
     Result := A_.X * B_.X
             + A_.Y * B_.Y;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CrossProduct

function CrossProduct( const A_,B_:TSingle2D ) :Single;
begin
     Result := A_.X * B_.Y - A_.Y * B_.X;
end;

function CrossProduct( const A_,B_:TDouble2D ) :Double;
begin
     Result := A_.X * B_.Y - A_.Y * B_.X;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Distance

function Distance2( const A_,B_:TSingle2D ) :Single;
begin
     Result := Pow2( B_.X - A_.X ) + Pow2( B_.Y - A_.Y );
end;

function Distance2( const A_,B_:TDouble2D ) :Double;
begin
     Result := Pow2( B_.X - A_.X ) + Pow2( B_.Y - A_.Y );
end;

function Distance( const A_,B_:TSingle2D ) :Single;
begin
     Result := Roo2( Distance2( A_, B_ ) );
end;

function Distance( const A_,B_:TDouble2D ) :Double;
begin
     Result := Roo2( Distance2( A_, B_ ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ave

function Ave( const P1_,P2_:TSingle2D ) :TSingle2D;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

function Ave( const P1_,P2_:TDouble2D ) :TDouble2D;
begin
     Result := ( P1_ + P2_ ) / 2;
end;

//------------------------------------------------------------------------------

function Ave( const P1_,P2_,P3_:TSingle2D ) :TSingle2D;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

function Ave( const P1_,P2_,P3_:TDouble2D ) :TDouble2D;
begin
     Result := ( P1_ + P2_ + P3_ ) / 3;
end;

//------------------------------------------------------------------------------

function Ave( const P1_,P2_,P3_,P4_:TSingle2D ) :TSingle2D;
begin
     Result := ( P1_ + P2_ + P3_ + P4_ ) / 4;
end;

function Ave( const P1_,P2_,P3_,P4_:TDouble2D ) :TDouble2D;
begin
     Result := ( P1_ + P2_ + P3_ + P4_ ) / 4;
end;

end. //######################################################################### ■
