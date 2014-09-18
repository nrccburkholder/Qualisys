unit Code;

{ a non-modal dialog box used for inserting codes into heading, question, and scale text }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Clipbrd, DBCGrids, StdCtrls, DBCtrls, ExtCtrls, Grids, DBGrids, Buttons,
  ComCtrls, DBRichEdit;

type
  TfrmCode = class(TForm)
    Panel2: TPanel;
    DBNavigator1: TDBNavigator;
    btnClose: TSpeedButton;
    btnNext: TSpeedButton;
    btnInsertCode: TSpeedButton;
    btnFind: TSpeedButton;
    DBGrid1: TDBGrid;
    procedure CloseClick(Sender: TObject);
    procedure InsertClick(Sender: TObject);
    procedure FindClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    vForm : TForm;
  end;

var
  frmCode: TfrmCode;

implementation

uses  Support, DOpenQ, REEdit, fTrans, FDynaQ;

{$R *.DFM}

{ ACTIVATION SECTION }

{ sets the button states each time the form is activated }

procedure TfrmCode.FormActivate(Sender: TObject);
begin
  btnInsertCode.Enabled := ( vForm.ActiveControl is TclDBRichEdit ) and
      not TclDBRichEdit( vForm.ActiveControl ).ReadOnly;
  if modSupport.dlgLocate.DataSource <> DBGrid1.datasource then btnNext.Enabled := False;
end;

{ BUTTON SECTION }

{ calls the DBRichEdit's embed method, passing in the currently selected code }

procedure TfrmCode.InsertClick(Sender: TObject);
begin
  if vForm.Caption = 'Translation' then begin
    frmTranslation.tCodeText.findkey([frmTranslation.tCodesCode.value]);
    with frmTranslation.clDBRichCodeBtnFrgn do EmbedCode( frmTranslation.tCodesCode.AsString );
    with frmTranslation do begin
      if tCodesFielded.value <> 1 then begin
        tcodes.edit;
        tcodesfielded.value := 1;
        tcodes.post;
      end;
    end;
  end else if vForm.name = 'F_DynaQ' then begin
    F_DynaQ.tCodeText.findkey([F_DynaQ.tCodesCode.value]);
    with F_DynaQ.DBRESelQstnText do EmbedCode( F_DynaQ.tCodesCode.AsString );
    with F_DynaQ do begin
      if tCodesFielded.value <> 1 then begin
        tcodes.edit;
        tcodesfielded.value := 1;
        tcodes.post;
      end;
    end;
  end else begin
    frmREEdit.tCodeText.findkey([frmREEdit.tCodesCode.value]);
    with frmREEdit.clDBRichCodeBtn1 do
      EmbedCode( frmREEdit.tCodesCode.AsString );
    with frmREEdit do begin
      if tCodesFielded.value <> 1 then begin
        tcodes.edit;
        tcodesfielded.value := 1;
        tcodes.post;
      end;
    end;
  end;
end;

procedure TfrmCode.FindClick(Sender: TObject);
begin
  with modSupport.dlgLocate do
  begin
    Caption := 'Locate Code';
    DataSource := DBGrid1.datasource;
    SearchField := 'Description';
    btnNext.Enabled := Execute;
  end;
end;

procedure TfrmCode.NextClick(Sender: TObject);
begin
  btnNext.Enabled := modSupport.dlgLocate.FindNext;
end;

procedure TfrmCode.CloseClick(Sender: TObject);
begin
  Close;
end;

{ FINALIZATION SECTION }

{ resets the calling form on close:
    1. repositions calling form to the center of the screen
    2. pops up the code button on the calling form }

procedure TfrmCode.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Hide;
  with vForm do begin
    if name <> 'F_DynaQ' then
      Position := poScreenCenter;
    ( FindComponent( 'btnCode' ) as TSpeedButton ).Down := False;
    ( FindComponent( 'clCodeToggle1' ) as TclCodeToggle).enabled := true;
  end;
  Action := caFree;
end;

end.
