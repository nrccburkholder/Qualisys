unit fTrans;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, DBRichEdit, ExtCtrls, Buttons, CDK_Comp, Db, DBTables,
  Grids, DBGrids, DBCtrls, Mask;

type
  TfrmTranslation = class(TForm)
    Panel1: TPanel;
    clDBRichCodeBtnEng: TclDBRichCodeBtn;
    clDBRichCodeBtnFrgn: TclDBRichCodeBtn;
    tCodeText: TTable;
    tConstants: TTable;
    clCodeToggle1: TclCodeToggle;
    SpeedButton1: TSpeedButton;
    btnCode: TSpeedButton;
    btnSpellCheck: TSpeedButton;
    cmbLanguage: TComboBox;
    cbFonts: TComboBox;
    cbFontSize: TComboBox;
    btnLeftJustify: TSpeedButton;
    btnCenter: TSpeedButton;
    ds_codes: TDataSource;
    tCodes: TTable;
    Panel2: TPanel;
    Label1: TLabel;
    DBTextLangReview: TDBText;
    Label2: TLabel;
    tCodesCode: TIntegerField;
    tCodesLangID: TIntegerField;
    tCodesDescription: TStringField;
    tCodesFielded: TSmallintField;
    tCodesAge: TBooleanField;
    tCodesSex: TBooleanField;
    tCodesDoctor: TBooleanField;
    tCodesAltered: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tCodeTextFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnCodeClick(Sender: TObject);
    procedure btnSpellCheckClick(Sender: TObject);
    procedure cmbLanguageChange(Sender: TObject);
    procedure cbFontsChange(Sender: TObject);
    procedure cbFontSizeChange(Sender: TObject);
    procedure btnLeftJustifyClick(Sender: TObject);
    procedure btnCenterClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure clDBRichCodeBtnFrgnProtectChange(Sender: TObject; StartPos,
      EndPos: Integer; var AllowChange: Boolean);
    procedure clDBRichCodeBtnFrgnSelectionChange(Sender: TObject);
    procedure clDBRichCodeBtnEngEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure clDBRichCodeBtnFrgnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure clDBRichCodeBtnFrgnKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    IsAComment : boolean;
    procedure FindNextToTranslate;
    procedure LoadLanguageCombo;
  public
    { Public declarations }
    procedure SetFrgnFont;
  end;

var
  frmTranslation: TfrmTranslation;
  ChangeFormatOnly : boolean;
  SpanishVowels : integer;

implementation

{$R *.DFM}
uses
  dataMod, DOpenQ, common, Support, Code;

procedure TfrmTranslation.FormCreate(Sender: TObject);
begin
  tCodes.open;
  tCodeText.open;
  tConstants.open;
  IsAComment := false;
  if dmOpenQ.FindTransUponCreate then begin
    dmopenQ.wwt_Qstns.first;
    dmopenQ.wwt_TextBox.first;
    FindNextToTranslate;
  end;
  LoadLanguageCombo;
  SpanishVowels := 0;
end;

procedure TfrmTranslation.LoadLanguageCombo;
var
  i : Word;
begin
  with dmOpenQ.t_Language, cmbLanguage do begin
    Clear;
    DisableControls;
    First;
    Next;  {Skip 'English'}
    for i := 2 to RecordCount do begin
      if fieldbyname('UseLang').asboolean then
        Items.AddObject( fieldbyname('Language').Value,tobject(fieldbyname('LangID').asinteger) );
      Next;
    end;
    if items.count > 0 then
    begin
       if dmOpenQ.CurrentLanguage >-1 then
       begin
         Locate( 'LangID', dmOpenQ.CurrentLanguage, [ ] );
         ItemIndex := Items.IndexOf( fieldbyname('Language').Value );
       end
       else
         ItemIndex := 0;

    end;
    cmbLanguageChange(self);
    if fieldbyname('Dictionary').isnull then
      modSupport.dlgSpell.DictionaryName := ''
    else
      modSupport.dlgSpell.DictionaryName := fieldbyname('Dictionary').Value;
    EnableControls;
  end;
end;

procedure tFrmTranslation.FindNextToTranslate;
var What : char;
  procedure settag(const tagval:integer);
  begin
    tag := tagval;
  end;
begin
 with dmOpenQ do begin
  what := FindNextUntranslated;
  wwT_TransQ.refresh;
  wwT_TransTB.refresh;
  settag(0);
  IsAComment := (upcase(What)='C');
  case what of
    'Q','q','C','c': begin
        clDBRichCodeBtnEng.DataSource := wwds_Qstns;
        clDBRichCodeBtnFrgn.DataSource := wwds_transQ;
        DBTextLangReview.DataSource := wwds_transQ;
        wwt_TransQ.findkey([glbSurveyid,wwt_QstnsID.value,currentLanguage]);
      end;
    'T','t': begin
        clDBRichCodeBtnEng.DataSource := wwds_TextBox;
        clDBRichCodeBtnFrgn.DataSource := wwds_transTB;
        DBTextLangReview.DataSource := wwds_transTB;
        wwt_transtb.findkey([glbSurveyID,wwt_TextBoxID.value,currentLanguage]);
      end;
    else
      begin
        messagedlg('Nothing left to translate!',mtinformation,[mbok],0);
        settag(1);
      end;
  end;
 end;
  if (what='c') or (what='q') or (what='t') then begin
    {a lowercase 'what' indicates a new wwt_Trans record}
    clDBRichCodeBtnEng.SelStart := 0;
    clDBRichCodeBtnEng.SelLength := 1;
    with clDBRichCodeBtnFrgn do begin
      selectall;
      Selattributes.style := clDBRichCodeBtnEng.selattributes.style;
      Selattributes.name := clDBRichCodeBtnEng.selattributes.name;
      Selattributes.size := clDBRichCodeBtnEng.selattributes.size;
      Paragraph.assign(clDBRichCodeBtnEng.Paragraph);
      SelStart := 0;
      SelLength := 0;
    end;
    clDBRichCodeBtnEng.SelLength := 0;
  end;
end;

procedure TfrmTranslation.FormDestroy(Sender: TObject);
begin
  tCodes.close;
  tCodeText.close;
  tConstants.close;
  if dmopenQ.wwt_transQ.State in [dsEdit,dsInsert] then dmopenq.wwt_transQ.post;
  if dmopenQ.wwt_transTB.State in [dsEdit,dsInsert] then dmopenq.wwt_transTB.post;
end;

procedure TfrmTranslation.tCodeTextFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := ((( DataSet[ 'Age' ] = vAge[1] ) OR ( DataSet[ 'Age' ] = Null )) AND
            (( DataSet[ 'Sex' ] = vSex[1] ) OR ( DataSet[ 'Sex' ] = Null )) AND
            (( DataSet[ 'Doctor' ] = vDoc[1] ) OR ( DataSet[ 'Doctor' ] = Null )));
end;

procedure TfrmTranslation.SpeedButton1Click(Sender: TObject);
begin
  if (clDBRichCodeBtnFrgn.datasource.dataset.fieldbyname('bitLangReview').isnull) or (clDBRichCodeBtnFrgn.datasource.dataset.fieldbyname('bitLangReview').asBoolean) then begin
    Label2.color := clLime;
    DBTextLangReview.color := clLime;
    messagebeep(0);
  end else
    FindNextToTranslate;
  dmopenq.wwt_qstns.enablecontrols;
  dmopenq.wwt_TextBox.enablecontrols;
end;

procedure TfrmTranslation.btnCodeClick(Sender: TObject);
begin
  if btnCode.Down then begin
    if vAsText then begin
      clCodeToggle1.text.down := false;
      clCodeToggle1.Text_ClickTransfer(sender);
    end;
    clCodeToggle1.enabled := false;
    frmCode := TfrmCode.Create( Self );
    frmCode.vForm := frmTranslation;
    Hide;
    frmCode.DBGrid1.Datasource := DS_Codes;
    frmCode.Top := ( Screen.Height - frmCode.Height ) div 2;
    if Screen.Width < ( frmCode.Width + Width ) then begin
      frmCode.Left := 2;
      Left := Screen.Width - ( Width + 2 );
    end else begin
      frmCode.Left := ( Screen.Width - frmCode.Width - Width - 4 ) div 2;
      Left := frmCode.Left + frmCode.Width + 4;
    end;
    frmCode.vForm := Self;
    Show;
    frmCode.Show;
  end else begin
    clCodeToggle1.enabled := false;
    frmCode.Close;
  end;
end;

procedure TfrmTranslation.btnSpellCheckClick(Sender: TObject);
begin
  with clDBRichCodeBtnFrgn.datasource.dataset do begin
    if state in [dsInsert,dsEdit] then post;
    if modSupport.dlgSpell.DictionaryName <> '' then
      modsupport.checkme(clDBRichCodeBtnFrgn,clDBRichCodeBtnFrgn.datasource);

    if (modSupport.dlgSpell.DictionaryName = '') or (modSupport.dlgSpell.tag<>mrCancel) then begin
      edit;
      fieldbyname('bitLangReview').value := false;
      post;
      Label2.color := clBtnFace;
      DBTextLangReview.color := clBtnFace;
    end;
  end;
end;

procedure TfrmTranslation.cmbLanguageChange(Sender: TObject);
begin
  with dmOpenQ do begin
    //t_Language.Locate( 'Language', cmbLanguage.Text, [ ] );
    CurrentLanguage := integer(cmbLanguage.Items.Objects[cmbLanguage.ItemIndex]);  //t_Language.fieldbyname('LangID').Value;
//    fieldbyname('Language').value := currentLanguage;
    t_Language.FindKey([CurrentLanguage]);

    if (wwt_transQ.fieldbyname('Language').value = -1)
    and (not wwt_transQ.findkey([glbSurveyID,wwt_QstnsID.value,CurrentLanguage]))  then
    begin
       wwt_transQ.Edit;
       wwt_transQ.fieldbyname('Language').value := CurrentLanguage;
       wwt_transQ.post;
    end;

    if t_Language.fieldbyname('Dictionary').isnull then
      modSupport.dlgSpell.DictionaryName := ''
    else
      modSupport.dlgSpell.DictionaryName := t_Language.fieldbyname('Dictionary').Value;
  end;
  with dmOpenQ,wwt_transQ do
    if clDBRichCodeBtnFrgn.datasource = wwds_transQ then begin
      if not wwt_transQ.findkey([glbSurveyID,wwt_QstnsID.value,CurrentLanguage]) then begin
        Append;
        wwt_TransQSurvey_ID.value := glbSurveyid;
        wwt_TransQSelQstns_ID.value := wwt_QstnsID.value;
        //wwt_TransQQstnCore.value := wwt_QstnsID.value;
        wwt_TransQLanguage.value := CurrentLanguage;

        wwt_TransQPlusMinus.value :=  wwt_QstnsPlusMinus.value;
        wwt_TransQLabel.value :=  wwt_QstnsLabel.value;
        wwt_TransQSection.value :=  wwt_QstnsSection.value;
        wwt_TransQType.value :=  wwt_QstnsType.value;
        wwt_TransQSubsection.value :=  wwt_QstnsSubsection.value;
        wwt_TransQItem.value :=  wwt_QstnsItem.value;
        wwt_TransQSubtype.value :=  wwt_QstnsSubtype.value;
        wwt_TransQScaleID.value :=  wwt_QstnsScaleID.value;
        wwt_TransQWidth.value :=  wwt_QstnsWidth.value;
        wwt_TransQHeight.value :=  wwt_QstnsHeight.value;
        wwt_TransQQstnCore.value :=  wwt_QstnsQstnCore.value;
        wwt_TransQScalePos.value :=  wwt_QstnsScalePos.value;
        wwt_TransQnumMarkCount.value :=  wwt_QstnsnumMarkCount.value;

        wwt_TransQbitLangReview.value :=  true;


        fieldbyname('bitMeanable').value := wwt_QstnsbitMeanable.value;
        fieldbyname('numBubbleCount').value := wwt_QstnsnumBubbleCount.value;

        post;
      end;
    end else begin
      if not wwt_TransTB.findkey([glbSurveyID,wwt_TextBoxID.value,CurrentLanguage]) then begin
        wwt_TransTB.Append;
        wwt_TransTBSurvey_ID.value := glbSurveyid;
        wwt_TransTBID.value := wwt_TextBoxID.value;
        wwt_TransTBLanguage.value := CurrentLanguage;
        wwt_TransTB.post;
      end;
    end;
end;

procedure TfrmTranslation.cbFontsChange(Sender: TObject);
begin
  ChangeFormatOnly := true;
  if cbFonts.itemindex = 0 then clDBRichCodeBtnFrgn.SelAttributes.name := 'Arial';
  if cbFonts.itemindex = 1 then clDBRichCodeBtnFrgn.SelAttributes.name := 'Arial Narrow';
  ActiveControl := clDBRichCodeBtnFrgn;
  ChangeFormatOnly := false;
end;

procedure TfrmTranslation.SetFrgnFont;
begin
  clDBrichCodeBtnEng.SelStart :=1;
  clDBrichCodeBtnEng.SelLength := 1;
  clDBrichCodeBtnFrgn.DefAttributes.name:= clDBrichCodeBtnEng.SelAttributes.name;
  clDBrichCodeBtnFrgn.DefAttributes.size:= clDBrichCodeBtnEng.SelAttributes.size;
end;

procedure TfrmTranslation.cbFontSizeChange(Sender: TObject);
begin
  ChangeFormatOnly := true;
  clDBrichCodeBtnFrgn.SelAttributes.size := cbFontSize.itemindex + 9;
  ActiveControl := clDBRichCodeBtnFrgn;
  ChangeFormatOnly := false;
end;

procedure TfrmTranslation.btnLeftJustifyClick(Sender: TObject);
begin
  clDBRichCodeBtnFrgn.Paragraph.Alignment := taLeftJustify;
end;

procedure TfrmTranslation.btnCenterClick(Sender: TObject);
begin
  clDBRichCodeBtnFrgn.Paragraph.Alignment := taCenter;
end;

procedure TfrmTranslation.FormActivate(Sender: TObject);
begin
  clDBRichCodeBtnFrgnSelectionChange(sender);
  ChangeFormatOnly := false;
end;

procedure TfrmTranslation.clDBRichCodeBtnFrgnProtectChange(Sender: TObject;
  StartPos, EndPos: Integer; var AllowChange: Boolean);
begin
  AllowChange := ChangeFormatOnly;
  if (StartPos+EndPos=0) and (clCodeToggle1.enabled) then begin
    clDBRichCodeBtnFrgn.SelStart := 0;
    clDBRichCodeBtnFrgn.SelLength := 1;
    if clDBRichCodeBtnFrgn.SelText <> '{' then begin
      clDBRichCodeBtnFrgn.SelAttributes.Protected := false;
      clDBRichCodeBtnFrgn.SelAttributes.Color := clBlack;
      AllowChange := true;
    end;
    clDBRichCodeBtnFrgn.SelLength := 0;
  end;
end;

procedure TfrmTranslation.clDBRichCodeBtnFrgnSelectionChange(
  Sender: TObject);
begin
  if clDBRichCodeBtnFrgn.SelAttributes.name = 'Arial' then cbFonts.itemindex := 0;
  if clDBRichCodeBtnFrgn.SelAttributes.name = 'Arial Narrow' then cbFonts.itemindex := 1;
  cbFontsize.itemindex := clDBrichCodeBtnFrgn.SelAttributes.size-9;
end;

procedure TfrmTranslation.clDBRichCodeBtnEngEnter(Sender: TObject);
begin
  Messagebeep(0);
  ActiveControl := clDBRichCodeBtnFrgn;

  with dmOpenQ do
    if clDBRichCodeBtnFrgn.datasource = wwds_transQ then
      wwt_transQ.findkey([glbSurveyID,wwt_QstnsID.value,CurrentLanguage])
    else
      wwt_TransTB.findkey([glbSurveyID,wwt_TextBoxID.value,CurrentLanguage]);
end;

procedure TfrmTranslation.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if btnCode.Down then btnCodeClick(Sender);
  vAsText := false;
  with dmOpenQ.wwT_Qstns do begin
    filtered := true;
    first;
  end;
end;

procedure TfrmTranslation.clDBRichCodeBtnFrgnKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=116) then begin
    if shift=[] then begin
      SpanishVowels := 1;
      Label1.caption  := 'Press a, c, e, i, o, u, n, ? or !';
    end else if shift=[ssAlt] then begin
      SpanishVowels := 2;
      Label1.caption  := 'Press a, e, i, o or u';
    end else if shift=[ssCtrl] then begin
      SpanishVowels := 3;
      Label1.caption  := 'Press a, e, i, o or u';
    end;
  end;
end;

procedure TfrmTranslation.clDBRichCodeBtnFrgnKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key='{') or (key='}') then begin
    messagedlg('Braces "{" & "}" are not allowed!',mterror,[mbok],0);
    key:=' ';
  end else if SpanishVowels=1 then
    case (key) of
      'a' : key := chr(225); // á
      'c' : key := chr(231); // ç
      'e' : key := chr(233); // é
      'i' : key := chr(237); // í
      'o' : key := chr(243); // ó
      'u' : key := chr(250); // ú
      'n' : key := chr(241); // ñ
      '?' : key := chr(191); // ¿
      '!' : key := chr(161); // ¡
      'A' : key := chr(193); // Á
      'C' : key := chr(199); // Ç
      'E' : key := chr(201); // É
      'I' : key := chr(205); // Í
      'O' : key := chr(211); // Ó
      'U' : key := chr(218); // Ú
      'N' : key := chr(209); // Ñ
    end
  else if SpanishVowels=2 then
    case (key) of
      'a' : key := chr(224); // à
      'e' : key := chr(232); // è
      'i' : key := chr(236); // ì
      'o' : key := chr(242); // ò
      'u' : key := chr(249); // ù
      'A' : key := chr(192); // À
      'E' : key := chr(200); // È
      'I' : key := chr(204); // Ì
      'O' : key := chr(210); // Ò
      'U' : key := chr(217); // Ù
    end
  else if SpanishVowels=3 then
    case (key) of
      'a' : key := chr(226); // â
      'e' : key := chr(234); // ê
      'i' : key := chr(238); // î
      'o' : key := chr(244); // ô
      'u' : key := chr(251); // û
      'A' : key := chr(194); // Â
      'E' : key := chr(202); // Ê
      'I' : key := chr(206); // Î
      'O' : key := chr(212); // Ô
      'U' : key := chr(219); // Û
    end;

  SpanishVowels := 0;
  Label1.caption := 'Press F5 for characters (á, ç, ..), Alt-F5 for (à, è, ..) or Ctrl-F5 for (â, ê, ..)';
end;

end.
