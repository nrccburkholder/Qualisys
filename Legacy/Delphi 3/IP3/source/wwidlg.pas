unit wwidlg;
{
//
// Components : TwwLookupDlg, TwwSearchDlg, TwwLookupComboDlg
//
// Copyright (c) 1995, 1996, 1997 by Woll2Woll Software
//
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBTables, DB, StdCtrls,
  Buttons, Wwkeycb, Wwdbgrid,
  Wwtable, Wwdblook, DsgnIntf, wwCommon, wwstr, Wwdbigrd, Wwdatsrc,
  ExtCtrls;

type
  TwwLookupDlg = class;

  TwwDBLookupDlgOption =(opShowOKCancel, opShowSearchBy, opGroupControls,
                         opFixFirstColumn, opShowStatusBar);
  TwwDBLookupDlgOptions = Set of TwwDBLookupDlgOption;

  TwwUserButtonEvent = procedure(Sender: TObject; LookupTable: TDataSet) of object;
  TwwOnInitDialogEvent = procedure(Dialog : TwwLookupDlg) of object;

  TwwLookupDlg = class(TForm)
    SearchCharacterLabel: TLabel;
    wwKeyCombo1: TwwKeyCombo;
    SortByLabel: TLabel;
    wwDBGrid1: TwwDBGrid;
    wwIncrementalSearch1: TwwIncrementalSearch;
    DataSource1: TwwDataSource;
    StatusHeader: THeader;
    UserButtonPanel: TPanel;
    UserButton1: TButton;
    UserButton2: TButton;
    procedure wwKeyCombo1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure wwKeyCombo1Enter(Sender: TObject);

    procedure wwDBGrid1DblClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure wwKeyCombo1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UserButton1Click(Sender: TObject);
    procedure UserButton2Click(Sender: TObject);
    procedure wwDBGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    {$ifdef win32}
    procedure wwDBGrid1ColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Integer);
    {$else}
    procedure wwDBGrid1ColumnMoved(Sender: TObject; FromIndex,
      ToIndex: Longint);
    {$endif}

  private
    FUserButton1Click: TwwUserButtonEvent;
    FUserButton2Click: TwwUserButtonEvent;
    FOnInitDialog: TwwOnInitDialogEvent;
    FOnCloseDialog: TwwOnInitDialogEvent;
    FSearchText: string;
    FShowingChanged: boolean;
    OrigLeft: integer;

    initialized: boolean;
    procedure AdjustColumnsToIndex;
    procedure ResizeControls(padOnly: boolean);
    procedure ApplyIntl;
    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure UpdateSearchField;

  protected
    procedure WriteStatusInfo;
    procedure DoShow; override;
    procedure Activate; override;

  public
    OKBtn: TButton;
    CancelBtn: TButton;

    MaxWidth, MaxHeight: integer;
    Options: TwwDBLookupDlgOptions;
    ClickedMemoField: boolean;
    ThisDataSet: TDataSet;

    constructor Create(AOwner: TComponent); override;

  end;

TwwCustomLookupDialog = class(TComponent)
  private
    FUserButton1Click: TwwUserButtonEvent;
    FUserButton2Click: TwwUserButtonEvent;
    FOnInitDialog: TwwOnInitDialogEvent;
    FOnCloseDialog: TwwOnInitDialogEvent;
    FUserButton1Caption: string;
    FUserButton2Caption: string;
    FUseTFields: boolean;

  protected
    FMaxWidth: integer;  { maximum width of dialog }
    FMaxHeight: integer;
    FGridTitleAlignment: TAlignment;
    FSelected : TStrings;
    FLookupTable: TDataSet;
    FSyncTable: TwwTable;
    FOptions: TwwDBLookupDlgOptions;
    FGridOptions: TwwDBGridOptions;
    FGridColor: TColor;
    FCaption: String;
    FCharCase: TEditCharCase;

    function GetSelectedFields: TStrings;
    procedure SetSelectedFields(sel : TStrings);

    procedure SetLookupTable(sel : TDataSet);
    procedure SetWWLookupTable(sel : TwwTable);
    procedure SetSyncTable(sel : TwwTable);
    function GetSyncTable: TwwTable;
    function GetLookupTable: TDataSet;
    function GetWWLookupTable: TwwTable;
    procedure SetOptions(sel: TwwDBLookupDlgOptions);
    procedure SetGridOptions(sel: TwwDBGridOptions);
    procedure Notification(AComponent: TComponent;
               Operation: TOperation); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function Execute: boolean; virtual;

    property SearchTable: TwwTable read getSyncTable write SetSyncTable;
    property Selected : TStrings read getSelectedFields write setSelectedFields;
    property GridColor: TColor read FGridColor write FGridColor;
    property Options: TwwDBLookupDlgOptions read FOptions write SetOptions
      default [opShowOKCancel, opShowSearchBy];
    property GridOptions: TwwDBGridOptions read FGridOptions write SetGridOptions
      default [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines,
      dgRowLines, dgTabs, dgConfirmDelete];
    property Caption : String read FCaption write FCaption;
    property MaxWidth : integer read FMaxWidth write FMaxWidth;
    property MaxHeight : integer read FMaxHeight write FMaxHeight;
    property CharCase: TEditCharCase read FCharCase write FCharCase;
    property GridTitleAlignment: TAlignment read FGridTitleAlignment write FGridTitleAlignment;
    property OnUserButton1Click: TwwUserButtonEvent read FUserButton1Click write FUserButton1Click;
    property OnUserButton2Click: TwwUserButtonEvent read FUserButton2Click write FUserButton2Click;
    property UserButton1Caption: string read FUserButton1Caption write FUserButton1Caption;
    property UserButton2Caption: string read FUserButton2Caption write FUserButton2Caption;
    property OnInitDialog: TwwOnInitDialogEvent read FOnInitDialog write FOnInitDialog;
    property OnCloseDialog: TwwOnInitDialogEvent read FOnCloseDialog write FOnCloseDialog;
    property UseTFields: boolean read FUseTFields write FUseTFields default True;
end;

TwwLookupDialog = class(TwwCustomLookupDialog)
  public
    Function Execute: boolean; override;
  published
    property Selected;
    property GridTitleAlignment;
    property GridColor;
    property Options;
    property GridOptions;
    property LookupTable: TDataSet read getLookupTable write SetLookupTable;
    property Caption;
    property MaxWidth;
    property MaxHeight;
    property CharCase;
    property UseTFields;
    property UserButton1Caption;
    property UserButton2Caption;
    property OnUserButton1Click;
    property OnUserButton2Click;
    property OnInitDialog;
    property OnCloseDialog;
end;

TwwSearchDialog = class(TwwCustomLookupDialog)
  published
   property Selected;
   property GridTitleAlignment;
   property GridColor;
   property Options;
   property GridOptions;
   property SearchTable;
   property ShadowSearchTable: TwwTable read GetWWLookupTable write SetWWLookupTable;
   property Caption;
   property MaxWidth;
   property MaxHeight;
   property CharCase;
   property UseTFields;
   property UserButton1Caption;
   property UserButton2Caption;
   property OnUserButton1Click;
   property OnUserButton2Click;
   property OnInitDialog;
   property OnCloseDialog;
end;

Function ExecuteWWLookupDlg(
   AParentForm: TForm;
   ASelected: TStrings;
   ADataSet: TDataSet;
   AOptions: TwwDBLookupDlgOptions;
   AGridOptions: TwwDBGridOptions;
   AGridColor: TColor;
   AGridTitleAlignment: TAlignment;
   ACaption: String;
   AMaxWidth, AMaxHeight: integer;
   ACharCase: TEditCharCase;
   AUserButton1Caption, AUserButton2Caption: string;
   AUserButton1Click, AUserButton2Click: TwwUserButtonEvent;
   AOnInitDialog: TwwOnInitDialogEvent;
   AOnCloseDialog: TwwOnInitDialogEvent;
   ASearchText: string;
   AUseTFields: boolean): boolean;

procedure Register;

implementation

uses wwmemo, wwintl,
{$ifdef win32}
bde;
{$else}
dbiprocs, dbierrs, dbitypes;
{$endif}

{$R *.DFM}

constructor TwwLookupDlg.Create(AOwner: Tcomponent);
begin
   inherited Create(AOwner);
   initialized:= False;

   MaxWidth:= 0;
   MaxHeight:= 360;

   OkBtn:= TButton(wwCreateCommonButton(Self, bkOK));
   OKBtn.TabOrder := 4;
   OKBtn.Default:= True;
   OKBtn.Top:= 600;
   OKBtn.visible:= True;
   CancelBtn:= TButton(wwCreateCommonButton(Self, bkCancel));
   CancelBtn.TabOrder := 5;
   CancelBtn.Top:= 600;
   CancelBtn.visible:= True;
end;

constructor TwwCustomLookupDialog.Create(AOwner: TComponent);
begin
   inherited create(AOwner);

   FSelected:= TStringList.create;  { Must be a TStringList type }
   FLookupTable:= Nil;
   FSyncTable:= Nil;

   FGridOptions := [dgTitles, dgIndicator, dgColumnResize, dgRowSelect,
    dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete,
    dgPerfectRowFit];
   FOptions:= [opShowOKCancel, opShowSearchBy];
   FGridColor:= clWhite;
   FGridTitleAlignment:= taLeftJustify;
   if self is TwwLookupDialog then FCaption:= 'Lookup'
   else FCaption:= 'Search';
   FMaxHeight:= 209;
   FUseTFields:= True;
end;

destructor TwwCustomLookupDialog.Destroy;
begin
   FSelected.Free;
   FSelected := Nil;
   inherited Destroy;
end;

procedure ReadFromTableComponent(ListHandle: TStrings; dataSet: TDataSet);
var calcString: string;
    i: integer;
begin
    ListHandle.clear;
    with dataSet do begin
       if not Active then begin
          MessageDlg('DataSet for this component must be active.', mtInformation, [mbok], 0);
          exit;
       end;

       for i:= 0 to fieldCount-1 do begin
         if (fields[i].visible) then begin
             if fields[i].calculated then calcString:= 'Yes'
             else calcString:= 'No';
             ListHandle.add(fields[i].fieldName + #9 +
                      inttostr(fields[i].displayWidth) + #9 +
                      fields[i].displayLabel + #9 + calcString);
          end;
       end
   end;
end;

Function ExecuteWWLookupDlg(
   AParentForm: TForm;
   ASelected: TStrings;
   ADataSet: TDataSet;
   AOptions: TwwDBLookupDlgOptions;
   AGridOptions: TwwDBGridOptions;
   AGridColor: TColor;
   AGridTitleAlignment: TAlignment;
   ACaption: String;
   AMaxWidth, AMaxHeight: integer;
   ACharCase: TEditCharCase;
   AUserButton1Caption, AUserButton2Caption: string;
   AUserButton1Click, AUserButton2Click: TwwUserButtonEvent;
   AOnInitDialog: TwwOnInitDialogEvent;
   AOnCloseDialog: TwwOnInitDialogEvent;
   ASearchText: string;
   AUseTFields: boolean): boolean;
var TempResult: boolean;
begin
   TempResult:= False;

   with TwwLookupDlg.create(Application) do
   try
      Caption:= ACaption;

      if (AParentForm<>Nil) and (AParentForm.FormStyle=fsStayOnTop) then
         FormStyle:= fsStayOnTop;

      if (ASelected<>Nil) and (Aselected.count=0) then Aselected:=Nil; {Read field list from Table }

      if ASelected <>Nil then wwDBGrid1.selected:= ASelected
      else ReadFromTableComponent(wwDBGrid1.selected, ADataSet);

      wwDBGrid1.useTFields:= AUseTFields;
      wwDBGrid1.Options:= AGridOptions;
      if (dgMultiSelect in wwDBGrid1.options) then
         wwDBGrid1.multiSelectOptions:= [msoAutoUnselect, msoShiftSelect];
      wwDBGrid1.Color:= AGridColor;
      wwDBGrid1.TitleAlignment:= AGridTitleAlignment;
      ThisDataSet:= ADataSet;

      if (ASelected<>Nil) and AUseTFields then wwDataSetUpdateFieldProperties(ADataSet, ASelected);
      Options:= AOptions;
      MaxWidth:= AMaxWidth;
      MaxHeight:= AMaxHeight;
      wwIncrementalSearch1.CharCase:= ACharCase;
      FSearchText:= ASearchText;
      if (opFixFirstColumn in AOptions) then begin
         wwDBGrid1.FixedCols:= 1;
      end
      else begin
         wwDBGrid1.FixedCols:= 0;
      end;
      FUserButton1Click:= AUserButton1Click;
      FUserButton2Click:= AUserButton2Click;
      FOnInitDialog:= AOnInitDialog;
      FOnCloseDialog:= AOnCloseDialog;
      UserButton1.caption:= AUserButton1Caption;
      UserButton2.caption:= AUserButton2Caption;
      TempResult := ShowModal = IDOK;
   finally
      dataSource1.DataSet:= Nil;
      Free;
      Result:= TempResult;
   end;
end;

Function TwwLookupDialog.Execute: boolean;
begin
   Result:= False;

   if (FlookupTable=Nil) then begin
      MessageDlg('You must define a lookupTable.', mtWarning, [mbok], 0);
      exit;
   end;

   if (not LookupTable.active) then
   begin
      MessageDlg('Search Table is not active.',  mtWarning, [mbok], 0);
      exit;
   end;

   result:=  ExecuteWWLookupDlg(Screen.ActiveForm, FSelected, LookupTable, Options, GridOptions,
                                GridColor, GridTitleAlignment, FCaption, FMaxWidth, FMaxHeight, FCharCase,
                                FUserButton1Caption, FUserButton2Caption,
                                FUserButton1Click, FUserButton2Click, FOnInitDialog,
                                FOnCloseDialog, '', UseTFields);

end;

Function TwwCustomLookupDialog.Execute: boolean;
var
   tempLookupTable: TwwTable;
begin
   Result:= False;

   if (FlookupTable=Nil) then begin
      if self is TwwLookupDialog then begin
         MessageDlg('You must define a lookupTable.', mtWarning, [mbok], 0);
         exit;
      end
      else begin
         tempLookupTable:= FSyncTable;
      end
   end
   else tempLookupTable:= FLookupTable as TwwTable;

   if (FSyncTable<>Nil) and (FSyncTable=FLookupTable) then begin
      MessageDlg('Your SearchTable and ShadowSearchTable must reference two' +
                 ' distinct TwwTable objects, but each must reference the same ' +
                 'physical table.',
                 mtWarning, [mbok], 0);
      exit;
   end;

   { 5/28/97}
   if (FSyncTable<>Nil) and not (FSyncTable is TwwTable) then begin
      MessageDlg('The SearchDialog requires TwwTable objects',
                 mtWarning, [mbok], 0);
      exit;
   end;


   if (FSyncTable<>Nil) and
      ((Uppercase(FSyncTable.databaseName)<>Uppercase(tempLookupTable.databasename)) or
       (Uppercase(FSyncTable.tableName)<>Uppercase(tempLookupTable.tablename))) then
   begin
      MessageDlg('Your SearchTable and ShadowSearchTable must reference two' +
                 ' distinct TwwTable objects, and each must reference the same ' +
                 'physical table.',
                 mtWarning, [mbok], 0);
      exit;
   end;

   if tempLookupTable.database=Nil then
   begin
      MessageDlg('Unable to open search or lookup table.',
                 mtWarning, [mbok], 0);
      exit;
   end;

   if (not tempLookupTable.active) or
      ((FSyncTable<>Nil) and (not FSyncTable.active)) then
   begin
      MessageDlg('Search Table is not active.',  mtWarning, [mbok], 0);
      exit;
   end;

   if FSyncTable<>Nil then begin
      if tempLookupTable.database.isSQLBased and tempLookupTable.SyncSQLByRange then
      begin
         tempLookupTable.syncSQLTable(FSyncTable);
      end
      else if tempLookupTable.NarrowSearch then tempLookupTable.CancelRange;

      try
         if (FSyncTable<>tempLookupTable) then tempLookupTable.gotoCurrent(FSyncTable);
      except
      end;
   end;

   if FSyncTable = tempLookupTable then begin
      result:=  ExecuteWWLookupDlg(Screen.ActiveForm, Nil, tempLookupTable, Options, GridOptions,
                                GridColor, GridTitleAlignment, FCaption, FMaxWidth, FMaxHeight, FCharCase,
                                FUserButton1Caption, FUserButton2Caption,
                                FUserButton1Click, FUserButton2Click, FOnInitDialog,
                                FOnCloseDialog, '', UseTFields)
   end
   else result:=  ExecuteWWLookupDlg(Screen.ActiveForm, FSelected, tempLookupTable, Options, GridOptions,
                                GridColor, GridTitleAlignment, FCaption, FMaxWidth, FMaxHeight, FCharCase,
                                FUserButton1Caption, FUserButton2Caption,
                                FUserButton1Click, FUserButton2Click, FOnInitDialog,
                                FOnCloseDialog, '', UseTFields);

   if result then begin
      if FSyncTable<>Nil then begin
         if (FSyncTable.database.isSqlBased) and (FSyncTable.SyncSQLByRange) then
            FSyncTable.SyncSQLTable(tempLookupTable);
         If not (tempLookupTable.eof and tempLookupTable.bof) then
            FSyncTable.gotoCurrent(tempLookupTable);
      end;
   end
end;

function TwwCustomLookupDialog.GetSelectedFields: TStrings;
begin
    result:= FSelected;
end;

procedure TwwCustomLookupDialog.SetSelectedFields(sel : TStrings);
begin
    FSelected.assign(sel);
end;

procedure TwwCustomLookupDialog.SetLookupTable(sel : TDataSet);
begin
   FLookupTable:= sel;
end;

procedure TwwCustomLookupDialog.SetWWLookupTable(sel : TwwTable);
begin
   FLookupTable:= sel as TDataSet
end;

procedure TwwCustomLookupDialog.SetSyncTable(sel : TwwTable);
begin
   FSyncTable:= sel;
end;

Function TwwCustomLookupDialog.GetSyncTable: TwwTable;
begin
   result:= FSyncTable;
end;

Function TwwCustomLookupDialog.GetLookupTable: TDataSet;
begin
   result:= FLookupTable;
end;

Function TwwCustomLookupDialog.GetWWLookupTable: TwwTable;
begin
   result:= FLookupTable as TwwTable;
end;

procedure TwwCustomLookupDialog.SetOptions(sel: TwwDBLookupDlgOptions);
begin
   FOptions:= sel;
end;

procedure TwwCustomLookupDialog.SetGridOptions(sel: TwwDBGridOptions);
begin
   FGridOptions:= sel;
end;

  procedure TwwLookupDlg.writeStatusInfo;
  var recNumber, recCount: longint;
      tempTableName: string;
  begin
    if Showing then Update; { Fixes canvas font }
    with (DataSource1) do begin
       if not (dataset is TwwTable) then exit;
       with (dataSet as TwwTable) do begin
         if isSequencable then begin
            UpdateCursorPos;
            if dbiGetSeqNo(Handle, recNumber)<>0 then exit;
            if dbiGetRecordCount(Handle, recCount)<>0 then exit;

            tempTableName:= tableName;
            strStripTrailing(temptableName, [' ']);
            StatusHeader.sections[0]:= tempTableName;
            StatusHeader.sections[1]:=
              wwInternational.SearchDialog.StatusRecLabel + ' ' +
              inttostr(recNumber) + ' ' +
              wwInternational.SearchDialog.StatusOfLabel + ' ' +
              inttostr(recCount);
         end
       end
    end
  end;


procedure TwwLookupDlg.Activate;
begin
   if not initialized then
   begin
      if wwIncrementalSearch1.visible then wwIncrementalSearch1.SetFocus;
      WriteStatusInfo;
      initialized:= True;
      if (FSearchText<>'') then
         wwIncrementalSearch1.text:= FSearchText;

      if wwIncrementalSearch1.text<>'' then
         wwIncrementalSearch1.selStart:= length(wwIncrementalSearch1.text);
   end;

   inherited Activate;
end;

procedure TwwLookupDlg.UpdateSearchField;
begin
   if (not wwdbgrid1.useTFields) then begin
     if (not (DataSource1.dataset is TTable)) or ((DataSource1.dataset as TwwTable).IndexFieldCount=0) then
     begin
        wwIncrementalSearch1.SearchField:= wwdbgrid1.fields[0].FieldName;
     end;
   end
end;

procedure TwwLookupDlg.AdjustColumnsToIndex;
var i: integer;
    foundIndexField: boolean;
    curIndex: integer;
    index: integer;
begin
   UpdateSearchField;
   if not (DataSource1.dataset is TTable) then exit;
   foundIndexField:= false;
   wwIncrementalSearch1.setSearchField('');
   curIndex:= 0;

   { Move grid columns to match index }
   with (DataSource1.dataSet as TTable) do begin
      DisableControls;

      { reset column sizes back to starting size }
      if (indexFieldCount>0) then
         if wwDBGrid1.useTFields then
            wwDataSetUpdateFieldProperties(datasource1.dataSet, wwdbgrid1.selected);

      if wwDBGrid1.useTFields then begin
         for i:= 0 to IndexFieldCount-1 do begin
            if indexFields[i].visible then begin
               indexFields[i].index:= curIndex;
               if not foundIndexfield then begin
                  wwIncrementalSearch1.setSearchField(indexFields[i].fieldName);
                  foundIndexField:= True;
               end;
               inc(curIndex);
            end;
         end
      end
      else begin
         for i:= 0 to IndexFieldCount-1 do begin
            if wwFindSelected(wwDBGrid1.Selected, indexFields[i].FieldName, Index) then
            begin
               wwdbgrid1.Selected.Insert(0, wwDBGrid1.selected[Index]);
               wwdbgrid1.Selected.Delete(Index+1);
               if not foundIndexfield then begin
                  wwIncrementalSearch1.setSearchField(indexFields[i].fieldName);
                  foundIndexField:= True;
               end;
            end
         end;
         wwDBGrid1.ApplySelected;
      end;
      EnableControls;
   end;


end;

procedure TwwLookupDlg.wwKeyCombo1Change(Sender: TObject);
begin
   wwIncrementalSearch1.clear;
   AdjustColumnsToIndex;
   ResizeControls(True);

   if not wwKeyCombo1.droppedDown then wwIncrementalSearch1.setFocus;
end;


procedure TwwLookupDlg.ResizeControls(padOnly: boolean);
const spacing = 13;
var
   i,growByWidth, desiredSize: integer;
   lastHeight: integer;
   minWidth: integer;
   UserButtonX: integer;
   bottomPad: integer;
   totalColWidth: integer;

   Function max(x,y: integer): integer;
   begin
      if x>y then result:=x
      else result:= y;
   end;
   Function min(x,y: integer): integer;
   begin
      if x<y then result:=x
      else result:= y;
   end;
begin
   bottomPad := {36;}
      1 +
      GetSystemMetrics(SM_CYDLGFRAME)*2 + 8 +
      GetSystemMetrics(SM_CYCAPTION);  {Win95 fix }
   desiredSize:= GetSystemMetrics(SM_CXHThumb) + 1;  {Win95 fix }
{   desiredSize:= 18;}
   minWidth:= SortByLabel.width + SortByLabel.Left + 3;
   if opShowOKCancel in Options then begin
      minWidth:= OkBtn.width + CancelBtn.width + Spacing + 5;
      if (UserButton1.caption<>'')  then minWidth:= minWidth + UserButton1.width + 30;
      if (UserButton2.caption<>'')  then minWidth:= minWidth + UserButton2.width + 30;
   end
   else begin
      if (UserButton1.caption<>'') and (UserButton2.caption<>'') then
         minWidth:= max(minWidth, UserButton1.width + UserButton2.width + 35)
      else if (UserButton1.caption<>'') or (UserButton2.caption<>'') then
         minWidth:= max(minWidth, UserButton1.width + 35)
   end;

   if (opShowStatusBar in Options) then
      minWidth:= max(minWidth, StatusHeader.width);

   for i:= 0 to wwDBGrid1.getColCount-1 do
      desiredSize:= desiredSize + wwDBGrid1.colWidths[i] + wwDBGrid1.GridLineWidth;
   TotalColWidth:= desiredSize;

   if (desiredSize < minWidth) then {pad last field }
      wwDBGrid1.colWidths[wwDBGrid1.getColCount-1]:=
         wwDBGrid1.colWidths[wwDBGrid1.getColCount-1] + (minWidth - desiredSize);
   if padOnly then exit;

   If MaxWidth= 0 then MaxWidth:= Screen.width-40
   else MaxWidth:= min(MaxWidth, screen.width - 40);

   If MaxHeight= 0 then MaxHeight:= Screen.height-200
   else MaxHeight:= min(MaxHeight, screen.height - 200);
   wwDBGrid1.height:= MaxHeight;

   desiredSize:= min(desiredSize, MaxWidth);
   desiredSize:= max(desiredSize, minWidth);

   GrowByWidth:= desiredSize - wwDBGrid1.width;
   wwDBGrid1.width:= wwDBGrid1.width + GrowByWidth;

   if TotalColWidth <= wwDBGrid1.width then  { Don't show horizontal scroll bar }
      wwDBGrid1.ShowHorzScrollBar:= False;
   wwDBGrid1.DoPerfectFit;  { Adjust size before its shown }

   self.width:= self.width + GrowByWidth;

   if OrigLeft>=0 then
      self.left:= OrigLeft
   else
      self.left:= (Screen.width - self.width) div 2;

   lastHeight:= 8;

   SearchCharacterLabel.Top:= lastHeight;
{   lastHeight:= SearchCharacterLabel.Top + SearchCharacterLabel.height + 3; ?????}
   lastHeight:= SearchCharacterLabel.Top + ((13 * PixelsPerInch) div 96) + 3;
   wwIncrementalSearch1.Top:= lastHeight;
   lastHeight:= wwIncrementalSearch1.Top + wwIncrementalSearch1.height + 8;
   wwDBGrid1.Top:= lastHeight;
   lastHeight:= wwDBGrid1.top + wwDBGrid1.height;

   { Handle status bar }
   if (opShowStatusBar in Options) then with DataSource1 do
   begin
      if (dataSet<>Nil) and (dataSet is TwwTable) then begin
         with (dataSet as TwwTable) do
         begin
           if (database<>Nil) and (isSequencable) then
              StatusHeader.visible:= True
         end
      end
   end;
   if StatusHeader.visible then begin
      if (opShowOKCancel in Options) or
         (UserButton1.caption<>'') or (UserButton2.caption<>'') then
{$ifdef win32}
         statusHeader.top:= lastHeight + -1 { Seems to look aesthetically better in Win32}
{$else}
         statusHeader.top:= lastHeight + 1
{$endif}
      else statusHeader.top:= lastHeight + 10;
      statusHeader.left:= wwDBGrid1.left;
      statusHeader.width:= wwDBGrid1.width;
      lastHeight:= statusHeader.top + statusHeader.height ;
   end;

   if opShowSearchBy in Options then begin
      if opGroupControls in Options then begin
         wwIncrementalSearch1.width := (wwDBGrid1.width-20) div 2;
         SortbyLabel.visible:= True;
         wwKeyCombo1.visible:= True;
         SortByLabel.top:= SearchCharacterLabel.top;
         wwKeyCombo1.top:= wwIncrementalSearch1.top;
         wwKeyCombo1.width:= (wwDBGrid1.width - 20) div 2;
         wwKeyCombo1.left:= wwIncrementalSearch1.left + wwIncrementalSearch1.width + 20;
         SortbyLabel.left:= SearchCharacterLabel.left + wwIncrementalSearch1.width + 20;
         wwKeyCombo1.tabOrder:= 1;
      end
      else begin
         wwIncrementalSearch1.width := wwDBGrid1.width;
         SortbyLabel.visible:= True;
         wwKeyCombo1.visible:= True;
         SortByLabel.top:= lastHeight + 8;
         SortByLabel.left:= SearchCharacterLabel.left;
         wwKeyCombo1.top:= SortByLabel.height + SortBylabel.top + 3;
         wwKeyCombo1.width:= wwDBGrid1.width;
         wwKeyCombo1.left:= wwDBGrid1.left;
         lastHeight:= wwKeyCombo1.top + wwKeyCombo1.height;
      end
   end
   else begin
      wwIncrementalSearch1.width := wwDBGrid1.width;
   end;

   if (UserButton1.caption<>'') or (UserButton2.caption<>'') then begin
      UserButtonPanel.visible:= True;
      UserButtonPanel.top:= lastHeight + 5;
      UserButtonX:= 0;

      if UserButton1.caption<>'' then begin
         UserButton1.visible:= True;
         UserButton1.left:= UserButtonX + 10;
         UserButtonX := UserButton1.left + UserButton1.width;
      end;

      if UserButton2.caption<>'' then begin
         UserButton2.visible:= True;
         UserButton2.left:= UserButtonX + 15;
         UserButtonX := UserButton2.left + UserButton2.width;
      end;
      if opShowOKCancel in Options then
         UserButtonPanel.width:= UserButtonX + 10
      else UserButtonPanel.width:= wwDBGrid1.width;
   end;

   if opShowOKCancel in Options then begin
      CancelBtn.tabStop:= True;
      OkBtn.tabStop:= True;
      OkBtn.top:= lastHeight + 13;
      CancelBtn.top:= lastHeight + 13;
      OKBtn.Left:= (self.Width - 10) - ((OKBtn.Width + Spacing) * 2);
      CancelBtn.Left:= (self.Width-10) - ((OKBtn.Width + Spacing) * 1);
      if (desiredSize = minWidth) then begin
         OKBtn.Left:= OkBtn.Left + 5;
         CancelBtn.Left:= CancelBtn.Left + 5;
      end;
      self.height:= OkBtn.Top + OkBtn.height + BottomPad;
   end
   else begin
      if (UserButton1.caption<>'') or (UserButton2.caption<>'') then
         self.height:= UserButtonPanel.Top + UserButtonPanel.height + BottomPad
      else self.height:= lastHeight+BottomPad;
   end;

   if (SearchCharacterLabel.width>wwIncrementalSearch1.width) then begin
      if (opShowSearchBy in Options) and (opGroupControls in Options) then
         SearchCharacterlabel.caption:= wwInternational.SearchDialog.SearchCharShortLabel;
   end;

end;


procedure TwwLookupDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

   if ActiveControl=wwKeyCombo1 then begin
      exit;
   end;

   if Key=VK_RETURN then begin
      OkBtn.setFocus;
      ModalResult:= mrOK;
   end
   else if (Key in [VK_UP, VK_DOWN, VK_NEXT, VK_PRIOR] ) then
   begin
      wwDBGrid1.KeyDown(Key, Shift);
      Key := 0;
   end
end;


procedure Register;
begin
{  RegisterPropertyEditor(TypeInfo(TStrings),
                         TwwLookupDialog, '', TwwLookupDialogProperty);
  RegisterComponents('InfoPower', [TwwLookupDialog]);
  RegisterComponentEditor(TwwLookupDialog, TwwLookupDialogComponentEditor);
}
end;


procedure TwwLookupDlg.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
   if wwKeyCombo1.droppedDown then canClose:= False;
   if canClose then begin
      wwIncrementalSearch1.onEditTimerEvent(Sender);
      if Assigned(FOnCloseDialog) then FOnCloseDialog(self);
   end;
end;

{ Allow drop-down to close on Escape or Return }
procedure TwwLookupDlg.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (ActiveControl=wwKeyCombo1) AND
      ((key = VK_RETURN) or (key = VK_ESCAPE)) then
   begin
      wwKeyCombo1.DroppedDown:= False;
      wwIncrementalSearch1.setFocus;
   end;

end;

procedure TwwLookupDlg.wwKeyCombo1Enter(Sender: TObject);
begin
{   wwKeyCombo1.DroppedDown:= True;}
end;

procedure TwwLookupDlg.DoShow;
var wRect: TRect;
    origTop, OrigMaxWidth, OrigMaxHeight: integer;
begin
   if (not (ThisDataSet is TwwTable)) then
   begin
      Options:= Options - [opShowSearchBy];
   end;
   wRect:= wwGetWorkingRect;

   { 6/27/97 - Support modification of top, left, MaxHeight, MaxWidth during runtime }
   If MaxWidth= 0 then MaxWidth:= Screen.width-40
   else MaxWidth:= wwmin(MaxWidth, screen.width - 40);
   If MaxHeight= 0 then MaxHeight:= Screen.height-200
   else MaxHeight:= wwmin(MaxHeight, screen.height - 200);
   Top:= wwMax(0, ((wRect.top + wRect.bottom)-(MaxHeight+200)) div 2);
   Left:= ((wRect.left + wRect.right)-(MaxWidth+40)) div 2;
   OrigTop:= Top;
   OrigLeft:= Left;
   OrigMaxWidth:= MaxWidth;
   OrigMaxHeight:= MaxHeight;
   if Assigned(FOnInitDialog) and (not initialized) then begin
      FOnInitDialog(self);
      if (MaxWidth<>OrigMaxWidth) and (Left=OrigLeft) then
         Left:= ((wRect.left + wRect.right)-(MaxWidth+40)) div 2;
      if (MaxHeight<>OrigMaxHeight) and (top=OrigTop) then
         Top:= ((wRect.top + wRect.bottom)-(MaxHeight+200)) div 2;
      if Left<>OrigLeft then begin
         OrigLeft:= Left;
      end
      else OrigLeft:= -1;
   end
   else OrigLeft:= -1;

   DataSource1.DataSet:= ThisDataSet;
   ApplyIntl;
   AdjustColumnsToIndex;
   ResizeControls(False);
   if opShowSearchBy in Options then wwKeyCombo1.InitComboWithGrid(wwDBGrid1);
   inherited DoShow;
end;

procedure TwwLookupDlg.wwDBGrid1DblClick(Sender: TObject);
begin
   if (not wwDBGrid1.canEditGrid) then
      if (not ClickedMemoField) or (mDisableDialog in wwDBGrid1.MemoAttributes) then
         ModalResult := mrOK;
end;

procedure TwwLookupDlg.DataSource1DataChange(Sender: TObject;
  Field: TField);
begin
    if not StatusHeader.visible then exit;
    writeStatusInfo;
end;

procedure TwwLookupDlg.wwKeyCombo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (not (ssAlt in shift)) and (key=vk_down) and (not wwKeyCombo1.DroppedDown) then begin
      wwKeyCombo1.setFocus;
      wwKeyCombo1.DroppedDown:= True
   end
end;

procedure TwwLookupDlg.UserButton1Click(Sender: TObject);
begin
    if Assigned(FUserButton1Click) then
       FUserButton1Click(self, DataSource1.dataSet);
end;

procedure TwwLookupDlg.UserButton2Click(Sender: TObject);
begin
    if Assigned(FUserButton2Click) then
       FUserButton2Click(self, DataSource1.dataSet);
end;

procedure TwwLookupDlg.wwDBGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var coord: TGridCoord;
begin
   coord := wwDBGrid1.MouseCoord(x,y);
   clickedMemoField:= wwDBGrid1.isMemoField(Coord.x, Coord.y);
end;

procedure TwwLookupDlg.ApplyIntl;
begin
   Font.Style:= wwInternational.DialogFontStyle;
   with wwInternational.SearchDialog do begin
      SearchCharacterLabel.caption:= SearchCharLabel;
      SortBylabel.caption:= SearchByLabel;
      wwIncrementalSearch1.Hint:= SearchCharHint;
      wwKeyCombo1.Hint:= SearchByHint;
   end
end;

procedure TwwLookupDlg.CMShowingChanged(var Message: TMessage);
  {$ifdef win32}
  Function isWinNT: boolean;
  var vers: TOSVersionInfo;
  begin
      vers.dwOSVersionInfoSize := sizeOf(TOSVersionInfo);
      GetVersionEx(vers);
      result:= (vers.dwPlatformID = VER_PLATFORM_WIN32_NT);
  end;
  {$endif}

begin
   {$ifdef win32}
   if isWinNT then begin
      if not FShowingChanged then begin
         FShowingChanged:= True;
         RecreateWnd; {Avoid WinNT redraw bug }
      end
      else inherited;
   end
   else inherited;
   {$else}
   inherited;
   {$endif}
end;

procedure TwwCustomLookupDialog.Notification(AComponent: TComponent;
               Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then begin
     if (FLookupTable<>Nil) and (AComponent = FLookupTable) then
        FLookupTable:=Nil;
     if (FSyncTable<>Nil) and (AComponent = FSyncTable) then
        FSyncTable:=Nil;
  end
end;

{$ifdef win32}
procedure TwwLookupDlg.wwDBGrid1ColumnMoved(Sender: TObject; FromIndex,
  ToIndex: Integer);
begin
   UpdateSearchField;
end;
{$else}
procedure TwwLookupDlg.wwDBGrid1ColumnMoved(Sender: TObject; FromIndex,
  ToIndex: Longint);
begin
   UpdateSearchField;
end;
{$endif}

end.
