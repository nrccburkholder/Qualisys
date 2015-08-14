unit fQPDE;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, DBTables, Db, ExtCtrls, Math, common, ComCtrls,
  DBCtrls, BDE, filectrl;

type
  TfrmQPDE = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    dbQualPro: TDatabase;
    Query: TQuery;
    dsSurvey: TDataSource;
    tSurvey: TTable;
    Database2: TDatabase;
    DBGrid: TDBGrid;
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    DateTimePicker: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    Memo1: TMemo;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Panel3: TPanel;
    DBMemo1: TDBMemo;
    Panel4: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tSurveyBeforePost(DataSet: TDataSet);
    procedure tSurveyPostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure DBGridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dsSurveyStateChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridKeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
    SID : string;
    QFID : string;
    Litho : string;
    BarCode : string;
    ScanExportPath, FinalPath : string;
    curLen : integer;
    procedure SQLQuery(const qry:string;const exe:boolean);
    procedure LocalQuery(const qry:string;const exe:boolean);
    function GetUserParam(const prm:string):string;
    procedure QPLogIn;
    function BubblePosDB:string;
    //procedure ViewData(var ds:tDataset);
  public
    { Public declarations }
  end;

var
  frmQPDE: TfrmQPDE;

implementation

uses fViewData;

{$R *.DFM}

procedure tfrmQPDE.SQLQuery(const qry:string;const exe:boolean);
begin
  with Query do begin
    close;
    databasename := '_QualPro';
    sql.clear;
    sql.add(qry);
    if exe then
      ExecSQL
    else
      Open;
  end;
end;

procedure tfrmQPDE.LocalQuery(const qry:string;const exe:boolean);
begin
  with Query do begin
    close;
    databasename := '_PRIV';
    sql.clear;
    sql.add(qry);
    if exe then
      ExecSQL
    else
      Open;
  end;
end;

function tfrmQPDE.BubblePosDB:string;
begin
  result := '';
  try
    SQLQuery('Select STRPARAM_VALUE from qualpro_params where STRPARAM_NM=''ScanServer''',false);
    result := query.fieldbyname('STRPARAM_VALUE').asstring;
    SQLQuery('Select STRPARAM_VALUE from qualpro_params where STRPARAM_NM=''ScanDatabase''',false);
    result := result + '.' + query.fieldbyname('STRPARAM_VALUE').asstring + '.dbo.';
  finally
    query.close;
  end;
end;

procedure TfrmQPDE.Button1Click(Sender: TObject);
var SU,QC:integer;
    StID,PopID,s,BPDB : string;
begin
  if strtointdef(edit1.text,0) = 0 then begin
    s := edit1.text;
    if s[1]='*' then delete(s,1,1);
    if s[length(s)]='*' then delete(s,length(s),1);
    if length(s)=8 then delete(s,7,2);
    litho := inttostr(unBase36(s));
  end else
    Litho := edit1.text;
  LocalQuery('delete from ASurvey',true);
  SQLQuery('select qf.datreturned, sm.datExpire, getdate() as datNow '+
        ' from sentmailing sm, scheduledmailing scm, questionform qf '+
        ' where sm.sentmail_id=scm.sentmail_id '+
        ' and scm.samplepop_id=qf.samplepop_id '+
//        ' and qf.datreturned is not null '+
        ' and sm.strlithocode='''+Litho+'''',false);
  if not query.FieldByName('datreturned').isnull then begin
    messagedlg('survey was already returned on '+query.FieldByName('datreturned').asstring ,mterror,[mbok],0);
    query.close;
    edit1.text:='';
    activecontrol := edit1;
    exit;
  end;
  if query.FieldByName('datExpire').value < query.FieldByName('datNow').value then begin
    messagedlg('survey was cut off on '+query.FieldByName('datExpire').asstring ,mterror,[mbok],0);
    query.close;
    edit1.text:='';
    activecontrol := edit1;
    exit;
  end;
    SQLQuery('select sm.strlithocode, qf.survey_id, qf.questionform_id, qf.datreturned, qf.datresultsimported, sm.datdeleted, sm.datmailed, sd.study_id, sp.pop_id, strclient_nm + '' - '' + strStudy_nm + '' - '' + strSurvey_nm as Survey_nm'+
        ' from questionform qf, sentmailing sm, survey_def sd, scheduledmailing sc, samplepop sp, study s, client c'+
        ' where qf.sentmail_id=sm.sentmail_id'+
        '   and qf.survey_id=sd.survey_id'+
        '   and sm.sentmail_id=sc.sentmail_id'+
        '   and sc.samplepop_id=sp.samplepop_id'+
        '   and sd.study_id=s.study_id'+
        '   and s.client_id=c.client_id'+
        '   and sm.strlithocode='''+Litho+'''',false);
    if query.fieldbyname('questionform_id').isnull then begin
      messagedlg('Can''t find litho '+litho,mterror,[mbok],0);
      if tsurvey.active then tsurvey.refresh;
      activecontrol := edit1;
    end else if not query.fieldbyname('datresultsimported').isnull then begin
      messagedlg('This survey''s results are already in the system',mtinformation,[mbok],0);
      if tsurvey.active then tsurvey.refresh;
      activecontrol := edit1;
    end else if not query.fieldbyname('datdeleted').isnull then begin
      messagedlg('This survey was mailed on '+query.fieldbyname('datmailed').asstring + '.  It has expired.',mtinformation,[mbok],0);
      if tsurvey.active then tsurvey.refresh;
      activecontrol := edit1;
    end else begin
      if not query.fieldbyname('datreturned').isnull then
        datetimepicker.Date := query.fieldbyname('datreturned').value;
      SID := query.fieldbyname('Survey_id').asString;
      QFID := query.fieldbyname('QuestionForm_id').asString;
      StID := query.fieldbyname('Study_id').asstring;
      PopID := query.fieldbyname('POP_ID').asstring;
      label7.caption := query.fieldbyname('Survey_nm').asstring;
      try
        SQLQuery('select FName,LName,Addr,City,ST,ZIP5 from s' + StID + '.POPULATION where Pop_id='+PopID,false);
      except
        try
          SQLQuery('select '''' as Fname, '''' as LName, Addr,City,ST,ZIP5 from s' + Stid + '.POPULATION where Pop_id='+PopID,false);
        finally
          SQLQuery('select '''' as Fname, '''' as LName, '''' as Addr,'''' as City,'''' as ST,'''' as ZIP5 from s' + StID + '.POPULATION where Pop_id='+PopID,false);
        end
      end;
      label4.caption := query.fieldbyname('Fname').asstring + ' ' + query.fieldbyname('LName').asstring;
      label5.caption := query.fieldbyname('Addr').asstring;
      label6.caption := query.fieldbyname('City').asstring + ', ' + query.fieldbyname('ST').asstring + ' ' + query.fieldbyname('Zip5').asstring;
      BPDB := BubblePosDB;
      SQLQuery('select BP.intbegcolumn, BP.qstncore, bp.SampleUnit_id, sq.label, sq.scaleid, '''' as RespVal, '''' as Scale, mm.mx, bp.readmethod_id, bp.intRespCol, bp.intPage_num'+
          ' from '+BPDB+'bubblepos BP, sel_qstns SQ,'+
          ' (select qstncore, max(item) as mx from '+BPDB+'bubbleitempos where questionform_id='+QFID+' group by qstncore) as mm' +
          ' where BP.questionform_id='+QFID+
          '   and bp.qstncore=sq.QstnCore'+
          '   and sq.survey_id='+SID+
          '   and bp.qstncore=mm.qstncore'+
          '   and sq.language=1'+
          '   and sq.subtype=1'+
          ' order by BP.intbegcolumn',false);
      if query.RecordCount = 0 then begin
        messagedlg('No data in BubblePos or BubbleItemPos table.',mterror,[mbok],0);
        if tsurvey.active then tsurvey.refresh;
        activecontrol := edit1;
      end else begin
        tSurvey.batchmove(query,batAppend);
        SQLQuery('select BIP.QuestionForm_id, BIP.QstnCore, BIP.SampleUnit_id, BIP.Survey_id, BIP.Item, BIP.Val, sq.scaleid, ss.label'+
            ' from '+BPDB+'bubbleitempos BIP, sel_Qstns SQ, sel_scls SS'+
            ' where BIP.questionform_id='+QFID+' and'+
            '   bip.qstncore=sq.qstncore and'+
            '   bip.survey_id=sq.survey_id and'+
            '   sq.scaleid=ss.qpc_id and'+
            '   sq.language=1 and'+
            '   sq.subtype=1 and'+
            '   ss.language=1 and'+
            '   bip.item=ss.item and'+
            '   bip.survey_id=ss.survey_id'+
            ' order by bip.qstncore, bip.SampleUnit_id, ss.scaleorder',false);
        with tSurvey do begin
          open;
          disablecontrols;
          BeforePost := nil;
          indexfieldnames := 'QstnCore';
          first;
          query.first;
          label1.caption := '';
          while not eof do begin
            QC := fieldbyname('QstnCore').value;
            SU := fieldbyname('SampleUnit_id').value;
            if fieldbyname('readmethod_id').value<>1 then
              s := ''
            else begin
              s := '(ATA) ';
              label1.caption := 'ATA=All That Apply';
            end;
            while (not query.eof) and (query.fieldbyname('QstnCore').value=QC) and (query.fieldbyname('SampleUnit_id').value=SU) do begin
              if fieldbyname('readmethod_id').value<>1 then
                s := s + query.fieldbyname('item').asstring + '. '+query.fieldbyname('label').asstring {+' ('+query.fieldbyname('val').asstring+')'} +#13+#10
              else
                s := s + query.fieldbyname('item').asstring + '. '+query.fieldbyname('label').asstring+#13+#10;
              query.next;
            end;
            edit;
            fieldbyname('Scale').value := s;
            post;
            next;
          end;
          indexfieldnames := 'intBegcolumn';
          first;
          enablecontrols;
          beforepost := tSurveyBeforePost;
        end;
      end;
      //query.close;
    end;
    activecontrol := dbGrid;
end;

function TfrmQPDE.GetUserParam(const prm:string):string;
begin
  Session.AddPassword( 'Dave' );
  Session.AddPassword( '(uU\`rlvLHh4Au]' );
  result := '';
  with TTable.create(self) do begin
    try
      databasename := 'Question';
      tablename := 'Users.db';
      Open;
      if Locate('User',Prm,[]) then
        result := fieldbyname('Name').value;
      close;
    finally
      free;
    end;
  end;
  session.RemoveAllPasswords;
end;

procedure TfrmQPDE.QPLogIn;
var userid,password:string;
    s,nd : string;
    envname : string;
begin
  Check(dbiInit(Nil));
  ND := 'c:\';
  s := AliasPath('Question');
  if directoryexists(paramstr(1)) then
    ND := paramstr(1)
  else if (directoryexists(copy(s,1,length(s)-7)+'net')) then
    ND := copy(s,1,length(s)-7)+'net'
  else if directoryexists('\\capmts\capgemini\NRC\DATA\NET') then
    ND := '\\capmts\capgemini\NRC\DATA\NET'
  else if directoryexists('\\nrc1\nrc1\NET') then
    ND := '\\nrc1\nrc1\NET';
  try
    session.netfiledir := nd;
    UserID := GetUserParam('USERID&PASSWORD');
  except
    on e:eDBEngineError do begin
      nd := uppercase(e.message);
      delete(nd,1,pos('DIRECTORY: ',nd)+10);
      delete(nd,pos('FILE:',nd)-2,length(nd));
      session.netfiledir := ND;
      UserID := GetUserParam('USERID&PASSWORD');
    end;
  end;
  if UserID <> '' then begin
    Password := UserID;
    delete(UserID,pos(';',UserID),length(UserID));
    delete(Password,1,pos(';',Password));
    dbQualPro.params.add('USER NAME='+UserID);
    dbQualPro.params.add('PASSWORD='+password);
  end else
    Password := '';
  EnvName := GetUserParam('ENVIRONMENTNAME');
  if EnvName <> '' then begin
    SQLQuery('select strParam_value from QualPro_params where strParam_nm=''EnvName'' and strParam_grp=''Environment''',false);
    if Query.fieldbyname('strParam_value').value <> EnvName then begin
      MessageDlg('SQL Environment ('+query.fieldbyname('strParam_value').value+
          ') doesn''t match Paradox Environment ('+EnvName+').  Please '+
          'notify Tech Services.',mterror,[mbok],0);
      Application.Terminate;
    end;
    Query.close;
  end else begin
    MessageDlg('Environment (ENVIRONMENTNAME) isn''t registered in Paradox '+
        'Tables.  Please notify Tech Services.',mterror,[mbok],0);
    Application.Terminate;
  end;
end;

procedure TfrmQPDE.FormCreate(Sender: TObject);
begin
  qpLogIn;
  DateTimePicker.date := now;
  label1.caption := '';
  with tSurvey do begin
    close;
    DatabaseName := '_PRIV';
    TableName := 'ASurvey.DB';
    TableType := ttParadox;
    with FieldDefs do begin
      Clear;
      add('intBegColumn',ftInteger,0,false);
      add('QstnCore',ftInteger,0,false);
      add('SampleUnit_id',ftinteger,0,false);
      add('Label',ftString,60,false);
      add('ScaleID',ftinteger,0,false);
      add('RespVal',ftString,20,false);
      add('Scale',ftMemo,250,false);
      add('mx',ftinteger,0,false);
      add('readmethod_id',ftinteger,0,false);
      add('intRespCol',ftinteger,0,false);
      add('intPage_num',ftinteger,0,false);
    end;
    with IndexDefs do begin
      Clear;
      Add('intBegColumn', 'intBegColumn', [ixPrimary]);
      Add('QstnCore', 'QstnCore;SampleUnit_id', []);
    end;
    createtable;
    open;
  end;
  SQLQuery('select strParam_nm, strParam_value from QualPro_Params where strParam_grp=''Scanner''',false);
  with Query do begin
    if locate('strParam_nm','ScanExportUnProc',[loCaseInsensitive]) then
      ScanExportPath := fieldbyname('strParam_value').value
    else
      ScanExportPath := '\\Nrc9\nrc9\FAQSS\DYNAMIC\BARCODES\';
    if locate('strParam_nm','ScanImportUnProcRet',[loCaseInsensitive]) then
      FinalPath := fieldbyname('strParam_value').value
    else
      FinalPath := '\\Nrc9\nrc9\FAQSS\DYNAMIC\Final\';
    close;
  end;
  curLen := 0;
end;

procedure TfrmQPDE.tSurveyBeforePost(DataSet: TDataSet);
var RespVal,i : integer;
    s,s2:string;
begin
  if not dataset.fieldbyname('RespVal').isnull then begin
    if dataset['readmethod_id'] <> 1 then begin {Only One Response}
      respval := strtointdef(dataset.fieldbyname('RespVal').value,-99);
      if respval = -99 then begin
        messagebeep(0);
        dataset.cancel;
      end else
        if pos(inttostr(respval)+'. ',dataset.fieldbyname('scale').asstring)=0 then begin
          messagebeep(0);
          dataset.Cancel;
        end;
    end else begin {All That Apply}
      s := dataset['RespVal'];
      for i := 1 to length(s) do
        if pos(s[i],'-1234567890')=0 then s[i] := ',';
      while pos(',,',s)>0 do delete(s,pos(',,',s),1);
      if s[1]=',' then delete(s,1,1);
      if s[length(s)]=',' then delete(s,length(s),1);
      s2 := '';
      while length(s)>0 do begin
        respval := strtoint(getword(s));
        if (pos(inttostr(respval)+'. ',dataset.fieldbyname('scale').asstring)<>0)
            and (pos(','+inttostr(respval)+',', ','+s2)=0) then begin
          if respval < 10 then
            s2 := s2 + inttostr(respval) +','
          else
            s2 := s2 + chr(respval+55) + ',';
        end else
          messagebeep(0);
      end;
      //if s2<>'' then delete(s2,length(s2),1);
      while pos(',',s2)>0 do delete(s2,pos(',',s2),1);
      dataset['RespVal'] := s2;
    end;
  end;
end;

procedure TfrmQPDE.tSurveyPostError(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction);
begin
  action := daAbort;
end;

(*
procedure tfrmQPDE.ViewData(var ds:tDataset);
begin
  frmViewData := TfrmViewData.Create( Self );
  with frmViewData do
  try
    datasource1.dataset := ds;
    caption := ds.name;
    showmodal;
  finally
    Release;
  end;
end;
*)

procedure TfrmQPDE.DBGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with tSurvey do begin
    if (state=dsEdit) then begin
      if (fieldbyname('mx').value<10) and
         (key<>189) and
         (key<>109) and
         (fieldbyname('readmethod_id').value<>1) then begin
        post;
        next;
      end;
    end;
  end;
end;

procedure TfrmQPDE.dsSurveyStateChange(Sender: TObject);
begin
  if tsurvey.state=dsInsert then tsurvey.cancel;
end;

procedure TfrmQPDE.Button2Click(Sender: TObject);
  procedure myDelete(var S: string; Index, Count:Integer);
  begin
    delete(s,index,count);
  end;
  procedure myInsert(Source: string; var S: string; Index: Integer);
  begin
    insert(source,s,index);
  end;
var s,s2,ThisResponse,responses : string;
    su_id,core,item : integer;
begin
  barcode := Base36(strtoint(litho),6)+'1';
  barcode := barcode+checkdigit(barcode);
  Responses := formatdatetime('yyyymmdd',datetimepicker.date) + barcode;
  with tSurvey do begin
    first;
    while not eof do begin
      if fieldbyname('ReadMethod_id').value<>1 then begin
        su_id := fieldbyname('SampleUnit_id').asinteger;
        core := fieldbyname('qstncore').asinteger;
        item := strtointdef(fieldbyname('RespVal').asstring,-9);
        thisresponse := '';
        if query.Locate('sampleunit_id;qstncore;item',vararrayof([su_id,core,item]),[]) then
          thisresponse := query.fieldbyname('val').asstring;
        while length(ThisResponse) < fieldbyname('intRespCol').value do
          ThisResponse := ThisResponse + ' ';
      end else begin
        ThisResponse := '';
        s := fieldbyname('respval').asstring;
        while length(s) > 0 do begin
          s2 := getword(s);
          while length(s2) < fieldbyname('intRespCol').value do
            s2 := s2 + ' ';
          ThisResponse := thisResponse + s2;
        end;
      end;
      while length(responses) < fieldbyname('intBegColumn').value + length(ThisResponse) do
        responses := responses + ' ';
      mydelete(responses,fieldbyname('intBegColumn').value,length(ThisResponse));
      myinsert(ThisResponse,Responses,fieldbyname('intBegColumn').value);
      next;
    end;
  end;
  for item := 0 to memo1.lines.count-1 do
    if copy(memo1.lines[item],9,6) = copy(responses,9,6) then break;
  if copy(memo1.lines[item],9,6) = copy(responses,9,6) then
    memo1.lines[item] := responses
  else
    memo1.lines.add(responses);
  //edit1.text := '';
  activecontrol := edit1;
end;

procedure TfrmQPDE.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (edit1.text<>'') and (key=vk_return) then Button1Click(sender);
end;

procedure TfrmQPDE.DBGridKeyPress(Sender: TObject; var Key: Char);
begin
if (ord(key)=13) then begin
  if tsurvey.State = dsEdit then tsurvey.post;
  tsurvey.next;
end;
end;

procedure TfrmQPDE.Edit1Change(Sender: TObject);
begin
  tsurvey.close;
  label4.caption := '';
  label5.caption := '';
  label6.caption := '';
  label7.caption := '';
end;

end.
