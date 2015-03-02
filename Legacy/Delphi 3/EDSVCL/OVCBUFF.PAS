(* OVCBUFF.PAS - Copyright (c) 1995-1996, Eminent Domain Software *)

unit OvcBuff;
  {-Orpheus buffer manager for EDSSpell component}
interface
uses
  Classes, Controls, Graphics, SysUtils, Forms, StdCtrls,
  WinProcs, WinTypes,
  OvcEdit, OvcEF,
  AbsBuff, MemoUtil, SpellGbl;

type
  TSpellOvcEditor = class (TOvcEditor);

  TOrpheusEditor = class (TPCharBuffer)  {Orpheus Editor Buffer Manager}
    private                              {any descendant of TSpellOvcEditor}
      { Private declarations }
      FPara:       Longint;              {current paragraph}
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
      function    InheritedGetNextWord: String;
        {-special GetNextWord call for XSpell}
      procedure   UpdateBuffer;  override;
        {-updates the buffer from the parent component, if any}
      procedure   ReplaceWord (WithWord: string);  override;
        {-replaces the current word with the word provided}

      property    CurPara: Longint     read  FPara
                                       write FPara;
  end;  { TOrpheusEditor }

  TOrpheusField = class (TPCharBuffer)  {Orpheus Field Buffer Manager}
    private                             {any descendant of TOvcBaseEntryField}
      { Private declarations }
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
        {-highlights the current word using FBeginPos & FEndPos}
      procedure   UpdateBuffer;  override;
        {-updates the buffer from the parent component, if any}
      procedure   ReplaceWord (WithWord: string);  override;
        {-replaces the current word with the word provided}
  end;  { TOrpheusEditor }

implementation

{Orpheus Editor Buffer Manager}
constructor TOrpheusEditor.Create (AParent: TControl);
begin
  FPara := 1;
  inherited Create (AParent);
end;  { TOrpheusEditor.Create }

function TOrpheusEditor.IsModified: Boolean;
  {-returns TRUE if parent had been modified}
begin
  Result := TSpellOvcEditor (Parent).Modified;
end;  { TOrpheusEditor.IsModified }

procedure TOrpheusEditor.SetModified (NowModified: Boolean);
  {-sets parents modified flag}
begin
  TSpellOvcEditor (Parent).Modified := NowModified;
end;  { TOrpheusEditor.SetModified }

function TOrpheusEditor.GetYPos: integer;
  {-gets the current y location of the highlighted word (absolute screen)}
var
  Line:       Longint;
  Column:     Integer;
  AbsXY:      TPoint;
  FontHeight: Integer;
begin
  with TSpellOvcEditor (Parent) do
  begin
    Line   := CurPara;   {set to current paragraph}
    Column := BeginPos;  {set to current position in buffer}
    ParaToLine (Line, Column);
    AbsXY  := ClientToScreen (Point (0, 0));
    FontHeight := Abs (Round (FixedFont.Font.Height * (FixedFont.Font.PixelsPerInch/72)));
    Result := AbsXY.Y + ((Line - TopLine) * FontHeight);
  end;  { with }
end;  { TOrpheusEditor.GetYPos }

procedure TOrpheusEditor.SetSelectedText;
  {-highlights the current word using FBeginPos & FEndPos}
var
  Line:    Longint;
  Column:  Integer;
begin
  Line   := CurPara;
  Column := BeginPos;
  with TSpellOvcEditor (Parent) do
  begin
    ParaToLine (Line, Column);
    SetSelection (Line, Column, Line,
                  Column + (EndPos - BeginPos), TRUE);
    ResetScrollBars (TRUE);
  end;  { with }
end;  { TOrpheusEditor.SetSelectedText }

function TOrpheusEditor.GetNextWord: string;
  {-returns the next word in the buffer}
var
  St: String;
begin
  St := inherited GetNextWord;
  while (St = '') and (CurPara < TSpellOvcEditor (Parent).ParaCount) do
  begin
    CurPara := CurPara + 1;
    InitParms;
    UpdateBuffer;
    St := inherited GetNextWord;
  end;  { while }
  Result := St;
end;  { TOrpheusEditor.GetNextWord }

function TOrpheusEditor.InheritedGetNextWord: String;
  {-special GetNextWord call for XSpell}
begin
  Result := inherited GetNextWord;
end;  { TOrpheusEditor.InheritedGetNextWord }

procedure TOrpheusEditor.UpdateBuffer;
  {-updates the buffer from the parent component, if any}
var
  ParaSize: Word;
  ParaPtr:  PChar;
begin
  ParaPtr := TSpellOvcEditor (Parent).GetPara (CurPara, ParaSize);
  BufSize := ParaSize + 1;
  StrCopy (pChar (Buffer), ParaPtr);
  {support international characters}
  AnsiToOemBuff (pChar (Buffer), pChar (Buffer), BufSize);
  PCurPos := @Buffer^[CurPos];
end;  { TOrpheusEditor.UpdateBuffer }

procedure TOrpheusEditor.ReplaceWord (WithWord: string);
  {-replaces the current word with the word provided}
begin
  CurPos   := CurPos - (EndPos - BeginPos) + Length (WithWord);
  WithWord := WithWord + #0;
  TSpellOvcEditor (Parent).Insert (@WithWord[1]);
  UpdateBuffer;
end;  { TOrpheusEditor.ReplaceWord }

{Orpheus Field Buffer Manager}
constructor TOrpheusField.Create (AParent: TControl);
begin
  inherited Create (AParent);
end;  { TOrpheusField.Create }

function TOrpheusField.IsModified: Boolean;
  {-returns TRUE if parent had been modified}
begin
  Result := TOvcBaseEntryField (Parent).Modified;
end;  { TOrpheusField.IsModified }

procedure TOrpheusField.SetModified (NowModified: Boolean);
  {-sets parents modified flag}
begin
  TOvcBaseEntryField (Parent).Modified := NowModified;
end;  { TOrpheusField.SetModified }

function TOrpheusField.GetYPos: integer;
  {-gets the current y location of the highlighted word (absolute screen)}
var
  AbsXY: TPoint;
begin
  with TOvcBaseEntryField (Parent) do
  begin
    AbsXY  := ClientToScreen (Point (0, 0));
    Result := AbsXY.Y;
  end;  { with }
end;  { TOrpheusField.GetYPos }

procedure TOrpheusField.SetSelectedText;
  {-highlights the current word using FBeginPos & FEndPos}
begin
  TOvcBaseEntryField (Parent).SetSelection (BeginPos, EndPos);
end;  { TOrpheusField.SetSelectedText }

procedure TOrpheusField.UpdateBuffer;
  {-updates the buffer from the parent component, if any}
var
  FieldSt:   String;
begin
  FieldSt := TOvcBaseEntryField (Parent).AsString;
  BufSize := Length (FieldSt) + 1;
  Move (FieldSt[1], Buffer^, BufSize);
  Buffer^[BufSize] := #0;
  {support international characters}
  AnsiToOemBuff (pChar (Buffer), pChar (Buffer), BufSize);
  PCurPos := @Buffer^[CurPos];
end;  { TOrpheusField.UpdateBuffer }

procedure TOrpheusField.ReplaceWord (WithWord: string);
  {-replaces the current word with the word provided}
var
  FieldSt: String;
begin
  with TOvcBaseEntryField (Parent) do
  begin
    CurPos   := CurPos - (EndPos - BeginPos);
    FieldSt  := AsString;
    Delete (FieldSt, CurPos, (EndPos - BeginPos));
    Insert (WithWord, FieldSt, CurPos);
    CurPos   := CurPos + Length (WithWord);
    AsString := FieldSt;
    UpdateBuffer;
  end;  { with }
end;  { TOrpheusField.ReplaceWord }

end.  { OvcBuff }
