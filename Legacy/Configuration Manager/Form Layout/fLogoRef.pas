unit fLogoRef;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBCtrls, Grids, DBGrids, ExtCtrls, StdCtrls;

type
  TfrmLogoRef = class(TForm)
    DBGrid1: TDBGrid;
    dsGraphics: TDataSource;
    Image1: TImage;
    btnOK: TButton;
    btnCancel: TButton;
    rbStatic: TRadioButton;
    rbDynamic: TRadioButton;
    procedure dsGraphicsDataChange(Sender: TObject; Field: TField);
    procedure rbDynamicClick(Sender: TObject);
    procedure rbStaticClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogoRef: TfrmLogoRef;

implementation

uses Code, dataMod, DOpenQ;

{$R *.DFM}

procedure TfrmLogoRef.dsGraphicsDataChange(Sender: TObject; Field: TField);
var ratio : integer;
begin
  with dsgraphics.dataset do begin
    {try}
      image1.Picture.bitmap.Assign(tBlobfield(fieldbyname('Bitmap')));
    {except
      tBlobField(fieldbyname('Bitmap')).savetofile(dmopenq.tempdir+'\logo.jpg');
      image1.picture.loadfromfile(dmopenq.tempdir+'\logo.jpg');
    end;}
    if fieldbyname('scaling').value=300 then
      ratio := 2958
    else
      ratio := 1479;
    image1.Width := round(image1.picture.width * (ratio / 10000));
    image1.height := round(image1.picture.height * (ratio / 10000));
  end;
end;

procedure TfrmLogoRef.rbDynamicClick(Sender: TObject);
begin
  frmCode := TfrmCode.Create( Self );
  with frmCode do
  try
    Top := ( Screen.Height - Height ) div 2;
    vForm := Self;
    dbgrid1.datasource := dqdatamodule.ds_codes;
    Onclose := nil;
    ShowModal;
    rbDynamic.tag := dqdatamodule.t_codes.fieldbyname('code').value;
    rbDynamic.hint := dqdatamodule.t_codes.fieldbyname('description').value;
    rbDynamic.caption := 'Personalize (' + rbDynamic.hint + ')';
  finally
    release;
  end;
end;

procedure TfrmLogoRef.rbStaticClick(Sender: TObject);
begin
  rbDynamic.caption := 'Personalize';
  rbDynamic.tag := -1;
end;

procedure TfrmLogoRef.FormCreate(Sender: TObject);
begin
  rbDynamic.tag := -1;
  rbStatic.checked := true;
end;

end.
