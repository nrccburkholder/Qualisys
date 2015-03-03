unit Wwprpcom;

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons,
  StdCtrls, Grids, wwdbcomb, dialogs, sysutils, wwstr, ExtCtrls;

type
  TwwPrpEditComboList = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Notebook1: TNotebook;
    StringGrid1: TStringGrid;
    Memo1: TMemo;
    Panel1: TPanel;
    SeparateStoredList: TCheckBox;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SeparateStoredListClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OKBtnClick(Sender: TObject);
  private
    combobox: TwwDBComboBox;
    init: boolean;
    changingMapCheckbox: boolean;
    okBtnPressed, changed: boolean;
    startWidth1: integer;

    procedure DeleteCurrentRow;
    Procedure ComputeGridColumns;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  wwPrpEditComboList: TwwPrpEditComboList;

Function wwEditComboList(combo: TwwDBComboBox): boolean;

implementation

{$R *.DFM}

uses wwcommon;

function min(x,y: integer): integer;
begin
   if x<y then result:= x else result:= y;
end;
function max(x,y: integer): integer;
begin
   if x>y then result:= x else result:= y;
end;

Function wwEditComboList(combo: TwwDBComboBox): boolean;
var i :integer;
begin
    result:= False;
    with TwwPrpEditComboList.create(Application) do try
       with Combo, stringGrid1 do begin
          combobox:= combo;

          if (showModal = mrOK) then begin
             combobox.MapList := SeparateStoredList.checked;
             if combobox.maplist then begin
                with stringGrid1 do begin
                   Items.clear;
                   for i:= 0 to rowCount-2 do begin
                      if Cells[0,i+1]<>'' then begin
                         Items.add(Cells[0,i+1] + #9 + Cells[1,i+1])
                      end
                   end;
                end;
             end
             else begin
                Items.assign(memo1.Lines);
             end;
             result:= True;
          end
       end
    finally
       Free;
    end;
end;

procedure TwwPrpEditComboList.FormCreate(Sender: TObject);
begin
  with stringgrid1 do begin
     rows[0].strings[0]:= 'Displayed Value';
     rows[0].strings[1]:= 'Stored Value';
  end;
end;

procedure TwwPrpEditComboList.FormShow(Sender: TObject);
var i, curpos: integer;
begin
   KeyPreview:= True;
   StartWidth1:= StringGrid1.ColWidths[1];

   if combobox.MapList then with StringGrid1, combobox do begin
      RowCount:= max(Items.count+1, 2);
      for i:= 0 to Items.count-1 do begin
         curpos:= 1;
         Cells[0, i+1]:= strGetToken(Items[i], #9, curPos);
         Cells[1, i+1]:= strGetToken(Items[i], #9, curPos);
      end
   end
   else begin
      Memo1.Lines.assign(combobox.Items);
      Memo1.modified:= False;
   end;

   if combobox.MapList then begin
      SeparateStoredList.checked:= True;
      notebook1.pageIndex:=0;
   end
   else begin
      SeparateStoredList.checked:= False;
      notebook1.pageIndex:=1;
   end;
   Init:= True;

   ComputeGridColumns;
end;

procedure TwwPrpEditComboList.DeleteCurrentRow;
var i, tempRowCount: integer;
begin
   with StringGrid1 do begin
      for i:= row to rowCount-1 do begin
         cells[1, i]:= cells[1,i+1];
         cells[0, i]:= cells[0,i+1];
      end;
      tempRowCount:= max(rowCount - 1, 2);
      if row>=tempRowCount then row:= tempRowCount-1;
      RowCount:= tempRowCount;
   end
end;

procedure TwwPrpEditComboList.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i: integer;
    onLastRow: boolean;
    origRowCount: integer;

   Function EmptyRow: boolean;
   begin
      with StringGrid1 do
        result:=  (cells[1,row]='') and (cells[0,row]='');
   end;
   Function isValidChar(key: word): boolean;
   begin
      result:= (key = VK_BACK) or (key=VK_SPACE) or (key=VK_DELETE) or
               ((key >= ord('0')) and (key<=VK_DIVIDE)) or
               (key>VK_SCROLL);
   end;

begin
   origRowCount:= StringGrid1.RowCount;

   if isValidChar(key) then Changed:= True;

   with StringGrid1 do
   case Key of
      VK_INSERT: begin
         if not EmptyRow then begin
            rowCount:= rowCount + 1;
            for i:= rowCount-1 downto row do begin
               cells[1, i+1]:= cells[1,i];
               cells[0, i+1]:= cells[0,i];
            end;
            cells[1, row]:= '';
            cells[0, row]:= '';
         end
      end;

      VK_DELETE: begin
         if ssCtrl in Shift then begin
            DeleteCurrentRow;
            key:= 0;
         end;
      end;

      VK_UP: begin
            if (row>=2) and EmptyRow then begin
               OnLastRow:= (row=RowCount-1);
               DeleteCurrentRow;
               if not OnLastRow then row:= row - 1;
               key:= 0;
            end
         end;

      VK_DOWN: begin
         if (row = rowCount-1) then begin
            if not EmptyRow then begin
              rowCount:= rowCount + 1;
              row:= rowCount-1;
              cells[0,row]:='';
              cells[1,row]:='';
              col:= 0;
            end;
         end
         else if EmptyRow then begin
            DeleteCurrentRow;
            key:= 0;
         end
      end;

      VK_TAB, VK_RETURN: begin
         if (ssShift in Shift) then exit;
         if (row = rowCount-1) then begin
            if (not EmptyRow) and (col=1) then begin
              rowCount:= rowCount + 1;
              row:= rowCount-1;
              col:= 0;
              if key=VK_TAB then key:= 0;
            end
            else begin
              if col=0 then begin
                 col:= col + 1;
                 if key=VK_TAB then key:= 0;
              end
            end;
         end
         else begin
            if (col=1) and EmptyRow then begin
               DeleteCurrentRow;
               Key:= 0;
               col:= 0;
               EditorMode:= True;
            end
            else if key=vk_return then begin
               if (col=1) then begin
                  row:= row+1;
                  col:= 0;
               end
               else col:= col + 1;
               EditorMode:= True;
            end
         end
      end;
   end;

   ComputeGridColumns;

   if OrigRowCount<>StringGrid1.RowCount then Changed:= True;
end;

procedure TwwPrpEditComboList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (key=vk_f1) then wwHelp(Handle, 'Edit Combo List Dialog Box')
   else if Key=vk_escape then modalResult:= mrCancel
{   else if key=vk_return then modalResult:= mrOK;}
end;

procedure TwwPrpEditComboList.SeparateStoredListClick(Sender: TObject);
var i: integer;
begin
  if changingMapCheckbox then exit; { prevent recursion }

  try
     changingMapCheckbox:= True;
     if init then changed:= True;
     if SeparateStoredList.checked then begin
        notebook1.pageIndex:=0;
        if not init then exit;

        StringGrid1.rowCount:= max(2, Memo1.Lines.count + 1);
        for i:= 0 to Memo1.Lines.count-1 do begin
           StringGrid1.cells[0, i+1]:= Memo1.Lines[i];
           StringGrid1.cells[1, i+1]:= Memo1.Lines[i];
        end;
        StringGrid1.setFocus;
     end
     else begin
        if init and (MessageDlg('Your mapped values will be lost! ' +
                   'Are you sure you want to use a unmapped drop-down list?',
                   mtConfirmation, [mbYes,mbNo], 0)<>mrYes) then
        begin
           separateStoredList.checked:= True;
           exit;
        end;

        notebook1.pageIndex:= 1;
        if not init then exit;

        Memo1.Lines.clear;
        for i:= 1 to StringGrid1.rowCount-1 do begin
           Memo1.Lines.add(StringGrid1.cells[0, i]);
        end;
        Memo1.modified:= False;
        Memo1.setFocus;

     end
  finally
     changingMapCheckbox:= False;
  end;


end;

procedure TwwPrpEditComboList.Button1Click(Sender: TObject);
begin
   if MessageDlg('Are you sure you want to clear the entire list?',
                   mtConfirmation, [mbYes,mbNo], 0)<>mrYes then exit;
   Changed:= True;

   if SeparateStoredList.checked then begin
      StringGrid1.rowCount:= 2;
      StringGrid1.cells[0, 1]:= '';
      StringGrid1.cells[1, 1]:= '';
   end
   else begin
      Memo1.lines.clear;
   end
end;

procedure TwwPrpEditComboList.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var answer: integer;
begin
   canClose:= True;

   if (Changed or Memo1.modified) and not OKBtnPressed then begin
     answer:=
        MessageDlg('Changes have been made!  Are you sure you want to cancel?',
                 mtConfirmation, [mbYes, mbNo], 0);

     if (answer = mrYes) then begin
        ModalResult:= mrCancel;
     end
     else canClose:= False;
   end;

   okBtnPressed:= False;
end;


procedure TwwPrpEditComboList.OKBtnClick(Sender: TObject);
begin
   okBtnPressed:= True;
end;

Procedure TwwPrpEditComboList.ComputeGridColumns;
begin
   if (StringGrid1.RowCount-1) > StringGrid1.visibleRowCount then
   begin
      StringGrid1.ColWidths[1]:= StartWidth1 - GetSystemMetrics(SM_CXHThumb);
   end
   else StringGrid1.ColWidths[1]:= StartWidth1;
end;

end.
