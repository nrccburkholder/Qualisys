(* SPELLLE.INC - Copyright (c) 1995-1996, Eminent Domain Software *)

uses
  SysUtils, Forms, Dialogs, Controls, StdCtrls, Classes, WinProcs,
  AbsBuff, LEBuff, 
{$IFDEF Win32}
  {$IFDEF VER100}
    Spell32, LEDlp32,
  {$ELSE}
   Spell32, LEDlp32,
  {$ENDIF}
{$ELSE}
  Spell16, LEDlp,
{$ENDIF}
  SpellGbl;

type
  TLEditSpellDlg = class (TSpellDlg)
    function SpellCheck (AControl: TControl): integer;  override;
    function CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;  override;
      {-checks all of the edit fields on the form}
    procedure WordCount (AControl: TControl;
                         var NumWords, UniqueWords: Longint);  override;
      {-returns the number of words in a TOvcCustomEditor}
  end;  { TLEditSpellDlg }

procedure Register;
  {-register the component}

implementation

function TLEditSpellDlg.SpellCheck (AControl: TControl): Integer;
  {-checks an LEdit editor component}
var
  LEditBuf:       TLEditBuffer;
  sStartPos:      Longint;
  sEndPos:        Longint;
  sStartLine:     Longint;
  sEndLine:       Longint;
begin
  if AControl is TLEdit then
  begin
    with TLEdit (AControl) do
    begin
      GetSelection;
      sStartPos  := StartPos;
      sEndPos    := EndPos;
      sStartLine := StartLine;
      sEndLine   := EndLine;
      StartPos   := 0;
      EndPos     := 0;
      StartLine  := 0;
      EndLine    := 0;
      SetScan;
      LEditBuf := TLEditBuffer.Create (AControl);
      Result := CheckBuffer (LEditBuf);
      LEditBuf.Free;
      {set all settings back}
      StartPos   := sStartPos;
      EndPos     := sEndPos;
      StartLine  := sStartLine;
      EndLine    := sEndLine;
      SetSelection;
    end;  { with }
  end;  { if... }
end;  { TLEditSpellDlg.SpellCheck }

function TLEditSpellDlg.CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;
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
       (AForm.Components[i] is TLEdit) then
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
end;  { TLEditSpellDlg.CheckAllFields }

procedure TLEditSpellDlg.WordCount (AControl: TControl;
                                  var NumWords, UniqueWords: Longint);
  {-returns the number of words in a TSpellOvcEditor}
var
  LEditBuf: TLEditBuffer;
begin
  if AControl is TLEdit then
  begin
    LEditBuf := TLEditBuffer.Create (AControl);
    LEditBuf.WordCount (NumWords, UniqueWords);
    LEditBuf.Free;
  end {:} else
    inherited WordCount (AControl, NumWords, UniqueWords);
end;  { TLEditSpellDlg.WordCount }

procedure Register;
  {-register the component}
begin
  RegisterComponents('Domain', [TLEditSpellDlg]);
end;  { Register }

