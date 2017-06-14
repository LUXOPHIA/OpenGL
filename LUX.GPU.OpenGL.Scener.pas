﻿unit LUX.GPU.OpenGL.Scener;

interface //#################################################################### ■

uses System.Generics.Collections,
     Winapi.OpenGL, Winapi.OpenGLext,
     LUX, LUX.D2, LUX.D3, LUX.M4, LUX.Tree,
     LUX.GPU.OpenGL,
     LUX.GPU.OpenGL.Buffer.Unifor;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     TGLScener = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLNode

     IGLNode = interface
     ['{049DB60C-9F5D-45B9-89D8-E4AC58C807E3}']
     {protected}
       ///// アクセス
       function GetScener :TGLScener;
       function GetMove :TSingleM4;
       procedure SetMove( const Move_:TSingleM4 );
     {public}
       ///// プロパティ
       property Scener :TGLScener read GetScener              ;
       property Move   :TSingleM4 read GetMove   write SetMove;
       ///// メソッド
       procedure Draw;
     end;

     TGLNode = class( TTreeNode<TGLNode>, IGLNode )
     private
     protected
       _Move :TGLUnifor<TSingleM4>;
       ///// アクセス
       function GetScener :TGLScener;
       function GetMove :TSingleM4;
       procedure SetMove( const Move_:TSingleM4 ); virtual;
     public
       constructor Create; override;
       destructor Destroy; override;
       ///// プロパティ
       property Scener :TGLScener read GetScener              ;
       property Move   :TSingleM4 read GetMove   write SetMove;
       ///// メソッド
       procedure Draw; virtual;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLScener

     IGLCamera = interface( IGLNode )
     ['{648646AC-975D-464E-BD83-C39EA3EB4E1E}']
     {protected}
     {public}
     end;

     IGLShaper = interface( IGLNode )
     ['{8045CCEA-8FC4-4D0A-A6CE-A97FF6972A7F}']
     {protected}
     {public}
     end;

     IGLScener = interface( IGLNode )
     ['{600C6A00-B748-4A1B-A841-A7135257ABCA}']
     {protected}
     {public}
     end;

     //-------------------------------------------------------------------------

     TGLScener = class( TGLNode, IGLScener )
     private
     protected
     public
       constructor Create; override;
       destructor Destroy; override;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

uses System.SysUtils, System.Classes,
     LUX.GPU.OpenGL.Camera,
     LUX.GPU.OpenGL.Shaper;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLNode

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLNode.GetScener :TGLScener;
begin
     Result := RootNode as TGLScener;
end;

//------------------------------------------------------------------------------

function TGLNode.GetMove :TSingleM4;
begin
     Result := _Move[ 0 ];
end;

procedure TGLNode.SetMove( const Move_:TSingleM4 );
begin
     _Move[ 0 ] := Move_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLNode.Create;
begin
     inherited;

     _Move := TGLUnifor<TSingleM4>.Create( GL_DYNAMIC_DRAW );
     _Move.Count := 1;
end;

destructor TGLNode.Destroy;
begin
     _Move.DisposeOf;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLNode.Draw;
var
   I :Integer;
begin
     for I := 0 to ChildsN-1 do Childs[ I ].Draw;

     _Move.Use( 3{BinP} );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLScener

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLScener.Create;
begin
     inherited;

end;

destructor TGLScener.Destroy;
begin

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
