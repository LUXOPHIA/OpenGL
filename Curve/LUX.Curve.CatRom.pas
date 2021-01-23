unit LUX.Curve.CatRom;

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

implementation //############################################################### ■

uses LUX.Curve;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

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

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
