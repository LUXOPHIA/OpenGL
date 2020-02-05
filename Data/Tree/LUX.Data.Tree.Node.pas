unit LUX.Data.Tree.Node;

interface //#################################################################### ■

uses LUX.Data.Tree.core;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ＴＹＰＥ】

     TTreeRoot   = class;
     TTreeZero   = class;
       TTreeNode = class;
       TTreeLeaf = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ＲＥＣＯＲＤ】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ＣＬＡＳＳ】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeRoot

     TTreeRoot = class( TTreeItem )
     private
       FChilds   :TChildTable;
       FChildsN  :Integer;
       FMaxOrder :Integer;
     protected
       ///// ACCESS
       function Get_Childs :TChildTable; override;
       procedure Set_Childs( const Childs_:TChildTable ); override;
       function Get_ChildsN :Integer; override;
       procedure Set_ChildsN( const ChildsN_:Integer ); override;
       function Get_MaxOrder :Integer; override;
       procedure Set_MaxOrder( const MaxOrder_:Integer ); override;
     public
       constructor Create; overload; virtual;
       procedure BeforeDestruction; override;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeZero

     TTreeZero = class( TTreeItem )
     private
       FPrev :TTreeItem;
       FNext :TTreeItem;
     protected
       ///// ACCESS
       function Get_Prev :TTreeItem; override;
       procedure Set_Prev( const Prev_:TTreeItem ); override;
       function Get_Next :TTreeItem; override;
       procedure Set_Next( const Next_:TTreeItem ); override;
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
     protected
       ///// ACCESS
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
     public
       constructor Create; overload; override;
       constructor Create( const Parent_:TTreeItem ); overload; virtual;
       procedure BeforeDestruction; override;
       destructor Destroy; override;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeLeaf

     TTreeLeaf = class( TTreeZero )
     private
       FParent :TTreeItem;
       FOrder  :Integer;
     protected
       ///// ACCESS
       function Get_Parent :TTreeItem; override;
       procedure Set_Parent( const Parent_:TTreeItem ); override;
       function Get_Order :Integer; override;
       procedure Set_Order( const Order_:Integer ); override;
     public
       constructor Create; overload; override;
       constructor Create( const Parent_:TTreeItem ); overload; virtual;
       procedure BeforeDestruction; override;
       destructor Destroy; override;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ＣＯＮＳＴＡＮＴ】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ＶＡＲＩＡＢＬＥ】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ＲＯＵＴＩＮＥ】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ＲＥＣＯＲＤ】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ＣＬＡＳＳ】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeRoot

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

///////////////////////////////////////////////////////////////////////// ACCESS

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

     inherited;
end;

destructor TTreeRoot.Destroy;
begin
     _Zero  .Free;

     _Childs.Free;

     inherited;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeZero

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

///////////////////////////////////////////////////////////////////////// ACCESS

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

///////////////////////////////////////////////////////////////////////// ACCESS

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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeLeaf

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

///////////////////////////////////////////////////////////////////////// ACCESS

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

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ＲＯＵＴＩＮＥ】

end. //######################################################################### ■
