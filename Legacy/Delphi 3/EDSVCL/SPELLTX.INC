(* SPELLTX.INC - Copyright (c) 1995-1996, Eminent Domain Software *)

uses
  Forms, Dialogs, Controls, StdCtrls, Classes,
  TXBuff, Tx4vb,
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
  TTXSpellDlg = class (TSpellDlg)
    function    SpellCheck (AControl: TControl): Integer;  override;
      {-checks a TXTextControl}
    function    CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;  override;
      {-checks all of the edit fields on the form}
    procedure   WordCount (AControl: TControl;
                           var NumWords, UniqueWords: Longint);  override;
      {-returns the number of words in a TX Text-Control}
  end;  { TTXSpellDlg }

procedure Register;
  {-register the component}

implementation

function TTXSpellDlg.SpellCheck (AControl: TControl): Integer;
  {-checks a TXTextControl}
var
  TXBuf:       TTXTextBuf;   {buffer manager for text control}
  sSelStart:   Longint;      {saves the current attributes of Memo}
  sSelLength:  Longint;      { '' }
  sHideSel:    Boolean;      { '' }
begin
  if AControl is TTextControl then
  begin
    with AControl as TTextControl do
    begin
      sSelStart   := SelStart;
      sSelLength  := SelLength;
      sHideSel := HideSelection;
      HideSelection := FALSE;
      TXBuf  := TTXTextBuf.Create (AControl as TTextControl);
      Result := CheckBuffer (TXBuf);
      TXBuf.Free;
      SelStart      := sSelStart;
      SelLength     := sSelLength;
      HideSelection := sHideSel;
    end;  { with }
  end {:} else
    Result := inherited SpellCheck (AControl);
end;  { TTXSpellDlg.SpellCheck }

function TTXSpellDlg.CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;
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
       (AForm.Components[i] is TTextControl) then
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
end;  { TTXSpellDlg.CheckAllFields }

procedure TTXSpellDlg.WordCount (AControl: TControl;
                                 var NumWords, UniqueWords: Longint);
  {-returns the number of words in a TX Text-Control}
var
  TXBuf: TTXTextBuf;
begin
  if AControl is TTextControl then
  begin
    TXBuf := TTXTextBuf.Create (AControl as TTextControl);
    TXBuf.WordCount (NumWords, UniqueWords);
    TXBuf.Free;
  end {:} else
    inherited WordCount (AControl, NumWords, UniqueWords);
end;  { TTXSpellDlg.WordCount }

procedure Register;
  {-register the component}
begin
  RegisterComponents('Domain', [TTXSpellDlg]);
end;  { Register }
