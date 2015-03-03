unit Wwcaldlg;
{
//
// Calendar dialog pop-up demonstration - Use with TwwDBComboDlg
//
// Copyright (c) 1995 by Woll2Woll Software
//
// Credit:  Thanks to Walter Fordham and International Software Systems
//          for providing the inspiration and work for this example.
//
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Grids, Calendar, ExtCtrls, Buttons, Wwdbdlg,
  wwsystem, wwdotdot;

type
  TMyCalendar = class(TForm)
    OkButton: TBitBtn;
    CancelButton: TBitBtn;
    MonthCombo: TComboBox;
    YearCombo: TComboBox;
    Calendar1: TCalendar;
    procedure MonthComboChange(Sender: TObject);
    procedure YearComboChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Calendar1Change(Sender: TObject);
    procedure Calendar1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  public
     DateVal:TDateTime;
  end;

Function wwCalendarComboDlg(comboDlg: TwwDBComboDlg): boolean;

implementation

{$R *.DFM}

Function wwCalendarComboDlg(comboDlg: TwwDBComboDlg): boolean;
var
   rectBox: TRect;
   UpperPoint, LowerPoint: TPoint;
   myForm: TMyCalendar;
begin
   Screen.cursor:= crHourGlass;

   myForm:= TMyCalendar.create(Application);

   with myForm do begin
      Screen.cursor:= crDefault;

      if wwStrToDate(combodlg.text) then DateVal:= strToDate(comboDlg.text)
      else DateVal:= Date;

      with comboDlg do begin
        {Get the relative screen position of TwwDBComboDlg}
        rectBox := ClientRect;
        UpperPoint.X := rectBox.Left;
        UpperPoint.Y := rectBox.Top;
        UpperPoint := ClientToScreen( UpperPoint );
        LowerPoint.X := rectBox.Right;
        LowerPoint.Y := rectBox.Bottom;
        LowerPoint := ClientToScreen( LowerPoint );

        { If calendar too far down, popup over wwDBComboDlg }
        if UpperPoint.X + 1 + MyForm.Width > Screen.Width then
           MyForm.Left := Screen.Width - Myform.Width - 1
        else MyForm.Left := UpperPoint.X + 1;

        if LowerPoint.Y + 1 + MyForm.Height > Screen.Height then
           MyForm.Top := UpperPoint.Y - Myform.Height
        else MyForm.Top := LowerPoint.Y + 1;
      end;

      result:= ShowModal = mrOK;
      if result then
         with combodlg do begin
            if (datasource<>nil) and (datafield<>'') then
              datasource.dataset.fieldByName(dataField).text:= DateToStr(DateVal)
            else text:= DateToStr(DateVal);
         end;
      Free;
   end
end;

procedure TMyCalendar.MonthComboChange(Sender: TObject);
begin
   While true do
   begin
      try
        Calendar1.Month:=MonthCombo.ItemIndex+1;
        Break;
      Except
        on EConvertError do
        begin
           Calendar1.Day := Calendar1.Day - 1;
        end;
      end;
   end;
end;

procedure TMyCalendar.YearComboChange(Sender: TObject);
begin
   While true do
   begin
      try
         Calendar1.Year:=
            StrToInt(YearCombo.Items[YearCombo.ItemIndex]);
         Break;
      Except
         on EConvertError do
         begin
            Calendar1.Day := Calendar1.Day - 1;
         end
      end
  end;
end;

procedure TMyCalendar.FormActivate(Sender: TObject);
begin
   Calendar1.CalendarDate:=DateVal;
   OkButton.Caption:='';
   CancelButton.Caption:='';

   MonthCombo.ItemIndex:=Calendar1.Month-1;
   YearCombo.ItemIndex:=YearCombo.Items.IndexOf(IntToStr(Calendar1.Year));
   Calendar1.OnChange(Calendar1);
end;

procedure TMyCalendar.Calendar1Change(Sender: TObject);
begin
   DateVal:=Calendar1.CalendarDate;
end;

procedure TMyCalendar.Calendar1DblClick(Sender: TObject);
begin
   modalResult:= mrOK;
end;

procedure TMyCalendar.FormShow(Sender: TObject);
begin
   {$ifdef win32}
   width:= width - 5;
   height:= height - 5;
   {$endif}
end;

end.
