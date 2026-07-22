unit LUX.Data.Model.Poins;

interface //#################################################################### ■

uses System.Classes,
     LUX,
     LUX.Data.List;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TPoin<TPos_;TPoinSet_:class> = class;
     TPoinSet<TPos_;TPoin_:class> = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoin<TPos_,TPoinSet_>

     TPoin<TPos_;TPoinSet_:class> = class( TListChildr<TPoinSet_> )
     private
     protected
       _Pos :TPos_;
       ///// A C C E S S O R
       function GetPos :TPos_; virtual;
       procedure SetPos( const Pos_:TPos_ ); virtual;
     public
       constructor Create( const Pos_:TPos_ ); overload;
       constructor Create( const Pos_:TPos_; const Parent_:TPoinSet_ ); overload;
       ///// P R O P E R T Y
       property Pos :TPos_ read GetPos write SetPos;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoinSet<TPos_,TPoin_>

     TPoinSet<TPos_;TPoin_:class> = class( TListParent<TPoin_> )
     private
     protected
       ///// M E T H O D
       function LoadPoin( const Pos_:TPos_ ) :TPoin_; virtual; abstract;  // 読み込む点を生成する。点の型を知る派生が実装する
     public
       ///// M E T H O D
       procedure SaveToStream( const Stream_:TStream ); virtual; abstract;  // 全ての点の座標を書き込む。点の型を知る派生が実装する
       procedure LoadFromStream( const Stream_:TStream; const PoinsN_:Integer ); virtual;  // 座標列から点を生成して置き換える
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoin<TPos_,TPoinSet_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TPoin<TPos_,TPoinSet_>.GetPos :TPos_;
begin
     Result := _Pos;
end;

procedure TPoin<TPos_,TPoinSet_>.SetPos( const Pos_:TPos_ );
begin
     _Pos := Pos_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TPoin<TPos_,TPoinSet_>.Create( const Pos_:TPos_ );
begin
     inherited Create;

     Pos := Pos_;
end;

constructor TPoin<TPos_,TPoinSet_>.Create( const Pos_:TPos_; const Parent_:TPoinSet_ );
begin
     inherited Create( Parent_ );

     Pos := Pos_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TPoinSet<TPos_,TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TPoinSet<TPos_,TPoin_>.LoadFromStream( const Stream_:TStream; const PoinsN_:Integer );
var
   I :Integer;
   V :TPos_;
begin
     Clear;  // 既存の点は置き換わる（点を参照している要素の解放は呼び出し側の責務）

     for I := 1 to PoinsN_ do
     begin
          Stream_.ReadBuffer( V, SizeOf( TPos_ ) );

          LoadPoin( V );  // 生成順 = 保存順 = 点の番号
     end;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
