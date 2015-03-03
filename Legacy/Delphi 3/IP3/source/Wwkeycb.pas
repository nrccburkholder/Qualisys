unit Wwkeycb;
{
//
// Components : TwwIncrementalSearch, wwKeyCombo
//
// Copyright (c) 1995, 1996, 1997 by Woll2Woll Software
//
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, db, dbtables, wwtable, wwstr, dialogs, wwcommon,
  wwSystem, ExtCtrls, wwdatsrc, menus, wwtypes,
{$IFDEF WIN32}
bde
{$ELSE}
dbiprocs, dbiTypes, dbierrs
{$ENDIF}
;


type

  wwKeyDataLink = class;
  TwwIncrementalSearch = class;
  TwwAfterSearchEvent = Procedure(Sender: TwwIncrementalSearch; MatchFound: boolean) of object;

  TwwKeyCombo = class(TCustomComboBox)
    private
      FDataLink: wwKeyDataLink;
      FShowAllIndexes: boolean;
      FPrimaryKeyName: string;
      initComboFlag: boolean;

    protected
      procedure Change; override;
      procedure SetDataSource(value : TDataSource);
      Function GetDataSource: TDataSource;
      procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
      Function GetPrimaryName: string;
      procedure SetShowAllIndexes(value: boolean);
      procedure Notification(AComponent: TComponent;
        Operation: TOperation); override;

    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure LinkActive(active: Boolean);
      procedure InitCombo;
      procedure InitComboWithGrid(grid: TComponent);

    published
      property Style; {Must be published before Items}
      property Color;
      property Ctl3D;
      property DragMode;
      property DragCursor;
      property DropDownCount;
      property Enabled;
      property Font;
      property ItemHeight;
{      property Items;}
      property MaxLength;
      property ParentColor;
      property ParentCtl3D;
      property ParentFont;
      property ParentShowHint;
      property PopupMenu;
      property ShowHint;
      property Sorted;
      property TabOrder;
      property TabStop;
      property Text;
      property Visible;
      property OnChange;
      property OnClick;
      property OnDblClick;
      property OnDragDrop;
      property OnDragOver;
      property OnDrawItem;
      property OnDropDown;
      property OnEndDrag;
      property OnEnter;
      property OnExit;
      property OnKeyDown;
      property OnKeyPress;
      property OnKeyUp;
      property OnMeasureItem;
      property ShowAllIndexes: boolean read FShowAllIndexes write SetShowAllIndexes;
      property DataSource: TDataSource read getDataSource write setDataSource;
      property PrimaryKeyName: string read FPrimaryKeyName write FPrimaryKeyName;
  end;


  TwwIncrementalSearch = class(TCustomEdit)
    private
      FDataLink: TDataLink;
      FTimerInterval: integer;
      FTimer: TTimer;
      FOnAfterSearch: TwwAfterSearchEvent;
      FShowMatchText: boolean;
      LastValue: string;
      FieldNo: integer;
      FSearchField: string;

    protected
      procedure SetDataSource(value : TDataSource);
      Function GetDataSource: TDataSource;

    public

      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure FindValue;
      procedure OnEditTimerEvent(Sender: TObject);
      procedure KeyUp(var Key: Word; Shift: TShiftState); override;
      procedure SetSearchField(ASearchField: string);
      procedure Clear;
      {$ifdef ver100} override; {$endif}

    published
      property DataSource: TDataSource read getDataSource write setDataSource;
      property SearchField : string read FSearchField write FSearchField;
      property OnAfterSearch: TwwAfterSearchEvent read FOnAfterSearch write FOnAfterSearch;
      property ShowMatchText: boolean read FShowMatchText write FShowMatchText default False;
      property AutoSelect;
      property AutoSize;
      property BorderStyle;
      property CharCase;
      property Color;
      property Ctl3D;
      property DragCursor;
      property DragMode;
      property Enabled;
      property Font;
      property HideSelection;
      {$ifdef ver100}
      property ImeMode;
      property ImeName;
      {$endif}
      property MaxLength;
      property OEMConvert;
      property ParentColor;
      property ParentCtl3D;
      property ParentFont;
      property ParentShowHint;
      property PasswordChar;
      property PopupMenu;
      property ReadOnly;
      property ShowHint;
      property TabOrder;
      property TabStop;
      property Visible;
      property OnChange;
      property OnClick;
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
  end;


  wwKeyDataLink = class(TDataLink)
    private
      FwwKeyCombo: TwwKeyCombo;
    protected
      procedure ActiveChanged; override;
    public
      constructor Create(key: TwwKeyCombo);
  end;

procedure Register;

implementation

uses wwlocate, wwdbigrd, typinfo, wwintl, wwquery;

constructor wwKeyDataLink.Create(key: TwwKeyCombo);
begin
   FwwKeyCombo:= key;
end;

procedure wwKeyDataLink.ActiveChanged;
begin
   if FwwKeyCombo=Nil then exit;
   FwwKeyCombo.linkActive(active);
end;

constructor TwwKeyCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink:= wwKeyDataLink.create(self);

  initComboFlag:= True;
  style:= csDropDownList;
  FPrimaryKeyName:='PrimaryKey';
end;

destructor TwwKeyCombo.Destroy;
begin
  FDataLink.dataSource:= nil;
  FDataLink.free;
  FDataLink:= Nil;
  inherited destroy;
end;

procedure TwwKeyCombo.SetDataSource(value : TDataSource);
begin
   if (value<>Nil) and
      (value.dataSet<>Nil) and not (value.dataSet is TTable) then
   begin
      MessageDlg('DataSource must point to a TTable.', mtWarning, [mbok], 0);
      exit;
   end;

   FDataLink.dataSource:= value;
{$IFDEF WIN32}
   if value<>Nil then Value.FreeNotification(self); { Win95}
{$ENDIF}
   LinkActive(FdataLink.active);
end;

Function TwwKeyCombo.GetDataSource: TDataSource;
begin
   if FDataLink=Nil then Result:=Nil
   else Result:= FDataLink.dataSource;
end;

procedure TwwKeyCombo.LinkActive(active: Boolean);
begin
   if not Active then exit;
   initComboFlag:= True;
end;

procedure TwwKeyCombo.WMPaint(var Message: TWMPaint);
begin
   if initComboFlag and
      not (csDesigning in ComponentState) then
   begin
      initComboFlag:= False;
      initCombo;
   end;
   inherited;
end;

Function TwwKeyCombo.GetPrimaryName: string;
begin
   if FPrimaryKeyName='' then result:= 'PrimaryKey'
   else result:= FPrimaryKeyName;
end;

procedure TwwKeyCombo.SetShowAllIndexes(value: boolean);
begin
   FShowAllIndexes:= value;
   if (datasource<>nil) {and (FShowAllIndexes<>value) }then
   begin
      initCombo;
   end
end;

procedure TwwKeyCombo.InitCombo;
begin
   InitComboWithGrid(nil);
end;

procedure TwwKeyCombo.InitComboWithGrid(grid: TComponent);
var parts : TStrings;
    i: integer;
    activeIndex, fieldTitle: string;
    table: TTable;
    tempIndexName : string;
    tempVisible: boolean;
    selIndex: integer;
begin
   if datasource=nil then exit;
   if DataSource.DataSet=nil then exit;

   if dataSource.dataSet is TTable then
      table:= dataSource.dataSet as TTable
   else begin
      MessageDlg('TwwKeyCombo: DataSet not initialized for chosen DataSource.',
                 mtWarning, [mbok], 0);
      exit;
   end;

   if table.masterSource<>Nil then begin
      MessageDlg('TwwKeyCombo: Data Source can not be a child table.' + #13 +
                 'Component ' + self.name + ' has a MasterSource defined.',
                 mtWarning, [mbok], 0);
      exit;
   end;

   if wwIsTableQuery(Table) then begin
      MessageDlg('TwwKeyCombo: DataSet cannot be a TwwTable using a Query.',
                 mtWarning, [mbok], 0);
      exit;
   end;

   Items.clear;
   ActiveIndex:= '';

   table.IndexDefs.update;  { refreshes Index list }

   if ShowAllIndexes then begin
      for i:= 0 to Table.IndexDefs.count-1 do begin
         tempIndexName:= table.IndexDefs.Items[i].Name;
         if tempIndexName='' then tempIndexName:= GetPrimaryName;
         self.items.add(tempIndexName);
      end;
      tempIndexName:= Table.IndexName;
      if tempIndexName='' then tempIndexName:= GetPrimaryName;
      ItemIndex:= Items.indexOf(tempIndexName);
      exit;
   end;

   { Fill combo box with list of index names - but show field titles instead of index names}
   parts := TStringList.create;

   if Grid<>Nil then InitComboFlag:= False;

   { 6/6/97 - Use wwEqualStr function to make comparisons case insensitive }
   for i:= 0 to Table.IndexDefs.count-1 do begin
      with Table.IndexDefs.Items[i] do begin
          strBreakApart(fields, ';', parts);
          if not wwDataSetIsValidField(Table, parts[0]) then continue;
          if (grid=nil) then tempVisible:= Table.fieldByName(parts[0]).visible
          else tempVisible:= wwFindSelected((grid as TwwCustomDBGrid).selected, parts[0], SelIndex);
          if tempVisible then begin
             fieldTitle:=  strReplaceChar(Table.fieldByName(parts[0]).displayLabel, '~', ' ');
             if (ixDescending in Options) then begin
                if (fieldTitle<>'') then
                begin
                   if Table.IndexFieldNames = '' then begin
                      if wwEqualStr(Table.IndexDefs.Items[i].name, Table.indexName) then
                         activeIndex:= fieldTitle;
                   end
                   else begin
                      if wwEqualStr(Table.indexFieldNames,Fields) then
                         activeIndex:= fieldTitle;
                   end;

                   if (self.items.indexOf(fieldTitle + ' - Desc')<0) then
                      self.items.add(fieldTitle + ' - Desc');

                end
             end
             else begin
                if (fieldTitle<>'') then
                begin
                   if Table.IndexFieldNames = '' then begin
                      if wwEqualStr(Table.IndexDefs.Items[i].name, Table.indexName) then
                         activeIndex:= fieldTitle;
                   end
                   else begin
                      if wwEqualStr(Table.indexFieldNames, Fields) then
                         activeIndex:= fieldTitle;
                   end;

                   if (self.items.indexOf(fieldTitle)<0) then
                      self.items.add(fieldTitle);

                end
             end
          end
      end
   end;

   {6/16/97 - Support descending index type }
   for i:= 0 to Items.count-1 do
   begin
      if Items[i]=activeIndex then ItemIndex:= i
      else if Items[i]=activeIndex + ' - Desc' then ItemIndex:= i
   end;
   parts.free;

end;

procedure TwwKeyCombo.Change;
var i: integer;
    found: boolean;
    IndexTitle: String;
    parts: TStrings;
    table: TTable;

   Function useThisIndex: boolean;
   begin
      result:= False;
      with Table.IndexDefs do begin
          if (ixDescending in Items[i].Options) then begin
             if (IndexTitle =
                 strReplaceChar(Table.fieldByName(Parts[0]).displayLabel + ' - Desc','~', ' ')) then
             begin
                wwTableChangeIndex(Table, Items[i]);
                result:= True;
                exit;
             end
          end
          else begin
             if (IndexTitle = strReplaceChar(Table.fieldByName(Parts[0]).displayLabel, '~', ' ')) then
             begin
                wwTableChangeIndex(Table, Items[i]);
                result:= True;
                exit;
             end
          end
      end
   end;

begin

   if dataSource=Nil then exit;
   if not (DataSource.dataSet is TTable) then exit;

   IndexTitle:= Text;

   if ShowAllIndexes then begin
      if IndexTitle=GetPrimaryName then IndexTitle:= '';
      (dataSource.dataSet as TTable).indexName:= indexTitle;
      inherited change;  { added 7/20/95}
      exit;
   end;

   parts:= TStringList.Create;

   { Look for case insensitive index for this field }
   { If not found then use case sensitive index     }

   table:= dataSource.dataSet as TTable;

   table.IndexDefs.update;  { refreshes Index list - not sure why this is needed}

   found:= False;
   for i:= 0 to Table.IndexDefs.count-1 do begin
      with Table.IndexDefs do begin
          strBreakApart(Items[i].fields, ';', parts);
          if not ( wwDataSetIsValidField(Table, Parts[0]) and
                  (ixCaseInsensitive in Items[i].Options)) then continue;
          if useThisIndex then begin
             Found:= True;
             break;
          end
       end
   end;

   if not Found then begin
      for i:= 0 to Table.IndexDefs.count-1 do begin
         with Table.IndexDefs do begin
             strBreakApart(Items[i].fields, ';', parts);
             if not wwDataSetIsValidField(Table, Parts[0]) then continue;
             if useThisIndex then break;
          end
      end;
   end;

   parts.Free;

   itemIndex:= items.indexOf(IndexTitle); {ft5 bug requires this redundancy}

   inherited change;

end;


constructor TwwIncrementalSearch.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink:= TDataLink.create;
  FTimer:= TTimer.create(self);
  FTimer.enabled:= False;
  FTimerInterval:= 333;
  FTimer.Interval:= FTimerInterval;
  FTimer.OnTimer:= OnEditTimerEvent;
  LastValue:= '';
  Text:= '';
  FieldNo:= 0;
end;

destructor TwwIncrementalSearch.Destroy;
begin
  FDataLink.free;
  FTimer.free;
  inherited destroy;
end;

procedure TwwIncrementalSearch.OnEditTimerEvent(Sender: TObject);
begin
   if not FTimer.enabled then exit;
   FTimer.enabled:= False;
   if text <> lastValue then
   begin
      findValue;
      lastValue:= text;
   end;
end;

procedure TwwIncrementalSearch.SetDataSource(value : TDataSource);
begin
   FDataLink.dataSource:= value;
end;

Function TwwIncrementalSearch.GetDataSource: TDataSource;
begin
   Result:= FdataLink.dataSource;
end;

procedure TwwIncrementalSearch.KeyUp(var Key: Word; Shift: TShiftState);
   Function isValidChar(key: word): boolean;
   begin
      result:= (key = VK_BACK) or (key=VK_SPACE) or (key=VK_DELETE) or
               ((key >= ord('0')) and (key<=VK_DIVIDE)) or
               (key>VK_SCROLL); { Support international characters }
   end;
begin
  inherited KeyUp(Key, Shift);
  if ((lastValue<>Text) and IsValidChar(Key)) then
  begin
     if FShowMatchText and (key in [VK_BACK, VK_DELETE]) then begin
        { 1/29/97 - Cancel range when blank }
        if (datasource.dataset is TwwTable) and (datasource.dataset as TwwTable).narrowSearch
           and (Text = '') then
           (datasource.dataset as TwwTable).FastCancelRange;
        exit;
     end;

     FTimer.enabled:= False;
     if (dataSource=Nil) then begin
         MessageDlg('DataSource not defined - object ' + name, mtWarning, [mbok], 0);
         exit;
     end;
     if (dataSource.dataSet=Nil) then begin
         MessageDlg('Dataset not defined for DataSource', mtWarning, [mbok], 0);
         exit;
     end;

     if not wwIsClass(DataSource.DataSet.classType, 'TwwClientDataSet') then
     begin
        if datasource.dataset.active then
           if not (datasource.dataSet as TDBDataSet).database.isSQLBased then
              FTimer.Interval:= FTimerInterval div 2;
     end;
     FTimer.enabled:= True;
  end
end;

procedure TwwIncrementalSearch.FindValue;
var
   dataSet : TDataSet;
   SearchIndex: integer;
   i: integer;
   tempSearchField: wwSmallString;
   SearchText: string;
   isQuery, isFound: boolean;
   {$ifdef ver100}
   curField: TField;
   {$endif}

   Function isExpressionIndex(table: TDataSet): boolean;
   var curpos: integer;
       expression: string;
       curWord: wwSmallString;
   begin
      result:= False;
      with Table as TTable do begin
         if (TableType = ttDBase) or
            (CompareText(ExtractFileExt(TableName), '.DBF') = 0) then
         begin
            if (IndexDefs.indexof(IndexName)>=0) and
               (ixExpression in IndexDefs.Items[IndexDefs.indexof(IndexName)].Options) then
            begin
               TempSearchField:= SearchField;
               if SearchField<>'' then begin
                  result:= True;
               end
               else begin
                  expression:= Uppercase(IndexDefs.Items[IndexDefs.indexOf(IndexName)].expression);
                  curPos:= 1;
                  repeat
                     curWord:=
                        wwGetWord(Expression, curpos, [wwgwSkipLeadingBlanks],
                            [ ')','(', '+', '-', '*', '/']);
                     if FindField(curWord)<>Nil then begin
                        TempSearchField:= curWord;
                        result:= True;
                        exit;
                     end
                  until (curWord='');
               end
            end
         end
      end
   end;

begin
   if dataSource=Nil then exit;
   if dataSource.dataSet=Nil then exit;
   if not dataSource.dataset.Active then exit;
   dataSet := dataSource.DataSet as TDataSet;
   isQuery:= False;
   TempSearchField:= SearchField;

   if (dataSet is TTable) then begin
     with (DataSet as TTable) do
        if not wwIsTableQuery(DataSet) and (IndexDefs.count=0) then IndexDefs.update;  { refreshes Index list }

     if ((dataset as TTable).indexFieldCount=0) and wwIsTableQuery(DataSet) then begin
        isQuery:= True;
        if SearchField='' then TempSearchField:= dataset.fields[0].FieldName
        else TempSearchField:= SearchField;
        isFound:= wwDataSetFindRecord(DataSet, Text, TempSearchField, mtPartialMatchStart, False);
     end
     else if isExpressionIndex(dataSet) then
     begin
        with DataSet as TTable do begin
           if not wwFieldIsValidValue(FieldbyName(TempSearchField), text) then exit;
           EditKey;
           FieldByName(TempSearchField).asString:= text;
           GoToNearest;
           isFound:= pos(Uppercase(Text), Uppercase(FieldByName(TempSearchField).asString))=1;
        end
     end
     else begin
        SearchIndex:= 0;
        if SearchField<>'' then with DataSet as TTable do begin
           for i:= 0 to indexFieldCount-1 do
              if (lowercase(SearchField)=lowercase(indexFields[i].fieldName)) then
                 SearchIndex:= i;
        end;
        if (DataSet as TTable).indexFieldCount>0 then
           isFound:= wwTableFindNearest(dataSet as TTable, Text, SearchIndex)
        else begin
           if SearchField='' then TempSearchField:= dataset.fields[0].FieldName
           else TempSearchField:= SearchField;
           isFound:= wwDataSetFindRecord(DataSet, Text, TempSearchField, mtPartialMatchStart, False);
        end
     end
   end
   else begin
      isQuery:= True;
      if SearchField='' then TempSearchField:= dataset.fields[0].FieldName
      else TempSearchField:= SearchField;

      {$ifdef ver100}
      curField:= DataSet.FindField(TempSearchField);
      if (not wwFieldIsValidLocateValue(curField, Text)) then begin { If invalid value type then skip search }
         isFound:= False;
      end
      else if (not wwIsClass(DataSet.classType, 'TwwQuery')) or  {ClientDataSet Locate fails on partial match }
              (not wwInternational.UseLocateMethodForSearch) then
         isFound:= wwDataSetFindRecord(DataSet, Text, TempSearchField, mtPartialMatchStart, False)
      else begin
         { Require seq search on live parameterized query as Delphi Locate does not support this}
         if (DataSet is TwwQuery) and TwwQuery(DataSet).RequestLive and
                   TwwQuery(DataSet).CanModify and (TwwQuery(DataSet).DataSource<>Nil) then
         begin
             isFound:= wwDataSetFindRecord(DataSet, Text, TempSearchField, mtPartialMatchStart, False);
         end
         else begin
            Screen.cursor:= crHourGlass;
            try
              if TwwQuery(DataSet).isValidIndexField(TempSearchField, False) then
                 isFound:= DataSet.Locate(TempSearchField, Text, [loPartialKey, loCaseInsensitive])
              else if TwwQuery(DataSet).isValidIndexField(TempSearchField, True) then
                 isFound:= DataSet.Locate(TempSearchField, Text, [loPartialKey])
              else
                 isFound:= wwDataSetFindRecord(DataSet, Text, TempSearchField, mtPartialMatchStart, False);
            except { 7/1/97 - In case of capability not supported }
              isFound:= wwDataSetFindRecord(DataSet, Text, TempSearchField, mtPartialMatchStart, False);
            end;
            Screen.cursor:= crDefault;
         end
      end;
      {$else}
      isFound:= wwDataSetFindRecord(DataSet, Text, TempSearchField, mtPartialMatchStart, False);
      {$endif}

   end;

   if Assigned(FOnAfterSearch) then FOnAfterSearch(self, isFound);

   if FShowMatchText and isFound then begin
      SearchText:= Text;
      if isQuery then
         Text:=  DataSource.DataSet.FieldByName(TempSearchField).asString
      else if (TempSearchField<>'') then  { 4/11/97 - Support searchfield }
         Text:=  DataSource.DataSet.FieldByName(TempSearchField).asString
      else Text:=  (DataSource.DataSet as TwwTable).IndexFields[0].asString;
      selStart:= length(SearchText);
      selLength:= length(Text)-length(SearchText)
   end

end;

procedure TwwIncrementalSearch.SetSearchField(ASearchField: string);
begin
   SearchField:= ASearchField;
end;

procedure TwwIncrementalSearch.Clear;
begin
   Text:= '';
   LastValue:= '';
end;

procedure TwwKeyCombo.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure Register;
begin
{  RegisterComponents('InfoPower', [TwwKeyCombo]);
  RegisterComponents('InfoPower', [TwwIncrementalEdit]);
}
end;

end.
