unit LUX.D1.Half.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D1.Half;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdHalf

     ///// 半精度の一階微分付き数（前進微分）
     ///// ・o が値、d が微分係数。演算は Single で行われ、格納の度に binary16 へ丸められる。

     TdHalf = record
     private
     public
       o :THalf;
       d :THalf;
       /////
       constructor Create( const o_,d_:THalf );
       ///// O P E R A T O R
       class operator Positive( const V_:TdHalf ) :TdHalf;
       class operator Negative( const V_:TdHalf ) :TdHalf;
       class operator Add( const A_,B_:TdHalf ) :TdHalf;
       class operator Subtract( const A_,B_:TdHalf ) :TdHalf;
       class operator Multiply( const A_:THalf; const B_:TdHalf ) :TdHalf;
       class operator Multiply( const A_:TdHalf; const B_:THalf ) :TdHalf;
       class operator Multiply( const A_,B_:TdHalf ) :TdHalf;
       class operator Divide( const A_:TdHalf; const B_:THalf ) :TdHalf;
       class operator Divide( const A_,B_:TdHalf ) :TdHalf;
       class operator Equal( const A_,B_:TdHalf ) :Boolean;
       class operator NotEqual( const A_,B_:TdHalf ) :Boolean;
       class operator GreaterThan( const A_,B_:TdHalf ) :Boolean;
       class operator GreaterThanOrEqual( const A_,B_:TdHalf ) :Boolean;
       class operator LessThan( const A_,B_:TdHalf ) :Boolean;
       class operator LessThanOrEqual( const A_,B_:TdHalf ) :Boolean;
       ///// C A S T
       class operator Implicit( const V_:Integer ) :TdHalf;
       class operator Implicit( const V_:Int64 ) :TdHalf;
       class operator Implicit( const V_:Single ) :TdHalf;
       class operator Implicit( const V_:THalf ) :TdHalf;
       ///// M E T H O D
       class function RandG( const SD_:Single = 1 ) :TdHalf; overload; static;
       class function RandBS1 :TdHalf; static;
       class function RandBS2 :TdHalf; static;
       class function RandBS4 :TdHalf; static;
       class function NaN :TdHalf; static;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Pow2( const X_:TdHalf ) :TdHalf; overload;

function Pow3( const X_:TdHalf ) :TdHalf; overload;

function Pow4( const X_:TdHalf ) :TdHalf; overload;

function Pow5( const X_:TdHalf ) :TdHalf; overload;

function Roo2( const X_:TdHalf ) :TdHalf; overload;

function ArcCos( const X_:TdHalf ) :TdHalf; overload;

function Abso( const V_:TdHalf ) :TdHalf; overload;

function Sin( const X_:TdHalf ) :TdHalf; overload;

function Cos( const X_:TdHalf ) :TdHalf; overload;

procedure CosSin( const X_:TdHalf; out C_,S_:TdHalf ); overload;

procedure SinCos( const X_:TdHalf; out S_,C_:TdHalf ); overload;

function Tan( const X_:TdHalf ) :TdHalf; overload;

function ArcTan( const X_:TdHalf ) :TdHalf; overload;

function ArcTan2( const Y_,X_:TdHalf ) :TdHalf; overload;

function ArcSin( const X_:TdHalf ) :TdHalf; overload;

function Min( const A_,B_:TdHalf ) :TdHalf; overload;

function Max( const A_,B_:TdHalf ) :TdHalf; overload;

function Min( const A_,B_,C_:TdHalf ) :TdHalf; overload;

function Max( const A_,B_,C_:TdHalf ) :TdHalf; overload;

function Exp( const X_:TdHalf ) :TdHalf; overload;

function Ln( const X_:TdHalf ) :TdHalf; overload;

function Power( const X_:TdHalf; const N_:THalf ) :TdHalf; overload;

function IntPower( const X_:TdHalf; const N_:Integer ) :TdHalf; overload;

function Power( const X_,N_:TdHalf ) :TdHalf; overload;  // 0 < X

function Cosh( const X_:TdHalf ) :TdHalf; overload;

function Sinh( const X_:TdHalf ) :TdHalf; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdHalf

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdHalf.Create( const o_,d_:THalf );
begin
     o := o_;
     d := d_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdHalf.Positive( const V_:TdHalf ) :TdHalf;
begin
     Result.o := +V_.o;
     Result.d := +V_.d;
end;

class operator TdHalf.Negative( const V_:TdHalf ) :TdHalf;
begin
     Result.o := -V_.o;
     Result.d := -V_.d;
end;

//------------------------------------------------------------------------------

class operator TdHalf.Add( const A_,B_:TdHalf ) :TdHalf;
begin
     Result.o := A_.o + B_.o;
     Result.d := A_.d + B_.d;
end;

class operator TdHalf.Subtract( const A_,B_:TdHalf ) :TdHalf;
begin
     Result.o := A_.o - B_.o;
     Result.d := A_.d - B_.d;
end;

//------------------------------------------------------------------------------

class operator TdHalf.Multiply( const A_:THalf; const B_:TdHalf ) :TdHalf;
begin
     Result.o := A_ * B_.o;
     Result.d := A_ * B_.d;
end;

class operator TdHalf.Multiply( const A_:TdHalf; const B_:THalf ) :TdHalf;
begin
     Result.o := A_.o * B_;
     Result.d := A_.d * B_;
end;

class operator TdHalf.Multiply( const A_,B_:TdHalf ) :TdHalf;
begin
     Result.o := A_.o * B_.o;
     Result.d := A_.d * B_.o + A_.o * B_.d;
end;

//------------------------------------------------------------------------------

class operator TdHalf.Divide( const A_:TdHalf; const B_:THalf ) :TdHalf;
begin
     Result.o := A_.o / B_;
     Result.d := A_.d / B_;
end;

class operator TdHalf.Divide( const A_,B_:TdHalf ) :TdHalf;
begin
     Result.o := A_.o / B_.o;
     Result.d := ( A_.d * B_.o - A_.o * B_.d ) / Pow2( B_.o );
end;

//------------------------------------------------------------------------------

class operator TdHalf.Equal( const A_,B_:TdHalf ) :Boolean;
begin
     Result := ( A_.o = B_.o ) and ( A_.d = B_.d );
end;

class operator TdHalf.NotEqual( const A_,B_:TdHalf ) :Boolean;
begin
     Result := not ( A_ = B_ );
end;

//------------------------------------------------------------------------------

class operator TdHalf.GreaterThan( const A_,B_:TdHalf ) :Boolean;
begin
     Result := ( A_.o >  B_.o );
end;

class operator TdHalf.GreaterThanOrEqual( const A_,B_:TdHalf ) :Boolean;
begin
     Result := ( A_.o >= B_.o );
end;

class operator TdHalf.LessThan( const A_,B_:TdHalf ) :Boolean;
begin
     Result := ( A_.o <  B_.o );
end;

class operator TdHalf.LessThanOrEqual( const A_,B_:TdHalf ) :Boolean;
begin
     Result := ( A_.o <= B_.o );
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TdHalf.Implicit( const V_:Integer ) :TdHalf;
begin
     Result.o := V_;
     Result.d := 0 ;
end;

class operator TdHalf.Implicit( const V_:Int64 ) :TdHalf;
begin
     Result.o := V_;
     Result.d := 0 ;
end;

class operator TdHalf.Implicit( const V_:Single ) :TdHalf;
begin
     Result.o := V_;
     Result.d := 0 ;
end;

class operator TdHalf.Implicit( const V_:THalf ) :TdHalf;
begin
     Result.o := V_;
     Result.d := 0 ;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

class function TdHalf.RandG( const SD_:Single = 1 ) :TdHalf;
begin
     Result.o := THalf.RandG( SD_ );
     Result.d := 0;
end;

//------------------------------------------------------------------------------

class function TdHalf.RandBS1 :TdHalf;
begin
     Result.o := THalf.RandBS1;
     Result.d := 0;
end;

class function TdHalf.RandBS2 :TdHalf;
begin
     Result.o := THalf.RandBS2;
     Result.d := 0;
end;

class function TdHalf.RandBS4 :TdHalf;
begin
     Result.o := THalf.RandBS4;
     Result.d := 0;
end;

//------------------------------------------------------------------------------

class function TdHalf.NaN :TdHalf;
begin
     Result.o := THalf.NaN;
     Result.d := THalf.NaN;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Pow2( const X_:TdHalf ) :TdHalf;
begin
     Result.o := LUX.D1.Half.Pow2( X_.o );
     Result.d := 2 * X_.o * X_.d;
end;

//------------------------------------------------------------------------------

function Pow3( const X_:TdHalf ) :TdHalf;
begin
     Result.o :=     LUX.D1.Half.Pow3( X_.o )       ;
     Result.d := 3 * LUX.D1.Half.Pow2( X_.o ) * X_.d;
end;

//------------------------------------------------------------------------------

function Pow4( const X_:TdHalf ) :TdHalf;
begin
     Result.o :=     LUX.D1.Half.Pow4( X_.o )       ;
     Result.d := 4 * LUX.D1.Half.Pow3( X_.o ) * X_.d;
end;

//------------------------------------------------------------------------------

function Pow5( const X_:TdHalf ) :TdHalf;
begin
     Result.o :=     LUX.D1.Half.Pow5( X_.o )       ;
     Result.d := 5 * LUX.D1.Half.Pow4( X_.o ) * X_.d;
end;

//------------------------------------------------------------------------------

function Roo2( const X_:TdHalf ) :TdHalf;
begin
     Result.o := LUX.D1.Half.Roo2( X_.o );
     Result.d := X_.d / ( 2 * Result.o );
end;

//------------------------------------------------------------------------------

function ArcCos( const X_:TdHalf ) :TdHalf;
begin
     Result.o := LUX.D1.Half.ArcCos( X_.o );
     Result.d := -X_.d / LUX.D1.Half.Roo2( 1 - LUX.D1.Half.Pow2( X_.o ) );
end;

//------------------------------------------------------------------------------

function Abso( const V_:TdHalf ) :TdHalf;
var
   S :THalf;
begin
     S := LUX.D1.Half.Sign( V_.o );

     Result := S * V_;
end;

//------------------------------------------------------------------------------

function Sin( const X_:TdHalf ) :TdHalf;
begin
     Result.o :=         LUX.D1.Half.Sin( X_.o );
     Result.d := X_.d * +LUX.D1.Half.Cos( X_.o );
end;

//------------------------------------------------------------------------------

function Cos( const X_:TdHalf ) :TdHalf;
begin
     Result.o :=         LUX.D1.Half.Cos( X_.o );
     Result.d := X_.d * -LUX.D1.Half.Sin( X_.o );
end;

//------------------------------------------------------------------------------

procedure CosSin( const X_:TdHalf; out C_,S_:TdHalf );
var
   S, C :THalf;
begin
     LUX.D1.Half.SinCos( X_.o, S, C );

     S_.o :=         S;
     S_.d := X_.d * +C;

     C_.o :=         C;
     C_.d := X_.d * -S;
end;

//------------------------------------------------------------------------------

procedure SinCos( const X_:TdHalf; out S_,C_:TdHalf );
var
   S, C :THalf;
begin
     LUX.D1.Half.SinCos( X_.o, S, C );

     S_.o :=         S;
     S_.d := X_.d * +C;

     C_.o :=         C;
     C_.d := X_.d * -S;
end;

//------------------------------------------------------------------------------

function Tan( const X_:TdHalf ) :TdHalf;
begin
     Result.o := LUX.D1.Half.Tan( X_.o );
     Result.d := X_.d / LUX.D1.Half.Pow2( LUX.D1.Half.Cos( X_.o ) );
end;

//------------------------------------------------------------------------------

function ArcTan( const X_:TdHalf ) :TdHalf;
begin
     Result.o := LUX.D1.Half.ArcTan( X_.o );
     Result.d := X_.d / ( 1 + LUX.D1.Half.Pow2( X_.o ) );
end;

//------------------------------------------------------------------------------

function ArcTan2( const Y_,X_:TdHalf ) :TdHalf;
begin
     Result.o := LUX.D1.Half.ArcTan2( Y_.o, X_.o );
     Result.d := ( X_.o * Y_.d - Y_.o * X_.d ) / ( LUX.D1.Half.Pow2( X_.o ) + LUX.D1.Half.Pow2( Y_.o ) );
end;

//------------------------------------------------------------------------------

function ArcSin( const X_:TdHalf ) :TdHalf;
begin
     Result.o := LUX.D1.Half.ArcSin( X_.o );
     Result.d := X_.d / LUX.D1.Half.Roo2( 1 - LUX.D1.Half.Pow2( X_.o ) );
end;

//------------------------------------------------------------------------------

function Min( const A_,B_:TdHalf ) :TdHalf;
begin
     if A_ <= B_ then Result := A_
                 else Result := B_;
end;

//------------------------------------------------------------------------------

function Max( const A_,B_:TdHalf ) :TdHalf;
begin
     if A_ <= B_ then Result := B_
                 else Result := A_;
end;

//------------------------------------------------------------------------------

function Min( const A_,B_,C_:TdHalf ) :TdHalf;
begin
     if A_ <= B_ then
     begin
          if A_ <= C_ then Result := A_
                      else Result := C_;
     end
     else
     begin
          if B_ <= C_ then Result := B_
                      else Result := C_;
     end;
end;

//------------------------------------------------------------------------------

function Max( const A_,B_,C_:TdHalf ) :TdHalf;
begin
     if A_ >= B_ then
     begin
          if A_ >= C_ then Result := A_
                      else Result := C_;
     end
     else
     begin
          if B_ >= C_ then Result := B_
                      else Result := C_;
     end;
end;

//------------------------------------------------------------------------------

function Exp( const X_:TdHalf ) :TdHalf;
begin
     Result.o :=        LUX.D1.Half.Exp( X_.o );
     Result.d := X_.d * LUX.D1.Half.Exp( X_.o );
end;

//------------------------------------------------------------------------------

function Ln( const X_:TdHalf ) :TdHalf;
begin
     Result.o := LUX.D1.Half.Ln( X_.o );
     Result.d := X_.d / X_.o             ;
end;

//------------------------------------------------------------------------------

function Power( const X_:TdHalf; const N_:THalf ) :TdHalf;
begin
     Result.o :=             LUX.D1.Half.Power( X_.o, N_     );
     Result.d := X_.d * N_ * LUX.D1.Half.Power( X_.o, N_ - 1 );
end;

//------------------------------------------------------------------------------

function IntPower( const X_:TdHalf; const N_:Integer ) :TdHalf;
begin
     Result.o :=             LUX.D1.Half.IntPower( X_.o, N_     );
     Result.d := X_.d * N_ * LUX.D1.Half.IntPower( X_.o, N_ - 1 );
end;

//------------------------------------------------------------------------------

function Power( const X_,N_:TdHalf ) :TdHalf;
begin
     Result.o := LUX.D1.Half.Power( X_.o, N_.o );
     Result.d := Result.o * ( N_.d * LUX.D1.Half.Ln( X_.o ) + N_.o * X_.d / X_.o );
end;

//------------------------------------------------------------------------------

function Cosh( const X_:TdHalf ) :TdHalf;
begin
     Result.o := LUX.D1.Half.Cosh( X_.o );
     Result.d := X_.d * LUX.D1.Half.Sinh( X_.o );
end;

//------------------------------------------------------------------------------

function Sinh( const X_:TdHalf ) :TdHalf;
begin
     Result.o := LUX.D1.Half.Sinh( X_.o );
     Result.d := X_.d * LUX.D1.Half.Cosh( X_.o );
end;

end. //######################################################################### ■
