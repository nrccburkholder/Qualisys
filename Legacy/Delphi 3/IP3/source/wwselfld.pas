unit Wwselfld;
{
//
// Dialog to support wwDBGrid field property selection
//
// Copyright (c) 1995 by Woll2Woll Software
//
}

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, db, dsgnintf, wwTable, wwaddlk, sysutils, dialogs,
  TabNotBk, Tabs, ExtCtrls, DBTables, wwDBLook, wwcommon, wwstr,
  wwdbcomb, wwdbgrid, wwQuery, wwQBE, Wwdbdlg, wwidlg, wwprpfld,
  {$ifdef win32}
  wwriched,
  {$endif}
  wwtypes, Mask, wwdbedit, Wwdotdot;

type
   TwwSelectedPropertyType = (sptNone, sptDataSetType, sptRecordViewType);

TSelFieldsForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    GroupBox1: TGroupBox;
    DstList: TListBox;
    AddFieldsButton: TButton;
    RemoveFieldsButton: TButton;
    SelectedFieldCaption: TGroupBox;
    FieldNotebook: TNotebook;
    DisplayWidthLabel: TLabel;
    Label2: TLabel;
    DisplayWidth: TEdit;
    DisplayTitle: TEdit;
    Label3: TLabel;
    ControlType: TComboBox;
    ControlTypeNotebook: TNotebook;
    Label10: TLabel;
    Label11: TLabel;
    BitmapScalingCombo: TComboBox;
    RasterCombo: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    CheckOnValue: TEdit;
    CheckOffValue: TEdit;
    Label9: TLabel;
    DBLookupComboList: TComboBox;
    PictureMaskLabel: TLabel;
    DesignMaskButton: TButton;
    Bevel1: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    LookupFieldCaption: TLabel;
    LookupTableCaption: TLabel;
    FieldTabSet: TTabSet;
    AutoFillCheckbox: TCheckBox;
    PictureMaskEdit: TwwDBLookupComboDlg;
    wwTable1: TwwTable;
    PictureDescription: TMemo;
    Button4: TButton;
    EditLookupButton: TButton;
    Panel1: TPanel;
    UsePictureMask: TCheckBox;
    UseTFieldCheckbox: TCheckBox;
    DBRichEditComboList: TwwDBComboBox;
    Label1: TLabel;
    InsertNewLineButton: TBitBtn;
    function InDestList(Value: string): Boolean;
    procedure ExcludeItems;
    procedure DstListClick(Sender: TObject);
    procedure EditLookupButtonClick(Sender: TObject);
    procedure ClearLinkButtonClick(Sender: TObject);
    procedure SelectDest(index: integer);
    procedure FormActivate(Sender: TObject);
    procedure DisplayWidthChange(Sender: TObject);
    procedure DisplayTitleChange(Sender: TObject);
    procedure FieldTabSetClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure ControlTypeChange(Sender: TObject);
    procedure ExcludeBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SortAvailCheckboxClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure DesignMaskButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PictureMaskEditInitDialog(Dialog: TwwLookupDlg);
    procedure PictureMaskEditChange(Sender: TObject);
    procedure PictureMaskEditCloseUp(Sender: TObject;
      LookupTable: TDataSet; FillTable: TDataset; modified: Boolean);
    procedure RemoveFieldsButtonClick(Sender: TObject);
    procedure AddFieldsButtonClick(Sender: TObject);
    procedure DstListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure DstListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure DstListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure ScrollTimerOnTimer(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure UseTFieldCheckboxClick(Sender: TObject);
    procedure InsertNewLineButtonClick(Sender: TObject);

  private
    gridTable: TDataSet;
    curField: TField;
    dragFromRow: integer;
    initialized: boolean;
    SrcListItems: TStrings;
    ScrollTimer: TTimer;
    GoForwards, GoBackwards: Boolean;
    useTFields: boolean;
    GSelected: TStrings;

    procedure refreshSourceList;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure getLookupFields(curField: Tfield;
      var databasename, tableName, fieldName, index: wwSmallString;
      var indexFields: string;
      var joins: string;
      var useExtension: char;
      var foundIndex: integer);

    procedure getControlInfo(curField: Tfield;
            var controlName: wwSmallString; { formerly String }
            controlData: TStrings);

    procedure setControlInfo(curField: TField;
            controlName: String;
            controlData: TStrings);

    procedure saveControlInfo;
    procedure SavePictureMasks;
end;

function wwSelectTableFields(
   dataSet: TDataSet;
   var fields: TStrings;
   var AuseTFields: boolean;
   Designer: TFormDesigner;
   PropertyType: TwwSelectedPropertyType): boolean;

implementation

{$R *.DFM}

uses wwprppic, wwlocate;

{type SmallString = String[64];}

const LINKS_TABSETNAME = '&Links';

var callingDesigner: TFormDesigner;

destructor TSelFieldsForm.Destroy;
begin
   SrcListItems.Free;
   ScrollTimer.enabled:= False;
   ScrollTimer.Free;
   inherited Destroy;
end;

constructor TSelFieldsForm.Create(AOwner: TComponent);
begin
   initialized:= False;
   inherited Create(AOwner);
   curField:= Nil;
   SrcListItems:= TStringList.create;
   ScrollTimer:= TTimer.create(self);
   ScrollTimer.onTimer:= ScrollTimerOnTimer;
   ScrollTimer.interval:= 50;

end;

procedure TSelFieldsForm.ScrollTimerOnTimer(Sender: TObject);
begin
   if GoForwards then DstList.TopIndex:= DstList.TopIndex + 1
   else if GoBackwards then DstList.TopIndex:= DstList.TopIndex - 1;
end;

function wwSelectTableFields(
   dataSet: TDataSet;
   var fields: TStrings;
   var AUseTFields: boolean;
   Designer: TFormDesigner;
   PropertyType: TwwSelectedPropertyType): boolean;
var i: integer;
   parts : TStrings;
   thisIndex: integer;
{   curField: TField;}
   selString: string;
   component: TComponent;
   origSelected: TStrings;
   APos: integer;
   tempForm: TSelFieldsForm;
begin
   parts := TStringList.create;
   callingDesigner:= designer;
   result:= False;
   origSelected:= nil;

   tempForm:= TSelFieldsForm.create(Application);
   with tempForm do
{   with TSelFieldsForm.create(Application) do}
   try
      if not wwDataSet(dataSet) then begin
         MessageDlg('Data source must reference a TwwTable, TwwQuery, TwwQBE, or TwwStoredProc.', mtError,
                        [mbok], 0);
         exit;
      end;

      useTFields:= AUseTFields;
      GSelected:= Fields;
      OrigSelected:= TStringList.create;
      OrigSelected.assign(GSelected);

      gridTable:= dataSet;
      if not gridTable.active then begin
         MessageDlg('Cannot edit field properties.  Dataset must be active.',
                    mtError, [mbok], 0);
         exit;
      end;

      gridTable.designer.Free;  { reset dataset designer }

      { Initialize list of data-sources }
      DBLookupComboList.items.clear;
      DBRichEditComboList.items.clear;
      if (callingDesigner<>Nil) and (callingDesigner.form=nil) then
         showmessage('calling designer form is nil');

      if callingDesigner<>Nil then
      begin
         for i:= 0 to callingDesigner.Form.ComponentCount-1 do begin
            component:= callingDesigner.Form.components[i];
            if (component is TwwDBCustomEdit) or (component is TwwDBCustomLookupCombo) then
                DBLookupComboList.items.add(component.name)
            {$ifdef win32}
            else if (component is TwwCustomRichEdit) then
                DBRichEditComboList.items.add(component.name)
            {$endif}
         end
      end
      else showmessage('calling designer is nil');

      { 5/2/97 - Included controls on same form as dataset }
{      if (callingDesigner.Form<>gridtable.owner) then begin
         for i:= 0 to gridtable.owner.ComponentCount-1 do begin
            component:= gridtable.owner.components[i];
            if (component is TwwDBCustomEdit) or (component is TwwDBCustomLookupCombo) then
                DBLookupComboList.items.add('DataSetForm.' + Component.Name)
         end
      end;
}
      gridTable.disableControls;
      Screen.cursor:= crHourGlass;

      gridTable.getFieldNames(SrcListItems);

         { Fill selected fields grid }
         for i:= 0 to fields.count-1 do begin
            strBreakApart(fields[i], #9, parts);
            curField:= gridTable.FindField(parts[0]);
            if curField<>Nil then begin
               { added in case no grid is used to show fields - i.e. LookupDialog}
               if AUseTFields then begin
                  curField:= gridTable.fieldByName(parts[0]);
                  curField.displayWidth:= strtoint(parts[1]);
                  curField.displayLabel:= parts[2];
               end;

               DstList.items.add(parts[0]);

               thisIndex:= SrcListItems.indexOf(parts[0]);
               if thisIndex>=0 then SrcListItems.delete(thisIndex);
            end
            else if (wwNewLineString=parts[0]) then begin
               DstList.items.add(parts[0]);
            end
         end;

      gridTable.enableControls;
      Screen.cursor:= crDefault;

      if propertyType=sptRecordViewType then
      begin
         useTFieldCheckbox.checked:= False;
         useTFieldCheckbox.enabled:= False;
      end
      else begin
         if propertyType= sptDataSetType then
            useTFieldCheckbox.enabled:= False;
         InsertNewLineButton.visible:= False;
         AddFieldsButton.left:= DstList.left;
         AddFieldsbutton.width:= DstList.width div 2;
         RemoveFieldsbutton.width:= DstList.width div 2;
         RemoveFieldsButton.left:= DstList.Left + DstList.Width - RemoveFieldsButton.Width;
      end;

      Result := ShowModal = IDOK;

      if Result then begin
         AUseTFields:= UseTFields;

         gridTable.disableControls;

         if AUseTFields then begin
            fields.clear;
            for i:= 0 to SrcListItems.count-1 do begin
               curField:= gridTable.fieldByName(SrcListItems[i]);
               curField.visible:= False;
            end;
         end;

         for i:= 0 to DstList.items.count-1 do begin
            curField:= gridTable.findField(DstList.items[i]);
            if curField=nil then begin  {5/12/97}
               if useTFields then fields.add(DstList.items[i]);
               continue;
            end;

            if AUseTFields then begin
{               if SrcListItems.count>0 then begin {5/2/97}
                  selString:= curField.fieldName + #9 +
                       inttostr(curField.displayWidth) + #9 +
                       curField.displayLabel;
                  fields.add(selString);
{               end;}
               curField.index:= i;
               curField.visible:= True;
            end
            else begin
               if wwFindSelected(GSelected, curField.FieldName, ThisIndex) then
               begin
                  APos:= 1;
                  strGetToken(GSelected[thisIndex], #9, APos);
                  strGetToken(GSelected[ThisIndex], #9, APos);
                  curField.displaylabel:= strGetToken(GSelected[ThisIndex], #9, APos);
               end
            end
         end;
         gridTable.enableControls;

      end
      else begin
         GSelected.assign(OrigSelected);
      end

   finally
      Free;
      parts.Free;
      origSelected.Free;
   end;
end;

procedure TSelFieldsForm.SelectDest(index: integer);
var lkDatabase, lkTable, lkField, lkIndex: wwSmallString;
    lkIndexFields: string;
    lkJoins: string;
    lkFoundIndex: integer;
    lkUseExtension: char;
    controlData: TStrings;
    controlName: wwSmallString;
    i: integer;
    tempMask: string;
    tempAutoFill, tempUsePictureMask: boolean;
    apos, aindex: integer;
begin
   editLookupButton.enabled:= False;
   if DstList.items.count=0 then index:= -1;

   if (index>=0) then begin
      if (DstList.items.count>0) and (index>=DstList.items.count) then
         index:= DstList.items.count-1; {Limit to range }

      if not DstList.Selected[index] then
         DstList.Selected[index]:= True;

      if initialized then begin
         saveControlInfo;  { Save changes }
         savePictureMasks;
      end;


      curField:= gridTable.findField(DstList.items[index]);
      if curfield=nil then begin
         SelectedFieldCaption.visible:= False;
         FieldTabSet.visible:= False;
         exit;
      end
      else begin
         SelectedFieldCaption.visible:= True;
         FieldTabSet.visible:= True;
      end;

      { Initalize control information on form, first flush current contents}
      controlData:= TStringList.create;
      getControlInfo(curField, controlName, controlData);
      if controlName='Bitmap' then begin
         BitmapScalingCombo.itemIndex:= BitmapScalingCombo.Items.indexOf(ControlData[0]);
         if BitmapScalingCombo.itemIndex<0 then BitmapScalingCombo.itemIndex:= 0;
         RasterCombo.itemIndex:= RasterCombo.Items.indexOf(ControlData[1]);
         if RasterCombo.itemIndex<0 then RasterCombo.itemIndex:= 0;
         ControlTypeNotebook.Activepage:= 'Bitmap';
      end
      else if controlName='CheckBox' then begin
         CheckOnValue.Text:= ControlData[0];
         CheckOffValue.Text:= ControlData[1];
         ControlTypeNotebook.Activepage:= 'Checkbox';
      end
      else if controlName='RichEdit' then begin
         ControlTypeNotebook.Activepage:= 'RichEdit';
         with DBRichEditComboList do begin
            for i:= 0 to items.count - 1 do begin
               if uppercase(items[i]) = uppercase(ControlData[0]) then
                  DBRichEditComboList.itemIndex:= i;
            end
         end;
      end
      else  if controlName='Field' then begin
         ControlTypeNotebook.Activepage:= 'Field';
      end
      else  if isWWEditControl(controlName) then begin
         ControlTypeNotebook.Activepage:= WW_DB_LOOKUP_COMBO;

         { Search list to find which entry it is }
         with DBLookupComboList do begin
            for i:= 0 to items.count - 1 do begin
               if uppercase(items[i]) = uppercase(ControlData[0]) then
                  DBLookupComboList.itemIndex:= i;
            end
         end;
      end;
      if controlName=WW_DB_LOOKUP_COMBO then controlName:= WW_DB_EDIT;
      ControlType.itemIndex:= ControlType.items.indexOf(controlName);
      controlData.free;

      if curField.calculated and (not wwIsClass(gridtable.classType, 'TwwClientDataSet')) then
      begin
         if (FieldTabset.tabs.indexOf(LINKS_TABSETNAME)<0) then
            FieldTabSet.tabs.insert(FieldNotebook.pages.indexOf('Links'),
               LINKS_TABSETNAME);

         editLookupButton.enabled:= True;
         getLookupFields(curField,
            lkDatabase, lkTable, lkField, lkIndex, lkIndexFields, lkJoins,
            lkUseExtension, lkFoundIndex);
         if lkTable='' then lkTable:= '???';
         if lkField='' then lkField:= '???';
         LookupTableCaption.caption:= lkTable;
         LookupFieldCaption.caption:= lkField;

      end
      else begin { Adjust tab set to not show 'Links' page }
         if (FieldTabset.tabs.indexOf(LINKS_TABSETNAME)>=0) then begin
            FieldTabSet.tabs.delete(FieldTabSet.tabs.IndexOf(LINKS_TABSETNAME));
            if (FieldNotebook.PageIndex=FieldNotebook.pages.indexOf('Links')) then
               FieldNotebook.PageIndex:= 0;
         end;
      end;
      FieldTabSet.tabIndex:= FieldNotebook.pageIndex; { Synchronize tabset and notebook}

      SelectedFieldCaption.caption:= 'Currently Selected Field: ' + curField.fieldName;

      if useTFields then
      begin
         DisplayWidth.text:= inttostr(curField.displayWidth);
         DisplayTitle.text:= curField.displayLabel;
      end
      else begin
         if wwFindSelected(GSelected, curField.FieldName, aindex) then
         begin
            APos:= 1;
            strGetToken(GSelected[aindex], #9, apos);
            DisplayWidth.text:= strGetToken(GSelected[aindex], #9, apos);
{            DisplayTitle.text:= strGetToken(GSelected[aindex], #9, apos);}
            DisplayTitle.text:= curField.displayLabel;
         end
      end;

      wwPictureByField(gridTable, curField.FieldName, False, tempMask,
                                  tempAutoFill, tempUsePictureMask);
      PictureMaskEdit.text:= tempMask;
{      PictureMaskEdit.LookupValue:= tempMask;}
      AutoFillCheckbox.checked:= tempAutoFill;
      UsePictureMask.checked:= tempUsePictureMask;

      if (wwPdxPictureMask(gridTable, curField.FieldName)<>'') then
      begin
         PictureMaskEdit.enabled:= False;
         PictureMaskLabel.caption:= '&Picture Mask (From Paradox Table)';
         PictureMaskEdit.ShowButton:= False;
         DesignMaskButton.enabled:= False;
      end
      else begin
         PictureMaskEdit.enabled:= True;
         PictureMaskLabel.caption:= '&Picture Mask';
         PictureMaskEdit.ShowButton:= True;
         DesignMaskButton.enabled:= True;
      end;
   end
   else begin
      curField:= Nil;
      DisplayWidth.text:= '';
      DisplayTitle.text:= '';
   end;

end;

procedure TSelFieldsForm.DstListClick(Sender: TObject);
begin
   SelectDest(DstList.itemIndex)
end;

function TSelFieldsForm.InDestList(Value: string): Boolean;
begin
  Result := False;
  if DstList.Items.IndexOf(Value) > -1 then
    Result := True;
end;


procedure TSelFieldsForm.ExcludeItems;
var
  I, SelIndex: Integer;
begin
  with DstList do
  begin
    I := 0;
    while SelCount > 0 do
    begin
      if Selected[I] then
      begin
        SrcListItems.add(Items[i]);
        if not useTFields then begin
          if wwFindSelected(GSelected, Items[i], selindex) then
             GSelected.delete(selIndex);
        end;

        Items.Delete(I);
      end
      else
        Inc(I);
    end;
    if Items.Count = 0 then begin
      DisplayWidth.Text:= '';
      DisplayTitle.Text:= '';
    end
    else begin
      DstList.ItemIndex:= 0;
      SelectDest(i);  { Select close to last entry }
    end
  end;

end;

procedure TSelFieldsForm.getControlInfo(curField: Tfield;
            var controlName: wwSmallString;
            controlData: TStrings);
var parts: TStrings;
   i,j: integer;
begin
   parts:= TStringList.create;
   controlData.clear;
   controlName:= 'Field';

   with wwGetControlType(gridTable) do begin
      for i:= 0 to count-1 do begin
         strBreakApart(strings[i], ';', parts);
         if parts[0]=curField.fieldName then begin
            controlName:= parts[1];
            for j:= 2 to parts.count-1 do controlData.add(parts[j]);
            for j:= parts.count to 10 do controlData.add(''); { pad to avoid out-of-bounds }
            break;
         end
      end;

      parts.free;
   end

end;

procedure TSelFieldsForm.setControlInfo(curField: TField;
            controlName: String;
            controlData: TStrings);
var parts: TStrings;
   i,j: integer;
   found: boolean;
   line: string;
begin
   parts:= TStringList.create;
   found:= false;

   with wwGetControlType(gridTable) do begin
      for i:= 0 to count-1 do begin
         strBreakApart(strings[i], ';', parts);
         if parts[0]=curField.fieldName then begin
            if controlType.text='Field' then begin
               wwGetControlType(gridTable).delete(i);
               found:= True;
               break;
            end
            else begin
               line:= parts[0] + ';' + controlType.text;
               for j:= 0 to controlData.count-1 do line:= line + ';' + controlData[j];
               strings[i]:= line;
               found:= True;
               break;
            end
         end
      end;

      if (not found) and (controlType.text<>'Field') then begin
         line:= curfield.fieldname + ';' + controlType.text;
         for j:= 0 to controlData.count-1 do line:= line + ';' + controlData[j];
         wwGetControlType(gridTable).add(line);
      end;

      parts.free;
   end

end;


procedure TSelFieldsform.getLookupFields(curField: Tfield;
   var databasename, tableName, fieldName, index: wwSmallString;
   var indexFields: string;
   var joins: string;
   var useExtension: char;
   var foundIndex: integer);
var found: boolean;
    i,j: integer;
    parts: TStrings;
begin
      parts:= TStringList.create;

      found:= false;
      with wwGetLookupFields(gridTable) do begin
         for i:= 0 to count-1 do begin
            strBreakApart(strings[i], ';', parts);
            if parts[0]=curField.fieldName then begin
               if parts.count<5 then continue;

               found:=True;
               foundIndex:= i;
               databaseName:= parts[1];
               tableName:= parts[2];
               fieldName:= parts[3];
               index:= parts[4];

               useExtension:= 'Y';
               if (parts.count>5) then
               begin
                  if parts[parts.count-1]='N' then useExtension:= 'N';
               end;

               if parts.count>5 then begin
                  indexFields:= parts[5];
                  for j:= 6 to parts.count-2 do indexFields:= indexFields + ';' + parts[j];
               end;

               while (i>=wwGetLookupLinks(gridTable).count) do
                  wwGetLookupLinks(gridTable).add('');
               joins:= wwGetLookupLinks(gridTable).Strings[i];
               break;
            end
         end
      end;

      if not found then begin
         databaseName:= wwGetDatabaseName(gridTable);
         tableName:= '';
         fieldName:= '';
         index:= '';
         indexFields:= '';
         joins:= '';
         useExtension:= 'Y';
         foundIndex:= -1;
      end;
      parts.free;

end;

procedure TSelFieldsForm.EditLookupButtonClick(Sender: TObject);
var databaseName, tableName, fieldName, index: wwSmallString;
    useExtension: char;
    indexFields: string;
    joins: string;
    curField: TField;
{    found: boolean;}
    foundIndex: integer;
begin
   if (DstList.items.count=0) then begin
      wwDebug('You must create a field with the Fields Editor before defining its links.');
      exit;
   end;

   if (DstList.itemIndex<>-1) then begin

      curField:= gridTable.fieldByName(DstList.items[DstList.itemIndex]);
      if curField.calculated then begin

         { Search gridTable for curField }
         getLookupFields(curField, databasename, tablename, fieldName,
               index, indexFields, joins, useExtension, foundIndex);

         if wwAddLookupfield(databasename, tableName, fieldname, index, indexFields,
                joins, useExtension, gridTable) then
         begin
            with wwGetLookupFields(gridTable) do begin
               if (foundIndex<0) then
               begin
                  foundIndex:= count;
                  wwGetLookupFields(gridTable).add('Dummy');
                  wwGetLookupLinks(gridTable).add('Dummy');
               end;
               strings[foundIndex]:= curField.fieldName + ';' +
                                 databasename + ';' + tableName + ';' +
                                 fieldName + ';;' + indexFields + ';' + useExtension;
               wwGetLookupLinks(gridTable).strings[foundIndex]:= joins;
               if gridTable is TwwTable then
                  TwwTable(gridTable).FreeLookupTables
               else if gridTable is TwwQuery then
                  TwwQuery(gridTable).FreeLookupTables;

               { Update FieldInfo caption }
               LookupTableCaption.caption:= tablename;
               LookupFieldCaption.caption:= fieldname;

            end;
         end
      end

   end
end;

procedure TSelFieldsForm.ClearLinkButtonClick(Sender: TObject);
var foundIndex: integer;
    curField: TField;
    databaseName, tableName, fieldName, index: wwSmallString;
    useExtension: char;
    indexFields: string;
    joins: string;
begin
   if (DstList.itemIndex<>-1) then begin
      curField:= gridTable.fieldByName(DstList.items[DstList.itemIndex]);
      if curField.calculated then begin
         { Search gridTable for curField }
         getLookupFields(curField, databasename, tablename, fieldName,
               index, indexFields, joins, useExtension, foundIndex);

         LookupTableCaption.caption:= '???';
         LookupFieldCaption.caption:= '???';

         if foundIndex>=0 then
         begin
            wwGetLookupFields(gridTable).delete(foundIndex);
            wwGetLookupLinks(gridTable).delete(foundIndex);
         end;

      end
   end
end;

procedure TSelFieldsForm.FormActivate(Sender: TObject);
begin
   if initialized then exit;

   if DstList.items.count>0 then begin
      if DstList.itemIndex<0 then SelectDest(0)
      else SelectDest(DstList.itemIndex);
      DstList.setFocus;
   end
   else begin
      DisplayWidth.text:= '';
      DisplayTitle.text:= '';
   end;

   FieldNotebook.Activepage:= 'Display';
   FieldTabSet.tabIndex:= FieldNotebook.pageIndex; { Synchronize tabset and notebook}
   initialized:= True;

end;

procedure TSelFieldsForm.DisplayWidthChange(Sender: TObject);
var apos, index: integer;
begin
   if curField=Nil then exit;

   if UseTFields then
   begin
      if DisplayWidth.text<>'' then
         curField.DisplayWidth:= strtoint(DisplayWidth.Text)
   end
   else begin
      if wwFindSelected(GSelected, curField.FieldName, index) then
      begin
         APos:=1;
         strGetToken(GSelected[index], #9, apos);
         strGetToken(GSelected[index], #9, apos);
         GSelected[index]:= curField.FieldName + #9 + DisplayWidth.text + #9 +
                           strGetToken(GSelected[index], #9, apos);
      end
   end
end;

procedure TSelFieldsForm.DisplayTitleChange(Sender: TObject);
var apos, index: integer;
begin
   if curField=Nil then exit;

   if UseTFields then
      curField.DisplayLabel:= DisplayTitle.text
   else begin
      if wwFindSelected(GSelected, curField.FieldName, index) then
      begin
         APos:=1;
         strGetToken(GSelected[index], #9, apos);
         GSelected[index]:= curField.FieldName + #9 +
                           strGetToken(GSelected[index], #9, apos) + #9 +
                           DisplayTitle.text;
      end
   end
end;

procedure TSelFieldsForm.FieldTabSetClick(Sender: TObject);
begin
   FieldNotebook.pageIndex:= FieldTabSet.Tabindex;
end;

procedure TSelFieldsForm.savePictureMasks;
begin
   if curField=Nil then exit;
   wwSetPictureMask(GridTable, curField.FieldName,
      PictureMaskEdit.text, AutoFillCheckbox.checked, 
      UsePictureMask.checked, True, True, True);
   wwDataModuleChanged(GridTable);
end;

procedure TSelFieldsForm.saveControlInfo;
var
   controlData : TStrings;
begin
   if curField=Nil then exit;

   controlData:= TStringList.create;

   if controlType.text = 'RichEdit' then begin
      controlData.add(DBRichEditComboList.Text);
      setControlInfo(curField, controlType.text, controlData);
   end
   else if controlType.text = 'CheckBox' then begin
      controlData.add(CheckOnValue.text);
      controlData.add(CheckOffValue.text);
      setControlInfo(curField, controlType.text, controlData);
   end
   else if controlType.text = 'Bitmap' then begin
      controlData.add(BitmapScalingCombo.text);
      controlData.add(RasterCombo.text);
      setControlInfo(curField, controlType.text, controlData);
   end
   else if controlType.text = 'Field' then begin
      setControlInfo(curField, controlType.text, controlData);
   end
   else if isWWEditControl(controlType.text) then begin
      controlData.add(DBLookupComboList.Text);
      setControlInfo(curField, controlType.text, controlData);
   end;

   controlData.free;
end;

procedure TSelFieldsForm.OKBtnClick(Sender: TObject);
var NewSelected: TStrings;
    index, i: integer;
begin
    saveControlInfo;  { Updates last changes }
    savePictureMasks;

    NewSelected:= TStringList.create;
    for i:= 0 to DstList.Items.Count-1 do
    begin
       if wwFindSelected(GSelected, DstList.items[i], index) then
          NewSelected.add(GSelected[index]);
    end;
    GSelected.Assign(NewSelected);
    NewSelected.Free;
end;

procedure TSelFieldsForm.ControlTypeChange(Sender: TObject);
var   controlName: wwSmallString;
begin
   controlName:= controlType.text;
   if controlName='RichEdit' then begin
      DBRichEditComboList.itemIndex:= -1;
      ControlTypeNotebook.Activepage:= 'RichEdit';
   end
   else if controlName='CheckBox' then begin
      CheckOnValue.Text:= 'Yes';
      CheckOffValue.Text:= 'No';
      ControlTypeNotebook.Activepage:= 'Checkbox';
   end
   else  if controlName='Bitmap' then begin
      BitmapScalingCombo.itemIndex:= 0;
      RasterCombo.itemIndex:= 0;
      ControlTypeNotebook.Activepage:= 'Bitmap';
   end
   else  if controlName='Field' then begin
      ControlTypeNotebook.Activepage:= 'Field';
   end
   else  if isWWEditControl(controlName) then begin
      DBLookupComboList.itemIndex:= -1;
      ControlTypeNotebook.Activepage:= WW_DB_LOOKUP_COMBO;
   end;
end;

procedure TSelFieldsForm.ExcludeBtnClick(Sender: TObject);
begin
   ExcludeItems;
end;

procedure TSelFieldsForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var act: string;
begin
   if (key=vk_f1) then wwHelp(Handle, 'Select Fields Dialog Box')
   else if (Key = VK_Down) or (Key = VK_UP) then begin
      if ActiveControl=Nil then act:= 'DisplayWidth'
      else act:= ActiveControl.name;
      if ((act = 'DisplayWidth') or (act = 'DisplayTitle')) then
      begin
         if (Key = VK_Down) then begin
            if DstList.itemIndex < DstList.items.count-1 then begin
               DstList.selected[DstList.ItemIndex]:= False;
               SelectDest(DstList.ItemIndex + 1);
            end
         end
         else if DstList.itemIndex > 0 then begin
            DstList.selected[DstList.ItemIndex]:= False;
            SelectDest(DstList.ItemIndex - 1 );
         end
      end
   end
end;

procedure TSelFieldsForm.SortAvailCheckboxClick(Sender: TObject);
begin
   RefreshSourceList;
end;

procedure TSelFieldsForm.RefreshSourceList;
begin
end;

procedure TSelFieldsForm.HelpBtnClick(Sender: TObject);
begin
   wwHelp(Handle, 'Select Fields Dialog Box');
end;

procedure TSelFieldsForm.DesignMaskButtonClick(Sender: TObject);
var component: TwwCustomMaskEdit;
begin
   component:= TwwCustomMaskEdit.create(self);
   with component do begin
      component.visible:= False;
      component.parent:= self;
      with component.picture do begin
         PictureMask:= PictureMaskEdit.Text;
         AutoFill:= AutoFillCheckbox.checked;
      end;
      if wwPrpEdit_PictureMask(component) then
      begin
         with component.picture do begin
            PictureMaskEdit.Text:= PictureMask;
            PictureMaskEdit.LookupValue:= PictureMaskEdit.text;
            AutoFillCheckbox.checked:= AutoFill;
         end;
      end;

      Free;
   end

end;

procedure TSelFieldsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   ScrollTimer.enabled:= False;
   wwtable1.active:= False;
end;

procedure TSelFieldsForm.PictureMaskEditInitDialog(Dialog: TwwLookupDlg);
begin
   if not wwtable1.active then exit;

   if not wwtable1.wwFindRecord(PictureMaskEdit.Text, 'Mask', mtExactMatch, False) then
   begin
      wwtable1.indexFieldName:= 'Desc';
      wwtable1.First;
   end
   else wwtable1.indexFieldName:= 'Desc';
   wwtable1.FieldByName('Desc').index:= 0;
end;

procedure TSelFieldsForm.PictureMaskEditChange(Sender: TObject);
begin
   if not wwtable1.active then exit;

   if wwtable1.wwFindRecord(PictureMaskEdit.Text, 'Mask', mtExactMatch, False) then
      PictureDescription.Text:= wwtable1.FieldByName('Desc').asString
   else PictureDescription.Text:= 'Mask not found in database';

{   if wwtable1.indexName<>'iMask' then
   begin
      wwtable1.indexName:='iMask';
   end;
   if wwtable1.FindKey([PictureMaskEdit.Text]) then
      PictureDescription.Text:= wwtable1.FieldByName('Desc').asString
   else PictureDescription.Text:= 'Mask not found in database';
}
end;

procedure TSelFieldsForm.PictureMaskEditCloseUp(Sender: TObject;
  LookupTable: TDataSet; FillTable: TDataset; modified: Boolean);
begin
    if modified then begin
       PictureDescription.text:= lookupTable.fieldByName('Desc').asString;
    end
end;

procedure TSelFieldsForm.RemoveFieldsButtonClick(Sender: TObject);
begin
  ExcludeItems;
end;

procedure TSelFieldsForm.AddFieldsButtonClick(Sender: TObject);
var selectedList: TStrings;
    i: integer;
    tempField: TField;
begin
   selectedList:= TStringlist.create;

   try
      if wwDlgSelectFields(GridTable, DstList.items, selectedList) then
      begin
         for i:= 0 to selectedList.count-1 do begin
            DstList.items.add(selectedList[i]);
            if not useTFields then begin
               tempField:= GridTable.FindField(SelectedList[i]);
               if tempField<>Nil then begin
                  GSelected.add(tempField.FieldName + #9 +
{                    inttostr(tempField.DisplayWidth*wwPixelCharRatio + 4) + #9 +}
                    inttostr(tempField.DisplayWidth) + #9 +
                               tempField.DisplayLabel);
               end
            end
         end;
      end
   finally
      selectedList.free;
   end
end;

procedure TSelFieldsForm.DstListDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var row: integer;
    dragString: string;
    TempTopIndex: integer;
begin
   if not (Sender is TListbox) then exit;
   if not (Source is TListbox) then exit;

   if (Source=DstList) and (Sender=DstList) then
   begin
      TempTopIndex:= DstList.TopIndex;
      row := y  div DstList.ItemHeight + DstList.TopIndex;
      if row>DstList.items.count then row:= DstList.items.count;
      if dragFromRow>=DstList.items.count then exit;
      if row=dragFromRow then exit;
      dragString:= DstList.items[dragFromRow];
      DstList.items.delete(dragFromRow);
      if (row>DstList.items.count) then
        DstList.items.add(dragString)
      else DstList.items.insert(row, dragString);
      SelectDest(row);
      DstList.TopIndex:= TempTopIndex;
   end;

end;

procedure TSelFieldsForm.DstListDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
   GoForwards:= False;
   GoBackwards:= False;
   Accept:= True;
end;

procedure TSelFieldsForm.DstListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if (not(ssCtrl in shift)) and (not(ssShift in shift)) then begin
      dragFromRow := y  div DstList.ItemHeight + DstList.TopIndex;
      DstList.BeginDrag(False);
   end;
end;

procedure TSelFieldsForm.FormShow(Sender: TObject);
begin
   wwOpenPictureDB(wwtable1);
   useTFieldCheckBox.checked:= useTFields;
   ControlType.items.add('RichEdit');
{   if useTfields then DisplayWidthLabel.Caption:= '&Width '
   else DisplayWidthLabel.Caption:= '&Width (Pixels)';}
end;

procedure TSelFieldsForm.FormDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
   if DstList.dragging then begin
      GoBackwards:= y<DstList.Top;
      GoForwards:= y>DstList.Top + DstList.height;
   end;
end;

procedure TSelFieldsForm.UseTFieldCheckboxClick(Sender: TObject);
begin
   useTFields:= UseTFieldCheckbox.checked;
{   if useTfields then DisplayWidthLabel.Caption:= '&Width '
   else DisplayWidthLabel.Caption:= '&Width (Pixels)';}
end;


procedure TSelFieldsForm.InsertNewLineButtonClick(Sender: TObject);
begin
   DstList.items.insert(DstList.itemIndex, wwNewLineString);
   GSelected.insert(DstList.itemIndex, wwNewLineString);
end;

end.
