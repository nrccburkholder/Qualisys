unit RRelated;

{ report displaying all the questions related to a question }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, quickrpt, Qrctrls;

type
  TrptRelated = class(TForm)
    qrRelated: TQuickRep;
    PageHeaderBand1: TQRBand;
    TitleBand1: TQRBand;
    PageFooterBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRSysData1: TQRSysData;
    QRSysData2: TQRSysData;
    QRLabel5: TQRLabel;
    QRExpr1: TQRExpr;
    QRExpr2: TQRExpr;
    QRLabel6: TQRLabel;
    ColumnHeaderBand1: TQRBand;
    QRShape1: TQRShape;
    QRLabel4: TQRLabel;
    QRLabel3: TQRLabel;
    DetailBand1: TQRBand;
    lblCore: TQRLabel;
    lblText: TQRLabel;
    procedure qrRelatedNeedData(Sender: TObject; var MoreData: Boolean);
    procedure qrRelatedBeforePrint(Sender: TQuickRep;
      var PrintReport: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  rptRelated: TrptRelated;

implementation

uses Related, Data;

{$R *.DFM}

{ since this report is not linked to a specific data source, it can only be started by
  setting the PrintReport to true in the beforePrint event, and then using the OnNeedData
  event to provide each record. }

procedure TrptRelated.qrRelatedBeforePrint(Sender: TQuickRep; var PrintReport: Boolean);
begin
  PrintReport := True;
end;

{ manually set the report labels in the detail band; keeps running until set Moredata = False }

procedure TrptRelated.qrRelatedNeedData(Sender: TObject; var MoreData: Boolean);
begin
  MoreData := True;
  with frmRelated do
    if not qryPreced.EOF then
    begin
      lblCore.Caption := qryPrecedCore.asString;
      lblText.Caption := qryPrecedShort.asString;
      qryPreced.Next;
    end
    else if not qryFollow.EOF then
    begin
      lblCore.Caption := qryFollowCore.AsString;
      lblText.Caption := qryFollowShort.AsString;
      qryFollow.Next;
    end
    else if not qryRecode.EOF then
    begin
      lblCore.Caption := qryRecodeCore.asString;
      lblText.Caption := qryRecodeShort.Value;
      qryRecode.Next;
    end
    else
      MoreData := False;
end;

end.
