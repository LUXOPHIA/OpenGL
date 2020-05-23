unit LUX.D3x4;

interface //#################################################################### ■

uses LUX, LUX.D1, LUX.D2, LUX.D3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle4x3D

     TSingle4x3D = record
     private
       ///// アクセス
       function Gets( const Y_:Integer ) :TSingle3D; inline;
       procedure Sets( const Y_:Integer; const V_:TSingle3D ); inline;
     public
       ///// プロパティ
       property _s[ const Y_:Integer ] :TSingle3D read Gets write Sets; default;
     case Byte of
      0:( _YXs :array [ 1..4, 1..3 ] of Single; );
      1:( _11, _12, _13,
          _21, _22, _23,
          _31, _32, _33,
          _41, _42, _43 :Single;                );
      2:( _Ys :array [ 1..4 ] of TSingle3D;     );
      3:( _1,
          _2,
          _3,
          _4 :TSingle3D;                        );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble4x3D

     TDouble4x3D = record
     private
       ///// アクセス
       function Gets( const Y_:Integer ) :TDouble3D; inline;
       procedure Sets( const Y_:Integer; const V_:TDouble3D ); inline;
     public
       ///// プロパティ
       property _s[ const Y_:Integer ] :TDouble3D read Gets write Sets; default;

     case Byte of
      0:( _YXs :array [ 1..4, 1..3 ] of Double; );
      1:( _11, _12, _13,
          _21, _22, _23,
          _31, _32, _33,
          _41, _42, _43 :Double;                );
      2:( _Ys :array [ 1..4 ] of TDouble3D;     );
      3:( _1,
          _2,
          _3,
          _4 :TDouble3D;                        );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle4x3D

     TdSingle4x3D = record
     private
       ///// アクセス
       function Gets( const Y_:Integer ) :TdSingle3D; inline;
       procedure Sets( const Y_:Integer; const V_:TdSingle3D ); inline;
     public
       ///// プロパティ
       property _s[ const Y_:Integer ] :TdSingle3D read Gets write Sets; default;
     case Byte of
      0:( _YXs :array [ 1..4, 1..3 ] of TdSingle; );
      1:( _11, _12, _13,
          _21, _22, _23,
          _31, _32, _33,
          _41, _42, _43 :TdSingle;                );
      2:( _Ys :array [ 1..4 ] of TdSingle3D;      );
      3:( _1,
          _2,
          _3,
          _4 :TdSingle3D;                         );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble4x3D

     TdDouble4x3D = record
     private
       ///// アクセス
       function Gets( const Y_:Integer ) :TdDouble3D; inline;
       procedure Sets( const Y_:Integer; const V_:TdDouble3D ); inline;
     public
       ///// プロパティ
       property _s[ const Y_:Integer ] :TdDouble3D read Gets write Sets; default;
     case Byte of
      0:( _YXs :array [ 1..4, 1..3 ] of TdDouble; );
      1:( _11, _12, _13,
          _21, _22, _23,
          _31, _32, _33,
          _41, _42, _43 :TdDouble;                );
      2:( _Ys :array [ 1..4 ] of TdDouble3D;      );
      3:( _1,
          _2,
          _3,
          _4 :TdDouble3D;                         );
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle4x3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TSingle4x3D.Gets( const Y_:Integer ) :TSingle3D;
begin
     Result := _Ys[ Y_ ];
end;

procedure TSingle4x3D.Sets( const Y_:Integer; const V_:TSingle3D );
begin
     _Ys[ Y_ ] := V_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble4x3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TDouble4x3D.Gets( const Y_:Integer ) :TDouble3D;
begin
     Result := _Ys[ Y_ ];
end;

procedure TDouble4x3D.Sets( const Y_:Integer; const V_:TDouble3D );
begin
     _Ys[ Y_ ] := V_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle4x3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TdSingle4x3D.Gets( const Y_:Integer ) :TdSingle3D;
begin
     Result := _Ys[ Y_ ];
end;

procedure TdSingle4x3D.Sets( const Y_:Integer; const V_:TdSingle3D );
begin
     _Ys[ Y_ ] := V_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble4x3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TdDouble4x3D.Gets( const Y_:Integer ) :TdDouble3D;
begin
     Result := _Ys[ Y_ ];
end;

procedure TdDouble4x3D.Sets( const Y_:Integer; const V_:TdDouble3D );
begin
     _Ys[ Y_ ] := V_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■