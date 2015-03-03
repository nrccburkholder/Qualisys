(* W96SPELL.PAS - Copyright (c) 1995-1996, Eminent Domain Software *)

unit W96Spell;
  {-WordPro 96 style spell dialog for EDSSpell component}
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, ExtCtrls, StdCtrls, EDSUtil,
{$IFDEF Win32}
  {$IFDEF Ver100}
  LexDCTD3,
  {$ELSE}
  LexDCT32,
  {$ENDIF}
{$ELSE}
  LexDCT,
{$ENDIF}
  AbsSpell, SpellGbl;

{$I SpellDef.PAS}

type
  TW96Labels = (tlblSpellCheck, tlblFound, tlblNotFound,
                tbtnReplace, tbtnReplaceAll, tbtnAdd, tbtnSkip, tbtnSkipAll,
                tbtnClose);
  TLabelArray = array[TW96Labels] of string[20];
const
  cLabels : array[TLanguages] of TLabelArray = (
{$IFDEF SupportEnglish}
      {English}    ('Spell Check', 'Word Found:', 'Word in Question:',
                    '&Replace', 'Replace All', '&Add', 'Skip &Once', 'Skip &Always',
                    '&Done')
{$ENDIF}
{$IFDEF SupportSpanish}      {Spanish}   ,('Verificar', 'Encontrado', 'No Encontrado',
                    'Cambiar', 'Cambiarlos', 'Añadir', 'Saltar', 'Ignorar',
                    'Cerrar')
{$ENDIF}
{$IFDEF SupportBritish}
      {British}   ,('Spell Check', 'Word Found:', 'Word in Question:',
                    '&Replace', 'Replace All', '&Add', 'Skip &Once', 'Skip &Always',
                    '&Done')
{$ENDIF}
{$IFDEF SupportItalian}
      {Italian}   ,('Verificar', 'Trovato', 'Non Trovato',
                    'Sostituisci', 'Sostituisci Tutti', 'Aggiungi', 'Salta', 'Salta Tutti',
                    'Cancella')
{$ENDIF}
{$IFDEF SupportFrench}
      {French}    ,('Vérification', 'Mot Trouve:', 'Mot:',
                    '&Remplacar', 'Remplacar &Par', '&Ajouter', '&Ignorer', 'Ignorer &Toujours',
                    '&Fermer')
{$ENDIF}
{$IFDEF SupportGerman}
      {German}    ,('Rechtschreibprüfung', 'Gefundenes Wort:', 'Fragliches Wor:',
                    '&Ersetze', '&Immer Ersetze', '&Einfügen', 'Ü&berspringe', 'Immer Übe&rspringe',
                    '&Schließen')
{$ENDIF}
{$IFDEF SupportDutch}
      {Dutch}     ,('Spellingcontrole', 'Gevonden:', 'Niet gevonden:',
                    'Vervang', 'Volledig vervangen', 'Toevoegen', 'Negeer', 'Totaal negeren',
                    'Annuleren')
{$ENDIF}
                    );

type
  TW96SpellDlg = class(TAbsSpellDialog)
    Panel1: TPanel;
    lblFound: TLabel;
    SpeedButton1: TSpeedButton;
    Shape1: TShape;
    lblSpellChk: TLabel;
    Shape2: TShape;
    Panel2: TPanel;
    edtWord: TEnterEdit;
    lstSuggest: TNewListBox;
    pnlIcons: TPanel;
    btnA: TSpeedButton;
    btnE: TSpeedButton;
    btnI: TSpeedButton;
    btnO: TSpeedButton;
    btnU: TSpeedButton;
    btnN: TSpeedButton;
    btnN2: TSpeedButton;
    btnReplace: TBitBtn;
    btnAdd: TBitBtn;
    btnSkip: TBitBtn;
    btnSkipAll: TBitBtn;
    btnClose: TBitBtn;
    btnReplaceAll: TBitBtn;
    procedure edtWordExit(Sender: TObject);
    procedure lstSuggestChange(Sender: TObject);
    procedure lstSuggestDblClick(Sender: TObject);
    procedure AccentClick(Sender: TObject);
    procedure btnSuggestClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure btnReplaceAllClick(Sender: TObject);
    procedure btnSkipClick(Sender: TObject);
    procedure btnSkipAllClick(Sender: TObject);
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

var
  W96SpellDlg: TW96SpellDlg;

implementation

{$R *.DFM}

constructor TW96SpellDlg.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
end;  { TW96SpellDlg.Create }

{--- Extensions of TAbsSpellDialog ---}
{--- Labels and Prompts ----}
procedure TW96SpellDlg.SetNotFoundPrompt (ToString: String);
  {-sets the not found prompt}
begin
  lblFound.Caption := ToString;
end;  { TMSSpellDlg.SetNotFoundPrompt }

procedure TW96SpellDlg.SetNotFoundCaption (ToString: String);
  {-sets the not found caption}
begin
  {edtCurWord.Text := ToString;}
end;  { TSpellDlg.SetNotFoundCaption }

procedure TW96SpellDlg.SetEditWord (ToWord: String);
  {-sets the edit word string}
begin
  edtWord.Text := ToWord;
end;  { TMSSpellDlg.SetEditWord }

function TW96SpellDlg.GetEditWord: String;
  {-gets the edit word}
begin
  Result := edtWord.Text;
end;  { TMSSpellDlg.GetEditWord }

procedure TW96SpellDlg.SetEditAsActive;
  {-sets activecontrol the edit control}
begin
  ActiveControl := btnReplace;
  ActiveControl := edtWord;
end;  { TMSSpellDlg.SetEditAsActive }

procedure TW96SpellDlg.SetLabelLanguage;
  {-sets labels and buttons to a the language}
begin
  inherited SetLabelLanguage;
  lblSpellChk.Caption := cLabels[Language][tlblSpellCheck];
  lblFound.Caption := cLabels[Language][tlblFound];
  btnReplace.Caption := cLabels[Language][tbtnReplace];
  btnReplaceAll.Caption := cLabels[Language][tbtnReplaceAll];
  btnAdd.Caption := cLabels[Language][tbtnAdd];
  btnSkip.Caption := cLabels[Language][tbtnSkip];
  btnSkipAll.Caption := cLabels[Language][tbtnSkipAll];
  btnClose.Caption := cLabels[Language][tbtnClose];
end;  { TW96SpellDlg.SetLabelLanguage }

{--- Buttons ---}
procedure TW96SpellDlg.EnableSkipButtons;
  {-enables the Skip and Skip All buttons}
  {-or          Ignore and Ignore All}
begin
  btnSkip.Enabled     := TRUE;
  btnSkipAll.Enabled  := TRUE;
end;  { TW96SpellDlg.EnableSjipButtons }

procedure TW96SpellDlg.DisableSkipButtons;
  {-disables the Skip and Skip All buttons}
  {-or           Ignore and Ignore All}
begin
  btnSkip.Enabled     := FALSE;
  btnSkipAll.Enabled  := FALSE;
end;  { TW96SpellDlg.DisableSkipButtons }


{--- Accented Buttons ---}

procedure TW96SpellDlg.SetAccentSet (Accents: TAccentSet);
  {-sets the accented buttons to be displayed}
begin
  lstSuggest.Height  := 48;
  pnlIcons.Visible   := FALSE;
  if acSpanish in Accents then
    pnlIcons.Visible   := TRUE
  else
    lstSuggest.Height  := lstSuggest.Height + pnlIcons.Height;
end;  { TMSSpellDlg.SetAccentSet }

{--- Suggest List ----}
procedure TW96SpellDlg.ClearSuggestList;
  {-clears the suggest list}
begin
  lstSuggest.Clear;
end;  { TMSSpellDlg.ClearSuggestList }

procedure TW96SpellDlg.MakeSuggestions;
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
end;  { TMSSpellDlg.MakeSuggestions }

procedure TW96SpellDlg.edtWordExit(Sender: TObject);
var
  ChkWord:  String;
begin
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
  end;  { else }
end;

procedure TW96SpellDlg.lstSuggestChange(Sender: TObject);
begin
  if lstSuggest.ItemIndex<>-1 then
    edtWord.Text := lstSuggest.Items[lstSuggest.ItemIndex];
end;

procedure TW96SpellDlg.lstSuggestDblClick(Sender: TObject);
begin
  if lstSuggest.ItemIndex<>-1 then
    edtWord.Text := lstSuggest.Items[lstSuggest.ItemIndex];
  btnReplaceClick (Sender);
end;

procedure TW96SpellDlg.AccentClick(Sender: TObject);
begin
  if Sender is TSpeedButton then
    edtWord.SelText := TSpeedButton (Sender).Caption[1];
end;

procedure TW96SpellDlg.btnSuggestClick(Sender: TObject);
begin
  MakeSuggestions;
end;

procedure TW96SpellDlg.btnCloseClick(Sender: TObject);
begin
  SpellDlgResult := mrCancel;
end;

procedure TW96SpellDlg.btnAddClick(Sender: TObject);
begin
  SpellDlgResult := mrAdd;
end;

procedure TW96SpellDlg.btnReplaceClick(Sender: TObject);
begin
  SpellDlgResult := mrReplace;
end;

procedure TW96SpellDlg.btnReplaceAllClick(Sender: TObject);
begin
  SpellDlgResult := mrReplaceAll;
end;

procedure TW96SpellDlg.btnSkipClick(Sender: TObject);
begin
  SpellDlgResult := mrSkipOnce;
end;

procedure TW96SpellDlg.btnSkipAllClick(Sender: TObject);
begin
  SpellDlgResult := mrSkipAll;
end;

procedure TW96SpellDlg.QuickSuggest(Sender: TObject; var Key: Word;
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

end.
