(* TXBUFF.PAS - Copyright (c) 1995-1996, Eminent Domain Software *)

unit TXBuff;
  {-TXTextControl buffer manager for EDSSpell component}
interface
uses
  Classes, Controls, Graphics, SysUtils, Forms, StdCtrls, Dialogs,
  WinProcs, WinTypes, VBXCtrl, BIVBX, Tx4vb,
{$IFDEF Win32}
  {$IFDEF Ver100}
  LexDCTD3,
  {$ELSE}
  LexDCT32,
  {$ENDIF}
{$ELSE}
  LexDCT,
{$ENDIF}
  AbsBuff, MemoUtil, SpellGbl;

(* For version 5.0 of the TX-Text Control, it was necessary to add a *)
(* carraige return counter for the highlighighting of the word.  If  *)
(* you are using version 5.0 then you must enable the $Define for    *)
(* TXText5 by removing the period below.                             *)

{.$DEFINE TXText5}

type
  TTXTextBuf = class (TPCharBuffer)  {TX Text-Control Editor Buffer Manager}
    private
      { Private declarations }
      FCRCount: integer;
        {-counter for carraige returns within TX-Text Control}
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
      procedure   UpdateBuffer;  override;
        {-updates the buffer from the parent component, if any}
      procedure   ReplaceWord (WithWord: string);  override;
        {-replaces the current word with the word provided}
{$IFDEF TXText5}
      function    GetNextWord: string;  override;
        {-returns the next word in the buffer}
      property CRCount: integer read FCRCount write FCRCount;
{$ENDIF}
  end;  { TTXTextBuf }

implementation

{TX Text-Control Editor Buffer Manager}
constructor TTXTextBuf.Create (AParent: TControl);
begin
  inherited Create (AParent);
{$IFDEF TXText5}
  CRCount := 0;     {!!ES 7/2797}
{$ENDIF}
end;  { TTXTextBuf.Create }

function TTXTextBuf.IsModified: Boolean;
  {-returns TRUE if parent had been modified}
begin
  {Result := TTextControl (Parent).Modified;}
  Result := TRUE;
end;  { TTXTextBuf.IsModified }

procedure TTXTextBuf.SetModified (NowModified: Boolean);
  {-sets parents modified flag}
begin
  {TTextControl (Parent).Modified := NowModified;}
end;  { TTXTextBuf.SetModified }

{$IFDEF TXText5}
(* The following code was essentially copied from AbsBuff.PAS             *)
(* Changes that were made are identified with the {!!ES} identifier       *)
function TTXTextBuf.GetNextWord: string;
  {-returns the next word in the buffer}
var
  S: string;  {string being constructed}
  InHTML: Boolean;  {TRUE if '<' has been encountered}
  Ch: Char;
begin
  BeginPos := CurPos;
  EndPos   := CurPos;
  S        := '';
  InHTML   := FALSE;
  AllNumbers := TRUE;    {!!ES 7/27/97}
  {find the first letter of the next word}
  while (not (Char (PCurPos^) in ValidChars)) and
        (CurPos<BufSize) or InHTML do
  begin
    if SupportHTML then
    begin
      Ch := PCurPos^;
      if InHTML and (Ch = '>') then InHTML := FALSE
      else
      if Ch = '<' then InHTML := TRUE;
    end;  { if... }
    Inc (CurPos, 1);
    PCurPos := @Buffer^[CurPos];
  end; {  while }
  if CurPos<BufSize then
  begin
    BeginPos := CurPos;
    {goto the end of the word}
    while ((Char (PCurPos^) in ValidChars) and
           (CurPos<BufSize)) do
    begin
      S := ConCat (S, Char (PCurPos^));
      Inc (CurPos, 1);
      if AllNumbers and (not (Char (PCurPos^) in NumberSet)) then
        AllNumbers := FALSE;     {!!ES 7/27/97}
      PCurPos := @Buffer^[CurPos];
      EndPos := CurPos;
      if EndPos - BeginPos = MaxWordLength then
      begin
        MessageDlg ('Aborting spell check (Invalid word): ' + #13 + S, mtError,
                    [mbOk], 0);
        S := '';
        Break;
      end;  { if... }
    end;  { while }
    if Char (PCurPos^) = #13 then   {!!ES 7/2797}
      CRCount := CRCount + 1;
    Result := S;
  end {:} else
    Result := '';
end;  { TTXTextBuf.GetNextword }
{$ENDIF}

function TTXTextBuf.GetYPos: integer;
  {-gets the current y location of the highlighted word (absolute screen)}
begin
  Result := 0;
end;  { TTXTextBuf.GetYPos }

procedure TTXTextBuf.SetSelectedText;
  {-highlights the current word using FBeginPos & FEndPos}
begin
  with Parent as TTextControl do
  begin
    SelStart  := BeginPos - 1;
{$IFDEF TXText5}
    SelStart  := SelStart - CRCount;    {!!ES 7/2797}
{$ENDIF}
    SelLength := EndPos - BeginPos;
    Update;
  end;  { with }
end;  { TTXTextBuf.SetSelectedText }

procedure TTXTextBuf.UpdateBuffer;
  {-updates the buffer from the parent component, if any}
begin
  BufSize := TTextControl (Parent).GetTextLen + 1;
  TTextControl (Parent).GetTextBuf (pChar(Buffer), BufSize);
  {support international characters}
  AnsiToOemBuff (pChar (Buffer), pChar (Buffer), BufSize);
  PCurPos := @Buffer^[CurPos];
end;  { TTXTextBuf.UpdateBuffer }

procedure TTXTextBuf.ReplaceWord (WithWord: string);
  {-replaces the current word with the word provided}
begin
  with Parent as TTextControl do
  begin
    CurPos   := CurPos - (EndPos - BeginPos);
    SelText  := WithWord;
    CurPos   := CurPos + SelLength;
    UpdateBuffer;
  end;  { with }
end;  { TTXTextBuf.ReplaceWord }

end.  { TXBuff }
