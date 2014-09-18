unit REEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CDK_Comp, DBRichEdit, StdCtrls, ComCtrls, ExtCtrls, Buttons, Wwtable,
  Wwdatsrc, DB, DBTables, Spin, printers, Mask, DBCtrls;

type
  TfrmREEdit = class(TForm)
    pnlToolBar: TPanel;
    clCodeToggle1: TclCodeToggle;
    btnCode: TSpeedButton;
    DSCodes: TDataSource;
    tCodes: TTable;
    tConstant: TTable;
    wDStext: TwwDataSource;
    wTText: TwwTable;
    wTTextText: TBlobField;
    tCodesCode: TAutoIncField;
    tCodesLangID: TIntegerField;
    tCodesDescription: TStringField;
    tCodesFielded: TSmallintField;
    tCodesAge: TBooleanField;
    tCodesSex: TBooleanField;
    tCodesDoctor: TBooleanField;
    tConstantConstant: TStringField;
    tConstantValue: TStringField;
    tCodeText: TTable;
    cbFonts: TComboBox;
    cbFontSize: TComboBox;
    Button1: TButton;
    Button2: TButton;
    btnLeftJustify: TSpeedButton;
    btnCenter: TSpeedButton;
    btnRightJustify: TSpeedButton;
    btnSpellCheck: TSpeedButton;
    editBlankLines: TSpinEdit;
    lblBlankLines: TLabel;
    btnNewCode: TSpeedButton;
    Label1: TLabel;
    wTTextLabel: TStringField;
    DBEdit1: TDBEdit;
    BorderWidth: TSpinEdit;
    Label2: TLabel;
    clDBRichCodeBtn1: TclDBRichCodeBtn;
    pnlShading: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel9: TPanel;
    Panel11: TPanel;
    procedure btnCodeClick(Sender: TObject);
    procedure tCodeTextFilterRecord(DataSet: TDataSet;
      var Accept: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure cbFontsChange(Sender: TObject);
    procedure clDBRichCodeBtn1SelectionChange(Sender: TObject);
    procedure cbFontSizeChange(Sender: TObject);
    procedure clDBRichCodeBtn1ProtectChange(Sender: TObject; StartPos,
      EndPos: Integer; var AllowChange: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnLeftJustifyClick(Sender: TObject);
    procedure btnCenterClick(Sender: TObject);
    procedure btnRightJustifyClick(Sender: TObject);
    procedure btnSpellCheckClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure clDBRichCodeBtn1KeyPress(Sender: TObject; var Key: Char);
    procedure clDBRichCodeBtn1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Panel1Click(Sender: TObject);
    procedure editBlankLinesChange(Sender: TObject);
  private
    { Private declarations }
    SpanishVowels : boolean;
  public
    { Public declarations }
  end;

var
  frmREEdit: TfrmREEdit;
  ChangeFormatOnly : boolean;

implementation

uses  Code, support,common, uLayoutCalc;

{$R *.DFM}

procedure TfrmREEdit.btnCodeClick(Sender: TObject);
begin
  if btnCode.Down then begin
    if vAsText then begin
      clCodeToggle1.text.down := false;
      clCodeToggle1.Text_ClickTransfer(sender);
    end;
    clCodeToggle1.enabled := false;
    frmCode := TfrmCode.Create( Self );
    frmCode.vForm := frmREEdit;
    Hide;

    frmCode.Top := ( Screen.Height - frmCode.Height ) div 2;
    if Screen.Width < ( frmCode.Width + Width ) then begin
      frmCode.Left := 2;
      Left := Screen.Width - ( Width + 2 );
    end else begin
      frmCode.Left := ( Screen.Width - frmCode.Width - Width - 4 ) div 2;
      Left := frmCode.Left + frmCode.Width + 4;
    end;
    frmCode.vForm := Self;
    Show;
    frmCode.Show;
  end else begin
    clCodeToggle1.enabled := false;
    frmCode.Close;
    frmCode.free;
  end;
end;

procedure TfrmREEdit.tCodeTextFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := ((( DataSet[ 'Age' ] = vAge[1] ) OR ( DataSet[ 'Age' ] = Null )) AND
            (( DataSet[ 'Sex' ] = vSex[1] ) OR ( DataSet[ 'Sex' ] = Null )) AND
            (( DataSet[ 'Doctor' ] = vDoc[1] ) OR ( DataSet[ 'Doctor' ] = Null )));
end;

procedure TfrmREEdit.FormActivate(Sender: TObject);
var i:integer;
begin
  if clDBRichCodeBtn1.font.name = 'Arial' then cbFonts.itemindex := 0;
  if clDBRichCodeBtn1.font.name = 'Arial Narrow' then cbFonts.itemindex := 1;
  cbFontSize.itemindex := clDBRichCodeBtn1.font.size-9;
  for i:=0 to Panel11.ControlCount -1 do
    if tpanel(Panel11.Controls[i]).color = pnlShading.Color then
    begin
       Panel1Click(Panel11.Controls[i]);
       break;
    end;

end;

procedure TfrmREEdit.cbFontsChange(Sender: TObject);
begin
  ChangeFormatOnly := true;
  if cbFonts.itemindex = 0 then clDBRichCodeBtn1.SelAttributes.name := 'Arial';
  if cbFonts.itemindex = 1 then clDBRichCodeBtn1.SelAttributes.name := 'Arial Narrow';
  ActiveControl := clDBRichCodeBtn1;
  ChangeFormatOnly := false;
end;

procedure TfrmREEdit.clDBRichCodeBtn1SelectionChange(Sender: TObject);
begin
  if clDBRichCodeBtn1.SelAttributes.name = 'Arial' then cbFonts.itemindex := 0;
  if clDBRichCodeBtn1.SelAttributes.name = 'Arial Narrow' then cbFonts.itemindex := 1;
  cbFontsize.itemindex := clDBrichCodeBtn1.SelAttributes.size-9;
end;

procedure TfrmREEdit.cbFontSizeChange(Sender: TObject);
begin
  ChangeFormatOnly := true;
  clDBrichCodeBtn1.SelAttributes.size := cbFontSize.itemindex + 9;
  ActiveControl := clDBRichCodeBtn1;
  ChangeFormatOnly := false;
end;

procedure TfrmREEdit.clDBRichCodeBtn1ProtectChange(Sender: TObject;
  StartPos, EndPos: Integer; var AllowChange: Boolean);
begin
  AllowChange := ChangeFormatOnly;
  if (StartPos+EndPos=0) and (clCodeToggle1.enabled) then begin
    clDBRichCodeBtn1.SelStart := 0;
    clDBRichCodeBtn1.SelLength := 1;
    if clDBRichCodeBtn1.SelText <> '{' then begin
      clDBRichCodeBtn1.SelAttributes.Protected := false;
      clDBRichCodeBtn1.SelAttributes.Color := clBlack;
      AllowChange := true;
    end;
    clDBRichCodeBtn1.SelLength := 0;
  end;
end;

procedure TfrmREEdit.Button1Click(Sender: TObject);
var i,L : integer;
begin
  if dsEdit <= wtText.state then
    wtText.post;
  with clDBRichCodeBtn1 do begin
    {replace tabs with eight spaces}
    selectall;
    if pos(#9,seltext) > 0 then begin
      wtText.edit;
      L := length(seltext);
      i := 0;
      while i < L do begin
        selstart := i;
        sellength := 1;
        if (sellength=1) and (ord(seltext[1])=9) then begin
          seltext := '        ';
          L := L + 7;
        end;
        inc(i);
      end;
      wtText.post;
    end;
    selstart := 0;
    selLength := 0;
  end;
  clDBRichCodeBtn1.wordwrap := false;
//  if (editBlankLines.visible) and (clDBRichCodeBtn1.lines.count > 1) then
//    messagedlg('The text in a comment box will be wrapped automatically.  You cannot use returns to wrap text in a specific place.',mterror,[mbok],0)
//  else begin
    if clDBRichCodeBtn1.lines.count>20 then
      messagedlg('There is a limit of 20 paragraphs -- you have '+inttostr(clDBRichCodeBtn1.lines.count)+'. (Blank lines count as paragraphs).',mterror,[mbok],0)
      {modify PGraph array to [0..(limit+5)] in tfrmLayoutCalc.PCLTextBox to change limit}
    else begin
      wtTextText.SaveToFile(AliasPath('PRIV')+'\RichEdit.rtf');
      modalresult := mrOK;
    end;
//  end;
  clDBRichCodeBtn1.wordwrap := true;
end;

procedure TfrmREEdit.Button2Click(Sender: TObject);
begin
  Modalresult := mrCancel;
end;

procedure TfrmREEdit.btnLeftJustifyClick(Sender: TObject);
begin
  clDBRichCodeBtn1.Paragraph.Alignment := taLeftJustify;
end;

procedure TfrmREEdit.btnCenterClick(Sender: TObject);
begin
  clDBRichCodeBtn1.Paragraph.Alignment := taCenter;
end;

procedure TfrmREEdit.btnRightJustifyClick(Sender: TObject);
begin
  clDBRichCodeBtn1.Paragraph.Alignment := taRightJustify;
end;

procedure TfrmREEdit.btnSpellCheckClick(Sender: TObject);
begin
  if wtText.state = dsEdit then wtText.post;
  modsupport.checkme(clDBRichCodeBtn1,wDStext);

end;

procedure TfrmREEdit.FormDestroy(Sender: TObject);
begin
  tCodes.close;
  tConstant.close;
  wTText.close;
  tCodeText.close;
end;

procedure TfrmREEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if btnCode.Down then btnCodeClick(Sender);
  vAsText := false;
end;

procedure TfrmREEdit.FormCreate(Sender: TObject);
begin
  tCodes.open;
  tConstant.open;
  wTText.open;
  tCodeText.open;
  modSupport.dlgSpell.DictionaryName := 'English.dct';
  ChangeFormatOnly := false;
  SpanishVowels := false;
  clDBRichCodeBtn1.PopupMenu := modSupport.popRTF; 
end;

procedure TfrmREEdit.clDBRichCodeBtn1KeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key='{') or (key='}') then begin
    messagedlg('Braces "{" & "}" are not allowed!',mterror,[mbok],0);
    key:=' ';
  end else if SpanishVowels then
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
  SpanishVowels := false;
  Label1.caption := 'Press F5 for accented characters';
end;

procedure TfrmREEdit.clDBRichCodeBtn1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=116) then begin
    SpanishVowels := true;
    Label1.caption  := 'Press a, e, i, o, u, n, ?, or !';
  end;
end;

procedure TfrmREEdit.Panel1Click(Sender: TObject);
var i:integer;
begin
  for i:= 0 to panel11.ControlCount  - 1 do
  begin
    tPanel(panel11.Controls[i]).caption:= '';
  end;

  if  editblanklines.value = 0 then
  begin
    tPanel(sender).caption:= 'ü';
    pnlShading.color := tPanel(sender).color;
  end
  else
    pnlShading.color := clWhite;




end;

procedure TfrmREEdit.editBlankLinesChange(Sender: TObject);
begin
  if editBlankLines.Value > 0 then
  begin
    pnlShading.Enabled := false;
    pnlShading.Color := clWhite;
    Panel1Click(pnlShading);
  end
  else
    pnlShading.Enabled := true;

end;

end.
