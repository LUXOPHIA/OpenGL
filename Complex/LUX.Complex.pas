unit LUX.Complex;

interface //#################################################################### ■

uses LUX, LUX.D1;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleC

     TSingleC = record
     private
       ///// A C C E S S O R
       class function GetImaginary :TSingleC; static;
       //--------
       function GetAbs2 :Single;
       function GetAbso :Single;
       procedure SetAbso( const Abso_:Single );
       function GetUnitor :TSingleC;
       procedure SetUnitor( const Unitor_:TSingleC );
       function GetConj :TSingleC;
       procedure SetConj( const Conj_:TSingleC );
       function GetAngle :Single;
     public
       R :Single;
       I :Single;
       /////
       constructor Create( const R_:Single ); overload;
       constructor Create( const R_,I_:Single ); overload;
       ///// P R O P E R T Y
       class property Imaginary :TSingleC read GetImaginary;
       //--------
       property Abs2   :Single   read GetAbs2                  ;
       property Abso   :Single   read GetAbso   write SetAbso  ;
       property Unitor :TSingleC read GetUnitor write SetUnitor;
       property Conj   :TSingleC read GetConj   write SetConj  ;
       property Angle  :Single   read GetAngle                 ;
       ///// O P E R A T O R
       class operator Negative( const V_:TSingleC ) :TSingleC;
       class operator Positive( const V_:TSingleC ) :TSingleC;
       class operator Add( const A_,B_:TSingleC ) :TSingleC;
       class operator Subtract( const A_,B_:TSingleC ) :TSingleC;
       class operator Multiply( const A_,B_:TSingleC ) :TSingleC;
       class operator Multiply( const A_:TSingleC; const B_:Single ) :TSingleC;
       class operator Multiply( const A_:Single; const B_:TSingleC ) :TSingleC;
       class operator Divide( const A_,B_:TSingleC ) :TSingleC;
       class operator Divide( const A_:TSingleC; const B_:Single ) :TSingleC;
       ///// C A S T
       class operator Implicit( const V_:Single ) :TSingleC;
       ///// M E T H O D
       class function RandG( const SD_:Single = 1 ) :TSingleC; overload; static;
       class function RandG( const SD_:TSingleC ) :TSingleC; overload; static;
       class function RandBS1 :TSingleC; static;
       class function RandBS2 :TSingleC; static;
       class function RandBS4 :TSingleC; static;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleC

     TDoubleC = record
     private
       ///// A C C E S S O R
       class function GetImaginary :TDoubleC; static;
       //--------
       function GetAbs2 :Double;
       function GetAbso :Double;
       procedure SetAbso( const Abso_:Double );
       function GetUnitor :TDoubleC;
       procedure SetUnitor( const Unitor_:TDoubleC );
       function GetConj :TDoubleC;
       procedure SetConj( const Conj_:TDoubleC );
       function GetAngle :Double;
     public
       R :Double;
       I :Double;
       /////
       constructor Create( const R_:Double ); overload;
       constructor Create( const R_,I_:Double ); overload;
       ///// P R O P E R T Y
       class property Imaginary :TDoubleC read GetImaginary;
       //--------
       property Abs2   :Double   read GetAbs2                  ;
       property Abso   :Double   read GetAbso   write SetAbso  ;
       property Unitor :TDoubleC read GetUnitor write SetUnitor;
       property Conj   :TDoubleC read GetConj   write SetConj  ;
       property Angle  :Double   read GetAngle                 ;
       ///// O P E R A T O R
       class operator Negative( const V_:TDoubleC ) :TDoubleC;
       class operator Positive( const V_:TDoubleC ) :TDoubleC;
       class operator Add( const A_,B_:TDoubleC ) :TDoubleC;
       class operator Subtract( const A_,B_:TDoubleC ) :TDoubleC;
       class operator Multiply( const A_,B_:TDoubleC ) :TDoubleC;
       class operator Multiply( const A_:TDoubleC; const B_:Double ) :TDoubleC;
       class operator Multiply( const A_:Double; const B_:TDoubleC ) :TDoubleC;
       class operator Divide( const A_,B_:TDoubleC ) :TDoubleC;
       class operator Divide( const A_:TDoubleC; const B_:Double ) :TDoubleC;
       ///// C A S T
       class operator Implicit( const V_:Double ) :TDoubleC;
       class operator Implicit( const V_:TSingleC ) :TDoubleC;
       class operator Implicit( const V_:TDoubleC ) :TSingleC;
       ///// M E T H O D
       class function RandG( const SD_:Double = 1 ) :TDoubleC; overload; static;
       class function RandG( const SD_:TDoubleC ) :TDoubleC; overload; static;
       class function RandBS1 :TDoubleC; static;
       class function RandBS2 :TDoubleC; static;
       class function RandBS4 :TDoubleC; static;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% T*CFunc

     TSingleCFunc = reference to function ( const C_:TSingleC ) :TSingleC;
     TDoubleCFunc = reference to function ( const C_:TDoubleC ) :TDoubleC;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleAreaC

     TSingleAreaC = record
     private
       ///// A C C E S S O R
       function GetCenter :TSingleC;
       procedure SetCenter( const Center_:TSingleC );
       function GetCenterR :Single;
       procedure SetCenterR( const CenterR_:Single );
       function GetCenterI :Single;
       procedure SetCenterI( const CenterI_:Single );
       function GetSizeR :Single;
       procedure SetSizeR( const SizeR_:Single );
       function GetSizeI :Single;
       procedure SetSizeI( const SizeI_:Single );
     public
       Min :TSingleC;
       Max :TSingleC;
       /////
       constructor Create( const Min_,Max_:TSingleC ); overload;
       constructor Create( const MinR_,MinI_,MaxR_,MaxI_:Single ); overload;
       ///// P R O P E R T Y
       property Center  :TSingleC read GetCenter  write SetCenter ;
       property CenterR :Single   read GetCenterR write SetCenterR;
       property CenterI :Single   read GetCenterI write SetCenterI;
       property SizeR   :Single   read GetSizeR   write SetSizeR  ;
       property SizeI   :Single   read GetSizeI   write SetSizeI  ;
       ///// O P E R A T O R
       class operator Negative( const V_:TSingleAreaC ) :TSingleAreaC;
       class operator Positive( const V_:TSingleAreaC ) :TSingleAreaC;
       class operator Add( const A_,B_:TSingleAreaC ) :TSingleAreaC;
       class operator Subtract( const A_,B_:TSingleAreaC ) :TSingleAreaC;
       class operator Multiply( const A_:TSingleAreaC; const B_:Single ) :TSingleAreaC;
       class operator Multiply( const A_:Single; const B_:TSingleAreaC ) :TSingleAreaC;
       class operator Divide( const A_:TSingleAreaC; const B_:Single ) :TSingleAreaC;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleAreaC

     TDoubleAreaC = record
     private
       ///// A C C E S S O R
       function GetCenter :TDoubleC;
       procedure SetCenter( const Center_:TDoubleC );
       function GetCenterR :Double;
       procedure SetCenterR( const CenterR_:Double );
       function GetCenterI :Double;
       procedure SetCenterI( const CenterI_:Double );
       function GetSizeR :Double;
       procedure SetSizeR( const SizeR_:Double );
       function GetSizeI :Double;
       procedure SetSizeI( const SizeI_:Double );
     public
       Min :TDoubleC;
       Max :TDoubleC;
       /////
       constructor Create( const Min_,Max_:TDoubleC ); overload;
       constructor Create( const MinR_,MinI_,MaxR_,MaxI_:Double ); overload;
       ///// P R O P E R T Y
       property Center  :TDoubleC read GetCenter  write SetCenter ;
       property CenterR :Double   read GetCenterR write SetCenterR;
       property CenterI :Double   read GetCenterI write SetCenterI;
       property SizeR   :Double   read GetSizeR   write SetSizeR  ;
       property SizeI   :Double   read GetSizeI   write SetSizeI  ;
       ///// O P E R A T O R
       class operator Negative( const V_:TDoubleAreaC ) :TDoubleAreaC;
       class operator Positive( const V_:TDoubleAreaC ) :TDoubleAreaC;
       class operator Add( const A_,B_:TDoubleAreaC ) :TDoubleAreaC;
       class operator Subtract( const A_,B_:TDoubleAreaC ) :TDoubleAreaC;
       class operator Multiply( const A_:TDoubleAreaC; const B_:Double ) :TDoubleAreaC;
       class operator Multiply( const A_:Double; const B_:TDoubleAreaC ) :TDoubleAreaC;
       class operator Divide( const A_:TDoubleAreaC; const B_:Double ) :TDoubleAreaC;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pow

function Pow( const X_:TSingleC; const N_:Single ) :TSingleC; overload;
function Pow( const X_:TDoubleC; const N_:Double ) :TDoubleC; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Roo2

function Roo2( const X_:TSingleC ) :TSingleC; overload;
function Roo2( const X_:TDoubleC ) :TDoubleC; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cos

function Cos( const A_:TSingleC ) :TSingleC; overload;
function Cos( const A_:TDoubleC ) :TDoubleC; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sin

function Sin( const A_:TSingleC ) :TSingleC; overload;
function Sin( const A_:TDoubleC ) :TDoubleC; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Tan

function Tan( const A_:TSingleC ) :TSingleC; overload;
function Tan( const A_:TDoubleC ) :TDoubleC; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Exp

function Exp( const A_:TSingleC ) :TSingleC; overload;
function Exp( const A_:TDoubleC ) :TDoubleC; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Expi

function Expi( const X_:Single ) :TSingleC; overload;
function Expi( const X_:Double ) :TDoubleC; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ln

function Ln( const A_:TSingleC ) :TSingleC; overload;
function Ln( const A_:TDoubleC ) :TDoubleC; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ArcCos

function ArcCos( const X_:TSingleC ) :TSingleC; overload;
function ArcCos( const X_:TDoubleC ) :TDoubleC; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ArcSin

function ArcSin( const X_:TSingleC ) :TSingleC; overload;
function ArcSin( const X_:TDoubleC ) :TDoubleC; overload;

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleC

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

class function TSingleC.GetImaginary :TSingleC;
begin
     Result.R := 0;
     Result.I := 1;
end;

//------------------------------------------------------------------------------

function TSingleC.GetAbs2 :Single;
begin
     Result := Pow2( R ) + Pow2( I );
end;

function TSingleC.GetAbso :Single;
begin
     Result := Roo2( GetAbs2 );
end;

procedure TSingleC.SetAbso( const Abso_:Single );
begin
     Self := Abso_ * Unitor;
end;

function TSingleC.GetUnitor :TSingleC;
begin
     Result := Self / Abso;
end;

procedure TSingleC.SetUnitor( const Unitor_:TSingleC );
begin
     Self := Abso * Unitor_;
end;

function TSingleC.GetConj :TSingleC;
begin
     Result.R := +R;
     Result.I := -I;
end;

procedure TSingleC.SetConj( const Conj_:TSingleC );
begin
     R := +Conj_.R;
     I := -Conj_.I;
end;

function TSingleC.GetAngle :Single;
begin
     Result := ArcTan2( I, R );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingleC.Create( const R_:Single );
begin
     R := R_;
     I := 0 ;
end;

constructor TSingleC.Create( const R_,I_:Single );
begin
     R := R_;
     I := I_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TSingleC.Negative( const V_:TSingleC ) :TSingleC;
begin
     Result.R := -V_.R;
     Result.I := -V_.I;
end;

class operator TSingleC.Positive( const V_:TSingleC ) :TSingleC;
begin
     Result.R := +V_.R;
     Result.I := +V_.I;
end;

class operator TSingleC.Add( const A_,B_:TSingleC ) :TSingleC;
begin
     Result.R := A_.R + B_.R;
     Result.I := A_.I + B_.I;
end;

class operator TSingleC.Subtract( const A_,B_:TSingleC ) :TSingleC;
begin
     Result.R := A_.R - B_.R;
     Result.I := A_.I - B_.I;
end;

class operator TSingleC.Multiply( const A_,B_:TSingleC ) :TSingleC;
begin
     Result.R := A_.R * B_.R - A_.I * B_.I;
     Result.I := A_.R * B_.I + A_.I * B_.R;
end;

class operator TSingleC.Multiply( const A_:TSingleC; const B_:Single ) :TSingleC;
begin
     Result.R := A_.R * B_;
     Result.I := A_.I * B_;
end;

class operator TSingleC.Multiply( const A_:Single; const B_:TSingleC ) :TSingleC;
begin
     Result.R := A_ * B_.R;
     Result.I := A_ * B_.I;
end;

class operator TSingleC.Divide( const A_,B_:TSingleC ) :TSingleC;
var
   C :Single;
begin
     C := B_.Abs2;

     Result.R := ( A_.R * B_.R + A_.I * B_.I ) / C;
     Result.I := ( A_.I * B_.R - A_.R * B_.I ) / C;
end;

class operator TSingleC.Divide( const A_:TSingleC; const B_:Single ) :TSingleC;
begin
     Result.R := A_.R / B_;
     Result.I := A_.I / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TSingleC.Implicit( const V_:Single ) :TSingleC;
begin
     Result.R := V_;
     Result.I := 0 ;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

class function TSingleC.RandG( const SD_:Single = 1 ) :TSingleC;
begin
     Result.R := TSingle.RandG( SD_ );
     Result.I := TSingle.RandG( SD_ );
end;

class function TSingleC.RandG( const SD_:TSingleC ) :TSingleC;
begin
     Result.R := TSingle.RandG( SD_.R );
     Result.I := TSingle.RandG( SD_.I );
end;

//------------------------------------------------------------------------------

class function TSingleC.RandBS1 :TSingleC;
begin
     Result.R := TSingle.RandBS1;
     Result.I := TSingle.RandBS1;
end;

class function TSingleC.RandBS2 :TSingleC;
begin
     Result.R := TSingle.RandBS2;
     Result.I := TSingle.RandBS2;
end;

class function TSingleC.RandBS4 :TSingleC;
begin
     Result.R := TSingle.RandBS4;
     Result.I := TSingle.RandBS4;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleC

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

class function TDoubleC.GetImaginary :TDoubleC;
begin
     Result.R := 0;
     Result.I := 1;
end;

//------------------------------------------------------------------------------

function TDoubleC.GetAbs2 :Double;
begin
     Result := Pow2( R ) + Pow2( I );
end;

function TDoubleC.GetAbso :Double;
begin
     Result := Roo2( GetAbs2 );
end;

procedure TDoubleC.SetAbso( const Abso_:Double );
begin
     Self := Abso_ * Unitor;
end;

function TDoubleC.GetUnitor :TDoubleC;
begin
     Result := Self / Abso;
end;

procedure TDoubleC.SetUnitor( const Unitor_:TDoubleC );
begin
     Self := Abso * Unitor_;
end;

function TDoubleC.GetConj :TDoubleC;
begin
     Result.R := +R;
     Result.I := -I;
end;

procedure TDoubleC.SetConj( const Conj_:TDoubleC );
begin
     R := +Conj_.R;
     I := -Conj_.I;
end;

function TDoubleC.GetAngle :Double;
begin
     Result := ArcTan2( I, R );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDoubleC.Create( const R_:Double );
begin
     R := R_;
     I := 0 ;
end;

constructor TDoubleC.Create( const R_,I_:Double );
begin
     R := R_;
     I := I_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TDoubleC.Negative( const V_:TDoubleC ) :TDoubleC;
begin
     Result.R := -V_.R;
     Result.I := -V_.I;
end;

class operator TDoubleC.Positive( const V_:TDoubleC ) :TDoubleC;
begin
     Result.R := +V_.R;
     Result.I := +V_.I;
end;

class operator TDoubleC.Add( const A_,B_:TDoubleC ) :TDoubleC;
begin
     Result.R := A_.R + B_.R;
     Result.I := A_.I + B_.I;
end;

class operator TDoubleC.Subtract( const A_,B_:TDoubleC ) :TDoubleC;
begin
     Result.R := A_.R - B_.R;
     Result.I := A_.I - B_.I;
end;

class operator TDoubleC.Multiply( const A_,B_:TDoubleC ) :TDoubleC;
begin
     Result.R := A_.R * B_.R - A_.I * B_.I;
     Result.I := A_.R * B_.I + A_.I * B_.R;
end;

class operator TDoubleC.Multiply( const A_:TDoubleC; const B_:Double ) :TDoubleC;
begin
     Result.R := A_.R * B_;
     Result.I := A_.I * B_;
end;

class operator TDoubleC.Multiply( const A_:Double; const B_:TDoubleC ) :TDoubleC;
begin
     Result.R := A_ * B_.R;
     Result.I := A_ * B_.I;
end;

class operator TDoubleC.Divide( const A_,B_:TDoubleC ) :TDoubleC;
var
   C :Double;
begin
     C := B_.Abs2;

     Result.R := ( A_.R * B_.R + A_.I * B_.I ) / C;
     Result.I := ( A_.I * B_.R - A_.R * B_.I ) / C;
end;

class operator TDoubleC.Divide( const A_:TDoubleC; const B_:Double ) :TDoubleC;
begin
     Result.R := A_.R / B_;
     Result.I := A_.I / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TDoubleC.Implicit( const V_:Double ) :TDoubleC;
begin
     Result.R := V_;
     Result.I := 0 ;
end;

class operator TDoubleC.Implicit( const V_:TSingleC ) :TDoubleC;
begin
     Result.R := V_.R;
     Result.I := V_.I;
end;

class operator TDoubleC.Implicit( const V_:TDoubleC ) :TSingleC;
begin
     Result.R := V_.R;
     Result.I := V_.I;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

class function TDoubleC.RandG( const SD_:Double = 1 ) :TDoubleC;
begin
     Result.R := TDouble.RandG( SD_ );
     Result.I := TDouble.RandG( SD_ );
end;

class function TDoubleC.RandG( const SD_:TDoubleC ) :TDoubleC;
begin
     Result.R := TDouble.RandG( SD_.R );
     Result.I := TDouble.RandG( SD_.I );
end;

//------------------------------------------------------------------------------

class function TDoubleC.RandBS1 :TDoubleC;
begin
     Result.R := TDouble.RandBS1;
     Result.I := TDouble.RandBS1;
end;

class function TDoubleC.RandBS2 :TDoubleC;
begin
     Result.R := TDouble.RandBS2;
     Result.I := TDouble.RandBS2;
end;

class function TDoubleC.RandBS4 :TDoubleC;
begin
     Result.R := TDouble.RandBS4;
     Result.I := TDouble.RandBS4;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingleAreaC

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TSingleAreaC.GetCenter :TSingleC;
begin
     Result := ( Max + Min ) / 2;
end;

procedure TSingleAreaC.SetCenter( const Center_:TSingleC );
begin
     CenterR := Center_.R;
     CenterI := Center_.I;
end;

function TSingleAreaC.GetCenterR :Single;
begin
     Result := ( Max.R + Min.R ) / 2;
end;

procedure TSingleAreaC.SetCenterR( const CenterR_:Single );
var
   S :Single;
begin
     S := SizeR / 2;

     Min.R := CenterR_ - S;
     Max.R := CenterR_ + S;
end;

function TSingleAreaC.GetCenterI :Single;
begin
     Result := ( Max.I + Min.I ) / 2;
end;

procedure TSingleAreaC.SetCenterI( const CenterI_:Single );
var
   S :Single;
begin
     S := SizeI / 2;

     Min.I := CenterI_ - S;
     Max.I := CenterI_ + S;
end;

function TSingleAreaC.GetSizeR :Single;
begin
     Result := Max.R - Min.R;
end;

procedure TSingleAreaC.SetSizeR( const SizeR_:Single );
var
   C, S :Single;
begin
     C := CenterR;
     S := SizeR_ / 2;

     Min.R := C - S;
     Max.R := C + S;
end;

function TSingleAreaC.GetSizeI :Single;
begin
     Result := Max.I - Min.I;
end;

procedure TSingleAreaC.SetSizeI( const SizeI_:Single );
var
   C, S :Single;
begin
     C := CenterI;
     S := SizeI_ / 2;

     Min.I := C - S;
     Max.I := C + S;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TSingleAreaC.Create( const Min_,Max_:TSingleC );
begin
     Min := Min_;
     Max := Max_;
end;

constructor TSingleAreaC.Create( const MinR_,MinI_,MaxR_,MaxI_:Single );
begin
     Min.R := MinR_;
     Min.I := MinI_;
     Max.R := MaxR_;
     Max.I := MaxI_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TSingleAreaC.Negative( const V_:TSingleAreaC ) :TSingleAreaC;
begin
     Result.Min := -V_.Min;
     Result.Max := -V_.Max;
end;

class operator TSingleAreaC.Positive( const V_:TSingleAreaC ) :TSingleAreaC;
begin
     Result.Min := +V_.Min;
     Result.Max := +V_.Max;
end;

class operator TSingleAreaC.Add( const A_,B_:TSingleAreaC ) :TSingleAreaC;
begin
     Result.Min := A_.Min + B_.Min;
     Result.Max := A_.Max + B_.Max;
end;

class operator TSingleAreaC.Subtract( const A_,B_:TSingleAreaC ) :TSingleAreaC;
begin
     Result.Min := A_.Min - B_.Min;
     Result.Max := A_.Max - B_.Max;
end;

class operator TSingleAreaC.Multiply( const A_:TSingleAreaC; const B_:Single ) :TSingleAreaC;
begin
     Result.Min := A_.Min * B_;
     Result.Max := A_.Max * B_;
end;

class operator TSingleAreaC.Multiply( const A_:Single; const B_:TSingleAreaC ) :TSingleAreaC;
begin
     Result.Min := A_ * B_.Min;
     Result.Max := A_ * B_.Max;
end;

class operator TSingleAreaC.Divide( const A_:TSingleAreaC; const B_:Single ) :TSingleAreaC;
begin
     Result.Min := A_.Min / B_;
     Result.Max := A_.Max / B_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDoubleAreaC

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TDoubleAreaC.GetCenter :TDoubleC;
begin
     Result := ( Max + Min ) / 2;
end;

procedure TDoubleAreaC.SetCenter( const Center_:TDoubleC );
begin
     CenterR := Center_.R;
     CenterI := Center_.I;
end;

function TDoubleAreaC.GetCenterR :Double;
begin
     Result := ( Max.R + Min.R ) / 2;
end;

procedure TDoubleAreaC.SetCenterR( const CenterR_:Double );
var
   S :Double;
begin
     S := SizeR / 2;

     Min.R := CenterR_ - S;
     Max.R := CenterR_ + S;
end;

function TDoubleAreaC.GetCenterI :Double;
begin
     Result := ( Max.I + Min.I ) / 2;
end;

procedure TDoubleAreaC.SetCenterI( const CenterI_:Double );
var
   S :Double;
begin
     S := SizeI / 2;

     Min.I := CenterI_ - S;
     Max.I := CenterI_ + S;
end;

function TDoubleAreaC.GetSizeR :Double;
begin
     Result := Max.R - Min.R;
end;

procedure TDoubleAreaC.SetSizeR( const SizeR_:Double );
var
   C, S :Double;
begin
     C := CenterR;
     S := SizeR_ / 2;

     Min.R := C - S;
     Max.R := C + S;
end;

function TDoubleAreaC.GetSizeI :Double;
begin
     Result := Max.I - Min.I;
end;

procedure TDoubleAreaC.SetSizeI( const SizeI_:Double );
var
   C, S :Double;
begin
     C := CenterI;
     S := SizeI_ / 2;

     Min.I := C - S;
     Max.I := C + S;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TDoubleAreaC.Create( const Min_,Max_:TDoubleC );
begin
     Min := Min_;
     Max := Max_;
end;

constructor TDoubleAreaC.Create( const MinR_,MinI_,MaxR_,MaxI_:Double );
begin
     Min.R := MinR_;
     Min.I := MinI_;
     Max.R := MaxR_;
     Max.I := MaxI_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TDoubleAreaC.Negative( const V_:TDoubleAreaC ) :TDoubleAreaC;
begin
     Result.Min := -V_.Min;
     Result.Max := -V_.Max;
end;

class operator TDoubleAreaC.Positive( const V_:TDoubleAreaC ) :TDoubleAreaC;
begin
     Result.Min := +V_.Min;
     Result.Max := +V_.Max;
end;

class operator TDoubleAreaC.Add( const A_,B_:TDoubleAreaC ) :TDoubleAreaC;
begin
     Result.Min := A_.Min + B_.Min;
     Result.Max := A_.Max + B_.Max;
end;

class operator TDoubleAreaC.Subtract( const A_,B_:TDoubleAreaC ) :TDoubleAreaC;
begin
     Result.Min := A_.Min - B_.Min;
     Result.Max := A_.Max - B_.Max;
end;

class operator TDoubleAreaC.Multiply( const A_:TDoubleAreaC; const B_:Double ) :TDoubleAreaC;
begin
     Result.Min := A_.Min * B_;
     Result.Max := A_.Max * B_;
end;

class operator TDoubleAreaC.Multiply( const A_:Double; const B_:TDoubleAreaC ) :TDoubleAreaC;
begin
     Result.Min := A_ * B_.Min;
     Result.Max := A_ * B_.Max;
end;

class operator TDoubleAreaC.Divide( const A_:TDoubleAreaC; const B_:Double ) :TDoubleAreaC;
begin
     Result.Min := A_.Min / B_;
     Result.Max := A_.Max / B_;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pow

function Pow( const X_:TSingleC; const N_:Single ) :TSingleC;
var
   S, A: Single;
begin
     S := Power( X_.Abso, N_ );
     A :=        X_.Angle * N_;

     Result.R := S * System.Cos( A );
     Result.I := S * System.Sin( A );
end;

function Pow( const X_:TDoubleC; const N_:Double ) :TDoubleC;
var
   S, A: Double;
begin
     S := Power( X_.Abso, N_ );
     A :=        X_.Angle * N_;

     Result.R := S * System.Cos( A );
     Result.I := S * System.Sin( A );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Roo2

function Roo2( const X_:TSingleC ) :TSingleC;
var
   S, A: Single;
begin
     S := Roo2( X_.Abso );
     A :=       X_.Angle / 2;

     Result.R := S * System.Cos( A );
     Result.I := S * System.Sin( A );
end;

function Roo2( const X_:TDoubleC ) :TDoubleC;
var
   S, A: Double;
begin
     S := Roo2( X_.Abso );
     A :=       X_.Angle / 2;

     Result.R := S * System.Cos( A );
     Result.I := S * System.Sin( A );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cos

function Cos( const A_:TSingleC ) :TSingleC;
begin
     with A_ do
     begin
          Result.R := +System.Cos( R ) * Cosh( I );
          Result.I := -System.Sin( R ) * Sinh( I );
     end;
end;

function Cos( const A_:TDoubleC ) :TDoubleC;
begin
     with A_ do
     begin
          Result.R := +System.Cos( R ) * Cosh( I );
          Result.I := -System.Sin( R ) * Sinh( I );
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sin

function Sin( const A_:TSingleC ) :TSingleC;
begin
     with A_ do
     begin
          Result.R := +System.Sin( R ) * Cosh( I );
          Result.I := +System.Cos( R ) * Sinh( I );
     end;
end;

function Sin( const A_:TDoubleC ) :TDoubleC;
begin
     with A_ do
     begin
          Result.R := +System.Sin( R ) * Cosh( I );
          Result.I := +System.Cos( R ) * Sinh( I );
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Tan

function Tan( const A_:TSingleC ) :TSingleC;
begin
     Result := Sin( A_ ) / Cos( A_ );
end;

function Tan( const A_:TDoubleC ) :TDoubleC;
begin
     Result := Sin( A_ ) / Cos( A_ );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Exp

function Exp( const A_:TSingleC ) :TSingleC;
var
   E :Single;
begin
     with A_ do
     begin
          E := System.Exp( R );

          Result.R := E * System.Cos( I );
          Result.I := E * System.Sin( I );
     end;
end;

function Exp( const A_:TDoubleC ) :TDoubleC;
var
   E :Double;
begin
     with A_ do
     begin
          E := System.Exp( R );

          Result.R := E * System.Cos( I );
          Result.I := E * System.Sin( I );
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Expi

function Expi( const X_:Single ) :TSingleC;
begin
     SinCos( X_, Result.I, Result.R );
end;

function Expi( const X_:Double ) :TDoubleC;
begin
     SinCos( X_, Result.I, Result.R );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Ln

function Ln( const A_:TSingleC ) :TSingleC;
begin
     Result.R := System.Ln( A_.Abso );
     Result.I :=     A_.Angle ;
end;

function Ln( const A_:TDoubleC ) :TDoubleC;
begin
     Result.R := System.Ln( A_.Abso );
     Result.I :=     A_.Angle ;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ArcCos

function ArcCos( const X_:TSingleC ) :TSingleC;
begin
     Result := -TSingleC.Imaginary * Ln( X_ + TSingleC.Imaginary * Roo2( 1 - X_ * X_ ) );
end;

function ArcCos( const X_:TDoubleC ) :TDoubleC;
begin
     Result := -TDoubleC.Imaginary * Ln( X_ + TDoubleC.Imaginary * Roo2( 1 - X_ * X_ ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ArcSin

function ArcSin( const X_:TSingleC ) :TSingleC;
begin
     Result := -TSingleC.Imaginary * Ln( TSingleC.Imaginary * X_ + Roo2( 1 - X_ * X_ ) );
end;

function ArcSin( const X_:TDoubleC ) :TDoubleC;
begin
     Result := -TDoubleC.Imaginary * Ln( TDoubleC.Imaginary * X_ + Roo2( 1 - X_ * X_ ) );
end;

end. //######################################################################### ■
