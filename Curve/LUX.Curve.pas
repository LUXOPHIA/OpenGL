unit LUX.Curve;

interface //#################################################################### ■

uses LUX,
     LUX.D1,
     LUX.D2, LUX.D2x2,
     LUX.D3, LUX.D3x3,
     LUX.D4, LUX.D4x4,
     LUX.D5,
     LUX.DN;

//type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function Sinc( const X_:Single ) :Single; overload;
function Sinc( const X_:Double ) :Double; overload;

function Lerp( const P0_,P1_,T0_,T1_,T_:Single ) :Single; overload;
function Lerp( const P0_,P1_,T0_,T1_,T_:Double ) :Double; overload;
function Lerp( const P0_,P1_,T0_,T1_,T_:TdSingle ) :TdSingle; overload;
function Lerp( const P0_,P1_,T0_,T1_,T_:TdDouble ) :TdDouble; overload;

function Lerp( const P0_,P1_,T_:Single ) :Single; overload;
function Lerp( const P0_,P1_,T_:Double ) :Double; overload;
function Lerp( const P0_,P1_,T_:TdSingle ) :TdSingle; overload;
function Lerp( const P0_,P1_,T_:TdDouble ) :TdDouble; overload;

function CatmullRom( const P0_,P1_,P2_,P3_,T0_,T1_,T2_,T3_,T_:Single ) :Single; overload;
function CatmullRom( const P0_,P1_,P2_,P3_,T0_,T1_,T2_,T3_,T_:Double ) :Double; overload;
function CatmullRom( const P0_,P1_,P2_,P3_,T0_,T1_,T2_,T3_,T_:TdSingle ) :TdSingle; overload;
function CatmullRom( const P0_,P1_,P2_,P3_,T0_,T1_,T2_,T3_,T_:TdDouble ) :TdDouble; overload;

function CatmullRom( const P0_,P1_,P2_,P3_,T_:Single ) :Single; overload;
function CatmullRom( const P0_,P1_,P2_,P3_,T_:Double ) :Double; overload;
function CatmullRom( const P0_,P1_,P2_,P3_,T_:TdSingle ) :TdSingle; overload;
function CatmullRom( const P0_,P1_,P2_,P3_,T_:TdDouble ) :TdDouble; overload;
function CatmullRom( const P0_,P1_,P2_,P3_:Single; const T_:TdSingle ) :TdSingle; overload;
function CatmullRom( const P0_,P1_,P2_,P3_:Double; const T_:TdDouble ) :TdDouble; overload;

function Delta( const X_:Single ) :Single; overload;
function Delta( const X_:Double ) :Double; overload;

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

function Sinc( const X_:Single ) :Single;
begin
     if Abs( X_ ) < SINGLE_EPS1 then Result := 1
                                else Result := Sin( Pi * X_ ) / ( Pi * X_ );
end;

function Sinc( const X_:Double ) :Double;
begin
     if Abs( X_ ) < DOUBLE_EPS1 then Result := 1
                                else Result := Sin( Pi * X_ ) / ( Pi * X_ );
end;

//------------------------------------------------------------------------------

function Lerp( const P0_,P1_,T0_,T1_,T_:Single ) :Single;
begin
     Result := ( ( T1_ - T_ ) * P0_ + ( T_ - T0_ ) * P1_ ) / ( T1_ - T0_ );
end;

function Lerp( const P0_,P1_,T0_,T1_,T_:Double ) :Double;
begin
     Result := ( ( T1_ - T_ ) * P0_ + ( T_ - T0_ ) * P1_ ) / ( T1_ - T0_ );
end;

function Lerp( const P0_,P1_,T0_,T1_,T_:TdSingle ) :TdSingle;
begin
     Result := ( ( T1_ - T_ ) * P0_ + ( T_ - T0_ ) * P1_ ) / ( T1_ - T0_ );
end;

function Lerp( const P0_,P1_,T0_,T1_,T_:TdDouble ) :TdDouble;
begin
     Result := ( ( T1_ - T_ ) * P0_ + ( T_ - T0_ ) * P1_ ) / ( T1_ - T0_ );
end;

//------------------------------------------------------------------------------

function Lerp( const P0_,P1_,T_:Single ) :Single;
begin
     Result := ( P1_ - P0_ ) * T_ + P0_;
end;

function Lerp( const P0_,P1_,T_:Double ) :Double;
begin
     Result := ( P1_ - P0_ ) * T_ + P0_;
end;

function Lerp( const P0_,P1_,T_:TdSingle ) :TdSingle;
begin
     Result := ( P1_ - P0_ ) * T_ + P0_;
end;

function Lerp( const P0_,P1_,T_:TdDouble ) :TdDouble;
begin
     Result := ( P1_ - P0_ ) * T_ + P0_;
end;

//------------------------------------------------------------------------------

function CatmullRom( const P0_,P1_,P2_,P3_,T0_,T1_,T2_,T3_,T_:Single ) :Single;
var
   A01, A12, A23, B02, B13 :Single;
begin
     A01 := Lerp( P0_, P1_, T0_, T1_, T_ );
     A12 := Lerp( P1_, P2_, T1_, T2_, T_ );
     A23 := Lerp( P2_, P3_, T2_, T3_, T_ );

     B02 := Lerp( A01, A12, T0_, T2_, T_ );
     B13 := Lerp( A12, A23, T1_, T3_, T_ );

     Result := Lerp( B02, B13, T1_, T2_, T_ );
end;

function CatmullRom( const P0_,P1_,P2_,P3_,T0_,T1_,T2_,T3_,T_:Double ) :Double;
var
   A01, A12, A23, B02, B13 :Double;
begin
     A01 := Lerp( P0_, P1_, T0_, T1_, T_ );
     A12 := Lerp( P1_, P2_, T1_, T2_, T_ );
     A23 := Lerp( P2_, P3_, T2_, T3_, T_ );

     B02 := Lerp( A01, A12, T0_, T2_, T_ );
     B13 := Lerp( A12, A23, T1_, T3_, T_ );

     Result := Lerp( B02, B13, T1_, T2_, T_ );
end;

function CatmullRom( const P0_,P1_,P2_,P3_,T0_,T1_,T2_,T3_,T_:TdSingle ) :TdSingle;
var
   A01, A12, A23, B02, B13 :TdSingle;
begin
     A01 := Lerp( P0_, P1_, T0_, T1_, T_ );
     A12 := Lerp( P1_, P2_, T1_, T2_, T_ );
     A23 := Lerp( P2_, P3_, T2_, T3_, T_ );

     B02 := Lerp( A01, A12, T0_, T2_, T_ );
     B13 := Lerp( A12, A23, T1_, T3_, T_ );

     Result := Lerp( B02, B13, T1_, T2_, T_ );
end;

function CatmullRom( const P0_,P1_,P2_,P3_,T0_,T1_,T2_,T3_,T_:TdDouble ) :TdDouble;
var
   A01, A12, A23, B02, B13 :TdDouble;
begin
     A01 := Lerp( P0_, P1_, T0_, T1_, T_ );
     A12 := Lerp( P1_, P2_, T1_, T2_, T_ );
     A23 := Lerp( P2_, P3_, T2_, T3_, T_ );

     B02 := Lerp( A01, A12, T0_, T2_, T_ );
     B13 := Lerp( A12, A23, T1_, T3_, T_ );

     Result := Lerp( B02, B13, T1_, T2_, T_ );
end;

//------------------------------------------------------------------------------

function CatmullRom( const P0_,P1_,P2_,P3_,T_:Single ) :Single;
begin
     Result := ( ( ( -0.5 * P0_ + 1.5 * P1_ - 1.5 * P2_ + 0.5 * P3_ ) * T_
                   +        P0_ - 2.5 * P1_ + 2.0 * P2_ - 0.5 * P3_ ) * T_
                   -  0.5 * P0_             + 0.5 * P2_             ) * T_
                                +       P1_;
end;

function CatmullRom( const P0_,P1_,P2_,P3_,T_:Double ) :Double;
begin
     Result := ( ( ( -0.5 * P0_ + 1.5 * P1_ - 1.5 * P2_ + 0.5 * P3_ ) * T_
                   +        P0_ - 2.5 * P1_ + 2.0 * P2_ - 0.5 * P3_ ) * T_
                   -  0.5 * P0_             + 0.5 * P2_             ) * T_
                                +       P1_;
end;

function CatmullRom( const P0_,P1_,P2_,P3_,T_:TdSingle ) :TdSingle;
begin
     Result := ( ( ( -0.5 * P0_ + 1.5 * P1_ - 1.5 * P2_ + 0.5 * P3_ ) * T_
                   +        P0_ - 2.5 * P1_ + 2.0 * P2_ - 0.5 * P3_ ) * T_
                   -  0.5 * P0_             + 0.5 * P2_             ) * T_
                                +       P1_;
end;

function CatmullRom( const P0_,P1_,P2_,P3_,T_:TdDouble ) :TdDouble;
begin
     Result := ( ( ( -0.5 * P0_ + 1.5 * P1_ - 1.5 * P2_ + 0.5 * P3_ ) * T_
                   +        P0_ - 2.5 * P1_ + 2.0 * P2_ - 0.5 * P3_ ) * T_
                   -  0.5 * P0_             + 0.5 * P2_             ) * T_
                                +       P1_;
end;

function CatmullRom( const P0_,P1_,P2_,P3_:Single; const T_:TdSingle ) :TdSingle;
begin
     Result.o := CatmullRom( P0_, P1_, P2_, P3_, T_.o );

     Result.d := ( ( ( -1.5 * P0_ + 4.5 * P1_ - 4.5 * P2_ + 1.5 * P3_ ) * T_.o
                     +  2.0 * P0_ - 5.0 * P1_ + 4.0 * P2_ -       P3_ ) * T_.o
                     -  0.5 * P0_             + 0.5 * P2_             ) * T_.d;
end;

function CatmullRom( const P0_,P1_,P2_,P3_:Double; const T_:TdDouble ) :TdDouble;
begin
     Result.o := CatmullRom( P0_, P1_, P2_, P3_, T_.o );

     Result.d := ( ( ( -1.5 * P0_ + 4.5 * P1_ - 4.5 * P2_ + 1.5 * P3_ ) * T_.o
                     +  2.0 * P0_ - 5.0 * P1_ + 4.0 * P2_ -       P3_ ) * T_.o
                     -  0.5 * P0_             + 0.5 * P2_             ) * T_.d;
end;

//------------------------------------------------------------------------------

function Delta( const X_:Single ) :Single;
begin
     if Abs( X_ ) < SINGLE_EPS1 then Result := 1
                                else Result := 0;
end;

function Delta( const X_:Double ) :Double;
begin
     if Abs( X_ ) < DOUBLE_EPS1 then Result := 1
                                else Result := 0;
end;

//------------------------------------------------------------------------------

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
     M :TSingleM3 = ( _11:+09  ;  _12:-09/2;  _13:+01  ;
                      _21:-45/2;  _22:+18  ;  _23:-09/2;
                      _31:+27/2;  _32:-27/2;  _33:+09/2; );
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
     M :TDoubleM3 = ( _11:+09  ;  _12:-09/2;  _13:+01  ;
                      _21:-45/2;  _22:+18  ;  _23:-09/2;
                      _31:+27/2;  _32:-27/2;  _33:+09/2; );
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
     M :TSingleM4 = ( _11:+016  ;  _12:-012  ;  _13:+016/3;  _14:-001  ;
                      _21:-208/3;  _22:+076  ;  _23:-112/3;  _24:+022/3;
                      _31:+096  ;  _32:-128  ;  _33:+224/3;  _34:-016  ;
                      _41:-128/3;  _42:+064  ;  _43:-128/3;  _44:+032/3; );
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
     M :TDoubleM4 = ( _11:+016  ;  _12:-012  ;  _13:+016/3;  _14:-001  ;
                      _21:-208/3;  _22:+076  ;  _23:-112/3;  _24:+022/3;
                      _31:+096  ;  _32:-128  ;  _33:+224/3;  _34:-016  ;
                      _41:-128/3;  _42:+064  ;  _43:-128/3;  _44:+032/3; );
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
