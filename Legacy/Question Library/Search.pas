unit Search;

{ data module for the rubicon search components and accompanying tables }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  taRubicn, DB, DBTables, taPhase, ComCtrls, Wwdatsrc, Wwtable;

type
  TmodSearch = class(TDataModule)
    srcMatch: TDataSource;
    rubMake: TMakeDictionary;
    rubProgress: TMakeProgress;
    rubSearch: TSearchDictionary;
    tblWords: TTable;
    tblMatch: TTable;
    procedure MakeProcessField(Sender: TObject; Field: TField; Location: Longint);
    procedure DuringSearch(Sender: TObject);
    procedure modSearchCreate(Sender: TObject);
    procedure modSearchDestroy(Sender: TObject);
    procedure tblMatchLevelQuestGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure tblMatchLevelQuestSetText(Sender: TField;
      const Text: String);
    procedure tblMatchCalcFields(DataSet: TDataSet);
  private

  public

  end;

var
  modSearch: TmodSearch;
  f:textfile;

implementation

uses common, Data, Browse, Lookup, Find;

{$R *.DFM}

{ adds question text to the word table for later searching:
    1. moves to the question text record using the core passed in via Field (from question)
    2. puts contents of blob field into a hidden rich edit on the Browse form
    3. processes the words in the rich edit as a list }

procedure TmodSearch.MakeProcessField(Sender: TObject; Field: TField; Location: Longint);
var s : string;
    sl : tStringList;
  procedure mydelete(var s:string;i1,i2:integer);
  begin
    delete(s,i1,i2);
  end;
begin
  sl := tStringList.create;
  if (Field.Name='wtblQuestionShort') or (Field.Name='wtblQuestionDescription') then begin
    sl.add(field.asString);
    rubMake.ProcessList(sl,Location, true);
  end;
  with modLookup.tblQstnText do
    if (Field.Name='wtblQuestionCore') and
       (Locate('Core;LangID', VarArrayOf([Field.AsInteger, 1]), [])) then begin
      s := modLookup.tblQstnTextText.AsString;
      WHILE pos('\PROTECT',UPPERCASE(S))>0 DO
        mydelete(S,pos('\PROTECT',UPPERCASE(S)),8);
      sl.add( s );
      rubMake.ProcessList( sl, Location, True);
      {frmLibrary.rtfWords.lines.clear;
      frmLibrary.rtfWords.Lines.Add( modLookup.tblQstnTextText.AsString );
      rubMake.ProcessList( frmLibrary.rtfWords.Lines, Location, True );}
    end;
  sl.free;
end;

{ supposed to allow for aborting a search, but only seems to be called at begin and end of
  the search (documentation states called intermitently) }

procedure TmodSearch.DuringSearch(Sender: TObject);
begin
  Application.ProcessMessages;
  if frmFind.vAbort then with rubSearch do State := State + [ dsAbort ];
end;

procedure TmodSearch.modSearchCreate(Sender: TObject);
begin
  try
    tblMatch.databasename := aliaspath('PRIV');
  except
    tblmatch.databasename := 'c:\windows\temp';
  end;
  assignfile(f,'c:\protect.txt');
  rewrite(f);
end;

procedure TmodSearch.modSearchDestroy(Sender: TObject);
begin
  closefile(f);
  deldotstar(tblmatch.databasename+'\Match.*');
end;

procedure TmodSearch.tblMatchLevelQuestGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  case sender.asinteger of
    1 : text := 'Key';
    2 : text := 'Core';
    3 : text := 'Drill down';
    4 : text := 'Behavioral';
  else
    text := 'No level defined';
  end;
end;

procedure TmodSearch.tblMatchLevelQuestSetText(Sender: TField;
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

procedure TmodSearch.tblMatchCalcFields(DataSet: TDataSet);
begin
  with modLookup do begin
    DataSet[ 'Review' ] := ( tblQstnText.Locate( 'Core', tblMatch.fieldbyname('Core').Value, [ ] ) or
        tblScaleText.Locate( 'Scale', tblMatch.fieldbyname('Scale').Value, [ ] ) or
        tblHeadText.Locate( 'HeadID', tblMatch.fieldbyname('HeadID').Value, [ ] ));

    with tblQstnText do begin
      filter := 'LangID <> 1';
      dataset[ 'Languages' ] := '';
      if Locate( 'Core', tblMatch.fieldbyname('Core').Value, [ ] ) then
        while (not eof) and (fieldbyname('Core').Value = tblMatch.fieldbyname('Core').Value) do begin
          if modlibrary.tblLanguage.Locate( 'LangID', Fieldbyname('LangID').Value, [ ]) then
            DataSet[ 'Languages' ] := DataSet[ 'Languages' ] + modLibrary.tblLanguageLanguage.AsString + ' '
          else
            DataSet[ 'Languages' ] := DataSet[ 'Languages' ] + '{' + Fieldbyname('LangID').AsString + '}';
          next;
        end;
      filter := 'Review';
    end;
  end;
end;

end.

