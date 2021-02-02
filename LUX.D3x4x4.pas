unit LUX.D3x4x4;

interface //#################################################################### ■

uses LUX, LUX.D1, LUX.D2, LUX.D3;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle4x4x3D

     TSingle4x4x3D = record
     private
       ///// アクセス
       function Gets( const Y_,X_:Integer ) :TSingle3D; inline;
       procedure Sets( const Y_,X_:Integer; const M_:TSingle3D ); inline;
     public
       ///// プロパティ
       property _s[ const Y_,X_:Integer ] :TSingle3D read Gets write Sets; default;
     case Integer of
      0:( _ :array [ 1..4, 1..4 ] of TSingle3D; );
      1:( _11, _12, _13, _14,
          _21, _22, _23, _24,
          _31, _32, _33, _34,
          _41, _42, _43, _44 :TSingle3D;        );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble4x4x3D

     TDouble4x4x3D = record
     private
       ///// アクセス
       function Gets( const Y_,X_:Integer ) :TDouble3D; inline;
       procedure Sets( const Y_,X_:Integer; const M_:TDouble3D ); inline;
     public
       ///// プロパティ
       property _s[ const Y_,X_:Integer ] :TDouble3D read Gets write Sets; default;
     case Integer of
      0:( _ :array [ 1..4, 1..4 ] of TDouble3D; );
      1:( _11, _12, _13, _14,
          _21, _22, _23, _24,
          _31, _32, _33, _34,
          _41, _42, _43, _44 :TDouble3D;        );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle4x4x3D

     TdSingle4x4x3D = record
     private
       ///// アクセス
       function Gets( const Y_,X_:Integer ) :TdSingle3D; inline;
       procedure Sets( const Y_,X_:Integer; const M_:TdSingle3D ); inline;
     public
       ///// プロパティ
       property _s[ const Y_,X_:Integer ] :TdSingle3D read Gets write Sets; default;
       ///// 型変換
       class operator Implicit( const M_:TSingle4x4x3D ) :TdSingle4x4x3D; inline;
       class operator Explicit( const M_:TdSingle4x4x3D ) :TSingle4x4x3D; inline;
     case Integer of
      0:( _ :array [ 1..4, 1..4 ] of TdSingle3D; );
      1:( _11, _12, _13, _14,
          _21, _22, _23, _24,
          _31, _32, _33, _34,
          _41, _42, _43, _44 :TdSingle3D;        );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble4x4x3D

     TdDouble4x4x3D = record
     private
       ///// アクセス
       function Gets( const Y_,X_:Integer ) :TdDouble3D; inline;
       procedure Sets( const Y_,X_:Integer; const M_:TdDouble3D ); inline;
     public
       ///// プロパティ
       property _s[ const Y_,X_:Integer ] :TdDouble3D read Gets write Sets; default;
       ///// 型変換
       class operator Implicit( const M_:TDouble4x4x3D ) :TdDouble4x4x3D; inline;
       class operator Explicit( const M_:TdDouble4x4x3D ) :TDouble4x4x3D; inline;
     case Integer of
      0:( _ :array [ 1..4, 1..4 ] of TdDouble3D; );
      1:( _11, _12, _13, _14,
          _21, _22, _23, _24,
          _31, _32, _33, _34,
          _41, _42, _43, _44 :TdDouble3D;        );
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle4x4x3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TSingle4x4x3D.Gets( const Y_,X_:Integer ) :TSingle3D;
begin
     Result := _[ Y_, X_ ];
end;

procedure TSingle4x4x3D.Sets( const Y_,X_:Integer; const M_:TSingle3D );
begin
     _[ Y_, X_ ] := M_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble4x4x3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TDouble4x4x3D.Gets( const Y_,X_:Integer ) :TDouble3D;
begin
     Result := _[ Y_, X_ ];
end;

procedure TDouble4x4x3D.Sets( const Y_,X_:Integer; const M_:TDouble3D );
begin
     _[ Y_, X_ ] := M_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle4x4x3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TdSingle4x4x3D.Gets( const Y_,X_:Integer ) :TdSingle3D;
begin
     Result := _[ Y_, X_ ];
end;

procedure TdSingle4x4x3D.Sets( const Y_,X_:Integer; const M_:TdSingle3D );
begin
     _[ Y_, X_ ] := M_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

///////////////////////////////////////////////////////////////////////// 型変換

class operator TdSingle4x4x3D.Implicit( const M_:TSingle4x4x3D ) :TdSingle4x4x3D;
begin
     with Result  do
     begin
          _11 := M_._11;  _12 := M_._12;  _13 := M_._13;  _14 := M_._14;
          _21 := M_._21;  _22 := M_._22;  _23 := M_._23;  _24 := M_._24;
          _31 := M_._31;  _32 := M_._32;  _33 := M_._33;  _34 := M_._34;
          _41 := M_._41;  _42 := M_._42;  _43 := M_._43;  _44 := M_._44;
     end;
end;

class operator TdSingle4x4x3D.Explicit( const M_:TdSingle4x4x3D ) :TSingle4x4x3D;
begin
     with Result  do
     begin
          _11 := M_._11;  _12 := M_._12;  _13 := M_._13;  _14 := M_._14;
          _21 := M_._21;  _22 := M_._22;  _23 := M_._23;  _24 := M_._24;
          _31 := M_._31;  _32 := M_._32;  _33 := M_._33;  _34 := M_._34;
          _41 := M_._41;  _42 := M_._42;  _43 := M_._43;  _44 := M_._44;
     end;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble4x4x3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TdDouble4x4x3D.Gets( const Y_,X_:Integer ) :TdDouble3D;
begin
     Result := _[ Y_, X_ ];
end;

procedure TdDouble4x4x3D.Sets( const Y_,X_:Integer; const M_:TdDouble3D );
begin
     _[ Y_, X_ ] := M_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

///////////////////////////////////////////////////////////////////////// 型変換

class operator TdDouble4x4x3D.Implicit( const M_:TDouble4x4x3D ) :TdDouble4x4x3D;
begin
     with Result  do
     begin
          _11 := M_._11;  _12 := M_._12;  _13 := M_._13;  _14 := M_._14;
          _21 := M_._21;  _22 := M_._22;  _23 := M_._23;  _24 := M_._24;
          _31 := M_._31;  _32 := M_._32;  _33 := M_._33;  _34 := M_._34;
          _41 := M_._41;  _42 := M_._42;  _43 := M_._43;  _44 := M_._44;
     end;
end;

class operator TdDouble4x4x3D.Explicit( const M_:TdDouble4x4x3D ) :TDouble4x4x3D;
begin
     with Result  do
     begin
          _11 := M_._11;  _12 := M_._12;  _13 := M_._13;  _14 := M_._14;
          _21 := M_._21;  _22 := M_._22;  _23 := M_._23;  _24 := M_._24;
          _31 := M_._31;  _32 := M_._32;  _33 := M_._33;  _34 := M_._34;
          _41 := M_._41;  _42 := M_._42;  _43 := M_._43;  _44 := M_._44;
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■