(* SPELLTE.INC - Copyright (c) 1995-1996, Eminent Domain Software and Bryan Cleland *)

uses
  SysUtils, Forms, Dialogs, Controls, StdCtrls, Classes, WinProcs,
  WinTypes, AbsBuff, TEBuff,
{$IFDEF Win32}
  {$IFDEF Win32}
    Spell32, Tvb32{?},
  {$ELSE}
    Spell32, Tvb32{?},
  {$ENDIF}
{$ELSE}
  Spell16, Tvb,
{$ENDIF}
  SpellGbl;

{$I c:\ter\delphi\ter.pas TER constant and type declaration}

type
  TTESpellDlg = class (TSpellDlg)
    function SpellCheck (AControl: TControl): integer;  override;
    function CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;  override;
      {-checks all of the edit fields on the form}
    procedure WordCount (AControl: TControl;
                         var NumWords, UniqueWords: Longint);  override;
      {-returns the number of words in a TOvcCustomEditor}
  end;  { TTESpellDlg }

procedure Register;
  {-register the component}

implementation

{$I c:\ter\delphi\ter_prot.pas TER function declaration}

function TTESpellDlg.SpellCheck (AControl: TControl): Integer;
  {-checks an TEdit editor component}
var
  TerFields:     StrTerField;
  TEBuf:          TTEBuf;
  sCurLine:       Longint;
  sCurCol:        integer;
  sStartPos:      integer;
  sEndPos:        integer;
  sStartLine:     Longint;
  sEndLine:       Longint;
begin
  if AControl is TTer then
  begin
    with TTer (AControl) do
    begin
      GetTerFields((AControl as TTer).Handle, TerFields);
      sCurLine   := TerFields.CurLine;
      sCurCol    := TerFields.CurCol;
      sStartPos  := TerFields.HilightBegCol;
      sEndPos    := TerFields.HilightEndCol;
      sStartLine := TerFields.HilightBegRow;
      sEndLine   := TerFields.HilightEndRow;
      TEBuf := TTEBuf.Create (AControl);
      Result := CheckBuffer (TEBuf);
      TEBuf.Free;
      {set all settings back}
      SelectTerText((AControl as TTer).Handle,sStartLine,sStartPos,sEndLine,sEndPos,False);
      SetTerCursorPos((AControl as TTer).Handle,sCurLine,sCurCol,True);
    end;  { with }
  end;  { if... }
end;  { TTESpellDlg.SpellCheck }

function TTESpellDlg.CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;
  {-checks all of the edit fields on the form}
var
  SpellResult:   integer;
  NoErrors:      Boolean;
  MessageSt:     string;
  i:             integer;
begin
  {find the form's spell dialog}
  SpellResult := mrNone;
  NoErrors := TRUE;
  Open;
  CloseWin := FALSE;
  for i := 0 to AForm.ComponentCount - 1 do
  begin
    if (AForm.Components[i] is TCustomEdit) or
       (AForm.Components[i] is TTer) then
      SpellResult := SpellCheck (AForm.Components[i] as TControl);
    if SpellResult = mrCancel then
      Break
    else
    if SpellResult = mrOk then
      NoErrors := FALSE;
  end; { next i }
  Close;
  if (SpellResult = mrNone) and (not NoErrors) then
    SpellResult := mrOk;
  if DisplayMsg then
  begin
    case SpellResult of
      mrNone:   MessageSt := NoErrorsMesg[LabelLanguage];
      mrCancel: MessageSt := ''{AbortedMesg[LabelLanguage]};
      mrOk:     MessageSt := CompleteMesg[LabelLanguage];
    end;  { case }
    if MessageSt <> '' then
      MessageDlg (MessageSt, mtInformation, [mbOk], 0);
  end;  { if... }
  if SpellWin.Visible then SpellWin.Hide;
  CloseWin := TRUE;
  Result := SpellResult;
end;  { TTESpellDlg.CheckAllFields }

procedure TTESpellDlg.WordCount (AControl: TControl;
                                 var NumWords, UniqueWords: Longint);
  {-returns the number of words in a TSpellOvcEditor}
var
  TEditBuf: TTEBuf;
begin
  if AControl is TTer then
  begin
    TEditBuf := TTEBuf.Create (AControl);
    TEditBuf.WordCount (NumWords, UniqueWords);
    TEditBuf.Free;
  end {:} else
    inherited WordCount (AControl, NumWords, UniqueWords);
end;  { TTESpellDlg.WordCount }

procedure Register;
  {-register the component}
begin
  RegisterComponents('Domain', [TTESpellDlg]);
end;  { Register }

