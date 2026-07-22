unit LUX.Curve.Poly;

interface //#################################################################### ■

uses LUX,
     LUX.D1,
     LUX.D2, LUX.D2x2,
     LUX.D3, LUX.D3x3,
     LUX.D4, LUX.D4x4,
     LUX.D5,
     LUX.DN,
     LUX.Curve;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function Legendre( const X_:Single; const N_:Cardinal ) :Single; overload;
function Legendre( const X_:Double; const N_:Cardinal ) :Double; overload;

function Chebyshev1( const X_:Single; const N_:Cardinal ) :Single; overload;
function Chebyshev1( const X_:Double; const N_:Cardinal ) :Double; overload;

function SumLegendre( const X_:Single; const Ws_:array of Single ) :Single; overload;
function SumLegendre( const X_:Double; const Ws_:array of Double ) :Double; overload;

function SumChebyshev1( const X_:Single; const Ws_:array of Single ) :Single; overload;
function SumChebyshev1( const X_:Double; const Ws_:array of Double ) :Double; overload;

function Poly( const X_:Single; const Ks_:TSingle2D ) :Single; overload;
function Poly( const X_:Double; const Ks_:TDouble2D ) :Double; overload;

function Poly( const X_:Single; const Ks_:TSingle3D ) :Single; overload;
function Poly( const X_:Double; const Ks_:TDouble3D ) :Double; overload;

function Poly( const X_:Single; const Ks_:TSingle4D ) :Single; overload;
function Poly( const X_:Double; const Ks_:TDouble4D ) :Double; overload;

function Poly( const X_:Single; const Ks_:TSingle5D ) :Single; overload;
function Poly( const X_:Double; const Ks_:TDouble5D ) :Double; overload;

function Poly( const X_:Single; const Ks_:TSingleND ) :Single; overload;
function Poly( const X_:Double; const Ks_:TDoubleND ) :Double; overload;

function FitPoly( const P_:TSingle4D ) :TSingle4D; overload;
function FitPoly( const P_:TDouble4D ) :TDouble4D; overload;

function FitPoly( const P_:TSingle5D ) :TSingle5D; overload;
function FitPoly( const P_:TDouble5D ) :TDouble5D; overload;

procedure RandPoly( out Ks_:TSingle4D ); overload;
procedure RandPoly( out Ks_:TDouble4D ); overload;

procedure RandPoly( out Ks_:TSingle5D ); overload;
procedure RandPoly( out Ks_:TDouble5D ); overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function Legendre( const X_:Single; const N_:Cardinal ) :Single;
var
   I :Cardinal;
   P0, P1, P2 :Single;
begin
     if N_ = 0 then Result := 1
     else
     begin
          P1 := 1 ;
          P2 := X_;
          for I := 2 to N_ do
          begin
               P0 := P1;  P1 := P2;

               P2 := ( ( 2 * I - 1 ) * X_ * P1 - ( I - 1 ) * P0 ) / I;
          end;

          Result := P2;
     end;
end;

function Legendre( const X_:Double; const N_:Cardinal ) :Double;
var
   I :Cardinal;
   P0, P1, P2 :Double;
begin
     if N_ = 0 then Result := 1
     else
     begin
          P1 := 1 ;
          P2 := X_;
          for I := 2 to N_ do
          begin
               P0 := P1;  P1 := P2;

               P2 := ( ( 2 * I - 1 ) * X_ * P1 - ( I - 1 ) * P0 ) / I;
          end;

          Result := P2;
     end;
end;

//------------------------------------------------------------------------------

function Chebyshev1( const X_:Single; const N_:Cardinal ) :Single;
var
   I :Cardinal;
   T0, T1, T2 :Single;
begin
     if N_ = 0 then Result := 1
     else
     begin
          T1 := 1 ;
          T2 := X_;
          for I := 2 to N_ do
          begin
               T0 := T1;  T1 := T2;

               T2 := 2 * X_ * T1 - T0;
          end;

          Result := T2;
     end;
end;

function Chebyshev1( const X_:Double; const N_:Cardinal ) :Double;
var
   I :Cardinal;
   T0, T1, T2 :Double;
begin
     if N_ = 0 then Result := 1
     else
     begin
          T1 := 1 ;
          T2 := X_;
          for I := 2 to N_ do
          begin
               T0 := T1;  T1 := T2;

               T2 := 2 * X_ * T1 - T0;
          end;

          Result := T2;
     end;
end;

//------------------------------------------------------------------------------

function SumLegendre( const X_:Single; const Ws_:array of Single ) :Single;
var
   H, I :Integer;
   P0, P1, P2 :Single;
begin
     Result := Ws_[ 0 ];

     H := High( Ws_ );

     if H > 0 then
     begin
          P1 := 1 ;
          P2 := X_;

          Result := Result + Ws_[ 1 ] * P2;

          for I := 2 to H do
          begin
               P0 := P1;  P1 := P2;

               P2 := ( ( 2 * I - 1 ) * X_ * P1 - ( I - 1 ) * P0 ) / I;

               Result := Result + Ws_[ I ] * P2;
          end;
     end;
end;

function SumLegendre( const X_:Double; const Ws_:array of Double ) :Double;
var
   H, I :Integer;
   P0, P1, P2 :Double;
begin
     Result := Ws_[ 0 ];

     H := High( Ws_ );

     if H > 0 then
     begin
          P1 := 1 ;
          P2 := X_;

          Result := Result + Ws_[ 1 ] * P2;

          for I := 2 to H do
          begin
               P0 := P1;  P1 := P2;

               P2 := ( ( 2 * I - 1 ) * X_ * P1 - ( I - 1 ) * P0 ) / I;

               Result := Result + Ws_[ I ] * P2;
          end;
     end;
end;

//------------------------------------------------------------------------------

function SumChebyshev1( const X_:Single; const Ws_:array of Single ) :Single;
var
   H, I :Integer;
   P0, P1, P2 :Single;
begin
     Result := Ws_[ 0 ];

     H := High( Ws_ );

     if H > 0 then
     begin
          P1 := 1 ;
          P2 := X_;

          Result := Result + Ws_[ 1 ] * P2;

          for I := 2 to H do
          begin
               P0 := P1;  P1 := P2;

               P2 := 2 * X_ * P1 - P0;

               Result := Result + Ws_[ I ] * P2;
          end;
     end;
end;

function SumChebyshev1( const X_:Double; const Ws_:array of Double ) :Double;
var
   H, I :Integer;
   P0, P1, P2 :Double;
begin
     Result := Ws_[ 0 ];

     H := High( Ws_ );

     if H > 0 then
     begin
          P1 := 1 ;
          P2 := X_;

          Result := Result + Ws_[ 1 ] * P2;

          for I := 2 to H do
          begin
               P0 := P1;  P1 := P2;

               P2 := 2 * X_ * P1 - P0;

               Result := Result + Ws_[ I ] * P2;
          end;
     end;
end;

//------------------------------------------------------------------------------

function Poly( const X_:Single; const Ks_:TSingle2D ) :Single;
begin
     with Ks_ do Result := _2 * X_ + _1;
end;

function Poly( const X_:Double; const Ks_:TDouble2D ) :Double;
begin
     with Ks_ do Result := _2 * X_ + _1;
end;

//------------------------------------------------------------------------------

function Poly( const X_:Single; const Ks_:TSingle3D ) :Single;
begin
     with Ks_ do Result := ( _3 * X_ + _2 ) * X_ + _1;
end;

function Poly( const X_:Double; const Ks_:TDouble3D ) :Double;
begin
     with Ks_ do Result := ( _3 * X_ + _2 ) * X_ + _1;
end;

//------------------------------------------------------------------------------

function Poly( const X_:Single; const Ks_:TSingle4D ) :Single;
begin
     with Ks_ do Result := ( ( _4 * X_ + _3 ) * X_ + _2 ) * X_ + _1;
end;

function Poly( const X_:Double; const Ks_:TDouble4D ) :Double;
begin
     with Ks_ do Result := ( ( _4 * X_ + _3 ) * X_ + _2 ) * X_ + _1;
end;

//------------------------------------------------------------------------------

function Poly( const X_:Single; const Ks_:TSingle5D ) :Single;
begin
     with Ks_ do Result := ( ( ( _5 * X_ + _4 ) * X_ + _3 ) * X_ + _2 ) * X_ + _1;
end;

function Poly( const X_:Double; const Ks_:TDouble5D ) :Double;
begin
     with Ks_ do Result := ( ( ( _5 * X_ + _4 ) * X_ + _3 ) * X_ + _2 ) * X_ + _1;
end;

//------------------------------------------------------------------------------

function Poly( const X_:Single; const Ks_:TSingleND ) :Single;
var
   I :Integer;
begin
     Result := Ks_[ Ks_.DimN-1 ];

     for I := Ks_.DimN-2 downto 0 do Result := Result * X_ + Ks_[ I ];
end;

function Poly( const X_:Double; const Ks_:TDoubleND ) :Double;
var
   I :Integer;
begin
     Result := Ks_[ Ks_.DimN-1 ];

     for I := Ks_.DimN-2 downto 0 do Result := Result * X_ + Ks_[ I ];
end;

//------------------------------------------------------------------------------

function FitPoly( const P_:TSingle4D ) :TSingle4D;
const
     M :TSingleM3 = ( _11:+09  ;  _21:-09/2;  _31:+01  ;
                      _12:-45/2;  _22:+18  ;  _32:-09/2;
                      _13:+27/2;  _23:-27/2;  _33:+09/2; );
var
   P, K :TSingle3D;
begin
     with P_ do
     begin
          P._1 := _2 - _1;
          P._2 := _3 - _1;
          P._3 := _4 - _1;
     end;

     K := M * P;

     with Result do
     begin
          _1 := P_._1;
          _2 := K ._1;
          _3 := K ._2;
          _4 := K ._3;
     end;
end;

function FitPoly( const P_:TDouble4D ) :TDouble4D;
const
     M :TDoubleM3 = ( _11:+09  ;  _21:-09/2;  _31:+01  ;
                      _12:-45/2;  _22:+18  ;  _32:-09/2;
                      _13:+27/2;  _23:-27/2;  _33:+09/2; );
var
   P, K :TDouble3D;
begin
     with P_ do
     begin
          P._1 := _2 - _1;
          P._2 := _3 - _1;
          P._3 := _4 - _1;
     end;

     K := M * P;

     with Result do
     begin
          _1 := P_._1;
          _2 := K ._1;
          _3 := K ._2;
          _4 := K ._3;
     end;
end;

//------------------------------------------------------------------------------

function FitPoly( const P_:TSingle5D ) :TSingle5D;
const
     M :TSingleM4 = ( _11:+016  ;  _21:-012  ;  _31:+016/3;  _41:-001  ;
                      _12:-208/3;  _22:+076  ;  _32:-112/3;  _42:+022/3;
                      _13:+096  ;  _23:-128  ;  _33:+224/3;  _43:-016  ;
                      _14:-128/3;  _24:+064  ;  _34:-128/3;  _44:+032/3; );
var
   P, K :TSingle4D;
begin
     with P_ do
     begin
          P._1 := _2 - _1;
          P._2 := _3 - _1;
          P._3 := _4 - _1;
          P._4 := _5 - _1;
     end;

     K := M * P;

     with Result do
     begin
          _1 := P_._1;
          _2 := K ._1;
          _3 := K ._2;
          _4 := K ._3;
          _5 := K ._4;
     end;
end;

function FitPoly( const P_:TDouble5D ) :TDouble5D;
const
     M :TDoubleM4 = ( _11:+016  ;  _21:-012  ;  _31:+016/3;  _41:-001  ;
                      _12:-208/3;  _22:+076  ;  _32:-112/3;  _42:+022/3;
                      _13:+096  ;  _23:-128  ;  _33:+224/3;  _43:-016  ;
                      _14:-128/3;  _24:+064  ;  _34:-128/3;  _44:+032/3; );
var
   P, K :TDouble4D;
begin
     with P_ do
     begin
          P._1 := _2 - _1;
          P._2 := _3 - _1;
          P._3 := _4 - _1;
          P._4 := _5 - _1;
     end;

     K := M * P;

     with Result do
     begin
          _1 := P_._1;
          _2 := K ._1;
          _3 := K ._2;
          _4 := K ._3;
          _5 := K ._4;
     end;
end;

//------------------------------------------------------------------------------

procedure RandPoly( out Ks_:TSingle4D );
var
   Ws :array [ 0..3 ] of Single;
   Ps :TSingle4D;
begin
     Ws[ 0 ] := 2 * Random - 1;
     Ws[ 1 ] := 2 * Random - 1;
     Ws[ 2 ] := 2 * Random - 1;
     Ws[ 3 ] := 2 * Random - 1;

     with Ps do
     begin
          _1 := SumChebyshev1( 0/3, Ws );
          _2 := SumChebyshev1( 1/3, Ws );
          _3 := SumChebyshev1( 2/3, Ws );
          _4 := SumChebyshev1( 3/3, Ws );
     end;

     Ks_ := FitPoly( Ps / 2 );
end;

procedure RandPoly( out Ks_:TDouble4D );
var
   Ws :array [ 0..3 ] of Double;
   Ps :TDouble4D;
begin
     Ws[ 0 ] := 2 * Random - 1;
     Ws[ 1 ] := 2 * Random - 1;
     Ws[ 2 ] := 2 * Random - 1;
     Ws[ 3 ] := 2 * Random - 1;

     with Ps do
     begin
          _1 := SumChebyshev1( 0/3, Ws );
          _2 := SumChebyshev1( 1/3, Ws );
          _3 := SumChebyshev1( 2/3, Ws );
          _4 := SumChebyshev1( 3/3, Ws );
     end;

     Ks_ := FitPoly( Ps / 2 );
end;

//------------------------------------------------------------------------------

procedure RandPoly( out Ks_:TSingle5D );
var
   Ws :array [ 0..4 ] of Single;
   Ps :TSingle5D;
begin
     Ws[ 0 ] := 2 * Random - 1;
     Ws[ 1 ] := 2 * Random - 1;
     Ws[ 2 ] := 2 * Random - 1;
     Ws[ 3 ] := 2 * Random - 1;
     Ws[ 4 ] := 2 * Random - 1;

     with Ps do
     begin
          _1 := SumChebyshev1( 0/4, Ws );
          _2 := SumChebyshev1( 1/4, Ws );
          _3 := SumChebyshev1( 2/4, Ws );
          _4 := SumChebyshev1( 3/4, Ws );
          _5 := SumChebyshev1( 4/4, Ws );
     end;

     Ks_ := FitPoly( Ps / Roo2(5) );
end;

procedure RandPoly( out Ks_:TDouble5D );
var
   Ws :array [ 0..4 ] of Double;
   Ps :TDouble5D;
begin
     Ws[ 0 ] := 2 * Random - 1;
     Ws[ 1 ] := 2 * Random - 1;
     Ws[ 2 ] := 2 * Random - 1;
     Ws[ 3 ] := 2 * Random - 1;
     Ws[ 4 ] := 2 * Random - 1;

     with Ps do
     begin
          _1 := SumChebyshev1( 0/4, Ws );
          _2 := SumChebyshev1( 1/4, Ws );
          _3 := SumChebyshev1( 2/4, Ws );
          _4 := SumChebyshev1( 3/4, Ws );
          _5 := SumChebyshev1( 4/4, Ws );
     end;

     Ks_ := FitPoly( Ps / Roo2(5) );
end;

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
