unit wwriched;
{
//
// Component : TwwDBRichEdit
//
// Copyright (c) 1995, 1996, 1997 by Woll2Woll Software
//
}
interface

uses
  WinProcs, WinTypes, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, RichEdit, menus, dbctrls, db, wwstr, wwcommon, printers,
  dbtables, wwintl;

const wwLogXPixelsPerInch = 72;

type
  TwwRichEditWidth=(rewWindowSize, rewPrinterSize);
  TwwOnRichEditDlgEvent = procedure(Form : TForm) of object;
  TwwMeasurementUnits=(muInches, muCentimeters);
  TwwRichEditParaOption=(rpoAlignment, rpoBullet,
                         rpoLeftIndent, rpoRightIndent, rpoFirstLineIndent, rpoTabs);
  TwwRichEditParaOptions=Set of TwwRichEditParaOption;
  TwwRichEditPopupOption=(rpoPopupEdit, rpoPopupCut, rpoPopupCopy, rpoPopupPaste,
       rpoPopupBold, rpoPopupItalic, rpoPopupUnderline,
       rpoPopupFont, rpoPopupBullet, rpoPopupParagraph, rpoPopupTabs,
       rpoPopupFind, rpoPopupReplace
        );
  TwwRichEditPopupOptions=Set of TwwRichEditPopupOption;

  TwwRichEditOption=(reoShowLoad, reoShowSaveAs, reoShowSaveExit, reoShowPrint, reoShowPageSetup,
                     reoShowFormatBar, reoShowToolBar, reoShowStatusBar, reoShowHints, reoCloseOnEscape);
  TwwRichEditOptions=Set of TwwRichEditOption;

  TwwPrintMargins = class(TPersistent)
  private
     FTop, FBottom, FLeft, FRight: Double;
  public
     Procedure Assign(Source: TPersistent); override;
     constructor Create(AOwner: TComponent); virtual;

  published
     property Top: Double read FTop write FTop;
     property Bottom: Double read FBottom write FBottom;
     property Left : Double read FLeft write FLeft;
     property Right : Double read FRight write FRight;
  end;

  TwwCustomRichEdit = class(TCustomRichEdit)
  private
     FWordWrap: boolean;
     FPrintMargins: TwwPrintMargins;
     FPrintPageSize: integer;
     FEditWidth: TwwRichEditWidth;
     StartingFindPos: integer;
     InResetToStart: boolean;
     DefaultPopupMenu: TPopupMenu;
     PopupEdit, PopupCut, PopupCopy, PopupPaste,
     PopupBold, PopupItalic, PopupUnderline,
     PopupFont, PopupBullet, PopupParagraph, PopupTabs,
     PopupFind, PopupReplace,
     PopupSep1, PopupSep2, PopupSep3, PopupSep4: TMenuItem;
     FPopupOptions: TwwRichEditPopupOptions;
     FEditorOptions: TwwRichEditOptions;
     FEditorCaption: string;
     LastSearchText: string;
     FUnits: TwwMeasurementUnits;
     FOnInitDialog: TwwOnRichEditDlgEvent;
     FOnCloseDialog: TwwOnRichEditDlgEvent;
     FScreenLogPixels : integer;
     FLastSetRect: TRect;
     OrigHideSelection: boolean;

     procedure FindDialog1Close(Sender: TObject);
     procedure FindDialog1Find(Sender: TObject);
     Procedure FindReplaceDlg(
        dialog: TFindDialog; replace: boolean;
        replaceStr: string);
     procedure ReplaceDialog1Replace(Sender: TObject);
     Procedure CreatePopup;
     procedure PopupMenuPopup(Sender: TObject);
     procedure PopupEditclick(Sender: TObject);
     procedure PopupCutClick(Sender: TObject);
     procedure PopupCopyClick(Sender: TObject);
     procedure PopupPasteClick(Sender: TObject);
     procedure PopupFontClick(Sender: TObject);
     procedure PopupParagraphClick(Sender: TObject);
     procedure PopupTabsClick(Sender: TObject);
     procedure PopupBulletClick(Sender: TObject);
     procedure PopupBoldClick(Sender: TObject);
     procedure PopupItalicClick(Sender: TObject);
     procedure PopupUnderlineClick(Sender: TObject);
     procedure PopupFindClick(Sender: TObject);
     procedure PopupReplaceClick(Sender: TObject);
     procedure SetWordWrap(val: boolean);
     procedure CreateRuntimeComponents;
     procedure SetPrintPageSize(val: integer);

  protected
     BoundMode: boolean;
     procedure WriteState(Writer: TWriter); override;
     procedure ReadState(Reader: TReader); override;
     procedure Loaded; override;
     procedure CreateParams(var Params: TCreateParams); override;
     procedure EMFormatRange(var msg:TMessage); message EM_FORMATRANGE;
     procedure SelectionChange; override;
     procedure WMSize(var msg:twmsize); message wm_size;
     function GetReadOnly: Boolean; virtual;
     procedure BeginEditing; virtual;
     procedure UpdateField; virtual;
  public
     FindDialog1: TFindDialog;
     ReplaceDialog1: TReplaceDialog;
     FontDialog1: TFontDialog;
     GutterWidth: integer;

     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
     function Execute: boolean; virtual;  { shows dialog }
     procedure ExecuteFindDialog; virtual;
     procedure ExecuteReplaceDialog; virtual;
     procedure ExecuteFontDialog; virtual;
     procedure ExecuteParagraphDialog; virtual;
     procedure ExecuteTabDialog; virtual;

     Procedure FindNextMatch; virtual;
     Procedure FindReplace; virtual;

     procedure SetBullet(val: boolean);
     procedure SetBold(val: boolean);
     procedure SetItalic(val: boolean);
     procedure SetUnderline(val: boolean);
     Function CanPaste: boolean;
     Function CanUndo: boolean;
     Function CanCut: boolean;
     Function CanFindNext: boolean;

     Procedure CopyRichEditTo(val: TCustomRichEdit);
     Procedure SetRichEditFontAttributes(
          FontName: string; FontSize: integer; FontStyle: TFontStyles;
          FontColor: TColor);
     function GetCharSetOfFontName(const FaceName : string) : integer;
     procedure GetParaIndent(var LeftIndent, RightIndent, FirstIndent: integer);
     procedure SetParaFormat(
          Options: TwwRichEditParaOptions;
          alignment: string;
          bulletStyle: boolean;
          leftindent, rightindent, firstlineindent: integer;
          tabCount: integer; tabArray: Pointer);
     procedure GetParaFormat(var Format: TParaFormat);
     Function UnitStrToTwips(str: string): integer;  { Convert to twips }
     Function FormatUnitStr(val: double): string;  { Append units to number }
     Function TwipsToUnits(val: integer): double;
     Procedure DoInitDialog(Form: TForm); virtual;
     Procedure DoCloseDialog(Form: TForm); virtual;
     Procedure SetEditRect;
     procedure Print(const Caption: string);
     Procedure UpdatePrinter;

{ to be published}
    property PopupOptions: TwwRichEditPopupOptions read FPopupOptions write FPopupOptions default
        [rpoPopupEdit, rpoPopupCut, rpoPopupCopy, rpoPopupPaste,
         rpoPopupFind, rpoPopupReplace, rpoPopupBullet, rpoPopupFont, rpoPopupParagraph, rpoPopupTabs];
    property EditorOptions: TwwRichEditOptions read FEditorOptions write FEditorOptions default
           [reoShowSaveExit, reoShowPrint, reoShowPageSetup,
            reoShowFormatBar, reoShowToolbar, reoShowStatusBar, reoShowHints, reoCloseOnEscape];

    property EditorCaption : string read FEditorCaption write FEditorCaption;
    property MeasurementUnits: TwwMeasurementUnits read FUnits write FUnits;
    property OnInitDialog: TwwOnRichEditDlgEvent read FOnInitDialog write FOnInitDialog;
    property OnCloseDialog: TwwOnRichEditDlgEvent read FOnCloseDialog write FOnCloseDialog;
    property PrintMargins: TwwPrintMargins read FPrintMargins write FPrintMargins;
    property EditWidth: TwwRichEditWidth read FEditWidth write FEditWidth default rewWindowSize;
    property PrintPageSize : integer read FPrintPageSize write SetPrintPageSize;

    {Override so inherited wordwrap is not used in WriteState}
    property WordWrap : boolean read FWordWrap write SetWordWrap default True;
    property PlainText;
  published
    property Lines;  { Required to be published for proper streaming }

  end;

{  TwwRichEdit = class(TwwCustomRichEdit)
  published
    property PopupOptions;
    property EditorOptions;
    property EditorCaption;
    property MeasurementUnits;
    property PrintMargins;
    property EditWidth;
    property OnInitDialog;
    property OnCloseDialog;

    property Align;
    property Alignment;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HideScrollBars;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property WantTabs;
    property WantReturns;
    property WordWrap;
    property OnChange;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResizeRequest;
    property OnSelectionChange;
    property OnStartDrag;
    property OnProtectChange;
    property OnSaveClipboard;
  end;
}
  TwwDBRichEdit = class(TwwCustomRichEdit)
  private
    FDataLink: TFieldDataLink;
    FAutoDisplay: Boolean;
    FFocused: Boolean;
    FMemoLoaded: Boolean;
    FDataSave: string;
    Function isBlob: boolean;
    procedure BeginEditing; override;
    procedure DataChange(Sender: TObject);
    procedure EditingChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure SetReadOnly(Value: Boolean);
    procedure SetAutoDisplay(Value: Boolean);
    procedure SetFocused(Value: Boolean);
    procedure UpdateData(Sender: TObject);
    procedure WMCut(var Message: TMessage); message WM_CUT;
    procedure WMPaste(var Message: TMessage); message WM_PASTE;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    procedure Change; override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    function GetReadOnly: Boolean; override;
    procedure UpdateField; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadMemo;
    property Field: TField read GetField;
  published
    property Align;
    property Alignment;
    property AutoDisplay: Boolean read FAutoDisplay write SetAutoDisplay default True;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property HideScrollBars;
    {$ifdef ver100}
    property ImeMode;
    property ImeName;
    {$endif}
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
{    property PlainText;}
    property PopupMenu;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResizeRequest;
    property OnSelectionChange;
    property OnProtectChange;
    property OnSaveClipboard;
    property OnStartDrag;

    property PopupOptions;
    property EditorOptions;
    property EditorCaption;
    property MeasurementUnits;
    property PrintMargins;
    property EditWidth;
    property OnInitDialog;
    property OnCloseDialog;

  end;


procedure Register;

implementation

uses wwrich, wwrchdlg, wwrichtb;


{ TwwDBRichEdit }

constructor TwwDBRichEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoDisplay := True;
  FDataLink := TFieldDataLink.Create;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnEditingChange := EditingChange;
  FDataLink.OnUpdateData := UpdateData;
end;

destructor TwwDBRichEdit.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TwwDBRichEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

procedure TwwDBRichEdit.BeginEditing;
begin
  if (FDataLink.Field=Nil) then exit;
  if not FDataLink.Editing then
  try
    if isBlob then
      FDataSave := FDataLink.Field.AsString;
    FDataLink.Edit;
  finally
    FDataSave := '';
  end;
end;

procedure TwwDBRichEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (key=vk_f2) and (rpoPopupEdit in PopupOptions) {and not visible }then
  begin
     Execute;
     key:= 0;
  end;

  if (FDataLink.Field=Nil) then exit;
  if FMemoLoaded then
  begin
    if (Key = VK_DELETE) or (Key = VK_BACK) or
      ((Key = VK_INSERT) and (ssShift in Shift)) or
      (((Key = Ord('V')) or (Key = Ord('X'))) and (ssCtrl in Shift)) then
      BeginEditing;
  end;
end;

procedure TwwDBRichEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (FDataLink.Field=Nil) then exit;
  if FMemoLoaded then
  begin
    if (Key in [#32..#255]) and (FDataLink.Field <> nil) and
      not FDataLink.Field.IsValidChar(Key) then
    begin
      MessageBeep(0);
      Key := #0;
    end;
    case Key of
      ^H, ^I, ^J, ^M, ^V, ^X, #32..#255:
        BeginEditing;
      #27:
        FDataLink.Reset;
    end;
  end else
  begin
    if Key = #13 then LoadMemo;
    Key := #0;
  end;
end;

procedure TwwDBRichEdit.Change;
begin
  if (FDataLink.Field<>Nil) then
  begin
     if FMemoLoaded then
        if FDataLink.Editing then {5/10/97}
           FDataLink.Modified;
     FMemoLoaded := True;
  end;
  inherited Change;
end;

function TwwDBRichEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TwwDBRichEdit.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TwwDBRichEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TwwDBRichEdit.SetDataField(const Value: string);
begin
  if (Value<>'') then begin
     if  (Value<>FDataLink.FieldName) then
        inherited ReadOnly := True;
     BoundMode:= True;
  end
  else BoundMode:= False;
  FDataLink.FieldName := Value;
end;

function TwwDBRichEdit.GetReadOnly: Boolean;
begin
  if (FDataLink.Field=Nil) then result:= inherited ReadOnly
  else Result := FDataLink.ReadOnly;
end;

procedure TwwCustomRichEdit.BeginEditing;
begin
end;

procedure TwwCustomRichEdit.UpdateField;
begin
end;

function TwwCustomRichEdit.GetReadOnly: Boolean;
begin
   result:= inherited ReadOnly
end;

procedure TwwDBRichEdit.SetReadOnly(Value: Boolean);
begin
  if (FDataLink.Field=Nil) then inherited ReadOnly:= Value
  else FDataLink.ReadOnly := Value;
end;

function TwwDBRichEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TwwDBRichEdit.LoadMemo;
begin
  if (FDataLink.Field=Nil) then exit;
  if not FMemoLoaded and Assigned(FDataLink.Field) and isBlob then
  begin
    try
      Lines.Assign(FDataLink.Field);
      FMemoLoaded := True;
    except
      { Rich Edit Load failure }
      on E:EOutOfResources do
        Lines.Text := Format('(%s)', [E.Message]);
    end;
    EditingChange(Self);
    modified:= False; { 5/10/97}
  end;
end;

procedure TwwDBRichEdit.DataChange(Sender: TObject);
begin
  if FDataLink.Field <> nil then begin
    if isBlob then
    begin
      if FAutoDisplay or (FDataLink.Editing and FMemoLoaded) then
      begin
        { Check if the data has changed since we read it the first time }
        if (FDataSave <> '') and (FDataSave = FDataLink.Field.AsString) then Exit;
        FMemoLoaded := False;
        LoadMemo;
      end else
      begin
        Text := Format('(%s)', [FDataLink.Field.DisplayLabel]);
        FMemoLoaded := False;
      end;
    end
    else begin
      if FFocused and FDataLink.CanModify then
        Text := FDataLink.Field.Text
      else
        Text := FDataLink.Field.DisplayText;
      FMemoLoaded := True;
    end
  end
  else begin
    if csDesigning in ComponentState then Text := Name else Text := '';
    FMemoLoaded := False;
  end;

  if HandleAllocated then
    RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_FRAME);
end;

procedure TwwDBRichEdit.EditingChange(Sender: TObject);
begin
  if (FDataLink.Field=Nil) then exit;
  inherited ReadOnly := not (FDataLink.Editing and FMemoLoaded);
end;

procedure TwwDBRichEdit.UpdateData(Sender: TObject);
begin
   UpdateField;
end;

procedure TwwDBRichEdit.UpdateField;
begin
  if (FDataLink.Field=Nil) then exit;
  if IsBlob then
    FDataLink.Field.Assign(Lines) else
    FDataLink.Field.AsString := Text;
end;

procedure TwwDBRichEdit.SetFocused(Value: Boolean);
begin
  if (FDataLink.Field=Nil) then exit;
  if FFocused <> Value then
  begin
    FFocused := Value;
    if not Assigned(FDataLink.Field) or not isBlob then
      FDataLink.Reset;
  end;
end;

procedure TwwDBRichEdit.CMEnter(var Message: TCMEnter);
begin
  if (FDataLink.Field<>Nil) then SetFocused(True);
  inherited;
end;

procedure TwwDBRichEdit.CMExit(var Message: TCMExit);
begin
  if (FDataLink.Field<>Nil) then begin
    try
      FDataLink.UpdateRecord;
    except
      SetFocus;
      raise;
    end;
    SetFocused(False);
  end;
  inherited;
end;

procedure TwwDBRichEdit.SetAutoDisplay(Value: Boolean);
begin
  if (FDataLink.Field=Nil) then exit;
  if FAutoDisplay <> Value then
  begin
    FAutoDisplay := Value;
    if Value then LoadMemo;
  end;
end;

procedure TwwDBRichEdit.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if (FDataLink.Field<>Nil) and (not FMemoLoaded) then LoadMemo
  else inherited;
end;

procedure TwwDBRichEdit.WMCut(var Message: TMessage);
begin
  if (FDataLink.Field<>Nil) then BeginEditing;
  inherited;
end;

procedure TwwDBRichEdit.WMPaste(var Message: TMessage);
begin
  if (FDataLink.Field<>Nil) then BeginEditing;
  inherited;
end;

procedure TwwDBRichEdit.CMGetDataLink(var Message: TMessage);
begin
  if (FDataLink.Field=Nil) then exit;
  Message.Result := Integer(FDataLink);
end;

{****}

function EnumFontProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
         FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  PWord(Data)^ := LogFont.lfCharSet;
  Result := 0;
end;

function TwwCustomRichEdit.GetCharSetOfFontName(const FaceName : string) : integer;
var
  Flag: Word;
  DC: HDC;
begin
  result := -1;
  Flag := $8000;
  DC := GetDC(0);
  EnumFontFamilies(DC, PChar(FaceName), @EnumFontProc, LPARAM(@Flag));
  ReleaseDC(0, DC);
  if Flag <> $8000 then
    Result := LoByte(Flag);
end;

constructor TwwCustomRichEdit.Create(AOwner: TComponent);
var DC: HDC;
begin
   inherited Create(AOwner);

   EditWidth:= rewWindowSize;
   FPrintMargins:=  TwwPrintMargins.create(self);
   PrintPageSize:= 2;

   PopupOptions:= [rpoPopupEdit, rpoPopupCut, rpoPopupCopy, rpoPopupPaste,
         rpoPopupFind, rpoPopupReplace,
         rpoPopupBullet, rpoPopupFont, rpoPopupParagraph, rpoPopupTabs];

   EditorOptions:=
         [reoShowSaveExit, reoShowPrint, reoShowPageSetup,
            reoShowFormatBar, reoShowToolbar, reoShowStatusBar, reoShowHints, reoCloseOnEscape];

   EditorCaption:= 'Edit Rich Text';
   FWordWrap:= True;
   FUnits:= muInches;

   CreateRunTimeComponents;

   DC := GetDC(0);
   FScreenLogPixels := GetDeviceCaps(DC, LOGPIXELSY);
   ReleaseDC(0, DC);

end;

procedure TwwCustomRichEdit.CreateRunTimeComponents;
begin
   if (csDesigning in Componentstate) then exit;

   FindDialog1:= TFindDialog.create(self);
   with FindDialog1 do begin
     Options := [frHideUpDown, frReplace, frReplaceAll];
     OnFind := FindDialog1Find;
     {$ifdef ver100}
     OnClose := FindDialog1Close;
     {$endif}
   end;

   ReplaceDialog1:= TReplaceDialog.create(self);
   with ReplaceDialog1 do begin
      OnReplace:= ReplaceDialog1Replace;
      OnFind := FindDialog1Find;
     {$ifdef ver100}
      OnClose := FindDialog1Close;
      {$endif}
   end;

   FontDialog1:= TFontDialog.create(self);
   with FontDialog1 do begin
      Device := fdBoth;
      MinFontSize := 0;
      MaxFontSize := 0;
   end;

   CreatePopup;  { Only create during runtime - Moved from loaded function 5/14/97 }
   if PopupMenu=Nil then PopupMenu:= DefaultPopupMenu;

end;

destructor TwwCustomRichEdit.Destroy;
begin
   FindDialog1.Free;
   ReplaceDialog1.Free;
   FontDialog1.Free;
   DefaultPopupMenu.Free;
   FPrintMargins.Free;

   inherited Destroy;
end;

function TwwCustomRichEdit.Execute: boolean;
var form: TwwRichEditForm;
begin
   form:= TwwRichEditForm.create(Application);
   with form do try
      { Create rich-edit control - Control is created dynamically so that the
        pop-up editor's richedit will support any overrided virtual functions }
      RichEdit1:= TwwDBRichEdit(TComponentClass(self.classType).create(form));
      with RichEdit1 do begin
         Parent:= form;
         Left := 0;
         Top := 60;
         Width := 595;
         Height := 330;
         Align := alClient;
         HideSelection := False;
         ScrollBars := ssVertical;
         TabOrder := 3;
         WantTabs := True;
         WordWrap := False;
         OnSelectionChange := RichEdit1SelectionChange;
         PopupOptions := [rpoPopupCut, rpoPopupCopy, rpoPopupPaste, rpoPopupFont, rpoPopupBullet, rpoPopupParagraph];
         EditorCaption := 'Edit Rich Text';
         MeasurementUnits := muInches;
         PrintMargins.Top := 1;
         PrintMargins.Bottom := 1;
         PrintMargins.Left := 1;
         PrintMargins.Right := 1;
         Name:= 'RichEdit1';
      end;
      ActiveControl:= RichEdit1;
   
      Caption:= EditorCaption;
      RichEdit1.Font.Assign(self.font); { Assign default font - Put before CopyRichEditTo }
      with RichEdit1 do begin
         DefAttributes.Name:= self.Font.Name;
         DefAttributes.Style:= self.Font.Style;
         DefAttributes.Color:= self.Font.Color;
         DefAttributes.Size:= self.Font.Size;
         DefAttributes.Pitch:= self.Font.Pitch;
      end;
      CopyRichEditTo(RichEdit1);
      RichEdit1.WordWrap:= self.WordWrap;
      RichEdit1.WantReturns:= True;
      RichEdit1.WantTabs:= True;
      RichEdit1.MeasurementUnits:= self.MeasurementUnits;
      RichEdit1.OnInitDialog:= self.onInitDialog;
      RichEdit1.PrintMargins.Assign(self.PrintMargins);
      RichEdit1.EditWidth:= self.EditWidth;
      RichEdit1.PrintPageSize:= self.PrintPageSize;
      if RichEdit1.EditWidth=rewPrinterSize then with RichEdit1.FontDialog1 do
         Options:= Options + [fdWysiwyg];
      RichEdit1.EditorOptions:= self.EditorOptions;
      RichEdit1.MaxLength:= self.MaxLength;
      RichEdit1.ReadOnly:= self.GetReadOnly;
      RichEdit1.selStart:= self.selStart;

      result:= ShowModal=mrOK;
      self.DoCloseDialog(form);

      if result then begin
         if RichEdit1.modified then begin
             BeginEditing;
             RichEdit1.CopyRichEditTo(self);
             UpdateField;
             modified:= True; {5/21/97}
         end;
         self.PrintMargins.Assign(RichEdit1.PrintMargins);
         self.PrintPageSize:= RichEdit1.PrintPageSize;
      end;
   finally
      Free;
   end;
end;

Procedure TwwCustomRichEdit.CopyRichEditTo(val: TCustomRichEdit);
var stream1: TMemoryStream;
begin
   stream1:= TMemoryStream.create;
   lines.SaveToStream(stream1);
   stream1.position:= 0;
   TRichEdit(val).lines.LoadFromStream(stream1);
   stream1.free;
end;

Procedure TwwCustomRichEdit.ExecuteFindDialog;
var tempText: string;
begin
   tempText:= selText;
   if (length(tempText)>0) and
      (pos(#13, tempText)<=0) then FindDialog1.FindText:= tempText
   else FindDialog1.FindText:= LastSearchText;
   InResetToStart:= False;
   StartingFindPos:= selStart;
   OrigHideSelection:= HideSelection;
   HideSelection:= False;
   FindDialog1.execute;
end;

Procedure TwwCustomRichEdit.FindNextMatch;
begin
   FindReplaceDlg(FindDialog1, false, '');
end;

Procedure TwwCustomRichEdit.FindReplace;
begin
   FindReplaceDlg(ReplaceDialog1, true, ReplaceDialog1.replaceText);
end;

Procedure TwwCustomRichEdit.FindReplaceDlg(
        dialog: TFindDialog; replace: boolean;
        replaceStr: string);
var SearchTypes : TSearchTypes;
    MatchPos: integer;
begin
   While True do With dialog do begin
      SearchTypes:= [];
      if frMatchCase in Options then
         SearchTypes:= SearchTypes + [stMatchCase];
      if frWholeWord in Options then
         SearchTypes:= SearchTypes + [stWholeWord];

      if replace then begin
         MatchPos:=
            self.FindText(FindText, selStart,  length(self.Text), SearchTypes);
         if (MatchPos=selStart) and
            (length(selText)=length(FindText)) then
         begin
            if inResetToStart then
               StartingFindPos:= StartingFindPos + length(ReplaceStr)-length(FindText);
            selText:= ReplaceStr;
            selStart:= MatchPos + length(ReplaceStr);
         end
      end;

      MatchPos:=
            self.FindText(FindText,  selStart+1,  length(self.Text), SearchTypes);
      if InResetToStart and (MatchPos>StartingFindPos) then MatchPos:= -1;

      if (not InResetToStart) and (MatchPos<0) and (selStart>=1) then
      begin
         MatchPos:=
            self.FindText(FindText,  0,  length(self.Text), SearchTypes);
         if MatchPos>StartingFindPos then MatchPos:= -1;
         InResetToStart:= True;
      end;

      if MatchPos>=0 then
      begin
         selStart:= MatchPos;
         selLength:= length(FindText);
      end
      else begin
         MessageDlg('No more matches found', mtInformation, [mbOK], 0);
         StartingFindPos:= selStart;
         InResetToStart:= False;
         break;
      end;

      if (frReplaceAll in dialog.options) then
      begin
      end
      else break;

   end;
end;

procedure TwwCustomRichEdit.ReplaceDialog1Replace(Sender: TObject);
begin
   LastSearchText:= ReplaceDialog1.FindText;
   FindReplace;
end;

procedure TwwCustomRichEdit.ExecuteFontDialog;
begin
  with FontDialog1 do
  begin
    Font.Name:= SelAttributes.Name;
    Font.Style:= SelAttributes.Style;
    Font.Color:= SelAttributes.Color;
    Font.Size:= SelAttributes.Size;
    Font.Pitch:= SelAttributes.Pitch;
  end;

  with FontDialog1 do begin
     if EditWidth=rewPrinterSize then
{        Device:= fdPrinter}
        Options:= Options + [fdWysiwyg]
     else
{        Device:= fdBoth;}
        Options:= Options - [fdWysiwyg];
  end;

  if FontDialog1.execute then
  begin
    with FontDialog1 do
    begin
       SetRichEditFontAttributes(Font.Name, Font.Size, Font.Style, Font.Color);
    end;
  end;
end;

procedure TwwCustomRichEdit.ExecuteReplaceDialog;
var tempText : string;
begin
   tempText:= selText;
   if (length(tempText)>0) and
      (pos(#13, tempText)<=0) then ReplaceDialog1.FindText:= tempText
   else ReplaceDialog1.FindText:= LastSearchText;
   InResetToStart:= False;
   StartingFindPos:= SelStart;
   OrigHideSelection:= HideSelection;
   HideSelection:= False;
   ReplaceDialog1.execute;
end;

Procedure TwwCustomRichEdit.SetRichEditFontAttributes(
   FontName: string; FontSize: integer; FontStyle: TFontStyles;
   FontColor: TColor);
var Format: TCharFormat;
begin
  FillChar(Format, SizeOf(TCharFormat), 0);
  Format.cbSize := SizeOf(TCharFormat);
  with Format do
  begin
    dwMask:= CFM_FACE OR CFM_CHARSET or CFM_SIZE or CFM_BOLD or
             CFM_ITALIC or CFM_COLOR OR CFM_UNDERLINE OR CFM_STRIKEOUT;
    StrPLCopy(szFaceName, FontName, SizeOf(szFaceName));
    bCharSet := GetCharSetOfFontName(FontName);
    crTextColor:= FontColor;
    if fsBold in FontStyle then
       dwEffects:= dwEffects + CFE_BOLD;
    if fsItalic in FontStyle then dwEffects:= dwEffects + CFE_Italic;
    if fsUnderline in FontStyle then dwEffects:= dwEffects + CFE_Underline;
    if fsStrikeout in FontStyle then dwEffects:= dwEffects + CFE_Strikeout;
    yHeight:= FontSize * 20;
  end;
  SendMessage(Handle, EM_SETCHARFORMAT, SCF_SELECTION, LPARAM(@Format));
end;

Procedure TwwCustomRichEdit.ExecuteParagraphDialog;
begin
   wwRichEditParagraphDlg(self);
end;

procedure TwwCustomRichEdit.WriteState(Writer: TWriter);
var stream1, stream2: TMemoryStream;
begin
  if BoundMode then
  begin
     inherited WriteState(Writer);
     exit;
  end;
  stream1:= TMemoryStream.create;
  stream2:= TMemoryStream.create;
  lines.saveToStream(stream2);
  lines.saveToStream(stream1);
  stream1.position:= 0;
  PlainText:= True;
  inherited WordWrap:= False;
  lines.LoadFromStream(stream1);
  inherited WriteState(Writer);
  inherited WordWrap:= WordWrap; {Restore original wordwrap }
  PlainText:= False;
  stream2.position:= 0;
  lines.LoadFromStream(stream2);
  stream1.free;
  stream2.free;
end;

procedure TwwCustomRichEdit.ReadState(Reader: TReader);
var stream1: TMemoryStream;
    tempHourGlass: TCursor;
begin
  if BoundMode then
  begin
     inherited ReadState(Reader);
     exit;
  end;
  tempHourGlass:= Screen.cursor;
  Screen.cursor:= crHourGlass;

  PlainText:= True;
  inherited ReadState(Reader);
  stream1:= TMemoryStream.create;
  lines.SaveToStream(stream1);
  stream1.position:= 0;
  PlainText:= False;
  lines.LoadFromStream(stream1);
  stream1.free;
  Screen.cursor:= tempHourGlass;
end;

procedure TwwCustomRichEdit.FindDialog1Close(Sender: TObject);
begin
   HideSelection:= OrigHideSelection;
end;

procedure TwwCustomRichEdit.FindDialog1Find(Sender: TObject);
begin
   LastSearchText:= (Sender as TFindDialog).FindText;
   FindDialog1.FindText:= LastSearchText;
   FindNextMatch;
end;

function TwwCustomRichEdit.CanPaste: boolean;
begin
   result:= SendMessage(Handle, EM_CANPASTE, 0, 0)<>0;
end;

function TwwCustomRichEdit.CanUndo: boolean;
begin
   result:= SendMessage(Handle, EM_CANUNDO, 0, 0)<>0;
end;

Function TwwCustomRichEdit.CanFindNext: boolean;
begin
   result:= lastSearchText<>'';
end;

function TwwCustomRichEdit.CanCut: boolean;
begin
   result:= seltext<>'';
end;

procedure TwwCustomRichEdit.GetParaIndent(
   var LeftIndent, RightIndent, FirstIndent: integer);
var Format: TParaFormat;
begin
  LeftIndent:= 0; RightIndent:= 0; FirstIndent:= 0;
  FillChar(Format, SizeOf(TParaFormat), 0);
  Format.cbSize := SizeOf(TParaFormat);
  if HandleAllocated then begin
     SendMessage(Handle, EM_GETPARAFORMAT, 0, LPARAM(@Format));
     LeftIndent:= format.dxOffset;
     RightIndent:= format.dxRightIndent;
     FirstIndent:= format.dxStartIndent;
  end;
end;

procedure TwwCustomRichEdit.GetParaFormat(var Format: TParaFormat);
begin
  FillChar(Format, SizeOf(TParaFormat), 0);
  Format.cbSize := SizeOf(TParaFormat);
  if HandleAllocated then begin
     SendMessage(Handle, EM_GETPARAFORMAT, 0, LPARAM(@Format));
  end;
end;

procedure TwwCustomRichEdit.SetParaFormat(
    Options: TwwRichEditParaOptions;
    alignment: string;
    bulletStyle: boolean;
    leftindent, rightindent, firstlineindent: integer;
    tabCount: integer; tabArray: Pointer);
type wwLongArray = Array [0..MAX_TAB_STOPS] of longint;
     PwwLongArray=^wwLongArray;
var Format: TParaFormat;
    i: integer;
begin
   FillChar(Format, SizeOf(TParaFormat), 0);
   Format.cbSize := SizeOf(TParaFormat);
   with Format do
   begin
      if rpoAlignment in Options then dwMask:= dwMask + PFM_ALIGNMENT;
      if rpoBullet in Options then dwMask:= dwMask + PFM_NUMBERING;
      if rpoLeftIndent in Options then dwMask:= dwMask + PFM_OFFSET;
      if rpoRightIndent in Options then dwMask:= dwMask + PFM_RIGHTINDENT;
      if rpoFirstLineIndent in Options then dwMask:= dwMask + PFM_STARTINDENT;
      if rpoTabs in Options then dwMask:= dwMask + PFM_TABSTOPS;

      if bulletStyle then wNumbering:= PFN_BULLET
      else wNumbering:= 0;
      dxOffset:= leftIndent;
      dxRightIndent:= rightIndent;
      dxStartIndent:= firstLineIndent;
      if Alignment = 'Left' then wAlignment:=PFA_LEFT
      else if Alignment = 'Right' then wAlignment:= PFA_RIGHT
      else wAlignment:= PFA_CENTER;
      if rpoTabs in Options then
      begin
         cTabCount:= wwMin(tabCount, MAX_TAB_STOPS);
         for i:= 0 to cTabCount-1 do
         begin
            rgxTabs[i]:= PwwLongArray(tabArray)^[i];
         end;
      end;
      SendMessage(Handle, EM_SETPARAFORMAT, 0, LPARAM(@Format));
   end
end;


procedure TwwCustomRichEdit.SetBullet(val: boolean);
begin
   if val then begin
       SetParaFormat([rpoBullet, rpoLeftIndent], '', True,
          Trunc(0.5*wwLogXPixelsPerInch*20), 0, 0, 0, nil);
   end
   else
      Paragraph.Numbering:= nsNone;
end;

procedure TwwCustomRichEdit.SetBold(val: boolean);
begin
  if (val) then
     SelAttributes.Style:= SelAttributes.Style +[fsBold]
  else
     SelAttributes.Style:= SelAttributes.Style -[fsBold];
end;

procedure TwwCustomRichEdit.SetItalic(val: boolean);
begin
  if (val) then
     SelAttributes.Style:= SelAttributes.Style +[fsItalic]
  else
     SelAttributes.Style:= SelAttributes.Style -[fsItalic];
end;

procedure TwwCustomRichEdit.SetUnderline(val: boolean);
begin
  if (val) then
     SelAttributes.Style:= SelAttributes.Style +[fsUnderline]
  else
     SelAttributes.Style:= SelAttributes.Style -[fsUnderline];
end;

Procedure TwwCustomRichEdit.CreatePopup;
   Function AddMenuItem(ACaption: string; event: TNotifyEvent): TMenuItem;
   var menuItem: TMenuItem;
   begin
      menuItem:= TMenuItem.create(DefaultPopupMenu);
      menuItem.caption:= ACaption;
      menuItem.OnClick:= event;
      result:= menuItem;
      DefaultPopupMenu.items.Add(menuItem);
   end;
begin
   DefaultPopupMenu:= TPopupMenu.create(self);

   with DefaultPopupMenu,wwInternational.RichEdit do begin
      OnPopup:= PopupMenuPopup;
      PopupEdit:= AddMenuItem(PopupMenuLabels.EditCaption, PopupEditClick);
      PopupSep1:= AddMenuItem('-', nil);
      PopupCut:= AddMenuItem(PopupMenuLabels.CutCaption, PopupCutClick);
      PopupCopy:= AddMenuItem(PopupMenuLabels.CopyCaption, PopupCopyClick);
      PopupPaste:= AddMenuItem(PopupMenuLabels.PasteCaption, PopupPasteClick);
      PopupSep2:= AddMenuItem('-', nil);
      PopupBold:= AddMenuItem(PopupMenuLabels.BoldCaption, PopupBoldClick);
      PopupItalic:= AddMenuItem(PopupMenuLabels.ItalicCaption, PopupItalicClick);
      PopupUnderline:= AddMenuItem(PopupMenuLabels.UnderlineCaption, PopupUnderlineClick);
      PopupSep3:= AddMenuItem('-', nil);
      PopupFont:= AddMenuItem(PopupMenuLabels.FontCaption, PopupFontClick);
      PopupBullet:= AddMenuItem(PopupMenuLabels.BulletStyleCaption, PopupBulletClick);
      PopupParagraph:= AddMenuItem(PopupMenuLabels.ParagraphCaption, PopupParagraphClick);
      PopupTabs:= AddMenuItem(PopupMenuLabels.TabsCaption, PopupTabsClick);
      PopupSep4:= AddMenuItem('-', nil);
      PopupFind:= AddMenuItem(PopupMenuLabels.FindCaption, PopupFindClick);
      PopupReplace:= AddMenuItem(PopupMenuLabels.ReplaceCaption, PopupReplaceClick);
   end;
end;

procedure TwwCustomRichEdit.PopupCutClick(Sender: TObject);
begin
   CutToClipboard;
end;

procedure TwwCustomRichEdit.PopupCopyClick(Sender: TObject);
begin
   CopyToClipboard;
end;

procedure TwwCustomRichEdit.PopupPasteClick(Sender: TObject);
begin
   PasteFromClipboard;
end;

procedure TwwCustomRichEdit.PopupFontClick(Sender: TObject);
begin
   ExecuteFontDialog;
end;

procedure TwwCustomRichEdit.PopupParagraphClick(Sender: TObject);
begin
   ExecuteParagraphDialog;
end;

procedure TwwCustomRichEdit.PopupTabsClick(Sender: TObject);
begin
   ExecuteTabDialog;
end;

procedure TwwCustomRichEdit.PopupFindClick(Sender: TObject);
begin
   ExecuteFindDialog;
end;

procedure TwwCustomRichEdit.PopupReplaceClick(Sender: TObject);
begin
   ExecuteReplaceDialog;
end;

procedure TwwCustomRichEdit.PopupEditclick(Sender: TObject);
begin
   execute;
end;

procedure TwwCustomRichEdit.PopupBulletClick(Sender: TObject);
begin
   SetBullet(not PopupBullet.checked);
   PopupBullet.checked:= not PopupBullet.checked;
end;

procedure TwwCustomRichEdit.PopupBoldClick(Sender: TObject);
begin
   SetBold(not PopupBold.checked);
   PopupBold.checked:= not PopupBold.checked;
end;

procedure TwwCustomRichEdit.PopupItalicClick(Sender: TObject);
begin
   SetItalic(not PopupItalic.checked);
   PopupItalic.checked:= not PopupItalic.checked;
end;

procedure TwwCustomRichEdit.PopupUnderlineClick(Sender: TObject);
begin
   SetUnderline(not PopupUnderline.checked);
   PopupUnderline.checked:= not PopupUnderline.checked;
end;


procedure TwwCustomRichEdit.PopupMenuPopup(Sender: TObject);
begin
   if GetReadOnly then begin
      PopupOptions:= PopupOptions -
         [rpoPopupEdit,
          rpoPopupBold, rpoPopupItalic, rpoPopupUnderline,
          rpoPopupFont, rpoPopupParagraph, rpoPopupTabs,
              rpoPopupBullet, rpoPopupReplace];
   end;

   PopupEdit.visible:= rpoPopupEdit in PopupOptions;
   PopupSep1.visible:= PopupEdit.visible and
      ([rpoPopupCut, rpoPopupcopy, rpoPopupPaste,
        rpoPopupBold, rpoPopupItalic, rpoPopupUnderline,
        rpoPopupFont, rpoPopupParagraph, rpoPopupBullet, rpoPopupTabs,
        rpoPopupFind, rpoPopupReplace]*PopupOptions<>[]);

   PopupCut.visible:= (rpoPopupCut in PopupOptions);
   PopupCopy.visible:= rpoPopupCopy in PopupOptions;
   PopupPaste.visible:= (rpoPopupPaste in PopupOptions);

   PopupSep2.visible:= ([rpoPopupCut, rpoPopupCopy, rpoPopupPaste]*PopupOptions<>[])
      and
      ([rpoPopupBold, rpoPopupItalic, rpoPopupUnderline,
        rpoPopupFont, rpoPopupParagraph, rpoPopupTabs, rpoPopupBullet,
        rpoPopupFind, rpoPopupReplace]*PopupOptions<>[]);

   PopupBold.visible:= rpoPopupBold in PopupOptions;
   PopupItalic.visible:= rpoPopupItalic in PopupOptions;
   PopupUnderline.visible:= rpoPopupUnderline in PopupOptions;

   PopupSep3.visible:=
      ([rpoPopupBold, rpoPopupItalic, rpoPopupUnderline]*PopupOptions<>[]) and
      ([rpoPopupFont, rpoPopupParagraph, rpoPopupTabs, rpoPopupBullet,
        rpoPopupFind, rpoPopupReplace]*PopupOptions<>[]);

   PopupFont.visible:= (rpoPopupFont in PopupOptions);
   PopupParagraph.visible:= (rpoPopupParagraph in PopupOptions);
   PopupTabs.visible:= (rpoPopupTabs in PopupOptions);
   PopupBullet.visible:= (rpoPopupBullet in PopupOptions);

   PopupSep4.visible:=
      ([rpoPopupFont, rpoPopupParagraph, rpoPopupTabs, rpoPopupBullet]*PopupOptions<>[]) and
      ([rpoPopupFind, rpoPopupReplace]*PopupOptions<>[]);

   PopupFind.visible:= rpoPopupFind in PopupOptions;
   PopupReplace.visible:= (rpoPopupReplace in PopupOptions);

   PopupCut.enabled:= CanCut and (not GetReadOnly);
   PopupCopy.enabled:= CanCut;
   PopupPaste.enabled:= CanPaste and (not GetReadOnly);
   PopupBullet.checked:= Paragraph.Numbering <> nsNone;
   PopupBold.checked:= fsBold in SelAttributes.Style;
   PopupItalic.checked:= fsItalic in SelAttributes.Style;
   PopupUnderline.checked:= fsUnderline in SelAttributes.Style;
end;

procedure TwwCustomRichEdit.Loaded;
begin
   inherited Loaded;

   { Avoid Delphi bug which ignores visible=False }
   if not (csDesigning in GetParentForm(self).ComponentState) then
   begin
      if (not visible) then ShowWindow(handle, sw_hide)
   end;


end;

procedure TwwCustomRichEdit.SetWordWrap(val: boolean);
begin
   inherited WordWrap:= val;
   FWordWrap:= val;
end;

Function TwwCustomRichEdit.FormatUnitStr(val: double): string;  { Append units to number }
begin
   if measurementunits=muCentimeters then
      result:= floatToStr(val) + ' cm'
   else
      result:= floattostr(val) + '''''';
end;

Function TwwCustomRichEdit.UnitStrToTwips(str: string): integer;
var temp: double;
begin
   strStripTrailing(str, ['''', ' ', 'c', 'm', 'C', 'M']);
   temp:= strtofloat(str) * wwLogXPixelsPerInch * 20; { Use Twips }
   if measurementUnits=muCentimeters then temp:= temp / wwCentimetersPerInch;
   result:= trunc(temp);
end;

Function TwwCustomRichEdit.TwipsToUnits(val: integer): double;
var temp: double;
begin
   temp:= val / (wwLogXPixelsPerInch * 20);
   if measurementunits=muCentimeters then
   begin
      temp:= temp * wwCentimetersPerInch;
      temp:= round(temp * 100) / 100; { 2 decimal places }
   end
   else begin
      temp:= round(temp * 100) / 100; { 2 decimal places }
   end;
   result:= temp;
end;

procedure TwwCustomRichEdit.ExecuteTabDialog;
begin
   wwRichTabDlg(self);
end;

Procedure TwwCustomRichEdit.DoCloseDialog(Form: TForm);
begin
  if Assigned(FOnCloseDialog) then OnCloseDialog(Form);
end;

Procedure TwwCustomRichEdit.DoInitDialog(Form: TForm);
begin
  if Assigned(FOnInitDialog) then OnInitDialog(Form);
end;

procedure TwwCustomRichEdit.CreateParams(var Params: TCreateParams);
begin
   inherited CreateParams(Params);
end;


Procedure TwwCustomRichEdit.SetEditRect;
var r: TRect;
   Logx, logy: integer;
   PrnPhysPageSize: TPoint;
   xMarginInches: double;

   Function isVertScrollVisible: boolean;
   var si: TScrollInfo;
   begin
      result:= False;
      if not ((ScrollBars=ssVertical) or (ScrollBars=ssBoth)) then exit;

      FillChar(SI, SizeOf(TScrollInfo), 0);
      SI.cbSize := sizeof(SI);
      SI.fMask := SIF_ALL;
      GetScrollInfo(Handle, SB_VERT, SI);
      result:= (si.nMax<>0);
   end;

   function sameRect(rect1, rect2: TRect): boolean;
   begin
      result:=
       (rect1.left = rect2.left) and
       (rect1.right = rect2.right) and
       (rect1.top = rect2.top) and
       (rect1.bottom = rect2.bottom);
   end;

begin
   if EditWidth<>rewWindowSize then begin
      with Printer do begin
        Escape( Printer.Handle, GETPHYSPAGESIZE, 0, nil, @PrnPhysPageSize);
        LogX := GetDeviceCaps(Handle, LOGPIXELSX);
        LogY := GetDeviceCaps(Handle, LOGPIXELSY);
        XMarginInches:= UnitStrToTwips(floattostr(PrintMargins.left+PrintMargins.Right))/1440;

        r.left:= GutterWidth;
        r.top:= 0;
        r.right:= GutterWidth+4+Trunc(((PrnPhysPageSize.x/logx) - XMarginInches)*96);
        if isVertScrollVisible then r.right:= r.right - (GetSystemMetrics(SM_CXHThumb)+5);
        r.bottom:= PageHeight * 96 div logy;

        SendMessage(self.handle, EM_SETRECT, 0, longint(@r));
      end
   end
   else begin
      if not isWindowVisible(self.handle) then exit;

      r.left:= GutterWidth;
      r.top:= 0;
      r.right:= Width - 4;
      if isVertScrollVisible then r.right:= r.right - (GetSystemMetrics(SM_CXHThumb));
      r.bottom:= Height;
      if sameRect(r,FLastSetRect) then exit;
      FLastSetRect:= r;

      SendMessage(self.handle, EM_SETRECT, 0, longint(@r));
   end
end;

procedure TwwCustomRichEdit.EMFormatRange(var msg:TMessage);
type PFormatRange = ^TFormatRange;
var
   pf: PFormatRange;
   PrnPageOffset : TPoint;	{Offset from physical printer page size to print size X/Y}
   PrnPhysPageSize: TPoint;

   rect: TRect;
   LeftoffsetTwips, TopOffsetTwips: integer;

   Function PixelsToTwipsX(pixels: integer): integer;
   begin
       result := (pixels * 1440) div GetDeviceCaps(Printer.Handle, LogPixelsX);
   end;
   Function PixelsToTwipsY(pixels: integer): integer;
   begin
       result := (pixels * 1440) div GetDeviceCaps(Printer.Handle, LogPixelsY);
   end;
begin
   Escape( Printer.Handle, GETPHYSPAGESIZE, 0, nil, @PrnPhysPageSize);
   Escape( Printer.Handle, GETPRINTINGOFFSET, 0, nil, @PrnPageOffset);
   LeftOffsetTwips := PixelsToTwipsX(PrnPageOffset.x);
   TopOffsetTwips := PixelsToTwipsY(PrnPageOffset.Y);

   with rect do begin
      Left:= UnitStrToTwips(floattostr(PrintMargins.left));
      Left:= Left - LeftOffsetTwips;
      Left:= wwMax(0, Left);
      Left:= wwMin(Left, PixelsToTwipsX(PrnPhysPageSize.X - PrnPageOffset.X*2));

      Right:= PixelsToTwipsX(PrnPhysPageSize.X)
              - UnitStrToTwips(floattostr(PrintMargins.right)) - LeftOffsetTwips;
      Right:= wwMax(Left, Right);
      Right:= wwMin(Right, PixelsToTwipsX(PrnPhysPageSize.X - 2*PrnPageOffset.X));

      Top:= UnitStrToTwips(floattostr(PrintMargins.top));
      Top:= Top - TopOffsetTwips;
      Top:= wwMax(0, Top);
      Top:= wwMin(Top, PixelsToTwipsY(PrnPhysPageSize.Y - PrnPageOffset.Y));

      Bottom:= PixelsToTwipsX(PrnPhysPageSize.Y)
               - UnitStrToTwips(floattostr(PrintMargins.bottom)) - TopOffsetTwips;
      Bottom:= wwMax(Top, Bottom);
      Bottom:= wwMin(Bottom, PixelsToTwipsX(PrnPhysPageSize.Y - 2*PrnPageOffset.Y));
   end;
   pf := PFormatRange(msg.LParam);
   if pf<>nil then begin
      pf^.rc:= rect;
   end;
   inherited;
end;

procedure TwwPrintMargins.Assign(Source: TPersistent);
begin
  if Source is TwwPrintMargins then with TwwPrintMargins(Source) do
  begin
     self.left:= left;
     self.right:= right;
     self.top:= top;
     self.bottom:= bottom;
  end;
end;

constructor TwwPrintMargins.Create(AOwner: TComponent);
begin
   left:= 1;
   right:= 1;
   top:= 1;
   bottom:= 1;
end;

Procedure TwwCustomRichEdit.UpdatePrinter;
var Device, Driver, Port: array[0..79] of char;
    hDMode: THandle;
    pDMode: PDEVMODE;
begin
   Printer.PrinterIndex:= Printer.PrinterIndex;  { Forces hdMode to be valid }
   Printer.GetPrinter(Device, Driver, Port, hDMode);
   if hDMode<>0 then begin
      pDMode:= GlobalLock(hDMode);
      if pDMode<>nil then begin
         pDMode^.dmFields:= pDMode^.dmFields or dm_PaperSize;
         pDMode.dmPaperSize:= PrintPageSize;
         GlobalUnlock(hDMode);
         Printer.PrinterIndex:= Printer.PrinterIndex;
      end
   end;
end;

procedure TwwCustomRichEdit.Print(const Caption: string);
var
  Range: TFormatRange;
  LastChar, MaxLen, LogX, LogY, OldMap: Integer;
begin

  if EditWidth=rewPrinterSize then UpdatePrinter;

  FillChar(Range, SizeOf(TFormatRange), 0);
  with Printer, Range do
  begin
    BeginDoc;
    hdc := Handle;
    hdcTarget := hdc;
    LogX := GetDeviceCaps(Handle, LOGPIXELSX);
    LogY := GetDeviceCaps(Handle, LOGPIXELSY);
    if IsRectEmpty(PageRect) then
    begin
      rc.right := PageWidth * 1440 div LogX;
      rc.bottom := PageHeight * 1440 div LogY;
    end
    else begin
      rc.left := PageRect.Left * 1440 div LogX;
      rc.top := PageRect.Top * 1440 div LogY;
      rc.right := PageRect.Right * 1440 div LogX;
      rc.bottom := PageRect.Bottom * 1440 div LogY;
    end;
    rcPage := rc;
    Title := Caption;
    LastChar := 0;
    MaxLen := GetTextLen;
    chrg.cpMax := -1;
    // ensure printer DC is in text map mode
    OldMap := SetMapMode(hdc, MM_TEXT);
    SendMessage(Handle, EM_FORMATRANGE, 0, 0);    // flush buffer
    try
      repeat
        chrg.cpMin := LastChar;
        LastChar := SendMessage(Self.Handle, EM_FORMATRANGE, 1, Longint(@Range));
        if (LastChar < MaxLen) and (LastChar <> -1) then NewPage;
      until (LastChar >= MaxLen) or (LastChar = -1);
      EndDoc;
    finally
      SendMessage(Handle, EM_FORMATRANGE, 0, 0);  // flush buffer
      SetMapMode(hdc, OldMap);       // restore previous map mode
    end;
  end;
end;

Function TwwDBRichEdit.isBlob: boolean;
begin
   result:= FDataLink.Field is TBlobField;
end;

procedure TwwCustomRichEdit.SetPrintPageSize(val: integer);
begin
   FPrintPageSize:= val;

   if (GetParentForm(self)<>Nil) and (EditWidth<>rewWindowSize) then
   begin
      UpdatePrinter;
      SetEditRect;
   end
end;

procedure TwwCustomRichEdit.SelectionChange;
begin
   inherited SelectionChange;
   if Focused and (EditWidth=rewWindowSize) then SetEditRect;  { Readjust edit rectange if scroll becomes visible }
end;

procedure TwwCustomRichEdit.WMSize(var msg:twmsize);
begin
   inherited;
   if (EditWidth=rewWindowSize) then SetEditRect;  { Readjust edit rectange if scroll becomes visible }
end;

procedure Register;
begin
end;

end.
