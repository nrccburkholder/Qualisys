unit Wwdbdlg;
{
//
// Components : TwwDBLookupDlg
//
// Copyright (c) 1995 by Woll2Woll Software
//
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Buttons,
  Forms, Dialogs, StdCtrls, wwdblook, dbTables, wwiDlg, DsgnIntf, db,
  Wwdbgrid, wwTable, menus, wwdbigrd, wwstr, wwcommon;


type

  TwwDBLookupComboDlg = class(TwwDBCustomLookupCombo)
  private
    FGridOptions: TwwDBGridOptions;
    FGridColor: TColor;
    FGridTitleAlignment: TAlignment;
    FOptions : TwwDBLookupDlgOptions;
    FCaption: String;
    FMaxWidth, FMaxHeight: integer;
    FUserButton1Click: TwwUserButtonEvent;
    FUserButton2Click: TwwUserButtonEvent;
    FUserButton1Caption: string;
    FUserButton2Caption: string;
    FOnInitDialog: TwwOnInitDialogEvent;
    FOnCloseDialog: TwwOnInitDialogEvent;

    procedure SetOptions(sel: TwwDBLookupDlgOptions);
    procedure SetGridOptions(sel: TwwDBGridOptions);

  protected
    Function LoadComboGlyph: HBitmap; override;
    Procedure DrawButton(Canvas: TCanvas; R: TRect; State: TButtonState;
       ControlState: TControlState; var DefaultPaint: boolean); override;
    Function IsLookupDlg: boolean; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DropDown; override;

  published
    property Options: TwwDBLookupDlgOptions read FOptions write SetOptions
      default [opShowOKCancel, opShowSearchBy];
    property GridOptions: TwwDBGridOptions read FGridOptions write SetGridOptions
      default [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines,
      dgRowLines, dgTabs, dgConfirmDelete, dgPerfectRowFit];

    property GridColor: TColor read FGridColor write FGridColor;
    property GridTitleAlignment: TAlignment read FGridTitleAlignment write FGridTitleAlignment;
    property Caption : String read FCaption write FCaption;
    property MaxWidth : integer read FMaxWidth write FMaxWidth;
    property MaxHeight : integer read FMaxHeight write FMaxHeight;
    property UserButton1Caption: string read FUserButton1Caption write FUserButton1Caption;
    property UserButton2Caption: string read FUserButton2Caption write FUserButton2Caption;
    property OnUserButton1Click: TwwUserButtonEvent read FUserButton1Click write FUserButton1Click;
    property OnUserButton2Click: TwwUserButtonEvent read FUserButton2Click write FUserButton2Click;
    property OnInitDialog: TwwOnInitDialogEvent read FOnInitDialog write FOnInitDialog;
    property OnCloseDialog: TwwOnInitDialogEvent read FOnCloseDialog write FOnCloseDialog;

    property Selected;
    property DataField;
    property DataSource;
    property LookupTable;
    property LookupField;
    property SeqSearchOptions;
    property Style;
    property AutoSelect;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    {$ifdef ver100}
    property ImeMode;
    property ImeName;
    {$endif}
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property AutoDropDown;
    property ShowButton;
    property OrderByDisplay;
    property AllowClearKey;
    property UseTFields;
    property ShowMatchText;

    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnCloseUp;
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

procedure Register;

implementation

uses wwlocate;

constructor TwwDBLookupComboDlg.Create(AOwner: TComponent);
begin
   inherited create(AOwner);

   FGridOptions := [dgTitles, dgIndicator, dgColumnResize, dgRowSelect,
    dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete,
    dgPerfectRowFit];

   FGridColor:= clWhite;
   FGridTitleAlignment:= taLeftJustify;
   FOptions:= [opShowOKCancel, opShowSearchBy];
   FCaption:= 'Lookup';
   FMaxHeight:= 209;
   FGrid.SkipDataChange:= True;
end;

destructor TwwDBLookupComboDlg.Destroy;
begin
   inherited Destroy;
end;

Procedure TwwDBLookupComboDlg.DrawButton(Canvas: TCanvas; R: TRect; State: TButtonState;
       ControlState: TControlState; var DefaultPaint: boolean);
begin
   {$ifdef win32}
   DefaultPaint:= False;
   wwDrawEllipsis(Canvas, R, State, Enabled, ControlState)
   {$endif}
end;

Function TwwDBLookupComboDlg.LoadComboGlyph: HBitmap; { Win95 }
begin
   result:= LoadBitmap(HInstance, 'DOTS');
end;

procedure TwwDBLookupComboDlg.SetOptions(sel: TwwDBLookupDlgOptions);
begin
   FOptions:= sel;
end;

procedure TwwDBLookupComboDlg.SetGridOptions(sel: TwwDBGridOptions);
begin
   FGridOptions:= sel;
end;

procedure TwwDBLookupComboDlg.DropDown;
type SmallString = string[63];
var MyOnDropDown: TNotifyEvent;
    {fromFieldName: String;} {Win95 - formerly SmallString}
    MyOnCloseUp: TNotifyCloseUpEvent;
    res: boolean;
    keyFieldValue: string;
    lkupField: TField;
    searchText, field1name: SmallString;
    curpos: integer;
    modified: boolean;
begin
   if ReadOnly then exit;

   if (LookupTable=Nil) then begin
      MessageDlg('No lookup table specified!', mtWarning, [mbok], 0);
      RefreshButton;
      exit;
   end;

   if (not LookupTable.active) then begin
      MessageDlg('No lookup table specified!', mtWarning, [mbok], 0);
      RefreshButton;
      exit;
   end;

   try
     { If calculated field then
       1. Find dest link field(s) name
       2. Set lookup table to use indexName for calculated field indexName
       3. Perform FindKey
       4. Switch index of lookupTable to match display of left-most column field
       5. After dialog returns, change value of from link field to selection
     }
     MyOnDropDown:= OnDropDown;
     MyOnCloseUp:= OnCloseUp;
     if Assigned(MyOnDropDown) then MyOnDropDown(Self);

     { default to lookup field if no selection }
     curPos:= 1;
     field1Name:= strGetToken(lookupField, ';', curpos);

     if (Selected.count=0) then begin
        if isWWCalculatedField then lkupField:= TwwPopupGrid(FGrid).DisplayFld
        else lkupField:= lookupTable.findField(field1Name);
        if (lkupField<>Nil) then begin
           Selected.add(
              lkupField.fieldName + #9 + inttostr(lkupField.displayWidth) + #9 +
              lkupField.DisplayLabel);
        end
     end;

     if AutoDropDown and inAutoDropDown then SearchText:= Text
     else SearchText:= '';

     if (dataSource<>Nil) and (dataSource.dataSet<>Nil)
        and isWWCalculatedField then begin

{        wwDataSetSyncLookupTable(dataSource.dataSet, lookupTable, dataField, fromFieldName);}
        Grid.DoLookup(True); { Called in case lookupTable was moved by another control }

        if (not HasMasterSource) and (LookupTable is TwwTable) and OrderByDisplay then
           LTable.setToIndexContainingFields(Selected);

        res:=  ExecuteWWLookupDlg(Screen.ActiveForm, Selected, lookupTable, FOptions, FGridOptions,
                  FGridColor, FGridTitleAlignment, FCaption, FMaxWidth, FMaxHeight, CharCase,
                  FUserButton1Caption, FUserButton2Caption,
                  FUserButton1Click, FUserButton2Click, FOnInitDialog, FOnCloseDialog, SearchText, UseTFields);
        if (DataSource<>Nil) and (DataSource.dataset<>Nil) then
           DataSource.dataSet.disableControls;

        if res then begin
           if LookupField<>'' then UpdateFromCurrentSelection;  { Updates FValue^ used by wwChangeFromLink }
           wwChangefromLink(LookupTable, modified)
        end
        else modified:= false;


        if Assigned(MyOnCloseUp) then begin
           MyOnCloseUp(Self, LookupTable, dataSource.dataSet, modified);
        end;
        if (DataSource<>Nil) and (DataSource.dataset<>Nil) then
           DataSource.dataSet.enableControls;
     end
     else begin
{        if (lookupTable.fieldByName(Field1Name).asString <> LookupValue) or}
         if  (LookupValue='') or isLookupRequired then begin

           { Switch index to lookup field's index }
           if (LookupTable is TwwTable) and (LTable.MasterSource=Nil) and (Lookupfield<>'') then
              LTable.setToIndexContainingField(LookupField);

           if TwwPopupGrid(FGrid).LookupFieldCount<2 then begin
              if UseSeqSearch or (LTable.indexFieldCount=0) then { Sequential search }
              begin
                 FindRecord(LookupValue, LookupField, mtExactMatch,
                            ssoCaseSensitive in SeqSearchOptions)
              end
              else LTable.wwFindKey([LookupValue])
           end
           else if TwwPopupGrid(FGrid).LookupFieldCount<3 then
             LTable.wwFindKey([LookupValue, Value2])
           else LTable.wwFindKey([LookupValue, SetValue2, SetValue3]);
        end;

        {Switch index back to previous index if not sql}
        if (LookupTable is TwwTAble) and (not HasMasterSource) and OrderByDisplay then
           LTable.setToIndexContainingFields(Selected);

        res:= ExecuteWWLookupDlg(Screen.ActiveForm, Selected, lookupTable, FOptions, FGridOptions,
                  FGridColor, FGridTitleAlignment, FCaption, FMaxWidth, FMaxHeight, CharCase,
                  FUserButton1Caption, FUserButton2Caption,
                  FUserButton1Click, FUserButton2Click, FOnInitDialog, FOnCloseDialog, SearchText, UseTFields);

        if (DataSource<>Nil) and (DataSource.dataset<>Nil) then
           DataSource.dataSet.disableControls;

        try

           skipDataChange:= True;  { Don't update internal lookup values 1/15/96 }

           if res then
           begin
              if LookupField<>'' then begin
                 KeyFieldValue:= lookupTable.fieldByName(Field1Name).Text;
                 FFieldLink.Edit;
                 if (DataSource=Nil) or (DataSource.dataSet=Nil) then
                 begin
                     UpdateFromCurrentSelection;
                     Text:= TwwPopupGrid(FGrid).DisplayValue;
                 end;
                 FFieldLink.Modified;
                 if FFieldLink.Field<>Nil then begin
                    FFieldLink.Field.AsString := KeyFieldValue; { forces calculated fields to refresh }
                    UpdateFromCurrentSelection;       { 8/25/96 - Update internal variables }
                    Text:= FGrid.DisplayFld.asString; { 8/25/96 }
                    FFieldLink.UpdateRecord;          { 1/22/96 - Update 2nd-3rd fields }
                 end
              end
           end;
           if Assigned(MyOnCloseUp) then begin
              if DataSource=Nil then MyOnCloseUp(Self, LookupTable, Nil, res)
              else MyOnCloseUp(Self, LookupTable, DataSource.dataSet, res);
           end;

        finally
           if (DataSource<>Nil) and (DataSource.dataset<>Nil) then
              DataSource.dataSet.enableControls;
        end;
     end;

   finally
      if (Style <> csDropDownList) or AutoDropDown then SelectAll;
      FLastSearchKey:= '';
      RefreshButton;
      SkipDataChange:= False;
      if modified then begin
         LookupTable.updateCursorPos;
         LookupTable.resync([]);
      end
   end;
end;

Function TwwDBLookupComboDlg.IsLookupDlg: boolean;
begin
   result:= True;
end;

procedure Register;
begin
{  RegisterComponents('InfoPower', [TwwDBLookupComboDlg]);}
end;

end.
