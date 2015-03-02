unit Wwfltdum;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, dialogs, wwtable, wwquery, wwqbe, wwstorep, StdCtrls, db, dbtables,
  wwtypes;

type

  TwwDummyForm = class(TForm)
  private
     FFilterParam: TParam;
     FFilterFieldBuffer: PChar;
  public
     DlgComponent: TComponent;
     MatchAny: boolean;
     DataSet: TDataSet;
     Procedure OnFilterEvent(table: TDataSet; var Accept: boolean);
     Function GetFilterField(AFieldName: string): TParam;
     Function IsNullValue(Token,Value,NullStr: string): boolean;
     Function CheckFilterField(Index:integer): boolean;
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
  end;

var
  wwDummyForm: TwwDummyForm;

implementation

uses wwfltdlg, wwstr, wwcommon, dbconsts,
(*
{$ifdef delphi3_cs}
 wwclient,
{$endif}
*)

(*{$ifdef ver100}
 dbconsts,
{$endif}
*)

{$ifdef win32}
bde;
{$else}
dbiprocs, dbierrs, dbitypes;
{$endif}

constructor TwwDummyForm.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   GetMem(FFilterFieldBuffer, 256);
   FFilterParam:= TParam.create(nil, ptUnknown);
end;

destructor TwwDummyForm.Destroy;
begin
   FreeMem(FFilterFieldBuffer, 256);
   FFilterParam.Free;
   inherited Destroy;
end;


Function TwwDummyForm.IsNullValue(Token,Value,NullStr: string): boolean;
begin
{If the current Token is the NullCharacter and the Value is Null then return true.}
   result := ((Value = '') and (AnsiCompareText(Token,NullStr)=0));
end;

Function TwwDummyForm.GetFilterField(AFieldName: string): TParam;
var curField: TField;
begin
   if DataSet is TwwQuery then result:= (DataSet as TwwQuery).wwFilterField(AFieldName)
   else if DataSet is TwwQBE then result:= (DataSet as TwwQBE).wwFilterField(AFieldName)
   else if DataSet is TwwStoredProc then result:= (DataSet as TwwStoredProc).wwFilterField(AFieldName)
(*
   {$ifdef delphi3_cs}
   else if DataSet is TwwClientDataSet then result:= (DataSet as TwwClientDataSet).wwFilterField(AFieldName)
   {$endif}
*)
   else if DataSet is TwwTable then result:= (DataSet as TwwTable).wwFilterField(AFieldName)
   else begin
      curField:= dataset.findField(AFieldName);
      if curField=Nil then begin
        {$ifdef ver100}
         DatabaseErrorFmt(SFieldNotFound, [AFieldName, AFieldName]);
        {$else}
         DBErrorFmt(SFieldNotFound, [AFieldName]);
        {$endif}
      end
      else begin
         FFilterParam.DataType:= curField.DataType;
         wwConvertFieldToParam(curField,FFilterParam,FFilterFieldBuffer);
      end;
      result:= FFilterParam;
   end
end;

Function TwwDummyForm.CheckFilterField(Index:Integer):boolean;
var
    FilterValue, FilterFieldName, RecordFieldValue: string;

    CheckMemoStr: string;
    matchPtr: PChar;
    numread: integer;
    MemoBuffer: PChar;
    blobStream: TwwMemoStream;
    FilterValuePtr: packed array[0..255] of char;

    FilterField: TField;
    tempDataType: TFieldType;
    CurPos: Integer;
    OrFlg, AndFlg: Boolean;
    SearchDelimiter: string;
    Token: string;
    tempDatetime: TParam;

    FieldOps: TwwFieldOperators;
    tempComponent: TwwFilterDialog;
    FldInfo: TwwFieldInfo;
begin

   TempComponent:= (DlgComponent as TwwFilterDialog);

   FldInfo:= TwwFieldInfo(tempComponent.FieldInfo[Index]);
   if FldInfo.FieldName='' then  { Compute field name from displaylabel if unspecified }
      FldInfo.FieldName:= wwGetFieldNameFromTitle(DataSet, FldInfo.DisplayLabel);

   FieldOps := TempComponent.FieldOperators;
   FilterFieldName:= FldInfo.FieldName;
   FilterField:= DataSet.FindField(FilterFieldName);
   FilterValue:= FldInfo.Filtervalue;

   Result:=True;

   if (FldInfo.MatchType <> fdMatchRange) then begin

      {Find if And or Or Token is in the FilterValue}
      SearchDelimiter := wwGetFilterOperator(FilterValue,FieldOps,OrFlg,AndFlg);

      {If OrFlg then initialize to false and find first case that is true}
      if (OrFlg) then Result:= False;

   end;

   if (FilterField<>Nil) and (FilterField.dataType = ftMemo) then begin
      MemoBuffer:= tempComponent.MemoBuffer;

      {$ifdef ver100}
      if (dataset is TBDEDataSet) then begin
      {$endif}

         blobStream:= TwwMemoStream.createInFilter(TMemoField(DataSet.FindField(FilterFieldName)),1);
         numread:= blobStream.read(memobuffer^, 32767);
         memobuffer[numread]:= #0;
         if numread = 0 then strcopy(memobuffer, '');
         blobstream.free;

      {$ifdef ver100}
      end
      else begin
         strcopy(MemoBuffer, PChar(DataSet.FindField(FilterFieldName).asString));
         numRead:= strlen(MemoBuffer);
      end;
      {$endif}

      if not FldInfo.caseSensitive then begin
         StrUpper(memoBuffer);
         FilterValue:=Uppercase(FilterValue);
      end;
      strpcopy(FiltervaluePtr, Filtervalue);

      CurPos := 1;
      repeat
         if (FldInfo.MatchType <> fdMatchRange) then begin
            token:= wwGetFilterToken(FilterValue,SearchDelimiter,CurPos);
            strpcopy(FiltervaluePtr, token);
         end;

         if strlen(MemoBuffer) = 0 then
            CheckMemoStr := ''             {Null Memo Field}
         else
            CheckMemoStr := 'not null';    {Non Null Memo Field}

         case FldInfo.MatchType of

         fdMatchStart:
           begin
             matchptr:=strPos(MemoBuffer,FilterValuePtr);
             if (OrFlg) then begin
                if (isnullvalue(token,CheckMemoStr,FieldOps.NullChar)) then begin
                   Result := True;
                   break;
                end
                else if (MemoBuffer=matchPtr) then begin
                   Result:=True;
                   break;
                end;
             end
             else begin
                if not isnullvalue(token,CheckMemoStr,FieldOps.NullChar) then
                   if (MemoBuffer<>matchPtr) then begin
                      Result:= False;
                      exit;
                   end
             end;
           end;

         fdMatchAny:
           begin
             matchptr:=strPos(MemoBuffer,FilterValuePtr);
             if (OrFlg) then begin
                if (isnullvalue(token,CheckMemoStr,FieldOps.NullChar)) then
                begin
                   Result := True;
                   break;
                end
                else if (matchPtr <> Nil) then begin
                   Result:=True;
                   break;
                end;
             end
             else begin
                if not isnullvalue(token,CheckMemoStr,FieldOps.NullChar) then
                   if (matchPtr=Nil) then begin
                      Result:= False;
                      exit;
                   end;
                end;
           end;

         fdMatchExact:
           begin
              if (OrFlg) then begin
                 if (isnullvalue(token,CheckMemoStr,FieldOps.NullChar)) then
                    begin
                      Result := True;
                      break;
                    end
                 else if (strlen(FiltervaluePtr)=numread) then begin
                    matchPtr:= strPos(MemoBuffer,FilterValuePtr);
                    if (matchPtr<>Nil) then begin
                       Result:= True;
                       break;
                    end;
                 end;
              end
              else begin
                 if not isnullvalue(token,CheckMemoStr,FieldOps.NullChar) then
                    if strlen(FiltervaluePtr)<>numread then begin
                       Result:= False;
                       exit;
                    end
                    else begin
                       matchPtr:= strPos(MemoBuffer, FilterValuePtr);
                       if matchPtr=Nil then begin
                          Result:= False;
                          exit;
                       end;
                 end;
              end;
           end;

         fdMatchRange:

         end;      {case}

      until (CurPos=-1) or (FldInfo.MatchType=fdMatchRange);

   end
   else begin (* Not Memo Field *)
      RecordFieldValue := '';
      case Filterfield.dataType of
         ftDate:   begin   {!!!!! Paul - Added to handle null date/times}
                   tempDatetime := GetFilterField(FilterFieldName);
                   if not tempDatetime.isnull then
                      RecordFieldValue:= DateToStr(tempDatetime.asDate);
                   end;
         ftDateTime:begin
                    tempDatetime := GetFilterField(FilterFieldName);
                    if tempDatetime.isnull then
                       RecordFieldValue:= DateTimeToStr(tempDatetime.asDateTime);
                    end;
         ftTime:    begin
                    tempDatetime := GetFilterField(FilterFieldName);
                    if tempDatetime.isnull then
                       RecordFieldValue:= TimeToStr(tempDatetime.asTime);
                    end;
         else RecordFieldValue:= GetFilterField(FilterFieldName).asString;
      end;

      if not FldInfo.caseSensitive then begin
         RecordFieldValue:= UpperCase(RecordFieldValue);
         FilterValue:= Uppercase(FilterValue);
      end;

      CurPos:= 1;
      repeat

         if (FldInfo.MatchType <> fdMatchRange) then begin
            token:= wwGetFilterToken(FilterValue,SearchDelimiter,CurPos);
            strpcopy(FilterValuePtr,token);
         end;

         case FldInfo.MatchType of
           fdMatchEnd:
              begin
                 if (OrFlg) then begin
                    if (isnullvalue(token,recordfieldvalue,FieldOps.NullChar)) then
                    begin
                       Result := True;
                       break;
                    end
                    else if (length(RecordFieldValue)>=length(token)) and
                       (pos(token, RecordFieldValue)=
                       length(RecordFieldValue)+1-length(token)) then
                    begin
                       Result:= True;
                       exit;
                    end;
                 end
                 else begin
                    if not isnullvalue(token,recordfieldvalue,FieldOps.NullChar) then
                       if (length(RecordFieldValue)<length(token)) or
                          (pos(token, RecordFieldValue)<>
                          length(RecordFieldValue)+1-length(token)) then
                       begin
                          Result:= False;
                          exit;
                       end;
                 end
              end;

            fdMatchStart:
              begin
                 if (OrFlg) then begin
                    if (isnullvalue(token,recordfieldvalue,FieldOps.NullChar)) then
                    begin
                       Result := True;
                       break;
                    end
                    else if (pos(token, RecordFieldValue)=1) then begin
                       Result:= True;
                       break;
                    end;
                 end
                 else begin
                    if not isnullvalue(token,recordfieldvalue,FieldOps.NullChar) then
                       if (pos(token, RecordFieldValue)<>1) then begin
                          Result:= False;
                          exit;
                       end
                 end
              end;

            fdMatchAny:
              begin
                 if (OrFlg) then begin
                    if (isnullvalue(token,recordfieldvalue,FieldOps.NullChar)) then
                    begin
                       Result := True;
                       break;
                    end
                    else if (pos(token, RecordFieldValue)<>0) then begin
                       Result:=True;
                       break;
                    end;
                 end
                 else begin
                    if not isnullvalue(token,recordfieldvalue,FieldOps.NullChar) then
                       if (pos(token, RecordFieldValue)=0) then begin
                          Result:= False;
                          exit;
                       end
                 end
              end;

            fdMatchExact:
              begin
                 if (OrFlg) then begin
                    if (isnullvalue(token,recordfieldvalue,FieldOps.NullChar)) then begin
                       Result := True;
                       break;
                    end
                    else if (token = RecordFieldValue) then begin
                       Result:= True;
                       break;
                    end
                 end
                 else begin    {And Flag or nothing}
                    if not isnullvalue(token,recordfieldvalue,FieldOps.NullChar) then
                       if (token<>RecordFieldValue) then
                       begin
                          Result:= False;
                          exit;
                       end
                 end
              end;

            fdMatchRange:
              begin
                 tempDataType:= FilterField.dataType;
                 {$ifdef win32}
                 if tempDataType = ftAutoInc then tempDataType:= ftInteger;
                 {$endif}

                 case tempDataType of
                    ftDate:
                          if (FldInfo.MinValue<>'') and
                             (GetFilterField(FilterFieldName).asDate<StrToDate(FldInfo.MinValue)) then
                          begin
                             Result:= False;
                             exit;
                          end
                          else if (FldInfo.MaxValue<>'') and
                                  (GetFilterfield(FilterFieldName).asDate>StrToDate(FldInfo.MaxValue)) then
                          begin
                             Result:= False;
                             exit;
                          end;

                    ftDateTime:
                          if (FldInfo.MinValue<>'') and
                             (GetFilterField(FilterFieldName).asDateTime<StrToDateTime(FldInfo.MinValue)) then
                          begin
                               Result:= False;
                               exit;
                          end
                          else if (FldInfo.MaxValue<>'') and
                                  (GetFilterfield(FilterFieldName).asDateTime>StrToDateTime(FldInfo.MaxValue)) then
                          begin
                             Result:= False;
                             exit;
                          end;

                    ftTime:
                          if (FldInfo.MinValue<>'') and
                             (GetFilterField(FilterFieldName).asTime<StrToTime(FldInfo.MinValue)) then
                          begin
                             Result:= False;
                             exit;
                          end
                          else if (FldInfo.MaxValue<>'') and
                                  (GetFilterfield(FilterFieldName).asTime>StrTotime(FldInfo.MaxValue)) then
                          begin
                             Result:= False;
                             exit;
                          end;

                    ftSmallInt, ftInteger, ftWord:
                          if (FldInfo.MinValue<>'') and
                             (GetFilterField(FilterFieldName).asInteger<StrToInt(FldInfo.MinValue)) then
                          begin
                             Result:= False;
                             exit;
                          end
                          else if (FldInfo.MaxValue<>'') and
                                  (GetFilterfield(FilterFieldName).asInteger>StrToInt(FldInfo.MaxValue)) then
                          begin
                             Result:= False;
                             exit;
                          end;

                    ftFloat, ftCurrency:
                          if (FldInfo.MinValue<>'') and
                             (GetFilterField(FilterFieldName).asFloat<StrToFloat(FldInfo.MinValue)) then
                          begin
                             Result:= False;
                             exit;
                          end
                          else if (FldInfo.MaxValue<>'') and
                                  (GetFilterfield(FilterFieldName).asFloat>StrToFloat(FldInfo.MaxValue)) then
                          begin
                             Result:= False;
                             exit;
                          end;

                    ftString:
                          if (FldInfo.MinValue<>'') and
                             (GetFilterField(FilterFieldName).asString<FldInfo.MinValue) then
                          begin
                             Result:= False;
                             exit;
                          end
                          else if (FldInfo.MaxValue<>'') and
                                  (GetFilterfield(FilterFieldName).asString>FldInfo.MaxValue) then
                          begin
                             Result:= False;
                             exit;
                          end;
                 end; {end case for tempDataType}
             end; {End MatchRange}
         end; {End case;}
      until (CurPos= -1) or (FldInfo.MatchType=fdMatchRange);
   end;

end;

{ Don't use try finally block because performance dramatically slows down }
Procedure TwwDummyForm.OnFilterEvent(table: TDataSet; var Accept: boolean);
var i: integer;
    tempComponent: TwwFilterDialog;
    FldInfo:TwwFieldInfo;
begin
   Accept:= True;

   tempComponent:= (DlgComponent as TwwFilterDialog);
   DataSet:= table;

   for i:= 0 to tempComponent.FieldInfo.count-1 do begin
      FldInfo:= TwwFieldInfo(tempComponent.FieldInfo[i]);
      if FldInfo.FieldName='' then  { Compute field name from displaylabel if unspecified }
        FldInfo.FieldName:= wwGetFieldNameFromTitle(DataSet, FldInfo.DisplayLabel);

      Accept := CheckFilterField(i);

      if ((FldInfo.NonMatching) and (FldInfo.MatchType <> fdMatchRange)) then
         Accept := not Accept;      {3/10/97 - Added NonMatching support for values}

      if not Accept then break;
   end; {end for}
end;

{$R *.DFM}

end.
