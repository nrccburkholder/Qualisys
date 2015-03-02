//----------------------------------------------------------------------------
// MSSpell.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: MSSpell.pas
//----------------------------------------------------------------------------
#ifndef MSSpellHPP
#define MSSpellHPP
//----------------------------------------------------------------------------
#include <SpellGbl.hpp>
#include <AbsSpell.hpp>
#include <LexDCT32.hpp>
#include <EDSUtil.hpp>
#include <StdCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Buttons.hpp>
#include <Dialogs.hpp>
#include <Forms.hpp>
#include <Controls.hpp>
#include <Graphics.hpp>
#include <Classes.hpp>
#include <Messages.hpp>
#include <Windows.hpp>
#include <SysUtils.hpp>
#include <System.hpp>
namespace Msspell
{
//-- type declarations -------------------------------------------------------
enum TMSLabels { tlblFound, tlblNotFound, tlblReplace, tlblSuggestions, tbtnReplace, tbtnReplaceAll, 
	tbtnAdd, tbtnSkip, tbtnSkipAll, tbtnSuggest, tbtnClose, tbtnAutoCorrect, tbtnOptions, tbtnUndoLast, 
	tbtnHelp };

typedef System::SmallString<20>  TLabelArray[15];

class __declspec(delphiclass) TMSSpellDlg;
class __declspec(pascalimplementation) TMSSpellDlg : public Absspell::TAbsSpellDialog
{
	typedef Absspell::TAbsSpellDialog inherited;
	
__published:
	Stdctrls::TLabel* lblFound;
	Stdctrls::TLabel* lblReplace;
	Stdctrls::TLabel* lblSuggestions;
	Edsutil::TEnterEdit* edtWord;
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
	Buttons::TBitBtn* btnAutoCorrect;
	Buttons::TBitBtn* btnOptions;
	Buttons::TBitBtn* btnUndo;
	Buttons::TBitBtn* btnHelp;
	Buttons::TBitBtn* btnReplaceAll;
	Edsutil::TEnterEdit* edtCurWord;
	void __fastcall lstSuggestChange(System::TObject* Sender);
	void __fastcall lstSuggestDblClick(System::TObject* Sender);
	void __fastcall AccentClick(System::TObject* Sender);
	void __fastcall btnSuggestClick(System::TObject* Sender);
	void __fastcall btnCloseClick(System::TObject* Sender);
	void __fastcall btnAddClick(System::TObject* Sender);
	void __fastcall btnReplaceClick(System::TObject* Sender);
	void __fastcall btnReplaceAllClick(System::TObject* Sender);
	void __fastcall btnSkipClick(System::TObject* Sender);
	void __fastcall btnSkipAllClick(System::TObject* Sender);
	void __fastcall QuickSuggest(System::TObject* Sender, Word &Key, Classes::TShiftState Shift);
	
public:
	__fastcall virtual TMSSpellDlg(Classes::TComponent* AOwner);
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
	/* TAbsSpellDialog.Destroy */ __fastcall virtual ~TMSSpellDlg(void) { }
	
public:
	/* TForm.CreateNew */ __fastcall TMSSpellDlg(Classes::TComponent* AOwner, int Dummy) : Absspell::TAbsSpellDialog(
		AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ __fastcall TMSSpellDlg(HWND ParentWindow) : Absspell::TAbsSpellDialog(
		ParentWindow) { }
	
};

//-- var, const, procedure ---------------------------------------------------
extern System::SmallString<20>  cLabels[1][15];
extern TMSSpellDlg* MSSpellDlg;
//-- template instantiations -------------------------------------------------
template class SmallString<20> ;

}	/* namespace Msspell */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Msspell;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// MSSpell
