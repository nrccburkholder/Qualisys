unit EditCode;

{*******************************************************************************
Description: a dialog box used for creating, modifying and deleting codes and constants 

Modifications:
--------------------------------------------------------------------------------
Date        UserID   Description
--------------------------------------------------------------------------------
08-01-2006  GN01     Writing to the root drive is bad as our users don't have Admin rights

10-06-2006  GN02     The codes weren't getting updated in QualPro 

*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, DBCtrls, Mask, Grids, DBGrids, ComCtrls, DB,
  DBTables, Clipbrd;

type
  TfrmCodeEdit = class(TForm)
    Panel4: TPanel;
    btnFirst: TSpeedButton;
    btnFind: TSpeedButton;
    btnNext: TSpeedButton;
    navCode: TDBNavigator;
    btnNew: TSpeedButton;
    btnSave: TSpeedButton;
    btnInsert: TSpeedButton;
    btnSpell: TSpeedButton;
    panHead: TPanel;
    btnClose: TSpeedButton;
    dgrConst: TDBGrid;
    pclCode: TPageControl;
    shtCode: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    detDescription: TDBEdit;
    dgrText: TDBGrid;
    GroupBox1: TGroupBox;
    chkSex: TDBCheckBox;
    chkDoc: TDBCheckBox;
    chkAge: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    Panel7: TPanel;
    DBText6: TDBText;
    shtConstant: TTabSheet;
    DBGrid1: TDBGrid;
    detValue: TDBEdit;
    detConstant: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    Bevel1: TBevel;
    Label6: TLabel;
    Bevel2: TBevel;
    Label7: TLabel;
    Label8: TLabel;
    tblConst: TTable;
    srcConst: TDataSource;
    tblConstConstant: TStringField;
    tblConstValue: TStringField;
    cmbLanguage: TComboBox;
    btnDelete: TSpeedButton;
    Panel1: TPanel;
    LocalQuery: TQuery;
    ComboBox1: TComboBox;
    btnInsertFunc: TButton;
    Memo1: TMemo;
    procedure InsertConstClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FindClick(Sender: TObject);
    procedure FirstClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure TextExit(Sender: TObject);
    procedure SpellClick(Sender: TObject);
    procedure PageChange(Sender: TObject);
    procedure TextEnter(Sender: TObject);
    procedure ValueEnter(Sender: TObject);
    procedure PageChanging(Sender: TObject; var AllowChange: Boolean);
    procedure LanguageChange(Sender: TObject);
    procedure DependencyMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DepencencyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ConstantEnter(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure dgrTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dgrTextKeyPress(Sender: TObject; var Key: Char);
    procedure detDescriptionExit(Sender: TObject);
    procedure navCodeClick(Sender: TObject; Button: TNavigateBtn);
    procedure btnInsertFuncClick(Sender: TObject);
  private
    vOriginal : Byte;
    procedure SetData;
    procedure LoadLanguageCombo;
    procedure DependencyRows( Sender : TObject );
    procedure updateSQLcodetables;
    function GetCodeID:integer;
    function SQLString(const s:string; const delim:boolean):string;
    procedure CompareCodes;
    procedure CompareCodetext;
    procedure CompareConstants;
    procedure UpdateSQLCodes;
  public
    procedure GoToCode( vRTF : TRichEdit );
    procedure ExecQuery;
    procedure OpenQuery;
  end;

var
  frmCodeEdit: TfrmCodeEdit;
  SpanishVowels: Boolean;

implementation

uses Data, Common, Support
{$IFDEF cdLibrary}
, Edit
{$ENDIF}
;

{$R *.DFM}

{ INITIALIZATION SECTION }

procedure TfrmCodeEdit.ExecQuery;
{var i : integer;
    f : textfile;
}
begin
{
  assignfile(f,'c:\query.txt');
  if fileexists('c:\query.txt') then
    append(f)
  else
    rewrite(f);
  with modlibrary.ww_Query do begin
    for i := 0 to sql.count-1 do
      writeln(f,sql[i]);
    writeln(f,'[Execute]');
    closefile(f);
  end;
}
  modlibrary.ww_Query.ExecSQL;
end;
procedure TfrmCodeEdit.OpenQuery;
{
var i : integer;
    f : textfile;
}
begin
{
  assignfile(f,'c:\query.txt');
  if fileexists('c:\query.txt') then
    append(f)
  else
    rewrite(f);
  with modlibrary.ww_Query do begin
    for i := 0 to sql.count-1 do
      writeln(f,sql[i]);
    writeln(f,'[Open]');
    closefile(f);
  end;
}
  modlibrary.ww_Query.open;
end;

procedure TfrmCodeEdit.FormCreate(Sender: TObject);
begin
  //deletefile('c:\query.txt');
  SetData;
  LoadLanguageCombo;
  with modlibrary do
    btnDelete.Enabled := ( tblCode.RecordCount > 0 ) and ( tblCodeFielded.Value = 0 );
  btnInsertFunc.enabled := btnDelete.Enabled;
  combobox1.ItemIndex := 0;
end;

{ configure the database to work with form:
    1. set various table handlers to react correctly for the form
    2. open secondary constant table (for display) }

procedure TfrmCodeEdit.SetData;
begin
  with modLibrary do begin
    //updateCodeTables;
    srcCode.OnStateChange := CodeStateChange;
    srcCodeText.OnStateChange := CodeStateChange;
    srcConstant.OnStateChange := CodeStateChange;
  end;
  tblConst.Open;
end;

{ fills the language combo box with all available languages:
    1. save previous working language
    2. load languages
    3. make sure speller is using the correct language dictionary }

procedure TfrmCodeEdit.LoadLanguageCombo;
var
  i : Word;
begin
  vOriginal := vLanguage;
  with modLibrary.tblLanguage, cmbLanguage do
  begin
    Clear;
    First;
    for i := 1 to RecordCount do
    begin
      Items.Add( modLibrary.tblLanguageLanguage.Value );
      Next;
    end;
    Locate( 'LangID', vLanguage, [ ] );
    ItemIndex := Items.IndexOf( modLibrary.tblLanguageLanguage.Value );
    modSupport.dlgSpell.DictionaryName := modLibrary.tblLanguageDictionary.Value;
  end;
end;

{ GENERAL METHODS }

{ creates rows in the code grid in response to checking the age, sex and doctor boxes }

procedure TfrmCodeEdit.DependencyRows( Sender : TObject );
begin
  with modLibrary do
    if tblCodeCode.IsNull then tblCode.Post;
  if modlibrary.tblcodefielded.value > 0 then
    MessageDlg( 'Used codes are not subject to modification.', mtWarning, [ mbOK ], 0 )
  else
    with modLibrary.tblCodeText do begin
      vLockCodeRows := False;
      First;
      while not EOF do Delete;
      if chkAge.Checked and chkSex.Checked and chkDoc.Checked then begin
        AppendRecord([ nil, 'Adult', 'Male', 'Group' ]);
        AppendRecord([ nil, 'Adult', 'Male', 'Doctor' ]);
        AppendRecord([ nil, 'Adult', 'Female', 'Group' ]);
        AppendRecord([ nil, 'Adult', 'Female', 'Doctor' ]);
        AppendRecord([ nil, 'Minor', 'Male', 'Group' ]);
        AppendRecord([ nil, 'Minor', 'Male', 'Doctor' ]);
        AppendRecord([ nil, 'Minor', 'Female', 'Group' ]);
        AppendRecord([ nil, 'Minor', 'Female', 'Doctor' ]);
      end else if chkAge.Checked and chkSex.Checked then begin
        AppendRecord([ nil, 'Adult', 'Male' ]);
        AppendRecord([ nil, 'Adult', 'Female' ]);
        AppendRecord([ nil, 'Minor', 'Male' ]);
        AppendRecord([ nil, 'Minor', 'Female' ]);
      end else if chkSex.Checked and chkDoc.Checked then begin
        AppendRecord([ nil, Null, 'Male', 'Group' ]);
        AppendRecord([ nil, Null, 'Male', 'Doctor' ]);
        AppendRecord([ nil, Null, 'Female', 'Group' ]);
        AppendRecord([ nil, Null, 'Female', 'Doctor' ]);
      end else if chkAge.Checked and chkDoc.Checked then begin
        AppendRecord([ nil, 'Adult', Null, 'Group' ]);
        AppendRecord([ nil, 'Adult', Null, 'Doctor' ]);
        AppendRecord([ nil, 'Minor', Null, 'Group' ]);
        AppendRecord([ nil, 'Minor', Null, 'Doctor' ]);
      end else if chkAge.Checked then begin
        AppendRecord([ nil, 'Adult' ]);
        AppendRecord([ nil, 'Minor' ]);
      end else if chkSex.Checked then begin
        AppendRecord([ nil, Null, 'Male' ]);
        AppendRecord([ nil, Null, 'Female' ]);
      end else if chkDoc.Checked then begin
        AppendRecord([ nil, Null, Null, 'Group' ]);
        AppendRecord([ nil, Null, Null, 'Doctor' ]);
      end else
        AppendRecord([ nil ]);
      First;
    end;
  vLockCodeRows := True;
  ( Sender as TDBCheckBox ).OnClick := nil;
end;

{ move to code (if any) embeded in the text of the calling form }

procedure TfrmCodeEdit.GoToCode( vRTF : TRichEdit );
{var
  vCode : Integer;}
begin
  {with vRTF do
  begin
    select protected text
    if vAsText then
    begin
      find in list
      get code
    end
    else
      get code
    modLibrary.tblCode.Locate( 'Code', vCode, [ ] );
  end;}
end;

{ BUTTON SECTION }

{ inserts selected constant into code grid at the cursor (or value text box):
    1. put constant into a string (in order to cast it as an integer pointer for API call)
    2. send space followed by backspace to grid cell so it registers a modification (API calls)
    3. send constant to grid cell (API call) }

procedure TfrmCodeEdit.InsertConstClick(Sender: TObject);
var
  vText : string;
begin
  with modLibrary do begin
    vText := '«' + tblConstConstant.Value + '»';
    if pos(vText,dgrText.selectedfield.text)=0 then begin
      SendMessage( GetFocus, WM_CHAR, VK_SPACE, 0 );
      SendMessage( GetFocus, WM_CHAR, VK_BACK, 0 );
      SendMessage( GetFocus, EM_REPLACESEL, 1, Integer( vText ) );
      tblCodeText.post;
    end else
      messagedlg('Can''t use the same constant twice in one code.',mterror,[mbok],0);
  end;
end;

procedure TfrmCodeEdit.SaveClick(Sender: TObject);
begin
  with modLibrary do if pclCode.ActivePage = shtCode then
  begin
    ActiveControl := dgrText;
    ActiveControl := detDescription;
    if tblCodeText.State <> dsBrowse then tblCodeText.Post;
    if tblCode.State <> dsBrowse then tblCode.Post;
  end
  else
    if tblConstant.State <> dsBrowse then begin
      ActiveControl := detValue;
      ActiveControl := detConstant;
      tblConstant.Post;
    end;
end;

procedure TfrmCodeEdit.NewClick(Sender: TObject);
begin
  with modLibrary do if pclCode.ActivePage = shtCode then
  begin
    detDescription.SetFocus;
    tblCode.Append;
    tblcodecode.value := getCodeID;
    tblCodeText.AppendRecord([ nil ]);
  end
  else
  begin
    detConstant.SetFocus;
    detConstant.ReadOnly := False;
    tblConstant.Append;
  end;
end;

function tFrmCodeEdit.GetCodeID:integer;
var userID:string;
begin
  randomize;
  userID := getuser + inttostr(random(100000));
  with modLibrary, ww_Query do begin
    sql.clear;
    sql.add('insert codes'+{_test}' (LangID,Description,Fielded) values '+
      '('+tblcodeLangid.asstring+','''+userID+''',-1)');
    ExecQuery;
    sql.clear;
    sql.add('Select code from Codes'+{_test}' where Description='''+userID+''' order by -code');
    OpenQuery;
    result:=fieldbyname('Code').value;
    close;
    sql.clear;
    sql.add('delete from codes'+{_test}' where code='+inttostr(result));
    ExecQuery;
  end;
end;

procedure TfrmCodeEdit.FindClick(Sender: TObject);
begin
  with modSupport, modLibrary do
  begin
    if pclCode.ActivePage = shtCode then
    begin
      dlgLocate.DataSource := srcCode;
      dlgLocate.SearchField := 'Description';
      dlgLocate.Caption := 'Locate Code';
    end
    else
    begin
      dlgLocate.DataSource := srcConstant;
      dlgLocate.SearchField := 'Constant';
      dlgLocate.Caption := 'Locate Constant';
    end;
    if dlgLocate.Execute then
    begin
      btnFirst.Enabled := True;
      btnNext.Enabled := True;
    end;
  end;
end;

procedure TfrmCodeEdit.FirstClick(Sender: TObject);
begin
  modSupport.dlgLocate.FindFirst;
  btnFirst.Enabled := False;
end;

procedure TfrmCodeEdit.NextClick(Sender: TObject);
begin
  btnNext.Enabled := modSupport.dlgLocate.FindNext;
end;

procedure TfrmCodeEdit.SpellClick(Sender: TObject);
begin
  with modSupport.dlgSpell do
    if DictionaryName = '' then
      MessageDlg( 'No ' + cmbLanguage.Text + ' language dictionary is available '
          + 'for a spell check', mtInformation, [ mbOK ], 0 )
    else begin
      Open;
      Show;
      case pclCode.ActivePage.PageIndex of
        0 : begin
              SpellCheck( detDescription );
              { need to check entries in grid: parse record, use CheckWord }
            end;
        1 : begin
              SpellCheck( detConstant );
              SpellCheck( detValue );
            end;
      end;
      Close;
    end;
end;

procedure TfrmCodeEdit.DeleteClick(Sender: TObject);
var codeid : string;
begin
  with modLibrary do begin
    if tblCodeFielded.value <> 0 then begin
      MessageDlg( 'Used codes are not subject to deletion.', mtWarning, [ mbOK ], 0 );
      Abort;
    end else begin
      codeid := tblcodecode.asstring;
      tblCode.Delete;
      localquery.close;
      localquery.sql.clear;
      localquery.sql.add('delete from codetext where code='+codeid);
      localquery.execsql;
    end;
    btnDelete.Enabled := ( tblCode.RecordCount > 0 ) and ( tblCodeFielded.Value = 0 );
    btnInsertFunc.enabled := btnDelete.Enabled;
  end;
end;

procedure TfrmCodeEdit.CloseClick(Sender: TObject);
begin
  SaveClick( nil );
  Close;
end;

{ COMPONENT HANDLER SECTION }

procedure TfrmCodeEdit.LanguageChange(Sender: TObject);
begin
  if cmblanguage.text = 'Spanish' then begin
    Panel1.caption := 'Press Alt-Space for accented characters';
    frmCodeEdit.Height := 358;
  end else begin
    Panel1.caption := '';
    frmCodeEdit.Height := 333;
  end;
  with modLibrary do
  begin
    tblLanguage.Locate( 'Language', cmbLanguage.Text, [ ] );
    vLanguage := tblLanguageLangID.Value;
    modSupport.dlgSpell.DictionaryName := tblLanguageDictionary.Value;
    tblCode.Refresh;
  end;
end;

{ calls dependencyRows in response to mouse click on age, sex or doctor }

procedure TfrmCodeEdit.DependencyMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then DependencyRows( Sender );
end;

{ calls dependencyRows in response to keyboard change of age, sex or doctor }

procedure TfrmCodeEdit.DepencencyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_SPACE then ( Sender as TDBCheckBox ).OnClick := DependencyRows;
end;

{ allows editing in constant text only if inserting (can not change an entered value) }

procedure TfrmCodeEdit.ConstantEnter(Sender: TObject);
begin
  with detConstant do ReadOnly := not ( DataSource.State in [ dsInsert ] );
end;

procedure TfrmCodeEdit.TextEnter(Sender: TObject);
begin
  btnInsert.Enabled := (( dgrText.SelectedField.FieldName = 'Text' ) and
    (modlibrary.tblCodeFielded.value=0));
end;

procedure TfrmCodeEdit.TextExit(Sender: TObject);
begin
  btnInsert.Enabled := False;
end;

procedure TfrmCodeEdit.ValueEnter(Sender: TObject);
begin
  btnInsert.Enabled := True;
end;

{ PAGE/TAB SECTION }

{ save changes when switching to another page }

procedure TfrmCodeEdit.PageChanging(Sender: TObject; var AllowChange: Boolean);
begin
  try
    SaveClick( nil );
  except
    on EDatabaseError do AllowChange := False; { show message? }
  end;
end;

{ configures tables and buttons to function with a different tab page }

procedure TfrmCodeEdit.PageChange(Sender: TObject);
begin
  if pclCode.ActivePage = shtCode then begin
    detDescription.SetFocus;
    with modLibrary do begin
      navCode.DataSource := srcCode;
      if tblConstant.RecordCount > 0 then tblConst.GoToCurrent( tblConstant );
      btnDelete.Enabled := ( tblCode.RecordCount > 0 ) and ( tblCodeFielded.Value = 0 );
      btnInsertFunc.enabled := btnDelete.Enabled;
    end;
    navCode.Hints.Clear;
    navCode.Hints.Add( 'First Code|' );
    navCode.Hints.Add( 'Prior Code|' );
    navCode.Hints.Add( 'Next Code|' );
    navCode.Hints.Add( 'Last Code|' );
    btnNew.Hint := 'New Code|';
    btnSave.Hint := 'Save Code|';
  end else begin
    detConstant.SetFocus;
    btnDelete.Enabled := False;
    btnInsertFunc.enabled := btnDelete.Enabled;
    with modLibrary do begin
      navCode.DataSource := srcConstant;
      if tblConst.RecordCount > 0 then
        tblConstant.GoToCurrent( tblConst );
    end;
    navCode.Hints.Clear;
    navCode.Hints.Add( 'First Constant|' );
    navCode.Hints.Add( 'Prior Constant|' );
    navCode.Hints.Add( 'Next Constant|' );
    navCode.Hints.Add( 'Last Constant|' );
    btnNew.Hint := 'New Constant|';
    btnSave.Hint := 'Save Constant|';
  end;
  btnFirst.Enabled := False;
  btnNext.Enabled := False;
end;

{ FINALIZATION SECTION }

{ warn of blank code text before closing dialog box }

procedure TfrmCodeEdit.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  with modLibrary do
  begin
    SaveClick(Sender);
    tblCodeText.DisableControls;
    try
      tblcodetext.mastersource := nil;
      if not tblCodeText.BOF then tblCodeText.First;
      while not tblCodeText.EOF do begin
        if tblCodeTextText.IsNull then begin
          if MessageDlg( 'There are blanks in code substitution text table.' + #13#10 +
              'Are the blanks valid substitution text for the code?', mtWarning,
              [ mbYes, mbNo ], 0 ) = mrNo then begin
            CanClose := False;
            pclCode.ActivePage := shtCode;
          end else begin
            tblcodetext.edit;
            tblcodetexttext.value := '°'; 
            tblcodetext.post;
          end;
          Break;
        end;
        tblCodeText.Next;
      end;
    finally
      tblCodeText.EnableControls;
      tblcodetext.mastersource := srcCode;
    end;
  end;
end;

{ undo database support for the dialog box and reset original language }

procedure TfrmCodeEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Hide;
  try
    with modLibrary do
    begin
      srcCode.OnStateChange := nil;
      srcCodeText.OnStateChange := nil;
      srcConstant.OnStateChange := nil;
    end;
    tblConst.Close;
    //updateSQLcodetables;
    updateSQLcodes; //GN02
  except
    on EDatabaseError do
    begin
      Action := caNone;
      Show;
      Raise;
    end;
  end;
  vLanguage := vOriginal;
end;

procedure TfrmCodeEdit.updateSQLcodetables;
var orgfiltered : boolean;
    q,x : string;
    curCode : integer;
  function fix(const s:string):string;
  begin
    result := s;
    while pos('''',result)>0 do
      result[pos('''',result)] := #1;
    while pos(#1,result)>0 do begin
      insert('''''',result,pos(#1,result));
      delete(result,pos(#1,result),1);
    end;
    result := '''' + result + '''';
  end;
  function SQLDelim(const s:string):string;
  var i : integer;
  begin
    result := '';
    for i := 1 to length(s) do begin
      if s[i]='«' then result := result + '''+@DelimCL+'''
      else if s[i]='»' then result := result + '''+@DelimCR+'''
      else result := result + s[i];
    end;
    while pos('''''+@DelimCL',result)>0 do
      delete(result,pos('''''+@DelimCL',result),3);
  end;
  function maybenull(const fld:string):string;
  begin
    if length(trim(LocalQuery.fieldbyname(fld).text))=0 then
      result := 'null'
    else
      result := '''' + LocalQuery.fieldbyname(fld).text + '''';
  end;
begin
  with modlibrary do begin
    tblcode.DisableControls;
    tblcodetext.disablecontrols;
    tblconstant.disablecontrols;
    ww_query.close;
    ww_query.sql.clear;
    q := 'Begin Transaction'+#10;
    with ww_Query do begin
      close;
      sql.clear;
      sql.add('select code from codes'+{_test}' where fielded<>1');
      OpenQuery;
    end;
    with tblcode do begin
      orgfiltered := filtered;
      if orgfiltered then filtered := false;
      first;
      while not eof do begin
        if (tblcodefielded.asinteger=1) and
            ww_Query.Locate('Code', tblcodecode.value, []) then
          q := q + 'update codes'+{_test}' set fielded=1 where code='+tblcodecode.asstring + #10;
        next;
      end;
    end;
    ww_Query.close;
    q := q + 'declare @DelimCL Char'+ #10;
    q := q + 'declare @DelimCR Char'+ #10;
    q := q + 'select @DelimCL = (select strParam_value from QualPro_params where strParam_nm=''CorrectLeft'' and strParam_grp=''Tag Delimiters'')'+ #10;
    q := q + 'select @DelimCR = (select strParam_value from QualPro_params where strParam_nm=''CorrectRight'' and strParam_grp=''Tag Delimiters'')'+ #10;
    q := q + 'delete from codestext'+{_test}' where code in (select code from codes'+{_test}' where abs(fielded)<>1)'+#10;
    q := q + 'delete from codes'+{_test}' where abs(fielded) <> 1' + #10;
    q := q + 'set identity_insert codes'+{_test}' on'+#10;
    with LocalQuery do begin
      close;
      sql.clear;
      sql.add('select c.code,c.Langid,c.description,ct.age,ct.sex,ct.doctor,ct.text');
      //sql.add('from codes c, codetext ct where c.code=ct.code and c.fielded<>1'); //GN02
      sql.add('from codes c, codetext ct where c.code=ct.code ');
      open;
      while not eof do begin
        CurCode := fieldbyname('Code').value;
        q := q + 'insert codes (code,langid,description,fielded) values ('+
            inttostr(curCode) + ',' +
            fieldbyname('Langid').asstring + ',' +
            fix(fieldbyname('Description').asstring) + ',0)' + #10;
        while (not eof) and (CurCode = fieldbyname('Code').value) do begin
          q := q + 'insert codestext'+{_test}' (code,age,sex,doctor,'+qpc_Text+') values '+
             '('+inttostr(curCode)+','+maybenull('age')+','+
             maybenull('sex')+','+maybenull('doctor')+','+
             SQLDelim(fix(fieldbyname('text').asstring))+')' + #10;
          next;
        end;
      end;
      close;
    end;
    q := q + 'set identity_insert codes'+{_test}' off';
    if orgfiltered then tblcode.filtered := true;
    if not dbQualPro.connected then
      dbQualPro.connected := true;
    ww_Query.sql.clear;
    ww_Query.sql.add(q);
    ww_Query.sql.add('Commit Transaction');
    //ww_Query.SQL.savetofile('c:\qryfile.txt'); GN01
    {ww_Query.}ExecQuery;

    with ww_Query do begin
      sql.clear;
      sql.add('select * from tag'+{_test}' order by tag');
      openQuery;
    end;
    with tblConstant do begin
      orgfiltered := filtered;
      if orgfiltered then filtered := false;
      first;
      q := '';
      while not eof do begin
        x := tblconstantconstant.asstring;
        if not ww_Query.Locate('Tag', x, []) then
          q := q + 'insert tag'+{_test}' (tag,tag_dsc) values ('+
              fix(tblconstantconstant.asstring)+','+
              fix(tblconstantvalue.asstring)+')'+#10
        else
          if tblconstantvalue.asstring <> ww_query.fieldbyname('Tag_dsc').asstring then
            q := q + 'update tag'+{_test}' set tag_dsc='+fix(tblconstantvalue.asstring)+
              ' where tag='+fix(tblconstantconstant.asstring)+#10;
        next;
      end;
      if orgfiltered then filtered := true;
    end;
    if q <> '' then
      with ww_Query do begin
        close;
        sql.clear;
        sql.add(q);
        ExecQuery;
      end;
    tblcode.EnableControls;
    tblcodetext.Enablecontrols;
    tblconstant.Enablecontrols;
  end;
end;

procedure TfrmCodeEdit.dgrTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (cmblanguage.text = 'Spanish') and ((Shift = [ssAlt]) and (Key = VK_Space)) then begin
    SpanishVowels := true;
    panel1.caption := 'Press a, e, i, o, u, n, ?, or !';
  end;
end;

procedure TfrmCodeEdit.dgrTextKeyPress(Sender: TObject; var Key: Char);
begin
  if SpanishVowels then begin
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
    Panel1.caption := 'Press Alt-Space for accented characters';
  end;
  SpanishVowels := false;
  with modLibrary.tblCodeText do
    if eof and ((state=dsInsert) or (state=dsEdit)) then cancel;
end;

procedure TfrmCodeEdit.detDescriptionExit(Sender: TObject);
begin
  if detDescription.Text = '' then begin
    messagebeep(0);
    activeControl := detDescription;
  end;
end;

procedure TfrmCodeEdit.navCodeClick(Sender: TObject; Button: TNavigateBtn);
begin
  if pclCode.ActivePage = shtCode then begin
    with modLibrary do
      btnDelete.Enabled := ( tblCode.RecordCount > 0 ) and ( tblCodeFielded.Value = 0 );
    btnInsertFunc.enabled := btnDelete.Enabled;
  end;
end;

procedure TfrmCodeEdit.btnInsertFuncClick(Sender: TObject);
var s,t,c : string;
sp,tp,tl : integer;
st : boolean;
begin
  t := tTable(dgrText.datasource.dataset).fieldbyname('Text').asstring;
  tp := pos('«',t);
  if tp=0 then
    messagedlg('There are no constants/tags in the current substitution text.  Each function needs a constant/tag.',mtinformation,[mbok],0)
  else begin
    tl := 1 + pos('»',t) - tp;
    c := copy(t,tp,tl);
    delete(t,tp,tl);

    s := combobox1.text;
    s := copy(s,1,pos(']',s));
    sp := pos('«',s);
    delete(s,sp,2);

    insert(c,s,sp);
    insert(s,t,tp);
    with tTable(dgrText.datasource.dataset) do begin
      st := (state=dsBrowse);
      if st then edit;
      fieldbyname('Text').value := t;
      if st then post;
    end;
  end;
end;

function TfrmCodeEdit.SQLString(const s:string; const delim:boolean):string;
var i,c : integer;
begin
  result := '''';
  c := 0;
  for i := 1 to length(s) do begin
    if (s[i]<#32) then begin
      //result := result + '''+char('+inttostr(ord(s[i]))+')+''';
      //c := 0;
    end else if (s[i]>#126) then begin
      result := result + s[i];
      inc(c);
    end else if s[i]='''' then begin
      result := result + '''''';
      inc(c,2);
    end else begin
      result := result + s[i];
      inc(c);
    end;
    if c>=250 then begin
      if delim then result := result + '''' + chr(1) + ''''
      else          result := result + '''+''';
      c := 0;
    end;
  end;
  result := result + '''';
  if delim then result := result + chr(1);
  //while pos('+''''+',result)>0 do delete(result,pos('+''''+',result),3);
end;


procedure TfrmCodeEdit.CompareCodes;
var
   s,s2,q : string;
   curCode : integer;
begin
  with modLibrary do
  begin
    ww_Query.close;
    ww_Query.DatabaseName := 'dbQualPro';
    ww_Query.sql.clear;
    ww_Query.sql.add('select code,langid,description from codes order by code');
    ww_Query.Open;

    LocalQuery.Close;
    LocalQuery.sql.clear;
    LocalQuery.sql.add('select code,langid,description from codes order by code');
    LocalQuery.Open;

    memo1.lines.add('set identity_insert codes on');
    while not LocalQuery.eof do
    begin
      curCode := LocalQuery.fieldbyname('code').value;
      if ww_Query.Locate('Code',curcode,[]) then
      begin
        s := 'update codes set ';
        s2 := ' ';

        if LocalQuery.fieldbyname('LangID').value <> ww_Query.fieldbyname('LangID').value then
        begin
          s := s + 'LangID='+LocalQuery.fieldbyname('LangID').asstring+',';
          s2 := s2 + '/* '+ww_Query.fieldbyname('LangID').asstring + ' */';
        end;

        if LocalQuery.fieldbyname('description').value <> ww_Query.fieldbyname('description').value then
        begin
          s := s + 'Description='+sqlstring(LocalQuery.fieldbyname('description').asstring,false)+',';
          s2 := s2 + '/* '+sqlstring(ww_Query.fieldbyname('description').asstring,false) + ' */';
        end;

        if s <> 'update codes set ' then begin
          s := copy(s,1,length(s)-1);
          memo1.lines.add(s + ' where code='+LocalQuery.fieldbyname('code').asstring + s2);
        end;
        //end else
        //  memo2.lines.add('code '+LocalQuery.fieldbyname('code').asstring+' OK');
      end
      else
      begin
        memo1.lines.add('insert into codes (code,langid,description,fielded) values (' +
          LocalQuery.fieldbyname('Code').asstring + ','+
          LocalQuery.fieldbyname('LangID').asstring+','+
          sqlstring(LocalQuery.fieldbyname('description').asstring,false) + ',1)');
      end;//if
      LocalQuery.next;
    end;//while
    LocalQuery.close;
    memo1.lines.add('set identity_insert codes off');
    ww_Query.close;
  end;//with modLibrary
end;

procedure TfrmCodeEdit.CompareCodetext;
var s,s2 : string;
  curCode:string;
  a,sx,d,fnd : boolean;
  function diffdelim(const src:string):string;
  begin
    result := src;
    while pos('«',result)>0 do result[pos('«',result)] := '®';
    while pos('»',result)>0 do result[pos('»',result)] := '¯';
    if Pos('·',modLibrary.ww_Query.fieldbyname(qpc_text).value) > 0 then
       if src[1] = ' ' then result[1] := '·';
  end;
begin
  with modLibrary do
  begin
    ww_Query.close;
    ww_Query.databasename := 'dbQualPro';
    ww_Query.sql.clear;
    ww_Query.sql.Add('select codetext_id,code,age,sex,doctor,'+qpc_text+' from codestext order by code,age,sex,doctor');
    ww_Query.Open;

    LocalQuery.Close;
    LocalQuery.sql.clear;
    //LocalQuery.sql.add('select code,age,sex,doctor,text from codetext order by code,age,sex,doctor'); //error key violation
    LocalQuery.sql.add('select t.code,t.age,t.sex,t.doctor,t.text  ');
    LocalQuery.sql.add('from codetext t, codes c where t.code=c.code ');
    LocalQuery.sql.add('order by t.code,t.age,t.sex,t.doctor');
    LocalQuery.Open;

    while not LocalQuery.eof do begin
      curCode := LocalQuery.fieldbyname('code').asstring+'.'+LocalQuery.fieldbyname('age').asstring+'.'+
                 LocalQuery.fieldbyname('sex').asstring+'.'+LocalQuery.fieldbyname('doctor').asstring;
      a := (LocalQuery.fieldbyname('age').asstring = '');
      sx := (LocalQuery.fieldbyname('sex').asstring = '');
      d := (LocalQuery.fieldbyname('doctor').asstring = '');
      fnd := false;
      if a and sx and d then
        fnd := ww_Query.Locate('code',LocalQuery.fieldbyname('code').value,[])
      else if a and sx then
        fnd := ww_Query.Locate('code;doctor',vararrayof([LocalQuery.fieldbyname('code').value,LocalQuery.fieldbyname('doctor').value]),[])
      else if a and d then
        fnd := ww_Query.Locate('code;sex',vararrayof([LocalQuery.fieldbyname('code').value,LocalQuery.fieldbyname('sex').value]),[])
      else if sx and d then
        fnd := ww_Query.Locate('code;age',vararrayof([LocalQuery.fieldbyname('code').value,LocalQuery.fieldbyname('age').value]),[])
      else if a then
        fnd := ww_Query.Locate('code;sex;doctor',vararrayof([LocalQuery.fieldbyname('code').value,LocalQuery.fieldbyname('sex').value,LocalQuery.fieldbyname('doctor').value]),[])
      else if sx then
        fnd := ww_Query.Locate('code;age;doctor',vararrayof([LocalQuery.fieldbyname('code').value,LocalQuery.fieldbyname('age').value,LocalQuery.fieldbyname('doctor').value]),[])
      else if d then
        fnd := ww_Query.Locate('code;age;sex',vararrayof([LocalQuery.fieldbyname('code').value,LocalQuery.fieldbyname('age').value,LocalQuery.fieldbyname('sex').value]),[])
      else
        fnd := ww_Query.Locate('code;age;sex;doctor',vararrayof([LocalQuery.fieldbyname('code').value,LocalQuery.fieldbyname('age').value,LocalQuery.fieldbyname('sex').value,LocalQuery.fieldbyname('doctor').value]),[]);
      if fnd then begin
        s := 'update codestext set ';
        s2 := ' ';
        if (trim(diffdelim(LocalQuery.fieldbyname('text').value))) <> trim(ww_Query.fieldbyname(qpc_text).value) then begin
          s := s + qpc_text+'='+sqlstring(LocalQuery.fieldbyname('text').asstring,false)+',';
          s2 := s2 + '/* '+curcode + ' ' + sqlstring(ww_Query.fieldbyname(qpc_text).asstring,false) + ' */';
          if (s = 'update codestext set '+qpc_text+'=''°'',') and (ww_Query.fieldbyname(qpc_text).asstring='') then
            s := 'update codestext set ';
        end;
        if s <> 'update codestext set ' then begin
          s := copy(s,1,length(s)-1);
          if s = 'update codestext set '+qpc_text+'=''°''' then
            s := 'update codestext set '+qpc_text+'=''''';
          memo1.lines.add(s + ' where codetext_id='+ww_Query.fieldbyname('codetext_id').asstring + s2);
        end;
        //end else
          //memo2.lines.add('code '+curcode+' OK');
      end else begin

        s := 'insert into codestext (code,';
        s2 := ') values (' + LocalQuery.fieldbyname('Code').asstring + ',' ;
        if not LocalQuery.fieldbyname('age').isnull then begin
          s := s + 'age,';
          s2 := s2 + ''''+LocalQuery.fieldbyname('age').asstring + ''',';
        end;
        if not LocalQuery.fieldbyname('sex').isnull then begin
          s := s + 'sex,';
          s2 := s2 + ''''+LocalQuery.fieldbyname('sex').asstring + ''',';
        end;
        if not LocalQuery.fieldbyname('doctor').isnull then begin
          s := s + 'doctor,';
          s2 := s2 + ''''+LocalQuery.fieldbyname('doctor').asstring + ''',';
        end;
        s := s + qpc_text;
        if LocalQuery.fieldbyname('text').asstring = '°' then
          s2 := s2 + ''''')'
        else
          s2 := s2 + sqlstring(LocalQuery.fieldbyname('text').asstring,false) + ')';
        memo1.lines.add(s+s2);
      end;
      LocalQuery.next;
    end;
    LocalQuery.close;
    ww_Query.close;
  end;

end;

procedure TfrmCodeEdit.CompareConstants;
var s,s2 : string;
begin
  with modLibrary do
  begin
    ww_Query.close;
    ww_Query.DatabaseName := 'dbQualPro';
    ww_Query.sql.clear;
    ww_Query.sql.add('select tag,tag_dsc from tag order by tag');
    ww_Query.Open;

    LocalQuery.Close;
    LocalQuery.sql.clear;
    LocalQuery.sql.add('select * from constants order by constant');
    LocalQuery.Open;

    while not LocalQuery.eof do begin
      if ww_Query.Locate('Tag',LocalQuery.fieldbyname('constant').value,[]) then begin
        s := 'update tag set ';
        s2 := ' ';
        if LocalQuery.fieldbyname('value').value <> ww_Query.fieldbyname('tag_dsc').value then begin
          s := s + 'tag_dsc='+sqlstring(LocalQuery.fieldbyname('value').asstring,false)+',';
          s2 := s2 + '/* '+sqlstring(ww_Query.fieldbyname('tag_dsc').asstring,false) + ' */';
        end;
        if s <> 'update tag set ' then begin
          s := copy(s,1,length(s)-1);
          memo1.lines.add(s + ' where tag='+sqlstring(LocalQuery.fieldbyname('constant').asstring,false) + s2);
        end;// else
        //memo2.lines.add('tag '+LocalQuery.fieldbyname('constant').asstring+' OK');
      end else begin
        memo1.lines.add('insert into tag (tag,tag_dsc) values (' +
          sqlstring(LocalQuery.fieldbyname('constant').asstring,false) + ','+
          sqlstring(LocalQuery.fieldbyname('value').asstring,false) + ')');
      end;
      LocalQuery.next;
    end;
    LocalQuery.close;
    ww_Query.close;
  end;

end;

procedure TfrmCodeEdit.UpdateSQLCodes();
var
   i : integer;
begin
   memo1.lines.Clear ;
   try
      CompareCodes;
      CompareCodeText;
      CompareConstants;

      with modLibrary.ww_Query do
      begin
         i := 0;
         sql.clear;
         while i < memo1.lines.Count do
         begin
            sql.add(memo1.lines[i]);
            inc(i);
{            if sql.Count > 20 then //INC0022439 fix for Juan 2/26/2014
            begin
              ExecSQL;
              sql.clear;
            end;}
         end;
         if sql.Count > 0 then
         begin
            ExecSQL;
            sql.clear;
         end;
      end;
   except
      on E:EDatabaseError do
      begin
         MessageDlg(E.Message, mtError, [mbOK], 0);
         if memo1.Lines.Count > 0 then
         begin
            memo1.Lines.SaveToFile('C:\temp\codessql.txt');
            WinExec('notepad c:\temp\codessql.txt',SW_SHOWNORMAL);
         end;
      end;
      on E:Exception do MessageDlg(E.Message, mtError, [mbOK], 0);
   end;
end;

end.

