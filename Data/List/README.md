# LUX.Data.List
[English](README.md) | [日本語](ja/README.md)

An intrusive doubly linked list in two layers: an untyped core ( `LUX.Data.List.core` ) that does the work, and a generic typed layer ( `LUX.Data.List` ) that re-types the cross-reference properties — `Parent`, `Childrs`, the enumerator — onto the client's own classes, so client code never needs a downcast.

## 1. Overview

The list is intrusive: a node **is** a `TListChildr`, a list **is** a `TListParent`, and both derive from `TListObject`, which carries the `_Prev` / `_Next` links. There is no separate wrapper object per element, so membership costs two pointers and insertion or removal is a pure link rebinding.

Ownership is explicit. A parent owns its children: `Clear` and the destructor free them. `Remove` merely detaches — the removed node becomes the caller's property — while `Free` of a node detaches it and destroys it. Assigning `Parent` moves a node from its old list to the tail of the new one.

On top of the linked structure the parent maintains an incremental index, so `Childrs[ I_ ]` ( also reachable as `Items` / `Count` aliases ) is amortised O(1) for forward sweeps rather than O(n) per access. `for-in` enumerates with one-element read-ahead, so deleting the current element during enumeration is safe.

## 2. Technical Background

### 2.1 The sentinel ring

Parent and children form one circular ring in which the parent itself is the sentinel ( `Origin` ). An empty list is a ring of one: the parent's links point at itself. Because the sentinel is always present, `InsertHead`, `InsertTail`, `InsertPrev`, `InsertNext` and `Remove` are branch-free link rebindings, all O(1), performed by the `Bind` helpers.

### 2.2 The incremental index

The parent caches the first $M+1$ nodes of the ring in an array ( `_Indexes` ), where $M$ = `_MaxOrder` is the highest position indexed so far. Reading `Childrs[ i ]` walks the ring only for the unindexed tail,

```math
C(i) = \max( 0, \; i - M ) \qquad \text{(2.1)}
```

links, and records every node it passes, so a forward sweep over a list of $N$ nodes costs at most

```math
\sum_{i=0}^{N-1} C(i) \le N \qquad \text{(2.2)}
```

link steps in total — amortised O(1) per access. Mutations invalidate only the tail of the index: inserting at the head resets $M$ to $-1$, removing an indexed node truncates $M$ to its position minus one, and the index array shrinks once the population falls below half its capacity.

`Order` reads a node's position through the same index. Assigning `Order` is defined as an **exchange** with the node currently at that position — the nodes between them do not shift — implemented by `Swap`, which also repairs the index entries of both nodes.

## 3. Architecture

### 3.1 Class structure

```
・TListObject                               ･･･ _Prev / _Next links of the ring
  ┣・TListChildr                           ･･･ Parent, Order, Insert*, Remove
  ┃  ┗・TListChildr<TParent_>             ･･･ typed Parent
  ┃     ┗・TListChildr<TOwnere_,TParent_> ･･･ adds Ownere
  ┗・TListParent                           ･･･ sentinel Origin, index, Clear
     ┗・TListParent<TChildr_>              ･･･ Childrs, insert / remove events
        ┗・TListParent<TOwnere_,TChildr_>  ･･･ adds Ownere

・TListEnumer                               ･･･ read-ahead; safe Current delete
・TListEnumer<TChildr_>                     ･･･ wrapper forwarding to the core
```

The parent raises `OnInsertChildr` / `OnRemoveChildr` around every insertion and removal, and `OnInit` on first access to an empty list; all are virtual hooks for derived lists. The `Ownere` layer lets a node reach the object that owns its list ( `OwnereObject` is virtual, so it works across generic instantiations ) — this is what `LUX.Data.Tree` builds on.

A naming note baked into the core: the untyped accessors are called `GetParent0` / `SetParent0` so that the typed layer can declare same-named typed accessors plainly — reintroducing them under the same name makes dcc64 lose the property read in mutually recursive generic instantiations ( E2130 ).

### 3.2 File layout

```
・Data/List/
  ┣・LUX.Data.List.core.pas ･･･ the untyped core and TListEnumer
  ┗・LUX.Data.List.pas      ･･･ the typed layers over the core
```

The core depends only on `System.SysUtils`; the typed layer only on the core.

## 4. Usage

`TChildr_` must be a **true descendant** of `TListChildr` — not the base class itself — or the typed `overload`s collide with the untyped ones.

```pascal
uses LUX.Data.List.core, LUX.Data.List;

type
   TItem = class;

   TItems = class( TListParent<TItem> )
   end;

   TItem = class( TListChildr<TItems> )
   end;

var
   Items :TItems;
   I     :TItem;
begin
     Items := TItems.Create;
     try
        TItem.Create( Items );       // Create( Parent ) joins the tail
        TItem.Create( Items );
        TItem.Create( Items );

        for I in Items do { ... };   // read-ahead: freeing I here is safe

        Items[ 0 ].Order := 2;       // exchange with the node at order 2

        I := Items.Header;
        I.Remove;                    // detach only — I is now caller-owned
        I.Free;                      // a node's Free also detaches it first
     finally
        Items.Free;                  // frees all remaining children
     end;
end;
```

## 💖 [Embarcadero](https://www.embarcadero.com/) [**Delphi**](https://www.embarcadero.com/products/delphi)
Integrated Development Environment (IDE) for Creating Native Cross-Platform Apps.
### Free Download: [**Delphi** Community Edition](https://www.embarcadero.com/products/delphi/starter)
