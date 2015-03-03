unit Wwdbgrid;
{
//
// Components : TwwDBGrid
//
// Copyright (c) 1995, 1996, 1997 by Woll2Woll Software
//
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, StdCtrls,
  Forms, Grids, DsgnIntf, dialogs, dbtables, db, wwstr,
  wwtable, wwMemo, wwcommon, wwdbigrd,
  {$ifdef win32}
  comctrls,
  {$endif}
  Menus, wwdatsrc, wwdbedit, wwtypes, dbctrls;

type
  TwwFieldControlType = (fctNone, fctField, fctCheckBox, fctCustom, fctBitmap,
                         fctLookupCombo, fctComboBox, fctRichEdit);
  TwwOnInitMemoDlgEvent = procedure(Dialog : TwwMemoDlg) of object;
  TwwMemoUserButtonEvent = procedure(Dialog: TwwMemoDlg; Memo: TMemo) of object;
  TwwEditControlOption = (ecoCheckboxSingleClick, ecoSearchOwnerForm);
  TwwEditControlOptions = set of TwwEditControlOption;

  TwwDBGrid = class;

  TwwMemoDialog = class(TComponent)
  private
     FFont: TFont;
     FDataLink: TFieldDataLink;
     FMemoAttributes: TwwMemoAttributes;
     FCaption: String;
     FLeft, FTop, FWidth, FHeight: integer;

     { IP 2.0 additions }
     FUserButton1Click: TwwMemoUserButtonEvent;
     FUserButton2Click: TwwMemoUserButtonEvent;
     FOnInitDialog: TwwOnInitMemoDlgEvent;
     FOnCloseDialog: TwwOnInitMemoDlgEvent;
     FUserButton1Caption: string;
     FUserButton2Caption: string;
  protected
     procedure SetDataField(value: String);
     procedure SetDataSource(value : TDataSource);
     Function GetDataSource: TDataSource;
     Function GetDataField: String;
     procedure SetwwMemoAttributes(sel: TwwMemoAttributes);
     procedure SetFont(Value: TFont);
     procedure SetCaption(Value: String);
  public
     Form: TwwMemoDlg;  { Used by TwwMemoDlg }
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
     procedure DoInitDialog; virtual;  { called by wwmemo }
     procedure DoCloseDialog; virtual;  { called by wwmemo }

  published
     property DataSource: TDataSource read getDataSource write setDataSource;
     property DataField: String read getDataField write setDataField;
     function Execute: boolean; virtual;
     property Font: TFont read FFont write SetFont;
     property MemoAttributes : TwwMemoAttributes
        read FMemoAttributes write setwwMemoAttributes
        default [mSizeable, mWordWrap];
     property Caption: string read FCaption write setCaption;

     property DlgLeft: integer read FLeft write FLeft;
     property DlgTop: integer read FTop write FTop;
     property DlgWidth: integer read FWidth write FWidth;
     property DlgHeight: integer read FHeight write FHeight;

     property OnInitDialog: TwwOnInitMemoDlgEvent read FOnInitDialog write FOnInitDialog;
     property OnCloseDialog: TwwOnInitMemoDlgEvent read FOnCloseDialog write FOnCloseDialog;
     property OnUserButton1Click: TwwMemoUserButtonEvent read FUserButton1Click write FUserButton1Click;
     property OnUserButton2Click: TwwMemoUserButtonEvent read FUserButton2Click write FUserButton2Click;
     property UserButton1Caption: string read FUserButton1Caption write FUserButton1Caption;
     property UserButton2Caption: string read FUserButton2Caption write FUserButton2Caption;

  end;


  TwwMemoOpenEvent =
     procedure (Grid: TwwDBGrid; MemoDialog: TwwMemoDialog) of object;

  TwwMemoCloseEvent =
     procedure (Grid: TwwDBGrid; Cancel: boolean) of object;

  TwwSelectRecordEvent =
     procedure (Grid: TwwDBGrid; Selecting: boolean; var Accept: boolean) of object;

TwwDBGrid = class(TwwCustomDBGrid)
  private
    FMemoAttributes : TwwMemoAttributes;
    redrawingGrid: Boolean;
    initialized: Boolean;
    doneInitControls: boolean;
    drawingCell: Boolean;
    currentComboBoxRow, currentComboBoxCol: integer;
    FOnMemoOpen: TwwMemoOpenEvent;
    FOnMemoClose: TwwMemoCloseEvent;
    FFixedCols: integer;
    inLinkActive: boolean;
    inTopLeftChanged: boolean;
    GridIsLoaded: boolean;
    FEditControlOptions: TwwEditControlOptions;
    FOnSelectRecord : TwwSelectRecordEvent;
    {$ifdef win32}
    TempRichEdit: TRichEdit;
    {$endif}

    { Multi-selection support variables}
    bookmarks: TList;
    FDependentComponents: Tlist;

    Function GetTitleColor: TColor;
    procedure SetTitleColor(sel: TColor);
    Function GetDataSource: TwwDataSource;
    Procedure SetDataSource(val: TwwDataSource);

    procedure SetwwMemoAttributes(sel: TwwMemoAttributes);
    procedure CMDesignHitTest(var Msg: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure WMLButtonDblClk(var Msg: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;

    procedure UpdateSelectedProperty;

  protected
    SelectedRecordList: TStrings; { Internal buffers selected value }
    CurrentCustomEdit: TCustomEdit;

    procedure CalcRowHeight; override;

    Function XIndicatorOffset: integer;
    procedure DoExit; override;
    procedure ColumnMoved(FromIndex, ToIndex: Longint); override;
    procedure ColWidthsChanged; override;
    procedure LinkActive(value: boolean); override;
    procedure SetFieldValue(ACol: Integer; val: string);
    function CanEditShow: Boolean; override;
    procedure MouseDown(Button: TMouseButton; shift: TShiftState; x, y: integer); override;
    procedure MouseUp(Button: TMouseButton; shift: TShiftState; x, y: integer); override;
    procedure ColExit; override;
    procedure TopLeftChanged; override;
    Function AllowCancelOnExit: boolean; override;
    Function GetFieldValue(ACol: integer): string; override;

    procedure ToggleCheckBox(col, row: integer);
    procedure InitControls;
    procedure SetFixedCols(val: integer);
    function GetFixedCols: integer;
    procedure Paint; override;
    function IsWWControl(ACol, ARow: integer): boolean; override;
    procedure CallMemoDialog;
    Function findBookmark: TBookmark;

{    Function GetControlDataSource(ctrl: TWinControl): TDataSource; virtual;
    Function GetControlDataField(ctrl: TWinControl): string; virtual;
    Procedure SetControlDataSource(ctrl: TWinControl; ds: TwwDataSource); virtual;
    Procedure SetControlDataField(ctrl: TWinControl; df: string); virtual;}
    Function CellColor(ACol, ARow: integer): TColor; override;
    procedure RefreshBookmarkList; override;
    procedure Scroll(Distance: Integer); override;
    procedure Loaded; override;
    Function GetComponent(thisName: string): TCustomEdit;
    procedure SelectRecordRange(bkmrk1, bkmrk2: TBookmark);
    Procedure RemoveSelected(bkmrk1, bkmrk2: TBookmark);
    Function IsSelectedRow(DataRow: integer): boolean; override;

  public
    AlwaysShowControls: boolean; { Undocumented: when true controls will display even when grid is readonly}

    Function IsSelected: boolean; override;
    Function IsSelectedRecord: boolean;
    Procedure SelectRecord; override;
    Procedure UnselectRecord; override;
    Procedure SelectAll;
    Procedure UnselectAll; override;

    procedure FlushChanges; override;
    procedure KeyDown(var key: word; shift: TShiftState); override;
    Function GetRowCount: integer;
    Function GetColCount: integer;
    Function GetActiveRow: integer;
    Function GetActiveCol: integer;
    Procedure SetActiveRow(val: integer); {10/24/96 }
    Function GetActiveField: TField;
    Procedure SetActiveField(AFieldName: string);

    Function FieldName(Acol: integer): string;
    function IsRichEditCell(col, row: integer; var customEdit: TCustomEdit) : boolean;
    function IsCustomEditCell(col, row: integer; var customEdit: TCustomEdit) : boolean;
    procedure SetScrollBars(scrollVal: TScrollStyle);
    procedure RedrawGrid;
    procedure SetColumnAttributes; override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect;  AState: TGridDrawState); override;
    function CanEditGrid: Boolean;
    procedure Hidecontrols; override;                          { InfoPower documented method }
    function MouseCoord(X, Y: Integer): TGridCoord;           { InfoPower documented method }
    procedure SetControlType(AFieldName: string;
        AComponentType: TwwFieldControlType; AParameters: string); { InfoPower documented method }
    procedure RefreshDisplay;                                 { InfoPower documented method }
    procedure SortSelectedList;                               { IP 2 documented method }

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ColEnter; override; { 3/29/97}

    property InplaceEditor;  { Support in-cell editing events }
    property ColWidths;
    property GridLineWidth;
    property Canvas;
    property SelectedList: TList read Bookmarks;
    property TabStops;
    Procedure AddDependent(value: TComponent);
    Procedure RemoveDependent(value: TComponent);
    Procedure InvalidateCurrentRow;
    procedure ApplySelected;

  published
    property Selected;
    property MemoAttributes : TwwMemoAttributes
        read FMemoAttributes write setwwMemoAttributes
        default [mSizeable, mWordWrap];
    property TitleColor: TColor read getTitleColor write setTitleColor;
    property OnMemoOpen : TwwMemoOpenEvent read FOnMemoOpen write FOnMemoOpen;
    property OnMemoClose : TwwMemoCloseEvent read FOnMemoClose write FOnMemoClose;
    property OnMultiSelectRecord : TwwSelectRecordEvent read FOnSelectRecord write FOnSelectRecord;
    property FixedCols : integer read getFixedCols write setFixedCols;
    property ShowHorzScrollBar;
    property ShowVertScrollBar;
    property EditControlOptions: TwwEditControlOptions read FEditControlOptions write FEditControlOptions
             default [ecoSearchOwnerForm];
    property IndicatorButton;

    { From TwwCustomDBGrid }
    property Align;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DataSource : TwwDataSource read getDataSource write setDataSource;
    property DefaultDrawing;
    property DragCursor;
    property DragMode;
    property EditCalculated;
    property Enabled;
    property Font;
    {$ifdef ver100}
    property ImeMode;// : TImeMode read getImeMode write setImeMode default imDontCare;
    property ImeName;// : string read getImeName write setImeName;
    {$endif}
    property KeyOptions;
    property MultiSelectOptions;
    property Options;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property RowHeightPercent;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TitleAlignment;
    property TitleFont;
    property TitleLines;
    property TitleButtons;
    property UseTFields;
    property Visible;
    property OnCalcCellColors;
    property OnCalcTitleAttributes;
    property OnTitleButtonClick;
    property OnColEnter;
    property OnColExit;
    property OnDrawDataCell;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;

    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property IndicatorColor;
    property OnCheckValue;
    property OnColumnMoved;
    property OnTopRowChanged;
end;

implementation

uses wwdbcomb,
{$ifdef win32}
bde;
{$else}
dbiprocs, dbierrs, dbitypes;
{$endif}

function sameRect(rect1, rect2: TRect): boolean;
begin
   result:=
      (rect1.left = rect2.left) and
      (rect1.right = rect2.right) and
      (rect1.top = rect2.top) and
      (rect1.bottom = rect2.bottom);
end;

function Max(X, Y: Integer): Integer;
begin
  Result := Y;
  if X > Y then Result := X;
end;


Function minInt(x,y: integer): integer;
begin
   if x<y then result:= x
   else result:= y
end;

    constructor TwwDBGrid.create(AOwner: TComponent);
    begin
      inherited Create(AOwner);

      redrawingGrid:= False;
      initialized:= False;
      doneInitControls:= False;
      drawingCell:= False;

      MemoAttributes := [mSizeable, mWordWrap];
      FFixedCols:= 0;
      inLinkActive:= False;

      bookmarks:= TList.create;
      FDependentComponents:= TList.create;

      SelectedRecordList:= TStringList.create;

      FEditControlOptions := [ecoSearchOwnerForm];
      GridIsLoaded:= False;
      AlwaysShowControls:= False;
      CurrentCustomEdit:= Nil;

      {$ifdef win32}
{      FIndicatorButton:= TSpeedButton.create(self);}
      {$else}
{      FIndicatorButton:= TSpeedButton.create(wwGetOwnerForm(self));}
      {$endif}
{      FIndicatorButton.parent:= self;
      FIndicatorButton.Name:= Name + 'IButton';}
    end;

    destructor TwwDBGrid.Destroy;
    var i: integer;
    begin
      for i:= 0 to bookmarks.count-1 do begin
         if (datasource<>nil) and (datasource.dataset<>nil) then
            datasource.dataset.FreeBookmark(TBookmark(bookmarks.items[i]));
      end;
      bookmarks.Free;
      bookmarks:= Nil;

      for i:= 0 to FDependentComponents.count-1 do begin
         TwwCheatCastNotify(FDependentComponents[i]).notification(self, opRemove);
      end;
      FDependentComponents.Free;

      SelectedRecordList.Free;

      inherited Destroy;
    end;

    procedure TwwDBGrid.SetFixedCols(val: integer);
    begin
       if (csDesigning in ComponentState) then begin
          if ((dataSource<>Nil) and (dataSource.dataSet<>Nil) and
             (dataSource.dataSet.active) and (val+xIndicatorOffset>=ColCount)) or
             (val<0) then
          begin
             MessageDlg('Invalid value for FixedCols', mtWarning, [mbok], 0);
             exit;
          end
       end;

       FFixedCols:= val;
       LayoutChanged;
    end;

    Function TwwDBGrid.GetFixedCols: integer;
    begin
       result:= FFixedCols;
    end;

    Function TwwDBGrid.GetDataSource: TwwDataSource;
    begin
       if (inherited DataSource) is TwwDataSource then
          result:= (inherited DataSource) as TwwDataSource
       else result:= Nil;
    end;

    Procedure TwwDBGrid.SetDataSource(val: TwwDataSource);
    begin
       Inherited DataSource:= Val;
    end;

    procedure TwwDBGrid.SetwwMemoAttributes(sel : TwwMemoAttributes);
    begin
        FMemoAttributes:= sel;
        redrawGrid;
    end;

    Function TwwDBGrid.GetTitleColor: TColor;
    begin
       result:= inherited TitleColor;
    end;

    procedure TwwDBGrid.SetTitleColor(sel: TColor);
    begin
       if sel<>inherited TitleColor then
       begin
         inherited TitleColor:= sel;
         LayoutChanged;
       end
    end;

    procedure TwwDBGrid.SetScrollBars(scrollVal: TScrollStyle);
    begin
      ScrollBars:= scrollVal;
    end;

procedure TwwDBGrid.RedrawGrid;
var i: integer;
    haveCalculatedField: boolean;
    form: TCustomForm;
begin
   if redrawingGrid then exit;
   if Selected = Nil then exit;
   if (dataSource=Nil) then exit;
   if (dataSource.dataSet=Nil) then exit;
   if not (wwDataSet(DataSource.dataSet)) then
   begin
      MessageDlg('wwGrid must use descendent of TwwTable, TwwQuery, TwwQBE, TwwStoredProc, TwwClientDataSet.',
          mtInformation, [mbok], 0);
      DataSource := Nil;
      exit;
   end;

   InitControls;

   try
      dataSource.dataSet.disableControls;
      with datasource do
         wwDataSetRemoveObsolete(dataset,
            wwGetLookupFields(dataset), wwGetLookupLinks(dataset),
             wwGetControlType(dataSet));
{      if DataSource.dataSet is TwwTable then
         (dataSource.dataSet as TwwTable).removeObsoleteLinks
      else if DataSource.dataSet is TwwQuery then
         (dataSource.dataSet as TwwQuery).removeObsoleteLinks
      else if DataSource.dataSet is TwwStoredProc then
         (dataSource.dataSet as TwwStoredProc).removeObsoleteLinks
      else if DataSource.dataset is TwwClientDataSet then
         (dataSource.dataSet as TwwClientDataSet).removeObsoleteLinks;
      else (dataSource.dataSet as TwwQBE).removeObsoleteLinks;
}
      if ecoSearchOwnerForm in FEditControlOptions then form:= wwGetOwnerForm(self)
      else form:= GetParentForm(self);
      wwDataSetRemoveObsoleteControls(form, datasource.dataset);

      redrawingGrid:= True;

      { If no selection then don't override }
      { If running program and have calculated field then don't change visibility }
      if selected.Count>0 then begin
         haveCalculatedField:= False;
         for i:= 0 to dataSource.dataSet.fieldCount-1 do begin
            if (datasource.dataset.fields[i].calculated) then
               haveCalculatedField:= True;
         end;

         if (csDesigning in ComponentState) or (not haveCalculatedField) then
         begin
            ApplySelected;
         end;

      end;

      {InitControls could change row height so update }
      if (csDesigning in ComponentState) then
      begin
         if useTFields then updateSelectedProperty;
         UpdateRowCount;
      end;


   finally
      dataSource.dataSet.enableControls;
      redrawingGrid:= False;
      initialized:= True;

   end;

end;


procedure TwwDBGrid.LinkActive(value: boolean);
begin
   inLinkActive:= True;
   inherited linkActive(value);
   if value then
   begin
      redrawGrid;
   end;
   inLinkActive:= False;
end;

{ Don't allow insertion of record to cancel if combo is showing. }
Function TwwDBGrid.AllowCancelOnExit: boolean;
begin
   result:= True;
end;

procedure TwwDBGrid.DoExit;
begin
   HideControls;
   HideEditor;
   inherited doExit;
end;


  procedure TwwDBGrid.UpdateSelectedProperty;
  begin
    if redrawingGrid then exit;
    if Selected = Nil then exit;
    if dataSource=Nil then exit;
    if dataSource.dataSet = Nil then exit;

    if (initialized) then begin
       with GetParentForm(Self) do begin
          if (Designer<>Nil) then begin
             wwDataSetUpdateSelected(datasource.dataset, selected);
{             Selected.clear;
             with dataSource.dataSet do begin
                for i:= 0 to fieldCount-1 do begin
                   if (fields[i].visible) then
                      Selected.add(fields[i].fieldName + #9 +
                             inttostr(fields[i].displayWidth) + #9 +
                             fields[i].displayLabel);
                end;
             end;   }
          end;
       end;
    end;
  end;

  procedure TwwDBGrid.ApplySelected;
  begin
    if Selected = Nil then exit;
    if UseTFields then begin
       if dataSource=Nil then exit;
       if dataSource.dataSet = Nil then exit;
       wwDataSetUpdateFieldProperties(dataSource.dataSet,  selected);
    end
    else begin
       RefreshDisplay;
    end
  end;


procedure TwwDBGrid.SetColumnAttributes;
var i: integer;
    customEdit: TCustomEdit;
    ControlType, Parameters: wwSmallString;
begin
  if useTFields and (not inLinkActive) then
     updateSelectedProperty;

   { Update fixed columns if changed }
   if (inherited FixedCols<> FFixedCols+xIndicatorOffset) and
      (datasource<>Nil) and (datasource.dataset<>nil) and
      (datasource.dataset.active) then
   begin
      if (FFixedCols+xIndicatorOffset<ColCount) and (FFixedCols>=0) then
      begin
         inherited FixedCols:= FFixedCols + xIndicatorOffset;
         for i:= 0 to FFixedCols+xIndicatorOffset do TabStops[i]:= False;
      end
   end;

  inherited setColumnAttributes;

  { Enable tabstops for calculated columns with a lookup control attached to it }
  if not DataLink.active then exit;

  for I := 0 to FieldCount - 1 do begin
    with Fields[I] do
       if Calculated then begin
          if isCustomEditCell(i+xIndicatorOffset, 1, customEdit) then
             TabStops[I + xIndicatorOffset] := True
          else if isSelectedCheckbox(i+xIndicatorOffset) then
          begin
             TabStops[I + xIndicatorOffset] := True;
          end
          else begin
             WWDataSet_GetControl(DataSource.DataSet, FieldName,
                    ControlType, Parameters);
             if (ControlType = 'Bitmap') then TabStops[I + xIndicatorOffset] := True;
          end
       end
  end;

end;
{
Function TwwDBGrid.IsSelectedCheckbox(ACol: integer): boolean;
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
}
function TwwDBGrid.MouseCoord(X, Y: Integer): TGridCoord;
begin
   result:= inherited MouseCoord(X,Y);
end;

procedure TwwDBGrid.HideControls;
begin
   if (currentCustomEdit<>Nil) and currentCustomEdit.visible and
      (currentCustomEdit.parent=self) then  { 5/1/97 - Only hide if grid is parent of control }
   begin
      if currentCustomEdit.focused then setFocus;
      currentCustomEdit.visible:= False;
   end
end;

Procedure TwwDBGrid.Paint;
var
   tempFldName: string;
   index: integer;
begin
   RefreshBookmarkList;
   if not ShowVertScrollBar then SetScrollRange(Self.Handle, SB_VERT, 0, 0, False);

   { combo field has disappeared so hide combo control }
   if (currentCustomEdit<>Nil) and currentCustomEdit.visible and
      (datasource<>Nil) and (datasource.dataset<>nil) and
      (datasource.dataset.active) then
   begin
       tempFldName:= wwGetControlDataField(currentCustomEdit);
       if useTFields then begin
          if (datasource.dataset.findField(tempFldName)=Nil) or
             not dataSource.dataSet.fieldByName(tempFldName).visible then
                HideControls;
       end
       else begin
          if not wwFindSelected(Selected, tempFldName, index) then
              HideControls;
       end
   end;

   inherited paint;

{   if Optimize then begin
      ARect.left:= left;
      ARect.right:= left + FDrawBitmap.width;
      ARect.top:= top;
      ARect.bottom:= top + FDrawbitmap.height;
      Canvas.CopyMode:= cmMergeCopy;
      Canvas.CopyRect(ARect, FDrawBitmapCanvas, ARect);
   end;
}
   if Focused and (not SuppressShowEditor) and
      (not isMemoField(col, row)) and {11/25/96 - Memo fields should never show editor }
      (dgAlwaysShowEditor in Options) and (not isWWControl(col, row)) then
      ShowEditor;
end;

Function TwwDBGrid.CellColor(ACol, ARow: integer): TColor;
begin
   if ACol>FFixedCols then result:= Color
   else result:= TitleColor;
end;

procedure TwwDBGrid.DrawCell(ACol, ARow: Longint; ARect: TRect;  AState: TGridDrawState);
var value: string;
    OldActive: integer;
    Highlight: Boolean;
    lookupControl: TCustomEdit;
    tempFld: TField;

  procedure GetAbsolutePos(var ALeft, ATop: integer);
  var curObject: TWinControl;
      lastObject: TWinControl;
  begin
     curObject:= self;
     lastObject:= self;
     ALeft:= curObject.left;
     ATop:= curObject.top;

     while (curObject<>Nil) do begin
        curObject:= curObject.parent;
        if curObject is TCustomform then break;

        if curObject.containsControl(lastObject) then begin
           ALeft:= ALeft + curObject.left;
           ATop:= ATop + curObject.top;
        end;
     end;
  end;

begin
   if drawingCell then exit; { Avoid recursion }
   drawingCell:= True;

   if (row=ARow) and (col=ACol) and
      isCustomEditCell(ACol, ARow, lookupControl) and (canEditGrid or AlwaysShowControls) then
   begin
      if not (csDesigning in ComponentState) then
         currentCustomEdit:= lookupControl;

      with Canvas do begin
         Highlight := HighlightCell(ACol, dbRow(ARow), Value, AState);

         if (gdSelected in AState) and (not (csDesigning in ComponentState)) then
         begin
            if (currentCustomEdit<>Nil) and (currentCustomEdit.parent=self) and
               (ValidParentForm(Self).ActiveControl = currentCustomEdit) then
            begin
               if not sameRect(currentCustomEdit.BoundsRect, ARect) then
                  currentCustomEdit.BoundsRect := ARect;
            end
            else if Highlight and (ValidParentForm(Self).ActiveControl = Self) then
            begin

              { Clear buffer if changing rows so old value isn't drawn at all}
              OldActive:= DataLink.ActiveRecord;
              Value:= '';
              try
                 DataLink.ActiveRecord:= dbRow(ARow);

                 if wwIsClass(currentCustomEdit.classType, 'TwwDBCustomLookupCombo') then
                 begin
                    tempFld:= GetColField(dbCol(ACol));
                    if tempFld<>Nil then
                       value:= tempFld.asString
                 end
                 else value:= GetFieldValue(dbCol(ACol));

              finally
                 DataLink.ActiveRecord:= OldActive;
              end;

              { This is here for screen repainting reasons, otherwise screen is painted wrong then right. }
              currentCustomEdit.Text:= Value;

              if not sameRect(currentCustomEdit.BoundsRect, ARect) then begin
                 currentCustomEdit.BoundsRect := ARect;
              end;

              if (currentCustomEdit.parent <> Self) then
                 currentCustomEdit.parent:= Self;

              if not currentCustomEdit.visible then begin
                 currentCustomEdit.visible:= True;
                 if dgAlwaysShowEditor in Options then begin
                    currentCustomEdit.setFocus;
                    currentCustomEdit.selectAll;
                    currentCustomEdit.refresh;
                 end;
                 Update;
              end
              else begin
                 if (dgAlwaysShowEditor in Options) then currentCustomEdit.setFocus;
                 currentCustomEdit.refresh;
              end;
              currentComboBoxRow:= ARow;
              currentComboBoxCol:= ACol;
              ValidateRect(self.Handle, @ARect);
              drawingCell:= False;
              exit;
            end
         end;

         { Handles redraw problems when combo gets focus after already being visible }
         if not (csDesigning in ComponentState) and (currentCustomEdit.visible) then
         begin
           if sameRect(currentCustomEdit.BoundsRect,ARect) then begin
              currentCustomEdit.refresh;
              update;
              ValidateRect(self.Handle, @ARect);
              drawingCell:= False;
              exit;
           end
         end

      end;
   end;


   inherited DrawCell(ACol, ARow, ARect, AState);

   { Make cells 3D style }
   if DefaultDrawing then Draw3DLines(ARect, ACol, ARow, AState);

   drawingCell:= False;

end;

function TwwDBGrid.CanEditGrid: Boolean;
begin
  result:= (dgEditing in Options) and (not ReadOnly)
end;

{ Override so checkboxes in grid don't show underlying text }
function TwwDBGrid.IsWWControl(ACol, ARow: integer): boolean;
var fldName: string;
    ControlType, Parameters: string;
begin
   result:= False;
   if not isValidCell(ACol, ARow) then exit;
   fldName:= DataLink.fields[dbCol(ACol)].fieldName;
   WWDataSet_GetControl(DataSource.DataSet, FldName, ControlType, Parameters);
   result:= (ControlType='Bitmap') or (ControlType='CheckBox') or
            isWWEditControl(ControlType);
end;

function TwwDBGrid.CanEditShow: Boolean;
begin
   Result:= inherited CanEditShow;

   if Result then
   begin
      if (dgAlwaysShowEditor in Options) and not Focused and
          (inplaceEditor<>Nil) and not inplaceEditor.visible then
         Result:= False {(ValidParentForm(Self).ActiveControl = Self)}
      else if isWWControl(col, row) then result:= False
      else if isMemoField(col, row) then result:= False;
   end
end;

{ Update checkbox }
procedure TwwDBGrid.SetFieldValue(ACol: Integer; val: string);
begin
  if (ACol >= 0) and Datalink.Active and (ACol < DataLink.FieldCount) then
    Datalink.Fields[ACol].Text:= Val;
end;


Function TwwDBGrid.FieldName(Acol: integer): string;
var Field: TField;
begin
   Result:= '';
   Field := GetColField(dbCol(Acol));
   if (Field = nil) then exit;
   result:= Field.fieldName;
end;

   Function TwwDBGrid.GetComponent(thisName: string): TCustomEdit;
   var component: TComponent;
       form: TCustomForm;
   begin
      result:= Nil;
      if ecoSearchOwnerForm in FEditControlOptions then form:= wwGetOwnerForm(self)
      else form:= GetParentForm(self);
      if form=nil then exit; { 5/2/97 }

      { 5/2/97 - Also search owner of dataset form }
      component:= nil;
      if pos('.', thisName)>0 then begin
         if (length(StrTrailing(thisName,'.'))>0) then begin
            if (DataSource=nil) or (DataSource.DataSet=Nil) or
               (DataSource.DataSet.owner=nil) then exit;
            component:= DataSource.Dataset.owner.FindComponent(strTrailing(thisName,'.'));
         end
      end
      else component:= Form.FindComponent(thisName);
      if (component<>Nil) and (component is TCustomEdit) then
         result:= TCustomEdit(component);

   end;


function TwwDBGrid.IsRichEditCell(
        col, row: integer;
        var customEdit: TCustomEdit) : boolean;
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
      if parts.count<2 then continue;
      if parts[0]<>fldName then continue;
      if parts[1]='RichEdit' then begin
         customEdit:= GetComponent(parts[2]);
	 result:= True;
	 break;
      end
   end;

   parts.free;
end;

function TwwDBGrid.IsCustomEditCell(
        col, row: integer;
        var customEdit: TCustomEdit) : boolean;
var fldName: string;
    i: integer;
    parts : TStrings;
begin
   result:= False;

   if not isValidCell(col, row) then exit;

   fldName:= DataLink.fields[dbCol(col)].fieldName;
   parts:= TStringList.create;

   with dataSource do begin
      for i:= 0 to wwGetControlType(dataSet).count-1 do begin
         strBreakapart(wwGetControlType(dataSet)[i], ';', parts);
         if parts.count<2 then continue;
         if parts[0]<>fldName then continue;
         if isWWEditControl(parts[1]) then begin
            customEdit:= GetComponent(parts[2]);
            if customEdit=Nil then break;
            if wwisClass(GetParentForm(customEdit).classType, 'TwwRecordViewForm') then break;
            result:= True;
            break;
         end
      end
   end;

   parts.free;
end;

procedure TwwDBGrid.SetControlType(AFieldName: string; AComponentType: TwwFieldControlType;
        AParameters: string);
var componentTypeStr: string;
    customEdit: TCustomEdit;
begin
   case AComponentType of
     fctNone, fctField: componentTypeStr:= '';
     fctCustom, fctComboBox, fctLookupCombo: begin
         componentTypeStr:=WW_DB_EDIT;
         customEdit:= GetComponent(AParameters);  { 1/22/97 - Change customEdit properties immediately }
         if customEdit<>Nil then begin
            customEdit.visible:= False;
            customEdit.parent:= self;

            wwSetControlDataSource(customEdit, dataSource);
            wwSetControlDataField(customEdit, AFieldName);

            {  !!!!! Cheating casts to make protected properties public}
            TwwDBEdit(customEdit).ctl3d:= False;
            TwwDBEdit(customEdit).font:= self.font;
            TwwDBEdit(customEdit).BorderStyle:= bsNone;
         end
       end;
     fctCheckbox: componentTypeStr:= 'CheckBox';
     fctBitmap: componentTypeStr:= 'Bitmap';
     fctRichEdit: componentTypeStr:= 'RichEdit';
     else componentTypeStr:= '';
   end;

   wwDataSet_SetControl(dataSource.dataSet,
      AFieldName, componentTypeStr, AParameters);
end;

procedure TwwDBGrid.RefreshDisplay;
begin
   doneInitControls:= False;
   InitControls;
   LayoutChanged;
end;

{ Initialize controls to have the following attributes }
{ 1. This grid as parent
{ 2. Visible is False
{ 3. DataSource is this grid's datasource
{ 4. Set field later at time it is shown
}
{4/28/97 - Allow the same control to be attached more than once }
procedure TwwDBGrid.InitControls;
var
    i: integer;
    parts : TStrings;
    dbLookupComboBox: TCustomEdit;
begin
   if (doneInitcontrols) and not (csDesigning in ComponentState) then exit;
   if (dataSource=Nil) then exit;
   if (dataSource.dataSet=Nil) then exit;
   if (csLoading in ComponentState) then exit;
   if not GridIsLoaded then exit;

   parts:= TStringList.create;

   with dataSource do begin
      for i:= 0 to wwGetControlType(dataSet).count-1 do begin
         strBreakapart(wwGetControlType(dataSet)[i], ';', parts);
         if parts.count<2 then continue;

         if isWWEditControl(parts[1]) or (parts[1]='RichEdit') then begin
            dbLookupComboBox:= GetComponent(parts[2]);
            if (dbLookupComboBox<>Nil) then begin
               if (csDesigning in ComponentState) then continue;
               dbLookupComboBox.visible:= False;
               dbLookupComboBox.parent:= self;
               wwSetControlDataSource(dbLookupComboBox, self.dataSource);
               wwSetControlDataField(dbLookupComboBox, parts[0]);

               {  !!!!! Cheating casts to make protected properties public}
               TwwDBEdit(dbLookupComboBox).ctl3d:= False;
               TwwDBEdit(dbLookupComboBox).font:= self.font;
               TwwDBEdit(dbLookupComboBox).BorderStyle:= bsNone;
            end
         end
      end;
   end;

   doneInitControls:= True;
   parts.free;
end;

procedure TwwDBGrid.CMCtl3DChanged(var Message: TMessage);
begin
   if csFramed in ControlStyle then redrawGrid;
end;

procedure TwwDBGrid.ColExit;
begin
   inherited colExit;

   if not (csDesigning in ComponentState) and
          ((ValidParentForm(Self).ActiveControl = Self) or
           (ValidParentForm(Self).ActiveControl = currentCustomEdit)) then  { Hide customedit }
   begin
      if currentCustomEdit<>Nil then
      begin
         HideControls;
      end
   end;
end;

{ This code necessary to handle when column has changed when the combobox
  has focus }
procedure TwwDBGrid.TopLeftChanged;
var Loc: TRect;
   Procedure ResetTopRow(val: integer);
   begin
      inTopLeftChanged:= True;
      TopRow:= val;
      inTopLeftchanged:= False;
   end;

begin
   if inTopLeftChanged then exit;

   if dgRowSelect in Options then begin { 8/13/96 Fix - Override toprow in case TCustomGrid changed it }
      if (dgTitles in Options) then begin
         if (TopRow<>1) then ResetTopRow(1)
      end
      else if (TopRow<>0) then ResetTopRow(0);
   end;

   inherited TopLeftChanged;

   if (currentCustomEdit<>Nil) then begin
     if currentCustomEdit.visible then begin
        Loc:= CellRect(Col, Row);
        if IsRectEmpty(Loc) then currentCustomEdit.Hide
        else begin
           if not sameRect(currentCustomEdit.BoundsRect, CellRect(col, row)) then
           begin
              HideControls;
              Invalidate;
           end
        end
     end
   end;

end;

{ Override so it allows column resizing in design mode even when DefaultFields is True }
procedure TwwDBGrid.CMDesignHitTest(var Msg: TCMDesignHitTest);
var yTitleOffset: integer;
begin
  Msg.Result := Longint(BOOL(Sizing(Msg.Pos.X, Msg.Pos.Y)));

  if dgTitles in Options then yTitleOffset:= 1
  else yTitleOffset:= 0;

  if Msg.Result = 0 then
    with MouseCoord(Msg.Pos.X, Msg.Pos.Y) do
      if (X >= xIndicatorOffset) and (Y < yTitleOffset) then Msg.Result := 1;

  if (Msg.Result = 1) and ((DataLink = nil) or
    not DataLink.Active) then
    Msg.Result := 0;
end;

procedure TwwDBGrid.SelectRecordRange(bkmrk1, bkmrk2: TBookmark);
var
   curBookmark: Tbookmark;
   res: CmpBkmkRslt;
   ScrollCount, currentrow, moveByCount: integer;

   Function LessThan(bookmark1, bookmark2: TBookmark): boolean;
   begin
       res:= wwDataSetCompareBookmarks(DataSource.DataSet, bookmark1, bookmark2);
{       dbiCompareBookmarks((datasource.dataset as TDBDataSet).handle, bookmark1, bookmark2, res);}
       result:= integer(res)=CmpLESS;
   end;

begin
   with DataLink.Dataset do begin
      currentRow:= GetActiveRow;

      DisableControls;


      if Lessthan(bkmrk1, bkmrk2) then
      begin
         RemoveSelected(bkmrk1, bkmrk2); { Remove all selected records in range before selecting}
         curBookmark:= GetBookmark;
         bookmarks.add(curBookmark);

         while Lessthan(curBookmark, bkmrk2) do
         begin
            Next;
            curBookmark:= GetBookmark;
            bookmarks.add(curBookmark);
         end;
         Gotobookmark(bkmrk1);
      end
      else begin
         RemoveSelected(bkmrk2, bkmrk1); { Remove all selected records in range before selecting}
         Gotobookmark(bkmrk2);

         curBookmark:= GetBookmark;
         bookmarks.add(curBookmark);

         while Lessthan(curBookmark, bkmrk1) do
         begin
            if DataLink.ActiveRecord<VisibleRowCount-1 then
               DataLink.ActiveRecord:= DataLink.ActiveRecord + 1
            else begin
               Next;
            end;

            curBookmark:= GetBookmark;
            bookmarks.add(curBookmark);
         end
      end;

      Freebookmark(bkmrk1);
      EnableControls;       { Updates display controls }
      DisableControls;      { Disable them during setting of active row }

      { Maintain current row so grid doesn't jump}
      if GetActiveRow<currentRow then
      begin
         ScrollCount:= CurrentRow-GetActiveRow;
         MoveByCount:= -(GetActiveRow + ScrollCount);
         if MoveByCount<>0 then begin
            MoveBy(MoveByCount);
            SetActiveRow(CurrentRow);
         end;
      end
      else begin
         ScrollCount:= GetActiveRow-currentRow;
         MoveByCount:= ((VisibleRowCount-1)-GetActiveRow) + ScrollCount;
         If MoveByCount<>0 then begin
            MoveBy(MoveByCount);
            SetActiveRow(CurrentRow);
         end;
      end;
      EnableControls;
   end;
end;

procedure TwwDBGrid.MouseUp(Button: TMouseButton; shift: TShiftState; x, y: integer);
begin
   inherited MouseUp(Button, shift, x, y);
end;


procedure TwwDBGrid.MouseDown(Button: TMouseButton; shift: TShiftState; x, y: integer);
var Coord: TGridCoord;
    lookupControl: TCustomEdit;
    doubleClicking: boolean;
    TempShiftSelectMode: boolean;
    TempShiftSelectBookmark: TBookmark;
begin
   TempShiftSelectMode:= ShiftSelectMode;
   TempShiftSelectBookmark:= ShiftSelectBookmark;

   Doubleclicking:= ssDouble in shift;  { save state before calling inherited class }

   inherited MouseDown(Button, shift, x, y);

   if (Button = mbLeft) then begin
      update;  {Allow screen repaints to finish before continuing }

      Coord:= MouseCoord(x,y);
      if (not CanEditGrid) and
          not (isSelectedCheckbox(Coord.x) or (dgMultiSelect in Options)) then exit;
      if not (isValidCell(Coord.x, Coord.y)) then exit;

      if doubleClicking then begin
         if not (ecoCheckboxSingleClick in FEditControlOptions) then begin
            ToggleCheckBox(Coord.x, Coord.y);
            update;
         end
      end
      else begin
         if (ecoCheckboxSingleClick in FEditControlOptions) then begin
            ToggleCheckBox(Coord.x, Coord.y);
            update;
         end
      end;

      { Draw combo area since mouse doesn't invalidate area if activerecord has not changed }
      if (isCustomEditCell(Coord.x, Coord.y, lookupControl) and not lookupControl.visible) then
      begin
         if (Coord.x=Col) and (Coord.y=Row) then {is Selected Cell}
            DrawCell(Coord.x, Coord.y, CellRect(Coord.x, Coord.y), [gdSelected]);
      end;

      if (dgMultiSelect in Options) and (ssShift in Shift) and TempShiftSelectMode then
      begin
         with Datalink.Dataset do begin
           SelectRecordRange(GetBookmark, TempShiftSelectBookmark);
         end
      end;

   end
end;

procedure TwwDBGrid.WMChar(var Msg: TWMChar);
var lookupControl: TCustomEdit;
begin
   if isMemoField(col, row) or
      isWWControl(col, row) then
   begin
      if canEditGrid and (Char(Msg.CharCode) in [^H, #32..#255]) then
      begin
         if isCustomEditCell(col, row, lookupControl) then begin
            if lookupControl.visible then
            begin
               lookupControl.setFocus;
               lookupControl.selectAll; {2.0}
               PostMessage(lookupControl.Handle, WM_CHAR, Word(Msg.Charcode), 0);
            end
         end
      end;

      exit;
   end;
   inherited;
end;

procedure TwwDBGrid.CallMemoDialog;
var  memoDlg: TwwMemoDialog;
     cancel: boolean;
begin
   if (mDisableDialog in MemoAttributes) then exit;

   memoDlg:= TwwMemoDialog.create(self);
   try
      memoDlg.dataSource:= dataSource;
      memoDlg.dataField:= fieldName(col);
      memoDlg.MemoAttributes:= FMemoAttributes;
      memoDlg.Caption:= strReplaceChar(Datalink.fields[dbCol(col)].DisplayLabel, '~', ' ');
      memoDlg.Font:= font;
      memoDlg.DlgLeft:= -1; { leave as default size }

      if (not canEditGrid) or (DataLink.fields[dbCol(col)].ReadOnly) then
         memoDlg.memoAttributes:= memoDlg.memoAttributes + [mViewOnly];
      if Assigned(FOnMemoOpen) then FOnMemoOpen(self, memoDlg);
      cancel:= not memoDlg.execute;
      if Assigned(FOnMemoClose) then FOnMemoClose(self, cancel);
   finally
      memoDlg.free;
      DrawCell(col, row, CellRect(col, row), [gdSelected]);
      EditorMode := False;  {2.0}
   end;
end;

{ Override to support memo editing when F2 is entered }
procedure TwwDBGrid.KeyDown(var key: word; shift: TShiftState);
var wwControl: TCustomEdit;
begin

  case Key of
    VK_DOWN:
       if isCustomEditCell(col, row, wwControl) and (ssAlt in shift) and (wwControl.visible) then
       begin
          wwControl.setFocus;
          wwPlayKeystroke(wwControl.Handle, key, VK_MENU);
          key:= 0;
       end
   end;

   inherited KeyDown(key, shift);
   if not DataLink.Active or not CanGridAcceptKey(key, shift) then exit;

   if (not isMemoField(col, row)) and (not canEditGrid) and
      (not isSelectedCheckbox(col)) then exit;

   if isCheckBox(col, row, dummy1, dummy2) then begin
      if Key = VK_SPACE then TogglecheckBox(col, row);
   end
   else if isCustomEditCell(col, row, wwControl) then begin
      if (Key = VK_F2) and (wwControl.visible) then
         wwControl.setFocus;
      if wwControl is TwwDBCustomEdit then
      begin
         if wwIsValidChar(Key) then
         begin
            if wwControl.visible then
            begin
               wwControl.setFocus;
               TwwDBCustomEdit(wwControl).KeyDown(Key, shift);  {8/22/96}
            end
         end
      end
   end
   else if isRichEditCell(col, row, wwControl) then
   begin
      if Key <> VK_F2 then exit;
      if (wwControl=Nil) then exit;
      SendMessage(wwControl.Handle, WM_KEYDOWN, VK_F2, 0); { (wwControl as TwwDBRichEdit).execute;}
      InvalidateCell(col, row);
   end
   else if isMemoField(col, row) then begin  { 12/20/96 - Move this test at the end to give customeeditor priority }
      if Key <> VK_F2 then exit;
      CallMemoDialog;
      InvalidateCell(col, row);
   end
end;

procedure TwwDBGrid.WMLButtonDblClk(var Msg:TWMLButtonDblClk);
var Coord: TGridCoord;
    col, row: integer;
    wwControl: TCustomEdit;
begin
   Coord:= MouseCoord(Msg.xpos, Msg.yPos);
   col:= Coord.x;
   row:= Coord.y;
   if isRichEditCell(col, row, wwControl) then begin
      inherited;
      if (wwControl<>Nil) then
         SendMessage(wwControl.Handle, WM_KEYDOWN, VK_F2, 0); { (wwControl as TwwDBRichEdit).execute;}
   end
   else if isMemoField(col, row) then
   begin
      inherited;  { Move before CallMemoDialog }
      CallMemoDialog;
   end
   else inherited;
end;

procedure TwwDBGrid.ToggleCheckBox(col, row: integer);
var
    dbColumn: integer;
    value: string;
    checkBoxOn, checkBoxOff: string;
    tempField: TField;
begin
   if not isCheckBox(col, row, checkBoxOn, checkBoxOff) then exit;

   dbColumn:= dbCol(col);

   if (DataLink.fields[dbColumn].ReadOnly) then exit;
   if (not DataSource.autoEdit) and
      (not (DataSource.state in [dsEdit, dsInsert])) then exit;

   { if AutoEdit }
   tempField:=GetColField(dbColumn);
   if (tempField.calculated) and (lowercase(tempField.fieldName)='selected') then
   begin
      if isSelected then UnselectRecord
      else SelectRecord;
   end
   else begin
      DataLink.Edit;
      value:= GetFieldValue(dbColumn);
      if value=checkBoxOn then SetFieldValue(dbColumn, checkBoxOff)
      else SetFieldValue(dbColumn, checkBoxOn);
      DrawCell(col, row, CellRect(col, row), [gdSelected]);
   end;

end;

Function TwwDBGrid.GetRowCount: integer;
begin
   result:= rowCount;
end;

Function TwwDBGrid.GetColCount: integer;
begin
   result:= colCount;
end;

Function TwwDBGrid.GetActiveRow: integer;
begin
   result:= dbRow(row);
end;

Function TwwDBGrid.GetActiveCol: integer;
begin
   result:= col;
end;

Function TwwDBGrid.GetActiveField: TField;
begin
   result:= GetColField(dbCol(Col));
end;

Procedure TwwDBGrid.SetActiveField(AFieldName: string);
var ACol: integer;
    curField: TField;
begin
   if not Datalink.Active then exit;

   for ACol:= 0 to colCount-1 do begin
      curField:= GetColField(ACol);
      if curField=Nil then continue;
      if lowercase(curField.FieldName)=lowercase(AFieldName) then begin
         SelectedIndex:= ACol;
         break;
      end
   end
end;

procedure TwwDBGrid.ColWidthsChanged;
begin
  inherited ColWidthsChanged;
end;

procedure TwwDBGrid.ColumnMoved(FromIndex, ToIndex: Longint);
begin
   HideControls;
   inherited ColumnMoved(FromIndex, toIndex);
end;

Function isControlInGrid(col: integer): boolean;
begin
   result:= False;
end;

constructor TwwMemoDialog.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
   FDataLink := TFieldDataLink.Create;
  FMemoAttributes:= [mWordWrap, mSizeable];
  FFont:= TFont.create;
  DlgWidth:= 561;
  DlgHeight:= 396;
  DlgLeft:= 0; { center dialog }
  DlgTop:= 0;
end;

destructor TwwMemoDialog.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FFont.Free;
  inherited Destroy;
end;

Function TwwMemoDialog.getDataSource: TDataSource;
begin
   Result:= FdataLink.dataSource;
end;

procedure TwwMemoDialog.SetDataSource(value: TDataSource);
begin
   FDataLink.DataSource:= value;
end;

procedure TwwMemoDialog.SetDataField(value: String);
begin
   FDataLink.fieldName:= value;
end;

function TwwMemoDialog.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TwwMemoDialog.setFont(Value: TFont);
begin
    FFont.assign(Value);
end;

procedure TwwMemoDialog.setCaption(Value: String);
begin
   FCaption:= value;
end;

function TwwMemoDialog.Execute: boolean;
begin
   result:= wwEditMemoField(Screen.ActiveForm, self, not(mViewOnly in MemoAttributes))
end;

procedure TwwMemoDialog.setwwMemoAttributes(sel : TwwMemoAttributes);
begin
     FMemoAttributes:= sel;
end;

Procedure TwwMemoDialog.DoInitDialog;
begin
  if Assigned(FOnInitDialog) then OnInitDialog(Form);
end;

Procedure TwwMemoDialog.DoCloseDialog;
begin
  if Assigned(FOnCloseDialog) then OnCloseDialog(Form);
end;

{Function TwwDBGrid.GetControlDataSource(ctrl: TWinControl): TDataSource;
begin
   if (ctrl is TwwDBCustomLookupCombo) then
      result:= TwwDBCustomLookupCombo(ctrl).dataSource
   else if (ctrl is TwwDBCustomEdit) then
      result:= TwwDBCustomEdit(ctrl).dataSource
   else result:= nil;
end;

Function TwwDBGrid.GetControlDataField(ctrl: TWinControl): string;
begin
   if (ctrl is TwwDBCustomLookupCombo) then
      result:= TwwDBCustomLookupCombo(ctrl).dataField
   else if (ctrl is TwwDBCustomEdit) then
      result:= TwwDBCustomEdit(ctrl).dataField
   else result:= '';
end;

Procedure TwwDBGrid.SetControlDataSource(ctrl: TWinControl; ds: TwwDataSource);
begin
   if (ctrl is TwwDBCustomLookupCombo) then
      (ctrl as TwwDBCustomLookupCombo).dataSource:= ds
   else if (ctrl is TwwDBCustomEdit) then
      (ctrl as TwwDBCustomEdit).dataSource:= ds;
end;

Procedure TwwDBGrid.SetControlDataField(ctrl: TWinControl; df: string);
begin
   if (ctrl is TwwDBCustomLookupCombo) then
      (ctrl as TwwDBCustomLookupCombo).dataField:= df
   else if (ctrl is TwwDBCustomEdit) then
      (ctrl as TwwDBCustomEdit).dataField:= df;
end;
}
Procedure TwwDBGrid.SelectAll;
var saveBK: TBookmark;
    i: integer;
begin
   with DataSource.Dataset do
   begin
      for i:= 0 to SelectedList.Count-1 do  { 6/3/97 - Clear previous bookmarks }
         FreeBookmark(SelectedList.Items[i]);
      SelectedList.Clear;

      saveBK := GetBookmark;  { Save current record position }
      DisableControls;
      First;
      while (not Eof) do begin
         SelectedList.Add(GetBookmark);
         Next;
      end;
      GotoBookmark(saveBK);  { Restore original record position}
      Freebookmark(saveBK);
      EnableControls;
   end
end;

Procedure TwwDBGrid.RemoveSelected(bkmrk1, bkmrk2: TBookmark);
var i: integer;
   Function GreaterThanOrEqual(bookmark1, bookmark2: TBookmark): boolean;
   var res: CmpBkmkRslt;
   begin
       res:= wwDataSetCompareBookmarks(DataSource.DataSet, bookmark1, bookmark2);
{       dbiCompareBookmarks((datasource.dataset as TDBDataSet).handle, bookmark1, bookmark2, res);}
       result:=
          (integer(res)=CmpGtr) or
          (integer(res)=CmpKeyEql) or
          (integer(res)=CmpEql);
   end;
begin
   with DataSource.Dataset do
   begin
      i:= 0;
      while i<=SelectedList.Count-1 do begin
         if GreaterThanOrEqual(bkmrk2, SelectedList[i]) and
            GreaterThanOrEqual(SelectedList[i], bkmrk1) then
         begin
            FreeBookmark(SelectedList.Items[i]);
            SelectedList.delete(i);
         end
         else i:= i + 1;
      end;
      invalidate;
   end
end;

Procedure TwwDBGrid.UnselectAll;
var i: integer;
begin
   with DataSource.Dataset do
   begin
      for i:= 0 to SelectedList.Count-1 do
         FreeBookmark(SelectedList.Items[i]);
      SelectedList.Clear;
      invalidate;
   end;

   { Clear cached values }
   SelectedRecordList.clear;
   for i:= 0 to VisibleRowCount-1 do
      SelectedRecordList.add('F')

end;

Procedure TwwDBGrid.UnselectRecord;
var newBookmark: TBookmark;
    accept: boolean;
begin
    if not isSelected then exit;  { Can't unselect since its not selected 6/16/96}

    accept:= True;
    if Assigned(FOnSelectRecord) then FOnSelectRecord(self, False, Accept);
    if not accept then exit;

    newBookmark:= findBookmark;
    if newBookmark<>nil then begin
       datasource.dataset.Freebookmark(newBookmark);
       bookmarks.remove(newBookmark);
       invalidateCurrentRow;
{       for i:= 0 to colCount-1 do InvalidateCell(i, row);}
    end
end;

procedure TwwDBGrid.SortSelectedList;
var res: CmpBkmkRslt;
   Function LessThan(bookmark1, bookmark2: TBookmark): boolean;
   begin
       res:= wwDataSetCompareBookmarks(DataSource.DataSet, bookmark1, bookmark2);
{       dbiCompareBookmarks((datasource.dataset as TDBDataSet).handle, bookmark1, bookmark2, res);}
       result:= integer(res)=CmpLESS;
   end;
   Function GreaterThan(bookmark1, bookmark2: TBookmark): boolean;
   begin
       res:= wwDataSetCompareBookmarks(DataSource.DataSet, bookmark1, bookmark2);
{       dbiCompareBookmarks((datasource.dataset as TDBDataSet).handle, bookmark1, bookmark2, res);}
       result:= integer(res)=CmpGtr;
   end;

   procedure Partition(var i, j: integer);
   var Pivot, Temp: TBookmark;
   begin
      Pivot:= bookmarks[(i+j) div 2];
      repeat
         while LessThan(bookmarks[i], Pivot) do i:= i + 1;
         while GreaterThan(bookmarks[j], Pivot) do j:= j - 1;
         if (i<=j) then begin
            Temp:= bookmarks[i];
            bookmarks[i]:= bookmarks[j];
            bookmarks[j]:= Temp;
            i:= i +1;
            j:= j-1;
         end
      until (i>j);
   end;

   procedure QuickSort(m, n: integer);
   var i,j: integer;
   begin
      if (m<n) then begin
         i:= m; j:= n;
         Partition(i, j);
         QuickSort(m,j);
         QuickSort(i,n);
      end
   end;
begin
    QuickSort(0, bookmarks.count-1);
end;

Procedure TwwDBGrid.SelectRecord;
var newBookmark: TBookmark;
    accept: boolean;
    
  procedure UpdateGrid;
  var j: integer;
  begin
     for j:= 0 to colCount-1 do InvalidateCell(j, row);
  end;

begin
   { 6/2/97 - Update starting shift-select record }
   if ShiftSelectMode then
   begin
      Datasource.dataset.checkBrowseMode;
      ShiftSelectBookmark:= DataSource.DataSet.GetBookmark;
   end;

   datasource.dataset.checkBrowseMode; {6/8/97 - Moved before isSelected - bookmarks don't work in edit mode}
   RefreshbookmarkList;   { 6/8/97 - Refresh before calling isSelected }

   if isSelected then exit; { Don't add if already in list 6/16/96}

   accept:= True;
   if Assigned(FOnSelectRecord) then FOnSelectRecord(self, True, Accept);
   if not accept then exit;

   newBookmark:= findBookmark;
   if newBookmark=Nil then
      newBookmark:= datasource.dataset.getBookmark;

   if (newBookmark<>nil) then bookmarks.add(newBookmark);  { 2/13/97 - Check for nil bookmark}
   InvalidateCurrentRow;

end;

Function TwwDBGrid.IsSelectedRecord: boolean;
var i: integer;
    curBookmark: Tbookmark;
    thisTable: TDataset;
    res: CmpBkmkRslt;
begin
   thisTable:= datasource.dataset;
   if (thisTable.state=dsEdit) or (thisTable.state=dsInsert) then begin
      result:= False;
      exit;
   end;

   curBookmark:= thisTable.getBookmark;

   result:= False;
   if curBookmark=Nil then exit;

   for i:= 0 to bookmarks.count-1 do begin
      res:= wwDataSetCompareBookmarks(DataSource.DataSet, bookmarks.items[i], curBookmark);
{      dbiCompareBookmarks((thisTable as TDBDataSet).handle, bookmarks.items[i],
                                            curBookmark, res);}
      if (res=CMPKeyEql) or (res=CMPEql) then begin
         result:= True;
         break;
      end
   end;

   thisTable.freebookmark(curBookmark); { Don't use finally block - too slow }

end;

procedure TwwDBGrid.RefreshBookmarkList;
var i, OldActive: integer;
begin
   SelectedRecordList.clear;
   if bookmarks.count>0 then begin
      OldActive:= 0; {Make compiler happy}
      try
         OldActive:= DataLink.ActiveRecord;
         for i:= 0 to VisibleRowCount-1 do begin
            DataLink.ActiveRecord:= i;
            if isSelectedRecord then SelectedRecordList.add('T')
            else SelectedRecordList.add('F');
         end;
         DataLink.ActiveRecord:= OldActive;
      except
         DataLink.ActiveRecord:= OldActive;
      end
   end
   else begin
      for i:= 0 to VisibleRowCount-1 do begin
         SelectedRecordList.add('F')
      end;
   end
end;

Function TwwDBGrid.IsSelected: boolean;
begin
   result:= IsSelectedRow(DataLink.ActiveRecord);
{   if (DataLink.ActiveRecord>=0) and (DataLink.ActiveRecord<SelectedRecordList.count) then
     result:= SelectedRecordList.strings[DataLink.ActiveRecord]='T'
   else result:= False;}
end;

Function TwwDBGrid.IsSelectedRow(DataRow: integer): boolean;
begin
   if (DataRow>=0) and (DataRow<SelectedRecordList.count) then
     result:= SelectedRecordList.strings[DataRow]='T'
   else result:= False;
end;

Function TwwDBGrid.FindBookmark: TBookmark;
var i: integer;
    curBookmark: Tbookmark;
    thisTable: TDataset;
    res: CmpBkmkRslt;
begin
   result:= Nil;
   thisTable:= datasource.dataset;
   curBookmark:= thisTable.getBookmark;
   if curBookmark=nil then exit;  {2/13/97 }

   try
      for i:= 0 to bookmarks.count-1 do begin
          res:= wwDataSetCompareBookmarks(DataSource.DataSet, bookmarks.items[i], curBookmark);
{          dbiCompareBookmarks((thisTable as TDBDataSet).handle, bookmarks.items[i],
                                             curBookmark, res);}
          if (res=CMPKeyEql) or (res=CMPEql) then begin
             result:= bookmarks.items[i];
             exit;
          end
      end;
   finally
      thisTable.freebookmark(curBookmark);
   end;
end;

Function TwwDBGrid.GetFieldValue(ACol: integer): string;
const MaxMemoSize = 255;
var
  Field: TField;
  Buffer: array[0..MaxMemoSize] of char;
  {$ifndef ver100} { Cannot rely on Delphi 2's TMemoField.AsString except for active record }
  numRead: LongInt;
  blobStream: TwwMemoStream;
  blobStream2: TBlobStream;  { Use when in insert mode}
  tempResult: string;
  {$endif}
  wwControl: TCustomEdit;

  Function HandleSpecialCharacters(tempResult: string; numRead: Longint): string;
  var curpos: integer;
      result1, result2: string;
  begin

     {$IFDEF WIN32}
     setLength(tempResult, numRead);
     {$ELSE}
     tempResult[0]:= char(numRead);
     {$ENDIF}

{     if WordWrap then}
     if dgWordWrap in Options then
     begin
        result:= tempResult;
        exit;
     end;

     curpos:= 1;
     result1:= strGetToken(tempResult, #13, curpos);
     curpos:= 1;
     result2:= strGetToken(tempResult, #10, curpos);
     if length(result1)<length(result2) then result:= result1
     else result:= result2;
  end;

begin
  Result := '';
  Field := GetColField(ACol);
  if Field <> nil then begin
     {$ifdef win32}
     if isRichEditCell(ACol+XIndicatorOffset, 1, wwControl) then
     begin
         if tempRichEdit=Nil then begin
            tempRichEdit:= TRichEdit.create(self);
            tempRichEdit.visible:= False;
            tempRichEdit.parent:= self;
            if csDesigning in ComponentState then {otherwise shows up at design time }
               ShowWindow(tempRichEdit.handle, sw_hide);
         end;

         if wwControl=Nil then
            tempRichEdit.Lines.Assign(Field)
         else begin
            tempRichEdit.Lines.Assign(Field);
         end;
         result:= tempRichEdit.Text;
     end
     else {$endif}
        if (Field.DataType = ftMemo) then begin

        { Don't display memo if no record }
        if (DataSource.DataSet.Bof and DataSource.dataSet.eof) and
           not (DataSource.DataSet.State = dsInsert) then
        begin
           result:= '';
           exit;
        end;

        if mGridShow in FMemoAttributes then begin
           try
              if (getActiveRow=DataLink.ActiveRecord) then
              begin
                 field.dataset.updateCursorPos;
                 {$ifdef ver100}
                 Result:= TMemoField(field).asString;
                 {$else}
                 blobStream2:= TBlobStream.create(TBlobField(field), bmRead);
                 numread:= blobStream2.read(buffer, MaxMemoSize);
                 buffer[numread]:= #0;
                 if numread = 0 then strcopy(buffer, '');
                 tempResult:= strPas(buffer);
                 blobStream2.Free;
                 result:= HandleSpecialCharacters(tempResult, numRead);
                 {$endif}
              end
              else begin
                 {$ifdef ver100}
                 Result:= TMemoField(field).asString;
                 {$else}
                 blobStream:= TwwMemoStream.create(TMemoField(Field));
                 numread:= blobStream.read(buffer, MaxMemoSize);
                 if numread = 0 then strcopy(buffer, '');
                 tempResult:= strPas(buffer);
                 result:= HandleSpecialCharacters(tempResult, numRead);
                 blobStream.Free;
                 {$endif}
              end

           except
              strcopy(buffer, '(Memo)');
              result:= strPas(buffer);
           end
        end
        else begin
           strcopy(buffer, '(Memo)');
           result:= strPas(buffer);
        end
     end
     else begin
        if (isCustomEditCell(ACol+xIndicatorOffset, 1, wwControl)) and
           (wwControl is TwwDBCustomEdit) then
        begin
            if not TwwDBCustomEdit(wwControl).GetFieldMapText(Field.asString, Result) then
               Result:= Field.DisplayText
        end
        else Result := Field.DisplayText;
     end
  end
end;

{ Set focus to this grid when changing records }
{ If focus is on currentCustomEdit then lookupcombo does not properly move }
procedure TwwDBGrid.Scroll(Distance: Integer);
begin
  if visible and (currentCustomEdit<>Nil) and
     (currentCustomEdit.visible) and currentCustomEdit.focused then
     setFocus;
  inherited Scroll(Distance);
end;

procedure TwwDBGrid.Loaded;
begin
   inherited loaded;
   GridIsLoaded:= True;
   if not DoneInitControls then RefreshDisplay;
end;

Procedure TwwDBGrid.AddDependent(value: TComponent);
begin
   FDependentComponents.add(value);
end;

Procedure TwwDBGrid.RemoveDependent(value: TComponent);
begin
   FDependentComponents.remove(value);
end;

Function TwwDBGrid.XIndicatorOffset: integer;
begin
   if dgIndicator in Options then result:= 1
   else result:= 0;
end;

Procedure TwwDBGrid.InvalidateCurrentRow;
var i :integer;
begin
    for i:= 0 to colCount-1 do InvalidateCell(i, row);
end;

Procedure TwwDBGrid.SetActiveRow(val: integer); {10/24/96 }
begin
   if dgTitles in Options then row:= val+1
   else row:= val;
   DataLink.ActiveRecord:= val;
   invalidate;
end;


procedure TwwDBGrid.ColEnter;
var CustomEdit: TCustomEdit;
begin
   if isCustomEditCell(Col, Row, customEdit) and
      (canEditGrid or AlwaysShowControls) then
   begin
      if wwGetControlDataSource(customEdit)<>datasource then
         wwSetControlDataSource(customEdit, dataSource);
      if not wwEqualStr(wwGetControlDataField(customEdit), GetActiveField.FieldName) then
         wwSetControlDataField(customEdit, GetActiveField.FieldName);
      if customEdit.parent<>self then customEdit.parent:= self;
      TEdit(customEdit).Ctl3d:= False;
      TEdit(customEdit).BorderStyle:= bsNone;
   end;

   inherited ColEnter;
end;

procedure TwwDBGrid.CalcRowHeight;
begin
   inherited CalcRowHeight;
end;

procedure TwwDBGrid.FlushChanges;
begin
   inherited FlushChanges;
   if (CurrentCustomEdit<>Nil) and (CurrentCustomEdit.visible) then
      CurrentCustomEdit.Perform(CM_Exit,0,0);
end;

procedure Register;
begin
end;

initialization
{  RegisterClass(TwwIButton);}
end.
