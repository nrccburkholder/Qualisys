unit Wwprpedt;
{
//
// Components : Property Editors
//
// Copyright (c) 1995, 1996, 1997 by Woll2Woll Software
//
}
interface

Uses dialogs, dsgnintf, wwDBLook, classes, db, wwTable, wwDBGrid,wwdbigrd,
     wwCommon, wwidlg, dbtables, sysutils, wwselfld, wwstr, wwQuery, wwQBE,

{$ifdef win32}
     comctrls, wwrich, wwriched,
{$else}
     LibMain,
{$endif}
     wwlocate, wwfltfld, wwfltdlg, wwrcdvw, buttons;


Type

  TwwTableProperty = class(TComponentProperty)
     procedure GetValues(Proc : TGetStrProc); override;
  end;

  TwwIndexFieldProperty = class(TStringProperty)
     function GetAttributes: TPropertyAttributes; override;
     procedure GetValues(Proc : TGetStrProc); override;
  end;

  TwwSearchFieldProperty = class(TStringProperty)
     function GetAttributes: TPropertyAttributes; override;
     procedure GetValues(Proc : TGetStrProc); override;
  end;

  TwwDBLookupDisplayProperty = class(TPropertyEditor)
     procedure Edit; override;
     function GetAttributes: TPropertyAttributes; override;
     function GetValue: string; override;
  end;

  TwwTableDisplayProperty = class(TPropertyEditor)
     procedure Edit; override;
     function GetAttributes: TPropertyAttributes; override;
     function GetValue: string; override;
  end;

  TwwDBLookupDisplayComponentEditor = class(TDefaultEditor)
     procedure Edit; override;
  end;

  TSelectedFieldsProperty = class(TPropertyEditor)
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;

  TwwDBGridComponentEditor = class(TDefaultEditor)
    procedure Edit; override;
  end;

  TwwFilterFieldsProperty = class(TPropertyEditor)
     procedure Edit; override;
     function GetAttributes: TPropertyAttributes; override;
     function GetValue: string; override;
  end;

  TwwComboItemsProperty = class(TPropertyEditor)
     procedure Edit; override;
     function GetAttributes: TPropertyAttributes; override;
     function GetValue: string; override;
  end;

  TwwPictureProperty = class(TClassProperty)
     procedure Edit; override;
     function GetAttributes: TPropertyAttributes; override;
     function GetValue: string; override;
  end;

  TwwRecordViewComponentEditor = class(TDefaultEditor)
    procedure Edit; override;
  end;

  TwwGridIndicatorProperty = class(TPropertyEditor)
     procedure Edit; override;
     function GetAttributes: TPropertyAttributes; override;
     function GetValue: string; override;
  end;

{$ifdef win32}
  TwwRichEditItemsProperty = class(TPropertyEditor)
     procedure Edit; override;
     function GetAttributes: TPropertyAttributes; override;
     function GetValue: string; override;
  end;

  TwwRichEditComponentEditor = class(TDefaultEditor)
    procedure Edit; override;
  end;
{$endif}

procedure Register;


implementation

uses wwdbcomb, wwprpcom, wwdbedit, wwprppic, wwpiced2,
     forms, wwstorep, typinfo;

{type SmallString = string[64];}

procedure GetComponentData(AComponent: TComponent;
            var ASelected: TStrings; var ADataSet: TDataSet);
begin
    if AComponent is TwwDBLookupList then begin
       ASelected:= (AComponent as TwwDBLookupList).Selected;
       ADataSet:= (AComponent as TwwDBLookupList).LookupTable;
    end
    else if AComponent is TwwDBCustomLookupCombo then begin
       ASelected:= (AComponent as TwwDBCustomLookupCombo).Selected;
       ADataSet:= (AComponent as TwwDBCustomLookupCombo).LookupTable;
    end
    else if AComponent is TwwLookupDialog then begin
       ASelected:= (AComponent as TwwLookupDialog).Selected;
       ADataSet:= (AComponent as TwwLookupDialog).LookupTable;
    end
    else if AComponent is TwwSearchDialog then begin
       ASelected:= (AComponent as TwwSearchDialog).Selected;
       ADataSet:= (AComponent as TwwSearchDialog).ShadowSearchTable;
    end
    else if AComponent is TwwRecordViewDialog then begin {5/2/97}
       ASelected:= (AComponent as TwwRecordViewDialog).Selected;
       if (AComponent as TwwRecordViewDialog).DataSource<>nil then
          ADataSet:= (AComponent as TwwRecordViewDialog).DataSource.Dataset
       else ADataSet:= nil;
    end
    else if AComponent is TwwTable then begin
       ADataSet:= AComponent as TwwTable
    end
    else if AComponent is TwwQuery then begin
       ADataSet:= AComponent as TwwQuery
    end
    else if AComponent is TwwQBE then begin
       ADataSet:= AComponent as TwwQBE
    end
    else if AComponent is TwwStoredProc then begin
       ADataSet:= AComponent as TwwStoredProc
    end
end;


{*** Property editors ***}
Function TwwGridIndicatorProperty.GetValue: string;
begin
   result:= '<TSpeedButton>'
end;

function TwwGridIndicatorProperty.GetAttributes: TPropertyAttributes;
begin
   result:= [paDialog];
end;

procedure TwwGridIndicatorProperty.Edit;
var grid: TwwDBGrid;
begin
   grid:= GetComponent(0) as TwwDBGrid;
   if grid.IndicatorButton=nil then
   begin
      grid.IndicatorButton:= TwwIButton.create(wwGetOwnerForm(grid));
      grid.IndicatorButton.parent:= grid;
      grid.IndicatorButton.name:= grid.name + 'IButton';
      grid.IndicatorButton.width:= 13;
      grid.IndicatorButton.AllowAllUp:=True;
   end;
  {$ifdef win32}
   Designer.SelectComponent(grid.IndicatorButton);
  {$else}
   Complib.GetActiveForm.SetSelection((GetComponent(0) as TwwDBGrid).IndicatorButton.Name);
  {$endif}
end;

function TwwTableDisplayProperty.GetValue: string;
begin
   result:= '<Display>';
end;

function TwwTableDisplayProperty.GetAttributes: TPropertyAttributes;
begin
   result:= [paDialog];
end;

{ Define selected fields property editor for grid }
function EditSelectedFieldsProperty(listHandle: TStrings; dataSet: TDataSet;
        designer: TFormDesigner; readFromTableComponent: Boolean;
        var useTFields: boolean; propertyType: TwwSelectedPropertyType): boolean;
var
  i: integer;
  calcString : string[3]; {Yes, No}
begin
  result:= False;

  if ReadFromTableComponent and (useTFields or (listhandle.count=0)) then begin
       ListHandle.clear;
       with dataSet do begin
          if not Active then begin
             MessageDlg('DataSet for this component must be active to edit design.', mtInformation, [mbok], 0);
             exit;
          end;

          for i:= 0 to fieldCount-1 do begin
             if (fields[i].visible) then begin
                if fields[i].calculated then calcString:= 'Yes'
                else calcString:= 'No';
                ListHandle.add(fields[i].fieldName + #9 +
                              inttostr(fields[i].displayWidth) + #9 +
                              fields[i].displayLabel + #9 + calcString);
             end
          end;
       end
   end;

   if wwSelectTableFields(dataSet, listHandle, useTFields, Designer, propertyType) then
   begin
      Designer.modified;
      wwDataModuleChanged(Dataset);
      if (dataSet is TwwTable) then
         if (TwwTable(dataset).query.count=0) then dataSet.refresh;
{               dataset.resync([]);}
      result:= True;
   end
end;


procedure TwwTableDisplayProperty.Edit;
var
   listHandle : TStrings;
   dataSet: TDataSet;
   useTFields: boolean;
begin
    GetComponentData(GetComponent(0) as TComponent, listHandle, dataSet);
    listHandle:= TStringList.create;
    if (dataSet=Nil) then begin
       MessageDlg('Missing TableName property', mtInformation, [mbok], 0);
       exit;
    end;

    useTFields:= True;
{    try}
       if (EditSelectedFieldsProperty(listHandle, DataSet, Designer, True,
          useTFields, sptDataSetType)) then begin
           wwDataSetUpdateFieldProperties(DataSet, listHandle);
       end;
{    finally}
       listHandle.free;
{    end;}
end;

function TwwDBLookupDisplayProperty.GetValue: string;
var
   listHandle : TStrings;
   dataSet: TDataSet;
begin
   GetComponentData(GetComponent(0) as TComponent, listHandle, dataSet);
{   GetComponentData(GetComponent(0), listHandle, dataSet);}
   if listHandle.count>0 then result:= listHandle[0]
   else result := '';
end;

function TwwDBLookupDisplayProperty.GetAttributes: TPropertyAttributes;
begin
   result:= [paDialog];
end;

procedure TwwDBLookupDisplayProperty.Edit;
var
   listHandle : TStrings;
   dataSet: TDataSet;
   component: TComponent;
   useTFields: boolean;
   SelectedPropertyType: TwwSelectedPropertyType;
begin
    component:= GetComponent(0) as TComponent;
    GetComponentData(GetComponent(0) as TComponent, listHandle, dataSet);
    SelectedPropertyType:= sptNone;
    if GetComponent(0) is TwwCustomLookupDialog then
    begin
       useTFields:= TwwCustomLookupDialog(GetComponent(0)).useTFields;
    end
    else if GetComponent(0) is TwwRecordViewDialog then begin
       useTFields:= False; {TwwRecordViewDialog(GetComponent(0)).useTFields;}
       SelectedPropertyType:= sptRecordViewType;
    end
    else if GetComponent(0) is TwwDBCustomLookupCombo then begin
       useTFields:= TwwDBCustomLookupCombo(GetComponent(0)).useTFields;
    end;

    if (dataSet=Nil) then begin
       if GetComponent(0) is TwwSearchDialog then begin
          MessageDlg('ShadowSearchTable is required to customize field layout of search dialog.', mtInformation, [mbok], 0);
       end
       else if Component is TwwRecordViewDialog then
          MessageDlg('DataSet required to customize RecordViewDialog Layout.', mtInformation, [mbok], 0)
       else MessageDlg('Missing LookupTable', mtInformation, [mbok], 0);
    end
    else if (EditSelectedFieldsProperty(listHandle, DataSet, Designer, True,
             useTFields, selectedPropertyType)) then
    begin
       if useTFields then wwDataSetUpdateFieldProperties(DataSet, listHandle);
       if GetComponent(0) is TwwCustomLookupDialog then
          TwwCustomLookupDialog(GetComponent(0)).useTFields:= useTFields
       else if GetComponent(0) is TwwDBCustomLookupCombo then
          TwwDBCustomLookupCombo(GetComponent(0)).useTFields:= useTFields;
{       else if GetComponent(0) is TwwRecordViewDialog then
          TwwRecordViewDialog(GetComponent(0)).useTFields:= useTFields;
}
       if Component is TwwDBCustomLookupCombo then
         (Component as TwwDBCustomLookupCombo).refreshDisplay;
    end
end;

procedure TwwDBLookupDisplayComponentEditor.Edit;
var
   listHandle : TStrings;
   dataSet: TDataSet;
   useTFields: boolean;
   SelectedPropertyType: TwwSelectedPropertyType;
begin
   GetComponentData(Component, listHandle, dataSet);
   SelectedPropertyType:= sptNone;
   if Component is TwwCustomLookupDialog then
   begin
      useTFields:= TwwCustomLookupDialog(Component).useTFields;
   end
   else if Component is TwwDBCustomLookupCombo then
   begin
      useTFields:= TwwDBCustomLookupCombo(Component).useTFields;
   end
   else if Component is TwwRecordViewDialog then {5/2/97}
   begin
      useTFields:= False; {TwwRecordViewDialog(Component).useTFields;}
      SelectedPropertyType:= sptRecordViewType;
   end;
   if (dataSet=Nil) then begin
      if Component is TwwSearchDialog then begin
         MessageDlg('ShadowSearchTable is required to customize field layout of search dialog.', mtInformation, [mbok], 0);
      end
      else if Component is TwwRecordViewDialog then
         MessageDlg('DataSet required to customize RecordViewDialog Layout.', mtInformation, [mbok], 0)
      else MessageDlg('Missing LookupTable', mtInformation, [mbok], 0);
   end
   else if (EditSelectedFieldsProperty(listHandle, DataSet, Designer, False, useTFields,
            SelectedPropertyType)) then
   begin
      if useTFields then wwDataSetUpdateFieldProperties(DataSet, listHandle);
      if Component is TwwCustomLookupDialog then
         TwwCustomLookupDialog(Component).useTFields:= useTFields
{      else if Component is TwwRecordViewDialog then
         TwwRecordViewDialog(Component).useTFields:= useTFields}
      else if Component is TwwDBCustomLookupCombo then
         TwwDBCustomLookupCombo(Component).useTFields:= useTFields;
      if Component is TwwDBCustomLookupCombo then
        (Component as TwwDBCustomLookupCombo).refreshDisplay;
   end
end;

Function TwwIndexFieldProperty.GetAttributes: TPropertyAttributes;
begin
   result:= [paValueList, paSortList];
end;

procedure TwwIndexFieldProperty.GetValues(Proc : TGetStrProc);
var
    LookupTable: TDataSet;
    curpos, i: integer;
    addedList: TStrings;
    indexFieldName: string;
begin
    if GetComponent(0) is TwwDBCustomLookupCombo then
       LookupTable:= (GetComponent(0) as TwwDBCustomLookupCombo).LookupTable
    else exit;

    if (LookupTable<>Nil) then begin
       if (LookupTable is TwwTable) and ((LookupTable as TwwTable).Query.Count=0) then begin
          addedList:= TStringList.create;

          (LookupTable as TwwTable).IndexDefs.update;
          for i:= 0 to (LookupTable as TwwTable).IndexDefs.count-1 do
          begin
             curpos:= 1;
             indexFieldName:= strGetToken((LookupTable as TwwTable).IndexDefs.Items[i].fields, ';', curpos);
             if (addedList.indexOf(indexFieldName)<0) then begin
                Proc(indexFieldname);
                addedList.add(indexFieldName);
             end
          end;

          addedList.free;
       end
       else begin
          for i:= 0 to LookupTable.FieldCount-1 do
             Proc(LookupTable.Fields[i].FieldName);
       end
    end
end;

Function TwwSearchFieldProperty.GetAttributes: TPropertyAttributes;
begin
   result:= [paValueList, paSortList];
end;

procedure TwwSearchFieldProperty.GetValues(Proc : TGetStrProc);
var
    ds: TDataSource;
    i: integer;
begin
   if GetComponent(0) is TwwLocateDialog then
      ds:= (GetComponent(0) as TwwLocateDialog).dataSource
   else if GetComponent(0) is TwwFilterDialog then
      ds:= (GetComponent(0) as TwwFilterDialog).dataSource
   else exit;

   if (ds<>Nil) and (ds.dataSet<>Nil) then begin
     with ds.DataSet do begin
        for i:= 0 to fieldCount-1 do begin
           if (fields[i].dataType = ftBlob) or (fields[i].dataType=ftGraphic) or
              (fields[i].dataType = ftVarBytes) or (fields[i].dataType=ftBytes) then
              continue;
           Proc(fields[i].FieldName);
        end
     end;
   end
end;

procedure TwwTableProperty.GetValues(Proc : TGetStrProc);
{$ifndef win32}
var
  I,J: Integer;
  ownerComponent, dmComponent, Component: TComponent;
{$endif}
begin
  {$ifdef win32}
  Designer.GetComponentNames(GetTypeData(TypeInfo(TwwTable)), Proc);
  {$else}
  ownerComponent:= ((GetComponent(0) as TComponent).Owner);
  if ownerComponent = nil then exit;

  for I := 0 to ownerComponent.ComponentCount - 1 do
  begin
    Component := ownerComponent.Components[I];
    if (Component is TwwTable) and (Component.Name <> '') then
      Proc(Component.Name);
  end;
  {$endif}
end;

    function TSelectedFieldsProperty.GetValue: string;
    begin
       result := 'wwDBGrid';
    end;

    function TSelectedFieldsProperty.GetAttributes: TPropertyAttributes;
    begin
      result:= [paDialog];
    end;

    procedure TSelectedFieldsProperty.Edit;
    var
      grid       : TwwDBGrid;
      useTFields: boolean;
    begin
       grid:= GetComponent(0) as TwwDBGrid;
       if (grid.dataSource=Nil) then begin
           MessageDlg('Grid requires a DataSource', mtInformation, [mbok], 0);
           exit;
       end;

       useTFields:= grid.useTFields;
       if (EditSelectedFieldsProperty(grid.Selected, grid.dataSource.dataset,
          Designer, True, useTFields, sptNone)) then
       begin
          grid.useTFields:= useTFields;
          grid.redrawGrid;
       end
       else if not useTFields then grid.ApplySelected;
    end;


    procedure TwwDBGridComponentEditor.edit;
    var
      grid       : TwwDBGrid;
      useTFields: boolean;
    begin
       grid:= Component as TwwDBGrid;
       if (grid.dataSource=Nil) then begin
           MessageDlg('Grid requires a DataSource', mtInformation, [mbok], 0);
           exit;
       end;
       useTFields:= grid.useTFields;
       if (EditSelectedFieldsProperty(grid.Selected, grid.dataSource.dataset,
          Designer, True, useTFields, sptNone)) then begin
          grid.useTFields:= useTFields;
          grid.redrawGrid;
       end
       else if not useTFields then grid.ApplySelected;
    end;

Function TwwComboItemsProperty.GetAttributes: TPropertyAttributes;
begin
   result:= [paDialog]
end;

procedure TwwComboItemsProperty.Edit;
begin
   if wwEditComboList(GetComponent(0) as TwwDBComboBox) then
      Designer.modified;
end;

Function TwwComboItemsProperty.GetValue: string;
begin
   result:= '<Items>';
end;

function TwwPictureProperty.GetValue: string;
begin
   with (GetComponent(0) as TwwCustomMaskEdit) do begin
      if (Picture.isDatasetMask) and (Picture.PictureMask<>'') then
         result:= '<DBPictureMask>'
      else result:= '<PictureMask>';
   end
end;

Procedure TwwPictureProperty.Edit;
var component: TwwCustomMaskEdit;
    i: integer;
begin
   component:= GetComponent(0) as TwwCustomMaskEdit;
   if wwPrpEdit_PictureMask2(component) then
   begin
      for i:= 1 to PropCount-1 do  {8/23/96 - Change all selected controls }
      begin
          with GetComponent(i) as TwwCustomMaskEdit do begin
             Picture.PictureMask:= component.Picture.PictureMask;
             Picture.AutoFill:= component.Picture.AutoFill;
             Picture.AllowInvalidExit:= component.Picture.AllowInvalidExit;
             UsePictureMask:= component.UsePictureMask;
          end
      end;

      Designer.modified;
   end
end;

function TwwPictureProperty.GetAttributes: TPropertyAttributes;
begin
   Result:= [paMultiSelect, paSubProperties, paReadOnly, paDialog];
end;

procedure Register;
begin
{
  RegisterPropertyEditor(TypeInfo(TStrings),
                         TwwDBLookupList, '', TwwDBLookupDisplayProperty);
  RegisterPropertyEditor(TypeInfo(TStrings),
                         TwwDBLookupCombo, '', TwwDBLookupDisplayProperty);
  RegisterComponentEditor(TwwDBLookupList, TwwDBLookupDisplayComponentEditor);
  RegisterComponentEditor(TwwDBLookupCombo, TwwDBLookupDisplayComponentEditor);
}
end;

Procedure TwwFilterFieldsProperty.Edit;
var
   listHandle : TStrings;
   component: TwwFilterDialog;
begin
   component:= GetComponent(0) as TwwFilterDialog;
   if (component.dataSource=Nil) then begin
      MessageDlg('Missing Datasource Property', mtInformation, [mbok], 0);
      exit;
   end;

   listHandle:= component.SelectedFields;

   if wwSelectFilterableFields(component, listHandle) then
   begin
      Designer.modified;
   end;

end;

Function TwwFilterfieldsProperty.GetAttributes: TPropertyAttributes;
begin
   result:= [paDialog];
end;

Function TwwFilterFieldsProperty.GetValue: string;
begin
   result:= '<TStringList>'
end;

procedure TwwRecordViewComponentEditor.edit;
begin
   (Component as TwwRecordViewDialog).execute;
end;

{$ifdef win32}
Procedure TwwRichEditItemsProperty.Edit;
var richedit: TwwCustomRichEdit;
    prevoptions: TwwRichEditOptions;
begin
   richedit:= GetComponent(0) as TwwCustomRichEdit;
   prevOptions:= richedit.editoroptions;
   richedit.editoroptions:= richedit.editoroptions + [reoShowLoad];
   if richedit.execute then Designer.modified;
   richedit.editoroptions:= prevOptions;
end;

function TwwRichEditItemsProperty.GetAttributes: TPropertyAttributes;
begin
   result:= [paDialog]
end;

function TwwRichEditItemsProperty.GetValue: string;
begin
   result:= '<TStringList>'
end;

procedure TwwRichEditComponentEditor.edit;
var richedit: TwwCustomRichEdit;
    prevoptions: TwwRichEditOptions;
begin
    richedit:= (Component as TwwCustomRichEdit);
    prevOptions:= richedit.editoroptions;
    richedit.editoroptions:= richedit.editoroptions + [reoShowLoad];
    if (Component as TwwCustomRichEdit).execute then
       Designer.modified;
    richedit.editoroptions:= prevOptions;
end;

{$endif}

end.
