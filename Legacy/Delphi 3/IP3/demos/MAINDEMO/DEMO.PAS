unit Demo;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, grdlook, TabNotBk, search, demoloc,
  ExtCtrls, grdmemo, wwstr,
  shellapi, DB, DBTables, Wwtable, Wwdatsrc, Wwmemo, combos,
  packtest, isearch, qbe, Wwdbgrid, DBCtrls, FltEvent, grdbitmp, pictures,
  multi, filtdlg, lkdtl, lkquery, grdbttn, ComCtrls, wwriched, wwrich, rcdvw,
  Wwintl, savefilt;

type
  TMainDemo = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    GroupBox1: TGroupBox;
    Button3: TButton;
    GroupBox2: TGroupBox;
    Button4: TButton;
    Label6: TLabel;
    Button5: TButton;
    GroupBox3: TGroupBox;
    Button6: TButton;
    GroupBox4: TGroupBox;
    Button7: TButton;
    Panel1: TPanel;
    Button2: TButton;
    Label24: TLabel;
    Button9: TButton;
    GroupBox6: TGroupBox;
    Button11: TButton;
    GroupBox7: TGroupBox;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Button10: TButton;
    Label31: TLabel;
    GroupBox5: TGroupBox;
    Button12: TButton;
    Button13: TButton;
    Memo2: TMemo;
    Button14: TButton;
    Button15: TButton;
    Memo4: TMemo;
    Memo5: TMemo;
    Memo6: TMemo;
    Memo8: TMemo;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    wwDBRichEdit1: TwwDBRichEdit;
    Button1: TButton;
    wwDBRichEdit2: TwwDBRichEdit;
    wwDBRichEdit3: TwwDBRichEdit;
    wwDBRichEdit4: TwwDBRichEdit;
    wwDBRichEdit5: TwwDBRichEdit;
    wwDBRichEdit6: TwwDBRichEdit;
    wwDBRichEdit7: TwwDBRichEdit;
    Memo11: TMemo;
    GroupBox8: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    RadioGroup1: TRadioGroup;
    wwIntl1: TwwIntl;
    wwDBRichEditDemo: TwwDBRichEdit;
    Button20: TButton;
    Button8: TButton;
    procedure Demo1ButtonClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure DemoButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainDemo: TMainDemo;

implementation

{$R *.DFM}

procedure TMainDemo.Demo1ButtonClick(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TGridDemo.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button6Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TIncrSearch.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button7Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TLocate.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button8Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TSaveFilterDemo.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.DemoButtonClick(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TGridMemoApp.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button2Click(Sender: TObject);
begin
  wwDBRichEdit1.execute;
end;

procedure TMainDemo.Button9Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TLookupForm.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button11Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TPackMain.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button10Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TQBEForm.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button4Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TSearchForm.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button12Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TFilterEventForm.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button13Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TBitmapForm.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button14Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TPictureForm.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button15Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TMultiSelectForm.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button16Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TFilterDialogForm.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button17Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TDetailComboForm.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button18Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TTableQueryForm.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;

procedure TMainDemo.Button19Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TBtnGridForm.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end
end;


procedure TMainDemo.Button1Click(Sender: TObject);
begin
   Screen.cursor:= crHourGlass;
   with TRecordViewDemoForm.create(Application) do begin
      Screen.cursor:= crDefault;
      ShowModal;
      Free;
   end

end;



procedure TMainDemo.RadioGroup1Click(Sender: TObject);
begin
   if (Sender as TRadioGroup).ItemIndex=0 then
      wwIntl1.CheckBoxInGridStyle := cbStyleCheckmark
   else
      wwIntl1.CheckBoxInGridStyle := cbStyleXmark;
   wwIntl1.Connected := false;
   wwIntl1.Connected := true;
end;

procedure TMainDemo.CheckBox2Click(Sender: TObject);
begin
   if (Sender as TCheckBox).checked then
      wwIntl1.DialogFontStyle := wwIntl1.DialogFontStyle + [fsBold]
   else
      wwIntl1.DialogFontStyle := wwIntl1.DialogFontStyle - [fsBold];
   wwIntl1.Connected := false;
   wwIntl1.Connected := true;

end;

procedure TMainDemo.CheckBox1Click(Sender: TObject);
begin
   wwIntl1.OKCancelBitmapped := (Sender as TCheckBox).checked;
   wwIntl1.Connected := false;
   wwIntl1.Connected := true;
end;




procedure TMainDemo.Button20Click(Sender: TObject);
begin
   wwDBRichEditDemo.execute;
end;

procedure TMainDemo.FormShow(Sender: TObject);
begin
  ShortDAteFormat:= 'mm/dd/yyyy';
end;

end.
