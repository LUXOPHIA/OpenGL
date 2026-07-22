unit LUX.D1.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D1;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle

     TdSingle = record
     private
     public
       o :Single;
       d :Single;
       /////
       constructor Create( const o_,d_:Single );
       ///// O P E R A T O R
       class operator Positive( const V_:TdSingle ) :TdSingle;
       class operator Negative( const V_:TdSingle ) :TdSingle;
       class operator Add( const A_,B_:TdSingle ) :TdSingle;
       class operator Subtract( const A_,B_:TdSingle ) :TdSingle;
       class operator Multiply( const A_:Single; const B_:TdSingle ) :TdSingle;
       class operator Multiply( const A_:TdSingle; const B_:Single ) :TdSingle;
       class operator Multiply( const A_,B_:TdSingle ) :TdSingle;
       class operator Divide( const A_:TdSingle; const B_:Single ) :TdSingle;
       class operator Divide( const A_,B_:TdSingle ) :TdSingle;
       class operator Equal( const A_,B_:TdSingle ) :Boolean;
       class operator NotEqual( const A_,B_:TdSingle ) :Boolean;
       class operator GreaterThan( const A_,B_:TdSingle ) :Boolean;
       class operator GreaterThanOrEqual( const A_,B_:TdSingle ) :Boolean;
       class operator LessThan( const A_,B_:TdSingle ) :Boolean;
       class operator LessThanOrEqual( const A_,B_:TdSingle ) :Boolean;
       ///// C A S T
       class operator Implicit( const V_:Integer ) :TdSingle;
       class operator Implicit( const V_:Int64 ) :TdSingle;
       class operator Implicit( const V_:Single ) :TdSingle;
       ///// M E T H O D
       class function RandG( const SD_:Single = 1 ) :TdSingle; overload; static;
       class function RandBS1 :TdSingle; static;
       class function RandBS2 :TdSingle; static;
       class function RandBS4 :TdSingle; static;
       class function NaN :TdSingle; static;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble

     TdDouble = record
     private
     public
       o :Double;
       d :Double;
       /////
       constructor Create( const o_,d_:Double );
       ///// O P E R A T O R
       class operator Positive( const V_:TdDouble ) :TdDouble;
       class operator Negative( const V_:TdDouble ) :TdDouble;
       class operator Add( const A_,B_:TdDouble ) :TdDouble;
       class operator Subtract( const A_,B_:TdDouble ) :TdDouble;
       class operator Multiply( const A_:Double; const B_:TdDouble ) :TdDouble;
       class operator Multiply( const A_:TdDouble; const B_:Double ) :TdDouble;
       class operator Multiply( const A_,B_:TdDouble ) :TdDouble;
       class operator Divide( const A_:TdDouble; const B_:Double ) :TdDouble;
       class operator Divide( const A_,B_:TdDouble ) :TdDouble;
       class operator Equal( const A_,B_:TdDouble ) :Boolean;
       class operator NotEqual( const A_,B_:TdDouble ) :Boolean;
       class operator GreaterThan( const A_,B_:TdDouble ) :Boolean;
       class operator GreaterThanOrEqual( const A_,B_:TdDouble ) :Boolean;
       class operator LessThan( const A_,B_:TdDouble ) :Boolean;
       class operator LessThanOrEqual( const A_,B_:TdDouble ) :Boolean;
       ///// C A S T
       class operator Implicit( const V_:Integer ) :TdDouble;
       class operator Implicit( const V_:Int64 ) :TdDouble;
       class operator Implicit( const V_:Double ) :TdDouble;
       class operator Implicit( const V_:TdSingle ) :TdDouble;
       class operator Explicit( const V_:TdDouble ) :TdSingle;
       ///// M E T H O D
       class function RandG( const SD_:Double = 1 ) :TdDouble; overload; static;
       class function RandBS1 :TdDouble; static;
       class function RandBS2 :TdDouble; static;
       class function RandBS4 :TdDouble; static;
       class function NaN :TdDouble; static;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Pow2( const X_:TdSingle ) :TdSingle; overload;
function Pow2( const X_:TdDouble ) :TdDouble; overload;
           
function Pow3( const X_:TdSingle ) :TdSingle; overload;
function Pow3( const X_:TdDouble ) :TdDouble; overload;

function Pow4( const X_:TdSingle ) :TdSingle; overload;
function Pow4( const X_:TdDouble ) :TdDouble; overload;

function Pow5( const X_:TdSingle ) :TdSingle; overload;
function Pow5( const X_:TdDouble ) :TdDouble; overload;

function Roo2( const X_:TdSingle ) :TdSingle; overload;
function Roo2( const X_:TdDouble ) :TdDouble; overload;

function ArcCos( const X_:TdSingle ) :TdSingle; overload;
function ArcCos( const X_:TdDouble ) :TdDouble; overload;

function Abso( const V_:TdSingle ) :TdSingle; overload;
function Abso( const V_:TdDouble ) :TdDouble; overload;

function Sin( const X_:TdSingle ) :TdSingle; overload;
function Sin( const X_:TdDouble ) :TdDouble; overload;

function Cos( const X_:TdSingle ) :TdSingle; overload;
function Cos( const X_:TdDouble ) :TdDouble; overload;

procedure CosSin( const X_:TdSingle; out C_,S_:TdSingle ); overload;
procedure CosSin( const X_:TdDouble; out C_,S_:TdDouble ); overload;

procedure SinCos( const X_:TdSingle; out S_,C_:TdSingle ); overload;
procedure SinCos( const X_:TdDouble; out S_,C_:TdDouble ); overload;

function Tan( const X_:TdSingle ) :TdSingle; overload;
function Tan( const X_:TdDouble ) :TdDouble; overload;

function ArcTan( const X_:TdSingle ) :TdSingle; overload;
function ArcTan( const X_:TdDouble ) :TdDouble; overload;

function ArcTan2( const Y_,X_:TdSingle ) :TdSingle; overload;
function ArcTan2( const Y_,X_:TdDouble ) :TdDouble; overload;

function ArcSin( const X_:TdSingle ) :TdSingle; overload;
function ArcSin( const X_:TdDouble ) :TdDouble; overload;

function Min( const A_,B_:TdDouble ) :TdDouble; overload;
function Min( const A_,B_:TdSingle ) :TdSingle; overload;

function Max( const A_,B_:TdSingle ) :TdSingle; overload;
function Max( const A_,B_:TdDouble ) :TdDouble; overload;

function Min( const A_,B_,C_:TdDouble ) :TdDouble; overload;
function Min( const A_,B_,C_:TdSingle ) :TdSingle; overload;

function Max( const A_,B_,C_:TdSingle ) :TdSingle; overload;
function Max( const A_,B_,C_:TdDouble ) :TdDouble; overload;

function Exp( const X_:TdSingle ) :TdSingle; overload;
function Exp( const X_:TdDouble ) :TdDouble; overload;

function Ln( const X_:TdSingle ) :TdSingle; overload;
function Ln( const X_:TdDouble ) :TdDouble; overload;

function Power( const X_:TdSingle; const N_:Single ) :TdSingle; overload;
function Power( const X_:TdDouble; const N_:Double ) :TdDouble; overload;

function IntPower( const X_:TdSingle; const N_:Integer ) :TdSingle; overload;
function IntPower( const X_:TdDouble; const N_:Integer ) :TdDouble; overload;

function Power( const X_,N_:TdSingle ) :TdSingle; overload;  // 0 < X
function Power( const X_,N_:TdDouble ) :TdDouble; overload;  // 0 < X

function Cosh( const X_:TdSingle ) :TdSingle; overload;
function Cosh( const X_:TdDouble ) :TdDouble; overload;

function Sinh( const X_:TdSingle ) :TdSingle; overload;
function Sinh( const X_:TdDouble ) :TdDouble; overload;

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdSingle.Create( const o_,d_:Single );
begin
     o := o_;
     d := d_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdSingle.Positive( const V_:TdSingle ) :TdSingle;
begin
     Result.o := +V_.o;
     Result.d := +V_.d;
end;

class operator TdSingle.Negative( const V_:TdSingle ) :TdSingle;
begin
     Result.o := -V_.o;
     Result.d := -V_.d;
end;

//------------------------------------------------------------------------------

class operator TdSingle.Add( const A_,B_:TdSingle ) :TdSingle;
begin
     Result.o := A_.o + B_.o;
     Result.d := A_.d + B_.d;
end;

class operator TdSingle.Subtract( const A_,B_:TdSingle ) :TdSingle;
begin
     Result.o := A_.o - B_.o;
     Result.d := A_.d - B_.d;
end;

//------------------------------------------------------------------------------

class operator TdSingle.Multiply( const A_:Single; const B_:TdSingle ) :TdSingle;
begin
     Result.o := A_ * B_.o;
     Result.d := A_ * B_.d;
end;

class operator TdSingle.Multiply( const A_:TdSingle; const B_:Single ) :TdSingle;
begin
     Result.o := A_.o * B_;
     Result.d := A_.d * B_;
end;

class operator TdSingle.Multiply( const A_,B_:TdSingle ) :TdSingle;
begin
     Result.o := A_.o * B_.o;
     Result.d := A_.d * B_.o + A_.o * B_.d;
end;

//------------------------------------------------------------------------------

class operator TdSingle.Divide( const A_:TdSingle; const B_:Single ) :TdSingle;    
begin
     Result.o := A_.o / B_;
     Result.d := A_.d / B_;
end;

class operator TdSingle.Divide( const A_,B_:TdSingle ) :TdSingle;
begin
     Result.o := A_.o / B_.o;
     Result.d := ( A_.d * B_.o - A_.o * B_.d ) / Pow2( B_.o );
end;

//------------------------------------------------------------------------------

class operator TdSingle.Equal( const A_,B_:TdSingle ) :Boolean;
begin
     Result := ( A_.o = B_.o ) and ( A_.d = B_.d );
end;

class operator TdSingle.NotEqual( const A_,B_:TdSingle ) :Boolean;
begin
     Result := not ( A_ = B_ );
end;

//------------------------------------------------------------------------------

class operator TdSingle.GreaterThan( const A_,B_:TdSingle ) :Boolean;
begin
     Result := ( A_.o >  B_.o );
end;

class operator TdSingle.GreaterThanOrEqual( const A_,B_:TdSingle ) :Boolean;
begin
     Result := ( A_.o >= B_.o );
end;

class operator TdSingle.LessThan( const A_,B_:TdSingle ) :Boolean;
begin
     Result := ( A_.o <  B_.o );
end;

class operator TdSingle.LessThanOrEqual( const A_,B_:TdSingle ) :Boolean;
begin
     Result := ( A_.o <= B_.o );
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TdSingle.Implicit( const V_:Integer ) :TdSingle;
begin
     Result.o := V_;
     Result.d := 0 ;
end;

class operator TdSingle.Implicit( const V_:Int64 ) :TdSingle;
begin
     Result.o := V_;
     Result.d := 0 ;
end;

class operator TdSingle.Implicit( const V_:Single ) :TdSingle;
begin
     Result.o := V_;
     Result.d := 0 ;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

class function TdSingle.RandG( const SD_:Single = 1 ) :TdSingle;
begin
     Result.o := TSingle.RandG( SD_ );
     Result.d := 0;
end;

//------------------------------------------------------------------------------

class function TdSingle.RandBS1 :TdSingle;
begin
     Result.o := TSingle.RandBS1;
     Result.d := 0;
end;

class function TdSingle.RandBS2 :TdSingle;
begin
     Result.o := TSingle.RandBS2;
     Result.d := 0;
end;

class function TdSingle.RandBS4 :TdSingle;
begin
     Result.o := TSingle.RandBS4;
     Result.d := 0;
end;

//------------------------------------------------------------------------------

class function TdSingle.NaN :TdSingle;
begin
     Result.o := System.Math.NaN;
     Result.d := System.Math.NaN;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdDouble.Create( const o_,d_:Double );
begin
     o := o_;
     d := d_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdDouble.Positive( const V_:TdDouble ) :TdDouble;
begin
     Result.o := +V_.o;
     Result.d := +V_.d;
end;

class operator TdDouble.Negative( const V_:TdDouble ) :TdDouble;
begin
     Result.o := -V_.o;
     Result.d := -V_.d;
end;

//------------------------------------------------------------------------------

class operator TdDouble.Add( const A_,B_:TdDouble ) :TdDouble;
begin
     Result.o := A_.o + B_.o;
     Result.d := A_.d + B_.d;
end;

class operator TdDouble.Subtract( const A_,B_:TdDouble ) :TdDouble;
begin
     Result.o := A_.o - B_.o;
     Result.d := A_.d - B_.d;
end;

//------------------------------------------------------------------------------

class operator TdDouble.Multiply( const A_:Double; const B_:TdDouble ) :TdDouble;
begin
     Result.o := A_ * B_.o;
     Result.d := A_ * B_.d;
end;

class operator TdDouble.Multiply( const A_:TdDouble; const B_:Double ) :TdDouble;
begin
     Result.o := A_.o * B_;
     Result.d := A_.d * B_;
end;

class operator TdDouble.Multiply( const A_,B_:TdDouble ) :TdDouble;
begin
     Result.o := A_.o * B_.o;
     Result.d := A_.d * B_.o + A_.o * B_.d;
end;

//------------------------------------------------------------------------------

class operator TdDouble.Divide( const A_:TdDouble; const B_:Double ) :TdDouble;    
begin
     Result.o := A_.o / B_;
     Result.d := A_.d / B_;
end;

class operator TdDouble.Divide( const A_,B_:TdDouble ) :TdDouble;
begin
     Result.o := A_.o / B_.o;
     Result.d := ( A_.d * B_.o - A_.o * B_.d ) / Pow2( B_.o );
end;

//------------------------------------------------------------------------------

class operator TdDouble.Equal( const A_,B_:TdDouble ) :Boolean;
begin
     Result := ( A_.o = B_.o ) and ( A_.d = B_.d );
end;

class operator TdDouble.NotEqual( const A_,B_:TdDouble ) :Boolean;
begin
     Result := not ( A_ = B_ );
end;

//------------------------------------------------------------------------------

class operator TdDouble.GreaterThan( const A_,B_:TdDouble ) :Boolean;
begin
     Result := ( A_.o >  B_.o );
end;

class operator TdDouble.GreaterThanOrEqual( const A_,B_:TdDouble ) :Boolean;
begin
     Result := ( A_.o >= B_.o );
end;

class operator TdDouble.LessThan( const A_,B_:TdDouble ) :Boolean;
begin
     Result := ( A_.o <  B_.o );
end;

class operator TdDouble.LessThanOrEqual( const A_,B_:TdDouble ) :Boolean;
begin
     Result := ( A_.o <= B_.o );
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TdDouble.Implicit( const V_:Integer ) :TdDouble;
begin
     Result.o := V_;
     Result.d := 0 ;
end;

class operator TdDouble.Implicit( const V_:Int64 ) :TdDouble;
begin
     Result.o := V_;
     Result.d := 0 ;
end;

class operator TdDouble.Implicit( const V_:Double ) :TdDouble;
begin
     Result.o := V_;
     Result.d := 0 ;
end;

class operator TdDouble.Implicit( const V_:TdSingle ) :TdDouble;
begin
     Result.o := V_.o;
     Result.d := V_.d;
end;

class operator TdDouble.Explicit( const V_:TdDouble ) :TdSingle;
begin
     Result.o := V_.o;
     Result.d := V_.d;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

class function TdDouble.RandG( const SD_:Double = 1 ) :TdDouble;
begin
     Result.o := TDouble.RandG( SD_ );
     Result.d := 0;
end;

//------------------------------------------------------------------------------

class function TdDouble.RandBS1 :TdDouble;
begin
     Result.o := TDouble.RandBS1;
     Result.d := 0;
end;

class function TdDouble.RandBS2 :TdDouble;
begin
     Result.o := TDouble.RandBS2;
     Result.d := 0;
end;

class function TdDouble.RandBS4 :TdDouble;
begin
     Result.o := TDouble.RandBS4;
     Result.d := 0;
end;

//------------------------------------------------------------------------------

class function TdDouble.NaN :TdDouble;
begin
     Result.o := System.Math.NaN;
     Result.d := System.Math.NaN;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Pow2( const X_:TdSingle ) :TdSingle;
begin
     Result.o := Pow2( X_.o );
     Result.d := 2 * X_.o * X_.d;
end;

function Pow2( const X_:TdDouble ) :TdDouble;
begin
     Result.o := Pow2( X_.o );
     Result.d := 2 * X_.o * X_.d;
end;

//------------------------------------------------------------------------------

function Pow3( const X_:TdSingle ) :TdSingle;
begin
     Result.o :=     Pow3( X_.o )       ;
     Result.d := 3 * Pow2( X_.o ) * X_.d;
end;

function Pow3( const X_:TdDouble ) :TdDouble;
begin
     Result.o :=     Pow3( X_.o )       ;
     Result.d := 3 * Pow2( X_.o ) * X_.d;
end;

//------------------------------------------------------------------------------

function Pow4( const X_:TdSingle ) :TdSingle;
begin
     Result.o :=     Power( X_.o, 4 )       ;
     Result.d := 4 * Power( X_.o, 3 ) * X_.d;
end;

function Pow4( const X_:TdDouble ) :TdDouble;
begin
     Result.o :=     Power( X_.o, 4 )       ;
     Result.d := 4 * Power( X_.o, 3 ) * X_.d;
end;

//------------------------------------------------------------------------------

function Pow5( const X_:TdSingle ) :TdSingle;
begin
     Result.o :=     Power( X_.o, 5 )       ;
     Result.d := 5 * Power( X_.o, 4 ) * X_.d;
end;

function Pow5( const X_:TdDouble ) :TdDouble;
begin
     Result.o :=     Power( X_.o, 5 )       ;
     Result.d := 5 * Power( X_.o, 4 ) * X_.d;
end;

//------------------------------------------------------------------------------

function Roo2( const X_:TdSingle ) :TdSingle;
begin
     Result.o := Roo2( X_.o );
     Result.d := X_.d / ( 2 * Result.o );
end;

function Roo2( const X_:TdDouble ) :TdDouble;
begin
     Result.o := Roo2( X_.o );
     Result.d := X_.d / ( 2 * Result.o );
end;

//------------------------------------------------------------------------------

function ArcCos( const X_:TdSingle ) :TdSingle;
begin
     Result.o := ArcCos( X_.o );
     Result.d := -X_.d / Roo2( 1 - Pow2( X_.o ) );
end;

function ArcCos( const X_:TdDouble ) :TdDouble;
begin
     Result.o := ArcCos( X_.o );
     Result.d := -X_.d / Roo2( 1 - Pow2( X_.o ) );
end;

//------------------------------------------------------------------------------

function Abso( const V_:TdSingle ) :TdSingle;
begin
     Result := Sign( V_.o ) * V_;
end;

function Abso( const V_:TdDouble ) :TdDouble;
begin
     Result := Sign( V_.o ) * V_;
end;

//------------------------------------------------------------------------------

function Sin( const X_:TdSingle ) :TdSingle;
begin
     Result.o :=         Sin( X_.o );
     Result.d := X_.d * +Cos( X_.o );
end;

function Sin( const X_:TdDouble ) :TdDouble;
begin
     Result.o :=         Sin( X_.o );
     Result.d := X_.d * +Cos( X_.o );
end;

//------------------------------------------------------------------------------

function Cos( const X_:TdSingle ) :TdSingle;
begin
     Result.o :=         Cos( X_.o );
     Result.d := X_.d * -Sin( X_.o );
end;

function Cos( const X_:TdDouble ) :TdDouble;
begin
     Result.o :=         Cos( X_.o );
     Result.d := X_.d * -Sin( X_.o );
end;

//------------------------------------------------------------------------------

procedure CosSin( const X_:TdSingle; out C_,S_:TdSingle );
var
   S, C :Single;
begin
     SinCos( X_.o, S, C );

     S_.o :=         S;
     S_.d := X_.d * +C;

     C_.o :=         C;
     C_.d := X_.d * -S;
end;

procedure CosSin( const X_:TdDouble; out C_,S_:TdDouble );
var
   S, C :Double;
begin
     SinCos( X_.o, S, C );

     S_.o :=         S;
     S_.d := X_.d * +C;

     C_.o :=         C;
     C_.d := X_.d * -S;
end;

//------------------------------------------------------------------------------

procedure SinCos( const X_:TdSingle; out S_,C_:TdSingle );
var
   S, C :Single;
begin
     SinCos( X_.o, S, C );

     S_.o :=         S;
     S_.d := X_.d * +C;

     C_.o :=         C;
     C_.d := X_.d * -S;
end;

procedure SinCos( const X_:TdDouble; out S_,C_:TdDouble );
var
   S, C :Double;
begin
     SinCos( X_.o, S, C );

     S_.o :=         S;
     S_.d := X_.d * +C;

     C_.o :=         C;
     C_.d := X_.d * -S;
end;

//------------------------------------------------------------------------------

function Tan( const X_:TdSingle ) :TdSingle;
begin
     Result.o := Tan( X_.o );
     Result.d := X_.d / Pow2( Cos( X_.o ) );
end;

function Tan( const X_:TdDouble ) :TdDouble;
begin
     Result.o := Tan( X_.o );
     Result.d := X_.d / Pow2( Cos( X_.o ) );
end;

//------------------------------------------------------------------------------

function ArcTan( const X_:TdSingle ) :TdSingle;
begin
     Result.o := ArcTan( X_.o );
     Result.d := X_.d / ( 1 + Pow2( X_.o ) );
end;

function ArcTan( const X_:TdDouble ) :TdDouble;
begin
     Result.o := ArcTan( X_.o );
     Result.d := X_.d / ( 1 + Pow2( X_.o ) );
end;

//------------------------------------------------------------------------------

function ArcTan2( const Y_,X_:TdSingle ) :TdSingle;
begin
     Result.o := ArcTan2( Y_.o, X_.o );
     Result.d := ( X_.o * Y_.d - Y_.o * X_.d ) / ( Pow2( X_.o  ) + Pow2( Y_.o ) );
end;

function ArcTan2( const Y_,X_:TdDouble ) :TdDouble;
begin
     Result.o := ArcTan2( Y_.o, X_.o );
     Result.d := ( X_.o * Y_.d - Y_.o * X_.d ) / ( Pow2( X_.o  ) + Pow2( Y_.o ) );
end;

//------------------------------------------------------------------------------

function ArcSin( const X_:TdSingle ) :TdSingle;
begin
     Result.o := ArcSin( X_.o );
     Result.d := X_.d / Roo2( 1 - Pow2( X_.o ) );
end;

function ArcSin( const X_:TdDouble ) :TdDouble;
begin
     Result.o := ArcSin( X_.o );
     Result.d := X_.d / Roo2( 1 - Pow2( X_.o ) );
end;

//------------------------------------------------------------------------------

function Min( const A_,B_:TdDouble ) :TdDouble;
begin
     if A_ <= B_ then Result := A_
                 else Result := B_;
end;

function Min( const A_,B_:TdSingle ) :TdSingle;
begin
     if A_ <= B_ then Result := A_
                 else Result := B_;
end;

//------------------------------------------------------------------------------

function Max( const A_,B_:TdSingle ) :TdSingle;
begin
     if A_ <= B_ then Result := B_
                 else Result := A_;
end;

function Max( const A_,B_:TdDouble ) :TdDouble;
begin
     if A_ <= B_ then Result := B_
                 else Result := A_;
end;

//------------------------------------------------------------------------------

function Min( const A_,B_,C_:TdSingle ) :TdSingle;
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

function Min( const A_,B_,C_:TdDouble ) :TdDouble;
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

function Max( const A_,B_,C_:TdSingle ) :TdSingle;
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

function Max( const A_,B_,C_:TdDouble ) :TdDouble;
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

function Exp( const X_:TdSingle ) :TdSingle;
begin
     Result.o :=        Exp( X_.o );
     Result.d := X_.d * Exp( X_.o );
end;

function Exp( const X_:TdDouble ) :TdDouble;
begin
     Result.o :=        Exp( X_.o );
     Result.d := X_.d * Exp( X_.o );
end;

//------------------------------------------------------------------------------

function Ln( const X_:TdSingle ) :TdSingle;
begin
     Result.o :=    Ln( X_.o );
     Result.d := X_.d / X_.o  ;
end;

function Ln( const X_:TdDouble ) :TdDouble;
begin
     Result.o := Ln( X_.o );
     Result.d := X_.d / X_.o  ;
end;

//------------------------------------------------------------------------------

function Power( const X_:TdSingle; const N_:Single ) :TdSingle;
begin
     Result.o :=             Power( X_.o, N_     );
     Result.d := X_.d * N_ * Power( X_.o, N_ - 1 );
end;

function Power( const X_:TdDouble; const N_:Double ) :TdDouble;
begin
     Result.o :=             Power( X_.o, N_     );
     Result.d := X_.d * N_ * Power( X_.o, N_ - 1 );
end;

//------------------------------------------------------------------------------

function IntPower( const X_:TdSingle; const N_:Integer ) :TdSingle;
begin
     Result.o :=             IntPower( X_.o, N_     );
     Result.d := X_.d * N_ * IntPower( X_.o, N_ - 1 );
end;

function IntPower( const X_:TdDouble; const N_:Integer ) :TdDouble;
begin
     Result.o :=             IntPower( X_.o, N_     );
     Result.d := X_.d * N_ * IntPower( X_.o, N_ - 1 );
end;

//------------------------------------------------------------------------------

function Power( const X_,N_:TdSingle ) :TdSingle;
begin
     Result.o := Power( X_.o, N_.o );
     Result.d := Result.o * ( N_.d * Ln( X_.o ) + N_.o * X_.d / X_.o );
end;

function Power( const X_,N_:TdDouble ) :TdDouble;
begin
     Result.o := Power( X_.o, N_.o );
     Result.d := Result.o * ( N_.d * Ln( X_.o ) + N_.o * X_.d / X_.o );
end;

//------------------------------------------------------------------------------

function Cosh( const X_:TdSingle ) :TdSingle;
begin
     Result.o := Cosh( X_.o );
     Result.d := X_.d * Sinh( X_.o );
end;

function Cosh( const X_:TdDouble ) :TdDouble;
begin
     Result.o := Cosh( X_.o );
     Result.d := X_.d * Sinh( X_.o );
end;

//------------------------------------------------------------------------------

function Sinh( const X_:TdSingle ) :TdSingle;
begin
     Result.o := Sinh( X_.o );
     Result.d := X_.d * Cosh( X_.o );
end;

function Sinh( const X_:TdDouble ) :TdDouble;
begin
     Result.o := Sinh( X_.o );
     Result.d := X_.d * Cosh( X_.o );
end;

end. //######################################################################### ■
