unit LUX.D3x3;

interface //#################################################################### ■

uses System.Math.Vectors,
     LUX,
     LUX.D1,
     LUX.D2, LUX.D2x2,
     LUX.D3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleM3

     TSingleM3 = record
     private
       ///// A C C E S S O R
       function GetD2( const Y_,X_:Integer ) :Single;
       procedure SetD2( const Y_,X_:Integer; const D2_:Single );
       function GetAxisX :TSingle2D;
       procedure SetAxisX( const AxisX_:TSingle2D );
       function GetAxisY :TSingle2D;
       procedure SetAxisY( const AxisY_:TSingle2D );
       function GetAxisP :TSingle2D;
       procedure SetAxisP( const AxisP_:TSingle2D );
     public
       constructor Create( const _11_,_12_,_13_,
                                 _21_,_22_,_23_,
                                 _31_,_32_,_33_:Single ); overload;
       constructor Create( const X_,Y_,P_:TSingle2D ); overload;
       ///// P R O P E R T Y
       property D2[ const Y_,X_:Integer ] :Single    read GetD2    write SetD2   ; default;
       property AxisX                     :TSingle2D read GetAxisX write SetAxisX;  // ２Ｄ同次系の座標軸
       property AxisY                     :TSingle2D read GetAxisY write SetAxisY;
       property AxisP                     :TSingle2D read GetAxisP write SetAxisP;
       ///// O P E R A T O R
       class operator Negative( const V_:TSingleM3 ) :TSingleM3;
       class operator Positive( const V_:TSingleM3 ) :TSingleM3;
       class operator Add( const A_,B_:TSingleM3 ) :TSingleM3;
       class operator Subtract( const A_,B_:TSingleM3 ) :TSingleM3;
       class operator Multiply( const A_,B_:TSingleM3 ) :TSingleM3;
       class operator Multiply( const A_:TSingleM3; const B_:Single ) :TSingleM3;
       class operator Multiply( const A_:Single; const B_:TSingleM3 ) :TSingleM3;
       class operator Multiply( const A_:TSingle3D; const B_:TSingleM3 ) :TSingle3D;
       class operator Multiply( const A_:TSingleM3; const B_:TSingle3D ) :TSingle3D;
       class operator Divide( const A_:TSingleM3; const B_:Single ) :TSingleM3;
       ///// C A S T
       class operator Implicit( const V_:Single ) :TSingleM3;
       class operator Implicit( const V_:TMatrix ) :TSingleM3;
       class operator Explicit( const V_:TSingleM3 ) :TMatrix;
       class operator Implicit( const V_:TSingleM2 ) :TSingleM3;
       class operator Explicit( const V_:TSingleM3 ) :TSingleM2;
       ///// M E T H O D
       function MultPos( const B_:TSingle2D ) :TSingle2D;
       function MultVec( const B_:TSingle2D ) :TSingle2D;
       function Transpose :TSingleM3;
       function Det :Single;
       function Adjugate :TSingleM3;
       function Inverse :TSingleM3;
       ///// C O N S T A N T
       class function Translate( const X_,Y_:Single ) :TSingleM3; overload; static;
       class function Translate( const T_:TSingle2D ) :TSingleM3; overload; static;
       class function Scale( const X_,Y_:Single ) :TSingleM3; overload; static;
       class function Scale( const S_:TSingle2D ) :TSingleM3; overload; static;
       class function Rotate( const Angle_:Single ) :TSingleM3; static;
       class function Identity :TSingleM3; static;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..3*3-1       ] of Single; );
      1:( _2D :array [ 0..3-1, 0..3-1 ] of Single; );
      2:( _11, _21, _31,
          _12, _22, _32,
          _13, _23, _33 :Single;                   );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleM3

     TDoubleM3 = record
     private
       ///// A C C E S S O R
       function GetD2( const Y_,X_:Integer ) :Double;
       procedure SetD2( const Y_,X_:Integer; const D2_:Double );
       function GetAxisX :TDouble2D;
       procedure SetAxisX( const AxisX_:TDouble2D );
       function GetAxisY :TDouble2D;
       procedure SetAxisY( const AxisY_:TDouble2D );
       function GetAxisP :TDouble2D;
       procedure SetAxisP( const AxisP_:TDouble2D );
     public
       constructor Create( const _11_,_12_,_13_,
                                 _21_,_22_,_23_,
                                 _31_,_32_,_33_:Double ); overload;
       constructor Create( const X_,Y_,P_:TDouble2D ); overload;
       ///// P R O P E R T Y
       property D2[ const Y_,X_:Integer ] :Double    read GetD2    write SetD2   ; default;
       property AxisX                     :TDouble2D read GetAxisX write SetAxisX;  // ２Ｄ同次系の座標軸
       property AxisY                     :TDouble2D read GetAxisY write SetAxisY;
       property AxisP                     :TDouble2D read GetAxisP write SetAxisP;
       ///// O P E R A T O R
       class operator Negative( const V_:TDoubleM3 ) :TDoubleM3;
       class operator Positive( const V_:TDoubleM3 ) :TDoubleM3;
       class operator Add( const A_,B_:TDoubleM3 ) :TDoubleM3;
       class operator Subtract( const A_,B_:TDoubleM3 ) :TDoubleM3;
       class operator Multiply( const A_,B_:TDoubleM3 ) :TDoubleM3;
       class operator Multiply( const A_:TDoubleM3; const B_:Double ) :TDoubleM3;
       class operator Multiply( const A_:Double; const B_:TDoubleM3 ) :TDoubleM3;
       class operator Multiply( const A_:TDouble3D; const B_:TDoubleM3 ) :TDouble3D;
       class operator Multiply( const A_:TDoubleM3; const B_:TDouble3D ) :TDouble3D;
       class operator Divide( const A_:TDoubleM3; const B_:Double ) :TDoubleM3;
       ///// C A S T
       class operator Implicit( const V_:Double ) :TDoubleM3;
       class operator Implicit( const V_:TMatrix ) :TDoubleM3;
       class operator Explicit( const V_:TDoubleM3 ) :TMatrix;
       class operator Implicit( const V_:TSingleM3 ) :TDoubleM3;
       class operator Explicit( const V_:TDoubleM3 ) :TSingleM3;
       class operator Implicit( const V_:TDoubleM2 ) :TDoubleM3;
       class operator Explicit( const V_:TDoubleM3 ) :TDoubleM2;
       ///// M E T H O D
       function MultPos( const B_:TDouble2D ) :TDouble2D;
       function MultVec( const B_:TDouble2D ) :TDouble2D;
       function Transpose :TDoubleM3;
       function Det :Double;
       function Adjugate :TDoubleM3;
       function Inverse :TDoubleM3;
       ///// C O N S T A N T
       class function Translate( const X_,Y_:Double ) :TDoubleM3; overload; static;
       class function Translate( const T_:TDouble2D ) :TDoubleM3; overload; static;
       class function Scale( const X_,Y_:Double ) :TDoubleM3; overload; static;
       class function Scale( const S_:TDouble2D ) :TDoubleM3; overload; static;
       class function Rotate( const Angle_:Double ) :TDoubleM3; static;
       class function Identity :TDoubleM3; static;
       ///// F I E L D
     case Byte of
      0:( _1D :array [ 0..3*3-1       ] of Double; );
      1:( _2D :array [ 0..3-1, 0..3-1 ] of Double; );
      2:( _11, _21, _31,
          _12, _22, _32,
          _13, _23, _33 :Double;                   );
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleM3

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TSingleM3.GetD2( const Y_,X_:Integer ) :Single;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TSingleM3.SetD2( const Y_,X_:Integer; const D2_:Single );
begin
     _2D[ X_-1, Y_-1 ] := D2_;
end;

//------------------------------------------------------------------------------

function TSingleM3.GetAxisX :TSingle2D;
begin
     with Result do
     begin
          X := _11;
          Y := _21;
     end;
end;

procedure TSingleM3.SetAxisX( const AxisX_:TSingle2D );
begin
     with AxisX_ do
     begin
          _11 := X;
          _21 := Y;
          _31 := 0;
     end;
end;

function TSingleM3.GetAxisY :TSingle2D;
begin
     with Result do
     begin
          X := _12;
          Y := _22;
     end;
end;

procedure TSingleM3.SetAxisY( const AxisY_:TSingle2D );
begin
     with AxisY_ do
     begin
          _12 := X;
          _22 := Y;
          _32 := 0;
     end;
end;

function TSingleM3.GetAxisP :TSingle2D;
begin
     with Result do
     begin
          X := _13;
          Y := _23;
     end;
end;

procedure TSingleM3.SetAxisP( const AxisP_:TSingle2D );
begin
     with AxisP_ do
     begin
          _13 := X;
          _23 := Y;
          _33 := 1;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingleM3.Create( const _11_,_12_,_13_,
                                    _21_,_22_,_23_,
                                    _31_,_32_,_33_:Single );
begin
     _11 := _11_;  _12 := _12_;  _13 := _13_;
     _21 := _21_;  _22 := _22_;  _23 := _23_;
     _31 := _31_;  _32 := _32_;  _33 := _33_;
end;

constructor TSingleM3.Create( const X_,Y_,P_:TSingle2D );
begin
     _11 := X_.X;  _12 := Y_.X;  _13 := P_.X;
     _21 := X_.Y;  _22 := Y_.Y;  _23 := P_.Y;
     _31 :=    0;  _32 :=    0;  _33 :=    1;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TSingleM3.Positive( const V_:TSingleM3 ) :TSingleM3;
begin
     with Result do
     begin
          _11 := +V_._11;  _12 := +V_._12;  _13 := +V_._13;
          _21 := +V_._21;  _22 := +V_._22;  _23 := +V_._23;
          _31 := +V_._31;  _32 := +V_._32;  _33 := +V_._33;
     end;
end;

class operator TSingleM3.Negative( const V_:TSingleM3 ) :TSingleM3;
begin
     with Result do
     begin
          _11 := -V_._11;  _12 := -V_._12;  _13 := -V_._13;
          _21 := -V_._21;  _22 := -V_._22;  _23 := -V_._23;
          _31 := -V_._31;  _32 := -V_._32;  _33 := -V_._33;
     end;
end;

class operator TSingleM3.Add( const A_,B_:TSingleM3 ) :TSingleM3;
begin
     with Result do
     begin
          _11 := A_._11 + B_._11;  _12 := A_._12 + B_._12;  _13 := A_._13 + B_._13;
          _21 := A_._21 + B_._21;  _22 := A_._22 + B_._22;  _23 := A_._23 + B_._23;
          _31 := A_._31 + B_._31;  _32 := A_._32 + B_._32;  _33 := A_._33 + B_._33;
     end;
end;

class operator TSingleM3.Subtract( const A_,B_:TSingleM3 ) :TSingleM3;
begin
     with Result do
     begin
          _11 := A_._11 - B_._11;  _12 := A_._12 - B_._12;  _13 := A_._13 - B_._13;
          _21 := A_._21 - B_._21;  _22 := A_._22 - B_._22;  _23 := A_._23 - B_._23;
          _31 := A_._31 - B_._31;  _32 := A_._32 - B_._32;  _33 := A_._33 - B_._33;
     end;
end;

class operator TSingleM3.Multiply( const A_,B_:TSingleM3 ) :TSingleM3;
begin
     {
       11 12 13    11 12 13
       21 22 23 × 21 22 23
       31 32 33    31 32 33
     }

     with Result do
     begin
          _11 := A_._11 * B_._11 + A_._12 * B_._21 + A_._13 * B_._31;
          _12 := A_._11 * B_._12 + A_._12 * B_._22 + A_._13 * B_._32;
          _13 := A_._11 * B_._13 + A_._12 * B_._23 + A_._13 * B_._33;

          _21 := A_._21 * B_._11 + A_._22 * B_._21 + A_._23 * B_._31;
          _22 := A_._21 * B_._12 + A_._22 * B_._22 + A_._23 * B_._32;
          _23 := A_._21 * B_._13 + A_._22 * B_._23 + A_._23 * B_._33;

          _31 := A_._31 * B_._11 + A_._32 * B_._21 + A_._33 * B_._31;
          _32 := A_._31 * B_._12 + A_._32 * B_._22 + A_._33 * B_._32;
          _33 := A_._31 * B_._13 + A_._32 * B_._23 + A_._33 * B_._33;
     end;
end;

class operator TSingleM3.Multiply( const A_:TSingleM3; const B_:Single ) :TSingleM3;
begin
     with Result do
     begin
          _11 := A_._11 * B_;  _12 := A_._12 * B_;  _13 := A_._13 * B_;
          _21 := A_._21 * B_;  _22 := A_._22 * B_;  _23 := A_._23 * B_;
          _31 := A_._31 * B_;  _32 := A_._32 * B_;  _33 := A_._33 * B_;
     end;
end;

class operator TSingleM3.Multiply( const A_:Single; const B_:TSingleM3 ) :TSingleM3;
begin
     with Result do
     begin
          _11 := A_ * B_._11;  _12 := A_ * B_._12;  _13 := A_ * B_._13;
          _21 := A_ * B_._21;  _22 := A_ * B_._22;  _23 := A_ * B_._23;
          _31 := A_ * B_._31;  _32 := A_ * B_._32;  _33 := A_ * B_._33;
     end;
end;

class operator TSingleM3.Multiply( const A_:TSingle3D; const B_:TSingleM3 ) :TSingle3D;
begin
     {
                11 12 13
       X Y Z × 21 22 23
                31 32 33
     }

     with Result do
     begin
          X := A_.X * B_._11 + A_.Y * B_._21 + A_.Z * B_._31;
          Y := A_.X * B_._12 + A_.Y * B_._22 + A_.Z * B_._32;
          Z := A_.X * B_._13 + A_.Y * B_._23 + A_.Z * B_._33;
     end;
end;

class operator TSingleM3.Multiply( const A_:TSingleM3; const B_:TSingle3D ) :TSingle3D;
begin
     {
       11 12 13    X
       21 22 23 × Y
       31 32 33    Z
     }

     with Result do
     begin
          X := A_._11 * B_.X + A_._12 * B_.Y + A_._13 * B_.Z;
          Y := A_._21 * B_.X + A_._22 * B_.Y + A_._23 * B_.Z;
          Z := A_._31 * B_.X + A_._32 * B_.Y + A_._33 * B_.Z;
     end;
end;

class operator TSingleM3.Divide( const A_:TSingleM3; const B_:Single ) :TSingleM3;
begin
     with Result do
     begin
          _11 := A_._11 / B_;  _12 := A_._12 / B_;  _13 := A_._13 / B_;
          _21 := A_._21 / B_;  _22 := A_._22 / B_;  _23 := A_._23 / B_;
          _31 := A_._31 / B_;  _32 := A_._32 / B_;  _33 := A_._33 / B_;
     end;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TSingleM3.Implicit( const V_:Single ) :TSingleM3;
begin
     with Result do
     begin
          _11 := V_;  _12 := 0 ;  _13 := 0 ;
          _21 := 0 ;  _22 := V_;  _23 := 0 ;
          _31 := 0 ;  _32 := 0 ;  _33 := V_;
     end;
end;

class operator TSingleM3.Implicit( const V_:TMatrix ) :TSingleM3;
begin
     with Result do
     begin
          _11 := V_.m11;  _12 := V_.m21;  _13 := V_.m31;
          _21 := V_.m12;  _22 := V_.m22;  _23 := V_.m32;
          _31 := V_.m13;  _32 := V_.m23;  _33 := V_.m33;
     end;
end;

class operator TSingleM3.Explicit( const V_:TSingleM3 ) :TMatrix;
begin
     with Result do
     begin
          m11 := V_._11;  m12 := V_._21;  m13 := V_._31;
          m21 := V_._12;  m22 := V_._22;  m23 := V_._32;
          m31 := V_._13;  m32 := V_._23;  m33 := V_._33;
     end;
end;

class operator TSingleM3.Implicit( const V_:TSingleM2 ) :TSingleM3;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := 0;
          _21 := V_._21;  _22 := V_._22;  _23 := 0;
          _31 :=      0;  _32 :=      0;  _33 := 1;
     end;
end;

class operator TSingleM3.Explicit( const V_:TSingleM3 ) :TSingleM2;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;
          _21 := V_._21;  _22 := V_._22;
     end;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TSingleM3.MultPos( const B_:TSingle2D ) :TSingle2D;
begin
     Result.X := _11 * B_.X + _12 * B_.Y + _13;
     Result.Y := _21 * B_.X + _22 * B_.Y + _23;
end;

function TSingleM3.MultVec( const B_:TSingle2D ) :TSingle2D;
begin
     Result.X := _11 * B_.X + _12 * B_.Y;
     Result.Y := _21 * B_.X + _22 * B_.Y;
end;

//------------------------------------------------------------------------------

function TSingleM3.Transpose :TSingleM3;
begin
     Result._11 := _11;  Result._12 := _21;  Result._13 := _31;
     Result._21 := _12;  Result._22 := _22;  Result._23 := _32;
     Result._31 := _13;  Result._32 := _23;  Result._33 := _33;
end;

function TSingleM3.Det :Single;
begin
     Result:= _11 * ( _22 * _33 - _23 * _32 )
            + _12 * ( _23 * _31 - _21 * _33 )
            + _13 * ( _21 * _32 - _22 * _31 );
end;

function TSingleM3.Adjugate :TSingleM3;
begin
     Result._11 := +TSingleM2.Create( {11} {12} {13}
                                      {21} _22, _23,
                                      {31} _32, _33  ).Det;

     Result._21 := -TSingleM2.Create( {11} {12} {13}
                                      _21, {22} _23,
                                      _31, {32} _33  ).Det;

     Result._31 := +TSingleM2.Create( {11} {12} {13}
                                      _21, _22, {23}
                                      _31, _32  {33} ).Det;

     Result._12 := -TSingleM2.Create( {11} _12, _13,
                                      {21} {22} {23}
                                      {31} _32, _33  ).Det;

     Result._22 := +TSingleM2.Create( _11, {12} _13,
                                      {21} {22} {23}
                                      _31, {32} _33  ).Det;

     Result._32 := -TSingleM2.Create( _11, _12, {13}
                                      {21} {22} {23}
                                      _31, _32  {33} ).Det;

     Result._13 := +TSingleM2.Create( {11} _12, _13,
                                      {21} _22, _23
                                      {31} {32} {33} ).Det;

     Result._23 := -TSingleM2.Create( _11, {12} _13,
                                      _21, {22} _23
                                      {31} {32} {33} ).Det;

     Result._33 := +TSingleM2.Create( _11, _12, {13}
                                      _21, _22  {23}
                                      {31} {32} {33} ).Det;
end;

function TSingleM3.Inverse :TSingleM3;
var
   A :TSingleM3;
begin
     A := Adjugate;

     Result := A / ( _11 * A._11
                   + _12 * A._21
                   + _13 * A._31 );
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TSingleM3.Translate( const X_,Y_:Single ) :TSingleM3;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;  _13 := X_;
          _21 := 0;  _22 := 1;  _23 := Y_;
          _31 := 0;  _32 := 0;  _33 := 1;
     end;
end;

class function TSingleM3.Translate( const T_:TSingle2D ) :TSingleM3;
begin
     with T_ do Result := Translate( X, Y );
end;

//------------------------------------------------------------------------------

class function TSingleM3.Scale( const X_,Y_:Single ) :TSingleM3;
begin
     with Result do
     begin
          _11 := X_;  _12 := 0 ;  _13 := 0;
          _21 := 0 ;  _22 := Y_;  _23 := 0;
          _31 := 0 ;  _32 := 0 ;  _33 := 1;
     end;
end;

class function TSingleM3.Scale( const S_:TSingle2D ) :TSingleM3;
begin
     with S_ do Result := Scale( X, Y );
end;

//------------------------------------------------------------------------------

class function TSingleM3.Rotate( const Angle_:Single ) :TSingleM3;
var
   S, C :Single;
begin
     SinCos( Angle_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 := -S;  _13 := 0;
          _21 := +S;  _22 :=  C;  _23 := 0;
          _31 :=  0;  _32 :=  0;  _33 := 1;
     end;
end;

//------------------------------------------------------------------------------

class function TSingleM3.Identity :TSingleM3;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;  _13 := 0;
          _21 := 0;  _22 := 1;  _23 := 0;
          _31 := 0;  _32 := 0;  _33 := 1;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleM3

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TDoubleM3.GetD2( const Y_,X_:Integer ) :Double;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TDoubleM3.SetD2( const Y_,X_:Integer; const D2_:Double );
begin
     _2D[ X_-1, Y_-1 ] := D2_;
end;

//------------------------------------------------------------------------------

function TDoubleM3.GetAxisX :TDouble2D;
begin
     with Result do
     begin
          X := _11;
          Y := _21;
     end;
end;

procedure TDoubleM3.SetAxisX( const AxisX_:TDouble2D );
begin
     with AxisX_ do
     begin
          _11 := X;
          _21 := Y;
          _31 := 0;
     end;
end;

function TDoubleM3.GetAxisY :TDouble2D;
begin
     with Result do
     begin
          X := _12;
          Y := _22;
     end;
end;

procedure TDoubleM3.SetAxisY( const AxisY_:TDouble2D );
begin
     with AxisY_ do
     begin
          _12 := X;
          _22 := Y;
          _32 := 0;
     end;
end;

function TDoubleM3.GetAxisP :TDouble2D;
begin
     with Result do
     begin
          X := _13;
          Y := _23;
     end;
end;

procedure TDoubleM3.SetAxisP( const AxisP_:TDouble2D );
begin
     with AxisP_ do
     begin
          _13 := X;
          _23 := Y;
          _33 := 1;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDoubleM3.Create( const _11_,_12_,_13_,
                                    _21_,_22_,_23_,
                                    _31_,_32_,_33_:Double );
begin
     _11 := _11_;  _12 := _12_;  _13 := _13_;
     _21 := _21_;  _22 := _22_;  _23 := _23_;
     _31 := _31_;  _32 := _32_;  _33 := _33_;
end;

constructor TDoubleM3.Create( const X_,Y_,P_:TDouble2D );
begin
     _11 := X_.X;  _12 := Y_.X;  _13 := P_.X;
     _21 := X_.Y;  _22 := Y_.Y;  _23 := P_.Y;
     _31 :=    0;  _32 :=    0;  _33 :=    1;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TDoubleM3.Positive( const V_:TDoubleM3 ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := +V_._11;  _12 := +V_._12;  _13 := +V_._13;
          _21 := +V_._21;  _22 := +V_._22;  _23 := +V_._23;
          _31 := +V_._31;  _32 := +V_._32;  _33 := +V_._33;
     end;
end;

class operator TDoubleM3.Negative( const V_:TDoubleM3 ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := -V_._11;  _12 := -V_._12;  _13 := -V_._13;
          _21 := -V_._21;  _22 := -V_._22;  _23 := -V_._23;
          _31 := -V_._31;  _32 := -V_._32;  _33 := -V_._33;
     end;
end;

class operator TDoubleM3.Add( const A_,B_:TDoubleM3 ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := A_._11 + B_._11;  _12 := A_._12 + B_._12;  _13 := A_._13 + B_._13;
          _21 := A_._21 + B_._21;  _22 := A_._22 + B_._22;  _23 := A_._23 + B_._23;
          _31 := A_._31 + B_._31;  _32 := A_._32 + B_._32;  _33 := A_._33 + B_._33;
     end;
end;

class operator TDoubleM3.Subtract( const A_,B_:TDoubleM3 ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := A_._11 - B_._11;  _12 := A_._12 - B_._12;  _13 := A_._13 - B_._13;
          _21 := A_._21 - B_._21;  _22 := A_._22 - B_._22;  _23 := A_._23 - B_._23;
          _31 := A_._31 - B_._31;  _32 := A_._32 - B_._32;  _33 := A_._33 - B_._33;
     end;
end;

class operator TDoubleM3.Multiply( const A_,B_:TDoubleM3 ) :TDoubleM3;
begin
     {
       11 12 13    11 12 13
       21 22 23 × 21 22 23
       31 32 33    31 32 33
     }

     with Result do
     begin
          _11 := A_._11 * B_._11 + A_._12 * B_._21 + A_._13 * B_._31;
          _12 := A_._11 * B_._12 + A_._12 * B_._22 + A_._13 * B_._32;
          _13 := A_._11 * B_._13 + A_._12 * B_._23 + A_._13 * B_._33;

          _21 := A_._21 * B_._11 + A_._22 * B_._21 + A_._23 * B_._31;
          _22 := A_._21 * B_._12 + A_._22 * B_._22 + A_._23 * B_._32;
          _23 := A_._21 * B_._13 + A_._22 * B_._23 + A_._23 * B_._33;

          _31 := A_._31 * B_._11 + A_._32 * B_._21 + A_._33 * B_._31;
          _32 := A_._31 * B_._12 + A_._32 * B_._22 + A_._33 * B_._32;
          _33 := A_._31 * B_._13 + A_._32 * B_._23 + A_._33 * B_._33;
     end;
end;

class operator TDoubleM3.Multiply( const A_:TDoubleM3; const B_:Double ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := A_._11 * B_;  _12 := A_._12 * B_;  _13 := A_._13 * B_;
          _21 := A_._21 * B_;  _22 := A_._22 * B_;  _23 := A_._23 * B_;
          _31 := A_._31 * B_;  _32 := A_._32 * B_;  _33 := A_._33 * B_;
     end;
end;

class operator TDoubleM3.Multiply( const A_:Double; const B_:TDoubleM3 ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := A_ * B_._11;  _12 := A_ * B_._12;  _13 := A_ * B_._13;
          _21 := A_ * B_._21;  _22 := A_ * B_._22;  _23 := A_ * B_._23;
          _31 := A_ * B_._31;  _32 := A_ * B_._32;  _33 := A_ * B_._33;
     end;
end;

class operator TDoubleM3.Multiply( const A_:TDouble3D; const B_:TDoubleM3 ) :TDouble3D;
begin
     {
                11 12 13
       X Y Z × 21 22 23
                31 32 33
     }

     with Result do
     begin
          X := A_.X * B_._11 + A_.Y * B_._21 + A_.Z * B_._31;
          Y := A_.X * B_._12 + A_.Y * B_._22 + A_.Z * B_._32;
          Z := A_.X * B_._13 + A_.Y * B_._23 + A_.Z * B_._33;
     end;
end;

class operator TDoubleM3.Multiply( const A_:TDoubleM3; const B_:TDouble3D ) :TDouble3D;
begin
     {
       11 12 13    X
       21 22 23 × Y
       31 32 33    Z
     }

     with Result do
     begin
          X := A_._11 * B_.X + A_._12 * B_.Y + A_._13 * B_.Z;
          Y := A_._21 * B_.X + A_._22 * B_.Y + A_._23 * B_.Z;
          Z := A_._31 * B_.X + A_._32 * B_.Y + A_._33 * B_.Z;
     end;
end;

class operator TDoubleM3.Divide( const A_:TDoubleM3; const B_:Double ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := A_._11 / B_;  _12 := A_._12 / B_;  _13 := A_._13 / B_;
          _21 := A_._21 / B_;  _22 := A_._22 / B_;  _23 := A_._23 / B_;
          _31 := A_._31 / B_;  _32 := A_._32 / B_;  _33 := A_._33 / B_;
     end;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TDoubleM3.Implicit( const V_:Double ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := V_;  _12 := 0 ;  _13 := 0 ;
          _21 := 0 ;  _22 := V_;  _23 := 0 ;
          _31 := 0 ;  _32 := 0 ;  _33 := V_;
     end;
end;

class operator TDoubleM3.Implicit( const V_:TMatrix ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := V_.m11;  _12 := V_.m21;  _13 := V_.m31;
          _21 := V_.m12;  _22 := V_.m22;  _23 := V_.m32;
          _31 := V_.m13;  _32 := V_.m23;  _33 := V_.m33;
     end;
end;

class operator TDoubleM3.Explicit( const V_:TDoubleM3 ) :TMatrix;
begin
     with Result do
     begin
          m11 := V_._11;  m12 := V_._21;  m13 := V_._31;
          m21 := V_._12;  m22 := V_._22;  m23 := V_._32;
          m31 := V_._13;  m32 := V_._23;  m33 := V_._33;
     end;
end;

class operator TDoubleM3.Implicit( const V_:TSingleM3 ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;
     end;
end;

class operator TDoubleM3.Explicit( const V_:TDoubleM3 ) :TSingleM3;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;
     end;
end;

class operator TDoubleM3.Implicit( const V_:TDoubleM2 ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := 0;
          _21 := V_._21;  _22 := V_._22;  _23 := 0;
          _31 :=      0;  _32 :=      0;  _33 := 1;
     end;
end;

class operator TDoubleM3.Explicit( const V_:TDoubleM3 ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;
          _21 := V_._21;  _22 := V_._22;
     end;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TDoubleM3.MultPos( const B_:TDouble2D ) :TDouble2D;
begin
     Result.X := _11 * B_.X + _12 * B_.Y + _13;
     Result.Y := _21 * B_.X + _22 * B_.Y + _23;
end;

function TDoubleM3.MultVec( const B_:TDouble2D ) :TDouble2D;
begin
     Result.X := _11 * B_.X + _12 * B_.Y;
     Result.Y := _21 * B_.X + _22 * B_.Y;
end;

//------------------------------------------------------------------------------

function TDoubleM3.Transpose :TDoubleM3;
begin
     Result._11 := _11;  Result._12 := _21;  Result._13 := _31;
     Result._21 := _12;  Result._22 := _22;  Result._23 := _32;
     Result._31 := _13;  Result._32 := _23;  Result._33 := _33;
end;

function TDoubleM3.Det :Double;
begin
     Result:= _11 * ( _22 * _33 - _23 * _32 )
            + _12 * ( _23 * _31 - _21 * _33 )
            + _13 * ( _21 * _32 - _22 * _31 );
end;

function TDoubleM3.Adjugate :TDoubleM3;
begin
     Result._11 := +TDoubleM2.Create( {11} {12} {13}
                                      {21} _22, _23,
                                      {31} _32, _33  ).Det;

     Result._21 := -TDoubleM2.Create( {11} {12} {13}
                                      _21, {22} _23,
                                      _31, {32} _33  ).Det;

     Result._31 := +TDoubleM2.Create( {11} {12} {13}
                                      _21, _22, {23}
                                      _31, _32  {33} ).Det;

     Result._12 := -TDoubleM2.Create( {11} _12, _13,
                                      {21} {22} {23}
                                      {31} _32, _33  ).Det;

     Result._22 := +TDoubleM2.Create( _11, {12} _13,
                                      {21} {22} {23}
                                      _31, {32} _33  ).Det;

     Result._32 := -TDoubleM2.Create( _11, _12, {13}
                                      {21} {22} {23}
                                      _31, _32  {33} ).Det;

     Result._13 := +TDoubleM2.Create( {11} _12, _13,
                                      {21} _22, _23
                                      {31} {32} {33} ).Det;

     Result._23 := -TDoubleM2.Create( _11, {12} _13,
                                      _21, {22} _23
                                      {31} {32} {33} ).Det;

     Result._33 := +TDoubleM2.Create( _11, _12, {13}
                                      _21, _22  {23}
                                      {31} {32} {33} ).Det;
end;

function TDoubleM3.Inverse :TDoubleM3;
var
   A :TDoubleM3;
begin
     A := Adjugate;

     Result := A / ( _11 * A._11
                   + _12 * A._21
                   + _13 * A._31 );
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TDoubleM3.Translate( const X_,Y_:Double ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;  _13 := X_;
          _21 := 0;  _22 := 1;  _23 := Y_;
          _31 := 0;  _32 := 0;  _33 := 1;
     end;
end;

class function TDoubleM3.Translate( const T_:TDouble2D ) :TDoubleM3;
begin
     with T_ do Result := Translate( X, Y );
end;

//------------------------------------------------------------------------------

class function TDoubleM3.Scale( const X_,Y_:Double ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := X_;  _12 := 0 ;  _13 := 0;
          _21 := 0 ;  _22 := Y_;  _23 := 0;
          _31 := 0 ;  _32 := 0 ;  _33 := 1;
     end;
end;

class function TDoubleM3.Scale( const S_:TDouble2D ) :TDoubleM3;
begin
     with S_ do Result := Scale( X, Y );
end;

//------------------------------------------------------------------------------

class function TDoubleM3.Rotate( const Angle_:Double ) :TDoubleM3;
var
   S, C :Double;
begin
     SinCos( Angle_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 := -S;  _13 := 0;
          _21 := +S;  _22 :=  C;  _23 := 0;
          _31 :=  0;  _32 :=  0;  _33 := 1;
     end;
end;

//------------------------------------------------------------------------------

class function TDoubleM3.Identity :TDoubleM3;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;  _13 := 0;
          _21 := 0;  _22 := 1;  _23 := 0;
          _31 := 0;  _32 := 0;  _33 := 1;
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
