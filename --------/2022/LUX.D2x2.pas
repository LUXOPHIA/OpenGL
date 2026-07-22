unit LUX.D2x2;

interface //#################################################################### ■

uses LUX, LUX.D1, LUX.D2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleM2

     TSingleM2 = record
     private
       ///// A C C E S S O R
       function Gets( const Y_,X_:Integer ) :Single;
       procedure Sets( const Y_,X_:Integer; const M_:Single );
       function GetAxisX :TSingle2D;
       procedure SetAxisX( const AxisX_:TSingle2D );
       function GetAxisY :TSingle2D;
       procedure SetAxisY( const AxisY_:TSingle2D );
     public
       constructor Create( const _11_,_12_,
                                 _21_,_22_:Single );
       ///// O P E R A T O R
       class operator Negative( const V_:TSingleM2 ) :TSingleM2;
       class operator Positive( const V_:TSingleM2 ) :TSingleM2;
       class operator Add( const A_,B_:TSingleM2 ) :TSingleM2;
       class operator Subtract( const A_,B_:TSingleM2 ) :TSingleM2;
       class operator Multiply( const A_,B_:TSingleM2 ) :TSingleM2;
       class operator Multiply( const A_:TSingleM2; const B_:Single ) :TSingleM2;
       class operator Multiply( const A_:Single; const B_:TSingleM2 ) :TSingleM2;
       class operator Multiply( const A_:TSingle2D; const B_:TSingleM2 ) :TSingle2D;
       class operator Multiply( const A_:TSingleM2; const B_:TSingle2D ) :TSingle2D;
       class operator Divide( const A_:TSingleM2; const B_:Single ) :TSingleM2;
       ///// P R O P E R T Y
       property _s[ const Y_,X_:Integer ] :Single    read Gets     write Sets    ; default;
       property AxisX                     :TSingle2D read GetAxisX write SetAxisX;
       property AxisY                     :TSingle2D read GetAxisY write SetAxisY;
       ///// M E T H O D
       function Det :Single;
       function Adjugate :TSingleM2;
       function Inverse :TSingleM2;
       class function Rotate( const Angle_:Single ) :TSingleM2; static;

     case Byte of
      0:( _1D :array [ 0..2*2-1       ] of Single; );
      1:( _2D :array [ 0..2-1, 0..2-1 ] of Single; );
      2:( _11, _21,
          _12, _22 :Single;                        );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleM2

     TDoubleM2 = record
     private
       ///// A C C E S S O R
       function Gets( const Y_,X_:Integer ) :Double;
       procedure Sets( const Y_,X_:Integer; const M_:Double );
       function GetAxisX :TDouble2D;
       procedure SetAxisX( const AxisX_:TDouble2D );
       function GetAxisY :TDouble2D;
       procedure SetAxisY( const AxisY_:TDouble2D );
     public
       constructor Create( const _11_,_12_,
                                 _21_,_22_:Double );
       ///// O P E R A T O R
       class operator Negative( const V_:TDoubleM2 ) :TDoubleM2;
       class operator Positive( const V_:TDoubleM2 ) :TDoubleM2;
       class operator Add( const A_,B_:TDoubleM2 ) :TDoubleM2;
       class operator Subtract( const A_,B_:TDoubleM2 ) :TDoubleM2;
       class operator Multiply( const A_,B_:TDoubleM2 ) :TDoubleM2;
       class operator Multiply( const A_:TDoubleM2; const B_:Double ) :TDoubleM2;
       class operator Multiply( const A_:Double; const B_:TDoubleM2 ) :TDoubleM2;
       class operator Multiply( const A_:TDouble2D; const B_:TDoubleM2 ) :TDouble2D;
       class operator Multiply( const A_:TDoubleM2; const B_:TDouble2D ) :TDouble2D;
       class operator Divide( const A_:TDoubleM2; const B_:Double ) :TDoubleM2;
       ///// P R O P E R T Y
       property _s[ const Y_,X_:Integer ] :Double    read Gets     write Sets    ; default;
       property AxisX                     :TDouble2D read GetAxisX write SetAxisX;
       property AxisY                     :TDouble2D read GetAxisY write SetAxisY;
       ///// M E T H O D
       function Det :Double;
       function Adjugate :TDoubleM2;
       function Inverse :TDoubleM2;
       class function Rotate( const Angle_:Double ) :TDoubleM2; static;

     case Byte of
       0: ( _1D :array [ 0..2*2-1       ] of Double; );
       1: ( _2D :array [ 0..2-1, 0..2-1 ] of Double; );
       2: ( _11, _21,
            _12, _22 :Double;                        );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingleM2

     TdSingleM2 = record
     private
       ///// A C C E S S O R
       function Gets( const Y_,X_:Integer ) :TdSingle;
       procedure Sets( const Y_,X_:Integer; const M_:TdSingle );
       function GetAxisX :TdSingle2D;
       procedure SetAxisX( const AxisX_:TdSingle2D );
       function GetAxisY :TdSingle2D;
       procedure SetAxisY( const AxisY_:TdSingle2D );
     public
       constructor Create( const _11_,_12_,
                                 _21_,_22_:TdSingle );
       ///// O P E R A T O R
       class operator Negative( const V_:TdSingleM2 ) :TdSingleM2;
       class operator Positive( const V_:TdSingleM2 ) :TdSingleM2;
       class operator Add( const A_,B_:TdSingleM2 ) :TdSingleM2;
       class operator Subtract( const A_,B_:TdSingleM2 ) :TdSingleM2;
       class operator Multiply( const A_,B_:TdSingleM2 ) :TdSingleM2;
       class operator Multiply( const A_:TdSingleM2; const B_:TdSingle ) :TdSingleM2;
       class operator Multiply( const A_:TdSingle; const B_:TdSingleM2 ) :TdSingleM2;
       class operator Multiply( const A_:TdSingle2D; const B_:TdSingleM2 ) :TdSingle2D;
       class operator Multiply( const A_:TdSingleM2; const B_:TdSingle2D ) :TdSingle2D;
       class operator Divide( const A_:TdSingleM2; const B_:TdSingle ) :TdSingleM2;
       ///// P R O P E R T Y
       property _s[ const Y_,X_:Integer ] :TdSingle   read Gets     write Sets    ; default;
       property AxisX                     :TdSingle2D read GetAxisX write SetAxisX;
       property AxisY                     :TdSingle2D read GetAxisY write SetAxisY;
       ///// M E T H O D
       function Det :TdSingle;
       function Adjugate :TdSingleM2;
       function Inverse :TdSingleM2;
       class function Rotate( const Angle_:TdSingle ) :TdSingleM2; static;

     case Byte of
      0:( _1D :array [ 0..2*2-1       ] of TdSingle; );
      1:( _2D :array [ 0..2-1, 0..2-1 ] of TdSingle; );
      2:( _11, _21,
          _12, _22 :TdSingle;                        );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDoubleM2

     TdDoubleM2 = record
     private
       ///// A C C E S S O R
       function Gets( const Y_,X_:Integer ) :TdDouble;
       procedure Sets( const Y_,X_:Integer; const M_:TdDouble );
       function GetAxisX :TdDouble2D;
       procedure SetAxisX( const AxisX_:TdDouble2D );
       function GetAxisY :TdDouble2D;
       procedure SetAxisY( const AxisY_:TdDouble2D );
     public
       constructor Create( const _11_,_12_,
                                 _21_,_22_:TdDouble );
       ///// O P E R A T O R
       class operator Negative( const V_:TdDoubleM2 ) :TdDoubleM2;
       class operator Positive( const V_:TdDoubleM2 ) :TdDoubleM2;
       class operator Add( const A_,B_:TdDoubleM2 ) :TdDoubleM2;
       class operator Subtract( const A_,B_:TdDoubleM2 ) :TdDoubleM2;
       class operator Multiply( const A_,B_:TdDoubleM2 ) :TdDoubleM2;
       class operator Multiply( const A_:TdDoubleM2; const B_:TdDouble ) :TdDoubleM2;
       class operator Multiply( const A_:TdDouble; const B_:TdDoubleM2 ) :TdDoubleM2;
       class operator Multiply( const A_:TdDouble2D; const B_:TdDoubleM2 ) :TdDouble2D;
       class operator Multiply( const A_:TdDoubleM2; const B_:TdDouble2D ) :TdDouble2D;
       class operator Divide( const A_:TdDoubleM2; const B_:TdDouble ) :TdDoubleM2;
       ///// P R O P E R T Y
       property _s[ const Y_,X_:Integer ] :TdDouble   read Gets     write Sets    ; default;
       property AxisX                     :TdDouble2D read GetAxisX write SetAxisX;
       property AxisY                     :TdDouble2D read GetAxisY write SetAxisY;
       ///// M E T H O D
       function Det :TdDouble;
       function Adjugate :TdDoubleM2;
       function Inverse :TdDoubleM2;
       class function Rotate( const Angle_:TdDouble ) :TdDoubleM2; static;

     case Byte of
       0: ( _1D :array [ 0..2*2-1       ] of TdDouble; );
       1: ( _2D :array [ 0..2-1, 0..2-1 ] of TdDouble; );
       2: ( _11, _21,
            _12, _22 :TdDouble;                        );
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 V A R I A B L E 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleM2

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TSingleM2.Gets( const Y_,X_:Integer ) :Single;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TSingleM2.Sets( const Y_,X_:Integer; const M_:Single );
begin
     _2D[ X_-1, Y_-1 ] := M_;
end;

//------------------------------------------------------------------------------

function TSingleM2.GetAxisX :TSingle2D;
begin
     with Result do
     begin
          X := _11; {X := _12;}
          Y := _21; {Y := _22;}
     end;
end;

procedure TSingleM2.SetAxisX( const AxisX_:TSingle2D );
begin
     with AxisX_ do
     begin
          _11 := X; {_12 := X;}
          _21 := Y; {_22 := Y;}
     end;
end;

function TSingleM2.GetAxisY :TSingle2D;
begin
     with Result do
     begin
         {X := _11;} X := _12;
         {Y := _21;} Y := _22;
     end;
end;

procedure TSingleM2.SetAxisY( const AxisY_:TSingle2D );
begin
     with AxisY_ do
     begin
         {_11 := X;} _12 := X;
         {_21 := Y;} _22 := Y;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingleM2.Create( const _11_,_12_, _21_,_22_:Single );
begin
     _11 := _11_;  _12 := _12_;
     _21 := _21_;  _22 := _22_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TSingleM2.Positive( const V_:TSingleM2 ) :TSingleM2;
begin
     with Result do
     begin
          _11 := +V_._11;  _12 := +V_._12;
          _21 := +V_._21;  _22 := +V_._22;
     end
end;

class operator TSingleM2.Negative( const V_:TSingleM2 ) :TSingleM2;
begin
     with Result do
     begin
          _11 := -V_._11;  _12 := -V_._12;
          _21 := -V_._21;  _22 := -V_._22;
     end
end;

class operator TSingleM2.Add( const A_,B_:TSingleM2 ) :TSingleM2;
begin
     with Result do
     begin
          _11 := A_._11 + B_._11;  _12 := A_._12 + B_._12;
          _21 := A_._21 + B_._21;  _22 := A_._22 + B_._22;
     end
end;

class operator TSingleM2.Subtract( const A_,B_:TSingleM2 ) :TSingleM2;
begin
     with Result do
     begin
          _11 := A_._11 - B_._11;  _12 := A_._12 - B_._12;
          _21 := A_._21 - B_._21;  _22 := A_._22 - B_._22;
     end
end;

class operator TSingleM2.Multiply( const A_,B_:TSingleM2 ) :TSingleM2;
begin
     // _11 _12    _11 _12
     // _21 _22 × _21 _22

     with Result do
     begin
          _11 := A_._11 * B_._11 + A_._12 * B_._21;
          _12 := A_._11 * B_._12 + A_._12 * B_._22;

          _21 := A_._21 * B_._11 + A_._22 * B_._21;
          _22 := A_._21 * B_._12 + A_._22 * B_._22;
     end
end;

class operator TSingleM2.Multiply( const A_:TSingleM2; const B_:Single ) :TSingleM2;
begin
     with Result do
     begin
          _11 := A_._11 * B_;  _12 := A_._12 * B_;
          _21 := A_._21 * B_;  _22 := A_._22 * B_;
     end
end;

class operator TSingleM2.Multiply( const A_:Single; const B_:TSingleM2 ) :TSingleM2;
begin
     with Result do
     begin
          _11 := A_ * B_._11;  _12 := A_ * B_._12;
          _21 := A_ * B_._21;  _22 := A_ * B_._22;
     end
end;

class operator TSingleM2.Multiply( const A_:TSingle2D; const B_:TSingleM2 ) :TSingle2D;
begin
     {
               _11 _12
        X Y × _21 _22
     }

     with Result do
     begin
          X := A_.X * B_._11 + A_.Y * B_._21;
          Y := A_.X * B_._12 + A_.Y * B_._22;
     end
end;

class operator TSingleM2.Multiply( const A_:TSingleM2; const B_:TSingle2D ) :TSingle2D;
begin
     {
       _11 _12    X
       _21 _22 × Y
     }

     with Result do
     begin
          X := A_._11 * B_.X + A_._12 * B_.Y;
          Y := A_._21 * B_.X + A_._22 * B_.Y;
     end
end;

class operator TSingleM2.Divide( const A_:TSingleM2; const B_:Single ) :TSingleM2;
begin
     with Result do
     begin
          _11 := A_._11 / B_;  _12 := A_._12 / B_;
          _21 := A_._21 / B_;  _22 := A_._22 / B_;
     end
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TSingleM2.Det :Single;
begin
     Result := _11 * _22 - _21 * _12;
end;

function TSingleM2.Adjugate :TSingleM2;
begin
     Result._11 := +_22;  Result._12 := -_12;
     Result._21 := -_21;  Result._22 := +_11;
end;

function TSingleM2.Inverse :TSingleM2;
begin
     Result := Adjugate / Det;
end;

//------------------------------------------------------------------------------

class function TSingleM2.Rotate( const Angle_:Single ) :TSingleM2;
var
   S, C :Single;
begin
     SinCos( Angle_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 := -S;
          _21 := +S;  _22 :=  C;
     end
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleM2

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TDoubleM2.Gets( const Y_,X_:Integer ) :Double;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TDoubleM2.Sets( const Y_,X_:Integer; const M_:Double );
begin
     _2D[ X_-1, Y_-1 ] := M_;
end;

//------------------------------------------------------------------------------

function TDoubleM2.GetAxisX :TDouble2D;
begin
     with Result do
     begin
          X := _11; {X := _12;}
          Y := _21; {Y := _22;}
     end;
end;

procedure TDoubleM2.SetAxisX( const AxisX_:TDouble2D );
begin
     with AxisX_ do
     begin
          _11 := X; {_12 := X;}
          _21 := Y; {_22 := Y;}
     end;
end;

function TDoubleM2.GetAxisY :TDouble2D;
begin
     with Result do
     begin
         {X := _11;} X := _12;
         {Y := _21;} Y := _22;
     end;
end;

procedure TDoubleM2.SetAxisY( const AxisY_:TDouble2D );
begin
     with AxisY_ do
     begin
         {_11 := X;} _12 := X;
         {_21 := Y;} _22 := Y;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDoubleM2.Create( const _11_,_12_, _21_,_22_:Double );
begin
     _11 := _11_;  _12 := _12_;
     _21 := _21_;  _22 := _22_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TDoubleM2.Positive( const V_:TDoubleM2 ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := +V_._11;  _12 := +V_._12;
          _21 := +V_._21;  _22 := +V_._22;
     end
end;

class operator TDoubleM2.Negative( const V_:TDoubleM2 ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := -V_._11;  _12 := -V_._12;
          _21 := -V_._21;  _22 := -V_._22;
     end
end;

class operator TDoubleM2.Add( const A_,B_:TDoubleM2 ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := A_._11 + B_._11;  _12 := A_._12 + B_._12;
          _21 := A_._21 + B_._21;  _22 := A_._22 + B_._22;
     end
end;

class operator TDoubleM2.Subtract( const A_,B_:TDoubleM2 ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := A_._11 - B_._11;  _12 := A_._12 - B_._12;
          _21 := A_._21 - B_._21;  _22 := A_._22 - B_._22;
     end
end;

class operator TDoubleM2.Multiply( const A_,B_:TDoubleM2 ) :TDoubleM2;
begin
     // _11 _12    _11 _12
     // _21 _22 × _21 _22

     with Result do
     begin
          _11 := A_._11 * B_._11 + A_._12 * B_._21;
          _12 := A_._11 * B_._12 + A_._12 * B_._22;

          _21 := A_._21 * B_._11 + A_._22 * B_._21;
          _22 := A_._21 * B_._12 + A_._22 * B_._22;
     end
end;

class operator TDoubleM2.Multiply( const A_:TDoubleM2; const B_:Double ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := A_._11 * B_;  _12 := A_._12 * B_;
          _21 := A_._21 * B_;  _22 := A_._22 * B_;
     end
end;

class operator TDoubleM2.Multiply( const A_:Double; const B_:TDoubleM2 ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := A_ * B_._11;  _12 := A_ * B_._12;
          _21 := A_ * B_._21;  _22 := A_ * B_._22;
     end
end;

class operator TDoubleM2.Multiply( const A_:TDouble2D; const B_:TDoubleM2 ) :TDouble2D;
begin
     {
               _11 _12
        X Y × _21 _22
     }

     with Result do
     begin
          X := A_.X * B_._11 + A_.Y * B_._21;
          Y := A_.X * B_._12 + A_.Y * B_._22;
     end
end;

class operator TDoubleM2.Multiply( const A_:TDoubleM2; const B_:TDouble2D ) :TDouble2D;
begin
     {
       _11 _12    X
       _21 _22 × Y
     }

     with Result do
     begin
          X := A_._11 * B_.X + A_._12 * B_.Y;
          Y := A_._21 * B_.X + A_._22 * B_.Y;
     end
end;

class operator TDoubleM2.Divide( const A_:TDoubleM2; const B_:Double ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := A_._11 / B_;  _12 := A_._12 / B_;
          _21 := A_._21 / B_;  _22 := A_._22 / B_;
     end
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TDoubleM2.Det :Double;
begin
     Result := _11 * _22 - _21 * _12;
end;

function TDoubleM2.Adjugate :TDoubleM2;
begin
     Result._11 := +_22;  Result._12 := -_12;
     Result._21 := -_21;  Result._22 := +_11;
end;

function TDoubleM2.Inverse :TDoubleM2;
begin
     Result := Adjugate / Det;
end;

//------------------------------------------------------------------------------

class function TDoubleM2.Rotate( const Angle_:Double ) :TDoubleM2;
var
   S, C :Double;
begin
     SinCos( Angle_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 := -S;
          _21 := +S;  _22 :=  C;
     end
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingleM2

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdSingleM2.Gets( const Y_,X_:Integer ) :TdSingle;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TdSingleM2.Sets( const Y_,X_:Integer; const M_:TdSingle );
begin
     _2D[ X_-1, Y_-1 ] := M_;
end;

//------------------------------------------------------------------------------

function TdSingleM2.GetAxisX :TdSingle2D;
begin
     with Result do
     begin
          X := _11; {X := _12;}
          Y := _21; {Y := _22;}
     end;
end;

procedure TdSingleM2.SetAxisX( const AxisX_:TdSingle2D );
begin
     with AxisX_ do
     begin
          _11 := X; {_12 := X;}
          _21 := Y; {_22 := Y;}
     end;
end;

function TdSingleM2.GetAxisY :TdSingle2D;
begin
     with Result do
     begin
         {X := _11;} X := _12;
         {Y := _21;} Y := _22;
     end;
end;

procedure TdSingleM2.SetAxisY( const AxisY_:TdSingle2D );
begin
     with AxisY_ do
     begin
         {_11 := X;} _12 := X;
         {_21 := Y;} _22 := Y;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdSingleM2.Create( const _11_,_12_, _21_,_22_:TdSingle );
begin
     _11 := _11_;  _12 := _12_;
     _21 := _21_;  _22 := _22_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdSingleM2.Positive( const V_:TdSingleM2 ) :TdSingleM2;
begin
     with Result do
     begin
          _11 := +V_._11;  _12 := +V_._12;
          _21 := +V_._21;  _22 := +V_._22;
     end
end;

class operator TdSingleM2.Negative( const V_:TdSingleM2 ) :TdSingleM2;
begin
     with Result do
     begin
          _11 := -V_._11;  _12 := -V_._12;
          _21 := -V_._21;  _22 := -V_._22;
     end
end;

class operator TdSingleM2.Add( const A_,B_:TdSingleM2 ) :TdSingleM2;
begin
     with Result do
     begin
          _11 := A_._11 + B_._11;  _12 := A_._12 + B_._12;
          _21 := A_._21 + B_._21;  _22 := A_._22 + B_._22;
     end
end;

class operator TdSingleM2.Subtract( const A_,B_:TdSingleM2 ) :TdSingleM2;
begin
     with Result do
     begin
          _11 := A_._11 - B_._11;  _12 := A_._12 - B_._12;
          _21 := A_._21 - B_._21;  _22 := A_._22 - B_._22;
     end
end;

class operator TdSingleM2.Multiply( const A_,B_:TdSingleM2 ) :TdSingleM2;
begin
     // _11 _12    _11 _12
     // _21 _22 × _21 _22

     with Result do
     begin
          _11 := A_._11 * B_._11 + A_._12 * B_._21;
          _12 := A_._11 * B_._12 + A_._12 * B_._22;

          _21 := A_._21 * B_._11 + A_._22 * B_._21;
          _22 := A_._21 * B_._12 + A_._22 * B_._22;
     end
end;

class operator TdSingleM2.Multiply( const A_:TdSingleM2; const B_:TdSingle ) :TdSingleM2;
begin
     with Result do
     begin
          _11 := A_._11 * B_;  _12 := A_._12 * B_;
          _21 := A_._21 * B_;  _22 := A_._22 * B_;
     end
end;

class operator TdSingleM2.Multiply( const A_:TdSingle; const B_:TdSingleM2 ) :TdSingleM2;
begin
     with Result do
     begin
          _11 := A_ * B_._11;  _12 := A_ * B_._12;
          _21 := A_ * B_._21;  _22 := A_ * B_._22;
     end
end;

class operator TdSingleM2.Multiply( const A_:TdSingle2D; const B_:TdSingleM2 ) :TdSingle2D;
begin
     {
               _11 _12
        X Y × _21 _22
     }

     with Result do
     begin
          X := A_.X * B_._11 + A_.Y * B_._21;
          Y := A_.X * B_._12 + A_.Y * B_._22;
     end
end;

class operator TdSingleM2.Multiply( const A_:TdSingleM2; const B_:TdSingle2D ) :TdSingle2D;
begin
     {
       _11 _12    X
       _21 _22 × Y
     }

     with Result do
     begin
          X := A_._11 * B_.X + A_._12 * B_.Y;
          Y := A_._21 * B_.X + A_._22 * B_.Y;
     end
end;

class operator TdSingleM2.Divide( const A_:TdSingleM2; const B_:TdSingle ) :TdSingleM2;
begin
     with Result do
     begin
          _11 := A_._11 / B_;  _12 := A_._12 / B_;
          _21 := A_._21 / B_;  _22 := A_._22 / B_;
     end
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TdSingleM2.Det :TdSingle;
begin
     Result := _11 * _22 - _21 * _12;
end;

function TdSingleM2.Adjugate :TdSingleM2;
begin
     Result._11 := +_22;  Result._12 := -_12;
     Result._21 := -_21;  Result._22 := +_11;
end;

function TdSingleM2.Inverse :TdSingleM2;
begin
     Result := Adjugate / Det;
end;

//------------------------------------------------------------------------------

class function TdSingleM2.Rotate( const Angle_:TdSingle ) :TdSingleM2;
var
   S, C :TdSingle;
begin
     SinCos( Angle_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 := -S;
          _21 := +S;  _22 :=  C;
     end
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDoubleM2

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdDoubleM2.Gets( const Y_,X_:Integer ) :TdDouble;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TdDoubleM2.Sets( const Y_,X_:Integer; const M_:TdDouble );
begin
     _2D[ X_-1, Y_-1 ] := M_;
end;

//------------------------------------------------------------------------------

function TdDoubleM2.GetAxisX :TdDouble2D;
begin
     with Result do
     begin
          X := _11; {X := _12;}
          Y := _21; {Y := _22;}
     end;
end;

procedure TdDoubleM2.SetAxisX( const AxisX_:TdDouble2D );
begin
     with AxisX_ do
     begin
          _11 := X; {_12 := X;}
          _21 := Y; {_22 := Y;}
     end;
end;

function TdDoubleM2.GetAxisY :TdDouble2D;
begin
     with Result do
     begin
         {X := _11;} X := _12;
         {Y := _21;} Y := _22;
     end;
end;

procedure TdDoubleM2.SetAxisY( const AxisY_:TdDouble2D );
begin
     with AxisY_ do
     begin
         {_11 := X;} _12 := X;
         {_21 := Y;} _22 := Y;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdDoubleM2.Create( const _11_,_12_, _21_,_22_:TdDouble );
begin
     _11 := _11_;  _12 := _12_;
     _21 := _21_;  _22 := _22_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdDoubleM2.Positive( const V_:TdDoubleM2 ) :TdDoubleM2;
begin
     with Result do
     begin
          _11 := +V_._11;  _12 := +V_._12;
          _21 := +V_._21;  _22 := +V_._22;
     end
end;

class operator TdDoubleM2.Negative( const V_:TdDoubleM2 ) :TdDoubleM2;
begin
     with Result do
     begin
          _11 := -V_._11;  _12 := -V_._12;
          _21 := -V_._21;  _22 := -V_._22;
     end
end;

class operator TdDoubleM2.Add( const A_,B_:TdDoubleM2 ) :TdDoubleM2;
begin
     with Result do
     begin
          _11 := A_._11 + B_._11;  _12 := A_._12 + B_._12;
          _21 := A_._21 + B_._21;  _22 := A_._22 + B_._22;
     end
end;

class operator TdDoubleM2.Subtract( const A_,B_:TdDoubleM2 ) :TdDoubleM2;
begin
     with Result do
     begin
          _11 := A_._11 - B_._11;  _12 := A_._12 - B_._12;
          _21 := A_._21 - B_._21;  _22 := A_._22 - B_._22;
     end
end;

class operator TdDoubleM2.Multiply( const A_,B_:TdDoubleM2 ) :TdDoubleM2;
begin
     // _11 _12    _11 _12
     // _21 _22 × _21 _22

     with Result do
     begin
          _11 := A_._11 * B_._11 + A_._12 * B_._21;
          _12 := A_._11 * B_._12 + A_._12 * B_._22;

          _21 := A_._21 * B_._11 + A_._22 * B_._21;
          _22 := A_._21 * B_._12 + A_._22 * B_._22;
     end
end;

class operator TdDoubleM2.Multiply( const A_:TdDoubleM2; const B_:TdDouble ) :TdDoubleM2;
begin
     with Result do
     begin
          _11 := A_._11 * B_;  _12 := A_._12 * B_;
          _21 := A_._21 * B_;  _22 := A_._22 * B_;
     end
end;

class operator TdDoubleM2.Multiply( const A_:TdDouble; const B_:TdDoubleM2 ) :TdDoubleM2;
begin
     with Result do
     begin
          _11 := A_ * B_._11;  _12 := A_ * B_._12;
          _21 := A_ * B_._21;  _22 := A_ * B_._22;
     end
end;

class operator TdDoubleM2.Multiply( const A_:TdDouble2D; const B_:TdDoubleM2 ) :TdDouble2D;
begin
     {
               _11 _12
        X Y × _21 _22
     }

     with Result do
     begin
          X := A_.X * B_._11 + A_.Y * B_._21;
          Y := A_.X * B_._12 + A_.Y * B_._22;
     end
end;

class operator TdDoubleM2.Multiply( const A_:TdDoubleM2; const B_:TdDouble2D ) :TdDouble2D;
begin
     {
       _11 _12    X
       _21 _22 × Y
     }

     with Result do
     begin
          X := A_._11 * B_.X + A_._12 * B_.Y;
          Y := A_._21 * B_.X + A_._22 * B_.Y;
     end
end;

class operator TdDoubleM2.Divide( const A_:TdDoubleM2; const B_:TdDouble ) :TdDoubleM2;
begin
     with Result do
     begin
          _11 := A_._11 / B_;  _12 := A_._12 / B_;
          _21 := A_._21 / B_;  _22 := A_._22 / B_;
     end
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TdDoubleM2.Det :TdDouble;
begin
     Result := _11 * _22 - _21 * _12;
end;

function TdDoubleM2.Adjugate :TdDoubleM2;
begin
     Result._11 := +_22;  Result._12 := -_12;
     Result._21 := -_21;  Result._22 := +_11;
end;

function TdDoubleM2.Inverse :TdDoubleM2;
begin
     Result := Adjugate / Det;
end;

//------------------------------------------------------------------------------

class function TdDoubleM2.Rotate( const Angle_:TdDouble ) :TdDoubleM2;
var
   S, C :TdDouble;
begin
     SinCos( Angle_, S, C );

     with Result do
     begin
          _11 :=  C;  _12 := -S;
          _21 := +S;  _22 :=  C;
     end
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
