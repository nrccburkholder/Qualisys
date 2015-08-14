{
//
// Components : TwwDBCustomCombo, TwwDBComboDlg
//
// Copyright (c) 1996, 1997 by Woll2Woll Software
//
//
}
unit Wwdotdot;

interface

uses
  Forms, Graphics, Menus, SysUtils, WinTypes, WinProcs, Messages, Classes,
  Controls, Buttons,
  dbctrls, mask, db, dbtables, stdctrls, wwdbedit, wwdblook, wwdatsrc;

type

  TwwComboButtonStyle = (cbsEllipsis, cbsDownArrow);

  TwwDBCustomCombo =class(TwwDBCustomEdit)
   private
    FBtnControl:TWincontrol;
    FButton:TSpeedButton;
    FOnCustomDlg:TNotifyevent;
    FStyle: TwwDBLookupComboStyle;
    FButtonStyle: TwwComboButtonStyle;
    FDroppedDown: boolean;

    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure NonEditMouseDown(var Message: TWMLButtonDown);
    procedure SetButtonStyle(val: TwwComboButtonStyle);
    Procedure UpdateButtonPosition;

   protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
    Function LoadComboGlyph: HBitmap; virtual;
    Procedure DrawButton(Canvas: TCanvas; R: TRect; State: TButtonState;
       ControlState: TControlState; var DefaultPaint: boolean); virtual;
    procedure SetEditRect; override;
    procedure WMSize(var msg:twmsize); message wm_size;
    procedure BtnClick(sender:tobject);
    function GetShowButton: boolean; override;
    procedure SetShowButton(sel: boolean); override;
    Function GetIconIndent: integer; override;
    Function GetIconLeft: integer; override;
    Function Editable: boolean; override;
    Function MouseEditable: boolean; virtual;
    Function GetClientEditRect: TRect; override;
    Function IsDroppedDown: boolean; virtual;
    procedure CloseUp(Accept: Boolean); virtual;
    procedure HandleDropDownKeys(var Key: Word; Shift: TShiftState);
    procedure Loaded; override;

   public
    constructor Create(AOwner:tcomponent); override;
    destructor Destroy; override;
    procedure DropDown; virtual;

    property Button: TSpeedButton read FButton;
    property OnCustomDlg: TNotifyevent read FOnCustomDlg write FOnCustomDlg;
    property Style: TwwDBLookupComboStyle read FStyle write FStyle;
    property ButtonStyle: TwwComboButtonStyle read FButtonStyle write SetButtonStyle;
  end;

  TwwDBComboDlg =class(TwwDBCustomCombo)
   published
    property OnCustomDlg;
    property ShowButton;
    property Style;
    property ButtonStyle default cbsEllipsis;
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
    property PasswordChar;
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

  TwwComboDlgButton = class(TSpeedButton)
  protected
    procedure Paint; override;
  end;

  procedure Register;

implementation

uses wwDBiGrd, wwcommon;

{.$R *.RES}
constructor TwwDBCustomCombo.Create;
begin
   inherited create(aowner);
   FButtonStyle:= cbsEllipsis;

   FBtnControl := TWinControl.Create (Self);
   {$IFDEF WIN32}
   FBtnControl.ControlStyle := FBtnControl.ControlStyle + [csReplicatable];
   {$ENDIF}
   FBtnControl.Width:= wwmax(GetSystemMetrics(SM_CXVSCROLL)+4, 17); {4/10/97}
   FBtnControl.Height := 17;
   FBtnControl.Visible := True;;
   FBtnControl.Parent := Self;

   FButton:=TwwComboDlgButton.create(self);
   {$IFDEF WIN32}
   FButton.ControlStyle := FButton.ControlStyle + [csReplicatable];
   {$ENDIF}
   FButton.SetBounds (0, 0, FBtnControl.Width, FBtnControl.Height);
   FButton.Width:= wwmax(GetSystemMetrics(SM_CXVSCROLL), 15); {5/2/97 }
{   FButton.align:=alClient; {<-- automatic fixup of the speedbutton}
   FButton.Glyph.Handle:= LoadComboGlyph;
   FButton.Parent:= FBtnControl;
   FButton.OnClick:=BtnClick;
end;

destructor TwwDBCustomCombo.Destroy;
begin
  FButton.Free;
  FButton:= Nil;
  inherited Destroy;
end;


Function TwwDBCustomCombo.GetIconIndent: integer;
begin
   result:= FBtnControl.Width;
end;

Function TwwDBCustomCombo.GetIconLeft: integer;
begin
   result:= FBtnControl.Left - 1;
end;

Function TwwDBCustomCombo.LoadComboGlyph: HBitmap;
begin
   {$ifdef win32}
{   result:= nil;}
   result:= 0;
   {$else}
   if FButtonStyle = cbsDownArrow then
      result:= LoadBitmap(0, PChar(32738))
   else result:= LoadBitmap(HInstance, 'DOTS')
   {$endif}
end;

function TwwDBCustomCombo.GetShowButton: boolean;
begin
   result:= FBtnControl.visible;
end;

procedure TwwDBCustomCombo.SetShowButton(sel: boolean);
begin
   if (FBtnControl.visible<> sel) then
   begin
      FBtnControl.visible:= sel;
      SetEditRect;
      self.invalidate;
   end
end;

procedure TwwDBCustomCombo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style :=(Params.Style and not (ES_AUTOVSCROLL or ES_WANTRETURN) or
                   WS_CLIPCHILDREN {or ES_MULTILINE})
end;

procedure TwwDBCustomCombo.SetEditRect;
var
  Loc: TRect;
begin
  Loc.Bottom :=ClientHeight+1; {+1 is workaround for windows paint bug}
  if ShowButton then Loc.Right := FBtnControl.Left - 2
  else Loc.Right:= ClientWidth - 2;

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

Procedure TwwDBCustomCombo.UpdateButtonPosition;
begin
  {$ifdef WIN32}
  if (not NewStyleControls) or (BorderStyle = bsNone) or (not Ctl3d) then
     FBtnControl.SetBounds (Width - FButton.Width, 0, FButton.Width, ClientHeight)
  else
     FBtnControl.SetBounds (Width - FButton.Width - 4, 0, FButton.Width, ClientHeight);

  if BorderStyle = bsNone then begin
     FButton.Top:= -1; {Allows bitmap to be larger }
     FButton.Height := FBtnControl.Height+1;
  end
  else begin
     FButton.Top:= 0; {Allows bitmap to be larger }
     FButton.Height := FBtnControl.Height;
  end;
  {$else}
  if (not NewStyleControls) or (BorderStyle = bsNone) then
     FBtnControl.SetBounds (Width - FButton.Width, 0, FButton.Width, ClientHeight)
  else
     FBtnControl.SetBounds (Width - FButton.Width - 2, 2, FButton.Width, ClientHeight-4);
  FButton.Height := FBtnControl.Height;
  {$endif}

  SetEditRect;
end;

procedure TwwDBCustomCombo.WMSize;
begin
  inherited;
  UpdateButtonPosition;
end;

procedure TwwDBCustomCombo.BtnClick;
begin
   if isDroppedDown then CloseUp(True)
   else begin
      if CanFocus then SetFocus;  { 8/30/96 - Set focus to control }
      if Focused then DropDown;   { 5/28/97 - Only drop-down if focus was allowed }
   end
end;

procedure TwwDBCustomCombo.CloseUp(Accept: boolean);
begin
   if Accept then modified:= True;
end;

procedure TwwDBCustomCombo.DropDown;
begin
   if Assigned(FOnCustomDlg) then begin
      FDroppedDown:= True;

      Invalidate;

      try  { If exception then clean-up }
         if (datasource<>nil) and (datasource.dataset<>nil) then
{            datasource.dataset.edit;}
            EnableEdit;
         FOnCustomDlg(self);
      finally
         if (not editable) then
            HideCaret(Handle); { Support csDropDownList style }
         Invalidate;
         FDroppedDown:= False;
      end;
   end
end;

Function TwwDBCustomCombo.Editable: boolean;
begin
   Result := (FStyle <> csDropDownList) or isDroppedDown;
end;

Function TwwDBCustomCombo.MouseEditable: boolean;
begin
   Result := (FStyle <> csDropDownList);
end;


procedure TwwDBCustomCombo.HandleDropDownKeys(var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_UP, VK_DOWN:
      if ssAlt in Shift then
      begin
        if isDroppedDown then CloseUp(True)
        else DropDown;
        Key := 0;
      end;
    VK_RETURN, VK_ESCAPE:
      if isDroppedDown and not (ssAlt in Shift) then
      begin
        CloseUp(Key = VK_RETURN);
        Key := 0;
      end;
  end;
end;


procedure TwwDBCustomCombo.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if GetKeyState(VK_MENU) < 0 then
  begin
     Include(Shift, ssAlt);
{     wwClearAltChar;}
  end;

  HandleDropDownKeys(Key, Shift);

  inherited KeyDown (Key, Shift);

  if (Key in [32..255]) and (not Editable) then key:=0;

end;

procedure TwwDBCustomCombo.KeyPress(var Key: Char);
begin
  { Disregard tab key since inherited maskedit event will beep }
  if isMasked and (Key=#9) then exit;
  inherited KeyPress(Key);
end;

procedure TwwDBCustomCombo.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if MouseEditable then
    inherited
  else
    NonEditMouseDown (Message);
end;

procedure TwwDBCustomCombo.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if MouseEditable then
    inherited
  else
    NonEditMouseDown (Message);
end;

procedure TwwDBCustomCombo.WMLButtonUp(var Message: TWMLButtonUp);
begin
  if not MouseEditable then MouseCapture := False;
  inherited;
end;

procedure TwwDBCustomCombo.NonEditMouseDown(var Message: TWMLButtonDown);
var
  CtrlState: TControlState;
begin
  if not (Parent is TwwCustomDBGrid) then SetFocus;
{  HideCaret (Handle);}

  if isDroppedDown then CloseUp(True)
  else DropDown;

  if csClickEvents in ControlStyle then
  begin
    CtrlState := ControlState;
    Include(CtrlState, csClicked);
    ControlState := CtrlState;
  end;
  with Message do
    MouseDown(mbLeft, KeysToShiftState(Keys), XPos, YPos);
end;

Procedure TwwDBCustomCombo.DrawButton(Canvas: TCanvas; R: TRect; State: TButtonState;
       ControlState: TControlState; var DefaultPaint: boolean);
begin
   {$ifdef win32}
   DefaultPaint:= False;
   if ButtonStyle=cbsDownArrow then
      wwDrawDropDownArrow(Canvas, R, State, Enabled, ControlState)
   else wwDrawEllipsis(Canvas, R, State, Enabled, ControlState)
   {$endif}
end;

procedure TwwComboDlgButton.Paint;
var R : TRect;
    DefaultPaint: boolean;
begin
   SetRect(R, 0, 0, ClientWidth, ClientHeight);
   with TwwDBCustomCombo(Parent.Parent) do
   begin
      DefaultPaint:= True;
      {$ifdef win32}
      DrawButton(Canvas, R, FState, ControlState, DefaultPaint);
      {$endif}
      if DefaultPaint then inherited Paint;
   end
end;

Function TwwDBCustomCombo.GetClientEditRect: TRect;
begin
   result:= ClientRect;
   if ShowButton then result.Right:= FBtnControl.Left;
end;

procedure TwwDBCustomCombo.SetButtonStyle(val: TwwComboButtonStyle);
begin
   if val<>FButtonStyle then begin
      FButtonStyle:= val;
      FButton.Glyph.Handle:= LoadComboGlyph;
      FButton.Invalidate;
   end
end;

Function TwwDBCustomCombo.IsDroppedDown: boolean;
begin
   result:= FDroppedDown;
end;

procedure TwwDBCustomCombo.Loaded;
begin
  FButton.Width:= wwmax(GetSystemMetrics(SM_CXVSCROLL), 15);
  UpdateButtonPosition;
  inherited Loaded;
end;

procedure TwwDBCustomCombo.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  FButton.Enabled := Enabled;
end;

procedure Register;
begin
{  RegisterComponents('InfoPower', [TwwDBComboDlg]);}
end;

end.
