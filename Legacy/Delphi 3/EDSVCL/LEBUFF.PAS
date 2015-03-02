(* LEBUFF.PAS - Copyright (c) 1995-1996, Eminent Domain Software *)

unit LEBuff;
  {-LEdit buffer manager for EDSSpell component}
interface
uses
  Classes, Controls, Graphics, SysUtils, Forms, StdCtrls,
  WinProcs, WinTypes,
{$IFDEF Win32}
  LeDlp32,
{$ELSE}
  LeDlp,
{$ENDIF}
  AbsBuff, MemoUtil, SpellGbl;

{Note: To support all the neat syntax highlighting available in LEdit,  }
{      we decided to get each line of the LEdit component and spell     }
{      check each line.  This also lowers the overhead of the spell     }
{      checker from 65535 bytes of memory down to a sphelt 8k of memory }

type
  TLEditBuffer = class (TPCharBuffer)    {LEdit Buffer Manager}
    private                              {any descendant of TLEdit}
      { Private declarations }
      FNumLine: Longint;                 {current line number}
    protected
      { Protected declarations }
    public
      { Public declarations }
      constructor Create (AParent: TControl);  override;

      function    GetTextBufferSize: integer;  override;
        {-returns the maximum size of the buffer}
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
      function    InheritedGetNextWord: String;
        {-special inherited GetNextWord call for XSpell}
      procedure   UpdateBuffer;  override;
        {-updates the buffer from the parent component, if any}
      procedure   ReplaceWord (WithWord: string);  override;
        {-replaces the current word with the word provided}
      property    NumLine: Longint read FNumLine write FNumLine;
        {-current line number we're workin' on}
  end;  { TLEditBuffer }

implementation

{LEdit Buffer Manager}
constructor TLEditBuffer.Create (AParent: TControl);
begin
  FNumLine := 1;
  inherited Create (AParent);
end;  { TOrpheusEditor.Create }

function TLEditBuffer.GetTextBufferSize: integer;
  {-returns the maximum size of the buffer}
begin
  Result := 8 * 1024;  {8K}
end;  { TLEditBuffer.GetTextBufferSize }

function TLEditBuffer.IsModified: Boolean;
  {-returns TRUE if parent had been modified}
begin
  Result := TLEdit (Parent).Modified;
end;  { TLEditBuffer.IsModified }

procedure TLEditBuffer.SetModified (NowModified: Boolean);
  {-sets parents modified flag}
begin
  TLEdit (Parent).Modified := NowModified;
end;  { TLEditBuffer.SetModified }

function TLEditBuffer.GetYPos: integer;
  {-gets the current y location of the highlighted word (absolute screen)}
begin
  (* not supported with LEdit *)
  Result := 0;
end;  { TLEditBuffer.GetYPos }

procedure TLEditBuffer.SetSelectedText;
  {-highlights the current word using FBeginPos & FEndPos}
begin
  TLEdit (Parent).StartLine  := NumLine;
  TLEdit (Parent).EndLine    := NumLine;
  TLEdit (Parent).StartPos   := BeginPos - 1;
  TLEdit (Parent).EndPos     := EndPos - 1;
  TLEdit (Parent).SetSelection;
end;  { TLEditBuffer.SetSelectedText }

function TLEditBuffer.GetNextWord: string;
  {-returns the next word in the buffer}
var
  St: String;
  CurLine: Longint;
begin
  St := inherited GetNextWord;
  while St = '' do
  begin
    with TLEdit (Parent) do
    begin
      CurLine := LineCount;
      if NumLine < CurLine then
      begin  {get the next line}
        inc (FNumLine);
        InitParms;
        UpdateBuffer;
        St := inherited GetNextWord;
      end {:} else
        Break;
    end;  { with }
  end;  { while }
  Result := St;
end;  { TLEditBuffer.GetNextWord }

function TLEditBuffer.InheritedGetNextWord: String;
  {-special GetNextWord call for XSpell}
begin
  Result := inherited GetNextWord;
end;  { TLEditBuffer.InheritedGetNextWord }

procedure TLEditBuffer.UpdateBuffer;
  {-updates the buffer from the parent component, if any}
begin
  with TLEdit (Parent) do
    BufSize := GetLine (@Buffer^[1], NumLine);
  if BufSize > 0 then
  begin
    Buffer^[BufSize + 1] := #0;
    BufSize := BufSize + 1;
  end;  { if... }
end;  { TLEditBuffer.UpdateBuffer }

procedure TLEditBuffer.ReplaceWord (WithWord: string);
  {-replaces the current word with the word provided}
begin
  with TLEdit (Parent) do
    InsertStr (WithWord);
end;  { TLEditBuffer.ReplaceWord }

end.  { OvcBuff }
