unit LUX.Curve;

interface //#################################################################### ■

uses LUX,
     LUX.D1;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurve<_TPoin_>

     TCurve<_TPoin_:record> = class
     private
     protected
       _MargsN   :Integer;
       _Poins    :TArray<_TPoin_>;  upPoins :Boolean;
       _CurvMinI :Integer;
       _CurvMaxI :Integer;
       ///// アクセス
       function GetMargsN :Integer; virtual;
       procedure SetMargsN( const MargsN_:Integer ); virtual;
       function GetPoinMinI :Integer; virtual;
       function GetPoinMaxI :Integer; virtual;
       function GetPoins( const I_:Integer ) :_TPoin_;
       procedure SetPoins( const I_:Integer; const Poins_:_TPoin_ );
       function GetCurvMinI :Integer; virtual;
       procedure SetCurvMinI( const CurvMinI_:Integer ); virtual;
       function GetCurvMaxI :Integer; virtual;
       procedure SetCurvMaxI( const CurvMaxI_:Integer ); virtual;
       ///// メソッド
       procedure MakePoins; virtual;
     public
       constructor Create;
       procedure AfterConstruction; override;
       destructor Destroy; override;
       ///// プロパティ
       property MargsN                    :Integer read GetMargsN   write SetMargsN  ;
       property PoinMinI                  :Integer read GetPoinMinI                  ;
       property PoinMaxI                  :Integer read GetPoinMaxI                  ;
       property Poins[ const I_:Integer ] :_TPoin_ read GetPoins    write SetPoins   ; default;
       property CurvMinI                  :Integer read GetCurvMinI write SetCurvMinI;
       property CurvMaxI                  :Integer read GetCurvMaxI write SetCurvMaxI;
       ///// メソッド
       function Curve( const X_:_TPoin_ ) :_TPoin_; virtual; abstract;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

function Delta( const X_:Single ) :Single; overload;
function Delta( const X_:Double ) :Double; overload;

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

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TCurve<_TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TCurve<_TPoin_>.GetMargsN :Integer;
begin
     Result := _MargsN;
end;

procedure TCurve<_TPoin_>.SetMargsN( const MargsN_:Integer );
begin
     _MargsN := MargsN_;  MakePoins;
end;

//------------------------------------------------------------------------------

function TCurve<_TPoin_>.GetPoinMinI :Integer;
begin
     Result := CurvMinI - MargsN;
end;

function TCurve<_TPoin_>.GetPoinMaxI :Integer;
begin
     Result := CurvMaxI + MargsN;
end;

//------------------------------------------------------------------------------

function TCurve<_TPoin_>.GetPoins( const I_:Integer ) :_TPoin_;
begin
     Result := _Poins[ I_ - PoinMinI ];
end;

procedure TCurve<_TPoin_>.SetPoins( const I_:Integer; const Poins_:_TPoin_ );
begin
     _Poins[ I_ - PoinMinI ] := Poins_;  upPoins := True;
end;

//------------------------------------------------------------------------------

function TCurve<_TPoin_>.GetCurvMinI :Integer;
begin
     Result := _CurvMinI;
end;

procedure TCurve<_TPoin_>.SetCurvMinI( const CurvMinI_:Integer );
begin
     _CurvMinI := CurvMinI_;  MakePoins;
end;

function TCurve<_TPoin_>.GetCurvMaxI :Integer;
begin
     Result := _CurvMaxI;
end;

procedure TCurve<_TPoin_>.SetCurvMaxI( const CurvMaxI_:Integer );
begin
     _CurvMaxI := CurvMaxI_;  MakePoins;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TCurve<_TPoin_>.MakePoins;
begin
     SetLength( _Poins, PoinMaxI - PoinMinI + 1 + 1 );  upPoins := True;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TCurve<_TPoin_>.Create;
begin
     inherited;

end;

procedure TCurve<_TPoin_>.AfterConstruction;
begin
     inherited;

     MargsN  := 0;

     CurvMinI := 0;
     CurvMaxI := 1;
end;

destructor TCurve<_TPoin_>.Destroy;
begin

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

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

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
