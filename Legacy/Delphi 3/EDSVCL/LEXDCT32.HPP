//----------------------------------------------------------------------------
// LexDCT32.hpp - bcbdcc32 generated hdr (DO NOT EDIT) rev: 0
// From: LexDCT32.pas
//----------------------------------------------------------------------------
#ifndef LexDCT32HPP
#define LexDCT32HPP
//----------------------------------------------------------------------------
#include <LexEdg32.hpp>
#include <CList32.hpp>
#include <Windows.hpp>
#include <Forms.hpp>
#include <Dialogs.hpp>
#include <Classes.hpp>
#include <SysUtils.hpp>
#include <System.hpp>
namespace Lexdct32
{
//-- type declarations -------------------------------------------------------
typedef short Int16;

typedef char TCopyRight[50];

typedef SmallString<50>  TDCTStr;

#pragma pack(push, 1)
struct THeader
{
	Byte Version;
	char Copyright[50];
	Byte Reserved[32];
} ;
#pragma pack(pop)

typedef Lexedg32::TDiskEdge TDiskEdgeArray[512];

typedef TDiskEdgeArray *PDiskEdgeArray;

class __declspec(delphiclass) TDCTFile;
class __declspec(pascalimplementation) TDCTFile : public Clist32::TLinkedListNode
{
	typedef Clist32::TLinkedListNode inherited;
	
private:
	System::file FFile;
	System::AnsiString FFileName;
	long FDictSize;
	THeader FHeader;
	long FBlock;
	TDiskEdgeArray *FBuffer;
	bool __fastcall HeaderVerified(void);
	void __fastcall ReadBlock(long Block);
	bool __fastcall OpenDictionary(void);
	void __fastcall CloseDictionary(void);
	void __fastcall CacheAlloc(void);
	void __fastcall CacheDeAlloc(void);
	
public:
	__fastcall TDCTFile( System::AnsiString DCTFileName);
	__fastcall virtual ~TDCTFile(void);
	Lexedg32::TDiskEdge __fastcall FetchEdge(long AnEdge);
	Lexedg32::TDiskEdge __fastcall ScanNode(long StartEdge, char ForLetter);
	bool __fastcall InDictionary( TDCTStr &AWord);
	void __fastcall DCTToTextFile( System::AnsiString ToFile);
	__property System::AnsiString FileName = {read=FFileName, write=FFileName, nodefault};
};

class __declspec(delphiclass) TDictionary;
class __declspec(pascalimplementation) TDictionary : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	bool FOpen;
	Clist32::TLinkedList* FDCTs;
	System::AnsiString FUserFile;
	Classes::TStringList* FAddedList;
	Classes::TStringList* FExclude;
	long FUserSize;
	bool FSaveAdded;
	int FTableSize;
	void *FScanTable;
	TDCTStr __fastcall AdjustCase( TDCTStr &St,  TDCTStr &PictureSt);
	void __fastcall AdjustList(Classes::TStringList* &AList,  TDCTStr &PictureSt);
	long __fastcall UserDCTSize(void);
	Classes::TStringList* __fastcall SuggestTwoWords( TDCTStr &AWord, Word SuggestNum);
	void __fastcall Suggest_First( TDCTStr &AWord, Classes::TStringList* &TheList, Word SuggestNum);
	
public:
	__fastcall TDictionary(void);
	__fastcall virtual ~TDictionary(void);
	void __fastcall WriteAddedList(void);
	bool __fastcall DCTAlreadyOpen( System::AnsiString DCTName);
	bool __fastcall OpenDictionary( System::AnsiString DCTName);
	bool __fastcall OpenUserDictionary( System::AnsiString UserName);
	bool __fastcall OpenExclusionFile( System::AnsiString ExcName);
	void __fastcall CloseDictionaries(void);
	bool __fastcall InDictionary( TDCTStr &AWord);
	void __fastcall AssignScanTable(int Size, void * TablePtr);
	Classes::TStringList* __fastcall QuickSuggest( TDCTStr &AWord, Word SuggestNum);
	Classes::TStringList* __fastcall SuggestWords( TDCTStr &AWord, Word SuggestNum);
	bool __fastcall AddWord( TDCTStr &AWord);
	__property bool Open = {read=FOpen, write=FOpen, nodefault};
	__property System::AnsiString UserDict = {read=FUserFile, write=FUserFile, nodefault};
	__property Classes::TStringList* AddedWords = {read=FAddedList, write=FAddedList, nodefault};
	__property int TableSize = {read=FTableSize, nodefault};
	__property void * ScanTable = {read=FScanTable, nodefault};
};

class __declspec(delphiclass) TEDictionaryInUse;
class __declspec(pascalimplementation) TEDictionaryInUse : public Sysutils::Exception
{
	typedef Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ __fastcall TEDictionaryInUse(const System::AnsiString Msg) : Sysutils::Exception(
		Msg) { }
	/* Exception.CreateFmt */ __fastcall TEDictionaryInUse(const System::AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ __fastcall TEDictionaryInUse(int Ident) : Sysutils::Exception(Ident) { }
	/* Exception.CreateResFmt */ __fastcall TEDictionaryInUse(int Ident, const System::TVarRec * Args, 
		const int Args_Size) : Sysutils::Exception(Ident, Args, Args_Size) { }
	/* Exception.CreateHelp */ __fastcall TEDictionaryInUse(const System::AnsiString Msg, int AHelpContext
		) : Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ __fastcall TEDictionaryInUse(const System::AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext
		) { }
	/* Exception.CreateResHelp */ __fastcall TEDictionaryInUse(int Ident, int AHelpContext) : Sysutils::
		Exception(Ident, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ __fastcall TEDictionaryInUse(int Ident, const System::TVarRec * Args
		, const int Args_Size, int AHelpContext) : Sysutils::Exception(Ident, Args, Args_Size, AHelpContext
		) { }
	
public:
	/* TObject.Destroy */ __fastcall virtual ~TEDictionaryInUse(void) { }
	
};

class __declspec(delphiclass) TEDictionaryCorrupt;
class __declspec(pascalimplementation) TEDictionaryCorrupt : public Sysutils::Exception
{
	typedef Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ __fastcall TEDictionaryCorrupt(const System::AnsiString Msg) : Sysutils::Exception(
		Msg) { }
	/* Exception.CreateFmt */ __fastcall TEDictionaryCorrupt(const System::AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ __fastcall TEDictionaryCorrupt(int Ident) : Sysutils::Exception(Ident) { }
		
	/* Exception.CreateResFmt */ __fastcall TEDictionaryCorrupt(int Ident, const System::TVarRec * Args
		, const int Args_Size) : Sysutils::Exception(Ident, Args, Args_Size) { }
	/* Exception.CreateHelp */ __fastcall TEDictionaryCorrupt(const System::AnsiString Msg, int AHelpContext
		) : Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ __fastcall TEDictionaryCorrupt(const System::AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext
		) { }
	/* Exception.CreateResHelp */ __fastcall TEDictionaryCorrupt(int Ident, int AHelpContext) : Sysutils::
		Exception(Ident, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ __fastcall TEDictionaryCorrupt(int Ident, const System::TVarRec * 
		Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Ident, Args, Args_Size, AHelpContext
		) { }
	
public:
	/* TObject.Destroy */ __fastcall virtual ~TEDictionaryCorrupt(void) { }
	
};

//-- var, const, procedure ---------------------------------------------------
extern System::SmallString<4>  DCTExt;
#define UserDCTDef "CUSTOM.DIC"
#define CopyLength (Byte)(50)
extern Byte Version;
#define MinCachedEdges (Byte)(64)
#define MaxCachedEdges (Word)(16000)
#define MaxWordLength (Byte)(50)
#define CachedEdges (Byte)(128)
#define CacheSize (Word)(512)
extern char EDSCopyRight[50];
extern TDictionary* DCT;
extern bool DCTInUse;
//-- template instantiations -------------------------------------------------
template class SmallString<4> ;
template class SmallString<50> ;

}	/* namespace Lexdct32 */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Lexdct32;
#endif
//-- end unit ----------------------------------------------------------------
#endif	// LexDCT32
