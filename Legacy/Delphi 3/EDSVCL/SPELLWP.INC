(* SPELLWP.INC - Copyright (c) 1995-1996, Eminent Domain Software *)

uses
  Classes, Forms, Controls, StdCtrls, Dialogs,
  WPRich, WPBuff, WPWinCtr,
{$IFDEF Win32}
  {$IFDEF VER100}
    Spell32,
  {$ELSE}
    Spell32,
  {$ENDIF}
{$ELSE}
  Spell16,
{$ENDIF}
  SpellGbl;

type
  TWPSpellDlg = class (TSpellDlg)
    function    SpellCheck (AControl: TControl): Integer;  override;
      {-checks a WPTools RTF Component}
    function    CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer; override;
      {-checks all of the edit fields on the form}
    procedure   WordCount (AControl: TControl;
                           var NumWords, UniqueWords: Longint);  override;
      {-returns the number od words in a TX Text-Control}
  end;  { TWPSpellDlg }

procedure Register;

implementation

function TWPSpellDlg.SpellCheck (AControl: TControl): Integer;
  {-checks a WPTools RTF Component}
var
  WPBuf:       TWPBuf;      {buffer manager for WpTools}
  sSelStart:   Longint;      {saves the current attributes of Memo}
  sSelLength:  Longint;      { '' }
begin
  if AControl is TWPCustomRtfEdit then
  begin
    with AControl as TWPCustomRtfEdit do
    begin
      sSelStart   := SelStart;
      sSelLength  := SelLength;
      Spell_FromStart;
      WPBuf  := TWPBuf.Create (AControl as TWPCustomRtfEdit);
      Result := CheckBuffer (WPBuf);
      WPBuf.Free;
      SelStart  := sSelStart;
      SelLength := sSelLength;
    end;  { with }
  end {:} else
    Result := inherited SpellCheck (AControl);
end;  { TWPSpellDlg.SpellCheck }

function TWPSpellDlg.CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;
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
       (AForm.Components[i] is TWPCustomRtfEdit) then
      SpellResult :=  SpellCheck (AForm.Components[i] as TControl);
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
end;  { TWPSpellDlg.CheckAllFields }

procedure TWPSpellDlg.WordCount (AControl : TControl;
                                 var NumWords, UniqueWords: Longint);
  {-returns the number od words in a TX Text-Control}
var
  WPBuf: TWPBuf;      {buffer manager for WpTools}
begin
  if AControl is TWPCustomRtfEdit then
  begin
    WPBuf := TWPBuf.Create (AControl as TWPCustomRtfEdit);
    WPBuf.WordCount (NumWords, UniqueWords);
    WPBuf.Free;
  end {:} else
    WordCount (AControl, NumWords, UniqueWords);
end;  { TWPSpellDlg.WordCount }

procedure Register;
  {-register the component}
begin
  RegisterComponents('Domain', [TWPSpellDlg]);
end;  { Register }

