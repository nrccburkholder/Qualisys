unit Wwfltdlg;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DB, Wwdatsrc, ExtCtrls, Buttons, wwfltdum, dbtables,
  Tabs, wwcommon, wwsystem;


type
  TwwFilterDialogOption = (fdCaseSensitive, fdShowCaseSensitive, fdShowOKCancel,
                               fdShowViewSummary, fdShowFieldOrder,
                               fdShowValueRangeTab, fdShowNonMatching);
  TwwFilterDialogOptions = set of TwwFilterDialogOption;

  TwwFilterDialogSort = (fdSortByFieldNo, fdSortByFieldName);
  TwwFilterMatchType = (fdMatchStart, fdMatchAny, fdMatchExact,
                        fdMatchEnd, fdMatchRange, fdMatchNone);
  TwwFilterMethodAll = (fdByFilter, fdByQueryModify, fdByQueryParams);
  TwwFilterMethod = fdByFilter..fdByQueryModify;

  TwwDefaultMatchType = fdMatchStart..fdMatchExact;
  TwwDefaultFilterBy = (fdSmartFilter, fdFilterByRange, fdFilterByValue);
  TwwFilterDlg = class;
  TwwOnInitFilterDlgEvent = procedure(Dialog : TwwFilterDlg) of object;
  TwwOnExecuteSQLEvent = procedure(Dialog: TwwFilterDlg; Query: TQuery) of object;
  TwwFilterOptimization = (fdNone, fdUseAllIndexes, fdUseActiveIndex);

  TwwFieldInfo = class
  public
     FieldName: string;
     DisplayLabel: string;
     MatchType: TwwFilterMatchType;
     FilterValue: string;
     MinValue: string;
     MaxValue: string;
     CaseSensitive: boolean;
     NonMatching: boolean;
  end;

  TwwFilterDlg = class(TForm)
    FieldsListBox: TListBox;
    FieldsLbl: TLabel;
    FieldOrder: TRadioGroup;
    FieldCriteria: TGroupBox;
    SelectNotebook: TNotebook;
    FieldValueLbl: TLabel;
    FilterValueEdit: TEdit;
    MatchTypeGroup: TRadioGroup;
    Panel1: TPanel;
    CaseSensitive: TCheckBox;
    StartingRangeLbl: TLabel;
    EndingRangeLbl: TLabel;
    MinValueEdit: TEdit;
    MaxValueEdit: TEdit;
    ClearSearchButton: TButton;
    ViewButton: TButton;
    ValueRangeTabSet: TTabSet;
    FieldTabSet: TTabSet;
    FilterValueClearButton: TBitBtn;
    MinValueClearButton: TBitBtn;
    MaxValueClearButton: TBitBtn;
    Nonmatching: TCheckBox;
    procedure FieldOrderClick(Sender: TObject);
    procedure FieldsListBoxClick(Sender: TObject);
    procedure ViewButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ValueRangeTabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FieldTabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure ClearSearchButtonClick(Sender: TObject);
    procedure FilterValueEditChange(Sender: TObject);
    procedure MinValueEditChange(Sender: TObject);
    procedure MaxValueEditChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure MinValueClearButtonClick(Sender: TObject);
    procedure MaxValueClearButtonClick(Sender: TObject);
    procedure FilterValueClearButtonClick(Sender: TObject);
  private
    DlgComponent: TComponent;
    DlgDataSet: TDataSet;
    FieldInfo: TList;
    LastItemIndex: integer;
    FormActivated: boolean;

    Function IsValueField(ADisplayLabel: string): boolean;
    Function IsValueType(AFieldType: TFieldType): boolean;
    Procedure RefreshFieldList(ShowAll: boolean);
    Procedure RefreshClearbutton;
    Function ValidEditValue(val: string): boolean;
    Function ValidEditValues(val: string): boolean; {paul}
    procedure ApplyIntl;
    Function GetFieldType(ADisplayLabel: wwSmallString): TFieldType;

  public
     OKBtn, CancelBtn: TButton;
     FilterChanged: Boolean;

     constructor CreateDlg(AOwner: TComponent; ADlgComponent: TComponent);
     destructor Destroy; override;
     Function SelectField(FieldChanged: boolean): boolean;
     Procedure SelectPage;
     Procedure SelectFocus;
     procedure SetFilterfield(ADisplayLabel: wwSmallString;
       AMatchType: TwwFilterMatchType; AFilterValue, AMinValue, AMaxValue: string;
       ACaseSensitive, ANonMatching: boolean);
     Function GetFilterField(ADisplayLabel: wwSmallString; var FldInfo: TwwFieldInfo): boolean;
     Procedure CopyList(fromlist, tolist: TList);

  end;

  TwwDBFieldInfo = class
  public
     LogicalFieldName: string;
     PhysicalFieldName: string;
     TableName: string;
     FieldType: TFieldType;
     DisplayLabel: string;
  end;

  TwwFieldOperators = class(TPersistent)
  private
     FOrChar: string;
     FAndChar: string;
     FNullChar: string;
     procedure SetOrChar(val: string);
     procedure SetAndChar(val: string);
     procedure SetNullChar(val: string);
     procedure SetOpChar(var opchar: string; val:string);
  public
     constructor Create(Owner: TComponent);
  published
     property OrChar: string read FOrChar write SetOrChar;
     property AndChar: string read FAndChar write SetAndChar;
     property NullChar: string read FNullChar write SetNullChar;
  end;

  TwwFilterDialog = class(TComponent)
  private
     FDataLink: TDataLink;
     FOptions: TwwFilterDialogOptions;
     FSortBy: TwwFilterDialogSort;
     FDummyForm: TwwDummyForm;
     FTitle: String;
     FFilterMethod: TwwFilterMethod;
     FDefaultMatchType: TwwDefaultMatchType;
     FDefaultFilterBy: TwwDefaultFilterBy;
     FDefaultField: string;
     FSelectedFields: TStrings;
     FOnInitDialog: TwwOnInitFilterDlgEvent;
     FOnExecuteSQL: TwwOnExecuteSQLEvent;
     FwwOperators: TwwFieldOperators;
     FRangeApplied: boolean;
     FFilterOptimization: TwwFilterOptimization;

     FOrigSQL: TStrings;
     FFldList: TList;
     FShowDialog: boolean;
     FDependentComponents: Tlist;

     procedure SetDataSource(value : TDataSource);
     Function GetDataSource: TDataSource;
     procedure SetFilterMethod(val: TwwFilterMethod);
     Procedure ReplaceWhereClause(whereClause: TStrings);
     Procedure InitQueryFields;
     Procedure InitTableFields;

  protected
      Procedure DoInitDialog; virtual;   { This method should only be called by TwwFilterDlg }
  public
     MemoBuffer: PChar;
     form: TwwFilterDlg;
     FieldInfo: TList;

     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
     function Execute: boolean; virtual;  { shows dialog }
     Procedure ApplyFilter;
     Procedure ClearFilter;
     Procedure InitFields;                    { Used by filter fields property editor}
     property AllFields: TList read FFldList; { Used by filter fields property editor}
     property ShowDialog: boolean read FShowDialog write FShowDialog;
     Function GetDBInfoForField(AFilterFieldName: wwSmallString): TwwDBFieldInfo; { Used by filter fields property editor}
     Procedure AddDependent(value: TComponent);
     Procedure RemoveDependent(value: TComponent);
     
  published
     property DataSource: TDataSource read GetDataSource write SetDataSource;
     property Options: TwwFilterDialogOptions read FOptions write FOptions default
              [fdShowCaseSensitive, fdShowOKCancel, fdShowViewSummary, fdShowFieldOrder,
               fdShowValueRangeTab];

     property SortBy: TwwFilterDialogSort read FSortBy write FSortBy;
     property Caption: string read FTitle write FTitle;
     property FilterMethod: TwwFilterMethod read FFilterMethod write SetFilterMethod;
     property DefaultMatchType: TwwDefaultMatchType read FDefaultMatchType write FDefaultMatchType;
     property DefaultFilterBy: TwwDefaultFilterBy read FDefaultFilterBy write FDefaultFilterBy;
     property DefaultField: string read FDefaultField write FDefaultField;
     property FieldOperators: TwwFieldOperators read FwwOperators write FwwOperators;
     property SelectedFields: TStrings read FSelectedFields write FSelectedFields;
     property FilterOptimization: TwwFilterOptimization read FFilterOptimization write FFilterOptimization;

     property OnInitDialog: TwwOnInitFilterDlgEvent read FOnInitDialog write FOnInitDialog;
     property OnExecuteSQL: TwwOnExecuteSQLEvent read FOnExecuteSQL write FOnExecuteSQL;
  end;

  Function wwGetFilterOperator(FilterValue: string;
                             FilterOperator: TwwFieldOperators;
                             var OrFlg: boolean; var AndFlg: boolean): string;

  Function wwGetFilterToken(FilterValue: string;
                          SearchDelimiter: string;
                          var CurPos: integer): string;

  procedure Register;

var
  wwFilterDlg: TwwFilterDlg;

implementation
{$R *.DFM}

uses wwtable, wwquery, wwqbe, wwstorep, wwstr, wwfltvw, wwtypes, wwintl, typinfo;

const dbl='"';
      single='''';

constructor TwwFieldOperators.Create(Owner: TComponent);
begin
   FOrChar:= 'or';
   FAndChar:= 'and';
   FNullChar := 'null';
end;

Procedure TwwFilterDlg.CopyList(fromlist, tolist: TList);
var i: integer;
    srcFieldInfo, tempFieldInfo: TwwFieldInfo;
begin
   for i:= 0 to toList.count-1 do TwwFieldInfo(toList[i]).Free;
   toList.clear;
   for i:= 0 to fromList.count-1 do begin
      tempFieldInfo:= TwwFieldInfo.create;
      srcFieldInfo:= TwwFieldInfo(fromList[i]);
      tempFieldInfo.DisplayLabel:= srcFieldInfo.DisplayLabel;
      tempFieldInfo.MatchType:= srcFieldInfo.MatchType;
      tempFieldInfo.FilterValue:= srcFieldInfo.FilterValue;
      tempFieldInfo.MinValue:= srcFieldInfo.MinValue;
      tempFieldInfo.MaxValue:= srcFieldInfo.MaxValue;
      tempFieldInfo.CaseSensitive:= srcFieldInfo.CaseSensitive;
      tempFieldInfo.NonMatching:= srcFieldInfo.NonMatching;
      tempFieldInfo.FieldName:= wwGetFieldNameFromTitle(DlgDataSet, srcFieldInfo.DisplayLabel);

      toList.add(tempFieldInfo);
   end;
end;

constructor TwwFilterDlg.CreateDlg(AOwner: TComponent; ADlgComponent: TComponent);
begin
  inherited Create(AOwner);
  FieldInfo:= TList.create;
  DlgDataSet:= TwwFilterDialog(ADlgComponent).DataSource.DataSet;
  CopyList(TwwFilterDialog(ADlgComponent).FieldInfo, FieldInfo);
  LastItemIndex:= -1;
  FormActivated:= False;
  DlgComponent:= ADlgComponent;
  (DlgComponent as TwwFilterDialog).InitFields;

  OkBtn:= TButton(wwCreateCommonButton(Self, bkOK));
  OKBtn.TabOrder := 2;
  OKBtn.Top:= (22 * PixelsPerInch) div 96;
  OKBtn.Left := FieldCriteria.Left + FieldCriteria.Width + ((7 * PixelsPerInch) div 96);
  OKBtn.visible:= True;
  CancelBtn:= TButton(wwCreateCommonButton(Self, bkCancel));
  CancelBtn.TabOrder := 3;
  CancelBtn.Top:= (62 * PixelsPerInch) div 96;
  CancelBtn.Left := FieldCriteria.Left + FieldCriteria.Width + ((7 * PixelsPerInch) div 96);
  cancelBtn.visible:= True;
end;

destructor TwwFilterDlg.Destroy;
var i :integer;
begin
  for i:= 0 to FieldInfo.count-1 do TwwFieldInfo(FieldInfo[i]).Free; { Free items }
  FieldInfo.Free;
  inherited destroy;
end;

constructor TwwFilterDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink:= TDataLink.create;
  FSortBy:= fdSortByFieldNo;
  FDummyForm:= TwwDummyForm.create(self);
  FDummyForm.DlgComponent:= self;
  GetMem(MemoBuffer, 32767);
  FieldInfo:= TList.create;
  FOrigSQL:= TStringList.create;
  FFldList:= TList.create;
  FFilterMethod:= fdByFilter;
  FSelectedFields:= TStringlist.create;
  FOptions:= [fdShowCaseSensitive, fdShowOKCancel, fdShowViewSummary, fdShowFieldOrder, fdShowValueRangeTab];
  FShowDialog:= True;
  FDependentComponents:= TList.create;
  FwwOperators:=TwwFieldOperators.create(self);
end;

destructor TwwFilterDialog.Destroy;
var i: integer;
begin
  { Detach onFilter event 10/22/96 -
    Consider case where table is destroyed before dialog.
    Comment out code until this issue is resolved.   }
{  if datasource.dataset is TwwQuery then
     (datasource.dataset as TwwQuery).OnFilter:= nil
  else if datasource.dataset is TwwTable then
     (datasource.dataset as TwwTable).OnFilter:= nil
  else if datasource.dataset is TwwQBE then
     (datasource.dataset as TwwQBE).onFilter:= nil;
}
  FDataLink.free;
  FDataLink:= Nil;
  FDummyForm.Free;
  FwwOperators.Free;
  FreeMem(memoBuffer, 32767);

  for i:= 0 to FieldInfo.count-1 do TwwFieldInfo(FieldInfo[i]).Free;
  FieldInfo.Free;
  FOrigSQL.free;

  for i:= 0 to FFldList.count-1 do TwwDBFieldInfo(FFldList[i]).Free;
  FFldList.Free;
  FSelectedFields.Free;

  for i:= 0 to FDependentComponents.count-1 do
     TwwCheatCastNotify(FDependentComponents[i]).notification(self, opRemove);
  FDependentComponents.Free;

  inherited destroy;
end;

procedure TwwFilterDialog.SetDataSource(value : TDataSource);
begin
   if (value<>nil) and (value.dataset<>nil) then begin
      if (value.dataset is TTable) then
        FFilterMethod:= fdByFilter
   end;
   FDataLink.dataSource:= value;
end;

Function TwwFilterDialog.GetDataSource: TDataSource;
begin
   if FDataLink<>Nil then Result:= FDataLink.dataSource
   else Result:= nil;
end;

{ Fill listbox with fields }
Procedure TwwFilterDlg.RefreshFieldList(ShowAll: boolean);
var i, curpos: integer;
    FldInfo: TwwFieldInfo;
    ParamName: wwSmallString;
    query: TQuery;
    Dlg: TwwFilterDialog;
    dbInfo: TwwDBFieldInfo;
    FieldName: wwSmallString;

    Procedure AddFieldToListBox(ADisplaylabel: wwSmallString);
    var TempLabelName: wwSmallString;
    begin
       if ShowAll or (GetFilterField(ADisplayLabel, FldInfo)) then
       begin
         TempLabelname:= strReplaceChar(ADisplayLabel,'~', ' ');
         if FieldsListBox.items.indexOf(TempLabelName)<0 then
            FieldsListBox.items.add(TempLabelname);
       end
    end;


begin
   FieldsListBox.items.clear;
   FieldsListBox.sorted:= (FieldOrder.itemIndex = 0);
   Dlg:= DlgComponent as TwwFilterDialog;

   if (DlgDataSet is TQuery) and
      (Dlg.FilterMethod=fdByQueryParams) then begin
      query:= DlgDataset as TQuery;
      for i:= 0 to query.ParamCount-1 do begin
         ParamName:= query.Params.items[i].name;
         if ShowAll or (GetFilterField(ParamName, FldInfo)) then
         begin
            FieldsListBox.items.add(ParamName);
         end
      end;
      exit;
   end;

   if Dlg.SelectedFields.count=0 then begin
      for i:= 0 to Dlg.FFldList.count-1 do begin
         if not wwValidFilterableFieldType(TwwDBFieldInfo(Dlg.FFldList[i]).FieldType) then continue;
         AddFieldToListBox(TwwDBFieldInfo(Dlg.FFldList[i]).DisplayLabel);
      end
   end
   else begin
      for i:= 0 to Dlg.SelectedFields.count-1 do begin
         curpos:= 1;
         FieldName:= strGetToken(Dlg.SelectedFields[i], ';', curpos);
         dbInfo:= Dlg.GetDBInfoForField(FieldName);
         if dbInfo=nil then continue;
         if not wwValidFilterableFieldType(dbInfo.FieldType) then continue;
         AddFieldToListBox(dbInfo.DisplayLabel);
      end
   end;
end;

Function GetWord(s: string; var APos: integer): string;
var i: integer;

   Function max(x,y: integer): integer;
   begin
     if x>y then result:= x
     else result:= y;
   end;

begin
   result:= '';
   if APos<=0 then exit;
   if APos>length(s) then exit;

   i:= APos;
   while (i<=length(s)) and ((s[i]=' ') or (s[i]=#9)) do inc(i); { skip leading whitespace}
   APos:= i; { Skip leading blanks/tabs }
   if s[i]='"' then begin
      inc(i);
      while (i<=length(s)) and (s[i]<>'"') do inc(i);
      if s[i]='"' then begin
         result:= copy(s, APos, i+1-APos);
         APos:= i+1;
      end
   end
   else if s[i]='''' then begin
      inc(i);
      while (i<=length(s)) and (s[i]<>'''') do inc(i);
      if s[i]='''' then begin
         result:= copy(s, APos, i+1-APos);
         APos:= i+1;
      end
   end
   else begin
      while (i<=length(s)) and (s[i] in ['A'..'Z','0'..'9','.','_' ]) do inc(i);
      result:= copy(s, APos, max(i-APos, 1));

      if length(result)>1 then APos:= i
      else APos:= i+1;
   end;
end;

Procedure TwwFilterDialog.ReplaceWhereClause(whereClause: TStrings);
var query: TQuery;
    i,j, APos: integer;
    line: string;
    word: string;
    startline, lastpos, startPos: integer;

    Function isKeyWord(word: string): boolean;
    begin
      result:=
         (word='WHERE') or
         (word='GROUP') or (word='HAVING') or
         (word='UNION') or (word='PLAN') or
         (word='ORDER') or (word='FOR');
    end;

begin
   startpos:= 0; lastpos:= 0; startLine:= 0; { Make compiler happy}

   query:= (DataSource.DataSet as TQuery);
   if query.sql.count=0 then exit;
   if whereClause.count=0 then exit;

   for i:= 0 to query.sql.count-1 do begin
      line:= uppercase(query.sql[i]);
      APos:= 1;
      repeat
         word:= GetWord(line, APos);
      until (isKeyWord(word) or (word=''));
      if isKeyWord(word) then begin
         startLine:= i;
         startPos:= APos;
         break;
      end
   end;

   if word='WHERE' then
   begin
      startPos:= startPos + 5; { Skip where keyword }

      { Find end of where clause and append to where clause }
      for i:= startLine to query.sql.count-1 do begin
         line:= uppercase(query.sql[i]);
         APos:= startPos;
         repeat
            lastPos:= APos;
            word:= GetWord(line, APos);
         until (isKeyWord(word) or (word=''));
         if isKeyWord(word) then break;
         startPos:= 1;
      end;
      if (i>=query.sql.count) then i:= i - 1;
      query.sql[i]:= copy(line, 1, lastPos-1);
      query.sql.insert(i+1, 'And');
      query.sql.insert(i+2, copy(line, lastPos, length(line)));
      inc(i); { Insert after 'And'}
   end
   else begin
      if word='' then begin
         query.sql.add('Where');
         for j:= 0 to whereClause.count-1 do
           query.sql.add(whereClause[j]);
         exit;
      end
      else begin
         query.sql.insert(i, 'Where');
      end
   end;

   for j:= 0 to whereClause.count-1 do
      query.sql.insert(i+j+1, whereClause[j]);

end;

procedure TwwFilterDialog.InitFields;
begin
   { Initializes FieldDefs for dataset}
   if (FilterMethod=fdByQueryModify) then
      InitQueryFields
   else begin
      InitTableFields;
   end
end;

Function TwwFilterDlg.IsValueField(ADisplayLabel: string): boolean;
begin
   result:= isValueType(GetFieldType(ADisplayLabel));
end;

Function TwwFilterDlg.IsValueType(AFieldType: TFieldType): boolean;
begin
   result:=
       (AFieldType in
       [ftDate, ftSmallInt, ftInteger, ftWord, ftFloat, ftCurrency, ftBoolean]);
   {$ifdef win32}
   if AFieldType=ftAutoInc then result:= True;
   {$endif}

   if ((DlgComponent as TwwFilterDialog).FilterMethod=fdByQueryModify) and
      (AFieldType in [ftDateTime, ftTime]) then result:= True;
end;

Procedure TwwFilterDialog.InitTableFields;
var i: integer;
    newFldItem: TwwDBFieldInfo;
    curField: TField;
begin
   FFldList.clear;

   if (DataSource<>Nil) and (DataSource.DataSet<>Nil) then
   begin
      { No peristent fields and not active }
{      if (DataSource.DataSet is TwwQuery) or (DataSource.DataSet is TwwQBE) then
      begin
         if (DataSource.DataSet.FieldCount=0) and (not DataSource.DataSet.active) then
         begin
            MessageDlg('No persistent fields found.  InfoPower requires ' +
              'persistent fields when using fdByFilter on an inactive Query or QBE. '+
              'Dbl-click the TwwQuery or TwwQBE component to make your field''s persistent ' +
              'or make your query active before calling this dialog', mtError,
              [mbOK], 0);
            exit;
         end
      end
}
   end;

{   for i:= 0 to FieldDefs.count-1 do begin
      newFldItem:= TwwDBFieldInfo.create;
      with newFldItem do
      begin
         LogicalFieldName:= FieldDefs.items[i].Name;
         PhysicalFieldName:= FieldDefs.items[i].Name;
         TableName:= '';
         FieldType:= FieldDefs.items[i].DataType;

         curField:=DataSource.DataSet.FindField(PhysicalFieldName);
         if curField=nil then DisplayLabel:= PhysicalFieldName
         else DisplayLabel:= curField.DisplayLabel;
      end;
      FFldList.add(newFldItem);
   end;
}

   for i:= 0 to datasource.dataset.FieldCount-1 do begin
      newFldItem:= TwwDBFieldInfo.create;
      with newFldItem do
      begin
         curField:= DataSource.DataSet.Fields[i];
         LogicalFieldName:= curField.FieldName;
         PhysicalFieldName:= LogicalFieldName;
         TableName:= '';  { Not used witih this filter method}
         FieldType:= curField.DataType;
         DisplayLabel:= curField.DisplayLabel;;
      end;
      FFldList.add(newFldItem);
   end;

end;

Procedure TwwFilterDialog.InitQueryFields;
var query: TQuery;
    table: TTable;
    i, j, Apos: integer;
    line, word: string;
    tableName, tableAlias: wwSmallString;
    tempFldList, TempAllFldList: TStringList;
    PhysFieldName : wwSmallString;
    FieldDef: TFieldDef;
    newFldItem: TwwDBFieldInfo;
    tempField: TField;

   Function FldInList(TempFldName: wwSmallString): boolean;
   var i: integer;
   begin
      result:= False;
      for i:= 0 to FFldList.count-1 do begin
         if wwEqualStr(tempFldName, TwwDBFieldInfo(FFldList[i]).LogicalFieldName) then
         begin
            result:= True;
            exit;
         end
      end
   end;

   Function ComputeFieldName(TempFldName: wwSmallString): string;
   var FirstTime: boolean;
   begin
       FirstTime:= True;
       while FldInList(TempFldName) do begin
          if FirstTime then
              TempFldName:= TempFldName + '_' + '1'
          else begin
              TempFldName[length(TempFldName[j])]:=
                 char(ord(TempFldName[length(TempFldName)])+1);
          end
       end;
       result:= TempFldName;
    end;

begin
    query:= (DataSource.DataSet as TQuery);

    { Search for From clause }
    for i:= 0 to query.sql.count-1 do begin
       line:= uppercase(query.sql[i]);
       APos:= 1;
       repeat
          word:= GetWord(line, APos);
       until (word='FROM') or (word='');
       if word='FROM' then break;
    end;


    table:= TTable.create(Nil);
    FFldList.clear;
    TempFldList:= TStringList.create;
    TempAllFldList:= TStringList.create;

    if word='FROM' then begin
       repeat
          repeat { Get Next table in From list }
             TableName:= GetWord(line, APos);
             if TableName='' then begin
                if (i>=query.sql.count-1) then break;
                inc(i);
                line:=uppercase(query.sql[i]);
                APos:= 1;
             end
          until TableName<>'';

          if (TableName[1]=Dbl) or (TableName[1]=Single) then
          begin
             TableName:= copy(TableName, 2, length(TableName)-2);
             TableAlias:= GetWord(line, APos);
          end
          else begin
             TableAlias:= TableName;
          end;
          table.databaseName:= query.databaseName;
          table.tableName:= tableName;
          table.readOnly:= True;

          table.GetFieldNames(TempFldList);
          for j:= 0 to TempFldList.Count-1 do begin
             if TempAllFldList.indexOf(uppercase(TempFldList[j]))<0 then
                TempAllFldList.add(uppercase(TempFldList[j]))
             else continue;  { Duplicate field name so ignore }

             PhysFieldName:= TempFldList[j];
             TempFldList[j]:= ComputeFieldName(TempFldList[j]);
             newFldItem:= TwwDBFieldInfo.create;
             with newFldItem do
             begin
                LogicalFieldName:= TempFldList[j];
                TableName:= TableAlias;
                PhysicalFieldName:= PhysFieldName;
                FieldDef:= Table.FieldDefs.Find(PhysicalFieldName);
                if FieldDef<>nil then
                   FieldType:= FieldDef.DataType;
                tempField:=Table.FindField(PhysicalFieldName);
                if tempField=nil then begin  { If field not found check query's fields }
                   tempField:= query.FindField(PhysicalFieldName);
                   if tempField=nil then DisplayLabel:= PhysicalFieldName
                   else DisplayLabel:= tempField.DisplayLabel;
                end
                else DisplayLabel:= tempField.DisplayLabel;
             end;
             FFldList.add(newFldItem);
          end;

          if GetWord(line, APos)<>',' then break;

        until False;
    end;

    table.free;
    tempFldList.Free;
    tempAllFldList.Free;

end;

{ From internal Field Name, Map to Physical Table and Field names.
  The FieldName and Physical Field Name would be the same except in the case
  where two related tables have the same field name.
  The logic assumes that the Delphi numbering scheme is based on the
  relative order of the tables in the 'From' clause.
}
Function TwwFilterDialog.GetDBInfoForField(AFilterFieldName: wwSmallString): TwwDBFieldInfo;
var i: integer;
begin
    result:= nil;
    for i:= 0 to FFldList.count-1 do begin
       if wwEqualStr(TwwDBFieldInfo(FFldList[i]).LogicalFieldName, AFilterFieldName) then
       begin
          result:= TwwDBFieldInfo(FFldList[i]);
          break;
       end;
    end;
end;

Function TwwFilterDialog.Execute;
var
    FOnFilter: TwwDataSetFilterEvent;
{    myTable: TwwTable;
    myQuery: TwwQuery;
    myQBE: TwwQBE;
    myStoredProc: TwwStoredProc;}
    ApplyFilter: boolean;

   Procedure ExecQueryByParams;
   var i,j: integer;
       FilterFieldName, FilterValue: string;
       query: TQuery;
       FldInfo: TwwFieldInfo;
       ParamName: string;
       Found: boolean;
   begin
      query:= (DataSource.DataSet as TQuery);
      query.active:= False;

      for i:= 0 to query.ParamCount-1 do begin
         ParamName:= query.Params.items[i].name;

         Found:= False;
         for j:= 0 to FieldInfo.count-1 do begin
            FldInfo:= TwwFieldInfo(FieldInfo[j]);
            if FldInfo.FieldName='' then FldInfo.FieldName:= FldInfo.DisplayLabel;

            if not wwEqualStr(FldInfo.FieldName, ParamName) then continue;
            Found:= True;
            FilterFieldName:= FldInfo.FieldName;
            FilterValue:= FldInfo.Filtervalue;
            if FldInfo.MatchType = fdMatchStart then FilterValue:= FilterValue + '%'
            else if FldInfo.MatchType = fdMatchAny then FilterValue := '%' + Filtervalue + '%';
            query.ParamByName(FilterFieldName).asString:= FilterValue;
            break;
         end;

         if not Found then
            query.ParamByName(ParamName).asString:= '%';
      end;

      try
         if Assigned(FOnExecuteSQL) then FOnExecuteSQL(form, query);
         query.active:= True;
      except
      end;
   end;

   Function QueryFormatDateTime(val: string): string;
   var  year, month, day, hour, min, sec, msec: word;
   begin
       result:= '';
       if val='' then exit;
       DecodeDate(StrToDateTime(val), Year, Month, Day);
       DecodeTime(StrToDateTime(val), Hour, Min, Sec, MSec);
       Result:= inttostr(Month) + '/' + inttostr(Day) + '/' + inttostr(year) +
                   ' ' + inttostr(hour) + ':' + inttostr(min) + ':' + inttostr(sec);
   end;

   Function QueryFormatDate(val: string): string;
   var  year, month, day: word;
   begin
       result:= '';
       if val='' then exit;
       DecodeDate(StrToDateTime(val), Year, Month, Day);
       Result:= inttostr(Month) + '/' + inttostr(Day) + '/' + inttostr(year);
   end;

   Function QueryFormatTime(val: string): string;
   var  hour, min, sec, msec: word;
   begin
       result:= '';
       if val='' then exit;
       DecodeTime(StrToTime(val), Hour, Min, Sec, MSec);
       Result:= inttostr(hour) + ':' + inttostr(min) + ':' + inttostr(sec);
   end;

   Procedure ExecQueryByNewQuery;
   var j: integer;
       FilterFieldName: wwSmallString;
       FilterValue: string;
       TableFieldName: string;
       query: TQuery;
       FldInfo: TwwFieldInfo;
       Found: boolean;
       line: string;
       tableName: wwSmallString;
       MatchType: TwwFilterMatchType;
       whereClause: TStrings;
       FoundField: boolean;
       quote: string[1];
       dbInfo: TwwDBFieldInfo;
       nextword: wwSmallString;
       First: boolean;
       SearchDelimiter: string;
       OrFlg,AndFlg : Boolean;
       CurPos : Integer;
       tempMinValue, tempMaxValue: string;
   begin
      query:= (DataSource.DataSet as TQuery);
      query.active:= False;

      if FOrigSQL.count=0 then FOrigSQL.assign(query.sql)
      else query.sql.assign(FOrigSQL);

      whereClause:= TStringlist.create;
      foundField:= True;

      for j:= 0 to FieldInfo.count-1 do begin

         FldInfo:= TwwFieldInfo(FieldInfo[j]);
         MatchType:= FldInfo.MatchType;

         case MatchType of
           fdMatchStart, fdMatchAny, fdMatchExact:
             begin
               if (FldInfo.NonMatching) and (j>0) then
                  whereClause.add('  and not')
               else if (FldInfo.NonMatching) and (j=0) then
                  whereClause.add('  not')
               else if j>0 then whereClause.add(' and');
             end;
           fdMatchRange:
             begin
                if j>0 then whereClause.add(' and');
             end;
         end;

{         FilterField:= query.FindField(FilterFieldName);}

         if FldInfo.FieldName='' then FldInfo.FieldName:= FldInfo.DisplayLabel;
         FilterFieldName:= FldInfo.FieldName;
         FilterValue:= FldInfo.Filtervalue;

         if pos(' ', FilterFieldName)>0 then quote:= dbl
         else if pos('-', FilterFieldName)>0 then quote:= dbl
         else quote:= '';

         dbInfo:= GetDBInfoForField(FilterFieldName);
         found:= dbInfo<>Nil;

         TableFieldName:=
             dbInfo.TableName + '.' + quote + dbInfo.PhysicalFieldName + quote;


         case MatchType of
           fdMatchStart, fdMatchAny, fdMatchExact:
             begin

               SearchDelimiter := wwGetFilterOperator(FilterValue,FwwOperators,OrFlg,AndFlg);

                {$ifdef win32}
                if (not FldInfo.CaseSensitive) and
                   not (dbInfo.FieldType in
                        [ftDate, ftDateTime, ftTime, ftSmallInt, ftInteger, ftWord, ftFloat, ftCurrency,
                         ftAutoInc, ftBoolean]) then
                begin
                   TableFieldName:=
                     'Upper(' + dbInfo.TableName + '.' + quote + dbInfo.PhysicalFieldName + quote + ')';
                   FilterValue:= uppercase(FilterValue);
                end;
                {$endif}

                if found then
                begin
                   line:= '(';
                   CurPos := 1;
                   First := True;
                   repeat
                      nextword:= wwGetFilterToken(FilterValue,SearchDelimiter,CurPos);
                      if (pos('''',nextword))<>0 then
                         nextword :=  strReplaceCharWithStr(nextword,'''','''''');

                      if (not First and (nextword<>'')) then begin
                        if (OrFlg) then line:= line + ' or '
                        else line := line + ' and ';
                      end
                      else First := False;

                      strStripWhiteSpace(nextword);

                      if (Uppercase(FwwOperators.FNullChar) = uppercase(nextword)) then
                      begin
                         line := line + TableFieldName + ' is NULL';
                      end
                      else begin

                      case MatchType of
                         fdMatchStart: nextword:= nextword + '%';
                         fdMatchAny:   nextword:= '%' + nextword + '%';
                      end;

                      if (not FldInfo.CaseSensitive) then
                         nextword := uppercase(nextword);

                      case dbInfo.FieldType of
                         ftSmallInt, ftInteger, ftWord, ftFloat, ftCurrency, ftBoolean:
                            line:= line + TableFieldName + '=' + nextword;
                         {$ifdef win32}
                         ftAutoInc:
                            line:= line + TableFieldName + '=' + nextword;
                         {$endif}

                         ftDate:
                            line:= line + TableFieldName + '=' +  single + QueryFormatDate(nextword) + single;
                         ftDateTime:
                            line:= line + '   ' + TableFieldName + '=' +  single + QueryFormatDateTime(nextword) + single;
                         ftTime:
                            line:= line + '   ' + TableFieldName + '=' +  single + QueryFormatTime(nextword) + single;

                         else
                           { 2/27/97 - Use = instead of like for exact match }
                           if MatchType=fdMatchExact then
                             line:= line + TableFieldName + '=' + single + nextword + single
                           else line:= line + TableFieldName + ' like ' + single + nextword + single;
                      end;
                      end;
                   until CurPos=-1;
                   line := line + ')';
                   whereClause.add(line);
                end
                else foundField:= False;
             end;

           fdMatchRange:
             begin
                if found then
                begin
                   tableName:= dbInfo.TableName;
                   FilterFieldName:= dbInfo.PhysicalFieldName;

                   if (dbInfo.FieldType in [ftString, ftDate, ftTime, ftDateTime]) then begin
                      case dbInfo.FieldType of
                         ftString: begin
                             TempMinValue:= FldInfo.MinValue;
                             TempMaxValue:= FldInfo.MaxValue;
                           end;
                         ftDate: begin
                             TempMinValue:= QueryFormatDate(FldInfo.MinValue);
                             TempMaxValue:= QueryFormatDate(FldInfo.MaxValue);
                           end;
                         ftTime: begin
                             TempMinValue:= QueryFormatTime(FldInfo.MinValue);
                             TempMaxValue:= QueryFormatTime(FldInfo.MaxValue);
                           end;
                         ftDateTime: begin
                            TempMinValue:= QueryFormatDateTime(FldInfo.MinValue);
                            TempMaxValue:= QueryFormatDateTime(FldInfo.MaxValue);
                           end;
                      end;
                      if FldInfo.MinValue<>'' then begin
                         line:= '   ' + TableFieldName + ' >= ' +
                              single + TempMinValue + single;
                         whereClause.add(line);
                      end;

                      if FldInfo.MaxValue<>'' then begin
                         if FldInfo.MinValue<>'' then whereClause.add(' and');
                         line:= '   ' + TableFieldName + ' <= ' +
                              single + TempMaxValue + single;
                         whereClause.add(line);
                      end
                   end
                   else if Form.isValueType(dbinfo.FieldType) then
                   begin
                      if FldInfo.MinValue<>'' then begin
                         line:= '   ' + TableFieldName + ' >= ' +
                           FldInfo.MinValue;
                         whereClause.add(line);
                      end;

                      if FldInfo.MaxValue<>'' then begin
                         if FldInfo.MinValue<>'' then whereClause.add(' and');
                         line:= '   ' + TableFieldName + ' <= ' +
                             FldInfo.MaxValue;
                         whereClause.add(line);
                      end
                   end;
                end
                else foundField:= False;
             end
         end; { Case }

         if not FoundField then begin
            MessageDlg('Field Name not found in referenced tables. ' + #13 +
                FilterFieldName, mtWarning, [mbok], 0);
            break;
         end;

      end;

      try
         if FoundField then begin
            ReplaceWhereClause(whereClause);
            if Assigned(FOnExecuteSQL) then FOnExecuteSQL(form, query);
            query.active:= True;
         end;
      finally
         whereClause.free;
      end;

   end;

   procedure UseIndexForFilter;
   var i: integer;
       FldInfo: TwwFieldInfo;
       MatchType: TwwFilterMatchType;
       tempIndexName: string;
       OrFlg, AndFlg: boolean;
   begin

     if ((DataSource.DataSet as TwwTable).MasterSource<>Nil) then exit;  { Don't change index if detail table}

     if FRangeApplied then begin
        (DataSource.DataSet as TwwTable).FastCancelRange;
        FRangeApplied:= False;
     end;

     { Try to use active index }
     if fdUseActiveIndex = FilterOptimization then begin

        for i:= 0 to FieldInfo.count-1 do begin
           FldInfo:= TwwFieldInfo(FieldInfo[i]);
           if FldInfo.NonMatching then continue;
           if wwGetFilterOperator(FldInfo.FilterValue,FwwOperators,OrFlg,AndFlg)<>'' then continue;

           if FldInfo.FieldName='' then  { Compute field name from displaylabel if unspecified }
              FldInfo.FieldName:= wwGetFieldNameFromTitle(DataSource.DataSet, FldInfo.DisplayLabel);
           MatchType:= FldInfo.MatchType;

           case MatchType of
              fdMatchStart, fdMatchExact:
                begin
                   if (FldInfo.FieldName=(DataSource.DataSet as TwwTable).indexFieldName) then
                   begin
                      if FldInfo.FilterValue<>'' then begin
                         if MatchType=fdMatchExact then
                         begin
                            (DataSource.DataSet as TwwTable).SetRange([FldInfo.FilterValue], [FldInfo.FilterValue]);
                            FRangeApplied:= True;
                            exit;
                         end
                         else if (MatchType=fdMatchStart) and
                            ((DataSource.DataSet as TwwTable).indexFields[0].dataType = ftString) then
                         begin
                            (DataSource.DataSet as TwwTable).SetRange([FldInfo.FilterValue], [FldInfo.FilterValue+
                                        char((DataSource.DataSet as TwwTable).NarrowSearchUpperChar)]);
                            FRangeApplied:= True;
                            exit;
                         end
                      end;
                   end
                end;

              fdMatchRange:
                begin
                   if (FldInfo.FieldName=(DataSource.DataSet as TwwTable).indexFieldName) then
                   begin
                      if (FldInfo.MinValue<>'') and (FldInfo.MaxValue<>'') then
                         (DataSource.DataSet as TwwTable).SetRange([FldInfo.MinValue], [FldInfo.MaxValue])
                      else if FldInfo.MinValue<>'' then
                         (DataSource.DataSet as TwwTable).wwSetRangeStart([FldInfo.MinValue])
                      else begin
                         with (datasource.dataset as TwwTable) do begin
                            setRangeStart;
                            setRangeEnd;
                            indexFields[0].asString:= FldInfo.MaxValue;
                            ApplyRange;
                         end
                      end;

                      FRangeApplied:= True;
                      exit;
                   end
                end;
           end;
        end;
     end

     { Switch index }
     else if fdUseAllIndexes = FilterOptimization then begin
        for i:= 0 to FieldInfo.count-1 do begin
           FldInfo:= TwwFieldInfo(FieldInfo[i]);
           if FldInfo.NonMatching then continue;
           if wwGetFilterOperator(FldInfo.FilterValue,FwwOperators,OrFlg,AndFlg)<>'' then continue;

           if FldInfo.FieldName='' then  { Compute field name from displaylabel if unspecified }
              FldInfo.FieldName:= wwGetFieldNameFromTitle(DataSource.DataSet, FldInfo.DisplayLabel);
           MatchType:= FldInfo.MatchType;

           case MatchType of
              fdMatchStart, fdMatchExact:
                begin
                   with (DataSource.dataSet as TwwTable) do begin
                      tempIndexName:= FieldsToIndexWithCase(FldInfo.FieldName, FldInfo.caseSensitive);
                      if tempIndexName='?' then
                         tempIndexName:= FieldsToIndexWithCase(FldInfo.FieldName, not FldInfo.caseSensitive);

                      if tempIndexName<>'?' then
                      begin
                         IndexName:= tempIndexName;

                         if FldInfo.FilterValue<>'' then begin
                            if MatchType=fdMatchExact then
                            begin
                               SetRange([FldInfo.FilterValue], [FldInfo.FilterValue]);
                               FRangeApplied:= True;
                               exit;
                            end
                            else if (MatchType=fdMatchStart) and
                               (indexFields[0].dataType = ftString) then
                            begin
                               SetRange([FldInfo.FilterValue], [FldInfo.FilterValue+
                                        char(NarrowSearchUpperChar)]);
                               FRangeApplied:= True;
                               exit;
                            end
                         end;
                      end
                   end
                end;

              fdMatchRange:
                begin
                   with (DataSource.dataSet as TwwTable) do begin
                      tempIndexName:= FieldsToIndexWithCase(FldInfo.FieldName, False);
                      if tempIndexName='?' then
                         tempIndexName:= FieldsToIndexWithCase(FldInfo.FieldName, True);

                      if tempIndexName<>'?' then
                      begin
                         IndexName:= tempIndexName;

                         if (FldInfo.MinValue<>'') and (FldInfo.MaxValue<>'') then
                            SetRange([FldInfo.MinValue], [FldInfo.MaxValue])
                         else if FldInfo.MinValue<>'' then
                            wwSetRangeStart([FldInfo.MinValue])
                         else begin
                            setRangeStart;
                            setRangeEnd;
                            indexFields[0].asString:= FldInfo.MaxValue;
                            ApplyRange;
                         end;

                         FRangeApplied:= True;
                         exit;
                      end;

                   end
                end;
           end;
        end;
      end;
   end;

   procedure SetOnFilterEvent;
   var PropInfo: PPropInfo;
       NilMethod: TMethod;
   begin
      NilMethod.data:= DataSource.DataSet;
      if not DataSource.DataSet.active then DataSource.DataSet.active:= True;
      NilMethod.code:= nil;
      PropInfo:= Typinfo.GetPropInfo(Datasource.DataSet.ClassInfo,'OnFilter');
      SetMethodProp(datasource.dataset, PropInfo, NilMethod);
      if DataSource.DataSet is TTable then UseIndexForFilter;
      if FieldInfo.count> 0 then begin
         FOnFilter:= (FDummyForm as TwwDummyForm).OnFilterEvent;
         SetMethodProp(datasource.dataset, PropInfo, TMethod(FOnFilter));
      end;
      {$ifdef WIN32}
      if wwIsClass(datasource.dataset.classType, 'TwwClientDataSet') then
         datasource.dataset.filtered:= True;
      {$endif}
   end;

begin
   result:= False;
   if datasource=nil then exit;
   if datasource.dataset=nil then exit;
   if (not DataSource.dataSet.active) and (FilterMethod=fdByFilter) then
   begin
      MessageDlg('Dataset must be active to perform local filtering (FilterMethod=fdByFilter).',
          mtError, [mbOK], 0);
      exit;
   end;
   if (FwwOperators.OrChar = FwwOperators.AndChar) then
      MessageDlg('And and Or Operators have the same value.',mtWarning,[mbok],0);

   Form:= Nil;

   try
    Screen.cursor:= crHourGlass;
    if ShowDialog then begin
       form:=  TwwFilterDlg.CreateDlg(Application, self);
       form.DlgComponent:= self;
       form.Caption:= Caption;
       form.RefreshFieldList(True);

       ApplyFilter:= False;
       Result:= (form.showModal = mrOK);
       if Result and
          ((form.FilterChanged) or
           (not (ofoEnabled in wwGetOnFilterOptions(datasource.dataset)))) then
       begin
          Form.CopyList(form.FieldInfo, FieldInfo);
          ApplyFilter:= True;
       end
    end
    else ApplyFilter:= True;

    if ApplyFilter then begin
       wwSetOnFilterEnabled(datasource.dataset, True);

       if not (datasource.dataset is TwwQuery) then begin
          SetOnFilterEvent;
       end
       else begin
          case FilterMethod of
             fdByQueryModify:  ExecQueryByNewQuery;
             fdByFilter: begin
                   SetOnFilterEvent;
                end;
          end;
       end;
       result:= True;
    end;

   Finally
     Screen.cursor:= crDefault;
     if ShowDialog then form.Free;
   end;
end;


procedure Register;
begin
end;


procedure TwwFilterDlg.FieldOrderClick(Sender: TObject);
var currentFieldName :string;
begin
   CurrentFieldName:= '';
   if FieldsListBox.itemIndex>=0 then
      CurrentFieldName:= FieldsListBox.items[FieldsListBox.itemIndex];
   RefreshFieldList(FieldTabSet.tabIndex=0);
   FieldsListBox.itemIndex:= FieldsListBox.items.indexOf(CurrentFieldName);
   FieldsListBox.setFocus;
   LastItemIndex:= FieldsListBox.itemIndex;;
end;

Function TwwFilterDlg.GetFilterField(ADisplayLabel: wwSmallString; var FldInfo: TwwFieldInfo): boolean;
var tempFldInfo: TwwFieldInfo;
   i: integer;
begin
   FldInfo:= Nil;
   for i:= 0 to FieldInfo.count-1 do begin
      tempFldInfo:= TwwFieldInfo(FieldInfo[i]);
      if wwEqualStr(strReplaceChar(tempFldInfo.displayLabel,'~', ' '),
                    strReplaceChar(ADisplayLabel,'~', ' ')) then
      begin
         FldInfo:= tempFldInfo;
         break;
      end
   end;

   result:= FldInfo<>Nil;
end;

procedure TwwFilterDlg.SetFilterfield(ADisplayLabel: wwSmallString;
       AMatchType: TwwFilterMatchType; AFilterValue, AMinValue, AMaxValue: string;
       ACaseSensitive, ANonMatching: boolean);
var tempFldInfo: TwwFieldInfo;
   i: integer;
   found: boolean;
begin
   found:= False;

   for i:= 0 to FieldInfo.count-1 do begin

      tempFldInfo:= TwwFieldInfo(FieldInfo[i]);

      if wwEqualStr(tempFldInfo.DisplayLabel, ADisplayLabel) then
      begin
         if ((AFilterValue='') and (AMatchType<>fdMatchRange)) or
            ((AMinValue='') and (AMaxValue='') and (AMatchType=fdMatchRange)) then
         begin
            FieldInfo.delete(i);
            FilterChanged:= True;
            break;
         end
         else begin
            with TwwFieldInfo(FieldInfo[i]) do
            begin
               if (MatchType<>AMatchType) then FilterChanged:= True;

               MatchType:= AMatchType;
               if MatchType=fdMatchRange then
               begin
                  if (MinValue<>AMinValue) or (MaxValue<>AMaxValue) then FilterChanged:= True;
                  MinValue:= AMinValue;
                  MaxValue:= AMaxValue;
               end
               else begin
                  if (FilterValue<>AFilterValue) or (CaseSensitive<>ACaseSensitive) or
                     (NonMatching<>ANonMatching) then
                     FilterChanged:= True;
                  FilterValue:= AFilterValue;
                  CaseSensitive:= ACaseSensitive;
                  NonMatching:= ANonMatching;
               end;
               found:= True;
               break;
            end
         end
      end
   end;

   if (not found) and ((AFilterValue<>'') or (AMinValue<>'') or (AMaxValue<>'')) then
   begin
      tempFldInfo:= TwwFieldInfo.create;
      with tempFldInfo do
      begin
         DisplayLabel:= ADisplayLabel;
         MatchType:= AMatchType;
         if MatchType=fdMatchRange then
         begin
            MinValue:= AMinValue;
            MaxValue:= AMaxValue;
         end
         else begin
            FilterValue:= AFilterValue;
            CaseSensitive:= ACaseSensitive;
            NonMatching:= ANonMatching;
         end;
      end;
      FieldInfo.add(tempFldInfo);
      FilterChanged:= True;
   end
end;

procedure TwwFilterDlg.FieldsListBoxClick(Sender: TObject);
begin
   if SelectField(True) then
   begin
      SelectPage;
      FieldsListBox.SetFocus;
   end
end;

{ FieldChanged indicates have moved to new field so clear unused edit controls }
Function TwwFilterDlg.SelectField(FieldChanged: boolean): boolean;
var MatchType: TwwFilterMatchType;
    DisplayLabel: wwSmallString;
    FilterValue, MinValue, MaxValue: string;
    FldInfo: TwwFieldInfo;
begin
   result:= True;

   if MatchTypeGroup.itemIndex=0 then MatchType:= fdMatchExact
   else if MatchTypeGroup.itemIndex=1 then MatchType:= fdMatchStart
   else MatchType:= fdMatchAny;

   if LastItemIndex>=0 then
   begin
      DisplayLabel:= FieldsListBox.items[LastItemIndex];

      if isValueField(DisplayLabel) and (not ValidEditValues(FilterValueEdit.text)) then begin
         SelectNotebook.pageIndex:= 0;
         FilterValueEdit.SelectAll;
         FilterValueEdit.SetFocus;
         if LastItemIndex<>FieldsListBox.ItemIndex then FieldsListBox.itemIndex:= LastItemIndex;
         result:= False;
         exit;
      end;
      if not ValidEditValue(MinValueEdit.text) then begin
         SelectNotebook.pageIndex:= 1;
         MinValueEdit.SelectAll;
         MinValueEdit.SetFocus;
         if LastItemIndex<>FieldsListBox.ItemIndex then FieldsListBox.itemIndex:= LastItemIndex;
         result:= False;
         exit;
      end;
      if not ValidEditValue(MaxValueEdit.text) then begin
         SelectNotebook.pageIndex:= 1;
         MaxValueEdit.SelectAll;
         MaxValueEdit.SetFocus;
         if LastItemIndex<>FieldsListBox.ItemIndex then FieldsListBox.itemIndex:= LastItemIndex;
         result:= False;
         exit;
      end;

      if FormActivated then begin
        if SelectNotebook.pageIndex=0 then
            SetFilterField(DisplayLabel, MatchType, FilterValueEdit.Text, MinValueEdit.Text,
                 MaxValueEdit.Text, CaseSensitive.checked, NonMatching.checked)
         else begin
            SetFilterField(DisplayLabel, fdMatchRange, FilterValueEdit.Text, MinValueEdit.Text,
                 MaxValueEdit.Text, CaseSensitive.checked, NonMatching.checked);
         end
      end;
      ClearSearchButton.enabled:=  FieldInfo.count>0;
   end;

   if (FieldsListBox.itemIndex>=0) then
   begin
      LastItemIndex:= FieldsListBox.itemIndex;
      DisplayLabel:= FieldsListBox.items[LastItemIndex];
      if GetFilterField(DisplayLabel, FldInfo) then
      begin
         MatchType:= FldInfo.MatchType;
         MinValue:= FldInfo.MinValue;
         MaxValue:= FldInfo.MaxValue;
         FilterValue:= FldInfo.FilterValue;
         CaseSensitive.checked:= FldInfo.caseSensitive;
         NonMatching.checked:= FldInfo.NonMatching;
      end
      else begin
         MatchType:= fdMatchNone;
         FilterValue:= '';
         MinValue:= '';
         MaxValue:= '';
         CaseSensitive.checked:= (fdCaseSensitive in (DlgComponent as TwwFilterDialog).Options);
         NonMatching.checked:= False;
      end;

      if MatchType= fdMatchExact then MatchTypeGroup.itemIndex:= 0
      else if MatchType= fdMatchStart then MatchTypeGroup.itemIndex:= 1
      else if MatchType = fdMatchAny then MatchTypeGroup.itemIndex:= 2
      else begin
         case (DlgComponent as TwwFilterDialog).DefaultMatchType of
            fdMatchExact: MatchTypeGroup.itemIndex:= 0;
            fdMatchStart: MatchTypeGroup.itemIndex:= 1;
            fdMatchAny: MatchTypeGroup.itemIndex:= 2;
         end
      end;

      if MatchType<>fdMatchNone then begin
         if (MatchType=fdMatchRange) then begin
            MinValueEdit.text:= MinValue;
            MaxValueEdit.text:= MaxValue;
            if FieldChanged then FilterValueEdit.text:= '';
         end
         else begin
            FilterValueEdit.text:= FilterValue;
            if FieldChanged then begin
               MinValueEdit.text:= '';
               MaxValueEdit.text:= '';
            end
         end
      end
      else begin
         MinValueEdit.text:= '';
         MaxValueEdit.text:= '';
         FilterValueEdit.text:= '';
      end;
      FieldCriteria.caption:= DisplayLabel;

      if not (DlgDataSet is TTable) and
         isValueField(DisplayLabel) then
      begin
         MatchTypeGroup.itemIndex:= 0;
         MatchTypeGroup.enabled:= False;
         CaseSensitive.enabled:= False;
      end
      {$ifdef win32}                {Memo fields always case-sensitive in Delphi 2 SQL}
      else if (DlgDataSet is TQuery) and
              ((DlgComponent as TwwFilterDialog).FilterMethod = fdByQueryModify) and
              (GetFieldType(DisplayLabel) = ftmemo) then
      begin
         CaseSensitive.checked:=True;
         CaseSensitive.enabled:=False;
         MatchTypeGroup.enabled:=True;
      end
      {$endif}                                           {pwe}
      else begin
         MatchTypeGroup.enabled:= True;
         CaseSensitive.enabled:= True;
      end
   end;


end;

Function TwwFilterDlg.GetFieldType(ADisplayLabel: wwSmallString): TFieldType;
var Dlg: TwwFilterDialog;
    dbInfo: TwwDBFieldInfo;
    Field: TField;
    FieldName: wwSmallString;
begin
   result:= ftUnknown;
   
   Dlg:= TwwFilterDialog(DlgComponent);
   FieldName:= wwGetFieldNameFromTitle(
                 DlgDataSet, ADisplayLabel);
   if FieldName='' then FieldName:= ADisplayLabel;

   { Determine datatype of field }
   Field:= DlgDataSet.FindField(FieldName);
   if Field<>nil then result:= Field.DataType
   else begin
      dbInfo:= Dlg.GetDBInfoForField(FieldName);
      if dbInfo=nil then exit;
      result:= dbInfo.FieldType;
   end;
end;

Procedure TwwFilterDlg.SelectPage;
var FldInfo: TwwFieldInfo;
    DisplayLabel: wwSmallString;
{    ItemIndex: integer;}
    Dlg: TwwFilterDialog;
    curDataType: TFieldType;
begin
   Dlg:= TwwFilterDialog(DlgComponent);
   if FieldsListBox.items.count<=0 then exit;
   if not (fdShowValueRangeTab in Dlg.Options) then begin
      if Dlg.DefaultFilterBy=fdFilterByRange then SelectNotebook.pageIndex:= 1
      else SelectNotebook.pageIndex:= 0;
   end;
   if FieldsListBox.itemIndex<0 then FieldsListBox.itemIndex:= 0;

   DisplayLabel:= FieldsListBox.items[FieldsListBox.itemIndex];
   if GetFilterField(DisplayLabel, FldInfo) then
   begin
      if (FldInfo.MatchType=fdMatchRange) then
         SelectNotebook.pageIndex:= 1
      else
         SelectNotebook.pageIndex:= 0;
   end
   else begin
      curDataType:= GetFieldType(DisplayLabel);

{      FieldName:= wwGetFieldNameFromTitle(
                   DlgDataSet, DisplayLabel);
      if FieldName='' then FieldName:= DisplayLabel;

      Field:= DlgDataSet.FindField(FieldName);
      if Field<>nil then curDataType:= Field.DataType
      else begin
         dbInfo:= Dlg.GetDBInfoForField(FieldName);
         if dbInfo=nil then exit;
         curDataType:= dbInfo.FieldType;
      end;
}
      case TwwFilterDialog(DlgComponent).DefaultFilterBy of
        fdSmartFilter:
          begin
            if isValueType(curDataType) then
               SelectNotebook.pageIndex:= 1
            else SelectNotebook.pageIndex:= 0;
          end;
         fdFilterbyRange: SelectNotebook.pageIndex:= 1
         else SelectNotebook.pageIndex:= 0;
      end
   end;

   ValueRangeTabSet.TabIndex:= SelectNotebook.pageIndex;

end;

procedure TwwFilterDlg.ViewButtonClick(Sender: TObject);
begin
   SelectField(False);

   if FieldInfo.count=0 then begin
      MessageDlg(wwInternational.UserMessages.FilterDlgNoCriteria,
                 mtInformation, [mbok], 0);
      exit;
   end;

   wwFilterDialogView(dlgcomponent,FieldInfo);
   if ValueRangeTabSet.tabIndex=0 then
      FilterValueEdit.setFocus
   else MinValueEdit.setFocus;
end;


procedure TwwFilterDlg.SelectFocus;
begin
   if (SelectNotebook.pageIndex=0) then
   begin
      FilterValueEdit.setFocus;
      FiltervalueEdit.selectAll;
   end
   else begin
      MinValueEdit.setFocus;
      MinValueEdit.selectAll;
   end
end;

Function wwGetFilterToken(FilterValue: string;
                           SearchDelimiter: string;
                           var CurPos: integer): string;
var nextword:string;
    DelimSet:strCharSet;
    curtoken:string;
begin
   DelimSet:=[];
   if (length(SearchDelimiter)=1) then
      DelimSet := DelimSet + [SearchDelimiter[1]];

   nextword := '';
   repeat
      curtoken := wwGetWord(FilterValue,CurPos,
                  [wwgwSkipLeadingBlanks, wwgwQuotesAsWords, wwgwStripQuotes],DelimSet);

      if (UpperCase(curtoken)=UpperCase(SearchDelimiter)) then break
      else if (nextword <> '') and (curtoken <> '') then nextword := nextword + ' ' + curtoken
      else nextword := nextword + curtoken;
   until (CurPos>length(FilterValue)) or (curtoken='');

   if (CurPos > length(FilterValue)) or (curtoken='') then Curpos:=-1;

   result := nextword;
end;


Function wwGetFilterOperator(FilterValue: string;
                           FilterOperator: TwwFieldOperators;
                           var OrFlg: boolean; var AndFlg: boolean): string;

var Count,CurPos:Integer;
    DelimSet : strCharSet;
    tempword:string;

begin
  Count:=0;
  CurPos := 1;
  OrFlg:=False;
  AndFlg:=False;

  DelimSet:=[];
  if (length(FilterOperator.OrChar)=1) then
     DelimSet := DelimSet + [FilterOperator.OrChar[1]];
  if (length(FilterOperator.AndChar)=1) then
     DelimSet := DelimSet + [FilterOperator.AndChar[1]];

  repeat
     tempword := wwGetWord(FilterValue,CurPos,
                 [wwgwSkipLeadingBlanks, wwgwQuotesAsWords, wwgwStripQuotes],DelimSet);
     if (Count> 0) then begin
        if (Uppercase(tempword) = Uppercase(FilterOperator.OrChar)) then
        begin
           OrFlg := True;
           break;
        end
        else if (Uppercase(tempword) = UpperCase(FilterOperator.AndChar)) then
        begin
           AndFlg := True;
           break;
        end;
     end;
     inc(Count);
  until (CurPos>length(FilterValue)) or (tempword='');

  if (not OrFlg) and (not AndFlg) then result:=''
  else
  begin
     if (OrFlg)then begin
        result := FilterOperator.OrChar;
      { result:=False;  }
     end
     else result := FilterOperator.AndChar;
  end;
end;


procedure TwwFilterDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

var PrevItemIndex: integer;

  Function min(x,y: integer): integer;
  begin
    if x<y then result:= x else result:= y;
  end;
  Function max(x,y: integer): integer;
  begin
    if x>y then result:= x else result:= y;
  end;

begin
   if (ActiveControl=FieldsListBox) then begin
      if (FieldTabSet.tabIndex=1) and (Key=VK_Delete) then begin
         SetFilterfield(FieldsListBox.items[FieldsListBox.itemIndex],
            fdMatchNone, '', '', '', False, False);
         RefreshFieldList(False);

        LastItemIndex:= -1;
        FieldsListBox.itemIndex:= 0;

        { Move to correct Value/Range tab page }
        SelectField(True);
        SelectPage;
        FieldsListBox.SetFocus;
        key:= 0;
      end;
      exit;
   end;

   if (key in [vk_Next, vk_prior, vk_up, vk_down]) then begin
      PrevItemIndex:= FieldsListBox.itemIndex;

      if (key=vk_Next) then begin
         if FieldsListBox.itemIndex<FieldsListBox.items.count-1 then
            FieldsListBox.itemIndex:=
               min(FieldsListBox.itemIndex + (FieldsListBox.Height div FieldsListBox.itemHeight),
                   FieldsListBox.items.count-1);
      end
      else if (key=vk_Prior) then begin
         if FieldsListBox.itemIndex>0 then
            FieldsListBox.itemIndex:=
               max(FieldsListBox.itemIndex - (FieldsListBox.Height div FieldsListBox.itemHeight), 0);
      end
      else if (key=vk_down) then begin
         if FieldsListBox.itemIndex<FieldsListBox.items.count-1 then
            FieldsListBox.itemIndex:= FieldsListBox.itemIndex + 1;
      end
      else if (key=vk_up) then begin
         if FieldsListBox.itemIndex>0 then
            FieldsListBox.itemIndex:= FieldsListBox.itemIndex - 1;
      end;

      if FieldsListBox.itemIndex<>PrevItemIndex then begin
         if SelectField(True) then begin
            SelectPage;
            SelectFocus;
         end;
         key:= 0;
      end;
   end
end;

procedure TwwFilterDlg.FormShow(Sender: TObject);
var FldInfo: TwwFieldInfo;
    i: integer;
    Dlg: TwwFilterDialog;
    tempField: TField;
    DefaultField: string;
begin

  Dlg:= DlgComponent as TwwFilterDialog;

  if not (fdShowOKCancel in Dlg.Options) then begin
     OKBtn.Top:= 1000;
     CancelBtn.Top:= 1000;
     width:= width - OKBtn.width - 8;
  end;

  if not (fdShowFieldOrder in Dlg.Options) then begin
     FieldOrder.visible:= False;
     FieldsListBox.height:= FieldsListBox.height + FieldOrder.height ;
     FieldTabset.Top:= FieldTabset.Top + FieldOrder.height ;
  end;

  if not (fdShowViewSummary in Dlg.Options) then begin
     ViewButton.visible:= False;
     ClearSearchButton.left:= ViewButton.Left;
  end;

  if not (fdShowValueRangeTab in Dlg.Options) then begin
     ValueRangeTabSet.visible:= False;
     FieldsListBox.height:= FieldsListBox.height - 13;
     FieldTabset.Top:= FieldTabset.Top - 13;
     FieldOrder.Top:= FieldOrder.Top - 13;
     ClearSearchButton.Top:= ClearSearchButton.Top - 13;
     ViewButton.Top:= ViewButton.Top - 13;
     height:= height - 13;
  end;

  if not (fdShowCaseSensitive in Dlg.Options) then begin
     CaseSensitive.Visible := False;
  end;

  if not (fdShowNonMatching in Dlg.Options) then begin
     Nonmatching.visible:= False;
     if (fdShowCaseSensitive in Dlg.Options) then
        Panel1.height := wwAdjustPixels(26,PixelsPerInch) {*PixelsPerInch) div 96;}
     else
        Panel1.visible := false;
  end
  else begin
     if (fdShowCaseSensitive in Dlg.Options) then
        Panel1.height:= wwAdjustPixels(41,PixelsPerInch) {*PixelsPerInch) div 96}
     else begin
        Panel1.height:= wwAdjustPixels(26,PixelsPerInch); {*PixelsPerInch) div 96;}
        Nonmatching.Top := wwAdjustPixels(5,PixelsPerInch) {*PixelsPerInch) div 96;}
     end;
  end;

  if (Dlg.SortBy = fdSortByFieldName) then FieldOrder.itemIndex := 0
  else FieldOrder.itemIndex:= 1;

  if FieldInfo.count>0 then begin  { Default listbox to show first field of current filter}
     FieldTabset.tabIndex:= 1;
     for i:= 0 to FieldsListBox.items.count-1 do begin
        if GetFilterField(FieldsListBox.items[i], FldInfo) then
        begin
           FieldsListBox.itemIndex:= i;
           break;
        end
     end
  end
  else begin
     tempField:= DlgDataSet.FindField(Dlg.DefaultField);
     if tempField<>Nil then defaultField:= tempField.displayLabel
     else defaultField:= Dlg.DefaultField;

     FieldsListBox.itemIndex:= wwGetListIndex(FieldsListBox.items, DefaultField);
     if FieldsListBox.itemIndex<0 then FieldsListBox.itemIndex:= 0;
  end;

  SelectField(True);
  SelectPage;
  SelectFocus;

  Screen.cursor:= crDefault;

  ApplyIntl;
  Dlg.DoInitDialog;

  if DlgDataSet.Active then FilterChanged:= False
  else FilterChanged:= True;

end;

procedure TwwFilterDlg.ValueRangeTabSetChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
   SelectNotebook.pageIndex:= NewTab;
   if not SelectField(False) then AllowChange:= False;
   SelectFocus;
end;

procedure TwwFilterDlg.FieldTabSetChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var CurrentFieldName: wwSmallString;
begin
   if not SelectField(False) then
   begin
      AllowChange:= False;
      exit;  {Flushes current changes }
   end;

   if (NewTab=1) and (FieldInfo.count=0) then begin
      AllowChange:= False;
      MessageDlg(wwInternational.UserMessages.FilterDlgNoCriteria,
                 mtInformation, [mbok], 0);
      exit;
   end;

   CurrentFieldName:= '';
   if FieldsListBox.itemIndex>=0 then
      CurrentFieldName:= FieldsListBox.items[FieldsListBox.itemIndex];
   RefreshFieldList(NewTab=0);
   FieldsListBox.itemIndex:= FieldsListBox.items.indexOf(CurrentFieldName);
   FieldsListBox.setFocus;
   LastItemIndex:= -1;

   { Move to correct Value/Range tab page }
   SelectField(True);
   SelectPage;
   FieldsListBox.SetFocus;

end;

procedure TwwFilterDlg.ClearSearchButtonClick(Sender: TObject);
var i: integer;
begin
   for i:= 0 to FieldInfo.count-1 do TwwFieldInfo(FieldInfo[i]).Free;
   FieldInfo.clear;

   FilterChanged:= True;
   FilterValueEdit.text:= '';
   MinValueEdit.Text:= '';
   MaxValueEdit.Text:= '';
   ClearSearchButton.enabled:= False;
   MatchTypeGroup.itemIndex:= 1;
   FieldTabSet.tabIndex:= 0;
end;

Function TwwFilterDlg.ValidEditValue(val: string): boolean;
var curField: TField;
begin
   result:= True;
   if val='' then exit;
   curField:= nil;
   if FieldsListBox.itemIndex>=0 then
      curField:= DlgDataSet.FindField(wwGetFieldNameFromTitle(DlgDataSet, FieldsListBox.items[LastItemIndex]));
   result:= (curField=Nil) or wwFieldIsValidValue(curField, val);
end;

Function TwwFilterDlg.ValidEditValues(val: string): boolean;   {pwb}
var curFieldtype: TFieldtype;
    CurPos: Integer;
    testval: string;
begin
   result:= True;
   if val='' then exit;

   if FieldsListBox.itemIndex>=0 then
   begin
      curFieldType := GetFieldType(FieldsListBox.items[LastItemIndex]);

      CurPos:=1;
      repeat
         testval := strGetToken(val,(DlgComponent as TwwFilterDialog).FieldOperators.orChar,CurPos);
         if (CurPos>Length(val)) then CurPos := -1;
         strStripWhiteSpace(testval);
         if not (AnsiCompareText(testval,
                (DlgComponent as TwwFilterDialog).FieldOperators.nullChar)=0) then  {!!!! Paul}
            result := wwIsValidValue(curFieldType, testval);
      until ((CurPos = -1) or (result=False));
   end;
end;


procedure TwwFilterDlg.RefreshClearButton;
var tempEnabled: boolean;
begin
   tempEnabled:= False;
   if FieldInfo.count>0 then tempEnabled:= True
   else if FilterValueEdit.text<>'' then tempEnabled:= True
   else if MinValueEdit.text<>'' then tempEnabled:= True
   else if MaxValueEdit.text<>'' then tempEnabled:= True;

   FilterValueClearButton.enabled:= FilterValueEdit.text<>'';
   MinValueClearButton.enabled:= MinValueEdit.text<>'';
   MaxValueClearButton.enabled:= MaxValueEdit.text<>'';
   ClearSearchButton.enabled:= tempEnabled;
end;

procedure TwwFilterDlg.FilterValueEditChange(Sender: TObject);
begin
   RefreshClearButton;
end;

procedure TwwFilterDlg.MinValueEditChange(Sender: TObject);
begin
   RefreshClearButton;
end;

procedure TwwFilterDlg.MaxValueEditChange(Sender: TObject);
begin
   RefreshClearButton;
end;

procedure TwwFilterDlg.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
   if ModalResult=mrOK then
      if not SelectField(True) then CanClose:= False;
end;

procedure TwwFilterDlg.FormActivate(Sender: TObject);
begin
   FormActivated:= True;
end;

procedure TwwFilterDlg.MinValueClearButtonClick(Sender: TObject);
begin
   MinValueEdit.text:= '';
   MinValueClearButton.enabled:= False;
end;

procedure TwwFilterDlg.MaxValueClearButtonClick(Sender: TObject);
begin
   MaxValueEdit.text:= '';
   MaxValueClearButton.enabled:= False;
end;

procedure TwwFilterDlg.FilterValueClearButtonClick(Sender: TObject);
begin
  FilterValueEdit.text:= '';
  FilterValueClearButton.enabled:= False;
end;

procedure TwwFilterDialog.SetFilterMethod(val: TwwFilterMethod);
begin
   if datasource=nil then FFilterMethod:= val
   else if (datasource.dataset is TTable) or (datasource.dataset is TwwQBE) or
           (datasource.dataset is TwwStoredProc) then begin
      if (val<>fdByFilter) then
         MessageDlg('Invalid FilterMethod for TwwTable, TwwQBE, and TwwStoredProc. ' + #13 +
                     'Only fdByFilter is supported for TwwTable, TwwQBE, and TwwStoredProc', mtWarning, [mbok], 0)
      else FFilterMethod:= fdByFilter;
   end
   else if (datasource.dataset is TQuery) then begin
      FFilterMethod:= val;
   end
end;

Procedure TwwFilterDialog.ClearFilter;
var i: integer;
begin
   for i:= 0 to FieldInfo.count-1 do TwwFieldInfo(FieldInfo[i]).Free;
   FieldInfo.clear;

   { Restore initial state }
   if (datasource<>Nil) and (datasource.dataset is TQuery) and
      (FilterMethod=fdByQueryModify) then
   begin
      if FOrigSQl.count>0 then begin
         (datasource.dataset as TQuery).sql.assign(FOrigSQL);
         FOrigSQL.clear;
      end
   end;

end;

Procedure TwwFilterDialog.ApplyFilter;
begin
   ShowDialog:= False;
   InitFields; { 1/12/96 }
   Execute;
   ShowDialog:= True;
end;

procedure TwwFieldOperators.SetOpChar(var opChar: string; val: String);
begin
   if (val<>opChar) then begin
      strStripWhiteSpace(val);
      opChar:= val
   end;
   if ((AnsiCompareText(FOrChar,FAndChar)  =0) or
      (AnsiCompareText(FNullChar,FOrChar) =0) or
      (AnsiCompareText(FNullChar,FAndChar)=0)) then
      MessageDlg('Operators do not have a unique value.',
                  mtWarning, [mbOK], 0);
end;

procedure TwwFieldOperators.SetOrChar(val: String);
begin
  SetOpChar(FOrChar,val);
end;

procedure TwwFieldOperators.SetAndChar(val: String);
begin
  SetOpChar(FAndChar,val);
end;

procedure TwwFieldOperators.SetNullChar(val: String);
begin
  SetOpChar(FNullChar,val);
end;

procedure TwwFilterDlg.ApplyIntl;
begin
   Font.Style:= wwInternational.DialogFontStyle;
   FieldTabSet.Font.Style:= Font.Style;
   ValueRangeTabSet.Font.Style:= Font.Style;
   
   with wwInternational.FilterDialog do begin
      ViewButton.caption:= BtnViewSummary;
      ViewButton.Hint:= BtnViewSummaryHint;
      ClearSearchButton.caption:= BtnNewSearch;
      ClearSearchButton.Hint:= BtnNewSearchHint;
      FieldOrder.Caption:= FieldOrderLabel;
      FieldOrder.Hint:= FieldOrderHint;
      FieldOrder.Items[0]:= AlphabeticLabel;
      FieldOrder.Items[1]:= LogicalLabel;
      FieldTabSet.Tabs[0]:= AllFieldsLabel;
      FieldTabSet.Tabs[1]:= SearchedFieldsLabel;
      StartingRangeLbl.Caption:= StartingRangeLabel;
      MinValueEdit.Hint:= StartingRangeHint;
      EndingRangeLbl.Caption:= EndingRangeLabel;
      MaxValueEdit.Hint:= EndingRangeHint;
      MinValueClearButton.Caption:= BtnClearMin;
      MinValueClearButton.Hint:= BtnClearMinHint;
      MaxValueClearButton.Caption:= BtnClearMax;
      MaxValueClearButton.Hint:= BtnClearMaxHint;
      FilterValueClearButton.Caption:= BtnClearFilterValue;
      FilterValueClearButton.Hint:= BtnClearFilterValueHint;
      ValueRangeTabSet.Tabs[0]:= ByValueLabel;
      ValueRangeTabSet.Tabs[1]:= ByRangeLabel;
      FieldValueLbl.caption:= FieldValueLabel;
      FilterValueEdit.hint:= FieldValueHint;
      MatchTypeGroup.caption:= SearchTypeLabel;
      MatchTypeGroup.hint:= SearchTypeHint;
      MatchTypeGroup.Items[0]:= MatchExactLabel;
      MatchTypeGroup.Items[1]:= MatchStartLabel;
      MatchTypeGroup.Items[2]:= MatchAnyLabel;
      CaseSensitive.caption:= CaseSensitiveLabel;
      CaseSensitive.hint:= CaseSensitiveHint;
      NonMatching.caption:= NonMatchingLabel;
      NonMatching.hint:= NonMatchingHint;
      FieldsLbl.caption:= FieldsLabel;
      ValueRangeTabSet.hint:= ValueRangeTabHint;
      FieldTabSet.hint:= AllSearchedTabHint;
   end;
end;

Procedure TwwFilterDialog.AddDependent(value: TComponent);
begin
   FDependentComponents.add(value);
end;

Procedure TwwFilterDialog.RemoveDependent(value: TComponent);
begin
   FDependentComponents.remove(value);
end;

Procedure TwwFilterDialog.DoInitDialog;
begin
  if Assigned(FOnInitDialog) then OnInitDialog(form);
end;

end.
