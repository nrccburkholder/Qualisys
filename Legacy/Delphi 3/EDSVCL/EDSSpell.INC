(* EDSSPELL.INC - Copyright (c) 1995-1996, Eminent Domain Software *)

{$D-}
{$L-}
{$I SpellDef.PAS}
  {-defines for EDSSpell component}
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Menus, ExtCtrls,
  AbsBuff, AbsSpell, WPSpell, TabNotBk,
{$IFDEF Win32}
  {$IFDEF Ver100}
  LexDCTD3, LexLstD3,
  {$ELSE}
  LexDCT32, LexLst32,
  {$ENDIF}
  ComCtrls,
{$ELSE}
  LexDCT, LexLst,
{$ENDIF}
{$IFNDEF Shareware}
  MSSpell, W96Spell,
{$ENDIF}
  SpellGbl;

type
  {Dialog Component Wrapper}
  TSpellDlg = class (TComponent)
  private
    FPath:           TFileName;
    FDictionary:     TFileName;
    FExclude:        TFileName;
    FAutoCorrect:    TFileName;
    FDicType:        TLanguages;
    FLanguage:       TLanguages;
    FDialogType:     TDialogTypes;
    FSpellWin:       TAbsSpellDialog;
    FSuggestions:    Byte;
    FIcons:          TAccentSet;
    FAutoSuggest:    Boolean;
    FAutoShift:      Boolean;
    FHelpContext:    THelpContext;
    FConfirmAdd:     Boolean;
    FUserDCT:        TFileName;
    FCompletedMesg:  Boolean;
    FShowGlyphs:     Boolean;
    FFont:           TFont;
    FSupportHTML:    Boolean;
    FModal:          Boolean;
    {Lists of words}
    FSkipList:       TStringList;  {List of words to skip}
    FReplaceList:    TStringList;  {List of words to auto-replace}
    FReplacer:       TStringList;  {List of words to replace above list with}
    procedure   AddAutoCorrectList;
      {-loads auto correction list}
    procedure   SetDicType (NewType: TLanguages);
      {-sets the new dictionary type}
    procedure   SetExclusionList (TheList: TFileName);
      {-sets the name of the exclusion file}
    procedure   SetLanguage (NewLanguage: TLanguages);
      {-sets the language for the label}
    procedure   SetSuggestions (Num: Byte);
      {-sets the number of suggestions}
    procedure   SetIconSet (IconSet: TAccentSet);
      {-sets the icons to be visible}
    procedure   SetFont (Value: TFont);
      {-sets the font}
    procedure   SetHelpContext (HelpID: THelpContext);
      {-sets the help context for the spell component}
    procedure   SetSupportHTML (Value: Boolean);
      {-sets the appropriate character sets for HTML}
  public
    CloseWin:  Boolean;
    ModalPtr:  pointer;      {used to re-enable an apps windows (ForceModal}
    constructor Create (AOwner: TComponent); override;
      {-initializes object}
    destructor  Destroy;  override;
      {-destroys object}
    function    Open: Boolean;
      {-opens the dictionary}
    procedure   Close;
      {-closes the dictionary and removes the dialog}
    procedure   ClearLists;
      {-clears the SkipList, ReplaceList, and Replacer List}
    procedure   MoveDialog (YPos: Integer);
      {-moves the dialog so that it does not highlighted word}
    procedure   EnableSkipButtons;
      {-enables the skip buttons on the dialog}
    procedure   DisableSkipButtons;
      {-disables the skip buttons on the dialog}
    procedure   BringControlToFront (AControl: TWinControl);  dynamic;
      {-insures control is visible (in case on notebook page)}
    procedure   Show;
      {-displays the dialog}
    procedure   CloseSpellWin;
      {-closes the dialog (always use CloseSpellWin instead of FSpellWin.Close)) }
    procedure   ForceDialogTitle (ATitle: String);
      {-forces a different dialog title}
    procedure   UseScanTable (TableSize: integer; TablePtr: pointer);
      {-provides an alternate scan table for the spell checker}

    {-- Spell Checker ---}
    function    CheckBuffer (ABuffer: TAbsBuffer): Integer;
      {-checks the buffer}
    function    CheckWord (var AWord: String): Integer;
      {-checks the word (see AbsSpell for CheckWord results)}
    function    SpellCheck (AControl: TControl): Integer;  dynamic;
      {-checks a custom edit control}
    function    CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;  dynamic;
      {-checks all of the edit fields on the form}

    {---- Word Counter ----}
    procedure   WordCount (AControl: TControl;
                           var NumWords, UniqueWords: Longint);  dynamic;
      {-returns the number of words in a Control}

    {---- New AutoCorrect & AutoCheck ----}
    procedure   ShowBadword (AControl: TControl;
                             TheWord: String; Pos: integer);  dynamic;
      {-highlights a bad word}
    function    GetLastWordTyped (AControl: TControl;
                                  var Pos: integer): String;  dynamic;
      {-returns the string and position of the last word typed}
    procedure   AutoCheck (AControl: TControl; AutoCorrect: Boolean;
                           Key: Word; Shift: TShiftState);  dynamic;
      {-auto checks a bad word (should be tied to controls OnKeyUp event}

    procedure   SetDialogType (NewType: TDialogTypes);  virtual;
      {-sets the dailog type}

    {---- Internal Routines (No Dialog) ----}
    function    OpenDictionary: Boolean;
      {-opens the dictionary}
    procedure   AddDictionary (DCTFileName: TFileName);
      {-opens an additional dictionary}
    procedure   CloseDictionary;
      {-closes the dictionary}
    function    AddWord (AWord: string): Boolean;
      {-adds a word to the dictionary, returns TRUE if successful}
    function    InDictionary (AWord: String): Boolean;
      {-checks to see if the word is in the dictionary (no dialog)}
    function    SuggestWords (AWord: String; NumToList: Byte): TStringList;
      {-suggests words}
    {Lists of words}
    property SkipList:      TStringList read FSkipList write FSkipList;
    property ReplaceList:   TStringList read FReplaceList write FReplaceList;
    property Replacer:      TStringList read FReplacer write FReplacer;
    property SpellWin:      TAbsSpellDialog read FSpellWin write FSpellWin;
  published
    property AccentIcons:    TAccentSet read FIcons write SetIconSet;
    property AutoCorrectList:TFileName read FAutoCorrect write FAutoCorrect;
    property AutoShift:      Boolean read FAutoShift write FAutoShift;
    property AutoSuggest:    Boolean read FAutoSuggest write FAutoSuggest;
    property ConfirmAdd:     Boolean read FConfirmAdd write FConfirmAdd;
    property DialogStyle:    TDialogTypes read FDialogType write SetDialogType;
    property DictionaryName: TFileName read FDictionary write FDictionary;
    property DictionaryPath: TFileName read FPath write FPath;
    property DictionaryType: TLanguages read FDicType write SetDicType;
    property ExclusionList:  TFileName read FExclude write SetExclusionList;
    property Font:           TFont read FFont write SetFont;
    property ForceModal:     Boolean read FModal write FModal;
    property HelpContext:    THelpContext read FHelpContext write SetHelpContext;
    property LabelLanguage:  TLanguages read FLanguage write SetLanguage;
    property Suggestions:    Byte read FSuggestions write SetSuggestions;
    property ShowCompletedDialog: Boolean read FCompletedMesg write FCompletedMesg;
    property ShowGlyphs:     Boolean read FShowGlyphs write FShowGlyphs;
    property SupportHTML:    Boolean read FSupportHTML write SetSupportHTML;
    property UserDictionary: TFileName read FUserDCT write FUserDCT;
  end;  { TSpellDlg }

procedure Register;

implementation

{---- TSpellDlg.Wrapper ----}
constructor TSpellDlg.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  FSpellWin      := nil;
  {set up the default dialog font}
  FFont          := TFont.Create;
  FFont.Name     := 'MS Sans Serif';
  FFont.Style    := [fsBold];
  FFont.Size     := 8;
  FShowGlyphs    := TRUE;
  FDialogType    := dtWordPerfect;
  FIcons         := [];
  FAutoShift     := FALSE;
  FAutoSuggest   := TRUE;
  FCompletedMesg := TRUE;
  FDictionary    := '';
  FPath          := 'APPLICATIONPATH';
  FUserDCT       := UserDCTDef {'CUSTOM.DIC'};
  FAutoCorrect   := '';
  FDicType       := lgEnglish;
  FLanguage      := lgEnglish;
  FConfirmAdd    := TRUE;
  CloseWin       := TRUE;
  FSupportHTML   := FALSE;
  FModal         := FALSE;
  FExclude       := '';
  SetDialogType (FDialogType);
  ModalPtr       := nil;
  Suggestions    := 10;
  if not (csDesigning in ComponentState) then
  begin
    SkipList    := TStringList.Create;
    ReplaceList := TStringList.Create;
    Replacer    := TStringList.Create;
    SkipList.Duplicates := dupIgnore;
  end {:} else
  begin
    SkipList    := nil;
    ReplaceList := nil;
    Replacer    := nil;
  end;  { else }
end; { TSpellDlg.Create }

destructor TSpellDlg.Destroy;
begin
  FFont.Free;
  if SkipList <> nil then SkipList.Free;
  if Replacelist <> nil then ReplaceList.Free;
  if Replacer <> nil then Replacer.Free;
  CloseDictionary;
  CloseSpellWin;
  {FSpellWin is automatically destroyed by parent}
  {FSpellWin.Free implied}
  inherited Destroy;
end;  { TSpellDlg.Destroy }

procedure TSpellDlg.SetDicType (NewType: TLanguages);
  {-sets the new dictionary type}
begin
  FDicType := NewType;
{$IFDEF SupportSpanish}
  case FDicType of
    lgSpanish: Include (FIcons, acSpanish);
  end;  { case }
{$ENDIF}
end;  { TSpellDlg.SetDicType }

procedure TSpellDlg.SetLanguage (NewLanguage: TLanguages);
  {-sets the language for the label}
begin
  FLanguage := NewLanguage;
  if FSpellWin <> nil then
    FSpellWin.Language := FLanguage;
end;  { TSpellDlg.SetLanguage }

procedure TSpellDlg.SetDialogType (NewType: TDialogTypes);
  {-sets the dailog type}
begin
  if csDesigning in ComponentState then
  begin
{$IFDEF Shareware}
    if NewType in [dtMSWord, dtWordPro96] then
    begin
      MessageDlg ('MSWord and WordPro96 dialogs are not'+#13+
                  'supported in shareware version.', mtInformation,
                  [mbOk], 0);
    end {:} else
      FDialogType := NewType;
{$ELSE}
    FDialogType := NewType;
{$ENDIF}
  end {:} else
  begin
    if FSpellWin<>nil then
    begin
      FSpellWin.Free;
      FSpellWin := nil;
    end;  { if... }
    FDialogType := NewType;
    case FDialogType of
      dtWordPerfect: FSpellWin := TWPSpellDlg.Create (Owner);
{$IFNDEF Shareware}
      dtMSWord: FSpellWin := TMSSpellDlg.Create (Owner);
      dtWordPro96: FSpellWin := TW96SpellDlg.Create (Owner);
{$ENDIF}
    end;  { case }
    if not ShowGlyphs then
      FSpellWin.RemoveGlyphs;
    FSpellWin.Font.Assign (Font);
    FSpellWin.SetAccentSet (FIcons);
    FSpellWin.Suggestions := Suggestions;
  end;  { if... }
end;  { TSpellDlg.SetDialogType }

procedure TSpellDlg.SetSuggestions (Num: Byte);
begin
  if Num>255 then
  begin
    MessageDlg ('Maximum limit suggestions is 255.',
                mtInformation, [mbOk], 0);
    FSuggestions := 255;
  end {:} else
  if Num<1 then
  begin
    MessageDlg ('Invlid number of suggestions.',
                mtInformation, [mbOk], 0);
    FSuggestions := 1;
  end {:} else
    FSuggestions := Num;
  if FSpellWin <> nil then
    FSpellWin.Suggestions := FSuggestions;
end;  { TSpellDlg.SetSuggestions }

procedure TSpellDlg.SetIconSet (IconSet: TAccentSet);
begin
  FIcons := IconSet;
  if FSpellWin <> nil then
    FSpellWin.SetAccentSet (FIcons);
end;  { TSpellDlg.SetIconSet }

procedure TSpellDlg.SetExclusionList (TheList: TFileName);
begin
  FExclude := TheList;
  if DCT <> nil then
    DCT.OpenExclusionFile (FExclude);
end;  { TSpellDlg.SetExclusionList }

procedure TSpellDlg.SetFont (Value: TFont);
begin
  FFont.Assign (Value);
end;  { TSpellDlg.SetFont }

procedure TSpellDlg.SetHelpContext (HelpID: THelpContext);
  {-sets the help context for the spell component}
begin
  FHelpContext := HelpID;
  if FSpellWin<>nil then
    FSpellWin.HelpContext := FHelpContext;
end;  { TSpellDlg.SetHelpContext }

procedure TSpellDlg.SetSupportHTML (Value: Boolean);
  {-sets the appropriate character sets for HTML}
begin
  FSupportHTML := Value;
  {
  if FSupportHTML then
    ValidChars := ValidChars + ['<', '>']
  else
    ValidChars := ValidChars - ['<', '>'];
  }
end;  { TSpellDlg.SetSupportHTML }

function TSpellDlg.Open: Boolean;
  {-opens the dictionary and prepares dialog}
begin
  Result      := TRUE;    {assume success}
  if not OpenDictionary then
  begin
    MessageDlg ('Error opening dictionary '+ FPath + FDictionary,
                mtError, [mbOk], 0);
    Close;
    Result := FALSE;
  end;  { if... }
end;  { TSpellDlg.Open }

procedure TSpellDlg.Close;
  {-closes the dictionary and removes the dialog}
begin
  if FSpellWin <> nil then
    CloseSpellWin;
  CloseDictionary;
end;  { TSpellDlg.Close }

procedure TSpellDlg.ClearLists;
  {-clears the SkipList, ReplaceList, and Replacer List}
begin
  SkipList.Clear;
  ReplaceList.Clear;
  Replacer.Clear;
end;  { TSpellDlg.ClearLists }

procedure TSpellDlg.MoveDialog (YPos: integer);
  {-moves the dialog so that it does not highlighted word}
var
  CenterY: integer;
  OldTop: integer;
  MousePt: TPoint;
begin
  if YPos <> 0 then
  begin
    OldTop := FSpellWin.Top;
    CenterY := Screen.Height div 2;
    if YPos > CenterY
      then FSpellWin.Top := Margin
      else FSpellWin.Top := Screen.Height - FSpellWin.Height - Margin;
    if OldTop <> FSpellWin.Top then
    begin
      GetCursorPos (MousePt);
      MousePt.Y := MousePt.Y - (OldTop - FSpellWin.Top);
      SetCursorPos (MousePt.X, MousePt.Y);
    end;  { if... }
  end;  { if... }
end;  { TSpellDlg.MoveDialog }

procedure TSpellDlg.EnableSkipButtons;
  {-enables the skip buttons on the dialog}
begin
  if FSpellWin <> nil then
    FSpellWin.EnableSkipButtons;
end;  { TSpellDlg.EnableSkipButtons }

procedure TSpellDlg.DisableSkipButtons;
  {-disables the skip buttons on the dialog}
begin
  if FSpellWin <> nil then
    FSpellWin.DisableSkipButtons;
end;  { TSpellDlg.DisableSkipButtons }

procedure TSpellDlg.BringControlToFront (AControl: TWinControl);
  {-insures control is visible (in case on notebook page)}
var
  FControl: TWinControl;
  AParent:  TWinControl;
  AntiHang: integer;  {makes sure no hang in repeat until loop}
begin
  FControl := AControl;
  AntiHang := 0;
  repeat
    AParent := FControl.Parent;
    if AParent is TTabPage then
      TTabbedNotebook (TTabPage (AParent).Parent).ActivePage := TTabPage (AParent).Caption
    else
    if AParent is TPage then
      TNoteBook (TPage (AParent).Parent).ActivePage := TPage (AParent).Caption;
    FControl := AParent;
    Inc (AntiHang);
  until (FControl = nil) or
        (IsWindowVisible (FControl.Handle)) or
        (AParent is TForm) and
        (AntiHang >= 999);
end;  { TSpellDlg.BringControlToFront }

procedure TSpellDlg.Show;
  {-displays the dialog}
begin
  {Set up window}
  FSpellWin.Left := (Screen.Width div 2) - (FSpellWin.Width div 2);
  if AutoShift then MoveDialog (Margin);
  FSpellWin.Show;
  if not ShowGlyphs then
    FSpellWin.RemoveGlyphs;
  FSpellWin.Font.Assign (Font);
end;  { TSpellDlg.Show }

procedure TSpellDlg.CloseSpellWin;
begin
  if ModalPtr <> nil then
  begin
    EnableTaskWindows (ModalPtr);
    ModalPtr := nil;
  end;  { if... }
  try
    if (FSpellWin <> nil) and FSpellWin.Visible then
      FSpellWin.Close;
  except
  end;  { try }
end;  { TSpellDlg.CloseSpellWin }

procedure TSpellDlg.ForceDialogTitle (ATitle: String);
  {-forces a different dialog title}
begin
  if FSpellWin <> nil then
    FSpellWin.Caption := ATitle;
end;  { TSpellDlg.ForceDialogTitle }

procedure TSpellDlg.UseScanTable (TableSize: integer; TablePtr: pointer);
  {-provides an alternate scan table for the spell checker}
begin
  if DCT = nil then
    OpenDictionary;
  DCT.AssignScanTable (TableSize, TablePtr);
end;  { TSpellDlg.UseScanTable }

function TSpellDlg.CheckBuffer (ABuffer: TAbsBuffer): Integer;
  {-checks the buffer}
var
  WordSt:       TDCTStr;      {current word}
  MessageSt:    String[255];  {message string}
  NoErrors:     Boolean;      {TRUE if all words are spelled correctly}
  WinResult:    integer;      {Result from ShowModal call}
  WordChanged:  Boolean;      {TRUE if a word was changed on the memo}
  sModified:    Boolean;      {saves current Modified status of buffer}
  FReplaceNum:  integer;      {replace number in list}
begin
//  Result      := mrNone;
  WinResult   := mrNone;
  sModified   := ABuffer.Modified;
  ABuffer.Modified := FALSE;
  ABuffer.SupportHTML := SupportHTML;
  WordChanged := FALSE;
  if not Open then
  begin
    Result := mrCancel;
    Exit;
  end;  { if... }
  FSpellWin.HandleNeeded;
  if ForceModal and (ModalPtr = nil) then
    ModalPtr := DisableTaskWindows (FSpellWin.Handle);
  with ABuffer do
  begin
    {calculate the upper most bounds for the memo}
    {FSpellWin.}Show;  {!!!remove this line if you don't spell checker to automatically pop up}
    {assume entire document for now}
    FSpellWin.SpellDlgResult := mrNone;
    FSpellWin.ClearSuggestList;
    NoErrors := TRUE;
    repeat
      Application.ProcessMessages;
      Screen.Cursor := crHourGlass;
      if Modified then
      begin
        WordChanged := TRUE;
        UpdateBuffer;
        MoveBackOneWord;
      end;  { if... }
      WordSt := GetNextWord;
      if (Length (WordSt) > 1) and (not AllNumbers) and
         (not InDictionary (WordSt))  then
      begin
        FReplaceNum := ReplaceList.IndexOf (LowerCase (WordSt));
        if FReplaceNum <> (-1) then
        begin
          {word in replace list}
          SetSelectedText;
          ReplaceWord (Replacer[FReplaceNum]);
        end {:} else
        if SkipList.IndexOf (LowerCase (WordSt)) = (-1) then
        begin
          {word not in skip list}
          Screen.Cursor := crDefault;
          BringControlToFront (ABuffer.Parent as TWinControl);
          SetSelectedText;
          if not FSpellWin.Visible then
            Show;
          if AutoShift then MoveDialog (YPos);
          Application.ProcessMessages;
          FSpellWin.SetNotFoundPrompt (NotFoundPhrase[FLanguage]);
          FSpellWin.SetNotFoundCaption (Internationalize (WordSt));
          FSpellWin.SetEditWord (Internationalize (WordSt));
          Application.ProcessMessages;
          if FAutoSuggest then
            FSpellWin.MakeSuggestions;
          FSpellWin.SpellDlgResult := 0;
          FSpellWin.SetEditAsActive;
          repeat
            if Application.Active then FSpellWin.Show;
            Application.ProcessMessages;
          until (FSpellWin.SpellDlgResult <> 0) or (not FSpellWin.Visible);
          if not FSpellWin.Visible
            then WinResult := mrCancel
            else WinResult := FSpellWin.SpellDlgResult;
          case WinResult of
            mrReplace:
              begin
                WordChanged := TRUE;
                NoErrors := FALSE;
                WordSt := LowerCase (WordSt);
                if WordSt <> LowerCase (FSpellWin.GetEditWord) then
                begin
                  ReplaceWord (FSpellWin.GetEditWord);
                  FSpellWin.SetEditWord ('');
                end;  { if... }
              end;  { Replace }
            mrAdd:
              begin
                {Add to dictionary}
                {WordSt := FSpellWin.GetEditWord;}
                if not InDictionary (WordSt) then
                begin
                  WordSt := WordSt + #0;
                  WordSt := Copy (WordSt, 1, Length (WordSt) - 1);
                  OemToAnsi (@WordSt[1], @WordSt[1]);
                  MessageSt := Format (AddMesg[FLanguage], [WordSt]);
                  AnsiToOEM (@WordSt[1], @WordSt[1]);
                  if (not FConfirmAdd) or
                     (MessageDlg (MessageSt, mtConfirmation,
                                 [mbYes, mbNo], 0) = mrYes) then
                    DCT.AddWord (WordSt);
                end {:} else
                begin
                  {WordSt already in dictionary}
                  WordSt := WordSt + #0;
                  WordSt := Copy (WordSt, 1, Length (WordSt) - 1);
                  OemToAnsi (@WordSt[1], @WordSt[1]);
                  MessageSt := Format (AddedMesg[FLanguage], [WordSt]);
                  AnsiToOEM (@WordSt[1], @WordSt[1]);
                  MessageDlg (MessageSt, mtInformation, [mbOk], 0);
                end;  { else }
                FSpellWin.SetEditAsActive;
              end;  { Add }
            mrSkipOnce: {do nothing};
            mrSkipAll:
              begin
                {add word to skiplist}
                WordSt := LowerCase (WordSt);
                SkipList.Add (WordSt);
              end;  { SkipAll }
            mrReplaceAll:
              begin
                {add word to replacelist}
                WordChanged := TRUE;
                NoErrors := FALSE;
                WordSt := LowerCase (WordSt);
                if WordSt <> LowerCase (FSpellWin.GetEditWord) then
                begin
                  ReplaceList.Add (WordSt);  {the bad word}
                  Replacer.Add (FSpellWin.GetEditWord);
                  ReplaceWord (FSpellWin.GetEditWord);
                  FSpellWin.SetEditWord ('');
                end;  { if... }
              end;  { ReplaceAll }
            mrCancel:
              begin
                CloseSpellWin;
                WinResult := mrCancel;
                break;
              end;  { Cancel }
          end;  { case }
        end;  { if... }
        FSpellWin.ClearSuggestList;
      end {:} else
      begin
        if WordSt <> '' then
        begin
          FSpellWin.SetNotFoundPrompt (FoundPhrase[FLanguage]);
          FSpellWin.SetNotFoundCaption (Internationalize (WordSt));
          FSpellWin.SetEditWord (Internationalize (WordSt));
        end;  { if... }
        Application.ProcessMessages;
        if FSpellWin.SpellDlgResult = mrCancel then
        begin
          {I said stop!}
          CloseSpellWin;
          WinResult := mrCancel;
          Break;
        end;  { if... }
      end;  { else }
    until WordSt='';
    Screen.Cursor := crDefault;
    Modified := WordChanged or sModified;
    DCT.WriteAddedList;
  end;  { with }
  if WinResult=mrCancel then
  begin
    {remove cancel dialog}
    MessageSt := '';  {AbortedMesg[FLanguage];}
    Result    := mrCancel;
  end {:} else
  if NoErrors then
  begin
    MessageSt := NoErrorsMesg[FLanguage];
    Result    := mrNone;
  end {:} else
  begin
    MessageSt := CompleteMesg[FLanguage];
    Result    := mrOk;
  end;  { else }
  if CloseWin then
  begin
    if ShowCompletedDialog and (MessageSt <> '') then
      MessageDlg (MessageSt, mtInformation, [mbOk], 0);
    CloseSpellWin;
  end;  { if... }
end;  { TSpellDlg.CheckBuffer }

function TSpellDlg.CheckWord (var AWord: String): Integer;
  {-checks the word (see AbsSpell for CheckWord results)}
begin
  Result := mrNone;
  if not FSpellWin.Visible then
     Open ; {-open current dictionary}
  {Set up window}
  FSpellWin.Left := (Screen.Width div 2) - (FSpellWin.Width div 2);
  {FSpellWin.FormStyle := fsStayOnTop;}
  {if AutoShift then MoveDialog (AMemo);}
  FSpellWin.SetNotFoundCaption (AWord);
  FSpellWin.SetEditWord (AWord);
  if InDictionary (AWord) then
  begin
    FSpellWin.SetNotFoundPrompt (FoundPhrase[FLanguage]);
  end {:} else
  begin
    FSpellWin.SetNotFoundPrompt (NotFoundPhrase[FLanguage]);
    if FAutoSuggest then
      FSpellWin.MakeSuggestions;
    FSpellWin.SpellDlgResult := 0;
    repeat
      Show;
      Application.ProcessMessages;
    until (FSpellWin.SpellDlgResult <> 0) or (not FSpellWin.Visible);
    if not FSpellWin.Visible
      then Result := mrReplace
      else Result := FSpellWin.SpellDlgResult;
    if Result = mrReplace
      then AWord := FSpellWin.GetEditWord;
  end;  { else }
end;  { TSpellDlg.CheckWord }

function TSpellDlg.SpellCheck (AControl: TControl): Integer;
var
  CEBuf:       TCEBuffer;    {buffer manager for memo}
  sSelStart:   Longint;      {saves the current attributes of Memo}
  sSelLength:  Longint;      { '' }
  sHideSel:    Boolean;      { '' }
begin
  Result := mrNone;
  if AControl is TCustomEdit then
  begin
    with AControl as TCustomEdit do
    begin
      sSelStart   := SelStart;
      sSelLength  := SelLength;
      with TMemo (AControl) do     {force type-cast to overcome Delphi}
      begin                        {publishing the HideSelection property}
        sHideSel := HideSelection;
        HideSelection := FALSE;
      end;  { with }
      CEBuf  := TCEBuffer.Create (AControl);
      Result := CheckBuffer (CEBuf);
      CEBuf.Free;
      SelStart  := sSelStart;
      SelLength := sSelLength;
      TMemo (AControl).HideSelection := sHideSel;
    end;  { with }
  end {:} else
    MessageDlg ('Error : Unknown control.', mtError, [mbOk], 0);
end; { TSpellDlg.SpellCheck }

function TSpellDlg.CheckAllFields (AForm: TForm; DisplayMsg: Boolean): Integer;
  {-checks all of the edit fields on the form}
var
  SpellResult:   integer;
  NoErrors:      Boolean;
  MessageSt:     string;
  i:             integer;
begin
  SpellResult := mrNone;
  NoErrors := TRUE;
  Open;
  CloseWin := FALSE;
  for i := 0 to AForm.ComponentCount - 1 do
  begin
    if (AForm.Components[i] is TCustomEdit) then
      SpellResult :=  SpellCheck (AForm.Components[i] as TCustomEdit);
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
      mrNone:   MessageSt := NoErrorsMesg[FLanguage];
      mrCancel: MessageSt := ''{AbortedMesg[FLanguage]};
      mrOk:     MessageSt := CompleteMesg[FLanguage];
    end;  { case }
    if MessageSt <> '' then
      MessageDlg (MessageSt, mtInformation, [mbOk], 0);
  end;  { if... }
  if FSpellWin.Visible then
    CloseSpellWin;
  CloseWin := TRUE;
  Result := SpellResult;
end;  { TSpellDlg.CheckAllFields }

{---- Word Counters ----}
procedure TSpellDlg.WordCount (AControl: TControl; var NumWords, UniqueWords: Longint);
  {-returns the number of words in a Control}
var
  CEBuf: TCEBuffer;
begin
  if AControl is TCustomEdit then
  begin
    CEBuf := TCEBuffer.Create (AControl);
    if CEBuf <> nil then
    begin
      CEBuf.UpdateBuffer;
      CEBuf.WordCount (NumWords, UniqueWords);
      CEBuf.Free;
    end;  { if... }
  end;  { if... }
end;  { TSpellDlg.CustomEdit_WordCount }

{---- Internal Routines (No Dialog) ----}

procedure TSpellDlg.AddAutoCorrectList;
  {-loads auto correction list}
var
  AutoList: TStringList;
  AutoFile: TFileName;
  i: integer;
  BadSt: String[255];       {string to be replaced}
  ReplaceSt: String[255];   {string to replace bad word}
  EqualPos: integer;        {position of equals sign}
  CurWord: String[255];
begin
  AutoFile := FAutoCorrect;
  if not FileExists (AutoFile) then
  begin
    AutoFile := DictionaryPath + AutoFile;
    if not FileExists (AutoFile) then
    begin
      MessageDlg (FAutoCorrect + ' file not found.', mtError, [mbOk], 0);
      Exit;
    end;  { if... }
  end;  { if... }
  AutoList := TStringList.Create;
  AutoList.LoadFromFile (AutoFile);
  for i := 0 to AutoList.Count - 1 do
  begin
    CurWord := AutoList[i];
    EqualPos := Pos ('=', CurWord);
    if EqualPos > 0 then
    begin
      BadSt := Copy (CurWord, 1, EqualPos - 1);
         ReplaceSt := Copy (CurWord, EqualPos + 1, 255);
      if (BadSt <> '') and (ReplaceSt <> '') then
      begin
        ReplaceList.Add (BadSt);
        Replacer.Add (ReplaceSt);
      end;  { if... }
    end;  { if... }
  end;  { next i }
  AutoList.Free;
end;  { TSpellDlg.AddAutoCorrectList }

{---- New AutoCorrect & AutoCheck ----}
procedure TSpellDlg.ShowBadword (AControl: TControl;
                                 TheWord: String; Pos: integer);
  {-highlights a bad word}
begin
  {no highlighting here on TMemo and TEdit}
end;  { TSpellDlg.ShowBadWord }

function TSpellDlg.GetLastWordTyped (AControl: TControl;
                                     var Pos: integer): String;
  {-returns the string and position of the last word typed}
var
  SavePos: integer;
  SaveLen: integer;
  St: String;
begin
  if AControl is TCustomEdit then
  with AControl as TCustomEdit do
  begin
    {HideSelection := TRUE;}
    SavePos := SelStart;
    SaveLen := SelLength;
    SelLength := 1;
    SelStart := SelStart - 1;
    St := '';
    {continue moving back in the buffer until an entire word is contructed}
    while not (SelText[1] in ValidChars) do
    begin
      SelStart := SelStart - 1;
      SelLength := 1;
    end;  { while }
    repeat
      SelStart := SelStart - 1;
      SelLength := 1;
      St := SelText[1] + St;
    until (not (St[1] in ValidChars)) or (SelStart = 0);
    while not (St[1] in ValidChars) and (St <> '') do
    begin
      St := Copy (St, 2, 255);
      SelStart := SelStart + 1;
    end;  { if... }
    Pos := SelStart;
    SelStart := SavePos;
    SelLength := SaveLen;
    Result := St;
  end;  { if... }
end;  { TSpellDlg.GetLastWordTyped }

procedure TSpellDlg.AutoCheck (AControl: TControl; AutoCorrect: Boolean;
                               Key: Word; Shift: TShiftState);
  {-auto checks a bad word (should be tied to controls OnKeyUp event}
const
  {found in WinTypes.PAS}
  TriggerChars = [vk_Space, vk_Return];
var
  CheckWord: String;   {word to be checked}
  CheckID: integer;    {Index of CheckWord in auto - ReplaceList }
  CheckPos: integer;   {position of CheckWord in control}
  WordDif: integer;    {difference in length between misspelled word and replacement}
  ReplaceSt: String;
  SavePos: integer;
  SaveLength: integer;
begin
  if DCT = nil then
    OpenDictionary;
  if Key in TriggerChars then
  begin
    {get the last word typed}
    CheckWord := GetLastWordTyped (AControl, CheckPos);
    if (CheckWord <> '') then
    begin
      if AutoCorrect then
      begin
        CheckID := ReplaceList.IndexOf (CheckWord);
        if CheckID <> (-1) then
        begin  {word in replace list}
          {highlight the bad word}
          SavePos := TCustomEdit (AControl).SelStart;
          SaveLength := TCustomEdit (AControl).SelLength;
          TCustomEdit (AControl).SelStart := CheckPos;
          TCustomEdit (AControl).SelLength := Length (CheckWord);
          {replace the bad word}
          ReplaceSt := Replacer[CheckID];
          WordDif := Length (ReplaceSt) - Length (CheckWord);
          TCustomEdit (AControl).SelText := ReplaceSt;
          TCustomEdit (AControl).SelStart := SavePos + WordDif;
          TCustomEdit (AControl).SelLength := SaveLength;
        end {:} else
          ShowBadWord (AControl, CheckWord, CheckPos);
      end {:} else
        if not InDictionary (CheckWord) then
          ShowBadWord (AControl, CheckWord, CheckPos);
    end;  { if... }
  end;  { if... }
end;  { TSpellDlg.AutoCheck }

function  TSpellDlg.OpenDictionary: Boolean;
  {-opens the dictionary; returns TRUE if successful}
begin
  Result := TRUE;  {assume dictionary opens fine}
  if DictionaryName='' then
    DictionaryName := UpperCase (Dictionaries[DictionaryType] + DCTExt);
  DictionaryPath := UpperCase (DictionaryPath);
  if DictionaryPath = 'APPLICATIONPATH' then
    DictionaryPath := ExtractFilePath (Application.ExeName)
  else
  if Length (DictionaryPath)>0 then
    if DictionaryPath[Length(DictionaryPath)]<>'\' then
      DictionaryPath := DictionaryPath + '\';
  if DCT = nil then
    DCT := TDictionary.Create;
  if not DCT.OpenDictionary (DictionaryPath + DictionaryName) then
  begin
    Result := FALSE;
    DCT.Free;
    DCT := nil;
  end {:} else
  begin
    DCT.OpenUserDictionary (UserDictionary);
    if FExclude <> '' then
      DCT.OpenExclusionFile (FExclude);
    if FAutoCorrect <> '' then
      AddAutoCorrectList;
  end;  { else }
end;  { TSpellDlg.OpenDictionary }

procedure TSpellDlg.AddDictionary (DCTFileName: TFileName);
  {-opens an additional dictionary}
begin
  if DCT = nil then
    OpenDictionary;
  DCT.OpenDictionary (DCTFileName);
end;  { TSpellDlg.AddDictionary }

procedure TSpellDlg.CloseDictionary;
  {-closes the dictionary}
begin
  if DCT <> nil then
  begin
    DCT.Free;
    DCT := nil;
  end;  { if... }
end;  { TSpellDlg.CloseDictionary }

function TSpellDlg.AddWord (AWord: string): Boolean;
  {-adds a word to the dictionary, returns TRUE if successful}
begin
  if DCT = nil then 
    OpenDictionary;

  if DCT <> nil then
    Result := DCT.AddWord (AWord)
  else
    Result := FALSE;
end;  { TSpellDlg.AddWord }

function TSpellDlg.InDictionary (AWord: String): Boolean;
  {-checks to see if the word is in the dictionary (no dialog)}
begin
  if DCT = nil then 
    OpenDictionary;

  if DCT <> nil then
    Result := DCT.InDictionary (AWord)
  else
    Result := FALSE;
end;  { TSpellDlg.InDictionary }

function TSpellDlg.SuggestWords (AWord: String; NumToList: Byte): TStringList;
  {-suggests words}
begin
  if DCT = nil then
    OpenDictionary;

  if DCT <> nil then
    Result := DCT.SuggestWords (AWord, NumToList)
  else
    Result := nil;
end;  { TSpellDlg.SuggestWords }

procedure Register;
begin
  RegisterComponents('Domain', [TSpellDlg]);
end;  { Register }


