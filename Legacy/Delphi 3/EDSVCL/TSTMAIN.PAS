{ This demo shows how to use the TOpenDialog,
  TSaveDialog, TFindDialog and TReplaceDialog
  components along with the LoadFromFile and
  SaveToFile methods of a TStringList (in this
  case the string list in Memo1). }

{ and now... how to spell check that memo}

unit TstMain;

interface

uses WinTypes, WinProcs, Classes, Graphics, Controls, Menus,
  Forms, StdCtrls, Dialogs, ExtCtrls, MemoUtil,
{$IFDEF Win32}
  Spell32,
{$ENDIF}
{$IFDEF Ver100}
  Spell32,
{$ENDIF}
{$IFDEF Ver80}
  Spell16,
{$ENDIF}
  TestDlg, SpellTbl;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    FindDialog1: TFindDialog;
    Search1: TMenuItem;
    Find1: TMenuItem;
    Replace1: TMenuItem;
    FindNext1: TMenuItem;
    ReplaceDialog1: TReplaceDialog;
    Actions1: TMenuItem;
    SpellCheck1: TMenuItem;
    Panel1: TPanel;
    CountWords1: TMenuItem;
    SpellDlg1: TSpellDlg;
    N2: TMenuItem;
    SpellDialog1: TMenuItem;
    procedure New1Click(Sender: TObject);
    procedure FileOpenClick(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure Find(Sender : TObject);
    procedure FindNext1Click(Sender: TObject);
    procedure Replace1Click(Sender: TObject);
    procedure Replace(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SpellCheck1Click(Sender: TObject);
    procedure UpdateXY;
    procedure Memo1Change(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure Memo1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Memo1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CountWords1Click(Sender: TObject);
    procedure SpellDialog1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

uses SysUtils, Search;

{$R *.DFM}

procedure TForm1.New1Click(Sender: TObject);
begin
  Memo1.Clear;
  OpenDialog1.Filename := '';
  Caption := 'Text Demo - [Untitled]';
end;

procedure TForm1.FileOpenClick(Sender: TObject);
var
  Buffer:     pChar;
  BufferSize: Longint;
  f:          file;
begin
  with OpenDialog1 do
    if Execute then
    begin
      Memo1.Lines.LoadFromFile(FileName);
      try
        BufferSize := Memo1.GetTextLen + 1;
        GetMem (Buffer, BufferSize);
        if Memo1.GetTextBuf (Buffer, BufferSize)<>BufferSize-1 then
          MessageDlg ('Error Allocating Buffer...', mtError, [mbOk], 0);
        OemToAnsiBuff (Buffer, Buffer, BufferSize);
        Memo1.SetTextBuf (Buffer);
      finally
        FreeMem (Buffer, BufferSize);
      end;  { try }
      Caption := 'Text Demo - ' + ExtractFilename(FileName);
    end;
end;

procedure TForm1.Save1Click(Sender: TObject);
var
  Buffer:     PChar;
  BufferSize: Longint;
begin
  if OpenDialog1.Filename <> '' then
  begin
    try
      BufferSize := Memo1.GetTextLen + 1;
      GetMem (Buffer, BufferSize);
      if Memo1.GetTextBuf (Buffer, BufferSize)<>BufferSize-1 then
        MessageDlg ('Error Allocating Buffer...', mtError, [mbOk], 0);

      AnsiToOemBuff (Buffer, Buffer, BufferSize);
      Memo1.SetTextBuf (Buffer);
      Memo1.Lines.SaveToFile(OpenDialog1.Filename);
      Memo1.Modified := False;
      OemToAnsiBuff (Buffer, Buffer, BufferSize);
      Memo1.SetTextBuf (Buffer);
    finally
      FreeMem (Buffer, BufferSize);
    end;  { try }
  end
    else SaveAs1Click(Sender);
end;

procedure TForm1.SaveAs1Click(Sender: TObject);
begin
  with SaveDialog1 do
    if Execute then
    begin
      Memo1.Lines.SaveToFile(Filename);
      Caption := 'Text Demo - ' + ExtractFilename(FileName);
      OpenDialog1.Filename := Filename;
    end;
end;

procedure TForm1.Find1Click(Sender: TObject);
begin
  FindDialog1.Execute;
  FindNext1.Enabled := True;
end;

procedure TForm1.Find(Sender: TObject);
begin
  with Sender as TFindDialog do
    if not SearchMemo(Memo1, FindText, Options) then
      ShowMessage('Cannot find "' + FindText + '".');
end;

procedure TForm1.Replace1Click(Sender: TObject);
begin
  ReplaceDialog1.Execute;
end;

procedure TForm1.FindNext1Click(Sender: TObject);
begin
  Find(FindDialog1);
end;

{ Replace and ReplaceAll call this routine. }
procedure TForm1.Replace(Sender: TObject);
var
  Found: Boolean;
begin
  with ReplaceDialog1 do
  begin
    if AnsiCompareText(Memo1.SelText, FindText) = 0 then
      Memo1.SelText := ReplaceText;
    Found := SearchMemo(Memo1, FindText, Options);
    while Found and (frReplaceAll in Options) do
    begin
      Memo1.SelText := ReplaceText;
      Found := SearchMemo(Memo1, FindText, Options);
    end;
    if (not Found) and (frReplace in Options) then
      ShowMessage('Cannot find "' + FindText + '".');
  end;
end;

procedure TForm1.FileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  MsgResult: Word;
begin
  if Memo1.Modified then
    MsgResult := MessageDlg(Format('File %s has been modified. Save file?',
    [OpenDialog1.Filename]), mtWarning, mbYesNoCancel, 0);
  case MsgResult of
    mrYes:
      begin
        Save1Click(Sender);
        CanClose := True;
      end;
    mrNo: CanClose := True;
    mrCancel: CanClose := False;
  end;
end;

procedure TForm1.UpdateXY;
var
  XY:   TPoint;
  XStr: String[4];
  YStr: String[4];
begin
  {update the status panel on bottom}
  XY := Memo_CursorPos (Memo1);
  Str (XY.X:4, XStr);
  Str (XY.Y:4, YStr);
  Panel1.Caption := XStr + ':' + YStr;
end;  { TForm1.UpdateXY }

procedure TForm1.Memo1Change(Sender: TObject);
begin
  UpdateXY;
end;

procedure TForm1.Memo1Click(Sender: TObject);
begin
  UpdateXY;
end;

procedure TForm1.Memo1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateXY;
  {next line is version 3.5 beta}
  {SpellDlg1.AutoCheck (Memo1, TRUE, Key, Shift);}
end;

procedure TForm1.Memo1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  UpdateXY;
end;

procedure TForm1.SpellCheck1Click(Sender: TObject);
begin
  SpellDlg1.ForceDialogTitle ('My Spell Dialog');
  SpellDlg1.UseScanTable (ScanMax, @ScanTable);
  {SpellDlg1.AddDictionary ('SPANISH.DCT');}  {supports multiple dictionaries!}
  SpellDlg1.SpellCheck (Memo1);
end;

procedure TForm1.CountWords1Click(Sender: TObject);
var
  W1, U1: longint;
begin
  SpellDlg1.WordCount (Memo1, W1, U1);
end;

procedure TForm1.SpellDialog1Click(Sender: TObject);
begin
  EditSpellDialog.ShowModal;
end;

end.



