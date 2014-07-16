unit Common;

{*******************************************************************************
Program Modifications:

-------------------------------------------------------------------------------
Date        ID     Description
-------------------------------------------------------------------------------
03-30-2006  GN01   Temporary fix for procedure MxArrays.GetAvailableMem

03-30-2006  GN02   Attempt to find the missing questions from BubblePos
********************************************************************************}


interface

uses
  windows, Classes, Math, SysUtils, BDE, DB, DBTables, ComCtrls, Wwtable, Wwdatsrc, Dialogs,
  Buttons, Forms, Graphics, Messages, Controls, ShellAPI, Registry, FileCtrl, MxArrays;

const
  Base36Digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Base26Digits = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Base21Digits = 'ACDEFGHJKLMNPQRTUVWXY';
  cMaxResponses = 25;
  SkipMax = 65;

  {SQL 7 field name changes}
  QPC_ID = 'QPC_ID';
  QPC_SKIP = 'QPC_Skip';
  QPC_SECTION = 'Section_ID';
  QPC_TEXT = 'QPC_Text';

type
  EBase36Error = class( Exception );
  EOrphanTagError = class( Exception );
  EQuestionMismatchError = class( Exception ); //GN02

var
	ExePath,
	DataPath,
	PrivPath,
	dbAliasName : string;

function GetRegistryEntry(const RootKey:HKEY; const OpenKey,Name:string):string;
procedure SetRegistryEntry(const RootKey:HKEY; const OpenKey, Name, regValue : string);
procedure myDelete(var S: string; Index, Count:Integer);
procedure myInsert(substr:string; var Dest: string; Index:Integer);
function getword( var s : string ) : string;
function getstring( var s : string ) : string;
FUNCTION NOQUOTES(S:STRING):STRING;
function checkdigit(vStr:string):char;
function UnBase36( vStr : string ) : LongInt;
function Base36( vInt : LongInt; vLen : Byte ) : string;
function Base26( vInt : LongInt; vLen : Byte ) : string;
function UnBase21( vStr : string ) : LongInt;
function Base21( vInt : LongInt; vLen : Byte ) : string;
function Base21CheckDigit(digits:string):string;
procedure GenerateCore( vTable : tTable );
function GetUser : string;
function CountFilter( vTable : TTable; vField : string; vCore : integer; vDelete : Boolean ) : Word;
function fDbiGetBlobSize(InDataSet: TBDEDataSet; BlobIndex: Word): longint;
function GetRelatedCount( vCore : integer; vDelete : Boolean; vRecode, vQLookup : TTable ) : Word;
function ExecuteFile(const FileName, Params, DefaultDir: string;
  ShowCmd: Integer): THandle;
procedure DelDotStar(const fn:string);
function FileTime2DateTime(FileTime: TFileTime): TDateTime;
procedure DelOlderThan(const fn:string; numDays:integer);
function AliasPath(const AP:string):string;
function AllIn(s : string; const SearchFor : string):boolean;
function substitute(Text, Old_Text, New_Text : string) : string;
{from WLKLIB32}
procedure 	SQLError(QQ : TQuery; eMsg: string);
function 	rPos(sub, str: string): integer;
function 	iMax(ii, jj: integer): integer;
function 	iMin(ii, jj: integer): integer;

Function CreateLithoText(Survey_id,lngLithoCode:LongInt;
                         strPostalBundle,strGroupDest:string;
                         Pages:array of integer) : string;

function ComputerName:string;
function TempDir(deflt:string):string;
procedure SaveTempDirInRegistry(td:string);
procedure Pause(numSecs:double);
procedure SetPath(Name,Path:string);
function GetPath(Name:string):string;
procedure CopyFiles(const Src, Dest: String);

(*
function  	doIniTableSetup: boolean;
procedure 	IniTableEdit;
function 	readIniTableStr(Section, Item: string): string;
function 	isValidPath(ss: string): boolean;
procedure 	writeIniTableStr(Section, Item, ItemValue, DataType: string);
function 	getIniPath(ss: string): string;
*)
var
  vLockCodeRows : Boolean;      // allows or restricts adding new rows to the code grid
  vMarkReview : Boolean;        // temporary storage for whether to mark an item for review
  vNewCore : integer;           // holds a incremented core value after inserting a new record
  vLanguage : Byte;             // holds the currently selected language
  vTranslate : Byte;            // holds the currently selectec non-english language

implementation

//var AppIniTable: string;

{ CORE GENERATION }

procedure CopyFiles(const Src, Dest: String);
var
  sfos: TSHFileOpStruct;
begin
  FillChar(sfos, SizeOf(sfos), #0);
  with sfos do begin
    wnd := 0;
    wFunc := FO_COPY;
    pFrom := PChar(Src);
    pTo := PChar(Dest);
    fFlags := FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR;
    hNameMappings := nil;
    lpszProgressTitle := nil;
  end;
    SHFileOperation(sfos)
end;

function GetRegistryEntry(const RootKey:HKEY; const OpenKey,Name:string):string;
var reg:tregistry;
begin
    result:= '';
    reg:=nil;
    try
      reg:=tRegistry.Create;
      reg.RootKey := RootKey;
      reg.OpenKey(OpenKey,false);
      result:=reg.ReadString(Name);
    finally
      if reg <> nil then
      try
        reg.free;
      finally
      end;
    end;
end;

procedure SetRegistryEntry(const RootKey:HKEY; const OpenKey, Name, regValue : string);
var reg:tregistry;
begin
    reg:=nil;
    try
      reg:=tRegistry.Create;
      reg.RootKey := RootKey;
      reg.OpenKey(OpenKey,true);
      reg.WriteString(Name,regValue);
    finally
      if reg <> nil then
      try
        reg.free;
      finally
      end;
    end;
end;

function GetPath(Name:string):string;
begin
    try
      result := GetRegistryEntry(HKEY_CURRENT_USER,'Software\National Research\Form Layout\Paths',Name);
    finally
      if result = '' then
        result := 'c:\temp\';
    end;
end;

procedure SetPath(Name,Path:string);
begin
  SetRegistryEntry(HKEY_CURRENT_USER,'Software\National Research\Form Layout\Paths',Name,Path);
end;

procedure myDelete(var S: string; Index, Count:Integer);
begin
  delete(s,index,count);
end;

procedure myInsert(substr:string; var Dest: string; Index:Integer);
begin
  insert(substr,Dest,Index);
end;

function getword( var s : string ) : string;
var
  i,l : integer;
begin
  i := 1;
  while ((i <= length(s)) and (s[i] = ' ')) do inc(i);
  l := 0;
  while ((i+l <= length(s)) and (S[I+L] <> ',')) DO INC(L);
  getword := copy(s,i,l);
  s := copy(s,i+l+1,255);
end;

function getstring( var s : string ) : string;
var
   i,l : integer;
begin
  i := 1;
  while ((i <= length(s)) and (s[i] = ' ')) do inc(i);
  if (i > length(s)) then
    getstring := ''
  else
    if (not (s[i] in ['''','"'])) then
      getstring := getword(s)
    else begin
      l := 1;
      while ((i+l <= length(s)) and (s[i+l] <> s[i])) do inc(l);
      if (i+l > length(s)) then begin
        s := s + s[i];
      end;
      inc(l);
      getstring := copy(s,i,l);
      s := copy(s,i+l+1,255);
    end;
end;

FUNCTION NOQUOTES(S:STRING):STRING;
BEGIN
   IF S[1] IN ['''','"'] THEN
      NOQUOTES := COPY(S,2,LENGTH(S)-2)
   ELSE
      NOQUOTES := S;
END;

function AliasPath(const AP:string):string;
var dbDes: DBDesc;
begin
  Check(DbiGetDatabaseDesc(PChar(AP), @dbDes));
  result := dbDes.szPhyName;
end;

procedure DelDotStar(const fn:string);
var sr:tSearchRec;
begin
  if findfirst(fn, faAnyfile, SR) = 0 then
    repeat
      deletefile(extractfiledir(fn)+'\'+sr.name)
    until findnext(sr)<>0
end;

function FileTime2DateTime(FileTime: TFileTime): TDateTime;
var
  LocalFileTime: TFileTime;
  SystemTime: TSystemTime;
begin
  FileTimeToLocalFileTime(FileTime, LocalFileTime);
  FileTimeToSystemTime(LocalFileTime, SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;

procedure DelOlderThan(const fn:string; numDays:integer);
var sr:tSearchRec;
begin
  if findfirst(fn, faAnyfile, SR) = 0 then
    repeat begin
      if FileTime2DateTime(sr.finddata.ftCreationTime)<(now()-numDays) then
        deletefile(extractfiledir(fn)+'\'+sr.name);
    end until findnext(sr)<>0
end;

function checkdigit(vStr:string):char;
const barcodedigits = '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-.!$/+%';
var t,i : integer;
begin
  t := 0;
  for i := 1 to length(vStr) do begin
    if vStr[i]=' ' then vStr[i] := '!';
    t := t + pos(vStr[i],barcodedigits);
  end;
  if t mod 43 = 0 then
    result := '0'
  else
    result := barcodedigits[t mod 43];
end;

{ Takes a base 36 number as a string and returns the long integer equivalent }
function UnBase36( vStr : string ) : LongInt;
var
  i, j : LongInt;
begin
  i := 0;
  j := 1;
  vStr := uppercase(vStr);
  while j <= length(vStr) do begin
    if vStr[j]=' ' then vStr[j] := '!';
    if pos(vStr[j],Base36Digits)=0 then
      delete(vStr,j,1)
    else
      inc(j);
  end;
  for j := Length( vStr ) downto 1 do
    i := i + (( Trunc( Power ( Length( Base36Digits ), ( Length( vStr ) - j ))))
        * ( Pos( Copy( vStr, j, 1), Base36Digits ) - 1 ));
  Result := i;
end;

{ Takes a long integer and returns the base 36 equivalent as a string }

function Base36( vInt : LongInt; vLen : Byte ) : string;
var
  i : Word;
  n, t : LongInt;
  vStr : string;
begin
  vStr := '';
  if vInt >= 0 then
  begin
    while vInt >= Power( Length( Base36Digits ), vLen ) do Inc( vLen );
    n := vInt;
    for i := Pred( vLen ) downto 0 do
    begin
      t := n div Trunc( Power( Length( Base36Digits ), i ));
      vStr := vStr + Copy( Base36Digits, Succ( t ), 1 );
      n := n - Trunc(( Power( Length( Base36Digits ), i )) * t );
    end;
    if UnBase36( vStr ) <> vInt then
      raise EBase36Error.Create( 'Base36 Error: Conversion is not passing check routine' );
    Result := vStr;
  end
  else
    raise EBase36Error.Create( 'Base36 Error: Conversion does not work for negative numbers' );
end;

function Base26( vInt : LongInt; vLen : Byte ) : string;
var
  i : Word;
  n, t : LongInt;
  vStr : string;
begin
  vStr := '';
  if vInt >= 0 then
  begin
    while vInt >= Power( Length( Base26Digits ), vLen ) do Inc( vLen );
    n := vInt;
    for i := Pred( vLen ) downto 0 do
    begin
      t := n div Trunc( Power( Length( Base26Digits ), i ));
      vStr := vStr + Copy( Base26Digits, Succ( t ), 1 );
      n := n - Trunc(( Power( Length( Base26Digits ), i )) * t );
    end;
    Result := vStr;
  end
  else
    raise EBase36Error.Create( 'Base26 Error: Conversion does not work for negative numbers' );
end;

{ Takes a base 21 number as a string and returns the long integer equivalent }
function UnBase21( vStr : string ) : LongInt;
var
  i, j : LongInt;
begin
  i := 0;
  j := 1;
  vStr := uppercase(vStr);
  while j <= length(vStr) do begin
    if vStr[j]=' ' then vStr[j] := '!';
    if pos(vStr[j],Base21Digits)=0 then
      delete(vStr,j,1)
    else
      inc(j);
  end;
  for j := Length( vStr ) downto 1 do
    i := i + (( Trunc( Power ( Length( Base21Digits ), ( Length( vStr ) - j ))))
        * ( Pos( Copy( vStr, j, 1), Base21Digits ) - 1 ));
  Result := i;
end;

{ Takes a long integer and returns the base 21 equivalent as a string }
function Base21( vInt : LongInt; vLen : Byte ) : string;
var
  i : Word;
  n, t : LongInt;
  vStr : string;
begin
  vStr := '';
  if vInt >= 0 then
  begin
    while vInt >= Power( Length( Base21Digits ), vLen ) do Inc( vLen );
    n := vInt;
    for i := Pred( vLen ) downto 0 do
    begin
      t := n div Trunc( Power( Length( Base21Digits ), i ));
      vStr := vStr + Copy( Base21Digits, Succ( t ), 1 );
      n := n - Trunc(( Power( Length( Base21Digits ), i )) * t );
    end;
    if UnBase21( vStr ) <> vInt then
      raise EBase36Error.Create( 'Base21 Error: Conversion is not passing check routine' );
    Result := vStr;
  end
  else
    raise EBase36Error.Create( 'Base21 Error: Conversion does not work for negative numbers' );
end;

function Base21CheckDigit(digits:string):string;
var base, i, digit : integer;
    sum : cardinal;
    Prime : array[0..36] of integer;
begin
   base := length(Base21Digits);
   Prime[0] := 3;      Prime[10] := 37;     Prime[20] := 79;      Prime[30] := 131;
   Prime[1] := 5;      Prime[11] := 41;     Prime[21] := 83;      Prime[31] := 137;
   Prime[2] := 7;      Prime[12] := 43;     Prime[22] := 89;      Prime[32] := 139;
   Prime[3] := 11;     Prime[13] := 47;     Prime[23] := 97;      Prime[33] := 149;
   Prime[4] := 13;     Prime[14] := 53;     Prime[24] := 101;     Prime[34] := 151;
   Prime[5] := 17;     Prime[15] := 59;     Prime[25] := 103;     Prime[35] := 157;
   Prime[6] := 19;     Prime[16] := 61;     Prime[26] := 107;     Prime[36] := 163;
   Prime[7] := 23;     Prime[17] := 67;     Prime[27] := 109;
   Prime[8] := 29;     Prime[18] := 71;     Prime[28] := 113;
   Prime[9] := 31;     Prime[19] := 73;     Prime[29] := 127;

   sum := 0;
   for i := length(digits) downto 1 do begin
     digit := pos(copy(digits,i, 1), base21digits);
     sum := sum + (digit * prime[length(digits)-i]);
   end;

   sum := sum mod (base*base);

   result := Base21(sum,2);
end;

{ calculates an incremented core from previous max core }

procedure GenerateCore( vTable : TTable );
var orgindex : string;
begin
  with vTable do begin
    orgindex := indexname;
    if orgIndex <> '' then indexname := '';
    if RecordCount > 0 then
    begin
      Last;
      vNewCore := Succ( FieldByName( 'Core' ).asInteger );
    end
    else
      vNewCore := 1;
    if orgIndex <> '' then indexname := orgIndex;
  end;
end;

{ GENERAL }

{ returns the user name as a string (BDE call) }

function GetUser : string;
var
  vUser : string;
begin
  SetLength( vUser, 25 );
  if dbiGetNetUserName( PChar( vUser )) = DBIERR_NONE then
    Result := PChar( vUser )
  else
    Result := 'Unknown';
end;

{ RELATED QUESTIONS }

{ returns count of or deletes (vDelete) references to a question (vCore) in a specific
  table (vTable) and column (vField):
    1. filters table to find all references
    2. if delete, then removes row or field
    3. counts references
    4. unfilters
  called by GetRelatedCount }

function CountFilter( vTable : TTable; vField :string; vCore : integer; vDelete : Boolean ) : Word;
begin
  with vTable do
  begin
    try
      Filter := vField + ' = ''' + inttostr(vCore) + '''';
      Filtered := True;
      if vDelete then
      begin
        while not EOF do
          if vField = 'Recode' then
            Delete
          else
          begin
            Edit;
            FieldByName( vField ).Clear;
            Next;
          end;
        Result := 0;
      end
      else
        Result := RecordCount;
    finally
      Filtered := False;
      Filter := '';
    end;
  end;
end;

{ returns count of or deletes (vDelete) references to a question (vCore)
    1. prepares various tables
    2. calls CountFilter
    3. returns count of related questions ( if delete, count = 0 )
  called by DeleteQuestion }

function fDbiGetBlobSize(InDataSet: TBDEDataSet; BlobIndex: Word): longint;
begin
  Inc(BlobIndex);   // Parameter iField of DbiOpenBlob requires an ordinal field number
  InDataSet.UpdateCursorPos;
  Check(DbiOpenBlob(InDataSet.Handle, InDataSet.ActiveBuffer, BlobIndex, dbiReadOnly));
  Check(DbiGetBlobSize(InDataSet.Handle, InDataSet.ActiveBuffer, BlobIndex, result));
  Check(DbiFreeBlob(InDataSet.Handle, InDataSet.ActiveBuffer, BlobIndex));
end;

function GetRelatedCount( vCore : integer; vDelete : Boolean;
    vRecode, vQLookup : TTable ) : Word;
var vQuestion : TDataSource;
begin
  with vRecode do
  begin
    vQuestion := mastersource;
    MasterSource := nil;
    try
      Result := CountFilter( vRecode, 'Recode', vCore, vDelete );
    finally
      MasterSource := vQuestion;
    end;
  end;
  Result := Result + CountFilter( vQLookup, 'PrecededBy', vCore, vDelete );
  Result := Result + CountFilter( vQLookup, 'FollowedBy', vCore, vDelete );
end;

procedure SQLError(QQ : TQuery; eMsg: string);
var
  ii: integer;
  msg: string;
begin
  msg := 'SQL Error::'+QQ.name+#13+eMsg;
  with QQ.SQL as TStrings do
    for ii := 0 to count-1 do
      msg := msg + chr(13) + strings[ii];
  messageDlg(msg, mtError, [mbOK], 0);
end;

function rPos(sub, str: string): integer;
{Find the position of a substring, searching from the right.}
var
  ii, ls: integer;
begin
  ls := length(sub);
   ii := length(str)-ls+1;
   while (copy(str, ii, ls) <> sub) and (ii > 0) do dec(ii);
   result := ii;
end;

function iMax(ii, jj: integer): integer;
begin
  if ii > jj then
    result := ii
  else
    result := jj;
end;

function iMin(ii, jj: integer): integer;
begin
  if ii < jj then
    result := ii
  else
    result := jj;
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

function TempDir(deflt:string):string;
begin
  result := GetRegistryEntry(HKEY_LOCAL_MACHINE, '\Software\National Research\QualiSys', 'TempDir');
  if (result = '') or (not directoryexists(result)) then result := deflt;
end;

procedure SaveTempDirInRegistry(td:string);
begin
  SetRegistryEntry(HKEY_LOCAL_MACHINE, '\Software\National Research\QualiSys', 'TempDir', td);
end;

procedure Pause(numSecs:Double);
var 
  StartTime: double;
begin
  StartTime := now;
  repeat
    Application.ProcessMessages;
  until Now > StartTime + NumSecs * (1/24/60/60);
end;

function ComputerName:string;
begin
  result := GetRegistryEntry(HKEY_LOCAL_MACHINE, '\System\CurrentControlSet\Services\VxD\VNETSUP', 'ComputerName');
  if result = '' then begin
    result := GetRegistryEntry(HKEY_LOCAL_MACHINE, '\SYSTEM\ControlSet001\Control\ComputerName\ActiveComputerName', 'ComputerName');
    if result = '' then
      result := 'No ComputerName found';
  end;
end;

function AllIn(s : string; const SearchFor : string):boolean;
var i : integer;
begin
  for i := 1 to length(SearchFor) do
    while pos(Searchfor[i],s)>0 do delete(s,pos(Searchfor[i],s),1);
  AllIn := (length(S)=0);
end;

function substitute(Text, Old_Text, New_Text : string) : string;
var aChar : char;
    i : integer;
begin
  // check to see if we even need to do anything
  if pos(Old_Text,Text)=0 then begin
    result := text;
    exit;
  end;

  // find a character that doesn't exist in Text
  i := 0;
  aChar := char(i);
  while pos(aChar,Text)>0 do begin
    inc(i);
    aChar := char(i);
  end;

  // replace all occurances of Old_Text with aChar
  while pos(Old_Text,Text)>0 do begin
    i := pos(Old_Text,Text);
    delete(Text,i,length(Old_Text));
    insert(aChar, Text, i);
  end;

  // replace all occurances of aChar with New_Text
  while pos(aChar,Text)>0 do begin
    i := pos(aChar,Text);
    delete(Text,i,1);
    insert(New_Text,Text,i);
  end;
  result := Text;
end;

(*function doIniTableSetup: boolean;
begin
{  result := False;
  ExePath := extractFilePath(application.ExeName);
  AppIniTable := changeFileExt(application.ExeName, '.DB');
  with TTable.create(application) do
  try
    TableName := AppIniTable;
    DataPath := '';
    PrivPath := '';
    dbAliasName := '';
    if not fileExists(AppIniTable) then begin
      TableType := ttParadox;
      with fieldDefs do begin
        Clear;
	Add('Section', ftString, 15, False);
	Add('Item', ftString, 15, False);
	Add('ItemValue', ftString, 255, False);
	Add('DataType', ftString, 1, False);
      end;
      with IndexDefs do begin
        Clear;
	Add('', 'Section;Item', [ixPrimary]);
      end;
      CreateTable;
      open;
      appendRecord(['AppDB', 	 'AliasName', '', '']);
      appendRecord(['DBPaths', 'DataPath', '', '']);
      appendRecord(['DBPaths', 'PrivPath', '', '']);
      close;
    end;

    while (dbAliasName = '') or
          (DataPath = '') or
	  (PrivPath = '') do begin
      DataPath := readIniTableStr('DBPaths', 'DataPath');
      if DataPath = '' then
        if messageDlg('No ''DataPath'' value found!'+#13#13+'<'+
	  ExePath+'Data'+'>'+#13#13+
	  'will be used.  Is this OK?',
	  mtWarning, [mbYes,mbNo], 0) = idOK then
          if isValidPath(ExePath+'Data') then begin
            DataPath := ExePath+'Data';
            writeIniTableStr('DBPaths', 'DataPath', DataPath, 'S');
          end;

     PrivPath := readIniTableStr('DBPaths', 'PrivPath');
     if PrivPath = '' then
       if messageDlg('No [PrivPath] value found!  '+#13#13+'<'+
         ExePath+'Priv'+'>'+#13#13+
	 'will be used.  Is this OK?',
	 mtWarning, [mbYes,mbNo], 0) = idOK then
	   if isValidPath(ExePath+'Priv') then begin
             PrivPath := ExePath+'Priv';
             writeIniTableStr('DBPaths', 'PrivPath', PrivPath, 'S');
           end;

     dbAliasName := readIniTableStr('AppDB', 'AliasName');
     if (dbAliasName = '') or (DataPath = '') or (PrivPath = '') then
       if messageDlg('Some of the required Setup parameters are missing,'+#13#13+'do you wish to set them yourself?', mtWarning, [mbYes,mbNo], 0) = idYes then
         IniTableEdit
       else begin
         application.terminate;
         break;
       end else
         result := True;
    end;

    result := result and
      isValidPath(dbAliasName) and
      isValidPath(Datapath) and
      isValidPath(Privpath);
  finally
    free;
  end;}
end;

procedure IniTableEdit;
begin
{
  with TIniForm.create(application) do
  try
    with wwT_IniTable do begin
      close;
      TableName := AppIniTable;
    end;
    if (showModal = mrOK) then begin
      dbAliasName := readIniTableStr('AppDB', 'AliasName');
      DataPath := readIniTableStr('DBPaths', 'DataPath');
      PrivPath := readIniTableStr('DBPaths', 'PrivPath');
    end;
  finally
    free
  end;
}
end;

function readIniTableStr(Section, Item: string): string;
begin
{  with TTable.create(application) do
  try
    TableName := AppIniTable;
    open;
    if findkey([Section, Item]) then
      result := fieldByName('ItemValue').asString
    else
      result := '';
  finally
    free;
  end;}
end;

function isValidPath(ss: string): boolean;
var
  path: string;
begin
  result := False;
  path := getIniPath(ss);
  if path <> '' then
    if fileGetAttr(path) > -1 then
      result := True
    else if messageDlg('Directory='+Path+#13#13+'Does NOT exist, would you like to create it?',mtError, [mbYes,mbCancel], 0) = mrYes then
      try
        mkDir(path);
        result := True;
      except
        on e: EInOutError do
          showMessage('Could NOT create directory='+#13#13+path+')'+#13#13+e.message);
      end;
end;

(*procedure writeIniTableStr(Section, Item, ItemValue, DataType: string);
begin
{  with TTable.create(application) do
  try
    TableName := AppIniTable;
    open;
    if findkey([Section, Item]) then begin
      edit;
      fieldByName('ItemValue').value := ItemValue;
      fieldByName('DataType').value := DataType;
      post;
    end else
      appendRecord([Section, Item, '', '']);
  finally
    free;
  end;}
end;

function getIniPath(ss: string): string;
var
  alist,plist: TStringList;
begin
{	Two assumptions:  1) NO valid Alias will ever have ':\' in the string, and
							2) ALL valid paths will have ':\' in the string somewhere.
}
{  result := '';
  if pos(':\', ss) > 0 then
    result := ss
  else begin
    alist := TStringList.create;
    try
      session.getAliasNames(alist);
      with alist do
        if indexOf(ss) > -1 then begin
          plist := TStringList.create;
          try
            session.getAliasParams(ss, plist);
            result := plist.values['PATH'];
          finally
            plist.free;
          end;
        end;
    finally
      alist.free;
    end;
  end;
}
end;
*)


function GetKeyLine(l : integer) : string;
var s,c : string;
    i,j,cs:integer;
begin
    cs := 0;
    s := FormatFloat('0000000000',l);
    For i := 1 To Length(s) do
    begin
      c := inttostr(strtoint(s[i]) * ((i mod 2) + 1));
      For j := 1 To Length(c) do
         cs := cs + strtoint(c[j]);
    end;

    c := formatfloat('00',10 - strtoint(formatfloat('00',cs)[2]))[2];
    s := s + c;
    GetKeyLine := Formatfloat('0000 0000 000',strtoint(s));

end;

Function CreateLithoText(Survey_id,lngLithoCode:LongInt;
                         strPostalBundle,strGroupDest:string;
                         Pages:array of integer) : string;
const
  LookUpTable  = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-.!$/+%';
var tmpStr,
    strCrunch,
    SaveCrunch{,
    s,strKeyLine} : string;
    i,x,lngValue:integer;
begin

    strCrunch := Base21(lngLithoCode,8);
    strCrunch := strCrunch + Base21CheckDigit(strCrunch);
    strCrunch := copy(strCrunch,1,3) + '-' + copy(strCrunch,4,4) + '-' + copy(strCrunch,8,3);

    tmpStr := #27'&f497y0X' + GetKeyLine(lngLithoCode) + #27'&f1X' +
             #27'&f496y0X' + strCrunch + #27'&f1X' +
             #27'&f499y0X';
    //Push cursor; move cursor -600x +400y; run macro 498 (puts "SAMPLE" over address); pop cursor
    If lngLithoCode = 99999999 then
      tmpStr := tmpStr + #27'&f0S'#27'*p-600x+400Y'#27'&f498y2X'#27'&f1S';

    strGroupDest:=trim(strGroupDest);
    if strGroupDest <> '' then
       strGroupDest := '-'+strGroupDest;

    tmpStr := tmpStr+
             Trim(strPostalBundle) +
             strGroupDest +
             #27'&f1X'#27'&f500y0X' +
             formatfloat('00000000',lngLithoCode) +
             '  ' + inttostr(Survey_id) +
             #27'&f1X';

    strCrunch := Base36(lngLithoCode,6);
    SaveCrunch := strCrunch;

    for i := 0 to high(pages) do
    begin
      if  pages[i] > 0 Then
      begin
          strCrunch := SaveCrunch + base36(pages[i],1);
          lngValue := 0;
          for x := 1 to length(strCrunch) do
            lngValue := lngValue + pos(strCrunch[x],LookUpTable) - 1;

          if (lngValue mod 43) = 0 then
              strCrunch := strCrunch + '0'
          else
              strCrunch := strCrunch + LookUpTable[(lngValue Mod 43) + 1];

          tmpStr := tmpStr + #27'&f' + inttostr(500 + pages[i]) + 'y0X' + strCrunch + #27'&f1X';
      end;
    end;
    CreateLithoText := tmpStr;

End;


{-------------------------------------------------------------------------------

Bug workaround for 'The DecisionCube capacity is low' bug in DashBooard and FormLayout

If you have a lot of physical memory or a large page file, you may find that a
DecisionCube raises the following exception whenever the DecisionCube's data set is opened:

Exception class: ELowCapacityError
Message: "The DecisionCube capacity is low. Please deactivate dimensions or change the data set."

As a result, the DecisionCube cannot be activated.
________________________________________________________________________________

BUG DESCRIPTION
  If you have a lot of physical memory or a large page file, you may find that a
  DecisionCube raises the following exception whenever the DecisionCube's data
  set is opened:
    Exception class: ELowCapacityError
    Message: "The DecisionCube capacity is low. Please deactivate dimensions or
             change the data set."
  The exception will occur whenever the sum of the available physical memory and
  the available page file memory exceeds 2 GBytes. This is caused by a bug in
  Delphi - more specifically: an integer being out of range in the procedure
  GetAvailableMem (unit Mxarrays).

AFFECTED DELPHI VERSIONS
  Delphi 3-7 (with the DecisionCube package installed or where unit MxArrays been used)

WORKAROUND
  Add this unit to your project.

If you use TBaseArray and noticed that programs would NOT run on machines with:
   physical memory + page file  >  Integer size

The reason is simple (after looking into the mxarrays.pas source).
The routine to determine the amount of availabe memory is casted in a poor way.
Take the code (from .\source\decision cube\mxarrays.pas):

function GetAvailableMem: Integer;
var
  MemStats: TMemoryStatus;
begin
  GlobalMemoryStatus(MemStats);
  Result := MemStats.dwAvailPhys+
                 (MemStats.dwAvailPageFile div 2);
end;

If you are on a computer with 256MB of memory, everything is fine (assuming default of page file size being same as base memory):
   Memory=268435456 
   Swap/2=134217728
   Total =402653184
          no problem here...

What about 1.5GB?   1.5 GB * 1024 MB * 1024 KB * 1024 bytes
   Memory=1610612736  bytes
   Swap/2= 805306368
   Total =2415919104
          uhh ohhh - that's more than an Integer can hold!!

Since it is being cast to an Integer (max size of: 2147483647) this routine will
report AvailableMemory as NEGATIVE!  (around -268435457)!!  This has the result of
displaying some cryptic error (The decision cube capacity is low - Please deactive dimensions or change the data set)

RESOLUTION:  I recommend changing this unit so that it uses Int64 for "Available Memory"
and all other places (like procedure calls) needed to implement that change.
I've made my own mxarrays.pas with 6 changes that make it work for machines with lots of memory+page-file:

316:  procedure SetMemoryCapacity(Value: Int64);
317:  function GetMemoryCapacity: Int64;
324:  AvailableMemory : Int64;
327:  function GetAvailableMem: Int64;
335:  procedure SetMemoryCapacity(Value: Int64);
340:  function GetMemoryCapacity: Int64;
  
-------------------------------------------------------------------------------}
//GN01
function GetAvailableMem: Integer;
const
   //MaxInt: Int64 = High(Integer); if Upper than 3 Delphi Version
  MaxInt = High(Integer);

var
  MemoryStatus: TMemoryStatus;
  //AvailableMem: Int64; if Upper than 3 Delphi Version
  AvailableMem: LongInt;
begin
  MemoryStatus.dwLength :=SizeOf(MemoryStatus);
  GlobalMemoryStatus(MemoryStatus);
  AvailableMem:= MemoryStatus.dwAvailPhys;
  if AvailableMem >= 0 then
     AvailableMem:= AvailableMem + MemoryStatus.dwAvailPageFile;

  if AvailableMem < 0 then
     Result := MaxInt
  else
     Result := AvailableMem;

end;

{ INITIALIZATION }

initialization
  vNewCore := 1;
  vLanguage := 1;
  vTranslate := 2;
  vLockCodeRows := True;
  vMarkReview := False;
  MxArrays.SetMemoryCapacity(GetAvailableMem);

end.


