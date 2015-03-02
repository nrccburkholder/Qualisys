unit EDSDB;
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Controls, Graphics, Forms,
  Menus, StdCtrls, ExtCtrls, DBCtrls, DBGrids;

type
  TDBEnterEdit = class(TDBEdit)
    private
      { Private declarations }
    protected
      { Protected declarations }
      procedure KeyPress(var Key: Char); override;
      procedure KeyDown (var Key: Word; Shift: TShiftState);  override;
    public
      { Public declarations }
    published
      { Published declarations }
  end;  { TDBEnterEdit }

  TNewDBGrid = class (TDBGrid)
    private
      { Private declarations }
      (*
      FOnClick : TNotifyEvent;
      FOnMouseDown: TMouseEvent;
      FOnMouseMove: TMouseMoveEvent;
      FOnMouseUp: TMouseEvent;
      procedure Click; override;
      procedure DoMouseDown(var Message: TWMMouse; Button: TMouseButton;
        Shift: TShiftState);
      procedure DoMouseUp(var Message: TWMMouse; Button: TMouseButton);
      procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
      procedure WMNCLButtonDown(var Message: TWMNCLButtonDown); message WM_NCLBUTTONDOWN;
      procedure WMNCRButtonDown(var Message: TWMNCRButtonDown); message WM_NCRBUTTONDOWN;
      procedure WMRButtonDown(var Message: TWMRButtonDown); message WM_RBUTTONDOWN;
      procedure WMMButtonDown(var Message: TWMMButtonDown); message WM_MBUTTONDOWN;
      procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
      procedure WMRButtonDblClk(var Message: TWMRButtonDblClk); message WM_RBUTTONDBLCLK;
      procedure WMMButtonDblClk(var Message: TWMMButtonDblClk); message WM_MBUTTONDBLCLK;
      procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
      procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
      procedure WMRButtonUp(var Message: TWMRButtonUp); message WM_RBUTTONUP;
      procedure WMMButtonUp(var Message: TWMMButtonUp); message WM_MBUTTONUP;
      procedure WMCancelMode(var Message: TWMCancelMode); message WM_CANCELMODE;
      *)
    published
      { Published declarations }
      (*
      property OnClick : TNotifyEvent read FOnClick write FOnClick;
      property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
      property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
      property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
      *)
      property OnClick;
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;
  end;  { TNewDBGrid }

procedure Register;

implementation

procedure TDBEnterEdit.KeyPress(var Key: Char);
{$IFDEF Ver100}
var
  MyForm: TCustomForm;
{$ELSE}
var
   MYForm: TForm;
{$ENDIF}
begin
  if Key = #13 then
  begin
    MYForm := GetParentForm( Self );
    if not (MYForm = nil ) then
        SendMessage(MYForm.Handle, WM_NEXTDLGCTL, 0, 0);
    Key := #0;
  end;  { if... }
  if Key <> #0 then inherited KeyPress(Key);
end;  { TDBEnterEdit.KeyPress }

procedure TDBEnterEdit.KeyDown (var Key: Word; Shift: TShiftState);
var
  St: string;
begin
  case Key of
    VK_UP: if ssCtrl in Shift then
           begin
             Text := UpperCase (Text);
             Key  := 0;
           end;  { if... }
    VK_DOWN: if ssCtrl in Shift then
             begin
               St    := UpperCase (Text);
               St[1] := UpCase (St[1]);
               Text  := St;
               Key  := 0;
             end;  { if... }
  end;  { case }
end;  { TDBEnterEdit.KeyDown }
(*
procedure TNewDBGrid.Click;
begin
  inherited Click;
  if assigned (FOnClick) then FOnClick (Self);
end;  { TNewDBGrid.Click }
*)
procedure Register;
begin
  RegisterComponents('Domain', [TDBEnterEdit, TNewDBGrid]);
end;

end.  { EDSDB }
