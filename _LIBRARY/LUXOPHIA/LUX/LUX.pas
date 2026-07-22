unit LUX;

interface //#################################################################### ■

uses System.Classes, System.Generics.Collections;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TArray*

     TArray2<T> = array of TArray <T>;
     TArray3<T> = array of TArray2<T>;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TConstProc*

     TConstProc<TA         > = reference to procedure( const A:TA                                     );
     TConstProc<TA,TB      > = reference to procedure( const A:TA; const B:TB                         );
     TConstProc<TA,TB,TC   > = reference to procedure( const A:TA; const B:TB; const C:TC             );
     TConstProc<TA,TB,TC,TD> = reference to procedure( const A:TA; const B:TB; const C:TC; const D:TD );

     TConstProc1<T> = reference to procedure( const A:T       );
     TConstProc2<T> = reference to procedure( const A,B:T     );
     TConstProc3<T> = reference to procedure( const A,B,C:T   );
     TConstProc4<T> = reference to procedure( const A,B,C,D:T );

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TConstFunc*

     TConstFunc<TA,         TResult> = reference to function( const A:TA                                     ) :TResult;
     TConstFunc<TA,TB,      TResult> = reference to function( const A:TA; const B:TB                         ) :TResult;
     TConstFunc<TA,TB,TC,   TResult> = reference to function( const A:TA; const B:TB; const C:TC             ) :TResult;
     TConstFunc<TA,TB,TC,TD,TResult> = reference to function( const A:TA; const B:TB; const C:TC; const D:TD ) :TResult;

     TConstFunc1<T,TResult> = reference to function( const A:T       ) :TResult;
     TConstFunc2<T,TResult> = reference to function( const A,B:T     ) :TResult;
     TConstFunc3<T,TResult> = reference to function( const A,B,C:T   ) :TResult;
     TConstFunc4<T,TResult> = reference to function( const A,B,C,D:T ) :TResult;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDelegates

     TDelegates = record
     private type
       THolder = class( TInterfacedObject )
         _Events :TArray<TNotifyEvent>;
       end;
     private
       _Keeper :IInterface;  // 寿命管理（参照カウント）
       _Holder :THolder;     // 実体（レコードのコピー間で共有される）
     public
       class operator Initialize( out D_:TDelegates );
       ///// M E T H O D
       procedure Add( E_:TNotifyEvent );
       procedure Del( const E_:TNotifyEvent );
       procedure Run( const Sender_:TObject );
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C O N S T A N T 】

      //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EPS

      SINGLE_EPS = 1.1920928955078125E-7;
      DOUBLE_EPS = 2.220446049250313080847263336181640625E-16;

      SINGLE_EPS1 = SINGLE_EPS * 1E1;
      DOUBLE_EPS1 = DOUBLE_EPS * 1E1;

      SINGLE_EPS2 = SINGLE_EPS * 1E2;
      DOUBLE_EPS2 = DOUBLE_EPS * 1E2;

      SINGLE_EPS3 = SINGLE_EPS * 1E3;
      DOUBLE_EPS3 = DOUBLE_EPS * 1E3;

      SINGLE_EPS4 = SINGLE_EPS * 1E4;
      DOUBLE_EPS4 = DOUBLE_EPS * 1E4;

      //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pi

      Pi2 = 2 * Pi;
      Pi3 = 3 * Pi;
      Pi4 = 4 * Pi;

      P2i = Pi / 2;
      P3i = Pi / 3;
      P4i = Pi / 4;

      P3i2 = Pi2 / 3;

      //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CRLF

      CRLF = #13#10;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pow*

function Pow2( const X_:Single ) :Single; inline; overload;
function Pow2( const X_:Double ) :Double; inline; overload;

function Pow3( const X_:Single ) :Single; inline; overload;
function Pow3( const X_:Double ) :Double; inline; overload;

function Pow4( const X_:Single ) :Single; inline; overload;
function Pow4( const X_:Double ) :Double; inline; overload;

function Pow5( const X_:Single ) :Single; inline; overload;
function Pow5( const X_:Double ) :Double; inline; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Roo*

function Roo2( const X_:Single ) :Single; inline; overload;
function Roo2( const X_:Double ) :Double; inline; overload;

function Roo3( const X_:Single ) :Single; inline; overload;
function Roo3( const X_:Double ) :Double; inline; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clamp

function Clamp( const X_,Min_,Max_:Integer ) :Integer; inline; overload;
function Clamp( const X_,Min_,Max_:Single ) :Single; inline; overload;
function Clamp( const X_,Min_,Max_:Double ) :Double; inline; overload;

function ClampMin( const X_,Min_:Integer ) :Integer; inline; overload;
function ClampMin( const X_,Min_:Single ) :Single; inline; overload;
function ClampMin( const X_,Min_:Double ) :Double; inline; overload;

function ClampMax( const X_,Max_:Integer ) :Integer; inline; overload;
function ClampMax( const X_,Max_:Single ) :Single; inline; overload;
function ClampMax( const X_,Max_:Double ) :Double; inline; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min

function Min( const V1_,V2_,V3_:Integer ) :Integer; overload;
function Min( const V1_,V2_,V3_:Single ) :Single; overload;
function Min( const V1_,V2_,V3_:Double ) :Double; overload;

function MinI( const V1_,V2_:Integer ) :Byte; inline; overload;
function MinI( const V1_,V2_:Single ) :Byte; inline; overload;
function MinI( const V1_,V2_:Double ) :Byte; inline; overload;

function MinI( const V1_,V2_,V3_:Integer ) :Integer; inline; overload;
function MinI( const V1_,V2_,V3_:Single ) :Integer; inline; overload;
function MinI( const V1_,V2_,V3_:Double ) :Integer; inline; overload;

function MinI( const V1_,V2_,V3_,V4_:Integer ) :Integer; inline; overload;
function MinI( const V1_,V2_,V3_,V4_:Single ) :Integer; inline; overload;
function MinI( const V1_,V2_,V3_,V4_:Double ) :Integer; inline; overload;

function MinI( const Vs_:array of Integer ) :Integer; overload;
function MinI( const Vs_:array of Single ) :Integer; overload;
function MinI( const Vs_:array of Double ) :Integer; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Max

function Max( const V1_,V2_,V3_:Integer ) :Integer; overload;
function Max( const V1_,V2_,V3_:Single ) :Single; overload;
function Max( const V1_,V2_,V3_:Double ) :Double; overload;

function MaxI( const V1_,V2_:Integer ) :Byte; inline; overload;
function MaxI( const V1_,V2_:Single ) :Byte; inline; overload;
function MaxI( const V1_,V2_:Double ) :Byte; inline; overload;

function MaxI( const V1_,V2_,V3_:Integer ) :Integer; inline; overload;
function MaxI( const V1_,V2_,V3_:Single ) :Integer; inline; overload;
function MaxI( const V1_,V2_,V3_:Double ) :Integer; inline; overload;

function MaxI( const V1_,V2_,V3_,V4_:Integer ) :Integer; inline; overload;
function MaxI( const V1_,V2_,V3_,V4_:Single ) :Integer; inline; overload;
function MaxI( const V1_,V2_,V3_,V4_:Double ) :Integer; inline; overload;

function MaxI( const Vs_:array of Integer ) :Integer; overload;
function MaxI( const Vs_:array of Single ) :Integer; overload;
function MaxI( const Vs_:array of Double ) :Integer; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FloorMod

function FloorMod( const X_,DivN_:Integer ) :Integer; overload;
function FloorMod( const X_,DivN_:Int64 ) :Int64; overload;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Binomial = Combination

function Binomial32( N_,K_:UInt32 ) :UInt32;  // 0 <= K <= N, 0 <= N <= 34
function Binomial64( N_,K_:UInt32 ) :UInt64;  // 0 <= K <= N, 0 <= N <= 67

function Combination32( N_,K_:UInt32 ) :UInt32; inline;  // 0 <= K <= N, 0 <= N <= 34
function Combination64( N_,K_:UInt32 ) :UInt64; inline;  // 0 <= K <= N, 0 <= N <= 67

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDelegates

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

class operator TDelegates.Initialize( out D_:TDelegates );
begin
     D_._Holder := THolder.Create;
     D_._Keeper := D_._Holder;
end;

//------------------------------------------------------------------------------

procedure TDelegates.Add( E_:TNotifyEvent );
begin
     with _Holder do
     if TArray.IndexOf<TNotifyEvent>( _Events, E_ ) < 0 then _Events := _Events + [ E_ ];
end;

procedure TDelegates.Del( const E_:TNotifyEvent );
var
   I :Integer;
begin
     with _Holder do
     begin
          I := TArray.IndexOf<TNotifyEvent>( _Events, E_ );  if I < 0 then Exit;

          Delete( _Events, I, 1 );
     end;
end;

procedure TDelegates.Run( const Sender_:TObject );
var
   E :TNotifyEvent;
begin
     for E in Copy( _Holder._Events ) do E( Sender_ );  // ハンドラ内の Del に備えてコピーを走査
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pow

function Pow2( const X_:Single ) :Single;
begin
     Result := Sqr( X_ );
end;

function Pow2( const X_:Double ) :Double;
begin
     Result := Sqr( X_ );
end;

//------------------------------------------------------------------------------

function Pow3( const X_:Single ) :Single;
begin
     Result := X_ * Pow2( X_ );
end;

function Pow3( const X_:Double ) :Double;
begin
     Result := X_ * Pow2( X_ );
end;

//------------------------------------------------------------------------------

function Pow4( const X_:Single ) :Single;
begin
     Result := Pow2( Pow2( X_ ) );
end;

function Pow4( const X_:Double ) :Double;
begin
     Result := Pow2( Pow2( X_ ) );
end;

//------------------------------------------------------------------------------

function Pow5( const X_:Single ) :Single;
begin
     Result := Pow4( X_ ) * X_;
end;

function Pow5( const X_:Double ) :Double;
begin
     Result := Pow4( X_ ) * X_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Roo*

function Roo2( const X_:Single ) :Single;
begin
     Result := Sqrt( X_ );
end;

function Roo2( const X_:Double ) :Double;
begin
     Result := Sqrt( X_ );
end;

//------------------------------------------------------------------------------

function Roo3( const X_:Single ) :Single;
begin
     Result := Sign( X_ ) * Power( Abs( X_ ), 1/3 );
end;

function Roo3( const X_:Double ) :Double;
begin
     Result := Sign( X_ ) * Power( Abs( X_ ), 1/3 );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Clamp

function Clamp( const X_,Min_,Max_:Integer ) :Integer;
begin
     if X_ < Min_ then Result := Min_
                  else
     if Max_ < X_ then Result := Max_
                  else Result := X_;
end;

function Clamp( const X_,Min_,Max_:Single ) :Single;
begin
     if X_ < Min_ then Result := Min_
                  else
     if Max_ < X_ then Result := Max_
                  else Result := X_;
end;

function Clamp( const X_,Min_,Max_:Double ) :Double;
begin
     if X_ < Min_ then Result := Min_
                  else
     if Max_ < X_ then Result := Max_
                  else Result := X_;
end;

//------------------------------------------------------------------------------

function ClampMin( const X_,Min_:Integer ) :Integer;
begin
     if X_ < Min_ then Result := Min_
                  else Result := X_;
end;

function ClampMin( const X_,Min_:Single ) :Single;
begin
     if X_ < Min_ then Result := Min_
                  else Result := X_;
end;

function ClampMin( const X_,Min_:Double ) :Double;
begin
     if X_ < Min_ then Result := Min_
                  else Result := X_;
end;

//------------------------------------------------------------------------------

function ClampMax( const X_,Max_:Integer ) :Integer;
begin
     if Max_ < X_ then Result := Max_
                  else Result := X_;
end;

function ClampMax( const X_,Max_:Single ) :Single;
begin
     if Max_ < X_ then Result := Max_
                  else Result := X_;
end;

function ClampMax( const X_,Max_:Double ) :Double;
begin
     if Max_ < X_ then Result := Max_
                  else Result := X_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Min

function Min( const V1_,V2_,V3_:Integer ) :Integer;
begin
     if V1_ <= V2_ then
     begin
          if V1_ <= V3_ then Result := V1_ else Result := V3_;
     end
     else
     begin
          if V2_ <= V3_ then Result := V2_ else Result := V3_;
     end;
end;

function Min( const V1_,V2_,V3_:Single ) :Single;
begin
     if V1_ <= V2_ then
     begin
          if V1_ <= V3_ then Result := V1_ else Result := V3_;
     end
     else
     begin
          if V2_ <= V3_ then Result := V2_ else Result := V3_;
     end;
end;

function Min( const V1_,V2_,V3_:Double ) :Double;
begin
     if V1_ <= V2_ then
     begin
          if V1_ <= V3_ then Result := V1_ else Result := V3_;
     end
     else
     begin
          if V2_ <= V3_ then Result := V2_ else Result := V3_;
     end;
end;

//------------------------------------------------------------------------------

function MinI( const V1_,V2_:Integer ) :Byte;
begin
     if V1_ <= V2_ then Result := 1 else Result := 2;
end;

function MinI( const V1_,V2_:Single ) :Byte;
begin
     if V1_ <= V2_ then Result := 1 else Result := 2;
end;

function MinI( const V1_,V2_:Double ) :Byte;
begin
     if V1_ <= V2_ then Result := 1 else Result := 2;
end;

//------------------------------------------------------------------------------

function MinI( const V1_,V2_,V3_:Integer ) :Integer;
begin
     if V1_ <= V2_ then
     begin
          if V1_ <= V3_ then Result := 1 else Result := 3;
     end
     else
     begin
          if V2_ <= V3_ then Result := 2 else Result := 3;
     end;
end;

function MinI( const V1_,V2_,V3_:Single ) :Integer;
begin
     if V1_ <= V2_ then
     begin
          if V1_ <= V3_ then Result := 1 else Result := 3;
     end
     else
     begin
          if V2_ <= V3_ then Result := 2 else Result := 3;
     end;
end;

function MinI( const V1_,V2_,V3_:Double ) :Integer;
begin
     if V1_ <= V2_ then
     begin
          if V1_ <= V3_ then Result := 1 else Result := 3;
     end
     else
     begin
          if V2_ <= V3_ then Result := 2 else Result := 3;
     end;
end;

//------------------------------------------------------------------------------

function MinI( const V1_,V2_,V3_,V4_:Integer ) :Integer;
begin
     if V1_ <= V2_ then
     begin
          if V1_ <= V3_ then
          begin
               if V1_ <= V4_ then Result := 1 else Result := 4;
          end
          else
          begin
               if V3_ <= V4_ then Result := 3 else Result := 4;
          end;
     end
     else
     begin
          if V2_ <= V3_ then
          begin
               if V2_ <= V4_ then Result := 2 else Result := 4;
          end
          else
          begin
               if V3_ <= V4_ then Result := 3 else Result := 4;
          end;
     end;
end;

function MinI( const V1_,V2_,V3_,V4_:Single ) :Integer;
begin
     if V1_ <= V2_ then
     begin
          if V1_ <= V3_ then
          begin
               if V1_ <= V4_ then Result := 1 else Result := 4;
          end
          else
          begin
               if V3_ <= V4_ then Result := 3 else Result := 4;
          end;
     end
     else
     begin
          if V2_ <= V3_ then
          begin
               if V2_ <= V4_ then Result := 2 else Result := 4;
          end
          else
          begin
               if V3_ <= V4_ then Result := 3 else Result := 4;
          end;
     end;
end;

function MinI( const V1_,V2_,V3_,V4_:Double ) :Integer;
begin
     if V1_ <= V2_ then
     begin
          if V1_ <= V3_ then
          begin
               if V1_ <= V4_ then Result := 1 else Result := 4;
          end
          else
          begin
               if V3_ <= V4_ then Result := 3 else Result := 4;
          end;
     end
     else
     begin
          if V2_ <= V3_ then
          begin
               if V2_ <= V4_ then Result := 2 else Result := 4;
          end
          else
          begin
               if V3_ <= V4_ then Result := 3 else Result := 4;
          end;
     end;
end;

//------------------------------------------------------------------------------

function MinI( const Vs_:array of Integer ) :Integer;
var
   I, V0, V1 :Integer;
begin
     Result := 0;  V0 := Vs_[ 0 ];

     for I := 1 to High( Vs_ ) do
     begin
          V1 := Vs_[ I ];

          if V1 < V0 then
          begin
               Result := I;  V0 := V1;
          end
     end
end;

function MinI( const Vs_:array of Single ) :Integer;
var
   I :Integer;
   V0, V1 :Single;
begin
     Result := 0;  V0 := Vs_[ 0 ];

     for I := 1 to High( Vs_ ) do
     begin
          V1 := Vs_[ I ];

          if V1 < V0 then
          begin
               Result := I;  V0 := V1;
          end
     end
end;

function MinI( const Vs_:array of Double ) :Integer;
var
   I :Integer;
   V0, V1 :Double;
begin
     Result := 0;  V0 := Vs_[ 0 ];

     for I := 1 to High( Vs_ ) do
     begin
          V1 := Vs_[ I ];

          if V1 < V0 then
          begin
               Result := I;  V0 := V1;
          end
     end
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Max

function Max( const V1_,V2_,V3_:Integer ) :Integer;
begin
     if V1_ >= V2_ then
     begin
          if V1_ >= V3_ then Result := V1_ else Result := V3_;
     end
     else
     begin

          if V2_ >= V3_ then Result := V2_ else Result := V3_;
     end;
end;

function Max( const V1_,V2_,V3_:Single ) :Single;
begin
     if V1_ >= V2_ then
     begin
          if V1_ >= V3_ then Result := V1_ else Result := V3_;
     end
     else
     begin

          if V2_ >= V3_ then Result := V2_ else Result := V3_;
     end;
end;

function Max( const V1_,V2_,V3_:Double ) :Double;
begin
     if V1_ >= V2_ then
     begin
          if V1_ >= V3_ then Result := V1_ else Result := V3_;
     end
     else
     begin
          if V2_ >= V3_ then Result := V2_ else Result := V3_;
     end;
end;

//------------------------------------------------------------------------------

function MaxI( const V1_,V2_:Integer ) :Byte;
begin
     if V1_ <= V2_ then Result := 2 else Result := 1;
end;

function MaxI( const V1_,V2_:Single ) :Byte;
begin
     if V1_ <= V2_ then Result := 2 else Result := 1;
end;

function MaxI( const V1_,V2_:Double ) :Byte;
begin
     if V1_ <= V2_ then Result := 2 else Result := 1;
end;

//------------------------------------------------------------------------------

function MaxI( const V1_,V2_,V3_:Integer ) :Integer;
begin
     if V1_ >= V2_ then
     begin
          if V1_ >= V3_ then Result := 1 else Result := 3;
     end
     else
     begin
          if V2_ >= V3_ then Result := 2 else Result := 3;
     end;
end;

function MaxI( const V1_,V2_,V3_:Single ) :Integer;
begin
     if V1_ >= V2_ then
     begin
          if V1_ >= V3_ then Result := 1 else Result := 3;
     end
     else
     begin
          if V2_ >= V3_ then Result := 2 else Result := 3;
     end;
end;

function MaxI( const V1_,V2_,V3_:Double ) :Integer;
begin
     if V1_ >= V2_ then
     begin
          if V1_ >= V3_ then Result := 1 else Result := 3;
     end
     else
     begin
          if V2_ >= V3_ then Result := 2 else Result := 3;
     end;
end;

//------------------------------------------------------------------------------

function MaxI( const V1_,V2_,V3_,V4_:Integer ) :Integer;
begin
     if V1_ >= V2_ then
     begin
          if V1_ >= V3_ then
          begin
               if V1_ >= V4_ then Result := 1 else Result := 4;
          end
          else
          begin
               if V3_ >= V4_ then Result := 3 else Result := 4;
          end;
     end
     else
     begin
          if V2_ >= V3_ then
          begin
               if V2_ >= V4_ then Result := 2 else Result := 4;
          end
          else
          begin
               if V3_ >= V4_ then Result := 3 else Result := 4;
          end;
     end;
end;

function MaxI( const V1_,V2_,V3_,V4_:Single ) :Integer;
begin
     if V1_ >= V2_ then
     begin
          if V1_ >= V3_ then
          begin
               if V1_ >= V4_ then Result := 1 else Result := 4;
          end
          else
          begin
               if V3_ >= V4_ then Result := 3 else Result := 4;
          end;
     end
     else
     begin
          if V2_ >= V3_ then
          begin
               if V2_ >= V4_ then Result := 2 else Result := 4;
          end
          else
          begin
               if V3_ >= V4_ then Result := 3 else Result := 4;
          end;
     end;
end;

function MaxI( const V1_,V2_,V3_,V4_:Double ) :Integer;
begin
     if V1_ >= V2_ then
     begin
          if V1_ >= V3_ then
          begin
               if V1_ >= V4_ then Result := 1 else Result := 4;
          end
          else
          begin
               if V3_ >= V4_ then Result := 3 else Result := 4;
          end;
     end
     else
     begin
          if V2_ >= V3_ then
          begin
               if V2_ >= V4_ then Result := 2 else Result := 4;
          end
          else
          begin
               if V3_ >= V4_ then Result := 3 else Result := 4;
          end;
     end;
end;

//------------------------------------------------------------------------------

function MaxI( const Vs_:array of Integer ) :Integer;
var
   I, V0, V1 :Integer;
begin
     Result := 0;  V0 := Vs_[ 0 ];

     for I := 1 to High( Vs_ ) do
     begin
          V1 := Vs_[ I ];

          if V1 > V0 then
          begin
               Result := I;  V0 := V1;
          end
     end
end;

function MaxI( const Vs_:array of Single ) :Integer;
var
   I :Integer;
   V0, V1 :Single;
begin
     Result := 0;  V0 := Vs_[ 0 ];

     for I := 1 to High( Vs_ ) do
     begin
          V1 := Vs_[ I ];

          if V1 > V0 then
          begin
               Result := I;  V0 := V1;
          end
     end
end;

function MaxI( const Vs_:array of Double ) :Integer;
var
   I :Integer;
   V0, V1 :Double;
begin
     Result := 0;  V0 := Vs_[ 0 ];

     for I := 1 to High( Vs_ ) do
     begin
          V1 := Vs_[ I ];

          if V1 > V0 then
          begin
               Result := I;  V0 := V1;
          end
     end
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FloorMod

function FloorMod( const X_,DivN_:Integer ) :Integer;
begin
     // Result := ( ( X_ mod DivN_ ) + DivN_ ) mod DivN_;

     Result := X_ mod DivN_;

     if Result < 0 then Inc( Result, DivN_ );
end;

function FloorMod( const X_,DivN_:Int64 ) :Int64;
begin
     // Result := ( ( X_ mod DivN_ ) + DivN_ ) mod DivN_;

     Result := X_ mod DivN_;

     if Result < 0 then Inc( Result, DivN_ );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Binomial = Combination

function Binomial32( N_,K_:UInt32 ) :UInt32;
var
   I :UInt32;
begin
     if K_ > N_ - K_ then K_ := N_ - K_;

     Result := 1;

     for I := 1 to K_ do
     begin
          //Result := Result * ( N_ - K_ + I ) div I;

          Result := Result * N_ div I;  Dec( N_ );
     end;
end;

function Binomial64( N_,K_:UInt32 ) :UInt64;
var
   I :UInt32;
begin
     if K_ > N_ - K_ then K_ := N_ - K_;

     Result := 1;

     for I := 1 to K_ do
     begin
          //Result := Result * ( N_ - K_ + I ) div I;

          Result := Result * N_ div I;  Dec( N_ );
     end;
end;

function Combination32( N_,K_:UInt32 ) :UInt32;
begin
     Result := Binomial32( N_, K_ );
end;

function Combination64( N_,K_:UInt32 ) :UInt64;
begin
     Result := Binomial64( N_, K_ );
end;

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

     Randomize;

end. //######################################################################### ■
