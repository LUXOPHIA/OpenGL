unit LUX.GPU.OpenGL.Atom.Buffer;

interface //#################################################################### ■

uses Winapi.OpenGL, Winapi.OpenGLext,
     LUX,
     LUX.GPU.OpenGL.Atom;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLBuffer<_TYPE_>

     IGLBuffer = interface( IGLAtomer )
     ['{196C0785-DF74-480C-B1DB-76E689F19E32}']
       ///// アクセス
       function GetKind :GLenum;
       function GetAlign :GLint;
       function GetStrid :GLint;
       function GetUsage :GLenum;
       function GetCount :Integer;
       procedure SetCount( const Count_:Integer );
       ///// プロパティ
       property Kind  :GLenum  read GetKind                ;
       property Align :GLint   read GetAlign               ;
       property Strid :GLint   read GetStrid               ;
       property ID    :GLuint  read GetID                  ;
       property Usage :GLenum  read GetUsage               ;
       property Count :Integer read GetCount write SetCount;
       ///// メソッド
       procedure Bind;
       procedure Unbind;
     end;

     //-------------------------------------------------------------------------

     TGLBuffer<_TYPE_:record> = class( TGLAtomer, IGLBuffer )
     private
     private type
       PTYPE = ^_TYPE_;
     protected
       _Align :GLint;
       _Strid :GLint;
       _Usage :GLenum;
       _Count :Integer;
       _Items :TArray<Byte>;  upItems :Boolean;
       ///// アクセス
       function GetKind :GLenum; virtual; abstract;
       function GetAlign :GLint;
       function GetStrid :GLint;
       function GetUsage :GLenum;
       function GetCount :Integer;
       procedure SetCount( const Count_:Integer );
       function GetItems( const I_:Integer ) :_TYPE_;
       procedure SetItems( const I_:Integer; const Item_:_TYPE_ );
       ///// メソッド
       function InitAlign :GLint; virtual;
       function InitStrid :GLint;
     public
       constructor Create( const Usage_:GLenum );
       destructor Destroy; override;
       ///// プロパティ
       property Kind                      :GLenum  read GetKind                ;
       property Align                     :GLint   read GetAlign               ;
       property Strid                     :GLint   read GetStrid               ;
       property Usage                     :GLenum  read GetUsage               ;
       property Count                     :Integer read GetCount write SetCount;
       property Items[ const I_:Integer ] :_TYPE_  read GetItems write SetItems; default;
       ///// メソッド
       procedure Bind;
       procedure Unbind;
       procedure Use; virtual;
       procedure Unuse; virtual;
       procedure Import( const Array_:array of _TYPE_ );
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLBuffer<_TYPE_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TGLBuffer<_TYPE_>.GetAlign :GLint;
begin
     Result := _Align;
end;

function TGLBuffer<_TYPE_>.GetStrid :GLint;
begin
     Result := _Strid;
end;

function TGLBuffer<_TYPE_>.GetUsage :GLenum;
begin
     Result := _Usage;
end;

function TGLBuffer<_TYPE_>.GetCount :Integer;
begin
     Result := _Count;
end;

procedure TGLBuffer<_TYPE_>.SetCount( const Count_:Integer );
begin
     _Count := Count_;

     SetLength( _Items, _Strid * _Count );  upItems := True;
end;

function TGLBuffer<_TYPE_>.GetItems( const I_:Integer ) :_TYPE_;
begin
     Result := PTYPE( @_Items[ _Strid * I_ ] )^;
end;

procedure TGLBuffer<_TYPE_>.SetItems( const I_:Integer; const Item_:_TYPE_ );
begin
     PTYPE( @_Items[ _Strid * I_ ] )^ := Item_;  upItems := True;
end;

/////////////////////////////////////////////////////////////////////// メソッド

function TGLBuffer<_TYPE_>.InitAlign :GLint;
begin
     Result := 1;
end;

function TGLBuffer<_TYPE_>.InitStrid :GLint;
var
   M :Integer;
begin
     Result := SizeOf( _TYPE_ );

     M := Result mod _Align;

     if M > 0 then Inc( Result, _Align - M );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLBuffer<_TYPE_>.Create( const Usage_:GLenum );
begin
     inherited Create;

     _Align := InitAlign;
     _Strid := InitStrid;

     glGenBuffers( 1, @_ID );

     _Usage := Usage_;
      Count := 0;
end;

destructor TGLBuffer<_TYPE_>.Destroy;
begin
     glDeleteBuffers( 1, @_ID );

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLBuffer<_TYPE_>.Bind;
begin
     glBindBuffer( GetKind, _ID );
end;

procedure TGLBuffer<_TYPE_>.Unbind;
begin
     glBindBuffer( GetKind, 0 );
end;

//------------------------------------------------------------------------------

procedure TGLBuffer<_TYPE_>.Use;
begin
     Bind;

       if upItems then
       begin
            glBufferData( GetKind, _Strid * _Count, @_Items[ 0 ], _Usage );

            upItems := False;
       end;
end;

procedure TGLBuffer<_TYPE_>.Unuse;
begin
     Unbind;
end;

//------------------------------------------------------------------------------

procedure TGLBuffer<_TYPE_>.Import( const Array_:array of _TYPE_ );
var
   I :Integer;
begin
     Count := Length( Array_ );

     for I := 0 to Count-1 do Items[ I ] := Array_[ I ];
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■