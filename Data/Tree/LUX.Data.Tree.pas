unit LUX.Data.Tree;

interface //#################################################################### ■

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     TTreeAtom                                   = class;
       TTreeItem                                 = class;
         TTreeRoot                               = class;
           TTreeRoot<_TChild_:class>             = class;
         TTreeZero                               = class;
           TTreeNode                             = class;
             TTreeNode<_TParent_,_TChild_:class> = class;
               TTreeNode<_TNode_:class>          = class;
           TTreeLeaf                             = class;
             TTreeLeaf<_TParent_:class>          = class;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNodeProc<_INode_>

     TNodeProc<_TNode_:class> = reference to procedure( const Node_:_TNode_ );

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChildTable

     TChildTable = class
     private
       _Childs :TArray<TTreeItem>;
       ///// アクセス
       function GetChilds( I_:Integer ) :TTreeItem;
       procedure SetChilds( I_:Integer; const Value_:TTreeItem );
       function GetCount :Integer;
       procedure SetCount( const Count_:Integer );
     public
       constructor Create;
       ///// プロパティ
       property Childs[ I_:Integer ] :TTreeItem read GetChilds write SetChilds; default;
       property Count                :Integer   read GetCount  write SetCount ;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeAtom

     TTreeAtom = class
     private
       ///// アクセス
       function Get_Parent :TTreeItem; virtual;
       procedure Set_Parent( const Parent_:TTreeItem ); virtual;
       function Get_Order :Integer; virtual;
       procedure Set_Order( const Order_:Integer ); virtual;
       function Get_Prev :TTreeItem; virtual;
       procedure Set_Prev( const Prev_:TTreeItem ); virtual;
       function Get_Next :TTreeItem; virtual;
       procedure Set_Next( const Next_:TTreeItem ); virtual;
       function Get_Childs :TChildTable; virtual;
       procedure Set_Childs( const Childs_:TChildTable ); virtual;
       function Get_ChildsN :Integer; virtual;
       procedure Set_ChildsN( const ChildsN_:Integer ); virtual;
       function Get_MaxOrder :Integer; virtual;
       procedure Set_MaxOrder( const MaxOrder_:Integer ); virtual;
     protected
       ///// プロパティ
       property _Parent   :TTreeItem   read Get_Parent   write Set_Parent  ;
       property _Order    :Integer     read Get_Order    write Set_Order   ;
       property _Prev     :TTreeItem   read Get_Prev     write Set_Prev    ;
       property _Next     :TTreeItem   read Get_Next     write Set_Next    ;
       property _Childs   :TChildTable read Get_Childs   write Set_Childs  ;
       property _ChildsN  :Integer     read Get_ChildsN  write Set_ChildsN ;
       property _MaxOrder :Integer     read Get_MaxOrder write Set_MaxOrder;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeItem

     TTreeItem = class( TTreeAtom )
     private
       ///// アクセス
       function Get_Zero :TTreeItem;
       procedure Set_Zero( const Zero_:TTreeItem );
       function GetIsOrdered :Boolean;
       ///// メソッド
       class procedure Bind( const C0_,C1_:TTreeItem ); overload; inline;
       class procedure Bind( const C0_,C1_,C2_:TTreeItem ); overload; inline;
       class procedure Bind( const C0_,C1_,C2_,C3_:TTreeItem ); overload; inline;
     protected
       ///// アクセス
       function GetParent :TTreeItem;
       procedure SetParent( const Parent_:TTreeItem );
       function GetOrder :Integer;
       procedure SetOrder( const Order_:Integer );
       function GetHead :TTreeItem;
       function GetTail :TTreeItem;
       function GetChilds( const I_:Integer ) :TTreeItem;
       procedure SetChilds( const I_:Integer; const Child_:TTreeItem );
       function GetChildsN :Integer;
       function GetRootNode :TTreeItem;
       ///// プロパティ
       property _Zero     :TTreeItem read Get_Zero     write Set_Zero;
       property IsOrdered :Boolean   read GetIsOrdered               ;
       ///// メソッド
       procedure FindTo( const Child_:TTreeItem ); overload;
       procedure FindTo( const Order_:Integer   ); overload;
       procedure _Insert( const C0_,C1_,C2_:TTreeItem );
       procedure _Remove;
       procedure _InsertHead( const Child_:TTreeItem );
       procedure _InsertTail( const Child_:TTreeItem );
       procedure _InsertPrev( const Sibli_:TTreeItem );
       procedure _InsertNext( const Sibli_:TTreeItem );
       procedure OnInsertChild( const Child_:TTreeItem ); virtual;
       procedure OnRemoveChild( const Child_:TTreeItem ); virtual;
     public
       ///// プロパティ
       property Parent                     :TTreeItem read GetParent   write SetParent;
       property Order                      :Integer   read GetOrder    write SetOrder ;
       property Head                       :TTreeItem read GetHead                    ;
       property Tail                       :TTreeItem read GetTail                    ;
       property Childs[ const I_:Integer ] :TTreeItem read GetChilds   write SetChilds; default;
       property ChildsN                    :Integer   read GetChildsN                 ;
       property RootNode                   :TTreeItem read GetRootNode                ;
       ///// メソッド
       procedure Remove;
       class procedure RemoveChild( const Child_:TTreeItem );
       procedure DeleteChilds; virtual;
       procedure InsertHead( const Child_:TTreeItem );
       procedure InsertTail( const Child_:TTreeItem );
       procedure InsertPrev( const Sibli_:TTreeItem );
       procedure InsertNext( const Sibli_:TTreeItem );
       class procedure Swap( const C1_,C2_:TTreeItem ); overload;
       procedure Swap( const I1_,I2_:Integer ); overload;
       procedure RunFamily( const Proc_:TNodeProc<TTreeItem> );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeRoot

     TTreeRoot = class( TTreeItem )
     private
       FChilds   :TChildTable;
       FChildsN  :Integer;
       FMaxOrder :Integer;
       ///// アクセス
       function Get_Childs :TChildTable; override;
       procedure Set_Childs( const Childs_:TChildTable ); override;
       function Get_ChildsN :Integer; override;
       procedure Set_ChildsN( const ChildsN_:Integer ); override;
       function Get_MaxOrder :Integer; override;
       procedure Set_MaxOrder( const MaxOrder_:Integer ); override;
     protected
     public
       constructor Create; overload; virtual;
       procedure BeforeDestruction; override;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeRoot<_TChild_>

     TTreeRoot<_TChild_:class> = class( TTreeRoot )
     private
     protected
       ///// アクセス
       function GetHead :_TChild_; reintroduce;
       function GetTail :_TChild_; reintroduce;
       function GetChilds( const I_:Integer ) :_TChild_; reintroduce;
       procedure SetChilds( const I_:Integer; const Child_:_TChild_ ); reintroduce;
     public
       ///// プロパティ
       property Head                       :_TChild_ read GetHead                  ;
       property Tail                       :_TChild_ read GetTail                  ;
       property Childs[ const I_:Integer ] :_TChild_ read GetChilds write SetChilds; default;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeZero

     TTreeZero = class( TTreeItem )
     private
       FPrev :TTreeItem;
       FNext :TTreeItem;
       ///// アクセス
       function Get_Prev :TTreeItem; override;
       procedure Set_Prev( const Prev_:TTreeItem ); override;
       function Get_Next :TTreeItem; override;
       procedure Set_Next( const Next_:TTreeItem ); override;
     protected
     public
       constructor Create; overload; virtual;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeNode

     TTreeNode = class( TTreeZero )
     private
       FParent   :TTreeItem;
       FOrder    :Integer;
       FChilds   :TChildTable;
       FChildsN  :Integer;
       FMaxOrder :Integer;
       ///// アクセス
       function Get_Parent :TTreeItem; override;
       procedure Set_Parent( const Parent_:TTreeItem ); override;
       function Get_Order :Integer; override;
       procedure Set_Order( const Order_:Integer ); override;
       function Get_Childs :TChildTable; override;
       procedure Set_Childs( const Childs_:TChildTable ); override;
       function Get_ChildsN :Integer; override;
       procedure Set_ChildsN( const ChildsN_:Integer ); override;
       function Get_MaxOrder :Integer; override;
       procedure Set_MaxOrder( const MaxOrder_:Integer ); override;
     protected
     public
       constructor Create; overload; override;
       constructor Create( const Parent_:TTreeItem ); overload; virtual;
       procedure BeforeDestruction; override;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeNode<_TParent_,_TChild_>

     TTreeNode<_TParent_,_TChild_:class> = class( TTreeNode )
     private
     protected
       ///// アクセス
       function GetParent :_TParent_; reintroduce;
       procedure SetParent( const Parent_:_TParent_ ); reintroduce;
       function GetHead :_TChild_; reintroduce;
       function GetTail :_TChild_; reintroduce;
       function GetChilds( const I_:Integer ) :_TChild_; reintroduce;
       procedure SetChilds( const I_:Integer; const Child_:_TChild_ ); reintroduce;
     public
       ///// プロパティ
       property Parent                     :_TParent_ read GetParent write SetParent;
       property Head                       :_TChild_  read GetHead                  ;
       property Tail                       :_TChild_  read GetTail                  ;
       property Childs[ const I_:Integer ] :_TChild_  read GetChilds write SetChilds; default;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeNode<_TNode_>

     TTreeNode<_TNode_:class> = class( TTreeNode<_TNode_,_TNode_> ) end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeLeaf

     TTreeLeaf = class( TTreeZero )
     private
       FParent :TTreeItem;
       FOrder  :Integer;
       ///// アクセス
       function Get_Parent :TTreeItem; override;
       procedure Set_Parent( const Parent_:TTreeItem ); override;
       function Get_Order :Integer; override;
       procedure Set_Order( const Order_:Integer ); override;
     protected
     public
       constructor Create; overload; override;
       constructor Create( const Parent_:TTreeItem ); overload; virtual;
       procedure BeforeDestruction; override;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeLeaf<_TParent_>

     TTreeLeaf<_TParent_:class> = class( TTreeLeaf )
     private
     protected
       ///// アクセス
       function GetParent :_TParent_; reintroduce;
       procedure SetParent( const Parent_:_TParent_ ); reintroduce;
     public
       ///// プロパティ
       property Parent :_TParent_ read GetParent write SetParent;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TChildTable

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TChildTable.GetChilds( I_:Integer ) :TTreeItem;
begin
     Inc( I_ );  Result := _Childs[ I_ ];
end;

procedure TChildTable.SetChilds( I_:Integer; const Value_:TTreeItem );
begin
     Inc( I_ );  _Childs[ I_ ] := Value_;
end;

function TChildTable.GetCount :Integer;
begin
     Result := Length( _Childs ) - 1;
end;

procedure TChildTable.SetCount( const Count_:Integer );
begin
     SetLength( _Childs, 1 + Count_ );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TChildTable.Create;
begin
     inherited;

     Count := 0;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeAtom

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeAtom.Get_Parent :TTreeItem;
begin
     Result := nil;
end;

procedure TTreeAtom.Set_Parent( const Parent_:TTreeItem );
begin

end;

function TTreeAtom.Get_Order :Integer;
begin
     Result := -1;
end;

procedure TTreeAtom.Set_Order( const Order_:Integer );
begin

end;

function TTreeAtom.Get_Prev :TTreeItem;
begin
     Result := nil;
end;

procedure TTreeAtom.Set_Prev( const Prev_:TTreeItem );
begin

end;

function TTreeAtom.Get_Next :TTreeItem;
begin
     Result := nil;
end;

procedure TTreeAtom.Set_Next( const Next_:TTreeItem );
begin

end;

function TTreeAtom.Get_Childs :TChildTable;
begin
     Result := nil;
end;

procedure TTreeAtom.Set_Childs( const Childs_:TChildTable );
begin

end;

function TTreeAtom.Get_ChildsN :Integer;
begin
     Result := 0;
end;

procedure TTreeAtom.Set_ChildsN( const ChildsN_:Integer );
begin

end;

function TTreeAtom.Get_MaxOrder :Integer;
begin
     Result := -1;
end;

procedure TTreeAtom.Set_MaxOrder( const MaxOrder_:Integer );
begin

end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeItem

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeItem.Get_Zero :TTreeItem;
begin
     Result := _Childs[ -1 ];
end;

procedure TTreeItem.Set_Zero( const Zero_:TTreeItem );
begin
     _Childs[ -1 ] := Zero_;
end;

//------------------------------------------------------------------------------

function TTreeItem.GetIsOrdered :Boolean;
begin
     Result := ( _Order <= _Parent._MaxOrder )
           and ( _Parent._Childs[ _Order ] = Self );
end;

/////////////////////////////////////////////////////////////////////// メソッド

class procedure TTreeItem.Bind( const C0_,C1_:TTreeItem );
begin
     C0_._Next := C1_;
     C1_._Prev := C0_;
end;

class procedure TTreeItem.Bind( const C0_,C1_,C2_:TTreeItem );
begin
     Bind( C0_, C1_ );
     Bind( C1_, C2_ );
end;

class procedure TTreeItem.Bind( const C0_,C1_,C2_,C3_:TTreeItem );
begin
     Bind( C0_, C1_ );
     Bind( C1_, C2_ );
     Bind( C2_, C3_ );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeItem.GetParent :TTreeItem;
begin
     Result := _Parent;
end;

procedure TTreeItem.SetParent( const Parent_:TTreeItem );
begin
     Remove;

     if Assigned( Parent_ ) then Parent_._InsertTail( Self );
end;

//------------------------------------------------------------------------------

function TTreeItem.GetOrder :Integer;
begin
     if not IsOrdered then _Parent.FindTo( Self );

     Result := _Order;
end;

procedure TTreeItem.SetOrder( const Order_:Integer );
begin
     Swap( Self, _Parent.Childs[ Order_ ] );
end;

//------------------------------------------------------------------------------

function TTreeItem.GetHead :TTreeItem;
begin
     Result := _Zero._Next;
end;

function TTreeItem.GetTail :TTreeItem;
begin
     Result := _Zero._Prev;
end;

//------------------------------------------------------------------------------

function TTreeItem.GetChilds( const I_:Integer ) :TTreeItem;
begin
     if I_ > _MaxOrder then FindTo( I_ );

     Result := _Childs[ I_ ];
end;

procedure TTreeItem.SetChilds( const I_:Integer; const Child_:TTreeItem );
var
   S :TTreeItem;
begin
     with Childs[ I_ ] do
     begin
          S := Childs[ I_ ]._Prev;

          Remove;
     end;

     S.InsertNext( Child_ );
end;

function TTreeItem.GetChildsN :Integer;
begin
     Result := _ChildsN;
end;

function TTreeItem.GetRootNode :TTreeItem;
begin
     Result := Self;

     while Assigned( Result.Parent ) do Result := Result.Parent;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TTreeItem.FindTo( const Child_:TTreeItem );
var
   P :TTreeItem;
begin
     if _ChildsN > _Childs.Count then _Childs.Count := _ChildsN;

     P := _Childs[ _MaxOrder ];

     repeat
           P := P._Next;

           _MaxOrder := _MaxOrder + 1;

           _Childs[ _MaxOrder ] := P;  P._Order := _MaxOrder;

     until P = Child_;
end;

procedure TTreeItem.FindTo( const Order_:Integer );
var
   P :TTreeItem;
   I :Integer;
begin
     if _ChildsN > _Childs.Count then _Childs.Count := _ChildsN;

     P := _Childs[ _MaxOrder ];

     for I := _MaxOrder + 1 to Order_ do
     begin
           P := P._Next;

           _Childs[ I ] := P;  P._Order := I;
     end;

     _MaxOrder := Order_;
end;

//------------------------------------------------------------------------------

procedure TTreeItem._Insert( const C0_,C1_,C2_:TTreeItem );
begin
     C1_._Parent := Self;

     Bind( C0_, C1_, C2_ );

     _ChildsN := _ChildsN + 1;

     OnInsertChild( C1_ );
end;

procedure TTreeItem._Remove;
begin
     Bind( _Prev, _Next );

     if IsOrdered then _Parent._MaxOrder := _Order - 1;

     with _Parent do
     begin
          _ChildsN := _ChildsN - 1;

          if _ChildsN * 2 < _Childs.Count then _Childs.Count := _ChildsN;

          OnRemoveChild( Self );
     end;

     _Parent := nil;  _Order := -1;
end;

//------------------------------------------------------------------------------

procedure TTreeItem._InsertHead( const Child_:TTreeItem );
begin
     _Insert( _Zero, Child_, Head );

     _MaxOrder := -1;  { if Head.IsOrdered then _MaxOrder := Head._Order - 1; }
end;

procedure TTreeItem._InsertTail( const Child_:TTreeItem );
begin
     _Insert( Tail, Child_, _Zero );

     { if Tail.IsOrdered then _MaxOrder := Tail._Order; }
end;

procedure TTreeItem._InsertPrev( const Sibli_:TTreeItem );
begin
     _Parent._Insert( _Prev, Sibli_, Self );

     if IsOrdered then _Parent._MaxOrder := _Order - 1;
end;

procedure TTreeItem._InsertNext( const Sibli_:TTreeItem );
begin
     _Parent._Insert( Self, Sibli_, _Next );

     if IsOrdered then _Parent._MaxOrder := _Order;
end;

//------------------------------------------------------------------------------

procedure TTreeItem.OnInsertChild( const Child_:TTreeItem );
begin
     if Assigned( _Parent ) then _Parent.OnInsertChild( Child_ );
end;

procedure TTreeItem.OnRemoveChild( const Child_:TTreeItem );
begin
     if Assigned( _Parent ) then _Parent.OnRemoveChild( Child_ );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TTreeItem.Remove;
begin
     if Assigned( _Parent ) then _Remove;
end;

class procedure TTreeItem.RemoveChild( const Child_:TTreeItem );
begin
     Child_.Remove;
end;

//------------------------------------------------------------------------------

procedure TTreeItem.DeleteChilds;
var
   N :Integer;
begin
     for N := 1 to _ChildsN do _Zero._Prev.Free;
end;

//------------------------------------------------------------------------------

procedure TTreeItem.InsertHead( const Child_:TTreeItem );
begin
     Child_.Remove;  _InsertHead( Child_ );
end;

procedure TTreeItem.InsertTail( const Child_:TTreeItem );
begin
     Child_.Remove;  _InsertTail( Child_ );
end;

procedure TTreeItem.InsertPrev( const Sibli_:TTreeItem );
begin
     Sibli_.Remove;  _InsertPrev( Sibli_ );
end;

procedure TTreeItem.InsertNext( const Sibli_:TTreeItem );
begin
     Sibli_.Remove;  _InsertNext( Sibli_ );
end;

//------------------------------------------------------------------------------

class procedure TTreeItem.Swap( const C1_,C2_:TTreeItem );
var
   P1, P2,
   C1n, C1u,
   C2n, C2u :TTreeItem;
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
          P1._Childs[ I1 ] := C2_;  C2_._Order := I1;
     end;

     if B2 then
     begin
          P2._Childs[ I2 ] := C1_;  C1_._Order := I2;
     end;
end;

procedure TTreeItem.Swap( const I1_,I2_:Integer );
begin
     Swap( Childs[ I1_ ], Childs[ I2_ ] );
end;

//------------------------------------------------------------------------------

procedure TTreeItem.RunFamily( const Proc_:TNodeProc<TTreeItem> );
var
   I :Integer;
begin
     Proc_( Self );

     for I := 0 to ChildsN-1 do Childs[ I ].RunFamily( Proc_ );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeRoot

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeRoot.Get_Childs :TChildTable;
begin
     Result := FChilds;
end;

procedure TTreeRoot.Set_Childs( const Childs_:TChildTable );
begin
     FChilds := Childs_;
end;

function TTreeRoot.Get_ChildsN :Integer;
begin
     Result := FChildsN;
end;

procedure TTreeRoot.Set_ChildsN( const ChildsN_:Integer );
begin
     FChildsN := ChildsN_;
end;

function TTreeRoot.Get_MaxOrder :Integer;
begin
     Result := FMaxOrder;
end;

procedure TTreeRoot.Set_MaxOrder( const MaxOrder_:Integer );
begin
     FMaxOrder := MaxOrder_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTreeRoot.Create;
begin
     inherited;

     _ChildsN  := 0;

     _Childs   := TChildTable.Create;

     _Zero     := TTreeZero.Create;

     _MaxOrder := -1;
end;

procedure TTreeRoot.BeforeDestruction;
begin
     DeleteChilds;
end;

destructor TTreeRoot.Destroy;
begin
     _Zero  .Free;

     _Childs.Free;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeRoot<_TChild_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeRoot<_TChild_>.GetHead :_TChild_;
begin
     Result := _TChild_( inherited GetHead );
end;

function TTreeRoot<_TChild_>.GetTail :_TChild_;
begin
     Result := _TChild_( inherited GetTail );
end;

//------------------------------------------------------------------------------

function TTreeRoot<_TChild_>.GetChilds( const I_:Integer ) :_TChild_;
begin
     Result := _TChild_( inherited GetChilds( I_ ) );
end;

procedure TTreeRoot<_TChild_>.SetChilds( const I_:Integer; const Child_:_TChild_ );
begin
     inherited SetChilds( I_, TTreeItem( Child_ ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeZero

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeZero.Get_Prev :TTreeItem;
begin
     Result := FPrev;
end;

procedure TTreeZero.Set_Prev( const Prev_:TTreeItem );
begin
     FPrev := Prev_;
end;

function TTreeZero.Get_Next :TTreeItem;
begin
     Result := FNext;
end;

procedure TTreeZero.Set_Next( const Next_:TTreeItem );
begin
     FNext := Next_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTreeZero.Create;
begin
     inherited;

     FPrev := Self;
     FNext := Self;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeNode

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeNode.Get_Parent :TTreeItem;
begin
     Result := FParent;
end;

procedure TTreeNode.Set_Parent( const Parent_:TTreeItem );
begin
     FParent := Parent_;
end;

function TTreeNode.Get_Order :Integer;
begin
     Result := FOrder;
end;

procedure TTreeNode.Set_Order( const Order_:Integer );
begin
     FOrder := Order_;
end;

function TTreeNode.Get_Childs :TChildTable;
begin
     Result := FChilds;
end;

procedure TTreeNode.Set_Childs( const Childs_:TChildTable );
begin
     FChilds := Childs_;
end;

function TTreeNode.Get_ChildsN :Integer;
begin
     Result := FChildsN;
end;

procedure TTreeNode.Set_ChildsN( const ChildsN_:Integer );
begin
     FChildsN := ChildsN_;
end;

function TTreeNode.Get_MaxOrder :Integer;
begin
     Result := FMaxOrder;
end;

procedure TTreeNode.Set_MaxOrder( const MaxOrder_:Integer );
begin
     FMaxOrder := MaxOrder_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTreeNode.Create;
begin
     inherited;

     _Parent   := nil;

     _Order    := -1;

     _ChildsN  := 0;

     _Childs   := TChildTable.Create;

     _Zero     := TTreeZero.Create;

     _MaxOrder := -1;
end;

constructor TTreeNode.Create( const Parent_:TTreeItem );
begin
     Create;

     Parent_._InsertTail( Self );
end;

procedure TTreeNode.BeforeDestruction;
begin
     Remove;

     DeleteChilds;

     inherited;
end;

destructor TTreeNode.Destroy;
begin
     _Zero  .Free;

     _Childs.Free;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeNode<_TParent_,_TChild_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeNode<_TParent_,_TChild_>.GetParent :_TParent_;
begin
     Result := _TParent_( inherited GetParent );
end;

procedure TTreeNode<_TParent_,_TChild_>.SetParent( const Parent_:_TParent_ );
begin
     inherited SetParent( TTreeItem( Parent_ ) );
end;

//------------------------------------------------------------------------------

function TTreeNode<_TParent_,_TChild_>.GetHead :_TChild_;
begin
     Result := _TChild_( inherited GetHead );
end;

function TTreeNode<_TParent_,_TChild_>.GetTail :_TChild_;
begin
     Result := _TChild_( inherited GetTail );
end;

//------------------------------------------------------------------------------

function TTreeNode<_TParent_,_TChild_>.GetChilds( const I_:Integer ) :_TChild_;
begin
     Result := _TChild_( inherited GetChilds( I_ ) );
end;

procedure TTreeNode<_TParent_,_TChild_>.SetChilds( const I_:Integer; const Child_:_TChild_ );
begin
     inherited SetChilds( I_, TTreeItem( Child_ ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeNode<_TNode_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeLeaf

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeLeaf.Get_Parent :TTreeItem;
begin
     Result := FParent;
end;

procedure TTreeLeaf.Set_Parent( const Parent_:TTreeItem );
begin
     FParent := Parent_;
end;

function TTreeLeaf.Get_Order :Integer;
begin
     Result := FOrder;
end;

procedure TTreeLeaf.Set_Order( const Order_:Integer );
begin
     FOrder := Order_;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTreeLeaf.Create;
begin
     inherited;

     _Parent   := nil;

     _Order    := -1;
end;

constructor TTreeLeaf.Create( const Parent_:TTreeItem );
begin
     Create;

     Parent_._InsertTail( Self );
end;

procedure TTreeLeaf.BeforeDestruction;
begin
     Remove;

     inherited;
end;

destructor TTreeLeaf.Destroy;
begin

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeLeaf<_TParent_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeLeaf<_TParent_>.GetParent :_TParent_;
begin
     Result := _TParent_( inherited GetParent );
end;

procedure TTreeLeaf<_TParent_>.SetParent( const Parent_:_TParent_ );
begin
     inherited SetParent( TTreeItem( Parent_ ) );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■
