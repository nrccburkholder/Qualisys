unit wwclient;
{
//
// Components : TwwClientDataSet
//
// Copyright (c) 1995 by Woll2Woll Software
//
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, DB, DBTables, dialogs, wwfilter, wwStr,
  wwSystem, wwTable, wwtypes, dbclient,
{$IFDEF WIN32}
bde
{$ELSE}
dbiprocs, dbiTypes, dbierrs
{$ENDIF}
;

type
  TwwClientDataSet = class;
  TwwClientDataSetFilterEvent = Procedure(ClientDataSet: TwwClientDataSet; var Accept: boolean) of object;

  TwwClientDataSet = class(TClientDataSet)
  private
     FControlType: TStrings;
     FPictureMasks: TStrings;
     FUsePictureMask: boolean;

     FOnInvalidValue: TwwInvalidValueEvent;
     FOnFilter: TFilterRecordEvent;
     FFilterFieldBuffer: PChar;
     FFilterParam: TParam;
     procedure SetOnFilter(val: TFilterRecordEvent);

     function GetControlType: TStrings;
     procedure SetControlType(sel : TStrings);
     function GetPictureMasks: TStrings;
     procedure SetPictureMasks(sel : TStrings);

  protected
     procedure DoBeforePost; override; { For picture support }

     {$ifdef ver100}
     function IsSequenced: Boolean; override;
     {$endif}

  public
    InFilterEvent: boolean;    {Woll2Woll Internal use only}

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function wwFilterField(AFieldName: string): TParam;

  published
    property ControlType : TStrings read getControlType write setControltype;
    property PictureMasks: TStrings read GetPictureMasks write SetPictureMasks;
    property ValidateWithMask: boolean read FUsePictureMask write FUsePictureMask;
    property OnFilter: TFilterRecordEvent read FOnFilter write SetOnFilter;
    property OnInvalidValue: TwwInvalidValueEvent read FOnInvalidValue write FOnInvalidValue;
  end;

procedure Register;

implementation


   uses wwcommon, dbconsts;

    constructor TwwClientDataSet.create(AOwner: TComponent);
    begin
      inherited Create(AOwner);
      FControlType:= TStringList.create;
      FPictureMasks:= TStringList.create;

      GetMem(FFilterFieldBuffer, 256);
      FFilterParam:= TParam.create(nil, ptUnknown);
      FUsePictureMask:= True;

    end;

    destructor TwwClientDataSet.Destroy;
    begin
      FControlType.Free;
      FPictureMasks.Free;
      FPictureMasks:= Nil;

      FreeMem(FFilterFieldBuffer, 256);
      FFilterParam.Free;

      inherited Destroy;
    end;


    function TwwClientDataSet.GetControltype: TStrings;
    begin
         Result:= FControlType;
    end;

    procedure TwwClientDataSet.SetControlType(sel : TStrings);
    begin
       FControlType.assign(sel);
    end;

    function TwwClientDataSet.GetPictureMasks: TStrings;
    begin
       Result:= FPictureMasks
    end;

    procedure TwwClientDataSet.SetPictureMasks(sel : TStrings);
    begin
         FPictureMasks.assign(sel);
    end;


  procedure TwwClientDataSet.SetOnFilter(val: TFilterRecordEvent);
  begin
     OnFilterRecord:= val;
  end;


Function TwwClientDataSet.wwFilterField(AFieldName: string): TParam;
var curField, OtherField: TField;
   method: TMethod;
begin
   curField:= findField(AFieldName);
   if curField=Nil then begin
     {$ifdef ver100}
      DatabaseErrorFmt(SFieldNotFound, [AFieldName, AFieldName]);
     {$else}
      DBErrorFmt(SFieldNotFound, [AFieldName]);
     {$endif}
      result:= FFilterParam;
      exit;
   end;

   if not wwisNonPhysicalField(curfield) then begin
      FFilterParam.DataType:= curField.DataType;
      wwConvertFieldToParam(curField, FFilterParam, FFilterFieldBuffer);
   end
   else begin  {This is a lookup or a calculated field so get Lookup field value}
      method.data:= self;
      method.code:= @TwwClientDataset.wwFilterField;
      OtherField := wwDataSet_GetFilterLookupField(Self, curfield, method);

      if OtherField <> nil then begin
        FFilterParam.DataType:= OtherField.DataType;
        wwConvertFieldToParam(OtherField, FFilterParam, FFilterFieldBuffer);
      end;

   end;

   result:= FFilterParam;
end;

procedure TwwClientDataSet.DoBeforePost;
begin
  inherited DoBeforePost;
  if FUsePictureMask then
     wwValidatePictureFields(self, FOnInvalidValue);
end;

{$ifdef ver100}

function TwwClientDataSet.IsSequenced: Boolean;
begin
  result:= inherited isSequenced;
  if result then begin
     if Assigned(FOnFilter) then result:= False;
  end
end;

{$endif}

procedure Register;
begin
{  RegisterComponents('InfoPower', [TwwTable]);}
end;

end.
