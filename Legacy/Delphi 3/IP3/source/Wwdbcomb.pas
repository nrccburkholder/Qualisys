unit Wwdbcomb;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Mask, Wwdbedit, Wwdotdot,
  db, dbtables, menus, wwdatsrc, wwtypes;


type

  TwwDBComboBox = class;
  TwwComboCloseUpEvent = procedure(Sender: TwwDBComboBox; Select: boolean) of object;

  TwwPopupListbox = class(TCustomListbox)
  private
    FSearchText: String;
    FSearchTickCount: Longint;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Keypress(var Key: Char); override;
    procedure DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState); override;
  public
    constructor Create(AOwner: TComponent); Override;
  end;

  TwwDBComboBox = class(TwwDBCustomCombo)
  private
    FMapList: boolean;
    FItems: TStrings;
    FDropDownCount: integer;
    FItemHeight: integer;
    FListbox: TwwPopupListBox;
    FListVisible: Boolean;
    FNoKeysEnteredYet: boolean;
    FAllowClearKey: boolean;
    FItemIndex: integer;
    FStyle: TComboBoxStyle;
    FCanvas: TCanvas;
    FDropDownWidth: integer;
    FAutoDropDown: boolean;
    FShowMatchText: boolean;

    FOnDropDown: TNotifyEvent;
    FOnCloseUp: TwwComboCloseUpEvent;
    FOnDrawItem: TDrawItemEvent;
    FOnMeasureItem: TMeasureItemEvent;

    InAutoDropDown: boolean;

    procedure DataChange(Sender: TObject);
    function GetComboText: string;
    procedure SetComboText(const Value: string);
    procedure SetItemList(Value: TStrings);
    Function GetSorted: boolean;
    procedure SetSorted(val: Boolean);
    Function GetItemIndex: integer;
    procedure SetItemIndex(val: integer);
    procedure CMCancelMode(var Message: TCMCancelMode); message CM_CancelMode;
    procedure WMKillFocus(var Message: TMessage); message WM_KillFocus;
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN; {handle tab}

    procedure ListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WndProc(var Message: TMessage); override;
    Function GetCanvas: TCanvas;
    Function OwnerDraw: boolean;
    Procedure SetStyle(val: TComboBoxStyle);

  protected
    Function GetFieldMapText(StoreValue: string; var res: string): boolean; override; { Map Value to Display Value }
    Function GetStoredText: string; override;
    procedure CloseUp(Accept: Boolean); override;
    Function isDroppedDown: boolean; override;
    Function Editable: boolean; override;
    Function MouseEditable: boolean; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    procedure ListBoxNeeded;
    procedure DoSelectAll;
    Procedure ShowText(ACanvas: TCanvas;
          ARect: TRect; indentLeft, indentTop: integer; AText: string); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    Function GetComboValue(DisplayText: string): string;
    Function GetComboDisplay(Value: string): string;
    procedure ApplyList;
    procedure DropDown; override;

{    property Text;}
    property ItemIndex: integer read GetItemIndex write SetItemIndex;
    property Canvas : TCanvas read GetCanvas;
    property DroppedDown: boolean read isDroppedDown;

  published

    property ShowButton;  { Publish before Style property for SetStyle code }
    property Style : TComboboxStyle read FStyle write SetStyle; {Must be published before Items}
    property MapList: boolean read FMapList write FMapList; { publish before Items }

    property AllowClearKey : boolean read FAllowClearKey write FAllowClearKey;
    property AutoDropDown : boolean read FAutoDropDown write FAutoDropDown default False;
    property ShowMatchText: boolean read FShowMatchText write FShowMatchText default False;
    property AutoFillDate;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property ButtonStyle default cbsDownArrow;
    property CharCase;
    property Color;
    property Ctl3D;
    property DataField;
    property DataSource;
    property DragMode;
    property DragCursor;
    property DropDownCount : integer read FDropDownCount write FDropDownCount;
    property DropDownWidth: Integer read FDropDownWidth write FDropDownWidth default 0;
    property Enabled;
    property Font;
    {$ifdef ver100}
    property ImeMode;
    property ImeName;
    {$endif}
    property ItemHeight : integer read FItemHeight write FItemHeight;
    property Items : TStrings read FItems write SetItemList;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property Picture;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Sorted : boolean read GetSorted write SetSorted;
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
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnCloseUp: TwwComboCloseUpEvent read FOnCloseUp write FOnCloseUp;
    property OnDrawItem: TDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnMeasureItem: TMeasureItemEvent read FOnMeasureItem write FOnMeasureItem;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

procedure Register;

implementation

uses wwstr, wwdbigrd, wwcommon;


procedure TwwDBComboBox.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    wm_KeyDown, wm_SysKeyDown, wm_Char:
      with TWMKey(Message) do
      begin

        if not (isDroppedDown and
           (CharCode in [VK_LEFT, VK_RIGHT, VK_HOME, VK_END]) and
           (Message.Msg=wm_KeyDown)) then begin

           HandleDropDownKeys(CharCode, KeyDataToShiftState(KeyData));
           if (CharCode <> 0) and FListVisible then
           begin
             with TMessage(Message) do
                SendMessage(FListBox.Handle, Msg, WParam, LParam);
           end
        end;

        if  (isDroppedDown and
            (CharCode in [VK_UP, VK_DOWN])) then exit;
      end
  end;

  inherited WndProc(Message);
end;

procedure TwwDBComboBox.KeyPress(var Key: Char);
var TempAutoFillDate: boolean;
    TempText: string;
    i, curpos, TempIndex: integer;
    LItem: string;
    found: boolean;
    startIndex: integer;

   Function NewText: string;
   var curStr : string;
   begin
      curStr:= Text;
      result:= copy(curStr, 1, selStart) +
               char(Key) + copy(curStr, selStart + 1 + length(SelText), 32767);
   end;

    procedure SelectValue(AIndex: integer);
    begin
       if AIndex>FItems.count-1 then exit;
       if AIndex<0 then exit;
       if (Datasource<>nil) then begin
          DataLink.Edit;
          if not DataLink.Editing then exit;
       end;
       curpos:= 1;
       FItemIndex:= AIndex;
       Text:= strGetToken(FItems[AIndex], #9, curPos);
       SetModified(True);  {1/21/97}
    end;

    function max(x,y: integer): integer;
    begin
       if x>y then result:= x else result:= y;
    end;

begin
   tempText:= NewText;
   if ShowMatchText and (Key in [#32..#254]) and (Text<>TempText) then begin
      found:= False;
      if (selStart>=length(NewText)-1) then begin
         startIndex:= max(0, FItemIndex);
         for i:= startIndex to (startIndex + FItems.count-1) do begin  { 6/4/97 - Use startIndex }
            tempIndex:= i mod (FItems.count);
            curpos:= 1;
            Litem:=uppercase(strGetToken(FItems[tempIndex],#9, curPos));
            if pos(uppercase(TempText),Litem)=1 then begin
               SelectValue(tempIndex);
               selStart:= length(TempText);
               selLength:= length(Text)-length(TempText);
               key:= #0;
               found:= True;
               break;
            end
         end
      end;

      if not found then begin
         if (Style=csDropDownList) or isDroppedDown then begin
            key:= #0;
         end
      end

   end;

   TempAutoFillDate:= AutoFillDate;
   If MapList then AutoFillDate:= False;
   inherited KeyPress(Key);
   AutoFillDate:= TempAutoFillDate;

   if Key=#13 then Key:= #0; { 8/22/96 - Avoid Beep when closing dropdown :)}
end;

constructor TwwPopupListBox.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   {$IFDEF WIN32}
   ControlStyle := ControlStyle + [csReplicatable];
   {$ENDIF}
end;

procedure TwwPopupListbox.Keypress(var Key: Char);
var
  TickCount: Integer;
  buf: array[0..255] of char;
  selIndex: integer;
  combo: TwwDBComboBox;
   Function NewText: string;
   var curStr : string;
   begin
      curStr:= FSearchText;
      result:= copy(curStr, 1, combo.selStart) +
               char(Key) + copy(curStr, combo.selStart + 1 + length(combo.SelText), 32767);
   end;
begin
  Combo:= owner as TwwDBComboBox;
  case Key of
    #8, #27: FSearchText := '';
    #32..#255:
      begin
        { Allow incremental searching for up to 1.5 seconds before resetting }
        if Combo.OwnerDraw then begin
           TickCount := GetTickCount;
           if TickCount - FSearchTickCount > 1500 then FSearchText := '';
           FSearchTickCount := TickCount;
        end
        else FSearchText:= Combo.Text;

        if Length(FSearchText) < 32 then FSearchText := NewText;
        strplcopy(buf, FSearchText, 255);
        selIndex:= SendMessage(Handle, LB_SelectString, WORD(-1), Longint(@buf));
        if not combo.ShowMatchText then
           if selIndex=-1 then itemIndex:= -1;  {11/5/96 - If not found then clear itemInidex }
        Key := #0;
      end;
  end;
  inherited Keypress(Key);
end;

procedure TwwPopupListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or WS_BORDER;
    {$ifdef win32}
    ExStyle := WS_EX_TOOLWINDOW;
    {$endif}
    WindowClass.Style := CS_SAVEBITS;
  end;
end;

procedure TwwPopupListbox.CreateWnd;
begin
  inherited CreateWnd;
  WinProcs.SetParent(Handle, 0);
  CallWindowProc(DefWndProc, Handle, wm_SetFocus, 0, 0);
end;

procedure TwwPopupListBox.DrawItem(Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
var combo: TwwDBComboBox;
begin
  Combo:= owner as TwwDBComboBox;
  if Assigned(Combo.FOnDrawItem) then begin
     if not (odSelected in State) then begin
        Canvas.Brush.Color:= Color;
        Canvas.Font.Color:= Font.Color;
        Canvas.TextRect(Rect, Rect.Left, Rect.Top, '');
     end;

     Combo.FOnDrawItem(Combo, Index, Rect, State)
  end
  else inherited DrawItem(Index, Rect, State);
end;

constructor TwwDBComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DropDownCount:= 8;
  FItems:= TStringList.create;
  FItemIndex:= -1;
  ButtonStyle:= cbsDownArrow; {???}
  DataLink.OnDataChange := DataChange;
end;

Function TwwDBComboBox.GetCanvas: TCanvas;
begin
   if FCanvas<>Nil then result:= FCanvas
   else if FListBox<>Nil then result:= FListBox.Canvas
   else result:= Nil;
end;

destructor TwwDBComboBox.Destroy;
begin
  FItems.Free;
  FItems:= nil;
  FListbox.Free;
  FListbox:= nil;
  inherited Destroy;
end;

procedure TwwDBComboBox.ListboxNeeded;
begin
  if FListbox<>Nil then exit;

  FListbox:= TwwPopupListbox.create(self);
  FListbox.visible:= False;
  FListbox.integralHeight:= True;
  FListbox.ItemHeight := 11;
  FListbox.parent:= self;
  SetWindowPos(FListbox.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW); { Hide window }
  FListbox.visible:= False;
  FListbox.OnMouseUp := ListMouseUp;

end;

Function TwwDBComboBox.GetFieldMapText(StoreValue: string; var res: string): boolean;
begin
   if maplist then begin
      Res:= GetComboDisplay(StoreValue);
      result:= True;
   end
   else result:= False;
end;

Function TwwDBComboBox.GetStoredText: string;
begin
   result:= GetComboText;
end;

{ Return current combo's hidden value }
function TwwDBComboBox.GetComboText: string;
begin

  if (Style in [csDropDown]) and (Text='') then Result:= ''
  else Result:= GetComboValue(Text);

{  if Style in [csDropDown] then begin
     if Text = '' then tempIndex := -1
     else tempIndex := (FListbox.Items).IndexOf(Text);
  end;

  if (tempIndex < 0) then Result := ''
  else begin
     Result:= GetComboValue(Text);
  end;
}
end;

{ Map a HiddenValue to its corresponding Display Value }
Function TwwDBComboBox.GetComboDisplay(Value: string): string;
var curpos, i: integer;
   DisplayVal: string;
begin
   Result:= '';
   if FMapList then begin
      for i:= 0 to FItems.count-1 do begin
         curpos:= 1;
         DisplayVal:= strGetToken(FItems[i], #9, curPos);
         if strGetToken(FItems[i], #9, curPos)=Value then
         begin
            result:= DisplayVal;
            exit;
         end
      end
   end
   else Result:= Value;
end;

{ Map a DisplayValue to its corresponding Hidden Value }
Function TwwDBComboBox.GetComboValue(DisplayText: string): string;
var curpos, i: integer;
begin
   result:= '';
   if FMapList then begin
      for i:= 0 to FItems.count-1 do begin
         curpos:= 1;
         if strGetToken(FItems[i], #9, curPos)=DisplayText then
         begin
            result:= strGetToken(FItems[i], #9, curPos);
            break;
         end
      end
   end
   else Result:= DisplayText;
end;

procedure TwwDBComboBox.DataChange(Sender: TObject);
begin
  { When mapping list don't do edit masking }
  if MapList then begin
     if DataLink.Field <> nil then
       SetComboText(DataLink.Field.asString)
     else
       if csDesigning in ComponentState then
         SetComboText(Name)
       else
         SetComboText('');
  end
  else begin
    if (DataLink.Field<>Nil) then begin
       SetComboText(DataLink.Field.asString);  { 8/22/96 - Accurate ItemIndex}
       if OwnerDraw then begin
          FItemIndex:= FItems.IndexOf(DataLink.Field.asString);
          invalidate;
       end
    end;

    inherited DataChange(Sender);
  end
end;

procedure TwwDBComboBox.SetComboText(const Value: string);
var
  I,J: Integer;
  curPos: integer;
  NewText: string;
begin
  if (Value <> GetComboText) or ((Value='') and MapList) then  {5/6/97 - Support null mapping }
  begin
    if (Style in [csDropDown]) and (not FMapList) then
    begin
       Text := Value;
       exit;
    end;

    if (Value = '') and (not MapList) then I := -1  { 5/6/97 - Support null mapping }
    else begin
       if (FMapList) then begin
          i:= -1;
          for j:= 0 to FItems.count-1 do begin
             curpos:= 1;
             NewText:= strGetToken(FItems[j], #9, curPos);
             if Value=strGetToken(FItems[j], #9, curPos) then begin
                i:= j;
                Text:= NewText;
                break;
             end
          end;
          if i>=FItems.count then i:= -1;
       end
       else I:= FItems.IndexOf(Value);
    end;

    ItemIndex := I;

    if I >= 0 then Exit;
    if ItemIndex<0 then Text:= ''
{    else if FMapList then
       text:= FItems[I]}
  end;
end;

procedure TwwDBComboBox.SetItemList(Value: TStrings);
begin
  FItems.Assign(Value);
  DataLink.OnDataChange(Self);
end;

Function TwwDBComboBox.GetSorted: boolean;
begin
   result:= (FItems as TStringList).Sorted;
end;

Procedure TwwDBComboBox.SetSorted(val: boolean);
begin
   (FItems as TStringList).sorted:= val;
{   FItems.Sorted:= val;}
end;

procedure TwwDBComboBox.ApplyList;
var i, curpos: integer;
begin
  ListBoxNeeded;  { 8/16/96 - Listbox needed before applying list }
  (FListbox.Items).clear;
  for i:= 0 to FItems.count-1 do
  begin
     curPos:= 1;
     (FListbox.Items).add(strGetToken(FItems[i], #9, curPos));
  end;
end;

procedure TwwDBComboBox.DropDown;
var
  P: TPoint;
  X, Y: Integer;
  WinAttribute: HWnd;
  ListBoxWidth, ListBoxHeight: integer;
{  parentForm: TCustomForm;}
begin
   if FListVisible or (Style=csSimple) then exit;
   Invalidate;
{   EnableEdit;}  { 6/4/97 - Don't enter edit mode - Let EditCanModify handle it in CloseUp event}

   ApplyList;
   if Assigned(FOnDropDown) then
   begin
      FOnDropDown(Self);
      ApplyList;  { In case the list was modified }
   end;

   case Style of
      csOwnerDrawFixed: FListBox.Style:= lbOwnerDrawFixed;
      csOwnerDrawVariable: FListBox.Style:= lbOwnerDrawVariable;
   end;

   FListBox.Sorted:= Sorted;
   FListBox.Color := Color;
   FListBox.Font := Font;
   FListBox.ItemHeight:= FItemHeight;

   if FListBox.Items.Count >= DropDownCount then
     ListBoxHeight:= DropDownCount * FListBox.ItemHeight + 4
   else
     ListBoxHeight:= FListBox.Items.Count * FListBox.ItemHeight + 4;
   if FDropDownWidth=0 then ListBoxWidth:= Width
   else ListBoxWidth:= FDropDownWidth;

   { Pre-select record }
   if OwnerDraw and (DataLink.Field<>Nil) then
      FListBox.ItemIndex:= FItems.IndexOf(DataLink.Field.asString)
   else if Text='' then
     FListBox.ItemIndex := -1
   else begin
     if Field<>Nil then
        FListBox.ItemIndex := FListBox.Items.IndexOf(Text)
     else
        FListBox.ItemIndex := FListBox.Items.IndexOf(Text)
   end;

   P := Parent.ClientToScreen(Point(Left, Top));
   Y := P.Y + Height - 1;
   if Y + ListBoxHeight > Screen.Height then Y := P.Y - ListBoxHeight;

   { 4/1/97 - Expand list to left since it goes past edge of screen }
   X := P.X ;
   if P.X + ListBoxWidth >= Screen.Width then X := P.X + Width - 1 - ListBoxWidth;

   { 3/13/97 - Always Top so that drop-down is not hidden under taskbar}
   WinAttribute:= HWND_TOPMOST;
   SetWindowPos(FListBox.Handle, WinAttribute, X, Y, ListBoxWidth, ListBoxHeight,
    {  SWP_NOSIZE or} SWP_NOACTIVATE or SWP_SHOWWINDOW);
   FListVisible := True;
   FNoKeysEnteredYet:= True;

   WinProcs.SetFocus(Handle);
   if not inAutoDropDown then DoSelectAll;
   if Editable then ShowCaret(Handle);
   Invalidate;
end;

procedure TwwDBComboBox.CloseUp(Accept: Boolean);
var
  ListValue: String;
begin
  if FListVisible then
  begin
    ListValue:= '';
    if GetCapture <> 0 then SendMessage(GetCapture, WM_CANCELMODE, 0, 0);
    if Accept and (FListbox.ItemIndex <> -1) then
        ListValue := FListbox.Items[FListbox.ItemIndex];
    SetWindowPos(FListbox.Handle, 0, 0, 0, 0, 0, SWP_NOZORDER or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_HIDEWINDOW);
    FListVisible := False;
    if Accept then
    begin
      if (ListValue<>Text) and EditCanModify then { 6/5/97 - Only update if changed }
      begin
         if ListValue<>'' then begin
            Text:= ListValue;
         end
         else if (Style=csDropDownList) or FMapList then Text:= '';
         FItemIndex:= FListBox.itemIndex;
         SetModified(True);  {1/21/97}
      end;
    end;
    if (not editable) then HideCaret(Handle);
    Invalidate;
    DoSelectAll;
{    FListBox.Free;
    FListBox:= Nil; } { 5/2/97}
    if Assigned(FOnCloseUp) then FOnCloseUp(Self, Accept);
  end;
end;

Procedure TwwDBComboBox.DoSelectAll;
begin
   if Editable then SelectAll;
end;

Function TwwDBComboBox.GetItemIndex: integer;
begin
   if (FListBox<>Nil) then result:= FListbox.itemIndex
   else result:= FItemIndex;
end;

procedure TwwDBComboBox.SetItemIndex(val: integer);
var curpos: integer;
begin
   FItemIndex:= val;
   if (FListBox<>Nil) then FListbox.itemIndex:= val;
   if (val>=0) and (val<FItems.count) then
   begin
      curpos:= 1;
      Text:= strGetToken(FItems[val], #9, curPos); { 9/4/96 }
   end;
end;

Function TwwDBComboBox.isDroppedDown: boolean;
begin
    result:= FListVisible;
end;

procedure TwwDBComboBox.CMCancelMode(var Message: TCMCancelMode);
begin
  if (Message.Sender <> Self) and (Message.Sender <> FListBox) and
     (Message.Sender <> Button) then
    CloseUp(True);
end;

procedure TwwDBComboBox.WMKillFocus(var Message: TMessage);
begin
  inherited;
  CloseUp(True);
end;

procedure TwwDBComboBox.ListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then
    CloseUp(PtInRect(FListBox.ClientRect, Point(X, Y)));
end;

procedure TwwDBCombobox.CNKeyDown(var Message: TWMKeyDown);
begin
  if not (csDesigning in ComponentState) then
    with Message do
    begin
       if (charcode = VK_TAB) and FListVisible then Closeup(True)
       else if FListVisible and
        ((charcode=vk_return) or (charcode=vk_escape)) then
         exit;
    end;

  inherited;
end;

procedure TwwDBComboBox.KeyUp(var Key: Word; Shift: TShiftState);
begin
   if AllowClearKey then begin
      if FListVisible then begin
         if ((key=vk_delete) or (key=vk_back)) and (Text='') then
            itemIndex:= -1
      end
      else begin
         if ((key=vk_delete) or (key=vk_back)) and
             (Style=csDropDownList) and (not ShowMatchText) then
         begin
            Text:= '';
            itemIndex:= -1;  { 8/22/96}
         end
      end;
   end;

   inherited KeyUp(Key, Shift);
end;

{ Support scrolling vai VK_Up and VK_Down when listbox is not shown. }
procedure TwwDBComboBox.KeyDown(var Key: Word; Shift: TShiftState);
var i, curpos: integer;
    tempIndex: integer;
    Litem:string;

    procedure SelectValue(AIndex: integer);
    begin
       if AIndex>FItems.count-1 then exit;
       if AIndex<0 then exit;
       if (Datasource<>nil) then begin
          DataLink.Edit;
          if not DataLink.Editing then exit;
       end;
       curpos:= 1;
       FItemIndex:= AIndex;
       Text:= strGetToken(FItems[AIndex], #9, curPos);
       SetModified(True);  {5/17/97}
       DoSelectAll;
    end;

begin
   if (not DroppedDown) and wwIsValidChar(Key) and AutoDropDown and
      (not (key in [VK_DELETE,VK_BACK])) then begin
      InAutoDropDown:= True;
      DropDown;
      InAutoDropDown:= False;
   end;

   if GetKeyState(VK_MENU) < 0 then
   begin
      Include(Shift, ssAlt);
   end;

   if (not (FListVisible)) then
   begin
      if (not (parent is TwwCustomDBGrid)) and
         ((Key=VK_Down) or (Key=vk_Up)) then
      begin
         if key=vk_down then SelectValue(FItemIndex + 1)
         else SelectValue(FItemIndex-1);
         Key:= 0;
      end
      else if ShowMatchText then
      else if (Style=csDropDownList) and wwIsValidChar(Key) then begin  { Use first character to search }
         for i:= FItemIndex+1 to (FItemIndex + FItems.count) do begin
            tempIndex:= i mod (FItems.count);
            curpos:= 1;
            Litem:=uppercase(strGetToken(FItems[tempIndex],#9, curPos));
            if pos(uppercase(char(key)),Litem)=1 then begin
               SelectValue(tempIndex);
               break;
            end
         end;
      end
   end
   else begin
      if FListVisible and
         ((Style<>csDropDown) or AutoDropDown or   { 9/12/96 - Added "or AutoDropDown" }
         ((Style=csDropDown) and False and (selLength=length(Text)))) and  { 9/24/96 - Clear if all selected }
         wwIsValidChar(Key) and FNoKeysEnteredYet then
      begin
         Text:= '';
         FNoKeysEnteredYet:= False;
      end
   end;
   inherited KeyDown(Key, Shift);
end;

Function TwwDBComboBox.Editable: boolean;
begin
   if OwnerDraw then result:= False
   else Result := (FStyle <> csDropDownList) or isDroppedDown or ShowMatchText;
end;

Function TwwDBComboBox.MouseEditable: boolean;
begin
   if OwnerDraw then result:= False
   else Result := (FStyle <> csDropDownList);
end;

Procedure TwwDBComboBox.ShowText(ACanvas: TCanvas;
          ARect: TRect; indentLeft, indentTop: integer; AText: string);
begin
   FCanvas:= ACanvas;
   if Assigned(FOnDrawItem) and OwnerDraw then
   begin
      if isDroppedDown then begin
         FCanvas.Brush.Color:= Color;
         FCanvas.Font.Color:= Font.Color;
      end;
      FCanvas.TextRect(ARect, ARect.Left, ARect.Top, '');
      FOnDrawItem(self, FItemIndex, ARect, [odFocused])
   end
   else ACanvas.TextRect(ARect, indentLeft, indentTop, AText);
   FCanvas:= Nil;
end;

Function TwwDBComboBox.OwnerDraw: boolean;
begin
   result:= Style in [csOwnerDrawFixed, csOwnerDrawVariable]
end;

Procedure TwwDBComboBox.SetStyle(val: TComboBoxStyle);
begin
   if val=csSimple then ShowButton:= False
   else if (FStyle=csSimple) then ShowButton:= True;
   FStyle:= val;
end;

procedure Register;
begin
{  RegisterComponents('InfoPower', [TwwDBComboBox]);}
end;

end.
