unit sheet;

{*******************************************************************************
Program Modifications:

-------------------------------------------------------------------------------
Date        ID     Description
-------------------------------------------------------------------------------
08-10-2006  GN01   To preserve the leading zero's in a string field as excel converted
                   them to Integers

********************************************************************************}


interface

uses
	windows, sysutils, db,comobj, dialogs;

var
  xla : variant;
  xlw : variant;
  LCID : integer;
  Sheet1 : boolean;
  ExcelOpen : boolean = false;
  NextRow : integer;
  isTemplate:boolean;

procedure NewExcelSheet(template:string; titles:array of string);
Procedure ExcelTitles(titles:array of string; additionaltitle:string);
Procedure PushToExcel(sp_nm:string; ds : tDataset; titles:array of string; var additionaltitle:string);
procedure RunExcelMacro;
function OpenExcel(template:string):boolean;
procedure CloseExcel;
procedure ShowExcel;
procedure SaveExcel(const filename:string);
Procedure ShutDownExcel;

implementation

function OpenExcel(template:string):boolean;
begin
  try
    xla := createoleobject('Excel.application');//CoApplication.Create;
//    LCID := GetUserDefaultLCID;
    if template='' then
      xlw := xla.Workbooks.Add
    else
    begin
      xlw := xla.Workbooks.Add(template); // workbook based on template
      isTemplate := true;
    end;
    Sheet1 := true;
    result := true;
  except
    result := false;
  end;
  ExcelOpen := result;
end;

procedure CloseExcel;
begin
  if ExcelOpen then begin
    xla.Quit;
    ExcelOpen := false;
  end;
end;

function VerifyExcelOpen:boolean;
begin
  if ExcelOpen then
    try
      xla.range['A1', 'A1'].Value := xla.range['A1', 'A1'].Value;
      result := true;
    except
      CloseExcel;
      result := false;
    end
  else
    result := false;
end;

Procedure ExcelTitles(titles:array of string; additionaltitle:string);
var i,j : integer;
begin
  j := 1;
  for i := 0 to high(titles) do
    if (titles[i] <> '') then begin
      xla.range['A'+inttostr(j), 'A'+inttostr(j)].Value := titles[i];
      xla.range['A'+inttostr(j), 'A'+inttostr(j)].Font.Bold := true;
      inc(j);
    end;
  if (additionaltitle <> '') then begin
      xla.range['A'+inttostr(j), 'A'+inttostr(j)].Value := additionaltitle;
      xla.range['A'+inttostr(j), 'A'+inttostr(j)].Font.Bold := true;
      inc(j);
  end;
  xla.range['A1','A1'].Font.Size := 12;
  xla.range['A1','A1'].Font.Bold := true;
  xla.range['A'+inttostr(j), 'A'+inttostr(j)].Value := 'Date: '+ FormatDateTime('mmmm d, yyyy h:nn am/pm', Now);
end;

procedure NewExcelSheet(template:string; titles:array of string);
var i:integer;
begin
  if VerifyExcelOpen or OpenExcel(template) then
  try
    if not sheet1 then begin
//      xla.sheets.Add(null,null,null,null,lcid);
      if template='' then
        xlw := xla.Workbooks.Add
      else
      begin
        xlw := xla.Workbooks.Add(template); // workbook based on template
        isTemplate := true;
      end;
    end;
    sheet1 := false;
    NextRow := 4;
    for i := 0 to high(titles) do
      if titles[i] <> '' then inc(NextRow);
    {we only want to reserve rows for the titles.  We'll actually place
     the titles on the sheet after we've auto-fit the columns by using
     ExcelTitles()}
  finally
  end;
end;

procedure removehardreturn(var v:variant);
var s:string;
    i:integer;
begin
  s:= vartostr(v);
  i:=pos(#13#10,s);
  while i > 0 do
  begin
    delete(s,i,1);
    i:=pos(#13#10,s);
  end;

  i:=pos(#9,s);
  while i > 0 do
  begin
    delete(s,i,1);
    i:=pos(#9,s);
  end;
  if length(s)>910 then
  setlength(s,910);
  v := s;

end;

//GN01
function IsNumber(mStr: string): Boolean;
var 
  Code: Integer;
  Value: Double;
begin
  try
     StrToFloat(mStr);
     Result := True;
    //val(mStr, Value, Code);
    //Result := (Code = 0);
  except
    on EConvertError do Result := False;
    on EInvalidOp do Result := False;
  end;
end; { IsNumber }




Procedure PushToExcel(sp_nm:string; ds : tDataset; titles:array of string; var additionaltitle:string);
  function columnname(i : integer):string;
  var n : integer;
  begin
    n := ((i-1) div 26);
    if n > 0 then
      result := chr(n+64)
    else
      result := '';
    result := result + chr((i - (n*26))+64);
  end;
var
  fldCnt : integer;
  i,j : integer;
  firstcol : char;
  lastcol, s : string;
  row : array[0..1000] of variant;
  MultiSheet : boolean;
  SheetCol,SheetVal : string;
  orgNextRow : integer;
  strRow:string;

begin

  try
    MultiSheet := (pos('SheetName',ds.fields[0].fieldname)=1);
    SheetCol := ds.fields[0].fieldname;
    if (MultiSheet) then begin
      delete(SheetCol,1,9);
      if pos('dummy',lowercase(SheetCol))>0 then
         delete(Sheetcol,pos('dummy',lowercase(SheetCol)),5);
    end;

    with ds do begin
      disablecontrols;
      SheetVal := '';
      try
        if ds.RecordCount<>0 then SheetVal := fields[0].value;
      except
      end;
      fldcnt := fieldcount;
      for j := 0 to fieldcount-1 do
        if pos('dummy',lowercase(fields[j].fieldname))>0 then
          dec(fldcnt);
      firstcol := 'A';
      lastcol := columnname(ord(firstcol)-65+fldcnt);
      orgNextRow := NextRow;
      i := NextRow;
      inc(NextRow);
      first;
      while not eof do begin
        fldcnt := 0;
        for j := 0 to fieldcount-1 do
          if pos('dummy',lowercase(fields[j].fieldname))=0 then begin
            row[fldcnt] := fields[j].value;
            case ds.Fields[j].DataType of
              ftString: begin
                             if not VarIsNull(row[fldcnt]) then
                             begin
                                s := row[fldcnt];
                                if (Length(s) > 0) and IsNumber(s) and (s[1] = '0') then
                                   row[fldcnt] := '''' + row[fldcnt];
                             end;
                        end;//GN01
              ftSmallint: ;
              ftInteger:  ;
              ftWord:;
              ftBoolean:;
              ftFloat:;
              ftCurrency:;
              ftDate:;
              ftTime:;
              ftDateTime:;
              ftBytes:;
              ftMemo  : removehardreturn(row[fldcnt]);
              ftFmtMemo:;
            end;




//            xla.cell[NextRow,fldcnt ].value   :=fields[j].value;
            inc(fldcnt);
          end;
        try
          xla.Range[firstcol+inttostr(NextRow), lastcol+inttostr(NextRow)].value := vararrayof(slice(row,fldcnt));
        except
//        columnname(ord(firstcol)-65+fldcnt);
          for j := 0 to fldcnt-1 do
            try
              xla.range[columnname(ord(firstcol)-64+j)+inttostr(nextrow), columnname(ord(firstcol)-64+j)+inttostr(nextrow)].value := row[j];
            except
              try
                xla.range[columnname(ord(firstcol)-64+j)+inttostr(nextrow), columnname(ord(firstcol)-64+j)+inttostr(nextrow)].value := '#N/A';
                messagedlg('Invalid value in record '+inttostr(nextrow)+': can''t write "' + varastype(row[j],varstring) + '" to Excel.  Replacing it with #N/A.',mtwarning,[mbok],0);
              except
              end;
            end;
        end;
        inc(NextRow);
        next;
        if (MultiSheet) and (SheetVal <> fields[0].value) then begin
          fldcnt := 0;
          for j := 0 to fieldcount-1 do
            if pos('dummy',lowercase(fields[j].fieldname))=0 then begin
              row[fldcnt] := fields[j].fieldname;
              inc(fldcnt);
            end;
          xla.range[firstcol+inttostr(i),lastcol+inttostr(i)].value := vararrayof(row);
          xla.Range[firstcol+inttostr(i),lastcol+inttostr(i)].Font.Bold := True;

          if not isTemplate then
            xla.Columns.AutoFit;

          try
            xla.activesheet.name := sheetval;
          except
          end;

          if SheetCol <> '' then
            additionaltitle := SheetCol + ': '+SheetVal
          else
            additionaltitle := SheetVal;
          ExcelTitles(titles,additionaltitle);

          xla.Worksheets.Add;
          i := orgNextRow;
          NextRow := i+1;

          SheetVal := fields[0].value;
        end;
      end;

      fldcnt := 0;
      for j := 0 to fieldcount-1 do
        if pos('dummy',lowercase(fields[j].fieldname))=0 then begin
          row[fldcnt] := fields[j].fieldname;
          inc(fldcnt);
        end;
        
      xla.range[firstcol+inttostr(i),lastcol+inttostr(i)].value := vararrayof(row);
      xla.Range[firstcol+inttostr(i),lastcol+inttostr(i)].Font.Bold := True;

      if not isTemplate then
        xla.Columns.AutoFit;


      if (multiSheet) then begin
        xla.activesheet.name := sheetval;
        if SheetCol <> '' then
          additionaltitle := SheetCol + ': '+SheetVal
        else
          additionaltitle := SheetVal;
        ExcelTitles(titles,additionaltitle);
      end;

      lastcol := 'A'+inttostr(i);
      xla.range[lastcol,lastcol].addcomment(sp_nm);
      xla.range[lastcol,lastcol].comment.Shape.Width := 300;
      first;
      enablecontrols;
      inc(NextRow,1);
    end;

  finally
  end;
end;

procedure RunExcelMacro;
begin
  try
    xla.Run('AutoDashboard');
  except
  end;
end;

procedure ShowExcel;
begin
  if ExcelOpen then
    xla.Visible := true;
    //Keeping the handle of open cause problems when openning other excel docs.
    ExcelOpen:=false;
    xla:=unassigned;
end;

procedure SaveExcel(const filename:string);
begin
  if fileexists(filename) then
    deletefile(filename);
{
  xlw.SaveAs(
      filename,
      xlWorkbookNormal,
      '',
      '',
      False,
      False,
      xlNoChange,
      xlLocalSessionChanges,
      true,
      0,
      0,
      LCID);
}
  xlw.close(true,filename,false);
  ExcelOpen := false;
end;

Procedure ShutDownExcel;
begin
  xla.Quit;
end;

end.
