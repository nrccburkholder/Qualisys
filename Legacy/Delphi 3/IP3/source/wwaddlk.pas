unit Wwaddlk;
{
//
// Property Dialog : Add Lookup Link Dialog
//
// Copyright (c) 1995 by Woll2Woll Software
//
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, db, DBTables, Buttons, wwGtTbl, wwcommon, wwstr,
  Wwtable;

type
  TwwAddLookupForm = class(TForm)
    TableNameCaption: TGroupBox;
    Label6: TLabel;
    FieldNameComboBox: TComboBox;
    GroupBox2: TGroupBox;
    MasterFieldsCaption: TLabel;
    IndexFieldsCaption: TLabel;
    Label7: TLabel;
    MasterFieldsList: TListBox;
    IndexFieldsList: TListBox;
    IndexComboBox: TComboBox;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    JoinedFieldsList: TListBox;
    Label5: TLabel;
    Button1: TButton;
    AddJoinButton: TBitBtn;
    Button2: TButton;
    Table1: TwwTable;
    procedure IndexComboBoxChange(Sender: TObject);
    procedure IndexFieldsListClick(Sender: TObject);
    procedure MasterFieldsListClick(Sender: TObject);
    procedure AddJoinButtonClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FieldNameComboBoxChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
    MasterTable: TDataSet;
    firstTime: Boolean;

  public
    databaseName, tableName, fieldName, indexName, indexFields, joins: string;
    useExtension: char;

    { Public declarations }
    constructor create(AOwner: TComponent); override;
  end;

var
  wwAddLookupForm: TwwAddLookupForm;

function wwAddLookupfield(
   var aDbName, aTblName, aFieldName, aIndex: wwSmallString;
   var aIndexFields: string;
   var aJoins: string;
   var aUseExtension: char;
   aMasterTable: TDataSet): boolean;

implementation

type
  ListInitType = set of (initDatabase, initTable, initField, initIndex,
         initIndexfield, initJoin);

  SmallString = string[64];

constructor TWwAddLookupForm.create(AOwner: TComponent);
begin
   inherited create(AOwner);
   databaseName:= 'ezcust';
   tableName:= 'EZCUST.DB';
   fieldName:= 'LAST NAME';
   useExtension:= 'Y';
   indexName:= '';
   indexFields:= '';
   firstTime:= True;
end;

procedure checkOKEnable(form: TwwAddLookupForm);
var newEnable: boolean;
begin
  with form do begin
     newEnable:=
      (JoinedFieldsList.items.count>0) and
      (FieldNameComboBox.Text<>'');

     if newEnable <>OKBtn.enabled then
        OKBtn.enabled:= newEnable;
  end
end;

procedure checkJoinEnable(form: TwwAddLookupForm);
var newEnable: boolean;
begin
   with Form do begin
      newEnable:=
         (MasterFieldsList.itemIndex>=0) and
         (IndexFieldsList.itemIndex>=0) and
         (MasterFieldsList.items.count>0) and
         (IndexFieldsList.items.count>0);

      if newEnable<> AddJoinButton.enabled then
         AddJoinButton.enabled:= newEnable;
   end
 end;

procedure AddJoin(form: TwwAddLookupForm; s1, s2: SmallString);
begin
   with form do begin
      if (s1='') or (s2='') then exit;

      JoinedFieldsList.items.add(s1 + ' -> ' + s2);
      MasterFieldsList.items.delete(MasterFieldsList.items.indexOf(s1));
      IndexFieldsList.items.delete(IndexFieldsList.items.indexOf(s2));
      checkOKEnable(form);
   end
end;

procedure addJoins(myForm: TwwAddLookupForm);
var parts: TStrings;
    i: integer;
begin
   parts:= TStringList.create;

   strBreakApart(myForm.joins, ';', parts);
   if parts.count>1 then begin
      for i:= 0 to ((parts.count-1) div 2) do begin
         AddJoin(myForm, parts[i*2], parts[i*2+1]);
      end;
   end;

   parts.free;
end;

function wwAddLookupfield(
   var aDbName, aTblName, aFieldName, aIndex: wwSmallString;
   var aIndexFields: string;
   var aJoins: string;
   var aUseExtension: char;
   aMasterTable: TDataSet): boolean;
var myForm: TwwAddLookupForm;
    i, linkPos: integer;
    tempStr: String[128];
begin
   myForm:= TwwAddLookupForm.create(Application);

   with myForm do
   try
      databaseName:= aDbName;
      tableName:= aTblName;
      fieldname:= aFieldname;
      indexName:= aIndex;
      indexFields:= aIndexFields;
      joins:= aJoins;
      MasterTable:= aMasterTable;
      useExtension:= aUseExtension;

      Result := ShowModal = IDOK;

      if Result then begin
         aDbName:= table1.databasename;
         aTblName:= table1.tableName;
         aUseExtension:= useExtension;
         aFieldName:= fieldNameComboBox.Text;
         if indexComboBox.Text='PrimaryKey' then aIndex:= ''
         else aIndex:= indexComboBox.Text;
         aIndexFields:= Table1.IndexToFields(aIndex);

         with JoinedFieldsList do begin
            joins:= '';
            for i:= 0 to items.count-1 do begin
               tempStr:= items[i];
               linkPos:= pos(' -> ', TempStr);
               if linkPos>0 then begin
                  delete(TempStr, linkPos, 4);
                  insert(';', TempStr, linkPos);
                  joins:= joins + TempStr;
                  if i<items.count-1 then joins:= joins + ';';
               end
            end
         end;
         aJoins:= joins;
      end;

   finally
      Free;
   end
end;

{$R *.DFM}

procedure LoadMasterFieldsList(form :TwwAddLookupForm);
var i: integer;
begin
   with form do begin
     MasterFieldsList.items.clear;
     with MasterTable do for i:= 0 to fieldCount-1 do
        if not fields[i].calculated then MasterFieldsList.items.add(fields[i].fieldName);
   end
end;

procedure updateComboBoxes(
      form :TwwAddLookupForm;
      initCombo: ListInittype;
      aDatabaseName, aTableName, aFieldname, aIndexname: SmallString);
var i, j: integer;
    joinFound: boolean;

    procedure setIndexComboBox(aindexname: SmallString);
    var i: integer;
    begin
       with form.indexComboBox do begin
          for i:= 0 to items.count-1 do begin
             if lowercase(items[i])=lowercase(aindexname) then
             begin
                itemIndex:= i;
                break;
             end
          end
       end
    end;

begin
  with form do begin
    { change database }
    if initDatabase in initCombo then Table1.databaseName:= aDatabaseName;

    { change table }
    if ([initDatabase, initTable] * initCombo) <>[] then begin
       Table1.tableName:= aTableName;
       TableName:= aTableName;
       if aTableName='' then begin
          FieldNameComboBox.items.clear;
          IndexComboBox.items.clear;
          IndexfieldsList.items.clear;

          FieldNameComboBox.text:= '';
          IndexComboBox.text:= '';
          exit;
       end
       else begin
          IndexFieldsCaption.caption:= 'Index Fields (' + lowercase(aTableName) + ')';

          TableNameCaption.caption:= 'Select Displayed Field ('
                       + aDatabasename + ', ' + aTableName + ')';

          { Update field name list }
          Table1.ReadOnly:= True;
          Table1.active:= True;
          FieldNameComboBox.items.clear;
          if indexFields<>'' then begin
             indexName:= Table1.FieldsToIndex(indexFields);  { Translate fields to index }
             aIndexName:= indexName; { 4/3/97}
          end;
          Table1.getFieldNames(FieldNameComboBox.items);
          Table1.active:= False;

          { Update index list }
          IndexComboBox.items.clear;
          Table1.IndexDefs.update;  { refreshes Index list }
          Table1.getIndexNames(IndexComboBox.items);
          if Table1.IndexDefs.IndexOf('')>=0 then
          begin
             IndexComboBox.items.Insert(0, 'PrimaryKey');
             setIndexcomboBox('PrimaryKey');
          end
          else begin
             IndexComboBox.itemIndex:= 0;
          end;

          if aFieldName='' then FieldNameCombobox.itemIndex:= -1
          else FieldnameComboBox.Text:= aFieldname;

       end;
    end;

    { change index }
    if ([initDatabase, initTable, initIndex] * initCombo) <>[] then begin
       if (aIndexName = '') then setIndexComboBox('PrimaryKey')
       else setIndexComboBox(aIndexName);
       if Table1.IndexDefs.IndexOf(aIndexName)>=0 then begin
          with Table1.IndexDefs.Items[Table1.IndexDefs.IndexOf(aIndexName)] do begin
             strBreakApart(fields, ';', IndexFieldsList.items);
          end
       end
       else begin
          with Table1.IndexDefs.Items[0] do begin
             strBreakApart(fields, ';', IndexFieldsList.items);
          end;
          aIndexName:= Table1.IndexDefs.Items[0].name;
       end;
       JoinedFieldsList.items.clear;
       checkOKEnable(form);

{       OKBtn.enabled:= False;}
       LoadMasterFieldsList(form);
    end;

    { Make best guess at linked fields }
    if ([initJoin] * initCombo) <>[] then begin
{       MessageDlg('add joins', mtInformation, [mbok], 0);}
{       for i:= 0 to IndexFieldsList.items.count-1 do begin
          for j:= 0 to MasterFieldsList.items.count-1 do begin}

       i:= 0;
       while (i<=indexFieldsList.items.count-1) do begin
          j:= 0;
          joinFound:= False;
          while (j<=masterFieldsList.items.count-1) do begin
              if lowercase(IndexFieldsList.items[i])=
                 lowercase(MasterFieldsList.items[j]) then
              begin
                 AddJoin(form, MasterFieldsList.items[j], IndexFieldsList.items[i]);
                 joinFound:= True;
                 break;
              end
              else j:= j + 1;
          end;
          if not joinFound then i:= i + 1;
       end;

       AddJoinButton.enabled := False;

    end;
  end;

  checkJoinEnable(form);

end;

procedure TwwAddLookupForm.IndexComboBoxChange(Sender: TObject);
var indexTitle: SmallString;
begin
   IndexTitle:= IndexComboBox.Text;
   if Indextitle='PrimaryKey' then Indextitle:= '';
   updateComboBoxes(self, [initIndex,initJoin], '', '', '', IndexTitle);
end;

procedure TwwAddLookupForm.IndexFieldsListClick(Sender: TObject);
begin
   checkJoinEnable(self);
end;

procedure TwwAddLookupForm.MasterFieldsListClick(Sender: TObject);
begin
   checkJoinEnable(self);
end;

procedure TwwAddLookupForm.AddJoinButtonClick(Sender: TObject);
begin
    AddJoin (self, MasterFieldsList.items[MasterFieldsList.itemIndex],
             IndexFieldsList.items[IndexFieldsList.itemIndex]);
    AddJoinButton.enabled:= False;
end;

procedure TwwAddLookupForm.Button1Click(Sender: TObject);
var indexTitle: SmallString;
begin
   IndexTitle:= IndexComboBox.Text;
   if Indextitle='PrimaryKey' then Indextitle:= '';
   if JoinedFieldsList.items.count=0 then exit;
   updateComboBoxes(self, [initIndex], '', '', '', IndexTitle);
end;

procedure TwwAddLookupForm.Button2Click(Sender: TObject);
begin
   if wwGetTableDlg(databaseName, tableName, useExtension) then begin
      updateComboBoxes(self, [initDatabase, initTable, initJoin],
                       databaseName, tableName, '', '');
{      TableNameCaption.caption:= ':' + databaseName + ':' + tableName;}
   end
end;

procedure TwwAddLookupForm.FormActivate(Sender: TObject);
begin
    if firstTime and (databaseName <> '') then begin
       LoadMasterFieldsList(self);
       MasterFieldsCaption.caption:= 'Master Fields (' + lowercase(wwGetTableName(MasterTable)) + ')';
       updateComboBoxes(self, [initDatabase], databaseName, tableName, fieldName, indexName);
       addJoins(self);
       firstTime:= False;
    end
end;

procedure TwwAddLookupForm.FieldNameComboBoxChange(Sender: TObject);
begin
    checkOKEnable(self);
end;

procedure TwwAddLookupForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (key=vk_f1) then wwHelp(Handle, 'Edit Linked Field Dialog Box')
end;

end.
