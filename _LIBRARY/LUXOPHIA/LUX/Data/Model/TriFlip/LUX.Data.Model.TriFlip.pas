unit LUX.Data.Model.TriFlip;

// TriFlip の型付け層
//
// ・LUX.Data.List / LUX.Data.Tree の型付け層と同じ流儀で、点・面・集合の相互参照
//   プロパティを派生クラスの型へ付け替えるためのジェネリッククラス群。
//     TTriPoin   <TPos_;TFace_>            … Face を TFace_ に
//     TTriPoinSet<TPos_;TPoin_>            … Childrs / 列挙を TPoin_ に
//     TTriFace   <TPos_;TPoin_,TFace_>     … Poin / Face を TPoin_ / TFace_ に
//     TTriFaceSet<TPos_;TFace_,TPoinSet_>  … 列挙を TFace_ に、PoinSet を TPoinSet_ に
//   利用側は自分の派生クラスを型引数に与えるだけでよい（自己再帰・相互再帰可）。
//     TMyPoin = class( TTriPoin<TSingle2D,TMyFace> )
//     TMyFace = class( TTriFace<TSingle2D,TMyPoin,TMyFace> )
//
//【実装注意】型引数は class 制約のため基底の型とキャスト互換ではない。実装内の
// 相互変換は TObject 経由の二段キャストで行っている。直接キャストに簡略化しないこと。
// また、型引数を返す仮想メソッドを相互再帰の輪の中に置くとコンパイルできないため、
// 型付けアクセサは非仮想（reintroduce のみ）である。

interface //#################################################################### ■

uses LUX.Data.List.core,
     LUX.Data.List,
     LUX.Data.Model.TriFlip.core;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriPoin<TPos_,TFace_>

     TTriPoin<TPos_;TFace_:class> = class( TTriPoin<TPos_> )
     private
     protected
       ///// A C C E S S O R
       function GetFace :TFace_; reintroduce;
       procedure SetFace( const Face_:TFace_ ); reintroduce;
     public
       ///// P R O P E R T Y
       property Face :TFace_ read GetFace write SetFace;  // 所属先の面（アンカー）
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriPoinSet<TPos_,TPoin_>

     TTriPoinSet<TPos_;TPoin_:class> = class( TTriPoinSet<TPos_> )
     private
     protected
       ///// A C C E S S O R
       function GetChildrs( const I_:Integer ) :TPoin_; reintroduce;
     public
       ///// P R O P E R T Y
       property Childrs[ const I_:Integer ] :TPoin_ read GetChildrs; default;
       ///// M E T H O D
       function GetEnumerator :TListEnumer<TPoin_>;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriFace<TPos_,TPoin_,TFace_>

     TTriFace<TPos_;TPoin_,TFace_:class> = class( TTriFace<TPos_> )
     private
     protected
       ///// A C C E S S O R
       function GetPoin( const I_:Byte ) :TPoin_; reintroduce;
       procedure SetPoin( const I_:Byte; const Poin_:TPoin_ ); reintroduce;
       function GetFace( const I_:Byte ) :TFace_; reintroduce;
       procedure SetFace( const I_:Byte; const Face_:TFace_ ); reintroduce;
     public
       ///// P R O P E R T Y
       property Poin[ const I_:Byte ] :TPoin_ read GetPoin write SetPoin;  // 頂点
       property Face[ const I_:Byte ] :TFace_ read GetFace write SetFace;  // 隣接面
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriFaceSet<TPos_,TFace_,TPoinSet_>

     TTriFaceSet<TPos_;TFace_:class;TPoinSet_:class,constructor> = class( TTriFaceSet<TPos_> )
     private
     protected
       ///// A C C E S S O R
       function GetPoinSet :TPoinSet_; reintroduce;
       procedure SetPoinSet( const PoinSet_:TPoinSet_ ); reintroduce;
       ///// M E T H O D
       function NewPoinSet :TTriPoinSet<TPos_>; override;  // 点集合を TPoinSet_ として生成する
     public
       ///// P R O P E R T Y
       property PoinSet :TPoinSet_ read GetPoinSet write SetPoinSet;
       ///// M E T H O D
       function GetEnumerator :TListEnumer<TFace_>;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriPoin<TPos_,TFace_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTriPoin<TPos_,TFace_>.GetFace :TFace_;
begin
     Result := TFace_( TObject( inherited GetFace ) );
end;

procedure TTriPoin<TPos_,TFace_>.SetFace( const Face_:TFace_ );
begin
     inherited SetFace( TTriFace<TPos_>( TObject( Face_ ) ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriPoinSet<TPos_,TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTriPoinSet<TPos_,TPoin_>.GetChildrs( const I_:Integer ) :TPoin_;
begin
     Result := TPoin_( TObject( inherited GetChildrs( I_ ) ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TTriPoinSet<TPos_,TPoin_>.GetEnumerator :TListEnumer<TPoin_>;
begin
     Result := TListEnumer<TPoin_>.Create( TListParent( Self ).GetEnumerator );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriFace<TPos_,TPoin_,TFace_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTriFace<TPos_,TPoin_,TFace_>.GetPoin( const I_:Byte ) :TPoin_;
begin
     Result := TPoin_( TObject( inherited GetPoin( I_ ) ) );
end;

procedure TTriFace<TPos_,TPoin_,TFace_>.SetPoin( const I_:Byte; const Poin_:TPoin_ );
begin
     inherited SetPoin( I_, TTriPoin<TPos_>( TObject( Poin_ ) ) );
end;

function TTriFace<TPos_,TPoin_,TFace_>.GetFace( const I_:Byte ) :TFace_;
begin
     Result := TFace_( TObject( inherited GetFace( I_ ) ) );
end;

procedure TTriFace<TPos_,TPoin_,TFace_>.SetFace( const I_:Byte; const Face_:TFace_ );
begin
     inherited SetFace( I_, TTriFace<TPos_>( TObject( Face_ ) ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTriFaceSet<TPos_,TFace_,TPoinSet_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTriFaceSet<TPos_,TFace_,TPoinSet_>.GetPoinSet :TPoinSet_;
begin
     Result := TPoinSet_( TObject( inherited GetPoinSet ) );
end;

procedure TTriFaceSet<TPos_,TFace_,TPoinSet_>.SetPoinSet( const PoinSet_:TPoinSet_ );
begin
     inherited SetPoinSet( TTriPoinSet<TPos_>( TObject( PoinSet_ ) ) );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TTriFaceSet<TPos_,TFace_,TPoinSet_>.NewPoinSet :TTriPoinSet<TPos_>;
begin
     Result := TTriPoinSet<TPos_>( TObject( TPoinSet_.Create ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TTriFaceSet<TPos_,TFace_,TPoinSet_>.GetEnumerator :TListEnumer<TFace_>;
begin
     Result := TListEnumer<TFace_>.Create( TListParent( Self ).GetEnumerator );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
