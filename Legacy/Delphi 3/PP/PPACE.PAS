unit Ppace;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Menus, PPMain, exptintf, toolintf;

type
  TfrmPPace = class(TForm)
    GroupBox1: TGroupBox;
    cbMinWidth: TCheckBox;
    cbMaxWidth: TCheckBox;
    cbMinHeight: TCheckBox;
    cbMaxHeight: TCheckBox;
    cbSizableTop: TCheckBox;
    cbSizableBottom: TCheckBox;
    cbSizableLeft: TCheckBox;
    cbSizableRight: TCheckBox;
    cbMovable: TCheckBox;
    cbMovableVert: TCheckBox;
    cbMovableHorz: TCheckBox;
    cbHideChildren: TCheckBox;
    cbHideSiblings: TCheckBox;
    cbStayVisible: TCheckBox;
    cbTrackPositions: TCheckBox;
    cbEdgeOffset: TCheckBox;
    cbCursorMoving: TCheckBox;
    cbCursorSizingNS: TCheckBox;
    cbCursorSizingEW: TCheckBox;
    cbIniLog: TCheckBox;
    cbIniFileName: TCheckBox;
    cbIniSection: TCheckBox;
    cbIniPrefix: TCheckBox;
    GroupBox2: TGroupBox;
    lbPanels: TListBox;
    Label1: TLabel;
    btnApplyAll: TBitBtn;
    btnApplySelected: TBitBtn;
    PopupMenu1: TPopupMenu;
    Selectall1: TMenuItem;
    Deselectall1: TMenuItem;
    btnHelp: TBitBtn;
    btnClose: TBitBtn;
    cbAllowRollup: TCheckBox;
    cbAllowBeeps: TCheckBox;
    cbMoveParent: TCheckBox;
    cbMoveColor: TCheckBox;
    btnResetIni: TBitBtn;
    btnEraseINi: TBitBtn;
    openfile: TOpenDialog;
    cbGridAlignment: TCheckBox;
    cbTrackPanel: TCheckBox;
    procedure btnApplyAllClick(Sender: TObject);
    procedure btnApplySelectedClick(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure Deselectall1Click(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure lbPanelsClick(Sender: TObject);
    procedure btnResetIniClick(Sender: TObject);
    procedure btnEraseINiClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WhatForm: TComponent;
    procedure AlterPanel(s: string);
  end;

var
  frmPPace: TfrmPPace;

implementation

{$R *.DFM}

procedure TfrmPPace.AlterPanel(s: string);
var
c: tcomponent;
x: TGlobalAttributes;
a: TAttributes;
i: integer;

begin
c := Whatform.findcomponent(s);
for i := 0 to whatForm.ComponentCount-1 do
  if whatform.components[i] is TGlobalAttributes then
     x := tGlobalAttributes(whatform.components[i]);
a := x.attributes;
with TPowerPanel(c).attributes do begin
    if cbTrackPositions.checked then trackPositions := a.TrackPositions;
    if cbMinWidth.checked then MinWidth := a.MinWidth;
    if cbMaxWidth.checked then MaxWidth := a.MaxWidth;
    if cbMinHeight.checked then MinHeight := a.MinHeight;
    if cbMaxHeight.checked then MaxHeight := a.MaxHeight;
    if cbSizableTop.checked then SizableTop := a.SizableTop;
    if cbSizableBottom.checked then SizableBottom := a.SizableBottom;
    if cbSizableLeft.checked then SizableLeft := a.SizableLeft;
    if cbSizableRight.checked then SizableRight := a.SizableRight;
    if cbMovable.checked then Movable := a.Movable;
    if cbMovableVert.checked then MovableVert := a.MovableVert;
    if cbMovableHorz.checked then MovableHorz := a.MovableHorz;
    if cbMoveParent.checked then MoveParent := a.MoveParent;
    if cbMoveColor.checked then MoveColor := a.MoveColor;
    if cbHideChildren.checked then HideChildren := a.HideChildren;
    if cbHideSiblings.checked then HideSiblings := a.HideSiblings;
    if cbStayVisible.checked then StayVisible := a.StayVisible;
    if cbTrackPositions.checked then TrackPositions := a.TrackPositions;
    if cbEdgeOffset.checked then EdgeOffset := a.EdgeOffset;
    if cbCursorMoving.checked then CursorMoving := a.CursorMoving;
    if cbCursorSizingNS.checked then CursorSizingNS := a.CursorSizingNs;
    if cbCursorSizingEW.checked then CursorSizingEW := a.CursorSizingEw;
    if cbIniLog.checked then IniLog := a.IniLog;
    if cbIniFileName.checked then IniFileName := a.IniFileName;
    if cbIniSection.checked then IniSectionName := a.IniSectionName;
    if cbIniPrefix.checked then IniPrefix := a.IniPrefix;
    if cbAllowRollup.checked then AllowRollup := a.AllowRollup;
    if cbAllowBeeps.checked then AllowBeeps := a.AllowBeeps;
    if cbTrackPanel.checked then TrackPanel := a.TrackPanel;
    if cbGridAlignment.checked then GridAlignment := a.GridAlignment;

end;
end;
procedure TfrmPPace.btnApplyAllClick(Sender: TObject);
var i: integer;
begin
btnApplySelected.enabled := true;
btnResetini.enabled := true;
btnEraseini.enabled := true;
for i := 0 to lbpanels.items.count-1 do
  lbpanels.selected[i] := true;
end;

procedure TfrmPPace.btnApplySelectedClick(Sender: TObject);
var
i: integer;
begin
for i := 0 to lbPanels.items.count-1 do
  if lbpanels.selected[i] then
     alterPanel(lbPanels.items[i]);
end;

procedure TfrmPPace.Selectall1Click(Sender: TObject);
var
i: integer;
begin
for i := 0 to componentcount-1 do
  if components[i] is TCheckBox then
    tCheckBox(components[i]).checked := true;
end;

procedure TfrmPPace.Deselectall1Click(Sender: TObject);
var
i: integer;
begin
for i := 0 to componentcount-1 do
  if components[i] is TCheckBox then
    tCheckBox(components[i]).checked := false;
end;

procedure TfrmPPace.btnHelpClick(Sender: TObject);
begin
winhelp(handle,'PowerPan.hlp',HELP_CONTEXT, 38);
end;

procedure TfrmPPace.lbPanelsClick(Sender: TObject);
begin
if lbpanels.items.count > 0 then btnapplyselected.enabled := true;
btnResetIni.enabled := btnapplyselected.enabled;
btneraseIni.enabled := btnapplyselected.enabled;
end;

procedure TfrmPPace.btnResetIniClick(Sender: TObject);
var
i:integer;
c: tcomponent;
whatfile: string;
windir: array[0..200] of char;
begin
getwindowsdirectory(windir, 200);
openfile.initialdir := windir;
if assigned(toolservices) then
   openfile.filename := extractfilename(toolservices.getprojectname);
openfile.filename := ChangeFileExt(openfile.filename, '.INI');
if not (openfile.execute) then exit;
whatfile:= openfile.filename;
for i := 0 to lbPanels.items.count-1 do
  if lbpanels.selected[i] then begin
     c := Whatform.findcomponent(lbPanels.items[i]);
     tpowerpanel(c).resetini(whatfile);
  end;
end;

procedure TfrmPPace.btnEraseINiClick(Sender: TObject);

var
i:integer;
c: tcomponent;
whatfile: string;
windir: array[0..200] of char;
begin
getwindowsdirectory(windir, 200);
openfile.initialdir := windir;
if assigned(toolservices) then
   openfile.filename := extractfilename(toolservices.getprojectname);
openfile.filename := ChangeFileExt(openfile.filename, '.INI');
if not (openfile.execute) then exit;
whatfile:= openfile.filename;
for i := 0 to lbPanels.items.count-1 do
  if lbpanels.selected[i] then begin
     c := Whatform.findcomponent(lbPanels.items[i]);
     tpowerpanel(c).eraseini(whatfile);
  end;
end;

end.
