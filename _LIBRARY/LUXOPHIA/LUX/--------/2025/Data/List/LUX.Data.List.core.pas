unit LUX.Data.List.core;

interface //#################################################################### ■

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     TListObject = class;
     TListChildr = class;
     TListParent = class;
     TListEnumer = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListObject

     TListObject = class
     private
     protected
       _Prev :TListChildr;
       _Next :TListChildr;
       ///// アクセス
       function GetPrev :TListChildr; virtual;
       function GetNext :TListChildr; virtual;
       ///// メソッド
       class procedure Bind( const C0_,C1_:TListChildr ); overload; inline;
       class procedure Bind( const C0_,C1_,C2_:TListChildr ); overload; inline;
       class procedure Bind( const C0_,C1_,C2_,C3_:TListChildr ); overload; inline;
     public
       constructor Create; overload; virtual;
       ///// プロパティ
       property Prev :TListChildr read GetPrev;
       property Next :TListChildr read GetNext;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListChildr

     TListChildr = class( TListObject )
     private
       ///// アクセス
       function GetIsOrdered :Boolean;
     protected
       _Parent :TListParent;
       _Order  :Integer;
       ///// プロパティ
       property IsOrdered :Boolean read GetIsOrdered;
       ///// アクセス
       function GetParent :TListParent; virtual;
       procedure SetParent( const Parent_:TListParent ); virtual;
       function GetOrder :Integer; virtual;
       procedure SetOrder( const Order_:Integer ); virtual;
       ///// メソッド
       procedure _Remove;
     public
       constructor Create; overload; override;
       constructor Create( const Parent_:TListParent ); overload; virtual;
       procedure AfterConstruction; override;
       destructor Destroy; override;
       ///// プロパティ
       property Parent :TListParent read GetParent write SetParent;
       property Order  :Integer     read GetOrder  write SetOrder ;
       ///// メソッド
       procedure Remove;
       procedure InsertPrev( const Siblin_:TListChildr );
       procedure InsertNext( const Siblin_:TListChildr );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListParent

     TListParent = class( TListObject )
     private
       ///// アクセス
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
       ///// アクセス
       function GetHeader :TListChildr; virtual;
       function GetTailer :TListChildr; virtual;
       function GetChildrs( const I_:Integer ) :TListChildr; overload; virtual;
       procedure SetChildrs( const I_:Integer; const Childr_:TListChildr ); overload; virtual;
       function GetChildrsN :Integer; virtual;
       ///// プロパティ
       property Origin                      :TListChildr read GetOrigin   write SetOrigin  ;
       property Indexes[ const I_:Integer ] :TListChildr read GetIndexes  write SetIndexes ;
       property IndexesN                    :Integer     read GetIndexesN write SetIndexesN;
       ///// メソッド
       procedure FindTo( const Childr_:TListChildr ); overload;
       procedure FindTo( const Order_:Integer   ); overload;
       procedure InsertBind( const C0_,C1_,C2_:TListChildr );
       procedure _InsertHead( const Childr_:TListChildr );
       procedure _InsertTail( const Childr_:TListChildr );
       ///// イベント
       procedure OnInit; virtual;
       procedure OnInsertChild( const Childr_:TListChildr ); overload; virtual;
       procedure OnRemoveChild( const Childr_:TListChildr ); overload; virtual;
     public
       constructor Create; overload; override;
       destructor Destroy; override;
       ///// プロパティ
       property Header                      :TListChildr read GetHeader                   ;
       property Tailer                      :TListChildr read GetTailer                   ;
       property Childrs[ const I_:Integer ] :TListChildr read GetChildrs  write SetChildrs; default;
       property Items[ const I_:Integer ]   :TListChildr read GetChildrs  write SetChildrs;
       property ChildrsN                    :Integer     read GetChildrsN                 ;
       property Count                       :Integer     read GetChildrsN                 ;
       ///// メソッド
       procedure Clear; virtual;
       procedure InsertHead( const Childr_:TListChildr ); overload;
       procedure InsertTail( const Childr_:TListChildr ); overload;
       procedure Add( const Childr_:TListChildr ); overload;
       class procedure Swap( const C1_,C2_:TListChildr ); overload;
       procedure Swap( const I1_,I2_:Integer ); overload;
       function GetEnumerator: TListEnumer;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListEnumer

     TListEnumer = class
     private
     protected
       _Parent :TListParent;
       _Childr :TListChildr;
       ///// アクセス
       function GetChildr: TListChildr; virtual;
     public
       constructor Create( Parent_:TListParent );
       ///// プロパティ
       property Current :TListChildr read GetChildr;
       ///// メソッド
       function MoveNext :Boolean;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListObject

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TListObject.GetPrev :TListChildr;
begin
     Result := _Prev;
end;

function TListObject.GetNext :TListChildr;
begin
     Result := _Next;
end;

/////////////////////////////////////////////////////////////////////// メソッド

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

/////////////////////////////////////////////////////////////////////// アクセス

function TListChildr.GetIsOrdered :Boolean;
begin
     Result := ( _Order <= _Parent._MaxOrder ) and ( _Parent.Indexes[ _Order ] = Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

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
     if not IsOrdered then _Parent.FindTo( Self );

     Result := _Order;
end;

procedure TListChildr.SetOrder( const Order_:Integer );
begin
     TListParent.Swap( Self, _Parent[ Order_ ] );
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TListChildr._Remove;
begin
     _Parent.OnRemoveChild( Self );

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

/////////////////////////////////////////////////////////////////////// メソッド

procedure TListChildr.Remove;
begin
     if Assigned( _Parent ) then _Remove;
end;

//------------------------------------------------------------------------------

procedure TListChildr.InsertPrev( const Siblin_:TListChildr );
begin
     Siblin_.Remove;

     _Parent.InsertBind( _Prev, Siblin_, Self );

     if IsOrdered then _Parent._MaxOrder := _Order - 1;
end;

procedure TListChildr.InsertNext( const Siblin_:TListChildr );
begin
     Siblin_.Remove;

     _Parent.InsertBind( Self, Siblin_, _Next );

     if IsOrdered then _Parent._MaxOrder := _Order;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListParent

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

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

/////////////////////////////////////////////////////////////////////// アクセス

function TListParent.GetHeader :TListChildr;
begin
     if _ChildrsN = 0 then OnInit;

     Result := Origin._Next;
end;

function TListParent.GetTailer :TListChildr;
begin
     if _ChildrsN = 0 then OnInit;

     Result := Origin._Prev;
end;

//------------------------------------------------------------------------------

function TListParent.GetChildrs( const I_:Integer ) :TListChildr;
begin
     if _ChildrsN = 0 then OnInit;

     if I_ > _MaxOrder then FindTo( I_ );

     Result := Indexes[ I_ ];
end;

procedure TListParent.SetChildrs( const I_:Integer; const Childr_:TListChildr );
var
   S :TListChildr;
begin
     with Childrs[ I_ ] do
     begin
          S := Childrs[ I_ ]._Prev;

          Remove;
     end;

     S.InsertNext( Childr_ );
end;

//------------------------------------------------------------------------------

function TListParent.GetChildrsN :Integer;
begin
     if _ChildrsN = 0 then OnInit;

     Result := _ChildrsN;
end;

/////////////////////////////////////////////////////////////////////// メソッド

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

     OnInsertChild( C1_ );
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

/////////////////////////////////////////////////////////////////////// イベント

procedure TListParent.OnInit;
begin

end;

//------------------------------------------------------------------------------

procedure TListParent.OnInsertChild( const Childr_:TListChildr );
begin

end;

procedure TListParent.OnRemoveChild( const Childr_:TListChildr );
begin

end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TListParent.Create;
begin
     inherited;

      IndexesN := 0;
      Origin   := Origin;
     _MaxOrder := -1;
     _ChildrsN := 0;
end;

destructor TListParent.Destroy;
begin
     Clear;

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TListParent.Clear;
var
   N :Integer;
begin
     for N := 1 to _ChildrsN do Origin._Prev.Free;
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
     Result := TListEnumer.Create( Self );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TListEnumer

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TListEnumer.GetChildr: TListChildr;
begin
     Result := _Childr;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TListEnumer.Create( Parent_:TListParent );
begin
     inherited Create;

     with Parent_ do if _ChildrsN = 0 then OnInit;

     _Parent := Parent_;
     _Childr := Parent_.Origin;
end;

/////////////////////////////////////////////////////////////////////// メソッド

function TListEnumer.MoveNext :Boolean;
begin
     _Childr := _Childr.Next;

     Result := _Childr <> _Parent.Origin;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

end. //######################################################################### ■
