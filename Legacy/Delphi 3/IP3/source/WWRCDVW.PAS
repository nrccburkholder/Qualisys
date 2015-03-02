unit wwrcdvw;

interface

uses classes, messages, db, dbtables, forms, wwdbedit, wwdatsrc, stdctrls, extctrls, controls,
     wwcommon, dbctrls, winprocs, wintypes, graphics, wwstr, wwtypes, dialogs, menus,
     sysutils,wwintl, buttons, typinfo, wwmemo;

type
  TwwRecordViewForm = class(TForm)
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    Deactivated: boolean;
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    { Public declarations }
     DlgComponent: TComponent;
     RecordPanel, NavigatorPanel, ButtonPanel: TPanel;
     Navigator: TDBNavigator;
     ScrollBox: TScrollBox;
  end;


  TwwRecordViewStyle = (rvsVertical, rvsHorizontal);
  TwwRecordViewOption = (rvoHideReadOnly, rvoHideCalculated, rvoHideNavigator, rvoUseCustomControls,
                         rvoShortenEditBox, rvoModalForm, rvoStayOnTopForm, rvoConsistentEditWidth,
                         rvoEnterToTab, rvoConfirmCancel,
                         rvoCloseIsCancel, rvoMaximizeMemoWidth);
  TwwRecordViewOptions = Set of TwwRecordViewOption;

  TwwRecordViewOKCancelOption = (rvokShowOKCancel, rvokAutoPostRec, rvokAutoCancelRec);
  TwwRecordViewOKCancelOptions = Set of TwwRecordViewOKCancelOption;

  TwwCloseAction = (rvcOK,rvcCancel,rvcControlMenuClose);
  TwwCloseActions = Set of TwwCloseAction;
  TwwCancelEvent = Procedure(Form: TForm; var CanClose: boolean) of object;

  TwwOnBeforeCreateControlEvent =
     procedure(Form: TwwRecordViewForm; curField: TField; var Accept: boolean) of object;
  TwwOnAfterCreateControlEvent =
     procedure(Form: TwwRecordViewForm; curField: TField; Control: TControl) of object;
  TwwOnInitFormEvent = procedure(Form: TwwRecordViewForm) of object;

  TwwMargin = class(TPersistent)
  private
     FBottomOffset, FTopOffset, FLeftOffset, FRightOffset: integer;
  published
     property BottomOffset: integer read FBottomOffset write FBottomOffset
        default 5;
     property TopOffset: integer read FTopOffset write FTopOffset
        default 5;
     property LeftOffset: integer read FLeftOffset write FLeftOffset
        default 5;
     property RightOffset: integer read FRightOffset write FRightOffset
        default 5;
  end;

  TwwVertEditSpacing = class(TPersistent)
  private
     FBetweenLabelEdit, FBetweenRow: integer;
  published
     property BetweenLabelEdit: integer read FBetweenLabelEdit write FBetweenLabelEdit
          default 5;
     property BetweenRow: integer read FBetweenRow write FBetweenRow
          default 2;
  end;

  TwwHorzEditSpacing = class(TPersistent)
  private
     FBetweenLabelEdit, FBetweenEditsInRow, FBetweenRow, FLabelIndent: integer;
  published
     property BetweenEditsInRow: integer read FBetweenEditsInRow write FBetweenEditsInRow
          default 5;
     property BetweenLabelEdit: integer read FBetweenLabelEdit write FBetweenLabelEdit
          default 1;
     property BetweenRow: integer read FBetweenRow write FBetweenRow
          default 2;
     property LabelIndent: integer read FLabelIndent write FLabelIndent
          default 1;
  end;

  TwwEditSpacing = class(TPersistent)
  private
     FHorizontalView: TwwHorzEditSpacing;
     FVerticalView: TwwVertEditSpacing;
  public
     destructor Destroy; override;
  published
     property HorizontalView: TwwHorzEditSpacing read FHorizontalView write FHorizontalView;
     property VerticalView: TwwVertEditSpacing read FVerticalView write FVerticalView;
  end;

  TwwFormPosition = class(TPersistent)
  private
     FLeft, FTop: integer;
     FWidth, FHeight: integer;
  published
     property Left: integer read FLeft write FLeft;
     property Top: integer read FTop write FTop;
     property Width: integer read FWidth write FWidth;
     property Height: integer read FHeight write FHeight;
  end;

  TwwRecordViewDialog= class(TComponent)
  private
     FSelected: TStrings;
     FUseTFields: boolean;
     FControlList: TList;
     FEditSpacing: TwwEditSpacing;
     FMargin: TwwMargin;
     FFormPosition: TwwFormPosition;
     FBorderStyle: TFormBorderStyle;
     FDataLink: TDataLink;
     FOptions: TwwRecordViewOptions;
     FOKCancelOptions: TwwRecordViewOKCancelOptions;
     FFont: TFont;
     FLabelFont: TFont;
     FOnBeforeCreateControl: TwwOnBeforeCreateControlEvent;
     FOnAfterCreateControl: TwwOnAfterCreateControlEvent;
     FOnInitDialog: TwwOnInitFormEvent;
     FOnCloseDialog: TwwOnInitFormEvent;
     FCaption: string;
     FReadOnlyColor: TColor;
     FStyle: TwwRecordViewStyle;
     FMenu: TMainMenu;
     FNavigatorVisibleButtons: TButtonSet;
     FNavigatorFlat: boolean;
     FOnCancelWarning: TwwCancelEvent;

     EditStartOffset: integer;
     FormWidth, FormHeight: integer; { Scrollable range }
     CloseAction: TwwCloseAction;
     CustomControlList: TList;

     procedure SetDataSource(value : TwwDataSource);
     Function GetDataSource: TwwDataSource;
     Procedure SetLabelFont(val: TFont);
     Procedure SetFont(val: TFont);
     Function ShowField(field: TField): boolean;
{     procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);}
     procedure FormShow(Sender: TObject);
     procedure FormResize(Sender: TObject);
{     procedure FormActivate(Sender: TObject);}
     Procedure CreateMainMenu(Form: TwwRecordViewForm; mm: TMainMenu);
     procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
     procedure FormClose(Sender: TObject; var Action: TCloseAction);
     Procedure AddCustomControl(CustomEdit: TCustomEdit);
     Function IsModified: boolean;
     procedure DBMemoKeyDown(Sender: TObject; var Key: Word;
       Shift: TShiftState);
     procedure wwMemoDialogInitDialog(Dialog: TwwMemoDlg);
     function IsCheckBox(curField: TField; var checkboxOn, checkboxOff: string): boolean;
  protected
     procedure DoOnBeforeCreateControl(form: TwwRecordViewForm; curField: TField; var accept: boolean); virtual;
     procedure DoOnAfterCreateControl(form: TwwRecordViewForm; curField: TField; Control: TControl); virtual;
     procedure DoInitDialog(Form: TwwRecordViewForm); virtual;
     procedure DoCloseDialog(Form: TwwRecordViewForm); virtual;
     procedure Notification(AComponent: TComponent;
       Operation: TOperation); override;
     Procedure DisplayVertical;
     Procedure DisplayHorizontal;
     Procedure DoCancelWarning(var CanClose: boolean); virtual;
  public
     OKBtn: TButton;
     CancelBtn: TButton;
     RecordViewForm: TwwRecordViewForm;

     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
     Function Execute: boolean; virtual;
     procedure OKBtnClick(Sender: TObject); virtual;
     procedure CancelBtnClick(Sender: TObject); virtual;
  published
     property DataSource: TwwDataSource read GetDataSource write SetDataSource;
     property EditSpacing: TwwEditSpacing read FEditSpacing write FEditSpacing;
     property Margin: TwwMargin read FMargin write FMargin;
     property BorderStyle: TFormBorderStyle read FBorderStyle write FBorderStyle default bsSizeable;
     property FormPosition: TwwFormPosition read FFormPosition write FFormPosition;
     property NavigatorVisibleButtons: TButtonSet read FNavigatorVisibleButtons write FNavigatorVisibleButtons
              default [nbFirst,nbPrior,nbNext,nbLast,nbInsert,nbDelete,nbEdit,nbPost,nbCancel,nbRefresh];
     property Style : TwwRecordViewStyle read FStyle write FStyle default rvsVertical;
     property Options: TwwRecordViewOptions read FOptions write FOptions
              default [rvoShortenEditBox, rvoUseCustomControls,
                       rvoModalForm, rvoConfirmCancel, rvoCloseIsCancel, rvoMaximizeMemoWidth];
     property OKCancelOptions: TwwRecordViewOKCancelOptions read FOKCancelOptions write FOKCancelOptions
              default [rvokShowOKCancel, rvokAutoPostRec, rvokAutoCancelRec];
     property LabelFont: TFont read FlabelFont write SetLabelFont;
     property Font: TFont read FFont write SetFont;
     property OnBeforeCreateControl: TwwOnBeforeCreateControlEvent
              read FOnBeforeCreateControl write FOnBeforeCreateControl;
     property OnAfterCreateControl: TwwOnAfterCreateControlEvent
              read FOnAfterCreateControl write FOnAfterCreateControl;
     property OnInitDialog: TwwOnInitFormEvent read FOnInitDialog write FOnInitDialog;
     property OnCloseDialog: TwwOnInitFormEvent read FOnCloseDialog write FOnCloseDialog;
     property Caption: string read FCaption write FCaption;
     property ReadOnlyColor: TColor read FReadOnlyColor write FReadOnlyColor default clInactiveCaptionText;
     property Menu: TMainMenu read FMenu write FMenu;
     property Selected: TStrings read FSelected write FSelected;
     property NavigatorFlat: boolean read FNavigatorFlat write FNavigatorFlat default False;
     property OnCancelWarning: TwwCancelEvent read FOnCancelWarning write FOnCancelWarning;
{     property UseTFields: boolean read FUseTFields write FUseTFields default False;}

  end;

var
  wwRecordViewForm: TwwRecordViewForm;

implementation

   uses wwdbgrid;

const Spacing=13;
      FixedEditWidthConst=20;

{$R *.DFM}

type
  TwwCustomControlItem=class
     control: TCustomEdit;
     Left, Top, Width, Height: integer;
  end;

  TwwLabel =class(TLabel)
  protected
     procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  end;

  TwwDBCheckBox =class(TDBCheckBox)
  protected
     procedure DoEnter; override;
     procedure DoExit; override;
  public
     LabelControl: TLabel;
  end;

constructor TwwRecordViewDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink:= TDataLink.create;
  FEditSpacing:= TwwEditSpacing.create;
  with FEditSpacing do begin
     VerticalView:= TwwVertEditSpacing.create;
     VerticalView.BetweenRow:= 2;
     VerticalView.BetweenLabelEdit:= 5;
     HorizontalView:= TwwHorzEditSpacing.create;
     HorizontalView.BetweenRow:= 2;
     HorizontalView.BetweenLabelEdit:= 1;
     HorizontalView.BetweenEditsInRow:= 5;
     HorizontalView.LabelIndent:= 1;
  end;

  FMargin:= TwwMargin.create;
  with FMargin do begin
     LeftOffset:= 5;
     RightOffset:=5;
     TopOffset:= 5;
     BottomOffset:=5;
  end;

  FFormPosition:= TwwFormPosition.create;
  with FFormPosition do begin
     Left:= 0;  { Auto-center }
     Top:= 0;   { Auto-center }
     Width:= 0;  { Auto-size }
     Height:= 0; { Auto-size }
  end;

  FOptions:= [rvoShortenEditBox, rvoUseCustomControls, rvoModalForm, rvoConfirmCancel,
              rvoCloseIsCancel, rvoMaximizeMemoWidth];
  FOKCancelOptions:= [rvokShowOKCancel, rvokAutoPostRec, rvokAutoCancelRec];
  FFont := TFont.Create;
  FLabelFont:= TFont.create;
  FControlList:= TList.create;
  FCaption:= 'Record View';
  FReadOnlyColor:= clInactiveCaptionText;
  FStyle:= rvsVertical;
  FSelected:= TStringList.create;
  FUseTFields:= False;
  FNavigatorVisibleButtons:= [nbFirst,nbPrior,nbNext,nbLast,nbInsert,nbDelete,nbEdit,nbPost,nbCancel,nbRefresh];
  CloseAction := rvcControlMenuClose;
  CustomControlList:= TList.create;
  BorderStyle:= bsSizeable;
end;

destructor TwwEditSpacing.Destroy;
begin
  FHorizontalView.Free;
  FVerticalView.Free;
  inherited destroy;
end;

destructor TwwRecordViewDialog.Destroy;
var i: integer;
begin
  if not (csDestroying in Application.ComponentState) then
     RecordViewForm.Free;
  RecordViewForm:= Nil;
  FDataLink.free;
  FDataLink:= nil;
  FEditSpacing.Free;
  FMargin.Free;
  FFormPosition.Free;
  FFont.Free;
  FLabelFont.Free;
  FControlList.Free;
  FSelected.Free;
  for i:= 0 to CustomControlList.count-1 do TwwCustomControlItem(CustomControlList[i]).Free;
  CustomControlList.Free;

  inherited destroy;
end;

procedure TwwRecordViewDialog.SetDataSource(value : TwwDataSource);
begin
   FDataLink.dataSource:= value;
end;

Function TwwRecordViewDialog.getDataSource: TwwDataSource;
begin
   Result:= FdataLink.dataSource as TwwDataSource;
end;

procedure TwwRecordViewDialog.setFont(val: TFont);
begin
    FFont.assign(Val);
end;

procedure TwwRecordViewDialog.setLabelFont(val: TFont);
begin
    FLabelFont.assign(Val);
end;

Function TwwRecordViewDialog.ShowField(field: TField): boolean;
begin
   if field=nil then result:= False
   else if (rvoHideReadOnly in Options) and field.readonly then result:= False
   else if (rvoHideCalculated in Options) and field.calculated then result:= False
   else result:= True;
end;

procedure TwwRecordViewDialog.FormShow(Sender: TObject);
begin
   DoInitDialog(Sender as TwwRecordViewForm);
   Screen.cursor:= crDefault;
end;

procedure TwwRecordViewForm.KeyDown(var Key: Word; Shift: TShiftState);
var Dlg: TwwRecordViewDialog;

  Function GetWantReturns(Control: TControl): boolean;
  var PropInfo: PPropInfo;
  begin
   Result:= False;
   PropInfo:= Typinfo.GetPropInfo(Control.ClassInfo,'WantReturns');
   if PropInfo<>Nil then
      result:= Boolean(GetOrdProp(Control, PropInfo))
   else if Control is TCustomMemo then
      result:= TMemo(Control).wantReturns;
  end;

  Function GetWantTabs(Control: TControl): boolean;
  var PropInfo: PPropInfo;
  begin
   Result:= False;
   PropInfo:= Typinfo.GetPropInfo(Control.ClassInfo,'WantTabs');
   if PropInfo<>Nil then
      result:= Boolean(GetOrdProp(Control, PropInfo))
  end;

begin
  inherited KeyDown(Key, Shift);

  if ssAlt in Shift then exit;

  Dlg:= DlgComponent as TwwRecordViewDialog;

  if  ((ssCtrl in Shift) and (key=vk_return)) and (rvoModalForm in Dlg.Options) and
      (not (rvoEnterToTab in Dlg.Options)) then
  begin
     ModalResult:= mrOK;
  end;

  if Key=27 then begin
     TwwCheatCastKeyDown(ActiveControl).KeyDown(Key, Shift);
     if (Key=27) then begin
        Key:= 0;
        if (ActiveControl is TCustomEdit) and (ActiveControl as TCustomEdit).modified then exit
        else
          ModalResult:= mrCancel;
     end
  end
  else if (not GetWantReturns(ActiveControl) and (key=vk_return) and (rvoEnterToTab in Dlg.Options))
      or (not GetWantTabs(ActiveControl) and (key=vk_tab)) then
  begin
     if ssShift in Shift then
        PostMessage(Handle, WM_NEXTDLGCTL, 1, 0)
     else
        PostMessage(Handle, WM_NEXTDLGCTL, 0, 0);
     key:= 0;
  end;

end;

procedure TwwRecordViewDialog.DoOnAfterCreateControl(
    form: TwwRecordViewForm; curField: TField; Control: TControl);
begin
   if Assigned(FOnAfterCreateControl) then
      FOnAfterCreateControl(form, curfield, control);
end;

procedure TwwRecordViewDialog.DoOnBeforeCreateControl(
    form: TwwRecordViewForm; curField: TField; var accept: boolean);
begin
   if Assigned(FOnBeforeCreateControl) then
      FOnBeforeCreateControl(form, curfield, accept);
end;

Procedure TwwRecordViewDialog.DoInitDialog(form: TwwRecordViewForm);
begin
   if Assigned(FOnInitDialog) then OnInitDialog(Form);
end;

Procedure TwwRecordViewDialog.DoCancelWarning(var CanClose: boolean);
begin
   if Assigned(FOnCancelWarning) then FOnCancelWarning(RecordViewForm, CanClose);
end;

Procedure TwwRecordViewDialog.DoCloseDialog(form: TwwRecordViewForm);
begin
   if Assigned(FOnCloseDialog) then OnCloseDialog(Form);
end;

function IsCustomEditCell(
        ownerForm: TCustomForm;
        curField: TField;
        var customEdit: TCustomEdit) : boolean;
var i: integer;
    parts : TStrings;
{    ownerForm: TCustomForm;}
    component: TComponent;
begin
   result:= False;
{   ownerForm:= wwGetOwnerForm(curField.dataset);}
   if ownerForm=nil then exit;

   parts:= TStringList.create;

   for i:= 0 to wwGetControlType(curField.dataSet).count-1 do begin
      strBreakapart(wwGetControlType(curfield.dataSet)[i], ';', parts);
      if parts.count<2 then continue;
      if not wwEqualStr(parts[0], curField.FieldName) then continue;
      if isWWEditControl(parts[1]) or (parts[1]='RichEdit') then begin
         component:= OwnerForm.FindComponent(parts[2]);
         if (component<>Nil) and (component is TCustomEdit) then
         begin
            customEdit:= TCustomEdit(component);
            if customEdit=Nil then break;
            result:= True;
         end;
         break;
      end
   end;

   parts.free;
end;

Procedure TwwRecordViewDialog.AddCustomControl(CustomEdit: TCustomEdit);
var customItem: TwwCustomControlItem;
begin
   customItem:= TwwCustomControlItem.create;
   with customItem do begin
      Control:= CustomEdit;
      Left:= CustomEdit.Left;
      Width:= CustomEdit.Width;
      Top:= CustomEdit.Top;
      Height:= CustomEdit.Height;
   end;
   CustomControlList.add(customItem);
end;

function TwwRecordViewDialog.IsCheckBox(curField: TField; var checkboxOn, checkboxOff: string): boolean;
var fldName: string;
    i: integer;
    parts : TStrings;
    controlType: TStrings;
begin
   result:= False;
   fldName:= curField.fieldName;
   parts:= TStringList.create;

   controlType:= wwGetControlType(datasource.dataset);
   for i:= 0 to ControlType.count-1 do begin
      strBreakapart(controlType[i], ';', parts);
      if parts.count<4 then continue;
      if parts[0]<>fldName then continue;
      if parts[1]='CheckBox' then begin
	 CheckBoxOn:= parts[2];
	 CheckBoxOff:= parts[3];
	 result:= True;
	 break;
      end
   end;

   parts.free;
end;

Procedure TwwRecordViewDialog.DisplayVertical;
var
    LabelWidth, MaxLabelWidth, MaxEditWidth: integer;
    APos, i, numFields: integer;
    curFieldDisplayWidth: integer;
    curFieldDisplayLabel: wwSmallString;
    curField: TField;
    curLabel: Tlabel;
    customEdit: TCustomEdit;
    wwDbEdit: TwwDBEdit;
    dbMemo: TDBMemo;
    checkbox: TwwDBCheckBox;
    NavigatorWidth: integer;
    ButtonPanelHeight: integer;
    EditHeight: integer;
    FixedEditWidth: integer;
    accept: boolean;
    PrevTop: integer;
    ARect: TRect;
    checkboxOn, checkboxOff: wwSmallString;
begin
   PrevTop:= Margin.TopOffset;
   with RecordViewForm do begin
      if not (rvoHideNavigator in Options) then NavigatorWidth:= Navigator.width
      else NavigatorWidth:= 0;

      if (rvokShowOKCancel in OKCancelOptions) then
      begin
        ButtonPanelHeight:= ButtonPanel.Height;
      end
      else
      begin
        ButtonPanelHeight:= 0;
      end;

      if FuseTFields or (selected.count=0) then numFields:= DataSource.DataSet.FieldCount
      else numFields:= Selected.count;

      MaxLabelWidth:= 0;
      Canvas.Font := LabelFont;
      for i:= 0 to numFields-1 do begin
         if (Selected.count=0) or FuseTFields then begin
            curField:= DAtaSource.dataset.fields[i];
            curFieldDisplayLabel:= curField.DisplayLabel;
         end
         else begin
            APos:= 1;
            curField:= DAtaSource.dataset.findField(strGetToken(Selected[i], #9, APos));
            if curfield<>nil then begin
               strGetToken(Selected[i], #9, APos);
               curFieldDisplayLabel:= strGetToken(Selected[i], #9, APos);  { 6/4/97}
            end
         end;
         if not ShowField(curfield) then continue;
         MaxLabelWidth:= wwMax(MaxLabelWidth,
                           Canvas.TextWidth(curFieldDisplayLabel));
      end;

      LabelWidth:= MaxLabelWidth;
      Canvas.Font := Font;
            { Limit form length }
      EditStartOffset:= Margin.LeftOffset + labelWidth + EditSpacing.VerticalView.BetweenLabelEdit;

      { Compute desired form length }
      MaxEditWidth:= 0;
      curFieldDisplayWidth:= 0;

      for i:= 0 to numFields-1 do begin
         if (Selected.count=0) or FuseTFields then
         begin
            curField:= DAtaSource.dataset.fields[i];
            curFieldDisplayWidth:= curField.DisplayWidth;
         end
         else begin
            APos:= 1;
            curField:= DAtaSource.dataset.findField(strGetToken(Selected[i], #9, APos));
            if curfield<>nil then
               curFieldDisplayWidth:= strToInt(strGetToken(Selected[i], #9, APos));
         end;
         if not ShowField(curfield) then continue;

         MaxEditWidth:= wwmax(MaxEditWidth,
               (CurFieldDisplayWidth+1) * Canvas.TextWidth('0') + 3);
      end;


      ARect := wwGetWorkingRect;

      if FormPosition.Width>0 then
         FormWidth:= wwMax(FormPosition.Width, NavigatorWidth + (FixedEditWidthConst-6) + Margin.RightOffset)
      else begin
         FormWidth:= RecordPanel.Left + ScrollBox.left + EditStartOffset + MaxEditWidth +
                  (FixedEditWidthConst-6) + Margin.RightOffset;
         FormWidth:= wwMax(FormWidth, NavigatorWidth + (FixedEditWidthConst-6) + Margin.RightOffset);
      end;

      Width:= wwmin(FormWidth, (ARect.Right-ARect.Left)-((FixedEditWidthConst-6) + Margin.RightOffset));

      MaxEditWidth:= 0;
      EditHeight:= 8;

      FixedEditWidth:= RecordViewForm.width - (EditStartOffset + (FixedEditWidthConst + Margin.RightOffset));

      for i:= 0 to numFields-1 do begin
         if (Selected.count=0) or FuseTFields then
         begin
            curField:= DAtaSource.dataset.fields[i];
            curFieldDisplayWidth:= curField.displayWidth;
            curFieldDisplayLabel:= curField.displayLabel;
         end
         else begin
            APos:= 1;
            curField:= DAtaSource.dataset.findField(strGetToken(Selected[i], #9, APos));
            if curfield<>nil then begin
               curFieldDisplayWidth:= strToInt(strGetToken(Selected[i], #9, APos));
               curFieldDisplayLabel:= strGetToken(Selected[i], #9, APos);  { 6/4/97}
            end
         end;
         if not ShowField(curfield) then continue;

         accept:= True;
         DoOnBeforeCreateControl(RecordViewForm, curField, accept);
         if not accept then continue;

         if (rvoUseCustomControls in Options) and
            IsCheckbox(curField, checkboxOn, checkboxOff) then
            curLabel:= TwwLabel.create(Scrollbox)
         else
            curLabel:= TLabel.create(Scrollbox);

         with curLabel do begin
            parent:= ScrollBox;
            font:= self.labelFont;
            left:= Margin.LeftOffset;
            if (rvoUseCustomControls in Options) and
               IsCheckbox(curField, checkboxOn, checkboxOff) then
            begin
               Top:= PrevTop + 1
            end
            else
               Top:= PrevTop + 4;
            Caption:= strReplaceChar(curfieldDisplayLabel, '~', ' ');
            AutoSize:= False;
            Width:= LabelWidth;
            alignment:= taRightJustify;
         end;

         DoOnAfterCreateControl(RecordViewForm, curField, curLabel);

         if (rvoUseCustomControls in Options) and
            IsCheckbox(curField, checkboxOn, checkboxOff) then
         begin
            checkbox:= TwwDBCheckBox.create(ScrollBox);
            checkbox.LabelControl:= curLabel;
            curLabel.FocusControl:= checkBox;
            with checkbox do begin
               parent:= ScrollBox;
               datasource:= self.DataSource;
               datafield:= curfield.fieldName;
               left:= EditStartOffset; {EditPosition.LeftOffset + LabelWidth + 5;}
               Top:= PrevTop;
               caption:= '';
               valueChecked:= checkboxOn;
               valueUnchecked:= checkboxOff;
               Width:= 17;
               if Field.readonly or Field.calculated then
               begin
                  tabStop:= False;
               end;
            end;
            DoOnAfterCreateControl(RecordViewForm, curField, checkbox);

            MaxEditWidth:= wwmax(MaxEditWidth, checkbox.Width);
            PrevTop:= Prevtop + checkbox.Height + EditSpacing.VerticalView.BetweenRow;
            EditHeight:= checkbox.Height;

         end
         else if (rvoUseCustomControls in Options) and
            IsCustomEditCell(wwGetOwnerForm(self), curField, customEdit) then
         with TEdit(CustomEdit) do begin

            { Save previous position and restore when dialog is closed }
            AddCustomControl(CustomEdit);
            curLabel.FocusControl:= CustomEdit;

            parent:= ScrollBox;
            visible:= True;
            if not wwSetControlDataSource(customEdit, datasource) then continue;
            if not wwSetControlDataField(customEdit, curField.fieldName) then continue;
            Ctl3d:= True;
            BorderStyle:= bsSingle;
            left:= EditStartOffset;
            top:= PrevTop;

            if (wwisclass(customedit.classtype,'TwwCustomRichEdit')) then begin
{               Height:= Canvas.TextHeight('0')*2+8;}
               Width:= RecordViewForm.width - EditStartOffset - (FixedEditWidthConst + Margin.RightOffset);
            end
            else
               Width:= (curFieldDisplayWidth+1) * Canvas.TextWidth('0') + 3;

            if rvoShortenEditBox in Options then begin
               if Width>FixedEditWidth then Width:= FixedEditWidth;
            end;
            if rvoConsistentEditWidth in Options then begin
               if Width<FixedEditWidth then Width:= FixedEditWidth;
            end;
            TEdit(CustomEdit).HandleNeeded;
            FControlList.add(CustomEdit);
            DoOnAfterCreateControl(RecordViewForm, curField, customEdit);

            if rvoShortenEditBox in Options then begin
               if customEdit.Width>FixedEditWidth then
                  customEdit.Width:= FixedEditWidth;
            end;
            if rvoConsistentEditWidth in Options then begin
               if customEdit.Width<FixedEditWidth then customEdit.Width:= FixedEditWidth;
            end;
            MaxEditWidth:= wwmax(MaxEditWidth, customEdit.Width);
            PrevTop:= Prevtop + customEdit.Height + EditSpacing.VerticalView.BetweenRow;
            EditHeight:= customEdit.Height;
         end
         else if curField is TMemoField then begin
            dbMemo:= TDBMemo.create(Scrollbox);
            curLabel.FocusControl:= dbMemo;
            with dbMemo do begin
               parent:= ScrollBox;
               datasource:= self.DataSource;
               datafield:= curField.FieldName;
               left:= EditStartOffset; {EditPosition.LeftOffset + LabelWidth + 5;}
               Top:= PrevTop;
               if (rvoEnterToTab in Options) then
                   TMemo(dbMemo).WantReturns := False;

               Height:= Canvas.TextHeight('0')*2+8;

               Width:= RecordViewForm.width - EditStartOffset - (FixedEditWidthConst + Margin.RightOffset);
               if rvoShortenEditBox in Options then begin
                  if Width>FixedEditWidth then Width:= FixedEditWidth;
               end;
               if rvoConsistentEditWidth in Options then begin
                  if Width<FixedEditWidth then Width:= FixedEditWidth;
               end;
               if Field.readonly then enabled:=False;
               OnKeyDown:= DBMemoKeyDown;
            end;
            FControlList.add(dbMemo);
            DoOnAfterCreateControl(RecordViewForm, curField, dbMemo);

            if rvoShortenEditBox in Options then begin
               if dbMemo.Width>FixedEditWidth then dbMemo.Width:= FixedEditWidth;
            end;

            if rvoConsistentEditWidth in Options then begin
               if dbMemo.Width<FixedEditWidth then dbMemo.Width:= FixedEditWidth;
            end;

            MaxEditWidth:= wwmax(MaxEditWidth, dbMemo.Width);
            PrevTop:= Prevtop + dbMemo.Height + EditSpacing.VerticalView.BetweenRow;
            EditHeight := dbMemo.Height;
         end
         else begin
            wwDBEdit:= TwwDBEdit.create(Scrollbox);
            curLabel.FocusControl:= wwDBEdit;
            with wwDBEdit do begin
               parent:= ScrollBox;
               datasource:= self.DataSource;
               datafield:= curfield.fieldName;
               left:= EditStartOffset; {EditPosition.LeftOffset + LabelWidth + 5;}
               Top:= PrevTop;

               Width:= (curFieldDisplayWidth+1) * Canvas.TextWidth('0') + 3;
               if rvoShortenEditBox in Options then begin
                  if Width>FixedEditWidth then
                     Width:= FixedEditWidth;
               end;
               if rvoConsistentEditWidth in Options then begin
                  if Width<FixedEditWidth then Width:= FixedEditWidth;
               end;
               if Field.readonly or Field.calculated then
               begin
                  wwDBEdit.color:= ReadOnlyColor;
                  wwDBEdit.tabStop:= False;
               end;
            end;
            FControlList.add(wwDBEdit);

            DoOnAfterCreateControl(RecordViewForm, curField, wwDBEdit);

            {Added to handle changes to control in OnAfterCreateControl}
            if rvoShortenEditBox in Options then begin
               if wwDBEdit.Width>FixedEditWidth then
                  wwDBEdit.Width:= FixedEditWidth;
            end;

            if rvoConsistentEditWidth in Options then begin
               wwDBEdit.Width:= FixedEditWidth;
            end;

            MaxEditWidth:= wwmax(MaxEditWidth, wwDBEdit.Width);
            PrevTop:= Prevtop + wwDBEdit.Height + EditSpacing.VerticalView.BetweenRow;
            EditHeight:= wwDBEdit.Height;
         end
      end;

      CreateMainMenu(RecordViewForm, self.menu);
      PrevTop := PrevTop + Margin.BottomOffset - EditSpacing.VerticalView.BetweenRow;

      FormHeight:= (PrevTop  + RecordPanel.Top)+ 21+getsystemmetrics(SM_CYCAPTION) + ButtonPanelHeight;

      if (self.menu<>nil) and (BorderStyle<>bsDialog) then
         FormHeight:= FormHeight +  GetSystemMetrics(SM_CYMENU);
      if FormPosition.height>0 then Height:= wwMin(FormPosition.Height, FormHeight)
      else Height:= FormHeight;

      { Adjust width/height based on visibility of scrollbars }
      if Height>ARect.Bottom-ARect.Top-12 then Height:= ARect.Bottom-ARect.Top-12;
      ScrollBox.VertScrollBar.Margin:= 6;
      ScrollBox.VertScrollBar.Increment:= EditHeight + EditSpacing.VerticalView.BetweenRow;
      ScrollBox.VertScrollBar.Range := PrevTop;
      if (RecordPanel.Height-12)<PrevTop then Width:= Width + GetSystemMetrics(SM_CXHThumb);

      FormWidth:= RecordPanel.Left + ScrollBox.left + EditStartOffset + MaxEditWidth +
                  (FixedEditWidthConst-6) + Margin.RightOffset;
      if Width>ARect.Right-ARect.Left then Width:= ARect.Right-ARect.Left;

      if Width<FormWidth then
         Height:= Height + GetSystemMetrics(SM_CYVThumb);
      ScrollBox.HorzScrollBar.Margin:= 6;
      if (rvoConsistentEditWidth in Options) then
         ScrollBox.HorzScrollBar.Range := MaxEditWidth
      else
         ScrollBox.HorzScrollBar.Range := EditStartOffset + MaxEditWidth + Margin.RightOffset;

      if (rvokShowOKCancel in OKCancelOptions) then begin
         ButtonPanel.Width := Width;
         OKBtn.Left:= (ButtonPanel.Width - 10) - ((OKBtn.Width + Spacing) * 2);
         CancelBtn.Left:= (ButtonPanel.Width-10) - ((OKBtn.Width + Spacing) * 1);
      end;
   end
end;


{*****************************************************}

Procedure TwwRecordViewDialog.DisplayHorizontal;
var
    OrigMaxEditWidth, MaxEditWidth: integer;
    APos, i, numFields: integer;
    curFieldDisplayWidth: integer;

    curFieldEditWidth: integer;
    curFieldLabelWidth: integer;
    curFieldDisplayLabel: wwSmallString;
    RealMaxLineWidth, MaxLineWidth,curLineWidth: integer;
    LastEditHeight:integer;
    LastLabelHeight:integer;
    ARect:TRect;

    curField: TField;
    curLabel: Tlabel;
    customEdit: TCustomEdit;
    wwDbEdit: TwwDBEdit;
    dbMemo: TDBMemo;
    checkbox: TwwDBCheckBox;
    NavigatorWidth: integer;
    ButtonPanelHeight: integer;
    EditHeight: integer;
    FixedEditWidth: integer;
    accept: boolean;
    PrevTop: integer;
    checkboxOn, checkboxOff: wwSmallString;

begin
   PrevTop:= Margin.TopOffset;
   with RecordViewForm do begin
      if not (rvoHideNavigator in Options) then NavigatorWidth:= Navigator.width
      else NavigatorWidth:= 0;

      if (rvokShowOKCancel in OKCancelOptions) then
      begin
        ButtonPanelHeight:= ButtonPanel.Height;
      end
      else
      begin
        ButtonPanelHeight:= 0;
      end;

      if FuseTFields or (selected.count=0) then numFields:= DataSource.DataSet.FieldCount
      else numFields:= Selected.count;

      Canvas.Font := Font;

      { Compute desired form length }
      MaxEditWidth:= 0;
      RealMaxLineWidth:= 0;
      curFieldDisplayWidth:= 0;

      for i:= 0 to numFields-1 do begin
         if (Selected.count=0) or FuseTFields then
         begin
            curField:= DAtaSource.dataset.fields[i];
            curFieldDisplayWidth:= curField.DisplayWidth;
         end
         else begin
            APos:= 1;
            curField:= DAtaSource.dataset.findField(strGetToken(Selected[i], #9, APos));
            if curfield<>nil then
               curFieldDisplayWidth:= strToInt(strGetToken(Selected[i], #9, APos));
         end;
         if not ShowField(curfield) then continue;

         MaxEditWidth:= wwmax(MaxEditWidth,
               (CurFieldDisplayWidth+1) * Canvas.TextWidth('0') + 3);
      end;
      OrigMaxEditWidth:= MaxEditWidth;

      { Limit form length }
      EditStartOffset:= Margin.LeftOffset;

      if FormPosition.Width>0 then
         FormWidth:= wwMax(FormPosition.Width, NavigatorWidth + (FixedEditWidthConst-6) + Margin.RightOffset)
      else begin
         FormWidth:= RecordPanel.Left + ScrollBox.left + EditStartOffset + MaxEditWidth +
                  (FixedEditWidthConst-6) + Margin.RightOffset;
         FormWidth:= wwMax(FormWidth, NavigatorWidth + (FixedEditWidthConst-6) + Margin.RightOffset);
         FormWidth:= wwMax(FormWidth,400);
      end;

      ARect := wwGetWorkingRect;

      Width:= wwmin(FormWidth, (ARect.Right-ARect.Left)-((FixedEditWidthConst-6) + Margin.RightOffset));

      MaxEditWidth:= 0;

      lastEditHeight := 0;
      lastLabelHeight := 0;
      CurLineWidth:= 0;

      FixedEditWidth:= RecordViewForm.width - RecordViewForm.ScrollBox.left  { 6/16/97 - Substract scrollbox.left }
                      - (EditStartOffset + (FixedEditWidthConst + Margin.RightOffset));
      MaxLineWidth:= FixedEditWidth;

      for i:= 0 to numFields-1 do begin
         APos:= 1;
         if (Selected.count=0) or FUseTFields then
         begin
            curField:= DAtaSource.dataset.fields[i];
            curFieldDisplayWidth:= curfield.DisplayWidth;
            curFieldDisplayLabel:= curField.displayLabel;
         end
         else begin
            curField:= DAtaSource.dataset.findField(strGetToken(Selected[i], #9, APos));
            if curfield = nil then begin
               {NEW LINE}
               curLineWidth := 0;
               PrevTop := PrevTop + EditSpacing.HorizontalView.BetweenLabelEdit+
                          LastEditHeight + EditSpacing.HorizontalView.BetweenRow +
                          LastLabelHeight;{New Top Value}
               LastEditHeight := 0;
               continue;
            end
            else begin
               curFieldDisplayWidth:= strToInt(strGetToken(Selected[i], #9, APos));
               curFieldDisplayLabel:= strGetToken(Selected[i], #9, APos);
            end
         end;

         if not ShowField(curfield) then continue;

         Canvas.Font := LabelFont;
         curFieldLabelWidth := (Canvas.TextWidth(curFieldDisplayLabel));
         Canvas.Font := Font;

         if (rvoMaximizeMemoWidth in Options) and
            ((IsCustomEditCell(wwGetOwnerForm(self), curField, customEdit) and
             wwisclass(customedit.classtype,'TwwCustomRichEdit'))
             or (curField is TMemoField)) then
            curFieldEditWidth:= FixedEditWidth
         else
            curFieldEditWidth:= (curFieldDisplayWidth+1) * Canvas.TextWidth('0') + 3;

         if (curlineWidth > 0) and
            (curLineWidth + EditSpacing.HorizontalView.BetweenEditsInRow +
             wwmax(curFieldEditWidth,curFieldLabelWidth+EditSpacing.HorizontalView.LabelIndent) > MaxLineWidth) then
         begin
            {Won't fit on current line so go to next line}
            curLineWidth := 0;
            PrevTop := PrevTop + EditSpacing.HorizontalView.BetweenLabelEdit +
                       EditSpacing.HorizontalView.BetweenRow + LastEditHeight + LastLabelHeight;{New Top Value}
            LastEditHeight := 0;
         end;

         accept:= True;
         DoOnBeforeCreateControl(RecordViewForm, curField, accept);
         if not accept then continue;

         if (rvoUseCustomControls in Options) and
            IsCheckbox(curField, checkboxOn, checkboxOff) then
            curLabel:= TwwLabel.create(Scrollbox)
         else
            curLabel:= TLabel.create(Scrollbox);
         with curLabel do begin
            parent:= ScrollBox;
            font:= self.labelFont;
            left:= Margin.LeftOffset+ CurLineWidth+EditSpacing.HorizontalView.LabelIndent;
            Top:= PrevTop;
            Caption:= strReplaceChar(curfieldDisplayLabel, '~', ' ');
            AutoSize:= False;
            Width:= Canvas.TextWidth(curFieldDisplayLabel);
            alignment:= taLeftJustify;
         end;

         DoOnAfterCreateControl(RecordViewForm, curField, curLabel);
         LastLabelHeight := curLabel.height;
         curFieldLabelWidth := curlabel.width+EditSpacing.HorizontalView.LabelIndent;

         if (rvoUseCustomControls in Options) and
            IsCheckbox(curField, checkboxOn, checkboxOff) then
         begin
            checkbox:= TwwDBCheckBox.create(ScrollBox);
            checkbox.LabelControl:= curLabel;
            curLabel.FocusControl:= checkBox;
            with checkbox do begin
               parent:= ScrollBox;
               datasource:= self.DataSource;
               datafield:= curfield.fieldName;
               left:= EditStartOffset+curLineWidth;
               Top:= PrevTop+EditSpacing.HorizontalView.BetweenLabelEdit+ curlabel.Height;
               caption:= '';
               valueChecked:= checkboxOn;
               valueUnchecked:= checkboxOff;
               Width:= 17;
               if Field.readonly or Field.calculated then
               begin
                  tabStop:= False;
               end;
            end;
            DoOnAfterCreateControl(RecordViewForm, curField, checkbox);

            curFieldEditWidth := checkbox.Width;
            MaxEditWidth:= wwmax(MaxEditWidth, checkbox.Width);
            LastEditHeight:= wwMax(LastEditHeight,checkbox.Height);
         end
         else if (rvoUseCustomControls in Options) and
            IsCustomEditCell(wwGetOwnerForm(self), curField, customEdit) then
         with TEdit(CustomEdit) do begin
            AddCustomControl(CustomEdit);

            parent:= ScrollBox;
            visible:= True;
            if not wwSetControlDataSource(customEdit, datasource) then continue;
            if not wwSetControlDataField(customEdit, curField.fieldName) then continue;
            Ctl3d:= True;
            BorderStyle:= bsSingle;
            left:= EditStartOffset+curLineWidth;
            top:= PrevTop+EditSpacing.HorizontalView.BetweenLabelEdit+curlabel.Height;

            if wwIsClass(customedit.classtype,'TwwCustomRichEdit') and
               (rvoMaximizeMemoWidth in Options) then
               Width:= wwMax(OrigMaxEditWidth, FixedEditWidth)
            else
               Width:= (curFieldDisplayWidth+1) * Canvas.TextWidth('0') + 3;

            if rvoShortenEditBox in Options then begin
               if Width>FixedEditWidth then Width:= FixedEditWidth;
            end;

            TEdit(CustomEdit).HandleNeeded;
            FControlList.add(CustomEdit);

            DoOnAfterCreateControl(RecordViewForm, curField, customEdit);

            curFieldEditWidth := customEdit.Width;
            MaxEditWidth:= wwmax(MaxEditWidth, customEdit.Width);
            LastEditHeight:= wwMax(LastEditHeight,customEdit.Height);
         end
         else if curField is TMemoField then begin
            dbMemo:= TDBMemo.create(Scrollbox);
            with dbMemo do begin
               parent:= ScrollBox;
               datasource:= self.DataSource;
               datafield:= curField.FieldName;
               if (rvoEnterToTab in Options) then
                  TMemo(dbMemo).WantReturns := False;

               if (rvoMaximizeMemoWidth in Options) then begin
                  left:= EditStartOffset;
                  Top:= PrevTop+EditSpacing.HorizontalView.BetweenLabelEdit+curlabel.Height;
                  Width:= wwMax(OrigMaxEditWidth, FixedEditWidth);
               end
               else begin
                  left:= EditStartOffset+curLineWidth;
                  top:= PrevTop+EditSpacing.HorizontalView.BetweenLabelEdit+curlabel.Height;
                  Width:= (curFieldDisplayWidth+1) * Canvas.TextWidth('0') + 3;
               end;

               if (rvoShortenEditBox in Options) and (Width>FixedEditWidth) then Width:= FixedEditWidth;

               Height:= Canvas.TextHeight('0') * 2 + 8; {2 lines of Memo}
               if Field.readonly then enabled:=False;
               OnKeyDown:= DBMemoKeyDown;
            end;
            FControlList.add(dbMemo);

            DoOnAfterCreateControl(RecordViewForm, curField, dbMemo);


            curFieldEditWidth := dbMemo.Width;
            MaxEditWidth:= wwmax(MaxEditWidth, dbMemo.Width);
            LastEditHeight := wwMax(LastEditHeight,dbMemo.Height);
         end
         else begin
            wwDBEdit:= TwwDBEdit.create(Scrollbox);
            with wwDBEdit do begin
               parent:= ScrollBox;
               datasource:= self.DataSource;
               datafield:= curfield.fieldName;
               left:= EditStartOffset+curLineWidth;
               Top:= PrevTop+EditSpacing.HorizontalView.BetweenLabelEdit+ curlabel.Height;

               Width:= (curFieldDisplayWidth+1) * Canvas.TextWidth('0') + 3;
               if Width>FixedEditWidth then begin
                  if rvoShortenEditBox in Options then
                     Width:= FixedEditWidth
               end;
               if Field.readonly or Field.calculated then
               begin
                  wwDBEdit.color:= ReadOnlyColor;
                  wwDBEdit.tabStop:= False;
               end
            end;
            FControlList.add(wwDBEdit);
            DoOnAfterCreateControl(RecordViewForm, curField, wwDBEdit);

            curFieldEditWidth := wwDBEdit.Width;
            MaxEditWidth:= wwmax(MaxEditWidth, wwDBEdit.Width);
            LastEditHeight:= wwMax(LastEditHeight,wwDBEdit.Height);
         end;
         curLineWidth := curLineWidth + wwmax(curFieldEditWidth,curFieldLabelWidth)+
                         EditSpacing.HorizontalView.BetweenEditsInRow;
         realMaxLineWidth:= wwmax(realMaxLineWidth, curLineWidth - EditSpacing.HorizontalView.BetweenEditsInRow);
      end;

      CreateMainMenu(RecordViewForm, self.menu);
      PrevTop := PrevTop + EditSpacing.HorizontalView.BetweenLabelEdit +
                 LastEditHeight + LastLabelHeight + Margin.BottomOffset; {New Top Value}

      EditHeight := LastEditHeight;

      FormHeight:= (PrevTop  + RecordPanel.Top)+ 21+getsystemmetrics(SM_CYCAPTION) + ButtonPanelHeight;

      if (self.menu<>nil) and (BorderStyle<>bsDialog) then
         FormHeight:= FormHeight +  GetSystemMetrics(SM_CYMENU);
      if FormPosition.height>0 then Height:= wwMin(FormPosition.Height, FormHeight)
      else Height:= FormHeight;

      { Adjust width/height based on visibility of scrollbars }
      if Height>ARect.Bottom-ARect.Top-12 then Height:= ARect.Bottom-ARect.Top-12;
      ScrollBox.VertScrollBar.Margin:= 6;
      ScrollBox.VertScrollBar.Increment:= EditHeight + EditSpacing.HorizontalView.BetweenRow;
      ScrollBox.VertScrollBar.Range := PrevTop;
      if (RecordPanel.Height-12)<PrevTop then Width:= Width + GetSystemMetrics(SM_CXHThumb);

      FormWidth:= RecordPanel.Left + ScrollBox.left + EditStartOffset + RealMaxLineWidth +
                  (FixedEditWidthConst-6) + Margin.RightOffset;
      if Width>ARect.Right-ARect.Left then Width:= ARect.Right-ARect.Left;

      if Width<FormWidth then
         Height:= Height + GetSystemMetrics(SM_CYVThumb)
      else begin
         Width:= FormWidth; { shrink form to reduce space at the right }
         if (RecordPanel.Height-12)<PrevTop then
            Width:= Width + GetSystemMetrics(SM_CXHThumb);
      end;
      ScrollBox.HorzScrollBar.Margin:= 6;
      ScrollBox.HorzScrollBar.Range := EditStartOffset + MaxEditWidth + Margin.RightOffset;

      if (rvokShowOKCancel in OKCancelOptions) then begin
        ButtonPanel.Width := Width;
        OKBtn.Left:= (ButtonPanel.Width - 10) - ((OKBtn.Width + Spacing) * 2);
        CancelBtn.Left:= (ButtonPanel.Width-10) - ((OKBtn.Width + Spacing) * 1);
      end;
   end
end;

{*****************************************************}


Function TwwRecordViewDialog.Execute: boolean;
var ARect:TRect;
    bottompad:integer;
    i: integer;
begin
   Result := false;
   if (datasource=nil) or (datasource.dataset=nil) then begin
      MessageDlg('DataSource or DataSource.DataSet not defined.', mtWarning, [mbok], 0);
      exit;
   end;

   if not (datasource.dataset.active) then begin
      MessageDlg('DataSet must be active.', mtWarning, [mbok], 0);
      exit;
   end;

   CloseAction := rvcControlMenuClose;

   if RecordViewForm<>Nil then
   begin
      RecordViewForm.show;
      exit;
   end
   else begin
      RecordViewForm:= TwwRecordViewForm.create(Application);
      RecordViewForm.BorderStyle:= BorderStyle;
      RecordViewForm.DlgComponent:= self;
   end;

   FControlList.clear;

   with RecordViewForm do begin
      Caption:= self.caption;

      Font.Assign(self.font);
      KeyPreview:= True;
{      OnKeyDown:= FormKeyDown;}
      OnShow:= FormShow;
      OnClose:= FormClose;
      OnCloseQuery:=FormCloseQuery;

      if not (rvoHideNavigator in Options) then begin
         NavigatorPanel:= TPanel.create(RecordViewForm);
         with NavigatorPanel do begin
           Parent:= RecordViewForm;
           Left := 0;
           Top := 0;
           Align := alTop;
           TabOrder := 0;
         end;
         Navigator:= TDBNavigator.create(NavigatorPanel);
         with Navigator do begin
           Parent:= NavigatorPanel;    {!!!!! Changed from RecordViewForm}
           Left := 8;
           Top := 8;
           Width := 240;
           Height := 25;
           DataSource := self.DataSource;
           TabOrder := 0;
           ShowHint:= True;
           {$ifdef ver100}
           Flat:= NavigatorFlat;
           if Flat then begin
              Top:= 1;
              NavigatorPanel.height:= height+2;
           end
           {$endif}
         end;
         Navigator.VisibleButtons:= FNavigatorVisibleButtons;
      end
      else begin
      end;

      RecordPanel:= TPanel.create(RecordViewForm);
      with RecordPanel do begin
         parent:= RecordViewForm;
         Left := 0;
         Top := 41;
         Align := alClient;
         BevelInner := bvLowered;
         BorderWidth := 4;
         Caption := '';
         TabOrder := 1;
         Name:= 'RecordPanel';
         visible:= True;
      end;


      if (rvokShowOKCancel in OKCancelOptions) then begin
         ButtonPanel:= TPanel.create(RecordViewForm);
         with ButtonPanel do begin
            parent:= RecordViewForm;
            Left := 0;
            Top := 0;
            Align := alBottom;
            Name:= 'UserPanel';
            Caption := '';
            TabOrder := 0;
            visible:= True;

            OkBtn:= TButton(wwCreateCommonButton(RecordViewForm, bkOK));
            OKBtn.Default:= not (rvoEnterToTab in Options);
            OkBtn.parent:= ButtonPanel;
            OKBtn.visible:= True;
            OKBtn.OnClick := OKBtnClick;
            OKBtn.TabStop:= False;

            CancelBtn:= TButton(wwCreateCommonButton(RecordViewForm, bkCancel));
            CancelBtn.Parent := ButtonPanel;
            CancelBtn.visible:= True;
            CancelBtn.OnClick := CancelBtnClick;
            CancelBtn.TabStop:= False;
            CancelBtn.Cancel:= False; { Allows Escape to be processed }

            bottomPad := 1 + GetSystemMetrics(SM_CYDLGFRAME)*2 +8 +1;  {Win95 fix }
            Height := OkBtn.Top + OkBtn.height + BottomPad;

            OkBtn.Top := GetSystemMetrics(SM_CYDLGFRAME) + 5;
            CancelBtn.Top := GetSystemMetrics(SM_CYDLGFRAME) +5;
         end;
      end;

      ScrollBox:= TScrollBox.create(RecordPanel);
      with ScrollBox do begin
         parent:= RecordPanel;
         Left := 6;
         Top := 6;
         Align := alClient;
         AutoScroll := False;
         BorderStyle := bsNone;
         TabOrder := 0;
         visible:= True;
      end;

      if (Style = rvsVertical) then
         DisplayVertical
      else
         DisplayHorizontal;

      { 5/21/97 - Reset modified flag to False }
      for i:= 0 to FControlList.count-1 do begin
         TCustomEdit(FControlList.items[i]).Modified := False;
      end;

      { Position form on screen }
      ARect := wwGetWorkingRect;

      if FormPosition.Left>0 then Left:= FormPosition.Left
      else Left:= ARect.Left+(((ARect.Right-ARect.Left) - RecordViewForm.Width) div 2);

      if FormPosition.Top>0 then Top:= FormPosition.Top
      else Top:= ARect.Top+ (((ARect.Bottom-ARect.Top)-RecordViewForm.height) div 2);

      OnResize:= FormResize;

      if rvoModalForm in Options then begin
         result:= ShowModal=mrOK;
         Free;
      end
      else begin
         Show;
         ModalResult := mrCancel;
         result:= True;
      end;
   end;

end;

procedure TwwRecordViewDialog.FormClose(Sender: TObject; var Action: TCloseAction);
var i: integer;
    customEdit: TCustomEdit;
    customItem: TwwCustomControlItem;
begin
   if (Sender is TForm) then with (Sender as TForm) do begin

      DoCloseDialog(Sender as TwwRecordViewForm);

      if (rvokAutoCancelRec in OKCancelOptions) and (ModalResult = mrCancel) then
      begin
         DataSource.DataSet.Cancel;
      end
      else begin
         if (ActiveControl is TCustomEdit) then ActiveControl.Perform(CM_Exit,0,0);
         if (rvokAutoPostRec in OKCancelOptions) and (ModalResult = mrOK) then
         begin
            Datasource.Dataset.CheckBrowseMode
         end
      end;


     { if (ModalResult = mrOK) then showmessage('OK');
      if (ModalResult = mrCancel) then showmessage('Cancel'); }

{      if (rvokAutoPostOnOK in OKCancelOptions) and (CloseAction = rvcOK) then
            Datasource.Dataset.CheckBrowseMode
      else if (rvokAutoCancelOnCancel in OKCancelOptions) and (CloseAction = rvcCancel) then
            Datasource.Dataset.Cancel;}
{      if CloseAction=? then
         ModalResult:= ?;}

      Menu:= Nil;
   end;

   if not (rvoModalForm in Options) then
   begin
      Action:= caFree;
   end;
   RecordViewForm.DlgComponent:= nil;
   RecordViewForm:= nil;

   for i:= 0 to CustomControlList.count-1 do begin
      customItem:= TwwCustomControlItem(CustomControlList[i]);
      customEdit:= customItem.control;
      customEdit.parent:= wwGetOwnerForm(self);
      customEdit.visible:= False;
      customEdit.left:= customItem.left;
      customEdit.Top:= customItem.Top;
      customEdit.Width:= customItem.Width;
      customEdit.Height:= customItem.Height;
      if not (csDesigning in ComponentState) then
      begin
         TEdit(customEdit).ctl3d:= False;
         TEdit(customEdit).BorderStyle:= bsNone;
      end
   end;

end;

procedure TwwRecordViewDialog.FormResize(Sender: TObject);
var i :integer;
    FixedEditWidth: integer;
    minwidth:integer;
begin
   if (rvoConsistentEditWidth in Options) and (Style=rvsVertical) then begin
     FixedEditWidth:= (Sender as TForm).width - (EditStartOffset + FixedEditWidthConst + Margin.RightOffset);
     if (Sender as TForm).Height < FormHeight then
        dec(FixedEditWidth, GetSystemMetrics(SM_CXHThumb));
     for i:= 0 to FControlList.count-1 do begin
        TEdit(FControlList.items[i]).width:= FixedEditWidth;
     end;
   end;

   if (rvokShowOKCancel in OKCancelOptions) then begin
      minWidth:= OkBtn.width + CancelBtn.width + 2*Spacing + 5;

      OKBtn.Left:= ((Sender as TForm).Width - 10) - ((OKBtn.Width + spacing) * 2);
      CancelBtn.Left:= ((Sender as TForm).Width - 10) - ((OKBtn.Width + Spacing) * 1);

      if ((Sender as TForm).width -10 < minWidth) then begin
         OkBtn.Left:= 5;
         CancelBtn.Left := OkBtn.Width + 5 + Spacing;
      end;
   end;

end;

procedure TwwRecordViewDialog.OKBtnClick(Sender: TObject);
begin
   CloseAction := rvcOK;
   RecordViewForm.ModalResult:=mrOK;
   RecordViewForm.Close;
end;

procedure TwwRecordViewDialog.CancelBtnClick(Sender: TObject);
begin
   CloseAction := rvcCancel;
   RecordViewForm.ModalResult:=mrCancel;
   RecordViewForm.Close;
end;

Procedure TwwRecordViewDialog.CreateMainMenu(
   Form: TwwRecordViewForm; mm: TMainMenu);
begin
   if (mm=nil) or (mm.items.count=0) then exit;
   Form.Menu:= mm;
end;


procedure TwwRecordViewDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin

  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil

  else if (Operation=opRemove) and (Menu=AComponent) then
  begin
     Menu:= nil;

     with wwGetOwnerForm(Self) do begin
        if (Designer<>Nil) then begin
           Designer.Notification(AComponent, Operation);
        end
     end
  end;
end;


Function TwwRecordViewDialog.IsModified: boolean;
var i: integer;
begin
   result := false;
   for i:= 0 to FControlList.count-1 do begin
      if (TCustomEdit(FControlList.items[i]).Modified) then
         result := True;
   end;
end;

procedure TwwRecordViewDialog.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var answer: integer;
begin
   if CloseAction=rvcControlMenuClose then begin
      if not (rvoCloseIsCancel in Options) then RecordViewForm.ModalResult:= mrOK;
   end
   else if CloseAction=rvcOK then begin
      RecordViewForm.ModalResult:= mrOK;
      exit;
   end;

   if RecordViewForm.ModalResult=mrOK then exit;

   if ((IsModified) or
        { 5/27/97 - Confirm cancel if record was changed before entering dialog}
       (rvokAutoCancelRec in OKCancelOptions) and (DataSource.DataSet.state<>dsBrowse))
      and (rvoConfirmCancel in Options) then
   begin
      if Assigned(FOnCancelWarning) then
         DoCancelWarning(CanClose)
      else begin
         answer:= MessageDlg(wwInternational.UserMessages.RecordViewExitWarning,
               mtConfirmation, [mbYes, mbNo, mbCancel], 0);

         if (answer = mrYes) then begin
            RecordViewForm.ModalResult:= mrOK;
         end
         else if (answer = mrNo) then begin
            RecordViewForm.ModalResult:= mrCancel;
         end
         else CanClose:= False;
      end
   end
   else RecordViewForm.ModalResult:= mrCancel;

end;

procedure TwwRecordViewForm.FormDeactivate(Sender: TObject);
var WinAttribute: HWnd;
begin
   if (DlgComponent<>Nil) and (rvoStayOnTopForm in (DlgComponent as TwwRecordViewDialog).Options) then
   begin
      WinAttribute:= HWND_TOPMOST;
      SetWindowPos(Handle, WinAttribute, 0, 0, 0, 0,
        SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
      ActiveControl.invalidate;  { Windows redraw bug for focused control }
      Deactivated:= True;
   end
end;

procedure TwwRecordViewForm.FormActivate(Sender: TObject);
var WinAttribute: HWnd;
begin
   if Deactivated then begin
      WinAttribute:= HWND_NOTOPMOST;
      SetWindowPos(Handle, WinAttribute, 0, 0, 0, 0,
        SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
      Deactivated:= False;
   end
end;

procedure TwwRecordViewDialog.wwMemoDialogInitDialog(Dialog: TwwMemoDlg);
begin
   Dialog.Memo.selStart:= (RecordViewForm.ActiveControl as TDBMemo).selStart;
   Dialog.Memo.Font.Assign((RecordViewForm.ActiveControl as TDBMemo).Font);
end;

procedure TwwRecordViewDialog.DBMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var curField: TField;
begin
   if (key=vk_f2) then begin
      with (Sender as TDBMemo) do
         curField:= datasource.dataset.findField(datafield);
      if curField<>Nil then begin
         with TwwMemoDialog.create(self) do begin
            datasource:= (Sender as TDBMemo).datasource;
            dataField:= curfield.fieldName;
            caption:= dataField;
            OnInitDialog:= wwMemoDialogInitDialog;
            if (Sender as TDBMemo).modified then
               curfield.assign((Sender as TDBMemo).Lines); {Flush to tfield }
            Execute;
            Free;
         end;
         key:= 0;
      end
   end
end;

procedure TwwLabel.WMPaint(var Message: TWMPaint);
var ARect: TRect;
begin
   inherited;
   if (FocusControl<>Nil) and FocusControl.Focused then
   begin
      ARect := GetClientRect;
      Canvas.Pen.Color:= clGray;
      Canvas.Pen.Width:= 1;
      Canvas.Pen.Style:= psDot;
      Canvas.Polygon([Point(ARect.Left, ARect.Top), Point(ARect.Left, ARect.Bottom-1),
                      Point(ARect.Right-1, ARect.Bottom-1), Point(ARect.Right-1, ARect.Top)]);
{      Canvas.Brush.Color:= clBlack;
      Canvas.Brush.Style:= bsVertical;
      Canvas.FrameRect(ARect);}
   end
end;


procedure TwwDBCheckBox.DoEnter;
begin
   labelControl.invalidate;
end;

procedure TwwDBCheckBox.DoExit;
begin
   labelControl.invalidate;
end;


end.
