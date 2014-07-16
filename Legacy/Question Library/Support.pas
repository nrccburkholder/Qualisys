unit Support;

{ data module containing all non-visual non-database components (menus, dialogs) }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Spell32, Wwlocate, Menus, Wwfltdlg, stdctrls, db, comctrls, dbctrls;

type
  TmodSupport = class(TDataModule)
    popRTF: TPopupMenu;
    mniInsert: TMenuItem;
    mniDelete: TMenuItem;
    N1: TMenuItem;
    mniBold: TMenuItem;
    mniItalic: TMenuItem;
    mniUnderline: TMenuItem;
    dlgLocate: TwwLocateDialog;
    dlgSpell: TSpellDlg;
    dlgFilter: TwwFilterDialog;
    procedure RTFPopup(Sender: TObject);
    procedure InsertClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure BoldClick(Sender: TObject);
    procedure ItalicClick(Sender: TObject);
    procedure UnderlineClick(Sender: TObject);
    procedure FilterInitDialog(Dialog: TwwFilterDlg);
    procedure CheckMe(fld: tCustomEdit; ds: tdatasource; const frmopen,frmclose:boolean);
    procedure modSupportCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  modSupport: TmodSupport;

implementation

uses Data, DBRichEdit, common;

{$R *.DFM}

{ POPUP MENU }

{ initializes the popup menu before displaying it
    1. move focus to calling rich edit
    2. show delete item if in protected text
    3. show insert item if code insert dialog is open
    4. set other options }

procedure TmodSupport.RTFPopup(Sender: TObject);
var
  i : Integer;
begin
  with modSupport.popRTF.PopupComponent as TclDBRichCodeBtn do
  begin
    if not Focused then SetFocus;
    mniDelete.Visible := SelAttributes.Protected;
    for i := 0 to Pred( Screen.FormCount ) do
    begin
      if Screen.Forms[ i ].Name = 'frmCode' then
      begin
        mniInsert.Visible := True;
        Break;
      end;
      mniInsert.Visible := False;
    end;
    N1.Visible := ( mniDelete.Visible or mniInsert.Visible );
    mniBold.Checked := ( fsBold in SelAttributes.Style ) and
        ( caBold in SelAttributes.ConsistentAttributes );
    mniItalic.Checked := ( fsItalic in SelAttributes.Style ) and
        ( caItalic in SelAttributes.ConsistentAttributes );
    mniUnderline.Checked := ( fsUnderline in SelAttributes.Style ) and
        ( caUnderline in SelAttributes.ConsistentAttributes );
  end;
end;

procedure TmodSupport.InsertClick(Sender: TObject);
//var fieldedcode:string;
begin
  with popRTF.PopupComponent as TclDBRichCodeBtn do EmbedCode( modLibrary.tblCodeCode.AsString );
  //fieldedcode := '';
  with modlibrary do
    if tblcodefielded.value <> 1 then begin
      tblcode.edit;
      tblcodefielded.value := 1;
      tblcode.post;
      //fieldedcode := tblcodefielded.asstring;
    end;
  (*
  if fieldedcode <> '' then
    with modlibrary.ww_Query do begin
      close;
      databasename := '_QualPro';
      sql.clear;
      sql.add('Update codes set fielded=1 where code='+fieldedcode);
      execsql;
    end;
  *)
end;

procedure TmodSupport.DeleteClick(Sender: TObject);
begin
  with popRTF.PopupComponent as TclDBRichCodeBtn do RemoveCode;
end;

procedure TmodSupport.BoldClick(Sender: TObject);
begin
  with popRTF.PopupComponent as TclDBRichCodeBtn do DoBold;
end;

procedure TmodSupport.ItalicClick(Sender: TObject);
begin
  with popRTF.PopupComponent as TclDBRichCodeBtn do DoItalic;
end;

procedure TmodSupport.UnderlineClick(Sender: TObject);
begin
  with popRTF.PopupComponent as TclDBRichCodeBtn do DoUnderline;
end;

{ FILTER DIALOG }

{ removes the bold style from the dialog before displaying it }

procedure TmodSupport.FilterInitDialog(Dialog: TwwFilterDlg);
begin
  Dialog.Font.Style := [ ];
end;

procedure TmodSupport.CheckMe(fld : tCustomEdit; ds:tdatasource; const frmopen,frmclose:boolean);
begin
  with dlgSpell do begin
    ds.dataset.edit;
    closewin := false;
    if frmopen then show;
    if dlgSpell.SpellCheck( fld ) = mrOK then begin
      ds.dataset.post
    end else
      ds.dataset.cancel;
    if frmClose then close;
    closewin := true;
  end;
end;

procedure TmodSupport.modSupportCreate(Sender: TObject);
var s : string;
begin
  s := AliasPath('Question');
  delete(s,pos('LIBRARY',uppercase(s)),7);
  s := s + 'Dictionaries';
  dlgSpell.dictionaryPath := s;
end;

end.
