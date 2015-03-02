(* MEMOUTIL.PAS - Copyright (c) 1995-1996, Eminent Domain Software *)

unit MemoUtil;
  {-Memo simple memo functions}
interface
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Menus, ExtCtrls;

function Memo_CursorPos (AMemo: TMemo): TPoint;
  {-returns the cursor position in row, column}
function Memo_WhereY (AMemo: TMemo): Integer;
  {-returns the screen absolute y position of the highlighted word}

implementation

function Memo_CursorPos (AMemo: TMemo): TPoint;
  {-returns the cursor position in row, column}
var
  Col:      integer;
  Row:      integer;
  RowStart: integer;
begin
  Row      := SendMessage(AMemo.Handle, EM_LINEFROMCHAR, $FFFF, 0);
   {-returns the line number of the cursor position}
  RowStart := SendMessage(AMemo.Handle, EM_LINEINDEX, $FFFF, 0);
    {-returns the index of the start of the line within the buffer}
  Col      := AMemo.SelStart - RowStart;
  Result   := Point (Col, Row);
end;  { Memo_CursorPos }

function Memo_WhereY (AMemo: TMemo): Integer;
  {-returns the screen absolute y position of the highlighted word}
var
  CursorPos:  TPoint;
  AbsMemoXY:  TPoint;
  TopLine:    Integer;
  Height:     Integer;
begin
  TopLine   := SendMessage (AMemo.Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
  CursorPos := Memo_CursorPos (AMemo);
  AbsMemoXY := AMemo.ClientToScreen (Point (0, 0));
  Height    := Abs (Round (AMemo.Font.Height * (AMemo.Font.PixelsPerInch/72)));
  Result    := AbsMemoXY.Y + ((CursorPos.Y - TopLine) * Height);
end;  { Memo_WhereY }

end.  { MemoUtil }
