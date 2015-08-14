(* SPELLOVC.INC - Copyright (c) 1995-1996, Eminent Domain Software *)

uses
  Forms, Dialogs, Controls, StdCtrls, ExtCtrls, TabNotBk, Classes, WinProcs,
  AbsBuff, OvcEdit, OvcEF, OvcNbk, OvcBuff,
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
  TOvcSpellDlg = class (TSpellDlg)
    procedure BringControlToFront (AControl: TWinControl);  override;
      {-insures control is visible (in case on notebook page)}
    function SpellCheck (AControl: TControl): integer;  override;
    function CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;  override;
      {-checks all of the edit fields on the form}
    procedure WordCount (AControl: TControl;
                         var NumWords, UniqueWords: Longint);  override;
      {-returns the number of words in a TOvcCustomEditor}
  end;  { TOvcSpellDlg }

procedure Register;
  {-register the component}

implementation

procedure TOvcSpellDlg.BringControlToFront (AControl: TWinControl);
  {-insures control is visible (in case on notebook page)}
var
  FControl: TWinControl;
  AParent:  TWinControl;
  AntiHang: integer;  {makes sure no hang in repeat until loop}
begin
  {inherited BringControlToFront (AControl);}  {rewritten here to include TOvcNoteBook}
  FControl := AControl;
  AntiHang := 0;
  repeat
    AParent := FControl.Parent;
    if AParent is TTabPage then
      TTabbedNotebook (TTabPage (AParent).Parent).ActivePage := TTabPage (AParent).Caption
    else
    if AParent is TPage then
      TNoteBook (TPage (AParent).Parent).ActivePage := TPage (AParent).Caption
    else
    if AParent is TOvcNotebookPage then
      TOvcNoteBook (TOvcNotebookPage (AParent).Parent).ActivePageName :=
        TOvcNotebookPage (AParent).Caption;
    FControl := AParent;
    Inc (AntiHang);
  until (FControl = nil) or
        (IsWindowVisible (FControl.Handle)) or
        (AParent is TForm) and
        (AntiHang >= 999);
end;  { TOvcSpellDlg.BringControlToFront }

function TOvcSpellDlg.SpellCheck (AControl: TControl): Integer;
  {-checks an Orpheus editor component}
var
  OvcBuf:         TPCharBuffer;
  sLine1, sLine2: Longint;
  sCol1, sCol2:   Integer;
  cLine:          Longint;
  cCol:           Integer;
  sCursorPos:     Integer;
  sSelStart:      Integer;
  sSelLength:     Integer;
  sHideSel:       Boolean;
begin
  if AControl is TOvcCustomEditor then
  begin
    with TSpellOvcEditor (AControl) do
    begin
      sHideSel := HideSelection;   {save hide selection setting}
      HideSelection := FALSE;
      cLine := GetCaretPosition (cCol);  {save caret pos}
      GetSelection (sLine1, sCol1, sLine2, sCol2); {save select info}
      OvcBuf := TOrpheusEditor.Create (TSpellOvcEditor (AControl));
      Result := CheckBuffer (OvcBuf);
      OvcBuf.Free;
      {set all settings back}
      SetSelection (sLine1, sCol1, sLine2, sCol2, FALSE);
      SetCaretPosition (cLine, cCol);
      HideSelection := sHideSel;
    end;  { with }
  end {:} else
  if AControl is TOvcBaseEntryField then
  begin
    with AControl as TOvcBaseEntryField do
    begin
      sSelStart  := SelectionStart;
      sSelLength := SelectionLength;
      sCursorPos := CurrentPos;
      OvcBuf := TOrpheusField.Create (AControl);
      Result := CheckBuffer (OvcBuf);
      OvcBuf.Free;
      SelectionStart   := sSelStart;
      SelectionLength  := sSelLength;
      CurrentPos       := sCursorPos;
    end;  { with }
  end {:} else
    Result := inherited SpellCheck (AControl);
end;  { TOvcSpellDlg.SpellCheck }

function TOvcSpellDlg.CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;
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
       (AForm.Components[i] is TOvcCustomEditor) or
       (AForm.Components[i] is TOvcBaseEntryField) then
      SpellResult :=  SpellCheck (TOvcBaseEntryField (AForm.Components[i] as TControl));
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
end;  { TForm1.CheckAllFields }

procedure TOvcSpellDlg.WordCount (AControl: TControl;
                                  var NumWords, UniqueWords: Longint);
  {-returns the number of words in a TSpellOvcEditor}
var
  OvcEditBuf: TPCharBuffer;
begin
  if AControl is TOvcCustomEditor then
  begin
    OvcEditBuf := TOrpheusEditor.Create (AControl);
    OvcEditBuf.WordCount (NumWords, UniqueWords);
    OvcEditBuf.Free;
  end {:} else
  if AControl is TOvcBaseEntryField then
  begin
    OvcEditBuf := TOrpheusField.Create (AControl);
    OvcEditBuf.WordCount (NumWords, UniqueWords);
    OvcEditBuf.Free;
  end {:} else
    inherited WordCount (AControl, NumWords, UniqueWords);
end;  { TOvcSpellDlg.OvcEdit_WordCount }

procedure Register;
  {-register the component}
begin
  RegisterComponents('Domain', [TOvcSpellDlg]);
end;  { Register }

