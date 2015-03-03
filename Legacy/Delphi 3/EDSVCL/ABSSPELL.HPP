//----------------------------------------------------------------------------
// AbsSpell.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: AbsSpell.pas
//----------------------------------------------------------------------------
#ifndef AbsSpellHPP
#define AbsSpellHPP
//----------------------------------------------------------------------------
#include <SpellGbl.hpp>
#include <EDSUtil.hpp>
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
namespace Absspell
{
//-- type declarations -------------------------------------------------------
enum TAccents { acSpanish };

typedef Set<TAccents, acSpanish, acSpanish>  TAccentSet;

class __declspec(delphiclass) TAbsSpellDialog;
class __declspec(pascalimplementation) TAbsSpellDialog : public Forms::TForm
{
	typedef Forms::TForm inherited;
	
private:
	Byte FSuggestions;
	TAccentSet FAccents;
	TLanguages FLanguage;
	virtual void __fastcall CreateParams(Controls::TCreateParams &Params);
	void __fastcall SetLanguage(Spellgbl::TLanguages ToLanguage);
	
public:
	int SpellDlgResult;
	__fastcall virtual TAbsSpellDialog(Classes::TComponent* AOwner);
	__fastcall virtual ~TAbsSpellDialog(void);
	virtual void __fastcall SetNotFoundPrompt( System::AnsiString ToString) = 0;
	virtual void __fastcall SetNotFoundCaption( System::AnsiString ToString) = 0;
	virtual void __fastcall SetEditWord( System::AnsiString ToWord) = 0;
	virtual System::AnsiString __fastcall GetEditWord(void) = 0;
	virtual void __fastcall SetEditAsActive(void) = 0;
	virtual void __fastcall SetLabelLanguage(void);
	virtual void __fastcall RemoveGlyphs(void);
	virtual void __fastcall EnableSkipButtons(void) = 0;
	virtual void __fastcall DisableSkipButtons(void) = 0;
	virtual void __fastcall SetAccentSet(TAccentSet Accents) = 0;
	virtual void __fastcall ClearSuggestList(void) = 0;
	virtual void __fastcall MakeSuggestions(void) = 0;
	__property Byte Suggestions = {read=FSuggestions, write=FSuggestions, nodefault};
	__property Spellgbl::TLanguages Language = {read=FLanguage, write=SetLanguage, nodefault};
public:
	/* TForm.CreateNew */ __fastcall TAbsSpellDialog(Classes::TComponent* AOwner, int Dummy) : Forms::TForm(
		AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ __fastcall TAbsSpellDialog(HWND ParentWindow) : Forms::TForm(ParentWindow
		) { }
	
};

//-- var, const, procedure ---------------------------------------------------
#define mrReplace (Byte)(20)
#define mrAdd (Byte)(21)
#define mrSkipOnce (Byte)(22)
#define mrSkipAll (Byte)(23)
#define mrReplaceAll (Byte)(24)
#define mrSuggest (Byte)(25)
//-- template instantiations -------------------------------------------------
template class TAccentSet ;

}	/* namespace Absspell */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Absspell;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// AbsSpell
