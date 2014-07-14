unit Range;

{ a modal dialog used for setting the date range for the survey usage dialog }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, ComCtrls;

type
  TfrmRange = class(TForm)
    lblEnd: TLabel;
    lblStart: TLabel;
    lblInterval: TLabel;
    spnInterval: TUpDown;
    btnCancel: TButton;
    btnOK: TButton;
    edtStart: TMaskEdit;
    edtEnd: TMaskEdit;
    edtInterval: TMaskEdit;
    procedure OKClick(Sender: TObject);
    procedure RangeEnter(Sender: TObject);
    procedure IntervalEnter(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  private
    procedure EnableInterval( vEnable : Boolean );
  public
    { Public declarations }
  end;

var
  frmRange: TfrmRange;

implementation

uses Data;

{$R *.DFM}

{ BUTTON METHODS }

{ sets the range from the entered values:
    1. closes the query
    2. passes in the entered values as paramaters
    3. opens the query
    4. closes the dialog }

procedure TfrmRange.OKClick(Sender: TObject);
begin
  with modLibrary.wqryClient do
  begin
    modLibrary.wtblUsage.DisableControls;
    try
      Close;
      if lblInterval.Enabled then
      begin
        if edtInterval.Text = '' then
          ParamByName( 'start' ).AsDate := 0
        else
          ParamByName( 'start' ).AsDate := ( Date - ( StrToInt( edtInterval.Text ) * 30.5 ) );
        ParamByName( 'end' ).AsDate := Date;
      end
      else
      begin
        ParamByName( 'start' ).AsDate := StrToDate( edtStart.Text );
        ParamByName( 'end' ).AsDate := StrToDate( edtEnd.Text );
      end;
      Open;
    finally
      modLibrary.wtblUsage.EnableControls;
    end;
  end;
  Close;
end;

procedure TfrmRange.CancelClick(Sender: TObject);
begin
  Close;
end;

{ COMPONENT HANDLERS }

procedure TfrmRange.RangeEnter(Sender: TObject);
begin
  EnableInterval( False );
end;

procedure TfrmRange.IntervalEnter(Sender: TObject);
begin
  EnableInterval( True );
end;

{ GENERAL METHODS }

{ switches between interval and start/end for entering values }

procedure TfrmRange.EnableInterval( vEnable : Boolean );
begin
  if vEnable then
  begin
    edtStart.Clear;
    edtEnd.Clear;
    spnInterval.Position := 12;
  end
  else
  begin
    edtInterval.Clear;
    edtEnd.Text := DateToStr( Date );
  end;
  lblStart.Enabled := not vEnable;
  lblEnd.Enabled := not vEnable;
  lblInterval.Enabled := vEnable;
end;

end.
