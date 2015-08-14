//----------------------------------------------------------------------------
// MemoUtil.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: MemoUtil.pas
//----------------------------------------------------------------------------
#ifndef MemoUtilHPP
#define MemoUtilHPP
//----------------------------------------------------------------------------
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
namespace Memoutil
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern tagPOINT __fastcall Memo_CursorPos(Stdctrls::TMemo* AMemo);
extern int __fastcall Memo_WhereY(Stdctrls::TMemo* AMemo);

}	/* namespace Memoutil */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Memoutil;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// MemoUtil
