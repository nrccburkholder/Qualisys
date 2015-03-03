unit wwsavflt;
{
//---------------------------------------------------------------------------
// Component to save and restore filters to  text file. - This is
// an example component provided by Woll2Woll.  You are free to use this
// component in your own applications.
//
// Components : TwwSaveFilter
//
// Copyright (c) 1997 by Woll2Woll Software
//
//
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, db, ExtCtrls,
  dbtables, dbctrls, wwstr, wwfltdlg;

type

TwwSaveFilter = class(TComponent)
private
   FDelimiter: string;
   FFilePath: string;
protected
   FOverwriteMessage: boolean;
   FCalledBySave: boolean;
   FFilterDialog: TwwFilterDialog;

   procedure SetFilterDialog(val: TwwFilterDialog);
   Procedure Notification(AComponent: TComponent; Operation: TOperation); override;

public
   constructor create(Owner: TComponent); override;
   destructor destroy; override;
   procedure SaveFilter(FilterName: string); virtual;
   function DeleteFilter(FilterName: string): boolean; virtual;
   function LoadFilter(FilterName: string): boolean; virtual;
   function GetFilterNames(FilterNames: TStrings): boolean; virtual;
   function FilterExists(FilterName: string): boolean; virtual;

published
   property Delimiter: string read FDelimiter write FDelimiter;
   property FilePath: string read FFilePath write FFilePath;
   property OverwriteMessage: boolean read FOverwriteMessage write FOverwriteMessage;
   property wwFilterDialog: TwwFilterDialog read FFilterDialog write SetFilterDialog;
end;

procedure Register;

implementation

constructor TwwSaveFilter.create(Owner: TComponent);
begin
   inherited Create(Owner);
   Delimiter := '///';
   FCalledBySave := False;
   OverwriteMessage := True;
end;

destructor TwwSaveFilter.destroy;
begin
   if (FFilterDialog<>Nil) then FFilterDialog.RemoveDependent(self);
   inherited Destroy;
end;

{ Save filter information to the file}
procedure TwwSaveFilter.SaveFilter(FilterName: string);
var DoOverwrite: boolean;
    TempStringList: TStrings;
    curFieldInfo: TwwFieldInfo;
    NewCaseSensitive: string;
    i: integer;
begin

  if (FilterName='') then exit;

  if not FileExists(FilePath) then
  begin
     TempStringList:= TStringList.create;
     TempStringList.SaveToFile(FilePath);
     TempStringList.Free;
  end;

  if (FilterExists(FilterName)) then
  begin
     if (OverwriteMessage) then
     begin
        DoOverwrite :=
            (MessageDlg('"' + FilterName + '"' + ' already exists.  Overwrite?',
            mtWarning, [mbYes, mbNo], 0)= mrYes);
     end
     else DoOverwrite := true;

     if (DoOverwrite) then DeleteFilter(FilterName)
     else exit;
  end;

  TempStringList := TStringList.create;
  TempStringList.LoadFromFile(FilePath);

  TempStringList.Add(FilterName);
  for i:= 0 to FFilterDialog.FieldInfo.Count-1 do begin
     curFieldInfo := TwwFieldInfo(FFilterDialog.FieldInfo.Items[i]);

     if (curFieldInfo.CaseSensitive) then NewCaseSensitive := 'True'
     else NewCaseSensitive := 'False';

     TempStringList.Add(curFieldInfo.FieldName + #9 +
                     curFieldInfo.DisplayLabel + #9 +
                     IntToStr(integer(curFieldInfo.MatchType)) + #9 +
                     curFieldInfo.FilterValue + #9 +
                     curFieldInfo.MinValue + #9 +
                     curFieldInfo.MaxValue + #9 + NewCaseSensitive);
  end;

  TempStringList.Add(Delimiter);
  TempStringList.SaveToFile(FilePath);
  TempStringList.Free;
end;

// Check if filter exists in file
function TwwSaveFilter.FilterExists(FilterName: string): boolean;
var TempStringList: TStrings;
    lineNum: integer;
begin
  TempStringList := TStringList.create;
  TempStringList.LoadFromFile(FilePath);
  result:= False;
  lineNum:= 0;
  while(lineNum<TempStringList.Count) do begin
     if (TempStringList.Strings[lineNum] = FilterName) then begin
        result := true;
        break;
     end
     else inc(lineNum);
  end;
  TempStringList.Free;

end;

{ Delete filter from file}
function TwwSaveFilter.DeleteFilter(FilterName: string): boolean;
var TempStringList: TStrings;
    lineNum: integer;
begin
  TempStringList := TStringList.create;
  TempStringList.LoadFromFile(FilePath);
  result:= False;
  lineNum:= 0;
  while(lineNum<TempStringList.Count) do begin
     if (TempStringList.Strings[lineNum] = FilterName) then
     begin
        while (lineNum+1<TempStringList.Count) do
        begin
           TempStringList.Delete(lineNum);
           if (TempStringList.Strings[lineNum]= Delimiter)  then
           begin
              TempStringList.Delete(lineNum);
              result := true;
              break;
           end
        end;
        if (result) then break;
     end
     else inc(lineNum);
  end;
  TempStringList.SaveToFile(FilePath);
  TempStringList.Free;
end;

{
// Pass the name of the filter you want to load, the same name passed
// from the SaveFilterToFile procedure.
}
function TwwSaveFilter.LoadFilter(FilterName: string): boolean;
var myFieldInfoStrings, TempStringList: TStrings;
    lineNum: integer;
    curFieldInfo: TwwFieldInfo;
begin
  TempStringList := TStringList.create;
  TempStringList.LoadFromFile(FilePath);
  lineNum:=0;
  result:= false;

  while(lineNum<TempStringList.Count) do begin
     if (TempStringList.Strings[lineNum] = FilterName) then begin
        FFilterDialog.ClearFilter;
        myFieldInfoStrings := TStringList.create;
        while (lineNum+1<TempStringList.Count) do begin
           inc(lineNum);
           if (TempStringList.Strings[lineNum]= Delimiter) then break;

           curFieldInfo := TwwFieldInfo.create;
           strBreakApart(TempStringList.Strings[lineNum], #9, myFieldInfoStrings);
           curFieldInfo.FieldName := myFieldInfoStrings.Strings[0];
           curFieldInfo.DisplayLabel := myFieldInfoStrings.Strings[1];
           curFieldInfo.MatchType := TwwFilterMatchType(StrToInt(myFieldInfoStrings.Strings[2]));
           curFieldInfo.FilterValue := myFieldInfoStrings.Strings[3];
           curFieldInfo.MinValue := myFieldInfoStrings.Strings[4];
           curFieldInfo.MaxValue := myFieldInfoStrings.Strings[5];
           if (myFieldInfoStrings.Strings[6] = 'True') then
              curFieldInfo.CaseSensitive := True
           else curFieldInfo.CaseSensitive := False;

           FFilterDialog.FieldInfo.Add(curFieldInfo);
        end;
        myFieldInfoStrings.Free;
        FFilterDialog.ApplyFilter;
        result := true;
        break;
     end
     else inc(lineNum);
  end;

  TempStringList.Free;
end;

{
// Get list of filter names
}
function TwwSaveFilter.GetFilterNames(FilterNames: TStrings): boolean;
var TempStringList: TStrings;
   lineNum: integer;
begin
  FilterNames.Clear;
  if (not FileExists(FilePath)) then begin
     result:= false;
     exit;
  end;

  TempStringList := TStringList.create;
  TempStringList.LoadFromFile(FilePath);

  LineNum:=0;
  while(lineNum<TempStringList.Count) do begin
     if (length(TempStringList.Strings[lineNum])=0) then begin{ Skip null lines}
        inc(lineNum);
        continue;
     end;
     if (lineNum<TempStringList.Count) then
        FilterNames.Add(TempStringList.Strings[lineNum]);

     { Skip text until encounter delimeter, then add line following delimeter to list }
     while ((TempStringList.Strings[lineNum] <> Delimiter) and
            (lineNum<TempStringList.Count-1)) do inc(lineNum);
     inc(lineNum);
  end;

  TempStringList.Free;

  result:= FilterNames.count>0;
end;

{// Inform filterdialog to notify us when it is destroyed}
procedure TwwSaveFilter.SetFilterDialog(val: TwwFilterDialog);
begin
   if (FFilterDialog<>Nil) then FFilterDialog.RemoveDependent(self);
   FFilterDialog:=val;
   if (val<>Nil) then
      FFilterDialog.AddDependent(self);
end;

procedure TwwSaveFilter.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if ((Operation = opRemove) and (AComponent = FFilterDialog)) then
    FFilterDialog:= Nil;
end;


procedure Register;
begin
   RegisterComponents('Samples', [TwwSaveFilter]);
end;
end.

