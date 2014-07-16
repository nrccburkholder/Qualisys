unit uPCLString;

interface
type
  TPCLString = class(TObject)
  private
    strPCLText : string;
    strPlainText : string;
    aPosition : array[1..10000] of word;
    procedure SetPCLText(Value: string);
    procedure SetPlainText;
  published
    property Text: string read strPCLText write SetPCLText;
    property PlainText: string read strPlainText;
    procedure InsertIntoPlain(value : string; position : integer);
    procedure DeleteFromPlain(start, len: integer);
  end;

implementation

procedure tPCLString.SetPCLText(Value: string);
begin
{  while pos('[27]',Value)>0 do begin
    insert(#27,Value,pos('[27]',Value));
    delete(Value,pos('[27]',Value),4);
  end;
}
  while pos('[13]',Value)>0 do begin
    insert(#13,Value,pos('[13]',Value));
    delete(Value,pos('[13]',Value),4);
  end;
  while pos('[10]',Value)>0 do begin
    insert(#10,Value,pos('[10]',Value));
    delete(Value,pos('[10]',Value),4);
  end;

  strPCLText := Value;
  setPlainText;
end;

procedure tPCLString.SetPlainText;
var i : integer;
    t : string;
    inCmnd : boolean;
begin
  strPlainText := '';
  inCmnd := false;
  for i := 1 to length(strPCLText) do begin
    if inCmnd then begin
      if (strPCLText[i] >= '@') and (strPCLText[i] <= 'Z') then inCmnd := false;
    end else begin
      if strPCLText[i] = #27 then
        inCmnd := true
      else begin
        strPlainText := strPlainText + strPCLText[i];
        aPosition[length(strPlainText)] := i;
      end;
    end;
  end;
end;

procedure tPCLString.InsertIntoPlain(value : string; position : integer);
begin
  insert(value,strPCLText,aPosition[position]);
  setPlainText;
end;

procedure tPCLString.DeleteFromPlain(start, len: integer);
var i : integer;
begin
  for i := (start+len-1) downto start do
    delete(strPCLText,aposition[i],1);
  setPlainText;
end;

end.
