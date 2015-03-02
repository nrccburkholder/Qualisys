unit Ppce;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Ppmain, ExtCtrls, Buttons, Tabs;

type
  TfrmPPCE = class(TForm)
    OpenINI: TOpenDialog;
    TabSet1: TTabSet;
    Panel1: TPanel;
    btnGlobal: TBitBtn;
    btnCopy: TBitBtn;
    BitBtn1: TBitBtn;
    brnCancel: TBitBtn;
    btnOk: TBitBtn;
    Panel2: TPanel;
    Notebook1: TNotebook;
    MovementGroup: TGroupBox;
    Label7: TLabel;
    cbMovable: TCheckBox;
    cbMovableVert: TCheckBox;
    cbMovableHorz: TCheckBox;
    cbMoveParent: TCheckBox;
    cboColors: TComboBox;
    IniGroup: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    cbINILog: TCheckBox;
    ebINISection: TEdit;
    ebIniFileName: TEdit;
    ebINIPrefix: TEdit;
    Button1: TButton;
    LimitsGroup: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ebMinWidth: TEdit;
    ebMaxWidth: TEdit;
    ebMinHeight: TEdit;
    ebMaxHeight: TEdit;
    ebEdgeOffset: TEdit;
    GroupBox1: TGroupBox;
    cbAllowRollup: TCheckBox;
    cbAllowBeeps: TCheckBox;
    cbHideChildren: TCheckBox;
    cbHideSiblings: TCheckBox;
    cbStayVisible: TCheckBox;
    cbSizableTop: TCheckBox;
    cbSizableBottom: TCheckBox;
    cbSizableLeft: TCheckBox;
    cbSizableRight: TCheckBox;
    cbTrackPositions: TCheckBox;
    ebGridAlignment: TEdit;
    Label1: TLabel;
    cboTrack: TComboBox;
    Label14: TLabel;
    GroupBox2: TGroupBox;
    cboMoving: TComboBox;
    cboNS: TComboBox;
    cboEW: TComboBox;
    Label10: TLabel;
    Label9: TLabel;
    Label8: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnGlobalClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure cbSizableTopClick(Sender: TObject);
    procedure ebMinWidthChange(Sender: TObject);
    procedure TabSet1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    GlobalAttributes: TComponent;
    TargetForm: TComponent;
    modified: boolean;
    procedure ReadAttributes(C: TAttributes);
    procedure UpdateAttributes(C: TAttributes);
    procedure LoadTrackPanels;
  end;

var
  frmPPCE: TfrmPPCE;
const
   IDH_CONTENTS = 1;
   IDH_CursorMoving = 28;
   IDH_CursorSizingEW = 30;
   IDH_CursorSizingNS = 29;
   IDH_EdgeOffset = 27;
   IDH_Glossary = 2;
   IDH_HideChildren = 22;
   IDH_HideSiblings = 23;
   IDH_MaxHeight = 12;
   IDH_MaxWidth = 10;
   IDH_MinHeight = 11;
   IDH_MinWidth = 9;
   IDH_Movable = 17;
   IDH_MovableHorz = 19;
   IDH_MovableVert = 18;
   IDH_MoveColor = 21;
   IDH_MoveParent = 20;
   IDH_PowerPanel_Component_Editor = 33;
   IDH_SizableBottom = 14;
   IDH_SizableLeft = 15;
   IDH_SizableRight = 16;
   IDH_SizableTop = 13;
   IDH_StayVisible = 25;
   IDH_TPowerPanel = 5;
   IDH_TrackPositions = 26;
   Installing = 31;
   Properties = 8;
   Registration = 3;
   Siblings = 24;
type
  TCursorEntry = record
    Value: TCursor;
    Name: PChar;
  end;

const
  Cursors: array[0..16] of TCursorEntry = (
    (Value: crDefault;      Name: 'crDefault'),
    (Value: crArrow;        Name: 'crArrow'),
    (Value: crCross;        Name: 'crCross'),
    (Value: crIBeam;        Name: 'crIBeam'),
    (Value: crSize;         Name: 'crSize'),
    (Value: crSizeNESW;     Name: 'crSizeNESW'),
    (Value: crSizeNS;       Name: 'crSizeNS'),
    (Value: crSizeNWSE;     Name: 'crSizeNWSE'),
    (Value: crSizeWE;       Name: 'crSizeWE'),
    (Value: crUpArrow;      Name: 'crUpArrow'),
    (Value: crHourGlass;    Name: 'crHourGlass'),
    (Value: crDrag;         Name: 'crDrag'),
    (Value: crNoDrop;       Name: 'crNoDrop'),
    (Value: crHSplit;       Name: 'crHSplit'),
    (Value: crVSplit;       Name: 'crVSplit'),
    (Value: crMultiDrag;    Name: 'crMultiDrag'),
    (Value: crSQLWait;      Name: 'crSQLWait'));


type
  TColorEntry = record
    Value: TColor;
    Name: PChar;
  end;

const
  Colors: array[0..36] of TColorEntry = (
    (Value: clBlack; Name: 'clBlack'),
    (Value: clMaroon; Name: 'clMaroon'),
    (Value: clGreen; Name: 'clGreen'),
    (Value: clOlive; Name: 'clOlive'),
    (Value: clNavy; Name: 'clNavy'),
    (Value: clPurple; Name: 'clPurple'),
    (Value: clTeal; Name: 'clTeal'),
    (Value: clGray; Name: 'clGray'),
    (Value: clSilver; Name: 'clSilver'),
    (Value: clRed; Name: 'clRed'),
    (Value: clLime; Name: 'clLime'),
    (Value: clYellow; Name: 'clYellow'),
    (Value: clBlue; Name: 'clBlue'),
    (Value: clFuchsia; Name: 'clFuchsia'),
    (Value: clAqua; Name: 'clAqua'),
    (Value: clWhite; Name: 'clWhite'),
    (Value: clScrollBar; Name: 'clScrollBar'),
    (Value: clBackground; Name: 'clBackground'),
    (Value: clActiveCaption; Name: 'clActiveCaption'),
    (Value: clInactiveCaption; Name: 'clInactiveCaption'),
    (Value: clMenu; Name: 'clMenu'),
    (Value: clWindow; Name: 'clWindow'),
    (Value: clWindowFrame; Name: 'clWindowFrame'),
    (Value: clMenuText; Name: 'clMenuText'),
    (Value: clWindowText; Name: 'clWindowText'),
    (Value: clCaptionText; Name: 'clCaptionText'),
    (Value: clActiveBorder; Name: 'clActiveBorder'),
    (Value: clInactiveBorder; Name: 'clInactiveBorder'),
    (Value: clAppWorkSpace; Name: 'clAppWorkSpace'),
    (Value: clHighlight; Name: 'clHighlight'),
    (Value: clHighlightText; Name: 'clHighlightText'),
    (Value: clBtnFace; Name: 'clBtnFace'),
    (Value: clBtnShadow; Name: 'clBtnShadow'),
    (Value: clGrayText; Name: 'clGrayText'),
    (Value: clBtnText; Name: 'clBtnText'),
    (Value: clInactiveCaptionText; Name: 'clInactiveCaptionText'),
    (Value: clBtnHighlight; Name: 'clBtnHighlight'));

implementation

{$R *.DFM}
uses ppace;
procedure TfrmPPCE.LoadTrackPanels;
var i: integer;
begin
  cboTrack.items.clear;
  for i := 0 to targetform.componentcount-1 do
       if targetform.components[i] is tpanel then
          cbotrack.items.add(tcustompanel(targetform.components[i]).name);
end;
procedure TfrmPPCE.ReadAttributes(C: TAttributes);
begin
 with c do begin
 cboColors.itemindex := cboColors.items.indexof(colortostring(MoveColor));
 cboMoving.itemindex := cboMoving.items.indexof(Cursortostring(CursorMoving));
 cboNS.itemindex := cboNS.items.indexof(Cursortostring(CursorSizingNs));
 cboEW.itemindex := cboEW.items.indexof(Cursortostring(CursorSizingEW));
 cbtrackpositions.checked := trackpositions;
 cbSizabletop.checked := sizabletop;
 cbSizableBottom.checked := sizablebottom;
 cbSizableleft.checked := sizableleft;
 cbSizableRight.checked := sizableRight;
 cbHideChildren.checked := HideChildren;
 cbHideSiblings.checked := HideSiblings;
 cbAllowBeeps.checked := AllowBeeps;
 cbAllowRollup.checked := AllowRollup;
 cbStayVisible.checked := StayVisible;
 cbMovable.checked := Movable;
 cbMovableVert.checked := MovableVert;
 cbMovableHorz.checked := MovableHorz;
 cbMoveParent.checked := MoveParent;
 cbIniLog.checked := IniLog;
 ebMinWidth.text := inttostr(minwidth);
 ebMinHeight.text := inttostr(minHeight);
 ebMaxWidth.text := inttostr(Maxwidth);
 ebMaxHeight.text := inttostr(MaxHeight);
 ebEdgeOffset.text := inttostr(edgeoffset);
 ebIniFileName.text := IniFileName;
 ebIniSection.text := IniSectionName;
 ebIniPrefix.text := IniPrefix;
 ebGridAlignment.text := inttostr(GridAlignment);
 if not ( TrackPanel = nil ) then
  cboTrack.itemindex  := cboTrack.items.indexof(trackpanel.name);

 modified := false;
end;

end;
procedure TfrmPPCE.UpdateAttributes(C: TAttributes);
begin
 with c  do begin
  trackPositions := cbtrackpositions.checked;
  sizabletop := cbSizableTop.checked;
  sizableBottom := cbSizableBottom.checked;
  sizableleft := cbSizableLeft.checked;
  sizableRight := cbSizableRight.checked;
  HideSiblings := cbHideSiblings.checked;
  HideChildren := cbHideChildren.checked;
  AllowBeeps := cbAllowBeeps.checked;
  AllowRollup := cbAllowRollup.checked;
  StayVisible := cbStayVisible.checked;
  Movable := cbMovable.checked;
  MovableVert := cbMovableVert.checked;
  MovableHorz := cbMovableHorz.checked;
  MoveParent := cbMoveParent.checked;
  IniLog := cbIniLog.checked;
  MinWidth := strtoint(ebMinwidth.text);
  MinHeight := strtoint(ebMinHeight.text);
  MaxWidth := strtoint(ebMaxwidth.text);
  MaxHeight := strtoint(ebMaxHeight.text);
  EdgeOffset := strtoint(ebEdgeOffset.text);
  IniFileName := ebIniFileName.text;
  IniSectionName := ebIniSection.text;
  IniPrefix := ebIniPrefix.text;
  GridAlignment := strtoint(ebGridAlignment.text);
  cursorMoving := stringtocursor(cboMoving.items[cbomoving.itemindex]);
  cursorSizingNS := stringtocursor(cboNS.items[cboNS.itemindex]);
  cursorSizingEW := stringtocursor(cboEW.items[cboEW.itemindex]);
  MoveColor := stringtocolor(cboColors.items[cbocolors.itemindex]);
  if ( cbotrack.itemindex <> -1 ) then
      TrackPanel := tpanel(targetform.findcomponent(cbotrack.items[cbotrack.itemindex]))
  else TrackPanel := nil;
 end;
end;

procedure TfrmPPCE.FormCreate(Sender: TObject);
var
i, x: longint;
begin
tabset1.tabs := notebook1.pages;
modified := false;
for i := low(colors) to high(colors) do
 cbocolors.items.add(colortostring(colors[i].value));
for i := low(cursors) to high(cursors) do
 cbomoving.items.add(cursortostring(cursors[i].value));
cboNs.items.addstrings(cbomoving.items);
cboEW.items.addstrings(cbomoving.items);
end;

procedure TfrmPPCE.Button1Click(Sender: TObject);
begin
if openini.execute then
  ebIniFileName.text := openini.filename;

end;

procedure TfrmPPCE.btnCopyClick(Sender: TObject);
begin
 ReadAttributes((GlobalAttributes as TGlobalAttributes).attributes);
end;

procedure TfrmPPCE.btnGlobalClick(Sender: TObject);
 var
 myform: tfrmppace;
 i: integer;
begin
 if modified then
  if (MessageDlg(globalattributes.name + ' has changed would you like to save it?', mtConfirmation, [mbYes, mbNo], 0) = mryes)
  then begin
     UpdateAttributes((globalattributes as TGlobalAttributes).attributes);
     modified := false;
  end;
 myform := tfrmppace.create(application);

 with myform do begin

 whatform := TargetForm; {save form}

 for i := 0 to TargetForm.componentcount-1 do
   if TargetForm.components[i] is TPowerPanel then
      lbPanels.items.add(TargetForm.components[i].name);
 showmodal;

 end;
 myform.free;
end;

procedure TfrmPPCE.BitBtn1Click(Sender: TObject);
begin
  winhelp(handle,'PowerPan.hlp',HELP_CONTEXT, 37);

end;

procedure TfrmPPCE.cbSizableTopClick(Sender: TObject);
begin
modified := true;
end;

procedure TfrmPPCE.ebMinWidthChange(Sender: TObject);
begin
modified := true;
end;

procedure TfrmPPCE.TabSet1Click(Sender: TObject);
begin
notebook1.pageindex := tabset1.tabindex;
end;

end.
