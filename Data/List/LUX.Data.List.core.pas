unit LUX.Data.List.core;

interface //#################################################################### ■

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     TListObject = class;
     TListChildr = class;
     TListParent = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListEnumer

     // 直下の子の列挙子。レコードなのでヒープ割り当てが無い。
     TListEnumer = record
     private
       _Parent :TListParent;
       _Childr :TListChildr;
       _NextCh :TListChildr;  // 先読み（列挙中の Current 削除を安全にする）
     public
       ///// P R O P E R T Y
       property Current :TListChildr read _Childr;
       ///// M E T H O D
       function MoveNext :Boolean;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListObject

     TListObject = class
     private
     protected
       _Prev :TListChildr;
       _Next :TListChildr;
       ///// A C C E S S O R
       function GetPrev :TListChildr; virtual;
       function GetNext :TListChildr; virtual;
       ///// M E T H O D
       class procedure Bind( const C0_,C1_:TListChildr ); overload; inline;
       class procedure Bind( const C0_,C1_,C2_:TListChildr ); overload; inline;
       class procedure Bind( const C0_,C1_,C2_,C3_:TListChildr ); overload; inline;
     public
       constructor Create; overload; virtual;
       ///// P R O P E R T Y
       property Prev :TListChildr read GetPrev;
       property Next :TListChildr read GetNext;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListChildr

     TListChildr = class( TListObject )
     private
       ///// A C C E S S O R
       function GetIsOrdered :Boolean;
     protected
       _Parent :TListParent;
       _Order  :Integer;
       ///// P R O P E R T Y
       property IsOrdered :Boolean read GetIsOrdered;
       ///// A C C E S S O R
       function GetParent :TListParent; virtual;
       procedure SetParent( const Parent_:TListParent ); virtual;
       function GetOrder :Integer; virtual;
       procedure SetOrder( const Order_:Integer ); virtual;
       ///// M E T H O D
       procedure _Remove;
     public
       constructor Create; overload; override;
       constructor Create( const Parent_:TListParent ); overload; virtual;
       procedure AfterConstruction; override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Parent :TListParent read GetParent write SetParent;
       property Order  :Integer     read GetOrder  write SetOrder ;  // 代入は指定順位のノードとの「交換」であり、間のノードはシフトしない
       ///// M E T H O D
       procedure Remove; virtual;
       procedure InsertPrev( const Siblin_:TListChildr ); virtual;
       procedure InsertNext( const Siblin_:TListChildr ); virtual;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListParent

     TListParent = class( TListObject )
     private
       ///// A C C E S S O R
       function GetOrigin :TListChildr;
       procedure SetOrigin( const Origin_:TListChildr );
       function GetIndexes( const I_:Integer ) :TListChildr;
       procedure SetIndexes( const I_:Integer; const Indexe_:TListChildr );
       function GetIndexesN :Integer;
       procedure SetIndexesN( const IndexesN_:Integer );
     protected
       _Indexes  :TArray<TListChildr>;
       _MaxOrder :Integer;
       _ChildrsN :Integer;
       ///// A C C E S S O R
       function GetHeader :TListChildr; virtual;
       function GetTailer :TListChildr; virtual;
       function GetChildrs( const I_:Integer ) :TListChildr; overload; virtual;
       procedure SetChildrs( const I_:Integer; const Childr_:TListChildr ); overload; virtual;
       function GetChildrsN :Integer; virtual;
       function GetIsEmpty :Boolean;
       function GetOwnereObject :TObject; virtual;
       ///// P R O P E R T Y
       property Origin                      :TListChildr read GetOrigin   write SetOrigin  ;
       property Indexes[ const I_:Integer ] :TListChildr read GetIndexes  write SetIndexes ;
       property IndexesN                    :Integer     read GetIndexesN write SetIndexesN;
       ///// M E T H O D
       procedure FindTo( const Childr_:TListChildr ); overload;
       procedure FindTo( const Order_:Integer   ); overload;
       procedure InsertBind( const C0_,C1_,C2_:TListChildr );
       procedure _InsertHead( const Childr_:TListChildr );
       procedure _InsertTail( const Childr_:TListChildr );
       ///// E V E N T
       procedure OnInit; virtual;
       procedure OnInsertChildr( const Childr_:TListChildr ); overload; virtual;
       procedure OnRemoveChildr( const Childr_:TListChildr ); overload; virtual;
     public
       constructor Create; overload; override;
       destructor Destroy; override;
       ///// P R O P E R T Y
       property Header                      :TListChildr read GetHeader                   ;
       property Tailer                      :TListChildr read GetTailer                   ;
       property Childrs[ const I_:Integer ] :TListChildr read GetChildrs  write SetChildrs; default;
       property Items[ const I_:Integer ]   :TListChildr read GetChildrs  write SetChildrs;
       property ChildrsN                    :Integer     read GetChildrsN                 ;
       property Count                       :Integer     read GetChildrsN                 ;
       property IsEmpty                     :Boolean     read GetIsEmpty                  ;
       property OwnereObject                :TObject     read GetOwnereObject             ;
       ///// M E T H O D
       procedure Clear; virtual;
       procedure InsertHead( const Childr_:TListChildr ); overload; virtual;
       procedure InsertTail( const Childr_:TListChildr ); overload; virtual;
       procedure Add( const Childr_:TListChildr ); overload; virtual;
       class procedure Swap( const C1_,C2_:TListChildr ); overload;
       procedure Swap( const I1_,I2_:Integer ); overload;
       function GetEnumerator: TListEnumer;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.SysUtils;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListEnumer

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

function TListEnumer.MoveNext :Boolean;
begin
     _Childr := _NextCh;  // 次要素を先読みしているため、列挙中の削除は Current に対してのみ安全

     Result := _Childr <> _Parent.Origin;

     if Result then _NextCh := _Childr._Next;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListObject

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TListObject.GetPrev :TListChildr;
begin
     Result := _Prev;
end;

function TListObject.GetNext :TListChildr;
begin
     Result := _Next;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

class procedure TListObject.Bind( const C0_,C1_:TListChildr );
begin
     C0_._Next := C1_;
     C1_._Prev := C0_;
end;

class procedure TListObject.Bind( const C0_,C1_,C2_:TListChildr );
begin
     Bind( C0_, C1_ );
     Bind( C1_, C2_ );
end;

class procedure TListObject.Bind( const C0_,C1_,C2_,C3_:TListChildr );
begin
     Bind( C0_, C1_ );
     Bind( C1_, C2_ );
     Bind( C2_, C3_ );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TListObject.Create;
begin
     inherited;

     _Prev := TListChildr( Self );
     _Next := TListChildr( Self );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListChildr

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TListChildr.GetIsOrdered :Boolean;
begin
     Result := ( _Order <= _Parent._MaxOrder ) and ( _Parent.Indexes[ _Order ] = Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TListChildr.GetParent :TListParent;
begin
     Result := _Parent;
end;

procedure TListChildr.SetParent( const Parent_:TListParent );
begin
     Remove;

     _Parent := Parent_;

     if Assigned( _Parent ) then _Parent._InsertTail( Self );
end;

//------------------------------------------------------------------------------

function TListChildr.GetOrder :Integer;
begin
     if Assigned( _Parent ) then
     begin
          if not IsOrdered then _Parent.FindTo( Self );

          Result := _Order;
     end
     else Result := -1;  // リストに属していない
end;

procedure TListChildr.SetOrder( const Order_:Integer );
begin
     Assert( Assigned( _Parent ), 'TListChildr.SetOrder: 親リストに属していません' );

     TListParent.Swap( Self, _Parent[ Order_ ] );
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TListChildr._Remove;
begin
     _Parent.OnRemoveChildr( Self );

     Bind( _Prev, _Next );

     if IsOrdered then _Parent._MaxOrder := _Order - 1;

     with _Parent do
     begin
          Dec( _ChildrsN );

          if _ChildrsN * 2 < IndexesN then IndexesN := _ChildrsN;
     end;

     _Parent := nil;
     _Order  := -1;
     _Prev   := Self;
     _Next   := Self;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TListChildr.Create;
begin
     inherited;

     _Parent := nil;
     _Order  := -1;
end;

constructor TListChildr.Create( const Parent_:TListParent );
begin
     Create;

     _Parent := Parent_;
end;

procedure TListChildr.AfterConstruction;
begin
     inherited;

     if Assigned( _Parent ) then _Parent._InsertTail( Self );
end;

destructor TListChildr.Destroy;
begin
     Remove;

     inherited;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TListChildr.Remove;
begin
     if not Assigned( _Parent ) then Exit;

     if _Prev = Self then _Parent := nil  // 未連結（構築中の例外など）は切り離すのみ
                     else _Remove;
end;

//------------------------------------------------------------------------------

procedure TListChildr.InsertPrev( const Siblin_:TListChildr );
begin
     Assert( Assigned( _Parent ), 'TListChildr.InsertPrev: 親リストに属していません' );
     Assert( Siblin_ <> Self, 'TListChildr.InsertPrev: 自分自身は挿入できません' );

     Siblin_.Remove;

     Siblin_._Parent := _Parent;

     _Parent.InsertBind( _Prev, Siblin_, Self );

     if IsOrdered then _Parent._MaxOrder := _Order - 1;
end;

procedure TListChildr.InsertNext( const Siblin_:TListChildr );
begin
     Assert( Assigned( _Parent ), 'TListChildr.InsertNext: 親リストに属していません' );
     Assert( Siblin_ <> Self, 'TListChildr.InsertNext: 自分自身は挿入できません' );

     Siblin_.Remove;

     Siblin_._Parent := _Parent;

     _Parent.InsertBind( Self, Siblin_, _Next );

     if IsOrdered then _Parent._MaxOrder := _Order;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListParent

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TListParent.GetOrigin :TListChildr;
begin
     Result := TListChildr( Self );
end;

procedure TListParent.SetOrigin( const Origin_:TListChildr );
begin
     Indexes[ -1 ] := Origin_;
end;

function TListParent.GetIndexes( const I_:Integer ) :TListChildr;
begin
     Result := _Indexes[ 1 + I_ ];
end;

procedure TListParent.SetIndexes( const I_:Integer; const Indexe_:TListChildr );
begin
     _Indexes[ 1 + I_ ] := Indexe_;
end;

function TListParent.GetIndexesN :Integer;
begin
     Result := Length( _Indexes ) - 1;
end;

procedure TListParent.SetIndexesN( const IndexesN_:Integer );
begin
     SetLength( _Indexes, IndexesN_ + 1 );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//////////////////////////////////////////////////////////////// A C C E S S O R

function TListParent.GetHeader :TListChildr;
begin
     if _ChildrsN = 0 then OnInit;

     if _ChildrsN = 0 then Result := nil  // 空のときは nil
                      else Result := Origin._Next;
end;

function TListParent.GetTailer :TListChildr;
begin
     if _ChildrsN = 0 then OnInit;

     if _ChildrsN = 0 then Result := nil  // 空のときは nil
                      else Result := Origin._Prev;
end;

//------------------------------------------------------------------------------

function TListParent.GetChildrs( const I_:Integer ) :TListChildr;
begin
     if _ChildrsN = 0 then OnInit;

     if ( I_ < 0 ) or ( _ChildrsN <= I_ )
     then raise EArgumentOutOfRangeException.CreateFmt( 'TListParent.Childrs[%d]: 添字が範囲外です（Count=%d）', [ I_, _ChildrsN ] );

     if I_ > _MaxOrder then FindTo( I_ );

     Result := Indexes[ I_ ];
end;

procedure TListParent.SetChildrs( const I_:Integer; const Childr_:TListChildr );
var
   O, P :TListChildr;
begin
     O := Childrs[ I_ ];  // 範囲検査+ I_ までのインデックス化

     P := O._Prev;  // P は番兵（Origin）でも良い（以降はリンク操作しか行わない）

     O.Remove;  // 旧ノードは切り離すのみで解放しない（所有権は呼び出し側へ移る）

     Childr_.Remove;

     Childr_._Parent := Self;

     InsertBind( P, Childr_, P._Next );
end;

//------------------------------------------------------------------------------

function TListParent.GetChildrsN :Integer;
begin
     if _ChildrsN = 0 then OnInit;

     Result := _ChildrsN;
end;

//------------------------------------------------------------------------------

function TListParent.GetIsEmpty :Boolean;
begin
     Result := GetChildrsN = 0;
end;

//------------------------------------------------------------------------------

function TListParent.GetOwnereObject :TObject;
begin
     Result := nil;  // 所有者は派生クラス（LUX.Data.List の Ownere 層）が返す
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TListParent.FindTo( const Childr_:TListChildr );
var
   P :TListChildr;
begin
     if _ChildrsN > IndexesN then IndexesN := _ChildrsN;

     P := Indexes[ _MaxOrder ];

     repeat
           P := P._Next;

           Inc( _MaxOrder );

           Indexes[ _MaxOrder ] := P;  P._Order := _MaxOrder;

     until P = Childr_;
end;

procedure TListParent.FindTo( const Order_:Integer );
var
   P :TListChildr;
   I :Integer;
begin
     if _ChildrsN > IndexesN then IndexesN := _ChildrsN;

     P := Indexes[ _MaxOrder ];

     for I := _MaxOrder + 1 to Order_ do
     begin
           P := P._Next;

           Indexes[ I ] := P;  P._Order := I;
     end;

     _MaxOrder := Order_;
end;

//------------------------------------------------------------------------------

procedure TListParent.InsertBind( const C0_,C1_,C2_:TListChildr );
begin
     Bind( C0_, C1_, C2_ );

     Inc( _ChildrsN );

     OnInsertChildr( C1_ );
end;

procedure TListParent._InsertHead( const Childr_:TListChildr );
begin
     _MaxOrder := -1;

     InsertBind( Origin, Childr_, Origin._Next );
end;

procedure TListParent._InsertTail( const Childr_:TListChildr );
begin
     InsertBind( Origin._Prev, Childr_, Origin );
end;

////////////////////////////////////////////////////////////////////// E V E N T

procedure TListParent.OnInit;
begin

end;

//------------------------------------------------------------------------------

procedure TListParent.OnInsertChildr( const Childr_:TListChildr );
begin

end;

procedure TListParent.OnRemoveChildr( const Childr_:TListChildr );
begin

end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TListParent.Create;
begin
     inherited;

      IndexesN := 0;
      Origin   := Origin;  // 番兵（自身）を _Indexes[0] へ格納する初期化イディオム
     _MaxOrder := -1;
     _ChildrsN := 0;
end;

destructor TListParent.Destroy;
begin
     Clear;

     inherited;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

procedure TListParent.Clear;
begin
     while _ChildrsN > 0 do Origin._Prev.Free;  // 子は親の所有であり、ここで解放される（Remove は切り離すのみで解放しない）
end;

//------------------------------------------------------------------------------

procedure TListParent.InsertHead( const Childr_:TListChildr );
begin
     Childr_.Remove;

     Childr_._Parent := Self;

     _InsertHead( Childr_ );
end;

procedure TListParent.InsertTail( const Childr_:TListChildr );
begin
     Childr_.Remove;

     Childr_._Parent := Self;

     _InsertTail( Childr_ );
end;

procedure TListParent.Add( const Childr_:TListChildr );
begin
     InsertTail( Childr_ );
end;

//------------------------------------------------------------------------------

class procedure TListParent.Swap( const C1_,C2_:TListChildr );
var
   P1, P2 :TListParent;
   C1n, C1u,
   C2n, C2u :TListChildr;
   B1, B2 :Boolean;
   I1, I2 :Integer;
begin
     Assert( Assigned( C1_._Parent ) and Assigned( C2_._Parent ), 'TListParent.Swap: 親リストに属していないノードがあります' );

     with C1_ do
     begin
          P1 := _Parent   ;
          B1 :=  IsOrdered;
          I1 := _Order    ;

          C1n := _Prev;
          C1u := _Next;
     end;

     with C2_ do
     begin
          P2 := _Parent   ;
          B2 :=  IsOrdered;
          I2 := _Order    ;

          C2n := _Prev;
          C2u := _Next;
     end;

     C1_._Parent := P2;
     C2_._Parent := P1;

     if C1_ = C2n then Bind( C1n, C2_, C1_, C2u )
     else
     if C1_ = C2u then Bind( C2n, C1_, C2_, C1u )
     else
     begin
          Bind( C1n, C2_, C1u );
          Bind( C2n, C1_, C2u );
     end;

     if B1 then
     begin
          P1.Indexes[ I1 ] := C2_;  C2_._Order := I1;
     end;

     if B2 then
     begin
          P2.Indexes[ I2 ] := C1_;  C1_._Order := I2;
     end;
end;

procedure TListParent.Swap( const I1_,I2_:Integer );
begin
     Swap( Childrs[ I1_ ], Childrs[ I2_ ] );
end;

//------------------------------------------------------------------------------

function TListParent.GetEnumerator: TListEnumer;
begin
     if _ChildrsN = 0 then OnInit;

     Result._Parent := Self;
     Result._Childr := nil;
     Result._NextCh := Origin._Next;  // 空なら Origin ＝ 最初の MoveNext で即終端
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
