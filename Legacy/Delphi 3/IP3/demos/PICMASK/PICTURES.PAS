unit Pictures;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Wwdbspin, StdCtrls, Mask, Wwdbedit, TabNotBk, DB,
  DBTables, Wwtable, Wwdatsrc, ExtCtrls, DBCtrls;

type
  TPictureForm = class(TForm)
    wwTable1: TwwTable;
    TabbedNotebook1: TTabbedNotebook;
    ColorEdit: TwwDBEdit;
    ZipEdit: TwwDBEdit;
    PhoneEdit: TwwDBEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CapitalFirstEdit: TwwDBEdit;
    CapitalizedWordsEdit: TwwDBEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ResetButton: TButton;
    wwDataSource1: TwwDataSource;
    DateDBEdit: TwwDBSpinEdit;
    PhonDBEdit: TwwDBEdit;
    Zip_DBEdit: TwwDBEdit;
    wwTable1CustomerNo: TIntegerField;
    wwTable1Buyer: TStringField;
    wwTable1CompanyName: TStringField;
    wwTable1FirstName: TStringField;
    wwTable1LastName: TStringField;
    wwTable1Street: TStringField;
    wwTable1City: TStringField;
    wwTable1State: TStringField;
    wwTable1Zip: TStringField;
    wwTable1FirstContactDate: TDateField;
    wwTable1PhoneNumber: TStringField;
    wwTable1Information: TMemoField;
    wwTable1RequestedDemo: TStringField;
    wwTable1Logical: TBooleanField;
    Label8: TLabel;
    Label9: TLabel;
    Label2: TLabel;
    DBNavigator1: TDBNavigator;
    RadioGroup1: TRadioGroup;
    Memo1: TMemo;
    wwTable2: TwwTable;
    Bevel1: TBevel;
    PictureLabel: TLabel;
    TimeStampEdit: TwwDBEdit;
    AutoFillCheckbox: TCheckBox;
    AutoFillBound: TCheckBox;
    procedure ResetButtonClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure wwEditsEnter(Sender: TObject);
    procedure wwEditsExit(Sender: TObject);
    procedure ResetButtonEnter(Sender: TObject);
    procedure AutoFillCheckboxClick(Sender: TObject);
    procedure EditCheckValue(Sender: TObject;
      PassesPictureTest: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PictureForm: TPictureForm;

implementation

{$R *.DFM}

procedure TPictureForm.ResetButtonClick(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to ComponentCount - 1 do
    if (Components[i] is TwwDBEdit) and
      ((Components[i] as TwwDBEdit).DataSource = nil) then
      (Components[i] as TwwDBEdit).clear;
end;

procedure TPictureForm.RadioGroup1Click(Sender: TObject);
var i : integer;
    yesno : boolean;
begin
  if RadioGroup1.Itemindex = 0 then yesno := True else yesno := False;
  for i := 0 to ComponentCount - 1 do
  begin
     if Components[i] is TwwDBCustomEdit then with TwwDBCustomEdit(Components[i]) do
        if (DataSource <> nil) then UsePictureMask := yesno
  end;
end;

procedure TPictureForm.FormShow(Sender: TObject);
var
  MyComponent: TwwDBCustomEdit;
  i : integer;
  MyLabel : TLabel;

begin
  if wwtable2.indexName <> 'iMask' then wwtable2.indexName:='iMask';
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TwwDBCustomEdit then
    begin
      MyComponent := Components[i] as TwwDBCustomEdit;
      if wwTable2.FindKey([MyComponent.Picture.PictureMask]) then
         MyComponent.Hint := wwTable2.FieldByName('Desc').AsString;
    end
    else if (components[i] is TLabel) and ((components[i] as TLabel).Name[1] in ['Z', 'D', 'I']) then
    begin
      MyLabel := components[i] as TLabel;
      MyComponent:= FindComponent(Copy(MyLabel.Name, 1, 4) + 'DBEdit') as TwwDBCustomEdit;
      MyLabel.Caption := MyComponent.Picture.PictureMask;
    end;
  end;
end;

procedure TPictureForm.wwEditsEnter(Sender: TObject);
begin
  PictureLabel.Caption := 'Picture: ' + (Sender as TwwDBCustomEdit).Picture.PictureMask;
end;

procedure TPictureForm.wwEditsExit(Sender: TObject);
begin
  PictureLabel.Caption := '';
end;

procedure TPictureForm.ResetButtonEnter(Sender: TObject);
begin
  PictureLabel.Caption := 'Clear all the Edit Boxes of content';
end;

procedure TPictureForm.AutoFillCheckboxClick(Sender: TObject);
var i: integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
     if Components[i] is TwwDBCustomEdit then with TwwDBCustomEdit(Components[i]) do
        if (TabbedNotebook1.pageIndex=1) xor (DataSource = nil) then { Control is on current tab page }
           Picture.AutoFill := (Sender as TCheckBox).Checked;
  end;
end;


{ Show control in yellow during editing when the edited value does not pass the
  picture mask test }
procedure TPictureForm.EditCheckValue(Sender: TObject;
  PassesPictureTest: Boolean);
begin
  if PassesPictureTest then
     (Sender as TwwDBCustomEdit).Color:= clWhite
  else (Sender as TwwDBCustomEdit).Color:= clYellow
end;

end.
