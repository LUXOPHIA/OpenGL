unit LUX.D2x4;

interface //#################################################################### ■

uses LUX,
     LUX.D1,
     LUX.D2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle4x2D

     TSingle4x2D = record
     private
       ///// アクセス
       function Gets( const Y_,X_:Integer ) :Single; overload; inline;
       procedure Sets( const Y_,X_:Integer; const V_:Single ); overload; inline;
       function Gets( const Y_:Integer ) :TSingle2D; overload; inline;
       procedure Sets( const Y_:Integer; const V_:TSingle2D ); overload; inline;
     public
       ///// プロパティ
       property _s[ const Y_,X_:Integer ] :Single    read Gets write Sets; default;
       property _s[ const Y_   :Integer ] :TSingle2D read Gets write Sets; default;
     case Byte of
      0:( _YXs :array [ 1..4, 1..2 ] of Single; );
      1:( _11, _12,
          _21, _22,
          _31, _32,
          _41, _42 :Single;                     );
      3:( _Ys :array [ 1..4 ] of TSingle2D;     );
      4:( _1,
          _2,
          _3,
          _4 :TSingle2D;                        );
     end;

     TSingleM42 = TSingle4x2D;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble4x2D

     TDouble4x2D = record
     private
       ///// アクセス
       function Gets( const Y_,X_:Integer ) :Double; overload; inline;
       procedure Sets( const Y_,X_:Integer; const V_:Double ); overload; inline;
       function Gets( const Y_:Integer ) :TDouble2D; overload; inline;
       procedure Sets( const Y_:Integer; const V_:TDouble2D ); overload; inline;
     public
       ///// プロパティ
       property _s[ const Y_,X_:Integer ] :Double    read Gets write Sets; default;
       property _s[ const Y_   :Integer ] :TDouble2D read Gets write Sets; default;
     case Byte of
      0:( _YXs :array [ 1..4, 1..2 ] of Double; );
      1:( _11, _12,
          _21, _22,
          _31, _32,
          _41, _42 :Double;                     );
      2:( _Ys :array [ 1..4 ] of TDouble2D;     );
      3:( _1,
          _2,
          _3,
          _4 :TDouble2D;                        );
     end;

     TDoubleM42 = TDouble4x2D;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle4x2D

     TdSingle4x2D = record
     private
       ///// アクセス
       function Gets( const Y_,X_:Integer ) :TdSingle; overload; inline;
       procedure Sets( const Y_,X_:Integer; const V_:TdSingle ); overload; inline;
       function Gets( const Y_:Integer ) :TdSingle2D; overload; inline;
       procedure Sets( const Y_:Integer; const V_:TdSingle2D ); overload; inline;
     public
       ///// プロパティ
       property _s[ const Y_,X_:Integer ] :TdSingle   read Gets write Sets; default;
       property _s[ const Y_   :Integer ] :TdSingle2D read Gets write Sets; default;
     case Byte of
      0:( _YXs :array [ 1..4, 1..2 ] of TdSingle; );
      1:( _11, _12,
          _21, _22,
          _31, _32,
          _41, _42 :TdSingle;                     );
      2:( _Ys :array [ 1..4 ] of TdSingle2D;      );
      3:( _1,
          _2,
          _3,
          _4 :TdSingle2D;                         );
     end;

     TdSingleM42 = TdSingle4x2D;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble4x2D

     TdDouble4x2D = record
     private
       ///// アクセス
       function Gets( const Y_,X_:Integer ) :TdDouble; overload; inline;
       procedure Sets( const Y_,X_:Integer; const V_:TdDouble ); overload; inline;
       function Gets( const Y_:Integer ) :TdDouble2D; overload; inline;
       procedure Sets( const Y_:Integer; const V_:TdDouble2D ); overload; inline;
     public
       ///// プロパティ
       property _s[ const Y_,X_:Integer ] :TdDouble   read Gets write Sets; default;
       property _s[ const Y_   :Integer ] :TdDouble2D read Gets write Sets; default;
     case Byte of
      0:( _YXs :array [ 1..4, 1..2 ] of TdDouble; );
      1:( _11, _12,
          _21, _22,
          _31, _32,
          _41, _42 :TdDouble;                     );
      2:( _Ys :array [ 1..4 ] of TdDouble2D;      );
      3:( _1,
          _2,
          _3,
          _4 :TdDouble2D;                         );
     end;

     TdDoubleM42 = TdDouble4x2D;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TSingle4x2D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TSingle4x2D.Gets( const Y_,X_:Integer ) :Single;
begin
     Result := _YXs[ Y_, X_ ];
end;

procedure TSingle4x2D.Sets( const Y_,X_:Integer; const V_:Single );
begin
     _YXs[ Y_, X_ ] := V_;
end;

function TSingle4x2D.Gets( const Y_:Integer ) :TSingle2D;
begin
     Result := _Ys[ Y_ ];
end;

procedure TSingle4x2D.Sets( const Y_:Integer; const V_:TSingle2D );
begin
     _Ys[ Y_ ] := V_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDouble4x2D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TDouble4x2D.Gets( const Y_,X_:Integer ) :Double;
begin
     Result := _YXs[ Y_, X_ ];
end;

procedure TDouble4x2D.Sets( const Y_,X_:Integer; const V_:Double );
begin
     _YXs[ Y_, X_ ] := V_;
end;

function TDouble4x2D.Gets( const Y_:Integer ) :TDouble2D;
begin
     Result := _Ys[ Y_ ];
end;

procedure TDouble4x2D.Sets( const Y_:Integer; const V_:TDouble2D );
begin
     _Ys[ Y_ ] := V_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdSingle4x2D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TdSingle4x2D.Gets( const Y_,X_:Integer ) :TdSingle;
begin
     Result := _YXs[ Y_, X_ ];
end;

procedure TdSingle4x2D.Sets( const Y_,X_:Integer; const V_:TdSingle );
begin
     _YXs[ Y_, X_ ] := V_;
end;

function TdSingle4x2D.Gets( const Y_:Integer ) :TdSingle2D;
begin
     Result := _Ys[ Y_ ];
end;

procedure TdSingle4x2D.Sets( const Y_:Integer; const V_:TdSingle2D );
begin
     _Ys[ Y_ ] := V_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble4x2D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TdDouble4x2D.Gets( const Y_,X_:Integer ) :TdDouble;
begin
     Result := _YXs[ Y_, X_ ];
end;

procedure TdDouble4x2D.Sets( const Y_,X_:Integer; const V_:TdDouble );
begin
     _YXs[ Y_, X_ ] := V_;
end;

function TdDouble4x2D.Gets( const Y_:Integer ) :TdDouble2D;
begin
     Result := _Ys[ Y_ ];
end;

procedure TdDouble4x2D.Sets( const Y_:Integer; const V_:TdDouble2D );
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