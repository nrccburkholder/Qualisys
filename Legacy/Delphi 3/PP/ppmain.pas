{+--------------------------------------------------------------------------+
 | Component: TPowerPanel
 | Created: 2/28/96 9:57:43 PM
 | Author: John Panagia
 | Company: Strategic Applications
 | Copyright 1996, all rights reserved.
 | Description: PowerPanel for Delphi
 | Version: 2.00
 | Modification History:
 +--------------------------------------------------------------------------+
 New for version 2.00:
   1. Fixed the problem of a panel being moved out of sight. Now PowerPanels
      can only be moved within it's parents area. Will optionally beep when
      an attempt to move a panel beyond its parent boundries.

   2. New method: Rollitup; Will Rollup or close a parent container of a PowerPanel.
      This new method will be called automatically when you right click
      on a PowerPanel that has it's align set to altop, albottom, alright or alleft.
      If you enable InILogging the state of the panel will be maintained.

   3. New method: ResetIni(inifilename: string);
      Use this method to reset the INI file setting for this panel to the design time values.
      This can be performed on multiple panels by using the globalattributes component editor.

      New method: EraseIni(inifilename: string);
      Use this method to erase the INI file setting for this panel. This can be performed
      on multiple panels by using the globalattributes component editor.

   4. New property Attributes.AllowBeeps: boolean;
      This property allows you to enable/disable the beeping functionality
      for boundry violations.

   5. New Property Attributes.AllowRollups: boolean;
      This property allows you to enable/disable the rollup functionality.


 +--------------------------------------------------------------------------+}


{if you would like to have a version of powerpanel inherit from something other
than TPanel, you must complete the following steps:

    1. Make a copy of this unit under another name.
    2. Edit the new unit and disable the ($define InheritsFromTPanel)
    3. Do a global replace on 'PowerPanel' to something unique like 'PowerMemo',
       if you were making a version for a memo component.
    4. Change class reference of 'TCustomPanel' to class you would like to inherit,
       for example, TMemo, if you were creating a PowerMemo.
    5. Set up a registration unit for the new component.
    6. Install the new component.


The above steps have been tested on a few components in the VCL, If you decide to
create components in this manner, keep in mind that PowerPanel was originally
designed to work with TPanel. This ability was added because a few users had requested
this functionality. Any components you create this way, will have to be recreated with
each new version of PowerPanel. I had no choice but to take out some features that appear
in The standard PowerPanel component, such as the component editors, the about property and
all of the container logic(hiding and showing of children and siblings).

Also one major problem with this, are mouse event conflicts, for example a listbox interputs
a mouse click as a way of selecting an item, but PowerPanel will attempt to move or
resize the component. }

unit Ppmain;

{define ppdemo}
{remove the $ from the following define if you want create a new PowerComponent}
{$define InheritsFromTPanel}

{$D-}
{$L-}

interface

uses
  {$ifdef ppdemo}pputil,{$endif}
  SysUtils, Windows,
  Messages, Classes, Graphics, Controls,
  buttons,  Forms, Dialogs, menus, filectrl,
  extctrls,
  stdctrls, toolintf, DsgnIntf, inifiles;


type
  TDirection = (DirNone, DirRight, DirLeft, DirTop, DirBottom, DirTL, DirTR, DirBL, DirBR, DirMove);
  TPanelState = (psOpen, psClosed, psLocked);
  TAttributes = class(TPersistent)
  private
  FOnGridChanged: TNotifyEvent;
  FMinWidth: integer;
  FMaxWidth: integer;
  FMinHeight: integer;
  FMaxHeight: integer;
  FSizableTop: boolean;
  FSizableBottom: boolean;
  FSizableLeft: boolean;
  FSizableRight: boolean;
  FEdgeOffset: integer;
  FMovable: boolean;
  FMovableVert: boolean;
  FMovableHorz: boolean;
  FMoveParent: boolean;
  FMoveColor: TColor;
  FHideChildren: boolean;
  FHideSiblings: boolean;
  FStayVisible: boolean;
  FTrackPositions: boolean;
  FTrackPanel: TPanel;
  FCursorMoving: TCursor;
  FCursorSizingNS: TCursor;
  FCursorSizingEW: TCursor;
  FIniLog: Boolean;
  FIniFileName: String;
  FIniSectionName: String;
  FiniPrefix: String;
  FAllowRollup: boolean;
  FParentOpen: boolean;
  FAllowBeeps: boolean;
  FGridAlignment: integer;
  protected
  procedure SetGridAlignment(value: integer);
  public
 { property ParentOpen: boolean read FParentOpen write FParentOpen;}
  property OnGridChanged: TNotifyEvent read FOnGridChanged write FOnGridChanged;
  procedure Reset;
  published
  property MinWidth: integer read FMinWidth write FMinWidth;
  property MaxWidth: integer read FMaxWidth write FMaxWidth;
  property MinHeight: integer read FMinHeight write FMinHeight;
  property MaxHeight: integer read FMaxHeight write FMaxHeight;
  property SizableTop: boolean read FSizableTop write FSizableTop;
  property SizableBottom: boolean read FSizableBottom write FSizableBottom;
  property SizableLeft: boolean read FSizableLeft write FSizableLeft;
  property SizableRight: boolean read FSizableRight write FSizableRight;
  property Movable: boolean read fmovable write fmovable;
  property MovableHorz: boolean read FMovableHorz write FMovableHorz default true ;
  property MovableVert: boolean read FMovableVert write FMovableVert default true;
  property MoveParent: boolean read fmoveparent write fmoveparent;
  property MoveColor: TColor read FMoveColor write FMoveColor;
  property HideChildren: boolean read fHideChildren write fHideChildren;
  property HideSiblings: boolean read fHideSiblings write fHideSiblings;
  property StayVisible: boolean read FStayVisible write FStayVisible;
  property TrackPositions: boolean read FTrackPositions write FTrackPositions;
  property TrackPanel: TPanel read FTrackPanel write FTrackpanel;
  property EdgeOffset: integer read FEdgeOffset write FEdgeOffset;
  property CursorMoving: TCursor read FCursorMoving write FCursorMoving;
  property CursorSizingNS: TCursor read FCursorSizingNS write FCursorSizingNS;
  property CursorSizingEW: TCursor read FCursorSizingEW write FCursorSizingEW;
  property IniLog: Boolean read fIniLog write finiLog;
  property IniFileName: string read FIniFileName write FIniFileName;
  property IniSectionName: string read FIniSectionName write FIniSectionName;
  property IniPrefix: string read FIniPrefix write FIniPrefix;

  property AllowRollup: boolean read FAllowRollup write FAllowRollup;
  property AllowBeeps: boolean read FAllowBeeps write FAllowBeeps;
  property GridAlignment: integer read FGridAlignment write SetGridAlignment;
  end;

  {$ifdef InheritsFromTPanel}
  TGlobalAttributes = class(TComponent)
  private
  fattributes: TAttributes;
  protected

  public
  constructor create(aowner: TComponent); override;
  destructor Destroy; override;
  published
  property Attributes: TAttributes read FAttributes write FAttributes;
  end;

  TAboutPowerPanel = class(TPropertyEditor)
    function GetAttributes : TPropertyAttributes; override;
    function GetValue: string; override;
    procedure edit; override;
  end;
  {$endif}
  {change TCustomPanel to something else if your customizing this unit}
  TPowerPanel = class(TCustomPanel)
  private
  {$ifdef InheritsFromTPanel}
  FAbout: TAboutPowerPanel;
  {$endif}
  FOLdCaption: string;
  FAttributes: TAttributes;
  FOldColor: TColor;
  FOpenWidth, FOpenHeight: integer;
  FOpenTop, FOpenLeft: integer;

  FPanelState: TPanelState;

  FOnMouseDown: TMouseEvent;
  FOnMouseUp:   TMouseEvent;
  FOnMouseMove: TMouseMoveEvent;

  Origx,
  origy,
  pleft,
  pwidth,
  ptop,
  pheight,
  downx,
  downy: integer;
  fleft,
  ftop,
  fright,
  fbottom: boolean;
  xx,
  yy: integer;

  Direction: TDirection;
  ChildControls: array[0..99] of boolean;
  SiblingControls: array[0..99] of boolean;
  {$ifdef InheritsFromTPanel}
  procedure WMEraseBkgnd(var Msg: TWmEraseBkgnd); message WM_ERASEBKGND;
  {$endif}
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MoveUp(x, y: integer); virtual;
    procedure MoveDown(x, y: integer); virtual;
    procedure MoveLeft(x, y: integer); virtual;
    procedure MoveRight(x, y: integer); virtual;
    procedure MoveMove(x, y: integer); virtual;
    procedure SetDirection; virtual;
    procedure SetCursor; virtual;
    procedure TrackPosition; virtual;
    procedure GetChildControls; virtual;
    procedure GetSiblingControls; virtual;
    procedure HideControls; virtual;
    procedure ShowControls; virtual;
    procedure TestBounds(cc: tcontrol; dr: tdirection; cl, ct, cw, ch: integer); virtual;
    function GetNextName(const Value: String):string;
    function AdjustToGrid(x: integer): integer; virtual;

  public

    constructor create(aowner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    {$ifdef InheritsFromTPanel}
    procedure RollItUp; virtual;
    {$endif}
    procedure ResetIni(xIniFilename: string); virtual;
    procedure EraseIni(xIniFilename: string); virtual;
    procedure SaveParentsBounds; virtual;
    procedure UpdateGridAlignment(sender: tobject); virtual;
    {$ifdef InheritsFromTPanel}
    property Canvas;
    {$endif}

  published


    {$ifdef InheritsFromTPanel}
    property About: TAboutPowerPanel read fabout;
    property Align;
    property Alignment;
    property BevelInner nodefault;
    property BevelOuter nodefault;
    property BevelWidth nodefault;
    property BorderWidth nodefault;
    property BorderStyle nodefault;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Caption;
    property Color;
    property Ctl3D;
    property Font;
    property Locked;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnResize;
    {$endif}
    property OnMouseDown read FOnMouseDown write FOnMouseDown;
    property OnMouseUp read FOnMouseUp write FOnMouseUp;
    property OnMouseMove read FOnMouseMove write FOnMouseMove;
    property Attributes: TAttributes read FAttributes write FAttributes;
  end;
  {$ifdef InheritsFromTPanel}
  TPowerPanelEditor = class(TComponentEditor)
    procedure edit; override;

  end;
  TGlobalAttributesEditor = class(TPowerPanelEditor)
    procedure edit; override;

  end;
  {$endif}

implementation


uses {$ifdef InheritsFromTPanel} ppce, ppace, {$endif}ppabout;

{$ifdef InheritsFromTPanel}
function TAboutPowerPanel.GetAttributes: TPropertyAttributes;
begin
  result := [paDialog];
end;
function TAboutPowerPanel.getValue: string;
begin
 result := format('(%s)',[getproptype^.name]);
end;
procedure TAboutPowerPanel.edit;
var
abt: TPowerPanelAboutBox;

begin
  abt := TPowerPanelAboutBox.create( Application );
  abt.showmodal;
  abt.free;
end;
{$endif}
procedure TAttributes.SetGridAlignment(value: integer);
begin
  if fgridalignment = value then exit;
  fgridalignment := value;
  if assigned(FOnGridChanged) then
          FOnGridChanged(self);

end;
procedure  TAttributes.Reset;
begin
    SizableLeft := false;
    SizableRight := false;
    SizableTop := false;
    SizableBottom := false;
    HideChildren := false;
    HideSiblings := false;
    movable := false;

end;
{$ifdef InheritsFromTPanel}
constructor TGlobalAttributes.Create(AOwner: TComponent);
var
i: integer;

  begin

   inherited Create(AOwner);
   FAttributes := TAttributes.create;
   for i := 0 to aowner.componentcount-1 do begin
      if i > (aowner.componentcount-1) then exit;
      if aowner.components[i]  is TGlobalAttributes then
        if aowner.components[i] <> self then begin
          Raise Exception.Create ('You can only have one GlobalAttributes' + #13 +
                                  'component on each form.');
        end;
   end;


   with fAttributes do begin

    MaxHeight := -1;
    MaxWidth := -1;
    MinHeight := 30;
    MinWidth := 30;
    FEdgeOffset := 10;

    Movable := true;
    MovableHorz := true;
    MovableVert := true;
    MoveParent := false;
    MoveColor := clactiveCaption;
    FHideChildren := true;
    FHideSiblings := false;
    FStayVisible := false;
    FTrackPositions := true;
    FIniLog := true;

    FCursorMoving := crArrow;
    FCursorSizingNS := crSizeNS;
    FCursorSizingEW := crSizeWE;

    SizableBottom := true;
    SizableTop := true;
    SizableLeft := true;
    SizableRight := true;
   end;



 end;

destructor TGlobalAttributes.destroy;

begin
  FAttributes.free;
  inherited destroy;
end;
{$endif}
constructor TPowerPanel.Create(AOwner: TComponent);
 var i: integer;
  begin

   inherited Create(AOwner);
   {$ifdef InheritsFromTPanel}
   caption := ' ';
   borderwidth := 1;
   bevelwidth := 1;
   bevelouter := bvraised;
   {$endif}

   Height := 120;
   Width := 100;
   origx := -200;
   origy := -200;
   Cursor := crdefault;

   FAttributes := TAttributes.create;
   with fAttributes do begin
    FParentOpen := true;
    FPanelState := psOpen;
    MaxHeight := -1;
    MaxWidth := -1;
    MinHeight := 30;
    MinWidth := 30;
    FEdgeOffset := 10;

    Movable := true;
    MovableHorz := true;
    MovableVert := true;
    MoveParent := false;
    MoveColor := clactiveCaption;
    FHideChildren := true;
    FHideSiblings := false;
    FStayVisible := false;
    FTrackPositions := true;

    FCursorMoving := crArrow;
    FCursorSizingNS := crSizeNS;
    FCursorSizingEW := crSizeWE;

    SizableBottom := true;
    SizableTop := true;
    SizableLeft := true;
    SizableRight := true;
    GridAlignment := 1;
    OnGridChanged := UpdateGridAlignment;
   end;



 end;
procedure TPowerPanel.UpdateGridAlignment(sender: tobject);
{gets called due to an Attributes ongridchanged event} 
begin
  setbounds(adjusttogrid(left), adjusttogrid(top), adjusttogrid(width), adjusttogrid(height));
end;

procedure TPowerPanel.ResetINI(xinifilename: string);
var
PPIni: TIniFile;
work, xIniSectionName, xIniPrefix: string;
i, x: integer;
nums: array [1..4] of integer;

begin
with attributes do begin

   if not Attributes.INILog then exit;

   xinisectionname := finisectionname;
   xiniprefix := finiprefix;

   if xiniSectionName = '' then
     xiniSectionName := name;

   if (FiniPrefix = '') and (FiniSectionName <> name) then
     FiniPrefix := name;


   PPIni := TIniFile.create(xiniFileName);
   work := PPini.readstring(xiniSectionName, xIniPrefix+'Designed', 'None');

  if work = 'None' then
    begin
      PPIni.free;
      exit;
    end;

  work := work + ',';
  for i := 1 to 4 do
     begin
      x := pos(',',work);
      nums[i] := strtoint(copy(work,1,x-1));
      system.delete(work,1,x);
     end;

  if not (csDesigning in ComponentState) then
    begin
     top := nums[1];
     left := nums[2];
     Height := nums[3];
     width := nums[4];
    end;

  PPini.writeInteger(xiniSectionName, xiniPrefix+'Left', left);
  PPini.writeInteger(xiniSectionName, xiniPrefix+'Top', top);
  PPini.writeInteger(xiniSectionName, xiniPrefix+'Width', width);
  PPini.writeInteger(xiniSectionName, xiniPrefix+'Height', height);
  PPIni.free;
end; {with}
end;

procedure TPowerPanel.EraseIni(xIniFileName: string);
var
xsection: string;
ppini: tinifile;
begin
if xInifilename = '' then exit;
xsection := attributes.inisectionname;
if xsection = '' then xsection := name;
PPIni := TIniFile.create(xIniFilename);
PPini.erasesection(xsection);
PPini.free;
end;

procedure TPowerPanel.Notification(AComponent: TComponent; Operation: TOperation);
 begin
  Inherited Notification(AComponent, Operation);
  if Operation = opRemove then
    if AComponent = attributes.ftrackpanel then
      attributes.ftrackpanel := nil;
 end;

procedure TPowerPanel.Loaded;
var
PPIni: TIniFile;
Work: string;
i, x : integer;
nums: array [1..4] of integer;
function getDesignedVals: string;

  begin
   result := inttostr(top) + ',' + inttostr(left) + ',' +
             inttostr(height) + ',' + inttostr(width);
  end;

begin
  inherited Loaded;	{ always call the inherited Loaded first! }
  if csDesigning in ComponentState then exit;

  SaveParentsBounds;

  with fattributes do begin
     fparentopen := true;
  setbounds(adjusttogrid(left), adjusttogrid(top), adjusttogrid(width), adjusttogrid(height));
  if not FiniLog then exit;

  if FiniFilename = '' then
    FiniFileName :=  extractfilename(ChangeFileExt(ParamStr(0), '.INI'));

  if FiniSectionName = '' then
    FiniSectionName := name;

  if (FiniPrefix = '') and (FiniSectionName <> name) then
     FiniPrefix := name;


  PPIni := TIniFile.create(FiniFileName);
  {get panels parameters }

  ppini.writestring(FIniSectionName, FiniPrefix+'Designed',GetDesignedVals);
  Left := PPini.readInteger(FiniSectionName, FiniPrefix+'Left', left);
  top := PPini.readInteger(FiniSectionName, FiniPrefix+'Top', top);
  width := PPini.readInteger(FiniSectionName, FiniPrefix+'Width', width);
  height := PPini.readInteger(FiniSectionName, FiniPrefix+'Height', height);
  fpanelstate := tpanelstate(PPini.readinteger(FiniSectionName, FiniPrefix+'State', ord(psopen)));
  Work := PPini.readstring(FiniSectionName, FIniPrefix+'ExpandParent', 'None');
  setbounds(adjusttogrid(left), adjusttogrid(top), adjusttogrid(width), adjusttogrid(height));
  {$ifdef InheritsFromTPanel}
  if parent is tpowerpanel then
    begin
       if fpanelstate = psopen
         then
           attributes.fParentopen := true
         else
           attributes.fparentopen := false;
    end;
  {$endif}

  if Work = 'None' then begin
     PPini.free;
     exit;
  end;

  Work := Work + ',';   {ending delimiter}

  for i := 1 to 4 do
   begin
    x := pos(',',Work);
    nums[i] := strtoint(copy(Work,1,x-1));
    system.delete(Work,1,x);
   end;
  fopentop := nums[1];
  fopenleft := nums[2];
  fopenHeight := nums[3];
  fopenwidth := nums[4];
  PPIni.free;
  end;
end;


destructor TPowerPanel.destroy;
var
PPIni: TiniFile;
  function getopenvals: string;

  begin
   result := inttostr(fopentop) + ',' + inttostr(fopenleft) + ',' +
             inttostr(fopenheight) + ',' + inttostr(fopenwidth);
  end;
begin

  with fattributes do begin
  if not (csDesigning in ComponentState) and FiniLog then begin
   PPIni := TIniFile.create(FiniFileName);
  {set panels parameters }
  PPini.writeInteger(FiniSectionName, FiniPrefix+'Left', left);
  PPini.writeInteger(FiniSectionName, FiniPrefix+'Top', top);
  PPini.writeInteger(FiniSectionName, FiniPrefix+'Width', width);
  PPini.writeInteger(FiniSectionName, FiniPrefix+'Height', height);
  PPini.writeInteger(FiniSectionName, FiniPrefix+'State', ord(fpanelstate));
  ppini.writestring(FIniSectionName, FiniPrefix+'ExpandParent',GetOpenVals);
  PPIni.free;
  end;
  end;
  FAttributes.free;
  inherited destroy;
end;

procedure TPowerPanel.SaveParentsBounds;
begin
 fopenwidth := parent.width;
 fopenheight := parent.height;
 fopenleft := parent.left;
 fopentop := parent.top;
end;

function TPowerPanel.AdjustToGrid(x: integer): integer;
var
up, down, saveup: integer;

begin

result := x;

if attributes.GridAlignment < 2 then exit;
if x mod attributes.GridAlignment = 0 then exit;

up := 0;
down := 0;

while result mod attributes.GridAlignment <> 0 do
   inc(result);

saveup := result;

up := result - x;

result := x;

while result mod attributes.GridAlignment <> 0 do
   dec(result);

down := x - result;

if up < down then result := saveup;

end;

procedure TPowerPanel.TestBounds(cc: tcontrol; dr: tdirection; cl, ct, cw, ch: integer);
var
l, t, w, h: integer;
i, minh, minw: integer;
procedure soundoff;
begin
 if Attributes.AllowBeeps then
      messagebeep(MB_OK);

end;
procedure soundoff2;
begin
 if Attributes.AllowBeeps then
      messagebeep(MB_ICONASTERISK);

end;

begin
(* make sure this panel stays within its parents bounds *)

if (cc.left + xx) < 0 then begin soundoff; exit; end;
if (cc.top + yy)  < 0 then begin soundoff; exit; end;
l := 0;
t := 0;
minh:= 0;
minw := 0;
{$ifdef InheritsFromTPanel}

for i := 0 to tpowerpanel(cc).controlcount-1 do begin
  if Tpowerpanel(cc).controls[i].align in [altop, albottom] then
    minh := minh + Tpowerpanel(cc).controls[i].height;
  if Tpowerpanel(cc).controls[i].align in [alleft, alright] then
    minw := minw + Tpowerpanel(cc).controls[i].width;
end;
if minw <> 0 then inc(minw, 10);
if minh <> 0 then inc(minh, 10);

if (attributes.minheight <> -1) and (minh <> 0) then
   if attributes.minheight > minh then minh := attributes.minheight;

if (attributes.minwidth <> -1) and (minw <> 0) then
   if attributes.minwidth > minw then minw := attributes.minwidth;

minh := AdjustToGrid(minh);
minw := AdjustToGrid(minw);
{$endif}

w := cc.width;
h := cc.height;
if cl < 0 then soundoff;
if ct < 0 then soundoff;
if cl > -1 then
   begin
        l := cl;
        w := cw;
   end;

if ct > -1 then
   begin
        t := ct;
        h := ch;
   end;

if (cl+cw) > cc.parent.width then
   begin
        l := cc.left;
        w := cc.width;
       { w := cc.parent.width - cc.left;}
        SoundOff;

   end;

if (ct+ch) > cc.parent.height then
   begin
        t := cc.top;
        h := cc.height;
        {h := cc.parent.height - cc.top;}
        SoundOff;
   end;
if h < (minh) then
   begin
        SoundOff;
        exit;
   end;

if w < (minw) then
   begin
        SoundOff;
        exit;
   end;
case dr of
  DirRight:   w := AdjustToGrid(w);
  DirBottom:  h := AdjustToGrid(h);
  DirLeft:
    begin
     if not (align = alright) then
          l := AdjustToGrid(l);
    end;
  DirTop:
    begin
       if not (align = albottom) then
          t := AdjustToGrid(t);
          {h := AdjustToGrid(h);}
    end;
  Dirtr:
    begin
       t := AdjustToGrid(t);
       w := AdjustToGrid(w);
    end;
  Dirbr:
    begin
       w := AdjustToGrid(w);
       h := AdjustToGrid(h);
    end;
  Dirtl:
    begin
       t := AdjustToGrid(t);
       l := AdjustToGrid(l);
    end;
  Dirbl:
    begin
      h := AdjustToGrid(h);
      l := AdjustToGrid(l);
    end;
  DirMove:
    begin
      t := AdjustToGrid(t);
      l := AdjustToGrid(l);
    end;
  end;

cc.setbounds(l, t, w, h);
end;

procedure TPowerPanel.HideControls;
var i: integer;
begin
{$ifdef InheritsFromTPanel}
if FAttributes.HideChildren then
       begin
         GetChildControls;   {hold onto original visible values}
         for i := 0 to controlcount-1 do
           if  controls[i] is TPowerPanel then
             begin
               if not tPowerPanel(controls[i]).Attributes.StayVisible then
                  controls[i].hide;
             end
          else
             controls[i].hide;
       end;


{should we hide the siblings while resizing }
if not (direction = dirmove) then
   if FAttributes.Hidesiblings then
      begin
        GetSiblingControls;  {hold onto original visible values}
        for i := 0 to parent.controlcount-1 do
          if parent.controls[i] <> self then
             if parent.controls[i] is tPowerPanel then
                 begin
                   if not tPowerPanel(parent.controls[i]).Attributes.StayVisible then
                      parent.controls[i].hide;
                 end
             else
               parent.controls[i].hide;
      end; {if hidesiblings}
{$endif}
end; {proc}

procedure TPowerPanel.ShowControls;
var i: integer;
begin
{$ifdef InheritsFromTPanel}
   if FAttributes.HideChildren then
       for i := controlcount-1 downto 0 do
        if  controls[i] is TPowerPanel then
            begin
              if not tPowerPanel(controls[i]).Attributes.StayVisible then
                if childcontrols[i] then  {was it originally visible}
                    controls[i].show;
            end
          else
           if childcontrols[i] then  {was it originally visible}
             controls[i].show;

    {should we restore the siblings}
    if not (direction = dirmove) then
      if FAttributes.Hidesiblings then
        for i := parent.controlcount-1 downto 0 do
          if parent.controls[i] <> self then
           if parent.controls[i] is tPowerPanel then
                 begin
                   if not tPowerPanel(parent.controls[i]).Attributes.StayVisible then
                    if Siblingcontrols[i] then  {was it originally visible}
                      parent.controls[i].show;
                 end
           else
                if Siblingcontrols[i] then  {was it originally visible}
                   parent.controls[i].show;
{$endif}
end;

procedure TPowerPanel.GetChildControls;
var i: integer;
begin
{$ifdef InheritsFromTPanel}
{save original visible property of each child control}
 if controlcount > 100 then exit;  {alot of controls}
 for i := 0 to controlcount-1 do
   ChildControls[i] := controls[i].visible;
{$endif}
end;

procedure TPowerPanel.GetSiblingControls;
var i: integer;
begin
{$ifdef InheritsFromTPanel}
{save original visible property of each sibling control(parents controls)}
 if parent.controlcount > 100 then exit;  {alot of controls}
 for i := 0 to parent.controlcount-1 do
   SiblingControls[i] := parent.controls[i].visible;
{$endif}
end;

procedure TPowerPanel.TrackPosition;
var s: string;

begin
  {$ifdef InheritsFromTPanel}
  {if direction = dirmove then exit;}
  if not FAttributes.TrackPositions then exit;
  s  := 'L' + inttostr(left) + ',T' + inttostr(top) + ',W'
            + inttostr(width) + ',H' + inttostr(height);
  if attributes.FTrackPanel = nil then
        begin
          caption := s;
          exit;
        end;
  tpanel(attributes.FTrackPanel).caption := name + ': ' + s;
  {$endif}
end;
{$ifdef InheritsFromTPanel}
procedure TPowerPanel.RollItUp;
var
mysize, myleft, mytop: integer;
 function getalignedtotal(al: talign): integer;
 var i: integer;
 begin
 result := 0;
 if al in [altop, albottom] then
   begin
     for i := 0 to self.parent.controlcount-1 do
        if self.parent.controls[i].align in [altop, albottom] then
          result := result + self.parent.controls[i].height;
   end;
 if al in [alleft, alright] then
   begin
     for i := 0 to self.parent.controlcount-1 do
        if self.parent.controls[i].align in [alleft, alright] then
          result := result + self.parent.controls[i].width;
   end;
 end;

begin
  if not attributes.AllowRollup  then exit;
  if align = alnone then exit;
  if not (parent is tpowerpanel) then exit;
  if (tpowerpanel(parent).fpanelstate = pslocked) and (fpanelstate = psopen) then exit; ;
  if fpanelstate = pslocked then exit;
  if attributes.fParentOpen then
         begin
           SaveParentsBounds;
           if align in [altop, albottom] then
             begin
               mysize := getalignedtotal(align);
             end
           else
             begin
               mysize := getalignedtotal(align);
             end;

           if align in [albottom] then
            begin
             mytop := parent.top + ((parent.height-mysize)-5);
            end;

            if align in [alright] then
            begin
             myleft := parent.left + ((parent.width-mysize)-5);
            end;


           if attributes.Allowrollup then
              if align in [altop, albottom] then
                  begin
                    self.parent.height := mysize+5;
                    if align in [albottom] then
                       parent.top := mytop;
                  end
              else
                  begin
                    self.parent.width := Mysize+5;
                    if align in [alright] then
                      parent.left := myleft;
                  end;
           attributes.fparentopen := false;
           fpanelstate := psclosed;
           tpowerpanel(parent).fpanelstate := pslocked;
         end
       {reopen this panels parent}
       else
         begin

           if attributes.Allowrollup then
             if align in [altop, albottom] then
               begin
                 self.parent.height := fopenHeight;
                 if align in [albottom] then
                    self.parent.top := FOpenTop;
               end
             else
               begin
                 self.parent.width := fopenwidth;
                 if align in [alright] then
                    self.parent.left := fOpenleft;

               end;

           attributes.fparentopen := true;
           {tpowerpanel(parent).fpanelstate := psopen; }
           fpanelstate := psopen;
           tpowerpanel(parent).fpanelstate := psopen;

         end;
       exit;

end;
{$endif}
procedure TPowerPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
  begin
    xx := x;
    yy := y;
    if assigned(fonmousedown) then
       fOnMouseDown(self, Button, Shift, X, Y);
    {$ifdef InheritsFromTPanel}
    if button = mbright then
      begin
        RollItUp;
        Exit;
      end;
    {$endif}
    if (parent is TPowerPanel) and (tpowerpanel(parent).fpanelstate = pslocked) then exit;
    if fpanelstate = pslocked then exit;

    SetDirection; {establish the direction to resize}

    if direction = dirNone then exit;
    if direction = dirMove then
      begin
        Foldcolor := color;
        color := FAttributes.MoveColor;
      end;
    downx := x;
    downy := y;
    pleft := left;
    pwidth := width;
    ptop := top;
    pheight := height;
    {$ifdef InheritsFromTPanel}
    if Attributes.trackpositions then
       FOldCaption := caption;
    {$endif}

    HideControls;
    origx := left;
    origy := top;
    trackposition;

  end;

procedure TPowerPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
  begin
     xx := x;
     yy := y;
     if assigned(fonmouseup) then
       fOnMouseup(self, Button, Shift, X, Y);

     if button = mbright then exit;
     if (parent is tpowerpanel) and (tpowerpanel(parent).fpanelstate = pslocked) then exit;
     if fpanelstate = pslocked then exit;
     origx := -200;
     origy := -200;
     pleft := 0;
     pwidth := 0;
     if Direction  = DirMove then color := FOldColor;
     direction := DirNone;
     trackposition;
     {$ifdef InheritsFromTPanel}
     if Attributes.trackpositions then
       Caption := FOldcaption;
     {$endif}
     {restore if hidden}
     ShowControls;


  end;
procedure TPowerPanel.MouseMove(Shift: TShiftState; X, Y: integer);

  begin

     x := AdjustToGrid(x);
     y := AdjustToGrid(y);

     xx := x;
     yy := y;

     if assigned(fonmousemove) then
       fOnMouseMove(self, Shift, X, Y);

     {if either this panel or its parent is locked then abort}
     if parent is tpowerpanel then
         if TPowerpanel(parent).fpanelstate = pslocked
            then
               begin
                cursor := crdefault;
                exit;
               end;

     if fpanelstate = pslocked then
           begin
                  cursor := crdefault;
                  exit;
           end;


     if origx = -200 then begin {no mouse down yet}
       {modify cursor accordingly}
     if not (align = alclient) then
     begin
       with FAttributes do begin
       if Sizabletop then
             ftop :=  (y < edgeoffset);
       if SizableLeft then
             fleft := (x < edgeoffset);
       if SizableRight then
             fright := (x > width-edgeoffset);
       if SizableBottom then
             fbottom := (y > height-edgeoffset);

     end;
       if align = altop then
        begin
         ftop := false;
         fleft := false;
         fright := false;
        end;
        if align = albottom then
        begin
         fbottom := false;
         fleft := false;
         fright := false;
        end;
        if align = alleft then
        begin
         fbottom := false;
         fleft := false;
         ftop := false;
        end;
        if align = alright then
        begin
         fbottom := false;
         fright := false;
         ftop := false;
        end;

       SetCursor;  {change the cursor shape}
       end; {with}
     end;

if origx = -200 then exit;


case direction of
  DirRight:  MoveRight(x, y);
  DirBottom: MoveDown(x, y);
  DirLeft:   MoveLeft(x, y);
  DirTop:    MoveUp(x, y);
  Dirtr:
    begin
       MoveRight(x, y);
       MoveUp( x, y);
    end;
  Dirbr:
    begin
       MoveRight(x, y);
       MoveDown(x, y);
    end;
  Dirtl:
    begin
       MoveLeft(x, y);
       MoveUp(x, y);
    end;
  Dirbl:
    begin
       MoveLeft(x, y);
       MoveDown(x, y);
    end;
  DirMove:
    begin
     MoveMove(x, y);
    end;
  end;
  trackposition;
  end;

procedure TPowerPanel.MoveUp(x, y: integer);
 var h, t, z: integer;
 begin
  {offsety := downy;}
  h := ((height) - y);
  z := top+height;
  t := top+y;
  with FAttributes do begin
    if maxheight <> -1 then
       if h > maxheight then begin
         h := maxheight;
         t := z-maxheight;
       end;
    if minheight <> -1 then
       if h < minheight then begin
         exit;
         h := minheight;
         t := z-minheight;
       end;

  end;
 {setbounds(left, t, width, h); }
 testbounds(self, dirtop, left, t, width, h);
 end;
procedure TPowerPanel.MoveDown(x, y: integer);
 var h, offsety: integer;
 begin
  offsety := pheight-downy;
  h := offsety + (y+top) - top;

  with FAttributes do begin
    if maxheight <> -1 then
       if h > maxheight then h := maxheight;
    if minheight <> -1 then
       if h < minheight then h := minheight;
  end;

  {setbounds(left, top, width, h);}
  TestBounds(self, dirbottom, left, top, width, h);
 end;

procedure TPowerPanel.MoveLeft(x, y: integer);
var w,l,z: integer;
begin
 w:= width-x;
 l := left+x;
 {if l < 0 then exit;}
 z := left+width;
 with FAttributes do begin
    if maxwidth <> -1 then
       if w > maxwidth then begin
           w := maxwidth;
           l := z-maxwidth;
           end;
    if minwidth <> -1 then
       if w < minwidth then begin
          w := minwidth;
          l := z-minwidth;
          end;
  end;
 testbounds(self, dirleft, l, top, w, height);
end;

procedure TPowerPanel.MoveRight(x, y: integer);
 var w, offsetx: integer;
 begin
  offsetx := pwidth-downx;
  w := (offsetx + (x+left) - left);
  with FAttributes do begin
    if maxwidth <> -1 then
       if w > maxwidth then w := maxwidth;
    if minwidth <> -1 then
       if w < minwidth then w := minwidth;
  end;
  testbounds(self, dirright, left, top, w, height);

 end;
procedure TPowerPanel.MoveMove(x, y: integer);
var
l, t: integer;
cc: tcontrol;
begin
 if (parent.align <> alnone) and (align <> alnone) then exit;
 if (align <> alnone) and not (fAttributes.moveparent) then exit;
 cc := self;
 if FAttributes.MoveParent then begin
    cc := parent;
    {if parent is aligned then don't move it}
    if cc.align <> alnone then cc := self;
 end;
 with FAttributes do begin
 l := cc.left;
 t := cc.top;
 if  x < downx then
   if MovableHorz then
      l := cc.left - (downx-x);
 if  x > downx then
   if movableHorz then
     l := cc.left + (x-downx);
 if  y < downy then
   if movableVert then
     t := cc.top - (downy-y);
 if  y > downy then
   if movableVert Then
     t := cc.top + (y-downy);
end; {with}
{cc.setbounds(l, t, cc.width, cc.height);}
testbounds(cc, dirmove, l, t, cc.width, cc.height);
end;

procedure TPowerPanel.SetDirection;
begin
    direction := dirnone;
    if cursor = crdefault then exit;
    if FAttributes.Movable then
      if cursor = FAttributes.cursormoving then direction := DirMove;
    if ftop then direction := dirtop;
    if fleft then direction := dirleft;
    if fright then direction := dirright;
    if fbottom then direction := dirbottom;
    if ftop and fleft then direction := dirtl;
    if fbottom and fright then direction := dirbr;
    if ftop and fright then direction := dirtr;
    if fbottom and fleft then direction := dirbl;

end;

procedure TPowerPanel.SetCursor;
var xcursor: tcursor;
{xcursor is used so we dont force redisplay of an unchanged cursor}
begin
with FAttributes do begin

 if ftop then xcursor := FCursorSizingNS;
 if fleft then xcursor := FCursorSizingEW;
 if fright then xcursor := FCursorSizingEW;
 if fbottom then xcursor := FCursorSizingNS;
 if ftop and fleft then xcursor := crsizenwse;
 if fbottom and fright then xcursor := crsizenwse;
 if ftop and fright then xcursor := crsizenesw;
 if fbottom and fleft then xcursor := crsizenesw;

 if not ftop and not fbottom
     and not fright and not fleft and not FAttributes.movable
        then xcursor := crdefault;

 if not ftop and not fbottom
    and not fright and not fleft and FAttributes.movable
        then xcursor := FAttributes.CursorMoving;

 if xcursor <> cursor then cursor := xcursor;

end; {with}
end;

function tPowerPanel.GetNextName(const Value: String):string;
var
 i: integer;
 a: string[4];

begin
  Result := copy(Value,2,255);
  a := '1';
  i := 1;
  while true do
   if owner.findcomponent(Result+a)=nil then begin
    Result := Result+a;
    break;
    end
   else begin
    inc(i);
    a := inttostr(i);
    end;
end;
{$ifdef InheritsFromTPanel}
procedure TPowerPanel.WMEraseBkgnd;
begin
if origx = -200 then
        Msg.result := ord(false)
else
        Msg.result := ord(true);
end;
{$endif}
{$ifdef InheritsFromTPanel}
procedure TGlobalAttributesEditor.edit;

begin
inherited edit;
end;

procedure TPowerPanelEditor.edit;
var
Myform: tfrmppce;
i: integer;
c: tcomponent;
ta: tattributes;
begin
 c := component;
 if c is TPowerPanel then ta := TpowerPanel(c).attributes;
 if c is TGlobalAttributes then ta := TGlobalAttributes(c).attributes;

 myform := tfrmppce.create(application);
 with myform, ta do begin

 myform.caption := myform.caption + ' (' + component.owner.name + '.' +  component.name + ')';
 btncopy.visible := false;
 btnGlobal.visible := false;
   {find the TGlobalAttributes component}
   for i := 0 to component.owner.componentcount-1 do
    if component.owner.components[i] is TGlobalAttributes then begin
      btncopy.visible := true;
      GlobalAttributes := component.owner.components[i];
    end;

  TargetForm := component.owner;
  myform.loadtrackpanels;
  if c is TGlobalAttributes then btncopy.visible := false;
  if c is TGlobalAttributes then btnglobal.visible := true;

  readattributes(ta); {set forms fields with current properties}

 if showmodal = mrok then begin
  UpdateAttributes(ta);  {call form method}
   end; {if mrok}
 end;
 myform.free;
 designer.modified;
end;
 {$endif}


end.
