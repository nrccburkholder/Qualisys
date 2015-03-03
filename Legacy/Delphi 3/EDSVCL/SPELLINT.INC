type
  TChangerEntry = record
    ceChar:       Char;
    ceSymbol:     String[3];
  end;  { TChangerEntry }

const
  MaxEntries   = 35;
  ChangerTable : array[1..MaxEntries] of TChangerEntry = (
     (ceChar:'â'; ceSymbol:'A**'),
     (ceChar:'å'; ceSymbol:'A//'),
     (ceChar:'Å'; ceSymbol:'A//'),
     (ceChar:'æ'; ceSymbol:'A*_'),
     (ceChar:'Æ'; ceSymbol:'A*_'),
     (ceChar:'ä'; ceSymbol:'A*'),
     (ceChar:'Ä'; ceSymbol:'A*'),                                           (ceChar:'à'; ceSymbol:'A_'),
     (ceChar:'á'; ceSymbol:'A/'),
     (ceChar:'ê'; ceSymbol:'E**'),
     (ceChar:'ë'; ceSymbol:'E*'),
     (ceChar:'è'; ceSymbol:'E_'),
     (ceChar:'é'; ceSymbol:'E/'),
     (ceChar:'É'; ceSymbol:'E/'),
     (ceChar:'î'; ceSymbol:'I**'),
     (ceChar:'ï'; ceSymbol:'I*'),
     (ceChar:'ì'; ceSymbol:'I_'),
     (ceChar:'í'; ceSymbol:'I/'),
     (ceChar:'ô'; ceSymbol:'O**'),
     (ceChar:'ö'; ceSymbol:'O*'),
     (ceChar:'ò'; ceSymbol:'O_'),
     (ceChar:'Ö'; ceSymbol:'O*'),
     (ceChar:'ó'; ceSymbol:'O/'),
     (ceChar:'û'; ceSymbol:'U**'),
     (ceChar:'ü'; ceSymbol:'U*'),
     (ceChar:'ù'; ceSymbol:'U_'),
     (ceChar:'Ü'; ceSymbol:'U*'),
     (ceChar:'ú'; ceSymbol:'U/'),
     (ceChar:'ÿ'; ceSymbol:'Y*'),
     (ceChar:#158; ceSymbol:'P/'),
     (ceChar:'ƒ'; ceSymbol:'F/'),
     (ceChar:'Ç'; ceSymbol:'C/'),
     (ceChar:'ç'; ceSymbol:'C/'),
     (ceChar:'ñ'; ceSymbol:'N/'),
     (ceChar:'Ñ'; ceSymbol:'N*'));

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
