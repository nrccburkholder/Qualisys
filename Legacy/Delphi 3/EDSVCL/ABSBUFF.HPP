//----------------------------------------------------------------------------
// AbsBuff.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: AbsBuff.pas
//----------------------------------------------------------------------------
#ifndef AbsBuffHPP
#define AbsBuffHPP
//----------------------------------------------------------------------------
#include <Words.hpp>
#include <SpellGbl.hpp>
#include <MemoUtil.hpp>
#include <LexDCT32.hpp>
#include <Windows.hpp>
#include <StdCtrls.hpp>
#include <Dialogs.hpp>
#include <Forms.hpp>
#include <SysUtils.hpp>
#include <Graphics.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <System.hpp>
namespace Absbuff
{
//-- type declarations -------------------------------------------------------
class __declspec(delphiclass) TAbsBuffer;
class __declspec(pascalimplementation) TAbsBuffer : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	long FSize;
	char *FCurPosPtr;
	long FBeginPos;
	long FEndPos;
	Controls::TControl* FParent;
	bool FAllNums;
	bool FSupportHTML;
	
public:
	Spellgbl::TBigBuffer *Buffer;
	int BufferSize;
	long CurPos;
	__fastcall virtual TAbsBuffer(Controls::TControl* AParent);
	__fastcall virtual ~TAbsBuffer(void);
	void __fastcall InitParms(void);
	virtual bool __fastcall IsModified(void) = 0;
	virtual void __fastcall SetModified(bool NowModified) = 0;
	virtual int __fastcall GetYPos(void);
	virtual int __fastcall GetTextBufferSize(void);
	virtual System::AnsiString __fastcall GetNextWord(void) = 0;
	virtual void __fastcall MoveBackOneWord(void) = 0;
	virtual void __fastcall UpdateBuffer(void) = 0;
	virtual void __fastcall SetSelectedText(void);
	virtual void __fastcall ReplaceWord( System::AnsiString WithWord) = 0;
	virtual void __fastcall WordCount(long &NumWords, long &UniqueWords);
	__property long BufSize = {read=FSize, write=FSize, nodefault};
	__property char * PCurPos = {read=FCurPosPtr, write=FCurPosPtr, nodefault};
	__property long BeginPos = {read=FBeginPos, write=FBeginPos, nodefault};
	__property long EndPos = {read=FEndPos, write=FEndPos, nodefault};
	__property Controls::TControl* Parent = {read=FParent, write=FParent, nodefault};
	__property bool Modified = {read=IsModified, write=SetModified, nodefault};
	__property int YPos = {read=GetYPos, nodefault};
	__property bool AllNumbers = {read=FAllNums, write=FAllNums, nodefault};
	__property bool SupportHTML = {read=FSupportHTML, write=FSupportHTML, nodefault};
};

class __declspec(delphiclass) TPCharBuffer;
class __declspec(pascalimplementation) TPCharBuffer : public TAbsBuffer
{
	typedef TAbsBuffer inherited;
	
private:
	bool FModified;
	char *FPChar;
	
public:
	__fastcall virtual TPCharBuffer(Controls::TControl* AParent);
	__fastcall virtual TPCharBuffer(char * ParentBuffer);
	virtual bool __fastcall IsModified(void);
	virtual void __fastcall SetModified(bool NowModified);
	virtual System::AnsiString __fastcall GetNextWord(void);
	virtual void __fastcall MoveBackOneWord(void);
	virtual void __fastcall UpdateBuffer(void);
	virtual void __fastcall ReplaceWord( System::AnsiString WithWord);
public:
	/* TAbsBuffer.Destroy */ __fastcall virtual ~TPCharBuffer(void) { }
	
};

typedef System::AnsiString *PString;

class __declspec(delphiclass) TStringBuffer;
class __declspec(pascalimplementation) TStringBuffer : public TAbsBuffer
{
	typedef TAbsBuffer inherited;
	
private:
	bool FModified;
	System::AnsiString *FString;
	
public:
	__fastcall TStringBuffer(PString CheckString);
	virtual void __fastcall UpdateBuffer(void);
	virtual void __fastcall ReplaceWord( System::AnsiString WithWord);
public:
	/* TAbsBuffer.Destroy */ __fastcall virtual ~TStringBuffer(void) { }
	
};

class __declspec(delphiclass) TCEBuffer;
class __declspec(pascalimplementation) TCEBuffer : public TPCharBuffer
{
	typedef TPCharBuffer inherited;
	
public:
	__fastcall TCEBuffer(Controls::TControl* AParent);
	virtual bool __fastcall IsModified(void);
	virtual void __fastcall SetModified(bool NowModified);
	virtual int __fastcall GetYPos(void);
	virtual int __fastcall GetTextBufferSize(void);
	virtual void __fastcall SetSelectedText(void);
	virtual void __fastcall UpdateBuffer(void);
	virtual void __fastcall ReplaceWord( System::AnsiString WithWord);
public:
	/* TPCharBuffer.CreateSpecial */ __fastcall virtual TCEBuffer(char * ParentBuffer) : Absbuff::TPCharBuffer(
		ParentBuffer) { }
	
public:
	/* TAbsBuffer.Destroy */ __fastcall virtual ~TCEBuffer(void) { }
	
};

//-- var, const, procedure ---------------------------------------------------

}	/* namespace Absbuff */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Absbuff;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// AbsBuff
