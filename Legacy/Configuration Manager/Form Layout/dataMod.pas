unit dataMod;

{*******************************************************************************
Program Modifications:

-------------------------------------------------------------------------------
Date        ID     Description
-------------------------------------------------------------------------------
11-22-2005  GN01   Set the DataLib.Connected to False in design time.

********************************************************************************}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BDE, DB, Wwdatsrc, DBTables, Wwtable, Wwquery, DBRichEdit, FileCtrl;

const
  defPixelsPerInch = 120;

type
  TDQDataModule = class(TDataModule)
    wwT_Questions: TwwTable;
    wwT_QuestionText: TwwTable;
    wwDS_Questions: TwwDataSource;
    wwDS_QuestionText: TwwDataSource;
    wwDS_Languages: TwwDataSource;
    wwT_Services: TwwTable;
    wwT_ServicesService: TStringField;
    wwT_ServicesServID: TIntegerField;
    wwDS_Services: TwwDataSource;
    wwT_Themes: TwwTable;
    wwDS_Themes: TwwDataSource;
    wwT_ThemesThemID: TAutoIncField;
    wwT_ThemesTheme: TStringField;
    DataLib: TDatabase;
    wwT_Languages: TwwTable;
    wwT_LanguagesLanguage: TStringField;
    wwT_LanguagesLangID: TAutoIncField;
    wwT_Headings: TwwTable;
    wwT_HeadText: TwwTable;
    wwDS_Headings: TwwDataSource;
    wwDS_HeadText: TwwDataSource;
    wwT_HeadingsHeadID: TAutoIncField;
    wwT_HeadingsName: TStringField;
    wwT_HeadingsFielded: TSmallintField;
    wwT_HeadTextHeadID: TIntegerField;
    wwT_HeadTextLangID: TIntegerField;
    wwT_HeadTextText: TBlobField;
    wwT_HeadTextReview: TBooleanField;
    wwDS_Scales: TwwDataSource;
    wwT_Scales: TwwTable;
    wwDS_ScaleValues: TwwDataSource;
    wwT_ScaleValues: TwwTable;
    DS_Codes: TDataSource;
    T_Codes: TTable;
    DS_CodeText: TDataSource;
    T_CodeText: TTable;
    DS_Constants: TDataSource;
    T_Constants: TTable;
    wwDS_ScaleText: TwwDataSource;
    wwT_ScaleText: TwwTable;
    wwT_QuestionsCore: TIntegerField;
    wwT_QuestionsDescription: TStringField;
    wwT_QuestionsFielded: TSmallintField;
    wwT_QuestionsScale: TIntegerField;
    wwT_QuestionsShort: TStringField;
    wwT_QuestionsHeadID: TIntegerField;
    wwT_QuestionsFollowedBy: TIntegerField;
    wwT_QuestionsPrecededBy: TIntegerField;
    wwT_QuestionsAddedBy: TStringField;
    wwT_QuestionsAddedOn: TDateField;
    wwT_QuestionsModifiedBy: TStringField;
    wwT_QuestionsModifiedOn: TDateField;
    wwT_QuestionsServID: TIntegerField;
    wwT_QuestionsThemID: TIntegerField;
    wwT_QuestionsRestrictQuestion: TBooleanField;
    wwT_QuestionsTested: TBooleanField;
    wwT_QuestionsLevelQuest: TSmallintField;
    wwT_QuestionsParent: TIntegerField;
    wwT_QuestionsLabel: TStringField;
    wwT_QuestionsHeading: TStringField;
    wwT_QuestionsService: TStringField;
    wwT_QuestionsTheme: TStringField;
    wwT_QuestionTextCore: TIntegerField;
    wwT_QuestionTextLangID: TIntegerField;
    wwT_QuestionTextText: TBlobField;
    wwT_QuestionTextReview: TBooleanField;
    wwT_LanguagesDictionary: TStringField;
    wwT_ScalesScale: TAutoIncField;
    wwT_ScalesLabel: TStringField;
    wwT_ScalesFielded: TSmallintField;
    wwT_ScalesRight: TBooleanField;
    wwT_ScalesMean: TBooleanField;
    wwT_ScalesWidth: TIntegerField;
    wwT_ScalesMarkCount: TIntegerField;
    wwT_ScaleValuesScale: TIntegerField;
    wwT_ScaleValuesItem: TIntegerField;
    wwT_ScaleValuesType: TSmallintField;
    wwT_ScaleValuesBubbleValue: TSmallintField;
    wwT_ScaleValuesCharSet: TSmallintField;
    wwT_ScaleValuesShort: TStringField;
    wwT_ScaleValuesMissing: TBooleanField;
    wwT_ScaleValuesScaleOrder: TSmallintField;
    wwT_ScaleTextScale: TIntegerField;
    wwT_ScaleTextItem: TSmallintField;
    wwT_ScaleTextLangID: TIntegerField;
    wwT_ScaleTextReview: TBooleanField;
    wwT_ScaleTextText: TBlobField;
    wwT_ScaleLookup: TwwTable;
    wwT_HeadingLookup: TwwTable;
    T_CodeTextCodeTextID: TAutoIncField;
    T_CodeTextCode: TIntegerField;
    T_CodeTextAge: TStringField;
    T_CodeTextSex: TStringField;
    T_CodeTextDoctor: TStringField;
    T_CodeTextText: TStringField;
    T_CodesCode: TAutoIncField;
    T_CodesLangID: TIntegerField;
    T_CodesDescription: TStringField;
    T_CodesFielded: TSmallintField;
    T_CodesAge: TBooleanField;
    T_CodesSex: TBooleanField;
    T_CodesDoctor: TBooleanField;
    T_ConstantsConstant: TStringField;
    T_ConstantsValue: TStringField;
    wwT_QuestionsNotes: TMemoField;
    procedure wwDS_SurveysStateChange(Sender: TObject);
    procedure wwT_SurveysNewRecord(DataSet: TDataSet);
    procedure wwT_SurveysBeforePost(DataSet: TDataSet);
    procedure DQDataModuleCreate(Sender: TObject);
    procedure OpenCodeTables;
    procedure OpenLibraryTables;
    procedure DQDataModuleDestroy(Sender: TObject);
    procedure T_CodeTextFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure wwT_QuestionsLevelQuestGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure wwT_QuestionsFilter(table: TwwTable; var accept: Boolean);
    procedure UpdateQstnFilter;
    function FilterLevelText:string;
  private
    { Private declarations }
  public
    { Public declarations }
    defaultFont,
    QtextFont,
    scaleFont: TFont;
    filterTheme,filterService : integer;
    filterlevelK,filterlevelC,filterlevelDD,filterlevelB,filterlevelU,
    FilterRestrict : boolean;
    cmdLineTemplate : string;
    cmdLineSurveyID : integer;
    cmdLineLaptop : boolean;
    cmdLineNetFile : string;
    numOpened : smallint;
  end;

var
  DQDataModule: TDQDataModule;

implementation

{$R *.DFM}
uses Common;

procedure TDQDataModule.wwDS_SurveysStateChange(Sender: TObject);
begin
  with sender as TDatasource do
    with dataset do
      if state = dsEdit then
        if (fieldByName('FirstFielded').value <> null) or
	   (fieldByName('LastFielded').value <> null) then begin
          cancel;
	  messageDlg('A Survey that has been Fielded CANNOT be changed!', mtError, [mbOK], 0);
        end;
end;

procedure TDQDataModule.wwT_SurveysNewRecord(DataSet: TDataSet);
begin
  with dataset as TTable do begin
    fieldByName('AddUser').asString := getUser;
    fieldByName('AddDate').asDateTime := date;
  end;
end;

procedure TDQDataModule.wwT_SurveysBeforePost(DataSet: TDataSet);
begin
  with dataset as TTable do begin
    fieldByName('ChgUser').asString := getUser;
    fieldByName('ChgDate').asDateTime := date;

    if fieldByName('AddUser').asString = '' then
      fieldByName('AddUser').asString := getUser;
    if fieldByName('AddDate').asString = '' then
      fieldByName('AddDate').asDateTime := date;

    if fieldByName('QtextFontName').value = null then
      fieldByName('QtextFontName').value := defaultFont.name;
    if fieldByName('QtextFontSize').value = null then
      fieldByName('QtextFontSize').value := defaultFont.size;

    if fieldByName('ScaleFontName').value = null then
      fieldByName('ScaleFontName').value := defaultFont.name;
    if fieldByName('ScaleFontSize').value = null then
      fieldByName('ScaleFontSize').value := defaultFont.size;

    if (fieldByName('PixelsPerInch').value = 0) or
       (fieldByName('PixelsPerInch').value = null) then
      fieldByName('PixelsPerInch').value := defPixelsPerInch;

  end;
end;

procedure TDQDataModule.DQDataModuleCreate(Sender: TObject);
var nd:string;
begin
  Screen.cursor := crDefault;
  check(dbiInit(nil));
  try
    nd := aliaspath('PRIV');
    SaveTempDirInRegistry(nd);
    deldotstar(nd+'\p*.lck')
  except
  end;
  try
    nd := aliaspath('Question');
    deldotstar(nd+'\p*.lck');

    nd := ExtractFilePath(Application.ExeName);
    deldotstar(nd+'\p*.lck')

  except
  end;

  numOpened := 0;
  if (paramstr(1)='') or fileexists(paramstr(1)) then begin
    cmdLineTemplate := paramstr(1);
    cmdLineSurveyID := strtointdef(paramstr(2),-1);
    if paramstr(3)='' then cmdLineNetFile := 'C:\NotThere'
    else                   cmdLineNetFile := paramstr(3);
    if paramstr(4)='' then cmdLineLaptop := true
    else                   cmdLineLaptop := (uppercase(paramstr(4)) = '/L');
  end else begin
    cmdLineTemplate := '';
    cmdLineSurveyID := strtointdef(paramstr(1),0);
    cmdLineNetFile := paramstr(2);
    cmdLineLaptop := (uppercase(paramstr(3)) = '/L');
  end;

  if directoryexists(cmdLineNetFile) then
    ND := cmdLineNetFile
  else if (directoryexists(copy(aliaspath('Question'),1,length(aliaspath('Question'))-7)+'net')) {and (not fileexists('\\capmts\capgemini\NRC\DATA\NET\PdoxUsrs.dct'))} then
    ND := copy(aliaspath('Question'),1,length(aliaspath('Question'))-7)+'net'
  else if directoryexists('\\capmts\capgemini\NRC\DATA\NET') then
    ND := '\\capmts\capgemini\NRC\DATA\NET'
  else if directoryexists('\\nrc1\nrc1\NET') then
    ND := '\\nrc1\nrc1\NET';


  if uppercase(Session.NetFileDir) <> uppercase(ND) then begin
    if datalib.connected then datalib.close;
    try
      session.netfiledir := nd;
      wwt_Themes.open;
    except
      on e:eDBEngineError do begin
        nd := uppercase(e.message);
        delete(nd,1,pos('DIRECTORY: ',nd)+10);
        delete(nd,pos('FILE:',nd)-2,length(nd));
        session.netfiledir := ND;
      end;
    end;
  end;
  datalib.connected := True; //Gn01
  //ShowMessage('PrivDir ' + session.PrivateDir + #13 + 'netDir ' + session.NetFileDir);
  //Error message: 'The directory is controlled by another .net file.'
  //To solve the problem, exit from Paradox, find the pdoxusrs.net file

  defaultFont := TFont.create;
  with defaultFont do begin
    Color := clBlack;
    Name := 'Arial';
    Pitch := fpVariable;
    Size := 10;
    Style := [];
  end;

  filterlevelK := false;
  filterlevelC := false;
  filterlevelDD := false;
  filterlevelB := false;
  filterlevelU := false;
  filterRestrict := true;
  FilterTheme := 0;
  filterService := 0;
  UpdateQstnFilter;

  //OpenLibraryTables;
  openCodeTables;

  QtextFont := TFont.create;
  QtextFont.assign(defaultFont);

  ScaleFont := TFont.create;
  ScaleFont.assign(defaultFont);
end;


procedure TDQDataModule.OpenLibraryTables;
begin
  if not wwt_Themes.active then wwt_Themes.open;
  if not wwT_Services.active then wwT_Services.open;
  if not wwT_HeadingLookup.active then wwT_HeadingLookup.open;
  if not wwT_ScaleLookup.active then wwT_ScaleLookup.open;
  if not wwT_Questions.active then wwT_Questions.open;
  if not wwT_QuestionText.active then wwT_QuestionText.open;
  if not wwT_Headings.active then wwT_Headings.open;
  if not wwt_headtext.active then wwt_headtext.open;
  if not wwT_Scales.active then wwT_Scales.open;
  if not wwT_ScaleValues.active then wwT_ScaleValues.open;
  if not wwT_ScaleText.active then wwT_ScaleText.open;
  if not wwT_ScaleLookup.active then wwT_ScaleLookup.open;
  if not wwT_HeadingLookup.active then wwT_HeadingLookup.open;
end;

procedure TDQDataModule.OpenCodeTables;
begin
  if not t_Codes.active then t_Codes.open;
  if not t_CodeText.active then t_CodeText.open;
  if not t_Constants.active then t_Constants.open;
end;

procedure TDQDataModule.DQDataModuleDestroy(Sender: TObject);
begin
  defaultFont.free;
  QtextFont.free;
  scaleFont.free;

  //Gn01
  DataLib.CloseDataSets;
  DataLib.Connected := False;
  {
  wwT_Questions.Close;
  wwT_QuestionText.Close;
  wwT_Scales.Close;
  wwT_ScaleText.Close;
  wwT_ScaleValues.Close;
  wwT_Headings.Close;
  wwT_HeadText.Close;
  T_Codes.Close;
  T_CodeText.Close;
  T_Constants.Close;
  wwT_Services.Close;
  wwT_Languages.Close;
  wwT_Themes.Close;
  wwT_HeadingLookup.Close;
  wwT_ScaleLookup.Close;  }
end;

function Next_IDx(Dataset: TDataset; ID_Field: string): integer;
var
  TQ: TwwQuery;
begin
  result := 1;
  TQ := TwwQuery.create(dataset.owner);
  with TQ do
    try
      databasename := (dataset as TwwTable).databasename;
      with sql do begin
	add('Select '+ID_Field+' Last_ID from '+(dataset as TwwTable).tablename+' ');
	add('where ('+ID_Field+' = (select max('+ID_Field+')) ');
	add(' from '+(dataset as TwwTable).tablename+') ');
      end;
      try
      	open;
      	result := fieldByName('Last_ID').value + 1;
      except
      	on e:exception do SQLError(TQ, e.message);
      end;
    finally
      free;
    end;
end;

function Next_ID(Dataset: TDataset; ID_Field: string): integer;  
begin
  result := 0;
  with TwwTable.create(dataset.owner) do
    try
      DatabaseName := 	(dataset as TwwTable).DatabaseName;
      TableName := 		(dataset as TwwTable).TableName;
      TableType := 		(dataset as TwwTable).TableType;
      Masterfields := 	(dataset as TwwTable).Masterfields;
      Mastersource := 	(dataset as TwwTable).Mastersource;

      open;
      first;
      while not eof do begin
        result := iMax(result, fieldByName(ID_Field).asInteger);
	next;
      end;
    finally
      result := result + 1;
      free;
    end;
end;

procedure TDQDataModule.T_CodeTextFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := ((( DataSet[ 'Age' ] = vAge[1] ) OR ( DataSet[ 'Age' ] = Null )) AND
            (( DataSet[ 'Sex' ] = vSex[1] ) OR ( DataSet[ 'Sex' ] = Null )) AND
            (( DataSet[ 'Doctor' ] = vDoc[1] ) OR ( DataSet[ 'Doctor' ] = Null )));

end;

procedure TDQDataModule.wwT_QuestionsLevelQuestGetText(Sender: TField;
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

procedure TDQDataModule.wwT_QuestionsFilter(table: TwwTable;
  var accept: Boolean);
var f1,f2,f3 : boolean;
begin
  f1 := true;  f2 := true;  f3 := true;
  if (filterRestrict or (filterTheme>0) or (filterService>0)) then begin
    if FilterRestrict then f1 := (not wwt_Questions.fieldbyname('RestrictQuestion').asBoolean);
    if filterTheme>0 then f2 := (wwt_Questions.fieldbyname('ThemID').value=FilterTheme);
    if filterService>0 then f3 := (wwt_Questions.fieldbyname('ServID').value=filterService);
  end else
    wwt_questions.filtered := false;
  accept := f1 and f2 and f3;
end;

procedure TDQDataModule.UpdateQstnFilter;
var s,s2 : string;
begin
  s := '';
  if FilterRestrict then s := s + ' and RestrictQuestion=False';
  if filterTheme>0 then s := s + ' and ThemID='+inttostr(filterTheme);
  if filterService>0 then s := s + ' and ServID='+inttostr(filterservice);
  s2 := '';
  if not filterLevelK then s2 := s2 + ' or LevelQuest=1';
  if not filterLevelC then s2 := s2 + ' or LevelQuest=2';
  if not filterLevelDD then s2 := s2 + ' or LevelQuest=3';
  if not filterLevelB then s2 := s2 + ' or LevelQuest=4';
  if not filterLevelU then s2 := s2 + ' or LevelQuest=5';
  if length(s2)=16*5 then s2 := '';
  if s2 <> '' then delete(s2,1,4);
  if s<>'' then begin
    delete(s,1,5);
    if s2 <> '' then s := s + ' and (' + s2 + ')';
  end else
    s := s2;
  wwt_Questions.filtered := false;
  wwt_Questions.filter := s;
  wwt_Questions.filtered := (s<>'');
end;

function TDQDataModule.FilterLevelText:string;
var s:string;
begin
  if not filterLevelK then s := s + ', K';
  if not filterLevelC then s := s + ', C';
  if not filterLevelDD then s := s + ', DD';
  if not filterLevelB then s := s + ', B';
  if not filterLevelU then s := s + ', U';
  if (length(s)=16) or (s='') then
    s := 'All levels'
  else
    delete(s,1,2);
  result := s;
end;

end.
