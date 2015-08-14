unit Wwtypes;

interface
  uses classes, db, forms, stdctrls, dbtables;

const wwNewLineString='<New Line>';
type
  TwwInvalidValueEvent = Procedure(DataSet: TDataSet; Field: TField) of object;
  TwwFilterFieldMethod =  Function(AFieldName: string): TParam of object;
  TwwDataSetFilterEvent = Procedure(table: TDataSet; var Accept: boolean) of object;
  TwwGetWordOption = (wwgwSkipLeadingBlanks, wwgwQuotesAsWords, wwgwStripQuotes); {pwb}
  TwwGetWordOptions = set of TwwGetWordOption;  {pwe}

  TwwCheatCastNotify = class(TComponent)
  public
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  end;

  TwwCheatCastKeyDown = class(TCustomEdit)
  public
    procedure KeyDown(var key: word; shift: TShiftState); override;
  end;

  TwwOnFilterOption = (ofoEnabled, ofoShowHourGlass, ofoCancelOnEscape);
  TwwOnFilterOptions = set of TwwOnFilterOption;

{$ifndef ver100}
  TCustomForm = TForm;
{$endif}


implementation

procedure TwwCheatCastNotify.Notification(AComponent: TComponent;
      Operation: TOperation);
begin
   inherited Notification(AComponent, Operation);
end;

procedure TwwCheatCastKeyDown.KeyDown(var key: word; shift: TShiftState);
begin
   inherited KeyDown(Key, shift);
end;

end.
