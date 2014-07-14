unit Data;

{ main data module for the question library

Modifications:
--------------------------------------------------------------------------------
Date        UserID   Description
--------------------------------------------------------------------------------
11-03-2005  GN01     When you delete a question which has ProblemScores defined,
                     the link in ProblemScores table still existed after the delete.
                     So when the user tries to copy a new Question, the new coreid
                     gets re-used which then re-establishes the link back to the
                     ProblemScores table.

03-27-2006  GN02     When you edit a question that has translation, the record
                     is positioned to the last row in the table.
                     Example if you are editing a Quesiton in English and switch
                     to "Test Personalization" tab, Spanish Question is displayed
                     instead of the English Question.

11-21-2006  GN03     An admin reset for problem scores.
                     Added ScaleRankingImport

}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, DBGrids, Spell32, Wwlocate, Wwtable, Wwdatsrc, Menus, ComCtrls,
  Wwquery, DBRichEdit;

const
  {Scale Type}
  stBubble = 1;
  stICR = 2;
  {UserRights}
  urNormal = 1;
  urTranslator = 2;

type
  TmodLibrary = class(TDataModule)
    srcValues: TDataSource;
    srcScale: TDataSource;
    tblValues: TTable;
    tblScale: TTable;
    tblService: TTable;
    srcService: TDataSource;
    tblCode: TTable;
    srcCode: TDataSource;
    tblScaleScale: TAutoIncField;
    tblScaleMean: TBooleanField;
    tblCodeCode: TAutoIncField;
    tblCodeDescription: TStringField;
    tblCodeText: TTable;
    srcCodeText: TDataSource;
    tblCodeTextCode: TIntegerField;
    tblConstant: TTable;
    srcConstant: TDataSource;
    tblConstantConstant: TStringField;
    tblServiceServID: TAutoIncField;
    tblServiceService: TStringField;
    srcTheme: TDataSource;
    tblTheme: TTable;
    tblThemeThemID: TAutoIncField;
    tblThemeTheme: TStringField;
    tblConstantValue: TStringField;
    tblCodeTextText: TStringField;
    tblScaleRight: TBooleanField;
    wsrcQuestion: TwwDataSource;
    wsrcUsage: TwwDataSource;
    wsrcRecode: TwwDataSource;
    wtblRecode: TwwTable;
    dbSurvey: TDatabase;
    wtblQstnText: TwwTable;
    wsrcQstnText: TwwDataSource;
    wtblQstnTextText: TBlobField;
    wtblQstnTextReview: TBooleanField;
    wtblQstnTextLangID: TIntegerField;
    wsrcHeadText: TwwDataSource;
    wtblHeadText: TwwTable;
    wtblHeadTextHeadID: TIntegerField;
    wtblHeadTextLangID: TIntegerField;
    wtblHeadTextReview: TBooleanField;
    tblCodeLangID: TIntegerField;
    tblCodeAge: TBooleanField;
    tblCodeSex: TBooleanField;
    tblCodeDoctor: TBooleanField;
    wqryClient: TwwQuery;
    tblScaleFielded: TSmallintField;
    tblCodeFielded: TSmallintField;
    wqryUsage: TwwQuery;
    wqryUsageTotal: TIntegerField;
    srcScaleText: TwwDataSource;
    tblScaleText: TwwTable;
    tblScaleTextScale: TIntegerField;
    tblScaleTextLangID: TIntegerField;
    tblScaleTextReview: TBooleanField;
    tblScaleTextText: TBlobField;
    tblScaleRTF: TTable;
    srcScaleRTF: TDataSource;
    tblUser: TTable;
    srcTransH: TDataSource;
    srcTransQ: TDataSource;
    srcTransS: TDataSource;
    tblTransH: TTable;
    tblTransQ: TTable;
    tblTransS: TTable;
    tblLanguage: TwwTable;
    srcLanguage: TwwDataSource;
    tblLanguageLangID: TAutoIncField;
    tblLanguageLanguage: TStringField;
    tblLanguageDictionary: TStringField;
    tblScaleLabel: TStringField;
    tblHeading: TwwTable;
    tblHeadingHeadID: TAutoIncField;
    tblHeadingName: TStringField;
    tblHeadingFielded: TSmallintField;
    srcHeading: TwwDataSource;
    tblHeadingReview: TBooleanField;
    wtblHeadTextText: TBlobField;
    wtblQuestion: TwwTable;
    wtblQuestionDescription: TStringField;
    wtblQuestionFielded: TSmallintField;
    wtblQuestionScale: TIntegerField;
    wtblQuestionShort: TStringField;
    wtblQuestionHeadID: TIntegerField;
    wtblQuestionAddedBy: TStringField;
    wtblQuestionAddedOn: TDateField;
    wtblQuestionModifiedBy: TStringField;
    wtblQuestionModifiedOn: TDateField;
    wtblQuestionServID: TIntegerField;
    wtblQuestionThemID: TIntegerField;
    wtblQuestionRestrict: TBooleanField;
    wtblQuestionLabel: TStringField;
    wtblQuestionHeading: TStringField;
    wtblQuestionTheme: TStringField;
    wtblQuestionService: TStringField;
    wtblQuestionPreced: TStringField;
    wtblQuestionFollow: TStringField;
    wtblQuestionReview: TBooleanField;
    wtblQuestionUsage: TIntegerField;
    tblMap: TTable;
    wtblUsage: TwwTable;
    wtblUsageSurvey_ID: TIntegerField;
    wtblUsageSurvey: TStringField;
    wtblUsageClient: TStringField;
    wtblUsageUsed: TDateField;
    wtblQuestionLanguages: TStringField;
    wtblQuestionTested: TBooleanField;
    wtblQuestionCore: TIntegerField;
    wtblQuestionFollowedBy: TIntegerField;
    wtblQuestionPrecededBy: TIntegerField;
    wtblQstnTextCore: TIntegerField;
    wtblRecodeCore: TIntegerField;
    wtblRecodeRecode: TIntegerField;
    tblScaleWidth: TIntegerField;
    tblScaleMarkCount: TIntegerField;
    tblScaleTextItem: TSmallintField;
    tblValuesScale: TIntegerField;
    tblValuesItem: TIntegerField;
    tblValuesType: TSmallintField;
    tblValuesBubbleValue: TSmallintField;
    tblValuesCharSet: TSmallintField;
    tblValuesShort: TStringField;
    tblValuesMissing: TBooleanField;
    tblScalePosition: TStringField;
    wtblQuestionNotes: TMemoField;
    wtblQuestionLevel: TSmallintField;
    wtblQuestionParent: TIntegerField;
    tblValuesOrder: TSmallintField;
    tblCodeTextAge: TStringField;
    tblCodeTextSex: TStringField;
    tblCodeTextDoctor: TStringField;
    dbQualPro: TDatabase;
    ww_Query: TwwQuery;
    BatchMove: TBatchMove;
    tblCodeAltered: TIntegerField;
    tblCodeTextAltered: TIntegerField;
    wqryUsageCore: TIntegerField;
    wtblUsageCore: TIntegerField;
    wtblQuestionFullText: TStringField;
    t_TemplateUsage: TTable;
    tblProblemScores: TTable;
    srcProblemScores: TDataSource;
    tblProblemScoresCore: TIntegerField;
    tblProblemScoresVal: TIntegerField;
    tblProblemScoresProblem_Score_Flag: TIntegerField;
    tblProblemScoresStrProblemScore: TStringField;
    tblProblemScoresShort: TStringField;
    tblProblemScoresTransferred: TSmallintField;
    dbDataMart: TDatabase;
    tblProblemScoresScaleRanking: TIntegerField;
    procedure QuestionMainDataChange(Sender: TObject; Field: TField);
    procedure QuestionNewRecord(DataSet: TDataSet);
    procedure QstnTextDataChange(Sender: TObject; Field: TField);
    procedure CodeTextAfterInsert(DataSet: TDataSet);
    procedure QuestionCalcFields(DataSet: TDataSet);
    procedure CodeStateChange(Sender: TObject);
    procedure CodeBeforeDelete(DataSet: TDataSet);
    procedure CodeDataChange(Sender: TObject; Field: TField);
    procedure ValuesNewRecord(DataSet: TDataSet);
    procedure LangNewRecord(DataSet: TDataSet);
    procedure LanguageBeforePost(DataSet: TDataSet);
    procedure LibraryCreate(Sender: TObject);
    procedure UserAfterOpen(DataSet: TDataSet);
    procedure LanguageFilter(DataSet: TDataSet; var Accept: Boolean);
    procedure QuestionAfterEdit(DataSet: TDataSet);
    procedure HeadingBeforeDelete(DataSet: TDataSet);
    procedure HeadTextBeforeInsert(DataSet: TDataSet);
    procedure ValuesBeforeDelete(DataSet: TDataSet);
    procedure ScaleBeforeDelete(DataSet: TDataSet);
    procedure ValuesAfterInsert(DataSet: TDataSet);
    procedure ScaleDataChange(Sender: TObject; Field: TField);
    procedure CodeTextBeforeInsert(DataSet: TDataSet);
    procedure LanguageBeforeDelete(DataSet: TDataSet);
    procedure ServiceBeforeDelete(DataSet: TDataSet);
    procedure ThemeBeforeDelete(DataSet: TDataSet);
    procedure CodeTextBeforeDelete(DataSet: TDataSet);
    procedure ConstantBeforeDelete(DataSet: TDataSet);
    procedure RecodeBeforeDelete(DataSet: TDataSet);
    procedure HeadingDataChange(Sender: TObject; Field: TField);
    procedure TextChange(Sender: TField);
    procedure TransDataChange(Sender: TObject; Field: TField);
    procedure QuestionBeforeDelete(DataSet: TDataSet);
    procedure ValuesBeforeInsert(DataSet: TDataSet);
    procedure tblCodeFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure tblServiceFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure tblThemeFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure tblValuesTypeStringGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure tblScalePositionGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure tblScalePositionSetText(Sender: TField; const Text: String);
    procedure tblValuesTypeGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure tblValuesTypeSetText(Sender: TField; const Text: String);
    procedure tblValuesCharSetGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure tblValuesCharSetSetText(Sender: TField; const Text: String);
    procedure tblScaleAfterPost(DataSet: TDataSet);
    procedure tblScaleFieldedGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure wtblQuestionLevelGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure wtblQuestionLevelSetText(Sender: TField; const Text: String);
    procedure wtblQuestionShortChange(Sender: TField);
    procedure wtblHeadTextAfterPost(DataSet: TDataSet);
    procedure wtblHeadTextTextChange(Sender: TField);
    procedure wtblQstnTextTextChange(Sender: TField);
    procedure tblScaleTextTextChange(Sender: TField);
    procedure wtblQstnTextAfterPost(DataSet: TDataSet);
    procedure tblScaleTextAfterPost(DataSet: TDataSet);
    procedure tblCodeTextAfterEdit(DataSet: TDataSet);
    procedure tblCodeAfterEdit(DataSet: TDataSet);
  private
    vHeadTextReview : boolean;
    vQuestionTextReview : boolean;
    vScaleTextReview : boolean;
    //procedure FindMaxValue;
    //procedure updateCodeTables;
    SavePlace: TBookmark;
  public
    vValue : Integer;                // stores the highest scale value for next new
    EnvName : string;
    BaseDir : string;
    UserRights : integer;
    function SurveyDB(const fn:string):boolean;
    function DeleteQuestion:boolean;
    procedure UpdateInsertBtn( vEnable : Boolean );
    procedure ViewData(var ds:tDataset; const s:tStringList);
    procedure LibraryQuery(const Qry:string; const Exe:boolean);
    procedure InsertProblemScores;
    function RemoveProblemScores:boolean;
    function ProblemScoresDefined:boolean;
    procedure UpdateDataMartProblemScores;
    procedure ImportScaleRanking;
    function ResetProblemScores:boolean;
  end;

var
  modLibrary: TmodLibrary;

implementation

Uses Code, Common, Support, EditCode, Lookup, Browse, Recode, Edit, Related,
  Category, Heading, Translation, fViewData;

{$R *.DFM}

{ INITIALIZATION SECTION }

{ opens all tables necessary for initial browse screen to function:
    1. adds the password needed to open the user table }

(*
procedure TmodLibrary.updateCodeTables;
begin
    modlookup.tblCodeText.close;
    tblConstant.close;
    tblCodeText.close;
    tblCode.close;
    with ww_Query do begin
      close;
      databasename := 'dbQstnLib';
      sql.clear;
      sql.add('delete from Codes');
      execsql;
      databasename := 'dbQualPro';
      sql.clear;
      sql.add('select c.code, c.Langid, c.description, c.fielded,ct.age,ct.sex,ct.doctor');
      sql.add('from codes c, (select a.code, age, sex, doctor from');
      sql.add('(select code, 1 as age from codestext where age <> '' '' group by code');
      sql.add('union ');
      sql.add('select code, 0 as age from codestext where age = null group by code) A,');
      sql.add('(select code, 1 as sex from codestext where sex <> '' '' group by code');
      sql.add('union');
      sql.add('select code, 0 as sex from codestext where sex = null group by code) S,');
      sql.add('(select code, 1 as doctor from codestext where doctor <> '' '' group by code');
      sql.add('union');
      sql.add('select code, 0 as doctor from codestext where doctor = null group by code) D');
      sql.add('where a.code=s.code and a.code=d.code) ct');
      sql.add('where c.code=ct.code');
      open;
    end;
    with batchmove do begin
      source := ww_Query;
      destination := TblCode;
      mappings.clear;
      mappings.add('Code');
      mappings.add('LangID');
      mappings.add('Description');
      mappings.add('Fielded');
      mappings.add('Age');
      mappings.add('Sex');
      mappings.add('Doctor');
      Execute;
    end;
    with ww_Query do begin
      close;
      databasename := 'dbQstnLib';
      sql.clear;
      sql.add('delete from CodeText');
      execsql;
      databasename := 'dbQualPro';
      sql.clear;
      sql.add('Select Code, Age, Sex, Doctor, Text from CodesText');
      open;
    end;
    with batchmove do begin
      source := ww_Query;
      destination := TblCodeText;
      mappings.clear;
      mappings.add('Code');
      mappings.add('Age');
      mappings.add('Sex');
      mappings.add('Doctor');
      mappings.add('Text');
      Execute;
    end;
    with ww_Query do begin
      close;
      databasename := 'dbQstnLib';
      sql.clear;
      sql.add('delete from Constants');
      execsql;
      databasename := 'dbQualPro';
      sql.clear;
      sql.add('Select Tag, tag_dsc from Tag');
      open;
    end;
    with batchmove do begin
      source := ww_Query;
      destination := TblConstant;
      mappings.clear;
      mappings.add('Constant=Tag');
      mappings.add('Value=Tag_dsc');
      Execute;
    end;
    ww_Query.close;
    tblConstant.Open;
    tblCodeText.Open;
    tblCode.Open;
    modlookup.tblCodeText.open;
end;
*)

procedure TmodLibrary.LibraryQuery(const Qry:string; const Exe:boolean);
begin
  if EXE then begin
    with TWWQuery.Create(self) do
      try
        close;
        databasename := modLookup.dbQstnlib.databasename;
        sql.clear;
        sql.add(qry);
        ExecSQL;
      finally
        free;
      end;
  end else
    with ww_Query do begin
      close;
      databasename := modLookup.dbQstnlib.databasename;
      sql.clear;
      sql.add(qry);
      open;
    end;
end;

procedure TmodLibrary.ViewData(var ds:tDataset; const s:tStringList);
begin
  frmViewData := TfrmViewData.Create( Self );
  with frmViewData do
  try
    memo1.lines.clear;
    if s <> nil then
      memo1.lines.addstrings(s);
    datasource1.dataset := ds;
    caption := ds.name;
    showmodal;
  finally
    Release;
  end;
end;

procedure TmodLibrary.LibraryCreate(Sender: TObject);
begin
  Session.AddPassword( 'Dave' );
  Session.AddPassword( '(uU\`rlvLHh4Au]' );
  vValue := 1;
  vHeadTextReview := false;
  vQuestionTextReview := false;
  vScaleTextReview := false;
  try
    //updateCodeTables;
    tblUser.Open;
    tblUser.Close;
    wqryUsage.Open;
    wtblRecode.Open;
    tblMap.Open;
    wtblQstnText.Open;
    tblLanguage.Open;
    tblHeading.Open;
    wtblHeadText.Open;
    tblScale.Open;
    tblValues.Open;
    tblScaleText.Open;
    tblService.Open;
    tblTheme.Open;
    wtblQuestion.Open;
    tblScaleRTF.Open;
    tblConstant.Open;
    tblCodeText.Open;
    tblCode.Open;
    tblProblemScores.Open;
  except
    on E:EDatabaseError do
    begin
      MessageDlg( 'Unable to open required table(s). ' + E.Message, mtError, [ mbOK ], 0 );
      Application.Terminate;
    end;
  end;
  Session.Removeallpasswords;
end;

{ GENERAL SECTION }

{ enables the insert code button on various forms if the code form is running
  (this is called by the form with the button on it: Edit, Heading, Scale, Translate) }

procedure TmodLibrary.UpdateInsertBtn( vEnable : Boolean );
var
  i : Integer;
begin
  for i := 0 to Pred( Screen.FormCount ) do
    if Screen.Forms[ i ].Name = 'frmCode' then
      frmCode.btnInsertCode.Enabled := vEnable;
end;

{ sets review to true if editing changes are made to heading, question or scale text
  (called by every editable rich edit's OnChange event) }

procedure TmodLibrary.TextChange( Sender: TField );
begin
  wtblQuestion.tag := 1;
  vMarkReview := true;
  (*
  with Sender.DataSet do
    if State = dsEdit then begin
      DisableControls;
      try
        while not EOF do begin
          if fieldbyname('LangID').value <> 1 then begin
            Edit;
            FieldByName( 'Review' ).Value := True;
            Post;
          end;
          next;
        end;
        First;
      finally
        EnableControls;
      end;
    end;
  *)
end;

{ TRANSLATION }

{ disallows edting of fielded translations (questions, headings, scales);
  called by various datasources of the above
  also sets review to true if translation text is edited }

procedure TmodLibrary.TransDataChange(Sender: TObject; Field: TField);
{ var
  vSource : TDataSource; }
begin
(*
  if Field = nil then              { need to disable editing of text if fielded!!
  begin
    vSource := ( Sender as TDataSource );
    vSource.AutoEdit :=
       ((( vSource.DataSet ) as TTable ).MasterSource.DataSet.FieldByName( 'Fielded' ).Value = 0 );
  end  }
  else if ( Field.FieldName = 'Text' ) and ( Field.DataSet.State = dsEdit ) then
    Field.DataSet.FieldByName( 'Review' ).Value := True;
*)
end;

{ QUESTION }

{ when adding a new record to question, set core, user adding and default service and theme
  to none }

procedure TmodLibrary.QuestionNewRecord(DataSet: TDataSet);
begin
  GenerateCore( modLookup.tblQuestion );
  DataSet[ 'Core' ] := vNewCore;
  DataSet[ 'AddedBy' ] := GetUser;
  DataSet[ 'HeadID' ] := 0;
  DataSet[ 'ServID' ] := 0;
  DataSet[ 'ThemID' ] := 0;
  DataSet[ 'Scale' ] := 1;
  DataSet[ 'Fielded' ] := 0;
  DataSet[ 'Short' ] := 'New question';
  DataSet[ 'RestrictQuestion' ] := false;
  Dataset.post;
  dataset.edit;
end;

{ question data change (scroll) method for the browse screen:
    1. set button states
    2. check to see if recode button has been pushed (execute recode if yes)
    3. disallow editing of fielded questions }

procedure TmodLibrary.QuestionMainDataChange(Sender: TObject; Field: TField);
begin
  if Field = nil then
    with frmLibrary do
    begin
      SetGoToButtons( wtblQuestionPrecededBy.IsNull, wtblQuestionFollowedBy.IsNull );
      if userrights <> urTranslator then begin
        btnEditRecode.Enabled := not wtblRecodeCore.IsNull;
        btnDelete.Enabled := ( wtblQuestionFielded.Value = 0 ) and ( wtblQuestion.RecordCount > 0 );
        btnUsage.Enabled := ( wtblQuestionUsage.Value > 0 );
        //if btnRecode.Down then StartRecode;
      end;
    end;
    wsrcQuestion.AutoEdit := ( wtblQuestionFielded.Value = 0 );
    wsrcQstnText.AutoEdit := wsrcQuestion.AutoEdit;
end;

{ calculate review value displayed in the browse screen }

procedure TmodLibrary.QuestionCalcFields(DataSet: TDataSet);
var rvw : string[1];
begin
  with modLookup do begin
    DataSet[ 'Review' ] := ( tblQstnText.Locate( 'Core', wtblQuestionCore.Value, [ ] ) or
        tblScaleText.Locate( 'Scale', wtblQuestionScale.Value, [ ] ) or
        tblHeadText.Locate( 'HeadID', wtblQuestionHeadID.Value, [ ] ));

    with tblQstnText do begin
      filter := 'LangID <> 1';
      dataset[ 'Languages' ] := '';
      if Locate( 'Core', wtblQuestionCore.Value, [ ] ) then
        while (not eof) and (fieldbyname('Core').Value = wtblQuestionCore.Value) do begin
          if Fieldbyname('Review').asboolean  then rvw := '*' else rvw := '';
          if tblLanguage.Locate( 'LangID', Fieldbyname('LangID').Value, [ ]) then
            DataSet[ 'Languages' ] := DataSet[ 'Languages' ] + tblLanguageLanguage.AsString + Rvw + ' '
          else
            DataSet[ 'Languages' ] := DataSet[ 'Languages' ] + '{' + Fieldbyname('LangID').AsString + Rvw + '}';
          next;
        end;
      filter := 'Review';
    end;
  end;
end;

{ if a question is edited, set the modified fields }

procedure TmodLibrary.QuestionAfterEdit(DataSet: TDataSet);
begin
  DataSet[ 'ModifiedBy' ] := GetUser;
  DataSet[ 'ModifiedOn' ] := Date;
end;

{ Deletes a question from the library:
    1. checks if other question reference it (warning, offer list)
    2. removes all of references noted in (1)
    3. deletes all question text detail records
    4. deletes question }

function TmodLibrary.DeleteQuestion:boolean;
var
  vCount : Word;
begin
  result := true;
  modLookup.tblQuestion.GoToCurrent( wtblQuestion );
  vCount := GetRelatedCount( wtblQuestionCore.Value, False, modLookup.tblRecode, modLookup.tblQuestion );
  if vCount > 0 then        { see common unit for GetRelatedCount }
    case MessageDlg( 'The question selected to delete, ' + wtblQuestionDescription.Value
        + ', is associated with ' + IntToStr( vCount ) + ' other question(s). ' +
        'Display a list of the associated question(s)?', mtInformation, mbYesNoCancel, 0 ) of
      mrCancel : result := false;
      mrYes    : begin
                   frmRelated := TfrmRelated.Create( Application );
                   with frmRelated do
                   try
                     vDelete := True;
                     ShowModal;
                     if ModalResult = mrCancel then result := false;
                   finally
                     Release;
                   end;
                 end;
      mrNo     : if MessageDlg( 'Deleting this question will remove all references to '
                     + 'it made by other question(s). Continue with deletion?',
                     mtConfirmation, [ mbYes, mbNo ], 0 ) = mrNo then
                   result := false;
                 else
                   GetRelatedCount( wtblQuestionCore.Value, True, modLookup.tblRecode, modLookup.tblQuestion );
    end
  else
    if MessageDlg( 'Delete Record?', mtConfirmation, [ mbYes, mbNo ], 0 ) <> mrYes then result := false;
  if result then
    wtblQuestion.Delete;
end;

{ cascade deletes }

procedure TmodLibrary.QuestionBeforeDelete(DataSet: TDataSet);
begin
  with wtblQstnText do begin
    first;
    while not EOF do Delete;
  end;
  RemoveProblemScores; //GN01
end;

{ QUESTION TEXT }

{ question text OnDataChange event
    1. if scrolling, disallow editing of fielded questions
    2. if editing text, mark review as true }

procedure TmodLibrary.QstnTextDataChange(Sender: TObject; Field: TField);
begin
  if Field = nil then
  begin
    wsrcQuestion.AutoEdit := ( wtblQuestionFielded.Value = 0 );
    wsrcQstnText.AutoEdit := wsrcQuestion.AutoEdit;
  end
  else if ( Field = wtblQstnTextText ) and ( wtblQstnText.State = dsEdit ) then
    vMarkReview := True;
end;

{ CODE }

{ code state change event (only when code edting form is open) }

procedure TmodLibrary.CodeStateChange(Sender: TObject);
begin
  frmCodeEdit.btnSave.Enabled := ( Sender as TDataSource ).State <> dsBrowse;
end;

{ restrict deletes }

procedure TmodLibrary.CodeBeforeDelete(DataSet: TDataSet);
begin
  if tblCodeFielded.value <> 0 then begin
    MessageDlg( 'Used codes are not subject to deletion.', mtWarning, [ mbOK ], 0 );
    Abort;
  end;
end;

{ after scrolling, disallow editing of fielded codes }

procedure TmodLibrary.CodeDataChange(Sender: TObject; Field: TField);
begin
  if Field = nil then
  begin
    srcCode.AutoEdit := ( tblCodeFielded.Value = 0 );
    srcCodeText.AutoEdit := srcCode.AutoEdit;
  end;
end;

{ CODE TEXT }

{ disallow adding new records to table if vLockCodeRows is set
  (this ensures can't add rows to codeText grid on code editing form manually) }

procedure TmodLibrary.CodeTextAfterInsert(DataSet: TDataSet);
begin
  if vLockCodeRows and ( DataSet.RecordCount > 0 ) then DataSet.Cancel;
end;

{ ensures the auto increment is set in code before adding records to code text }

procedure TmodLibrary.CodeTextBeforeInsert(DataSet: TDataSet);
begin
  if tblCodeCode.IsNull then tblCode.Post;
end;

{ restrict deletes }

procedure TmodLibrary.CodeTextBeforeDelete(DataSet: TDataSet);
begin
  if tblCodeFielded.value <> 0 then begin
    MessageDlg( 'Used codes are not subject to modification.', mtWarning, [ mbOK ], 0 );
    Abort;
  end;
end;

{ HEADING SECTION }

{ after scrolling, disallow editing of fielded headings }

procedure TmodLibrary.HeadingDataChange(Sender: TObject; Field: TField);
begin
  if Field = nil then
  begin
    srcHeading.AutoEdit := ( tblHeadingFielded.Value = 0 );
    wsrcHeadText.AutoEdit := srcHeading.AutoEdit;
  end;
end;

{ cascade deteles to headText detail table }

procedure TmodLibrary.HeadingBeforeDelete(DataSet: TDataSet);
begin
  if modLookup.tblQuestion.Locate( 'HeadID', DataSet[ 'HeadID' ], [ ] ) then
  begin
    MessageDlg( '''' + DataSet[ 'Name' ] + ''' cannot be deleted while it is referenced ' +
          'by a Question.', mtWarning, [ mbOK ], 0 );
    Abort;
  end
  else
    with wtblHeadText do
    begin
      DisableControls;
      while not EOF do Delete;
      EnableControls;
    end;
end;

{ HEADTEXT }

{ ensure Heading autoincrement is set before adding child records in HeadText }

procedure TmodLibrary.HeadTextBeforeInsert(DataSet: TDataSet);
begin
  with tblHeading do if State <> dsBrowse then Post;
end;

{ SCALE SECTION }

{ on scroll, disallows editing of fielded Scales, sets the default scale value to 1 }

procedure TmodLibrary.ScaleDataChange(Sender: TObject; Field: TField);
begin
  if Field = nil then
  begin
    srcScale.AutoEdit := ( tblScaleFielded.Value = 0 );
    srcValues.AutoEdit := srcScale.AutoEdit;
    srcScaleText.AutoEdit := srcScale.AutoEdit;
    vValue := 1;
  end;
end;

{ cascade deletes }

procedure TmodLibrary.ScaleBeforeDelete(DataSet: TDataSet);
begin
  if modLookup.tblQuestion.Locate( 'Scale', DataSet[ 'Scale' ], [ ] ) then begin
    MessageDlg( '''' + DataSet[ 'Label' ] + ''' cannot be deleted while it is referenced ' +
          'by a Question.', mtWarning, [ mbOK ], 0 );
    Abort;
  end else
    with tblValues do begin
      DisableControls;
      while not EOF do Delete;
      EnableControls;
    end;
end;

{ SCALE VALUES }

{ increments the next scale value after last one is done }

procedure TmodLibrary.ValuesAfterInsert(DataSet: TDataSet);
begin
  {vValue := Succ( tblValuesValue.Value );}
end;

{ checks the next scale value before inserting it }

procedure TmodLibrary.ValuesBeforeInsert(DataSet: TDataSet);
begin
  {FindMaxValue;}
end;

{ sets global vValue to the next increment for adding a new Scale Value;
  this method should be revised to perform more sophisticated checking }

(*
procedure TmodLibrary.FindMaxValue;
var
  vOrigin : TBookmarkStr;
begin
  with tblValues do
  begin
    vOrigin := Bookmark;
    DisableControls;
    try
      while Locate( 'Value', vValue, [ ] ) do Inc( vValue );
    finally
      Bookmark := vOrigin;
      EnableControls;
    end;
  end;
end;
*)

procedure TmodLibrary.ValuesNewRecord(DataSet: TDataSet);
begin
  {DataSet[ 'Value' ] := vValue;}
end;

{ cascade deletes }

procedure TmodLibrary.ValuesBeforeDelete(DataSet: TDataSet);
begin
  with tblScaleText do begin
    DisableControls;
    first;
    while not EOF do Delete;
    EnableControls;
  end;
end;

{ LANGUAGE SECTION }

{ used by serveral tables in the OnNewRecord event to generate correct language ID
  (called by text tables: QstnText, HeadText, ScaleText, CodeText) }

procedure TmodLibrary.LangNewRecord(DataSet: TDataSet);
begin
  DataSet[ 'LangID' ] := vLanguage;
end;

{ filters for single language (called by HeadText, QstnText, ScaleText and CodeText) }

procedure TmodLibrary.LanguageFilter(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := ( DataSet[ 'LangID' ] = vLanguage );
end;

{ adds any new language to the translate language combo box and the browse menu }

procedure TmodLibrary.LanguageBeforePost(DataSet: TDataSet);
begin
  frmTranslate.cmbLanguage.Items.Add( tblLanguageLanguage.Value );
end;

{ restrict deletes }

procedure TmodLibrary.LanguageBeforeDelete(DataSet: TDataSet);
begin
  with modLookup do
    if ( tblQstnText.Locate( 'LangID', DataSet[ 'LangID' ], [ ] ) or
         tblScaleText.Locate( 'LangID', DataSet[ 'LangID' ], [ ] ) or
         tblHeadText.Locate( 'LangID', DataSet[ 'LangID' ], [ ] ) or
         tblCode.Locate( 'LangID', DataSet[ 'LangID' ], [ ] ) ) then
    begin
      MessageDlg( '''' + DataSet[ 'Language' ] + ''' cannot be deleted while it is referenced ' +
          'by a Question, Heading, Scale or Code.', mtWarning, [ mbOK ], 0 );
      Abort;
    end;
end;

{ USER SECTION }

procedure TmodLibrary.UserAfterOpen(DataSet: TDataSet);
var UserID,Password : string;
begin
  if not tblUser.Locate( 'User', UpperCase( GetUser ), [ ] ) then begin
    { Splash.Hide; }
    MessageDlg( 'You are not registered as a QualPro Question Library user.'
        + #13#10 + 'See the Library Administrator for access rights.',
        mtWarning, [ mbOK ], 0 );
    Application.Terminate;
  end else
    UserRights := tblUser.fieldbyname('rights').asinteger;
  if UserRights=0 then UserRights:=1;
  if tblUser.Locate('User','USERID&PASSWORD',[]) then begin
    UserID := tblUser.fieldbyname('Name').value;
    Password := tblUser.fieldbyname('Name').value;
    delete(UserID,pos(';',UserID),length(UserID));
    delete(Password,1,pos(';',Password));
    dbQualPro.params.add('USER NAME='+UserID);
    dbQualPro.params.add('PASSWORD='+password);
  end;
  if tblUser.Locate('User','DATAMART_UID&PW',[]) then begin
    UserID := tblUser.fieldbyname('Name').value;
    Password := tblUser.fieldbyname('Name').value;
    delete(UserID,pos(';',UserID),length(UserID));
    delete(Password,1,pos(';',Password));
    dbDataMart.params.add('USER NAME='+UserID);
    dbDataMart.params.add('PASSWORD='+password);
  end;
  if tblUser.Locate('User','ENVIRONMENTNAME',[]) then begin
    EnvName := tblUser.fieldbyname('Name').value;
    with ww_Query do begin
      close;
      databasename := 'dbQualPro';
      sql.clear;
      sql.add('select strParam_value from QualPro_params where strParam_nm=''EnvName'' and strParam_grp=''Environment''');
      open;
      if fieldbyname('strParam_value').value <> EnvName then begin
        MessageDlg('SQL Environment ('+fieldbyname('strParam_value').value+
            ') doesn''t match Paradox Environment ('+EnvName+').  Please '+
            'notify Tech Services.',mterror,[mbok],0);
        Application.Terminate;
      end;
    end;
  end else begin
    MessageDlg('Environment (ENVIRONMENTNAME) isn''t registered in Paradox '+
        'Tables.  Please notify Tech Services.',mterror,[mbok],0);
    Application.Terminate;
  end;
  if tblUser.Locate('User','TEMPLATEBASEDIR',[]) then begin
    BaseDir := extractfiledir(tblUser.fieldbyname('Name').value);
    if basedir[length(basedir)]<>'\' then basedir := basedir + '\';
  end else
    BaseDir := '';
end;

{ SERVICE SECTION }

{ restrict deletes }

procedure TmodLibrary.ServiceBeforeDelete(DataSet: TDataSet);
begin
  if modLookup.tblQuestion.Locate( 'ServID', DataSet[ 'ServID' ], [ ] ) then
  begin
    MessageDlg( '''' + DataSet[ 'Service' ] + ''' cannot be deleted while it is referenced ' +
          'by a Question.', mtWarning, [ mbOK ], 0 );
    Abort;
  end;
end;

{ THEME SECTION }

{ restrict deletes }

procedure TmodLibrary.ThemeBeforeDelete(DataSet: TDataSet);
begin
  if modLookup.tblQuestion.Locate( 'ThemID', DataSet[ 'ThemID' ], [ ] ) then
  begin
    MessageDlg( '''' + DataSet[ 'Theme' ] + ''' cannot be deleted while it is referenced ' +
          'by a Question.', mtWarning, [ mbOK ], 0 );
    Abort;
  end;
end;

{ CONSTANTS SECTION }

{ prevent deletes }

procedure TmodLibrary.ConstantBeforeDelete(DataSet: TDataSet);
begin
  MessageDlg( 'Constants are not subject to deletion.', mtWarning, [ mbOK ], 0 );
  Abort;
end;

{ RECODE SECTION }

{ cascade deletes }

procedure TmodLibrary.RecodeBeforeDelete(DataSet: TDataSet);
begin
  with tblMap do while not EOF do Delete;
end;

procedure TmodLibrary.tblCodeFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := ( DataSet[ 'LangID' ] = vLanguage );
end;

procedure TmodLibrary.tblServiceFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  accept := dataset['ServID'] > 0;
end;

procedure TmodLibrary.tblThemeFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  accept := dataset['ThemID'] > 0;
end;

procedure TmodLibrary.tblValuesTypeStringGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if tblValuesType.value = stBubble then Text := 'Bubble'
  else                                   Text := 'ICR';
end;

procedure TmodLibrary.tblScalePositionGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if tblScaleRight.value then text := 'Right' else text := 'Below';
end;

procedure TmodLibrary.tblScalePositionSetText(Sender: TField;
  const Text: String);
begin
  tblScaleRight.value := (text = 'Right');
end;

procedure TmodLibrary.tblValuesTypeGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if tblValuesType.value = stBubble then Text := 'Bubble'
  else                                   Text := 'ICR';
end;

procedure TmodLibrary.tblValuesTypeSetText(Sender: TField;
  const Text: String);
begin
  if lowercase(Text) = 'icr' then tblValuesType.value := stICR
  else tblValuestype.value := stBubble;
end;

procedure TmodLibrary.tblValuesCharSetGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if tblValuesType.value = stBubble then
    Text := 'N/A'
  else begin
    if tblValuesCharSet.value = 3 then Text := 'Alph/Num'
    else if tblValuesCharSet.value = 2 then Text := 'Alpha'
    else Text := 'Num';
  end;
end;

procedure TmodLibrary.tblValuesCharSetSetText(Sender: TField;
  const Text: String);
begin
  if (lowercase(Text)='alpha/numeric') or (lowercase(Text)='alph/num') then
    tblValuesCharset.value := 3
  else if (lowercase(text)='alpha') then
    tblValuesCharset.value := 2
  else
    tblValuescharset.value := 1;
end;

procedure TmodLibrary.tblScaleAfterPost(DataSet: TDataSet);
begin
  if (tblValues.MasterFields='Scale') and
      (tblValuesScale.value <> tblScaleScale.value) then begin
{
    tblScaleText.append;
    tblScaleTextScale.value := tblScaleScale.value;
    tblScaleTextItem.value := 1;
    tblScaleTextLangID.value := 1;
    tblScaleTextReview.value := False;
    tblScaleText.post;
}
    tblValues.append;
    tblValuesScale.value := tblScaleScale.value;
    tblValuesItem.value := 1;
    tblValuesType.value := stBubble;
    tblValuesBubbleValue.value := 1;
    tblValuesCharSet.value := 1;
    tblValuesMissing.value := false;
    tblValuesOrder.value := 1;
    tblValuesShort.value := '';
{    tblValues.post; }
  end;
end;

procedure TmodLibrary.tblScaleFieldedGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if tblScaleFielded.value = 0 then text := 'False' else text := 'True';
end;

procedure TmodLibrary.wtblQuestionLevelGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  case sender.asInteger of
    1 : text := 'Key';
    2 : text := 'Core';
    3 : text := 'Drill down';
    4 : text := 'Behavioral';
  else
    text := 'No level defined';
  end;
end;

procedure TmodLibrary.wtblQuestionLevelSetText(Sender: TField;
  const Text: String);
begin
  if uppercase(text) = 'KEY' then
    sender.value := 1
  else if uppercase(text) = 'CORE' then
    sender.value := 2
  else if uppercase(text) = 'DRILL DOWN' then
    sender.value := 3
  else if uppercase(text) = 'BEHAVIORAL' then
    sender.value := 4
  else
    sender.value := 0;
end;

procedure TmodLibrary.wtblQuestionShortChange(Sender: TField);
begin
  wtblQuestion.tag := 1;
end;

procedure TmodLibrary.wtblHeadTextAfterPost(DataSet: TDataSet);
begin
  if vHeadTextReview and (wtblHeadText.MasterSource=srcHeading) then begin
    vHeadTextReview := false;
    SavePlace := wtblHeadText.GetBookmark; //GN02
    wtblHeadText.first;
    while not wtblHeadText.eof do begin
      if wtblHeadTextLangID.value <> 1 then begin
        wtblHeadText.edit;
        wtblHeadTextReview.value := true;
        wtblHeadText.post;
      end;
      wtblHeadText.next;
    end;
    wtblHeadText.GotoBookmark(SavePlace);
    wtblHeadText.FreeBookmark(SavePlace);
  end;
  vHeadTextReview := false;
end;

procedure TmodLibrary.wtblHeadTextTextChange(Sender: TField);
begin
  vHeadTextReview := true;
end;

procedure TmodLibrary.wtblQstnTextTextChange(Sender: TField);
begin
  vQuestionTextReview := true;
end;

procedure TmodLibrary.tblScaleTextTextChange(Sender: TField);
begin
  vScaleTextReview := true;
end;

procedure TmodLibrary.wtblQstnTextAfterPost(DataSet: TDataSet);
begin
  if vQuestionTextReview and (wtblQstnText.MasterSource=wsrcQuestion) then begin
    vQuestionTextReview := false;
    SavePlace := wtblQstnText.GetBookmark; //GN02
    wtblQstnText.first;
    while not wtblQstnText.eof do begin
      if wtblQstnTextLangID.value <> 1 then begin
        wtblQstnText.edit;
        wtblQstnTextReview.value := true;
        wtblQstnText.post;
      end;
      wtblQstnText.next;
    end;
    wtblQstnText.GotoBookmark(SavePlace);
    wtblQstnText.FreeBookmark(SavePlace);
  end;
  vQuestionTextReview := false;
end;

procedure TmodLibrary.tblScaleTextAfterPost(DataSet: TDataSet);
begin
  if vScaleTextReview and (tblScaleText.MasterSource=srcValues) then begin
    vScaleTextReview := false;
    SavePlace := tblScaleText.GetBookmark; //GN02
    tblScaleText.first;
    while not tblScaleText.eof do begin
      if tblScaleTextLangID.value <> 1 then begin
        tblScaleText.edit;
        tblScaleTextReview.value := true;
        tblScaleText.post;
      end;
      tblScaleText.next;
    end;
    tblScaleText.GotoBookmark(SavePlace);
    tblScaleText.FreeBookmark(SavePlace);
  end;
  vScaleTextReview := false;
end;

procedure TmodLibrary.tblCodeTextAfterEdit(DataSet: TDataSet);
begin
  if (tblCodeText.mastersource <> nil) and (tblCodeFielded.value = 1) then
    tblCodeText.cancel;
end;

procedure TmodLibrary.tblCodeAfterEdit(DataSet: TDataSet);
begin
  if tblCodeFielded.value = 1 then tblCode.cancel;
end;

function TmodLibrary.SurveyDB(const fn:string):boolean;
var tmptbl : tTable;
begin
  tmptbl := tTable.create(self);
  try
    with tmptbl do begin
      close;
      Databasename := ExtractFilePath(fn);
      TableName := ExtractFileName(fn);
      Open;
      with fieldDefs do
        if (indexOf('Survey_ID') >= 0) and
           (indexOf('ID') >= 0) and
           (indexOf('Language') >= 0) and
           (indexOf('Section') >= 0) and
           (indexOf('Type') >= 0) and
           (indexOf('Label') >= 0) and
           (indexOf('PlusMinus') >= 0) and
           (indexOf('Subsection') >= 0) and
           (indexOf('Item') >= 0) and
           (indexOf('X') >= 0) and
           (indexOf('Y') >= 0) and
           (indexOf('Width') >= 0) and
           (indexOf('Height') >= 0) and
           (indexOf('RichText') >= 0) and
           (indexOf('MiscInt1') >= 0) and
           (indexOf('MiscInt2') >= 0) and
           (indexOf('MiscBool1') >= 0) and
           (indexOf('MiscBool2') >= 0) and
           (indexOf('MiscInt3') >= 0) and
           (indexOf('MiscInt4') >= 0) and
           (indexOf('MiscInt5') >= 0) and
           (indexOf('Bitmap') >= 0) then
           result := true
        else
          result := false;
      close;
    end;
  finally
    tmptbl.free;
  end;
end;

function TmodLibrary.ProblemScoresDefined:boolean;
begin
    with TWWQuery.Create(self) do
      try
        close;
        databasename := modLookup.dbQstnlib.databasename;
        sql.clear;
        sql.add('select count(*) as cnt from problemscores where core=' +wtblQuestionCore.asstring);
        open;
        ProblemScoresDefined := fieldbyname('cnt').value > 0;
        close;
      finally
        free;
      end;
end;

procedure TmodLibrary.InsertProblemScores;
var s : string;
    core,scale : string;
begin
   core := wtblQuestionCore.asstring;
   scale := wtblQuestionScale.AsString;
    with TWWQuery.Create(self) do
      try
        close;
        databasename := modLookup.dbQstnlib.databasename;
//        sql.clear;
//        sql.add('delete from problemscores where problem_score_flag=-1 and transferred=0 and core='+core);
//        ExecSQL;

        sql.clear;
        sql.add('update problemscores ps ' +
                'set ps.short = (' +
                    'select sv.short ' +
                    'from scalevalues sv ' +
                    'where sv.scale=' + scale +
                    ' and ps.val=sv.BubbleValue) '+
                'where ps.core='+core+
                ' and ps.val in (select bubblevalue from scalevalues where scale='+scale+')');
        ExecSQL;

        {transferred values: 0=never been transferred to datamart, 1=has been updated since last transfer to datamart, 2=unchanged
        since last transfer to datamart.  What's up with "transferred=transferred*0.5" ?  we're programatically updating the value
        of strProblemScore if it doesn't match problem_score_flag.  If we're changing something that has already been transferred
        to the datamart (i.e. transferred=1 or 2), the new transferred value should be 1.  if we're changing something that has
        never been transferred to the datamart (i.e. transferred=0), the new transferred value should be 0.  by multiplying
        transferred by 0.5, a 2 becomes a 1, a 1 stays 1 (because the 0.5 rounds up to 1) and a 0 stays a 0. }
        sql.clear;
        sql.add('update problemscores set strProblemScore="Positive", transferred=transferred*0.5 where problem_score_flag=0 and core='+core+' and strProblemScore<>"Positive"');
        ExecSQL;

        sql.clear;
        sql.add('update problemscores set strProblemScore="Problem", transferred=transferred*0.5 where problem_score_flag=1 and core='+core+' and strProblemScore<>"Problem"');
        ExecSQL;

        sql.clear;
        sql.add('update problemscores set strProblemScore="n/a", transferred=transferred*0.5 where problem_score_flag=9 and core='+core+' and strProblemScore<>"n/a"');
        ExecSQL;

        sql.clear;
        sql.add('update problemscores set strProblemScore="(undefined)", transferred=transferred*0.5 where problem_score_flag not in (0,1,9) and core='+core+' and strProblemScore<>"(undefined)"');
        ExecSQL;

        sql.clear;
        sql.add('select bubblevalue as Val, Short ' +
                'from scalevalues ' +
                'where scale='+scale+' ' +
                'and bubblevalue not in (select val from problemscores where core='+core+')');
        open;
        while not eof do begin
          s := fieldbyname('Short').value;
          while pos('''',s)>0 do
            s[pos('''',s)] := chr(0);

          while pos(chr(0),s)>0 do begin
            myinsert('''''',s,pos(chr(0),s));
            mydelete(s,pos(chr(0),s),1);
          end;

          s := 'insert into ProblemScores (Core, Val, Problem_Score_Flag, StrProblemScore, Short, Transferred) '+
            ' values ('+core+','+fieldbyname('Val').asstring+',-1,''(undefined)'','''+s+''',0)';

          libraryquery(s,true);
          next;
        end;
        close;

        tblproblemscores.Refresh;
      finally
        free;
      end;
end;

//GN03
function TmodLibrary.ResetProblemScores:boolean;
var
   core : string;
begin
   core := wtblQuestionCore.asstring;
   with TWWQuery.Create(self) do
     try
       close;
       databasename := modLookup.dbQstnlib.databasename;
       sql.clear;
       sql.add('update problemscores set transferred=0 where core='+core);
       ExecSQL;

       tblproblemscores.Refresh;
     finally
       free;
     end;
end;

function TmodLibrary.RemoveProblemScores:boolean;
var
   core : string;
begin
   core := wtblQuestionCore.asstring;
   with TWWQuery.Create(self) do
     try
       close;
       databasename := modLookup.dbQstnlib.databasename;
       sql.clear;
       sql.add('delete from problemscores where transferred=0 and core='+core);
       ExecSQL;

       tblproblemscores.Refresh;
     finally
       free;
     end;
   RemoveProblemScores := ProblemScoresDefined;
end;

procedure tmodLibrary.UpdateDataMartProblemScores;
var s, param_lst : string;
    core : string;
    procedure DataMartExec;
    begin
      with ww_Query do begin
        close;
        databasename := 'dbDataMart';
        sql.clear;
        sql.add('exec dbo.sp_Admin_UpdateProblemScores ''' + GetUser + ''', ' + core + s);
        execSQL;
      end;
    end;

    procedure CreateResponseRankOrder;
    begin
      with ww_Query do begin
        Close;
        DatabaseName := 'dbDataMart';
        sql.clear;
        sql.add('exec dbo.sp_InsertUpdateResponseRankOrder ' + core + param_lst + ',' + QuotedStr(GetUser));
        ExecSQL;
      end;
    end;

begin
   with TWWQuery.Create(self) do
     try
       close;
       databasename := modLookup.dbQstnlib.databasename;
       sql.clear;
       sql.add('select core, val, ScaleRanking, problem_score_flag ');
       sql.add(' from ProblemScores where Transferred<>2');
       open;
       while not eof do begin
         core := fieldbyname('core').asstring;
         frmLibrary.staLibrary.Panels.Items[ 2 ].Text := 'Updating Problem Scores for Core #' + core;
         frmLibrary.staLibrary.Refresh;
         s := '';
         param_lst := '';
         while (not eof) and (core = fieldbyname('core').asstring) do begin
           s := s + ', ' + fieldbyname('val').asstring + ', ' + fieldbyname('problem_score_flag').asstring;
           param_lst := ', ' + fieldbyname('val').asstring + ', ' + fieldbyname('ScaleRanking').asstring;
           CreateResponseRankOrder;
           next;
         end;
         DataMartExec;
         LibraryQuery('update ProblemScores set Transferred=2 where /*problem_score_flag<>-1 and*/ core='+core,true);
       end;
       close;
       tblproblemscores.Refresh;
     finally
       free;
     end;
end;

//GN03: This should be a 1 time deal
procedure tmodLibrary.ImportScaleRanking;
var
   s, core, val, rank :string;
   sl : TStringList;
   i, cnt : integer;

   //Create missing problem scores
   procedure CreateNewProblemScores;
   var
      short : string;
   begin
      with TWWQuery.Create(self) do
      try
        close;
        databasename := modLookup.dbQstnlib.databasename;
        sql.clear;
        sql.add('select q.core, s.bubblevalue, s.short ');
        sql.add('from questions q, scalevalues s ');
        sql.add('where q.scale = s.scale ');
        sql.add('and q.core not in (select core from problemscores) ');
        sql.add('order by q.core  ');
        open;

        rank := '-1';
        i := 0;
        cnt := RecordCount;
        while not EOF do
        begin
           core:=FieldByName('core').AsString;
           val:=FieldByName('bubblevalue').AsString;
           short := FieldByName('short').AsString;

           frmLibrary.staLibrary.Panels.Items[ 2 ].Text := 'Processing ' + IntToStr(i) + ' of ' + IntToStr(cnt)+ '. Creating ProblemScores for Core #' + core;
           frmLibrary.staLibrary.Refresh;

           s := 'insert into ProblemScores (Core, Val, ScaleRanking, Problem_Score_Flag, StrProblemScore, Short, Transferred) '+
                  ' values ('+core+','+val+','+rank+',-1, ''(undefined)'',' +QuotedStr(short) + ',0)';

           try
              LibraryQuery(s,true);
           except
              on E:Exception do sl.Add(s);
           end;
           Inc(i);
           Next;
        end;
        close;
      finally
        free;
      end;
   end;

begin
   sl := TStringList.Create;
   sl.Clear;

   CreateNewProblemScores;

   with TWWQuery.Create(self)  do
   begin
      try
         Close;
         DatabaseName := 'dbDataMart';
         sql.clear;
         sql.add('select qstncore, val, rankOrder from  ResponseRankOrder order by qstncore');
         Open;
         i := 0;
         cnt := RecordCount;
         while not EOF do
         begin

            core:=FieldByName('qstnCore').AsString;
            val:=FieldByName('val').AsString;
            rank:=FieldByName('rankOrder').AsString;
            if trim(rank) = '' then rank := '-1';

            frmLibrary.staLibrary.Panels.Items[ 2 ].Text := 'Processing ' + IntToStr(i) + ' of ' + IntToStr(cnt)+  '. Updating Scale Rank Order for Core #' + core;
            frmLibrary.staLibrary.Refresh;

            s := 'update ProblemScores set ScaleRanking=' + rank +
               ' where core='+ core +' and val=' + val;
            try
               LibraryQuery(s,true);
            except
               on E:Exception do sl.Add(s);
            end;
            Inc(i);
            Next;
         end;
         frmLibrary.staLibrary.Panels.Items[ 2 ].Text := 'Ready.';
         frmLibrary.staLibrary.Refresh;

      finally
        begin
           free;
           if sl.Count > 0 then
           begin
              MessageDlg('Please review the error log file', mtError, [mbOK], 0);
              sl.SaveToFile('c:\temp\scalerank.txt');
              WinExec('notepad c:\temp\scalerank.txt',SW_SHOWNORMAL);
           end;
           sl.free;
        end;
      end;
   end;
    
end;

end.
