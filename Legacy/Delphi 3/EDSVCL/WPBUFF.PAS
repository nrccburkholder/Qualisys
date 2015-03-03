(* WPBuff.PAS - Copyright (c) 1995-1996, Eminent Domain Software *)

unit WPBuff;
  {-WPTools buffer manager for EDSSpell component}
interface
uses
  Classes, Controls, Graphics, SysUtils, Forms, StdCtrls,
  WinProcs, WinTypes, WPWinCtr,
  AbsBuff, MemoUtil, SpellGbl;

type
  TWPBuf = class (TPCharBuffer)  {WPTools Editor Buffer Manager}
    private
      { Private declarations }
      WeModified: Boolean;
    protected
      { Protected declarations }
    public
      { Public declarations }
      constructor Create (AParent: TControl);  override;

      function    IsModified: Boolean;  override;
        {-returns TRUE if parent had been modified}
      procedure   SetModified (NowModified: Boolean);  override;
        {-sets parents modified flag}
      function    GetYPos: integer;  override;
        {-gets the current y location of the highlighted word (absolute screen)}
      procedure   SetSelectedText;  override;
        {-highlights the current word using BeginPos & EndPos}
      function    GetNextWord: string;  override;
        {-returns the next word in the buffer}
      procedure   UpdateBuffer;  override;
        {-updates the buffer from the parent component, if any}
      procedure   ReplaceWord (WithWord: string);  override;
        {-replaces the current word with the word provided}
  end;  { TWPBuf }

implementation

{WPTools Editor Buffer Manager}
constructor TWPBuf.Create (AParent: TControl);
begin
  inherited Create (AParent);
  WeModified := FALSE;
end;  { TWPBuf.Create }

function TWPBuf.IsModified: Boolean;
  {-returns TRUE if parent had been modified}
begin
  Result := WeModified;
end;  { TWPBuf.IsModified }

procedure TWPBuf.SetModified (NowModified: Boolean);
  {-sets parents modified flag}
begin
  WeModified := NowModified;
end;  { TWPBuf.SetModified }

function TWPBuf.GetYPos: integer;
  {-gets the current y location of the highlighted word (absolute screen)}
begin
  Result := 0;
end;  { TWPBuf.GetYPos }

procedure TWPBuf.SetSelectedText;
  {-highlights the current word using FBeginPos & FEndPos}
begin
  with Parent as TWPCustomRtfEdit do
    Spell_SelectWord;
end;  { TWPBuf.SetSelectedText }

function TWPBuf.GetNextWord: string;
  {-returns the next word in the buffer}
var
  i: byte;
  pResult : pChar;
begin
  with Parent as TWPCustomRtfEdit do
  begin
    Result := Spell_GetNextWord;
    if (Result <> '') then
     begin
      pResult := @Result[1];
      Result := Result + #00;
      ANSItoOEM(pResult, pResult);
      Result := StrPas (pResult);
      end;
    AllNumbers := TRUE;
    i := 1;
    while (i <= Length (Result)) and AllNumbers do
    begin
      AllNumbers := AllNumbers and (Result[i] in NumberSet);
      Inc(i);
    end;  { while }
  end;  { if... }
end;  { TWPBuf.GetNextWord }

procedure TWPBuf.UpdateBuffer;
  {-updates the buffer from the parent component, if any}
begin
  {do nothing}
end;  { TWPBuf.UpdateBuffer }

procedure TWPBuf.ReplaceWord (WithWord: string);
  {-replaces the current word with the word provided}
begin
  with Parent as TWPCustomRtfEdit do
    SelText := WithWord;
    {Spell_ReplaceWord (WithWord);}  {this should've work but didn't}
                                     {bug in WPTools?}
  WeModified := TRUE;
end;  { TWPBuf.ReplaceWord }

end.  { WPBuff }
