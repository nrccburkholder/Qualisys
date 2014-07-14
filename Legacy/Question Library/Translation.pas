unit Translation;

{*******************************************************************************
Description: a modal dialog used for creating, modifying, testing and
             deleting non-english headings, questions and scales

Modifications:
--------------------------------------------------------------------------------
Date        UserID   Description
--------------------------------------------------------------------------------
04-07-2006  GN01     If no codes constants are defined for the selected language,
                     display a warning to the user.

04-07-2006  GN02     Fixed the issue with the RichEdit control getting disabled for Header translation.
                     For example, If Spanish Header Translation had a Code in it
                     and you switch to any language like HCAHPS Spanish would
                     set the RichEdit control to readOnly.

*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Mask, DBCtrls, Grids, DBGrids, Buttons, ExtCtrls,
  DBRichEdit, CDK_Comp, DB, DBTables, Wwtable;

type
  TfrmTranslate = class(TForm)
    staTranslate: TStatusBar;
    pclPage: TPageControl;
    Panel1: TPanel;
    btnClose: TSpeedButton;
    shtQuestion: TTabSheet;
    shtScale: TTabSheet;
    Label31: TLabel;
    dgrScale: TDBGrid;
    detScale: TDBEdit;
    Label23: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    lblQuestion: TLabel;
    detQuestName: TDBEdit;
    detQuestShort: TDBEdit;
    DBCheckBox6: TDBCheckBox;
    DBCheckBox12: TDBCheckBox;
    shtHeading: TTabSheet;
    DBCheckBox1: TDBCheckBox;
    lblScale: TLabel;
    Label2: TLabel;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    detHeading: TDBEdit;
    DBCheckBox4: TDBCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    lblHeading: TLabel;
    btnFind: TSpeedButton;
    btnSpell: TSpeedButton;
    btnCode: TSpeedButton;
    btnCancel: TSpeedButton;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    shtLanguage: TTabSheet;
    TabSheet1: TTabSheet;
    Label6: TLabel;
    detLanguage: TDBEdit;
    DBEdit2: TDBEdit;
    Label7: TLabel;
    DBGrid1: TDBGrid;
    Bevel1: TBevel;
    Label8: TLabel;
    Bevel2: TBevel;
    Label9: TLabel;
    Label10: TLabel;
    btnReview: TSpeedButton;
    Label5: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Panel2: TPanel;
    DBText1: TDBText;
    btnToggle: TclCodeToggle;
    cmbLanguage: TComboBox;
    btnLink: TSpeedButton;
    rtfHead: TclDBRichCode;
    rtfTrHead: TclDBRichCodeBtn;
    rtfText: TclDBRichCode;
    rtfTrText: TclDBRichCodeBtn;
    rtfScale: TclDBRichCode;
    rtfTrScale: TclDBRichCodeBtn;
    rtfTsHead: TclDBRichCode;
    rtfTsText: TclDBRichCode;
    rtfTsScale: TclDBRichCode;
    btnFirst: TSpeedButton;
    btnNext: TSpeedButton;
    btnUnTrans: TSpeedButton;
    procedure CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ReviewClick(Sender: TObject);
    procedure SpellClick(Sender: TObject);
    procedure PageChange(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure EditChange(Sender: TObject);
    procedure PageChanging(Sender: TObject; var AllowChange: Boolean);
    procedure FindClick(Sender: TObject);
    procedure LanguageChange(Sender: TObject);
    procedure LinkClick(Sender: TObject);
    procedure CodeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ToTransClick(Sender: TObject);
    procedure rtfTrHeadKeyPress(Sender: TObject; var Key: Char);
    procedure rtfTrHeadKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rtfTrTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rtfTrTextKeyPress(Sender: TObject; var Key: Char);
    procedure rtfTrScaleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rtfTrScaleKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure rtfTrHeadExit(Sender: TObject);
    procedure rtfTrHeadEnter(Sender: TObject);
  private
    procedure TransHint( Sender : TObject );
    procedure SaveTranslate;
    procedure OpenTables;
    procedure LoadLanguageCombo;
    procedure EnableButtons;
    procedure SetLabels;
  public
    { Public declarations }
  end;

var
  frmTranslate: TfrmTranslate;
  SpanishVowels : boolean;

implementation

uses Data, Common, Lookup, Support, Code;

{$R *.DFM}
{$R BUTTONMAPS}

{ INITIALIZATION }

{ configure tables to function with dialog }

procedure TfrmTranslate.FormCreate(Sender: TObject);
begin
  vLanguage := vTranslate;
  OpenTables;
  LoadLanguageCombo;
  EnableButtons;
  SetLabels;
  Application.OnHint := TransHint;
  pclPage.ActivePage := shtHeading;
  ActiveControl := detHeading;
  LinkClick(Sender);
end;

procedure TfrmTranslate.OpenTables;
begin
  with modLibrary do
  begin
    tblTransH.Open;
    tblTransQ.Open;
    tblTransS.Open;
    tblScale.MasterSource := nil;
    tblHeading.MasterSource := nil;
  end;
end;

{ load all non-english languages into the language combo box }

procedure TfrmTranslate.LoadLanguageCombo;
var
  i : Word;
begin
  with modLibrary.tblLanguage, cmbLanguage do
  begin
    Clear;
    DisableControls;
    First;
    Next;
    for i := 2 to RecordCount do
    begin
      Items.Add( modLibrary.tblLanguageLanguage.Value );
      Next;
    end;
    Locate( 'LangID', vLanguage, [ ] );
    ItemIndex := Items.IndexOf( modLibrary.tblLanguageLanguage.Value );
    modSupport.dlgSpell.DictionaryName := modLibrary.tblLanguageDictionary.Value;
    EnableControls;
  end;
end;

procedure TfrmTranslate.EnableButtons;
begin
  btnDelete.Enabled := ( modLibrary.tblTransH.RecordCount > 0 );
  btnReview.Enabled := ( modLookup.tblHeadText.RecordCount > 0 );
end;

procedure TfrmTranslate.SetLabels;
var
  vLangName : string;
begin
  vLangName := cmbLanguage.Text;
  lblHeading.Caption := vLangName + ' &Heading';
  lblQuestion.Caption := vLangName + ' Survey &Text';
  lblScale.Caption := vLangName + ' &Scale Value';
end;

procedure TfrmTranslate.TransHint( Sender : TObject );
begin
  staTranslate.simpleText := Application.Hint;
end;

{ BUTTON METHODS }

procedure TfrmTranslate.CloseClick(Sender: TObject);
begin
  Close;
end;

{ move to the next translation tagged for review:
    1. if not set, set review table to proper table and filter for review and language
    2. move to current translation in review table
    3. find subsequent translation matching criteria in review table
    4. move translation table to match review table }

procedure TfrmTranslate.ReviewClick(Sender: TObject);
begin
 try
  case pclPage.ActivePage.PageIndex of
    0 : with modLibrary, modLookup.tblReview do
        begin
          if ( TableName <> 'HeadText' ) or ( Pos( '>', Filter ) = 0 ) then
          begin
            Close;
            TableName := 'HeadText';
            Filter := 'Review AND ( LangID > 1 )';
            Open;
            GoToCurrent( wtblHeadText );
          end;
          if not FindNext then
            if not FindFirst then
              if MessageDlg( 'There are no more Headings in Translation to be Reviewed',
                mtInformation, [ mbOK ], 0 ) = mrOK then Exit;
          tblHeading.Locate( 'HeadID', FieldByName( 'HeadID' ).Value, [ ] );
        end;
    1 : with modLibrary, modLookup.tblReview do
        begin
          if ( TableName <> 'QuestionText' ) or ( Pos( '>', Filter ) = 0 ) then
          begin
            Close;
            TableName := 'QuestionText';
            Filter := 'Review AND ( LangID > 1 )';
            Open;
            GoToCurrent( wtblQstnText );
          end;
          if not FindNext then
            if not FindFirst then
              if MessageDlg( 'There are no more Questions in Translation to be Reviewed',
                mtInformation, [ mbOK ], 0 ) = mrOK then Exit;
          wtblQuestion.Locate( 'Core', FieldByName( 'Core' ).Value, [ ] );
        end;
    2 : with modLibrary, modLookup.tblReview do
        begin
          if ( TableName <> 'ScaleText' ) or ( Pos( '>', Filter ) = 0 ) then
          begin
            Close;
            TableName := 'ScaleText';
            Filter := 'Review AND ( LangID > 1 )';
            Open;
            GoToCurrent( tblScaleText );
          end;
          if not FindNext then
            if not FindFirst then
              if MessageDlg( 'There are no more Scales in Tranlsation to be Reviewed',
                mtInformation, [ mbOK ], 0 ) = mrOK then Exit;
          tblScale.Locate( 'Scale', FieldByName( 'Scale' ).Value, [ ] );
          tblValues.Locate( 'Item', FieldByName( 'Item' ).Value, [ ] );
        end;
  end;
  except
  end;
end;

procedure TfrmTranslate.SpellClick(Sender: TObject);
var
  vDictionary : string;
begin
  with modSupport.dlgSpell do
  begin
    Open;
    Show;
    if ( DictionaryName = '' ) and ( pclPage.ActivePage <> shtLanguage ) then
      MessageDlg( 'No ' + cmbLanguage.Text + ' language dictionary is available '
          + 'for a spell check', mtInformation, [ mbOK ], 0 )
    else
      case pclPage.ActivePage.PageIndex of
        0 : if SpellCheck( rtfTrHead ) = mrOK then begin
              modlibrary.tbltransh.edit;
              modlibrary.tbltransh.fieldbyname('review').value := false;
              modlibrary.tbltransh.post;
            end;
        1 : if SpellCheck( rtfTrText ) = mrOK then begin
              modlibrary.tbltransq.edit;
              modlibrary.tbltransq.fieldbyname('review').value := false;
              modlibrary.tbltransq.post;
            end;
        2 : if SpellCheck( rtfTrScale ) = mrOK then begin
            end;
        4 : begin
              vDictionary := DictionaryName;
              DictionaryName := 'English.dct';
              SpellCheck( detLanguage );
              DictionaryName := vDictionary;
            end;
      end;
    Close;
  end;
end;

{ insert a new language record or save changes to other pages }

procedure TfrmTranslate.AddClick(Sender: TObject);
begin
  if pclPage.ActivePage = shtLanguage then begin
    modLibrary.tblLanguage.Append;
    detLanguage.SetFocus;
  end else
    SaveTranslate;
end;

procedure TfrmTranslate.FindClick(Sender: TObject);
begin
  with modSupport.dlgLocate do
  begin
    case pclPage.ActivePage.PageIndex of
      0 : begin
            Caption := 'Locate Heading';
            SearchField := 'Name';
            DataSource := modLibrary.srcHeading;
          end;
      1 : begin
            Caption := 'Locate Question';
            SearchField := 'Short';
            DataSource := modLibrary.wsrcQuestion;
          end;
      2 : begin
            Caption := 'Locate Scale Value';
            SearchField := 'BubbleValue';
            DataSource := modLibrary.srcScale;
          end;
      4 : begin
            Caption := 'Locate Language';
            SearchField := 'Langauge';
            DataSource := modLibrary.srcLanguage;
          end;
    end;
    Execute;
  end;
end;

{ links heading, question and scale together so they can be viewed as a unit in testing }

procedure TfrmTranslate.LinkClick(Sender: TObject);
var
  vSource : TDataSource;
begin
  with modLibrary do begin
    if btnLink.Down then begin
      vSource := wsrcQuestion;
      btnLink.Hint := 'Independent Edit|Disconnects the Heading and the Scale from the Question';
    end else begin
      vSource := nil;
      btnLink.Hint := 'Unit Editing|Connects the Heading and the Scale to the Question';
    end;
    btnReview.Enabled := not btnLink.Down;
    tblScale.MasterSource := vSource;
    tblHeading.MasterSource := vSource;
    wtblQuestion.Refresh;
  end;
end;

procedure TfrmTranslate.CodeClick(Sender: TObject);
begin
  if vAsText then begin            {DG}
    vAsText := False;              {DG}
    rtfText.UpdateRichText(cText); {DG}
  end;                             {DG}
  if btnCode.Down then
  begin
    //GN01: Trap when the user doesn't select any langauge
    if (cmbLanguage.ItemIndex = -1) then
    begin
       MessageDlg('Please select a language to translate.', mtWarning, [mbOK],0 );
       btnCode.Down := False;
       cmbLanguage.SetFocus;
       Exit;
    end;

    //GN01: If no codes are defined, don't display the form
    if (modLibrary.tblCode.RecordCount < 1) then
    begin
       MessageDlg('No code exists for the selected language '+  cmbLanguage.Text + '. Please define codes.', mtWarning, [mbOK],0 );
       btnCode.Down := False;
       cmbLanguage.SetFocus;
       Exit;
    end;



    Screen.Cursor := crHourGlass;
    try
      frmCode := TfrmCode.Create( Self );
      //Hide;
      frmCode.Top := ( Screen.Height - frmCode.Height ) div 2;
      if Screen.Width < ( frmCode.Width + Width ) then
      begin
        frmCode.Left := 2;
        Left := Screen.Width - ( Width + 2 );
      end
      else
      begin
        frmCode.Left := ( Screen.Width - frmCode.Width - Width - 4 ) div 2;
        Left := frmCode.Left + frmCode.Width + 4;
      end;
      frmCode.vForm := Self;
      frmCode.selectedLanguage  := cmbLanguage.ItemIndex ;
      Show;
      frmCode.Show;
    finally
      Screen.Cursor := crDefault;
    end;
  end
  else
    frmCode.Close;
end;

procedure TfrmTranslate.ToTransClick(Sender: TObject);
  function ScaleReview:boolean;
  begin
    with modLibrary do begin
      result := false;
      tblValues.first;
      while not tblValues.eof do begin
        if tblTransS.eof or
           tblTransS.fieldbyname('Review').asboolean {or
           tblScaleTextReview.asBoolean} then begin
          result := true;
          break;
        end;
        tblValues.next;
      end;
    end;
  end;

  function NeedReview : boolean;
  begin
    with modlibrary do
      result := {wtblQstnTextReview.asBoolean or
        wtblHeadTextReview.asBoolean or}
        tblTransQ.eof or
        tblTransH.eof or
        tblTransQ.fieldbyname('Review').asBoolean or
        tblTransH.fieldbyname('Review').asBoolean or
        ScaleReview;
  end;

begin
  with modlibrary.wtblQuestion do
    while (not NeedReview) and (not eof) do
      next;
  with modlibrary do
    if {wtblHeadTextReview.asboolean or} tblTransH.eof or tblTransH.fieldbyname('Review').asBoolean then begin
      pclpage.Activepage := shtHeading;
      activeControl := rtfTrHead;
    end else
      if {wtblQstnTextReview.asboolean or} tblTransQ.eof or tblTransQ.fieldbyname('Review').asBoolean then begin
        pclpage.Activepage := shtQuestion;
        activeControl := rtfTrText;
      end else begin
        pclpage.Activepage := shtScale;
        activeControl := rtfTrScale;
      end;
  { move to the next untranslated item
     1. limit to selected language
     2. limit to selected item type (heading, question, scale) ??
     3. how identify untranslated??
     4. since not all to be translated, how know which to exclude??  }
end;

{ PAGE/TAB }

{ changes made when leaving a tab/page }

procedure TfrmTranslate.PageChanging(Sender: TObject; var AllowChange: Boolean);
begin
  case pclPage.ActivePage.PageIndex of
    3 : with modLibrary do
        begin
         { tblHeading.MasterSource := nil;
          tblScale.MasterSource := nil; }
        end;
    4 : begin  { language tab }
          btnAdd.Glyph.LoadFromResourceName( HInstance, 'SAVE' );
          btnAdd.NumGlyphs := 2;
          btnLink.Enabled := True;
          btnToggle.Enabled := True;
          cmbLanguage.Enabled := True;
        end;
  end;
end;

{ when switching pages, reset buttons, hints and save editing }

procedure TfrmTranslate.PageChange(Sender: TObject);
begin
  SaveTranslate;
  btnFind.Enabled := True;
  btnNext.Enabled := False;
  btnFirst.Enabled := False;
  case pclPage.ActivePage.PageIndex of
    0 : begin
          btnCode.Enabled := True;
          btnReview.Enabled := true;
          btnLink.Enabled := true;
          btnDelete.Enabled := ( modLibrary.tblTransH.RecordCount > 0 );
          btnReview.Hint := 'Next To Review|Moves to the next Heading marked for Review';
          btnCancel.Hint := 'Cancel Translation|Cancels changes made to the Translated Heading';
          btnDelete.Hint := 'Delete Translation|Permanently removes Translated Heading from Library';
          btnAdd.Hint := 'Save Translation|Saves the changes made to the Translated Heading';
        end;
    1 : begin
          btnCode.Enabled := True;
          btnReview.Enabled := true;
          btnLink.Enabled := true;
          btnDelete.Enabled := ( modLibrary.tblTransQ.RecordCount > 0 );
          btnReview.Hint := 'Next To Review|Moves to the next Question marked for Review';
          btnCancel.Hint := 'Cancel Translation|Cancels changes made to the Translated Question';
          btnDelete.Hint := 'Delete Translation|Permanently removes Translated Question from Library';
          btnAdd.Hint := 'Save Translation|Saves the changes made to the Translated Question';
        end;
    2 : begin
          btnCode.Enabled := True;
          btnReview.Enabled := true;
          btnLink.Enabled := true;
          btnDelete.Enabled := ( modLibrary.tblTransS.RecordCount > 0 );
          btnReview.Hint := 'Next To Review|Moves to the next Scale marked for Review';
          btnCancel.Hint := 'Cancel Translation|Cancels changes made to the Translated Scale';
          btnDelete.Hint := 'Delete Translation|Permanently removes Translated Scale from Library';
          btnAdd.Hint := 'Save Translation|Saves the changes made to the Translated Scale';
        end;
    3 : begin
          rtfTsScale.LoadText;
          { link to sample for page coming from }
          btnCancel.Enabled := False;
          btnDelete.Enabled := False;
          btnAdd.Enabled := False;
          btnCode.Enabled := False;
          btnReview.Enabled := False;
          btnFind.Enabled := False;
          btnLink.Enabled := False;
        end;
    4 : begin
          btnToggle.Enabled := False;
          btnLink.Enabled := False;
          btnDelete.Enabled := False; {<-DG/CL->( modLibrary.tblLanguage.RecordCount > 0 );}
          cmbLanguage.Enabled := False;
          btnCode.Enabled := False;
          btnReview.Enabled := False;
          btnCancel.Hint := 'Cancel Language|Cancels changes made to the Langauge';
          btnDelete.Hint := 'Delete Language|Permanently removes the Langauge from Library';
          btnAdd.Hint := 'New Language|Adds a new, blank Language entry to the Library';
          btnAdd.Glyph.LoadFromResourceName( HInstance, 'INSERT' );
          btnAdd.NumGlyphs := 1;
          btnAdd.Enabled := True;
        end;
  end;
end;

{ GENERAL METHODS }

procedure TfrmTranslate.SaveTranslate;
begin
  with modLibrary do begin
{    case pclPage.ActivePage.PageIndex of
      0 : if tblTransH.Modified then tblTransH.Post;
      1 : if tblTransQ.Modified then tblTransQ.Post;
      2 : if tblTransS.Modified then tblTransS.Post;
      4 : if tblLanguage.Modified then tblLanguage.Post;
    end;}
    if tblTransH.Modified then tblTransH.Post;
    if tblTransQ.Modified then tblTransQ.Post;
    if tblTransS.Modified then tblTransS.Post;
    if tblLanguage.Modified then tblLanguage.Post;
  end;
  btnCancel.Enabled := False;
  btnAdd.Enabled := False;
end;

{ COMPONENT METHODS }

procedure TfrmTranslate.EditChange(Sender: TObject);
begin
  { need to only do this on visible and if editing; test for page? }
    btnCancel.Enabled := True;
    btnAdd.Enabled := True;
end;

procedure TfrmTranslate.LanguageChange(Sender: TObject);
begin
  with modLibrary do
  begin
    tblLanguage.Locate( 'Language', cmbLanguage.Text, [ ] );
    vLanguage := tblLanguageLangID.Value;
    modSupport.dlgSpell.DictionaryName := tblLanguageDictionary.Value;
    modLibrary.tblTransH.refresh;
    modLibrary.tblTransQ.refresh;
    modLibrary.tblTransS.refresh;
  end;
  SetLabels;

  //GN01
  try
     if frmCode <> nil then frmCode.FormActivate(self);
  except
  end;
end;

{ FINALIZATION }

{ remove database configuration used for dialog }

procedure TfrmTranslate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Hide;
  try
    activecontrol := cmbLanguage;
    SaveTranslate;
    with modLibrary do
    begin
      tblTransH.Close;
      tblTransQ.Close;
      tblTransS.Close;
      if btnLink.Down then
      begin
        tblScale.MasterSource := nil;
        tblHeading.MasterSource := nil;
      end;
    end;
    modSupport.dlgSpell.DictionaryName := 'English.dct';
    vTranslate := vLanguage;
    vLanguage := 1;
  except
    on EDatabaseError do
    begin
      Action := caNone;
      Show;
      Raise;
    end;
  end;
end;

{á:0225 é:0233 í:0237 ó:0243 ú:0250 ñ:0241 ¿:0191 ¡:0161 °:0176}
procedure TfrmTranslate.rtfTrHeadKeyPress(Sender: TObject; var Key: Char);
begin
  if SpanishVowels then
    case (key) of
      'a' : key := chr(225);
      'e' : key := chr(233);
      'i' : key := chr(237);
      'o' : key := chr(243);
      'u' : key := chr(250);
      'n' : key := chr(241);
      '?' : key := chr(191);
      '!' : key := chr(161);
    end;
  SpanishVowels := false;
  staTranslate.simpleText := '';
end;

procedure TfrmTranslate.rtfTrHeadKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=116) then begin
    SpanishVowels := true;
    staTranslate.SimpleText := 'Press a, e, i, o, u, n, ?, or !';
  end;
end;

procedure TfrmTranslate.rtfTrTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  rtfTrHeadKeyDown(Sender,Key,Shift);
end;

procedure TfrmTranslate.rtfTrTextKeyPress(Sender: TObject; var Key: Char);
begin
  rtfTrHeadKeyPress(Sender,Key)
end;

procedure TfrmTranslate.rtfTrScaleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  rtfTrHeadKeyDown(Sender,Key,Shift);
end;

procedure TfrmTranslate.rtfTrScaleKeyPress(Sender: TObject; var Key: Char);
begin
  rtfTrHeadKeyPress(Sender,Key)
end;

procedure TransCancel(var vTbl:ttable);
begin
  with vTbl do begin
    if (state=dsEdit) or (state=dsInsert) then
      Cancel;
    refresh;
  end;
end;

procedure TfrmTranslate.btnCancelClick(Sender: TObject);
begin
  with modlibrary do begin
    case pclPage.ActivePage.PageIndex of
      0 : TransCancel(tblTransH);
      1 : TransCancel(tblTransQ);
      2 : TransCancel(tblTransS);
      4 : if tblLanguage.modified then tblLanguage.Cancel;
    end;
  end;
  frmTranslate.show;
  frmTranslate.update;
end;

procedure TransDel(var vTbl:ttable; whichone:string);
begin
  if messagedlg('Are you sure you want to clear this '+whichone+' translation?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    with vTbl do begin
      Delete;
      Refresh;
    end;
end;

procedure TfrmTranslate.btnDeleteClick(Sender: TObject);
begin
  with modlibrary do begin
    case pclPage.ActivePage.PageIndex of
      0 : TransDel(tblTransH,'Header');
      1 : TransDel(tblTransQ,'Question');
      2 : TransDel(tblTransS,'Scale');
    end;
  end;
  frmTranslate.show;
  frmTranslate.update;
end;

procedure TfrmTranslate.rtfTrHeadExit(Sender: TObject);
begin
  //GN02:
  //modLibrary.UpdateInsertBtn( False );
end;

procedure TfrmTranslate.rtfTrHeadEnter(Sender: TObject);
begin
  //GN02
  //modLibrary.UpdateInsertBtn( True );
end;

end.
