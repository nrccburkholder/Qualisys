//----------------------------------------------------------------------------
// WPSpell.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: WPSpell.pas
//----------------------------------------------------------------------------
#ifndef WPSpellHPP
#define WPSpellHPP
//----------------------------------------------------------------------------
#include <SpellGbl.hpp>
#include <AbsSpell.hpp>
#include <EDSUtil.hpp>
#include <ExtCtrls.hpp>
#include <LexDCT32.hpp>
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
namespace Wpspell
{
//-- type declarations -------------------------------------------------------
enum TWPLabels { tlblFound, tlblNotFound, tlblReplace, tlblSuggestions, tbtnReplace, tbtnAdd, tbtnSkip, 
	tbtnSkipAll, tbtnSuggest, tbtnClose };

typedef System::SmallString<20>  TLabelArray[10];

class __declspec(delphiclass) TWPSpellDlg;
class __declspec(pascalimplementation) TWPSpellDlg : public Absspell::TAbsSpellDialog
{
	typedef Absspell::TAbsSpellDialog inherited;
	
__published:
	Stdctrls::TLabel* lblFound;
	Stdctrls::TLabel* lblNotFound;
	Stdctrls::TLabel* lblReplace;
	Edsutil::TEnterEdit* edtWord;
	Stdctrls::TLabel* lblSuggestions;
	Edsutil::TNewListBox* lstSuggest;
	Buttons::TBitBtn* btnReplace;
	Buttons::TBitBtn* btnSkip;
	Buttons::TBitBtn* btnSkipAll;
	Buttons::TBitBtn* btnSuggest;
	Buttons::TBitBtn* btnAdd;
	Buttons::TBitBtn* btnClose;
	Extctrls::TPanel* pnlIcons;
	Buttons::TSpeedButton* btnA;
	Buttons::TSpeedButton* btnE;
	Buttons::TSpeedButton* btnI;
	Buttons::TSpeedButton* btnO;
	Buttons::TSpeedButton* btnU;
	Buttons::TSpeedButton* btnN;
	Buttons::TSpeedButton* btnN2;
	void __fastcall edtWordExit(System::TObject* Sender);
	void __fastcall lstSuggestChange(System::TObject* Sender);
	void __fastcall lstSuggestDblClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, Word &Key, Classes::TShiftState Shift);
	void __fastcall AccentClick(System::TObject* Sender);
	void __fastcall btnSuggestClick(System::TObject* Sender);
	void __fastcall btnReplaceClick(System::TObject* Sender);
	void __fastcall btnAddClick(System::TObject* Sender);
	void __fastcall btnSkipClick(System::TObject* Sender);
	void __fastcall btnSkipAllClick(System::TObject* Sender);
	void __fastcall btnCloseClick(System::TObject* Sender);
	void __fastcall lstSuggestClick(System::TObject* Sender);
	void __fastcall lstSuggestEnter(System::TObject* Sender);
	void __fastcall QuickSuggest(System::TObject* Sender, Word &Key, Classes::TShiftState Shift);
	
public:
	__fastcall virtual TWPSpellDlg(Classes::TComponent* AOwner);
	virtual void __fastcall SetNotFoundPrompt( System::AnsiString ToString);
	virtual void __fastcall SetNotFoundCaption( System::AnsiString ToString);
	virtual void __fastcall SetEditWord( System::AnsiString ToWord);
	virtual System::AnsiString __fastcall GetEditWord(void);
	virtual void __fastcall SetEditAsActive(void);
	virtual void __fastcall SetLabelLanguage(void);
	virtual void __fastcall EnableSkipButtons(void);
	virtual void __fastcall DisableSkipButtons(void);
	virtual void __fastcall SetAccentSet(Absspell::TAccentSet Accents);
	virtual void __fastcall ClearSuggestList(void);
	virtual void __fastcall MakeSuggestions(void);
public:
	/* TAbsSpellDialog.Destroy */ __fastcall virtual ~TWPSpellDlg(void) { }
	
public:
	/* TForm.CreateNew */ __fastcall TWPSpellDlg(Classes::TComponent* AOwner, int Dummy) : Absspell::TAbsSpellDialog(
		AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ __fastcall TWPSpellDlg(HWND ParentWindow) : Absspell::TAbsSpellDialog(
		ParentWindow) { }
	
};

//-- var, const, procedure ---------------------------------------------------
extern System::SmallString<20>  cLabels[1][10];
//-- template instantiations -------------------------------------------------
template class SmallString<20> ;

}	/* namespace Wpspell */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Wpspell;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// WPSpell
