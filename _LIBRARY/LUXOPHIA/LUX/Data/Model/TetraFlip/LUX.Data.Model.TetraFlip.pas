unit LUX.Data.Model.TetraFlip;

// TetraFlip の型付け層
//
// ・LUX.Data.Model.TriFlip の型付け層と同じ流儀で、点・胞・集合の相互参照プロパティを
//   派生クラスの型へ付け替えるためのジェネリッククラス群。
//     TTetraPoin   <TPos_;TCell_>              … Cell を TCell_ に
//     TTetraPoinSet<TPos_;TPoin_>              … Childrs / 列挙を TPoin_ に
//     TTetraCell   <TPos_;TPoin_,TCell_>       … Poin / Cell を TPoin_ / TCell_ に
//     TTetraCellSet<TPos_;TCell_,TPoinSet_>    … 列挙を TCell_ に、PoinSet を TPoinSet_ に
//   利用側は自分の派生クラスを型引数に与えるだけでよい（自己再帰・相互再帰可）。
//     TMyPoin = class( TTetraPoin<TSingle3D,TMyCell> )
//     TMyCell = class( TTetraCell<TSingle3D,TMyPoin,TMyCell> )
//
//【実装注意】型引数は class 制約のため基底の型とキャスト互換ではない。実装内の
// 相互変換は TObject 経由の二段キャストで行っている。直接キャストに簡略化しないこと。
// また、型引数を返す仮想メソッドを相互再帰の輪の中に置くとコンパイルできないため、
// 型付けアクセサは非仮想（reintroduce のみ）である。

interface //#################################################################### ■

uses LUX.Data.List.core,
     LUX.Data.List,
     LUX.Data.Model.TetraFlip.core;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraPoin<TPos_,TCell_>

     TTetraPoin<TPos_;TCell_:class> = class( TTetraPoin<TPos_> )
     private
     protected
       ///// A C C E S S O R
       function GetCell :TCell_; reintroduce;
       procedure SetCell( const Cell_:TCell_ ); reintroduce;
     public
       ///// P R O P E R T Y
       property Cell :TCell_ read GetCell write SetCell;  // 所属先の胞（アンカー）
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraPoinSet<TPos_,TPoin_>

     TTetraPoinSet<TPos_;TPoin_:class> = class( TTetraPoinSet<TPos_> )
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

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraCell<TPos_,TPoin_,TCell_>

     TTetraCell<TPos_;TPoin_,TCell_:class> = class( TTetraCell<TPos_> )
     private
     protected
       ///// A C C E S S O R
       function GetPoin( const I_:Byte ) :TPoin_; reintroduce;
       procedure SetPoin( const I_:Byte; const Poin_:TPoin_ ); reintroduce;
       function GetCell( const I_:Byte ) :TCell_; reintroduce;
       procedure SetCell( const I_:Byte; const Cell_:TCell_ ); reintroduce;
     public
       ///// P R O P E R T Y
       property Poin[ const I_:Byte ] :TPoin_ read GetPoin write SetPoin;  // 頂点
       property Cell[ const I_:Byte ] :TCell_ read GetCell write SetCell;  // 隣接胞
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraCellSet<TPos_,TCell_,TPoinSet_>

     TTetraCellSet<TPos_;TCell_:class;TPoinSet_:class,constructor> = class( TTetraCellSet<TPos_> )
     private
     protected
       ///// A C C E S S O R
       function GetPoinSet :TPoinSet_; reintroduce;
       procedure SetPoinSet( const PoinSet_:TPoinSet_ ); reintroduce;
       ///// M E T H O D
       function NewPoinSet :TTetraPoinSet<TPos_>; override;  // 点集合を TPoinSet_ として生成する
     public
       ///// P R O P E R T Y
       property PoinSet :TPoinSet_ read GetPoinSet write SetPoinSet;
       ///// M E T H O D
       function GetEnumerator :TListEnumer<TCell_>;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraPoin<TPos_,TCell_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTetraPoin<TPos_,TCell_>.GetCell :TCell_;
begin
     Result := TCell_( TObject( inherited GetCell ) );
end;

procedure TTetraPoin<TPos_,TCell_>.SetCell( const Cell_:TCell_ );
begin
     inherited SetCell( TTetraCell<TPos_>( TObject( Cell_ ) ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraPoinSet<TPos_,TPoin_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTetraPoinSet<TPos_,TPoin_>.GetChildrs( const I_:Integer ) :TPoin_;
begin
     Result := TPoin_( TObject( inherited GetChildrs( I_ ) ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TTetraPoinSet<TPos_,TPoin_>.GetEnumerator :TListEnumer<TPoin_>;
begin
     Result := TListEnumer<TPoin_>.Create( TListParent( Self ).GetEnumerator );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraCell<TPos_,TPoin_,TCell_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTetraCell<TPos_,TPoin_,TCell_>.GetPoin( const I_:Byte ) :TPoin_;
begin
     Result := TPoin_( TObject( inherited GetPoin( I_ ) ) );
end;

procedure TTetraCell<TPos_,TPoin_,TCell_>.SetPoin( const I_:Byte; const Poin_:TPoin_ );
begin
     inherited SetPoin( I_, TTetraPoin<TPos_>( TObject( Poin_ ) ) );
end;

function TTetraCell<TPos_,TPoin_,TCell_>.GetCell( const I_:Byte ) :TCell_;
begin
     Result := TCell_( TObject( inherited GetCell( I_ ) ) );
end;

procedure TTetraCell<TPos_,TPoin_,TCell_>.SetCell( const I_:Byte; const Cell_:TCell_ );
begin
     inherited SetCell( I_, TTetraCell<TPos_>( TObject( Cell_ ) ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTetraCellSet<TPos_,TCell_,TPoinSet_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TTetraCellSet<TPos_,TCell_,TPoinSet_>.GetPoinSet :TPoinSet_;
begin
     Result := TPoinSet_( TObject( inherited GetPoinSet ) );
end;

procedure TTetraCellSet<TPos_,TCell_,TPoinSet_>.SetPoinSet( const PoinSet_:TPoinSet_ );
begin
     inherited SetPoinSet( TTetraPoinSet<TPos_>( TObject( PoinSet_ ) ) );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TTetraCellSet<TPos_,TCell_,TPoinSet_>.NewPoinSet :TTetraPoinSet<TPos_>;
begin
     Result := TTetraPoinSet<TPos_>( TObject( TPoinSet_.Create ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

function TTetraCellSet<TPos_,TCell_,TPoinSet_>.GetEnumerator :TListEnumer<TCell_>;
begin
     Result := TListEnumer<TCell_>.Create( TListParent( Self ).GetEnumerator );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
