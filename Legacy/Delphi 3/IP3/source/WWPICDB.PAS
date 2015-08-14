unit Wwpicdb;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, DBCtrls, Mask, Wwdbedit, DB, Wwdatsrc, DBTables,
  Wwtable;

type
  TwwEditMaskForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    MaskEdit: TwwDBEdit;
    Description: TwwDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    wwDataSource1: TwwDataSource;
    PictureTable: TwwTable;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  wwEditMaskForm: TwwEditMaskForm;

implementation

{$R *.DFM}

uses wwcommon;

procedure TwwEditMaskForm.FormCreate(Sender: TObject);
begin
   wwOpenPictureDB(PictureTable);
end;

procedure TwwEditMaskForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (key=vk_f1) then wwHelp(Handle, 'Edit Picture Mask Database Dialog Box')
end;

end.
