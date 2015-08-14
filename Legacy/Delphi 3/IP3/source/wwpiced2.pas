unit Wwpiced2;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, wwdblook, Wwdbdlg, ExtCtrls, Buttons, DB,
  DBTables, Wwtable, wwidlg, wwdbedit;

type
  TwwEditPictureMaskdlg = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Panel1: TPanel;
    AllowInvalidCheckbox: TCheckBox;
    AutoFillCheckbox: TCheckBox;
    PictureDescription: TMemo;
    PictureMaskEdit: TwwDBLookupComboDlg;
    PictureMaskLabel: TLabel;
    wwTable1: TwwTable;
    DesignMaskButton: TButton;
    UsePictureMask: TCheckBox;
    procedure PictureMaskEditChange(Sender: TObject);
    procedure PictureMaskEditCloseUp(Sender: TObject;
      LookupTable: TDataSet; FillTable: TDataset; modified: Boolean);
    procedure PictureMaskEditInitDialog(Dialog: TwwLookupDlg);
    procedure FormShow(Sender: TObject);
    procedure DesignMaskButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    MyComponent: TwwCustomMaskEdit;
  public
    { Public declarations }
  end;

  Function wwPrpEdit_PictureMask2(AComponent: TwwCustomMaskEdit): boolean;

var
  wwEditPictureMaskdlg: TwwEditPictureMaskdlg;

implementation

{$R *.DFM}
uses wwprppic, wwcommon, wwdatsrc, wwlocate;

Function wwPrpEdit_PictureMask2(AComponent: TwwCustomMaskEdit): boolean;
var component: TwwCustomMaskEdit;
begin
    result:= False;
{    if AComponent is TwwDBCustomEdit then with AComponent as TwwDBCustomEdit do
       if not (DataSource is TwwDataSource) then begin
           MessageDlg('TwwDataSource required for InfoPower''s picture masks.',
                         mtWarning, [mbok], 0);
       end;
}
    with TwwEditPictureMaskDlg.create(Application) do try
       Component:=AComponent;
       MyComponent:= component;

       if ShowModal=mrOK then begin
          component.Picture.PictureMask:= PictureMaskEdit.text;
          component.Picture.AutoFill:= AutoFillCheckbox.checked;
          component.Picture.AllowInvalidExit:= AllowInvalidCheckbox.checked;
          component.UsePictureMask:= UsePictureMask.checked;
          result:= True;
       end
    finally
       Free;
    end;
end;

procedure TwwEditPictureMaskdlg.PictureMaskEditChange(Sender: TObject);
begin
   if not wwtable1.active then exit;

   if wwtable1.wwFindRecord(PictureMaskEdit.Text, 'Mask', mtExactMatch, False) then
      PictureDescription.Text:= wwtable1.FieldByName('Desc').asString
   else PictureDescription.Text:= 'Mask not found in database';

{   if not wwtable1.active then exit;
   if wwtable1.indexName<>'iMask' then wwtable1.indexName:='iMask';
   if wwtable1.FindKey([PictureMaskEdit.Text]) then
      PictureDescription.Text:= wwtable1.FieldByName('Desc').asString
   else PictureDescription.Text:= 'Mask not found in database';
}
end;

procedure TwwEditPictureMaskdlg.PictureMaskEditCloseUp(Sender: TObject;
  LookupTable: TDataSet; FillTable: TDataset; modified: Boolean);
begin
    if modified then begin
       PictureDescription.text:= lookupTable.fieldByName('Desc').asString;
    end
end;

procedure TwwEditPictureMaskdlg.PictureMaskEditInitDialog(Dialog: TwwLookupDlg);
begin
   if not wwtable1.active then exit;

   if not wwtable1.wwFindRecord(PictureMaskEdit.Text, 'Mask', mtExactMatch, False) then
   begin
      wwtable1.indexFieldName:= 'Desc';
      wwtable1.First;
   end
   else wwtable1.indexFieldName:= 'Desc';
   wwtable1.FieldByName('Desc').index:= 0;

{   if not wwtable1.active then exit;
   wwtable1.indexName:='iMask';
   if not wwtable1.FindKey([PictureMaskEdit.Text]) then
   begin
      wwtable1.indexName:= 'iDesc';
      wwtable1.First;
   end
   else wwtable1.indexName:= 'iDesc';
}
end;

procedure TwwEditPictureMaskdlg.FormShow(Sender: TObject);
begin
   wwOpenPictureDB(wwtable1);

   AllowInvalidCheckbox.checked:= MyComponent.Picture.AllowInvalidExit;
   PictureMaskEdit.text:= MyComponent.Picture.PictureMask;
   AutoFillCheckbox.checked:= MyComponent.Picture.AutoFill;
   UsePictureMask.checked:= MyComponent.UsePictureMask;

   if (MyComponent is TwwDBCustomEdit) then
      with TwwDBCustomEdit(MyComponent) do
         if (datasource<>Nil) and (datasource.dataset<>Nil) then begin
            if (wwPdxPictureMask(datasource.dataset, dataField)<>'') then
            begin
               PictureMaskEdit.enabled:= False;
               PictureMaskLabel.caption:= '&Picture Mask (From Paradox Table)';
               PictureMaskEdit.ShowButton:= False;
               DesignMaskButton.enabled:= False;
            end;
            AllowInvalidCheckbox.checked:= False;
            AllowInvalidCheckbox.enabled:= False;
         end;


end;

procedure TwwEditPictureMaskdlg.DesignMaskButtonClick(Sender: TObject);
var component: TwwCustomMaskEdit;
begin
   component:= TwwCustomMaskEdit.create(self);
   with component do begin
      component.visible:= False;
      component.parent:= self;
      with component.picture do begin
         PictureMask:= PictureMaskEdit.Text;
         AutoFill:= AutoFillCheckbox.checked;
         AllowInvalidExit:= AllowInvalidCheckbox.checked;
      end;
      if wwPrpEdit_PictureMask(component) then
      begin
         with component.picture do begin
            PictureMaskEdit.Text:= PictureMask;
            PictureMaskEdit.LookupValue:= PictureMaskEdit.text;
            AutoFillCheckbox.checked:= AutoFill;
            AllowInvalidCheckbox.checked:= AllowInvalidExit;
         end;
      end;

      Free;
   end
end;
procedure TwwEditPictureMaskdlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (key=vk_f1) then wwHelp(Handle, 'Select Picture Mask Dialog Box')
end;

end.