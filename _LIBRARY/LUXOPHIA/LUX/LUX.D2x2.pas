unit LUX.D2x2;

interface //#################################################################### ■

uses LUX, LUX.D2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleM2

     TSingleM2 = record
     private
       ///// A C C E S S O R
       function GetD2( const Y_,X_:Integer ) :Single;
       procedure SetD2( const Y_,X_:Integer; const D2_:Single );
     public
       constructor Create( const _11_,_12_,
                                 _21_,_22_:Single );
       ///// P R O P E R T Y
       property D2[ const Y_,X_:Integer ] :Single read GetD2 write SetD2; default;
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
       ///// C A S T
       class operator Implicit( const V_:Single ) :TSingleM2;
       ///// M E T H O D
       function Transpose :TSingleM2;
       function Det :Single;
       function Adjugate :TSingleM2;
       function Inverse :TSingleM2;
       ///// C O N S T A N T
       class function Identity :TSingleM2; static;
       ///// F I E L D
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
       function GetD2( const Y_,X_:Integer ) :Double;
       procedure SetD2( const Y_,X_:Integer; const D2_:Double );
     public
       constructor Create( const _11_,_12_,
                                 _21_,_22_:Double );
       ///// P R O P E R T Y
       property D2[ const Y_,X_:Integer ] :Double read GetD2 write SetD2; default;
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
       ///// C A S T
       class operator Implicit( const V_:Double ) :TDoubleM2;
       class operator Implicit( const V_:TSingleM2 ) :TDoubleM2;
       class operator Explicit( const V_:TDoubleM2 ) :TSingleM2;
       ///// M E T H O D
       function Transpose :TDoubleM2;
       function Det :Double;
       function Adjugate :TDoubleM2;
       function Inverse :TDoubleM2;
       ///// C O N S T A N T
       class function Identity :TDoubleM2; static;
       ///// F I E L D
     case Byte of
       0: ( _1D :array [ 0..2*2-1       ] of Double; );
       1: ( _2D :array [ 0..2-1, 0..2-1 ] of Double; );
       2: ( _11, _21,
            _12, _22 :Double;                        );
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleM2

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TSingleM2.GetD2( const Y_,X_:Integer ) :Single;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TSingleM2.SetD2( const Y_,X_:Integer; const D2_:Single );
begin
     _2D[ X_-1, Y_-1 ] := D2_;
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
     end;
end;

class operator TSingleM2.Negative( const V_:TSingleM2 ) :TSingleM2;
begin
     with Result do
     begin
          _11 := -V_._11;  _12 := -V_._12;
          _21 := -V_._21;  _22 := -V_._22;
     end;
end;

class operator TSingleM2.Add( const A_,B_:TSingleM2 ) :TSingleM2;
begin
     with Result do
     begin
          _11 := A_._11 + B_._11;  _12 := A_._12 + B_._12;
          _21 := A_._21 + B_._21;  _22 := A_._22 + B_._22;
     end;
end;

class operator TSingleM2.Subtract( const A_,B_:TSingleM2 ) :TSingleM2;
begin
     with Result do
     begin
          _11 := A_._11 - B_._11;  _12 := A_._12 - B_._12;
          _21 := A_._21 - B_._21;  _22 := A_._22 - B_._22;
     end;
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
     end;
end;

class operator TSingleM2.Multiply( const A_:TSingleM2; const B_:Single ) :TSingleM2;
begin
     with Result do
     begin
          _11 := A_._11 * B_;  _12 := A_._12 * B_;
          _21 := A_._21 * B_;  _22 := A_._22 * B_;
     end;
end;

class operator TSingleM2.Multiply( const A_:Single; const B_:TSingleM2 ) :TSingleM2;
begin
     with Result do
     begin
          _11 := A_ * B_._11;  _12 := A_ * B_._12;
          _21 := A_ * B_._21;  _22 := A_ * B_._22;
     end;
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
     end;
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
     end;
end;

class operator TSingleM2.Divide( const A_:TSingleM2; const B_:Single ) :TSingleM2;
begin
     with Result do
     begin
          _11 := A_._11 / B_;  _12 := A_._12 / B_;
          _21 := A_._21 / B_;  _22 := A_._22 / B_;
     end;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TSingleM2.Implicit( const V_:Single ) :TSingleM2;
begin
     with Result do
     begin
          _11 := V_;  _12 := 0 ;
          _21 := 0 ;  _22 := V_;
     end;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TSingleM2.Transpose :TSingleM2;
begin
     Result._11 := _11;  Result._12 := _21;
     Result._21 := _12;  Result._22 := _22;
end;

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

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TSingleM2.Identity :TSingleM2;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;
          _21 := 0;  _22 := 1;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleM2

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TDoubleM2.GetD2( const Y_,X_:Integer ) :Double;
begin
     Result := _2D[ X_-1, Y_-1 ];
end;

procedure TDoubleM2.SetD2( const Y_,X_:Integer; const D2_:Double );
begin
     _2D[ X_-1, Y_-1 ] := D2_;
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
     end;
end;

class operator TDoubleM2.Negative( const V_:TDoubleM2 ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := -V_._11;  _12 := -V_._12;
          _21 := -V_._21;  _22 := -V_._22;
     end;
end;

class operator TDoubleM2.Add( const A_,B_:TDoubleM2 ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := A_._11 + B_._11;  _12 := A_._12 + B_._12;
          _21 := A_._21 + B_._21;  _22 := A_._22 + B_._22;
     end;
end;

class operator TDoubleM2.Subtract( const A_,B_:TDoubleM2 ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := A_._11 - B_._11;  _12 := A_._12 - B_._12;
          _21 := A_._21 - B_._21;  _22 := A_._22 - B_._22;
     end;
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
     end;
end;

class operator TDoubleM2.Multiply( const A_:TDoubleM2; const B_:Double ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := A_._11 * B_;  _12 := A_._12 * B_;
          _21 := A_._21 * B_;  _22 := A_._22 * B_;
     end;
end;

class operator TDoubleM2.Multiply( const A_:Double; const B_:TDoubleM2 ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := A_ * B_._11;  _12 := A_ * B_._12;
          _21 := A_ * B_._21;  _22 := A_ * B_._22;
     end;
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
     end;
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
     end;
end;

class operator TDoubleM2.Divide( const A_:TDoubleM2; const B_:Double ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := A_._11 / B_;  _12 := A_._12 / B_;
          _21 := A_._21 / B_;  _22 := A_._22 / B_;
     end;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TDoubleM2.Implicit( const V_:Double ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := V_;  _12 := 0 ;
          _21 := 0 ;  _22 := V_;
     end;
end;

class operator TDoubleM2.Implicit( const V_:TSingleM2 ) :TDoubleM2;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;
          _21 := V_._21;  _22 := V_._22;
     end;
end;

class operator TDoubleM2.Explicit( const V_:TDoubleM2 ) :TSingleM2;
begin
     with Result do
     begin
          _11 := V_._11;  _12 := V_._12;
          _21 := V_._21;  _22 := V_._22;
     end;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TDoubleM2.Transpose :TDoubleM2;
begin
     Result._11 := _11;  Result._12 := _21;
     Result._21 := _12;  Result._22 := _22;
end;

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

//////////////////////////////////////////////////////////////// C O N S T A N T

class function TDoubleM2.Identity :TDoubleM2;
begin
     with Result do
     begin
          _11 := 1;  _12 := 0;
          _21 := 0;  _22 := 1;
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
