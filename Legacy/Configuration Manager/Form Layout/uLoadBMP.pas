unit uLoadBMP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,Common;

type
  TfrmOpenPictureDialog = class(TForm)
    OpenDialog: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    ImagePanel: TPanel;
    btnOK: TButton;
    Button2: TButton;
    btnHelp: TButton;
    btnLoad: TButton;
    btnSave: TButton;
    btnClear: TButton;
    Image: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lblDimAt300: TLabel;
    lblDimAt600: TLabel;
    SaveDialog: TSaveDialog;
    Label3: TLabel;
    procedure btnLoadClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CalcDimensions;
  public
    { Public declarations }
    Filename:string;
  end;

var
  frmOpenPictureDialog: TfrmOpenPictureDialog;

implementation

{$R *.DFM}

procedure TfrmOpenPictureDialog.CalcDimensions;
var s : string;
begin
  Image.Visible := true;
  str(Image.Picture.width/300:7:2,s);
  lblDimAt300.caption := trim(s) + '" x ';
  str(Image.Picture.height/300:7:2,s);
  lblDimAt300.caption := lblDimAt300.caption + trim(s) + '"';
  str(Image.Picture.width/600:7:2,s);
  lblDimAt600.caption := trim(s) + '" x ';
  str(Image.Picture.height/600:7:2,s);
  lblDimAt600.caption := lblDimAt600.caption + trim(s) + '"';
  btnSave.Enabled := true;
  btnClear.Enabled := true;
  btnOK.enabled := (label3.caption='');
  with image do begin
    align := alNone;
    height := round(picture.height * 0.1479);
    width := round(picture.width * 0.1479);
    left := (imagepanel.width div 2) - (width div 2);
    top := (imagepanel.height div 2) - (height div 2);
    stretch := true;
    Imagepanel.caption := '';
  end;
end;

procedure TfrmOpenPictureDialog.btnLoadClick(Sender: TObject);
var f: file of Byte;
    size : Longint;
begin
  OpenDialog.InitialDir := GetPath('Load Logo');
  if OpenDialog.Execute then begin
    Image.Picture.LoadFromFile(OpenDialog.Filename);
    AssignFile(f, OpenDialog.FileName);
    Reset(f);
    size := FileSize(f);
    CloseFile(f);
    if size > 32000 then begin
      label3.caption := 'File Size='+inttostr(size);
      btnOK.enabled := false;
    end else begin
      label3.caption := '';
      btnOK.enabled := true;
    end;
    CalcDimensions;
    SetPath('Load Logo', ExtractFilePath(OpenDialog.Filename));
    FileName := ExtractFileName(OpenDialog.Filename);
  end;
end;

procedure TfrmOpenPictureDialog.btnClearClick(Sender: TObject);
begin
  Image.Visible := false;;
  lblDimAt300.Caption := '';
  lblDimAt600.Caption := '';
  btnSave.Enabled := false;
  btnClear.Enabled := false;
  btnOK.enabled := false;
  ImagePanel.caption := '(none)';
end;

procedure TfrmOpenPictureDialog.btnSaveClick(Sender: TObject);
begin
  SaveDialog.FileName := GetPath('Save Logo')+Filename;
  if SaveDialog.Execute then
  begin
    Image.Picture.SaveToFile(SaveDialog.Filename);
    SetPath('Save Logo', ExtractFilePath(SaveDialog.Filename));
  end;
end;

procedure TfrmOpenPictureDialog.FormShow(Sender: TObject);
begin
  if Image.Picture <> nil then
    CalcDimensions;
end;

procedure TfrmOpenPictureDialog.FormCreate(Sender: TObject);
begin
  label3.caption := '';
end;

end.
