unit wwstorep;
{
//
// Components : TwwStoredProc
//
// Copyright (c) 1995 by Woll2Woll Software
//
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, DB, DBTables, dialogs, wwfilter, wwStr,
  wwSystem, wwTable, wwtypes,
{$IFDEF WIN32}
bde
{$ELSE}
dbiprocs, dbiTypes, dbierrs
{$ENDIF}
;

type
  TwwStoredProc = class;
  TwwStoredProcFilterEvent = Procedure(StoredProc: TwwStoredProc; var Accept: boolean) of object;
  TwwStoredProc = class(TStoredProc)
  private
     FLookupFields: TStrings;
     FLookupLinks: TStrings;
     FControlType: TStrings;
     FPictureMasks: TStrings;
     FUsePictureMask: boolean;

     FOnInvalidValue: TwwInvalidValueEvent;
     FOnFilterOptions: TwwOnFilterOptions;
     FOnFilterEscape: TDataSetNotifyEvent;
     FOnFilter: TwwStoredProcFilterEvent;
     FFilterBuffer: Pointer;
     FFilterFieldBuffer: PChar;
     hFilterFunction: hDBIFilter;
     FFilterParam: TParam;
     procedure SetOnFilter(val: TwwStoredProcFilterEvent);

     function GetLookupFields: TStrings;
     procedure SetLookupFields(sel : TStrings);
     function GetLookupLinks: TStrings;
     procedure SetLookupLinks(sel : TStrings);
     function GetControlType: TStrings;
     procedure SetControlType(sel : TStrings);
     function GetPictureMasks: TStrings;
     procedure SetPictureMasks(sel : TStrings);
     Procedure SetOnFilterOptions(val: TwwOnFilterOptions);

  protected
     procedure DoOnCalcFields; override;
     procedure DoAfterOpen; override;
     procedure DoBeforePost; override; { For picture support }

     {$ifdef ver100}
     procedure DataEvent(Event: TDataEvent; Info: Longint); override;
     function IsSequenced: Boolean; override;
     function GetNextRecords: Integer; override;
     Procedure ResetMouseCursor;
     {$endif}

  public
    LookupTables: TList;       { List of lookup tables }
    InFilterEvent: boolean;    {Woll2Woll Internal use only}
    {$ifdef ver100}
    ProcessingOnFilter: boolean;
    {$endif}

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function IsValidField(fieldName : string): boolean;
    procedure RemoveObsoleteLinks;
    Procedure FreeLookupTables;
    Function wwFilterField(AFieldName: string): TParam;

  published
    property ControlType : TStrings read getControlType write setControltype;
    property LookupFields : TStrings read getLookupFields write setLookupFields;
    property LookupLinks : TStrings read getLookupLinks write setLookupLinks;
    property PictureMasks: TStrings read GetPictureMasks write SetPictureMasks;
    property ValidateWithMask: boolean read FUsePictureMask write FUsePictureMask;
    property OnFilter: TwwStoredProcFilterEvent read FOnFilter write SetOnFilter;
    property OnFilterEscape: TDataSetNotifyEvent read FOnFilterEscape write FOnFilterEscape;
    property OnFilterOptions: TwwOnFilterOptions read FOnFilterOptions write SetOnFilterOptions
       default [ofoEnabled, ofoShowHourGlass];
    property OnInvalidValue: TwwInvalidValueEvent read FOnInvalidValue write FOnInvalidValue;
  end;

procedure Register;

implementation


   uses wwcommon, dbconsts;

function filterQueryFunction(
      ulClientData  : Longint;
      pRecBuf       : Pointer;
      iPhyRecNum    : Longint
 ): Integer; export;
{$IFDEF WIN32}
 stdcall;  {stdcall added for win95}
{$ENDIF}
var filteredTable: TwwStoredProc;
    TempResult: boolean;
begin
   result:= 1;

   filteredTable:= TwwStoredProc(ulClientData);
   if (csDestroying in filteredTable.ComponentState) then begin
      exit;
   end;

   with filteredTable do begin
      if Assigned(FOnFilter) then begin
         if inFilterEvent then begin
            result:= 1;
            exit;
         end;

         inFilterEvent:= True;
         FFilterBuffer:= pRecBuf;
         TempResult:= True;
         OnFilter(filteredTable, TempResult);
         if TempResult then result:= 1 else result:= 0;
         inFilterEvent:= False;
      end
   end
end;


    constructor TwwStoredProc.create(AOwner: TComponent);
    begin
      inherited Create(AOwner);
      FControlType:= TStringList.create;
      FLookupFields:= TStringList.create;  { Must be a TStringList type }
      FLookupLinks:= TStringList.create;
      FPictureMasks:= TStringList.create;
      lookupTables:= TList.create;       { List of lookup tables }

      GetMem(FFilterFieldBuffer, 256);
      FFilterParam:= TParam.create(nil, ptUnknown);
      FUsePictureMask:= True;
      FOnFilterOptions:= [ofoEnabled, ofoShowHourGlass];
    end;

    destructor TwwStoredProc.Destroy;
    begin
      FLookupFields.Free;
      FLookupLinks.Free;
      FControlType.Free;
      FPictureMasks.Free;
      FPictureMasks:= Nil;
      LookupTables.free;

      FreeMem(FFilterFieldBuffer, 256);
      FFilterParam.Free;

      inherited Destroy;
    end;

    procedure TwwStoredProc.DoAfterOpen;
    begin
       inherited DoAfterOpen;  { 9/5/96 }
       if assigned(FOnFilter)then begin
          wwSetFilterFunction(@filterQueryFunction, self, hFilterFunction);
       end
    end;

    function TwwStoredProc.GetControltype: TStrings;
    begin
         Result:= FControlType;
    end;

    procedure TwwStoredProc.SetControlType(sel : TStrings);
    begin
       FControlType.assign(sel);
    end;

    function TwwStoredProc.GetLookupFields: TStrings;
    begin
       Result:= FLookupFields;
    end;

    procedure TwwStoredProc.SetLookupFields(sel : TStrings);
    begin
         FLookupFields.assign(sel);
    end;

    function TwwStoredProc.GetPictureMasks: TStrings;
    begin
       Result:= FPictureMasks
    end;

    procedure TwwStoredProc.SetPictureMasks(sel : TStrings);
    begin
         FPictureMasks.assign(sel);
    end;

    function TwwStoredProc.GetLookupLinks: TStrings;
    begin
         Result:= FLookupLinks;
    end;

    procedure TwwStoredProc.SetLookupLinks(sel : TStrings);
    begin
         FLookupLinks.assign(sel);
    end;

    Procedure TwwStoredProc.FreeLookupTables;
    var i: integer;
    begin
       for i:= lookupTables.count-1 downto 0 do
       begin
          TwwTable(lookupTables.items[i]).free;
          lookupTables.delete(i);
       end;
    end;

    { Removes obsolete links and control types }
    procedure TwwStoredProc.RemoveObsoleteLinks;
    begin
       wwDataSetRemoveObsolete(self, FLookupFields, FLookupLinks, FControlType);
    end;

    procedure TwwStoredProc.DoOnCalcFields;
    begin
       removeObsoleteLinks;
       wwDataSetDoOnCalcFields(self, FLookupFields, FLookupLinks, lookupTables);
       inherited DoOnCalcFields;
    end;

  Function TwwStoredProc.IsValidField(fieldName : string): boolean;
  begin
      result:= wwDataSetIsValidField(self, fieldname);
  end;

  procedure TwwStoredProc.SetOnFilter(val: TwwStoredProcFilterEvent);
  begin
     FOnFilter:= val;
     if @val=Nil then wwSetFilterFunction(Nil, self, hFilterFunction)
     else begin
        if not active then exit;
        wwSetFilterFunction(@filterQueryFunction, self, hFilterFunction);
        if hFilterFunction=nil then
           MessageDlg('Local filtering is not supported' +
              ' on a Live-Query which contains a Where clause in the SQL string. ' +
              'To perform a local filter on this query, you will need to set its RequestLive property' +
              ' to False.',  mtWarning, [mbok], 0);
     end

  end;


Function TwwStoredProc.wwFilterField(AFieldName: string): TParam;
var curField: TField;
    isBlank: bool;
    OtherField: TField;
    method: TMethod;
begin
   curField:= findField(AFieldName);
   if curField=Nil then begin
     {$ifdef ver100}
      DatabaseErrorFmt(SFieldNotFound, [AFieldName]);
     {$else}
      DBErrorFmt(SFieldNotFound, [AFieldName]);
     {$endif}
      result:= FFilterParam;
      exit;
   end;

   if not wwisNonPhysicalField(curfield) then begin
      dbiGetField(handle, curField.FieldNo, FFilterBuffer, FFilterFieldBuffer, isBlank);

      with FFilterParam do begin
         DataType:= curField.DataType;
         if (DataType=ftString) and TStringField(curField).transliterate then
            NativeToAnsiBuf(Database.Locale, FFilterFieldBuffer, FFilterFieldBuffer, 255);
         {$ifdef win32}
         if (DataType=ftAutoInc) then DataType:=ftInteger;
         {$endif}

         SetData(FFilterFieldBuffer);
         if isBlank then Clear;
      end;
   end
   else begin  {This is a lookup or a calculated field so get Lookup field value}

      method.data:= self;
      method.code:= @TwwStoredProc.wwFilterField;
      OtherField := wwDataSet_GetFilterLookupField(Self, curfield, method);

      if OtherField <> nil then begin
        FFilterParam.DataType:= OtherField.DataType;
        wwConvertFieldToParam(OtherField,FFilterParam,FFilterFieldBuffer);
      end;

   end;


   result:= FFilterParam;
end;

procedure TwwStoredProc.DoBeforePost;
begin
  inherited DoBeforePost;
  if FUsePictureMask then
     wwValidatePictureFields(self, FOnInvalidValue);
end;

Procedure TwwStoredProc.SetOnFilterOptions(val: TwwOnFilterOptions);
begin
   if (ofoEnabled in FOnFilterOptions) and
      not (ofoEnabled in val) then
   begin
      FOnFilterOptions:= val;
      if active and Assigned(FOnFilter) then begin
         UpdateCursorPos;
         resync([]);
      end
   end
   else FOnFilterOptions:= val;
end;

{$ifdef ver100}
procedure TwwStoredProc.ResetMouseCursor;
begin
   if (ofoShowHourGlass in OnFilterOptions) and ProcessingOnFilter then
   begin
      if Screen.cursor<>crArrow then
      begin
         Screen.cursor:= crArrow;
         ProcessingOnFilter:= False;
      end
   end
end;

function TwwStoredProc.IsSequenced: Boolean;
begin
  result:= inherited isSequenced;
  if result then begin
     if Assigned(FOnFilter) then result:= False;
  end
end;

function TwwStoredProc.GetNextRecords: Integer;
begin
   result:= inherited GetNextRecords;
   ResetMouseCursor;
end;

procedure TwwStoredProc.DataEvent(Event: TDataEvent; Info: Longint);
begin
   inherited DataEvent(Event, Info);
   ResetMouseCursor;
end;

{$endif}

procedure Register;
begin
{  RegisterComponents('InfoPower', [TwwTable]);}
end;

end.
