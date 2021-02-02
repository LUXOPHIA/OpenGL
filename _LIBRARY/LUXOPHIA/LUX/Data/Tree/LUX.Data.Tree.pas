unit LUX.Data.Tree;

interface //#################################################################### ■

uses LUX.Data.Tree.core,
     LUX.Data.Tree.Node;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     TTreeRoot<_TChild_:class>             = class;
       TTreeNode<_TParent_,_TChild_:class> = class;
         TTreeNode<_TNode_:class>          = class;
       TTreeLeaf<_TParent_:class>          = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

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

end. //######################################################################### ■
