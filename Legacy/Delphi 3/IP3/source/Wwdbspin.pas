unit Wwdbspin;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, db, dbtables, wwdbedit, Menus, Mask, wwdatsrc,
  wwspin;

type
  TwwDBSpinEdit = class(TwwDBCustomEdit)
  private
     FMinValue: Double;
     FMaxValue: Double;
     FIncrement: Double;
     FButton: TwwSpinButton;
     FEditorEnabled: Boolean;

     procedure CMExit(var Message: TCMExit); message CM_EXIT;
     procedure WMSize(var Message: TWMSize);  message WM_SIZE;

     procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
     procedure WMPaste(var Message: TWMPaste);   message WM_PASTE;
     procedure WMCut(var Message: TWMCut);   message WM_CUT;

     function GetValue: Double;
     function CheckValue (NewValue: Double): Double;
     procedure SetValue (NewValue: Double);
     procedure SetEditRect; override;

  protected
    function IsValidChar(Key: Char): Boolean; virtual;
    procedure UpClick (Sender: TObject); dynamic;
    procedure DownClick (Sender: TObject); dynamic;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    Function GetIconIndent: integer; override;
    Function GetIconLeft: integer; override;
    function GetShowButton: boolean; override;
    procedure Loaded; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property EditorEnabled: Boolean read FEditorEnabled write FEditorEnabled default True;
    property Increment: Double read FIncrement write FIncrement;
    property MaxValue: Double read FMaxValue write FMaxValue;
    property MinValue: Double read FMinValue write FMinValue;
    property Value: Double read GetValue write SetValue;
    property AutoFillDate;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property CharCase;
    property Color;
    property Ctl3D;
    property DataField;
    property DataSource;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    {$ifdef ver100}
    property ImeMode;
    property ImeName;
    {$endif}
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UnboundDataType;
    property UsePictureMask;
    property Visible;

    property OnChange;
    property OnCheckValue;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;

  end;

procedure Register;

implementation

uses wwsystem, wwdbigrd, wwstr, wwcommon;

{$IFDEF WIN32}
{$R WWSPIN32.RES}
{$ELSE}
{$R WWSPIN.RES}
{$ENDIF}

constructor TwwDBSpinEdit.create(AOwner: TComponent);
var i: integer;
    myOwner: TwwSpinButton;
begin
  inherited Create(AOwner);
  FButton := TwwSpinButton.Create (Self);
  FButton.Width := 15;
  FButton.Height := 17;
  FButton.Visible := True;
  FButton.Parent := Self;
  FButton.OnUpClick := UpClick;
  FButton.OnDownClick := DownClick;
  {$IFDEF WIN32}
  FButton.ControlStyle := FButton.ControlStyle + [csReplicatable] - [csFramed];
  myOwner:= FButton;
  if myOwner<>Nil then begin
     for i:= 0 to myOwner.ControlCount-1 do begin
        if myOwner.Controls[i] is TwwTimerSpeedButton then
           myOwner.Controls[i].ControlStyle:= myOwner.Controls[i].ControlStyle + [csReplicatable];
     end
  end;
  {$else}
  FButton.ControlStyle := FButton.ControlStyle - [csFramed];
  {$ENDIF}


  Text := '0';

  ControlStyle := ControlStyle - [csSetCaption];
  FIncrement := 1;
  FEditorEnabled := True;

end;

destructor TwwDBSpinEdit.Destroy;
begin
   FButton.Free;
   FButton:= Nil;

   inherited Destroy;
end;

procedure TwwDBSpinEdit.CMExit(var Message: TCmExit);
begin
  if CheckValue (Value) <> Value then
    SetValue (CheckValue(Value));
  inherited;
end;

procedure TwwDBSpinEdit.UpClick (Sender: TObject);
var Year, Month, Day: word;
    Hour, Min, Sec, MSec: word;
    tempDate, tempTime: TDateTime;
    dateCursor: TwwDateTimeSelection;
    TimeOnly : boolean;
begin
{   DataLink.Edit;}
   SetFocus;
   TimeOnly := false;
   if (not EditCanModify) or ReadOnly or ((DataLink.Field<>Nil) and DataLink.Field.readonly) then
      MessageBeep(0)
   else begin
      if (isDateField or isDateTimeField or isTimeField) then begin

         DecodeDate(Value, Year, Month, Day);
         wwDoEncodeDate(Year, Month, Day, tempDate);

         if (isTimeField) then TimeOnly := True;
         if not TimeOnly then
            tempTime:= Value - tempDate
         else
            tempTime:= Value;

         DecodeTime(Value, Hour, Min, Sec, MSec);

         dateCursor:= wwGetDateTimeCursorPosition(SelStart, Text, TimeOnly);
         case DateCursor of
            wwdsDay: Day:= wwNextDay(Year, Month, Day);
            wwdsYear: Year:= Year + 1;
            wwdsMonth: Month:= (Month mod 12) + 1;
            wwdsHour: Hour := ((Hour+1) mod 24);
            wwdsMinute: Min:= ((Min+1) mod 60);
            wwdsSecond: Sec:= ((Sec+1) mod 60);
            wwdsAMPM: if Hour>=12 then Hour:= Hour - 12 else Hour:= Hour + 12;
         end;

         if DateCursor in [wwdsDay, wwdsYear, wwdsMonth] then begin
            while True do
            begin
               if wwDoEncodeDate(Year, Month, Day, tempDate) then begin
                  Value:= tempDate + tempTime;
                  break;
               end
               else begin
                  Day:= Day - 1;
                  if Day<28 then break;
               end
            end;
         end
         else begin
            if wwDoEncodeTime(Hour, Min, Sec, MSec, tempTime) then
               if not TimeOnly then
                  Value:= int(Value)+ tempTime
               else
                  Value:= tempTime;
         end;

         wwSetDateTimeCursorSelection(dateCursor, self, TimeOnly)

      end
      else begin
         Value := Value + FIncrement;
      end;
   end;
   SetModified(True);
end;

procedure TwwDBSpinEdit.DownClick (Sender: TObject);
var Year, Month, Day: word;
    Hour, Min, Sec, MSec: word;
    tempDate, tempTime: TDateTime;
    dateCursor: TwwDateTimeSelection;
    TimeOnly: boolean;
begin
{   DataLink.Edit;}
   TimeOnly := false;
   SetFocus;
   if (not EditCanModify) or ReadOnly or ((DataLink.Field<>Nil) and DataLink.Field.readonly) then
      MessageBeep(0)
   else begin
      if (isDateField or isDateTimeField or isTimeField) then begin

         DecodeDate(Value, Year, Month, Day);
         wwDoEncodeDate(Year, Month, Day, tempDate);

         if (isTimeField) then TimeOnly := True;
         if not TimeOnly then
            tempTime:= Value - tempDate
         else
            tempTime:= Value;

         DecodeTime(Value, Hour, Min, Sec, MSec);

         dateCursor:= wwGetDateTimeCursorPosition(SelStart, Text, TimeOnly);
         case DateCursor of
            wwdsDay: Day:= wwPriorDay(Year, Month, Day);
            wwdsYear: Year:= Year - 1;
            wwdsMonth: Month:= ((Month+10) mod 12) + 1;
            wwdsHour: Hour := ((Hour+23) mod 24);
            wwdsMinute: Min:= ((Min+59) mod 60);
            wwdsSecond: Sec:= ((Sec+59) mod 60);
            wwdsAMPM: if Hour>=12 then Hour:= Hour - 12 else Hour:= Hour + 12;
         end;
         if DateCursor in [wwdsDay, wwdsYear, wwdsMonth] then begin
            while True do
            begin
               if wwDoEncodeDate(Year, Month, Day, tempDate) then begin
                  Value:= tempDate + tempTime;
                  break;
               end
               else begin
                  Day:= Day - 1;
                  if Day<28 then break;
               end
            end;
         end
         else begin
            if wwDoEncodeTime(Hour, Min, Sec, MSec, tempTime) then
               if not TimeOnly then
                  Value:= int(Value)+ tempTime
               else
                  Value:= tempTime;
         end;

         wwSetDateTimeCursorSelection(dateCursor, self, TimeOnly);

      end
      else begin
         Value := Value - FIncrement;
      end;
   end;
   SetModified(True);
end;

procedure TwwDBSpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Parent is TwwCustomDBGrid then begin
     if not AllSelected then begin
        if Key = VK_UP then UpClick (Self)
        else if Key = VK_DOWN then DownClick (Self);
        if (Key=VK_UP) or (Key=VK_DOWN) then Key:= 0;
     end
  end
  else begin
     if (Key = VK_UP) then UpClick (Self)
     else if (Key = VK_DOWN) then DownClick (Self);
     if (Key=VK_UP) or (Key=VK_DOWN) then Key:= 0;
  end;
  inherited KeyDown(Key, Shift);
  if (key=vk_delete) and (not FEditorEnabled) then begin { 7/3/97 - Ignore delete }
    key:= 0;
    MessageBeep(0)
  end;
end;

procedure TwwDBSpinEdit.KeyPress(var Key: Char);
begin
  if not IsValidChar(Key) then
  begin
    Key := #0;
    MessageBeep(0)
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;

function TwwDBSpinEdit.IsValidChar(Key: Char): Boolean;
begin
   { 7/3/97 - Check EditorEnabled in all cases }
   if isDateTimeField or ((Field=Nil) and isDateField)
                      or ((Field=Nil) and isTimeField) then
      result:= True
   else
      Result := (Key in [DecimalSeparator, '+', '-', '0'..'9']) or
        ((Key < #32));  {changed vk_return is valid }
   if not FEditorEnabled and Result and ((Key >= #32) or
       (Key = Char(VK_BACK)) or (Key = Char(VK_DELETE))) then
      Result := False;
end;

procedure TwwDBSpinEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style :=(Params.Style and not (ES_AUTOVSCROLL or ES_WANTRETURN) or
                   WS_CLIPCHILDREN {or ES_MULTILINE})
end;

procedure TwwDBSpinEdit.CreateWnd;
begin
  inherited CreateWnd;
{  SetEditRect;}
end;

procedure TwwDBSpinEdit.SetEditRect;
var
  Loc: TRect;
begin
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
  Loc.Bottom := ClientHeight;
  Loc.Right := ClientWidth - FButton.Width - 2;
  if BorderStyle = bsNone then begin
     Loc.Top := 2;
     Loc.Left := 2;
  end
  else begin
     Loc.Top := 0;
     Loc.Left := 0;
  end;
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
end;

procedure TwwDBSpinEdit.WMSize(var Message: TWMSize);
var offset: integer;
begin
  inherited;

  if FButton <> nil then
  begin
    {$ifdef win32}
{    if (not Ctl3d) then offset:= 1 else offset:= 0;}
    offset:= 1;
    if (not NewStyleControls) or (BorderStyle = bsNone) or (not Ctl3d) then
       FButton.SetBounds (Width - FButton.Width, offset, FButton.Width, Height-offset)
    else FButton.SetBounds (Width - FButton.Width - 4, 0, FButton.Width, Height-3);
    {$else}
    FButton.SetBounds (Width - FButton.Width, 0, FButton.Width, Height);
    {$endif}
    SetEditRect;
  end;
end;

Function TwwDBSpinEdit.GetIconIndent: integer;
begin
   result:= FButton.Width;
end;

Function TwwDBSpinEdit.GetIconLeft: integer;
begin
   result:= FButton.Left - 1;
end;


procedure TwwDBSpinEdit.WMPaste(var Message: TWMPaste);
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TwwDBSpinEdit.WMCut(var Message: TWMPaste);
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

function TwwDBSpinEdit.GetValue: Double;
var Date: TDateTime;
begin
  if (Field is TFloatField) then begin
     if (Text='') or (not wwStrToFloat(Text)) then
        result:= FMinValue
     else Result := StrToFloat(Text);
  end
  else if (Field is TIntegerField) then begin
     if (Text='') or (not wwStrToInt(Text)) then
        result:= FMinValue
     else Result := StrToInt(Text);
  end
  else if isDateField then begin
{  else if (Field is TDateField) then begin}
     if (Text='') or (not wwStrToDate(Text)) then
        result:= FMinValue
     else Result := StrToDate(Text);
  end
  else if isTimeField then begin
{  else if (Field is TDateField) then begin}
      if (Text='') or (not wwStrToTime(Text)) then
        result:= FMinValue
     else Result := StrToTime(Text);
  end
  else if isDateTimeField then begin
{  else if (Field is TDateTimeField) then begin}
     if (Text='') then result:= FMinValue
     else if (not wwStrToDateTime(Text)) and (wwStrToDate(Text)) then
        Result:= StrToDate(Text)
     else if wwStrToDateTime(Text) then
        Result:= wwStrToDateTimeVal(Text)
     else if wwScanDate(Text, Date) then
        result:= Date
     else
        result:= FMinValue
  end
  else if (Text='') or (not wwStrToFloat(Text)) then begin
     result:= FMinValue;
  end
  else begin
    Result := StrToFloat(Text);
  end;

end;

procedure TwwDBSpinEdit.SetValue (NewValue: Double);
begin
  if Field is TFloatField then
     Text := FloatToStr (CheckValue (NewValue))
  else if Field is TIntegerField then
     Text := IntToStr (Trunc(CheckValue (NewValue)))
  else if isDateField then
     Text := DateToStr (CheckValue(NewValue))
  else if isTimeField then
     Text := TimeToStr (CheckValue(NewValue))
  else if isDateTimeField then
  begin
     { DateTimeToStr does not show time if it is 0 }
     if (Field=Nil) and (NewValue=trunc(NewValue)) then
     begin
        Text:= DateToStr(NewValue) + ' '  + TimeToStr(0);
     end
     else Text := DateTimeToStr (CheckValue(NewValue))
   end
  else Text := FloatToStr (CheckValue (NewValue));
end;

function TwwDBSpinEdit.CheckValue (NewValue: Double): Double;
begin
  Result := NewValue;
  if (FMaxValue <> FMinValue) or ((FMinValue<>0) or (FMaxValue<>0)) then
  begin
    if NewValue < FMinValue then
      Result := FMinValue
    else if NewValue > FMaxValue then
      Result := FMaxValue;
  end;
end;

procedure TwwDBSpinEdit.CMEnter(var Message: TCMGotFocus);
begin
{  if AutoSelect and not (csLButtonDown in ControlState) then
    SelectAll; }
  inherited;
end;

function TwwDBSpinEdit.GetShowButton: boolean;
begin
   result:= FButton.visible;
end;

procedure TwwDBSpinEdit.Loaded;
begin
  inherited Loaded;
  if (Field=Nil) and (Text='0') and
     isDateField or isDateTimeField or isTimeField then
     Text:= '';
end;

procedure Register;
begin
{  RegisterComponents('InfoPower', [TwwDBSpinEdit]);}
end;

end.
