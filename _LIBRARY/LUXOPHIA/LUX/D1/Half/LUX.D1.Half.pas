unit LUX.D1.Half;

interface //#################################################################### ■

uses System.Math,
     LUX;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THalf

     PHalf = ^THalf;

     ///// IEEE 754 binary16（符号1・指数5・仮数10）の半精度浮動小数
     ///// ・演算は Single で行ってから binary16 へ丸め戻す（半精度の演算命令は使わない）
     ///// ・混合式は相手を先に THalf へ落とすので、極端に小さな係数は丸めで消える。
     /////   広い動的範囲が要るところは明示的に Single へ落として計算すること。

     THalf = record
     private
     public
       V :UInt16;
       /////
       constructor Create( const V_:Single );
       ///// O P E R A T O R
       class operator Positive( const V_:THalf ) :THalf;
       class operator Negative( const V_:THalf ) :THalf;
       class operator Add( const A_,B_:THalf ) :THalf;
       class operator Subtract( const A_,B_:THalf ) :THalf;
       class operator Multiply( const A_,B_:THalf ) :THalf;
       class operator Divide( const A_,B_:THalf ) :THalf;
       class operator Equal( const A_,B_:THalf ) :Boolean;
       class operator NotEqual( const A_,B_:THalf ) :Boolean;
       class operator GreaterThan( const A_,B_:THalf ) :Boolean;
       class operator GreaterThanOrEqual( const A_,B_:THalf ) :Boolean;
       class operator LessThan( const A_,B_:THalf ) :Boolean;
       class operator LessThanOrEqual( const A_,B_:THalf ) :Boolean;
       ///// C A S T
       class operator Implicit( const V_:Integer ) :THalf;
       class operator Implicit( const V_:Int64 ) :THalf;
       class operator Implicit( const V_:Single ) :THalf;
       class operator Implicit( const V_:Double ) :THalf;
       class operator Implicit( const V_:THalf ) :Single;  // 逆向きは Single のみ（多重にすると呼び出しが曖昧になる）
       ///// M E T H O D
       class function RandG( const SD_:Single = 1 ) :THalf; static;
       class function RandBS1 :THalf; static;
       class function RandBS2 :THalf; static;
       class function RandBS4 :THalf; static;
       class function NaN :THalf; static;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

      //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EPS

      HALF_EPS = 9.765625E-4;  // 2^-10 ： 1 の次の値との差

      HALF_MIN = 6.103515625E-5;  // 最小の正規化数 2^-14
      HALF_SUB = 5.9604644775390625E-8;  // 最小の非正規化数 2^-24
      HALF_MAX = 65504.0;  // 最大の有限値

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HalfToSingle / SingleToHalf

function HalfToSingle( const H_:UInt16 ) :Single;  // binary16 → binary32（無損失）
function SingleToHalf( const S_:Single ) :UInt16;  // binary32 → binary16（最近接偶数丸め・飽和は ±Inf）

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pow*

function Pow2( const X_:THalf ) :THalf; overload;
function Pow3( const X_:THalf ) :THalf; overload;
function Pow4( const X_:THalf ) :THalf; overload;
function Pow5( const X_:THalf ) :THalf; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Roo*

function Roo2( const X_:THalf ) :THalf; overload;
function Roo3( const X_:THalf ) :THalf; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clamp

function Clamp( const X_,Min_,Max_:THalf ) :THalf; overload;
function ClampMin( const X_,Min_:THalf ) :THalf; overload;
function ClampMax( const X_,Max_:THalf ) :THalf; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min / Max

function Min( const V1_,V2_:THalf ) :THalf; overload;
function Min( const V1_,V2_,V3_:THalf ) :THalf; overload;

function Max( const V1_,V2_:THalf ) :THalf; overload;
function Max( const V1_,V2_,V3_:THalf ) :THalf; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sign / Abso

function Sign( const V_:THalf ) :TValueSign; overload;
function Abso( const V_:THalf ) :THalf; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 初等関数

function Sin( const X_:THalf ) :THalf; overload;
function Cos( const X_:THalf ) :THalf; overload;

procedure SinCos( const X_:THalf; out S_,C_:THalf ); overload;
procedure CosSin( const X_:THalf; out C_,S_:THalf ); overload;

function Tan( const X_:THalf ) :THalf; overload;

function ArcSin( const X_:THalf ) :THalf; overload;
function ArcCos( const X_:THalf ) :THalf; overload;
function ArcTan( const X_:THalf ) :THalf; overload;
function ArcTan2( const Y_,X_:THalf ) :THalf; overload;

function Exp( const X_:THalf ) :THalf; overload;
function Ln( const X_:THalf ) :THalf; overload;

function Power( const X_,N_:THalf ) :THalf; overload;
function IntPower( const X_:THalf; const N_:Integer ) :THalf; overload;

function Cosh( const X_:THalf ) :THalf; overload;
function Sinh( const X_:THalf ) :THalf; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Gauss

function Gauss( const X_,SD_:THalf ) :THalf; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THalf

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor THalf.Create( const V_:Single );
begin
     V := SingleToHalf( V_ );
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator THalf.Positive( const V_:THalf ) :THalf;
begin
     Result := +HalfToSingle( V_.V );
end;

class operator THalf.Negative( const V_:THalf ) :THalf;
begin
     Result := -HalfToSingle( V_.V );
end;

//------------------------------------------------------------------------------

class operator THalf.Add( const A_,B_:THalf ) :THalf;
begin
     Result := HalfToSingle( A_.V ) + HalfToSingle( B_.V );
end;

class operator THalf.Subtract( const A_,B_:THalf ) :THalf;
begin
     Result := HalfToSingle( A_.V ) - HalfToSingle( B_.V );
end;

//------------------------------------------------------------------------------

class operator THalf.Multiply( const A_,B_:THalf ) :THalf;
begin
     Result := HalfToSingle( A_.V ) * HalfToSingle( B_.V );
end;

class operator THalf.Divide( const A_,B_:THalf ) :THalf;
begin
     Result := HalfToSingle( A_.V ) / HalfToSingle( B_.V );
end;

//------------------------------------------------------------------------------

class operator THalf.Equal( const A_,B_:THalf ) :Boolean;
begin
     Result := ( HalfToSingle( A_.V ) = HalfToSingle( B_.V ) );  // ±0 と NaN のために値で比べる
end;

class operator THalf.NotEqual( const A_,B_:THalf ) :Boolean;
begin
     Result := ( HalfToSingle( A_.V ) <> HalfToSingle( B_.V ) );
end;

//------------------------------------------------------------------------------

class operator THalf.GreaterThan( const A_,B_:THalf ) :Boolean;
begin
     Result := ( HalfToSingle( A_.V ) >  HalfToSingle( B_.V ) );
end;

class operator THalf.GreaterThanOrEqual( const A_,B_:THalf ) :Boolean;
begin
     Result := ( HalfToSingle( A_.V ) >= HalfToSingle( B_.V ) );
end;

class operator THalf.LessThan( const A_,B_:THalf ) :Boolean;
begin
     Result := ( HalfToSingle( A_.V ) <  HalfToSingle( B_.V ) );
end;

class operator THalf.LessThanOrEqual( const A_,B_:THalf ) :Boolean;
begin
     Result := ( HalfToSingle( A_.V ) <= HalfToSingle( B_.V ) );
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator THalf.Implicit( const V_:Integer ) :THalf;
begin
     Result.V := SingleToHalf( V_ );
end;

class operator THalf.Implicit( const V_:Int64 ) :THalf;
begin
     Result.V := SingleToHalf( V_ );
end;

class operator THalf.Implicit( const V_:Single ) :THalf;
begin
     Result.V := SingleToHalf( V_ );
end;

class operator THalf.Implicit( const V_:Double ) :THalf;
begin
     Result.V := SingleToHalf( V_ );
end;

class operator THalf.Implicit( const V_:THalf ) :Single;
begin
     Result := HalfToSingle( V_.V );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

class function THalf.RandG( const SD_:Single = 1 ) :THalf;
begin
     Result := System.Math.RandG( 0, SD_ );
end;

//------------------------------------------------------------------------------

class function THalf.RandBS1 :THalf;
begin
     Result := Random - 0.5;
end;

class function THalf.RandBS2 :THalf;
begin
     Result := HalfToSingle( RandBS1.V ) + HalfToSingle( RandBS1.V );
end;

class function THalf.RandBS4 :THalf;
begin
     Result := HalfToSingle( RandBS2.V ) + HalfToSingle( RandBS2.V );
end;

//------------------------------------------------------------------------------

class function THalf.NaN :THalf;
begin
     Result.V := $7E00;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% HalfToSingle / SingleToHalf

function HalfToSingle( const H_:UInt16 ) :Single;
var
   S, E, M, U :UInt32;
begin
     S := UInt32( H_ and $8000 ) shl 16;      // 符号
     E :=       ( H_ shr    10 ) and $1F;     // 指数
     M :=         H_ and $03FF;               // 仮数

     if E = 0 then
     begin
          if M = 0 then U := S                // ±0
                   else
          begin
               E := 127 - 15 + 1;             // 非正規化数 → 正規化

               while ( M and $0400 ) = 0 do
               begin
                    M := M shl 1;  Dec( E );
               end;

               U := S or ( E shl 23 ) or ( ( M and $03FF ) shl 13 );
          end;
     end
     else
     if E = 31 then U := S or $7F800000 or ( M shl 13 )                 // ±Inf / NaN
               else U := S or ( ( E + 127 - 15 ) shl 23 ) or ( M shl 13 );

     Result := PSingle( @U )^;
end;

function SingleToHalf( const S_:Single ) :UInt16;
var
   U, S, M, F, H :UInt32;
   E             :Int32;
   D             :Integer;
begin
     U := PUInt32( @S_ )^;

     S := ( U shr 16 ) and $8000;  // 符号
     U := U and $7FFFFFFF;         // 絶対値

     if U >= $7F800000 then        // ±Inf / NaN
     begin
          if U > $7F800000 then Exit( S or $7E00 )   // NaN（静粛化）
                           else Exit( S or $7C00 );  // ±Inf
     end;

     E := Int32( U shr 23 ) - 127 + 15;

     if E >= 31 then Exit( S or $7C00 );  // オーバーフロー → ±Inf

     if E <= 0 then                       // 非正規化数 → アンダーフロー
     begin
          if E < -10 then Exit( S );      // ±0

          M := ( U and $007FFFFF ) or $00800000;
          D := 14 - E;
          H := M shr D;
          F := M and ( ( UInt32( 1 ) shl D ) - 1 );  // 端数

          if      F >  ( UInt32( 1 ) shl ( D - 1 ) ) then Inc( H )
          else if F =  ( UInt32( 1 ) shl ( D - 1 ) ) then Inc( H, H and 1 );  // 最近接偶数

          Exit( S or H );
     end;

     H := ( UInt32( E ) shl 10 ) or ( ( U and $007FFFFF ) shr 13 );
     F := U and $00001FFF;  // 端数

     if      F >  $1000 then Inc( H )
     else if F =  $1000 then Inc( H, H and 1 );  // 最近接偶数（桁上がりは指数へ伝播）

     Result := S or H;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pow*

function Pow2( const X_:THalf ) :THalf;
begin
     Result := LUX.Pow2( Single( X_ ) );
end;

function Pow3( const X_:THalf ) :THalf;
begin
     Result := LUX.Pow3( Single( X_ ) );
end;

function Pow4( const X_:THalf ) :THalf;
begin
     Result := LUX.Pow4( Single( X_ ) );
end;

function Pow5( const X_:THalf ) :THalf;
begin
     Result := LUX.Pow5( Single( X_ ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Roo*

function Roo2( const X_:THalf ) :THalf;
begin
     Result := LUX.Roo2( Single( X_ ) );
end;

function Roo3( const X_:THalf ) :THalf;
begin
     Result := LUX.Roo3( Single( X_ ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clamp

function Clamp( const X_,Min_,Max_:THalf ) :THalf;
begin
     Result := LUX.Clamp( Single( X_ ), Single( Min_ ), Single( Max_ ) );
end;

function ClampMin( const X_,Min_:THalf ) :THalf;
begin
     Result := LUX.ClampMin( Single( X_ ), Single( Min_ ) );
end;

function ClampMax( const X_,Max_:THalf ) :THalf;
begin
     Result := LUX.ClampMax( Single( X_ ), Single( Max_ ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min / Max

function Min( const V1_,V2_:THalf ) :THalf;
begin
     if V1_ <= V2_ then Result := V1_
                   else Result := V2_;
end;

function Min( const V1_,V2_,V3_:THalf ) :THalf;
begin
     Result := Min( Min( V1_, V2_ ), V3_ );
end;

//------------------------------------------------------------------------------

function Max( const V1_,V2_:THalf ) :THalf;
begin
     if V1_ >= V2_ then Result := V1_
                   else Result := V2_;
end;

function Max( const V1_,V2_,V3_:THalf ) :THalf;
begin
     Result := Max( Max( V1_, V2_ ), V3_ );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sign / Abso

function Sign( const V_:THalf ) :TValueSign;
begin
     Result := System.Math.Sign( Single( V_ ) );
end;

function Abso( const V_:THalf ) :THalf;
begin
     Result.V := V_.V and $7FFF;  // 符号ビットを落とすだけ（丸め無し）
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 初等関数

function Sin( const X_:THalf ) :THalf;
begin
     Result := System.Sin( Single( X_ ) );
end;

function Cos( const X_:THalf ) :THalf;
begin
     Result := System.Cos( Single( X_ ) );
end;

//------------------------------------------------------------------------------

procedure SinCos( const X_:THalf; out S_,C_:THalf );
var
   S, C :Single;
begin
     System.Math.SinCos( Single( X_ ), S, C );

     S_ := S;
     C_ := C;
end;

procedure CosSin( const X_:THalf; out C_,S_:THalf );
begin
     SinCos( X_, S_, C_ );
end;

//------------------------------------------------------------------------------

function Tan( const X_:THalf ) :THalf;
begin
     Result := System.Math.Tan( Single( X_ ) );
end;

//------------------------------------------------------------------------------

function ArcSin( const X_:THalf ) :THalf;
begin
     Result := System.Math.ArcSin( Single( X_ ) );
end;

function ArcCos( const X_:THalf ) :THalf;
begin
     Result := System.Math.ArcCos( Single( X_ ) );
end;

function ArcTan( const X_:THalf ) :THalf;
begin
     Result := System.ArcTan( Single( X_ ) );
end;

function ArcTan2( const Y_,X_:THalf ) :THalf;
begin
     Result := System.Math.ArcTan2( Single( Y_ ), Single( X_ ) );
end;

//------------------------------------------------------------------------------

function Exp( const X_:THalf ) :THalf;
begin
     Result := System.Exp( Single( X_ ) );
end;

function Ln( const X_:THalf ) :THalf;
begin
     Result := System.Ln( Single( X_ ) );
end;

//------------------------------------------------------------------------------

function Power( const X_,N_:THalf ) :THalf;
begin
     Result := System.Math.Power( Single( X_ ), Single( N_ ) );
end;

function IntPower( const X_:THalf; const N_:Integer ) :THalf;
begin
     Result := System.Math.IntPower( Single( X_ ), N_ );
end;

//------------------------------------------------------------------------------

function Cosh( const X_:THalf ) :THalf;
begin
     Result := System.Math.Cosh( Single( X_ ) );
end;

function Sinh( const X_:THalf ) :THalf;
begin
     Result := System.Math.Sinh( Single( X_ ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Gauss

function Gauss( const X_,SD_:THalf ) :THalf;
var
   V :Single;
begin
     V := LUX.Pow2( Single( SD_ ) );

     Result := System.Exp( -LUX.Pow2( Single( X_ ) ) / ( 2 * V ) ) / LUX.Roo2( Pi2 * V );
end;

end. //######################################################################### ■
