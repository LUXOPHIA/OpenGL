unit LUX.D4x4;

interface //#################################################################### ■

uses System.SysUtils, System.Math.Vectors,
     LUX,
     LUX.D1,
     LUX.D2, LUX.D2x2,
     LUX.D3, LUX.D3x3,
     LUX.D4;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TIntegerM4

     TIntegerM4 = record
     private
       ///// A C C E S S O R
       function Gets( const Y_,X_:Integer ) :Integer;
       procedure Sets( const Y_,X_:Integer; const M_:Integer );
     public
       ///// P R O P E R T Y
       property _s[ const Y_,X_:Integer ] :Integer read Gets write Sets; default;
     case Byte of
      0:( _1D :array [ 0..4*4-1       ] of Integer; );
      1:( _2D :array [ 0..4-1, 0..4-1 ] of Integer; );
      2:( _11, _21, _31, _41,
          _12, _22, _32, _42,
          _13, _23, _33, _43,
          _14, _24, _34, _44 :Integer;              );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleM4

     TSingleM4 = record
     public
       ///// A C C E S S O R
       function Gets( const Y_,X_:Integer ) :Single;
       procedure Sets( const Y_,X_:Integer; const M_:Single );
       function GetAxisX :TSingle3D;
       procedure SetAxisX( const AxisX_:TSingle3D );
       function GetAxisY :TSingle3D;
       procedure SetAxisY( const AxisY_:TSingle3D );
       function GetAxisZ :TSingle3D;
       procedure SetAxisZ( const AxisZ_:TSingle3D );
       function GetAxisP :TSingle3D;
       procedure SetAxisP( const AxisP_:TSingle3D );
     public
       constructor Create( const _11_,_12_,_13_,_14_,
                                 _21_,_22_,_23_,_24_,
                                 _31_,_32_,_33_,_34_,
                                 _41_,_42_,_43_,_44_ :Single ); overload;
       constructor Create( const X_,Y_,Z_,P_:TSingle3D ); overload;
       ///// P R O P E R T Y
       property _s[ const Y_,X_:Integer ] :Single    read Gets     write Sets    ; default;
       property AxisX                     :TSingle3D read GetAxisX write SetAxisX;
       property AxisY                     :TSingle3D read GetAxisY write SetAxisY;
       property AxisZ                     :TSingle3D read GetAxisZ write SetAxisZ;
       property AxisP                     :TSingle3D read GetAxisP write SetAxisP;
       ///// O P E R A T O R
       class operator Multiply( const A_,B_:TSingleM4 ) :TSingleM4;
       class operator Multiply( const A_:Single; const B_:TSingleM4 ) :TSingleM4;
       class operator Multiply( const A_:TSingleM4; const B_:Single ) :TSingleM4;
       class operator Multiply( const A_:TSingleM4; const B_:TSingleRay3D ) :TSingleRay3D;
       class operator Multiply( const A_:TSingleM4; const B_:TSingle4D ) :TSingle4D;
       class operator Multiply( const A_:TSingle4D; const B_:TSingleM4 ) :TSingle4D;
       class operator Divide( const A_:TSingleM4; const B_:Single ) :TSingleM4;
       ///// C A S T
       class operator Implicit( const V_:Single ) :TSingleM4;
       class operator Implicit( const V_:TMatrix3D ) :TSingleM4;
       class operator Explicit( const V_:TSingleM4 ) :TMatrix3D;
       class operator Implicit( const V_:TSingleM3 ) :TSingleM4;
       class operator Explicit( const V_:TSingleM4 ) :TSingleM3;
       ///// M E T H O D
       function MultPos( const B_:TSingle3D ) :TSingle3D;
       function MultVec( const B_:TSingle3D ) :TSingle3D;
       function Adjugate :TSingleM4;
       function Transpose :TSingleM4;
       function Inverse :TSingleM4;
       ///// C O N S T A N T
       class function Translate( const X_,Y_,Z_:Single ) :TSingleM4; overload; static;
       class function Translate( const T_:TSingle3D ) :TSingleM4; overload; static;
       class function Scale( const X_,Y_,Z_:Single ) :TSingleM4; overload; static;
       class function Scale( const S_:TSingle3D ) :TSingleM4; overload; static;
       class function RotateX( const T_:Single ) :TSingleM4; static;
       class function RotateY( const T_:Single ) :TSingleM4; static;
       class function RotateZ( const T_:Single ) :TSingleM4; static;
       class function Identity :TSingleM4; static;
       class function ProjOrth( const MinX_,MaxX_,MinY_,MaxY_,NeaZ_,FarZ_:Single ) :TSingleM4; static;
       class function ProjPers( const MinX_,MaxX_,MinY_,MaxY_,NeaZ_,FarZ_:Single ) :TSingleM4; static;
       class function ProjPersH( const AngH_,AspW_,NeaZ_,FarZ_:Single ) :TSingleM4; static;
       class function LookAt( const EyeP_,TarP_,UppV_:TSingle3D ) :TSingleM4; static;

     case Byte of
      0:( _1D :array [ 0..4*4-1       ] of Single; );
      1:( _2D :array [ 0..4-1, 0..4-1 ] of Single; );
      2:( _11, _21, _31, _41,
          _12, _22, _32, _42,
          _13, _23, _33, _43,
          _14, _24, _34, _44 :Single;              );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleM4

     TDoubleM4 = record
     public
       ///// A C C E S S O R
       function Gets( const Y_,X_:Integer ) :Double;
       procedure Sets( const Y_,X_:Integer; const M_:Double );
       function GetAxisX :TDouble3D;
       procedure SetAxisX( const AxisX_:TDouble3D );
       function GetAxisY :TDouble3D;
       procedure SetAxisY( const AxisY_:TDouble3D );
       function GetAxisZ :TDouble3D;
       procedure SetAxisZ( const AxisZ_:TDouble3D );
       function GetAxisP :TDouble3D;
       procedure SetAxisP( const AxisP_:TDouble3D );
     public
       constructor Create( const _11_,_12_,_13_,_14_,
                                 _21_,_22_,_23_,_24_,
                                 _31_,_32_,_33_,_34_,
                                 _41_,_42_,_43_,_44_ :Double ); overload;
       constructor Create( const X_,Y_,Z_,P_:TDouble3D ); overload;
       ///// P R O P E R T Y
       property _s[ const Y_,X_:Integer ] :Double    read Gets     write Sets    ; default;
       property AxisX                     :TDouble3D read GetAxisX write SetAxisX;
       property AxisY                     :TDouble3D read GetAxisY write SetAxisY;
       property AxisZ                     :TDouble3D read GetAxisZ write SetAxisZ;
       property AxisP                     :TDouble3D read GetAxisP write SetAxisP;
       ///// O P E R A T O R
       class operator Multiply( const A_,B_:TDoubleM4 ) :TDoubleM4;
       class operator Multiply( const A_:Double; const B_:TDoubleM4 ) :TDoubleM4;
       class operator Multiply( const A_:TDoubleM4; const B_:Double ) :TDoubleM4;
       class operator Multiply( const A_:TDoubleM4; const B_:TDoubleRay3D ) :TDoubleRay3D;
       class operator Multiply( const A_:TDoubleM4; const B_:TDouble4D ) :TDouble4D;
       class operator Multiply( const A_:TDouble4D; const B_:TDoubleM4 ) :TDouble4D;
       class operator Divide( const A_:TDoubleM4; const B_:Double ) :TDoubleM4;
       ///// C A S T
       class operator Implicit( const V_:Double ) :TDoubleM4;
       class operator Implicit( const V_:TMatrix3D ) :TDoubleM4;
       class operator Explicit( const V_:TDoubleM4 ) :TMatrix3D;
       class operator Implicit( const V_:TSingleM4 ) :TDoubleM4;
       class operator Explicit( const V_:TDoubleM4 ) :TSingleM4;
       class operator Implicit( const V_:TDoubleM3 ) :TDoubleM4;
       class operator Explicit( const V_:TDoubleM4 ) :TDoubleM3;
       ///// M E T H O D
       function MultPos( const B_:TDouble3D ) :TDouble3D;
       function MultVec( const B_:TDouble3D ) :TDouble3D;
       function Adjugate :TDoubleM4;
       function Transpose :TDoubleM4;
       function Inverse :TDoubleM4;
       ///// C O N S T A N T
       class function Translate( const X_,Y_,Z_:Double ) :TDoubleM4; overload; static;
       class function Translate( const T_:TDouble3D ) :TDoubleM4; overload; static;
       class function Scale( const X_,Y_,Z_:Double ) :TDoubleM4; overload; static;
       class function Scale( const S_:TDouble3D ) :TDoubleM4; overload; static;
       class function RotateX( const T_:Double ) :TDoubleM4; static;
       class function RotateY( const T_:Double ) :TDoubleM4; static;
       class function RotateZ( const T_:Double ) :TDoubleM4; static;
       class function Identity :TDoubleM4; static;
       class function ProjOrth( const MinX_,MaxX_,MinY_,MaxY_,NeaZ_,FarZ_:Double ) :TDoubleM4; static;
       class function ProjPers( const MinX_,MaxX_,MinY_,MaxY_,NeaZ_,FarZ_:Double ) :TDoubleM4; static;
       class function ProjPersH( const AngH_,AspW_,NeaZ_,FarZ_:Double ) :TDoubleM4; static;
       class function LookAt( const EyeP_,TarP_,UppV_:TDouble3D ) :TDoubleM4; static;

     case Byte of
      0:( _1D :array [ 0..4*4-1       ] of Double; );
      1:( _2D :array [ 0..4-1, 0..4-1 ] of Double; );
      2:( _11, _21, _31, _41,
          _12, _22, _32, _42,
          _13, _23, _33, _43,
          _14, _24, _34, _44 :Double;              );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingleM4

     TdSingleM4 = record
     public
       ///// A C C E S S O R
       function Gets( const Y_,X_:Integer ) :TdSingle;
       procedure Sets( const Y_,X_:Integer; const M_:TdSingle );
       function GetAxisX :TdSingle3D;
       procedure SetAxisX( const AxisX_:TdSingle3D );
       function GetAxisY :TdSingle3D;
       procedure SetAxisY( const AxisY_:TdSingle3D );
       function GetAxisZ :TdSingle3D;
       procedure SetAxisZ( const AxisZ_:TdSingle3D );
       function GetAxisP :TdSingle3D;
       procedure SetAxisP( const AxisP_:TdSingle3D );
     public
       constructor Create( const _11_,_12_,_13_,_14_,
                                 _21_,_22_,_23_,_24_,
                                 _31_,_32_,_33_,_34_,
                                 _41_,_42_,_43_,_44_ :TdSingle ); overload;
       constructor Create( const X_,Y_,Z_,P_:TdSingle3D ); overload;
       ///// P R O P E R T Y
       property _s[ const Y_,X_:Integer ] :TdSingle   read Gets     write Sets    ; default;
       property AxisX                     :TdSingle3D read GetAxisX write SetAxisX;
       property AxisY                     :TdSingle3D read GetAxisY write SetAxisY;
       property AxisZ                     :TdSingle3D read GetAxisZ write SetAxisZ;
       property AxisP                     :TdSingle3D read GetAxisP write SetAxisP;
       ///// O P E R A T O R
       class operator Multiply( const A_,B_:TdSingleM4 ) :TdSingleM4;
       class operator Multiply( const A_:TdSingle; const B_:TdSingleM4 ) :TdSingleM4;
       class operator Multiply( const A_:TdSingleM4; const B_:TdSingle ) :TdSingleM4;
       class operator Multiply( const A_:TdSingleM4; const B_:TdSingle4D ) :TdSingle4D;
       class operator Multiply( const A_:TdSingle4D; const B_:TdSingleM4 ) :TdSingle4D;
       class operator Divide( const A_:TdSingleM4; const B_:TdSingle ) :TdSingleM4;
       ///// C A S T
       class operator Implicit( const V_:TdSingle ) :TdSingleM4;
       class operator Implicit( const V_:TMatrix3D ) :TdSingleM4;
       class operator Explicit( const V_:TdSingleM4 ) :TMatrix3D;
       class operator Implicit( const V_:TdSingleM3 ) :TdSingleM4;
       class operator Explicit( const V_:TdSingleM4 ) :TdSingleM3;
       ///// M E T H O D
       function MultPos( const B_:TdSingle3D ) :TdSingle3D;
       function MultVec( const B_:TdSingle3D ) :TdSingle3D;
       function Adjugate :TdSingleM4;
       function Transpose :TdSingleM4;
       function Inverse :TdSingleM4;
       ///// C O N S T A N T
       class function Translate( const X_,Y_,Z_:TdSingle ) :TdSingleM4; overload; static;
       class function Translate( const T_:TdSingle3D ) :TdSingleM4; overload; static;
       class function Scale( const X_,Y_,Z_:TdSingle ) :TdSingleM4; overload; static;
       class function Scale( const S_:TdSingle3D ) :TdSingleM4; overload; static;
       class function RotateX( const T_:TdSingle ) :TdSingleM4; static;
       class function RotateY( const T_:TdSingle ) :TdSingleM4; static;
       class function RotateZ( const T_:TdSingle ) :TdSingleM4; static;
       class function Identity :TdSingleM4; static;

     case Byte of
      0:( _1D :array [ 0..4*4-1       ] of TdSingle; );
      1:( _2D :array [ 0..4-1, 0..4-1 ] of TdSingle; );
      2:( _11, _21, _31, _41,
          _12, _22, _32, _42,
          _13, _23, _33, _43,
          _14, _24, _34, _44 :TdSingle;              );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDoubleM4

     TdDoubleM4 = record
     public
       ///// A C C E S S O R
       function Gets( const Y_,X_:Integer ) :TdDouble;
       procedure Sets( const Y_,X_:Integer; const M_:TdDouble );
       function GetAxisX :TdDouble3D;
       procedure SetAxisX( const AxisX_:TdDouble3D );
       function GetAxisY :TdDouble3D;
       procedure SetAxisY( const AxisY_:TdDouble3D );
       function GetAxisZ :TdDouble3D;
       procedure SetAxisZ( const AxisZ_:TdDouble3D );
       function GetAxisP :TdDouble3D;
       procedure SetAxisP( const AxisP_:TdDouble3D );
     public
       constructor Create( const _11_,_12_,_13_,_14_,
                                 _21_,_22_,_23_,_24_,
                                 _31_,_32_,_33_,_34_,
                                 _41_,_42_,_43_,_44_ :TdDouble ); overload;
       constructor Create( const X_,Y_,Z_,P_:TdDouble3D ); overload;
       ///// P R O P E R T Y
       property _s[ const Y_,X_:Integer ] :TdDouble   read Gets     write Sets    ; default;
       property AxisX                     :TdDouble3D read GetAxisX write SetAxisX;
       property AxisY                     :TdDouble3D read GetAxisY write SetAxisY;
       property AxisZ                     :TdDouble3D read GetAxisZ write SetAxisZ;
       property AxisP                     :TdDouble3D read GetAxisP write SetAxisP;
       ///// O P E R A T O R
       class operator Multiply( const A_,B_:TdDoubleM4 ) :TdDoubleM4;
       class operator Multiply( const A_:TdDouble; const B_:TdDoubleM4 ) :TdDoubleM4;
       class operator Multiply( const A_:TdDoubleM4; const B_:TdDouble ) :TdDoubleM4;
       class operator Multiply( const A_:TdDoubleM4; const B_:TdDouble4D ) :TdDouble4D;
       class operator Multiply( const A_:TdDouble4D; const B_:TdDoubleM4 ) :TdDouble4D;
       class operator Divide( const A_:TdDoubleM4; const B_:TdDouble ) :TdDoubleM4;
       ///// C A S T
       class operator Implicit( const V_:TdDouble ) :TdDoubleM4;
       class operator Implicit( const V_:TMatrix3D ) :TdDoubleM4;
       class operator Explicit( const V_:TdDoubleM4 ) :TMatrix3D;
       class operator Implicit( const V_:TdSingleM4 ) :TdDoubleM4;
       class operator Explicit( const V_:TdDoubleM4 ) :TdSingleM4;
       class operator Implicit( const V_:TdDoubleM3 ) :TdDoubleM4;
       class operator Explicit( const V_:TdDoubleM4 ) :TdDoubleM3;
       ///// M E T H O D
       function MultPos( const B_:TdDouble3D ) :TdDouble3D;
       function MultVec( const B_:TdDouble3D ) :TdDouble3D;
       function Adjugate :TdDoubleM4;
       function Transpose :TdDoubleM4;
       function Inverse :TdDoubleM4;
       ///// C O N S T A N T
       class function Translate( const X_,Y_,Z_:TdDouble ) :TdDoubleM4; overload; static;
       class function Translate( const T_:TdDouble3D ) :TdDoubleM4; overload; static;
       class function Scale( const X_,Y_,Z_:TdDouble ) :TdDoubleM4; overload; static;
       class function Scale( const S_:TdDouble3D ) :TdDoubleM4; overload; static;
       class function RotateX( const T_:TdDouble ) :TdDoubleM4; static;
       class function RotateY( const T_:TdDouble ) :TdDoubleM4; static;
       class function RotateZ( const T_:TdDouble ) :TdDoubleM4; static;
       class function Identity :TdDoubleM4; static;

     case Byte of
      0:( _1D :array [ 0..4*4-1       ] of TdDouble; );
      1:( _2D :array [ 0..4-1, 0..4-1 ] of TdDouble; );
      2:( _11, _21, _31, _41,
          _12, _22, _32, _42,
          _13, _23, _33, _43,
          _14, _24, _34, _44 :TdDouble;              );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDualM4

     TSingleDualM4 = record
     private
       _o :TSingleM4;
       _i :TSingleM4;
       ///// A C C E S S O R
       procedure Seto( const o_:TSingleM4 );
       procedure Seti( const i_:TSingleM4 );
     public
       ///// P R O P E R T Y
       property o :TSingleM4 read _o write Seto;
       property i :TSingleM4 read _i write Seti;
       ///// O P E R A T O R
       class operator Multiply( const A_,B_:TSingleDualM4 ) :TSingleDualM4;
       class operator Multiply( const A_:Single; B_:TSingleDualM4 ) :TSingleDualM4;
       class operator Multiply( const A_:TSingleDualM4; B_:Single ) :TSingleDualM4;
       class operator Divide( const A_:TSingleDualM4; const B_:Single ) :TSingleDualM4;
       ///// C O N S T A N T
       class function Translate( const X_,Y_,Z_:Single ) :TSingleDualM4; static;
       class function Scale( const X_,Y_,Z_:Single ) :TSingleDualM4; static;
       class function RotateX( const T_:Single ) :TSingleDualM4; static;
       class function RotateY( const T_:Single ) :TSingleDualM4; static;
       class function RotateZ( const T_:Single ) :TSingleDualM4; static;
       class function Identity :TSingleDualM4; static;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Tensor( const T_:TSingle2D; const Func_:TConstFunc<TdSingle2D,TdSingle3D> ) :TSingleM4; overload;
function Tensor( const T_:TDouble2D; const Func_:TConstFunc<TdDouble2D,TdDouble3D> ) :TDoubleM4; overload;

function ArrowPose( const P0_,P1_:TSingle3D ) :TSingleM4; overload;
function ArrowPose( const P0_,P1_:TDouble3D ) :TDoubleM4; overload;

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TIntegerM4

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TIntegerM4.Gets( const Y_,X_:Integer ) :Integer;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TIntegerM4.Sets( const Y_,X_:Integer; const M_:Integer );
begin
     _2D[ X_-1, Y_-1 ] := M_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleM4

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TSingleM4.Gets( const Y_,X_:Integer ) :Single;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TSingleM4.Sets( const Y_,X_:Integer; const M_:Single );
begin
     _2D[ X_-1, Y_-1 ] := M_;
end;

//------------------------------------------------------------------------------

function TSingleM4.GetAxisX :TSingle3D;
begin
     with Result do
     begin
          X := _11;
          Y := _21;
          Z := _31;
     end
end;

procedure TSingleM4.SetAxisX( const AxisX_:TSingle3D );
begin
     with AxisX_ do
     begin
          _11 := X;
          _21 := Y;
          _31 := Z;
     end
end;

function TSingleM4.GetAxisY :TSingle3D;
begin
     with Result do
     begin
          X := _12;
          Y := _22;
          Z := _32;
     end
end;

procedure TSingleM4.SetAxisY( const AxisY_:TSingle3D );
begin
     with AxisY_ do
     begin
          _12 := X;
          _22 := Y;
          _32 := Z;
     end
end;

function TSingleM4.GetAxisZ :TSingle3D;
begin
     with Result do
     begin
          X := _13;
          Y := _23;
          Z := _33;
     end
end;

procedure TSingleM4.SetAxisZ( const AxisZ_:TSingle3D );
begin
     with AxisZ_ do
     begin
          _13 := X;
          _23 := Y;
          _33 := Z;
     end
end;

function TSingleM4.GetAxisP :TSingle3D;
begin
     with Result do
     begin
          X := _14;
          Y := _24;
          Z := _34;
     end
end;

procedure TSingleM4.SetAxisP( const AxisP_:TSingle3D );
begin
     with AxisP_ do
     begin
          _14 := X;
          _24 := Y;
          _34 := Z;
     end
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingleM4.Create( const _11_, _12_, _13_, _14_,
                                    _21_, _22_, _23_, _24_,
                                    _31_, _32_, _33_, _34_,
                                    _41_, _42_, _43_, _44_ :Single );
begin
     _11 := _11_;  _12 := _12_;  _13 := _13_;  _14 := _14_;
     _21 := _21_;  _22 := _22_;  _23 := _23_;  _24 := _24_;
     _31 := _31_;  _32 := _32_;  _33 := _33_;  _34 := _34_;
     _41 := _41_;  _42 := _42_;  _43 := _43_;  _44 := _44_;
end;

constructor TSingleM4.Create( const X_,Y_,Z_:TSingle3D; const P_:TSingle3D );
begin
     _11 := X_.X;  _12 := Y_.X;  _13 := Z_.X;  _14 := P_.X;
     _21 := X_.Y;  _22 := Y_.Y;  _23 := Z_.Y;  _24 := P_.Y;
     _31 := X_.Z;  _32 := Y_.Z;  _33 := Z_.Z;  _34 := P_.Z;
     _41 :=    0;  _42 :=    0;  _43 :=    0;  _44 :=    1;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TSingleM4.Multiply( const A_,B_:TSingleM4 ) :TSingleM4;
begin
     with Result do
     begin
          _11 := A_._11 * B_._11 + A_._12 * B_._21 + A_._13 * B_._31 + A_._14 * B_._41;
          _12 := A_._11 * B_._12 + A_._12 * B_._22 + A_._13 * B_._32 + A_._14 * B_._42;
          _13 := A_._11 * B_._13 + A_._12 * B_._23 + A_._13 * B_._33 + A_._14 * B_._43;
          _14 := A_._11 * B_._14 + A_._12 * B_._24 + A_._13 * B_._34 + A_._14 * B_._44;

          _21 := A_._21 * B_._11 + A_._22 * B_._21 + A_._23 * B_._31 + A_._24 * B_._41;
          _22 := A_._21 * B_._12 + A_._22 * B_._22 + A_._23 * B_._32 + A_._24 * B_._42;
          _23 := A_._21 * B_._13 + A_._22 * B_._23 + A_._23 * B_._33 + A_._24 * B_._43;
          _24 := A_._21 * B_._14 + A_._22 * B_._24 + A_._23 * B_._34 + A_._24 * B_._44;

          _31 := A_._31 * B_._11 + A_._32 * B_._21 + A_._33 * B_._31 + A_._34 * B_._41;
          _32 := A_._31 * B_._12 + A_._32 * B_._22 + A_._33 * B_._32 + A_._34 * B_._42;
          _33 := A_._31 * B_._13 + A_._32 * B_._23 + A_._33 * B_._33 + A_._34 * B_._43;
          _34 := A_._31 * B_._14 + A_._32 * B_._24 + A_._33 * B_._34 + A_._34 * B_._44;

          _41 := A_._41 * B_._11 + A_._42 * B_._21 + A_._43 * B_._31 + A_._44 * B_._41;
          _42 := A_._41 * B_._12 + A_._42 * B_._22 + A_._43 * B_._32 + A_._44 * B_._42;
          _43 := A_._41 * B_._13 + A_._42 * B_._23 + A_._43 * B_._33 + A_._44 * B_._43;
          _44 := A_._41 * B_._14 + A_._42 * B_._24 + A_._43 * B_._34 + A_._44 * B_._44;
     end
end;

class operator TSingleM4.Multiply( const A_:Single; const B_:TSingleM4 ) :TSingleM4;
begin
     with Result do
     begin
          _11 := A_ * B_._11;  _12 := A_ * B_._12;  _13 := A_ * B_._13;  _14 := A_ * B_._14;
          _21 := A_ * B_._21;  _22 := A_ * B_._22;  _23 := A_ * B_._23;  _24 := A_ * B_._24;
          _31 := A_ * B_._31;  _32 := A_ * B_._32;  _33 := A_ * B_._33;  _34 := A_ * B_._34;
          _41 := A_ * B_._41;  _42 := A_ * B_._42;  _43 := A_ * B_._43;  _44 := A_ * B_._44;
     end
end;

class operator TSingleM4.Multiply( const A_:TSingleM4; const B_:Single ) :TSingleM4;
begin
     with Result do
     begin
          _11 := A_._11 * B_;  _12 := A_._12 * B_;  _13 := A_._13 * B_;  _14 := A_._14 * B_;
          _21 := A_._21 * B_;  _22 := A_._22 * B_;  _23 := A_._23 * B_;  _24 := A_._24 * B_;
          _31 := A_._31 * B_;  _32 := A_._32 * B_;  _33 := A_._33 * B_;  _34 := A_._34 * B_;
          _41 := A_._41 * B_;  _42 := A_._42 * B_;  _43 := A_._43 * B_;  _44 := A_._44 * B_;
     end
end;

class operator TSingleM4.Multiply( const A_:TSingleM4; const B_:TSingleRay3D ) :TSingleRay3D;
begin
     with Result do
     begin
          Pos := A_.MultPos( B_.Pos );
          Vec := A_.MultVec( B_.Vec );
     end
end;

class operator TSingleM4.Multiply( const A_:TSingleM4; const B_:TSingle4D ) :TSingle4D;
begin
     with Result do
     begin
          _1 := A_._11 * B_._1 + A_._12 * B_._2 + A_._13 * B_._3 + A_._14 * B_._4;
          _2 := A_._21 * B_._1 + A_._22 * B_._2 + A_._23 * B_._3 + A_._24 * B_._4;
          _3 := A_._31 * B_._1 + A_._32 * B_._2 + A_._33 * B_._3 + A_._34 * B_._4;
          _4 := A_._41 * B_._1 + A_._42 * B_._2 + A_._43 * B_._3 + A_._44 * B_._4;
     end;
end;

class operator TSingleM4.Multiply( const A_:TSingle4D; const B_:TSingleM4 ) :TSingle4D;
begin
     with Result do
     begin
          _1 := A_._1 * B_._11 + A_._2 * B_._21 + A_._3 * B_._31 + A_._4 * B_._41;
          _2 := A_._1 * B_._12 + A_._2 * B_._22 + A_._3 * B_._32 + A_._4 * B_._42;
          _3 := A_._1 * B_._13 + A_._2 * B_._23 + A_._3 * B_._33 + A_._4 * B_._43;
          _4 := A_._1 * B_._14 + A_._2 * B_._24 + A_._3 * B_._34 + A_._4 * B_._44;
     end;
end;

//------------------------------------------------------------------------------

class operator TSingleM4.Divide( const A_:TSingleM4; const B_:Single ) :TSingleM4;
begin
     with A_ do
     begin
          Result._11 := _11 / B_;  Result._12 := _12 / B_;  Result._13 := _13 / B_;  Result._14 := _14 / B_;
          Result._21 := _21 / B_;  Result._22 := _22 / B_;  Result._23 := _23 / B_;  Result._24 := _24 / B_;
          Result._31 := _31 / B_;  Result._32 := _32 / B_;  Result._33 := _33 / B_;  Result._34 := _34 / B_;
          Result._41 := _41 / B_;  Result._42 := _42 / B_;  Result._43 := _43 / B_;  Result._44 := _44 / B_;
     end
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TSingleM4.Implicit( const V_:Single ) :TSingleM4;
begin
     with Result do
     begin
          _11 := V_;  _12 := 0 ;  _13 := 0 ;  _14 := 0 ;
          _21 := 0 ;  _22 := V_;  _23 := 0 ;  _24 := 0 ;
          _31 := 0 ;  _32 := 0 ;  _33 := V_;  _34 := 0 ;
          _41 := 0 ;  _42 := 0 ;  _43 := 0 ;  _44 := V_;
     end
end;

class operator TSingleM4.Implicit( const V_:TMatrix3D ) :TSingleM4;
begin
     with Result do
     begin
          _11 := V_.m11;  _12 := V_.m21;  _13 := V_.m31;  _14 := V_.m41;
          _21 := V_.m12;  _22 := V_.m22;  _23 := V_.m32;  _24 := V_.m42;
          _31 := V_.m13;  _32 := V_.m23;  _33 := V_.m33;  _34 := V_.m43;
          _41 := V_.m14;  _42 := V_.m24;  _43 := V_.m34;  _44 := V_.m44;
     end
end;

class operator TSingleM4.Explicit( const V_:TSingleM4 ) :TMatrix3D;
begin
     with Result do
     begin
          m11 := V_._11;  m12 := V_._21;  m13 := V_._31;  m14 := V_._41;
          m21 := V_._12;  m22 := V_._22;  m23 := V_._32;  m24 := V_._42;
          m31 := V_._13;  m32 := V_._23;  m33 := V_._33;  m34 := V_._43;
          m41 := V_._14;  m42 := V_._24;  m43 := V_._34;  m44 := V_._44;
     end
end;

class operator TSingleM4.Implicit( const V_:TSingleM3 ) :TSingleM4;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;  _14 := 0;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;  _24 := 0;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;  _34 := 0;
          _41 :=      0;  _42 :=      0;  _43 :=      0;  _44 := 1;
     end
end;

class operator TSingleM4.Explicit( const V_:TSingleM4 ) :TSingleM3;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;
     end
end;

////////////////////////////////////////////////////////////////////////////////

function TSingleM4.MultPos( const B_:TSingle3D ) :TSingle3D;
begin
     Result.X := _11 * B_.X + _12 * B_.Y + _13 * B_.Z + _14;
     Result.Y := _21 * B_.X + _22 * B_.Y + _23 * B_.Z + _24;
     Result.Z := _31 * B_.X + _32 * B_.Y + _33 * B_.Z + _34;
end;

function TSingleM4.MultVec( const B_:TSingle3D ) :TSingle3D;
begin
     Result.X := _11 * B_.X + _12 * B_.Y + _13 * B_.Z;
     Result.Y := _21 * B_.X + _22 * B_.Y + _23 * B_.Z;
     Result.Z := _31 * B_.X + _32 * B_.Y + _33 * B_.Z;
end;

function TSingleM4.Adjugate :TSingleM4;
begin
     Result._11 := +TSingleM3.Create( {11} {12} {13} {14}
                                      {21} _22, _23, _24,
                                      {31} _32, _33, _34,
                                      {41} _42, _43, _44  ).Det;

     Result._21 := -TSingleM3.Create( {11} {12} {13} {14}
                                      _21, {22} _23, _24,
                                      _31, {32} _33, _34,
                                      _41, {42} _43, _44  ).Det;

     Result._31 := +TSingleM3.Create( {11} {12} {13} {14}
                                      _21, _22, {23} _24,
                                      _31, _32, {33} _34,
                                      _41, _42, {43} _44  ).Det;

     Result._41 := -TSingleM3.Create( {11} {12} {13} {14}
                                      _21, _22, _23, {24}
                                      _31, _32, _33, {34}
                                      _41, _42, _43  {44} ).Det;


     Result._12 := -TSingleM3.Create( {11} _12, _13, _14,
                                      {21} {22} {23} {24}
                                      {31} _32, _33, _34,
                                      {41} _42, _43, _44  ).Det;

     Result._22 := +TSingleM3.Create( _11, {12} _13, _14,
                                      {21} {22} {23} {24}
                                      _31, {32} _33, _34,
                                      _41, {42} _43, _44  ).Det;

     Result._32 := -TSingleM3.Create( _11, _12, {13} _14,
                                      {21} {22} {23} {24}
                                      _31, _32, {33} _34,
                                      _41, _42, {43} _44  ).Det;

     Result._42 := +TSingleM3.Create( _11, _12, _13, {14}
                                      {21} {22} {23} {24}
                                      _31, _32, _33, {34}
                                      _41, _42, _43  {44} ).Det;


     Result._13 := +TSingleM3.Create( {11} _12, _13, _14,
                                      {21} _22, _23, _24,
                                      {31} {32} {33} {34}
                                      {41} _42, _43, _44  ).Det;

     Result._23 := -TSingleM3.Create( _11, {12} _13, _14,
                                      _21, {22} _23, _24,
                                      {31} {32} {33} {34}
                                      _41, {42} _43, _44  ).Det;

     Result._33 := +TSingleM3.Create( _11, _12, {13} _14,
                                      _21, _22, {23} _24,
                                      {31} {32} {33} {34}
                                      _41, _42, {43} _44  ).Det;

     Result._43 := -TSingleM3.Create( _11, _12, _13, {14}
                                      _21, _22, _23, {24}
                                      {31} {32} {33} {34}
                                      _41, _42, _43  {44} ).Det;


     Result._14 := -TSingleM3.Create( {11} _12, _13, _14,
                                      {21} _22, _23, _24,
                                      {31} _32, _33, _34
                                      {41} {42} {43} {44} ).Det;

     Result._24 := +TSingleM3.Create( _11, {12} _13, _14,
                                      _21, {22} _23, _24,
                                      _31, {32} _33, _34
                                      {41} {42} {43} {44} ).Det;

     Result._34 := -TSingleM3.Create( _11, _12, {13} _14,
                                      _21, _22, {23} _24,
                                      _31, _32, {33} _34
                                      {41} {42} {43} {44} ).Det;

     Result._44 := +TSingleM3.Create( _11, _12, _13, {14}
                                      _21, _22, _23, {24}
                                      _31, _32, _33  {34}
                                      {41} {42} {43} {44} ).Det;
end;

//------------------------------------------------------------------------------

function TSingleM4.Transpose :TSingleM4;
begin
     Result._11 := _11;  Result._12 := _21;  Result._13 := _31;  Result._14 := _41;
     Result._21 := _12;  Result._22 := _22;  Result._23 := _32;  Result._24 := _42;
     Result._31 := _13;  Result._32 := _23;  Result._33 := _33;  Result._34 := _43;
     Result._41 := _14;  Result._42 := _24;  Result._43 := _34;  Result._44 := _44;
end;

//------------------------------------------------------------------------------

function TSingleM4.Inverse :TSingleM4;
var
   A :TSingleM4;
begin
     A := Adjugate;

     Result := A / ( _11 * A._11
                   + _12 * A._21
                   + _13 * A._31
                   + _14 * A._41 )
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TSingleM4.Translate( const X_,Y_,Z_:Single ) :TSingleM4;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;  _13 := 0;  _14 := X_;
          _21 := 0;  _22 := 1;  _23 := 0;  _24 := Y_;
          _31 := 0;  _32 := 0;  _33 := 1;  _34 := Z_;
          _41 := 0;  _42 := 0;  _43 := 0;  _44 := 1;
     end
end;

class function TSingleM4.Translate( const T_:TSingle3D ) :TSingleM4;
begin
     with T_ do Result := Translate( X, Y, Z );
end;

//------------------------------------------------------------------------------

class function TSingleM4.Scale( const X_,Y_,Z_:Single ) :TSingleM4;
begin
     with Result do
     begin
          _11 := X_;  _12 := 0;   _13 := 0;   _14 := 0;
          _21 := 0;   _22 := Y_;  _23 := 0;   _24 := 0;
          _31 := 0;   _32 := 0;   _33 := Z_;  _34 := 0;
          _41 := 0;   _42 := 0;   _43 := 0;   _44 := 1;
     end
end;

class function TSingleM4.Scale( const S_:TSingle3D ) :TSingleM4;
begin
     with S_ do Result := Scale( X, Y, Z );
end;

//------------------------------------------------------------------------------

class function TSingleM4.RotateX( const T_:Single ) :TSingleM4;
var
   C, S :Single;
begin
     SinCos( T_, S, C );

     with Result do
     begin
          _11 :=  1;  _12 :=  0;  _13 :=  0;  _14 :=  0;
          _21 :=  0;  _22 :=  C;  _23 := -S;  _24 :=  0;
          _31 :=  0;  _32 := +S;  _33 :=  C;  _34 :=  0;
          _41 :=  0;  _42 :=  0;  _43 :=  0;  _44 :=  1;
     end
end;

class function TSingleM4.RotateY( const T_:Single ) :TSingleM4;
var
   C, S :Single;
begin
     SinCos( T_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 :=  0;  _13 := +S;  _14 :=  0;
          _21 :=  0;  _22 :=  1;  _23 :=  0;  _24 :=  0;
          _31 := -S;  _32 :=  0;  _33 :=  C;  _34 :=  0;
          _41 :=  0;  _42 :=  0;  _43 :=  0;  _44 :=  1;
     end
end;

class function TSingleM4.RotateZ( const T_:Single ) :TSingleM4;
var
   C, S :Single;
begin
     SinCos( T_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 := -S;  _13 :=  0;  _14 :=  0;
          _21 := +S;  _22 :=  C;  _23 :=  0;  _24 :=  0;
          _31 :=  0;  _32 :=  0;  _33 :=  1;  _34 :=  0;
          _41 :=  0;  _42 :=  0;  _43 :=  0;  _44 :=  1;
     end
end;

//------------------------------------------------------------------------------

class function TSingleM4.Identity :TSingleM4;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;  _13 := 0;  _14 := 0;
          _21 := 0;  _22 := 1;  _23 := 0;  _24 := 0;
          _31 := 0;  _32 := 0;  _33 := 1;  _34 := 0;
          _41 := 0;  _42 := 0;  _43 := 0;  _44 := 1;
     end
end;

//------------------------------------------------------------------------------

class function TSingleM4.ProjOrth( const MinX_,MaxX_,MinY_,MaxY_,NeaZ_,FarZ_:Single ) :TSingleM4;
var
   SX, SY, SZ :Single;
begin
     SX := MaxX_ - MinX_;
     SY := MaxY_ - MinY_;
     SZ := FarZ_ - NeaZ_;

     with Result do
     begin
          _11 := +2 / SX;  _12 :=  0     ;  _13 :=  0     ;  _14 := -( MaxX_ + MinX_ ) / SX;
          _21 :=  0     ;  _22 := +2 / SY;  _23 :=  0     ;  _24 := -( MaxY_ + MinY_ ) / SY;
          _31 :=  0     ;  _32 :=  0     ;  _33 := -2 / SZ;  _34 := -( FarZ_ + NeaZ_ ) / SZ;
          _41 :=  0     ;  _42 :=  0     ;  _43 :=  0     ;  _44 := +1                     ;
     end;
end;

class function TSingleM4.ProjPers( const MinX_,MaxX_,MinY_,MaxY_,NeaZ_,FarZ_:Single ) :TSingleM4;
var
   SX, SY, SZ :Single;
begin
     SX := MaxX_ - MinX_;
     SY := MaxY_ - MinY_;
     SZ := FarZ_ - NeaZ_;

     with Result do
     begin
          _11 := +2 * NeaZ_ / SX;  _12 :=  0             ;  _13 :=  +( MaxX_ + MinX_ ) / SX;  _14 :=  0                     ;
          _21 :=  0             ;  _22 := +2 * NeaZ_ / SY;  _23 :=  +( MaxY_ + MinY_ ) / SY;  _24 :=  0                     ;
          _31 :=  0             ;  _32 :=  0             ;  _33 :=  -( FarZ_ + NeaZ_ ) / SZ;  _34 := -2 * FarZ_ * NeaZ_ / SZ;
          _41 :=  0             ;  _42 :=  0             ;  _43 :=  -1                     ;  _44 :=  0                     ;
     end;
end;

//------------------------------------------------------------------------------

class function TSingleM4.ProjPersH( const AngH_,AspW_,NeaZ_,FarZ_:Single ) :TSingleM4;
var
   SX, SY :Single;
begin
     SX := NeaZ_ * Tan( AngH_ / 2 );
     SY := SX * AspW_;

     Result := TSingleM4.ProjPers( -SX, +SY, -SY, +SY, NeaZ_, FarZ_ );
end;

//------------------------------------------------------------------------------

class function TSingleM4.LookAt( const EyeP_,TarP_,UppV_:TSingle3D ) :TSingleM4;
var
   AX, AY, AZ, AP :TSingle3D;
begin
     AZ := ( EyeP_ - TarP_ ).Unitor;
     AX := CrossProduct( UppV_, AZ ).Unitor;
     AY := CrossProduct( AZ, AX );

     AP.X := -DotProduct( AX, EyeP_ );
     AP.Y := -DotProduct( AY, EyeP_ );
     AP.Z := -DotProduct( AZ, EyeP_ );

     with Result do
     begin
          _11 := AX.X;  _12 := AX.Y;  _13 := AX.Z;  _14 := AP.X;
          _21 := AY.X;  _22 := AY.Y;  _23 := AY.Z;  _24 := AP.Y;
          _31 := AZ.X;  _32 := AZ.Y;  _33 := AZ.Z;  _34 := AP.Z;
          _41 :=    0;  _42 :=    0;  _43 :=    0;  _44 :=    1;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleM4

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TDoubleM4.Gets( const Y_,X_:Integer ) :Double;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TDoubleM4.Sets( const Y_,X_:Integer; const M_:Double );
begin
     _2D[ X_-1, Y_-1 ] := M_;
end;

//------------------------------------------------------------------------------

function TDoubleM4.GetAxisX :TDouble3D;
begin
     with Result do
     begin
          X := _11;
          Y := _21;
          Z := _31;
     end
end;

procedure TDoubleM4.SetAxisX( const AxisX_:TDouble3D );
begin
     with AxisX_ do
     begin
          _11 := X;
          _21 := Y;
          _31 := Z;
     end
end;

function TDoubleM4.GetAxisY :TDouble3D;
begin
     with Result do
     begin
          X := _12;
          Y := _22;
          Z := _32;
     end
end;

procedure TDoubleM4.SetAxisY( const AxisY_:TDouble3D );
begin
     with AxisY_ do
     begin
          _12 := X;
          _22 := Y;
          _32 := Z;
     end
end;

function TDoubleM4.GetAxisZ :TDouble3D;
begin
     with Result do
     begin
          X := _13;
          Y := _23;
          Z := _33;
     end
end;

procedure TDoubleM4.SetAxisZ( const AxisZ_:TDouble3D );
begin
     with AxisZ_ do
     begin
          _13 := X;
          _23 := Y;
          _33 := Z;
     end
end;

function TDoubleM4.GetAxisP :TDouble3D;
begin
     with Result do
     begin
          X := _14;
          Y := _24;
          Z := _34;
     end
end;

procedure TDoubleM4.SetAxisP( const AxisP_:TDouble3D );
begin
     with AxisP_ do
     begin
          _14 := X;
          _24 := Y;
          _34 := Z;
     end
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDoubleM4.Create( const _11_, _12_, _13_, _14_,
                                    _21_, _22_, _23_, _24_,
                                    _31_, _32_, _33_, _34_,
                                    _41_, _42_, _43_, _44_ :Double );
begin
     _11 := _11_;  _12 := _12_;  _13 := _13_;  _14 := _14_;
     _21 := _21_;  _22 := _22_;  _23 := _23_;  _24 := _24_;
     _31 := _31_;  _32 := _32_;  _33 := _33_;  _34 := _34_;
     _41 := _41_;  _42 := _42_;  _43 := _43_;  _44 := _44_;
end;

constructor TDoubleM4.Create( const X_,Y_,Z_,P_:TDouble3D );
begin
     _11 := X_.X;  _12 := Y_.X;  _13 := Z_.X;  _14 := P_.X;
     _21 := X_.Y;  _22 := Y_.Y;  _23 := Z_.Y;  _24 := P_.Y;
     _31 := X_.Z;  _32 := Y_.Z;  _33 := Z_.Z;  _34 := P_.Z;
     _41 :=    0;  _42 :=    0;  _43 :=    0;  _44 :=    1;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TDoubleM4.Multiply( const A_,B_:TDoubleM4 ) :TDoubleM4;
begin
     with Result do
     begin
          _11 := A_._11 * B_._11 + A_._12 * B_._21 + A_._13 * B_._31 + A_._14 * B_._41;
          _12 := A_._11 * B_._12 + A_._12 * B_._22 + A_._13 * B_._32 + A_._14 * B_._42;
          _13 := A_._11 * B_._13 + A_._12 * B_._23 + A_._13 * B_._33 + A_._14 * B_._43;
          _14 := A_._11 * B_._14 + A_._12 * B_._24 + A_._13 * B_._34 + A_._14 * B_._44;

          _21 := A_._21 * B_._11 + A_._22 * B_._21 + A_._23 * B_._31 + A_._24 * B_._41;
          _22 := A_._21 * B_._12 + A_._22 * B_._22 + A_._23 * B_._32 + A_._24 * B_._42;
          _23 := A_._21 * B_._13 + A_._22 * B_._23 + A_._23 * B_._33 + A_._24 * B_._43;
          _24 := A_._21 * B_._14 + A_._22 * B_._24 + A_._23 * B_._34 + A_._24 * B_._44;

          _31 := A_._31 * B_._11 + A_._32 * B_._21 + A_._33 * B_._31 + A_._34 * B_._41;
          _32 := A_._31 * B_._12 + A_._32 * B_._22 + A_._33 * B_._32 + A_._34 * B_._42;
          _33 := A_._31 * B_._13 + A_._32 * B_._23 + A_._33 * B_._33 + A_._34 * B_._43;
          _34 := A_._31 * B_._14 + A_._32 * B_._24 + A_._33 * B_._34 + A_._34 * B_._44;

          _41 := A_._41 * B_._11 + A_._42 * B_._21 + A_._43 * B_._31 + A_._44 * B_._41;
          _42 := A_._41 * B_._12 + A_._42 * B_._22 + A_._43 * B_._32 + A_._44 * B_._42;
          _43 := A_._41 * B_._13 + A_._42 * B_._23 + A_._43 * B_._33 + A_._44 * B_._43;
          _44 := A_._41 * B_._14 + A_._42 * B_._24 + A_._43 * B_._34 + A_._44 * B_._44;
     end
end;

class operator TDoubleM4.Multiply( const A_:Double; const B_:TDoubleM4 ) :TDoubleM4;
begin
     with Result do
     begin
          _11 := A_ * B_._11;  _12 := A_ * B_._12;  _13 := A_ * B_._13;  _14 := A_ * B_._14;
          _21 := A_ * B_._21;  _22 := A_ * B_._22;  _23 := A_ * B_._23;  _24 := A_ * B_._24;
          _31 := A_ * B_._31;  _32 := A_ * B_._32;  _33 := A_ * B_._33;  _34 := A_ * B_._34;
          _41 := A_ * B_._41;  _42 := A_ * B_._42;  _43 := A_ * B_._43;  _44 := A_ * B_._44;
     end
end;

class operator TDoubleM4.Multiply( const A_:TDoubleM4; const B_:Double ) :TDoubleM4;
begin
     with Result do
     begin
          _11 := A_._11 * B_;  _12 := A_._12 * B_;  _13 := A_._13 * B_;  _14 := A_._14 * B_;
          _21 := A_._21 * B_;  _22 := A_._22 * B_;  _23 := A_._23 * B_;  _24 := A_._24 * B_;
          _31 := A_._31 * B_;  _32 := A_._32 * B_;  _33 := A_._33 * B_;  _34 := A_._34 * B_;
          _41 := A_._41 * B_;  _42 := A_._42 * B_;  _43 := A_._43 * B_;  _44 := A_._44 * B_;
     end
end;

class operator TDoubleM4.Multiply( const A_:TDoubleM4; const B_:TDoubleRay3D ) :TDoubleRay3D;
begin
     with Result do
     begin
          Pos := A_.MultPos( B_.Pos );
          Vec := A_.MultVec( B_.Vec );
     end
end;

class operator TDoubleM4.Multiply( const A_:TDoubleM4; const B_:TDouble4D ) :TDouble4D;
begin
     with Result do
     begin
          _1 := A_._11 * B_._1 + A_._12 * B_._2 + A_._13 * B_._3 + A_._14 * B_._4;
          _2 := A_._21 * B_._1 + A_._22 * B_._2 + A_._23 * B_._3 + A_._24 * B_._4;
          _3 := A_._31 * B_._1 + A_._32 * B_._2 + A_._33 * B_._3 + A_._34 * B_._4;
          _4 := A_._41 * B_._1 + A_._42 * B_._2 + A_._43 * B_._3 + A_._44 * B_._4;
     end;
end;

class operator TDoubleM4.Multiply( const A_:TDouble4D; const B_:TDoubleM4 ) :TDouble4D;
begin
     with Result do
     begin
          _1 := A_._1 * B_._11 + A_._2 * B_._21 + A_._3 * B_._31 + A_._4 * B_._41;
          _2 := A_._1 * B_._12 + A_._2 * B_._22 + A_._3 * B_._32 + A_._4 * B_._42;
          _3 := A_._1 * B_._13 + A_._2 * B_._23 + A_._3 * B_._33 + A_._4 * B_._43;
          _4 := A_._1 * B_._14 + A_._2 * B_._24 + A_._3 * B_._34 + A_._4 * B_._44;
     end;
end;

class operator TDoubleM4.Divide( const A_:TDoubleM4; const B_:Double ) :TDoubleM4;
begin
     with A_ do
     begin
          Result._11 := _11 / B_;  Result._12 := _12 / B_;  Result._13 := _13 / B_;  Result._14 := _14 / B_;
          Result._21 := _21 / B_;  Result._22 := _22 / B_;  Result._23 := _23 / B_;  Result._24 := _24 / B_;
          Result._31 := _31 / B_;  Result._32 := _32 / B_;  Result._33 := _33 / B_;  Result._34 := _34 / B_;
          Result._41 := _41 / B_;  Result._42 := _42 / B_;  Result._43 := _43 / B_;  Result._44 := _44 / B_;
     end
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TDoubleM4.Implicit( const V_:Double ) :TDoubleM4;
begin
     with Result do
     begin
          _11 := V_;  _12 := 0 ;  _13 := 0 ;  _14 := 0 ;
          _21 := 0 ;  _22 := V_;  _23 := 0 ;  _24 := 0 ;
          _31 := 0 ;  _32 := 0 ;  _33 := V_;  _34 := 0 ;
          _41 := 0 ;  _42 := 0 ;  _43 := 0 ;  _44 := V_;
     end
end;

class operator TDoubleM4.Implicit( const V_:TMatrix3D ) :TDoubleM4;
begin
     with Result do
     begin
          _11 := V_.m11;  _12 := V_.m21;  _13 := V_.m31;  _14 := V_.m41;
          _21 := V_.m12;  _22 := V_.m22;  _23 := V_.m32;  _24 := V_.m42;
          _31 := V_.m13;  _32 := V_.m23;  _33 := V_.m33;  _34 := V_.m43;
          _41 := V_.m14;  _42 := V_.m24;  _43 := V_.m34;  _44 := V_.m44;
     end
end;

class operator TDoubleM4.Explicit( const V_:TDoubleM4 ) :TMatrix3D;
begin
     with Result do
     begin
          m11 := V_._11;  m12 := V_._21;  m13 := V_._31;  m14 := V_._41;
          m21 := V_._12;  m22 := V_._22;  m23 := V_._32;  m24 := V_._42;
          m31 := V_._13;  m32 := V_._23;  m33 := V_._33;  m34 := V_._43;
          m41 := V_._14;  m42 := V_._24;  m43 := V_._34;  m44 := V_._44;
     end
end;

class operator TDoubleM4.Implicit( const V_:TSingleM4 ) :TDoubleM4;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;  _14 := V_._14;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;  _24 := V_._24;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;  _34 := V_._34;
          _41 := V_._41;  _42 := V_._42;  _43 := V_._43;  _44 := V_._44;
     end
end;

class operator TDoubleM4.Explicit( const V_:TDoubleM4 ) :TSingleM4;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;  _14 := V_._14;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;  _24 := V_._24;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;  _34 := V_._34;
          _41 := V_._41;  _42 := V_._42;  _43 := V_._43;  _44 := V_._44;
     end
end;

class operator TDoubleM4.Implicit( const V_:TDoubleM3 ) :TDoubleM4;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;  _14 := 0;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;  _24 := 0;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;  _34 := 0;
          _41 :=      0;  _42 :=      0;  _43 :=      0;  _44 := 1;
     end
end;

class operator TDoubleM4.Explicit( const V_:TDoubleM4 ) :TDoubleM3;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;
     end
end;

////////////////////////////////////////////////////////////////////////////////

function TDoubleM4.MultPos( const B_:TDouble3D ) :TDouble3D;
begin
     Result.X := _11 * B_.X + _12 * B_.Y + _13 * B_.Z + _14;
     Result.Y := _21 * B_.X + _22 * B_.Y + _23 * B_.Z + _24;
     Result.Z := _31 * B_.X + _32 * B_.Y + _33 * B_.Z + _34;
end;

function TDoubleM4.MultVec( const B_:TDouble3D ) :TDouble3D;
begin
     Result.X := _11 * B_.X + _12 * B_.Y + _13 * B_.Z;
     Result.Y := _21 * B_.X + _22 * B_.Y + _23 * B_.Z;
     Result.Z := _31 * B_.X + _32 * B_.Y + _33 * B_.Z;
end;

function TDoubleM4.Adjugate :TDoubleM4;
begin
     Result._11 := +TDoubleM3.Create( {11} {12} {13} {14}
                                      {21} _22, _23, _24,
                                      {31} _32, _33, _34,
                                      {41} _42, _43, _44  ).Det;

     Result._21 := -TDoubleM3.Create( {11} {12} {13} {14}
                                      _21, {22} _23, _24,
                                      _31, {32} _33, _34,
                                      _41, {42} _43, _44  ).Det;

     Result._31 := +TDoubleM3.Create( {11} {12} {13} {14}
                                      _21, _22, {23} _24,
                                      _31, _32, {33} _34,
                                      _41, _42, {43} _44  ).Det;

     Result._41 := -TDoubleM3.Create( {11} {12} {13} {14}
                                      _21, _22, _23, {24}
                                      _31, _32, _33, {34}
                                      _41, _42, _43  {44} ).Det;


     Result._12 := -TDoubleM3.Create( {11} _12, _13, _14,
                                      {21} {22} {23} {24}
                                      {31} _32, _33, _34,
                                      {41} _42, _43, _44  ).Det;

     Result._22 := +TDoubleM3.Create( _11, {12} _13, _14,
                                      {21} {22} {23} {24}
                                      _31, {32} _33, _34,
                                      _41, {42} _43, _44  ).Det;

     Result._32 := -TDoubleM3.Create( _11, _12, {13} _14,
                                      {21} {22} {23} {24}
                                      _31, _32, {33} _34,
                                      _41, _42, {43} _44  ).Det;

     Result._42 := +TDoubleM3.Create( _11, _12, _13, {14}
                                      {21} {22} {23} {24}
                                      _31, _32, _33, {34}
                                      _41, _42, _43  {44} ).Det;


     Result._13 := +TDoubleM3.Create( {11} _12, _13, _14,
                                      {21} _22, _23, _24,
                                      {31} {32} {33} {34}
                                      {41} _42, _43, _44  ).Det;

     Result._23 := -TDoubleM3.Create( _11, {12} _13, _14,
                                      _21, {22} _23, _24,
                                      {31} {32} {33} {34}
                                      _41, {42} _43, _44  ).Det;

     Result._33 := +TDoubleM3.Create( _11, _12, {13} _14,
                                      _21, _22, {23} _24,
                                      {31} {32} {33} {34}
                                      _41, _42, {43} _44  ).Det;

     Result._43 := -TDoubleM3.Create( _11, _12, _13, {14}
                                      _21, _22, _23, {24}
                                      {31} {32} {33} {34}
                                      _41, _42, _43  {44} ).Det;


     Result._14 := -TDoubleM3.Create( {11} _12, _13, _14,
                                      {21} _22, _23, _24,
                                      {31} _32, _33, _34
                                      {41} {42} {43} {44} ).Det;

     Result._24 := +TDoubleM3.Create( _11, {12} _13, _14,
                                      _21, {22} _23, _24,
                                      _31, {32} _33, _34
                                      {41} {42} {43} {44} ).Det;

     Result._34 := -TDoubleM3.Create( _11, _12, {13} _14,
                                      _21, _22, {23} _24,
                                      _31, _32, {33} _34
                                      {41} {42} {43} {44} ).Det;

     Result._44 := +TDoubleM3.Create( _11, _12, _13, {14}
                                      _21, _22, _23, {24}
                                      _31, _32, _33  {34}
                                      {41} {42} {43} {44} ).Det;
end;

function TDoubleM4.Transpose :TDoubleM4;
begin
     Result._11 := _11;  Result._12 := _21;  Result._13 := _31;  Result._14 := _41;
     Result._21 := _12;  Result._22 := _22;  Result._23 := _32;  Result._24 := _42;
     Result._31 := _13;  Result._32 := _23;  Result._33 := _33;  Result._34 := _43;
     Result._41 := _14;  Result._42 := _24;  Result._43 := _34;  Result._44 := _44;
end;

function TDoubleM4.Inverse :TDoubleM4;
var
   A :TDoubleM4;
begin
     A := Adjugate;

     Result := A / ( _11 * A._11
                   + _12 * A._21
                   + _13 * A._31
                   + _14 * A._41 )
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TDoubleM4.Translate( const X_,Y_,Z_:Double ) :TDoubleM4;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;  _13 := 0;  _14 := X_;
          _21 := 0;  _22 := 1;  _23 := 0;  _24 := Y_;
          _31 := 0;  _32 := 0;  _33 := 1;  _34 := Z_;
          _41 := 0;  _42 := 0;  _43 := 0;  _44 := 1;
     end
end;

class function TDoubleM4.Translate( const T_:TDouble3D ) :TDoubleM4;
begin
     with T_ do Result := Translate( X, Y, Z );
end;

//------------------------------------------------------------------------------

class function TDoubleM4.Scale( const X_,Y_,Z_:Double ) :TDoubleM4;
begin
     with Result do
     begin
          _11 := X_;  _12 := 0;   _13 := 0;   _14 := 0;
          _21 := 0;   _22 := Y_;  _23 := 0;   _24 := 0;
          _31 := 0;   _32 := 0;   _33 := Z_;  _34 := 0;
          _41 := 0;   _42 := 0;   _43 := 0;   _44 := 1;
     end
end;

class function TDoubleM4.Scale( const S_:TDouble3D ) :TDoubleM4;
begin
     with S_ do Result := Scale( X, Y, Z );
end;

//------------------------------------------------------------------------------

class function TDoubleM4.RotateX( const T_:Double ) :TDoubleM4;
var
   C, S :Double;
begin
     SinCos( T_, S, C );

     with Result do
     begin
          _11 :=  1;  _12 :=  0;  _13 :=  0;  _14 :=  0;
          _21 :=  0;  _22 :=  C;  _23 := -S;  _24 :=  0;
          _31 :=  0;  _32 := +S;  _33 :=  C;  _34 :=  0;
          _41 :=  0;  _42 :=  0;  _43 :=  0;  _44 :=  1;
     end
end;

class function TDoubleM4.RotateY( const T_:Double ) :TDoubleM4;
var
   C, S :Double;
begin
     SinCos( T_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 :=  0;  _13 := +S;  _14 :=  0;
          _21 :=  0;  _22 :=  1;  _23 :=  0;  _24 :=  0;
          _31 := -S;  _32 :=  0;  _33 :=  C;  _34 :=  0;
          _41 :=  0;  _42 :=  0;  _43 :=  0;  _44 :=  1;
     end
end;

class function TDoubleM4.RotateZ( const T_:Double ) :TDoubleM4;
var
   C, S :Double;
begin
     SinCos( T_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 := -S;  _13 :=  0;  _14 :=  0;
          _21 := +S;  _22 :=  C;  _23 :=  0;  _24 :=  0;
          _31 :=  0;  _32 :=  0;  _33 :=  1;  _34 :=  0;
          _41 :=  0;  _42 :=  0;  _43 :=  0;  _44 :=  1;
     end
end;

//------------------------------------------------------------------------------

class function TDoubleM4.Identity :TDoubleM4;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;  _13 := 0;  _14 := 0;
          _21 := 0;  _22 := 1;  _23 := 0;  _24 := 0;
          _31 := 0;  _32 := 0;  _33 := 1;  _34 := 0;
          _41 := 0;  _42 := 0;  _43 := 0;  _44 := 1;
     end
end;

//------------------------------------------------------------------------------

class function TDoubleM4.ProjOrth( const MinX_,MaxX_,MinY_,MaxY_,NeaZ_,FarZ_:Double ) :TDoubleM4;
var
   SX, SY, SZ :Double;
begin
     SX := MaxX_ - MinX_;
     SY := MaxY_ - MinY_;
     SZ := FarZ_ - NeaZ_;

     with Result do
     begin
          _11 := +2 / SX;  _12 :=  0     ;  _13 :=  0     ;  _14 := -( MaxX_ + MinX_ ) / SX;
          _21 :=  0     ;  _22 := +2 / SY;  _23 :=  0     ;  _24 := -( MaxY_ + MinY_ ) / SY;
          _31 :=  0     ;  _32 :=  0     ;  _33 := -2 / SZ;  _34 := -( FarZ_ + NeaZ_ ) / SZ;
          _41 :=  0     ;  _42 :=  0     ;  _43 :=  0     ;  _44 := +1                     ;
     end;
end;

class function TDoubleM4.ProjPers( const MinX_,MaxX_,MinY_,MaxY_,NeaZ_,FarZ_:Double ) :TDoubleM4;
var
   SX, SY, SZ :Double;
begin
     SX := MaxX_ - MinX_;
     SY := MaxY_ - MinY_;
     SZ := FarZ_ - NeaZ_;

     with Result do
     begin
          _11 := +2 * NeaZ_ / SX;  _12 :=  0             ;  _13 :=  +( MaxX_ + MinX_ ) / SX;  _14 :=  0                     ;
          _21 :=  0             ;  _22 := +2 * NeaZ_ / SY;  _23 :=  +( MaxY_ + MinY_ ) / SY;  _24 :=  0                     ;
          _31 :=  0             ;  _32 :=  0             ;  _33 :=  -( FarZ_ + NeaZ_ ) / SZ;  _34 := -2 * FarZ_ * NeaZ_ / SZ;
          _41 :=  0             ;  _42 :=  0             ;  _43 :=  -1                     ;  _44 :=  0                     ;
     end;
end;

//------------------------------------------------------------------------------

class function TDoubleM4.ProjPersH( const AngH_,AspW_,NeaZ_,FarZ_:Double ) :TDoubleM4;
var
   SX, SY :Double;
begin
     SX := NeaZ_ * Tan( AngH_ / 2 );
     SY := SX * AspW_;

     Result := TDoubleM4.ProjPers( -SX, +SY, -SY, +SY, NeaZ_, FarZ_ );
end;

//------------------------------------------------------------------------------

class function TDoubleM4.LookAt( const EyeP_,TarP_,UppV_:TDouble3D ) :TDoubleM4;
var
   AX, AY, AZ, AP :TDouble3D;
begin
     AZ := ( EyeP_ - TarP_ ).Unitor;
     AX := CrossProduct( UppV_, AZ ).Unitor;
     AY := CrossProduct( AZ, AX );

     AP.X := -DotProduct( AX, EyeP_ );
     AP.Y := -DotProduct( AY, EyeP_ );
     AP.Z := -DotProduct( AZ, EyeP_ );

     with Result do
     begin
          _11 := AX.X;  _12 := AX.Y;  _13 := AX.Z;  _14 := AP.X;
          _21 := AY.X;  _22 := AY.Y;  _23 := AY.Z;  _24 := AP.Y;
          _31 := AZ.X;  _32 := AZ.Y;  _33 := AZ.Z;  _34 := AP.Z;
          _41 :=    0;  _42 :=    0;  _43 :=    0;  _44 :=    1;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingleM4

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdSingleM4.Gets( const Y_,X_:Integer ) :TdSingle;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TdSingleM4.Sets( const Y_,X_:Integer; const M_:TdSingle );
begin
     _2D[ X_-1, Y_-1 ] := M_;
end;

//------------------------------------------------------------------------------

function TdSingleM4.GetAxisX :TdSingle3D;
begin
     with Result do
     begin
          X := _11;
          Y := _21;
          Z := _31;
     end
end;

procedure TdSingleM4.SetAxisX( const AxisX_:TdSingle3D );
begin
     with AxisX_ do
     begin
          _11 := X;
          _21 := Y;
          _31 := Z;
     end
end;

function TdSingleM4.GetAxisY :TdSingle3D;
begin
     with Result do
     begin
          X := _12;
          Y := _22;
          Z := _32;
     end
end;

procedure TdSingleM4.SetAxisY( const AxisY_:TdSingle3D );
begin
     with AxisY_ do
     begin
          _12 := X;
          _22 := Y;
          _32 := Z;
     end
end;

function TdSingleM4.GetAxisZ :TdSingle3D;
begin
     with Result do
     begin
          X := _13;
          Y := _23;
          Z := _33;
     end
end;

procedure TdSingleM4.SetAxisZ( const AxisZ_:TdSingle3D );
begin
     with AxisZ_ do
     begin
          _13 := X;
          _23 := Y;
          _33 := Z;
     end
end;

function TdSingleM4.GetAxisP :TdSingle3D;
begin
     with Result do
     begin
          X := _14;
          Y := _24;
          Z := _34;
     end
end;

procedure TdSingleM4.SetAxisP( const AxisP_:TdSingle3D );
begin
     with AxisP_ do
     begin
          _14 := X;
          _24 := Y;
          _34 := Z;
     end
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdSingleM4.Create( const _11_,_12_,_13_,_14_,
                                     _21_,_22_,_23_,_24_,
                                     _31_,_32_,_33_,_34_,
                                     _41_,_42_,_43_,_44_ :TdSingle );
begin
     _11 := _11_;  _12 := _12_;  _13 := _13_;  _14 := _14_;
     _21 := _21_;  _22 := _22_;  _23 := _23_;  _24 := _24_;
     _31 := _31_;  _32 := _32_;  _33 := _33_;  _34 := _34_;
     _41 := _41_;  _42 := _42_;  _43 := _43_;  _44 := _44_;
end;

constructor TdSingleM4.Create( const X_,Y_,Z_:TdSingle3D; const P_:TdSingle3D );
begin
     _11 := X_.X;  _12 := Y_.X;  _13 := Z_.X;  _14 := P_.X;
     _21 := X_.Y;  _22 := Y_.Y;  _23 := Z_.Y;  _24 := P_.Y;
     _31 := X_.Z;  _32 := Y_.Z;  _33 := Z_.Z;  _34 := P_.Z;
     _41 :=    0;  _42 :=    0;  _43 :=    0;  _44 :=    1;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdSingleM4.Multiply( const A_,B_:TdSingleM4 ) :TdSingleM4;
begin
     with Result do
     begin
          _11 := A_._11 * B_._11 + A_._12 * B_._21 + A_._13 * B_._31 + A_._14 * B_._41;
          _12 := A_._11 * B_._12 + A_._12 * B_._22 + A_._13 * B_._32 + A_._14 * B_._42;
          _13 := A_._11 * B_._13 + A_._12 * B_._23 + A_._13 * B_._33 + A_._14 * B_._43;
          _14 := A_._11 * B_._14 + A_._12 * B_._24 + A_._13 * B_._34 + A_._14 * B_._44;

          _21 := A_._21 * B_._11 + A_._22 * B_._21 + A_._23 * B_._31 + A_._24 * B_._41;
          _22 := A_._21 * B_._12 + A_._22 * B_._22 + A_._23 * B_._32 + A_._24 * B_._42;
          _23 := A_._21 * B_._13 + A_._22 * B_._23 + A_._23 * B_._33 + A_._24 * B_._43;
          _24 := A_._21 * B_._14 + A_._22 * B_._24 + A_._23 * B_._34 + A_._24 * B_._44;

          _31 := A_._31 * B_._11 + A_._32 * B_._21 + A_._33 * B_._31 + A_._34 * B_._41;
          _32 := A_._31 * B_._12 + A_._32 * B_._22 + A_._33 * B_._32 + A_._34 * B_._42;
          _33 := A_._31 * B_._13 + A_._32 * B_._23 + A_._33 * B_._33 + A_._34 * B_._43;
          _34 := A_._31 * B_._14 + A_._32 * B_._24 + A_._33 * B_._34 + A_._34 * B_._44;

          _41 := A_._41 * B_._11 + A_._42 * B_._21 + A_._43 * B_._31 + A_._44 * B_._41;
          _42 := A_._41 * B_._12 + A_._42 * B_._22 + A_._43 * B_._32 + A_._44 * B_._42;
          _43 := A_._41 * B_._13 + A_._42 * B_._23 + A_._43 * B_._33 + A_._44 * B_._43;
          _44 := A_._41 * B_._14 + A_._42 * B_._24 + A_._43 * B_._34 + A_._44 * B_._44;
     end
end;

class operator TdSingleM4.Multiply( const A_:TdSingle; const B_:TdSingleM4 ) :TdSingleM4;
begin
     with Result do
     begin
          _11 := A_ * B_._11;  _12 := A_ * B_._12;  _13 := A_ * B_._13;  _14 := A_ * B_._14;
          _21 := A_ * B_._21;  _22 := A_ * B_._22;  _23 := A_ * B_._23;  _24 := A_ * B_._24;
          _31 := A_ * B_._31;  _32 := A_ * B_._32;  _33 := A_ * B_._33;  _34 := A_ * B_._34;
          _41 := A_ * B_._41;  _42 := A_ * B_._42;  _43 := A_ * B_._43;  _44 := A_ * B_._44;
     end
end;

class operator TdSingleM4.Multiply( const A_:TdSingleM4; const B_:TdSingle ) :TdSingleM4;
begin
     with Result do
     begin
          _11 := A_._11 * B_;  _12 := A_._12 * B_;  _13 := A_._13 * B_;  _14 := A_._14 * B_;
          _21 := A_._21 * B_;  _22 := A_._22 * B_;  _23 := A_._23 * B_;  _24 := A_._24 * B_;
          _31 := A_._31 * B_;  _32 := A_._32 * B_;  _33 := A_._33 * B_;  _34 := A_._34 * B_;
          _41 := A_._41 * B_;  _42 := A_._42 * B_;  _43 := A_._43 * B_;  _44 := A_._44 * B_;
     end
end;

class operator TdSingleM4.Multiply( const A_:TdSingleM4; const B_:TdSingle4D ) :TdSingle4D;
begin
     with Result do
     begin
          _1 := A_._11 * B_._1 + A_._12 * B_._2 + A_._13 * B_._3 + A_._14 * B_._4;
          _2 := A_._21 * B_._1 + A_._22 * B_._2 + A_._23 * B_._3 + A_._24 * B_._4;
          _3 := A_._31 * B_._1 + A_._32 * B_._2 + A_._33 * B_._3 + A_._34 * B_._4;
          _4 := A_._41 * B_._1 + A_._42 * B_._2 + A_._43 * B_._3 + A_._44 * B_._4;
     end;
end;

class operator TdSingleM4.Multiply( const A_:TdSingle4D; const B_:TdSingleM4 ) :TdSingle4D;
begin
     with Result do
     begin
          _1 := A_._1 * B_._11 + A_._2 * B_._21 + A_._3 * B_._31 + A_._4 * B_._41;
          _2 := A_._1 * B_._12 + A_._2 * B_._22 + A_._3 * B_._32 + A_._4 * B_._42;
          _3 := A_._1 * B_._13 + A_._2 * B_._23 + A_._3 * B_._33 + A_._4 * B_._43;
          _4 := A_._1 * B_._14 + A_._2 * B_._24 + A_._3 * B_._34 + A_._4 * B_._44;
     end;
end;

class operator TdSingleM4.Divide( const A_:TdSingleM4; const B_:TdSingle ) :TdSingleM4;
begin
     with A_ do
     begin
          Result._11 := _11 / B_;  Result._12 := _12 / B_;  Result._13 := _13 / B_;  Result._14 := _14 / B_;
          Result._21 := _21 / B_;  Result._22 := _22 / B_;  Result._23 := _23 / B_;  Result._24 := _24 / B_;
          Result._31 := _31 / B_;  Result._32 := _32 / B_;  Result._33 := _33 / B_;  Result._34 := _34 / B_;
          Result._41 := _41 / B_;  Result._42 := _42 / B_;  Result._43 := _43 / B_;  Result._44 := _44 / B_;
     end
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TdSingleM4.Implicit( const V_:TdSingle ) :TdSingleM4;
begin
     with Result do
     begin
          _11 := V_;  _12 := 0 ;  _13 := 0 ;  _14 := 0 ;
          _21 := 0 ;  _22 := V_;  _23 := 0 ;  _24 := 0 ;
          _31 := 0 ;  _32 := 0 ;  _33 := V_;  _34 := 0 ;
          _41 := 0 ;  _42 := 0 ;  _43 := 0 ;  _44 := V_;
     end
end;

class operator TdSingleM4.Implicit( const V_:TMatrix3D ) :TdSingleM4;
begin
     with Result do
     begin
          _11 := V_.m11;  _12 := V_.m21;  _13 := V_.m31;  _14 := V_.m41;
          _21 := V_.m12;  _22 := V_.m22;  _23 := V_.m32;  _24 := V_.m42;
          _31 := V_.m13;  _32 := V_.m23;  _33 := V_.m33;  _34 := V_.m43;
          _41 := V_.m14;  _42 := V_.m24;  _43 := V_.m34;  _44 := V_.m44;
     end
end;

class operator TdSingleM4.Explicit( const V_:TdSingleM4 ) :TMatrix3D;
begin
     with Result do
     begin
          m11 := V_._11.o;  m12 := V_._21.o;  m13 := V_._31.o;  m14 := V_._41.o;
          m21 := V_._12.o;  m22 := V_._22.o;  m23 := V_._32.o;  m24 := V_._42.o;
          m31 := V_._13.o;  m32 := V_._23.o;  m33 := V_._33.o;  m34 := V_._43.o;
          m41 := V_._14.o;  m42 := V_._24.o;  m43 := V_._34.o;  m44 := V_._44.o;
     end
end;

class operator TdSingleM4.Implicit( const V_:TdSingleM3 ) :TdSingleM4;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;  _14 := 0;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;  _24 := 0;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;  _34 := 0;
          _41 :=      0;  _42 :=      0;  _43 :=      0;  _44 := 1;
     end
end;

class operator TdSingleM4.Explicit( const V_:TdSingleM4 ) :TdSingleM3;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;
     end
end;

////////////////////////////////////////////////////////////////////////////////

function TdSingleM4.MultPos( const B_:TdSingle3D ) :TdSingle3D;
begin
     Result.X := _11 * B_.X + _12 * B_.Y + _13 * B_.Z + _14;
     Result.Y := _21 * B_.X + _22 * B_.Y + _23 * B_.Z + _24;
     Result.Z := _31 * B_.X + _32 * B_.Y + _33 * B_.Z + _34;
end;

function TdSingleM4.MultVec( const B_:TdSingle3D ) :TdSingle3D;
begin
     Result.X := _11 * B_.X + _12 * B_.Y + _13 * B_.Z;
     Result.Y := _21 * B_.X + _22 * B_.Y + _23 * B_.Z;
     Result.Z := _31 * B_.X + _32 * B_.Y + _33 * B_.Z;
end;

function TdSingleM4.Adjugate :TdSingleM4;
begin
     Result._11 := +TdSingleM3.Create( {11} {12} {13} {14}
                                       {21} _22, _23, _24,
                                       {31} _32, _33, _34,
                                       {41} _42, _43, _44  ).Det;

     Result._21 := -TdSingleM3.Create( {11} {12} {13} {14}
                                       _21, {22} _23, _24,
                                       _31, {32} _33, _34,
                                       _41, {42} _43, _44  ).Det;

     Result._31 := +TdSingleM3.Create( {11} {12} {13} {14}
                                       _21, _22, {23} _24,
                                       _31, _32, {33} _34,
                                       _41, _42, {43} _44  ).Det;

     Result._41 := -TdSingleM3.Create( {11} {12} {13} {14}
                                       _21, _22, _23, {24}
                                       _31, _32, _33, {34}
                                       _41, _42, _43  {44} ).Det;


     Result._12 := -TdSingleM3.Create( {11} _12, _13, _14,
                                       {21} {22} {23} {24}
                                       {31} _32, _33, _34,
                                       {41} _42, _43, _44  ).Det;

     Result._22 := +TdSingleM3.Create( _11, {12} _13, _14,
                                       {21} {22} {23} {24}
                                       _31, {32} _33, _34,
                                       _41, {42} _43, _44  ).Det;

     Result._32 := -TdSingleM3.Create( _11, _12, {13} _14,
                                       {21} {22} {23} {24}
                                       _31, _32, {33} _34,
                                       _41, _42, {43} _44  ).Det;

     Result._42 := +TdSingleM3.Create( _11, _12, _13, {14}
                                       {21} {22} {23} {24}
                                       _31, _32, _33, {34}
                                       _41, _42, _43  {44} ).Det;


     Result._13 := +TdSingleM3.Create( {11} _12, _13, _14,
                                       {21} _22, _23, _24,
                                       {31} {32} {33} {34}
                                       {41} _42, _43, _44  ).Det;

     Result._23 := -TdSingleM3.Create( _11, {12} _13, _14,
                                       _21, {22} _23, _24,
                                       {31} {32} {33} {34}
                                       _41, {42} _43, _44  ).Det;

     Result._33 := +TdSingleM3.Create( _11, _12, {13} _14,
                                       _21, _22, {23} _24,
                                       {31} {32} {33} {34}
                                       _41, _42, {43} _44  ).Det;

     Result._43 := -TdSingleM3.Create( _11, _12, _13, {14}
                                       _21, _22, _23, {24}
                                       {31} {32} {33} {34}
                                       _41, _42, _43  {44} ).Det;


     Result._14 := -TdSingleM3.Create( {11} _12, _13, _14,
                                       {21} _22, _23, _24,
                                       {31} _32, _33, _34
                                       {41} {42} {43} {44} ).Det;

     Result._24 := +TdSingleM3.Create( _11, {12} _13, _14,
                                       _21, {22} _23, _24,
                                       _31, {32} _33, _34
                                       {41} {42} {43} {44} ).Det;

     Result._34 := -TdSingleM3.Create( _11, _12, {13} _14,
                                       _21, _22, {23} _24,
                                       _31, _32, {33} _34
                                       {41} {42} {43} {44} ).Det;

     Result._44 := +TdSingleM3.Create( _11, _12, _13, {14}
                                       _21, _22, _23, {24}
                                       _31, _32, _33  {34}
                                       {41} {42} {43} {44} ).Det;
end;

function TdSingleM4.Transpose :TdSingleM4;
begin
     Result._11 := _11;  Result._12 := _21;  Result._13 := _31;  Result._14 := _41;
     Result._21 := _12;  Result._22 := _22;  Result._23 := _32;  Result._24 := _42;
     Result._31 := _13;  Result._32 := _23;  Result._33 := _33;  Result._34 := _43;
     Result._41 := _14;  Result._42 := _24;  Result._43 := _34;  Result._44 := _44;
end;

function TdSingleM4.Inverse :TdSingleM4;
var
   A :TdSingleM4;
begin
     A := Adjugate;

     Result := A / ( _11 * A._11
                   + _12 * A._21
                   + _13 * A._31
                   + _14 * A._41 )
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TdSingleM4.Translate( const X_,Y_,Z_:TdSingle ) :TdSingleM4;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;  _13 := 0;  _14 := X_;
          _21 := 0;  _22 := 1;  _23 := 0;  _24 := Y_;
          _31 := 0;  _32 := 0;  _33 := 1;  _34 := Z_;
          _41 := 0;  _42 := 0;  _43 := 0;  _44 := 1;
     end
end;

class function TdSingleM4.Translate( const T_:TdSingle3D ) :TdSingleM4;
begin
     with T_ do Result := Translate( X, Y, Z );
end;

//------------------------------------------------------------------------------

class function TdSingleM4.Scale( const X_,Y_,Z_:TdSingle ) :TdSingleM4;
begin
     with Result do
     begin
          _11 := X_;  _12 := 0;   _13 := 0;   _14 := 0;
          _21 := 0;   _22 := Y_;  _23 := 0;   _24 := 0;
          _31 := 0;   _32 := 0;   _33 := Z_;  _34 := 0;
          _41 := 0;   _42 := 0;   _43 := 0;   _44 := 1;
     end
end;

class function TdSingleM4.Scale( const S_:TdSingle3D ) :TdSingleM4;
begin
     with S_ do Result := Scale( X, Y, Z );
end;

//------------------------------------------------------------------------------

class function TdSingleM4.RotateX( const T_:TdSingle ) :TdSingleM4;
var
   C, S :TdSingle;
begin
     SinCos( T_, S, C );

     with Result do
     begin
          _11 :=  1;  _12 :=  0;  _13 :=  0;  _14 :=  0;
          _21 :=  0;  _22 :=  C;  _23 := -S;  _24 :=  0;
          _31 :=  0;  _32 := +S;  _33 :=  C;  _34 :=  0;
          _41 :=  0;  _42 :=  0;  _43 :=  0;  _44 :=  1;
     end
end;

class function TdSingleM4.RotateY( const T_:TdSingle ) :TdSingleM4;
var
   C, S :TdSingle;
begin
     SinCos( T_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 :=  0;  _13 := +S;  _14 :=  0;
          _21 :=  0;  _22 :=  1;  _23 :=  0;  _24 :=  0;
          _31 := -S;  _32 :=  0;  _33 :=  C;  _34 :=  0;
          _41 :=  0;  _42 :=  0;  _43 :=  0;  _44 :=  1;
     end
end;

class function TdSingleM4.RotateZ( const T_:TdSingle ) :TdSingleM4;
var
   C, S :TdSingle;
begin
     SinCos( T_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 := -S;  _13 :=  0;  _14 :=  0;
          _21 := +S;  _22 :=  C;  _23 :=  0;  _24 :=  0;
          _31 :=  0;  _32 :=  0;  _33 :=  1;  _34 :=  0;
          _41 :=  0;  _42 :=  0;  _43 :=  0;  _44 :=  1;
     end
end;

//------------------------------------------------------------------------------

class function TdSingleM4.Identity :TdSingleM4;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;  _13 := 0;  _14 := 0;
          _21 := 0;  _22 := 1;  _23 := 0;  _24 := 0;
          _31 := 0;  _32 := 0;  _33 := 1;  _34 := 0;
          _41 := 0;  _42 := 0;  _43 := 0;  _44 := 1;
     end
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDoubleM4

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdDoubleM4.Gets( const Y_,X_:Integer ) :TdDouble;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TdDoubleM4.Sets( const Y_,X_:Integer; const M_:TdDouble );
begin
     _2D[ X_-1, Y_-1 ] := M_;
end;

//------------------------------------------------------------------------------

function TdDoubleM4.GetAxisX :TdDouble3D;
begin
     with Result do
     begin
          X := _11;
          Y := _21;
          Z := _31;
     end
end;

procedure TdDoubleM4.SetAxisX( const AxisX_:TdDouble3D );
begin
     with AxisX_ do
     begin
          _11 := X;
          _21 := Y;
          _31 := Z;
     end
end;

function TdDoubleM4.GetAxisY :TdDouble3D;
begin
     with Result do
     begin
          X := _12;
          Y := _22;
          Z := _32;
     end
end;

procedure TdDoubleM4.SetAxisY( const AxisY_:TdDouble3D );
begin
     with AxisY_ do
     begin
          _12 := X;
          _22 := Y;
          _32 := Z;
     end
end;

function TdDoubleM4.GetAxisZ :TdDouble3D;
begin
     with Result do
     begin
          X := _13;
          Y := _23;
          Z := _33;
     end
end;

procedure TdDoubleM4.SetAxisZ( const AxisZ_:TdDouble3D );
begin
     with AxisZ_ do
     begin
          _13 := X;
          _23 := Y;
          _33 := Z;
     end
end;

function TdDoubleM4.GetAxisP :TdDouble3D;
begin
     with Result do
     begin
          X := _14;
          Y := _24;
          Z := _34;
     end
end;

procedure TdDoubleM4.SetAxisP( const AxisP_:TdDouble3D );
begin
     with AxisP_ do
     begin
          _14 := X;
          _24 := Y;
          _34 := Z;
     end
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdDoubleM4.Create( const _11_,_12_,_13_,_14_,
                                     _21_,_22_,_23_,_24_,
                                     _31_,_32_,_33_,_34_,
                                     _41_,_42_,_43_,_44_ :TdDouble );
begin
     _11 := _11_;  _12 := _12_;  _13 := _13_;  _14 := _14_;
     _21 := _21_;  _22 := _22_;  _23 := _23_;  _24 := _24_;
     _31 := _31_;  _32 := _32_;  _33 := _33_;  _34 := _34_;
     _41 := _41_;  _42 := _42_;  _43 := _43_;  _44 := _44_;
end;

constructor TdDoubleM4.Create( const X_,Y_,Z_,P_:TdDouble3D );
begin
     _11 := X_.X;  _12 := Y_.X;  _13 := Z_.X;  _14 := P_.X;
     _21 := X_.Y;  _22 := Y_.Y;  _23 := Z_.Y;  _24 := P_.Y;
     _31 := X_.Z;  _32 := Y_.Z;  _33 := Z_.Z;  _34 := P_.Z;
     _41 :=    0;  _42 :=    0;  _43 :=    0;  _44 :=    1;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdDoubleM4.Multiply( const A_,B_:TdDoubleM4 ) :TdDoubleM4;
begin
     with Result do
     begin
          _11 := A_._11 * B_._11 + A_._12 * B_._21 + A_._13 * B_._31 + A_._14 * B_._41;
          _12 := A_._11 * B_._12 + A_._12 * B_._22 + A_._13 * B_._32 + A_._14 * B_._42;
          _13 := A_._11 * B_._13 + A_._12 * B_._23 + A_._13 * B_._33 + A_._14 * B_._43;
          _14 := A_._11 * B_._14 + A_._12 * B_._24 + A_._13 * B_._34 + A_._14 * B_._44;

          _21 := A_._21 * B_._11 + A_._22 * B_._21 + A_._23 * B_._31 + A_._24 * B_._41;
          _22 := A_._21 * B_._12 + A_._22 * B_._22 + A_._23 * B_._32 + A_._24 * B_._42;
          _23 := A_._21 * B_._13 + A_._22 * B_._23 + A_._23 * B_._33 + A_._24 * B_._43;
          _24 := A_._21 * B_._14 + A_._22 * B_._24 + A_._23 * B_._34 + A_._24 * B_._44;

          _31 := A_._31 * B_._11 + A_._32 * B_._21 + A_._33 * B_._31 + A_._34 * B_._41;
          _32 := A_._31 * B_._12 + A_._32 * B_._22 + A_._33 * B_._32 + A_._34 * B_._42;
          _33 := A_._31 * B_._13 + A_._32 * B_._23 + A_._33 * B_._33 + A_._34 * B_._43;
          _34 := A_._31 * B_._14 + A_._32 * B_._24 + A_._33 * B_._34 + A_._34 * B_._44;

          _41 := A_._41 * B_._11 + A_._42 * B_._21 + A_._43 * B_._31 + A_._44 * B_._41;
          _42 := A_._41 * B_._12 + A_._42 * B_._22 + A_._43 * B_._32 + A_._44 * B_._42;
          _43 := A_._41 * B_._13 + A_._42 * B_._23 + A_._43 * B_._33 + A_._44 * B_._43;
          _44 := A_._41 * B_._14 + A_._42 * B_._24 + A_._43 * B_._34 + A_._44 * B_._44;
     end
end;

class operator TdDoubleM4.Multiply( const A_:TdDouble; const B_:TdDoubleM4 ) :TdDoubleM4;
begin
     with Result do
     begin
          _11 := A_ * B_._11;  _12 := A_ * B_._12;  _13 := A_ * B_._13;  _14 := A_ * B_._14;
          _21 := A_ * B_._21;  _22 := A_ * B_._22;  _23 := A_ * B_._23;  _24 := A_ * B_._24;
          _31 := A_ * B_._31;  _32 := A_ * B_._32;  _33 := A_ * B_._33;  _34 := A_ * B_._34;
          _41 := A_ * B_._41;  _42 := A_ * B_._42;  _43 := A_ * B_._43;  _44 := A_ * B_._44;
     end
end;

class operator TdDoubleM4.Multiply( const A_:TdDoubleM4; const B_:TdDouble ) :TdDoubleM4;
begin
     with Result do
     begin
          _11 := A_._11 * B_;  _12 := A_._12 * B_;  _13 := A_._13 * B_;  _14 := A_._14 * B_;
          _21 := A_._21 * B_;  _22 := A_._22 * B_;  _23 := A_._23 * B_;  _24 := A_._24 * B_;
          _31 := A_._31 * B_;  _32 := A_._32 * B_;  _33 := A_._33 * B_;  _34 := A_._34 * B_;
          _41 := A_._41 * B_;  _42 := A_._42 * B_;  _43 := A_._43 * B_;  _44 := A_._44 * B_;
     end
end;

class operator TdDoubleM4.Multiply( const A_:TdDoubleM4; const B_:TdDouble4D ) :TdDouble4D;
begin
     with Result do
     begin
          _1 := A_._11 * B_._1 + A_._12 * B_._2 + A_._13 * B_._3 + A_._14 * B_._4;
          _2 := A_._21 * B_._1 + A_._22 * B_._2 + A_._23 * B_._3 + A_._24 * B_._4;
          _3 := A_._31 * B_._1 + A_._32 * B_._2 + A_._33 * B_._3 + A_._34 * B_._4;
          _4 := A_._41 * B_._1 + A_._42 * B_._2 + A_._43 * B_._3 + A_._44 * B_._4;
     end;
end;

class operator TdDoubleM4.Multiply( const A_:TdDouble4D; const B_:TdDoubleM4 ) :TdDouble4D;
begin
     with Result do
     begin
          _1 := A_._1 * B_._11 + A_._2 * B_._21 + A_._3 * B_._31 + A_._4 * B_._41;
          _2 := A_._1 * B_._12 + A_._2 * B_._22 + A_._3 * B_._32 + A_._4 * B_._42;
          _3 := A_._1 * B_._13 + A_._2 * B_._23 + A_._3 * B_._33 + A_._4 * B_._43;
          _4 := A_._1 * B_._14 + A_._2 * B_._24 + A_._3 * B_._34 + A_._4 * B_._44;
     end;
end;

class operator TdDoubleM4.Divide( const A_:TdDoubleM4; const B_:TdDouble ) :TdDoubleM4;
begin
     with A_ do
     begin
          Result._11 := _11 / B_;  Result._12 := _12 / B_;  Result._13 := _13 / B_;  Result._14 := _14 / B_;
          Result._21 := _21 / B_;  Result._22 := _22 / B_;  Result._23 := _23 / B_;  Result._24 := _24 / B_;
          Result._31 := _31 / B_;  Result._32 := _32 / B_;  Result._33 := _33 / B_;  Result._34 := _34 / B_;
          Result._41 := _41 / B_;  Result._42 := _42 / B_;  Result._43 := _43 / B_;  Result._44 := _44 / B_;
     end
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TdDoubleM4.Implicit( const V_:TdDouble ) :TdDoubleM4;
begin
     with Result do
     begin
          _11 := V_;  _12 := 0 ;  _13 := 0 ;  _14 := 0 ;
          _21 := 0 ;  _22 := V_;  _23 := 0 ;  _24 := 0 ;
          _31 := 0 ;  _32 := 0 ;  _33 := V_;  _34 := 0 ;
          _41 := 0 ;  _42 := 0 ;  _43 := 0 ;  _44 := V_;
     end
end;

class operator TdDoubleM4.Implicit( const V_:TMatrix3D ) :TdDoubleM4;
begin
     with Result do
     begin
          _11 := V_.m11;  _12 := V_.m21;  _13 := V_.m31;  _14 := V_.m41;
          _21 := V_.m12;  _22 := V_.m22;  _23 := V_.m32;  _24 := V_.m42;
          _31 := V_.m13;  _32 := V_.m23;  _33 := V_.m33;  _34 := V_.m43;
          _41 := V_.m14;  _42 := V_.m24;  _43 := V_.m34;  _44 := V_.m44;
     end
end;

class operator TdDoubleM4.Explicit( const V_:TdDoubleM4 ) :TMatrix3D;
begin
     with Result do
     begin
          m11 := V_._11.o;  m12 := V_._21.o;  m13 := V_._31.o;  m14 := V_._41.o;
          m21 := V_._12.o;  m22 := V_._22.o;  m23 := V_._32.o;  m24 := V_._42.o;
          m31 := V_._13.o;  m32 := V_._23.o;  m33 := V_._33.o;  m34 := V_._43.o;
          m41 := V_._14.o;  m42 := V_._24.o;  m43 := V_._34.o;  m44 := V_._44.o;
     end
end;

class operator TdDoubleM4.Implicit( const V_:TdSingleM4 ) :TdDoubleM4;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;  _14 := V_._14;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;  _24 := V_._24;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;  _34 := V_._34;
          _41 := V_._41;  _42 := V_._42;  _43 := V_._43;  _44 := V_._44;
     end
end;

class operator TdDoubleM4.Explicit( const V_:TdDoubleM4 ) :TdSingleM4;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;  _14 := V_._14;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;  _24 := V_._24;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;  _34 := V_._34;
          _41 := V_._41;  _42 := V_._42;  _43 := V_._43;  _44 := V_._44;
     end
end;

class operator TdDoubleM4.Implicit( const V_:TdDoubleM3 ) :TdDoubleM4;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;  _14 := 0;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;  _24 := 0;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;  _34 := 0;
          _41 :=      0;  _42 :=      0;  _43 :=      0;  _44 := 1;
     end
end;

class operator TdDoubleM4.Explicit( const V_:TdDoubleM4 ) :TdDoubleM3;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;  _13 := V_._13;
          _21 := V_._21;  _22 := V_._22;  _23 := V_._23;
          _31 := V_._31;  _32 := V_._32;  _33 := V_._33;
     end
end;

////////////////////////////////////////////////////////////////////////////////

function TdDoubleM4.MultPos( const B_:TdDouble3D ) :TdDouble3D;
begin
     Result.X := _11 * B_.X + _12 * B_.Y + _13 * B_.Z + _14;
     Result.Y := _21 * B_.X + _22 * B_.Y + _23 * B_.Z + _24;
     Result.Z := _31 * B_.X + _32 * B_.Y + _33 * B_.Z + _34;
end;

function TdDoubleM4.MultVec( const B_:TdDouble3D ) :TdDouble3D;
begin
     Result.X := _11 * B_.X + _12 * B_.Y + _13 * B_.Z;
     Result.Y := _21 * B_.X + _22 * B_.Y + _23 * B_.Z;
     Result.Z := _31 * B_.X + _32 * B_.Y + _33 * B_.Z;
end;

function TdDoubleM4.Adjugate :TdDoubleM4;
begin
     Result._11 := +TdDoubleM3.Create( {11} {12} {13} {14}
                                       {21} _22, _23, _24,
                                       {31} _32, _33, _34,
                                       {41} _42, _43, _44  ).Det;

     Result._21 := -TdDoubleM3.Create( {11} {12} {13} {14}
                                       _21, {22} _23, _24,
                                       _31, {32} _33, _34,
                                       _41, {42} _43, _44  ).Det;

     Result._31 := +TdDoubleM3.Create( {11} {12} {13} {14}
                                       _21, _22, {23} _24,
                                       _31, _32, {33} _34,
                                       _41, _42, {43} _44  ).Det;

     Result._41 := -TdDoubleM3.Create( {11} {12} {13} {14}
                                       _21, _22, _23, {24}
                                       _31, _32, _33, {34}
                                       _41, _42, _43  {44} ).Det;


     Result._12 := -TdDoubleM3.Create( {11} _12, _13, _14,
                                       {21} {22} {23} {24}
                                       {31} _32, _33, _34,
                                       {41} _42, _43, _44  ).Det;

     Result._22 := +TdDoubleM3.Create( _11, {12} _13, _14,
                                       {21} {22} {23} {24}
                                       _31, {32} _33, _34,
                                       _41, {42} _43, _44  ).Det;

     Result._32 := -TdDoubleM3.Create( _11, _12, {13} _14,
                                       {21} {22} {23} {24}
                                       _31, _32, {33} _34,
                                       _41, _42, {43} _44  ).Det;

     Result._42 := +TdDoubleM3.Create( _11, _12, _13, {14}
                                       {21} {22} {23} {24}
                                       _31, _32, _33, {34}
                                       _41, _42, _43  {44} ).Det;


     Result._13 := +TdDoubleM3.Create( {11} _12, _13, _14,
                                       {21} _22, _23, _24,
                                       {31} {32} {33} {34}
                                       {41} _42, _43, _44  ).Det;

     Result._23 := -TdDoubleM3.Create( _11, {12} _13, _14,
                                       _21, {22} _23, _24,
                                       {31} {32} {33} {34}
                                       _41, {42} _43, _44  ).Det;

     Result._33 := +TdDoubleM3.Create( _11, _12, {13} _14,
                                       _21, _22, {23} _24,
                                       {31} {32} {33} {34}
                                       _41, _42, {43} _44  ).Det;

     Result._43 := -TdDoubleM3.Create( _11, _12, _13, {14}
                                       _21, _22, _23, {24}
                                       {31} {32} {33} {34}
                                       _41, _42, _43  {44} ).Det;


     Result._14 := -TdDoubleM3.Create( {11} _12, _13, _14,
                                       {21} _22, _23, _24,
                                       {31} _32, _33, _34
                                       {41} {42} {43} {44} ).Det;

     Result._24 := +TdDoubleM3.Create( _11, {12} _13, _14,
                                       _21, {22} _23, _24,
                                       _31, {32} _33, _34
                                       {41} {42} {43} {44} ).Det;

     Result._34 := -TdDoubleM3.Create( _11, _12, {13} _14,
                                       _21, _22, {23} _24,
                                       _31, _32, {33} _34
                                       {41} {42} {43} {44} ).Det;

     Result._44 := +TdDoubleM3.Create( _11, _12, _13, {14}
                                       _21, _22, _23, {24}
                                       _31, _32, _33  {34}
                                       {41} {42} {43} {44} ).Det;
end;

function TdDoubleM4.Transpose :TdDoubleM4;
begin
     Result._11 := _11;  Result._12 := _21;  Result._13 := _31;  Result._14 := _41;
     Result._21 := _12;  Result._22 := _22;  Result._23 := _32;  Result._24 := _42;
     Result._31 := _13;  Result._32 := _23;  Result._33 := _33;  Result._34 := _43;
     Result._41 := _14;  Result._42 := _24;  Result._43 := _34;  Result._44 := _44;
end;

function TdDoubleM4.Inverse :TdDoubleM4;
var
   A :TdDoubleM4;
begin
     A := Adjugate;

     Result := A / ( _11 * A._11
                   + _12 * A._21
                   + _13 * A._31
                   + _14 * A._41 )
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TdDoubleM4.Translate( const X_,Y_,Z_:TdDouble ) :TdDoubleM4;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;  _13 := 0;  _14 := X_;
          _21 := 0;  _22 := 1;  _23 := 0;  _24 := Y_;
          _31 := 0;  _32 := 0;  _33 := 1;  _34 := Z_;
          _41 := 0;  _42 := 0;  _43 := 0;  _44 := 1;
     end
end;

class function TdDoubleM4.Translate( const T_:TdDouble3D ) :TdDoubleM4;
begin
     with T_ do Result := Translate( X, Y, Z );
end;

//------------------------------------------------------------------------------

class function TdDoubleM4.Scale( const X_,Y_,Z_:TdDouble ) :TdDoubleM4;
begin
     with Result do
     begin
          _11 := X_;  _12 := 0;   _13 := 0;   _14 := 0;
          _21 := 0;   _22 := Y_;  _23 := 0;   _24 := 0;
          _31 := 0;   _32 := 0;   _33 := Z_;  _34 := 0;
          _41 := 0;   _42 := 0;   _43 := 0;   _44 := 1;
     end
end;

class function TdDoubleM4.Scale( const S_:TdDouble3D ) :TdDoubleM4;
begin
     with S_ do Result := Scale( X, Y, Z );
end;

//------------------------------------------------------------------------------

class function TdDoubleM4.RotateX( const T_:TdDouble ) :TdDoubleM4;
var
   C, S :TdDouble;
begin
     SinCos( T_, S, C );

     with Result do
     begin
          _11 :=  1;  _12 :=  0;  _13 :=  0;  _14 :=  0;
          _21 :=  0;  _22 :=  C;  _23 := -S;  _24 :=  0;
          _31 :=  0;  _32 := +S;  _33 :=  C;  _34 :=  0;
          _41 :=  0;  _42 :=  0;  _43 :=  0;  _44 :=  1;
     end
end;

class function TdDoubleM4.RotateY( const T_:TdDouble ) :TdDoubleM4;
var
   C, S :TdDouble;
begin
     SinCos( T_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 :=  0;  _13 := +S;  _14 :=  0;
          _21 :=  0;  _22 :=  1;  _23 :=  0;  _24 :=  0;
          _31 := -S;  _32 :=  0;  _33 :=  C;  _34 :=  0;
          _41 :=  0;  _42 :=  0;  _43 :=  0;  _44 :=  1;
     end
end;

class function TdDoubleM4.RotateZ( const T_:TdDouble ) :TdDoubleM4;
var
   C, S :TdDouble;
begin
     SinCos( T_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 := -S;  _13 :=  0;  _14 :=  0;
          _21 := +S;  _22 :=  C;  _23 :=  0;  _24 :=  0;
          _31 :=  0;  _32 :=  0;  _33 :=  1;  _34 :=  0;
          _41 :=  0;  _42 :=  0;  _43 :=  0;  _44 :=  1;
     end
end;

//------------------------------------------------------------------------------

class function TdDoubleM4.Identity :TdDoubleM4;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;  _13 := 0;  _14 := 0;
          _21 := 0;  _22 := 1;  _23 := 0;  _24 := 0;
          _31 := 0;  _32 := 0;  _33 := 1;  _34 := 0;
          _41 := 0;  _42 := 0;  _43 := 0;  _44 := 1;
     end
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleDualM4

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

procedure TSingleDualM4.Seto( const o_:TSingleM4 );
begin
     _o := o_        ;
     _i := o_.Inverse;
end;

procedure TSingleDualM4.Seti( const i_:TSingleM4 );
begin
     _o := i_.Inverse;
     _i := i_        ;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TSingleDualM4.Multiply( const A_,B_:TSingleDualM4 ) :TSingleDualM4;
begin
     with Result do
     begin
          _o := A_.o * B_.o;
          _i := B_.i * A_.i;
     end
end;

class operator TSingleDualM4.Multiply( const A_:Single; B_:TSingleDualM4 ) :TSingleDualM4;
begin
     with Result do
     begin
          _o := A_   * B_.o;
          _i := B_.i * A_  ;
     end
end;

class operator TSingleDualM4.Multiply( const A_:TSingleDualM4; B_:Single ) :TSingleDualM4;
begin
     with Result do
     begin
          _o := A_.o * B_  ;
          _i := B_   * A_.i;
     end
end;

class operator TSingleDualM4.Divide( const A_:TSingleDualM4; const B_:Single ) :TSingleDualM4;
begin
     with Result do
     begin
          _o := A_.o / B_;
          _i := A_.i / B_;
     end
end;

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TSingleDualM4.Translate( const X_,Y_,Z_:Single ) :TSingleDualM4;
begin
     with Result do
     begin
          _o := TSingleM4.Translate( +X_, +Y_, +Z_ );
          _i := TSingleM4.Translate( -X_, -Y_, -Z_ );
     end;
end;

class function TSingleDualM4.Scale( const X_,Y_,Z_:Single ) :TSingleDualM4;
begin
     with Result do
     begin
          _o := TSingleM4.Scale( +X_, +Y_, +Z_ );
          _i := TSingleM4.Scale( -X_, -Y_, -Z_ );
     end;
end;

class function TSingleDualM4.RotateX( const T_:Single ) :TSingleDualM4;
begin
     with Result do
     begin
          _o := TSingleM4.RotateX( +T_ );
          _i := TSingleM4.RotateX( -T_ );
     end;
end;

class function TSingleDualM4.RotateY( const T_:Single ) :TSingleDualM4;
begin
     with Result do
     begin
          _o := TSingleM4.RotateY( +T_ );
          _i := TSingleM4.RotateY( -T_ );
     end;
end;

class function TSingleDualM4.RotateZ( const T_:Single ) :TSingleDualM4;
begin
     with Result do
     begin
          _o := TSingleM4.RotateZ( +T_ );
          _i := TSingleM4.RotateZ( -T_ );
     end;
end;

class function TSingleDualM4.Identity :TSingleDualM4;
begin
     with Result do
     begin
          _o := TSingleM4.Identity;
          _i := TSingleM4.Identity;
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Tensor( const T_:TSingle2D; const Func_:TConstFunc<TdSingle2D,TdSingle3D> ) :TSingleM4;
var
   T :TdSingle2D;
   FP, FX, FY :TdSingle3D;
begin
     with T do
     begin
          U.o := T_.U;
          V.o := T_.V;

          U.d :=  0;  V.d :=  0;  FP := Func_( T );
          U.d := +1;  V.d :=  0;  FX := Func_( T );
          U.d :=  0;  V.d := -1;  FY := Func_( T );
     end;

     with Result do
     begin
          AxisP := FP.o;
          AxisX := FX.d;
          AxisY := FY.d;
          AxisZ := CrossProduct( FX.d, FY.d );
     end;
end;

function Tensor( const T_:TDouble2D; const Func_:TConstFunc<TdDouble2D,TdDouble3D> ) :TDoubleM4;
var
   T :TdDouble2D;
   FP, FX, FY :TdDouble3D;
begin
     with T do
     begin
          U.o := T_.U;
          V.o := T_.V;

          U.d :=  0;  V.d :=  0;  FP := Func_( T );
          U.d := +1;  V.d :=  0;  FX := Func_( T );
          U.d :=  0;  V.d := -1;  FY := Func_( T );
     end;

     with Result do
     begin
          AxisP := FP.o;
          AxisX := FX.d;
          AxisY := FY.d;
          AxisZ := CrossProduct( FX.d, FY.d );
     end;
end;

//------------------------------------------------------------------------------

function ArrowPose( const P0_,P1_:TSingle3D ) :TSingleM4;
begin
     Result := ArrowRot( P0_, P1_ );

     Result.AxisP := ( P1_ + P0_ ) / 2;
end;

function ArrowPose( const P0_,P1_:TDouble3D ) :TDoubleM4;
begin
     Result := ArrowRot( P0_, P1_ );

     Result.AxisP := ( P1_ + P0_ ) / 2;
end;

end. //######################################################################### ■
