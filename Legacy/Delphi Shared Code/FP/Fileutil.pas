unit FileUtil;

{*******************************************************************************
Modifications:
--------------------------------------------------------------------------------
Date        UserID   Description
--------------------------------------------------------------------------------
11-22-2005  GN01     Added Program Version info

*******************************************************************************}


interface

uses SysUtils, Windows, Classes, Consts;

type
  EInvalidDest = class(EStreamError);
  EFCantMove = class(EStreamError);

 TVerInfo = class
    private
      fVersBuffer                         : string;
      fCompanyNameText                    : string;
      fFileDescriptionText                : string;
      fFileVersionText                    : string;
      fInternalNameText                   : string;
      fLegalCopyrightText                 : string;
      fLegalTrademarksText                : string;
      fOriginalFilenameText               : string;
      fProductNameText                    : string;
      fProductVersionText                 : string;
      fCommentsText                       : string;
    public
      Constructor Create(f:string);
      destructor Destroy; override;
      property CompanyNameText            : string read fCompanyNameText;
      property FileDescriptionText        : string read
fFileDescriptionText;
      property FileVersionText            : string read fFileVersionText;
      property InternalNameText           : string read fInternalNameText;
      property LegalCopyrightText         : string read fLegalCopyrightText;
      property LegalTrademarksText        : string read
fLegalTrademarksText;
      property OriginalFilenameText       : string read
fOriginalFilenameText;
      property ProductNameText            : string read fProductNameText;
      property ProductVersionText         : string read fProductVersionText;
      property CommentsText               : string read fCommentsText;
  end;

procedure CopyFile(const FileName, DestName: string);
procedure MoveFile(const FileName, DestName: string);
function GetFileSize(const FileName: string): LongInt;
function FileDateTime(const FileName: string): TDateTime;
function HasAttr(const FileName: string; Attr: Word): Boolean;
function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
Function GetFileVersion(const FileName: string; var sVersion : string):string;

implementation

uses Forms, ShellAPI;

const
  SInvalidDest = 'Destination %s does not exist';
  SFCantMove = 'Cannot move file %s';

procedure CopyFile(const FileName, DestName: TFileName);
var
  CopyBuffer: Pointer; { buffer for copying }
  BytesCopied: Longint;
  Source, Dest: Integer; { handles }
  Destination: TFileName; { holder for expanded destination name }
const
  ChunkSize: Longint = 8192; { copy in 8K chunks }
begin
  Destination := ExpandFileName(DestName); { expand the destination path }
  //if HasAttr(Destination, faDirectory) then { if destination is a directory... }
  //  Destination := Destination + '\' + ExtractFileName(FileName); { ...clone file name }
  GetMem(CopyBuffer, ChunkSize); { allocate the buffer }
  try
    Source := FileOpen(FileName, fmShareDenyWrite); { open source file }
    if Source < 0 then raise EFOpenError.CreateFmt(SFOpenError, [FileName]);
    try
      Dest := FileCreate(Destination); { create output file; overwrite existing }
      if Dest < 0 then raise EFCreateError.CreateFmt(SFCreateError, [Destination]);
      try
        repeat
          BytesCopied := FileRead(Source, CopyBuffer^, ChunkSize); { read chunk }
          if BytesCopied > 0 then { if we read anything... }
            FileWrite(Dest, CopyBuffer^, BytesCopied); { ...write chunk }
        until BytesCopied < ChunkSize; { until we run out of chunks }
      finally
        FileClose(Dest); { close the destination file }
      end;
    finally
      FileClose(Source); { close the source file }
    end;
  finally
    FreeMem(CopyBuffer, ChunkSize); { free the buffer }
  end;
end;


{ MoveFile procedure }
{
  Moves the file passed in FileName to the directory specified in DestDir.
  Tries to just rename the file.  If that fails, try to copy the file and
  delete the original.

  Raises an exception if the source file is read-only, and therefore cannot
  be deleted/moved.
}

procedure MoveFile(const FileName, DestName: string);
var
  Destination: string;
begin
  Destination := ExpandFileName(DestName); { expand the destination path }
  if not RenameFile(FileName, Destination) then { try just renaming }
  begin
    if HasAttr(FileName, faReadOnly) then  { if it's read-only... }
      raise EFCantMove.Create(Format(SFCantMove, [FileName])); { we wouldn't be able to delete it }
      CopyFile(FileName, Destination); { copy it over to destination...}
//      DeleteFile(FileName); { ...and delete the original }
  end;
end;

{ GetFileSize function }
{
  Returns the size of the named file without opening the file.  If the file
  doesn't exist, returns -1.
}

function GetFileSize(const FileName: string): LongInt;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else Result := -1;
end;

function FileDateTime(const FileName: string): System.TDateTime;
begin
  Result := FileDateToDateTime(FileAge(FileName));
end;

function HasAttr(const FileName: string; Attr: Word): Boolean;
begin
  Result := (FileGetAttr(FileName) and Attr) = Attr;
end;

function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  Result := ShellExecute(Application.MainForm.Handle, nil,
    StrPCopy(zFileName, FileName), StrPCopy(zParams, Params),
    StrPCopy(zDir, DefaultDir), ShowCmd);
end;

Constructor TVerInfo.Create(f:string);
var
   dataSize                               : integer;
   Dummy                                  : integer;
   TempString                             : String;
begin
  dataSize := GetFileVersionInfoSize(PChar(f), Dummy);
  if not (dataSize<=0) then begin
    SetLength(fVersBuffer,dataSize);
    SetLength(TempString,dataSize);

GetFileVersionInfo(PChar(f),Dummy,DataSize,PChar(fVersBuffer));

    VerQueryValue(PChar(fVersBuffer),'\StringFileInfo\040904E4\CompanyName',
              Pointer(TempString),DataSize);
    fCompanyNameText := StrPas(Pchar(TempString));


VerQueryValue(PChar(fVersBuffer),'\StringFileInfo\040904E4\FileDescription',
              Pointer(TempString),DataSize);
    fFileDescriptionText := StrPas(Pchar(TempString));

    VerQueryValue(PChar(fVersBuffer),'\StringFileInfo\040904E4\FileVersion',
              Pointer(TempString),DataSize);
    fFileVersionText := StrPas(Pchar(TempString));


VerQueryValue(PChar(fVersBuffer),'\StringFileInfo\040904E4\InternalName',
              Pointer(TempString),DataSize);
    fInternalNameText := StrPas(Pchar(TempString));


VerQueryValue(PChar(fVersBuffer),'\StringFileInfo\040904E4\LegalCopyright',
              Pointer(TempString),DataSize);
    fLegalCopyrightText := StrPas(Pchar(TempString));


VerQueryValue(PChar(fVersBuffer),'\StringFileInfo\040904E4\LegalTrademarks',
              Pointer(TempString),DataSize);
    fLegalTrademarksText := StrPas(Pchar(TempString));


VerQueryValue(PChar(fVersBuffer),'\StringFileInfo\040904E4\OriginalFilename'
,
              Pointer(TempString),DataSize);
    fOriginalFilenameText := StrPas(Pchar(TempString));

    VerQueryValue(PChar(fVersBuffer),'\StringFileInfo\040904E4\ProductName',
              Pointer(TempString),DataSize);
    fProductNameText := StrPas(Pchar(TempString));


VerQueryValue(PChar(fVersBuffer),'\StringFileInfo\040904E4\ProductVersion',
              Pointer(TempString),DataSize);
    fProductVersionText := StrPas(Pchar(TempString));

    VerQueryValue(PChar(fVersBuffer),'\StringFileInfo\040904E4\Comments',
              Pointer(TempString),DataSize);
    fCommentsText := StrPas(Pchar(TempString));
  end;
end;

destructor TVerInfo.Destroy;
begin
  inherited;
end;

{
Function GetFileVersion(const FileName: string):string;
var v1:TVerInfo;
begin
  result:='';
  v1:=TVerInfo.Create(FileName);
  result:=v1.fFileVersionText;
  v1.destroy;
end;
}


//GN01:  Gets Major, Minor, Release and Build info
function GetFileVersion(const FileName: TFileName; var sVersion : string): string;
  var
    size, len: integer;
    handle: THandle;
    buffer: pchar;
    pinfo: ^TVSFixedFileInfo;
    Major, Minor, {Release,} Build: word;
begin
    Result := '';
    size := GetFileVersionInfoSize(Pointer(FileName), handle);
    if size > 0 then
    begin
      GetMem(buffer, size);
      if GetFileVersionInfo(Pointer(FileName), 0, size, buffer) then
        if VerQueryValue(buffer, '\', pointer(pinfo), len) then
        begin
          Major   := HiWord(pinfo.dwFileVersionMS);
          Minor   := LoWord(pinfo.dwFileVersionMS);
//          Release := HiWord(pinfo.dwFileVersionLS);
          Build   := LoWord(pinfo.dwFileVersionLS);
          //For display
          //sVersion:= Format('Version %d.%d.%d%s%d%s',
          //           [Major, Minor, Release, ' (Build ', Build, ')']);
          //For version Comparison
          //Result  :=  Format('%d.%d.%d.%d',
          //           [Major, Minor, Release,Build]);
          sVersion:= Format('Version %d.%d%s%d%s',
                     [Major, Minor, ' (Build ', Build, ')']);
          //For version Comparison
          Result  :=  Format('%d.%d',
                     [Major, Minor]);

        end;
      FreeMem(buffer);
    end;
end;

end.
