//----------------------------------------------------------------------------
// CList32.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: CList32.pas
//----------------------------------------------------------------------------
#ifndef CList32HPP
#define CList32HPP
//----------------------------------------------------------------------------
#include <System.hpp>
namespace Clist32
{
//-- type declarations -------------------------------------------------------
class __declspec(delphiclass) TLinkedListNode;
class __declspec(pascalimplementation) TLinkedListNode : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TLinkedListNode* FNext;
	
public:
	__fastcall TLinkedListNode(void);
	__fastcall virtual ~TLinkedListNode(void);
	__property TLinkedListNode* NextNode = {read=FNext, write=FNext, nodefault};
};

class __declspec(delphiclass) TDblLinkedListNode;
class __declspec(pascalimplementation) TDblLinkedListNode : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TDblLinkedListNode* FPrev;
	TDblLinkedListNode* FNext;
	
public:
	__fastcall TDblLinkedListNode(void);
	__fastcall virtual ~TDblLinkedListNode(void);
	__property TDblLinkedListNode* PrevNOde = {read=FPrev, write=FPrev, nodefault};
	__property TDblLinkedListNode* NextNode = {read=FNext, write=FNext, nodefault};
};

typedef void __fastcall (*ForEachProc)(TLinkedListNode* ANode, void *Rec);

typedef void __fastcall (*ForEachDblProc)(TDblLinkedListNode* ANode, void *Rec);

class __declspec(delphiclass) TLinkedList;
class __declspec(pascalimplementation) TLinkedList : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TLinkedListNode* FHead;
	TLinkedListNode* FTail;
	long FSize;
	TLinkedListNode* __fastcall PreviousNode(TLinkedListNode* ANode);
	
public:
	__fastcall TLinkedList(void);
	__fastcall virtual ~TLinkedList(void);
	void __fastcall Append(TLinkedListNode* NewNode);
	void __fastcall Insert(TLinkedListNode* NewNode);
	void __fastcall InsertAfter(TLinkedListNode* ANode, TLinkedListNode* NewNode);
	void __fastcall InsertBefore(TLinkedListNode* ANode, TLinkedListNode* NewNode);
	void __fastcall Remove(TLinkedListNode* ANode);
	void __fastcall Delete(TLinkedListNode* ANode);
	long __fastcall IndexOf(TLinkedListNode* ANode);
	TLinkedListNode* __fastcall GotoNode(long Index);
	void __fastcall Link(TLinkedListNode* NewNode);
	void __fastcall Clear(void);
	virtual TLinkedListNode* __fastcall Next(TLinkedListNode* ANode);
	void __fastcall ForEach(ForEachProc AProc, void *Rec);
	__property TLinkedListNode* Head = {read=FHead, write=FHead, nodefault};
	__property TLinkedListNode* Tail = {read=FTail, write=FTail, nodefault};
	__property long Size = {read=FSize, write=FSize, nodefault};
};

class __declspec(delphiclass) TDblLinkedList;
class __declspec(pascalimplementation) TDblLinkedList : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TDblLinkedListNode* FHead;
	TDblLinkedListNode* FTail;
	long FSize;
	
public:
	__fastcall TDblLinkedList(void);
	__fastcall virtual ~TDblLinkedList(void);
	void __fastcall Append(TDblLinkedListNode* NewNode);
	void __fastcall Insert(TDblLinkedListNode* NewNode);
	void __fastcall InsertAfter(TDblLinkedListNode* ANode, TDblLinkedListNode* NewNode);
	void __fastcall InsertBefore(TDblLinkedListNode* ANode, TDblLinkedListNode* NewNode);
	void __fastcall Remove(TDblLinkedListNode* ANode);
	void __fastcall Delete(TDblLinkedListNode* ANode);
	long __fastcall IndexOf(TDblLinkedListNode* ANode);
	TDblLinkedListNode* __fastcall GotoNode(long Index);
	void __fastcall Link(TDblLinkedListNode* NewNode);
	void __fastcall Clear(void);
	virtual TDblLinkedListNode* __fastcall Prev(TDblLinkedListNode* ANode);
	virtual TDblLinkedListNode* __fastcall Next(TDblLinkedListNode* ANode);
	void __fastcall ForEach(ForEachDblProc AProc, void *Rec);
	__property TDblLinkedListNode* Head = {read=FHead, write=FHead, nodefault};
	__property TDblLinkedListNode* Tail = {read=FTail, write=FTail, nodefault};
	__property long Size = {read=FSize, write=FSize, nodefault};
};

//-- var, const, procedure ---------------------------------------------------
extern void *NilVar;

}	/* namespace Clist32 */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Clist32;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// CList32
