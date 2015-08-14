unit Ppext;

interface

uses
  SysUtils, Windows,
  Messages, Classes, Graphics, Controls,
  buttons,  Forms, Dialogs, menus, filectrl,
  extctrls,outline, grids, tabnotbk, tabs,
  stdctrls, PPMain;

type
 TFilterBoxAligned = class(TFilterComboBox)
  public
  constructor create(aowner: TComponent); override;
  published
  property align;
  end;

  TDriveBoxAligned = class(TDriveComboBox)
  public
  constructor create(aowner: TComponent); override;
  published
  property align;
  end;

  TEditAligned = class(TEdit)
  public
  published
  property align;
  end;

  TPPStatus = class(TPowerPanel)
  public
    constructor create(aowner: TComponent); override;
  end;
  TPPCap = class(TPowerPanel)
  public
    constructor create(aowner: TComponent); override;
  end;
  TPPTabbedNB = class(TPPCap)
  public
    constructor create(aowner: TComponent); override;
  end;

  TPPTabSetAndNB = class(TPPCap)
  public
    constructor create(aowner: TComponent); override;
  end;

  TPPListBox = class(TPPCap)
  public
    constructor create(aowner: TComponent); override;
 end;

  TPPMemo = class(TPPCap)
  public
    constructor create(aowner: TComponent); override;
  end;

  TPPOutLine = class(TPPCap)
  public
    constructor create(aowner: TComponent); override;
  end;

  TPPStringGrid = class(TPPCap)
  public
    constructor create(aowner: TComponent); override;
  end;

  TPPDrawGrid = class(TPPCap)
  public
    constructor create(aowner: TComponent); override;
  end;

  TPPEdit = class(TPowerPanel)
  public
    constructor create(aowner: TComponent); override;
  end;
  TPPLabel = class(TPowerPanel)
  public
    constructor create(aowner: TComponent); override;
  end;
  TPPFilter = class(TPowerPanel)
  public
    constructor create(aowner: TComponent); override;
  end;

  TPPDirList = class(TPowerPanel)
  public
    constructor create(aowner: TComponent); override;
  end;

  TPPDrive = class(TPowerPanel)
  public
    constructor create(aowner: TComponent); override;
  end;

  TPPFileList = class(TPowerPanel)
  public
    constructor create(aowner: TComponent); override;
  end;

  TPPFileManager = class(TPPCap)
  public

    constructor create(aowner: TComponent); override;
  end;

implementation
const
statuscount = 3;
constructor TFilterBoxAligned.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   align := alclient;
 end;
constructor TDriveBoxAligned.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   align := alclient;
 end;
constructor TPPStatus.Create(AOwner: TComponent);
var i, next: integer;
  begin
   inherited Create(AOwner);
   height := 26;
   align := albottom;
   bevelwidth := 1;
   borderwidth := 2;
    with Attributes do begin
         hidesiblings := false;
         minheight := 22;
         maxheight := -1;
    end;
   If (csloading in Aowner.componentState) then exit;
   next := 5;
   for i := 1 to statuscount do begin
    with TPowerPanel.create(aowner) do begin
     parent := self;
     width := 20;
     height := 18;
     bevelouter := bvlowered;
     alignment := taLeftJustify;
     font.name := 'Arial';
     font.size := 8;
     left := next;
     next := next + width + 5;
     align := alleft;
     if i = statuscount then align := alright;
     caption := inttostr(i);
     name := GetNextName(classname);
     with Attributes do begin
      MinHeight := 20;
      HideSiblings := false;
      Movable := true;
      MovableVert := false;
      MoveParent := false;
      sizabletop := false;
      Sizablebottom := false;
      trackPositions := false;
      StayVisible := true;

     end; {with resize}
   end; {with tpanel}
  end; {do}

 end;

constructor TPPCap.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   If (csloading in Aowner.componentState) then exit;
   with TPowerPanel.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     height := 20;
     align := altop;
     name := GetNextName(classname);
     with Attributes do begin
      reset;
      MinHeight := 20;
      Movable := true;
      MoveParent := true;
      StayVisible := true;
      SizableBottom := true;
      Hidesiblings := true;
     end;
   end;

 end;

 constructor TPPTabbedNB.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   with TTabbedNoteBook.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     align := alclient;
     name := GetNextName(classname);
   end;
 end;
  constructor TPPTabsetAndNB.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   with TTabset.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     align := albottom;
     name := GetNextName(classname);
   end;
   with TNoteBook.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     align := alclient;
     name := GetNextName(classname);
   end;
 end;
 constructor TPPListBox.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   with TListBox.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     align := alclient;
     name := GetNextName(classname);
   end;
 end;
 
 constructor TPPMemo.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   with TMemo.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     align := alclient;
     name := GetNextName(classname);
   end;
 end;

 

  constructor TPPOutLine.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   with TOutLine.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     align := alclient;
     name := GetNextName(classname);
   end;
 end;



 constructor TPPStringGrid.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   with TStringGrid.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     align := alclient;
     name := GetNextName(classname);
   end;
 end;

 
  constructor TPPDrawGrid.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   with TDrawGrid.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     align := alclient;
     name := GetNextName(classname);
   end;
 end;

 

 constructor TPPEdit.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   with TEditaligned.create(aowner) do begin
          name := GetNextName(classname);
          parent := self;
          align := alclient;
          height := 20;
          BorderStyle := bssingle;
   end;
 end;

 constructor TPPLabel.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   with TLabel.create(aowner) do begin
          name := GetNextName(classname);
          parent := self;
          align := alclient;
          BorderStyle := bssingle;
   end;
 end;

 constructor TPPFilter.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   with TFilterboxaligned.create(aowner) do begin
          name := GetNextName(classname);
          height := 25;
          align := albottom;
          parent := self;
          BorderStyle := bssingle;
   end;
   height := 30;
 end;

 

 constructor TPPDrive.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   with TDriveboxaligned.create(aowner) do begin
          name := GetNextName(classname);
          height := 25;
          align := albottom;
          parent := self;
          BorderStyle := bssingle;
   end;
   height := 30;
 end;

 constructor TPPDirList.Create(AOwner: TComponent);
  var
  d: TPPDrive;
  x: tdirectorylistbox;
  l: TPPLabel;
  begin
   inherited Create(AOwner);
   with Attributes do begin
      reset;
      HideChildren := true;
      SizableRight := true;
   end;
   If (csloading in Aowner.componentState) then exit;

   l := TPPlabel.create(aowner);
   with l do begin
     parent := self;
     BorderStyle := bssingle;
     align := altop;
     name := GetNextName(classname);
     with l.Attributes do begin
      MinHeight := 25;
      MaxHeight := 25;
      Height := 25;
      Reset;
     end;
   end;

   d:=  TPPDrive.create(aowner);
   with d do begin
     parent := self;
     BorderStyle := bssingle;
     align := albottom;
     name := GetNextName(classname);
     with d.Attributes do begin
      MinHeight := 35;
      MaxHeight := 35;
      d.height := 35;
      Reset;
     end;
   end;

   x := TDirectoryListBox.create(aowner);
   with x do begin
     tdriveboxaligned(d.controls[0]).dirlist := x;
     parent := self;
     BorderStyle := bssingle;
     borderwidth := 2;
     align := alclient;
     name := GetNextName(classname);
   end;

 end;

 constructor TPPFileList.Create(AOwner: TComponent);
 var
 f: TPPFilter;
 x: TFileListBox;
 e: TPPEdit;
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   e := TPPEdit.create(aowner);
   with e do begin
     parent := self;
     BorderStyle := bssingle;
     align := altop;
     name := GetNextName(classname);
     with e.Attributes do begin
     MinHeight := 25;
     MaxHeight := 25;
     e.Height := 25;
     Reset;
     end;
   end;

   f:= TPPFilter.create(aowner);
   with f do begin
     parent := self;
     BorderStyle := bssingle;
     align := albottom;
     name := GetNextName(classname);
     with f.Attributes do begin
     MinHeight := 35;
     MaxHeight := 35;
     f.Height := 35;
     Reset;

     end;
   end;

   x:= TFileListBox.create(aowner);
   with x do begin
     parent := self;
     BorderStyle := bssingle;
     borderwidth := 2;
     align := alclient;
     tFilterboxaligned(f.controls[0]).filelist := x;
     name := GetNextName(classname);
   end;

 end;
 constructor TPPFileManager.Create(AOwner: TComponent);
 var
 d: TPPDirList;
 f: TPPFilelist;

  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   d := TPPDirList.create(aowner);
   with d do begin
     parent := self;
     width := self.width div 2;
     BorderStyle := bssingle;
     align := alleft;
     name := GetNextName(classname);
     with d.Attributes do begin
      hidesiblings := true;
     end;
   end;
   f := TPPFileList.create(aowner);
   with f do begin
     parent := self;
     f.Attributes.reset;
     BorderStyle := bssingle;
     align := alclient;
     name := GetNextName(classname);
   end;
   TDirectoryListbox(d.controls[2]).filelist := tFileListbox(f.controls[2]);
 end;

end.

