//----------------------------------------------------------------------------
// EDSDB.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: EDSDB.pas
//----------------------------------------------------------------------------
#ifndef EDSDBHPP
#define EDSDBHPP
//----------------------------------------------------------------------------
#include <Grids.hpp>
#include <Mask.hpp>
#include <DBGrids.hpp>
#include <DBCtrls.hpp>
#include <ExtCtrls.hpp>
#include <StdCtrls.hpp>
#include <Menus.hpp>
#include <Forms.hpp>
#include <Graphics.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <Messages.hpp>
#include <Windows.hpp>
#include <SysUtils.hpp>
#include <System.hpp>
namespace Edsdb
{
//-- type declarations -------------------------------------------------------
class __declspec(delphiclass) TDBEnterEdit;
class __declspec(pascalimplementation) TDBEnterEdit : public Dbctrls::TDBEdit
{
	typedef Dbctrls::TDBEdit inherited;
	
protected:
	virtual void __fastcall KeyPress(char &Key);
	virtual void __fastcall KeyDown(Word &Key, Classes::TShiftState Shift);
public:
	/* TDBEdit.Create */ __fastcall virtual TDBEnterEdit(Classes::TComponent* AOwner) : Dbctrls::TDBEdit(
		AOwner) { }
	/* TDBEdit.Destroy */ __fastcall virtual ~TDBEnterEdit(void) { }
	
public:
	/* TWinControl.CreateParented */ __fastcall TDBEnterEdit(HWND ParentWindow) : Dbctrls::TDBEdit(ParentWindow
		) { }
	
};

class __declspec(delphiclass) TNewDBGrid;
class __declspec(pascalimplementation) TNewDBGrid : public Dbgrids::TDBGrid
{
	typedef Dbgrids::TDBGrid inherited;
	
__published:
	__property OnClick ;
	__property OnMouseDown ;
	__property OnMouseMove ;
	__property OnMouseUp ;
public:
	/* TCustomDBGrid.Create */ __fastcall virtual TNewDBGrid(Classes::TComponent* AOwner) : Dbgrids::TDBGrid(
		AOwner) { }
	/* TCustomDBGrid.Destroy */ __fastcall virtual ~TNewDBGrid(void) { }
	
public:
	/* TWinControl.CreateParented */ __fastcall TNewDBGrid(HWND ParentWindow) : Dbgrids::TDBGrid(ParentWindow
		) { }
	
};

//-- var, const, procedure ---------------------------------------------------
extern void __fastcall Register(void);

}	/* namespace Edsdb */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Edsdb;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// EDSDB
