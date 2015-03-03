//----------------------------------------------------------------------------
// Spell32.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: Spell32.pas
//----------------------------------------------------------------------------
#ifndef Spell32HPP
#define Spell32HPP
//----------------------------------------------------------------------------
#include <SpellGbl.hpp>
#include <W96Spell.hpp>
#include <MSSpell.hpp>
#include <ComCtrls.hpp>
#include <LexLst32.hpp>
#include <LexDCT32.hpp>
#include <Tabnotbk.hpp>
#include <WPSpell.hpp>
#include <AbsSpell.hpp>
#include <AbsBuff.hpp>
#include <ExtCtrls.hpp>
#include <Menus.hpp>
#include <Buttons.hpp>
#include <StdCtrls.hpp>
#include <Dialogs.hpp>
#include <Forms.hpp>
#include <Controls.hpp>
#include <Graphics.hpp>
#include <Classes.hpp>
#include <Messages.hpp>
#include <Windows.hpp>
#include <SysUtils.hpp>
#include <System.hpp>
namespace Spell32
{
//-- type declarations -------------------------------------------------------
class __declspec(delphiclass) TSpellDlg;
class __declspec(pascalimplementation) TSpellDlg : public Classes::TComponent
{
	typedef Classes::TComponent inherited;
	
private:
	System::AnsiString FPath;
	System::AnsiString FDictionary;
	System::AnsiString FExclude;
	System::AnsiString FAutoCorrect;
	TLanguages FDicType;
	TLanguages FLanguage;
	TDialogTypes FDialogType;
	Absspell::TAbsSpellDialog* FSpellWin;
	Byte FSuggestions;
	Absspell::TAccentSet FIcons;
	bool FAutoSuggest;
	bool FAutoShift;
	Classes::THelpContext FHelpContext;
	bool FConfirmAdd;
	System::AnsiString FUserDCT;
	bool FCompletedMesg;
	bool FShowGlyphs;
	Graphics::TFont* FFont;
	bool FSupportHTML;
	bool FModal;
	Classes::TStringList* FSkipList;
	Classes::TStringList* FReplaceList;
	Classes::TStringList* FReplacer;
	void __fastcall AddAutoCorrectList(void);
	void __fastcall SetDicType(Spellgbl::TLanguages NewType);
	void __fastcall SetExclusionList( System::AnsiString TheList);
	void __fastcall SetLanguage(Spellgbl::TLanguages NewLanguage);
	void __fastcall SetSuggestions(Byte Num);
	void __fastcall SetIconSet(Absspell::TAccentSet IconSet);
	void __fastcall SetFont(Graphics::TFont* Value);
	void __fastcall SetHelpContext(Classes::THelpContext HelpID);
	void __fastcall SetSupportHTML(bool Value);
	
public:
	bool CloseWin;
	void *ModalPtr;
	__fastcall virtual TSpellDlg(Classes::TComponent* AOwner);
	__fastcall virtual ~TSpellDlg(void);
	bool __fastcall Open(void);
	void __fastcall Close(void);
	void __fastcall ClearLists(void);
	void __fastcall MoveDialog(int YPos);
	void __fastcall EnableSkipButtons(void);
	void __fastcall DisableSkipButtons(void);
	virtual void __fastcall BringControlToFront(Controls::TWinControl* AControl);
	void __fastcall Show(void);
	void __fastcall CloseSpellWin(void);
	void __fastcall ForceDialogTitle( System::AnsiString ATitle);
	void __fastcall UseScanTable(int TableSize, void * TablePtr);
	int __fastcall CheckBuffer(Absbuff::TAbsBuffer* ABuffer);
	int __fastcall CheckWord( System::AnsiString &AWord);
	virtual int __fastcall SpellCheck(Controls::TControl* AControl);
	virtual int __fastcall CheckAllFields(Forms::TForm* AForm, bool DisplayMsg);
	virtual void __fastcall WordCount(Controls::TControl* AControl, long &NumWords, long &UniqueWords);
		
	virtual void __fastcall ShowBadword(Controls::TControl* AControl,  System::AnsiString TheWord, int 
		Pos);
	virtual System::AnsiString __fastcall GetLastWordTyped(Controls::TControl* AControl, int &Pos);
	virtual void __fastcall AutoCheck(Controls::TControl* AControl, bool AutoCorrect, Word Key, Classes::TShiftState 
		Shift);
	virtual void __fastcall SetDialogType(Spellgbl::TDialogTypes NewType);
	bool __fastcall OpenDictionary(void);
	void __fastcall AddDictionary( System::AnsiString DCTFileName);
	void __fastcall CloseDictionary(void);
	bool __fastcall AddWord( System::AnsiString AWord);
	bool __fastcall InDictionary( System::AnsiString AWord);
	Classes::TStringList* __fastcall SuggestWords( System::AnsiString AWord, Byte NumToList);
	__property Classes::TStringList* SkipList = {read=FSkipList, write=FSkipList, nodefault};
	__property Classes::TStringList* ReplaceList = {read=FReplaceList, write=FReplaceList, nodefault};
	__property Classes::TStringList* Replacer = {read=FReplacer, write=FReplacer, nodefault};
	__property Absspell::TAbsSpellDialog* SpellWin = {read=FSpellWin, write=FSpellWin, nodefault};
	
__published:
	__property Absspell::TAccentSet AccentIcons = {read=FIcons, write=SetIconSet, nodefault};
	__property System::AnsiString AutoCorrectList = {read=FAutoCorrect, write=FAutoCorrect, nodefault};
		
	__property bool AutoShift = {read=FAutoShift, write=FAutoShift, nodefault};
	__property bool AutoSuggest = {read=FAutoSuggest, write=FAutoSuggest, nodefault};
	__property bool ConfirmAdd = {read=FConfirmAdd, write=FConfirmAdd, nodefault};
	__property Spellgbl::TDialogTypes DialogStyle = {read=FDialogType, write=SetDialogType, nodefault};
		
	__property System::AnsiString DictionaryName = {read=FDictionary, write=FDictionary, nodefault};
	__property System::AnsiString DictionaryPath = {read=FPath, write=FPath, nodefault};
	__property Spellgbl::TLanguages DictionaryType = {read=FDicType, write=SetDicType, nodefault};
	__property System::AnsiString ExclusionList = {read=FExclude, write=SetExclusionList, nodefault};
	__property Graphics::TFont* Font = {read=FFont, write=SetFont, nodefault};
	__property bool ForceModal = {read=FModal, write=FModal, nodefault};
	__property Classes::THelpContext HelpContext = {read=FHelpContext, write=SetHelpContext, nodefault}
		;
	__property Spellgbl::TLanguages LabelLanguage = {read=FLanguage, write=SetLanguage, nodefault};
	__property Byte Suggestions = {read=FSuggestions, write=SetSuggestions, nodefault};
	__property bool ShowCompletedDialog = {read=FCompletedMesg, write=FCompletedMesg, nodefault};
	__property bool ShowGlyphs = {read=FShowGlyphs, write=FShowGlyphs, nodefault};
	__property bool SupportHTML = {read=FSupportHTML, write=SetSupportHTML, nodefault};
	__property System::AnsiString UserDictionary = {read=FUserDCT, write=FUserDCT, nodefault};
};

//-- var, const, procedure ---------------------------------------------------
extern void __fastcall Register(void);
//-- template instantiations -------------------------------------------------
template class Absspell::TAccentSet ;

}	/* namespace Spell32 */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Spell32;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// Spell32
