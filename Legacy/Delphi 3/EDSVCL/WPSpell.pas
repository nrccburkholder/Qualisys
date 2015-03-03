(* WPSPELL.PAS - Copyright (c) 1995-1996, Eminent Domain Software *)

unit WPSpell;
  {-WordPerfect style spell dialog for EDSSpell component}
{$D-}
{$L-}
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Menus,
{$IFDEF Win32}
  {$IFDEF Ver100}
  LexDCTD3,
  {$ELSE}
  LexDCT32,
  {$ENDIF}
{$ELSE}
  LexDCT,
{$ENDIF}
  ExtCtrls, EDSUtil, AbsSpell, SpellGbl;

{$I SpellDef.PAS}

type
  TWPLabels = (tlblFound, tlblNotFound, tlblReplace, tlblSuggestions,
               tbtnReplace, tbtnAdd, tbtnSkip, tbtnSkipAll,
               tbtnSuggest, tbtnClose);
  TLabelArray = array[TWPLabels] of string[20];
const
  cLabels : array[TLanguages] of TLabelArray = (
{$IFDEF SupportEnglish}
      {English}    ('Found', 'Not Found', 'Replace &With', 'Sugg&estions',
                    '&Replace', '&Add', 'Skip &Once', 'Skip &Always',
                    '&Suggest', 'Close')
{$ENDIF}
{$IFDEF SupportSpanish}
      {Spanish}   ,('Encontrado', 'No Encontrado', 'Reemplazar Con', 'Sugerencias',
                    'Reemplazar', 'Añadir', 'Saltar', 'Ignorar',
                    'Sugerir', 'Cerrar')
{$ENDIF}
{$IFDEF SupportBritish}
      {British}   ,('Found', 'Not Found', 'Replace &With', 'Sugg&estions',
                    '&Replace', '&Add', 'Skip &Once', 'Skip &Always',
                    '&Suggest', 'Close')
{$ENDIF}
{$IFDEF SupportItalian}
      {Italian}   ,('Trovato', 'Non trovato', 'Modifica', 'Suggerimenti',
                    'Sostituisci', 'Aggiungi', 'Salta', 'Salta Tutti',
                    'Suggerisci', 'Cancella')
{$ENDIF}
{$IFDEF SupportFrench}
      {French}    ,('Dans le dictionaire', 'Pas dans le dictionarie', 'Remplacer par', 'Sugg&estions',
                    '&Remplacer', '&Ahouter', '&Ignorer', 'Ignorer toujours',
                    'Suggérer', 'Annuler')
{$ENDIF}
{$IFDEF SupportGerman}
      {German}    ,('Gefunden', 'Nicht Gefunden', 'Ersetze &Mit', '&Vorschläge',
                    '&Ersetze', 'E&infügen', 'Ü&berspringe', 'Überspringe &Immer',
                    '&Schlage vor', 'Schließen')
{$ENDIF}
{$IFDEF SupportDutch}
      {Dutch}     ,('Gevonden', 'Niet gevonden', 'Vervangen door', 'Suggesties',
                    'Vervang', 'Toevoegen', 'Negeer', 'Totaal negeren',
                    'Suggesties', 'Annuleren')
{$ENDIF}
                    );

type
  TWPSpellDlg = class(TAbsSpellDialog)
    lblFound: TLabel;
    lblNotFound: TLabel;
    lblReplace: TLabel;
    edtWord: TEnterEdit;
    lblSuggestions: TLabel;
    lstSuggest: TNewListBox;
    btnReplace: TBitBtn;
    btnSkip: TBitBtn;
    btnSkipAll: TBitBtn;
    btnSuggest: TBitBtn;
    btnAdd: TBitBtn;
    btnClose: TBitBtn;
    pnlIcons: TPanel;
    btnA: TSpeedButton;
    btnE: TSpeedButton;
    btnI: TSpeedButton;
    btnO: TSpeedButton;
    btnU: TSpeedButton;
    btnN: TSpeedButton;
    btnN2: TSpeedButton;
    procedure edtWordExit(Sender: TObject);
    procedure lstSuggestChange(Sender: TObject);
    procedure lstSuggestDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AccentClick(Sender: TObject);
    procedure btnSuggestClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnSkipClick(Sender: TObject);
    procedure btnSkipAllClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure lstSuggestClick(Sender: TObject);
    procedure lstSuggestEnter(Sender: TObject);
    procedure QuickSuggest(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }

    constructor Create (AOwner: TComponent);  override;
    {--- Extensions of TAbsSpellDialog ---}
    {--- Labels and Prompts ----}
    procedure SetNotFoundPrompt (ToString: String);  override;
      {-sets the not found prompt}
    procedure SetNotFoundCaption (ToString: String);  override;
      {-sets the not found caption}
    procedure SetEditWord (ToWord: String);  override;
      {-sets the edit word string}
    function  GetEditWord: String;  override;
      {-gets the edit word}
    procedure SetEditAsActive;  override;
      {-sets activecontrol the edit control}
    procedure SetLabelLanguage;  override;
      {-sets labels and buttons to a the language}

    {--- Buttons ---}
    procedure EnableSkipButtons;  override;
      {-enables the Skip and Skip All buttons}
      {-or          Ignore and Ignore All}
    procedure DisableSkipButtons;  override;
      {-disables the Skip and Skip All buttons}
      {-or           Ignore and Ignore All}

    {--- Accented Buttons ---}
    procedure SetAccentSet (Accents: TAccentSet);   override;
      {-sets the accented buttons to be displayed}

    {--- Suggest List ----}
    procedure ClearSuggestList;  override;
      {-clears the suggest list}
    procedure MakeSuggestions;  override;
      {-sets the suggest list}
   end;

implementation

{$R *.DFM}

constructor TWPSpellDlg.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
end;  { TWPSpellDlg.Create }

procedure TWPSpellDlg.edtWordExit(Sender: TObject);
var
  ChkWord:  String;
begin
  lblNotFound.Caption := edtWord.Text;
  if ActiveControl is TBitBtn then
    exit;
  ChkWord := edtWord.Text;
  if DCT.InDictionary (ChkWord) then
  begin
    lblFound.Caption := cLabels[Language][tlblFound];
    ActiveControl  := btnReplace;
  end {:} else
  begin
    lblFound.Caption := cLabels[Language][tlblNotFound];
    ActiveControl  := btnSuggest;
  end;  { else }
end;

procedure TWPSpellDlg.lstSuggestChange(Sender: TObject);
begin
  if lstSuggest.ItemIndex<>-1 then
    edtWord.Text := lstSuggest.Items[lstSuggest.ItemIndex];
end;

procedure TWPSpellDlg.lstSuggestDblClick(Sender: TObject);
begin
  if lstSuggest.ItemIndex<>-1 then
    edtWord.Text := lstSuggest.Items[lstSuggest.ItemIndex];
  btnReplaceClick (Sender);
end;

procedure TWPSpellDlg.lstSuggestClick(Sender: TObject);
begin
  if lstSuggest.ItemIndex<>-1 then
    edtWord.Text := lstSuggest.Items[lstSuggest.ItemIndex];
end;

procedure TWPSpellDlg.lstSuggestEnter(Sender: TObject);
begin
  if lstSuggest.ItemIndex<>-1 then
    edtWord.Text := lstSuggest.Items[lstSuggest.ItemIndex];
end;

procedure TWPSpellDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ClearKey: Boolean;
begin
  ClearKey := TRUE;
  case Key of
    Ord ('e'): if ssAlt in Shift then ActiveControl := lstSuggest;
    Ord ('w'): if ssAlt in Shift then ActiveControl := edtWord;
    else ClearKey := FALSE;
  end;  { case }
  if ClearKey then Key := 0;
end;

procedure TWPSpellDlg.AccentClick(Sender: TObject);
begin
  if Sender is TSpeedButton then
    edtWord.SelText := TSpeedButton (Sender).Caption[1];
end; { TSpellWin.AccentClick }

{--- Extensions of TAbsSpellDialog ---}
{--- Labels and Prompts ----}
procedure TWPSpellDlg.SetNotFoundPrompt (ToString: String);
  {-sets the not found prompt}
begin
  lblFound.Caption := ToString;
end;  { TWPSpellDlg.SetNotFoundPrompt }

procedure TWPSpellDlg.SetNotFoundCaption (ToString: String);
  {-sets the not found caption}
begin
  lblNotFound.Caption := ToString;
end;  { TSpellDlg.SetNotFoundCaption }

procedure TWPSpellDlg.SetEditWord (ToWord: String);
  {-sets the edit word string}
begin
  edtWord.Text := ToWord;
end;  { TWPSpellDlg.SetEditWord }

function TWPSpellDlg.GetEditWord: String;
  {-gets the edit word}
begin
  Result := edtWord.Text;
end;  { TWPSpellDlg.GetEditWord }

procedure TWPSpellDlg.SetEditAsActive;
  {-sets activecontrol the edit control}
begin
  ActiveControl := btnReplace;
  ActiveControl := edtWord;
end;  { TWPSpellDlg.SetEditAsActive }

procedure TWpSpellDlg.SetLabelLanguage;
  {-sets labels and buttons to a the language}
begin
  inherited SetLabelLanguage;
  lblFound.Caption := cLabels[Language][tlblFound];
  lblReplace.Caption := cLabels[Language][tlblReplace];
  lblSuggestions.Caption := cLabels[Language][tlblSuggestions];
  btnReplace.Caption := cLabels[Language][tbtnReplace];
  btnAdd.Caption := cLabels[Language][tbtnAdd];
  btnSkip.Caption := cLabels[Language][tbtnSkip];
  btnSkipAll.Caption := cLabels[Language][tbtnSkipAll];
  btnSuggest.Caption := cLabels[Language][tbtnSuggest];
  btnClose.Caption := cLabels[Language][tbtnClose];
end;  { TWpSpellDlg.SetLabelLanguage }

{--- Buttons ---}
procedure TWPSpellDlg.EnableSkipButtons;
  {-enables the Skip and Skip All buttons}
  {-or          Ignore and Ignore All}
begin
  btnSkip.Enabled     := TRUE;
  btnSkipAll.Enabled  := TRUE;
end;  { TSPSpellDlg.EnableSjipButtons }

procedure TWPSpellDlg.DisableSkipButtons;
  {-disables the Skip and Skip All buttons}
  {-or           Ignore and Ignore All}
begin
  btnSkip.Enabled     := FALSE;
  btnSkipAll.Enabled  := FALSE;
end;  { TWPSpellDlg.DisableSkipButtons }

{--- Accented Buttons ---}
procedure TWPSpellDlg.SetAccentSet (Accents: TAccentSet);
  {-sets the accented buttons to be displayed}
begin
  lstSuggest.Top     := pnlIcons.Top + 1;
  lstSuggest.Height  := 161;
  pnlIcons.Visible   := FALSE;
  if acSpanish in Accents then
  begin
    pnlIcons.Visible   := TRUE;
    lstSuggest.Top     := lstSuggest.Top + pnlIcons.Height;
    lblSuggestions.Top := lblSuggestions.Top + pnlIcons.Height;
    lstSuggest.Height  := lstSuggest.Height - pnlIcons.Height;
  end;  { if... }
end;  { TWPSpellDlg.SetAccentSet }

{--- Suggest List ----}
procedure TWPSpellDlg.ClearSuggestList;
  {-clears the suggest list}
begin
  lstSuggest.Clear;
end;  { TWPSpellDlg.ClearSuggestList }

procedure TWPSpellDlg.MakeSuggestions;
  {-sets the suggest list}
var
  TempList:   TStringList;
  SaveCursor: TCursor;
begin
  SaveCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  Application.ProcessMessages;
  TempList := DCT.SuggestWords (edtWord.Text, Suggestions);
  lstSuggest.Items.Assign (TempList);
  TempList.Free;
  if lstSuggest.Items.Count > 0 then
    SetEditWord (lstSuggest.Items[0]);
  ActiveControl := btnReplace;
  Screen.Cursor := SaveCursor;
end;  { TWPSpellDlg.MakeSuggestions }

procedure TWPSpellDlg.btnSuggestClick(Sender: TObject);
begin
  MakeSuggestions;
end;

procedure TWPSpellDlg.btnReplaceClick(Sender: TObject);
begin
  SpellDlgResult := mrReplace;
end;

procedure TWPSpellDlg.btnAddClick(Sender: TObject);
begin
  SpellDlgResult := mrAdd;
end;

procedure TWPSpellDlg.btnSkipClick(Sender: TObject);
begin
  SpellDlgResult := mrSkipOnce;
end;

procedure TWPSpellDlg.btnSkipAllClick(Sender: TObject);
begin
  SpellDlgResult := mrSkipAll; 
end;

procedure TWPSpellDlg.btnCloseClick(Sender: TObject);
begin
  SpellDlgResult := mrCancel;
end;

procedure TWPSpellDlg.QuickSuggest(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  TempList:   TStringList;
begin
  if (Shift = []) and (Char (Key) in ValidChars) then
  begin
    if edtWord.Text <> '' then
    begin
      TempList := DCT.QuickSuggest (edtWord.Text, Suggestions);
      lstSuggest.Items.Assign (TempList);
      TempList.Free;
    end {:} else
      lstSuggest.Clear;
  end;  { if... }
end;

end.  { WPSpell }
