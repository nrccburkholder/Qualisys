//----------------------------------------------------------------------------
// SpellGbl.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: SpellGbl.pas
//----------------------------------------------------------------------------
#ifndef SpellGblHPP
#define SpellGblHPP
//----------------------------------------------------------------------------
#include <System.hpp>
namespace Spellgbl
{
//-- type declarations -------------------------------------------------------
enum TLanguages { lgEnglish };

enum TDialogTypes { dtWordPerfect, dtMSWord, dtWordPro96 };

typedef char TBigBuffer[2147483647];

typedef TBigBuffer *PBigBuffer;

//-- var, const, procedure ---------------------------------------------------
extern System::Set<char, 0, 255>  ValidChars;
extern System::Set<char, 0, 255>  NumberSet;
#define MaxBuffer (int)(2147483647)
#define AddBufferSize (Word)(4096)
extern System::SmallString<8>  Dictionaries[1];
#define Margin (Byte)(10)
extern System::SmallString<30>  SpellTitle[1];
extern System::SmallString<15>  FoundPhrase[1];
extern System::SmallString<15>  NotFoundPhrase[1];
extern System::AnsiString NoErrorsMesg[1];
extern System::AnsiString AbortedMesg[1];
extern System::AnsiString CompleteMesg[1];
extern System::SmallString<30>  AddMesg[1];
extern System::SmallString<30>  AddedMesg[1];
//-- template instantiations -------------------------------------------------
template class SmallString<15> ;
template class SmallString<30> ;
template class SmallString<8> ;
template class System::Set<char, 0, 255>  ;
template class System::Set<char, 0, 255>  ;

}	/* namespace Spellgbl */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Spellgbl;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// SpellGbl
