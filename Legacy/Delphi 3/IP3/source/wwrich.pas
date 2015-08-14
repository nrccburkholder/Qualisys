unit wwrich;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, DBCtrls, ExtCtrls, Db, DBTables, Wwtable, Wwdatsrc, StdCtrls,
  ComCtrls, Grids, DBGrids, wwdbedit, Wwdotdot, Wwdbcomb, Buttons, richedit,
  Menus, wwrchdlg, wwriched, wwintl, wwrichtb, printers, commdlg, winspool;

type

  TwwRichEditForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Print1: TMenuItem;
    PageSetup1: TMenuItem;
    SaveExit1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Undo1: TMenuItem;
    EditSep1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Clear1: TMenuItem;
    SelectAll1: TMenuItem;
    EditSep2: TMenuItem;
    Find1: TMenuItem;
    FindNext1: TMenuItem;
    Replace1: TMenuItem;
    View1: TMenuItem;
    Toolbar1: TMenuItem;
    FormatBar1: TMenuItem;
    StatusBar: TStatusBar;
    OptionsSep: TMenuItem;
    Options1: TMenuItem;
    Insert1: TMenuItem;
    DateandTime1: TMenuItem;
    Format1: TMenuItem;
    Font1: TMenuItem;
    BulletStyle1: TMenuItem;
    Paragraph1: TMenuItem;
    Tabs1: TMenuItem;
    Help1: TMenuItem;
    FormatBar: TPanel;
    FontNameCombo: TwwDBComboBox;
    FontSizeCombo: TwwDBComboBox;
    BoldButton: TSpeedButton;
    UnderlineButton: TSpeedButton;
    ItalicButton: TSpeedButton;
    LeftButton: TSpeedButton;
    CenterButton: TSpeedButton;
    RightButton: TSpeedButton;
    BulletButton: TSpeedButton;
    StatusBar1: TMenuItem;
    PrintDialog1: TPrintDialog;
    FileSep2: TMenuItem;
    FileSep1: TMenuItem;
    Load1: TMenuItem;
    SaveAs1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Toolbar: TPanel;
    NewButton: TSpeedButton;
    ToolBarBevel: TBevel;
    FormatBarBevel: TBevel;
    LoadButton1: TSpeedButton;
    SaveAsButton: TSpeedButton;
    PrintButton: TSpeedButton;
    FindButton: TSpeedButton;
    CutButton: TSpeedButton;
    CopyButton: TSpeedButton;
    UndoButton: TSpeedButton;
    PasteButton: TSpeedButton;
    SaveDialog1: TSaveDialog;
    procedure BoldButtonClick(Sender: TObject);
    procedure UnderlineButtonClick(Sender: TObject);
    procedure ItalicButtonClick(Sender: TObject);
    procedure RightButtonClick(Sender: TObject);
    procedure CenterButtonClick(Sender: TObject);
    procedure LeftButtonClick(Sender: TObject);
    procedure BulletButtonClick(Sender: TObject);
    procedure RichEdit1SelectionChange(Sender: TObject);
    procedure BoldButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Undo1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure FindNext1Click(Sender: TObject);
    procedure Replace1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure FontNameComboCloseUp(Sender: TwwDBComboBox; Select: Boolean);
    procedure FontSizeComboCloseUp(Sender: TwwDBComboBox; Select: Boolean);
    procedure BulletStyle1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Paragraph1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure FormatBar1Click(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure SaveExit1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Tabs1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PageSetup1Click(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Toolbar1Click(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure LoadButton1Click(Sender: TObject);
    procedure SaveAsButtonClick(Sender: TObject);
    procedure PrintButtonClick(Sender: TObject);
    procedure FindButtonClick(Sender: TObject);
    procedure CutButtonClick(Sender: TObject);
    procedure CopyButtonClick(Sender: TObject);
    procedure PasteButtonClick(Sender: TObject);
    procedure UndoButtonClick(Sender: TObject);
    procedure FontNameComboDropDown(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    tempDown: boolean;
    OrigOnHint: TNotifyEvent;
    Procedure RefreshControls;
    Procedure SetRichEditFontName(Value: string);  { Bypass VCL bug as it doesn't set the CharSet}
    Procedure UpdateStatusBar;
    procedure UpdateFormatToolBar(ShowToolBar, ShowFormatBar: boolean);
    Procedure FormChangeHint(Sender: TObject);
    Procedure ApplyIntl;
  public
    RichEdit1: TwwDBRichEdit;

  end;

const wwCentimetersPerInch = 2.537;
var
  wwRichEditForm: TwwRichEditForm;

implementation

{$R *.DFM}
uses wwcommon;

type TwwPageSetupDialog = class(TCommonDialog)
public
   RichEdit1: TwwCustomRichEdit;
   {$ifdef ver100}
   function Execute: Boolean; override;
   {$else}
   function Execute: Boolean;
   {$endif}

end;

procedure TwwRichEditForm.BoldButtonClick(Sender: TObject);
begin
  if (TempDown) then
     richedit1.SelAttributes.Style:=
        richedit1.SelAttributes.Style -[fsBold]
  else
     richedit1.SelAttributes.Style:=
        richedit1.SelAttributes.Style +[fsBold];
  RefreshControls;
end;

procedure TwwRichEditForm.UnderlineButtonClick(Sender: TObject);
begin
  if (TempDown) then
    richedit1.SelAttributes.Style:=
        richedit1.SelAttributes.Style -[fsUnderline]
  else
    richedit1.SelAttributes.Style:=
        richedit1.SelAttributes.Style +[fsUnderline];
  RefreshControls;
end;

procedure TwwRichEditForm.ItalicButtonClick(Sender: TObject);
begin
  if (TempDown) then
    richedit1.SelAttributes.Style:=
        richedit1.SelAttributes.Style -[fsItalic]
  else
    richedit1.SelAttributes.Style:=
        richedit1.SelAttributes.Style +[fsItalic];
  RefreshControls;
end;

procedure TwwRichEditForm.RightButtonClick(Sender: TObject);
begin
  richedit1.Paragraph.Alignment:= taRightJustify;
  RefreshControls;
end;

procedure TwwRichEditForm.CenterButtonClick(Sender: TObject);
begin
  richedit1.Paragraph.Alignment:= taCenter;
  RefreshControls;
end;

procedure TwwRichEditForm.LeftButtonClick(Sender: TObject);
begin
  richedit1.Paragraph.Alignment:= taLeftJustify;
  RefreshControls;
end;

procedure TwwRichEditForm.BulletButtonClick(Sender: TObject);
begin
  RichEdit1.SetBullet(not TempDown);
  RefreshControls;
end;

procedure TwwRichEditForm.RichEdit1SelectionChange(Sender: TObject);
begin
  if richedit1.visible then
     RefreshControls;
end;

Procedure TwwRichEditForm.RefreshControls;
var haveSelection, haveText: boolean;
begin
  BoldButton.down:= fsBold in richedit1.SelAttributes.Style;
  UnderlineButton.down:= fsUnderline in richedit1.SelAttributes.Style;
  ItalicButton.down:= fsItalic in richedit1.SelAttributes.Style;
  FontNameCombo.itemIndex:= FontNameCombo.items.indexOf(RichEdit1.SelAttributes.Name);
  if FontNameCombo.itemIndex<0 then begin
     FontNameCombo.text:= RichEdit1.SelAttributes.Name;
     FontNameCombo.font.color:=clRed;
  end
  else FontNameCombo.font.color:=clWindowText;
  FontSizeCombo.itemIndex:= FontSizeCombo.items.indexOf(inttostr(RichEdit1.SelAttributes.Size));
  BulletButton.down:= richedit1.Paragraph.Numbering = nsBullet;
  BulletStyle1.checked:= BulletButton.down;
  case richedit1.Paragraph.Alignment of
    taLeftJustify: LeftButton.Down:= True;
    taCenter: CenterButton.Down:= True;
    taRightJustify: RightButton.Down:= True;
  end;


    Paste1.enabled:= RichEdit1.CanPaste and (not RichEdit1.readonly);
    PasteButton.enabled:= Paste1.enabled and (not RichEdit1.readonly);
    Undo1.enabled:= RichEdit1.CanUndo;
    UndoButton.enabled:= Undo1.enabled;

    haveSelection:= RichEdit1.CanCut;
    haveText:= RichEdit1.text<>'';
    Cut1.enabled:= haveSelection and (not RichEdit1.readonly);
    CutButton.enabled:= haveSelection and (not RichEdit1.readonly);
    Copy1.enabled:= haveSelection;
    CopyButton.enabled:= haveSelection;
    Clear1.enabled:= haveSelection and (not RichEdit1.readOnly);
    SelectAll1.enabled:= haveText;
    Find1.enabled:= haveText;
    FindButton.enabled:= haveText;
    FindNext1.enabled:= RichEdit1.CanFindNext;
    Replace1.enabled:= haveText and (not RichEdit1.readOnly);

end;


procedure TwwRichEditForm.BoldButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   tempdown:= (Sender as TSpeedButton).down;
end;

procedure TwwRichEditForm.Undo1Click(Sender: TObject);
begin
    SendMessage(RichEdit1.Handle, EM_UNDO, 0, 0);
    RefreshControls;
{    SendMessage(RichEdit1.Handle, EM_SETOPTIONS,
                ECOOP_XOR, ECO_AUTOWORDSELECTION);}
end;



procedure TwwRichEditForm.Cut1Click(Sender: TObject);
begin
   Richedit1.CutToClipboard;
end;

procedure TwwRichEditForm.Copy1Click(Sender: TObject);
begin
   Richedit1.CopyToClipboard;
end;

procedure TwwRichEditForm.Paste1Click(Sender: TObject);
begin
   Richedit1.PasteFromClipboard;
end;

procedure TwwRichEditForm.SelectAll1Click(Sender: TObject);
begin
   Richedit1.SelectAll;
end;

procedure TwwRichEditForm.Clear1Click(Sender: TObject);
begin
   Richedit1.ClearSelection;
end;

procedure TwwRichEditForm.Find1Click(Sender: TObject);
begin
   richedit1.ExecuteFindDialog;
end;

procedure TwwRichEditForm.FindNext1Click(Sender: TObject);
begin
   RichEdit1.FindNextMatch;
end;

procedure TwwRichEditForm.Replace1Click(Sender: TObject);
begin
   RichEdit1.ExecuteReplaceDialog;
end;

procedure TwwRichEditForm.Font1Click(Sender: TObject);
begin
   RichEdit1.ExecuteFontDialog;
   RefreshControls;
end;

Procedure TwwRichEditForm.SetRichEditFontName(Value: string);
var Format: TCharFormat;
begin
  if RichEdit1.selAttributes.Name=Value then exit;
  FillChar(Format, SizeOf(TCharFormat), 0);
  Format.cbSize := SizeOf(TCharFormat);
  with Format do
  begin
    dwMask:= CFM_FACE OR CFM_CHARSET;
    StrPLCopy(szFaceName, Value, SizeOf(szFaceName));
    bCharSet := RichEdit1.GetCharSetOfFontName(Value);
  end;
  SendMessage(RichEdit1.Handle, EM_SETCHARFORMAT, SCF_SELECTION, LPARAM(@Format));
end;


procedure TwwRichEditForm.FontNameComboCloseUp(Sender: TwwDBComboBox;
  Select: Boolean);
begin
  if not Select then exit;
  SetRichEditFontName(FontNameCombo.Text);
  RichEdit1.SetFocus;
  RefreshControls;
end;

procedure TwwRichEditForm.FontSizeComboCloseUp(Sender: TwwDBComboBox;
  Select: Boolean);
begin
   if not Select then exit;
   if FontSizeCombo.text='' then exit;
   RichEdit1.SelAttributes.Size:= StrToInt(FontSizeCombo.Text);
   RichEdit1.SetFocus;
   RefreshControls;
end;

procedure TwwRichEditForm.BulletStyle1Click(Sender: TObject);
begin
   TempDown:=  (richedit1.Paragraph.Numbering = nsBullet);
   BulletButton.OnClick(Sender);
end;

procedure TwwRichEditForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if RichEdit1.readOnly then begin
     if ord(key)=vk_escape then Close;
  end
  else if ord(key)=vk_escape then begin
     if reoCloseOnEscape in RichEdit1.EditorOptions then
        Close
     else
        Undo1Click(Sender)
  end
  else begin
     if GetKeyState(VK_CONTROL) >=0 then exit;

     if ord(key)=(ord('B')+1-ord('A')) then begin
        TempDown:=  fsBold in richedit1.SelAttributes.Style;
        BoldButton.onClick(BoldButton);
        key:= #0;
     end
     else if ord(key)=(ord('U')+1-ord('A')) then begin
        TempDown:=  fsUnderline in richedit1.SelAttributes.Style;
        UnderlineButton.onClick(UnderlineButton);
        key:= #0;
     end
     else if ord(key)=(ord('I')+1-ord('A')) then begin
        TempDown:=  fsItalic in richedit1.SelAttributes.Style;
        ItalicButton.onClick(ItalicButton);
        key:= #0;
     end
  end
end;



procedure TwwRichEditForm.UpdateStatusBar;
var KeyState: TKeyboardState;
begin
   GetKeyboardState(KeyState);
   with wwInternational.RichEdit do begin
     if KeyState [VK_NumLock] <> 0 then StatusBar.Panels[2].text:= NUMLockCaption
     else StatusBar.Panels[2].text:= '';
     if KeyState [VK_Capital] <> 0 then StatusBar.Panels[1].text:= CAPLockCaption
     else StatusBar.Panels[1].text:= '';
   end;
end;

procedure TwwRichEditForm.FormShow(Sender: TObject);
var i: integer;
begin
   OrigOnHint := Application.OnHint;
   Application.OnHint := FormChangeHint;

   RichEdit1.GutterWidth:= 6;
   for i:= 0 to Screen.Fonts.Count-1 do begin
      if (RichEdit1.EditWidth=rewWindowSize) or
        (Printer.Fonts.indexOf(Screen.Fonts[i])>=0) then
         FontNameCombo.Items.Add(Screen.Fonts[i]);
   end;

   UpdateStatusBar;
   RefreshControls;
   RichEdit1.modified:= False;

   with RichEdit1 do begin
      if ReadOnly then begin
         EditorOptions:= EditorOptions -
            [reoShowLoad, reoShowSaveAs, reoShowSaveExit,
             reoShowStatusBar, reoShowFormatBar, reoShowToolBar];
      end;

      if not (reoShowLoad in EditorOptions) then begin
         Load1.visible:= false;
         LoadButton1.visible:= False;
      end;
      if not (reoShowSaveAs in EditorOptions) then begin
         SaveAs1.visible:= false;
         SaveAsButton.visible:= False;
      end;
      if not (reoShowPrint in EditorOptions) then begin
         Print1.visible:= false;
         PrintButton.visible:= False;
      end;
      if ([reoShowPrint, reoShowPageSetup] * EditorOptions = []) then
         FileSep2.visible:= False;

      if not (reoShowPageSetup in EditorOptions) then PageSetup1.visible:= false;

      if not (reoShowSaveExit in EditorOptions) then begin
         SaveExit1.visible:= false;
      end;

      if ([reoShowLoad,reoShowSaveExit] * EditorOptions = []) then
         FileSep1.visible:= False;

      StatusBar.visible:= reoShowStatusBar in EditorOptions;
      FormatBar.visible:= reoShowFormatBar in EditorOptions;
      ToolBar.visible:= reoShowToolBar in EditorOPtions;
      ToolBarBevel.visible:= reoShowToolBar in EditorOPtions;
      FormatBarBevel.visible:= reoShowFormatBar in EditorOptions;

      if ReadOnly then begin
         Format1.visible:= False;
         View1.visible:= False;
         NewButton.visible:= False;
      end;


   end;

   Width:= wwAdjustPixels(Width, PixelsPerInch);
   Height:= wwAdjustPixels(Height, PixelsPerInch);
   with StatusBar do begin
     Panels[1].Width:= wwAdjustPixels(Panels[1].Width, PixelsPerInch);
     Panels[2].Width:= wwAdjustPixels(Panels[2].Width, PixelsPerInch);
     Panels[3].Width:= wwAdjustPixels(Panels[3].Width, PixelsPerInch);
   end;

   ApplyIntl;
   richedit1.DoInitDialog(self);
end;

procedure TwwRichEditForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (ssCtrl in Shift) and (key=ord('Z')) then Undo1Click(Sender);
   UpdateStatusBar;
end;

procedure TwwRichEditForm.Paragraph1Click(Sender: TObject);
begin
   RichEdit1.ExecuteParagraphDialog;
end;

procedure TwwRichEditForm.Edit1Click(Sender: TObject);
begin
   RefreshControls;
end;


procedure TwwRichEditForm.Print1Click(Sender: TObject);
var i: integer;
begin
  {Note: In order for an uncollated printout to take place, the target printer     }
  {      must support the setting of # of Copies via the Win API, and many do not. }
  {      Thus, the  Collate option is set to TRUE and NOTHING is done if the user  }
  {      changes it to FALSE (it still produces a collated printout)...            }
   printdialog1.collate:= True;
   if printdialog1.execute then
   begin
      for i:= 1 to printdialog1.copies do
         richedit1.Print('Test');
   end
end;


procedure TwwRichEditForm.UpdateFormatToolBar(ShowToolBar, ShowFormatBar: boolean);
begin
   if ShowToolBar then begin
      if ShowFormatBar then begin
         ToolBarBevel.visible:= True;
         ToolBar.visible:= True;
         FormatBarBevel.visible:= True;
         FormatBar.visible:= True;
      end
      else begin
         FormatBar.visible:= False;
         FormatBarBevel.visible:= False;
         ToolBarBevel.visible:= True;
         ToolBar.visible:= True;
      end
   end
   else begin
      if ShowFormatBar then begin
         ToolBar.visible:= False;
         ToolBarBevel.visible:= False;
         FormatBarBevel.visible:= True;
         FormatBar.visible:= True;
      end
      else begin
         FormatBar.visible:= False;
         FormatBarBevel.visible:= False;
         ToolBar.visible:= False;
         ToolBarBevel.visible:= FAlse;
      end
   end;
end;

procedure TwwRichEditForm.Toolbar1Click(Sender: TObject);
begin
   UpdateFormatToolBar(not ToolBar.visible, FormatBar.visible);
   ToolBar1.checked:= ToolBar.visible;
end;

procedure TwwRichEditForm.FormatBar1Click(Sender: TObject);
begin
   UpdateFormatToolBar(ToolBar.visible, not FormatBar.visible);
   FormatBar1.checked:= FormatBar.visible;
end;

procedure TwwRichEditForm.StatusBar1Click(Sender: TObject);
begin
   StatusBar.visible:= not StatusBar.visible;
   StatusBar1.checked:= StatusBar.visible;
end;

procedure TwwRichEditForm.Exit1Click(Sender: TObject);
begin
   ModalResult:= mrCancel;
end;

procedure TwwRichEditForm.SaveExit1Click(Sender: TObject);
begin
   ModalResult:= mrOK;
end;

procedure TwwRichEditForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var answer: integer;
begin
   if ModalResult=mrOK then exit;

   if RichEdit1.modified then
   begin
      answer:= MessageDlg(wwInternational.UserMessages.RichEditExitWarning,
                 mtConfirmation, [mbYes, mbNo, mbCancel], 0);
      if (answer = mrYes) then begin
         ModalResult:= mrOK;
      end
      else if (answer = mrNo) then begin
         ModalResult:= mrCancel;
      end
      else CanClose:= False;
   end
   else ModalResult:= mrCancel;

end;

procedure TwwRichEditForm.Tabs1Click(Sender: TObject);
begin
   richedit1.executeTabDialog;
end;

procedure TwwRichEditForm.FormResize(Sender: TObject);
begin
   richedit1.setEditRect;
   StatusBar.Panels[0].width:= Width - wwAdjustPixels(90, PixelsPerInch);
end;


procedure GetPrinter(var DeviceMode, DeviceNames: THandle);
var
  Device, Driver, Port: array[0..79] of char;
  DevNames: PDevNames;
  Offset: PChar;
begin
  Printer.GetPrinter(Device, Driver, Port, DeviceMode);
  if DeviceMode <> 0 then
  begin
    DeviceNames := GlobalAlloc(GHND, SizeOf(TDevNames) +
     StrLen(Device) + StrLen(Driver) + StrLen(Port) + 3);
    DevNames := PDevNames(GlobalLock(DeviceNames));
    try
      Offset := PChar(DevNames) + SizeOf(TDevnames);
      with DevNames^ do
      begin
        wDriverOffset := Longint(Offset) - Longint(DevNames);
        Offset := StrECopy(Offset, Driver) + 1;
        wDeviceOffset := Longint(Offset) - Longint(DevNames);
        Offset := StrECopy(Offset, Device) + 1;
        wOutputOffset := Longint(Offset) - Longint(DevNames);;
        StrCopy(Offset, Port);
      end;
    finally
      GlobalUnlock(DeviceNames);
    end;
  end;
end;

function CopyData(Handle: THandle): THandle;
var
  Src, Dest: PChar;
  Size: Integer;
begin
  if Handle <> 0 then
  begin
    Size := GlobalSize(Handle);
    Result := GlobalAlloc(GHND, Size);
    if Result <> 0 then
      try
        Src := GlobalLock(Handle);
        Dest := GlobalLock(Result);
        if (Src <> nil) and (Dest <> nil) then Move(Src^, Dest^, Size);
      finally
        GlobalUnlock(Handle);
        GlobalUnlock(Result);
      end
  end
  else Result := 0;
end;

procedure SetPrinter(DeviceMode, DeviceNames: THandle);
var
  DevNames: PDevNames;
begin
  DevNames := PDevNames(GlobalLock(DeviceNames));
  try
    with DevNames^ do begin
      Printer.SetPrinter(PChar(DevNames) + wDeviceOffset,
        PChar(DevNames) + wDriverOffset,
        PChar(DevNames) + wOutputOffset, DeviceMode);
    end;
  finally
    GlobalUnlock(DeviceNames);
    GlobalFree(DeviceNames);
  end;
end;


procedure SetPrinterDev(DevMode: PDeviceMode; DeviceMode, DeviceNames: THandle);
var
  DevNames: PDevNames;
  FPrinterHandle: THandle;
begin
  DevNames := PDevNames(GlobalLock(DeviceNames));
  try
    with DevNames^ do begin
      if OpenPrinter(PChar(DevNames) + wDeviceOffset, FPrinterHandle, nil) then
      begin
         ShowMessage(inttostr(DocumentProperties(Application.handle, FPrinterHandle, PChar(DevNames) + wDeviceOffset,
            PDevMode(Nil)^, DevMode^, DM_IN_BUFFER)));
         if FPrinterHandle <> 0 then ClosePrinter(FPrinterHandle);
      end;
    end;
  finally
    GlobalUnlock(DeviceNames);
  end;
end;


{Center PageSetup Dialog }
function PageSetupHook(Wnd: HWnd; Msg: UINT; WParam: WPARAM; LParam: LPARAM): UINT; stdcall;
  procedure CenterWindow(Wnd: HWnd);
  var Rect: TRect;
  begin
    GetWindowRect(Wnd, Rect);
    SetWindowPos(Wnd, 0,
      (GetSystemMetrics(SM_CXSCREEN) - Rect.Right + Rect.Left) div 2,
      (GetSystemMetrics(SM_CYSCREEN) - Rect.Bottom + Rect.Top) div 3,
      0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
  end;
begin
  Result := 0;
  case Msg of
    WM_INITDIALOG:
      begin
        Subclass3DDlg(Wnd, CTL3D_ALL);
        SetAutoSubClass(True);
        CenterWindow(Wnd);
      end;
    WM_DESTROY:
      SetAutoSubClass(False);
  end;
end;

{ TCommonDialog }
Function TwwPageSetupDialog.execute: boolean;
var setup: TPageSetupDlg;
    hOrigDeviceMode: THandle;
    hDeviceMode: THandle;
    DeviceMode : PDeviceMode;
    tempOrientation : TPrinterOrientation;
    tempPrintPageSize: integer;
begin
  FillChar(setup, SizeOf(TPageSetupDlg), 0);
  with Setup do begin
     lStructSize := SizeOf(TPageSetupDlg);
     hWndOwner := Application.Handle;
     {$ifdef ver100}
     hInstance := SysInit.HInstance;
     {$else}
     hInstance := System.HInstance;
     {$endif}
     GetPrinter(hOrigDeviceMode, hDevNames);
     hDeviceMode := CopyData(hOrigDeviceMode);
     lpfnPageSetupHook := PageSetupHook;

     flags:= PSD_MARGINS or PSD_ENABLEPAGESETUPHOOK;
     if richedit1.editwidth=rewWindowSize then flags:= flags or PSD_DISABLEPAPER;

     with RichEdit1 do begin
        if MeasurementUnits=muInches then
           flags:= flags or PSD_INTHOUSANDTHSOFINCHES
        else flags:= flags or PSD_INHUNDREDTHSOFMILLIMETERS;
        rtMargin.left:= Trunc(PrintMargins.left*1000);
        rtMargin.top:= Trunc(PrintMargins.top*1000);
        rtMargin.right:= Trunc(PrintMargins.right*1000);
        rtMargin.bottom:= Trunc(PrintMargins.bottom*1000);
        if richedit1.editwidth=rewPrinterSize then
        begin
           DeviceMode := GlobalLock(hDeviceMode);
           DeviceMode.dmPaperSize:= PrintPageSize;
           GlobalUnlock(hDeviceMode);
        end
     end;
     Result := TaskModalDialog(@PageSetupDlg, setup);
     if Result then with RichEdit1 do begin
        PrintMargins.Left:=  rtMargin.left /1000;
        PrintMargins.right:= rtMargin.right / 1000;
        PrintMargins.top:= rtMargin.top / 1000;
        Printmargins.bottom:= rtMargin.bottom / 1000;

        DeviceMode := GlobalLock(hDeviceMode);  { Set printer attributes }
        tempPrintPageSize:= DeviceMode.dmPaperSize;
        if DeviceMode.dmOrientation=DMORIENT_LANDSCAPE then
           tempOrientation:= poLandscape
        else tempOrientation:= poPortrait;
        GlobalUnlock(hDeviceMode);

        SetPrinter(hDeviceMode, hDevNames);  { Choose printer }
        Printer.orientation:= tempOrientation;
        PrintPageSize:= tempPrintPageSize;
        UpdatePrinter;

     end
     else begin
       if hDeviceMode <> 0 then GlobalFree(hDeviceMode);
       if hDevNames <> 0 then GlobalFree(hDevNames);
     end;

  end;
end;

procedure TwwRichEditForm.PageSetup1Click(Sender: TObject);
begin
   with TwwPageSetupDialog.create(self) do
   begin
      RichEdit1:= self.RichEdit1;
      if Execute then self.RichEdit1.SetEditRect;
      Free;
   end
end;


procedure TwwRichEditForm.Load1Click(Sender: TObject);
begin
{  if MessageDlg(wwInternational.UserMessages.RichEditLoadWarning,
                 mtConfirmation, [mbOK, mbCancel], 0)  <> mrOK then exit;
}
  if OpenDialog1.Execute then
  begin
    RichEdit1.Lines.LoadFromFile(OpenDialog1.FileName);
    RichEdit1.SetFocus;
  end;
end;

procedure TwwRichEditForm.SaveAs1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    if FileExists(SaveDialog1.FileName) then
      if MessageDlg(Format('OK to overwrite %s', [SaveDialog1.FileName]),
        mtConfirmation, mbYesNoCancel, 0) <> idYes then Exit;
    RichEdit1.Lines.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TwwRichEditForm.NewButtonClick(Sender: TObject);
begin
   if MessageDlg(wwInternational.UserMessages.RichEditClearWarning,
                 mtConfirmation, [mbOK, mbCancel], 0)  <> mrOK then exit;

   richedit1.clear;
   richedit1.modified:= True;
end;

procedure TwwRichEditForm.LoadButton1Click(Sender: TObject);
begin
   Load1Click(Sender);
end;

procedure TwwRichEditForm.SaveAsButtonClick(Sender: TObject);
begin
   SaveAs1Click(Sender);
end;

procedure TwwRichEditForm.PrintButtonClick(Sender: TObject);
begin
    Print1Click(Sender);
end;

procedure TwwRichEditForm.FindButtonClick(Sender: TObject);
begin
   Find1Click(Sender);
end;

procedure TwwRichEditForm.CutButtonClick(Sender: TObject);
begin
  Cut1Click(Sender);
end;

procedure TwwRichEditForm.CopyButtonClick(Sender: TObject);
begin
  Copy1Click(Sender);
end;

procedure TwwRichEditForm.PasteButtonClick(Sender: TObject);
begin
   Paste1Click(Sender);
end;

procedure TwwRichEditForm.UndoButtonClick(Sender: TObject);
begin
   Undo1Click(Sender);
end;

procedure TwwRichEditForm.FontNameComboDropDown(Sender: TObject);
begin
   FontNameCombo.font.color:=clBlack;
end;

procedure TwwRichEditForm.FormChangeHint(Sender: TObject);
begin
   StatusBar.Panels[0].text:=Application.Hint;
end;

procedure TwwRichEditForm.ApplyIntl;
begin
    with wwInternational.RichEdit do begin

       if (reoShowHints in richedit1.EditorOptions) then begin
          FontNameCombo.ShowHint := True;
          FontSizeCombo.ShowHint := True;
          NewButton.ShowHint := True;
          LoadButton1.ShowHint := True;
          SaveAsButton.ShowHint := True;
          PrintButton.ShowHint := True;
          FindButton.ShowHint := True;
          CutButton.ShowHint := True;
          CopyButton.ShowHint := True;
          UndoButton.ShowHint := True;
          PasteButton.ShowHint := True;
          BoldButton.ShowHint := True;
          UnderlineButton.ShowHint := True;
          ItalicButton.ShowHint := True;
          LeftButton.ShowHint := True;
          CenterButton.ShowHint := True;
          RightButton.ShowHint := True;
          BulletButton.ShowHint := True;

    {Change Hints}
    FontNameCombo.Hint := FontNameComboHint;
    FontSizeCombo.Hint := FontSizeComboHint;

    {Buttons}
    NewButton.Hint := NewButtonHint;
    LoadButton1.Hint := LoadButtonHint;
    SaveAsButton.Hint := SaveAsButtonHint;
    PrintButton.Hint := PrintButtonHint;
    FindButton.Hint := FindButtonHint;
    CutButton.Hint := CutButtonHint;
    CopyButton.Hint := CopyButtonHint;
    UndoButton.Hint := UndoButtonHint;
    PasteButton.Hint := PasteButtonHint;
    BoldButton.Hint := BoldButtonHint;
    UnderlineButton.Hint := UnderlineButtonHint;
    ItalicButton.Hint := ItalicButtonHint;
    LeftButton.Hint := LeftButtonHint;
    CenterButton.Hint := CenterButtonHint;
    RightButton.Hint := RightButtonHint;
    BulletButton.Hint := BulletButtonHint;

    {File Menu Items}
    Load1.Hint:= LoadButton1.Hint;
    SaveAs1.Hint:= SaveAsButton.Hint;
    SaveExit1.Hint := SaveExitHint;
    Print1.Hint := PrintButton.Hint;
    PageSetup1.Hint:=PageSetupHint;
    Exit1.Hint:= ExitHint;

    {Edit Menu Items}
    Undo1.Hint:= UndoButton.Hint;
    Cut1.Hint:= CutButton.Hint;
    Copy1.Hint:= CopyButton.Hint;
    Paste1.Hint:= PasteButton.Hint;
    Find1.Hint:=FindButton.Hint;
    Clear1.Hint:= ClearHint;
    SelectAll1.Hint:= SelectAllHint;
    FindNext1.Hint:= FindNextHint;
    Replace1.Hint:=ReplaceHint;

    {View Menu Items}
    Toolbar1.Hint:= ToolbarHint;
    FormatBar1.Hint:= FormatBarHint;
    StatusBar1.Hint :=ViewStatusBarHint;
    Options1.Hint:=OptionsHint;

    {Format Menu Items}
    Font1.Hint:=FontHint;
    BulletStyle1.Hint:= BulletButton.Hint;
    Paragraph1.Hint:= ParagraphHint;
    Tabs1.Hint:=TabsHint;

    end
    else Application.OnHint := nil;

{Change Menu Item Labels}

    File1.Caption := MenuLabels.FileCaption;
    Load1.Caption := MenuLabels.LoadCaption;
    SaveAs1.Caption := MenuLabels.SaveAsCaption;
    SaveExit1.Caption := MenuLabels.SaveExitCaption;
    Print1.Caption := MenuLabels.PrintCaption;
    PageSetup1.Caption := MenuLabels.PageSetupCaption;
    Exit1.Caption := MenuLabels.ExitCaption;

    Edit1.Caption := MenuLabels.EditCaption;
    Undo1.Caption := MenuLabels.UndoCaption;
    Cut1.Caption := MenuLabels.CutCaption;
    Copy1.Caption := MenuLabels.CopyCaption;
    Paste1.Caption := MenuLabels.PasteCaption;
    Clear1.Caption := MenuLabels.ClearCaption;
    Selectall1.Caption := MenuLabels.SelectallCaption;
    Find1.Caption:= MenuLabels.FindCaption;
    FindNext1.Caption:=MenuLabels.FindNextCaption;
    Replace1.Caption:=MenuLabels.ReplaceCaption;

    View1.Caption := MenuLabels.ViewCaption;
    Toolbar1.Caption:= MenuLabels.ToolbarCaption;
    FormatBar1.Caption:=MenuLabels.FormatBarCaption;
    StatusBar1.Caption:=MenuLabels.ViewStatusBarCaption;
    Options1.Caption:=MenuLabels.OptionsCaption;

    Format1.Caption:=MenuLabels.FormatCaption;
    Font1.Caption:=MenuLabels.FontCaption;
    BulletStyle1.Caption:=MenuLabels.BulletStyleCaption;
    Paragraph1.Caption:=MenuLabels.ParagraphCaption;
    Tabs1.Caption := MenuLabels.TabsCaption;

    Help1.Caption := MenuLabels.HelpCaption;
    end;
end;

procedure TwwRichEditForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Application.OnHint:= OrigOnHint;
end;

end.
