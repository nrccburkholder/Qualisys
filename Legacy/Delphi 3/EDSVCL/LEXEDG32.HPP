//----------------------------------------------------------------------------
// LexEdg32.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: LexEdg32.pas
//----------------------------------------------------------------------------
#ifndef LexEdg32HPP
#define LexEdg32HPP
//----------------------------------------------------------------------------
#include <System.hpp>
namespace Lexedg32
{
//-- type declarations -------------------------------------------------------
typedef short Int16;

typedef Byte TEdgeInfo[3];

#pragma pack(push, 1)
struct TDiskEdge
{
	Byte EdgeInfo[3];
	char Letter;
} ;
#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define InfoBytes (Byte)(3)
extern Byte flNodeEnd;
extern Byte flWordEnd;
extern bool __fastcall NodeEnd(TDiskEdge AnEdge);
extern bool __fastcall WordEnd(TDiskEdge AnEdge);
extern long __fastcall ChildID(TDiskEdge AnEdge);

}	/* namespace Lexedg32 */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Lexedg32;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// LexEdg32
