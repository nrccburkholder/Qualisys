unit Edit;

{ a tabbed dialog box for creating, modifying, testing and removing quesions

Modifications:
--------------------------------------------------------------------------------
Date        UserID   Description
--------------------------------------------------------------------------------
11-14-2006  GN01     Define ScaleRanking 

12-20-2006  GN02     removed the warning message on scale change

}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Clipbrd,
  Forms, Dialogs, StdCtrls, ExtCtrls, DBTables, DB, Grids, DBGrids, Mask,
  DBCtrls, ComCtrls, Buttons, Spell32, Menus, wwdblook, CDK_Comp, DBRichEdit,
  Wwtable, Wwdatsrc, Wwdbigrd, Wwdbgrid, DBCGrids;

type
  TfrmEdit = class(TForm)
    panHeader: TPanel;
    btnDelete: TSpeedButton;
    pclEdit: TPageControl;
    shtTest: TTabSheet;
    lblLong: TLabel;
    shtQuestion: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label12: TLabel;
    Label27: TLabel;
    btnRelated: TSpeedButton;
    btnFind: TSpeedButton;
    btnNext: TSpeedButton;
    btnFirst: TSpeedButton;
    btnUsage: TSpeedButton;
    btnEditCode: TSpeedButton;
    btnCode: TSpeedButton;
    btnSpell: TSpeedButton;
    btnCancel: TSpeedButton;
    btnClose: TSpeedButton;
    staEditor: TStatusBar;
    btnCategory: TSpeedButton;
    btnScale: TSpeedButton;
    btnTrans: TSpeedButton;
    shtHeading: TTabSheet;
    Label2: TLabel;
    Panel2: TPanel;
    comboHeading: TDBLookupComboBox;
    comboScale: TDBLookupComboBox;
    comboPreceding: TDBLookupComboBox;
    comboFollowing: TDBLookupComboBox;
    comboService: TDBLookupComboBox;
    comboTheme: TDBLookupComboBox;
    lblReportText: TLabel;
    lblReportText2: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    comboHeading2: TDBLookupComboBox;
    Label20: TLabel;
    Panel4: TPanel;
    lblInstructions: TLabel;
    Label22: TLabel;
    detText2: TDBEdit;
    detText: TDBEdit;
    btnHeading: TSpeedButton;
    DBCheckBox15: TDBCheckBox;
    lblModify: TLabel;
    lblAdd: TLabel;
    btnReview: TSpeedButton;
    togEdit: TclCodeToggle;
    rtfText: TclDBRichCodeBtn;
    rtfHead: TclDBRichCode;
    rtfTsHead: TclDBRichCode;
    rtfTsText: TclDBRichCode;
    rtfTsScale: TclDBRichCode;
    dbcbFielded: TDBCheckBox;
    dbcbReview: TDBCheckBox;
    dbcbRestrict: TDBCheckBox;
    dbcbTested: TDBCheckBox;
    dbeDescription: TDBEdit;
    shtScale: TTabSheet;
    Label18: TLabel;
    Label19: TLabel;
    DBText1: TDBText;
    lblReportText3: TLabel;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    comboScale2: TDBLookupComboBox;
    Panel1: TPanel;
    lblDefault: TLabel;
    detText3: TDBEdit;
    DBGrid1: TDBGrid;
    rtfScale: TclDBRichCode;
    Panel10: TPanel;
    DBText2: TDBText;
    DBEdit1: TDBEdit;
    shtCategories: TTabSheet;
    lblReportText4: TLabel;
    detText4: TDBEdit;
    shtNotes: TTabSheet;
    GroupBoxNotes: TGroupBox;
    DBMemoQstnNotes: TDBMemo;
    detText5: TDBEdit;
    lblReportText5: TLabel;
    Label1: TLabel;
    comboLevel: TDBComboBox;
    StaticText1: TStaticText;
    DBCtrlGrid: TDBCtrlGrid;
    comboProblemScore: TDBComboBox;
    editVal: TDBEdit;
    editShort: TDBEdit;
    Panel3: TPanel;
    HeaderControl1: THeaderControl;
    cbProblemScores: TCheckBox;
    cmbScaleRanking: TDBComboBox;
    btnResetProblemScores: TButton;
    cboxMultiResponse: TCheckBox;
    procedure SpellClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure RelatedClick(Sender: TObject);
    procedure UsageClick(Sender: TObject);
    procedure SelCodeClick(Sender: TObject);
    procedure EditCodeClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure SexClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ToggleCodeClick(Sender: TObject);
    procedure AgeClick(Sender: TObject);
    procedure DoctorClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ScaleClick(Sender: TObject);
    procedure FindClick(Sender: TObject);
    procedure FirstClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure RTFEnter(Sender: TObject);
    procedure RTFExit(Sender: TObject);
    procedure CategoryClick(Sender: TObject);
    procedure TransClick(Sender: TObject);
    procedure HeadingClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure PageChange(Sender: TObject);
    procedure ReviewClick(Sender: TObject);
    procedure pclEditChanging(Sender: TObject; var AllowChange: Boolean);
    procedure shtQuestionEnter(Sender: TObject);
    procedure shtHeadingEnter(Sender: TObject);
    procedure shtScaleEnter(Sender: TObject);
    procedure shtTestEnter(Sender: TObject);
    procedure panHeaderDblClick(Sender: TObject);
    procedure DBEdit1Change(Sender: TObject);
    procedure QstnDBControlEnter(Sender: TObject);
    procedure QstnDBControlExit(Sender: TObject);
    procedure QstnDBControlMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure dbcbFieldedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure comboProblemScoreChange(Sender: TObject);
    procedure comboScale2CloseUp(Sender: TObject);
    procedure cbProblemScoresClick(Sender: TObject);
    procedure comboScaleCloseUp(Sender: TObject);
    procedure rtfTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    OverrideReadOnly : boolean;
    procedure SetLabels;
    procedure EditHint(Sender: TObject);
    procedure EditIdle(Sender: TObject; var Done: Boolean);
    procedure InsertProblemScores;
    procedure RemoveProblemScores;
    procedure PopulateRankOrder;
    procedure ChangeScaleData;
  public

  end;

  MultiResponseException = Class(Exception);
  RankSequenceException = Class(Exception);
  RankableScaleException = Class(Exception);

var
  frmEdit: TfrmEdit;

implementation

uses Data, Code, Related, Usage, EditCode, Browse, Common, Lookup,
  Category, Translation, Heading, Support, NewScale;

{$R *.DFM}

{ INITIALIZATION SECTION }

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  OverrideReadOnly := false;
  SetLabels;
  pclEdit.ActivePage := shtQuestion;
  ActiveControl := dbeDescription;


  //GN01
  if modlibrary.tblProblemScores.RecordCount > 1 then
  begin
     PopulateRankOrder; //pre-populate so that you can display the data
     InsertProblemScores;
     //cbProblemScores.checked := true; //We need all problem definition as ScaleRanking information is stored in the same table
  end
  else
  begin
     //cbProblemScores.checked := true;
     InsertProblemScores;
     PopulateRankOrder; //in the case of new problem scores, create the ranking list again
     cmbScaleRanking.ItemIndex := 0;
  end;
  //cbProblemScores.checked := modLibrary.ProblemScoresDefined; GN01
end;

{ sets various status and instruction labels:
    1. set 'added by' and 'edited by' labels
    2. set the 'default to if missing scale value' label }

procedure TfrmEdit.SetLabels;
var
  s : string;
begin
  with modLibrary do
  begin
    lblAdd.Caption := 'Added by ' + wtblQuestionAddedBy.Value + ' on ' + formatdatetime('m/d/yyyy',wtblQuestionAddedOn.AsDateTime) +'      ';
    if wtblQuestionModifiedBy.IsNull then
      lblAdd.Caption := lblAdd.caption + 'Unaltered to date'
    else
      lblAdd.Caption := lblAdd.caption + 'Edited by ' + wtblQuestionModifiedBy.Value
         + ' on ' + formatdatetime('m/d/yyyy',wtblQuestionModifiedOn.AsDateTime);
    lblDefault.Caption := 'No responses are considered missing values.';
    with tblValues do begin
      DisableControls;
      try
        First;
        s := '';
        while (not eof) and (tblValuesScale.value = tblScaleScale.value) do begin
          if tblValuesMissing.Value then
            s := s + '"'+ tblValuesShort.Value + '", ';
          Next;
        end;
        if s <> '' then
          lblDefault.caption := copy(s,1,length(s)-2) + ' values are treated as missing.';
      finally
        First;
        EnableControls;
      end;
    end;
  end;
end;

{ ACTIVATION SECTION }

procedure TfrmEdit.FormActivate(Sender: TObject);
begin
  Application.OnHint := EditHint;
  Application.OnIdle := EditIdle;
  with modLibrary do
  begin
    tblScale.MasterSource := wsrcQuestion;
    tblHeading.MasterSource := wsrcQuestion;
  end;
end;

procedure TfrmEdit.EditHint(Sender: TObject);
begin
  staEditor.Panels[ 4 ].Text := Application.Hint;
end;

procedure TfrmEdit.EditIdle(Sender: TObject; var Done: Boolean);
begin
  with modLibrary do
    btnCancel.Enabled := ( wtblQuestion.State <> dsBrowse ) or ( wtblQstnText.State <> dsBrowse );
end;

{ PAGE/TAB SECTION }

procedure TfrmEdit.PageChange(Sender: TObject);
begin
  with modLibrary.wtblQstnText do
    if ( pclEdit.ActivePage = shtTest ) and ( State <> dsBrowse ) then Post;
  with modLibrary.wtblQuestion do
    if ( pclEdit.ActivePage = shtTest ) and ( State <> dsBrowse ) then Post;
end;

{ BUTTON SECTION }

procedure TfrmEdit.SpellClick(Sender: TObject);
begin
  with dettext.datasource.dataset do if modified then post;
  with rtftext.datasource.dataset do if modified then post;
  if modLibrary.wtblQuestionFielded.Value = 0 then
    with modSupport do
      case pclEdit.ActivePage.PageIndex of
        0 : begin // Edit Question
              checkme(detText,detText.datasource,true,false);
              checkme(rtfText,rtftext.datasource,false,true);
            end;
        1 : checkme(detText2,detText2.dataSource,true,true); // Select Heading
        2 : checkme(detText3,detText3.dataSource,true,true); // Select Scale
        4 : checkme(detText4,detText4.dataSource,true,true); // Problem Scores
        5 : checkme(detText5,detText5.dataSource,true,true); // Notes
      end;
end;

procedure TfrmEdit.DeleteClick(Sender: TObject);
begin
  if modLibrary.DeleteQuestion then Close;
end;

procedure TfrmEdit.RelatedClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    frmRelated := TfrmRelated.Create( Self );
    with frmRelated do
    try
      ShowModal;
    finally
      Application.OnHint := EditHint;
      Release;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmEdit.UsageClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    frmUsage := TfrmUsage.Create( Self );
    with frmUsage do
    try
      ShowModal;
    finally
      Application.OnHint := EditHint;
      Release;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmEdit.SelCodeClick(Sender: TObject);
begin
  if vAsText then begin            {DG}
    vAsText := False;              {DG}
    rtfText.UpdateRichText(cText); {DG}
  end;                             {DG}
  if btnCode.Down then
  begin
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
      Show;
      frmCode.Show;
    finally
      Screen.Cursor := crDefault;
    end;
  end
  else
    frmCode.Close;
end;

procedure TfrmEdit.EditCodeClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    frmCodeEdit := TfrmCodeEdit.Create( Self );
    with frmCodeEdit do
    try
      { call GoToCode }
      ShowModal;
    finally
      Release;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmEdit.CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEdit.CancelClick(Sender: TObject);
begin
  with modLibrary do
  begin
    wtblQstnText.Cancel;
    wtblQuestion.Cancel;
  end;
end;

procedure TfrmEdit.ToggleCodeClick(Sender: TObject);
begin
  if vAsText then
    staEditor.Panels[ 0 ].Text := 'TEXT'
  else
    staEditor.Panels[ 0 ].Text := 'CODE';
end;

procedure TfrmEdit.SexClick(Sender: TObject);
begin
  staEditor.Panels[ 1 ].Text := UpperCase( vSex );
end;

procedure TfrmEdit.AgeClick(Sender: TObject);
begin
  staEditor.Panels[ 2 ].Text := UpperCase( vAge );
end;

procedure TfrmEdit.DoctorClick(Sender: TObject);
begin
  staEditor.Panels[ 3 ].Text := UpperCase( vDoc );
end;

procedure TfrmEdit.ScaleClick(Sender: TObject);
var orgScale : integer;
    EditState : boolean;
begin
  Screen.Cursor := crHourGlass;
  try
    orgScale := modlibrary.tblScaleScale.value;
    frmNewScale := TfrmNewScale.Create( Self );
    with frmNewScale do
    try
      modlibrary.tblscale.mastersource := nil;
      ShowModal;
    finally
      if (orgScale <> modlibrary.tblScaleScale.value) and
         (messagedlg('You ended up on a different scale in the Scale Editor.  '+
          'Do you want to use "'+modlibrary.tblScaleLabel.value+'" for this question?',
          mtconfirmation,[mbyes,mbNo],0)=mrYes) then begin
        EditState := (modlibrary.wtblQuestion.state in dsEditModes);
        if not EditState then modlibrary.wtblQuestion.edit;
        modlibrary.wtblquestionScale.value := modlibrary.tblScaleScale.value;
        if not EditState then modlibrary.wtblQuestion.post;
      end;
      modlibrary.tblscale.mastersource := modlibrary.wsrcQuestion;
      Application.OnHint := EditHint;
      Release;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmEdit.FindClick(Sender: TObject);
begin
  with modLibrary, modSupport do
  begin
    dlgLocate.DataSource := wsrcQuestion;
    dlgLocate.SearchField := 'Short';
    dlgLocate.Caption := 'Locate Question';
    OverrideReadOnly := false;
    if dlgLocate.Execute then
    begin
      btnFirst.Enabled := True;
      btnNext.Enabled := True;
    end;
  end;
end;

procedure TfrmEdit.FirstClick(Sender: TObject);
begin
  OverrideReadOnly := false;
  modSupport.dlgLocate.FindFirst;
  btnFirst.Enabled := False;
end;

procedure TfrmEdit.NextClick(Sender: TObject);
begin
  OverrideReadOnly := false;
  btnNext.Enabled := modSupport.dlgLocate.FindNext;
end;

procedure TfrmEdit.CategoryClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    frmCategory := TfrmCategory.Create( Self );
    with frmCategory do
    try
      ShowModal;
    finally
      Application.OnHint := EditHint;
      Release;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmEdit.TransClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    frmTranslate := TfrmTranslate.Create( Self );
    with frmTranslate do
    try
      ShowModal;
    finally
      Application.OnHint := EditHint;
      Release;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmEdit.HeadingClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    frmHeading := TfrmHeading.Create( Self );
    with frmHeading do
    try
      ShowModal;
    finally
      Application.OnHint := EditHint;
      Release;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

{ move to the next question tagged for review:
    1. if not set, set review table to QuestionText.DB and filter for review and language
    2. move to current question in review table
    3. find subsequent quesiton matching criteria in review table
    4. move question table to match review table }

procedure TfrmEdit.ReviewClick(Sender: TObject);
begin
  with modLibrary, modLookup.tblReview do
  begin
    if ( TableName <> 'QuestionText' ) and ( Pos( '=', Filter ) = 0 ) then
    begin
      Close;
      TableName := 'QuestionText';
      Filter := 'Review AND ( LangID = 1 )';
      Open;
      GoToCurrent( wtblQstnText );
    end;
    if not FindNext then
      if not FindFirst then
        if MessageDlg( 'There are no more Questions in English to be Reviewed',
          mtInformation, [ mbOK ], 0 ) = mrOK then Exit;
    wtblQuestion.Locate( 'Core', FieldByName( 'Core' ).Value, [ ] );
  end;
end;

{ COMPONENT HANDLERS SECTION }

{ UpdateInsertBtn enables the insert button on the Insert Code dialog (if it is open) when
  the focus is in a control that can accept code insertions (RichEdits) }

procedure TfrmEdit.RTFEnter(Sender: TObject);
begin
  modLibrary.UpdateInsertBtn( True );
end;

procedure TfrmEdit.RTFExit(Sender: TObject);
begin
  modLibrary.UpdateInsertBtn( False );
end;

{ FINALIZATION SECTION }

{ removes table configuration supporting the Edit dialog box and marks questions to review }

procedure TfrmEdit.FormClose(Sender: TObject; var Action: TCloseAction);

var
   i, rank, seq, index: Integer;
   s : string;
   slRank : TStringList;
   MultiResponse : Boolean;

   procedure checkRankSeq;
   var
      k : integer;
   begin
      if slRank.Count>0 then
      begin
         seq := 0;
         for k := 0 to slRank.Count-1 do
         begin
            Inc(seq);
            if not slRank.Find(IntToStr(seq),index) then
               raise RankSequenceException.Create('Missing Rank=' + IntToStr(seq) + '. The rank order is not in sequence');

         end;
      end;
   end;

begin
  //Hide;
  with modLibrary do begin
    if tblProblemScores.Modified then tblProblemScores.Post;
    //gn01: if cbProblemScores.Checked then begin
      libraryquery('select min(problem_score_flag) as minFlag, max(problem_score_flag) as maxFlag '+
                   'from ProblemScores '+
                   'where core='+wtblQuestionCore.AsString, false);
      if (ww_Query.FieldByName('minflag').value=-1) and (ww_Query.FieldByName('maxflag').value>-1) then begin
        pclEdit.ActivePage := shtCategories;
        messagedlg('Either all problem scores should be set to (undefined) or none should be.'+#13+
                   'Use n/a for responses that are neither problems or positives.',mterror,[mbok],0);
        Action := caNone;
        exit;
      end;

      //GN01
      MultiResponse := tblScaleMarkCount.Value <> 1;
      cboxMultiResponse.checked := MultiResponse;

      libraryquery('select ScaleRanking, val '+
                   'from ProblemScores '+
                   'where core='+wtblQuestionCore.AsString + ' order by ScaleRanking', false);
      slRank := TStringList.Create;
      slRank.Sorted := True;
      slRank.Duplicates  := dupError;
      seq := 0;
      rank := -1;
      try
         with ww_Query do
         begin
            try
               while not EOF do
               begin
                  rank := FieldByName('ScaleRanking').AsInteger;

                  //check for rankable scale
                  if (FieldByName('val').AsInteger < 0) and (rank > -1) then
                     raise RankableScaleException.Create('Scale values that are treated as missing should not be rankable <rank=' +IntToStr(rank)+'>.');                  

                  //check for duplicates
                  if rank > -1 then
                     slRank.Add(IntToStr(rank));

                  //no ranking for multi-response
                  if (MultiResponse) and (Rank <> -1) then
                     raise MultiResponseException.Create('Ranking should be -1 for multiple response question.');

                  Next;
               end;

               //check for missing sequence
               checkRankSeq;
            except
               on E:EStringListError do
               begin
                  MessageDlg('Scale ranking <rank=' + IntToStr(rank) + '> cannot have duplicate values',mtError,[mbok],0);
                  Action := caNone;
                  Exit;
               end;
               on E:MultiResponseException do
               begin
                  MessageDlg(E.Message,mtError,[mbok],0);
                  Action := caNone;
                  Exit;
               end;
               on E:RankSequenceException do
               begin
                  MessageDlg(E.Message,mtError,[mbok],0);
                  Action := caNone;
                  Exit;
               end;
               on E:RankableScaleException do
               begin
                  MessageDlg(E.Message,mtError,[mbok],0);
                  Action := caNone;
                  Exit;
               end;


               on E:Exception do
               begin
                  MessageDlg(E.Message,mtError,[mbok],0);
               end;
            end;
         end;
      finally
         slRank.Free ;
      end;
    //end;
  end;
  pclEdit.activepage := shtHeading;
  pclEdit.activepage := shtQuestion;
  with modLibrary do
  try
    if wtblQuestion.Modified or wtblQstnText.Modified then begin
      if wtblQstnText.Modified then begin
        wtblQstnText.Post;
        if not (wtblquestion.State in [dsEdit,dsInsert]) then
          wtblquestion.edit;
        s := '';
        if rtfText.lines.count>0 then
          for i := 0 to rtfText.lines.count-1 do
            s := s + rtfText.lines[i] + ' ';
        wtblQuestionFullText.value := s;
      end;
      (*
      if vMarkReview then
        with wtblQstnText do begin
          DisableControls;
          while not EOF do begin
            if wtblQstnTextLangID.value <> 1 then begin
              Edit;
              wtblQstnTextReview.Value := True;
              post;
            end;
            Next;
          end;
          First;
          EnableControls;
        end;
      *)
      if wtblQuestion.Modified then
        wtblQuestion.Post
      else
        wtblQuestion.Refresh;
      //vMarkReview := False;
    end;
    if tblScaleFielded.value = 0 then begin
      tblScale.edit;
      tblScaleFielded.value := 1;
      tblScale.post;
    end;
    if tblHeadingFielded.value = 0 then begin
      tblHeading.edit;
      tblHeadingFielded.value := 1;
      tblHeading.post;
    end;
    tblScale.MasterSource := nil;
    tblHeading.MasterSource := nil;
    if tblProblemScores.Modified then
        tblProblemScores.Post
    else
        tblProblemScores.Refresh;
  except  { move Some stuff down; are we getting to formActivate ?? }
    on EDatabaseError do
    begin
      Action := caNone;
      Show;
      Raise;
    end;
  end;
  Application.OnIdle := nil;
end;

procedure TfrmEdit.pclEditChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  {messagedlg('Before change',mtinformation,[mbok],0);}
  if vAsText then begin
    togEdit.tag := 1;
    rtftext.showasCode;
    rtfhead.showasCode;
    rtfscale.showascode;
    rtftstext.showasCode;
    rtftshead.showasCode;
    rtftsscale.showascode;
  end else
    togEdit.tag := 0;
end;

procedure TfrmEdit.shtQuestionEnter(Sender: TObject);
begin
  btncode.enabled := true;
  {messagedlg('After change',mtinformation,[mbok],0);}
  if togEdit.tag = 1 then begin
    rtfHead.showasText;
    rtfText.showasText;
    rtfscale.showasText;
    rtftsHead.showasText;
    rtftsText.showasText;
    rtftsscale.showasText;
    togEdit.tag := 0;
  end;
end;

procedure TfrmEdit.shtHeadingEnter(Sender: TObject);
begin
  shtquestionenter(sender);
  btncode.enabled := false;
end;

procedure TfrmEdit.shtScaleEnter(Sender: TObject);
begin
  shtquestionenter(sender);
  btncode.enabled := false;
end;

procedure TfrmEdit.shtTestEnter(Sender: TObject);
begin
  shtquestionenter(sender);
  btncode.enabled := false;
end;

procedure TfrmEdit.panHeaderDblClick(Sender: TObject);
begin
  if width = 669 then
    Width := 528
  else
    Width := 669;

end;

procedure TfrmEdit.DBEdit1Change(Sender: TObject);
begin
  setlabels;
end;

procedure TfrmEdit.QstnDBControlEnter(Sender: TObject);
begin
  modlibrary.wsrcQuestion.Autoedit := true;
end;

procedure TfrmEdit.QstnDBControlExit(Sender: TObject);
begin
  with modlibrary.wsrcQuestion do
    if dataset.fieldbyname('Fielded').value<>0 then begin
      if dataset.state <> dsBrowse then dataset.post;
      Autoedit := false;
    end;
end;

procedure TfrmEdit.QstnDBControlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  modlibrary.wsrcQuestion.Autoedit := true;
end;

procedure TfrmEdit.dbcbFieldedMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var cnt: integer;
    s : string;
    sl:tStringList;
    doit:boolean;
begin
  if dbcbfielded.state <> cbUnchecked then begin
    //cnt := fileage(aliaspath('Question')+'\TemplateUsage.db');
    //if (now()-filedatetodatetime(cnt)) > 1.0 then
    //  messagedlg('Useage data hasn''t been reloaded since '+datetimetostr(filedatetodatetime(cnt)),mtinformation,[mbok],0);
    Screen.Cursor := crHourGlass;
    with modlibrary.ww_Query do begin
      close;
      databasename := 'dbQualPro';
      sql.clear;
      sql.add('select s.strparam_value+''.''+d.strparam_value as strDatabase ' +
              'from qualpro_params s, qualpro_params d ' +
              'where s.STRPARAM_NM=''ScanServer'' ' +
              'and d.STRPARAM_NM=''ScanDatabase''');
      open;
      s := fieldbyname('strDatabase').asstring;
      close;
      sql.clear;
      sql.add('select qstnCore,count(*) as cnt from '+s+'.dbo.bubblepos where qstncore='+dbText2.field.AsString+' group by qstncore');
      open;
      cnt := fieldbyname('cnt').asinteger;
      close;
      //databasename := 'QstnLib';
      sql.clear;
      //sql.add('select Client,Study,Survey from templateusage where qstncore='+dbText2.field.AsString);
      sql.add('select c.strClient_nm as Client, s.strStudy_nm as Study, sd.strSurvey_nm as Survey');
      sql.add('from sel_qstns sq, survey_def sd, study s, client c');
      sql.add('where sq.subtype=1 and sq.qstncore='+dbText2.field.AsString+' and sq.survey_id=sd.survey_id');
      sql.add(' and sd.study_id=s.study_id and s.client_id=c.client_id');
      open;
      Screen.Cursor := crDefault;
      if (cnt>0) then begin
        sl := tstringlist.create;
        sl.add('This question can''t be unfielded.  The above surveys have used this question.');
        sl.add('Furthermore, '+inttostr(cnt)+' fielded surveys have this question on them.');
        modlibrary.ViewData(tdataset(modlibrary.ww_Query),SL);
        sl.free;
      end else begin
        if (recordcount>0) then begin
          sl := tstringlist.create;
          sl.add('The above surveys have used this question.  However, no fielded surveys have this question on them.');
          sl.add('');
          sl.add('If you intend to make changes to this question, notify the teams for the above listed projects and ');
          sl.add('have them delete this question off their survey and then add it back.  This way the change will be ');
          sl.add('reflected on their survey.');
          modlibrary.ViewData(tdataset(modlibrary.ww_Query),SL);
          sl.free;
          s := modlibrary.wtblQuestionCore.asstring + ' - ' + modlibrary.wtblquestionshort.asstring+#13+#10+'Client,Study,Survey';
          first;
          while not eof do begin
            s := s + #13 + #10 + fieldbyname('Client').asstring+','+fieldbyname('Study').asstring+','+fieldbyname('Survey').asstring;
            next;
          end;
          clipboard.AsText := s;
          doit := (messagedlg('This question isn''t used on any surveys that have been fielded. '+
            ' However, it appears on at least one layout definition and it might'+
            ' be used on surveys that have been saved as templates.  If you'+
            ' unfield this question and make changes, these changes will NOT be'+
            ' reflected on the surveys that already have this question.  The list of'+
            ' surveys that use this question have been copied to the clipboard. '+
            ' Are you sure you want to unfield this question?',mtwarning,[mbyes,mbno],0) = mrYes);
        end else begin
          modlibrary.ViewData(tdataset(modlibrary.ww_Query),nil);
          doit := (messagedlg('This question isn''t used on any surveys that have been saved to the server. '+
            ' Are you sure you want to unfield this question?',mtwarning,[mbyes,mbno],0) = mrYes);
        end;
        if doit then begin
          if dbcbFielded.DataSource.DataSet.state <> dsEdit then
            dbcbFielded.DataSource.DataSet.edit;
          dbcbFielded.Field.Value := false;
        end;
      end;
      close;
    end;
  end;
end;

procedure TfrmEdit.comboProblemScoreChange(Sender: TObject);
var orgstate : tDataSetState;
    i : string;
begin
  with modlibrary.tblProblemScores do begin
    orgState := state;
    if orgState <> dsEdit then
       edit;
    if fieldbyname('transferred').value = 2 then
      fieldbyname('transferred').value := 1;

    i := comboproblemscore.items.Strings[comboproblemscore.itemindex];

    if i='Problem' then fieldbyname('problem_score_flag').value := 1
    else if i='Positive' then fieldbyname('problem_score_flag').value := 0
    else if i='n/a' then fieldbyname('problem_score_flag').value := 9
    else fieldbyname('problem_score_flag').value := -1;
    if orgState <> dsEdit then
       post;
  end;
end;

procedure tFrmEdit.InsertProblemScores;
var
  Save_Cursor:TCursor;
Begin
  Save_Cursor := Screen.Cursor;
  Screen.Cursor := crHourglass;    { Show hourglass cursor }
  try
    modlibrary.InsertProblemScores;
    DBCtrlGrid.Refresh;
  finally
    Screen.Cursor := Save_Cursor;  { Always restore to normal }
  end;
end;

procedure tFrmEdit.RemoveProblemScores;
var
  Save_Cursor:TCursor;
Begin
  Save_Cursor := Screen.Cursor;
  Screen.Cursor := crHourglass;    { Show hourglass cursor }
  try
    cbProblemScores.checked := modlibrary.RemoveProblemScores;
    if cbProblemScores.checked then
      messagedlg('Some problem score designations have already been transferred to the datamart.  '+
        'Please contact the help desk to make any changes.',mterror,[mbok],0);
    DBCtrlGrid.Refresh;
  finally
    Screen.Cursor := Save_Cursor;  { Always restore to normal }
  end;
end;


//GN01: Assign new scale
procedure TfrmEdit.ChangeScaleData;
begin
  //Scale/problemscores cannot be changed once its fielded
  if (dbcbfielded.state = cbUnchecked) then
     //and (MessageDlg('Problem scores will be affected by the scale change. Continue?', mtConfirmation, [mbYes,mbNo],0) = mrYes) //GN02: commented out this warning as the librarian thoughts it was annoying
  begin
     //reset the problem scores if they have been transferred to datamart
     modLibrary.ResetProblemScores;
     RemoveProblemScores;

     //Assign the new scale
     InsertProblemScores;
     PopulateRankOrder;
     cmbScaleRanking.ItemIndex := 0;
  end;
end;

procedure TfrmEdit.comboScale2CloseUp(Sender: TObject);
Begin
  //GN01: if cbProblemScores.checked then InsertProblemScores;
  ChangeScaleData;
end;

procedure TfrmEdit.cbProblemScoresClick(Sender: TObject);
begin
//GN01
{  if cbProblemScores.checked then
      InsertProblemScores
  else
      RemoveProblemScores;
}
end;

procedure TfrmEdit.comboScaleCloseUp(Sender: TObject);
begin
  //GN01:if cbProblemScores.checked then InsertProblemScores;
  ChangeScaleData;
end;

procedure TfrmEdit.rtfTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not modLibrary.wsrcQstnText.autoedit then begin
     if (OverrideReadOnly) or (messagedlg('This question is already fielded.  You shouldn''t edit it unless you''re fixing a typo or otherwise understand what surveys this will impact.  Do you want to edit it?', mtconfirmation, [mbYes,mbNo],0) = mrYes) then begin
       rtftext.ReadOnly := false;
       modLibrary.wsrcQstnText.autoedit := true;
       OverrideReadOnly := true;
     end;
  end;

end;

//GN01: Populate the combobox based on the number of problem scores
procedure TfrmEdit.PopulateRankOrder;
var
   cnt,i : Integer;
begin
   cnt := modlibrary.tblProblemScores.RecordCount;
   cmbScaleRanking.Items.Clear ;
   cmbScaleRanking.Items.add('-1'); //-1=n/a,  0= (undefined)
   //cmbScaleRanking.ItemIndex := 0;
   for i := 1 to Cnt do
   begin
      cmbScaleRanking.Items.Add(IntToStr(i));
   end;
end;

procedure TfrmEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (ssAlt in Shift) and ((Key = Ord('v')) or  (Key = Ord('V'))) then
   begin
      btnResetProblemScores.Visible := True;
      cboxMultiResponse.Visible := True;
   end;
end;

end.
