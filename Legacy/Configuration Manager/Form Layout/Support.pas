unit Support;

{ data module containing all non-visual non-database components (menus, dialogs) }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {Spell32,} Wwlocate, Menus, Wwfltdlg, stdctrls, db, comctrls, Spell32;

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
    dlgFilter: TwwFilterDialog;
    DlgSpell: TSpellDlg;
    procedure RTFPopup(Sender: TObject);
    procedure InsertClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure BoldClick(Sender: TObject);
    procedure ItalicClick(Sender: TObject);
    procedure UnderlineClick(Sender: TObject);
    procedure FilterInitDialog(Dialog: TwwFilterDlg);
    procedure CheckMe(fld: tCustomEdit; ds: tdatasource);
    procedure modSupportCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  modSupport: TmodSupport;

implementation

uses  DBRichEdit, REEdit, dataMod, common, DOpenQ, Code, fTrans, FDynaQ;

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
  try
    with modSupport.popRTF.PopupComponent as TclDBRichCode{Btn} do
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
  except
  end;
end;

procedure TmodSupport.InsertClick(Sender: TObject);
//var fieldedcode:string;
begin
 try
   if frmCode <> nil then
    if frmCode.vForm.caption = 'Translation' then begin
      frmTranslation.tCodeText.findkey([frmTranslation.tCodesCode.value]);
      with frmTranslation.clDBRichCodeBtnFrgn do EmbedCode( frmTranslation.tCodesCode.AsString );
      with frmTranslation do begin
        if tCodesFielded.value <> 1 then begin
          tcodes.edit;
          tcodesfielded.value := 1;
          tcodes.post;
        end;
      end;
    end else if frmCode.vform.name = 'F_DynaQ' then begin
      F_DynaQ.tCodeText.findkey([F_DynaQ.tCodesCode.value]);
      with F_DynaQ.DBRESelQstnText do
        EmbedCode( F_DynaQ.tCodesCode.AsString );
      with F_DynaQ do begin
        if tCodesFielded.value <> 1 then begin
          tcodes.edit;
          tcodesfielded.value := 1;
          tcodes.post;
        end;
      end;
    end else begin
      frmREEdit.tCodeText.findkey([frmREEdit.tCodesCode.value]);
      with popRTF.PopupComponent as TclDBRichCodeBtn do
        EmbedCode( frmREEdit.tCodesCode.AsString );
      with frmREEdit do begin
        if tCodesFielded.value <> 1 then begin
          tcodes.edit;
          tcodesfielded.value := 1;
          tcodes.post;
        end;
      end;
    end;
  except
  end;
end;

procedure TmodSupport.DeleteClick(Sender: TObject);
begin
  with popRTF.PopupComponent as TclDBRichCode{Btn} do RemoveCode;
end;

procedure TmodSupport.BoldClick(Sender: TObject);
begin
  try
    with popRTF.PopupComponent as TclDBRichCodeBtn do DoBold;
  except
    with popRTF.PopupComponent as TclDBRichCode do
      if fsBold in selattributes.style then
        selattributes.style := selattributes.Style - [ fsBold ]
      else
        selattributes.style := selattributes.Style + [ fsBold ];
  end;
end;

procedure TmodSupport.ItalicClick(Sender: TObject);
begin
  try
    with popRTF.PopupComponent as TclDBRichCodeBtn do DoItalic;
  except
    with popRTF.PopupComponent as TclDBRichCode do
      if fsItalic in selattributes.style then
        selattributes.style := selattributes.Style - [ fsItalic ]
      else
        selattributes.style := selattributes.Style + [ fsItalic ];
  end;
end;

procedure TmodSupport.UnderlineClick(Sender: TObject);
begin
  try
    with popRTF.PopupComponent as TclDBRichCodeBtn do DoUnderline;
  except
    with popRTF.PopupComponent as TclDBRichCode do
      if fsUnderline in selattributes.style then
        selattributes.style := selattributes.Style - [ fsUnderline ]
      else
        selattributes.style := selattributes.Style + [ fsUnderline ];
  end;
end;

{ FILTER DIALOG }

{ removes the bold style from the dialog before displaying it }

procedure TmodSupport.FilterInitDialog(Dialog: TwwFilterDlg);
begin
  Dialog.Font.Style := [ ];
end;

procedure TmodSupport.CheckMe(fld : tCustomEdit; ds:tdatasource);
var mr:integer;
begin
  with dlgSpell do begin
    ds.dataset.edit;
    closewin := false;
    show;
    dlgSpell.tag := dlgSpell.SpellCheck(fld);
    if dlgSpell.tag <> mrCancel then
      ds.dataset.post
    else
      ds.dataset.cancel;
    close;
  end;
end;

procedure TmodSupport.modSupportCreate(Sender: TObject);
var s : string;
begin
  s := AliasPath('Question');
  delete(s,pos('LIBRARY',uppercase(s)),255);
  s := s + 'Dictionaries';
  dlgSpell.dictionaryPath := s;
end;

end.


