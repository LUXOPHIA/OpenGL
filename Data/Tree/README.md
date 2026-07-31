# LUX.Data.Tree
[English](README.md) | [日本語](ja/README.md)

A generic tree built on `LUX.Data.List`. Three node kinds — root, knot and leaf — share one base class, so a whole tree can be handled uniformly, while the generic layers type the `Parent` and `Childrs` cross-references onto the client's own classes, including self-recursive ones.

## 1. Overview

The node kinds are:

```
・TTreeRoot<TChildr_>          ･･･ cannot belong to a parent; can have children
・TTreeKnot<TParent_,TChildr_> ･･･ can belong to a parent and have children
・TTreeLeaf<TParent_>          ･･･ can belong to a parent; no child-list cost
```

All three descend from `TTreeNode` and can be handled as such — `Parent`, `Root`, `Level`, `Prev`, `Next`, `Childrs`, `for-in`, `All`. The type parameters are constrained only to `class` so that a type may name itself as its own parent or child type; the finer requirements ( the parent must descend from `TTreeStem`, the child from `TTreeNode` ) are enforced at run time with `ETreeError`.

Ownership follows the list: `Free` releases a whole subtree, `Remove` only detaches it ( the detached subtree belongs to the caller ), and assigning `Parent` transfers a node from its old parent to the tail of the new one. A child list is created lazily when the first child arrives.

## 2. Technical Background

### 2.1 Flat preorder traversal

`for N in Node.All do` walks the subtree rooted at `Node` ( including `Node` itself ) in preorder without recursion, without a stack and without heap allocation: the enumerator is a two-pointer record whose successor function descends to the first child when there is one, and otherwise climbs until a right sibling appears, stopping at the anchor:

```math
\mathrm{succ}(n) =
\begin{cases}
\mathrm{Header}(n) & \mathrm{Header}(n) \neq \mathrm{nil} \\[4pt]
\mathrm{Next}(m), \quad m = \text{nearest ancestor-or-self of } n \text{ with a right sibling} & \text{otherwise}
\end{cases} \qquad \text{(2.1)}
```

Each parent–child link is crossed at most once downward and once upward, so a full walk of a subtree of $V$ nodes costs

```math
T \le 2\,(V - 1) + V = O(V) \qquad \text{(2.2)}
```

link steps with O(1) memory. `All` does no read-ahead, so the tree's structure must not be changed during the walk; the plain child enumerator ( `for C in Node do` ) *does* read ahead, so deleting `Current` while enumerating direct children is safe.

### 2.2 Invariants, gate and notifications

Operations that would break the tree — making an ancestor ( or the node itself ) a child, attaching a `TTreeRoot` to a parent, or inserting a child the parent does not accept — raise `ETreeError`, in release builds too. Every insertion passes through the child list `TTreeChildrs`, which asks the parent `AcceptChildr` ( the typed layer's default accepts exactly `TChildr_` and its descendants ) and then notifies it via `OnInsertChildr` / `OnRemoveChildr`; all three are virtual. The low-level list operations `InsertPrev` / `InsertNext` bypass the cycle and root checks, so tree manipulation should use this unit's API — `Add`, `InsertHead`, `InsertTail`, `Parent`, `Create`.

`BeginUpdate` / `EndUpdate` batch changes on any node that can have children, at a cost of one byte per node ( nesting up to 255 deep ): derived classes test `Updating` at the entry of their notification handlers, and the outermost `EndUpdate` calls `Updated` exactly once, whether or not anything changed. Destruction is treated as an update that never ends — a node being destroyed is `Updating`, so its own notifications stay silent, while a surviving parent receives exactly one detach notification for the removed subtree.

## 3. Architecture

### 3.1 Class structure

```
・TTreeNode ( = TListChildr )                         ･･･ members listed in §1
  ┣・TTreeStem                                       ･･･ can have children
  ┃  ┗・TTreeStem<TChildr_>                         ･･･ typed children
  ┃     ┣・TTreeRoot<TChildr_>                      ･･･ refuses any parent
  ┃     ┗・TTreeKnot<TParent_,TChildr_>             ･･･ typed Parent as well
  ┗・TTreeLeaf<TParent_>                             ･･･ typed Parent

・TTreeChildrs ( = TListParent<TTreeNode,TTreeNode> ) ･･･ the insertion gate
・TTreeEnumer / TTreeEnumer<TChildr_>                 ･･･ children, read-ahead
・TTreeEnumerAll                                      ･･･ preorder subtree walk
```

`ForceChildrs` creates the child list on demand and is virtual, so a derived class can substitute its own `TTreeChildrs` descendant.

### 3.2 File layout

```
・Data/Tree/
  ┗・LUX.Data.Tree.pas ･･･ everything above, in one unit
```

The unit depends on `System.SysUtils`, `LUX.Data.List.core` and `LUX.Data.List` only.

## 4. Usage

```pascal
uses LUX.Data.Tree;

type
   TNode = class( TTreeKnot<TNode,TNode> )   // self-recursive: its own
   end;                                      // parent and child type

   TRoot = class( TTreeRoot<TNode> )
   end;

var
   R    :TRoot;
   A, B :TNode;
   N    :TTreeNode;
begin
     R := TRoot.Create;
     try
        A := TNode.Create;  R.Add( A );      // attach to the root
        B := TNode.Create( A );              // attach to A on creation

        B.Parent := nil;                     // detach — B is caller-owned
        B.Parent := A;                       // re-attach ( auto-transfer )

        for N in R do { ... };               // direct children only
        for N in R.All do { ... };           // whole subtree, preorder

        R.BeginUpdate;
        try
           // many changes; notifications stay silent
        finally
           R.EndUpdate;                      // Updated fires exactly once
        end;
     finally
        R.Free;                              // frees the whole subtree
     end;
end;
```

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
