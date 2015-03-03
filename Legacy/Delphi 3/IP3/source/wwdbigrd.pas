{
//
// Components : TwwDBCustomGrid
//
// Copyright (c) 1995, 1996, 1997 by Woll2Woll Software
//
//
}
unit Wwdbigrd;

interface

uses SysUtils, WinTypes, WinProcs, Messages, Classes, Controls, Forms,
     Graphics, Menus, StdCtrls, DB, DBTables, Grids, DBCtrls,
     wwTable, wwStr, wwdbedit, wwtypes, buttons;

type
  TwwCustomDBGrid = class;

  TTitleButtonClickEvent =
     procedure (Sender: TObject; AFieldName: string) of object;
  TCalcCellColorsEvent =
     procedure (Sender: TObject; Field: TField; State: TGridDrawState;
		Highlight: boolean; AFont: TFont; ABrush: TBrush) of object;
  TCalcTitleAttributesEvent =
     procedure (Sender: TObject; AFieldName: string; AFont: TFont; ABrush: TBrush;
		var ATitleAlignment: TAlignment) of object;

  TwwMultiSelectOption = (msoAutoUnselect, msoShiftSelect);
  TwwMultiSelectOptions = set of TwwMultiSelectOption;
{
  TwwGridColumn = class
  public
  published
     FieldName: string read GetFieldName write SetFieldName;
     DisplayWidth: integer read GetDisplayWidth write SetDisplayWidth;
     DisplayLabel: string read GetDisplayLabel write SetDisplayLabel;
  end;

  TwwGridColumns = class
  private
     FList: TStringList;
     FGrid: TwwCustomDBGrid;
     function GetItem(Index: Integer): TwwGridColumn;
  public
     constructor Create(AGrid: TwwCustomDBGrid);
     destructor Destroy; override;

     procedure TwwGridColumns.GetItemFromField(AFieldName: string): TwwGridColumn;
     function  Find(const AFieldName: string; var Index: Integer): Boolean;
     procedure Remove(const AFieldName: string);
     procedure Insert(AFieldName: string; DisplayWidth: integer; DisplayLabel: string);

     property Items[Index: Integer]: TwwGridColumn read GetItem;
  end;
}
  TwwGridDataLink = class(TDataLink)
  private
    FGrid: TwwCustomDBGrid;
    FFieldCount: Integer;
    FFieldMapSize: Integer;
    FModified: Boolean;
    FInUpdateData: Boolean;
    FFieldMap: Pointer;
    function GetDefaultFields: Boolean;
    function GetFields(I: Integer): TField;
  protected
    procedure ActiveChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure EditingChanged; override;
    procedure LayoutChanged; override;
    procedure RecordChanged(Field: TField); override;
    procedure UpdateData; override;
  public
    constructor Create(AGrid: TwwCustomDBGrid);
    destructor Destroy; override;
    function AddMapping(const FieldName: string): Boolean;
    procedure ClearMapping;
    procedure Modified;
    procedure Reset;
    property DefaultFields: Boolean read GetDefaultFields;
    property FieldCount: Integer read FFieldCount;
    property Fields[I: Integer]: TField read GetFields;
    property isFieldModified : boolean read FModified;
  end;

  TwwDBGridOption = (dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator,
    dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect,
    dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit,
    dgWordWrap, dgPerfectRowFit, dgMultiSelect);
  TwwDBGridOptions = set of TwwDBGridOption;
  TwwDBGridKeyOption = (dgEnterToTab, dgAllowDelete, dgAllowInsert);
  TwwDBGridKeyOptions = set of TwwDBGridKeyOption;
  TwwDrawDataCellEvent = procedure (Sender: TObject; const Rect: TRect; Field: TField;
    State: TGridDrawState) of object;
  TIndicatorColorType = (icBlack, icYellow);
  TwwBitmapSizeType = (bsOriginalSize, bsStretchToFit, bsFitHeight, bsFitWidth);

  TwwIButton=class(TSpeedButton)
  protected
     procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  public
     procedure Loaded; override;
     procedure Paint; override;
  end;

  TwwInplaceEdit = class(TInplaceEdit)
    private
      FwwPicture: TwwDBPicture;
      FWordWrap: boolean;
      ParentGrid: TwwCustomDBGrid;
      FUsePictureMask: boolean;

      procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
      procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
      procedure WMPaste(var Message: TMessage); message WM_PASTE;  {10/28/96 }

    protected
      procedure KeyDown(var Key: Word; Shift: TShiftState); override;
      procedure CreateParams(var Params: TCreateParams); override;
      procedure KeyUp(var Key: Word; Shift: TShiftState); override;
      procedure KeyPress(var Key: Char); override;
      procedure SetWordWrap(val: boolean);
    public
      constructor wwCreate(AOwner: TComponent; dummy: integer); virtual;
      destructor Destroy; override;
      function IsValidPictureValue(s: string): boolean;
      Function HavePictureMask: boolean;

      property Picture: TwwDBPicture read FwwPicture write FwwPicture;
      property WordWrap: boolean read FWordWrap write SetWordWrap;
      property Color;
      property Font;
    end;

  TwwCustomDBGrid = class(TCustomGrid)
  private
    FSelected : TStrings;
    FTitleFont: TFont;
    FTitleColor: TColor;
    FReadOnly: Boolean;
    FUserChange: Boolean;
    FDataChanged: Boolean;
    FEditRequest: Boolean;
    FUpdatingColWidths: Boolean;
    FOptions: TwwDBGridOptions;
    FKeyOptions: TwwDBGridKeyOptions;
    FTitleOffset, FIndicatorOffset: Byte;
    FUpdateLock: Byte;
    FInColExit: Boolean;
    FDefaultDrawing: Boolean;
    FSelfChangingTitleFont: Boolean;
    FSelRow: Integer;
    FDataLink: TwwGridDataLink;
    FOnColEnter: TNotifyEvent;
    FOnColExit: TNotifyEvent;
    FOnDrawDataCell: TwwDrawDataCellEvent;
    FOnCalcCellColors: TCalcCellColorsEvent;
    FOnCalcTitleAttributes: TCalcTitleAttributesEvent;
    FOnTitleButtonClick: TTitleButtonClickEvent;
    FOnCheckValue: TwwValidateEvent;
    FOnTopRowChanged: TNotifyEvent;
    FEditText: string;
    FIndicatorColor: TIndicatorColorType;
    FTitleAlignment: TAlignment;
    FRowHeightPercent: Integer;
    FTitleLines: integer;
    FShowVertScrollBar: boolean;
    FOnColumnMoved: TMovedEvent;
    FTitleButtons: boolean;
    FEditCalculated : boolean;
    FUseTFields: boolean;
    FIndicatorWidth: integer;
    FIndicatorButton: TwwIButton;

    InUpdateRowCount: boolean;
    FCalcCellRow, FCalcCellCol: integer;
    isWhiteBackground: boolean;
    isDrawFocusRect: boolean;
    SkipLineDrawing: boolean;
    TitleClickColumn: integer;
    TitleClickRow: integer;
    FMultiSelectOptions: TwwMultiSelectOptions;
    Function IsScrollBarVisible: boolean;
    function AcquireFocus: Boolean;
    procedure EditingChanged;
    function Edit: Boolean;
    function GetDataSource: TDataSource;
    function GetFieldCount: Integer;
    function GetFields(Index: Integer): TField;
    function GetSelectedField: TField;
    function GetSelectedIndex: Integer;
    procedure MoveCol(ACol: Integer);
    procedure RecordChanged(Field: TField);
    procedure SetDataSource(Value: TDataSource);
    procedure SetOptions(Value: TwwDBGridOptions);
    procedure SetSelectedField(Value: TField);
    procedure SetSelectedIndex(Value: Integer);
    procedure SetTitleFont(Value: TFont);
    procedure SetIndicatorColor(Value: TIndicatorColorType);
    procedure SetTitleAlignment(sel: TAlignment);
    procedure SetTitleLines(sel: integer);
    procedure SetRowHeightPercent(sel: Integer);
    Procedure SetShowVertScrollBar(val: boolean);
    Procedure SetTitleButtons(val: boolean);
    Function GetShowHorzScrollBar: Boolean;
    Procedure SetShowHorzScrollBar(val: boolean);
    function GetSelectedFields: TStrings;
    procedure SetSelectedFields(sel : TStrings);
{    Procedure SetWordWrap(val: boolean);}

    function GetColWidthsPixels(Index: Longint): Integer;  {4/23/97}
    procedure SetColWidthsPixels(Index: Longint; Value: Integer); {4/23/97}
    procedure SetIndicatorWidth(val: integer);

    procedure TitleFontChanged(Sender: TObject);
    procedure UpdateData;
    procedure UpdateActive;
    procedure CMExit(var Message: TMessage); message CM_EXIT;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMParentFontChanged(var Message: TMessage); message CM_PARENTFONTCHANGED;
    procedure CMDesignHitTest(var Msg: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure WMSetCursor(var Msg: TWMSetCursor); message WM_SETCURSOR;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
  protected

    FUpdateFields: Boolean;
    FAcquireFocus: Boolean;
    SuppressShowEditor: boolean;
    ShiftSelectMode: boolean;
    ShiftSelectBookmark: TBookmark;
    dummy1, dummy2: string;
    TitleTextOffset: integer;

    procedure LayoutChanged; virtual;
    procedure CalcRowHeight; dynamic;
    Function AllowCancelOnExit: boolean; dynamic;
    function CanEditAcceptKey(Key: Char): Boolean; override;
    function CanEditModify: Boolean; override;
    function GetEditLimit: Integer; override;
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
    procedure ColEnter; dynamic;
    procedure ColExit; dynamic;
    procedure Scroll(Distance: Integer); virtual;
    procedure ColWidthsChanged; override;
    function HighlightCell(DataCol, DataRow: Integer; const Value: string;
      AState: TGridDrawState): Boolean; virtual;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    function GetEditMask(ACol, ARow: Longint): string; override;
    function GetEditText(ACol, ARow: Longint): string; override;
    procedure SetEditText(ACol, ARow: Longint; const Value: string); override;
    function GetColField(ACol: Integer): TField;
    function GetFieldValue(ACol: Integer): string; dynamic;
    procedure DefineFieldMap; virtual;
    procedure DrawDataCell(const Rect: TRect; Field: TField;
      State: TGridDrawState); dynamic;
    procedure SetColumnAttributes; virtual;
    procedure KeyPress(var Key: Char); override;
    procedure LinkActive(Value: Boolean); virtual;
    procedure Loaded; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure TimedScroll(Direction: TGridScrollDirection); override;
    procedure CreateWnd; override;
    function IsWWControl(ACol, ARow: integer): boolean; virtual;

    property DefaultDrawing: Boolean read FDefaultDrawing write FDefaultDrawing default True;
    property DataSource: TDataSource read GetDataSource write SetDataSource; {W2W}
    property DataLink: TwwGridDataLink read FDataLink;
    property ParentColor default False;
    property ReadOnly: Boolean read FReadOnly write FReadOnly default False;
    property TitleColor: TColor read FTitleColor write FTitleColor default clBtnFace;
    property TitleFont: TFont read FTitleFont write SetTitleFont;
    property OnColEnter: TNotifyEvent read FOnColEnter write FOnColEnter;
    property OnColExit: TNotifyEvent read FOnColExit write FOnColExit;
    property OnDrawDataCell: TwwDrawDataCellEvent read FOnDrawDataCell write FOnDrawDataCell;
    procedure DoCalcCellColors(Field: TField; State: TGridDrawState;
	     highlight: boolean; AFont: TFont; ABrush: TBrush); virtual;
    procedure DoTitleButtonClick(AFieldName: string); virtual;
    procedure DoCalcTitleAttributes(AFieldName: string; AFont: TFont; ABrush: TBrush;
	     var FTitleAlignment: TAlignment); virtual;
    procedure UpdateScrollBar;
    Function IsValidCell(ACol, ARow: integer): boolean;
    function DbCol(col: integer): integer;
    function DbRow(row: integer): integer;
    procedure Draw3DLines(ARect: TRect; ACol, ARow: integer;
	    AState: TGridDrawState);
    Function CellColor(ACol, ARow: integer): TColor; virtual;
    procedure DrawCheckBox(ARect: TRect; ACol, ARow: integer; val: boolean); virtual;
    procedure DrawCheckBox_Checkmark(ARect: TRect; ACol, ARow: integer; val: boolean);
    procedure RefreshBookmarkList; virtual;
    function CreateEditor: TInplaceEdit; override;
    procedure HideControls; virtual;
    property OnColumnMoved: TMovedEvent read FOnColumnMoved write FOnColumnMoved;
    Procedure UnselectAll; virtual;
    Function IsSelectedCheckbox(ACol: integer): boolean;
    procedure DataChanged; virtual;
    Function IsSelectedRow(DataRow: integer): boolean; dynamic;
    procedure DoTopRowChanged; virtual;
    property IndicatorWidth: integer read FIndicatorWidth write SetIndicatorWidth;
    {$ifdef win32}
     {$ifdef ver100}
     procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
     {$else}
     procedure GetChildren(Proc: TGetChildProc); override;
     {$endif}
    {$else}
    procedure WriteComponents(Writer: TWriter); override;
    {$endif}


  public
    SkipHideControls: boolean;  { IP Internal - Set by TwwDBLookupCombo DropDown method }
    SkipDataChange: boolean;    { IP Internal - Set by TwwDBLookupComboDlg }

    procedure FlushChanges; virtual;
    procedure UpdateRowCount;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override; {public to allow child to send keys to parent }
    Procedure SizeLastColumn;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsCheckBox(col,row: integer; var checkboxon, checkboxoff: string): boolean;
    Function IsMemoField(Acol, Arow: integer): boolean;
    Function IsSelected: boolean; dynamic;
    function AllowPerfectFit: boolean;
    Function DoPerfectFit: boolean;
    Procedure SelectRecord; virtual;
    Procedure UnselectRecord; virtual;
    Procedure SetPictureMask(FieldName: string; Mask: string);
    Procedure SetPictureAutoFill(FieldName: string; AutoFill: boolean);

    procedure DefaultDrawDataCell(const Rect: TRect; Field: TField; State: TGridDrawState);
    property ColWidthsPixels[Index: Longint]: Integer read GetColWidthsPixels write SetColWidthsPixels;
    property EditorMode;
    property FieldCount: Integer read GetFieldCount;
    property Fields[Index: Integer]: TField read GetFields;
    property SelectedField: TField read GetSelectedField write SetSelectedField;
    property SelectedIndex: Integer read GetSelectedIndex write SetSelectedIndex;
    property IndicatorColor: TIndicatorColorType read FIndicatorColor write SetIndicatorColor;
    property Options: TwwDBGridOptions read FOptions write SetOptions
       default [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines,
      dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit,
      dgWordWrap];
    property KeyOptions : TwwDBGridKeyOptions read FKeyOptions write FKeyOptions
       default [dgAllowInsert, dgAllowDelete];
    property TitleAlignment: TAlignment read FTitleAlignment write setTitleAlignment;
    property TitleLines : integer read FTitleLines write setTitleLines;
    property OnCalcCellColors: TCalcCellColorsEvent read FOnCalcCellColors write FOnCalcCellColors;
    property OnCalcTitleAttributes: TCalcTitleAttributesEvent read FOnCalcTitleAttributes write FOnCalcTitleAttributes;
    property OnTitleButtonClick: TTitleButtonClickEvent read FOnTitleButtonClick write FOnTitleButtonClick;
    property RowHeightPercent : Integer read FRowHeightPercent write SetRowHeightPercent Default 100;
    property ShowVertScrollBar: boolean read FShowVertScrollBar write setShowVertScrollBar default True;
    property ShowHorzScrollBar: boolean read getShowHorzScrollBar write setShowHorzScrollBar;
    property OnCheckValue: TwwValidateEvent read FOnCheckValue write FOnCheckValue;
    property OnTopRowChanged: TNotifyEvent read FOnTopRowChanged write FOnTopRowChanged;
    property CalcCellRow: integer read FCalcCellRow;  {onCalcCellColor Row}
    property CalcCellCol: integer read FCalcCellCol;  {onCalcCellColor Column}
    property TitleButtons: boolean read FTitleButtons write SetTitleButtons;
    property EditCalculated : boolean read FEditCalculated write FEditCalculated default False;
    property MultiSelectOptions: TwwMultiSelectOptions read FMultiSelectOptions write FMultiSelectOptions default [];
    property Selected : TStrings read getSelectedFields write setSelectedFields;
    property UseTFields: boolean read FUseTFields write FUseTFields default True;
    property IndicatorButton: TwwIButton read FIndicatorButton write FIndicatorButton stored False;

  end;

Procedure wwWriteTextLines(ACanvas: TCanvas;
    const ARect: TRect; DX, DY: Integer; S: PChar; Alignment: TAlignment);

implementation

uses DBConsts, Consts, Dialogs, wwcommon, wwpict, wwintl,
{$IFDEF WIN32}
bde
{$ELSE}
dbiprocs, dbiTypes, dbierrs
{$ENDIF}
;

{$IFDEF WIN32}
{$R WWDBI32.RES}
{$ELSE}
{$R WWDBIGRD.RES}
{$ENDIF}

const
  bmArrow = 'WWDBGARROW';
  bmEdit = 'WWDBEDIT';
  bmInsert = 'WWDBINSERT';
  bmArrowYellow = 'WWDBGARROWYELLOW';
  bmEditYellow = 'WWDBEDITYELLOW';
  bmInsertYellow = 'WWDBINSERTYELLOW';

  MaxMapSize = 65520 div SizeOf(Integer);
  GridScrollSize = 200;

  NormalPad = 2;

var
  BrowseIndicatorBitmap, EditIndicatorBitmap, InsertIndicatorBitmap: TBitmap;

Function min(x,y: integer): integer;
begin
   if x<y then min:= x
   else min:= y;
end;

{ Error reporting }
procedure RaiseGridError(const S: string);
begin
  raise EInvalidGridOperation.Create(S);
end;

procedure GridError(S: Word);
begin
  RaiseGridError(LoadStr(S));
end;

procedure GridErrorFmt(S: Word; const Args: array of const);
begin
  RaiseGridError(FmtLoadStr(S, Args));
end;

{ TwwGridDataLink }
type
  TIntArray = array[0..MaxMapSize] of Integer;
  PIntArray = ^TIntArray;

  TBitmapCacheType=class
    Bitmap: TBitmap;
    LookupValue: string;
    curField: TField;
  end;

constructor TwwGridDataLink.Create(AGrid: TwwCustomDBGrid);
begin
  inherited Create;
  FGrid := AGrid;
end;

destructor TwwGridDataLink.Destroy;
begin
  ClearMapping;
  inherited Destroy;
end;

function TwwGridDataLink.GetDefaultFields: Boolean;
begin
  Result := True;
  if DataSet <> nil then Result := DataSet.DefaultFields;
end;

function TwwGridDataLink.GetFields(I: Integer): TField;
begin
  if I < FFieldCount then
    Result := DataSet.Fields[PIntArray(FFieldMap)^[I]]
  else Result:= nil;
end;

function TwwGridDataLink.AddMapping(const FieldName: string): Boolean;
var
  Field: TField;
  NewSize: Integer;
  NewMap: Pointer;
begin
  if FFieldCount >= MaxMapSize then
  {$ifdef ver100}
     RaiseGridError(STooManyColumns);
  {$else}
     GridError(STooManyColumns);
  {$endif}
  Field := DataSet.FindField(FieldName);
  Result := Field <> nil;
  if Result then
  begin
    if FFieldMapSize = 0 then
    begin
      FFieldMapSize := 8;
      GetMem(FFieldMap, FFieldMapSize * SizeOf(Integer));
    end
    else if FFieldCount = FFieldMapSize then
    begin
      NewSize := FFieldMapSize;
      Inc(NewSize, NewSize);
      if (NewSize > MaxMapSize) or (NewSize < FFieldCount) then
	NewSize := MaxMapSize;
      GetMem(NewMap, NewSize * SizeOf(Integer));
      Move(FFieldMap^, NewMap^, SizeOf(Integer) * FFieldCount);
      FreeMem(FFieldMap, SizeOf(Integer) * FFieldCount);
      FFieldMapSize := NewSize;
      FFieldMap := NewMap;
    end;
    PIntArray(FFieldMap)^[FFieldCount] := Field.Index;
{    if FGrid.useTFields then
       PIntArray(FFieldMap)^[FFieldCount] := Field.Index
    else if wwFindSelected(FGrid.Selected, Field.FieldName, AIndex) then
       PIntArray(FFieldMap)^[FFieldCount] := AIndex;}
    Inc(FFieldCount);
  end;
end;

procedure TwwGridDataLink.ActiveChanged;
begin
  FGrid.LinkActive(Active);
end;

procedure TwwGridDataLink.ClearMapping;
begin
  if FFieldMap <> nil then
  begin
    FreeMem(FFieldMap, FFieldMapSize * SizeOf(Integer));
    FFieldMap := nil;
    FFieldMapSize := 0;
    FFieldCount := 0;
  end;
end;

procedure TwwGridDataLink.Modified;
begin
  FModified := True;
end;

procedure TwwGridDataLink.DataSetChanged;
begin
  FGrid.DataChanged;
  FModified := False;
end;

procedure TwwGridDataLink.DataSetScrolled(Distance: Integer);
begin
  FGrid.Scroll(Distance);
end;

procedure TwwGridDataLink.LayoutChanged;
begin
{  if FGrid.useTFields then} FGrid.LayoutChanged;
end;

procedure TwwGridDataLink.EditingChanged;
begin
  FGrid.EditingChanged;
end;

procedure TwwGridDataLink.RecordChanged(Field: TField);
begin
  if (Field = nil) or not FInUpdateData then
  begin
    FGrid.RecordChanged(Field);
    FModified := False;
  end;
end;

procedure TwwGridDataLink.UpdateData;
begin
  FInUpdateData := True;
  try
    if FModified then FGrid.UpdateData;
    FModified := False;
  finally
    FInUpdateData := False;
  end;
end;

procedure TwwGridDataLink.Reset;
begin
  if FModified then RecordChanged(nil) else begin
     if ((DataSource.DataSet.State = dsEdit) or (DataSource.DataSet.State = dsInsert)) and
	 dataSet.modified then
     begin
	 if MessageDlg(wwInternational.UserMessages.wwDBGridDiscardChanges,
		    mtConfirmation, [mbYes,mbNo], 0)<>mrYes then exit;
     end;
     Dataset.Cancel;
  end
end;

{ TwwCustomDBGrid }

var
  DrawBitmap: TBitmap;
  UserCount: Integer;

procedure UsesBitmap;
begin
  if UserCount = 0 then
  begin
    DrawBitmap := TBitmap.Create;
{    DrawBitmap.Monochrome := True;}
  end;
  Inc(UserCount);
end;

procedure ReleaseBitmap;
begin
  Dec(UserCount);
  if UserCount = 0 then begin
     DrawBitmap.Free;
     EditIndicatorBitmap.Free;
     BrowseIndicatorBitmap.Free;
     InsertIndicatorBitmap.Free;
     EditIndicatorBitmap:= Nil;
     BrowseIndicatorBitmap:= Nil;
     InsertIndicatorBitmap:= Nil;
  end;
end;

function Max(X, Y: Integer): Integer;
begin
  Result := Y;
  if X > Y then Result := X;
end;

{Parse a word from a string based on position and delimiters (#9, #10, #13, #32 or #45)...}
function GetNextWord
   ( s: PChar; var StartPos: LongInt; TextLen: LongInt;
     var Spaces: String; var TabCharsInWord: Boolean ): String;
var
   x, y       : Integer;
   RtnString  : String;
   LeadSpaces : String;
begin
   {Set default values...}
   RtnString            := '';
   LeadSpaces           := '';

   {Validate the StartPos value...}
   if ( (StartPos < 0) or
       (StartPos > TextLen) ) then
   begin
      StartPos := -1;
      Result := RtnString;
      exit;
   end;


   {Include LEADING spaces in the first word found...}
   if StartPos = 0 then
   begin
      if s[StartPos] = #32 then
      begin
	 {Skip over all leading spaces...}
	 for y := StartPos to TextLen do
	 begin
	    if s[y] <> #32 then Break
	    else
	       LeadSpaces := LeadSpaces + ' ';
	 end;

	 StartPos := y;  {...set new StartPos to 1 char after the leading spaces}
      end;
   end;  {if StartPos = 0}


   {Locate a SPACE (#32), C/R (#13), C/R+L/F (#13+#10) combination, L/F+C/R combination
   { (#10+#13), L/F (#10), Tab (#9) or hyphen '-' (#45)...}

   {NOTE: Paradox Memo fields use #10 as C/R+L/F combinations instead of #13+#10.}

   x:= StartPos;
   while (x<=TextLen) do
   begin
      case s[x] of
	#9 : {Tab...}
	begin
	   TabCharsInWord       := TRUE;
	   StartPos := x + 1;  {...set new StartPos to 1 char after the #9}
	   TabCharsInWord := TRUE;
	   Result := LeadSpaces + RtnString + #9;
	   exit;
	end;

	#10:{LineFeed (L/F)...}
	   if x < TextLen then
	   begin
	      if s[x +1] = #13 then  {...embeded C/R+L/F chars}
	      begin
		 StartPos := x + 2;  {...set new StartPos to 1 char after the #10+#13}
		 Result := LeadSpaces + RtnString + #13;  {...send #13 back so we know to L/F}
		 exit;
	      end
	      else  {...not a L/F+C/R combo, so just add a #13}
	      begin
		 StartPos := x + 1;          {...set new StartPos to 1 char after the #13}
		 Result := LeadSpaces + RtnString + #13;  {...send #13 back so we know to L/F}
		 exit;
	      end
	   end  {if x < TextLen}
	   else  {...x must be equal to TextLen...}
	   begin
	      StartPos:= x + 1;          {...set new StartPos to 1 char after the #13}
	      Result := LeadSpaces + RtnString + #13;  {...send #13 back so we know to L/F}
	      exit;
	   end;


	#13 : {Carriage Return (C/R)...}
	   if x < TextLen then
	   begin
	      if s[x +1] = #10 then  {...embeded C/R+L/F chars}
	      begin
		  StartPos := x + 2;  {...set new StartPos to 1 char after the #13+#10}
		  Result := LeadSpaces + RtnString + #13;  {...send #13 back so we know to L/F}
		  exit;
	      end
	      else  {...not a C/R+L/F combo, so just add a #13}
	      begin
		 StartPos := x + 1;          {...set new StartPos to 1 char after the #13}
		 Result := LeadSpaces + RtnString + #13;  {...send #13 back so we know to L/F}
		 exit;
	      end
	   end   {if x < TextLen}
	   else  {...x must be equal to TextLen...}
	   begin
	      StartPos := x + 1;          {...set new StartPos to 1 char after the #13}
	      Result := LeadSpaces + RtnString + #13;  {...send #13 back so we know to L/F}
	      exit;
	   end;

	#32 : {Space ' '...}
	   begin
	   {Determine how many spaces to the next non-space character...}
	      if x = TextLen then  {...last char is a space}
	      begin
		 StartPos := TextLen + 1;  {...set to 1 char past end of buffer}
		 Result := '';
		 exit;
	      end
	      else begin
		 for y := x to TextLen do
		 begin
		    if s[y] = #32 then
		       Spaces := Spaces + ' '
		    else  {...next char is not a space, so exit the loop}
		       Break;
		 end;
		 StartPos := y;  {...set new StartPos to 1 char after the space}
		 Result := LeadSpaces + RtnString;
		 exit;
	      end;

	   end;  {#32 - Space}

	else  {...char is not one of the ones we want to trap}
	   RtnString := RtnString + s[x];
      end;  {case s[x]}

      inc(x);
   end;  {while x <= TextLen do}

   {At this point, the end of the text has been reached...}
   StartPos := x + 1;  {...so that if routine is called again, it will exit at top}
   Result := LeadSpaces + RtnString;  {...all characters already added}
end;  {GetNextWord}


{ Support all colors }
procedure WriteText(ACanvas: TCanvas; ARect: TRect; DX, DY: Integer;
  const Text: string; Alignment: TAlignment);
const
  AlignFlags : array [TAlignment] of Integer =
    ( DT_LEFT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_RIGHT or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX,
      DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX );
var
  B, R: TRect;
  I, Left: Longint; { 6/17/97 - Longint for 16 bit compatibilty }
  {$ifndef win32}
  S: array[0..255] of Char;
  {$endif}
begin
  I := ColorToRGB(ACanvas.Brush.Color);
  if GetNearestColor(ACanvas.Handle, I) = I then
  begin                       { Use ExtTextOut for solid colors }
    case Alignment of
      taLeftJustify:
	Left := ARect.Left + DX;
      taRightJustify:
	Left := ARect.Right - ACanvas.TextWidth(Text) - 3;
    else { taCenter }
      Left := ARect.Left + (ARect.Right - ARect.Left) shr 1
	- (ACanvas.TextWidth(Text) shr 1);
    end;
    {$ifdef win32}
    ExtTextOut(ACanvas.Handle, Left, ARect.Top + DY, ETO_OPAQUE or
       ETO_CLIPPED, @ARect, PChar(Text), Length(Text), nil)
    {$else}
    ExtTextOut(ACanvas.Handle, Left, ARect.Top + DY, ETO_OPAQUE or
       ETO_CLIPPED, @ARect, StrPCopy(S, Text), Length(Text), nil)
    {$endif}
  end
  else begin                  { Use FillRect and Drawtext for dithered colors }
    with DrawBitmap, ARect do { Use offscreen bitmap to eliminate flicker and }
    begin                     { brush origin tics in painting / scrolling.    }
      Width := Max(Width, Right - Left);
      Height := Max(Height, Bottom - Top);
      if Alignment=taRightJustify then
         R := Rect(DX, DY, Right - Left-3, Bottom - Top - 1)
      else
         R := Rect(DX, DY, Right - Left, Bottom - Top - 1);
      B := Rect(0, 0, Right - Left, Bottom - Top);
    end;
    with DrawBitmap.Canvas do
    begin
      Font := ACanvas.Font;
      Font.Color := ACanvas.Font.Color;
      Brush := ACanvas.Brush;
      Brush.Style := bsSolid;
      FillRect(B);
      SetBkMode(Handle, TRANSPARENT);
      {$ifdef win32}
      DrawText(Handle, PChar(Text), Length(Text), R, AlignFlags[Alignment]);
      {$else}
      DrawText(Handle, StrPCopy(S, Text), Length(Text), R, AlignFlags[Alignment]);
      {$endif}
    end;
    ACanvas.CopyRect(ARect, DrawBitmap.Canvas, B);
  end;
end;

Procedure wwWriteTextLines(ACanvas: TCanvas;
    const ARect: TRect; DX, DY: Integer; S: PChar; Alignment: TAlignment);
var StartPos, LineStartPos, LastStartPos: Longint;
    TextLen: Longint;
    Spaces: String;
    TabCharsInWord: boolean;
    NextWord: string;
    TextStringWidth, TextStringHeight: Longint;
    LastCurrentLine, CurrentLineStr: string;
    LineWordCount, LineCount, CurPos: integer;
    TempRect: TRect;
    RemoveLeadingSpaces: Boolean;
begin
  TextLen:= strlen(s);
  StartPos:= 0;
  CurrentLineStr:= '';
  LineStartPos:= 0;
  LineCount:= 0;
  TempRect:= ARect;
  RemoveLeadingSpaces:= False;
  LineWordCount:= 0;
  TextStringHeight:= 0; {Make compiler happy}
  if dx<0 then dx:= 0;  { 2/14/97 - Don't allow negative number here}

  while True do begin
     LastStartPos:= StartPos;
     NextWord:= GetNextWord(s, StartPos, TextLen, Spaces, TabCharsInWord);
     LastCurrentLine:= CurrentLineStr;
     if NextWord<>'' then begin
	inc(LineWordCount);
{        CurrentLineStr:= Copy(StrPas(s), LineStartPos+1, (StartPos - LineStartPos) );}
	CurrentLineStr:= Copy(StrPas(s), LineStartPos+1, LastStartPos + length(NextWord) - LineStartPos);
	if RemoveLeadingSpaces then begin
	   curpos:= 1;
	   while (curPos<=length(CurrentLineStr)) and
		 (CurrentLineStr[curPos] in [#9,#32]) do inc(curPos);
	   if curPos>0 then Delete(CurrentLineStr, 1, curPos-1);
	end;
     end;

     {********************************}
     {*** Start - Wordwrap fix 8/22/96}
     {********************************}
     if (length(CurrentLineStr)>0) and
	(CurrentLineStr[length(CurrentLineStr)] in [#10,#13]) then
	TextStringWidth:= ACanvas.TextWidth(copy(CurrentLineStr, 1, length(CurrentLineStr)-1))
     else
	TextStringWidth:= ACanvas.TextWidth(CurrentLineStr);

     { Reset back to previous word }
     if (TextStringWidth > (ARect.Right - ARect.Left)-DX) then  { 2/14/97 - Don't use DX*2 }
     begin
	{ Reset back to previous word }
	if (LastCurrentLine<>'') then StartPos:= LastStartPos;
	{ Just one word and overflow so write word }
	if LineWordCount<=1 then
	   LastCurrentLine:= CurrentLineStr;
     end
     else
     begin
	{ Terminated by carriage return, so prepare LastCurrentLine to be written }
	if ((length(CurrentLineStr)>0) and
	 (CurrentLineStr[length(CurrentLineStr)] in [#10,#13])) then
	   LastCurrentLine:= CurrentLineStr;
     end;
     {******************************}
     {*** End - Wordwrap fix 8/22/96}
     {******************************}

     if (TextStringWidth > (ARect.Right - ARect.Left)-DX) or (NextWord='') or { 2/14/97 - Don't use DX*2 }
	((length(LastCurrentLine)>0) and
	 (LastCurrentLine[length(LastCurrentLine)] in [#10,#13])) then
     begin
	inc(LineCount);
	if (length(LastCurrentLine)>0) and
	   (LastCurrentLine[length(LastCurrentLine)] in [#10,#13,#9,#0]) then
	begin
	   {$ifdef win32}
	   SetLength(LastCurrentLine, length(LastCurrentLine) - 1);
	   {$else}
	   LastCurrentLine[0]:= char(length(LastCurrentLine) - 1);
	   {$endif}
	   RemoveLeadingSpaces:= False;
	end
	else RemoveLeadingSpaces:= True; { Next line remove leading spaces }

	WriteText(ACanvas, TempRect, DX, DY, LastCurrentLine, Alignment);

	if LineCount<=1 then
	   TextStringHeight:= ACanvas.TextHeight(CurrentLineStr);

	TempRect.Top:= TempRect.Top + TextStringHeight + DY;
	if TempRect.Top>=TempRect.Bottom then break;
	DY:= 0;
	CurrentLineStr:= '';
	LineWordCount:= 0;
	LineStartPos:= StartPos;
     end;

     if NextWord='' then break;
  end;
end;

constructor TwwCustomDBGrid.Create(AOwner: TComponent);
var
  Bmp: TBitmap;
begin

  inherited Create(AOwner);
  inherited DefaultDrawing := False;
  FAcquireFocus := True;
  Bmp := TBitmap.Create;
  try
    Bmp.Handle := LoadBitmap(HInstance, bmArrow);
    if BrowseIndicatorBitmap=Nil then begin
       BrowseIndicatorBitmap:= TBitmap.create;
       BrowseIndicatorBitmap.assign(Bmp);
    end;
    Bmp.Handle := LoadBitmap(HInstance, bmEdit);
    if EditIndicatorBitmap=Nil then begin
       EditIndicatorBitmap:=TBitmap.create;
       editIndicatorBitmap.assign(Bmp);
    end;
    Bmp.Handle := LoadBitmap(HInstance, bmInsert);
    if InsertIndicatorBitmap=Nil then begin
       InsertIndicatorBitmap:= TBitmap.create;
       InsertIndicatorBitmap.assign(Bmp);
    end;

    FIndicatorColor := icBlack;
  finally
    Bmp.Free;
  end;
  FTitleOffset := 1;
  FIndicatorOffset := 1;
  FUpdateFields := True;
  FOptions := [dgEditing, dgTitles, dgIndicator, dgColumnResize,
    dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit,
    dgWordWrap];
  FKeyOptions:= [dgAllowInsert, dgAllowDelete];
  UsesBitmap;
  ScrollBars := ssHorizontal;
  inherited Options := [goFixedHorzLine, goFixedVertLine, goHorzLine,
    goVertLine, goColSizing, goColMoving, goTabs, goEditing];
  inherited RowCount := 2;
  inherited ColCount := 2;
  FDataLink := TwwGridDataLink.Create(Self);
  Color := clWindow;
  ParentColor := False;
  FTitleFont := TFont.Create;
  FTitleFont.OnChange := TitleFontChanged;
  FTitleColor := clBtnFace;
  FSaveCellExtents := False;
  FUserChange := True;
  FDefaultDrawing := True;
  HideEditor;

  FTitleAlignment:= taLeftJustify;
  FRowHeightPercent:= 100;

  FTitleLines:= 1;
  ShowVertScrollBar:= True;

  InUpdateRowCount:= False;
  TitleClickColumn:= -1;

  FSelected:= TStringList.create;
  UseTFields:= True;
  FIndicatorWidth:= 11;

end;

destructor TwwCustomDBGrid.Destroy;
begin
  FIndicatorButton.Free;

  FSelected.Free;
  FSelected := Nil;

  FDataLink.Free;
  FDataLink := nil;
  FTitleFont.Free;
  FTitleFont:= Nil;

  inherited Destroy;
  ReleaseBitmap;
end;

procedure TwwCustomDBGrid.DefineFieldMap;
var
  I: Integer;
  APos: integer;
  FldName: string;
begin

  if FDataLink.DataSet=nil then exit;

  with FDatalink.Dataset do begin
    if useTFields then begin
       for I := 0 to FieldCount - 1 do
       begin
         with Fields[I] do if Visible then FDatalink.AddMapping(Fieldname);
       end
    end
    else begin
       i:= 0;
       while i<=Selected.count-1 do
       begin
          APos:= 1;
          FldName:= strGetToken(selected[i], #9, APos);
          if FDataLink.Active and (FindField(FldName)=Nil) then
          begin
             Selected.delete(i);
             continue;
          end
          else begin
             FDatalink.AddMapping(FldName);
          end;
          inc(i);
       end
    end
  end

end;

procedure TwwCustomDBGrid.DrawDataCell(const Rect: TRect; Field: TField;
  State: TGridDrawState);
begin
  if Assigned(FOnDrawDataCell) then FOnDrawDataCell(Self, Rect, Field, State);
end;

procedure TwwCustomDBGrid.SetColumnAttributes;
var
  I: Integer;
  CWidth: Integer;
  parts: TStrings;
  tempField: TField;
  tempCount: integer;

  Function GetTitleWidth(lbl: string): integer;
  var APos, currentTitleWidth, lineWidth: integer;
      line: string;
  begin
     APos:= 1;
     lineWidth:= 0;
     while True do begin
	line:= strGetToken(lbl, '~', APos);
	if (line='') and ((APos<=0) or (APos>=length(line))) then break;
	currentTitleWidth:= Canvas.TextWidth(line);
	if currentTitleWidth>LineWidth then lineWidth:= currentTitleWidth;
     end;
     result:= lineWidth + 4;
  end;

  Function GetDisplayWidth(index: integer): integer;
  begin
     if useTFields then
        result:= Fields[i].DisplayWidth * Canvas.TextWidth('0') + 4
     else result:= strtoint(parts[1]) * Canvas.TextWidth('0') + 4;
  end;

  Function GetDisplayLabel(index: integer): string;
  begin
     if useTFields then result:= Fields[i].DisplayLabel
{     else result:= parts[2]}
     else result:= tempField.DisplayLabel;
  end;

begin
   if datasource=nil then exit;
   if datasource.dataset=nil then exit; {3/15/97}


   if useTFields then TempCount:= FieldCount
   else begin
      TempCount:= selected.Count;
      parts := TStringList.create;
   end;

   for I := 0 to TempCount - 1 do
   begin
       if useTFields then
         tempField:= Fields[i]
       else begin
         strBreakApart(selected[i], #9, parts);
         tempField:= DataSource.DataSet.FindField(parts[0]);
         if tempField=nil then continue;
       end;
       Canvas.Font := Font;
       CWidth := GetDisplayWidth(i);

       if dgTitles in Options then
       begin
           Canvas.Font := TitleFont;
           if CWidth < GetTitleWidth(GetDisplayLabel(i)) then
              CWidth:= GetTitleWidth(GetDisplaylabel(i));
       end;
       ColWidths[I + FIndicatorOffset] := CWidth;
       TabStops[I + FIndicatorOffset] := (not TempField.ReadOnly);
       if TabStops[I + FIndicatorOffset] and (not EditCalculated) then
          TabStops[I + FIndicatorOffset] := (not TempField.Calculated);
   end;

   if not useTFields then parts.Free;

{   else begin
      parts := TStringList.create;
      for i:= 0 to selected.count-1 do begin
         strBreakApart(selected[i], #9, parts);
         tempField:= DataSource.DataSet.FindField(parts[0]);
         if tempField<>Nil then begin
            Canvas.Font := Font;
            CWidth := strtoint(parts[1]) * Canvas.TextWidth('0') + 4;
            if dgTitles in Options then
            begin
               Canvas.Font := TitleFont;
               if CWidth < GetTitleWidth(parts[2]) then
                  CWidth:= GetTitleWidth(parts[2]);
            end;
            ColWidths[I + FIndicatorOffset] := CWidth;
            TabStops[I + FIndicatorOffset] := not ReadOnly and not TempField.Calculated;
         end
      end
   end;
   parts.Free;
   end
}
end;

procedure TwwCustomDBGrid.CalcRowHeight;
begin
   Canvas.Font := Font;
   DefaultRowHeight:= Canvas.Textheight('W') + NormalPad;
   if dgRowLines in Options then DefaultRowHeight:= DefaultRowHeight + 1;

   DefaultRowHeight:= (DefaultRowHeight * RowHeightPercent) div 100;

   if dgTitles in Options then
   begin
      Canvas.Font := TitleFont;
      RowHeights[0] := Canvas.TextHeight('W') * TitleLines + 4;

      {$ifndef win32}
      rowHeights[0]:= RowHeights[0] + 1;
      {$endif}

      { Increase by 1 in order to show 3D effects }
      if (not (dgRowLines in Options)) {and Ctl3D} then
	 rowHeights[0]:= RowHeights[0] + 1;

   end;

   if (dgIndicator in Options) and (FIndicatorButton<>Nil) then
   begin
      TitleTextOffset:= 2 +
         (max(RowHeights[0], FIndicatorButton.height) - rowHeights[0]) div 2;
      {$ifdef win32}
      if (dgRowLines in Options)then
         RowHeights[0]:= max(RowHeights[0], FIndicatorButton.height)-1  {5/09/97 Removed -1}
      else RowHeights[0]:= max(RowHeights[0], FIndicatorButton.height)+1;  {5/09/97 Removed -1}
      {$else}
      RowHeights[0]:= max(RowHeights[0], FIndicatorButton.height)-2;
      {$endif}
   end
   else TitleTextOffset:= 2;

end;

procedure TwwCustomDBGrid.SetIndicatorWidth(val: integer);
begin
   if FIndicatorWidth<>val then
   begin
      FIndicatorWidth:= val;
   end
end;

procedure TwwCustomDBGrid.LayoutChanged;
var
  J: Integer;
  PrevVisibleRowCount: integer;
begin
  if csLoading in ComponentState then Exit;
  if not HandleAllocated then Exit;
  if FUpdateLock <> 0 then Exit;
  Inc(FUpdateLock);
  try
    FUpdatingColWidths := True;
    try
      FTitleOffset := 0;
      if dgTitles in Options then FTitleOffset := 1;

      calcRowHeight;

      FIndicatorOffset := 0;
      if dgIndicator in Options then FIndicatorOffset := 1;

      FDatalink.ClearMapping;
      if FDatalink.Active then DefineFieldMap;
      if not useTFields and (FieldCount=0) then j:= Selected.Count
      else J := FieldCount;
      if J = 0 then J := 1;
      inherited ColCount := J + FIndicatorOffset;
      if dgIndicator in Options then ColWidths[0] := IndicatorWidth;
      if (dgIndicator in Options) and (Col=0) then Col:= 1; {5/31/95 - Avoid }

      UpdateRowCount;

      PrevVisibleRowCount:= VisibleRowCount;
      SetColumnAttributes;
      if VisibleRowCount<>PrevVisibleRowCount then UpdateRowCount;  {6/1/95}
    finally
      FUpdatingColWidths := False;
    end;
    UpdateActive;

    if AllowPerfectFit then DoPerfectFit;
    Invalidate;

  finally
    Dec(FUpdateLock);
  end;
end;

procedure TwwCustomDBGrid.LinkActive(Value: Boolean);
begin
  if not Value then HideEditor;
  LayoutChanged;
  UpdateScrollBar;
end;

procedure TwwCustomDBGrid.CreateWnd;
begin
  inherited CreateWnd;
  LayoutChanged;
  UpdateScrollBar;
end;

function TwwCustomDBGrid.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TwwCustomDBGrid.CanEditAcceptKey(Key: Char): Boolean;
begin
  Result := FDatalink.Active and (FieldCount > 0) and
    Fields[SelectedIndex].IsValidChar(Key);
end;

function TwwCustomDBGrid.GetEditLimit: Integer;
begin
  Result := 0;
  if (FieldCount > 0) and (SelectedField is TStringField) then
    Result := TStringField(SelectedField).Size;
end;

function TwwCustomDBGrid.CanEditModify: Boolean;
begin
  Result := False;
  if not ReadOnly and FDatalink.Active and not FDatalink.Readonly and
    (FieldCount > 0) and
    (Fields[SelectedIndex].CanModify or
    (FEditCalculated and wwisNonPhysicalField(Fields[SelectedIndex]) {5/9/97}
     and not Fields[SelectedIndex].ReadOnly)) then
  begin
    FDatalink.Edit;
    Result := FDatalink.Editing;
    if Result then FDatalink.Modified;
  end;
end;

function TwwCustomDBGrid.GetEditMask(ACol, ARow: Longint): string;
begin
  Result := '';
  if FDatalink.Active and (ACol - FIndicatorOffset < FieldCount) then
    Result := Fields[ACol - FIndicatorOffset].EditMask;
end;

function TwwCustomDBGrid.GetEditText(ACol, ARow: Longint): string;
begin
  Result := '';
  if FDatalink.Active and (ACol - FIndicatorOffset < FieldCount) then
    Result := Fields[ACol - FIndicatorOffset].Text;
  FEditText := Result;
end;

procedure TwwCustomDBGrid.SetEditText(ACol, ARow: Longint; const Value: string);
begin
  FEditText := Value;
end;

function TwwCustomDBGrid.GetFieldCount: Integer;
begin
  Result := FDatalink.FieldCount;
{  if Result=0 then
   result:= Selected.count}
end;

function TwwCustomDBGrid.GetFields(Index: Integer): TField;
begin
  Result := FDatalink.Fields[Index];
end;

procedure TwwCustomDBGrid.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  LinkActive(FDataLink.Active);
end;

function TwwCustomDBGrid.GetSelectedField: TField;
begin
  Result := nil;
  if SelectedIndex < FieldCount then Result := Fields[SelectedIndex];
end;

function TwwCustomDBGrid.GetSelectedIndex: Integer;
begin
  Result := Col - FIndicatorOffset;
end;

procedure TwwCustomDBGrid.SetSelectedField(Value: TField);
var
  I: Integer;
begin
  for I := 0 to FieldCount - 1 do
    if Fields[I] = Value then SelectedIndex := I;
end;

procedure TwwCustomDBGrid.SetSelectedIndex(Value: Integer);
begin
  MoveCol(Value);
end;

procedure TwwCustomDBGrid.DataChanged;
begin
  if not HandleAllocated then Exit;
  if SkipDataChange then exit;

  { 2/12/97 - This line used to be after the call to InvalidateEditor }
  { By putting it before UpdateRowCount then screen painting is more optimized }
  if (not SkipHideControls) and (DataSource.state=dsBrowse) then HideControls;
  UpdateRowCount;
  UpdateScrollBar;
  UpdateActive;
  InvalidateEditor;

  { Fix - (8/25/96) Required when canceling insert with navigator }
{  if (not SkipHideControls) and (DataSource.state=dsBrowse) then HideControls;}

  ValidateRect(Handle, nil);
  Invalidate;
end;

procedure TwwCustomDBGrid.EditingChanged;
begin
  if dgIndicator in Options then InvalidateCell(0, FSelRow);
end;

procedure TwwCustomDBGrid.RecordChanged(Field: TField);
var
  R: TRect;
  InvBegin, InvEnd: Integer;
begin
  if not HandleAllocated then Exit;
  InvBegin := 0;
  if Field = nil then InvEnd := ColCount - 1 else
  begin
    for InvBegin := 0 to FieldCount - 1 do
      if Fields[InvBegin] = Field then Break;
    InvEnd := InvBegin;
  end;
  R := BoxRect(InvBegin + FIndicatorOffset, Row, InvEnd + FIndicatorOffset,
    Row);
  InvalidateRect(Handle, @R, False);
  if ((Field = nil) or (SelectedField = Field)) and
    (SelectedIndex<FieldCount) and  { 6/17/97}
    (Fields[SelectedIndex].Text <> FEditText) then
  begin
    InvalidateEditor;
    if InplaceEditor <> nil then InplaceEditor.Deselect;
  end;
end;

function TwwCustomDBGrid.Edit: Boolean;
begin
  Result := False;
  if not ReadOnly then
  begin
    FDataChanged := False;
    FEditRequest := True;
    try
      FDataLink.Edit;
    finally
      FEditRequest := False;
    end;
    Result := FDataChanged;
  end;
end;

procedure TwwCustomDBGrid.Scroll(Distance: Integer);
var
  OldRect, NewRect: TRect;
  RowHeight: Integer;
begin
  if not HandleAllocated then Exit;  { 6/2/97}
  
  OldRect := BoxRect(0, Row, ColCount - 1, Row);
  UpdateScrollBar;
  UpdateActive;
  NewRect := BoxRect(0, Row, ColCount - 1, Row);
  ValidateRect(Handle, @OldRect);
  InvalidateRect(Handle, @OldRect, False);
  InvalidateRect(Handle, @NewRect, False);

  {$ifdef win32}
  HideEditor;  { 10/20/96 - Always hide editor if this method is called }
  {$endif}

  if Distance <> 0 then
  begin
    {$ifndef win32}
    HideEditor;
    {$endif}

    HideControls;
    try
      if Abs(Distance) > VisibleRowCount then
      begin
	{ Update bookmarks }
	Invalidate;
	Exit;
      end
      else
      begin
	RowHeight := DefaultRowHeight;
	if dgRowLines in Options then Inc(RowHeight);
	NewRect := BoxRect(FIndicatorOffset, FTitleOffset, ColCount - 1, 1000);
	ScrollWindow(Handle, 0, -RowHeight * Distance, @NewRect, @NewRect);
	if dgIndicator in Options then
	begin
	  OldRect := BoxRect(0, FSelRow, ColCount - 1, FSelRow);
	  InvalidateRect(Handle, @OldRect, False);
	  NewRect := BoxRect(0, Row, ColCount - 1, Row);
	  InvalidateRect(Handle, @NewRect, False);
	end;
      end;
    finally {1/2/96 - Don't show editor for memo}
      if (dgAlwaysShowEditor in Options) and (not isWWControl(col, row)) and
	 (not isMemoField(Col, Row)) then
	 ShowEditor;
    end;
  end;
  if (not SuppressShowEditor) and visible then Update;
  if (Distance<>0) then DoTopRowChanged;
end;

procedure TwwCustomDBGrid.DoTopRowChanged;
begin
   if Assigned(FOnTopRowChanged) then FOnTopRowChanged(self);
end;

procedure TwwCustomDBGrid.TitleFontChanged(Sender: TObject);
begin
  if (not FSelfChangingTitleFont) and not (csLoading in ComponentState) then
    ParentFont := False;
  if dgTitles in Options then LayoutChanged;
end;

procedure TwwCustomDBGrid.UpdateData;
begin
  if FieldCount > 0 then with Fields[SelectedIndex] do Text := FEditText;
end;

procedure TwwCustomDBGrid.UpdateActive;
var
  NewRow: Integer;
begin
  if FDatalink.Active then
  begin
    NewRow := FDatalink.ActiveRecord + FTitleOffset;
    if Row <> NewRow then
    begin
      if not (dgAlwaysShowEditor in Options) then HideEditor;
      if NewRow>VisibleRowCount then
      begin
	 UpdateRowCount; { Avoid index out of range }
	 NewRow:= VisibleRowCount + FTitleOffset - 1;  { 12/7/96 - Subtract 1 }
      end;
      {$ifdef win32}
      MoveColRow(Col, NewRow, False, False);
      {$else}
      Row := NewRow;
      {$endif}
    end;
    if (SelectedIndex>=0) and
       (FieldCount > 0) and (Fields[SelectedIndex].Text <> FEditText) then
      InvalidateEditor;
  end;
end;

function TwwCustomDBGrid.GetColField(ACol: Integer): TField;
begin
  Result := nil;
  if (ACol >= 0) and FDatalink.Active and (ACol < FDataLink.FieldCount) then
    Result := FDatalink.Fields[ACol];
end;

function TwwCustomDBGrid.GetFieldValue(ACol: Integer): string;
var
  Field: TField;
begin
  Result := '';
  Field := GetColField(ACol);
  if Field <> nil then Result := Field.DisplayText;
end;

procedure TwwCustomDBGrid.UpdateScrollBar;
var
  Pos: Integer;
  recNum, recCount: longint;
  sequencable: boolean;
begin
  if not FShowVertScrollBar then exit;

  if FDatalink.Active and HandleAllocated then
  begin

    { Set scroll bar precisely }
    recNum:= 0; { Make compiler happy}
    recCount:= 0;  { Make compiler happy}

    {$ifdef ver100}
    sequencable:= FDataLink.DataSet.isSequenced;
    if sequencable then begin
       FDataLink.DataSet.UpdateCursorPos;
       recCount:= FDataLink.DataSet.RecordCount;
       recNum:= FDataLink.DataSet.RecNo;
    end;
    {$else}
    sequencable:= (FDataLink.DataSet is TwwTable)  and (FDataLink.DataSet as TwwTable).isSequencable;
    if sequencable then with FDataLink.DataSet do begin
       UpdateCursorPos;
       if dbiGetRecordCount(Handle, recCount)<>0 then sequencable:= False;
       if dbiGetSeqNo(Handle, recNum)<>0 then sequencable:= False;
    end;
    {$endif}
    if sequencable then with FDataLink.DataSet do
    begin
       if recCount<2 then recCount:= 2;
       SetScrollRange(Self.Handle, SB_VERT, 0, GridScrollSize, False);
       if BOF then Pos := 0
       else if EOF then Pos := GridScrollSize
       else Pos:= ((recNum-1) * GridScrollSize) div (recCount-1);
       if GetScrollPos(Self.Handle, SB_VERT) <> Pos then
       SetScrollPos(Self.Handle, SB_VERT, Pos, True);
       exit;
    end;

    with FDatalink.DataSet do
    begin
      SetScrollRange(Self.Handle, SB_VERT, 0, 4, False);
      if BOF then Pos := 0
      else if EOF then Pos := 4
      else Pos := 2;
      if GetScrollPos(Self.Handle, SB_VERT) <> Pos then
	SetScrollPos(Self.Handle, SB_VERT, Pos, True);

    end
  end
end;

procedure TwwCustomDBGrid.UpdateRowCount;
begin
  if InUpdateRowCount then exit;  { Prevent recursion }
  InUpdateRowCount:= True;

  if RowCount <= FTitleOffset then RowCount := FTitleOffset + 1;
  FixedRows := FTitleOffset;
  with FDataLink do
    if not Active or (RecordCount = 0) then
      RowCount := 1 + FTitleOffset
    else
    begin
      RowCount := 1000;

      {6/23/97 - Toprow has changed so repaint grid }
      if (FDataLink.Buffercount>VisibleRowCount) and (row>=VisibleRowCount+FTitleOffset) then
      begin
         invalidate;
         DoTopRowChanged;
      end;

      FDataLink.BufferCount := VisibleRowCount;
      RowCount := RecordCount + FTitleOffset;
      UpdateActive;
    end;

  InUpdateRowCount:= False;
end;

function TwwCustomDBGrid.AcquireFocus: Boolean;
begin
  Result := True;
  if FAcquireFocus and CanFocus and not (csDesigning in ComponentState) then
  begin
    SetFocus;
    Result := Focused or (InplaceEditor <> nil) and InplaceEditor.Focused;
  end;
end;

procedure TwwCustomDBGrid.CMParentFontChanged(var Message: TMessage);
begin
  inherited;
  if ParentFont then
  begin
    FSelfChangingTitleFont := True;
    try
      TitleFont := Font;
    finally
      FSelfChangingTitleFont := False;
    end;
    LayoutChanged;
  end;
end;

Function TwwCustomDBGrid.AllowCancelOnExit: boolean;
begin
   result:= True;
end;

procedure TwwCustomDBGrid.CMExit(var Message: TMessage);
begin
  try
    if FDatalink.Active then
      with FDatalink.Dataset do
	if (dgCancelOnExit in Options) and (State = dsInsert) and
	  not Modified and not FDatalink.FModified and AllowCancelOnExit then
	  Cancel else
	  FDataLink.UpdateData;
  except
    SetFocus;
    raise;
  end;
  inherited;
end;

procedure TwwCustomDBGrid.CMFontChanged(var Message: TMessage);
begin
  inherited;
  LayoutChanged;
end;

procedure TwwCustomDBGrid.CMDesignHitTest(var Msg: TCMDesignHitTest);
begin
  inherited;
  if Msg.Result = 0 then
    with MouseCoord(Msg.Pos.X, Msg.Pos.Y) do
      if (X >= FIndicatorOffset) and (Y < FTitleOffset) then Msg.Result := 1;
  if (Msg.Result = 1) and ((FDataLink = nil) or FDataLink.DefaultFields or
    not FDataLink.Active) then
    Msg.Result := 0;
end;

procedure TwwCustomDBGrid.WMSetCursor(var Msg: TWMSetCursor);
begin
  if (csDesigning in ComponentState) and ((FDataLink = nil) or
    not FDataLink.Active) then
    WinProcs.SetCursor(LoadCursor(0, IDC_ARROW))
  else inherited;
end;

procedure TwwCustomDBGrid.WMSize(var Message: TWMSize);
begin
  inherited;
  if FUpdateLock = 0 then
  begin
     HideControls;   {10/9/96 - in case of resize}
     HideEditor;     {10/9/96 - in case of resize }
     UpdateRowCount;
     if AllowPerfectFit then DoPerfectFit;
  end
end;

Function TwwCustomDBGrid.IsScrollBarVisible: boolean;
  function getWidth: integer;
  var i: integer;
      CWidth: Integer;
      tempGridLineWidth: integer;
  begin
     if dgColLines in Options then tempGridLineWidth:= GridLineWidth
     else tempGridLineWidth:= 0;

     cWidth:= 1;
     if ShowVertScrollBar then cwidth:= GetSystemMetrics(SM_CXHThumb) + 1;
     for i:= 0 to ColCount-1 do
	CWidth:= CWidth + ColWidths[i] + TempGridLineWidth;
     result:= CWidth;
  end;
begin
    if (GetWidth > Width) then
    begin
       if ShowHorzScrollBar then
	  result:= True
       else result:= False;
    end
    else result:= False;
end;

Function TwwCustomDBGrid.AllowPerfectFit: boolean;
begin
   result:= False;
   if not (Align in [alTop, alBottom, alClient]) and
      (dgPerfectRowFit in Options) then
      if (csDesigning in ComponentState) and not (csLoading in ComponentState) then
	 result:= True;
end;

Function TwwCustomDBGrid.DoPerfectFit: boolean;
var newHeight: integer;
    NextToBottomCell: TRect;
    BottomCellTop: integer;
    offset: integer;
    ScrollBarVisible: boolean;
begin
   NextToBottomCell:= CellRect(0, RowCount-1);
   BottomCellTop:= NextToBottomCell.Top + DefaultRowHeight + 1;
   newHeight:= Height;
   ScrollBarVisible:=  isScrollBarVisible;
   {$ifdef win32}
   if ScrollBarVisible then offset:= 5
   else offset:= 4;
   {$else}
   if ScrollBarVisible then offset:= 3
   else offset:= 2;
   if not (dgRowLines in Options) then offset:= offset - 1;
   {$endif}
   if (ScrollBarVisible) then begin
      if ((BottomCellTop + GetSystemMetrics(SM_CYHSCROLL) + DefaultRowHeight + offset - 1)>self.height) then
      begin
	 newHeight:= BottomCellTop + GetSystemMetrics(SM_CYHSCROLL) + offset - 1;
      end
   end
   else begin
      if ((BottomCellTop + DefaultRowHeight + offset)>self.height) then
      begin
	 newHeight:= BottomCellTop + offset;
      end
   end;

   { Auto-shrink grid height}
   if (newHeight<>height) then begin
      height:= newHeight;
      result:= True;
   end
   else result:= False;
end;

procedure TwwCustomDBGrid.WMVScroll(var Message: TWMVScroll);
  procedure NextRow;
  begin
    with FDatalink.Dataset do
    begin
      if (State = dsInsert) and not Modified and not FDatalink.FModified then
	if EOF then Exit else Cancel
      else begin
	 { Already pointing to end of table but active record is before this. 10/15/96 - dsInsert should not increment}
	 if Eof and (FDataLink.ActiveRecord>=0) and  { IP2 - Used to be >0, now >=0 }
	     (FDataLink.ActiveRecord<FDataLink.RecordCount-1) and not (State=dsInsert) then
	    FDataLink.ActiveRecord:= FDataLink.ActiveRecord + 1
	 else Next;
      end;
    end;
  end;

  procedure PriorRow;
  begin
    with FDatalink.Dataset do
      if (State = dsInsert) and not Modified and EOF and
	not FDatalink.FModified then
	Cancel
      else begin
	if BOF and (FDataLink.ActiveRecord>0) then
	   FDataLink.ActiveRecord:= FDataLink.ActiveRecord - 1
	else Prior;
      end
  end;

  Function Sequencable: boolean;
  begin
    {$ifdef ver100}
    result:= FDataLink.DataSet.isSequenced;
    {$else}
     if (FDatalink.Dataset is TwwTable) then
	result:= (FDataLink.DataSet as TwwTable).isSequencable
     else result:= False;
     {$endif}
  end;


  procedure ParadoxPosition;
  var recNum : Longint;
      {$ifndef ver100}
      recCount: Longint;
      {$endif}
  begin
     {$ifdef ver100}
     with FDataLink.DataSet do begin
        recNum:= (Message.Pos * recordCount) div GridScrollSize;
        checkBrowseMode;
        RecNo:= recNum+1;
        resync([]);
     end;
     {$else}
     if (FDatalink.Dataset is TwwTable) then with FDataLink.DataSet as TwwTable do
     begin
	if isSequencable and (dbiGetRecordCount(Handle, recCount)=0) then
	begin
	   recNum:= (Message.Pos * recCount) div GridScrollSize;
	   checkBrowseMode;
	   dbiSetToSeqNo(Handle, recNum+1);
	   resync([]);
	end
     end;
     {$endif}
  end;

begin
  if not AcquireFocus then Exit;
  if FDatalink.Active then
    with Message, FDataLink.DataSet, FDatalink do
      case ScrollCode of
	SB_LINEUP: PriorRow;  {MoveBy(-ActiveRecord - 1); }
	SB_LINEDOWN: NextRow; {MoveBy(RecordCount - ActiveRecord);}
	SB_PAGEUP: MoveBy(-VisibleRowCount);
	SB_PAGEDOWN: MoveBy(VisibleRowCount);
	SB_THUMBPOSITION:
	  begin
	    if Sequencable then begin
	       if pos=0 then First
	       else if pos=GridScrollSize then Last
	       else ParadoxPosition;
	    end
	    else begin
	       case Pos of
		 0: First;
		 1: MoveBy(-VisibleRowCount);
		 2: exit;
		 3: MoveBy(VisibleRowCount);
		 4: Last;
	       end;
	    end
	  end;

	SB_BOTTOM: Last;
	SB_TOP: First;
      end;
end;

function TwwCustomDBGrid.HighlightCell(DataCol, DataRow: Integer;
  const Value: string; AState: TGridDrawState): Boolean;
begin
  Result := (gdSelected in AState) and ((dgAlwaysShowSelection in Options) or
    Focused);
  if (dgMultiSelect in Options) then
  begin
     result:= isSelectedRow(DataRow);
  end
end;

procedure TwwCustomDBGrid.DefaultDrawDataCell(const Rect: TRect; Field: TField;
  State: TGridDrawState);
const
  Formats: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT,
    DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX);
var
  Alignment: TAlignment;
  Value: string;
begin
  Alignment := taLeftJustify;
  Value := '';
  if Field <> nil then
  begin
    Alignment := Field.Alignment;
    Value := Field.DisplayText;
  end;
  WriteText(Canvas, Rect, 2, 2, Value, Alignment);
end;

  Function TwwCustomDBGrid.CellColor(ACol, ARow: integer): TColor;
  begin
     result:= Color;
  end;

  procedure TwwCustomDBGrid.Draw3DLines(ARect: TRect; ACol, ARow: integer;
	    AState: TGridDrawState);
  var ACanvas: TCanvas;
  begin
     if SkipLineDrawing then exit;

     SkipLineDrawing:= True;

     { 4/16/97 - Treat as non-3d when white background }
           { Exit if highlighted cell, and background color is same as highlight }
     if (ACol>=FIndicatorOffset) and (ARow>=FTitleOffset) and (ColorToRGB(Color)=clWhite) then
     begin
        if isWhiteBackground then exit
        else if HighlightCell(ACol, dbRow(ARow), '', AState) and
               (ColorToRGB(Canvas.Brush.Color)=ColorToRGB(clHighLight)) then exit;
     end;
     ACanvas:= Canvas;

     with ACanvas do begin
	with ARect do
	begin
	   if (Ctl3D) or (dbrow(ARow)=-1) or (dbcol(ACol)=-1) then
	   begin
	      Pen.Color := clBtnHighlight;
	      Pen.Width:= 1;
	      if dgColLines in Options then begin
		if not (dgRowLines in Options) then begin
		   PolyLine([Point(Left, Bottom), Point(Left, Top-1)]);
                   Pen.Color:= clBtnShadow;     {Changed from clGray - 5/09/97}
                   if (ACol>=FIndicatorOffset) then PolyLine([Point(Right, Bottom), Point(Right, Top-1)]);
                   Pen.Color:= clBtnHighlight;
                end
		else begin
		   if isWhiteBackground then begin
		      PolyLine([Point(Left, Bottom), Point(Left, Top)]);
		   end
		   else begin
		      if not isDrawFocusRect then
			PolyLine([Point(Left, Bottom), Point(Left, Top)]);
		      if gdFixed in AState then Pen.Color:= clBlack
		      else Pen.Color:= clBtnShadow;     {Changed from clGray - 5/09/97}
		      PolyLine([Point(Right, Bottom), Point(Right, Top)]);
		      Pen.Color:= clBtnHighlight;
		   end
		end
	      end;

              {Retest all combinations - 5/9/97 !!!!}
              if ColorToRGB(Color)=clWhite then begin
                 if (dbRow(ARow)=-1) and (not (dgRowLines in Options)) then
                 begin
                    Pen.Color:= clBlack;
		    PolyLine([Point(Left, Bottom-1), Point(Right, Bottom-1)]);
                 end
              end;

	      if (not (dgRowLines in Options)) and (dbRow(ARow)=0) and (dbCol(ACol)=-1) and
                 (FIndicatorButton<>Nil) then
              begin
		 PolyLine([Point(Left, Top-0), Point(Right, Top-0)]);
		 Pen.Color:= clBtnShadow;     {Changed from clGray - 5/09/97}
		 PolyLine([Point(Left, Top-1), Point(Right, Top-1)]);
	      end
	      else if (dgRowLines in Options) then begin
		 if isWhiteBackground then begin
		    PolyLine([Point(Left, Top), Point(Right, Top)]);
                    Pen.Color:= clBtnHighlight;
		 end
		 else begin
		    if not isDrawFocusRect then begin
		       Pen.Color:= clBtnHighlight;    {Changed from clWhite - 5/09/97}
		       PolyLine([Point(Left, Top), Point(Right, Top)]);
		    end;

		    if gdFixed in AState then Pen.Color:= clBlack
		    else Pen.Color:= clBtnShadow;     {Changed from clGray - 5/09/97}
		    if (dgRowLines in Options) then
		       PolyLine([Point(Left, Bottom), Point(Right, Bottom)]);
		 end
	      end
              { Make TopFixedRow look 3d}
              else if (dbRow(ARow)=-1) then begin
                 Pen.Color:= clBtnHighlight;
		 PolyLine([Point(Left, Top), Point(Right, Top)]);
              end
	   end
	   else begin
	   end
	end
     end;
  end;

    procedure TwwCustomDBGrid.DrawCheckBox_Checkmark(ARect: TRect; ACol, ARow:
      integer; val: boolean);
    var ACanvas : TCanvas;
    begin
       ACanvas:= Canvas; { Draw to bitmap canvas for performance }

       ACanvas.Pen.Width:= 1;
       ACanvas.Brush.Color := clWindow;

       { Draw checkbox frame }
       ACanvas.FillRect(ARect);
       ACanvas.Pen.Color:= clBlack;
       ACanvas.MoveTo(ARect.right-1, ARect.Top);
       ACanvas.LineTo(ARect.left, ARect.Top);
       ACanvas.LineTo(ARect.left, ARect.Bottom+1);

       ACanvas.Pen.Color:= clGrayText;
       ACanvas.MoveTo(ARect.left+1, ARect.Bottom);
       ACanvas.LineTo(ARect.right, ARect.Bottom);
       ACanvas.LineTo(ARect.right, ARect.Top-1);

       ACanvas.Pen.Color:= clWhite;
       ACanvas.MoveTo(ARect.left, ARect.Bottom+1);
       ACanvas.LineTo(ARect.right+1, ARect.Bottom+1);
       ACanvas.LineTo(ARect.right+1, ARect.Top-1);

       ACanvas.Pen.Color:= clGray;
       ACanvas.MoveTo(ARect.right, ARect.Top-1);
       ACanvas.LineTo(ARect.left-1, ARect.Top-1);
       ACanvas.LineTo(ARect.left-1, ARect.Bottom+1);

       if val then begin
         ACanvas.Pen.Color:= clBlack;
         { Draw TICKmark lines }
         ACanvas.Pen.Width:=1;

         ACanvas.MoveTo(ARect.Left+2,ARect.Top+8 div 2);
         ACanvas.LineTo(ARect.Left+2,ARect.Bottom-3);
         ACanvas.MoveTo(ARect.Left+3,ARect.Top+10 div 2);
         ACanvas.LineTo(ARect.Left+3,ARect.Bottom-2);
         ACanvas.MoveTo(ARect.Left+4,ARect.Top+12 div 2);
         ACanvas.LineTo(ARect.Left+4,ARect.Bottom-1);
         ACanvas.MoveTo(ARect.Left+5,ARect.Top+10 div 2);
         ACanvas.LineTo(ARect.Left+5,ARect.Bottom-2);
         ACanvas.MoveTo(ARect.Left+6,ARect.Top+8 div 2);
         ACanvas.LineTo(ARect.Left+6,ARect.Bottom-3);
         ACanvas.MoveTo(ARect.Left+7,ARect.Top+6 div 2);
         ACanvas.LineTo(ARect.Left+7,ARect.Bottom-4);
         ACanvas.MoveTo(ARect.Left+8,ARect.Top+4 div 2);
         ACanvas.LineTo(ARect.Left+8,ARect.Bottom-5);
      end;
{       if val then begin
         ACanvas.Pen.Color:= clBlack;
         ACanvas.Pen.Width:=1;
         ACanvas.MoveTo(ARect.Left+2,ARect.Top+13 div 2+1);
         ACanvas.LineTo(ARect.Left+2,ARect.Bottom-1);
         ACanvas.MoveTo(ARect.Left+3,ARect.Top+13 div 2);
         ACanvas.LineTo(ARect.Left+3,ARect.Bottom-2);
         ACanvas.MoveTo(ARect.Left+2,ARect.Bottom-1);
         ACanvas.LineTo(ARect.Right-2,ARect.Top+3);
         ACanvas.MoveTo(ARect.Left+3,ARect.Bottom-1);
         ACanvas.LineTo(ARect.Right-1,ARect.Top+3);
      end;}
  end;

  procedure TwwCustomDBGrid.DrawCheckBox(ARect: TRect; ACol, ARow: integer; val: boolean);
  var ACanvas : TCanvas;
  begin
      if (wwInternational.CheckBoxInGridStyle=cbStyleCheckmark) or
         (NewStyleControls and (wwInternational.CheckBoxInGridStyle=cbStyleAuto)) then
      begin
         DrawCheckBox_Checkmark(ARect, ACol, ARow, val);
         exit;
      end;

      ACanvas:= DrawBitmap.Canvas; { Draw to bitmap canvas for performance }

      with DrawBitmap do
      begin
	Width := self.width;
	Height := self.height;
      end;

      ACanvas.Pen.Width:= 1;
      ACanvas.Brush.Color := clWindow;

      { Draw checkbox frame }
      ACanvas.FillRect(ARect);
      ACanvas.Pen.Color:= clBlack;
      ACanvas.MoveTo(ARect.right-1, ARect.Top);
      ACanvas.LineTo(ARect.left, ARect.Top);
      ACanvas.LineTo(ARect.left, ARect.Bottom+1);

      ACanvas.Pen.Color:= clGrayText;
      ACanvas.MoveTo(ARect.left+1, ARect.Bottom);
      ACanvas.LineTo(ARect.right, ARect.Bottom);
      ACanvas.LineTo(ARect.right, ARect.Top-1);

      ACanvas.Pen.Color:= clWhite;
      ACanvas.MoveTo(ARect.left, ARect.Bottom+1);
      ACanvas.LineTo(ARect.right+1, ARect.Bottom+1);
      ACanvas.LineTo(ARect.right+1, ARect.Top-1);

      ACanvas.Pen.Color:= clGray;
      ACanvas.MoveTo(ARect.right, ARect.Top-1);
      ACanvas.LineTo(ARect.left-1, ARect.Top-1);
      ACanvas.LineTo(ARect.left-1, ARect.Bottom+1);

      if val then begin
	 ACanvas.Pen.Color:= clBlack;

	{ Draw checkbox lines }
	 ACanvas.MoveTo(ARect.right-2, ARect.Top+2);
	 ACanvas.LineTo(ARect.left+1, ARect.Bottom-1);
	 ACanvas.MoveTo(ARect.right-3, ARect.Top+2);
	 ACanvas.LineTo(Arect.left+1, ARect.Bottom-2);
	 ACanvas.MoveTo(ARect.right-2, ARect.Top+3);
	 ACanvas.LineTo(ARect.left+2, ARect.Bottom-1);

	 ACanvas.MoveTo(ARect.left+2, ARect.Top+2);
	 ACanvas.LineTo(ARect.right-1, ARect.Bottom-1);
	 ACanvas.MoveTo(ARect.left+3, ARect.Top+2);
	 ACanvas.LineTo(ARect.right-1, ARect.Bottom-2);
	 ACanvas.MoveTo(ARect.left+2, ARect.Top+3);
	 ACanvas.LineTo(ARect.right-2, ARect.Bottom-1);
     end;

     if Canvas<>ACanvas then begin
	Canvas.CopyMode := cmSrcCopy;
	InflateRect(ARect, 1, 1);
	ARect.right:= ARect.right + 1;
	ARect.bottom:= ARect.bottom + 1;
	Canvas.CopyRect(ARect, ACanvas, ARect);
     end

  end;


Procedure TwwCustomDBGrid.DrawCell(ACol, ARow: Longint;
	 ARect: TRect; AState: TGridDrawState);
var
  OldActive: Integer;
  Alignment: TAlignment;
  Highlight: Boolean;
  Value: string;
  ATitleAlignment: TAlignment;
{  TempDisplayLabel: string;}

  procedure showHighlight(ACanvas: TCanvas; const ARect: TRect; DX, DY: Integer);
  var text: string;
      S: array[0..1] of char;
  begin
     text:= '';
     s[0]:= #0;
     with ACanvas do
       ExtTextOut(Handle, ARect.Right - TextWidth(Text) - 3, ARect.Top + DY,
	   ETO_OPAQUE or ETO_CLIPPED, @ARect, s, Length(Text), nil)
  end;

  procedure Display(const S: string; Alignment: TAlignment);
  const
    Formats: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT,
      DT_CENTER or DT_WORDBREAK or DT_EXPANDTABS or DT_NOPREFIX);
  var
    APos: integer;
    line: string;
    tempRect: TRect;
    tempOffset: integer;
    {$ifndef win32}
    SPtr: array[0..255] of char;
    {$endif}
    ButtonOffset: integer;
    NumLines, startOffset: integer;
  begin
    if FTitleButtons and (TitleClickColumn>=0) then
       ButtonOffset:= 1
    else ButtonOffset:= 0;

    if (ARow<0) then begin
       if FTitleLines=1 then NumLines:= 1
       else NumLines:= strCount(s, '~')+1;
       startOffset:= Trunc((RowHeights[0]/2)-(0.5*NumLines *Canvas.Textheight(s)));
       {$ifNdef win32}
       inc(startOffset);
       {$endif}

       APos:= 1;
       tempRect:= ARect;
       tempOffset:= startOffset;
       if s='' then begin
          WriteText(Canvas, tempRect, 3+ButtonOffset, tempOffset+ButtonOffset, s, Alignment);
          exit;
       end;
       while True do begin
          if TitleLines>1 then line:= strGetToken(S, '~', APos)
          else line:= s;      {!!!!PW Check  APos > length(s) funny bug with ~D or ~}
          if (line='') and ((APos<=0) or (APos>=length(s))) then break;
	  WriteText(Canvas, tempRect, 3+ButtonOffset, tempOffset+ButtonOffset, Line, Alignment);
          if tempRect.Top=0 then  tempRect.Top:= startOffset + Canvas.TextHeight(s)
          else tempRect.Top:= tempRect.Top + Canvas.TextHeight(s);
	  tempOffset:= 1;
          if TitleLines=1 then break;
       end
    end
    else begin
       if not (dgWordWrap in Options) then begin
	  WriteText(Canvas, ARect, 3+ButtonOffset, (NormalPad div 2)+1+ButtonOffset, S, Alignment);
       end
       else begin
          {$ifdef win32}
	  wwWriteTextLines(Canvas, ARect, 3+ButtonOffset, (NormalPad div 2)+1+ButtonOffset, PChar(s), Alignment);
          {$else}
          StrPCopy(SPtr, S);
	  wwWriteTextLines(Canvas, ARect, 3+ButtonOffset, (NormalPad div 2)+1+ButtonOffset, SPtr, Alignment);
          {$endif}
       end;
    end
  end;


  procedure SaveToBitmap(Bitmap: TBitmap; tempField: TField);
  type
    TGraphicHeader = record
      Count: Word;                { Fixed at 1 }
      HType: Word;                { Fixed at $0100 }
      Size: Longint;              { Size not including header }
    end;

  var
     {$ifdef ver100}
     BlobStream: TStream;
     {$else}
     BlobStream: TwwMemoStream;
     {$endif}
     Size: Longint;
     Header: TGraphicHeader;
  begin
     {$ifdef ver100}
     { Support TClientDataSet by using CreateBlobStream instead }
     BlobStream:= tempField.dataset.CreateBlobStream(tempField, bmRead);
     {$else}
     BlobStream := TwwMemoStream.Create(tempField as TBlobField);
     {$endif}

     try { Use try/except instead of try/finally for efficiency}
       Size := BlobStream.Size;
       if Size >= SizeOf(TGraphicHeader) then
       begin
	 BlobStream.Read(Header, SizeOf(Header));
	 if (Header.Count <> 1) or (Header.HType <> $0100) or
	   (Header.Size <> Size - SizeOf(Header)) then
	   BlobStream.Position := 0;
       end;
       Bitmap.LoadFromStream(BlobStream);
       BlobStream.Free;
     except
       BlobStream.Free;
     end;
  end;

  procedure DrawCellColors(tempField: TField);
  begin
      with Canvas do begin
	 if gdFixed in AState then Brush.Color := TitleColor
	 else Brush.Color := Color;

	 FCalcCellRow:= ARow;
	 if dgTitles in Options then Dec(FCalcCellRow, 1);
	 FCalcCellCol:= ACol;
	 if dgIndicator in Options then Dec(FCalcCellcol, 1);

	 Highlight := HighlightCell(ACol, FCalcCellRow, Value, AState);
	 if Highlight then
	 begin
	   Brush.Color := clHighlight;
	   Font.Color := clHighlightText;
	 end;

	 DoCalcCellColors(tempField, AState, Highlight, Font, Brush); {new code}

         showHighlight(Canvas, ARect, 2, 2); {Call after brush and font are set }

	 if Highlight then begin
	   if not (csDesigning in ComponentState) and
		  (ValidParentForm(Self).ActiveControl = Self) then
	   begin
	      if not (dgRowSelect in Options) then begin
		 isDrawFocusRect:= True;
		 WinProcs.DrawFocusRect(Handle, ARect);
	      end
	   end
	 end;
      end;
  end;

  procedure DisplayBitMap(tempField: TField; Parameters: string);
  var myBitmap: TBitmap;
      SRect, DRect : TRect;
      tempBitmapField: TField; {win95}
      tempLookupValue: string;
      tempHeight, tempWidth: Longint;
      bitmapSubsetWidth, bitmapSubsetHeight: integer;
      PrevCopyMode: TCopyMode;
      bitmapSize, rasterOperation: string;
      APos: integer;
      cellWidth, cellHeight: integer;

      Function GetCopyMode(cm: string): TCopyMode;
      begin
	  Result:= cmSrcCopy;
	  if cm='Source Copy' then Result:= cmSrcCopy
	  else if cm='Source Paint' then Result:= cmSrcPaint
	  else if cm='Source And' then Result:= cmSrcAnd
	  else if cm='Source Invert' then Result:= cmSrcInvert
	  else if cm='Source Erase' then Result:= cmSrcErase
	  else if cm='Not Source Copy' then Result:= cmNotSrcCopy
	  else if cm='Not Source Erase' then Result:= cmNotSrcErase
	  else if cm='Merge Paint' then Result:= cmMergePaint
      end;

  begin
      Apos:= 1;
      BitmapSize:= strGetToken(Parameters, ';', APos);
      RasterOperation:= strGetToken(Parameters, ';', APos);
      cellWidth:= ARect.Right - ARect.Left;
      cellHeight:= ARect.Bottom - ARect.Top;

      if tempField.calculated then
      begin
	 if not wwDataSetLookupDisplayField(tempField, tempLookupValue, tempBitmapField) then
	 begin
	    DrawCellColors(tempField);   { Lookup failed }
	    exit;
	 end
      end
      else begin
	tempBitmapField:= tempField;
      end;

      myBitmap := TBitmap.Create;
      if not ((DataSource.DataSet.State = dsInsert) and
	      (dbRow(row)=DataLink.ActiveRecord)) then SaveToBitmap(myBitmap, tempBitmapField);

      if (MyBitmap.height<=0) or (MyBitmap.width<=0) then
      begin
	 DrawCellColors(tempField);
	 myBitmap.Free;
	 exit;
      end;

      SRect  := classes.Rect(0, 0, myBitmap.Width, myBitmap.Height);

      PrevCopyMode:= Canvas.CopyMode;
      Canvas.CopyMode:= GetCopyMode(rasterOperation);
      DrawCellColors(tempField);

      if BitmapSize='Original Size' then
      begin
	 tempHeight:= cellHeight;
	 tempWidth:= cellWidth;
	 SRect  := classes.Rect(0, 0, min(myBitmap.Width, tempWidth-1),
				      min(myBitmap.Height, tempHeight - 1));
	 DRect  := classes.Rect(ARect.Left+1, ARect.Top + 1,
		ARect.Left + 1 + (SRect.Right - SRect.Left),
		ARect.Top + 1 + (SRect.Bottom - SRect.Top));

	 Canvas.CopyRect(DRect, myBitmap.Canvas, SRect);
      end
      else if BitmapSize='Stretch To Fit' then
      begin
	 Canvas.StretchDraw(ARect, myBitmap);
      end
      else if BitmapSize='Fit Height' then begin
	 { Paint bitmap portion that is shown.                  }
	 { BitmapSubsetWidth is portion of bitmap that is drawn }
	 tempHeight:= cellHeight;
	 tempWidth:= (myBitmap.Width * tempHeight) div myBitmap.Height;
	 if tempWidth > CellWidth then begin
	    BitmapSubsetWidth:= (myBitmap.width * cellWidth) div tempWidth;
	    tempWidth:= cellWidth; { Limit to cell's width }
	 end
	 else BitmapSubsetWidth:= myBitmap.width;

	 if (tempWidth>2) and (tempHeight>2) then begin
	    DRect  := classes.Rect(ARect.Left+1, ARect.Top,
		ARect.Left + tempWidth,
		ARect.Top + tempHeight - 1);
	    SRect  := classes.Rect(0, 0, BitmapSubsetWidth, myBitmap.Height);
	    Canvas.CopyRect(DRect, myBitmap.Canvas, SRect);
	 end
      end
      else if BitmapSize='Fit Width' then
      begin
	 { Paint bitmap portion that is shown.                   }
	 { BitmapSubsetHeight is portion of bitmap that is drawn }
	 tempWidth:= cellWidth;
	 tempHeight:= (myBitmap.Height * tempWidth) div myBitmap.Width;
	 if tempHeight > CellHeight then begin
	    BitmapSubsetHeight:= (myBitmap.height * cellHeight) div tempHeight;
	    tempHeight:= cellHeight; { Limit to cell's height }
	 end
	 else BitmapSubsetHeight:= myBitmap.Height;

	 if (tempWidth>2) and (tempHeight>2) then begin
	    DRect  := classes.Rect(ARect.Left+1, ARect.Top ,
		     ARect.Left+ tempWidth,
		     ARect.Top + tempHeight - 1);
	    SRect  := classes.Rect(0, 0, myBitmap.Width, BitmapSubsetHeight);
	    Canvas.CopyRect(DRect, myBitmap.Canvas, SRect);
	 end
      end;

      if Highlight then begin
	 Canvas.Brush.Color := clHighlight;
	 Canvas.FrameRect(ARect);
	 SkipLineDrawing:= True;
      end;
      Canvas.CopyMode:= PrevCopyMode;

      myBitmap.Free;
  end;



  Function HandleWWControls: boolean;
  var tempField: TField;
      Rect: TRect;
      ControlType, Parameters: string;
      checkboxOn, checkBoxOff: string;
      APos: integer;
  begin
     result:= False;
     if not isValidCell(ACol, ARow) then exit;
     tempField:= GetColField(dbCol(ACol));
     if tempField=Nil then exit;

     WWDataSet_GetControl(DataSource.DataSet, tempField.FieldName, ControlType, Parameters);

     {  Bitmap support }
     if ControlType='Bitmap' then begin
       OldActive:= DataLink.ActiveRecord;
       try
	  DataLink.ActiveRecord:= dbRow(ARow);
	  DisplayBitMap(tempField, Parameters);
       finally
	  DataLink.ActiveRecord:= OldActive;
       end;

       Draw3DLines(ARect, ACol, ARow, AState);

       result:= True;
       exit;
    end
    else if ControlType='CheckBox' then begin
      APos:= 1;
      checkBoxOn:= strGetToken(Parameters, ';', APos);
      checkBoxOff:= strGetToken(Parameters, ';', APos);
      OldActive:= DataLink.ActiveRecord;
      Value:= '';
      try
	 DataLink.ActiveRecord:= dbRow(ARow);
	 if tempField.calculated and (lowercase(tempField.fieldName)='selected') then begin
	    if isSelected then value:= checkBoxOn
	    else value:= checkBoxOff;
	 end
	 else begin
	    value:= GetFieldValue(dbCol(ACol));
	 end;

	 DrawCellColors(tempField);
      finally
	 DataLink.ActiveRecord:= OldActive;
      end;

      rect.left:= (ARect.right + ARect.left - 10) div 2;
      rect.right:= rect.left + 10;
      rect.Top:= ((ARect.Top + ARect.Bottom - 10) div 2);
      rect.Bottom:= rect.Top + 10;

      DrawCheckBox(rect, ACol, ARow, wwEqualStr(value, checkBoxOn));  { 2/11/97 Case insensitive check}

      Draw3DLines(ARect, ACol, ARow, AState);
      result:= True;
      exit;
   end;


  end;

  {4/31/97 - Use extra temp bitmap due to bug in Delphi 3 BrushCopy method }
  procedure ShowIndicator;
  var tempBitmap, tempBitmap2: TBitmap;
      SRect: TRect;
  begin
     tempBitmap:= TBitmap.create;
     tempBitmap2:= TBitmap.create;
     if FDataLink.DataSet = nil then tempBitmap.assign(BrowseIndicatorBitmap)
     else begin
       case FDataLink.DataSet.State of
	  dsEdit: tempBitmap.assign(EditIndicatorBitmap);
	  dsInsert: tempBitmap.assign(InsertIndicatorBitmap);
	  else tempBitmap.assign(BrowseIndicatorBitmap);
       end;
     end;

     SRect  := classes.Rect(0, 0, tempBitmap.Width, tempBitmap.Height);

{     tempBitmap2.assign(tempBitmap);
     tempBitmap2.Canvas.Brush.Color:= Canvas.Brush.Color;
     tempBitmap2.Canvas.BrushCopy(SRect, tempBitmap, SRect, clWhite);

     if FIndicatorColor=icYellow then
	tempBitmap.Canvas.Brush.Color:= clYellow
     else tempBitmap.Canvas.Brush.Color:= clBlack;
     tempBitmap.Canvas.BrushCopy(SRect, tempBitmap2, SRect, clBlack);
}

     if FIndicatorColor=icYellow then begin
        { Substitute background color for white}
        tempBitmap2.assign(tempBitmap);
        tempBitmap2.Canvas.Brush.Color:= Canvas.Brush.Color;
        tempBitmap2.Canvas.BrushCopy(SRect, tempBitmap, SRect, clWhite);
        {Warning - Delphi 2's brushcopy may have a resource leak }

        { Substitute yellow for indicator color }
	tempBitmap.Canvas.Brush.Color:= clYellow;
        tempBitmap.Canvas.BrushCopy(SRect, tempBitmap2, SRect, clBlack);
        Canvas.CopyMode:= cmSrcCopy;
     end
     else Canvas.CopyMode:= cmSrcAnd;

     Canvas.Draw(((ARect.right-tempBitmap.Width) div 2)+1,
		(ARect.Top + ARect.Bottom - tempBitmap.Height) div 2, tempBitmap);

     tempBitmap.Free;
     tempBitmap2.Free;
     Canvas.CopyMode:= cmSrcCopy;  { Restore default }
  end;


begin
  isDrawFocusRect:= False;
  SkipLineDrawing:= False;

  if gdFixed in AState then
    Canvas.Font := TitleFont
  else
    Canvas.Font := Font;

  with Canvas do
  begin
    if gdFixed in AState then
      Brush.Color := TitleColor else
      Brush.Color := Color;

    if HandleWWControls then exit;

    if dgTitles in Options then Dec(ARow, 1);
    if dgIndicator in Options then Dec(ACol, 1);

    if ARow < 0 then begin
      ATitleAlignment:= FTitleAlignment;
      if (ACol >= 0) and (ACol < FieldCount) then begin
{        if useTFields then tempDisplayLabel:= Fields[ACol].DisplayLabel
        else begin
           if wwFindSelected(Selected, Fields[ACol].FieldName, index) then
           begin
              APos:= 1;
              strGetToken(Selected[ACol], #9, APos);
              strGetToken(Selected[ACol], #9, APos);
              tempDisplayLabel:= strGetToken(Selected[index], #9, APos);
           end;
        end;
}
	DoCalcTitleAttributes(Fields[ACol].FieldName, Font, Brush, ATitleAlignment);
        Display(Fields[ACol].DisplayLabel, ATitleAlignment);

	if FTitleButtons then
	begin
	   SkipLineDrawing:= True;
	   if TitleClickColumn<0 then begin
	      Pen.Color:= clGray;
	      with ARect do begin
		 PolyLine([Point(Left, Top), Point(Left, Bottom-1)]);
		 PolyLine([Point(Left, Bottom-1), Point(Right-1, Bottom-1)]);
		 PolyLine([Point(Right-1, Bottom-1), Point(Right-1, Top)]);
	      end;
	      Pen.Color:= clBtnHighlight;
	      with ARect do begin
		 PolyLine([Point(Left, Top), Point(Left, Bottom)]);
		 PolyLine([Point(Left+1, Top), Point(Right-1, Top)]);
	      end;
              Pen.Color:= clBtnShadow;
	      with ARect do begin
                PolyLine([Point(Left, Bottom-1), Point(Right, Bottom-1)]);
              end;
	   end
	   else begin
	      Pen.Color:= clBlack;
	      with ARect do begin
		 PolyLine([Point(Left, Top), Point(Left, Bottom)]);
		 PolyLine([Point(Left, Top), Point(Right, Top)]);
	      end;
	      Pen.Color:= clGray;
	      with ARect do begin
		 PolyLine([Point(Left+1, Top+1), Point(Left+1, Bottom-1)]);
		 PolyLine([Point(Left+1, Bottom-1), Point(Right, Bottom-1)]);
                 Pen.Color:= clBtnHighlight;
		 PolyLine([Point(Right, Bottom-1), Point(Right, Top-1)]);
	      end;
	   end
	end
      end
      else
         Display('', FTitleAlignment);
    end
    else if (DataLink = nil) or not DataLink.Active then FillRect(ARect)
    else if ACol < 0 then
    begin
      FillRect(ARect);
      if ARow = FDataLink.ActiveRecord then
      begin
	ShowIndicator;
	FSelRow := ARow + FTitleOffset;
      end;
    end
    else begin
      Value := '';
      OldActive := DataLink.ActiveRecord;
      try
	DataLink.ActiveRecord := ARow;
	FCalcCellRow:= ARow;
	FCalcCellCol:= ACol;

	Value := GetFieldValue(ACol);

	Highlight := HighlightCell(ACol, ARow, Value, AState);
	if Highlight then
	begin
	  Brush.Color := clHighlight;
	  Font.Color := clHighlightText;
	end;

	DoCalcCellColors(GetColField(ACol), AState, Highlight, Font, Brush);
	Alignment := taLeftJustify;
	if ACol < FieldCount then Alignment := Fields[ACol].Alignment;
	if DefaultDrawing then
	   Display(Value, Alignment);
	DrawDataCell(ARect, GetColField(ACol), AState);
      finally
	DataLink.ActiveRecord := OldActive;
      end;
      if DefaultDrawing and Highlight and not (csDesigning in ComponentState) and
	not (dgRowSelect in Options) and (ValidParentForm(Self).ActiveControl = Self) then
      begin
	WinProcs.DrawFocusRect(Handle, ARect);
	isDrawFocusRect:= True;
      end

    end;

{    if (gdFixed in AState) or not isWhiteBackground then
      with ARect do
      begin
	Pen.Color := clBtnHighlight;
	if dgRowLines in Options then
	  PolyLine([Point(Left, Top), Point(Right, top)]);
	if dgColLines in Options then
	  PolyLine([Point(Left, Bottom - 1), Point(Left, Top)]);
      end;
}
  end;
end;

procedure TwwCustomDBGrid.MoveCol(ACol: Integer);
var
  OldCol: Integer;
  editor: TwwInplaceEdit;
  FOnInvalidValue: TwwInvalidValueEvent;

  procedure validateError;
  begin
    MessageBeep(0);
    {$ifdef ver100}
    raise EInvalidOperation.create(Format(SMaskEditErr, ['']));
    {$else}
    raise EInvalidOperation.create(FmtLoadStr(SMaskEditErr, ['']));
    {$endif}
  end;

begin
   if (InplaceEditor <> nil) then
   begin
      editor:= TwwInplaceEdit(InplaceEditor);
      if (editor.HavePictureMask) and FDataLink.isFieldModified and
	 (not editor.IsValidPictureValue(editor.Text)) and
	    (not editor.Picture.AllowInvalidExit) then
      begin
	 editor.SelectAll;
	 editor.SetFocus;
	 FDataLink.Modified; {SetFocus clears modified so set it back to true }

         {7/3/97 - Use OnInvalidValue }
         FOnInvalidValue := wwGetOnInvalidValue(FDataLink.DataSet);
         if Assigned(FOnInvalidValue) then
         begin
            FOnInvalidValue(FDataLink.DataSet, GetColField(dbCol(Col)));
         end
         else validateError;

	 exit;
      end
   end;

  FDatalink.UpdateData;
  if ACol >= FieldCount then ACol := FieldCount - 1;
  if ACol < 0 then ACol := 0;
  if ACol < (FixedCols - FIndicatorOffset) then begin
     { Don't allow movement to a fixed column }
     ACol:= FixedCols - FIndicatorOffset;
  end;

  OldCol := Col - FIndicatorOffset;
  if ACol <> OldCol then
  begin
    if not FInColExit then
    begin
      FInColExit := True;
      try
	ColExit;
      finally
	FInColExit := False;
      end;
      if Col - FIndicatorOffset <> OldCol then Exit;
    end;

    HideEditor;
    if (not SuppressShowEditor) and
       (dgAlwaysShowEditor in Options) and not isWWControl(ACol + FIndicatorOffset, row) then
    begin
       HideControls;
       { 12/19/96 - Don't call showeditor if going to memo field}
       if not isMemoField(ACol + FIndicatorOffset, row) then ShowEditor;
    end;

    Col := ACol + FIndicatorOffset;
    ColEnter;
  end;
end;

function TwwCustomDBGrid.IsWWControl(ACol, ARow: integer): boolean;
begin
   result:= False;
end;

function TwwCustomDBGrid.CreateEditor: TInplaceEdit;
begin
  Result := TwwInplaceEdit.wwCreate(Self, 0);
end;

procedure TwwCustomDBGrid.KeyDown(var Key: Word; Shift: TShiftState);
var
  KeyDownEvent: TKeyEvent;
  editor: TwwInplaceEdit;

  procedure NextRow;
  begin
    with FDatalink.Dataset do
    begin
      if (State = dsInsert) and not Modified and not FDatalink.FModified then
	if EOF then Exit else Cancel
      else begin
	 { Already pointing to end of table but active record is before this. 10/15/96 - dsInsert should not increment}
	 if Eof and (FDataLink.ActiveRecord>=0) and  { IP2 - Used to be >0, now >=0 }
	     (FDataLink.ActiveRecord<FDataLink.RecordCount-1) and not (State=dsInsert) then
	    FDataLink.ActiveRecord:= FDataLink.ActiveRecord + 1
	 else Next;
      end;
      if EOF and CanModify and (dgEditing in Options) and (dgAllowInsert in KeyOptions) then
      begin
	HideControls;
	Append;
      end;
    end
  end;

  procedure PriorRow;
  begin
    with FDatalink.Dataset do
      if (State = dsInsert) and not Modified and EOF and
	not FDatalink.FModified then
	Cancel
      else begin
	if BOF and (FDataLink.ActiveRecord>0) then
	   FDataLink.ActiveRecord:= FDataLink.ActiveRecord - 1
	else Prior;
      end
  end;

  procedure Tab(GoForward: Boolean);
  var
    ACol, Original: Integer;
  begin
    ACol := SelectedIndex;
    Original := ACol;
    while True do
    begin

      if GoForward then
	Inc(ACol) else
	Dec(ACol);
      if ACol >= FieldCount then
      begin
	HideControls; { Necessary when all columns fit in grid's view }
	if (Original=0) and TabStops[FIndicatorOffset] then SuppressShowEditor:= True;
	NextRow;
	ACol := 0;
      end
      else if ACol < 0 then
      begin
	HideControls;
	if (FieldCount-1<>Original) and TabStops[(FieldCount-1) + FIndicatorOffset] then SuppressShowEditor:= True;
	PriorRow;
	ACol := FieldCount - 1;
      end;
      if ACol = Original then Exit;
      if TabStops[ACol + FIndicatorOffset] then
      begin
	SuppressShowEditor:= False;
	MoveCol(ACol);
	Exit;
      end;

      SuppressShowEditor:= False;
    end;
  end;

  function DeletePrompt: Boolean;
  begin
    Result := not (dgConfirmDelete in Options) or
      (MessageDlg(
         {$ifdef ver100}
         SDeleteRecordQuestion,
         {$else}
         LoadStr(SDeleteRecordQuestion),
         {$endif}
         mtConfirmation, mbOKCancel, 0) <> idCancel);
  end;

  Function ShouldShowEditor: boolean;
  var tempField: TField;
  begin
      result:= False;
      tempField:= GetColField(dbCol(Col));
      if tempField=Nil then exit;
      if (tempField is TBlobField) then exit;  { Changed to TBlobField}
      if isWWControl(Col, Row) then exit;  {10/12/96 - Don't show editor for any customEdit }

      result:= True;
  end;

begin
  KeyDownEvent := OnKeyDown;

  if Assigned(KeyDownEvent) then KeyDownEvent(Self, Key, Shift);
  if not FDatalink.Active or not CanGridAcceptKey(Key, Shift) then Exit;

  with FDatalink.DataSet do
    if ssCtrl in Shift then
      case Key of
	VK_UP, VK_PRIOR: MoveBy(-FDatalink.ActiveRecord);
	VK_DOWN, VK_NEXT: MoveBy(FDatalink.BufferCount - FDatalink.ActiveRecord - 1);
	VK_LEFT: MoveCol(0);
	VK_RIGHT: MoveCol(FieldCount - 1);
	VK_HOME: First;
	VK_END: Last;
	VK_DELETE: begin
	      if (dgAllowDelete in KeyOptions) and (not ReadOnly) and CanModify and
		 (dgEditing in Options) and DeletePrompt then
	      begin
		 Delete;
		 HideEditor; {10/3/96}
	      end;
	      Key:= 0; {10/3/96 }
	   end;
      end
    else
      case Key of
	VK_UP: PriorRow;
	VK_DOWN: NextRow;
	VK_LEFT:
	  if dgRowSelect in Options then
	    PriorRow else
	    MoveCol(SelectedIndex - 1);
	VK_RIGHT:
	  if dgRowSelect in Options then
	    NextRow else
	    MoveCol(SelectedIndex + 1);
	VK_HOME:
	  if (FieldCount = 1) or (dgRowSelect in Options) then
	    First else
	    MoveCol(0);
	VK_END:
	  if (FieldCount = 1) or (dgRowSelect in Options) then
	    Last else
	    MoveCol(FieldCount - 1);
	VK_NEXT: MoveBy(VisibleRowCount);
	VK_PRIOR: MoveBy(-VisibleRowCount);
	VK_INSERT: if not ReadOnly and
		  (dgEditing in Options) and (dgAllowInsert in KeyOptions) then Insert;
	VK_TAB: if not (ssAlt in Shift) then Tab(not (ssShift in Shift));
	VK_RETURN: if dgEnterToTab in KeyOptions then Tab(not (ssShift in Shift));
	VK_ESCAPE:
	  begin
	    FDatalink.Reset;
	    if not (dgAlwaysShowEditor in Options) then HideEditor
	    else if Assigned(FOnCheckValue) then begin
	       if (InplaceEditor <> nil) then
	       begin
		  editor:= TwwInplaceEdit(InplaceEditor);
		  editor.IsValidPictureValue(editor.Text);
	       end
	    end
	  end;
	VK_F2: if ShouldShowEditor then EditorMode := True;
      end;
end;

procedure TwwCustomDBGrid.KeyPress(var Key: Char);
begin
  if (dgEnterToTab in KeyOptions) and (ord(Key)=VK_RETURN) then Key:= #9;
  if not (dgAlwaysShowEditor in Options) and (Key = #13) then
    FDatalink.UpdateData;
  inherited KeyPress(Key);
end;

procedure TwwCustomDBGrid.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var temp: integer;
    field: TField;
    Cell: TGridCoord;
begin
   inherited MouseUp(Button, Shift, x, y);
   if TitleClickColumn>=0 then begin
      Cell := MouseCoord(X, Y);
      Temp:= TitleClickColumn;
      TitleClickColumn:= -1;
      InvalidateCell(Temp, 0);
      if (Cell.X=Temp) and (Cell.Y=TitleClickRow) and (Y>=0) then
      begin
	 field:= GetColField(dbCol(Cell.X));
	 if field<>nil then
	    DoTitleButtonClick(Field.FieldName)
      end;
      TitleClickRow:= -1;
   end
end;

procedure TwwCustomDBGrid.DoTitleButtonClick(AFieldName: string);
begin
  if Assigned(FOnTitleButtonClick) then
     FOnTitleButtonClick(Self, AFieldName)
end;

procedure TwwCustomDBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var
  Cell: TGridCoord;
  TempOnMouseDown: TMouseEvent;
  NewRow: boolean;

  Procedure CallMouseDown;
  begin
    TempOnMouseDown:= OnMouseDown;
    if Assigned(TempOnMouseDown) then begin
       update;
       TempOnMouseDown(Self, Button, Shift, X, Y);
    end
  end;

  procedure ProcessTitleClick;
  begin
    if TitleButtons and (ssLeft in Shift) and not (csDesigning in ComponentState) then
    begin
       Cell := MouseCoord(X, Y);
       if (Cell.Y < FTitleOffset) then
       begin
	  TitleClickColumn:= Cell.X;
	  TitleClickRow:= Cell.y;
	  InvalidateCell(Cell.X, 0);
       end
    end;
  end;

begin
  if not AcquireFocus then Exit;
  if (ssDouble in Shift) and (Button = mbLeft) then
  begin
    DblClick;
    Exit;
  end;
  if Sizing(X, Y) then begin
    FDataLink.UpdateData;    { 2/7/97 - Flush data to TField if modified }
    inherited MouseDown(Button, Shift, X, Y)
  end
  else begin
    Cell := MouseCoord(X, Y);
    if Cell.Y<0 then begin  {2/7/97}
       CallMouseDown;
       exit;
    end;
    if ((csDesigning in ComponentState) or (dgColumnResize in Options)) and
      (Cell.Y < FTitleOffset) then
    begin
       if (not TitleButtons) or (csDesigning in ComponentState) then
	  inherited MouseDown(Button, Shift, X, Y);
       ProcessTitleClick;
    end
    else if (not (dgColumnResize in Options)) and (Cell.Y < FTitleOffset) then
       ProcessTitleClick
    else
      if FDatalink.Active then
	with Cell do
	begin
	  if (X = Col) and (Y = Row) and not isWWControl(col, row) and
	    (not isMemoField(col, row)) then ShowEditor;  { Don't show internal editor if memo field }
	  NewRow:=(Y >= FTitleOffset) and (Y - Row <> 0);
	  if NewRow then SuppressShowEditor:= True;

	  if (dgMultiSelect in Options) then
          begin
             if not ((ssCtrl in Shift) or (ssShift in Shift)) then
                if (msoAutoUnselect in MultiSelectOptions) then
                begin
                end
          end;

{             begin
                if not NewRow then begin
		   if isSelected then UnselectRecord
                   else SelectRecord;
                end
             end
             else if (msoAutoUnselect in MultiSelectOptions) then
             begin
                UnselectAll;
             end
	  end;              }


	  if X >= inherited FixedCols then MoveCol(X - FIndicatorOffset);
	  SuppressShowEditor:= False;

	  if NewRow then FDatalink.Dataset.MoveBy(Y - Row);

	  if (dgMultiSelect in Options) and not isSelectedCheckbox(X) then
          begin
             if ((ssCtrl in Shift) or (ssShift in Shift)) then
             begin
                if isSelected then UnselectRecord
                else SelectRecord;
             end
             else begin
                if (msoAutoUnselect in MultiSelectOptions) then
                begin
                   UnselectAll;
                   SelectRecord;
                end
             end
          end;

          if (dgMultiSelect in Options) and
             ((ssShift in Shift) or (ssCtrl in Shift) or (msoAutoUnselect in MultiSelectOptions)) then
          begin
             if (msoShiftSelect in MultiSelectOptions) then
             begin
                ShiftSelectMode:= True;
                FDataLink.dataset.checkBrowseMode;
                ShiftSelectBookmark:= FDataLink.DataSet.GetBookmark;
             end
          end

	end;

    CallMouseDown;
  end;
end;

procedure TwwCustomDBGrid.ColEnter;
begin
  if Assigned(FOnColEnter) then begin
{     Update;  { Complete any pending display operation }
     FOnColEnter(Self);
  end
end;

procedure TwwCustomDBGrid.ColExit;
begin
  if Assigned(FOnColExit) then FOnColExit(Self);
end;

procedure TwwCustomDBGrid.ColumnMoved(FromIndex, ToIndex: Longint);
var temp: string;
begin
  FromIndex:= FromIndex  - FIndicatorOffset;
  ToIndex := ToIndex - FIndicatorOffset;

  if useTFields then begin
     if FDatalink.Active and (FieldCount > 0) then
       Fields[FromIndex].Index := Fields[ToIndex].Index;
  end
  else begin
     Temp:= Selected[FromIndex];
     Selected[FromIndex]:= Selected[toIndex];
     Selected[ToIndex]:= Temp;
     LayoutChanged;
  end;

  if Assigned(FOnColumnMoved) then FOnColumnMoved(Self, FromIndex, ToIndex);

end;

procedure TwwCustomDBGrid.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
      (AComponent = DataSource)  then
    DataSource := nil
  else if (Operation=opRemove) and (FIndicatorButton=AComponent) then
  begin
     FIndicatorButton:= nil;
  end

end;

procedure TwwCustomDBGrid.TimedScroll(Direction: TGridScrollDirection);
begin
  if FDatalink.Active then
  begin
    with FDatalink do
    begin
      if sdUp in Direction then
      begin
	DataSet.MoveBy(-ActiveRecord - 1);
	Exclude(Direction, sdUp);
      end;
      if sdDown in Direction then
      begin
	DataSet.MoveBy(RecordCount - ActiveRecord);
	Exclude(Direction, sdDown);
      end;
    end;
    if Direction <> [] then inherited TimedScroll(Direction);
  end;
end;

procedure TwwCustomDBGrid.ColWidthsChanged;
var
  I: Integer;
  CWidth: Integer;
  ParentForm: TCustomForm;
  tempSelected, Parts: TStrings;
begin
  inherited ColWidthsChanged;
  if not FUpdatingColWidths and FUpdateFields and FDatalink.Active and
    HandleAllocated then
  begin
    Inc(FUpdateLock);
    tempSelected:= nil;
    parts:= nil;

    try
      Canvas.Font := Font;
      CWidth := Canvas.TextWidth('0');
      if useTFields then begin
         for I := 0 to FieldCount - 1 do
            Fields[I].DisplayWidth := (ColWidths[I + FIndicatorOffset] +
               CWidth div 2 - 3) div CWidth;
      end
      else begin
         tempSelected:= TStringList.create;
         parts:= TStringList.create;
         tempSelected.assign(Selected);
         Selected.clear;
         for I := 0 to tempSelected.count-1 do
         begin
             strBreakApart(tempselected[i], #9, parts);
             Selected.Add(parts[0] + #9 +
{                inttostr(ColWidths[I + FIndicatorOffset])}
               inttostr((ColWidths[I + FIndicatorOffset] + CWidth div 2 - 3) div CWidth)
                  +#9 + parts[2]);
         end;
      end;

      ParentForm := GetParentForm(Self);
      if (ParentForm <> nil) and (TForm(ParentForm).Designer <> nil) then
      begin
	ParentForm.Designer.Modified;
      end
    finally
      Dec(FUpdateLock);
      tempSelected.Free;
      Parts.Free;
    end;
    LayoutChanged;
{    SizelastColumn; {!!! 4/7/97}
  end;
end;

procedure TwwCustomDBGrid.Loaded;
begin
  inherited Loaded;
  LayoutChanged;
end;

procedure TwwCustomDBGrid.SetOptions(Value: TwwDBGridOptions);
const
  LayoutOptions = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator,
    dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgPerfectRowFit];
var
  NewGridOptions: TGridOptions;
  ChangedOptions: TwwDBGridOptions;
begin
  if FOptions <> Value then
  begin
    NewGridOptions := [];
    if dgColLines in Value then
      NewGridOptions := NewGridOptions + [goFixedVertLine, goVertLine];
    if dgRowLines in Value then
      NewGridOptions := NewGridOptions + [goFixedHorzLine, goHorzLine];
    if dgColumnResize in Value then
      NewGridOptions := NewGridOptions + [goColSizing, goColMoving];
    if dgTabs in Value then Include(NewGridOptions, goTabs);
    if dgRowSelect in Value then Include(NewGridOptions, goRowSelect);
    if (dgEditing in Value) and not (dgRowSelect in Value) then  {edit not allowed if RowSelect}
       Include(NewGridOptions, goEditing);
    if dgAlwaysShowEditor in Value then Include(NewGridOptions, goAlwaysShowEditor);
    inherited Options := NewGridOptions;
    ChangedOptions := (FOptions + Value) - (FOptions * Value);
{    if (dgPerfectRowFit in Value) <> (dgPerfectRowFit in FOptions) then
    begin
       Invalidate;
    end;}
    if (dgWordWrap in Value) <> (dgWordWrap in FOptions) then
    begin
       if (InplaceEditor<>Nil) then
	  (InplaceEditor as TwwInplaceEdit).WordWrap:= (dgWordWrap in Value);
       Invalidate; { if wordwrap changed }
    end;
    FOptions := Value;
    if ChangedOptions * LayoutOptions <> [] then LayoutChanged;
  end;


end;

procedure TwwCustomDBGrid.SetTitleFont(Value: TFont);
begin
  FTitleFont.Assign(Value);
  LayoutChanged;
end;

procedure TwwCustomDBGrid.SetIndicatorColor(Value: TIndicatorColorType);
begin
  FIndicatorColor:= Value;
  LayoutChanged;
end;

procedure TwwCustomDBGrid.SetTitleAlignment(sel: TAlignment);
begin
   if sel<>FtitleAlignment then
   begin
      FTitleAlignment:= sel;
      LayoutChanged;
   end
end;

procedure TwwCustomDBGrid.SetTitleLines(sel: integer);
begin
   if sel<=0 then exit;
   if sel<>FTitleLines then
   begin
      FTitleLines:= sel;
      LayoutChanged;
   end
end;

procedure TwwCustomDBGrid.SetRowHeightPercent(sel: Integer);
begin
   if sel<=0 then begin
      FRowHeightPercent:= 100;
      exit;
   end;

   if sel<>FRowHeightPercent then
   begin
      FRowHeightPercent:= sel;
      LayoutChanged;
   end
end;

procedure TwwCustomDBGrid.DoCalcTitleAttributes(AFieldName: string; AFont: TFont; ABrush: TBrush;
	     var FTitleAlignment: TAlignment);
begin
  if Assigned(FOnCalcTitleAttributes) then
     FOnCalcTitleAttributes(Self, AFieldName, AFont, ABrush, FTitleAlignment)
end;

procedure TwwCustomDBGrid.DoCalcCellColors(Field: TField; State: TGridDrawState;
	     highlight: boolean; AFont: TFont; ABrush: TBrush);
begin
  if Assigned(FOnCalcCellColors) then
     FOnCalcCellColors(Self, Field, State, highlight, AFont, ABrush);
  isWhiteBackground:= ColorToRGB(Canvas.Brush.Color)=clWhite;
end;

Function TwwCustomDBGrid.GetShowHorzScrollBar: Boolean;
begin
   result:= ScrollBars in [ssBoth, ssHorizontal];
end;

Procedure TwwCustomDBGrid.SetShowHorzScrollBar(val: boolean);
begin
   if (val) then ScrollBars:= ssHorizontal
   else ScrollBars:= ssNone;
end;

Procedure TwwCustomDBGrid.SetShowVertScrollBar(val: boolean);
begin
   FShowVertScrollBar:= val;
   UpdateScrollBar;
   invalidate;
end;

Function TwwCustomDBGrid.IsMemoField(Acol, Arow: integer): boolean;
var Field: TField;
begin
   Result:= False;
   if dbRow(ARow)<0 then exit;
   Field := GetColField(dbCol(Acol));
   if (Field = nil) then exit;
{   if not (Field is TMemoField) then exit;}
   if not (Field is TBlobField) then exit;
   Result:= True;
end;

function TwwCustomDBGrid.IsCheckBox(col, row: integer; var checkboxOn, checkboxOff: string): boolean;
var fldName: string;
    i: integer;
    parts : TStrings;
    controlType: TStrings;
begin
   result:= False;
   if not isValidCell(col, row) then exit;

   fldName:= DataLink.fields[dbCol(col)].fieldName;
   parts:= TStringList.create;

   controlType:= wwGetControlType(datasource.dataset);
   for i:= 0 to ControlType.count-1 do begin
      strBreakapart(controlType[i], ';', parts);
      if parts.count<4 then continue;
      if parts[0]<>fldName then continue;
      if parts[1]='CheckBox' then begin
	 CheckBoxOn:= parts[2];
	 CheckBoxOff:= parts[3];
	 result:= True;
	 break;
      end
   end;

   parts.free;
end;

Function TwwCustomDBGrid.isValidCell(ACol, ARow: integer): boolean;
begin
   Result:= False;
   if dataSource=Nil then exit;
   if dataSource.dataSet=Nil then exit;
   ACol:= dbCol(ACol);
   ARow:= dbRow(ARow);
   if (ACol<0) or (ACol>=DataLink.FieldCount) then exit;
   if (ARow<0) then exit;
   if not (wwDataSet(DataSource.dataSet)) then exit;
   Result:= True;
end;

function TwwCustomDBGrid.DbCol(col: integer): integer;
begin
   result:= col;
   if dgIndicator in Options then result:= col - 1;
end;

function TwwCustomDBGrid.DbRow(row: integer): integer;
begin
   result:= row;
   if dgtitles in Options then result:= row - 1;
end;

Function TwwCustomDBGrid.IsSelected: boolean;
begin
   result:= False;
end;

Function TwwCustomDBGrid.IsSelectedRow(DataRow: integer): boolean;
begin
   result:= False;
end;

procedure TwwCustomDBGrid.RefreshBookmarkList;
begin
end;

procedure TwwCustomDBGrid.HideControls;
begin
end;

constructor TwwInplaceEdit.wwCreate(AOwner: TComponent; dummy: integer);
begin
  Create(AOwner);
  FwwPicture:= TwwDBPicture.create(self);
  ParentGrid:= Owner as TwwCustomDBGrid;
  FWordWrap:= dgWordWrap in ParentGrid.Options;
  {$ifdef ver100}
  ImeMode := ParentGrid.ImeMode;
  ImeName := ParentGrid.ImeName;
  {$endif}
end;

destructor TwwInplaceEdit.Destroy;
begin
  FwwPicture.Free;
  inherited Destroy;
end;

{ Convert cr to tab }
procedure TwwInplaceEdit.KeyDown(var Key: Word; Shift: TShiftState);

  procedure SendToParent;
  begin
     ParentGrid.setFocus;
     ParentGrid.KeyDown(Key, Shift);
     Key := 0;
     Update;
  end;

  function Ctrl: Boolean;
  begin
    Result := ssCtrl in Shift;
  end;

begin
   case Key of
      VK_RETURN:
	 if dgEnterToTab in ParentGrid.KeyOptions then
	 begin
	    SendToParent;
	 end;

      VK_DELETE: if (Ctrl) then SendToParent;
   end;

   inherited KeyDown(Key, Shift);
end;

procedure TwwInplaceEdit.KeyUp(var Key: Word; Shift: TShiftState);
begin
   if (dgEnterToTab in ParentGrid.KeyOptions) and (Key=VK_RETURN) then Key:= 9;
   inherited KeyUp(Key, Shift);
   if (Key= VK_DELETE) then
   begin
      if Assigned(parentGrid.FOnCheckValue) then
	 IsValidPictureValue(Text);
   end
end;

procedure TwwInplaceEdit.KeyPress(var Key: Char);
var pict: TwwPictureValidator;
    s: string;
    res: TwwPicResult;
    padlength, OldSelStart, Oldlen, OldSelLen: integer;
    DisplayTextIsInvalid: boolean;

   Function NewText: string;
   var curStr : string;
   begin
      curStr:= Text;
      if (ord(key)=vk_back) then begin
	 if (length(curstr)>=1) then
	    delete(curstr, selStart, 1);
	 result:= curStr;
      end
      else
	 result:= copy(curStr, 1, selStart+1-1) +
	       char(Key) + copy(curStr, selStart + 1 + length(SelText), 32767);
   end;


begin
  if (dgEnterToTab in ParentGrid.KeyOptions) and (ord(Key)=VK_RETURN) then Key:= #9;

  inherited KeyPress(Key);

  if HavePictureMask then begin
     if (ord(Key) = VK_BACK) then
     begin
       if Assigned(parentGrid.FOnCheckValue) then IsValidPictureValue(NewText);
       exit;
     end;
     if (ord(key)<VK_SPACE) then exit;

     pict:= TwwPictureValidator.create(FwwPicture.PictureMask, FwwPicture.AutoFill);

     s:= NewText;
     if (Maxlength>0) and (length(s)>MaxLength) and (length(s)>length(Text)) then exit; { Limit to maxlength }
     res:= Pict.picture(s, FwwPicture.AutoFill);
     DisplayTextIsInvalid:= False;

     oldSelStart:= SelStart;
     oldLen:= length(Text);
     oldSelLen:= SelLength;

     case res of
       prError: begin
	     { If at end of list }
	     if (selStart + length(selText) >= length(Text)) then begin
		key:= char(0);
		MessageBeep(0);
	     end
	     else DisplayTextIsInvalid:= True;
	 end;

       prIncomplete: begin
	    padLength := length(s) - length(text);
	    text:= s;
	    (Owner as TwwCustomDBGrid).FEditText:= Text;
	    if (oldSelLen=oldLen) then selStart:= length(s)
	    else selStart:= OldSelStart + padLength;
	    key:= char(0);
	    DisplayTextIsInvalid:= True;
	    end;

       prComplete: begin
            {$ifdef win32}
            if (length(s)>1) then text:= copy(s, 1, length(s)-1)
            else text:= '';   {11/21/96 - Workaround for Delphi 2 bug in scrolling}
            {$else}
            text:= s;
            {$endif}
	    (Owner as TwwCustomDBGrid).FEditText:= s;

	    if (oldSelLen=oldLen) then selStart:= length(s)
	    else if (length(s)>oldlen) then
	       selStart:= oldSelStart + (length(s)-oldlen) {Move caret to the right}
	    else selStart:= oldSelStart + 1;  { 11/26/96 }

            {$ifdef win32}
            if (length(s)>0) then
               key:= s[length(s)];  {11/21/96 - Workaround for Delphi 2 bug in scrolling in unbordered control}
            {$else}
            key:= char(0);
            {$endif}

	 end;

     end;
     pict.Free;

     if Assigned(parentGrid.FOnCheckValue) then
	parentGrid.FOnCheckValue(self, not DisplayTextIsInvalid);

  end;
end;

{ Allow paste to change text - 10/29/96 }
procedure TwwInplaceEdit.WMPaste(var Message: TMessage);
begin
  inherited;
  ParentGrid.edit;
  ParentGrid.DataLink.modified;
end;

procedure TwwInplaceEdit.SetWordWrap(val: boolean);
begin
   FWordWrap:= val;
   RecreateWnd;
end;

procedure TwwInplaceEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style and not (ES_AUTOVSCROLL or ES_WANTRETURN);
  if (BorderStyle = bsNone) or WordWrap then Params.Style:= Params.Style or ES_MULTILINE;
  if WordWrap then Params.Style := (Params.Style or ES_AUTOVSCROLL) and not ES_AUTOHSCROLL;
end;

function TwwInplaceEdit.IsValidPictureValue(s: string): boolean;
var pict: TwwPictureValidator;
    res: TwwPicResult;
begin
   if s='' then
      result:= True
   else if not HavePictureMask then
      result:= True
   else begin
      pict:= TwwPictureValidator.create(FwwPicture.PictureMask, FwwPicture.AutoFill);;
      res:= Pict.picture(s, False);
      result := res = prComplete;
      pict.Free;
   end;
   if Assigned(parentGrid.FOnCheckValue) then
      parentGrid.FOnCheckValue(self, result);
end;

procedure TwwInplaceEdit.WMSetFocus(var Message: TWMSetFocus);
var tempMask: string;
    tempAutoFill: boolean;
begin
  inherited;
  if (parentGrid.datasource=nil) or (parentGrid.datasource.dataset=nil) then exit;
  with ParentGrid do begin
     if GetColField(dbCol(Col))=nil then exit;
     wwPictureByField(Datasource.dataset, GetColField(dbCol(Col)).FieldName, True,
		      tempMask, tempAutoFill, FUsePictureMask);
     FwwPicture.PictureMask:= tempMask;
     FwwPicture.AutoFill:=tempAutoFill;
     FwwPicture.AllowInvalidExit:= False;
     IsValidPictureValue(GetColField(dbCol(Col)).text)
  end
end;

Function TwwInplaceEdit.HavePictureMask: boolean;
begin
   result:=
     FUsePictureMask and
     (FwwPicture.PictureMask<>'')
end;

procedure TwwInplaceEdit.CMFontChanged(var Message: TMessage);
var
  Loc: TRect;
begin
  inherited;
  Loc.Bottom :=ClientHeight;
  Loc.Right := ClientWidth-1;
  if BorderStyle = bsNone then begin
     Loc.Top := 2;
     Loc.Left := 2;
  end
  else begin
     Loc.Top := 0;
     Loc.Left := 0;
  end;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));  { Use 2 pixel border on top and left }
end;

Procedure TwwCustomDBGrid.SelectRecord;
begin
end;

Procedure TwwCustomDBGrid.UnselectRecord;
begin
end;

Procedure TwwCustomDBGrid.SetTitleButtons(val: boolean);
begin
   if (FTitleButtons<>val) then
   begin
      FTitleButtons:= val;
      invalidate;
   end
end;

Procedure TwwCustomDBGrid.SetPictureMask(FieldName: string; Mask: string);
begin
   if DataSource=nil then exit;
   wwSetPictureMask(DataSource.Dataset, FieldName, Mask, True, True,
		    True, False, False);
end;

Procedure TwwCustomDBGrid.SetPictureAutoFill(FieldName: string; AutoFill: boolean);
begin
   if DataSource=nil then exit;
   wwSetPictureMask(DataSource.Dataset, FieldName, '', AutoFill, True,
		    False, True, False);
end;

Procedure TwwCustomDBGrid.UnselectAll;
begin
end;

    function TwwCustomDBGrid.GetSelectedFields: TStrings;
    begin
         Result:= FSelected;
    end;

    procedure TwwCustomDBGrid.SetSelectedFields(sel : TStrings);
    begin
         FSelected.assign(sel);
    end;

Function TwwCustomDBGrid.IsSelectedCheckbox(ACol: integer): boolean;
var tempField: TField;
begin
    if isCheckBox(ACol, 1, dummy1, dummy2) then
    begin
       tempField:=GetColField(dbCol(ACol));
       if tempField=nil then result:= False
       else result:= (lowercase(tempField.fieldName)='selected');
    end
    else result:= False;
end;


Procedure TwwCustomDBGrid.SizeLastColumn;
var i, FieldsSize: integer;
begin
   FUpdatingColWidths:= True;
   SetColumnAttributes;
   FUpdatingColWidths:= False;

   if ShowVertScrollBar then FieldsSize:= GetSystemMetrics(SM_CXHThumb) + 5
   else FieldsSize:= 0;

   if dgIndicator in Options then FieldsSize:= FieldsSize + colWidths[0] + GridLineWidth;

   for i:= LeftCol to ColCount-2 do
      FieldsSize:= FieldsSize + colWidths[i] + GridLineWidth;
   if FieldsSize>Width then exit;  { Last column is not visble }

   FieldsSize:= FieldsSize + ColWidths[ColCount-1] + GridLineWidth;

   FUpdatingColWidths:= True;
   if Width-FieldsSize>0 then
      colWidths[ColCount-1]:= colWidths[ColCount-1] + (Width - FieldsSize);
   FUpdatingColWidths:= False;
end;

function TwwCustomDBGrid.GetColWidthsPixels(Index: Longint): Integer;
begin
  result:= inherited ColWidths[Index];
end;

procedure TwwCustomDBGrid.SetColWidthsPixels(Index: Longint; Value: Integer);
begin
   FUpdatingColWidths:= True;
   ColWidths[Index]:= Value;
   FUpdatingColWidths:= False;
end;

procedure TwwCustomDBGrid.FlushChanges;
begin
   DataLink.UpdateData;
end;

procedure TwwIButton.Loaded;
begin
  inherited Loaded;
  if parent is TwwCustomDBGrid then
  begin
     (parent as TwwCustomDBGrid).FIndicatorButton:= self;
     {$ifdef win32}
     (parent as TwwCustomDBGrid).IndicatorWidth:= Width-1;
     {$else}
     (parent as TwwCustomDBGrid).IndicatorWidth:= Width-2;
     {$endif}
  end;
end;

procedure TwwIButton.Paint;
begin
   inherited Paint;
{   if parent is TwwDBGrid then
      with (parent as TwwDBGrid) do begin
         InvalidateCell(0,1);
         Update;
      end}
end;

procedure TwwIButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var SizeChanging: boolean;
begin
  {$ifdef win32}
  if ALeft>0 then ALeft:= 0;
  if ATop>0 then ATop:= 0;
  {$else}
  ALeft:= -1;
  ATop:= -1;
  {$endif}

  SizeChanging:= (AWidth<>Width) or (AHeight<>Height);
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if (parent=nil) then exit;

  if SizeChanging and (not (csLoading in ComponentSTate)) then
  begin
     with (parent as TwwCustomDBGrid) do begin
        {$ifdef win32}
        IndicatorWidth:= self.Width-1;
        {$else}
        IndicatorWidth:= self.Width-2;
        {$endif}
        LayoutChanged;
     end
  end
end;

{$ifdef win32}
{$ifdef ver100}
procedure TwwCustomDBGrid.GetChildren(Proc: TGetChildProc; Root: TComponent);
{$else}
procedure TwwCustomDBGrid.GetChildren(Proc: TGetChildProc);
{$endif}
begin
   if FIndicatorButton<>Nil then begin
      Proc(FIndicatorButton);
   end;
end;
{$else}
procedure TwwCustomDBGrid.WriteComponents(Writer: TWriter);
begin
   if FIndicatorButton<>Nil then Writer.WriteComponent(FIndicatorButton);
end;
{$endif}


end.
