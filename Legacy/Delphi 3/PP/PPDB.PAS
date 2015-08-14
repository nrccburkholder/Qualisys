unit Ppdb;

interface
uses
  SysUtils, Windows,
  Messages, Classes, Graphics, Controls,
  buttons,  Forms, Dialogs, menus, filectrl,
  extctrls,grids, db, dbgrids, dbctrls,
  stdctrls, PPMain, PPExt;

type

TPPDBGrid = class(TPPCap)
  public
    constructor create(aowner: TComponent); override;
  end;

TPPDBGridAccess = class(TPPCap)
  private
  public
    constructor create(aowner: TComponent); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  end;

TPPDBNav = class(TPowerPanel)
  public
    constructor create(aowner: TComponent); override;
  end;

TPPDBNavSplit = class(TPowerPanel)
  public
    constructor create(aowner: TComponent); override;
  end;

TPPDBNavLeft = class(TPowerPanel)
  public
    constructor create(aowner: TComponent); override;
  end;

TPPDBNavRight = class(TPowerPanel)
  public
    constructor create(aowner: TComponent); override;
  end;

Function FindDataSource(aowner: tcomponent): tdatasource;

implementation

function FindDataSource(aowner: tcomponent): tdatasource;
var
i: integer;
found: integer;
begin
result := nil;
found := 0;
for i := 0 to aowner.componentcount-1 do
  if aowner.components[i] is tdatasource then begin
    inc(found);
    result := tdatasource(aowner.components[i]);
  end;
if found > 1 then result := nil;

end;
 constructor TPPDBGrid.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;

   with TDBGrid.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     align := alclient;
     datasource := finddatasource(aowner);
     name := GetNextName(classname);
   end;
 end;


  constructor TPPDBGridAccess.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   width := 300;
   height := 175;
   If (csloading in Aowner.componentState) then exit;

   with TPPDbNavSplit.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     align := albottom;
     height := 30;
     name := GetNextName(classname);
   end;
   with TDBGrid.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     align := alclient;
     datasource := finddatasource(aowner);
     name := GetNextName(classname);
   end;

 end;
 procedure TPPDbGridAccess.Notification(AComponent: TComponent; Operation: TOperation);
 begin
  Inherited Notification(AComponent, Operation);
 end;

  constructor TPPDBNav.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   If (csloading in Aowner.componentState) then exit;
   with TDBNavigator.create(aowner) do begin
     parent := self;
     BorderStyle := bssingle;
     align := alclient;
     datasource := finddatasource(aowner);
     name := GetNextName(classname);
   end;
 end;
  constructor TPPDBNavSplit.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   height := 34;
   width := 180;
   borderwidth := 2;
   If (csloading in Aowner.componentState) then exit;
   with TPPDBNavLeft.create(aowner) do begin
     parent := self;
     width := 60;
     name := GetNextName(classname);
   end;
   with TPPDBNavRight.create(aowner) do begin
     parent := self;
     width := 60;
     name := GetNextName(classname);
   end;
   with TPPStatus.create(aowner) do begin
     parent := self;
     bevelouter := bvnone;
     align := alclient;
     name := GetNextName(classname);
   end;

 end;
 constructor TPPDBNavLeft.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   align := alleft;
   If (csloading in Aowner.componentState) then exit;
   with TDBNavigator.create(aowner) do begin
     parent := self;
     BorderStyle := bsnone;
     BorderWidth := 2;
     BevelOuter :=  bvnone;
     align := alclient;
     datasource := finddatasource(aowner);
     visibleButtons := [nbfirst, nbprior];
     name := GetNextName(classname);
   end;
 end;
 constructor TPPDBNavRight.Create(AOwner: TComponent);
  begin
   inherited Create(AOwner);
   Attributes.HideChildren := true;
   align := alright;
   If (csloading in Aowner.componentState) then exit;
   with TDBNavigator.create(aowner) do begin
     parent := self;
     BorderStyle := bsnone;
     BorderWidth := 2;
     BevelOuter :=  bvnone;
     align := alclient;
     datasource := finddatasource(aowner);
     visibleButtons := [nbNext, nblast];
     name := GetNextName(classname);
   end;
 end;


end.
