//----------------------------------------------------------------------------
// W96Spell.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: W96Spell.pas
//----------------------------------------------------------------------------
#ifndef W96SpellHPP
#define W96SpellHPP
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
namespace W96spell
{
//-- type declarations -------------------------------------------------------
enum TW96Labels { tlblSpellCheck, tlblFound, tlblNotFound, tbtnReplace, tbtnReplaceAll, tbtnAdd, tbtnSkip, 
	tbtnSkipAll, tbtnClose };

typedef System::SmallString<20>  TLabelArray[9];

class __declspec(delphiclass) TW96SpellDlg;
class __declspec(pascalimplementation) TW96SpellDlg : public Absspell::TAbsSpellDialog
{
	typedef Absspell::TAbsSpellDialog inherited;
	
__published:
	Extctrls::TPanel* Panel1;
	Stdctrls::TLabel* lblFound;
	Buttons::TSpeedButton* SpeedButton1;
	Extctrls::TShape* Shape1;
	Stdctrls::TLabel* lblSpellChk;
	Extctrls::TShape* Shape2;
	Extctrls::TPanel* Panel2;
	Edsutil::TEnterEdit* edtWord;
	Edsutil::TNewListBox* lstSuggest;
	Extctrls::TPanel* pnlIcons;
	Buttons::TSpeedButton* btnA;
	Buttons::TSpeedButton* btnE;
	Buttons::TSpeedButton* btnI;
	Buttons::TSpeedButton* btnO;
	Buttons::TSpeedButton* btnU;
	Buttons::TSpeedButton* btnN;
	Buttons::TSpeedButton* btnN2;
	Buttons::TBitBtn* btnReplace;
	Buttons::TBitBtn* btnAdd;
	Buttons::TBitBtn* btnSkip;
	Buttons::TBitBtn* btnSkipAll;
	Buttons::TBitBtn* btnClose;
	Buttons::TBitBtn* btnReplaceAll;
	void __fastcall edtWordExit(System::TObject* Sender);
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
	__fastcall virtual TW96SpellDlg(Classes::TComponent* AOwner);
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
	/* TAbsSpellDialog.Destroy */ __fastcall virtual ~TW96SpellDlg(void) { }
	
public:
	/* TForm.CreateNew */ __fastcall TW96SpellDlg(Classes::TComponent* AOwner, int Dummy) : Absspell::TAbsSpellDialog(
		AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ __fastcall TW96SpellDlg(HWND ParentWindow) : Absspell::TAbsSpellDialog(
		ParentWindow) { }
	
};

//-- var, const, procedure ---------------------------------------------------
extern System::SmallString<20>  cLabels[1][9];
extern TW96SpellDlg* W96SpellDlg;
//-- template instantiations -------------------------------------------------
template class SmallString<20> ;

}	/* namespace W96spell */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace W96spell;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// W96Spell
