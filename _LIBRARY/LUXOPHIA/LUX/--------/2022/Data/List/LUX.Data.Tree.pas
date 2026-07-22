unit LUX.Data.Tree;

interface //#################################################################### ■

uses LUX.Data.List.core;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     TTreeNode<TRoot_,TNode_:class> = class;
     TTreeRoot<TRoot_,TNode_:class> = class;
     TTreeKnot<TRoot_,TNode_:class> = class;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeChildr<TRoot_,TNode_>

     TTreeChildr<TRoot_,TNode_:class> = class( TListChildr )
     private
       type TTreeNode_ = TTreeNode<TRoot_,TNode_>;
     protected
       _Ownere :TTreeNode_;
       ///// アクセス
       function GetOwnere :TNode_;
     public
       constructor Create( const Ownere_:TTreeNode_ );
       ///// プロパティ
       property Ownere :TNode_ read GetOwnere;
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeNode<TRoot_,TNode_>

     TTreeNode<TRoot_,TNode_:class> = class( TListParent )
     private
       type TTreeChildr_ = TTreeChildr<TRoot_,TNode_>;
            TTreeNode_   = TTreeNode  <TRoot_,TNode_>;
       ///// アクセス
       function Get_Childr :TTreeChildr_; virtual; abstract;
     protected
       ///// アクセス
       function GetRoot :TRoot_; virtual; abstract;
       function GetParent :TNode_; virtual;
       procedure SetParent( const Parent_:TNode_ ); virtual;
       function GetHeader :TNode_; reintroduce; virtual;
       function GetTailer :TNode_; reintroduce; virtual;
       function GetChildrs( const I_:Integer ) :TNode_; reintroduce; overload; virtual;
       procedure SetChildrs( const I_:Integer; const Childr_:TNode_ ); reintroduce; overload; virtual;
       ///// プロパティ
       property _Childr :TTreeChildr_ read Get_Childr;
     public
       constructor Create( const Parent_:TRoot_ ); overload; virtual;
       constructor Create( const Parent_:TNode_ ); overload; virtual;
       ///// プロパティ
       property Root                        :TRoot_ read GetRoot                    ;
       property Parent                      :TNode_ read GetParent  write SetParent ;
       property Header                      :TNode_ read GetHeader                  ;
       property Tailer                      :TNode_ read GetTailer                  ;
       property Childrs[ const I_:Integer ] :TNode_ read GetChildrs write SetChildrs; default;
       property Items[ const I_:Integer ]   :TNode_ read GetChildrs write SetChildrs;
       ///// メソッド
       procedure InsertPrev( const Siblin_:TNode_ );
       procedure InsertNext( const Siblin_:TNode_ );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeRoot<TRoot_,TNode_>

     TTreeRoot<TRoot_,TNode_:class> = class( TTreeNode<TRoot_,TNode_> )
       type TTreeChildr_ = TTreeChildr<TRoot_,TNode_>;
     private
       ///// アクセス
       function Get_Childr :TTreeChildr_; override;
     protected
       ///// アクセス
       function GetRoot :TRoot_; override;
     public
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeKnot<TRoot_,TNode_>

     TTreeKnot<TRoot_,TNode_:class> = class( TTreeNode<TRoot_,TNode_> )
       type TTreeChildr_ = TTreeChildr<TRoot_,TNode_>;
     private
       __Childr :TTreeChildr_;
       ///// アクセス
       function Get_Childr :TTreeChildr_; override;
     protected
       ///// アクセス
       function GetRoot :TRoot_; override;
     public
       constructor Create; override;
       destructor Destroy; override;
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeChildr<TRoot_,TNode_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeChildr<TRoot_,TNode_>.GetOwnere :TNode_;
begin
     Result := TNode_( _Ownere );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTreeChildr<TRoot_,TNode_>.Create( const Ownere_:TTreeNode_ );
begin
     inherited Create;

     _Ownere := Ownere_;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeNode<TRoot_,TNode_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeNode<TRoot_,TNode_>.GetParent :TNode_;
begin
     Result := TNode_( _Childr.Parent );
end;

procedure TTreeNode<TRoot_,TNode_>.SetParent( const Parent_:TNode_ );
begin
     _Childr.Parent := TListParent( Parent_ );
end;

//------------------------------------------------------------------------------

function TTreeNode<TRoot_,TNode_>.GetHeader :TNode_;
begin
     Result := TTreeChildr_( inherited Header ).Ownere;
end;

function TTreeNode<TRoot_,TNode_>.GetTailer :TNode_;
begin
     Result := TTreeChildr_( inherited Tailer ).Ownere;
end;

function TTreeNode<TRoot_,TNode_>.GetChildrs( const I_:Integer ) :TNode_;
begin
     Result := TTreeChildr_( inherited Childrs[ I_ ] ).Ownere;
end;

procedure TTreeNode<TRoot_,TNode_>.SetChildrs( const I_:Integer; const Childr_:TNode_ );
begin
     inherited Childrs[ I_ ] := TTreeNode_( Childr_ )._Childr;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTreeNode<TRoot_,TNode_>.Create( const Parent_:TRoot_ );
begin
     Create( TNode_( TTreeNode_( Parent_ ) ) );
end;

constructor TTreeNode<TRoot_,TNode_>.Create( const Parent_:TNode_ );
begin
     Create;

     Parent := Parent_;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TTreeNode<TRoot_,TNode_>.InsertPrev( const Siblin_:TNode_ );
begin
     _Childr.InsertPrev( TTreeNode_( Siblin_ )._Childr );
end;

procedure TTreeNode<TRoot_,TNode_>.InsertNext( const Siblin_:TNode_ );
begin
     _Childr.InsertNext( TTreeNode_( Siblin_ )._Childr );
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeRoot<TRoot_,TNode_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeRoot<TRoot_,TNode_>.Get_Childr :TTreeChildr_;
begin
     Result := nil;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeRoot<TRoot_,TNode_>.GetRoot :TRoot_;
begin
     Result := TRoot_( Self );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TTreeKnot<TRoot_,TNode_>

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeKnot<TRoot_,TNode_>.Get_Childr :TTreeChildr_;
begin
     Result := __Childr;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

/////////////////////////////////////////////////////////////////////// アクセス

function TTreeKnot<TRoot_,TNode_>.GetRoot :TRoot_;
begin
     Result := TTreeNode_( Parent ).Root;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TTreeKnot<TRoot_,TNode_>.Create;
begin
     inherited;

     __Childr := TTreeChildr_.Create( Self );
end;

destructor TTreeKnot<TRoot_,TNode_>.Destroy;
begin
     __Childr.Free;

     inherited;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

end. //######################################################################### ■
