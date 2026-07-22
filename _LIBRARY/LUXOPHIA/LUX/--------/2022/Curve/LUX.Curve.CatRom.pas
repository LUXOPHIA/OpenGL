unit LUX.Curve.CatRom;

interface //#################################################################### ■

uses LUX,
     LUX.D1,
     LUX.D2,
     LUX.D3,
     LUX.Curve;

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

function CatmullRom( const P0_,P1_,P2_,P3_:TSingle2D; const T_:Single ) :TSingle2D; overload;
function CatmullRom( const P0_,P1_,P2_,P3_:TDouble2D; const T_:Double ) :TDouble2D; overload;
function CatmullRom( const P0_,P1_,P2_,P3_:TdSingle2D; const T_:TdSingle ) :TdSingle2D; overload;
function CatmullRom( const P0_,P1_,P2_,P3_:TdDouble2D; const T_:TdDouble ) :TdDouble2D; overload;

function CatmullRom( const P0_,P1_,P2_,P3_:TSingle3D; const T_:Single ) :TSingle3D; overload;
function CatmullRom( const P0_,P1_,P2_,P3_:TDouble3D; const T_:Double ) :TDouble3D; overload;
function CatmullRom( const P0_,P1_,P2_,P3_:TdSingle3D; const T_:TdSingle ) :TdSingle3D; overload;
function CatmullRom( const P0_,P1_,P2_,P3_:TdDouble3D; const T_:TdDouble ) :TdDouble3D; overload;

implementation //############################################################### ■

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

//------------------------------------------------------------------------------

function CatmullRom( const P0_,P1_,P2_,P3_:TSingle2D; const T_:Single ) :TSingle2D;
begin
     Result.X := CatmullRom( P0_.X, P1_.X, P2_.X, P3_.X, T_ );
     Result.Y := CatmullRom( P0_.Y, P1_.Y, P2_.Y, P3_.Y, T_ );
end;

function CatmullRom( const P0_,P1_,P2_,P3_:TDouble2D; const T_:Double ) :TDouble2D;
begin
     Result.X := CatmullRom( P0_.X, P1_.X, P2_.X, P3_.X, T_ );
     Result.Y := CatmullRom( P0_.Y, P1_.Y, P2_.Y, P3_.Y, T_ );
end;

function CatmullRom( const P0_,P1_,P2_,P3_:TdSingle2D; const T_:TdSingle ) :TdSingle2D;
begin
     Result.X := CatmullRom( P0_.X, P1_.X, P2_.X, P3_.X, T_ );
     Result.Y := CatmullRom( P0_.Y, P1_.Y, P2_.Y, P3_.Y, T_ );
end;

function CatmullRom( const P0_,P1_,P2_,P3_:TdDouble2D; const T_:TdDouble ) :TdDouble2D;
begin
     Result.X := CatmullRom( P0_.X, P1_.X, P2_.X, P3_.X, T_ );
     Result.Y := CatmullRom( P0_.Y, P1_.Y, P2_.Y, P3_.Y, T_ );
end;

//------------------------------------------------------------------------------

function CatmullRom( const P0_,P1_,P2_,P3_:TSingle3D; const T_:Single ) :TSingle3D;
begin
     Result.X := CatmullRom( P0_.X, P1_.X, P2_.X, P3_.X, T_ );
     Result.Y := CatmullRom( P0_.Y, P1_.Y, P2_.Y, P3_.Y, T_ );
     Result.Z := CatmullRom( P0_.Z, P1_.Z, P2_.Z, P3_.Z, T_ );
end;

function CatmullRom( const P0_,P1_,P2_,P3_:TDouble3D; const T_:Double ) :TDouble3D;
begin
     Result.X := CatmullRom( P0_.X, P1_.X, P2_.X, P3_.X, T_ );
     Result.Y := CatmullRom( P0_.Y, P1_.Y, P2_.Y, P3_.Y, T_ );
     Result.Z := CatmullRom( P0_.Z, P1_.Z, P2_.Z, P3_.Z, T_ );
end;

function CatmullRom( const P0_,P1_,P2_,P3_:TdSingle3D; const T_:TdSingle ) :TdSingle3D;
begin
     Result.X := CatmullRom( P0_.X, P1_.X, P2_.X, P3_.X, T_ );
     Result.Y := CatmullRom( P0_.Y, P1_.Y, P2_.Y, P3_.Y, T_ );
     Result.Z := CatmullRom( P0_.Z, P1_.Z, P2_.Z, P3_.Z, T_ );
end;

function CatmullRom( const P0_,P1_,P2_,P3_:TdDouble3D; const T_:TdDouble ) :TdDouble3D;
begin
     Result.X := CatmullRom( P0_.X, P1_.X, P2_.X, P3_.X, T_ );
     Result.Y := CatmullRom( P0_.Y, P1_.Y, P2_.Y, P3_.Y, T_ );
     Result.Z := CatmullRom( P0_.Z, P1_.Z, P2_.Z, P3_.Z, T_ );
end;

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
