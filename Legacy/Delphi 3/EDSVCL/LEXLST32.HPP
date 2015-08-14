//----------------------------------------------------------------------------
// LexLst32.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: LexLst32.pas
//----------------------------------------------------------------------------
#ifndef LexLst32HPP
#define LexLst32HPP
//----------------------------------------------------------------------------
#include <LexEdg32.hpp>
#include <LexDCT32.hpp>
#include <CList32.hpp>
#include <Dialogs.hpp>
#include <Windows.hpp>
#include <SysUtils.hpp>
#include <System.hpp>
namespace Lexlst32
{
//-- type declarations -------------------------------------------------------
typedef short Int16;

typedef SmallString<6>  ScanStr;

typedef SmallString<4>  TSndXStr;

typedef ScanStr TScanTable[50];

class __declspec(delphiclass) TSuggestion;
class __declspec(pascalimplementation) TSuggestion : public Clist32::TLinkedListNode
{
	typedef Clist32::TLinkedListNode inherited;
	
private:
	Lexdct32::TDCTStr FString;
	short FMatch;
	
public:
	__fastcall TSuggestion( Lexdct32::TDCTStr &AStr, short AMatch);
	__fastcall virtual ~TSuggestion(void);
	__property Lexdct32::TDCTStr WordSt = {read=FString, write=FString};
	__property short Match = {read=FMatch, write=FMatch, nodefault};
};

class __declspec(delphiclass) TSuggestList;
class __declspec(pascalimplementation) TSuggestList : public Clist32::TLinkedList
{
	typedef Clist32::TLinkedList inherited;
	
private:
	Byte FMax;
	Lexdct32::TDCTFile* FDCT;
	TSndXStr FSndX;
	short MaxHitLen;
	short MinHitLen;
	short __fastcall SimIndex( Lexdct32::TDCTStr &ChkWord,  Lexdct32::TDCTStr &WithWord);
	bool __fastcall WordExists( Lexdct32::TDCTStr &AWord);
	System::AnsiString __fastcall CreateScanTable( Lexdct32::TDCTStr &ForWord);
	TSndXStr __fastcall SoundEx( Lexdct32::TDCTStr &AWord, bool Pad);
	long __fastcall FirstChildID(char ForLetter);
	
public:
	__fastcall TSuggestList(void);
	__fastcall virtual ~TSuggestList(void);
	bool __fastcall MatchSoundex( Lexdct32::TDCTStr &WithWord);
	void __fastcall AddMatch( Lexdct32::TDCTStr &ForWord,  Lexdct32::TDCTStr &MatchStr);
	void __fastcall CreateList(Lexdct32::TDCTFile* DCT, Byte Max,  Lexdct32::TDCTStr &FromWord);
	__property Byte Max = {read=FMax, nodefault};
};

//-- var, const, procedure ---------------------------------------------------
#define MaxSoundex (Byte)(4)
#define MaxScanStr (Byte)(6)
#define MaxScans (Byte)(50)
extern Lexdct32::TDCTStr __fastcall Internationalize( Lexdct32::TDCTStr &AWord);
extern Lexdct32::TDCTStr __fastcall UnInternationalize( Lexdct32::TDCTStr &AWord);
//-- template instantiations -------------------------------------------------
template class SmallString<4> ;
template class SmallString<6> ;

}	/* namespace Lexlst32 */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Lexlst32;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// LexLst32
