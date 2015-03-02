unit Wwprppic;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, wwdblook, StdCtrls, DB, DBTables, Wwtable, Wwdatsrc,
  Wwdbdlg, wwidlg, Mask, Wwdbedit, Wwdotdot, wwdbigrd, Buttons, ExtCtrls,
  wwpicdb, Grids, Wwdbgrid;

type
  TwwEditPictureForm = class(TForm)
    wwTable1: TwwTable;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    NewPicture: TwwDBLookupComboDlg;
    PictureDescription: TMemo;
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    wwPictureEdit1: TwwDBEdit;
    Label1: TLabel;
    Button3: TButton;
    Status: TPanel;
    AutoFill: TCheckBox;
    Button4: TButton;
    procedure NewPictureChange(Sender: TObject);
    procedure wwPictureEdit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure wwLookupDialog1UserButton1Click(Sender: TObject;
      LookupTable: TDataSet);
    procedure NewPictureInitDialog(Dialog: TwwLookupDlg);
    procedure wwDBLookupComboDlg1Change(Sender: TObject);
    procedure NewPictureCloseUp(Sender: TObject;
      LookupTable: TDataSet; FillTable: TDataset; modified: Boolean);
    procedure NewPictureUserButton1Click(Sender: TObject;
      LookupTable: TDataSet);
    procedure AutoFillClick(Sender: TObject);
    procedure NewPictureUserButton2Click(Sender: TObject;
      LookupTable: TDataSet);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    Component: TwwCustomMaskEdit;

    Function CreateNewPicture(ALookupTable: TTable): boolean;

  public
    { Public declarations }
  end;

var
  wwEditPictureForm: TwwEditPictureForm;

Function wwPrpEdit_PictureMask(AComponent: TwwCustomMaskEdit): boolean;

implementation

{$R *.DFM}

uses wwcommon, wwlocate;

Function wwPrpEdit_PictureMask(AComponent: TwwCustomMaskEdit): boolean;
begin
    result:= False;
    with TwwEditPictureForm.create(Application) do try
       Component:=AComponent;
       if ShowModal=mrOK then begin
          component.Picture.PictureMask:= NewPicture.text;
          component.Picture.AutoFill:= AutoFill.checked;
          result:= True;
       end
    finally
       Free;
    end;
end;

procedure TwwEditPictureForm.NewPictureChange(Sender: TObject);
begin
   wwPictureEdit1.Picture.PictureMask:= NewPicture.Text;
end;

procedure TwwEditPictureForm.wwPictureEdit1Change(Sender: TObject);
begin
   if wwPictureEdit1.isValidPictureValue(wwPictureEdit1.text) then
      Status.caption:= 'Value is valid'
   else Status.caption:= 'Picture does not accept value';
end;

procedure TwwEditPictureForm.Button1Click(Sender: TObject);
begin
   if wwPictureEdit1.isValidPictureMask(NewPicture.text) then
      Status.caption:= 'Invalid Picture Syntax'
   else Status.caption:= 'Picture is valid';
end;

procedure TwwEditPictureForm.FormShow(Sender: TObject);
begin
   wwOpenPictureDB(wwtable1);

   if Component<>Nil then begin
      NewPicture.text:= Component.Picture.PictureMask;
      NewPicture.LookupValue:= NewPicture.Text;
      AutoFill.checked:= Component.Picture.AutoFill;
   end
end;

procedure TwwEditPictureForm.Button2Click(Sender: TObject);
begin
   if Component<>Nil then begin
      NewPicture.text:= Component.Picture.PictureMask;
      AutoFill.checked:= Component.Picture.AutoFill;
   end
end;

procedure TwwEditPictureForm.wwLookupDialog1UserButton1Click(Sender: TObject;
  LookupTable: TDataSet);
begin
   with (Sender as TwwLookupDlg) do begin
      wwdbgrid1.Options:= wwdbgrid1.options + [dgEditing] - [dgRowSelect];
   end;
   LookupTable.insert;
end;

procedure TwwEditPictureForm.NewPictureInitDialog(Dialog: TwwLookupDlg);
begin
   if not wwtable1.active then exit;
   Dialog.wwdbgrid1.RowHeightPercent := 190;

   if not wwtable1.wwFindRecord(NewPicture.Text, 'Mask', mtExactMatch, False) then
   begin
      wwtable1.indexFieldName:= 'Desc';
      wwtable1.First;
   end
   else wwtable1.indexFieldName:= 'Desc';
   wwtable1.FieldByName('Desc').index:= 0;
{
   if not wwtable1.FindKey([NewPicture.Text]) then
   begin
      wwtable1.indexName:= 'iDesc';
      wwtable1.First;
   end
   else wwtable1.indexName:= 'iDesc';
}
end;

procedure TwwEditPictureForm.wwDBLookupComboDlg1Change(Sender: TObject);
begin
   wwPictureEdit1.Picture.PictureMask:= NewPicture.Text;
   if not wwtable1.active then exit;

   if wwtable1.wwFindRecord(NewPicture.Text, 'Mask', mtExactMatch, False) then
      PictureDescription.Text:= wwtable1.FieldByName('Desc').asString
   else PictureDescription.Text:= 'Mask not found in database';
{
   if wwtable1.indexName<>'iMask' then wwtable1.indexName:='iMask';
   if wwtable1.FindKey([NewPicture.Text]) then
      PictureDescription.Text:= wwtable1.FieldByName('Desc').asString
   else PictureDescription.Text:= 'Mask not found in database';
   }
end;

procedure TwwEditPictureForm.NewPictureCloseUp(Sender: TObject;
  LookupTable: TDataSet; FillTable: TDataset; modified: Boolean);
begin
    if modified then begin
       PictureDescription.text:= lookupTable.fieldByName('Desc').asString;
       wwPictureEdit1.text:= '';
    end
end;

procedure TwwEditPictureForm.NewPictureUserButton1Click(Sender: TObject;
  LookupTable: TDataSet);
begin
   Screen.cursor:= crHourGlass;
   with TwwEditMaskForm.create(Application) do begin
      PictureTable.GotoCurrent(LookupTable as TwwTable);
      Screen.cursor:= crDefault;
      if ShowModal = mrOK then
      begin
         (LookupTable as TwwTable).gotoCurrent(PictureTable);
      end;
      wwDataSource1.dataset:= Nil;
      Free;
   end
end;

Function TwwEditPictureForm.CreateNewPicture(ALookupTable: TTable): boolean;
begin
   result:= false;
   if not wwtable1.active then exit;

   Screen.cursor:= crHourGlass;
   with TwwEditMaskForm.create(Application) do begin
      Screen.cursor:= crDefault;
      if wwtable1.wwFindRecord(NewPicture.Text, 'Mask', mtExactMatch, False) then
{      if wwtable1.FindKey([NewPicture.Text]) then}
      begin
         if MessageDlg('Mask already exists.  Would you like to enter a new description for this mask?',
            mtInformation, [mbYes, mbNo], 0) = mrYes then
            PictureTable.goToCurrent(wwtable1)
         else begin
            Free;
            exit;
         end
      end
      else begin
          PictureTable.insert;
          PictureTable.FieldByName('Mask').asString:= NewPicture.Text;
      end;

      if ShowModal = mrOK then begin
         PictureTable.checkBrowseMode;
         if ALookupTable<>Nil then ALookupTable.gotoCurrent(PictureTable);
         result:= True;
      end;
      Free;
   end
end;

procedure TwwEditPictureForm.AutoFillClick(Sender: TObject);
begin
   wwPictureEdit1.Picture.AutoFill:= AutoFill.checked;
end;

procedure TwwEditPictureForm.NewPictureUserButton2Click(Sender: TObject;
  LookupTable: TDataSet);
begin
   if MessageDlg('Are you sure you wish to delete this picture mask?',
            mtInformation, [mbYes, mbNo], 0) = mrYes then
      LookupTable.delete;
end;

procedure TwwEditPictureForm.Button3Click(Sender: TObject);
begin
   if wwPictureEdit1.isValidPictureValue(wwPictureEdit1.text) then
      Status.caption:= 'Value is valid'
   else Status.caption:= 'Picture does not accept value';
end;

procedure TwwEditPictureForm.Button4Click(Sender: TObject);
begin
   if CreateNewPicture(wwTable1) then
   begin
   end
end;

procedure TwwEditPictureForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (key=vk_f1) then wwHelp(Handle, 'Design Picture Mask Dialog Box')
end;

end.
