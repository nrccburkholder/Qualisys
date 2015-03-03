unit Wwcommon;
{$T-}  { Disable Typed@ Operator}
{
//
// Components : Common routines
//
// Copyright (c) 1995, 1996, 1997 by Woll2Woll Software
//
}
interface

uses classes, db, sysutils, dialogs, wwstr, dbTables, forms, controls,
     wintypes, winprocs, graphics, buttons, wwtypes, wwlocate, wwstorep,
     stdctrls,

(*
{$ifdef delphi3_cs}
      wwclient,
{$endif}
*)

{$IFDEF WIN32}
bde, registry
{$ELSE}
dbiprocs, dbiTypes, dbierrs
{$ENDIF}
;

const
   WW_DB_COMBO = 'Combo';
   WW_DB_LOOKUP_COMBO = 'LookupCombo';  { Backward compatibility with Infopower 1.2}
   WW_DB_EDIT = 'CustomEdit';
   WW_DB_RICHEDIT = 'RichEdit';


type
{$ifdef win32}
  wwSmallString = string;
{$else}
  wwSmallString = string[64];
{$endif}

Function wwGetPictureMasks(DataSet: TDataSet): TStrings;
Function wwGetControlType(dataSet: TDataSet): TStrings;
Function wwGetValidateWithMask(dataSet: TDataSet): boolean;
Function wwGetLookupFields(dataSet: TDataSet): TStrings;
Function wwGetLookupLinks(dataSet: TDataSet): TStrings;
Function wwGetDatabaseName(dataSet: TDataSet): String;
Function wwGetTableName(dataSet: TDataSet): String;
Function wwDataSetIsValidField(dataset : TDataSet; fieldName : string): boolean;
Procedure wwDataSetUpdateFieldProperties(dataSet: TDataSet; selected: TStrings);
Procedure wwDataSetUpdateSelected(dataSet: TDataSet; selected: TStrings);
Function wwDataSet(dataSet : TDataSet): boolean;
Procedure wwDebug(s: string);
Function wwSetLookupField(dataSet: TDataSet; linkedField: TField): boolean;
procedure wwDataSetDoOnCalcFields(dataSet: TDataSet;
          FLookupFields, FLookupLinks: TStrings;
          lookupTables: TList);
procedure wwDataSetRemoveObsolete(dataSet: TDataSet;
          FLookupFields, FLookupLinks, FControlType: TStrings);
Function wwTableFindNearest(dataSet: TDataSet; key: string; FieldNo: integer): boolean;
procedure wwTableChangeIndex(dataSet: TDataSet; a_indexItem: TIndexDef);
Function wwDataSetGetLinks(dataSet: TDataSet; lookupFieldName: string): string;
Function wwDataSetGetDisplayField(dataSet: TDataSet; lookupFieldName: string): string;
Function wwDataSetSyncLookupTable(dataSet: TDataSet; AlookupTable: TDataSet;
                  lookupFieldName: string; var fromField: string): boolean;
Function wwDataSetRemoveObsoleteControls(parentForm: TCustomForm; dataSet: TDataSet): boolean;

procedure wwDataSet_SetControl(dataSet: TDataSet;
          AFieldName: string; AComponentType: string; AParameters: string);
function wwFieldIsValidValue(fld: TField; key: string): boolean;
Function wwIsValidValue(FldType: TFieldType; key: string):boolean;
Function wwFieldIsValidLocateValue(fld: TField; key: string):boolean;
Function wwGetAlias(aliasName: string): string;
Function wwSaveAnswerTable(ADataSet: TDBDataSet; AHandle: HDbiCur; tableName: string): boolean;
Function wwInPaintCopyState(ControlState: TControlState): boolean;
Function wwDataSetLookupDisplayField(
   curField: TField; var LookupValue: string; var DisplayField: TField): boolean;
procedure wwPlayKeystroke(Handle: HWND; VKChar: word; VKShift: Word);
procedure wwDataSet_GetControl(dataSet: TDataSet; AFieldName: string;
                      var AControlType: string; var AParameters: string);
function wwGetQueryText(tempQBE: TStrings; Sql: boolean): PChar;
Function wwMemAvail(memSize: integer): boolean;
Procedure wwPictureByField(DataSet: TDataset; FieldName: string; FromTable: boolean;
    var Mask: string; var AutoFill, UsePictureMask: boolean);
procedure wwSetPictureMask(dataSet: TDataSet; AFieldName: string;
    AMask: string;
    AutoFill: boolean;
    UsePictureMask: boolean;
    SetMask: boolean;
    SetAutoFill: boolean;
    SetUsePictureMask: boolean);
Function wwGetFieldNameFromTitle(DataSet: TDataSet; fieldTitle: string): string;
Function wwGetListIndex(list: TStrings; itemName: string): integer;
Function wwGetOwnerForm(component: TComponent):TCustomForm;
procedure wwClearAltChar;
Function isWWEditControl(pname: string): boolean;
procedure wwDataModuleChanged(temp: TComponent);
Function wwDoLookupTable(ALookupTable : TTable;  DataSet: TDataset; links: TStrings) : boolean;
{$ifdef win32}
Procedure wwDrawEllipsis(Canvas: TCanvas; R: TRect;
    State: TButtonState;
    Enabled: Boolean;
    ControlState: TControlState);
Procedure wwDrawDropDownArrow(Canvas: TCanvas; R: TRect;
    State: TButtonState;
    Enabled: Boolean;
    ControlState: TControlState);
{$endif}
Function wwHasIndex(ADataSet: TDataSet): boolean;
Function wwIsTableQuery(ADataSet: TDataSet): boolean;
Function wwPdxPictureMask(ADataSet: TDataSet; AFieldName: string): string;
procedure wwFixMouseDown;
procedure wwValidatePictureFields(ADataSet: TDataSet;
     FOnInvalidValue: TwwInvalidValueEvent);
function wwDataSetFindRecord(
   DataSet: TDataSet;
   KeyValue: string;
   LookupField: string;
   MatchType: TwwLocateMatchType;
   caseSensitive: boolean): boolean;
Procedure wwOpenPictureDB(wwtable: TTable);
Function wwValidFilterableFieldType(ADataType: TFieldType): boolean;
procedure wwHelp(Handle: HWND; HelpTopic: PChar);
Function wwIsValidChar(key: word): boolean;
Function wwGetOnInvalidValue(DataSet: TDataSet): TwwInvalidValueEvent;

procedure wwDataSet_SetLookupLink(dataSet: TDataSet;
   FldName, DatabaseName, TableName, DisplayFld, IndexFieldNames, Links: string;
   useExtension: Char);
Function wwFindSelected(selected: TStrings;
   FieldName: string; var index: integer): boolean;
Function wwAdjustPixels(PixelSize,PixelsPerInch : integer): integer;
Function wwProcessEscapeFilterEvent(dataset: TDataset): boolean;
Procedure wwSetOnFilterEnabled(dataset: TDataset; val: boolean);
Function wwGetOnFilterOptions(dataset: TDataset): TwwOnFilterOptions;
Function isCBuilder: boolean;
Function wwmin(x,y: integer): integer;  {4/10/97}
Function wwmax(x,y: integer): integer;  {4/10/97}
Function wwDataSet_GetFilterLookupField(dataSet: TDataSet; curfield: TField; AMethod: TMethod): TField;
Procedure wwConvertFieldToParam(OtherField:TField;var AFilterParam:TParam;AFilterFieldBuffer: PChar);
Function wwisNonBDEField(thisField: TField): boolean;
Function wwisNonPhysicalField(thisField: TField): boolean;
Function wwSetControlDataSource(ctrl: TWinControl; ds: TDataSource): boolean;
Function wwSetControlDataField(ctrl: TWinControl; df: string): boolean;
Function wwGetControlDataField(ctrl: TWinControl): string;
Function wwGetControlDataSource(ctrl: TComponent): TDataSource;
function wwDataSetCompareBookmarks(DataSet: TDataSet; Bookmark1, Bookmark2: TBookmark): CmpBkmkRslt;
function wwIsClass(ClassType: TClass; const Name: string): Boolean;
function wwGetWorkingRect:TRect;
procedure wwApplyPictureMask(Control: TCustomEdit; PictureMask: string; AutoFill: boolean; var Key: Char);
Function wwValidPictureValue(Control: TCustomEdit; PictureMask: string): boolean;

implementation

uses wwTable, wwQuery, wwQBE, wwsystem, Messages, wwpict, wwintl, typinfo;

var inLookupCalcLink : boolean;   {Internal Use Only}

{ 5/12/97 - Use generic way to retrieve propery }
Function wwGetOnInvalidValue(DataSet: TDataSet): TwwInvalidValueEvent;
var PropInfo: PPropInfo;
    method: TMethod;
begin
   Result:= Nil;
   PropInfo:= Typinfo.GetPropInfo(DataSet.ClassInfo,'OnInvalidValue');
   if PropInfo<>Nil then begin
      method:= GetMethodProp(DataSet, PropInfo);
      if method.code<>Nil then
         result:= TwwInvalidValueEvent(method);
   end
end;

Function wwGetPictureMasks(DataSet: TDataSet): TStrings;
var PropInfo: PPropInfo;
begin
   Result:= Nil;
   PropInfo:= Typinfo.GetPropInfo(DataSet.ClassInfo,'PictureMasks');
   if PropInfo<>Nil then
      result:= TStrings(GetOrdProp(DataSet, PropInfo));
end;

Function wwGetControlType(DataSet: TDataSet): TStrings;
var PropInfo: PPropInfo;
begin
   Result:= Nil;
   PropInfo:= Typinfo.GetPropInfo(DataSet.ClassInfo,'ControlType');
   if PropInfo<>Nil then
      result:= TStrings(GetOrdProp(DataSet, PropInfo));
end;

Function wwGetValidateWithMask(dataSet: TDataSet): boolean;
var PropInfo: PPropInfo;
begin
   Result:= False;
   PropInfo:= Typinfo.GetPropInfo(DataSet.ClassInfo,'ValidateWithMask');
   if PropInfo<>Nil then
      result:= Boolean(GetOrdProp(DataSet, PropInfo));
end;

Function wwGetLookupFields(dataSet: TDataSet): TStrings;
var PropInfo: PPropInfo;
begin
   Result:= Nil;
   PropInfo:= Typinfo.GetPropInfo(DataSet.ClassInfo,'LookupFields');
   if PropInfo<>Nil then
      result:= TStrings(GetOrdProp(DataSet, PropInfo));
end;

Function wwGetLookupLinks(dataSet: TDataSet): TStrings;
var PropInfo: PPropInfo;
begin
   Result:= Nil;
   PropInfo:= Typinfo.GetPropInfo(DataSet.ClassInfo,'LookupLinks');
   if PropInfo<>Nil then
      result:= TStrings(GetOrdProp(DataSet, PropInfo));
end;

Function wwGetLookupTables(dataSet: TDataSet): TList;
{var PropInfo: PPropInfo;}
begin
   if dataSet is TwwTable then result:= TwwTable(dataSet).LookupTables
   else if dataSet is TwwQuery then result:= TwwQuery(dataSet).LookupTables
   else if dataSet is TwwQBE then result:= TwwQBE(dataSet).LookupTables
   else if dataSet is TwwStoredProc then result:= TwwStoredProc(dataSet).LookupTables
(*
   {$ifdef delphi3_cs}
   else if dataSet is TwwClientDataSet then result:= TwwClientDataSet(dataSet).LookupTables
   {$endif}
*)
   else result:= nil
end;

Function wwGetFilterFieldValue(method: TMethod;AFieldName:string): TParam;
begin
   result:= TwwFilterFieldMethod(Method)(AFieldName);
end;

Function wwDataSetGetLinks(dataSet: TDataSet; lookupFieldName: string): string;
var parts: TStrings;
    i: integer;
    FLookupFields, FLookupLinks: TStrings;
begin
   result:= '';
   if wwGetLookupLinks(dataSet)=Nil then exit;

   parts:= TStringList.create;
   FLookupFields:= wwGetLookupFields(dataSet);
   FLookupLinks:= wwGetLookupLinks(dataSet);

   try
      for i:= 0 to FLookupfields.count-1 do begin
         strBreakApart(FLookupFields.Strings[i], ';', parts);
         if (parts[0]= lookupfieldName) then begin
            result:= FlookupLinks.strings[i];
            break;
         end
      end;
      parts.free;
   except
      parts.free;
   end
end;

Function wwDataSetGetDisplayField(dataSet: TDataSet; lookupFieldName: string): string;
var parts: TStrings;
    i: integer;
    FLookupFields: TStrings;
begin
   result:= '';
   if wwGetLookupFields(dataSet)=Nil then exit;

   parts:= TStringList.create;
   FLookupFields:= wwGetLookupFields(dataSet);

   try
      for i:= 0 to FLookupfields.count-1 do begin
         strBreakApart(FLookupFields.Strings[i], ';', parts);
         if (parts[0]= lookupfieldName) then begin
            result:= parts[3];
            break;
         end
      end;
   finally
      parts.free;
   end
end;

Function wwGetDatabaseName(dataSet: TDataSet): String;
var PropInfo: PPropInfo;
begin
   Result:= '';
   PropInfo:= Typinfo.GetPropInfo(DataSet.ClassInfo, 'DatabaseName');
   if PropInfo<>Nil then
      result:= GetStrProp(DataSet, PropInfo);
end;

Function wwGetTableName(dataSet: TDataSet): String;
begin
   if dataSet is TwwTable then result:= TwwTable(dataSet).tableName
   else result:= '?';
end;

Function wwDataSetIsValidField(dataset : TDataSet; fieldName : string): boolean;
var i: integer;
begin
   result:= False;
   if dataSet=Nil then exit;

   with dataset do begin
      for i:= 0 to fieldCount-1 do begin
         if (uppercase(fieldName) = uppercase(fields[i].fieldName)) then begin
            result:= true;
            break;
         end;
      end
   end
end;


procedure wwDataSetUpdateFieldProperties(dataSet: TDataSet; selected: TStrings);
var i: integer;
    parts: TStrings;
begin
   parts := TStringList.create;

   dataSet.disableControls; {5/27/95}

   for i:= 0 to dataSet.fieldCount-1 do begin
      dataSet.fields[i].visible:= False;
   end;
   if selected<>Nil then begin
      for i:= 0 to selected.count-1 do begin
         strBreakApart(selected[i], #9, parts);
         if wwDataSetIsValidfield(dataSet, parts[0]) then begin
            dataSet.fieldByName(parts[0]).displayWidth:= strtoint(parts[1]);
            dataSet.fieldByName(parts[0]).displayLabel:= parts[2];
            dataSet.fieldByName(parts[0]).index:= i;
            dataSet.fieldByName(parts[0]).visible:= True;
         end;
      end;
   end;

   dataSet.enableControls; {5/27/95}

   parts.Free;
end;

Function wwDataSet(dataSet : TDataSet): boolean;
begin
   if dataset=nil then result:= false
   else
     result:=
     wwIsClass(dataset.classType, 'TwwTable') or
     wwIsClass(dataset.classType, 'TwwQuery') or
     wwIsClass(dataset.classType, 'TwwQBE') or
     wwIsClass(dataset.classType, 'TwwStoredProc') or
     wwIsClass(dataset.classType, 'TwwClientDataSet');
end;

Procedure wwDebug(s: string);
begin
   MessageDlg(s, mtinformation, [mbok], 0);
end;

{ Win95 for Bitmap support }
procedure GetLookupFields(curField: Tfield;
   var databasename, tableName, displayFieldName: string;
   var joins: string);
var found: boolean;
    i: integer;
    parts: TStrings;
    gridTable: TDataSet;
begin
      found:= false;
      gridTable:= curField.dataset;
      if gridTable=nil then exit;

      parts:= TStringList.create;

      with wwGetLookupFields(gridTable) do begin
         for i:= 0 to count-1 do begin
            strBreakApart(strings[i], ';', parts);
            if parts[0]=curField.fieldName then begin
               if parts.count<5 then continue;

               found:=True;
               databaseName:= parts[1];
               tableName:= parts[2];
               displayFieldName:= parts[3];

               joins:= wwGetLookupLinks(gridTable).Strings[i];
               break;
            end
         end
      end;

      if not found then begin
         databaseName:= wwGetDatabaseName(gridTable);
         tableName:= '';
         displayFieldName:= '';
         joins:= '';
      end;

      parts.free;

end;

{ Win95 for Bitmap support }
Function wwDataSetLookupDisplayField(
   curField: TField; var LookupValue: string; var DisplayField: TField): boolean;
var
    j, APos: integer;
    lookupTable: TwwTable;
    databasename, tableName, displayFieldName, joins: string;
    lookupTables: TList;
begin
    displayField:= curField;
    result:= False;
    if (curField=Nil) or (curField.dataSet=nil) then exit;
    if (wwGetLookupTables(curField.dataset)=nil) then exit;

    GetLookupFields(curField, databasename, tableName, displayFieldName, joins);
    LookupTables:= wwGetLookupTables(curField.dataset);

    for j:= 0 to LookupTables.count-1 do begin
       lookupTable:= TwwTable(lookupTables.items[j]);
       if (lookupTable.databaseName=databaseName) and
          (lookupTable.tableName=tableName) then
       begin
          if (lowercase(joins)=lowercase(lookupTable.CalcLookupLinks)) then
          begin
             DisplayField:= lookupTable.FieldByname(DisplayFieldName);
             APos:= 1;
             LookupValue:= curField.dataset.FieldByName(strGetToken(joins, ';', APos)).asString;
             result:= lookupTable.wwFindKey([lookupValue]);
             exit;
          end
       end
    end;

end;

Function wwDoLookupTable(ALookupTable : TTable;  DataSet: TDataset; links: TStrings) : boolean;
var res: boolean;
    lookupTable: TwwTable;
begin
   res:= False;
   lookupTable:= AlookupTable as TwwTable;
   with DataSet do begin
      if LookupTable.IndexFieldCount=0 then begin
         result:= LookupTable.wwFindRecord(FieldByName(links[0]).asString, links[1],
{                            FieldByName(links[1]).FieldName,}  { 1/17/96 - FieldByName ref. is incorrect}
                            mtExactMatch, False);
         exit;
      end;

      case (links.count) of
         2:  res:= lookupTable.wwFindKey(
                [FieldByName(links[0]).asString]);

         4:  res:= lookupTable.wwFindKey(
                      [FieldByName(links[0]).asString,
                       FieldByName(links[2]).asString] );

         6:  res:= lookupTable.wwFindKey(
                      [FieldByName(links[0]).asString,
                       FieldByName(links[2]).asString,
                       FieldByName(links[4]).asString] );

         8:  res:= lookupTable.wwFindKey(
                      [FieldByName(links[0]).asString,
                       FieldByName(links[2]).asString,
                       FieldByName(links[4]).asString,
                       FieldByName(links[6]).asString] );

        10:  res:= lookupTable.wwFindKey(
                      [FieldByName(links[0]).asString,
                       FieldByName(links[2]).asString,
                       FieldByName(links[4]).asString,
                       FieldByName(links[6]).asstring,
                       FieldByName(links[8]).asString] );

        12:  res:= lookupTable.wwFindKey(
                      [FieldByName(links[0]).asString,
                       FieldByName(links[2]).asString,
                       FieldByName(links[4]).asString,
                       FieldByName(links[6]).asstring,
                       FieldByName(links[8]).asstring,
                       FieldByName(links[10]).asString] );
         else;
      end;
   end;

   result:= res;
end;

Function wwisNonBDEField(thisField: TField): boolean;
begin
   {$ifdef win32}
   result:=  thisfield.calculated or thisfield.lookup;
   if (not result) and (thisField.dataset<>nil) then
      result:= wwIsClass(thisField.dataset.classType, 'TwwClientDataSet');
{      result:= PTypeInfo(thisField.dataset.classInfo)^.Name='TwwClientDataSet';}
   {$else}
   result:=  thisfield.calculated;
   {$endif}
end;

Function wwisNonPhysicalField(thisField: TField): boolean;
begin
   {$ifdef win32}
   result:=  thisfield.calculated or thisfield.lookup;
   {$else}
   result:=  thisfield.calculated;
   {$endif}
end;

Procedure wwConvertFieldToParam(OtherField:TField;var AFilterParam:TParam;AFilterFieldBuffer: PChar);
var
   tempInt: integer;
   tempdouble: double;
   tempSmallInt: smallint;
  {$ifdef win32}
   tempTimeStamp: TTimeStamp;
  {$else}
   tempTime:LongInt;
   tempDate:LongInt;
   tempDateTime:double;
  {$endif}
   tempWordBool: WordBool;
  {tempBCD : fmtBCD;}
begin
   case OtherField.DataType of
      ftString:
        begin
          strPLCopy(AFilterFieldBuffer, OtherField.asString, 32767);
          AFilterParam.SetData(AFilterFieldBuffer);
        end;
      ftSmallint,ftWord:
        begin
          tempSmallInt:= OtherField.asInteger;
          move(tempSmallInt, AFilterFieldBuffer^, 2);
          AFilterParam.SetData(AFilterFieldBuffer);
        end;
      ftInteger:
        begin
          tempInt:= OtherField.asInteger;
          move(tempInt, AFilterFieldBuffer^, 4);
          AFilterParam.SetData(AFilterFieldBuffer);
        end;
      ftFloat,ftCurrency:
        begin
          tempDouble:= OtherField.asFloat;
          move(tempDouble, AFilterFieldBuffer^, 8);
          AFilterParam.SetData(AFilterFieldBuffer);
        end;
      ftBoolean:
        begin
          tempWordBool:= OtherField.asBoolean;
          move(tempWordBool, AFilterFieldBuffer^, 1);
          AFilterParam.SetData(AFilterFieldBuffer);
        end;
      ftTime:
        begin
         {$ifdef win32}
           tempTimeStamp:= DateTimeToTimeStamp(OtherField.asDateTime);
           move(tempTimeStamp.time, AFilterFieldBuffer^, 4);
           AFilterParam.SetData(AFilterFieldBuffer);
         {$else}
           tempTime := Round(Frac(OtherField.AsDateTime) * MSecsPerDay);
           move(tempTime, AFilterFieldBuffer^, 4);
           AFilterParam.SetData(AFilterFieldBuffer);
         {$endif}
        end;
      ftDate:
        begin
         {$ifdef win32}
           tempTimeStamp:= DateTimeToTimeStamp(OtherField.asDateTime);
           move(tempTimeStamp.date, AFilterFieldBuffer^, 4);
           AFilterParam.SetData(AFilterFieldBuffer);
         {$else}
           tempDate := Trunc(OtherField.AsDateTime);
           move(tempDate, AFilterFieldBuffer^, 4);
           AFilterParam.SetData(AFilterFieldBuffer);
         {$endif}
        end;
      ftDateTime:
        begin
         {$ifdef win32}
           tempDouble:= TimeStampToMSecs(DateTimeToTimeStamp(OtherField.asDateTime));
           move(tempDouble, AFilterFieldBuffer^, sizeof(double));
           AFilterParam.SetData(AFilterFieldBuffer);
         {$else}
           tempDateTime := OtherField.AsDateTime * MSecsPerDay;
           move(tempDateTime, AFilterFieldBuffer^, sizeof(double));
           AFilterParam.SetData(AFilterFieldBuffer);
         {$endif}
        end;
{     ftBCD:
        begin
           CurrToBCD((OtherField as TBCDField).asFloat,
                     pFMTBcd(AFilterFieldBuffer)^, 32, 4);
           AFilterParam.SetData(AFilterFieldBuffer);
        end;}
   end;
end;

Function ignoreExtension(parts: TStrings): boolean;
begin
   if parts.count>5 then begin
      result:= (parts[parts.count-1]='N');
   end
   else result:= False;
end;

Function getTablePrefix(tableName: string): string;
var APos: integer;
begin
   APos:= 1;
   result:= strGetToken(tableName, '.', APos);
end;

Function isSameTable(lookupTable: TwwTable; parts: TStrings): boolean;
begin
   if ignoreExtension(parts) then
   begin
      result:=
         (lookupTable.databaseName=parts[1]) and
         (lookupTable.tableName=GetTablePrefix(parts[2]));
   end
   else begin
      result:=
         (lookupTable.databaseName=parts[1]) and
         (lookupTable.tableName=parts[2]);
   end
end;

    Function SyncLookupTable(DataSet:TDataset;Alookuptable: TDataSet;links:TStrings;
       Method: TMethod): boolean;
    var res:boolean;
        lookupTable:TwwTable;
    begin
       res := False;
       if not (Alookuptable is TwwTable) then begin {!!!! - If not a TwwTable then return False}
         result := False;
         exit;
       end;

       lookupTable := Alookuptable as TwwTable;
       case (links.count) of
         2: begin
            res := TwwTable(lookuptable).wwFindKey(
              [(wwGetFilterFieldValue(method, links[0])).asString]);
            end;
         4: begin
            res := TwwTable(lookuptable).wwFindKey(
                  [wwGetFilterFieldValue(Method,links[0]).asString,
                   wwGetFilterFieldValue(Method,links[2]).asString]);
            end;
         6: begin
            res := TwwTable(lookuptable).wwFindKey(
                      [wwGetFilterFieldValue(method,links[0]).asString,
                       wwGetFilterFieldValue(method,links[2]).asString,
                       wwGetFilterFieldValue(method,links[4]).asString] );
            end;
         8: begin
            res := TwwTable(lookuptable).wwFindKey(
                      [wwGetFilterFieldValue(method,links[0]).asString,
                       wwGetFilterFieldValue(method,links[2]).asString,
                       wwGetFilterFieldValue(method,links[4]).asString,
                       wwGetFilterFieldValue(method,links[6]).asString] );
            end;
        10: begin
            res := TwwTable(lookuptable).wwFindKey(
                      [wwGetFilterFieldValue(method,links[0]).asString,
                       wwGetFilterFieldValue(method,links[2]).asString,
                       wwGetFilterFieldValue(method,links[4]).asString,
                       wwGetFilterFieldValue(method,links[6]).asString,
                       wwGetFilterFieldValue(method,links[8]).asString] );
            end;
        12: begin
            res := TwwTable(lookuptable).wwFindKey(
                      [wwGetFilterFieldValue(method,links[0]).asString,
                       wwGetFilterFieldValue(method,links[2]).asString,
                       wwGetFilterFieldValue(method,links[4]).asString,
                       wwGetFilterFieldValue(method,links[6]).asString,
                       wwGetFilterFieldValue(method,links[8]).asString,
                       wwGetFilterFieldValue(method,links[10]).asString] );
            end;
         else;
      end;
      result := res;
    end;

Function wwDataSet_GetFilterLookupField(dataSet: TDataSet; curfield: TField; AMethod: TMethod): TField;
var OtherField : TField;
    links: TStrings;
    foundvalue: bool;
    foundtable: bool;
    lookuplinks:string;
    mylookuplinks:Tstrings;
    lookuptable:TwwTable;
    lookupfields:Tstrings;
    lookuptables:TList;

    parts: TStrings;
    i,j:integer;

    {$ifdef win32}
    fromLinks, toLinks, fromlink, tolink: string;
    fpos, tpos: integer;
    {$endif}

begin
   otherfield := nil;

   if (not curfield.calculated) then begin   {Check LookupField value}
     {$ifdef win32}
      links:= TStringlist.create;

      fromLinks:= curField.KeyFields;
      toLinks:= curField.LookupKeyFields;
      fpos:= 1; tpos:= 1;

      while True do begin
         fromLink:= strGetToken(fromlinks, ';', fpos);
         toLink:= strGetToken(tolinks, ';', tpos);

         if (fromLink='') or (toLink='') then break;

         links.add(fromLink );
         links.add(toLink);

      end;

      foundvalue := SyncLookupTable(Dataset,curfield.lookupdataset,links, AMethod);

      if foundvalue then
         otherfield := curfield.lookupdataset.fieldbyname(curfield.lookupresultfield);
      {$endif}
   end
   else begin   {Check Linked field value}

     if (inLookupCalcLink) or (wwGetLookupTables(curField.dataset)=nil) then begin
        result := nil;
        exit;
     end;

     links:= TStringlist.create;
     lookuplinks := wwDataSetGetLinks(Dataset,curfield.fieldname);
     strBreakApart(lookuplinks, ';', links);

     lookuptable := nil;
     foundTable := false;

     lookupfields := wwGetLookupFields(Dataset);
     lookuptables := wwGetLookupTables(Dataset);
     mylookuplinks := wwGetLookupLinks(Dataset);
     parts:= TStringList.create;

     for i:= 0 to lookupfields.count-1 do begin
        strbreakApart(lookupfields.Strings[i], ';', parts);

        for j:= 0 to lookuptables.count-1 do begin
          lookupTable:= TwwTable(lookuptables.items[j]);
          if isSameTable(lookuptable, parts) then
          begin
            foundtable:= (lowercase(mylookuplinks.strings[i])=
                         lowercase(lookupTable.CalcLookupLinks));
            if foundtable then break;
          end
        end;
        if foundtable then break;

     end;

     if foundtable then begin

        inLookupCalcLink := true;
        foundvalue := SyncLookupTable(Dataset,lookuptable,links, AMethod);
        inLookupCalcLink := false;

        if foundvalue then
           otherfield := lookuptable.fieldbyname(wwDataSetGetDisplayField(Dataset,curfield.fieldname));
     end;

     parts.free;

   end;

   links.free;

   result := otherfield;

end;


Function wwSetLookupField(dataSet: TDataSet; LinkedField: TField): boolean;
var links, parts: TStrings;
    i,j: integer;
    foundTable: Boolean;
    lookupTable: TwwTable;
    lookupFields, lookupLinks: TStrings;
    lookupTables: TList;

    Function getTablePrefix(tableName: string): string;
    var APos: integer;
    begin
       APos:= 1;
       result:= strGetToken(tableName, '.', APos);
    end;

    Function ignoreExtension(parts: TStrings): boolean;
    begin
       if parts.count>5 then begin
          result:= (parts[parts.count-1]='N');
       end
       else result:= False;
    end;

    Function isSameTable(lookupTable: TwwTable; parts: TStrings): boolean;
    begin
       if ignoreExtension(parts) then
       begin
          result:=
             (lookupTable.databaseName=parts[1]) and
             (lookupTable.tableName=GetTablePrefix(parts[2]));
       end
       else begin
          result:=
             (lookupTable.databaseName=parts[1]) and
             (lookupTable.tableName=parts[2]);
       end
    end;

begin
    result:= False;

    {$ifdef win32}
    with LinkedField do begin
       if Lookup then begin
          if (LookupDataSet as TTable).FindKey([dataSet.FieldByName(KeyFields).asString]) then
          begin
             if LookupDataSet.FieldByName(LookupResultField).asString<>linkedField.asString then
             begin
                LookupDataSet.edit;
                LookupDataSet.FieldByName(LookupResultField).asString:= linkedField.asString;
                result:= True;
             end
          end;
          exit;
       end;
    end;
    {$endif}

    if wwGetLookupFields(dataSet)=nil then exit;

    parts:= TStringList.create;
    links:= TStringList.create;
    lookupTable:= nil; { Make compiler happy}
    LookupLinks:= wwGetLookupLinks(dataSet);
    LookupFields:= wwGetLookupFields(dataSet);
    LookupTables:= wwGetLookupTables(dataset);

    try
     for i:= 0 to LookupFields.count-1 do begin
       strbreakApart(LookupFields.Strings[i], ';', parts);
       if not wwEqualStr(linkedField.fieldname, parts[0]) then continue;

       { Find corresponding table }
       foundTable:= false;
       for j:= 0 to LookupTables.count-1 do begin
          lookupTable:= TwwTable(lookupTables.items[j]);
          if isSameTable(lookupTable, parts) then
          begin
             foundTable:= (lowercase(LookupLinks.strings[i])=
                           lowercase(lookupTable.CalcLookupLinks));
             if foundTable then break;
          end
       end;
       if not foundTable then break;

       strBreakApart(LookupLinks[i], ';', links);

       with DataSet do begin
          if LookupTable.readOnly then begin
             LookupTAble.active:= False;
             LookupTable.readonly:=False;
             LookupTAble.active:= True;
          end;

          LookupTable.inLookupLink:= True; { Faster performance with inlookuplink }
          result:= wwDoLookupTable(lookupTable, DataSet, links);
          LookupTable.inLookupLink:= False;

          if result and (LookupTable.FieldByName(parts[3]).asString<>linkedField.asString) then
          begin
             LookupTable.edit;
             LookupTable.FieldByName(parts[3]).asString:= linkedField.asString;
{             LookupTable.post;} {7/4/97}
          end
       end;
     end

    finally
      parts.free;
      links.free;
    end;

end;

procedure wwDataSetDoOnCalcFields(dataSet: TDataSet;
          FLookupFields, FLookupLinks: TStrings;
          lookupTables: TList);
var links, parts: TStrings;
    i,j: integer;
    fieldName: wwSmallString;
    indexFields: string;
    foundTable: Boolean;
    lookupTable: TwwTable;
    res: boolean;

    Function getTablePrefix(tableName: string): string;
    var APos: integer;
    begin
       APos:= 1;
       result:= strGetToken(tableName, '.', APos);
    end;

    Function ignoreExtension(parts: TStrings): boolean;
    begin
       if parts.count>5 then begin
          result:= (parts[parts.count-1]='N');
       end
       else result:= False;
    end;

    Function isSameTable(lookupTable: TwwTable; parts: TStrings): boolean;
    begin
       if ignoreExtension(parts) then
       begin
          result:=
             (lookupTable.databaseName=parts[1]) and
             (lookupTable.tableName=GetTablePrefix(parts[2]));
       end
       else begin
          result:=
             (lookupTable.databaseName=parts[1]) and
             (lookupTable.tableName=parts[2]);
       end
    end;

begin
    parts:= TStringList.create;
    links:= TStringList.create;
    lookupTable:= nil; { Make compiler happy}

    { upToDate keeps track if lookuptable needs to do a findKey }
    for i:= 0 to LookupTables.count-1 do begin
        lookupTable:= TwwTable(lookupTables.items[i]);
        lookuptable.upToDate:= False;
    end;

    for i:= 0 to FLookupfields.count-1 do begin
       strbreakApart(FLookupFields.Strings[i], ';', parts);

       { Find corresponding table }
       foundTable:= false;
       for j:= 0 to LookupTables.count-1 do begin
          lookupTable:= TwwTable(lookupTables.items[j]);
          if isSameTable(lookupTable, parts) then
          begin
             foundTable:= (lowercase(FLookupLinks.strings[i])=
                           lowercase(lookupTable.CalcLookupLinks));
             if foundTable then break;
          end
       end;

       { Table not found so create it }
       if not foundTable then begin
          lookupTable:= TwwTable.create(dataSet);
          try { In case unable to open table }
             lookupTable.databaseName:= parts[1];
             if ignoreExtension(parts) then lookupTable.tableName:= getTablePrefix(parts[2])
             else lookupTable.tableName:= parts[2];

             if parts.count>5 then begin
                indexFields:= parts[5];
                for j:= 6 to parts.count-2 do indexFields:= indexFields + ';' + parts[j];
                lookupTable.indexName:= lookupTable.FieldsToIndex(indexFields);
             end
             else lookupTable.indexName:= parts[4];  { Set index name}

             lookupTable.readOnly:= True;  { Don't require write access }

             lookupTable.active:= True;
          except
             continue;  { Skip this lookup since table not found }
          end;
          lookupTables.add(lookupTable);
          lookupTable.upToDate:= False;
          lookupTable.CalcLookupLinks:= FLookupLinks.strings[i];
       end
       else if not lookupTable.active then
          lookupTable.active:= True;  { Force table to be active }

       fieldName:= parts[3];
       strBreakApart(FLookupLinks[i], ';', links);

       { Master Link field is gone, hide dependent field }
       for j:= 0 to ((links.count-1) div 2) do begin
           if not wwDataSetIsValidfield(dataSet, links[j*2]) then begin
              dataset.fieldByName(parts[0]).visible:= False;
              parts.free;
              links.free;
              exit;
           end
       end;

       res:= False;

       with DataSet do begin
          if not LookupTable.UpToDate then begin
             LookupTable.inLookupLink:= True; {12/4/96 }
             res:= wwDoLookupTable(lookupTable, DataSet, links);
             LookupTable.inLookupLink:= False; {12/4/96 }
             LookupTable.upToDateRes:= res;
          end;

          if (res or (LookupTable.upToDate and LookupTable.upToDateRes)) then
          begin
             {$ifdef win32}               { Support linked memo field display}
             if LookupTable.FieldByName(fieldName) is TBlobField then
                fieldbyName(parts[0]).text:= lookupTable.fieldByName(fieldName).asString
             else
             {$endif}
                fieldbyName(parts[0]).text:= lookupTable.fieldByName(fieldName).text
          end
          else fieldbyName(parts[0]).text:= '';
       end;
       LookupTable.upToDate:= True;

    end;
    parts.free;
    links.free;

 end;


    Function wwDataSetSyncLookupTable(dataSet: TDataSet; AlookupTable: TDataSet;
                  lookupFieldName: string; var fromField: string): boolean;
    var links, parts: TStrings;
        i,j, curpos: integer;
        lookupFields, controlType, lookupLinks: TStrings;
        lookupTable: TwwTable;
        tempTblName1, tempTblName2: wwSmallString;
        indexFields: string;
    begin
       parts:= TStringList.create;
       links:= TStringList.create;

       lookupFields:= wwGetLookupFields(dataSet);
       controlType:= wwGetControlType(dataset);
       lookupLinks:= wwGetLookupLinks(dataset);
       lookupTable:= ALookupTable as TwwTable;

       { Remove lookup fields that are no longer there }
       wwDataSetRemoveObsolete(dataSet, lookupfields, controlType, lookupLinks);
       result:= False;

       for i:= 0 to LookupFields.count-1 do begin
          strBreakApart(LookupFields.Strings[i], ';', parts);

          if (uppercase(parts[0])= uppercase(lookupfieldName)) then begin

             curpos:= 1;
             tempTblName1:= uppercase(strGetToken(lookupTable.tablename, '.', curpos));
             curpos:= 1;
             tempTblName2:= uppercase(strGetToken(parts[2], '.', curpos));
             if (tempTblName1=tempTblName2) then
             begin
                if parts.count>5 then begin
                   indexFields:= parts[5];
                   for j:= 6 to parts.count-2 do indexFields:= indexFields + ';' + parts[j];
                   lookupTable.ignoreMasterLink:= True;  { Just change index }
                   lookupTable.setToIndexContainingField(indexFields);  {2/10/97}
                   lookupTable.ignoreMasterLink:= False;
{                   lookupTable.indexName:= lookupTable.FieldsToIndex(indexFields);}
                end
                else if (lookupTable.indexName<>parts[4]) then   { Set index name}
                    lookuptable.indexName:=parts[4];
             end;

             strBreakApart(LookupLinks[i], ';', links);

             { Source Link field is gone, hide dependent field }
             for j:= 0 to ((links.count-1) div 2) do begin
                if not wwDataSetIsValidField(dataSet, links[j*2]) then begin
                   dataSet.fieldByName(parts[0]).visible:= False;
                   parts.free;
                   links.free;
                   exit;
                end
             end;

             with DataSet do
               result:= wwDoLookupTable(lookupTable, Dataset, links);

             fromField:= links[0];
             break;
          end
       end;
       parts.free;
       links.free;
    end;


Function wwDataSetRemoveObsoleteControls(parentForm: TCustomForm; dataSet: TDataSet): boolean;
var i: integer;
    parts: TStrings;
    ControlType: TStrings;
begin
   result:= True;
   if parentForm=nil then exit;
   if not (csDesigning in parentForm.ComponentState) then exit; { only remove in design mode}

   parts:= TStringList.create;
   ControlType:= wwGetControlType(dataSet);
   i:= 0;
   while (i<=ControlType.count-1) do begin
      strbreakApart(ControlType.Strings[i], ';', parts);
      if (parts.count<2) then begin
         i:= i + 1;
         continue;
      end;
      if isWWEditControl(parts[1]) then
{      if (parts[1] = WW_DB_COMBO) or (parts[1] = WW_DB_LOOKUP_COMBO) or
         (parts[1] = WW_DB_EDIT) then}
      begin
         if pos('.', parts[2])>0 then begin
            if (length(StrTrailing(parts[2],'.'))>0) and
               (Dataset.owner.FindComponent(strTrailing(parts[2],'.'))=Nil) then
            begin
               ControlType.delete(i);
            end
            else inc(i)
         end
         else begin
            if (parentForm.FindComponent(parts[2])=Nil) then
            begin
               ControlType.delete(i);
            end
            else inc(i);
         end;
      end
      else i:= i+1;
   end;

   parts.free;

end;

procedure wwDataSet_GetControl(dataSet: TDataSet; AFieldName: string;
                      var AControlType: string; var AParameters: string);
var i,j: integer;
    parts: TStrings;
    ControlType: TStrings;
begin
   parts:= TStringList.create;

   AControlType:= '';
   AParameters:= '';
   controlType:= wwGetControlType(dataset);
   for i:= 0 to ControlType.count-1 do begin
      strBreakapart(controlType[i], ';', parts);
      if parts.count<2 then continue;
      if parts[0]<>AFieldName then continue;
      if parts.count>1 then AControlType:= parts[1];
      if parts.count>2 then AParameters:= parts[2];
      for j:= 3 to parts.count-1 do AParameters:= AParameters + ';' + parts[j];
   end;

   parts.free;

end;

procedure wwDataSetRemoveObsolete(dataSet: TDataSet;
          FLookupFields, FLookupLinks, FControlType: TStrings);
var i: integer;
    parts: Tstrings;
begin
   parts:= TStringList.create;
   i:= 0;
   if FLookupFields<>Nil then while (i<=FLookupfields.count-1) do begin
      strbreakApart(FLookupFields.Strings[i], ';', parts);
      if not wwDataSetisValidField(dataSet, parts[0]) then begin
         FLookupFields.delete(i);
         FLookupLinks.delete(i);
      end
      else i:= i+1;
   end;

   i:= 0;
   while (i<=FControlType.count-1) do begin
      strbreakApart(FControlType.Strings[i], ';', parts);
      if (not wwDataSetIsValidField(dataSet, parts[0])) then
      begin
         FControlType.delete(i);
      end
      else i:= i+1;
   end;

   parts.free;
end;

procedure wwDataSet_SetControl(dataSet: TDataSet;
          AFieldName: string; AComponentType: string; AParameters: string);
var i: integer;
    parts: Tstrings;
    Found: boolean;
    ControlType: TStrings;
begin
   i:= 0;
   Found:= False;
   ControlType:= wwGetControlType(dataSet);
   parts:= TStringList.create;

   while (i<=ControlType.count-1) do begin
      strbreakApart(ControlType.Strings[i], ';', parts);
      if (lowercase(parts[0])=lowercase(AFieldName)) then begin
         if (lowercase(AComponentType)='field') or (lowercase(AComponentType)='') then
         begin
            ControlType.delete(i);  {Delete control}
            Found:= True;
            break;
         end
         else begin
            ControlType.Strings[i]:= parts[0] + ';' + AComponentType + ';' +
                 AParameters;
            Found:= True; {Update Control}
            break;
         end
      end;
      i:= i + 1;
   end;

   if not found then begin
      ControlType.add(AFieldName + ';' + AComponentType + ';' + AParameters);
   end;

   parts.free;
end;

function wwFieldIsValidValue(fld: TField; key: string): boolean;
begin
   result:= wwIsValidValue(fld.dataType, key);
end;

Function wwFieldIsValidLocateValue(fld: TField; key: string):boolean;
begin
   result:= False;
   if Fld=Nil then exit;
   
   result:= wwFieldIsValidValue(fld, key);

   if (key='') and
   {$ifdef win32}
   (fld.datatype in [ftCurrency, ftFloat, ftBCD, ftInteger, ftSmallInt, ftWord,
                    ftAutoInc, ftTime, ftDate, ftDateTime]) then result:= False;
   {$else}
   (fld.datatype in [ftCurrency, ftFloat, ftBCD, ftInteger, ftSmallInt, ftWord,
                   ftTime, ftDate, ftDateTime]) then result:= False;
   {$endif}
end;

Function wwIsValidValue(FldType: TFieldType; key: string):boolean;
begin
   result:= False;
   case FldType of
     ftCurrency, ftFloat, ftBCD  : if not wwStrToFloat(key) then exit;
     ftinteger, ftSmallInt, ftWord : if not wwStrToInt(key) then exit;

     {$ifdef win32}
     ftAutoInc : if not wwStrToInt(key) then exit;
     {$endif}

     ftTime: if not wwStrToTime(key) then exit;  {3/6/97}
     ftDate : if not wwStrToDate(key) then exit;
     ftDateTime :
        if not wwStrToDateTime(key) then begin
           if not wwStrToDate(key) then exit;
        end;
     else;
   end;
   result:= True;
end;


Function wwTableFindNearest(dataSet: TDataSet; key: string; FieldNo: integer): boolean;
var table: TwwTable;
    useNarrowSearch: boolean;
    useTextSearch: boolean;
    UpperRangeString: string;
    i: integer;
    {$ifdef ver100}
    LocateOptions: TLocateOptions;
    LocateValues: Variant;
    LocateFields: string;
    {$endif}

   Function IsValueType(AFieldType: TFieldType): boolean;
   begin
      result:=
          (AFieldType in [ ftSmallInt, ftInteger, ftWord, ftFloat, ftCurrency]);
      {$ifdef win32}
       if AFieldType=ftAutoInc then result:= True;
      {$endif}
   end;

begin
   result:= False;
   if not (dataset is TTable) then exit;

   { 5/25/95 - Use syncSQLByRange property }
   { 5/25/95 - Use syncSQLByRange property }
   {           Use NarrowSearch property   }
   if (dataset is TwwTable) then begin
      useNarrowSearch:= (dataset as TwwTable).NarrowSearch;
   end
   else begin
      MessageDlg('Incremental Search - TTable component not supported. Use TwwTable instead.', mtWarning, [mbok], 0);
      exit;
   end;
   table:= dataSet as TwwTable;


   if table.indexFieldCount=0 then begin
      MessageDlg('Table ' + dataset.name + ': Table index not found', mtWarning, [mbok], 0);
      exit;
   end;

   useTextSearch:= False;

   case table.indexFields[FieldNo].dataType of
         ftCurrency, ftFloat, ftBCD  : if not wwStrToFloat(key) then exit;
         ftinteger, ftSmallInt, ftWord : if not wwStrToInt(key) then exit;
         {$ifdef win32}
         ftAutoInc : if not wwStrToInt(key) then exit;
         {$endif}
         ftDate : if not wwStrToDate(key) then exit;
         ftTime: if not wwStrToTime(key) then exit;
         ftDateTime:
            if not wwStrToDateTime(key) then begin
               if not wwStrToDate(key) then exit;
            end;
         else useTextSearch:= True;
   end;

   with table do try

      if UseNarrowSearch then begin  { Search by narrowing down }
         Screen.cursor:= crHourGlass;
         DisableControls;
         if useTextSearch then begin
            if key='' then
              (table as TwwTable).FastCancelRange  { 12/4/96 - Faster cancel range }
            else begin
              { MSSQL does not work with char(255) }
              UpperRangeString:= key;
              for i:= 0 to indexfields[0].size-1 do
                 UpperRangeString:= UpperRangeString + char((table as TwwTable).NarrowSearchUpperChar);
              if (ixDescending in IndexDefs.Items[IndexDefs.indexof(IndexName)].Options) then
                  table.SetRange([UpperRangeString], [key])
              else table.setRange([key],[UpperRangeString])
            end;
         end
         else begin
            if table is TwwTable then
               (table as TwwTable).wwSetRangeStart([key]);
         end;
         EnableControls;
         Screen.cursor:= crDefault;
      end
      { 11/6/96 - Don't use setRange if detail table }
      else if (not database.isSqlBased) or (not SyncSQLByRange) or (table.mastersource<>nil) then begin
         {$ifdef ver100}
         { 5/29/97 - Use 32 bit Locate function instead of FindNearest }
         if wwInternational.UseLocateMethodForSearch then
         begin
            if table.isCaseInsensitiveIndex then LocateOptions:= [loPartialKey,  loCaseInsensitive]
            else LocateOptions:= [loPartialKey];

            if (Key='') then Dataset.first { 6/9/97}
            else if FieldNo=0 then
                DataSet.Locate(indexFields[0].FieldName, Key, LocateOptions)
            else begin
               LocateValues:= VarArrayCreate([0, FieldNo], varVariant);
               LocateFields:= '';
               for i:= 0 to FieldNo do begin
                  LocateValues[i]:= indexfields[i].asString;
                  if LocateFields<>'' then LocateFields:= LocateFields + ';';
                  LocateFields:= LocateFields + indexFields[i].FieldName;
               end;
               LocateValues[FieldNo]:= Key;

               DataSet.Locate(LocateFields, LocateValues, LocateOptions);
            end
         end
         else begin
            case FieldNo of
                0: FindNearest([key]);
                1: FindNearest([indexFields[0].text, key]);
                2: FindNearest([indexFields[0].text, indexFields[1].text, key]);
                3: FindNearest([indexFields[0].text, indexFields[1].text,
                           indexFields[2].text, key]);
            end
         end;

         {$else}
         case FieldNo of
             0: FindNearest([key]);
             1: FindNearest([indexFields[0].text, key]);
             2: FindNearest([indexFields[0].text, indexFields[1].text, key]);
             3: FindNearest([indexFields[0].text, indexFields[1].text,
                           indexFields[2].text, key]);
         end
         {$endif}
      end
      else begin
         Screen.cursor:= crHourGlass;
         DisableControls;

         if table is TwwTable then begin
            if key='' then begin
               (table as TwwTable).FastCancelRange;  { 12/4/96 - Faster cancel range }
            end
            else begin
{              (table as TwwTable).wwSetRangeStart([key]);}
              case FieldNo of
                0: (table as TwwTable).wwSetRangeStart([key]);
                1: (table as TwwTable).wwSetRangeStart([indexFields[0].text, key]);
                2: (table as TwwTable).wwSetRangeStart([indexFields[0].text, indexFields[1].text, key]);
                3: (table as TwwTable).wwSetRangeStart([indexFields[0].text, indexFields[1].text,
                                                     indexFields[2].text, key]);
              end

            end
         end
         else begin
            setRangeStart;
            IndexFields[FieldNo].asString:= key;
            setRangeEnd;
            ApplyRange;
         end;

         EnableControls;
         Screen.cursor:= crDefault;
      end;

     {4/6/97}
      if (indexFields[FieldNo].DataType in [ftFloat, ftCurrency]) then
      begin
         if (key = '') then
            result := (indexFields[fieldNo].AsString = '')
         else result:=  StrToFloat(key)=TFloatField(indexFields[fieldNo]).asFloat
      end
      else if isValueType(indexFields[FieldNo].DataType) then
         result:=  key=indexFields[fieldNo].asString
      else result:= pos(lowercase(key),
                   lowercase(indexFields[fieldNo].asString))=1;
   finally
   end;
end;

procedure wwTableChangeIndex(dataSet: TDataSet; a_indexItem: TIndexDef);
var newIndexValues, parts: TStrings;
    j: integer;
    table: TTable;
    syncSQLByRange: boolean;
begin
   if not (dataset is TTable) then exit;
   table:= dataSet as TTable;

   if (table is TwwTable) then begin
      syncSQLByRange:= (table as TwwTable).syncSQLByRange;
   end
   else begin
      syncSQLByRange:= True;
   end;

   if (table.database.isSqlBased) and (syncSQLByRange) then begin
      if table.indexName = a_indexItem.Name then exit; { index already correct}

      Screen.cursor:= crHourGlass;

      parts:= Nil;
      newIndexValues:= Nil;
      with table do try
         parts:= TStringList.Create;
         newIndexValues:= TStringList.create;

         strBreakApart(a_IndexItem.fields, ';', parts);

         for j:= 0 to parts.count-1 do
            newIndexValues.add(fieldByName(Parts[j]).text);

         disableControls;

 {12/7/96 - Following 2 lines not necessary and can be slow}
 {         dbiResetRange(handle);
         First; }
         active:= False;
         IndexName:=  a_indexItem.Name;
         active:= True;

         { Synchronize to previous position}
         setRangeStart;
         for j:= 0 to indexFieldCount-1 do
            IndexFields[j].asString:= newIndexValues[j];
         ApplyRange;

         enableControls;

      finally
         Screen.cursor:= crDefault;
         newIndexValues.free;
         parts.free;
      end

   end
   else begin
      table.IndexName:=  a_IndexItem.Name;
   end;
end;


Function wwGetAlias(aliasName: string): string;
var
    tempCString: array[0..255] of char;
    handle: hDBICur;
    cfg: CFGDesc;
    dbRes: DBIResult;
begin
   result:= '';
   dbRes:= DbiOpenCfgInfoList(Nil, dbiReadOnly, cfgPersistent,
           strpcopy(tempCString,'\Databases\' + aliasName + '\db info'), handle);
   if dbRes = DBIERR_OBJNOTFOUND then exit;

   while dbiGetNextRecord(handle, dbiNoLock, @cfg, nil)=0 do
   begin
      if (lowercase(strPas(cfg.szNodeName))='path') then
      begin
         result:=strPas(cfg.szValue);
         break;
      end
   end;
   DbiCloseCursor(handle);
end;

    Function wwSaveAnswerTable(ADataSet: TDBDataSet;
             AHandle: HDbiCur; tableName: string): boolean;
    var
       tableNameC: array [1..256] of char;
       dbRes: DBIRESULT;
       aliasName, restOfPath, aliasPath: string;
       endAliasPos: integer;
       tempCString: array[0..255] of char;
       differentDrive: boolean;

       function CopyAnswerTable: boolean;
       var aBatTblDesc : BATTblDesc;
           recMoveCount: longint;
           dbiErr: dbiResult;
{           bm: TBatchMove;}
{           tempTable: TTable;}
       begin
{          tempTable:= TTable.create(self);
          tempTable.TableName:= 'TempAnsw.db';

          bm:= TBatchMove.create(self);
          bm.Mode:= batCopy;
          bm.Source:= ADataSet;
          bm.Destination:= TempTable;
}

          Check(DbiSetToBegin(AHandle));
          with aBatTblDesc do begin
            hDB:=ADataSet.DBHandle;
            szUsername[0]:=#0;
            szPassword[0]:=#0;
            strpcopy(szTblName, tableName);
            strpcopy(szTblType, szParadox);
          end;

          try
             dbiErr:=dbiDeleteTable(ADataSet.DBHandle,aBatTblDesc.szTblName,aBatTblDesc.szTblType);
             if dbiErr<>DBIERR_NOSUCHTABLE then Check(dbiErr);
          except
          end;

          recMoveCount:=0;
          Check(DbiBatchMove(nil, AHandle, @aBatTblDesc, nil, batchCopy, 0, nil,
                            nil, nil, 0, nil, nil, nil, nil, nil, nil, TRUE, TRUE,
                            recMoveCount, TRUE));
          result:= True;
       end;

    begin
       result:= True;

       if tableName='' then begin
          result:= False;
          exit;
       end
       else if tableName[1]=':' then begin
         { convert alias to path }
         tableName:= copy(tableName, 2, length(tableName)-1);
         endAliasPos:= pos(':', tableName);
         aliasPath:= '';
         if endAliasPos>1 then begin
            aliasName:= copy(tableName, 1, endAliasPos-1);
            restOfPath:= copy(tableName, endAliasPos+1, length(tableName)+1-(endAliasPos+1));
            aliasPath := wwGetAlias(aliasName);
            if (aliasPath<>'') and (restOfPath<>'') and
               (aliasPath[length(aliasPath)]<>'\') and (restOfPath[1]<>'\') then
                tableName:= aliasPath + '\' + restOfPath
            else tableName:= aliasPath + restOfPath
         end;
         if aliasPath='' then begin
            MessageDlg('Invalid Alias in QBE', mtError, [mbok], 0);
            result:= False;
            exit;
         end
       end;

       try
          { Copy table when the temp file is on a different drive and have memo field}
          differentDrive := (length(tableName)>=2) and (tableName[2]=':') and
                (pos(lowercase(tableName[1]), lowercase(Session.privatedir))<>1);

          if differentDrive then
          begin
             CopyAnswerTable;
             Result:= True;
             exit;
          end;

          { Use make permanent since temp file is on same disk as answerTable }
          dbres:= dbiMakePermanent(AHandle, strpcopy(@tableNameC, tableName), True);
          if dbRes=DBIERR_NONE then begin
             dbRes:= dbiSaveChanges(AHandle);
             result:= dbRes=DBIERR_NONE;
          end
          else begin
             result:= False;
             dbiGetErrorString(dbres, @tempCstring);
             ShowMessage(strpas(tempcstring) +  '(' + tableName + ')');
          end
       except
          MessageDlg('Unable to create answer table ' + tableName, mtWarning, [mbok], 0);
       end;

    end;

Function wwInPaintCopyState(ControlState: TControlState): boolean;
begin
{$IFDEF WIN32}
   result:= (csPaintCopy in ControlState);
{$ELSE}
   result:= False;
{$ENDIF}
end;

procedure wwPlayKeystroke(Handle: HWND; VKChar: word; VKShift: Word);
var
  KeyState: TKeyboardState;
  NewKeyState: TKeyboardState;
{  i: integer;}
begin
   GetKeyboardState(KeyState);
{   for I := Low(NewKeyState) to High(NewKeyState) do
     NewKeyState[I] := 0;
}
   NewKeyState:= KeyState;
   NewKeyState [VKShift] := $81;
   NewKeyState [VKChar] := $81;
   SetKeyboardState(NewKeyState);
   PostMessage(Handle, WM_KEYDOWN, VKChar, 1);
   PostMessage(Handle, WM_KEYUP, VKChar, 1);
   SetKeyboardState(KeyState);
end;

procedure wwClearAltChar;
var KeyState: TKeyboardState;
begin
   GetKeyboardState(KeyState);
   KeyState [VK_Menu] := 0;
   SetKeyboardState(KeyState);
end;
{
Function wwGetUniqueFileName(Extension: string; var Filename: string): boolean;
var
    f: Double;
    startSeed, Seed: longint;
    Path: string;
    tempFileNameC: array[0..255] of char;
    SearchCount: integer;
begin
   GetTempFileName('C', '_WW', 1, tempFileNameC);
   path:= ExtractFilePath(strPas(tempFileNameC));
   f:= (Now - SysUtils.Date)*MSecsPerDay;
   seed:= Trunc(f) mod 10000;
   startSeed:= seed;
   repeat
      FileName:= Path + '_WW' + inttostr(seed) + '.' + Extension;
      seed:= (seed+1) mod 10000;
      if seed = startSeed then begin
         FileName:= '';
         result:= False;
         exit;
      end;
      inc(searchCount);
   until (not FileExists(FileName));
   result:= True;
end;
}
   function wwGetQueryText(tempQBE: TStrings; Sql: boolean): PChar;
   var
     I: Integer;
     StrEnd: PChar;
    {$ifndef win32}
     StrBuf: array[0..255] of Char;
    {$endif}
     BufLen: word;
     incr: integer;
   begin
     BufLen := 1;
     if SQL then incr:= 1 else incr:= 2;
     for I := 0 to tempQBE.Count - 1 do
       Inc(BufLen, Length(tempQBE.Strings[I]) + incr);
     Result := StrAlloc(BufLen);
     try
       StrEnd := Result;
       for I := 0 to tempQBE.Count - 1 do
       begin
         {$ifdef win32}
         StrEnd := StrECopy(StrEnd, PChar(tempQBE.Strings[I])); { Support >255 lines in 32 bit}
         {$else}
         StrPCopy(StrBuf, tempQBE.Strings[I]);
         StrEnd := StrECopy(StrEnd, StrBuf);
         {$endif}
         if i<tempQBE.Count-1 then
         begin
            if SQL then StrEnd := StrECopy(StrEnd, ' ')
            else StrEnd := StrECopy(StrEnd, #13#10);
         end
       end;
     except
       StrDispose(Result);
       raise;
     end;
   end;

Function wwMemAvail(memSize: integer): boolean;
begin
   {$ifdef win32}
   result:= False;
   {$else}
   result:=  (MaxAvail < memSize);
   {$endif}
end;

Procedure wwPictureByField(DataSet: TDataset; FieldName: string; FromTable: boolean;
    var Mask: string; var AutoFill, UsePictureMask: boolean);
var APos, i: integer;
    FPictureMasks: TStrings;
    TempMask: string;
begin
   Mask:= '';
   AutoFill:= True;
   UsePictureMask:= True;

   FPictureMasks:= wwGetPictureMasks(DataSet);
   if FPictureMasks=Nil then exit;

   for i:= 0 to FPictureMasks.count-1 do
   begin
      APos:= 1;
      if lowercase(FieldName)=lowercase(strGetToken(FPictureMasks[i], #9, APos)) then
      begin
         Mask:= strGetToken(FPictureMasks[i], #9, APos);
         Autofill:= strGetToken(FPictureMasks[i], #9, APos)='T';
         UsePictureMask:= strGetToken(FPictureMasks[i], #9, APos)='T';
         break;
      end
   end;

   { Use table mask and ignore component mask }
   if (DataSet is TwwTable) and fromTable then begin
      TempMask:= TwwTable(Dataset).GetDBPicture(FieldName);
      if (TempMask<>'') and (Mask<>'') then begin
         wwSetPictureMask(dataSet, FieldName,
            '', AutoFill, UsePictureMask, True, True, False);
         Mask:= TempMask;
         exit;
      end
      else if TempMask<>'' then Mask:= TempMask;
   end;
end;

procedure wwDataModuleChanged(temp: TComponent);
begin
   {$ifdef win32}
   while (temp<>Nil) and (temp.Owner<>Nil) and not (temp is TCustomForm) do temp:= temp.Owner;
   if (temp<>Nil) and (temp is TCustomForm) and ((temp as TCustomForm).Designer<>Nil) then
      (temp as TCustomForm).Designer.modified;
   {$endif}
end;

procedure wwSetPictureMask(dataSet: TDataSet; AFieldName: string;
    AMask: string;
    AutoFill: boolean;
    UsePictureMask: boolean;
    SetMask: boolean;
    SetAutoFill: boolean;
    SetUsePictureMask: boolean);
var i: integer;
    Found: boolean;
    FPictureMasks: TStrings;
    APos: integer;
    Temp: string;

    Function BoolToString(val: boolean): string;
    begin
       if val then result:= 'T' else result:= 'F';
    end;

begin
   Found:= False;
   FPictureMasks:= wwGetPictureMasks(DataSet);
   if FPictureMasks=Nil then exit;

   { DBMask takes precedence }
   Temp:= wwPdxPictureMask(DataSet, AFieldName);
   if Temp<>'' then AMask:= Temp;

   i:= 0;
   while (i<=FPictureMasks.count-1) do begin
      APos:= 1;
      if lowercase(AFieldName)=lowercase(strGetToken(FPictureMasks[i], #9, APos)) then
      begin
         Temp:= strGetToken(FPictureMasks[i], #9, APos);
         if not SetMask then AMask:= Temp;
         Temp:= strGetToken(FPictureMasks[i], #9, APos);
         if not SetAutoFill then AutoFill:= Temp='T';
         Temp:= strGetToken(FPictureMasks[i], #9, APos);
         if not SetUsePictureMask then usePictureMask:= Temp='T';

         if AMask='' then FPictureMasks.delete(i)
         else begin
            FPictureMasks.Strings[i]:= AFieldName + #9 +
                  AMask + #9 + BoolToString(AutoFill) +
                  #9 + BoolToString(UsePictureMask);
         end;
         Found:= True;
         break;
      end
      else i:= i + 1;
   end;

   if (not found) and (AMask<>'') then
      FPictureMasks.add(AFieldName + #9 + AMask + #9 +
               BoolToString(AutoFill) +
               #9 + BoolToString(UsePictureMask));

end;

Function wwGetFieldNameFromTitle(DataSet: TDataSet; fieldTitle: string): string;
var i: integer;
begin
   result:= '';
   with DataSet do begin
      for i:= 0 to fieldCount-1 do begin
         if strReplaceChar(fields[i].displayLabel,'~',' ')=strReplaceChar(fieldTitle,'~',' ') then begin
            result:= fields[i].FieldName;
            exit;
         end
      end
   end;
end;

Function wwGetListIndex(list: TStrings; itemName: string): integer;
var i: integer;
begin
   result:= -1;
   for i:= 0 to list.count-1 do begin
      if wwEqualStr(list[i], itemName) then begin
         result:= i;
         break;
      end
   end;
end;

Function wwGetOwnerForm(component: TComponent):TCustomForm;
var temp: TComponent;
begin
   temp:= component;
   while (temp<>Nil) and (temp.Owner<>Nil) and not (temp is TCustomForm) do temp:= temp.Owner;
   result:= TCustomForm(temp);
end;

Function isWWEditControl(pname: string): boolean;
begin
   result:= wwEqualStr(pname, WW_DB_EDIT) or wwEqualStr(pname, WW_DB_LOOKUP_COMBO) or
            wwEqualStr(pname, WW_DB_COMBO) { or wwEqualStr(pname, WW_DB_RICHEDIT) };
end;

{$ifdef win32}
Procedure wwDrawEllipsis(Canvas: TCanvas; R: TRect;
    State: TButtonState;
    Enabled: Boolean;
    ControlState: TControlState);
var Flags: Integer;
    DC: HDC;
    w: integer;
    LeftIndent, TopIndent: integer;
begin
   Flags:= 0;
   if (State=bsDown) and not (wwInPaintCopyState(ControlState)) then
     Flags := BF_FLAT;
   DC:= Canvas.Handle;
   DrawEdge(DC, R, EDGE_RAISED, BF_RECT or BF_MIDDLE or Flags);
   LeftIndent:= ((R.Right - R.Left) shr 1) - 1 + Ord(State=bsDown);
   TopIndent:= ((R.Bottom+1-R.Top) shr 1) - 1 + Ord(State=bsDown);
   W := (R.Right+1 - R.Left) shr 3;
   if W = 0 then W := 1;
   PatBlt(DC, R.Left + LeftIndent, R.Top + TopIndent, W, W, BLACKNESS);
   PatBlt(DC, R.Left + LeftIndent - (W * 2), R.Top + TopIndent, W, W, BLACKNESS);
   PatBlt(DC, R.Left + LeftIndent + (W * 2), R.Top + TopIndent, W, W, BLACKNESS);
end;

Procedure wwDrawDropDownArrow(Canvas: TCanvas; R: TRect;
    State: TButtonState;
    Enabled: Boolean;
    ControlState: TControlState);
var Flags: Integer;
begin
  if not Enabled then
    Flags := DFCS_SCROLLCOMBOBOX or DFCS_INACTIVE
  else if (State=bsUp) or wwInPaintCopyState(ControlState) then
    Flags := DFCS_SCROLLCOMBOBOX
  else
    Flags := DFCS_SCROLLCOMBOBOX or DFCS_FLAT or DFCS_PUSHED;
  DrawFrameControl(Canvas.Handle, R, DFC_SCROLL, Flags);
end;

{$endif}

Function wwHasIndex(ADataSet: TDataSet): boolean;
begin
   result:= (ADataSet is TwwTable) and (TwwTable(ADataSet).indexFieldCount>0);
end;

Function wwIsTableQuery(ADataSet: TDataSet): boolean;
begin
   result:= (ADataset is TwwTable) and (TwwTable(ADataset).Query.Count>0)
end;

Function wwPdxPictureMask(ADataSet: TDataSet; AFieldName: string): string;
begin
   result:= '';
   if ADataSet.FindField(AFieldName)=nil then exit;
   if (ADataSet is TwwTable) then
     result:= TwwTable(ADataSet).GetDBPicture(AFieldName)
end;

 { Calling a dialog in mouseDown event prevents mouseUp code from being executed}
 { The following code corrects this Windows anomaly.                            }
  procedure wwFixMouseDown;
  var i: integer;
      parentForm: TCustomForm;
      tempControl: TControl;
  begin
        parentForm:= Screen.ActiveForm;
        if parentForm=nil then exit;
        if (csLButtonDown in ParentForm.ControlState) then
        begin
           PostMessage(ParentForm.handle, WM_LBUTTONUP, 0, 0);
           exit;
        end;

        for i:= 0 to ParentForm.ControlCount-1 do begin
           tempControl:= ParentForm.Controls[i];
           if (csLButtonDown in tempControl.ControlState) and
              (tempControl is TWinControl) then begin
              PostMessage(TWinControl(tempControl).handle, WM_LBUTTONUP, 0, 0);
              break;
           end
        end
  end;

procedure wwValidatePictureFields(ADataSet: TDataSet;
     FOnInvalidValue: TwwInvalidValueEvent);
var
  I: Integer;
  tempPicture: string;
  tempAutoFill, tempUsePictureMask: boolean;

  function isValidPicture(PictureMask, s: string): boolean;
  var pict: TwwPictureValidator;
      res: TwwPicResult;
  begin
     if (s='') then
        result:= True
     else begin
        pict:= TwwPictureValidator.create(PictureMask, False);;
        res:= Pict.picture(s, False);
        result := res = prComplete;
        pict.Free;
     end;
  end;

begin
   { Component level validation }
   with ADataSet do begin
      for i:= 0 to FieldCount-1 do
      begin
         wwPictureByField(ADataSet, Fields[i].FieldName, True,
                    tempPicture, tempAutoFill, tempUsePictureMask);
         if tempPicture<>'' then begin
            if not isValidPicture(tempPicture, Fields[i].asString) then
{            if not isValidPicture(tempPicture, Fields[i].DisplayText) then}
            begin
               with Fields[i] do begin
                  if not ReadOnly then begin
                     FocusControl;
                     if Assigned(FOnInvalidValue) then
                        FOnInvalidValue(ADataSet, Fields[i]);
                     {$ifdef win32}
                     DatabaseError(wwInternational.UserMessages.PictureValidateError + DisplayName);
                     {$else}
                     DatabaseError(wwInternational.UserMessages.PictureValidateError + DisplayName^);
                     {$endif}
                  end
               end
            end
         end
      end
   end
end;

function wwDataSetFindRecord(
   DataSet: TDataSet;
   KeyValue: string;
   LookupField: string;
   MatchType: TwwLocateMatchType;
   caseSensitive: boolean): boolean;
var tempStr: string;

    { If already on this record then skip findkey }
    Function isAlreadyFound: boolean;
    begin
      if CaseSensitive then result:= tempStr=KeyValue
      else result:= lowercase(tempstr)=lowercase(KeyValue);
    end;

begin
   result:= True;
   tempStr:= DataSet.FieldByName(LookupField).asString;
   if isAlreadyFound then exit;
   result:=  wwFindMatch(True, DataSet, LookupField,
                       KeyValue, matchType, CaseSensitive);
end;


Procedure wwOpenPictureDB(wwtable: TTable);
var
    {$ifdef win32}
    ipReg: TRegIniFile;
    {$else}
    len: integer;
    Directory: packed array[0..255] of char;
    {$endif}

begin
   try
      {$ifdef win32}
      ipreg := TRegIniFile.create('');
      wwtable.databaseName:= ipreg.ReadString('\Software\Woll2Woll\InfoPower', 'Masks Database Path', '');
      ipreg.free;
      {$else}
      len:= GetPrivateProfileString('Paths', 'PictureDB', '',
              Directory, 255, 'InfoPowr.ini');
      Directory[len]:= #0;
      wwtable.databaseName:= strpas(Directory);
      {$endif}

      try
         wwtable.active:= True;
      except
         wwtable.tableName:= 'PICTURES.DBF';
         wwtable.indexName:= '';
         wwtable.active:= True;
      end

   except
      {$ifdef win32}
      ShowMessage('Unable to find picture mask database:'+#13 +
                  'Path: ' + wwtable.databaseName + #13 +
                  'Table: PICTURE' + #13 +
                  'See path specification defined in Windows Registry at' + #13 +
                  '  \Software\Woll2Woll\InfoPower\Masks Database Path');
      {$else}
      ShowMessage('Unable to find picture mask database:'+#13 +
                  'Path: ' + strPas(Directory) + #13 +
                  'Table: PICTURE' + #13 +
                  'See infopowr.ini for path specification.');
      {$endif}
   end;
end;

Function wwValidFilterableFieldType(ADataType: TFieldType): boolean;
begin
   result:= not ((ADataType = ftBlob) or (ADataType=ftGraphic) or
                  (ADataType = ftVarBytes) or (ADataType=ftBytes));
end;

procedure wwHelp(Handle: HWND; HelpTopic: PChar);
var
   context: array[0..127] of char;
begin
   if isCBuilder then
      WinHelp(Handle, 'ip_cpp.hlp', HELP_CONTEXT, longInt(HelpTopic))
   else begin
      strcopy(context, HelpTopic);
      {$ifdef win32}
        {$ifdef ver100}
        WinHelp(Handle, 'IP30.HLP', HELP_KEY, longint(@context));
        {$else}
        WinHelp(Handle, 'IP30D2.HLP', HELP_KEY, longint(@context));
        {$endif}
      {$else}
      WinHelp(Handle, 'IP30D1.HLP', HELP_KEY, longint(@context));
      {$endif}
   end
end;

Function wwIsValidChar(key: word): boolean;
begin
   result:= (key = VK_BACK) or (key=VK_SPACE) or (key=VK_DELETE) or
            ((key >= ord('0')) and (key<=VK_DIVIDE)) or
            (key>VK_SCROLL);
end;

{
Undocumented method to set links at runtime.   This method can safely be used
and will be supported in future versions of InfoPower

This routine will set the lookup links. The parameter description
follows...

dataSet: TDataSet         The Dataset containing the calculated field
FldName: string           The name of the calculated field to be linked
DatabaseName : string     The name of the Database
TableName:string          The Lookup Table Name (including .DB or whatever extension)
DisplayFld:string         The Lookup Field Name
IndexFieldNames:string    Index Field Names (i.e. CustomerNo;OrderNo)
Links: string             The join value in the following format
                          Join1MasterTable;Join1LinkTable;Join2MasterTable;Join2LinkTable;...'
                          For example Links := 'Customer No;Customer No'
useExtension: Char        'Y' or 'N': Whether or not to use extension in tablenamea


After calling this routine you need to call  TwwTable's refresh method.

Example:  The following is an example of calling this method.  The code will
create a link for an existing calculated field with the fieldname CompanyName.
It looks up the table infodemo:ip2cust.db and displays the company name field.

   wwDataSet_SetLookupLink(wwTable1,'CompanyName','InfoDemo','IP2CUST.DB',
        'Company Name','Customer No','Customer No;Customer No','Y');
   wwtable1.refresh;

}

procedure wwDataSet_SetLookupLink(dataSet: TDataSet;
   FldName, DatabaseName, TableName, DisplayFld, IndexFieldNames, Links: string;
   useExtension: Char);
var
   FLookupLinks, FLookupFields: TStrings;
   parts: Tstrings;
   i: integer;
begin
   parts:= TStringList.create;
   FLookupFields:= wwGetLookupFields(dataSet);
   FLookupLinks:= wwGetLookuplinks(dataSet);

   i:=0;
   while (i<=FLookupfields.count-1) do begin
      strbreakApart(FLookupFields.Strings[i], ';', parts);
      if lowercase(parts[0])=lowercase(FldName) then begin
         FLookupFields.delete(i);
         FLookupLinks.delete(i);
      end
      else i:= i+1;
   end;

   if not
     ((DatabaseName='') or (TableName='') or (DisplayFld='') or (IndexFieldNames='')) then
   begin
      FLookupFields.add(FldName + ';' + DatabaseName + ';' + TableName + ';' +
         DisplayFld + ';;' + IndexFieldNames + ';' + useExtension);

      FLookupLinks.add(Links);
   end;

   parts.Free;
end;

Procedure wwDataSetUpdateSelected(dataSet: TDataSet; selected: TStrings);
var i: integer;
begin
   selected.clear;
   with dataSet do begin
      for i:= 0 to fieldCount-1 do begin
         if (fields[i].visible) then
            Selected.add(fields[i].fieldName + #9 +
              inttostr(fields[i].displayWidth) + #9 +
              fields[i].displayLabel);
      end;
   end
end;

Function wwFindSelected(selected: TStrings;
   FieldName: string; var index: integer): boolean;
var i: integer;
    parts: TStringList;
begin
   parts := TStringList.create;
   result:= False;

   try
      if selected<>Nil then begin
         for i:= 0 to selected.count-1 do begin
            strBreakApart(selected[i], #9, parts);
            if uppercase(parts[0])=uppercase(FieldName) then begin
               index:= i;
               result:= True;
               exit;
            end;
         end
      end
   finally
      parts.Free;
   end;
end;

Function wwAdjustPixels(PixelSize,PixelsPerInch : integer): integer;
var temp: longint;
begin
   temp:= LongInt(PixelSize) * LongInt(PixelsPerInch);
   result := temp div 96;
end;

Procedure wwSetOnFilterEnabled(dataset: TDataset; val: boolean);
var PropInfo: PPropInfo;
    tempOptions: TwwOnFilterOptions;
    SetValue: Longint;
begin
   tempOptions:= wwGetOnFilterOptions(dataset);
   if val then tempOptions:= tempOptions + [ofoEnabled]
   else tempOptions:= tempOptions - [ofoEnabled];

   PropInfo:= Typinfo.GetPropInfo(DataSet.ClassInfo,'OnFilterOptions');
   if PropInfo<>Nil then begin
      SetValue:= LongInt(PChar(@tempOptions)^);
      SetOrdProp(dataset, PropInfo, SetValue);
   end;

{   if dataSet is TwwTable then TwwTable(dataSet).OnFilterOptions:= tempOptions{
{   else if dataSet is TwwQuery then TwwQuery(dataSet).OnFilterOptions:= tempOptions;
   else if dataSet is TwwQBE then TwwQBE(dataSet).OnFilterOptions:= tempOptions;
   else if dataSet is TwwStoredProc then TwwStoredProc(dataSet).OnFilterOptions:= tempOptions;
}
end;

Function wwGetOnFilterOptions(dataset: TDataset): TwwOnFilterOptions;
var PropInfo: PPropInfo;
    f: TwwOnFilterOptions;
begin
   Result:= [];

   {$ifdef ver100}
   if wwIsClass(dataset.classType, 'TwwClientDataSet') then
   begin
      if DataSet.Filtered then Result:= [ofoEnabled];
   end else
   {$endif}

   begin
      PropInfo:= Typinfo.GetPropInfo(DataSet.ClassInfo,'OnFilterOptions');
      if PropInfo<>Nil then PChar(@F)^:= Char(GetOrdProp(dataset, PropInfo));
      result:= f;
   end
{   if dataSet is TwwTable then result:= TwwTable(dataSet).OnFilterOptions
   else if dataSet is TwwQuery then result:=TwwQuery(dataSet).OnFilterOptions
{   else if dataSet is TwwQBE then result:= TwwQBE(dataSet).OnFilterEnabled
   else if dataSet is TwwStoredProc then result:= TwwStoredProc(dataSet).OnFilterEnabled; }
end;

Function wwProcessEscapeFilterEvent(dataset: TDataset): boolean;
var msg: TMsg;
begin
   result:= false;
   if PeekMessage(msg, 0, WM_KEYFIRST, WM_KEYLAST, PM_REMOVE) then
   begin
      if (Msg.Message=WM_KEYDOWN) and (Msg.wparam=VK_ESCAPE) then
      begin
         wwSetOnFilterEnabled(dataset, False);
         result:= true;
      end
   end;

{   if PeekMessage(msg, 0, WM_MOUSEFIRST+1, WM_MOUSELAST, PM_REMOVE) then
   begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
   end;}
end;

Function isCBuilder: boolean;
begin
   result:= (length(Application.ExeName)=0) or
            (pos('DELPHI', uppercase(Application.ExeName))=0)
end;

{4/10/97 - Define wwmin, wwmax}
Function wwmax(x,y: integer): integer;
begin
  if x>y then result:= x else result:= y;
end;

Function wwmin(x,y: integer): integer;
begin
  if x<y then result:= x else result:= y;
end;


Function wwSetControlDataSource(ctrl: TWinControl; ds: TDataSource): boolean;
var PropInfo: PPropInfo;
begin
   result:= False;
   if Ctrl.InheritsFrom(TCustomEdit) then
   begin
      PropInfo:= Typinfo.GetPropINfo(ctrl.ClassInfo,'DataSource');
      if (PropInfo <> nil) and (PropInfo^.Proptype^.Kind = tkClass) then
      begin
         SetOrdProp(Ctrl,PropInfo,LongInt(ds));
         result:= True;
      end
   end;
end;

Function wwSetControlDataField(ctrl: TWinControl; df: string): boolean;
var PropInfo: PPropInfo;
begin
   Result:= False;
   if Ctrl.InheritsFrom(TCustomEdit) then
   begin
      PropInfo:= Typinfo.GetPropINfo(ctrl.ClassInfo,'DataField');
      {$IFDEF WIN32}
      if (PropInfo<>nil) and (PropInfo^.Proptype^.Kind = tklString) then begin
      {$ELSE}
      if (PropInfo<>nil) and (PropInfo^.PropType^.Kind = tkString) then begin
      {$ENDIF}
         SetStrProp(Ctrl,PropInfo,df);
         result:= True;
      end
   end;
end;

Function wwGetControlDataField(ctrl: TWinControl): string;
var PropInfo: PPropInfo;
begin
   Result:= '';
   if Ctrl.InheritsFrom(TCustomEdit) then
   begin
      PropInfo:= Typinfo.GetPropInfo(ctrl.ClassInfo,'DataField');
      if PropInfo<>Nil then
         result:= GetStrProp(ctrl, PropInfo);
   end;
end;

{Function wwGetControlDataSource(ctrl: TWinControl): TDataSource;
var PropInfo: PPropInfo;
begin
   Result:= Nil;
   if Ctrl.InheritsFrom(TCustomEdit) then
   begin
      PropInfo:= Typinfo.GetPropInfo(ctrl.ClassInfo,'DataSource');
      if PropInfo<>Nil then begin
         result:= TDataSource(GetOrdProp(ctrl, PropInfo));
      end
   end;
end;
}
Function wwGetControlDataSource(ctrl: TComponent): TDataSource;
var PropInfo: PPropInfo;
begin
   Result:= Nil;
   PropInfo:= Typinfo.GetPropInfo(ctrl.ClassInfo,'DataSource');
   if PropInfo<>Nil then begin
      result:= TDataSource(GetOrdProp(ctrl, PropInfo));
   end
end;

function wwDataSetCompareBookmarks(DataSet: TDataSet; Bookmark1, Bookmark2: TBookmark): CmpBkmkRslt;
begin
   {$ifdef ver100}
   result:= (DataSet as TDataSet).CompareBookmarks(bookmark1, bookmark2);
   {$else}
   with (DataSet as TDBDataSet) do begin
     if Handle <> nil then
        Check(DbiCompareBookmarks(Handle, Bookmark1, Bookmark2, Result));
   end;
   {$endif}
end;

{ Return true if class is derived from 'Name' }
{ This code is more code efficient than InheritsFrom or 'Is'
  as it does not require that the compiler link in the class }
function wwIsClass(ClassType: TClass; const Name: string): Boolean;
begin
  Result := True;
  while ClassType <> nil do
  begin
{    if ClassType.ClassNameIs(Name) then Exit;}
    if wwEqualStr(ClassType.ClassName, Name) then Exit;
    ClassType := ClassType.ClassParent;
  end;
  Result := False;
end;

function wwGetWorkingRect:TRect;
begin
{$ifdef Win32}
   SystemParametersInfo(SPI_GETWORKAREA,0,Pointer(@Result),0);
{$else}
   Result.Left := 0;
   Result.Top := 0;
   Result.Right := Screen.Width;
   Result.Bottom := Screen.Height;
{$endif}
end;

Procedure wwApplyPictureMask(Control: TCustomEdit; PictureMask: string; AutoFill: boolean; var Key: Char);
var s: string;
    pict: TwwPictureValidator;

   Function NewText: string;
   var curStr : string;
   begin
      with Control do begin
         curStr:= Text;
         result:= copy(curStr, 1, selStart+1-1) +
                  char(Key) + copy(curStr, selStart + 1 + length(SelText), 32767);
      end
   end;

begin
    if not (Key in [#32..#254]) then exit;
    if Control.selStart<(length(Control.Text)-Control.selLength) then exit;

    pict:= TwwPictureValidator.create(PictureMask, AutoFill);
    s:= NewText;
    Pict.picture(s, AutoFill);
    Control.Text:= s;
    Control.selStart:= length(s);
    Pict.Free;
    key:= #0;
end;

Function wwValidPictureValue(Control: TCustomEdit; PictureMask: string): boolean;
var pict: TwwPictureValidator;
    s: string;
begin
   s:= Control.text;
   if s='' then result:= True
   else if PictureMask='' then result:= True
   else begin
      pict:= TwwPictureValidator.create(PictureMask, False);
      result:= Pict.picture(s, False)=prComplete;
      pict.Free;
   end;
end;


end.
