unit Lookup;

{*******************************************************************************
Description : data module containing all of the tables used as lookup tables

Modifications:
--------------------------------------------------------------------------------
Date        UserID   Description
--------------------------------------------------------------------------------
11-17-2005  GN01     remove lck files if present

*******************************************************************************}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BDE, DB, DBTables, Wwtable, Wwdatsrc, Filectrl;

type
  TmodLookup = class(TDataModule)
    tblScaleText: TwwTable;
    tblQstnText: TwwTable;
    tblHeadText: TwwTable;
    tblScale: TTable;
    srcScale: TDataSource;
    tblHeading: TwwTable;
    srcHeading: TwwDataSource;
    tblQuestion: TTable;
    srcQuestion: TDataSource;
    tblUsage: TTable;
    tblRecode: TTable;
    tblCodeText: TTable;
    dbQstnLib: TDatabase;
    tblReview: TwwTable;
    tblQstnTextText: TBlobField;
    tblQstnTextCore: TIntegerField;
    tblQstnTextLangID: TIntegerField;
    tblQstnTextReview: TBooleanField;
    procedure LookupCreate(Sender: TObject);
    procedure CodeTextFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  modLookup: TmodLookup;

implementation

uses Data, DBRichEdit, Common;

{$R *.DFM}

{ INITIALIZATION }

procedure TmodLookup.LookupCreate(Sender: TObject);
var s,nd : string;
begin
  Check(dbiInit(Nil));
  //GN01
  try
    nd := aliaspath('PRIV');
    SaveTempDirInRegistry(nd);
    deldotstar(nd+'\p*.lck')
  except
  end;
{  try
    nd := aliaspath('Question');
    deldotstar(nd+'\p*.lck')
  except
  end;

  ND := '\\nrc11\qualpro\QP_Lib\NET';
  s := AliasPath('Question');
  if directoryexists(paramstr(1)) then
    ND := paramstr(1)
  else if (directoryexists(copy(s,1,length(s)-7)+'net')) then
    ND := copy(s,1,length(s)-7)+'net';
  if dbQstnLib.connected then dbQstnlib.close;
  try
    session.netfiledir := nd;
    tblQuestion.Open;
    tblQuestion.Close;
  except
    on e:eDBEngineError do begin
      nd := uppercase(e.message);
      delete(nd,1,pos('DIRECTORY: ',nd)+10);
      delete(nd,pos('FILE:',nd)-2,length(nd));
      session.netfiledir := ND;
    end;
  end;


  if copy(s,length(s),1) = '\' then delete(s,length(s),1);
  if (not FileExists(s+'\Questions.DB')) or (UpperCase(paramstr(1))='/Q') then begin
    s := InputBox('Find Library','Specify the directory for the Question Library',s);
    if copy(s,length(s),1) = '\' then delete(s,length(s),1);
    while not FileExists(s+'\Questions.DB') do begin
      s := InputBox('Find Library','Specify the directory for the Question Library',s);
      if copy(s,length(s),1) = '\' then delete(s,length(s),1);
    end;
    if uppercase(s) <> uppercase(copy(dbQstnLib.params[0],6,255)) then
      with dbQstnLib do begin
        Connected := False;
        params.clear;
        params.add('PATH='+s);
        Connected := True;
      end;
   end;}
  tblQuestion.Open;
  tblHeading.Open;
  tblScale.Open;
  tblHeadText.Open;
  tblQstnText.Open;
  tblScaleText.Open;
  tblCodeText.Open;
  tblRecode.Open;
end;

{ CODE SUBSTITUTION FILTER }

{ !!! this is the filter responsible for determining what text gets displayed
      in place of a code !!! }

procedure TmodLookup.CodeTextFilterRecord(DataSet: TDataSet; var Accept: Boolean);
begin
  Accept := ((( DataSet[ 'Age' ] = copy(vAge,1,1) ) OR ( DataSet[ 'Age' ] = Null )) AND
            (( DataSet[ 'Sex' ] = copy(vSex,1,1) ) OR ( DataSet[ 'Sex' ] = Null )) AND
            (( DataSet[ 'Doctor' ] = copy(vDoc,1,1) ) OR ( DataSet[ 'Doctor' ] = Null )));
end;

end.
