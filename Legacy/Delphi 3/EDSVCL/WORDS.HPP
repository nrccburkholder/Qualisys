//----------------------------------------------------------------------------
// Words.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: Words.pas
//----------------------------------------------------------------------------
#ifndef WordsHPP
#define WordsHPP
//----------------------------------------------------------------------------
#include <Buttons.hpp>
#include <StdCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Dialogs.hpp>
#include <Forms.hpp>
#include <Controls.hpp>
#include <Graphics.hpp>
#include <Classes.hpp>
#include <Messages.hpp>
#include <Windows.hpp>
#include <SysUtils.hpp>
#include <System.hpp>
namespace Words
{
//-- type declarations -------------------------------------------------------
class __declspec(delphiclass) TWordForm;
class __declspec(pascalimplementation) TWordForm : public Forms::TForm
{
	typedef Forms::TForm inherited;
	
__published:
	Stdctrls::TLabel* Label1;
	Stdctrls::TLabel* Label2;
	Extctrls::TBevel* Bevel1;
	Extctrls::TBevel* Bevel2;
	Buttons::TBitBtn* btnOk;
	Stdctrls::TLabel* lblWords;
	Stdctrls::TLabel* lblUniqueWords;
	void __fastcall btnOkClick(System::TObject* Sender);
public:
	/* TForm.Create */ __fastcall virtual TWordForm(Classes::TComponent* AOwner) : Forms::TForm(AOwner)
		 { }
	/* TForm.CreateNew */ __fastcall TWordForm(Classes::TComponent* AOwner, int Dummy) : Forms::TForm(AOwner
		, Dummy) { }
	/* TForm.Destroy */ __fastcall virtual ~TWordForm(void) { }
	
public:
	/* TWinControl.CreateParented */ __fastcall TWordForm(HWND ParentWindow) : Forms::TForm(ParentWindow
		) { }
	
};

//-- var, const, procedure ---------------------------------------------------
extern TWordForm* WordForm;

}	/* namespace Words */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Words;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// Words
