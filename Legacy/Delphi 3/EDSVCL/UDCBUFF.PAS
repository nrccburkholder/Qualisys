(* UDCBuff.PAS - Copyright (c) 1995-1996, Eminent Domain Software *)

unit UDCBuff;
  {-UDC Memo Writer buffer manager for EDSSpell component}
interface
uses
  Classes, Controls, Graphics, SysUtils, Forms, StdCtrls,
  WinProcs, WinTypes,
  AbsBuff, MemoUtil, SpellGbl,
  UDC_mwps, UDC_Win;

type
  TUDCBuf = class (TPCharBuffer)  {UDC Memo Writer Buffer Manager}
    private                              
      { Private declarations }
      WeModified: Boolean;
    protected
      { Protected declarations }
    public
      { Public declarations }
      constructor Create (AParent: TControl);  override;

      function    IsModified: Boolean;  override;
        {-returns TRUE if parent had been modified}
      procedure   SetModified (NowModified: Boolean);  override;
        {-sets parents modified flag}
      function    GetYPos: integer;  override;
        {-gets the current y location of the highlighted word (absolute screen)}
      procedure   SetSelectedText;  override;
        {-highlights the current word using BeginPos & EndPos}
      function    GetNextWord: string;  override;
        {-returns the next word in the buffer}
      procedure   UpdateBuffer;  override;
        {-updates the buffer from the parent component, if any}
      procedure   ReplaceWord (WithWord: string);  override;
        {-replaces the current word with the word provided}
  end;  { TUDCBuf }

implementation

{UDC Memo Writer Buffer Manager}
constructor TUDCBuf.Create (AParent: TControl);
begin
  inherited Create (AParent);
  WeModified := FALSE;
end;  { TUDCBuf.Create }

function TUDCBuf.IsModified: Boolean;
  {-returns TRUE if parent had been modified}
begin
  Result := WeModified;
end;  { TUDCBuf.IsModified }

procedure TUDCBuf.SetModified (NowModified: Boolean);
  {-sets parents modified flag}
begin
  WeModified := NowModified;
end;  { TUDCBuf.SetModified }

function TUDCBuf.GetYPos: integer;
  {-gets the current y location of the highlighted word (absolute screen)}
begin
  Result := 0;
end;  { TUDCBuf.GetYPos }

procedure TUDCBuf.SetSelectedText;
  {-highlights the current word using FBeginPos & FEndPos}
begin
  with Parent as TUdcMWPStandard do
    SPSelectWord;
end;  { TUDCBuf.SetSelectedText }

function TUDCBuf.GetNextWord: string;
  {-returns the next word in the buffer}
var
  i: byte;
begin
  with Parent as TUdcMWPStandard do
  begin
    Result := SPGetNextWord;
    AllNumbers := TRUE;
    i := 1;
    while (i <= Length (Result)) and AllNumbers do
    begin
      AllNumbers := AllNumbers and (Result[i] in NumberSet);
      Inc(i);
    end;  { while }
  end;  { if... }
end;  { TUDCBuf.GetNextWord }

procedure TUDCBuf.UpdateBuffer;
  {-updates the buffer from the parent component, if any}
begin
  {do nothing}
end;  { TUDCBuf.UpdateBuffer }

procedure TUDCBuf.ReplaceWord (WithWord: string);
  {-replaces the current word with the word provided}
begin
  with Parent as TUdcMWPStandard do
    SelText := WithWord;
  WeModified := TRUE;
end;  { TUDCBuf.ReplaceWord }

end.  { UDCBuff }
