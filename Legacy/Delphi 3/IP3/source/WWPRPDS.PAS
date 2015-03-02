unit wwprpds;
{
//
// Components : Property Editors
//
// Copyright (c) 1995, 1996, 1997 by Woll2Woll Software
//
}

interface
Uses
     db, wwTable, sysutils, dsgnintf, classes, dbtables, wwstr, wwQuery, typinfo, wwstorep,
     wwcommon,
     {$ifdef ver100}
     wwclient,
     {$endif}
     wwQBE;
type
  TwwDataSetProperty = class(TComponentProperty)
     procedure GetValues(Proc : TGetStrProc); override;
  end;


implementation

procedure TwwDataSetProperty.GetValues(Proc : TGetStrProc);
{$ifndef win32}
var
  I: Integer;
  ownerComponent, dmComponent, Component: TComponent;
{$endif}

begin

  {$ifdef win32}
  Designer.GetComponentNames(GetTypeData(TypeInfo(TwwTable)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TwwQuery)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TwwQBE)), Proc);
  Designer.GetComponentNames(GetTypeData(TypeInfo(TwwStoredProc)), Proc);
  {$ifdef ver100}
  Designer.GetComponentNames(GetTypeData(TypeInfo(TwwClientDataSet)), Proc);
  {$endif}

  {$else}
  ownerComponent:= (GetComponent(0).Owner);
  if ownerComponent = nil then exit;

  for I := 0 to ownerComponent.ComponentCount - 1 do
  begin
    Component := ownerComponent.Components[I];
    if (Component is TDataSet) and wwDataSet(Component as TDataSet)
       and (Component.Name <> '') then
      Proc(Component.Name);
  end;
  {$endif}

end;

end.
