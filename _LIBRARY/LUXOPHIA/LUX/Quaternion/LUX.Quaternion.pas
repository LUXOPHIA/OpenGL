unit LUX.Quaternion;

interface //#################################################################### Å°

uses LUX.D3, LUX.D4x4;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$Åy T Y P E Åz

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$Åy R E C O R D Åz

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleQ

     TSingleQ = record
     private
       ///// A C C E S S O R
       function GetX :Single;
       procedure SetX( const X_:Single );
       function GetY :Single;
       procedure SetY( const Y_:Single );
       function GetZ :Single;
       procedure SetZ( const Z_:Single );
       function GetSiz2 :Single;
       function GetSize :Single;
       function GetInv :TSingleQ;
       function GetConj :TSingleQ;
       function GetUnitor :TSingleQ;
     public
       R :Single;
       I :TSingle3D;
       /////
       constructor Create( const R_,X_,Y_,Z_:Single ); overload;
       constructor Create( const R_:Single; const I_:TSingle3D ); overload;
       ///// P R O P E R T Y
       property X      :Single   read GetX      write SetX;
       property Y      :Single   read GetY      write SetY;
       property Z      :Single   read GetZ      write SetZ;
       property Siz2   :Single   read GetSiz2             ;
       property Size   :Single   read GetSize             ;
       property Inv    :TSingleQ read GetInv              ;
       property Conj   :TSingleQ read GetConj             ;
       property Unitor :TSingleQ read GetUnitor           ;
       ///// O P E R A T O R
       class operator Positive( const Q_:TSingleQ ) :TSingleQ;
       class operator Negative( const Q_:TSingleQ ) :TSingleQ;
       class operator Add( const A_,B_:TSingleQ ) :TSingleQ;
       class operator Subtract( const A_,B_:TSingleQ ) :TSingleQ;
       class operator Multiply( const A_,B_:TSingleQ ) :TSingleQ;
       class operator Multiply( const A_:Single; const B_:TSingleQ ) :TSingleQ;
       class operator Divide( const A_,B_:TSingleQ ) :TSingleQ;
       class operator Divide( const A_:TSingleQ; const B_:Single ) :TSingleQ;
       ///// C A S T
       class operator Implicit( const R_:Single ) :TSingleQ;
       class operator Implicit( const M_:TSingleM4 ) :TSingleQ;
       class operator Implicit( const Q_:TSingleQ ) :TSingleM4;
       ///// M E T H O D
       class function Rotate( const V_:TSingle3D; const T_:Single ) :TSingleQ; overload; static;
       class function Rotate( const V0_,V1_:TSingle3D; const T_:Single = 1 ) :TSingleQ; overload; static;
       function Trans( const V_:TSingle3D ) :TSingle3D;
       function Normalize :Boolean;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleQ

     TDoubleQ = record
     private
       ///// A C C E S S O R
       function GetX :Double;
       procedure SetX( const X_:Double );
       function GetY :Double;
       procedure SetY( const Y_:Double );
       function GetZ :Double;
       procedure SetZ( const Z_:Double );
       function GetSiz2 :Double;
       function GetSize :Double;
       function GetInv :TDoubleQ;
       function GetConj :TDoubleQ;
       function GetUnitor :TDoubleQ;
     public
       R :Double;
       I :TDouble3D;
       /////
       constructor Create( const R_,X_,Y_,Z_:Double ); overload;
       constructor Create( const R_:Double; const I_:TDouble3D ); overload;
       ///// P R O P E R T Y
       property X      :Double   read GetX    write SetX;
       property Y      :Double   read GetY    write SetY;
       property Z      :Double   read GetZ    write SetZ;
       property Siz2   :Double   read GetSiz2           ;
       property Size   :Double   read GetSize           ;
       property Inv    :TDoubleQ read GetInv            ;
       property Conj   :TDoubleQ read GetConj           ;
       property Unitor :TDoubleQ read GetUnitor         ;
       ///// O P E R A T O R
       class operator Positive( const Q_:TDoubleQ ) :TDoubleQ;
       class operator Negative( const Q_:TDoubleQ ) :TDoubleQ;
       class operator Add( const A_,B_:TDoubleQ ) :TDoubleQ;
       class operator Subtract( const A_,B_:TDoubleQ ) :TDoubleQ;
       class operator Multiply( const A_,B_:TDoubleQ ) :TDoubleQ;
       class operator Multiply( const A_:Double; const B_:TDoubleQ ) :TDoubleQ;
       class operator Divide( const A_,B_:TDoubleQ ) :TDoubleQ;
       class operator Divide( const A_:TDoubleQ; const B_:Double ) :TDoubleQ;
       ///// C A S T
       class operator Implicit( const R_:Double ) :TDoubleQ;
       class operator Implicit( const M_:TDoubleM4 ) :TDoubleQ;
       class operator Implicit( const Q_:TDoubleQ ) :TDoubleM4;
       class operator Implicit( const Q_:TSingleQ ) :TDoubleQ;
       class operator Explicit( const Q_:TDoubleQ ) :TSingleQ;
       ///// M E T H O D
       class function Rotate( const V_:TDouble3D; const T_:Double ) :TDoubleQ; overload; static;
       class function Rotate( const V0_,V1_:TDouble3D; const T_:Double = 1 ) :TDoubleQ; overload; static;
       function Trans( const V_:TDouble3D ) :TDouble3D;
       function Normalize :Boolean;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$Åy R O U T I N E Åz

function DotProduct( const A_,B_:TSingleQ ) :Single; overload;
function DotProduct( const A_,B_:TDoubleQ ) :Double; overload;

function CrossProduct( const A_,B_,C_:TSingleQ ) :TSingleQ; overload;
function CrossProduct( const A_,B_,C_:TDoubleQ ) :TDoubleQ; overload;

//%%%%%%%% General Function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Ave( const Q1_,Q2_:TSingleQ ) :TSingleQ; overload;
function Ave( const Q1_,Q2_:TDoubleQ ) :TDoubleQ; overload;
function Ave( const Q1_,Q2_,Q3_:TSingleQ ) :TSingleQ; overload;
function Ave( const Q1_,Q2_,Q3_:TDoubleQ ) :TDoubleQ; overload;
function Ave( const Q1_,Q2_,Q3_,Q4_:TSingleQ ) :TSingleQ; overload;
function Ave( const Q1_,Q2_,Q3_,Q4_:TDoubleQ ) :TDoubleQ; overload;

function Ln( const Q_: TSingleQ ) :TSingleQ; overload;
function Ln( const Q_: TDoubleQ ) :TDoubleQ; overload;

function Exp( const Q_: TSingleQ ) :TSingleQ; overload;
function Exp( const Q_: TDoubleQ ) :TDoubleQ; overload;

function Pow( const Q_: TSingleQ; const N_:Single ) :TSingleQ; overload;
function Pow( const Q_: TDoubleQ; const N_:Double ) :TDoubleQ; overload;

function Pows( const Qs_:TArray<TSingleQ>; const Ts_:TArray<Single> ) :TSingleQ; overload;
function Pows( const Qs_:TArray<TDoubleQ>; const Ts_:TArray<Double> ) :TDoubleQ; overload;

implementation //############################################################### Å°

uses System.Math,
     LUX;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$Åy R E C O R D Åz

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleQ

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TSingleQ.GetX :Single;
begin
     Result := I.X;
end;

procedure TSingleQ.SetX( const X_:Single );
begin
     I.X := X_;
end;

function TSingleQ.GetY :Single;
begin
     Result := I.Y;
end;

procedure TSingleQ.SetY( const Y_:Single );
begin
     I.Y := Y_;
end;

function TSingleQ.GetZ :Single;
begin
     Result := I.Z;
end;

procedure TSingleQ.SetZ( const Z_:Single );
begin
     I.Z := Z_;
end;

//------------------------------------------------------------------------------

function TSingleQ.GetSiz2 :Single;
begin
     Result := Sqr( R ) + Sqr( X ) + Sqr( Y ) + Sqr( Z );
end;

function TSingleQ.GetSize :Single;
begin
     Result := Sqrt( Siz2 );
end;

function TSingleQ.GetInv :TSingleQ;
begin
     Result := Conj / Siz2;
end;

function TSingleQ.GetConj :TSingleQ;
begin
     Result.R :=  R;
     Result.I := -I;
end;

function TSingleQ.GetUnitor :TSingleQ;
begin
     Result := Self / Size;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingleQ.Create( const R_,X_,Y_,Z_:Single );
begin
     R   := R_;
     I.X := X_;
     I.Y := Y_;
     I.Z := Z_;
end;

constructor TSingleQ.Create( const R_:Single; const I_:TSingle3D );
begin
     R := R_;
     I := I_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TSingleQ.Positive( const Q_:TSingleQ ) :TSingleQ;
begin
     with Result do
     begin
          R := +Q_.R;
          I := +Q_.I;
     end;
end;

class operator TSingleQ.Negative( const Q_:TSingleQ ) :TSingleQ;
begin
     with Result do
     begin
          R := -Q_.R;
          I := -Q_.I;
     end;
end;

class operator TSingleQ.Add( const A_,B_:TSingleQ ) :TSingleQ;
begin
     with Result do
     begin
          R := A_.R + B_.R;
          I := A_.I + B_.I;
     end;
end;

class operator TSingleQ.Subtract( const A_,B_:TSingleQ ) :TSingleQ;
begin
     with Result do
     begin
          R := A_.R - B_.R;
          I := A_.I - B_.I;
     end;
end;

class operator TSingleQ.Multiply( const A_,B_:TSingleQ ) :TSingleQ;
begin
     with Result do
     begin
          R := A_.R * B_.R - A_.X * B_.X - A_.Y * B_.Y - A_.Z * B_.Z;
          X := A_.R * B_.X + A_.X * B_.R + A_.Y * B_.Z - A_.Z * B_.Y;
          Y := A_.R * B_.Y - A_.X * B_.Z + A_.Y * B_.R + A_.Z * B_.X;
          Z := A_.R * B_.Z + A_.X * B_.Y - A_.Y * B_.X + A_.Z * B_.R;
     end;
end;

class operator TSingleQ.Multiply( const A_:Single; const B_:TSingleQ ) :TSingleQ;
begin
     with Result do
     begin
          R := A_ * B_.R;
          I := A_ * B_.I;
     end;
end;

class operator TSingleQ.Divide( const A_,B_:TSingleQ ) :TSingleQ;
begin
     Result := A_ * B_.Inv
end;

class operator TSingleQ.Divide( const A_:TSingleQ; const B_:Single ) :TSingleQ;
begin
     with Result do
     begin
          R := A_.R / B_;
          I := A_.I / B_;
     end;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TSingleQ.Implicit( const R_:Single ) :TSingleQ;
begin
     with Result do
     begin
          R := R_;
          I := TSingle3D.Create( 0 );
     end;
end;

class operator TSingleQ.Implicit( const M_:TSingleM4 ) :TSingleQ;
var
   T, S :Single;
begin
     with M_ do
     begin
          T := _11 + _22 + _33;

          if SINGLE_EPS3 < T + 1 then
          begin
               Result.R := Sqrt( T + 1 ) / 2;

               S := 4 * Result.R;
               Result.X := ( _32 - _23 ) / S;
               Result.Y := ( _13 - _31 ) / S;
               Result.Z := ( _21 - _12 ) / S;
          end
          else
          begin
               case MaxI( _11, _22, _33 ) of
                 1: begin
                         Result.X := Sqrt( _11 - _22 - _33 + 1 ) / 2;

                         S := 4 * Result.X;
                         Result.R := ( _32 - _23 ) / S;
                         Result.Y := ( _12 + _21 ) / S;
                         Result.Z := ( _13 + _31 ) / S;
                    end;
                 2: begin
                         Result.Y := Sqrt( _22 - _33 - _11 + 1 ) / 2;

                         S := 4 * Result.Y;
                         Result.R := ( _13 - _31 ) / S;
                         Result.X := ( _12 + _21 ) / S;
                         Result.Z := ( _23 + _32 ) / S;
                    end;
                 3: begin
                         Result.Z := Sqrt( _33 - _11 - _22 + 1 ) / 2;

                         S := 4 * Result.Z;
                         Result.R := ( _21 - _12 ) / S;
                         Result.X := ( _31 + _13 ) / S;
                         Result.Y := ( _32 + _23 ) / S;
                    end;
               end;
          end;
     end;
end;

class operator TSingleQ.Implicit( const Q_:TSingleQ ) :TSingleM4;
var
   RR, XX, YY, ZZ,
   YZ, ZX, XY,
   RX, RY, RZ :Single;
begin
     with Q_ do
     begin
          RR := R * R;
          XX := X * X;  YY := Y * Y;  ZZ := Z * Z;
          YZ := Y * Z;  ZX := X * Z;  XY := X * Y;
          RX := R * X;  RY := R * Y;  RZ := R * Z;
     end;

     with Result do
     begin
          _11 := RR + XX - YY - ZZ;
          _21 := 2 * ( XY + RZ );
          _31 := 2 * ( ZX - RY );
          _41 := 0;

          _12 := 2 * ( XY - RZ );
          _22 := RR - XX + YY - ZZ;
          _32 := 2 * ( YZ + RX );
          _42 := 0;

          _13 := 2 * ( ZX + RY );
          _23 := 2 * ( YZ - RX );
          _33 := RR - XX - YY + ZZ;
          _43 := 0;

          _14 := 0;
          _24 := 0;
          _34 := 0;
          _44 := 1;
     end;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

class function TSingleQ.Rotate( const V_:TSingle3D; const T_:Single ) :TSingleQ;
var
   T :Single;
begin
     T := T_ / 2;

     Result.R :=      Cos( T );
     Result.I := V_ * Sin( T );
end;

class function TSingleQ.Rotate( const V0_,V1_:TSingle3D; const T_:Single = 1 ) :TSingleQ;
var
   C :Single;
   E, A :TSingle3D;
begin
     C := DotProduct( V0_.Unitor, V1_.Unitor );

     if 1-SINGLE_EPS3 < C then Result := 1
     else
     if C < SINGLE_EPS3-1 then
     begin
          case MinI( Abs( V0_.X ), Abs( V0_.Y ), Abs( V0_.Z ) ) of
            1: E := TSingle3D.IdentityX;
            2: E := TSingle3D.IdentityY;
            3: E := TSingle3D.IdentityZ;
          end;

          A := CrossProduct( V0_, E ).Unitor;

          Result := Rotate( A, T_ * Pi );
     end
     else
     begin
          A := CrossProduct( V0_, V1_ ).Unitor;

          Result := Rotate( A, T_ * ArcCos( C ) );
     end;
end;

//------------------------------------------------------------------------------

function TSingleQ.Trans( const V_:TSingle3D ) :TSingle3D;
begin
     Result := ( Self * TSingleQ.Create( 0, V_ ) * Self.Inv ).I;
end;

//------------------------------------------------------------------------------

function TSingleQ.Normalize :Boolean;
var
   L :Single;
begin
     L := Size;

     Result := ( SINGLE_EPS3 < L );

     if Result then Self := Self / L;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleQ

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TDoubleQ.GetX :Double;
begin
     Result := I.X;
end;

procedure TDoubleQ.SetX( const X_:Double );
begin
     I.X := X_;
end;

function TDoubleQ.GetY :Double;
begin
     Result := I.Y;
end;

procedure TDoubleQ.SetY( const Y_:Double );
begin
     I.Y := Y_;
end;

function TDoubleQ.GetZ :Double;
begin
     Result := I.Z;
end;

procedure TDoubleQ.SetZ( const Z_:Double );
begin
     I.Z := Z_;
end;

//------------------------------------------------------------------------------

function TDoubleQ.GetSiz2 :Double;
begin
     Result := Sqr( R ) + Sqr( X ) + Sqr( Y ) + Sqr( Z );
end;

function TDoubleQ.GetSize :Double;
begin
     Result := Sqrt( Siz2 );
end;

function TDoubleQ.GetInv :TDoubleQ;
begin
     Result := Conj / Siz2;
end;

function TDoubleQ.GetConj :TDoubleQ;
begin
     Result.R :=  R;
     Result.I := -I;
end;

function TDoubleQ.GetUnitor :TDoubleQ;
begin
     Result := Self / Size;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDoubleQ.Create( const R_,X_,Y_,Z_:Double );
begin
     R   := R_;
     I.X := X_;
     I.Y := Y_;
     I.Z := Z_;
end;

constructor TDoubleQ.Create( const R_:Double; const I_:TDouble3D );
begin
     R := R_;
     I := I_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TDoubleQ.Positive( const Q_:TDoubleQ ) :TDoubleQ;
begin
     with Result do
     begin
          R := +Q_.R;
          I := +Q_.I;
     end;
end;

class operator TDoubleQ.Negative( const Q_:TDoubleQ ) :TDoubleQ;
begin
     with Result do
     begin
          R := -Q_.R;
          I := -Q_.I;
     end;
end;

class operator TDoubleQ.Add( const A_,B_:TDoubleQ ) :TDoubleQ;
begin
     with Result do
     begin
          R := A_.R + B_.R;
          I := A_.I + B_.I;
     end;
end;

class operator TDoubleQ.Subtract( const A_,B_:TDoubleQ ) :TDoubleQ;
begin
     with Result do
     begin
          R := A_.R - B_.R;
          I := A_.I - B_.I;
     end;
end;

class operator TDoubleQ.Multiply( const A_,B_:TDoubleQ ) :TDoubleQ;
begin
     with Result do
     begin
          R := A_.R * B_.R - A_.X * B_.X - A_.Y * B_.Y - A_.Z * B_.Z;
          X := A_.R * B_.X + A_.X * B_.R + A_.Y * B_.Z - A_.Z * B_.Y;
          Y := A_.R * B_.Y - A_.X * B_.Z + A_.Y * B_.R + A_.Z * B_.X;
          Z := A_.R * B_.Z + A_.X * B_.Y - A_.Y * B_.X + A_.Z * B_.R;
     end;
end;

class operator TDoubleQ.Multiply( const A_:Double; const B_:TDoubleQ ) :TDoubleQ;
begin
     with Result do
     begin
          R := A_ * B_.R;
          I := A_ * B_.I;
     end;
end;

class operator TDoubleQ.Divide( const A_,B_:TDoubleQ ) :TDoubleQ;
begin
     Result := A_ * B_.Inv
end;

class operator TDoubleQ.Divide( const A_:TDoubleQ; const B_:Double ) :TDoubleQ;
begin
     with Result do
     begin
          R := A_.R / B_;
          I := A_.I / B_;
     end;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TDoubleQ.Implicit( const R_:Double ) :TDoubleQ;
begin
     with Result do
     begin
          R := R_;
          I := TDouble3D.Create( 0 );
     end;
end;

class operator TDoubleQ.Implicit( const M_:TDoubleM4 ) :TDoubleQ;
var
   T, S :Double;
begin
     with M_ do
     begin
          T := _11 + _22 + _33;

          if DOUBLE_EPS3 < T + 1 then
          begin
               Result.R := Sqrt( T + 1 ) / 2;

               S := 4 * Result.R;
               Result.X := ( _32 - _23 ) / S;
               Result.Y := ( _13 - _31 ) / S;
               Result.Z := ( _21 - _12 ) / S;
          end
          else
          begin
               case MaxI( _11, _22, _33 ) of
                 1: begin
                         Result.X := Sqrt( _11 - _22 - _33 + 1 ) / 2;

                         S := 4 * Result.X;
                         Result.R := ( _32 - _23 ) / S;
                         Result.Y := ( _12 + _21 ) / S;
                         Result.Z := ( _13 + _31 ) / S;
                    end;
                 2: begin
                         Result.Y := Sqrt( _22 - _33 - _11 + 1 ) / 2;

                         S := 4 * Result.Y;
                         Result.R := ( _13 - _31 ) / S;
                         Result.X := ( _12 + _21 ) / S;
                         Result.Z := ( _23 + _32 ) / S;
                    end;
                 3: begin
                         Result.Z := Sqrt( _33 - _11 - _22 + 1 ) / 2;

                         S := 4 * Result.Z;
                         Result.R := ( _21 - _12 ) / S;
                         Result.X := ( _31 + _13 ) / S;
                         Result.Y := ( _32 + _23 ) / S;
                    end;
               end;
          end;
     end;
end;

class operator TDoubleQ.Implicit( const Q_:TDoubleQ ) :TDoubleM4;
var
   RR, XX, YY, ZZ,
   YZ, ZX, XY,
   RX, RY, RZ :Double;
begin
     with Q_ do
     begin
          RR := R * R;
          XX := X * X;  YY := Y * Y;  ZZ := Z * Z;
          YZ := Y * Z;  ZX := X * Z;  XY := X * Y;
          RX := R * X;  RY := R * Y;  RZ := R * Z;
     end;

     with Result do
     begin
          _11 := RR + XX - YY - ZZ;
          _21 := 2 * ( XY + RZ );
          _31 := 2 * ( ZX - RY );
          _41 := 0;

          _12 := 2 * ( XY - RZ );
          _22 := RR - XX + YY - ZZ;
          _32 := 2 * ( YZ + RX );
          _42 := 0;

          _13 := 2 * ( ZX + RY );
          _23 := 2 * ( YZ - RX );
          _33 := RR - XX - YY + ZZ;
          _43 := 0;

          _14 := 0;
          _24 := 0;
          _34 := 0;
          _44 := 1;
     end;
end;

class operator TDoubleQ.Implicit( const Q_:TSingleQ ) :TDoubleQ;
begin
     Result.R := Q_.R;
     Result.I := Q_.I;
end;

class operator TDoubleQ.Explicit( const Q_:TDoubleQ ) :TSingleQ;
begin
     Result.R := Q_.R;
     Result.I := Q_.I;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

class function TDoubleQ.Rotate( const V_:TDouble3D; const T_:Double ) :TDoubleQ;
var
   T :Double;
begin
     T := T_ / 2;

     Result.R :=      Cos( T );
     Result.I := V_ * Sin( T );
end;

class function TDoubleQ.Rotate( const V0_,V1_:TDouble3D; const T_:Double = 1 ) :TDoubleQ;
var
   C :Double;
   E, A :TDouble3D;
begin
     C := DotProduct( V0_.Unitor, V1_.Unitor );

     if 1-DOUBLE_EPS3 < C then Result := 1
     else
     if C < DOUBLE_EPS3-1 then
     begin
          case MinI( Abs( V0_.X ), Abs( V0_.Y ), Abs( V0_.Z ) ) of
            1: E := TDouble3D.IdentityX;
            2: E := TDouble3D.IdentityY;
            3: E := TDouble3D.IdentityZ;
          end;

          A := CrossProduct( V0_, E ).Unitor;

          Result := Rotate( A, T_ * Pi );
     end
     else
     begin
          A := CrossProduct( V0_, V1_ ).Unitor;

          Result := Rotate( A, T_ * ArcCos( C ) );
     end;
end;

//------------------------------------------------------------------------------

function TDoubleQ.Trans( const V_:TDouble3D ) :TDouble3D;
begin
     Result := ( Self * TDoubleQ.Create( 0, V_ ) * Self.Inv ).I;
end;

//------------------------------------------------------------------------------

function TDoubleQ.Normalize :Boolean;
var
   L :Double;
begin
     L := Size;

     Result := ( DOUBLE_EPS3 < L );

     if Result then Self := Self / L;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$Åy R O U T I N E Åz

function DotProduct( const A_,B_:TSingleQ ) :Single;
begin
     Result := A_.R * B_.R + A_.X * B_.X + A_.Y * B_.Y + A_.Z * B_.Z;
end;

function DotProduct( const A_,B_:TDoubleQ ) :Double;
begin
     Result := A_.R * B_.R + A_.X * B_.X + A_.Y * B_.Y + A_.Z * B_.Z;
end;

//------------------------------------------------------------------------------

function CrossProduct( const A_,B_,C_:TSingleQ ) :TSingleQ;
begin
     with Result do
     begin
          R := A_.Z * B_.Y * C_.X - A_.X * B_.Y * C_.Z
             + B_.Z * C_.Y * A_.X - B_.X * C_.Y * A_.Z
             + C_.Z * A_.Y * B_.X - C_.X * A_.Y * B_.Z;

          X := A_.Y * B_.Z * C_.R - A_.R * B_.Z * C_.Y
             + B_.Y * C_.Z * A_.R - B_.R * C_.Z * A_.Y
             + C_.Y * A_.Z * B_.R - C_.R * A_.Z * B_.Y;

          Y := A_.X * B_.R * C_.Z - A_.Z * B_.R * C_.X
             + B_.X * C_.R * A_.Z - B_.Z * C_.R * A_.X
             + C_.X * A_.R * B_.Z - C_.Z * A_.R * B_.X;

          Z := A_.R * B_.X * C_.Y - A_.Y * B_.X * C_.R
             + B_.R * C_.X * A_.Y - B_.Y * C_.X * A_.R
             + C_.R * A_.X * B_.Y - C_.Y * A_.X * B_.R;
     end;
end;

function CrossProduct( const A_,B_,C_:TDoubleQ ) :TDoubleQ;
begin
     with Result do
     begin
          R := A_.Z * B_.Y * C_.X - A_.X * B_.Y * C_.Z
             + B_.Z * C_.Y * A_.X - B_.X * C_.Y * A_.Z
             + C_.Z * A_.Y * B_.X - C_.X * A_.Y * B_.Z;

          X := A_.Y * B_.Z * C_.R - A_.R * B_.Z * C_.Y
             + B_.Y * C_.Z * A_.R - B_.R * C_.Z * A_.Y
             + C_.Y * A_.Z * B_.R - C_.R * A_.Z * B_.Y;

          Y := A_.X * B_.R * C_.Z - A_.Z * B_.R * C_.X
             + B_.X * C_.R * A_.Z - B_.Z * C_.R * A_.X
             + C_.X * A_.R * B_.Z - C_.Z * A_.R * B_.X;

          Z := A_.R * B_.X * C_.Y - A_.Y * B_.X * C_.R
             + B_.R * C_.X * A_.Y - B_.Y * C_.X * A_.R
             + C_.R * A_.X * B_.Y - C_.Y * A_.X * B_.R;
     end;
end;

//------------------------------------------------------------------------------

function Ave( const Q1_,Q2_:TSingleQ ) :TSingleQ;
begin
     Result := ( Q1_ + Q2_ ) / 2;
end;

function Ave( const Q1_,Q2_:TDoubleQ ) :TDoubleQ;
begin
     Result := ( Q1_ + Q2_ ) / 2;
end;

function Ave( const Q1_,Q2_,Q3_:TDoubleQ ) :TDoubleQ;
begin
     Result := ( Q1_ + Q2_ + Q3_ ) / 3;
end;

function Ave( const Q1_,Q2_,Q3_:TSingleQ ) :TSingleQ;
begin
     Result := ( Q1_ + Q2_ + Q3_ ) / 3;
end;

function Ave( const Q1_,Q2_,Q3_,Q4_:TSingleQ ) :TSingleQ;
begin
     Result := ( Q1_ + Q2_ + Q3_ + Q4_ ) / 4;
end;

function Ave( const Q1_,Q2_,Q3_,Q4_:TDoubleQ ) :TDoubleQ;
begin
     Result := ( Q1_ + Q2_ + Q3_ + Q4_ ) / 4;
end;

//------------------------------------------------------------------------------

function Ln( const Q_:TSingleQ ) :TSingleQ;
var
   A, L, T :Single;
begin
     A := Q_.Size;

     Result.R := Ln( A );

     L := Q_.I.Size;

     if Abs( L ) < SINGLE_EPS3 then Result.I := 0
     else
     begin
          T := ArcTan2( L, Q_.R );

          Result.I := T * Q_.I / L;
     end;
end;

function Ln( const Q_:TDoubleQ ) :TDoubleQ;
var
   A, L, T :Double;
begin
     A := Q_.Size;

     Result.R := Ln( A );

     L := Q_.I.Size;

     if Abs( L ) < DOUBLE_EPS3 then Result.I := 0
     else
     begin
          T := ArcTan2( L, Q_.R );

          Result.I := T * Q_.I / L;
     end;
end;

//------------------------------------------------------------------------------

function Exp( const Q_:TSingleQ ) :TSingleQ;
var
   L2, L, E, C, S: Single;
begin
     L2 := Q_.I.Size2;

     E := Exp( Q_.R );

     if Abs( L2 ) < SINGLE_EPS3 then
     begin
          Result.R := E * ( 1 - L2 / 2 );
          Result.I := E * Q_.I;
     end
     else
     begin
          L := Sqrt( L2 );

          C := Cos( L );  S := Sin( L );

          Result.R := E * C;
          Result.I := E * S / L * Q_.I;
     end;
end;

function Exp( const Q_:TDoubleQ ) :TDoubleQ;
var
   L2, L, E, C, S: Double;
begin
     L2 := Q_.I.Size2;

     E := Exp( Q_.R );

     if Abs( L2 ) < DOUBLE_EPS3 then
     begin
          Result.R := E * ( 1 - L2 / 2 );
          Result.I := E * Q_.I;
     end
     else
     begin
          L := Sqrt( L2 );

          C := Cos( L );  S := Sin( L );

          Result.R := E * C;
          Result.I := E * S / L * Q_.I;
     end;
end;

//------------------------------------------------------------------------------

function Pow( const Q_: TSingleQ; const N_:Single ) :TSingleQ;
begin
     Result := Exp( N_ * Ln( Q_ ) );
end;

function Pow( const Q_: TDoubleQ; const N_:Double ) :TDoubleQ;
begin
     Result := Exp( N_ * Ln( Q_ ) );
end;

//------------------------------------------------------------------------------

function Pows( const Qs_:TArray<TSingleQ>; const Ts_:TArray<Single> ) :TSingleQ;
var
   I :Integer;
begin
     Result := 0;

     for I := 0 to High( Qs_ ) do Result := Result + Ts_[ I ] * Ln( Qs_[ I ] );

     Result := Exp( Result );
end;

function Pows( const Qs_:TArray<TDoubleQ>; const Ts_:TArray<Double> ) :TDoubleQ;
var
   I :Integer;
begin
     Result := 0;

     for I := 0 to High( Qs_ ) do Result := Result + Ts_[ I ] * Ln( Qs_[ I ] );

     Result := Exp( Result );
end;

end. //######################################################################### Å°
