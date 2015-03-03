(* SPELLUDC.INC - Copyright (c) 1995-1996, Eminent Domain Software *)

uses
  Forms, Dialogs, Controls, StdCtrls, Classes,
  {Udc_win,} Udc_mwps, UDCBuff,
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
  TUDCSpellDlg = class (TSpellDlg)
    function    SpellCheck (AControl: TControl): Integer;  override;
      {-checks a UDC Memo Component}
    function    CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;  override;
      {-checks all of the edit fields on the form}
    procedure   WordCount (AControl: TControl;
                           var NumWords, UniqueWords: Longint);  override;
      {-returns the number od words in a UDCMemo}
  end;  { TUDCSpellDlg }

procedure Register;
  {-register the component}

implementation

function TUDCSpellDlg.SpellCheck (AControl: TControl): Integer;
  {-checks a UDC Memo Component}
var
  UDCBuf:      TUDCBuf;      {buffer manager for UDCMemoWriter}
  sSelStart:   Longint;      {saves the current attributes of Memo}
  sSelLength:  Longint;      { '' }
begin
  if AControl is TUdcMWPStandard then
  begin
    with AControl as TUdcMWPStandard do
    begin
      sSelStart  := SelStart;
      sSelLength := SelLength;
      StartAtTop := TRUE;
      SpellingCheckMode;
      UDCBuf := TUDCBuf.Create (AControl as TUdcMWPStandard);
      Result := CheckBuffer (UDCBuf);
      UDCBuf.Free;
      SpellingCheckMode;
      SelStart  := sSelStart;
      SelLength := sSelLength;
    end;  { with }
  end {:} else
    Result := inherited SpellCheck (AControl);
end;  { TUDCSpellDlg.SpellCheck }

function TUDCSpellDlg.CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;
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
       (AForm.Components[i] is TUDCMWPStandard) then
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
end;  { TUDCSpellDlg.CheckAllFields }

procedure TUDCSpellDlg.WordCount (AControl: TControl;
                                  var NumWords, UniqueWords: Longint);
  {-returns the number of words in a UDCMemo}
var
  UDCBuf:  TUDCBuf;      {buffer manager for UDCMemo}
begin
  if AControl is TUdcMWPStandard then
  begin
    UDCBuf := TUDCBuf.Create (AControl as TUdcMWPStandard);
    UDCBuf.WordCount (NumWords, UniqueWords);
    UDCBuf.Free;
  end {:} else
    inherited WordCount (AControl, NumWords, UniqueWords);
end;  { TUDCSpellDlg.WordCount }

procedure Register;
  {-register the component}
begin
  RegisterComponents('Domain', [TUDCSpellDlg]);
end;  { Register }

