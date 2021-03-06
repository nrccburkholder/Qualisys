type
  TChangerEntry = record
    ceChar:       Char;
    ceSymbol:     String[3];
  end;  { TChangerEntry }

const
  MaxEntries   = 35;
  ChangerTable : array[1..MaxEntries] of TChangerEntry = (
     (ceChar:'�'; ceSymbol:'A**'),
     (ceChar:'�'; ceSymbol:'A//'),
     (ceChar:'�'; ceSymbol:'A//'),
     (ceChar:'�'; ceSymbol:'A*_'),
     (ceChar:'�'; ceSymbol:'A*_'),
     (ceChar:'�'; ceSymbol:'A*'),
     (ceChar:'�'; ceSymbol:'A*'),                                           (ceChar:'�'; ceSymbol:'A_'),
     (ceChar:'�'; ceSymbol:'A/'),
     (ceChar:'�'; ceSymbol:'E**'),
     (ceChar:'�'; ceSymbol:'E*'),
     (ceChar:'�'; ceSymbol:'E_'),
     (ceChar:'�'; ceSymbol:'E/'),
     (ceChar:'�'; ceSymbol:'E/'),
     (ceChar:'�'; ceSymbol:'I**'),
     (ceChar:'�'; ceSymbol:'I*'),
     (ceChar:'�'; ceSymbol:'I_'),
     (ceChar:'�'; ceSymbol:'I/'),
     (ceChar:'�'; ceSymbol:'O**'),
     (ceChar:'�'; ceSymbol:'O*'),
     (ceChar:'�'; ceSymbol:'O_'),
     (ceChar:'�'; ceSymbol:'O*'),
     (ceChar:'�'; ceSymbol:'O/'),
     (ceChar:'�'; ceSymbol:'U**'),
     (ceChar:'�'; ceSymbol:'U*'),
     (ceChar:'�'; ceSymbol:'U_'),
     (ceChar:'�'; ceSymbol:'U*'),
     (ceChar:'�'; ceSymbol:'U/'),
     (ceChar:'�'; ceSymbol:'Y*'),
     (ceChar:#158; ceSymbol:'P/'),
     (ceChar:'�'; ceSymbol:'F/'),
     (ceChar:'�'; ceSymbol:'C/'),
     (ceChar:'�'; ceSymbol:'C/'),
     (ceChar:'�'; ceSymbol:'N/'),
     (ceChar:'�'; ceSymbol:'N*'));

function ToDictionaryFormat (St: string): string;
  {-prepares a word for dictionary}
var
  i:        integer;
  SavePos:  byte;
  CharSt:   string[1];
begin
  St := UpperCase (St);
  for i := 1 to MaxEntries do
  begin
    CharSt  := Char (ChangerTable[i].ceChar);
    SavePos := Pos (CharSt, St);
    if SavePos > 0 then
    begin
      Delete (St, SavePos, 1);
      Insert (ChangerTable[i].ceSymbol, St, SavePos);
    end;  { if... }
  end;  { next i }
  Result := St;
end;  { ToDictionaryFormat }

function FromDictionaryFormat (St: string): string;
  {-converts a word from the dictionary format}
var
  i:        integer;
  SavePos:  byte;
begin
  St := UpperCase (St);
  for i := 1 to MaxEntries do
  begin
    SavePos := Pos (ChangerTable[i].ceSymbol, St);
    if SavePos > 0 then
    begin
      Delete (St, SavePos, 1);
      Insert (ChangerTable[i].ceChar, St, SavePos);
    end;  { if... }
  end;  { next i }
  Result := St;
end;  { FromDictionaryFormat }

function AdjustCase (St, PictureSt: String): String;
  {-adjust the case of St according to the case of the PictureSt}
  {-usually used for suggest words using original word as PictureSt}
begin
  if PictureSt[2] = UpCase (PictureSt[2]) then
  begin
    {assume uppercase}
    Result := UpperCase (St);
  end {:} else
  begin
    St := LowerCase (St);
    if PictureSt[1] = UpCase (PictureSt[1]) then
      St[1] := UpCase (St[1]);
    Result := St;
  end;  { else }
end;  { AdjustCase }
