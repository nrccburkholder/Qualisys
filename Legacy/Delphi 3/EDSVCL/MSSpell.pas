(* MSSPELL.PAS - Copyright (c) 1995-1996, Eminent Domain Software *)

unit MSSpell;
  {-Microsoft Word style spell dialog for EDSSpell component}
{$D-}
{$L-}
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

{Labels for Microsoft-style dialog}
type
  TMSLabels = (tlblFound, tlblNotFound, tlblReplace, tlblSuggestions,
               tbtnReplace, tbtnReplaceAll, tbtnAdd, tbtnSkip, tbtnSkipAll,
               tbtnSuggest, tbtnClose, tbtnAutoCorrect, tbtnOptions,
               tbtnUndoLast, tbtnHelp);
  TLabelArray = array[TMSLabels] of string[20];

const
  cLabels : array[TLanguages] of TLabelArray = (
{$IFDEF SupportEnglish}
      {English}    ('In Dictionary:', 'Not in Dictionary:', 'Change &To:', 'Suggestio&ns:',
                    '&Change', 'C&hange All', '&Add', '&Ignore', 'I&gnore All',
                    '&Suggest', 'Cancel', 'AutoCorrect', '&Options', '&Undo Last', 'Help')
{$ENDIF}
{$IFDEF SupportSpanish}
      {Spanish}   ,('Encontrado:', 'No Encontrado:', 'Reemplazar Con:', 'Sugerencias:',
                    'Cambiar', 'Cambiarlos', 'A�adir', 'Saltar', 'Ignorar',
                    'Sugerir', 'Cerrar', 'Corregir', '&Opciones', 'Deshacer', 'Ayuda')
{$ENDIF}
{$IFDEF SupportBritish}
      {British}   ,('In Dictionary:', 'Not in Dictionary:', 'Change &To:', 'Suggestio&ns:',
                    '&Change', 'C&hange All', '&Add', 'Skip &Once', 'Skip &Always',
                    '&Suggest', 'Cancel', 'AutoCorrect', '&Options', '&Undo Last', 'Help')
{$ENDIF}
{$IFDEF SupportItalian}
      {Italian}   ,('Trovato:', 'Non trovato:', 'Modifica:', 'Suggerimenti:',
                    'Sostituisci', 'Sostituisci Tutti', 'Aggiungi', 'Salta',
                    'Salta Tutti', 'Suggerisci', 'Cancella',
                    'Correzione Automatica', 'Opzioni', 'Disfa Ultimo', '?')
{$ENDIF}
{$IFDEF SupportFrench}
      {Frehcn}    ,('Dans le dictionaire:', 'Absent du Dictionaire:', 'Remplacar &Par:', 'Suggestio&ns:',
                    '&Remplacar', 'Remplacar &Tout', '&Ajouter', '&Ignorer', 'I&gnorer toujours',
                    '&Sugg�rer', 'Annnuler', 'AutoCorrection', '&Options', 'Annuler &Derni�re', 'Aide')
{$ENDIF}
{$IFDEF SupportGerman}
      {German}    ,('Im W�rterbuch:', ' Nicht im W�rterbuch:', '�&ndere in:', '&Vorschl�ge:',
                    '�n&dern', '&Immer �ndern', '&Einf�gen', '&Ignorieren', 'Immer I&gnorieren',
                    '&Schlage Vor', 'Schlie�en', 'AutoKorrigieren', '&Optionen', '&Widerufe', 'Hilfe')
{$ENDIF}
{$IFDEF SupportDutch}
      {Dutch}     ,('In woordenboek:', 'Niet in woordenboek:', 'Vervangen door:', 'Suggesties:',
                    'Vervang', 'Volledig vervangen', 'Toevoegen', 'Negeer', 'Totaal negeren',
                    'Voorstellen', 'Annuleren', 'AutoCorrectie', 'Opties',
                    'Herstel laatste', 'Help')
{$ENDIF}
                    );

type
  TMSSpellDlg = class(TAbsSpellDialog)
    lblFound: TLabel;
    lblReplace: TLabel;
    lblSuggestions: TLabel;
    edtWord: TEnterEdit;
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
    btnAutoCorrect: TBitBtn;
    btnOptions: TBitBtn;
    btnUndo: TBitBtn;
    btnHelp: TBitBtn;
    btnReplaceAll: TBitBtn;
    edtCurWord: TEnterEdit;
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
  MSSpellDlg: TMSSpellDlg;

implementation

{$R *.DFM}

constructor TMSSpellDlg.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
end;  { TMSSpellDlg.Create }

{--- Extensions of TAbsSpellDialog ---}
{--- Labels and Prompts ----}
procedure TMSSpellDlg.SetNotFoundPrompt (ToString: String);
  {-sets the not found prompt}
begin
  lblFound.Caption := ToString;
end;  { TMSSpellDlg.SetNotFoundPrompt }

procedure TMSSpellDlg.SetNotFoundCaption (ToString: String);
  {-sets the not found caption}
begin
  edtCurWord.Text := ToString;
end;  { TSpellDlg.SetNotFoundCaption }

procedure TMSSpellDlg.SetEditWord (ToWord: String);
  {-sets the edit word string}
begin
  edtWord.Text := ToWord;
end;  { TMSSpellDlg.SetEditWord }

function TMSSpellDlg.GetEditWord: String;
  {-gets the edit word}
begin
  Result := edtWord.Text;
end;  { TMSSpellDlg.GetEditWord }

procedure TMSSpellDlg.SetEditAsActive;
  {-sets activecontrol the edit control}
begin
  ActiveControl := btnReplace;
  ActiveControl := edtWord;
end;  { TMSSpellDlg.SetEditAsActive }

procedure TMSSpellDlg.SetLabelLanguage;
  {-sets labels and buttons to a the language}
begin
  inherited SetLabelLanguage;
  lblFound.Caption := cLabels[Language][tlblFound];
  lblReplace.Caption := cLabels[Language][tlblReplace];
  lblSuggestions.Caption := cLabels[Language][tlblSuggestions];
  btnReplace.Caption := cLabels[Language][tbtnReplace];
  btnReplaceAll.Caption := cLabels[Language][tbtnReplaceAll];
  btnAdd.Caption := cLabels[Language][tbtnAdd];
  btnSkip.Caption := cLabels[Language][tbtnSkip];
  btnSkipAll.Caption := cLabels[Language][tbtnSkipAll];
  btnSuggest.Caption := cLabels[Language][tbtnSuggest];
  btnClose.Caption := cLabels[Language][tbtnClose];
  btnAutoCorrect.Caption := cLabels[Language][tbtnAutoCorrect];
  btnOptions.Caption := cLabels[Language][tbtnOptions];
  btnUndo.Caption := cLabels[Language][tbtnUndoLast];
  btnHelp.Caption := cLabels[Language][tbtnHelp];
end;  { TMSSpellDlg.SetLabelLanguage }

{--- Buttons ---}
procedure TMSSpellDlg.EnableSkipButtons;
  {-enables the Skip and Skip All buttons}
  {-or          Ignore and Ignore All}
begin
  btnSkip.Enabled     := TRUE;
  btnSkipAll.Enabled  := TRUE;
end;  { TSPSpellDlg.EnableSjipButtons }

procedure TMSSpellDlg.DisableSkipButtons;
  {-disables the Skip and Skip All buttons}
  {-or           Ignore and Ignore All}
begin
  btnSkip.Enabled     := FALSE;
  btnSkipAll.Enabled  := FALSE;
end;  { TMSSpellDlg.DisableSkipButtons }

{--- Accented Buttons ---}
procedure TMSSpellDlg.SetAccentSet (Accents: TAccentSet);
  {-sets the accented buttons to be displayed}
begin
  lstSuggest.Top     := pnlIcons.Top + 1;
  lstSuggest.Height  := 137;
  pnlIcons.Visible   := FALSE;
  if acSpanish in Accents then
  begin
    pnlIcons.Visible   := TRUE;
    lstSuggest.Top     := lstSuggest.Top + pnlIcons.Height;
    lblSuggestions.Top := lblSuggestions.Top + pnlIcons.Height;
    lstSuggest.Height  := lstSuggest.Height - pnlIcons.Height;
  end;  { if... }
end;  { TMSSpellDlg.SetAccentSet }

{--- Suggest List ----}
procedure TMSSpellDlg.ClearSuggestList;
  {-clears the suggest list}
begin
  lstSuggest.Clear;
end;  { TMSSpellDlg.ClearSuggestList }

procedure TMSSpellDlg.MakeSuggestions;
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
    edtWord.Text := lstSuggest.Items[0];
  ActiveControl := btnReplace;
  Screen.Cursor := SaveCursor;
end;  { TMSSpellDlg.MakeSuggestions }

procedure TMSSpellDlg.lstSuggestChange(Sender: TObject);
begin
  if lstSuggest.ItemIndex<>-1 then
    edtWord.Text := lstSuggest.Items[lstSuggest.ItemIndex];
end;

procedure TMSSpellDlg.lstSuggestDblClick(Sender: TObject);
begin
  if lstSuggest.ItemIndex<>-1 then
    edtWord.Text := lstSuggest.Items[lstSuggest.ItemIndex];
  btnReplaceClick (Sender);
end;

procedure TMSSpellDlg.AccentClick(Sender: TObject);
begin
  if Sender is TSpeedButton then
    edtWord.SelText := TSpeedButton (Sender).Caption[1];
end;

procedure TMSSpellDlg.btnSuggestClick(Sender: TObject);
begin
  MakeSuggestions;
end;

procedure TMSSpellDlg.btnCloseClick(Sender: TObject);
begin
  SpellDlgResult := mrCancel;
end;

procedure TMSSpellDlg.btnAddClick(Sender: TObject);
begin
  SpellDlgResult := mrAdd;
end;

procedure TMSSpellDlg.btnReplaceClick(Sender: TObject);
begin
  SpellDlgResult := mrReplace;
end;

procedure TMSSpellDlg.btnReplaceAllClick(Sender: TObject);
begin
  SpellDlgResult := mrReplaceAll;
end;

procedure TMSSpellDlg.btnSkipClick(Sender: TObject);
begin
  SpellDlgResult := mrSkipOnce;
end;

procedure TMSSpellDlg.btnSkipAllClick(Sender: TObject);
begin
  SpellDlgResult := mrSkipAll;
end;

procedure TMSSpellDlg.QuickSuggest(Sender: TObject; var Key: Word;
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
