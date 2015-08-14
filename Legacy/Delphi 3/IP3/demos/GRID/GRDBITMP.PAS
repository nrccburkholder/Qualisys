unit Grdbitmp;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DBTables, DB, Grids, Wwdbigrd, Wwdbgrid, Wwtable,
  Wwdatsrc, StdCtrls, DBCtrls, wwdblook, Wwdbdlg, Mask, Wwdbedit, Wwdotdot,
  Wwdbcomb, Wwdbspin, ExtCtrls;

type
  TBitmapForm = class(TForm)
    CustomerDS: TwwDataSource;
    CustomerTable: TwwTable;
    InvoiceDS: TwwDataSource;
    InvoiceTable: TwwTable;
    InvoiceGrid: TwwDBGrid;
    InvoiceTableInvoiceNo: TFloatField;
    InvoiceTablePaymentMethod: TStringField;
    InvoiceTableTotalInvoice: TCurrencyField;
    InvoiceTablePurchaseDate: TDateField;
    InvoiceTablePayBitmap: TStringField;
    InvoiceTableCustomerNo: TIntegerField;
    DBText1: TDBText;
    CustomerTableFullName: TStringField;
    DBText2: TDBText;
    CustomerTableCustomerNo: TIntegerField;
    CustomerTableBuyer: TStringField;
    CustomerTableCompanyName: TStringField;
    CustomerTableFirstName: TStringField;
    CustomerTableLastName: TStringField;
    CustomerTableStreet: TStringField;
    CustomerTableCity: TStringField;
    CustomerTableState: TStringField;
    CustomerTableZip: TStringField;
    CustomerTableFirstContactDate: TDateField;
    CustomerTablePhoneNumber: TStringField;
    CustomerTableInformation: TMemoField;
    CustomerTableRequestedDemo: TStringField;
    CustomerTableLogical: TBooleanField;
    CustomerTableFullAddress: TStringField;
    DBText3: TDBText;
    InvoiceTableBalanceDue: TCurrencyField;
    PayMethCombo: TwwDBCombobox;
    InvoiceSpinEdit: TwwDBSpinEdit;
    DBNavigator1: TDBNavigator;
    Memo1: TMemo;
    procedure CustomerTableCalcFields(DataSet: TDataset);
    procedure InvoiceGridCalcCellColors(Sender: TObject; Field: TField;
      State: TGridDrawState; highlight: Boolean; AFont: TFont;
      ABrush: TBrush);
    procedure InvoiceDSDataChange(Sender: TObject; Field: TField);
    procedure InvoiceGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure InvoiceGridCalcTitleAttributes(Sender: TObject;
      AFieldName: String; AFont: TFont; ABrush: TBrush;
      var ATitleAlignment: TAlignment);
    procedure InvoiceGridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure InvoiceGridDblClick(Sender: TObject);
    procedure PayMethComboCloseUp(Sender: TwwDBCombobox; select: Boolean);
  private
    procedure ToggleBitmaps;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  BitmapForm: TBitmapForm;

implementation

{$R *.DFM}

{Calculate the FullName and FullAddress fields.}
procedure TBitmapForm.CustomerTableCalcFields(DataSet: TDataset);
begin
  CustomerTableFullName.AsString := CustomerTable.FieldByName('First Name').AsString + ' ' +
    CustomerTable.FieldByName('Last Name').AsString;
  CustomerTableFullAddress.AsString :=
    CustomerTable.FieldByName('City').AsString + ', ' +
    CustomerTable.FieldByName('State').AsString + '  ' +
    CustomerTable.FieldByName('Zip').AsString;
end;

{If the customer owes money then paint the record red.  It checks the value of the
 'Balance Due' field and if it is greater than zero then it will change the attributes
 for every column except the one that has focus. }
procedure TBitmapForm.InvoiceGridCalcCellColors(Sender: TObject; Field: TField;
  State: TGridDrawState; highlight: Boolean; AFont: TFont; ABrush: TBrush);
begin
  if not highlight and (InvoiceTable.FieldByName('Balance Due').AsInteger > 0) then
  begin
    ABrush.Color := clRed;  {Change the background color to red}
    AFont.Color := clWhite; {Change the pen color to white}
  end;
end;

{For the mapped combobox.  If the value changes then this procedure tells the
 grid to repaint so that the bitmap can reflect the changed value.}
procedure TBitmapForm.InvoiceDSDataChange(Sender: TObject; Field: TField);
begin
  if (Field<>Nil) and
     ((Field.FieldName = 'Payment Method') or (Field.FieldName = 'Balance Due')) then
  begin
     InvoiceGrid.invalidateCurrentRow;
  end
end;

{Allows the user to cycle through the available bitmaps in the grid.
 The three choices are V (Visa), A (American Express), and
 M (MasterCard).  The if statements check which Card the record
 contains and changes it to another card.}
procedure TBitmapForm.ToggleBitmaps;
var payMethod: string;
begin
   InvoiceTable.Edit;
   PayMethod:= InvoiceTablePaymentMethod.text;
   if length(PayMethod)=0 then payMethod:= ' ';

   case PayMethod[1] of
      'A': PayMethod:='V';
      'V': PayMethod:='M';
      'M': PayMethod:=' ';
      ' ': PayMethod:='A';
   end;
   InvoiceTablePaymentMethod.asString := PayMethod;
   InvoiceGrid.InvalidateCurrentRow; { Redraw grid row based on changes }
end;

procedure TBitmapForm.InvoiceGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if InvoiceGrid.GetActiveField.FieldName = 'PayBitmap' then
    if (KEY=VK_SPACE) then
       ToggleBitmaps;
end;


{ Set Specific title attributes for the Invoice Grid }
procedure TBitmapForm.InvoiceGridCalcTitleAttributes(Sender: TObject;
  AFieldName: String; AFont: TFont; ABrush: TBrush;
  var ATitleAlignment: TAlignment);
begin
  if (AFieldName = 'Total Invoice') or (AFieldName = 'Balance Due') then
  begin
    ATitleAlignment := taRightJustify;
  end;
end;

procedure TBitmapForm.InvoiceGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
   Function isValidChar(key: word): boolean;
   begin
      result:= (key = VK_BACK) or (key=VK_SPACE) or (key=VK_DELETE) or
               ((key >= ord('0')) and (key<=VK_DIVIDE));
   end;
begin
   with (Sender as TwwDBGrid) do begin
      if (GetActiveField.FieldName='Balance Due') and EditorMode then
      begin
         if not isValidChar(key) then exit;
         if (length(InplaceEditor.Text)>=2) then begin
            SelectedIndex:= SelectedIndex + 1;
         end
      end
   end;
end;

{ Cycle through credit card bitmaps when dbl-clicked }
procedure TBitmapForm.InvoiceGridDblClick(Sender: TObject);
begin
  if InvoiceGrid.GetActiveField.FieldName = 'PayBitmap' then ToggleBitmaps;
end;

procedure TBitmapForm.PayMethComboCloseUp(Sender: TwwDBCombobox;
  select: Boolean);
begin
  if select then Sender.UpdateRecord;
end;

end.
