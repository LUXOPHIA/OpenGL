unit LUX.Data.Tree.core;

interface //#################################################################### ■

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     TTreeAtom   = class;
       TTreeItem = class;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TNodeProc<_INode_>

     TNodeProc<_TNode_:class> = reference to procedure( const Node_:_TNode_ );

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeAtom

     TTreeAtom = class
     private
     protected
       ///// アクセス
       function Get_Parent :TTreeItem; virtual;
       procedure Set_Parent( const Parent_:TTreeItem ); virtual;
       function Get_Order :Integer; virtual;
       procedure Set_Order( const Order_:Integer ); virtual;
       function Get_Prev :TTreeItem; virtual;
       procedure Set_Prev( const Prev_:TTreeItem ); virtual;
       function Get_Next :TTreeItem; virtual;
       procedure Set_Next( const Next_:TTreeItem ); virtual;
       function Get_Links( const I_:Integer ) :TTreeItem; virtual;
       procedure Set_Links( const I_:Integer; const Link_:TTreeItem ); virtual;
       function Get_LinksN :Integer; virtual;
       procedure Set_LinksN( const LinksN_:Integer ); virtual;
       function Get_ChildsN :Integer; virtual;
       procedure Set_ChildsN( const ChildsN_:Integer ); virtual;
       function Get_MaxOrder :Integer; virtual;
       procedure Set_MaxOrder( const MaxOrder_:Integer ); virtual;
       ///// プロパティ
       property _Parent                    :TTreeItem read Get_Parent   write Set_Parent  ;
       property _Order                     :Integer   read Get_Order    write Set_Order   ;
       property _Prev                      :TTreeItem read Get_Prev     write Set_Prev    ;
       property _Next                      :TTreeItem read Get_Next     write Set_Next    ;
       property _Links[ const I_:Integer ] :TTreeItem read Get_Links    write Set_Links   ;
       property _LinksN                    :Integer   read Get_LinksN   write Set_LinksN  ;
       property _ChildsN                   :Integer   read Get_ChildsN  write Set_ChildsN ;
       property _MaxOrder                  :Integer   read Get_MaxOrder write Set_MaxOrder;
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
       procedure RemoveChild( const Child_:TTreeItem );
       procedure DeleteChilds; virtual;
       procedure _InsertHead( const Child_:TTreeItem );
       procedure _InsertTail( const Child_:TTreeItem );
       procedure _InsertPrev( const Sibli_:TTreeItem );
       procedure _InsertNext( const Sibli_:TTreeItem );
       procedure InsertHead( const Child_:TTreeItem );
       procedure InsertTail( const Child_:TTreeItem );
       procedure InsertPrev( const Sibli_:TTreeItem );
       procedure InsertNext( const Sibli_:TTreeItem );
       class procedure Swap( const C1_,C2_:TTreeItem ); overload;
       procedure Swap( const I1_,I2_:Integer ); overload;
       procedure RunFamily( const Proc_:TNodeProc<TTreeItem> );
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeAtom

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

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

function TTreeAtom.Get_Links( const I_:Integer ) :TTreeItem;
begin
     Result := nil;
end;

procedure TTreeAtom.Set_Links( const I_:Integer; const Link_:TTreeItem );
begin

end;

function TTreeAtom.Get_LinksN :Integer;
begin
     Result := 0;
end;

procedure TTreeAtom.Set_LinksN( const LinksN_:Integer );
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

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeItem

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeItem.Get_Zero :TTreeItem;
begin
     Result := _Links[ -1 ];
end;

procedure TTreeItem.Set_Zero( const Zero_:TTreeItem );
begin
     _Links[ -1 ] := Zero_;
end;

//------------------------------------------------------------------------------

function TTreeItem.GetIsOrdered :Boolean;
begin
     Result := ( _Order <= _Parent._MaxOrder )
           and ( _Parent._Links[ _Order ] = Self );
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

     Result := _Links[ I_ ];
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
     if _ChildsN > _LinksN then _LinksN := _ChildsN;

     P := _Links[ _MaxOrder ];

     repeat
           P := P._Next;

           _MaxOrder := _MaxOrder + 1;

           _Links[ _MaxOrder ] := P;  P._Order := _MaxOrder;

     until P = Child_;
end;

procedure TTreeItem.FindTo( const Order_:Integer );
var
   P :TTreeItem;
   I :Integer;
begin
     if _ChildsN > _LinksN then _LinksN := _ChildsN;

     P := _Links[ _MaxOrder ];

     for I := _MaxOrder + 1 to Order_ do
     begin
           P := P._Next;

           _Links[ I ] := P;  P._Order := I;
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

          if _ChildsN * 2 < _LinksN then _LinksN := _ChildsN;

          OnRemoveChild( Self );
     end;

     _Parent := nil;  _Order := -1;
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

procedure TTreeItem.RemoveChild( const Child_:TTreeItem );
begin
     if Self = Child_.Parent then Child_.Remove;
end;

//------------------------------------------------------------------------------

procedure TTreeItem.DeleteChilds;
var
   N :Integer;
begin
     for N := 1 to _ChildsN do _Zero._Prev.Free;
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
          P1._Links[ I1 ] := C2_;  C2_._Order := I1;
     end;

     if B2 then
     begin
          P2._Links[ I2 ] := C1_;  C1_._Order := I2;
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

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

end. //######################################################################### ■
