//----------------------------------------------------------------------------
// EDSUtil.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: EDSUtil.pas
//----------------------------------------------------------------------------
#ifndef EDSUtilHPP
#define EDSUtilHPP
//----------------------------------------------------------------------------
#include <ExtCtrls.hpp>
#include <StdCtrls.hpp>
#include <Menus.hpp>
#include <Tabnotbk.hpp>
#include <Forms.hpp>
#include <Graphics.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Messages.hpp>
#include <Windows.hpp>
#include <SysUtils.hpp>
#include <System.hpp>
namespace Edsutil
{
//-- type declarations -------------------------------------------------------
class __declspec(delphiclass) TEnterEdit;
class __declspec(pascalimplementation) TEnterEdit : public Stdctrls::TEdit
{
	typedef Stdctrls::TEdit inherited;
	
protected:
	virtual void __fastcall KeyPress(char &Key);
	virtual void __fastcall KeyDown(Word &Key, Classes::TShiftState Shift);
public:
	/* TCustomEdit.Create */ __fastcall virtual TEnterEdit(Classes::TComponent* AOwner) : Stdctrls::TEdit(
		AOwner) { }
	
public:
	/* TWinControl.CreateParented */ __fastcall TEnterEdit(HWND ParentWindow) : Stdctrls::TEdit(ParentWindow
		) { }
	/* TWinControl.Destroy */ __fastcall virtual ~TEnterEdit(void) { }
	
};

class __declspec(delphiclass) TNewListBox;
class __declspec(pascalimplementation) TNewListBox : public Stdctrls::TListBox
{
	typedef Stdctrls::TListBox inherited;
	
private:
	Classes::TNotifyEvent FOnChange;
	int FLastSel;
	virtual void __fastcall Click(void);
	
protected:
	virtual void __fastcall Change(void);
	
__published:
	__property Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	
public:
	__fastcall virtual TNewListBox(Classes::TComponent* AOwner);
public:
	/* TCustomListBox.Destroy */ __fastcall virtual ~TNewListBox(void) { }
	
public:
	/* TWinControl.CreateParented */ __fastcall TNewListBox(HWND ParentWindow) : Stdctrls::TListBox(ParentWindow
		) { }
	
};

class __declspec(delphiclass) TNewLabel;
class __declspec(pascalimplementation) TNewLabel : public Stdctrls::TLabel
{
	typedef Stdctrls::TLabel inherited;
	
private:
	Classes::TNotifyEvent FOnChange;
	System::AnsiString __fastcall GetCaption(void);
	void __fastcall SetCaption( System::AnsiString Value);
	
protected:
	virtual void __fastcall Change(void);
	
__published:
	__property System::AnsiString Caption = {read=GetCaption, write=SetCaption, nodefault};
	__property Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	
public:
	__fastcall virtual TNewLabel(Classes::TComponent* AOwner);
public:
	/* TGraphicControl.Destroy */ __fastcall virtual ~TNewLabel(void) { }
	
};

//-- var, const, procedure ---------------------------------------------------
extern void __fastcall SurfaceControl(Controls::TWinControl* AControl);
extern void __fastcall Register(void);

}	/* namespace Edsutil */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Edsutil;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// EDSUtil
