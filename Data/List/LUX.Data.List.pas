unit LUX.Data.List;

interface //#################################################################### ■

uses LUX.Data.List.core;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TListChildr<TParent_:class> = class;
     TListParent<TChildr_:class> = class;

     TListChildr<TOwnere_,TParent_:class> = class;
     TListParent<TOwnere_,TChildr_:class> = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListEnumer<TChildr_>

     // 列挙子の型付け層。核のレコードを包んで転送する。
     TListEnumer<TChildr_:class> = record
     private
       _Enumer :TListEnumer;
       ///// A C C E S S O R
       function GetCurrent :TChildr_; inline;
     public
       constructor Create( const Enumer_:TListEnumer );  // 派生リストが列挙子を型付けし直すために使う
       ///// P R O P E R T Y
       property Current :TChildr_ read GetCurrent;
       ///// M E T H O D
       function MoveNext :Boolean; inline;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListChildr<TParent_>

     TListChildr<TParent_:class> = class( TListChildr )
     private
     protected
       ///// A C C E S S O R
       // virtual 化すると、深いジェネリック連鎖の実体化で dcc64 内部エラー（F2084: URW1402）が生じるため非仮想とする
       function GetParent :TParent_; reintroduce;
       procedure SetParent( const Parent_:TParent_ ); reintroduce;
     public
       constructor Create( const Parent_:TParent_ ); overload; virtual;
       ///// P R O P E R T Y
       property Parent :TParent_ read GetParent write SetParent;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListParent<TChildr_>

     // TChildr_ には TListChildr の「真の派生クラス」を指定すること（基底そのものだと overload が衝突する）
     TListParent<TChildr_:class> = class( TListParent )
     private
     protected
       ///// A C C E S S O R
       function GetHeader :TChildr_; reintroduce; virtual;
       function GetTailer :TChildr_; reintroduce; virtual;
       function GetChildrs( const I_:Integer ) :TChildr_; reintroduce; virtual;
       procedure SetChildrs( const I_:Integer; const Childr_:TChildr_ ); reintroduce; virtual;
       ///// E V E N T
       procedure OnInsertChildr( const Childr_:TListChildr ); override;
       procedure OnRemoveChildr( const Childr_:TListChildr ); override;
       procedure OnInsertChildr( const Childr_:TChildr_ ); overload; virtual;
       procedure OnRemoveChildr( const Childr_:TChildr_ ); overload; virtual;
     public
       ///// P R O P E R T Y
       property Header                      :TChildr_ read GetHeader                  ;
       property Tailer                      :TChildr_ read GetTailer                  ;
       property Childrs[ const I_:Integer ] :TChildr_ read GetChildrs write SetChildrs; default;
       property Items[ const I_:Integer ]   :TChildr_ read GetChildrs write SetChildrs;
       ///// M E T H O D
       procedure InsertHead( const Childr_:TChildr_ ); overload; virtual;
       procedure InsertTail( const Childr_:TChildr_ ); overload; virtual;
       procedure Add( const Childr_:TChildr_ ); overload; virtual;
       function GetEnumerator: TListEnumer<TChildr_>;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListChildr<TOwnere_,TParent_>

     TListChildr<TOwnere_,TParent_:class> = class( TListChildr<TParent_> )
     private
     protected
       ///// A C C E S S O R
       function GetOwnere :TOwnere_;
     public
       ///// P R O P E R T Y
       property Ownere :TOwnere_ read GetOwnere;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListParent<TOwnere_,TChildr_>

     TListParent<TOwnere_,TChildr_:class> = class( TListParent<TChildr_> )
     private
     protected
       _Ownere :TOwnere_;
       ///// A C C E S S O R
       function GetOwnereObject :TObject; override;
       function GetOwnere :TOwnere_;
     public
       constructor Create; overload; override;
       constructor Create( const Ownere_:TOwnere_ ); overload; virtual;
       ///// P R O P E R T Y
       property Ownere :TOwnere_ read GetOwnere;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListEnumer<TChildr_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TListEnumer<TChildr_>.GetCurrent :TChildr_;
begin
     Result := TChildr_( _Enumer.Current );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TListEnumer<TChildr_>.Create( const Enumer_:TListEnumer );
begin
     _Enumer := Enumer_;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TListEnumer<TChildr_>.MoveNext :Boolean;
begin
     Result := _Enumer.MoveNext;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListChildr<TParent_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TListChildr<TParent_>.GetParent :TParent_;
begin
     Result := TParent_( inherited Parent );
end;

procedure TListChildr<TParent_>.SetParent( const Parent_:TParent_ );
begin
     inherited Parent := TListParent( Parent_ );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TListChildr<TParent_>.Create( const Parent_:TParent_ );
begin
     inherited Create( TListParent( Parent_ ) );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListParent<TChildr_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TListParent<TChildr_>.GetHeader :TChildr_;
begin
     Result := TChildr_( inherited Header );
end;

function TListParent<TChildr_>.GetTailer :TChildr_;
begin
     Result := TChildr_( inherited Tailer );
end;

//------------------------------------------------------------------------------

function TListParent<TChildr_>.GetChildrs( const I_:Integer ) :TChildr_;
begin
     Result := TChildr_( inherited Childrs[ I_ ] );
end;

procedure TListParent<TChildr_>.SetChildrs( const I_:Integer; const Childr_:TChildr_ );
begin
     inherited Childrs[ I_ ] := TListChildr( Childr_ );
end;

////////////////////////////////////////////////////////////////////// E V E N T

procedure TListParent<TChildr_>.OnInsertChildr( const Childr_:TListChildr );
begin
     OnInsertChildr( TChildr_( Childr_ ) );
end;

procedure TListParent<TChildr_>.OnRemoveChildr( const Childr_:TListChildr );
begin
     OnRemoveChildr( TChildr_( Childr_ ) );
end;

procedure TListParent<TChildr_>.OnInsertChildr( const Childr_:TChildr_ );
begin

end;

procedure TListParent<TChildr_>.OnRemoveChildr( const Childr_:TChildr_ );
begin

end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TListParent<TChildr_>.InsertHead( const Childr_:TChildr_ );
begin
     inherited InsertHead( TListChildr( Childr_ ) );
end;

procedure TListParent<TChildr_>.InsertTail( const Childr_:TChildr_ );
begin
     inherited InsertTail( TListChildr( Childr_ ) );
end;

procedure TListParent<TChildr_>.Add( const Childr_:TChildr_ );
begin
     inherited Add( TListChildr( Childr_ ) );
end;

//------------------------------------------------------------------------------

function TListParent<TChildr_>.GetEnumerator: TListEnumer<TChildr_>;
begin
     Result._Enumer := inherited GetEnumerator;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListChildr<TOwnere_,TParent_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TListChildr<TOwnere_,TParent_>.GetOwnere :TOwnere_;
begin
     if Assigned( _Parent ) then Result := TOwnere_( _Parent.OwnereObject )  // 仮想メソッド経由のため、親のジェネリック実体に依存しない
                            else Result := nil;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListParent<TOwnere_,TChildr_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TListParent<TOwnere_,TChildr_>.GetOwnereObject :TObject;
begin
     Result := _Ownere;
end;

//------------------------------------------------------------------------------

function TListParent<TOwnere_,TChildr_>.GetOwnere :TOwnere_;
begin
     Result := _Ownere;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TListParent<TOwnere_,TChildr_>.Create;
begin
     inherited;

     _Ownere := nil;
end;

constructor TListParent<TOwnere_,TChildr_>.Create( const Ownere_:TOwnere_ );
begin
     Create;

     _Ownere := Ownere_;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
