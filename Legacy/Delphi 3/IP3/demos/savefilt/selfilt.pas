unit selfilt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TSelectSaveFilter = class(TForm)
    FiltersBox: TListBox;
    Button1: TButton;
    Button2: TButton;
    procedure FiltersBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FiltersBoxDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelectSaveFilter: TSelectSaveFilter;

implementation

{$R *.DFM}

procedure TSelectSaveFilter.FiltersBoxKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if ((Key= VK_DELETE) and (FiltersBox.ItemIndex <> -1)) then
      FiltersBox.Items.Delete(FiltersBox.ItemIndex);
end;

procedure TSelectSaveFilter.FiltersBoxDblClick(Sender: TObject);
begin
   ModalResult := mrOk;
end;

end.
