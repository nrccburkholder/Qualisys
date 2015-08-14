unit Wwmemo;
{
//
// Components : TwwMemoDialog
//
// Copyright (c) 1995 by Woll2Woll Software
//
// 8/12/96 - Changed TMemoField reference to TBlobField reference
}
interface

 uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, ExtCtrls, DBCtrls, DB, DBTables, Dialogs, SysUtils;

type
  TwwMemoAttribute =(mSizeable, mWordWrap, mGridShow, mViewOnly, mDisableDialog);
  TwwMemoAttributes = Set of TwwMemoAttribute;

  TwwMemoDlg = class(TForm)
    Memo: TMemo;
    UserButtonPanel: TPanel;
    UserButton1: TButton;
    UserButton2: TButton;

    procedure ResizeControls(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure MemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UserButton1Click(Sender: TObject);
    procedure UserButton2Click(Sender: TObject);

  private
    OKBtnpressed: boolean;
    posRect: TRect;
    procedure ApplyIntl;

  protected
    changed: boolean;
    init: boolean;
    allowClose: boolean;
    procedure KeyPress(var key: char);  override;

  public
    TempFont: TFont;  {Used when activating form the first time}
    TempTitle: String;
    CallingComponent : TComponent;
    OKBtn, CancelBtn: TButton;

    constructor Create(AOwner: TComponent); override;

  end;

Function wwEditMemoField(AParentForm: TForm;
                         ADialog: TComponent; Editable: boolean): boolean;

procedure Register;

implementation

{$R *.DFM}

uses wwdbgrid,
     {$ifndef win32}
     wwrcdvw,
     {$endif}
     wwIntl;

{$ifndef win32}
   procedure GetMemo(memoField: TBlobField; Memo: TMemo);
   const MaxMemoSize = 32767;
   var memoBuffer, memoBufferFinal: PChar;
       blobStream: TBlobStream;
       numRead: longint;
       i, j: integer;
   begin
      if memoField<>Nil then begin
         GetMem(memoBuffer, MaxMemoSize);
         GetMem(memoBufferFinal, MaxMemoSize);
         blobStream:= TBlobStream.create(TBlobField(memofield), bmRead);
         numread:= blobStream.read(memoBuffer^, MaxMemoSize);

         { Convert stand-alone Linefeeds to carriage return line feeds. }
         j:= 0;
         for i:= 0 to numRead-1 do begin
            if (memoBuffer[i]=#10) and ((i=0) or (memoBuffer[i-1]<>#13))  then begin
               memoBufferFinal[j]:= #13;
               j:= j + 1;
            end;
            memoBufferFinal[j]:= memoBuffer[i];
            j:= j + 1;
         end;
         memoBufferFinal[j]:= #0; {null-terminate}

         Memo.SetTextBuf(memoBufferFinal);
         FreeMem(memoBuffer, MaxMemoSize);
         FreeMem(memoBufferFinal, MaxMemoSize);
         blobStream.Free;
      end;
   end;

{$endif}

Function wwEditMemoField(AParentForm: TForm;
                         ADialog: TComponent; Editable: boolean): boolean;
var Dialog: TwwMemoDialog;
    {$ifndef win32}
    memoField: TBlobField;
    {$endif}
    curField: TField;
begin
{   memoField:= nil; { make compiler happy}

   with TwwMemoDlg.create(Application) do
   try
      if (AParentForm<>Nil) and (AParentForm.FormStyle=fsStayOnTop) then
         FormStyle:= fsStayOnTop;

      CallingComponent:= ADialog;
      Dialog:= callingComponent as TwwMemoDialog;

      if (Dialog.datasource<>Nil) and (Dialog.datasource.dataset<>Nil) and
         (Dialog.DataField<>'') then
      begin
         curField:= Dialog.datasource.dataset.fieldByName(Dialog.DataField);

         {$ifndef win32}
         if curField is TBlobField then begin
            memoField:= curField as TBlobField;
            GetMemo(memoField, Memo);
            if memoField.readonly then editable:= false;
         end
         else begin
            Memo.Text:= curfield.Text;
         end;
         {$else}
         Memo.Text:= curfield.asString;  {5/13/97}
         {$endif}
      end
      else curField:= nil;

      Memo.WordWrap:= mWordWrap in Dialog.MemoAttributes;

      if mSizeable in Dialog.MemoAttributes then BorderStyle := bsSizeable
      else BorderStyle:= bsDialog;

      TempFont:= Dialog.Font;
      TempTitle:= Dialog.Caption;

      if not editable then begin
         CancelBtn.visible:= False;
         Memo.ReadOnly:= True;
      end;

      posRect.left:= Dialog.DlgLeft;
      posRect.top:= Dialog.DlgTop;
      posRect.right:= Dialog.DlgLeft + Dialog.DlgWidth;
      posRect.bottom:= Dialog.DlgTop + Dialog.DlgHeight;

      if (posRect.left>0) or (posRect.Top>0) then
         Position:= poDefault;  {manually position form }
      UserButton1.caption:= Dialog.UserButton1Caption;
      UserButton2.caption:= Dialog.UserButton2Caption;
      Result := ShowModal = IDOK;
      Dialog.DoCloseDialog;
      if Result and Editable and (curField<>Nil) then begin
         {$ifndef win32}
         if (curField is TBlobField) then begin
            memofield.dataset.edit;
            memoField.Assign(Memo.Lines);
            if not (AParentForm is TwwRecordViewForm) then
               memofield.dataset.checkBrowseMode;  {Required for Delphi 1 }
            memoField.dataset.edit;
         end
         else begin
            curfield.dataset.edit;
            curfield.asString:= memo.text;
         end
         {$else}
         curfield.dataset.edit;
         curfield.asString:= memo.text;
         {$endif}
      end;
   finally
      Free;
   end
end;


constructor TwwMemoDlg.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   init:= False;
   okBtnPressed:= False;

   OkBtn:= TButton(wwCreateCommonButton(Self, bkOK));
   OKBtn.TabOrder := 1;
   OKBtn.OnClick := OKBtnClick;
   CancelBtn:= TButton(wwCreateCommonButton(Self, bkCancel));
   CancelBtn.TabOrder := 2;
end;

procedure TwwMemoDlg.ResizeControls(Sender: TObject);
const spacing = 20;
var
   windowExtra: integer;
   hasUserButton: boolean;
begin
   windowExtra := {Compute size of windows title bar + borders }
      GetSystemMetrics(SM_CYDLGFRAME)*2 +
      GetSystemMetrics(SM_CYCAPTION);  {Win95 fix }

   { Resize memo control }
   Memo.width := width - 20;
   Memo.height := height - (windowExtra + 53);
   Memo.top:= 6;
   Memo.left:= 6;

   OkBtn.Top:= Memo.height + 17;
   CancelBtn.Top:= Memo.height + 17;
   if UserButtonPanel.visible then UserButtonPanel.top:= Memo.Top + Memo.Height + 2; {10/28/96 }

   HasUserButton:= (UserButton1.caption<>'') or (UserButton2.caption<>'');

   if Memo.ReadOnly then begin
      if hasUserButton then
         OKBtn.Left:= Memo.Left + Memo.Width - OKBtn.Width - 25
      else OKBtn.Left:= Memo.Left + ((Memo.Width div 2)- (CancelBtn.Width div 2));
   end
   else begin
      OKBtn.Left:= Memo.Width - ((OKBtn.Width + Spacing) * 2);
      CancelBtn.Left:= Memo.Width - ((OKBtn.Width + Spacing) * 1);
      CancelBtn.visible:= True;
   end;

   OkBtn.visible:= True;
end;

procedure TwwMemoDlg.OKBtnClick(Sender: TObject);
begin
   AllowClose:= True;
   OKBtnPressed:= True;
end;

procedure TwwMemoDlg.KeyPress(var key: char);
begin
    if Key<>#27 then inherited KeyPress(key)
    else Key := #0;
end;

procedure Register;
begin
{  RegisterComponents('InfoPower', [TwwMemoDialog]);}
end;

procedure TwwMemoDlg.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var answer: integer;
begin
   canClose:= True;

   if memo.modified and not OKBtnPressed then begin
{   if Changed and not OKBtnPressed then begin}
     answer:=
        MessageDlg(wwInternational.UserMessages.MemoChangesWarning,
                 mtConfirmation, [mbYes, mbNo], 0);
     if (answer = mrYes) then begin
        ModalResult:= mrCancel;
     end
     else canClose:= False;
   end
   else if (okBtnPressed and (not AllowClose)) then canClose:= False;

   okBtnPressed:= False;
end;

procedure TwwMemoDlg.FormShow(Sender: TObject);
var UserButtonX: integer;
    Dialog: TwwMemoDialog;
begin
   if not init then begin
      Changed:= False;
      Init:= True;
      KeyPreview:= True;
      Memo.font:= TempFont;
      self.Caption:= TempTitle;

      if (posRect.left=0) and (posRect.Top=0) then begin { 2/9/97 - Top=0}
         Width:= posRect.right - posRect.left;
         Height:= posRect.bottom - posRect.top;
      end
      else if (posRect.left>0) or (posRect.Top>0) then begin { 2/9/97 - Top>0}
         Left:= posRect.left;
         Top:= posRect.top;
         Width:= posRect.right - posRect.left;
         Height:= posRect.bottom - posRect.top;
      end;

      if (UserButton1.caption<>'') or (UserButton2.caption<>'') then begin
         UserButtonPanel.visible:= True;
         UserButtonPanel.top:= Memo.Top + Memo.Height + 2;
         UserButtonPanel.left:= Memo.Left - 1;
         UserButtonX:= 0;

         if UserButton1.caption<>'' then begin
            UserButton1.visible:= True;
            UserButton1.left:= UserButtonX + 10;
            UserButtonX := UserButton1.left + UserButton1.width;
         end;

         if UserButton2.caption<>'' then begin
            UserButton2.visible:= True;
            UserButton2.left:= UserButtonX + 15;
            UserButtonX := UserButton2.left + UserButton2.width;
         end;

         UserButtonPanel.width:= UserButtonX + 10;
      end;

      ApplyIntl;
      Dialog:= callingComponent as TwwMemoDialog;
      Dialog.Form:= self;
      Dialog.DoInitDialog;
      memo.modified := False;


   end
end;

procedure TwwMemoDlg.MemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if ((ssCtrl in Shift) and (key = VK_RETURN)) or (key=VK_F2) then begin
      ModalResult:= mrOK;
      OKBtnClick(Sender);
   end
   else if (key = VK_ESCAPE) then begin
      ModalResult:= mrCancel;
   end;
end;

procedure TwwMemoDlg.UserButton1Click(Sender: TObject);
var tempEvent: TwwMemoUserButtonEvent;
    Dialog: TwwMemoDialog;
begin
    Dialog:= callingComponent as TwwMemoDialog;
    tempEvent:= Dialog.OnUserButton1Click;
    if Assigned(tempEvent) then
       Dialog.OnUserButton1Click(self, Memo);
end;

procedure TwwMemoDlg.UserButton2Click(Sender: TObject);
var tempEvent: TwwMemoUserButtonEvent;
    Dialog: TwwMemoDialog;
begin
    Dialog:= callingComponent as TwwMemoDialog;
    tempEvent:= Dialog.OnUserButton2Click;
    if Assigned(tempEvent) then
       Dialog.OnUserButton2Click(self, Memo);
end;

procedure TwwMemoDlg.ApplyIntl;
begin
   Font.Style:= wwInternational.DialogFontStyle;
end;

end.
