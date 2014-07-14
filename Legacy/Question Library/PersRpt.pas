unit PersRpt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, DBCtrls, Grids, DBGrids, DB, DBTables, StdCtrls, ComCtrls,
  DBRichEdit;

type
  TfrmPersRpt = class(TForm)
    clDBRichEdit1: TclDBRichEdit;
    DSQstnText: TDataSource;
    TQstnText: TTable;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Button1: TButton;
    ListBox1: TListBox;
    DSCodeText: TDataSource;
    TCodeText: TTable;
    DSConstants: TDataSource;
    TConstants: TTable;
    TCodes: TTable;
    DSCodes: TDataSource;
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPersRpt: TfrmPersRpt;

implementation

uses Data;

{$R *.DFM}


function myval(s:string):integer;
begin
  delete(s,pos('}',s),3);
  myval := strtoint(s);
end;

procedure personalize(s:string;Age,Sex,Doc:string);
var r,constant : string;
  code,j : integer;
begin
  r := '';
  with frmPersRpt do begin
    j := 1;
    while j <= length(s) do begin
      if s[j] = '{' then begin
        code := myval(copy(s,j+1,3));
        while s[j] <> '}' do inc(j);
        if not tCodeText.findkey([code,age,'      ','      ']) then
        if not tCodeText.findkey([code,'     ',sex,'      ']) then
        if not tCodeText.findkey([code,'     ','      ',doc]) then
        if not tCodeText.findkey([code,age,sex,'      ']) then
        if not tCodeText.findkey([code,age,'      ',doc]) then
        if not tCodeText.findkey([code,'     ',sex,doc]) then
        if not tCodeText.findkey([code,age,sex,doc]) then
          tCodeText.findkey([code,'     ','      ','      ']);
        r := r + #27+'&d0D'+trim(tCodeText.fieldbyname('Text').text)+#27+'&d@';
      end else
        r := r + s[j];
      inc(j);
    end;
    while pos('«',r) > 0 do begin
      j := pos('«',r);
      constant := copy(r,j+1,pos('»',r)-j-1);
      delete(r,j,length(constant)+2);
      if tConstants.findkey([constant]) then
        insert(trim(tConstants.fieldbyname('value').text),r,j)
      else
        insert('['+constant+']',r,j);
    end;
    while pos('°',r) > 0 do r[pos('°',r)] := ' ';
    with listbox1 do 
      if (items.count=0) or
      (copy(items[items.count-1],2+pos(':',items[items.count-1]),255) <> r) then
        items.add(age+', '+trim(sex)+': '+r);
  end;
end;

procedure personalization(s:string);
var codelist : array[0..10] of integer;
  J : integer;
  bage,bsex,bdoc:boolean;
begin
  with frmPersRpt do begin
    codelist[0] := 0;
    for j := pos('{',s) to length(s) do
      if s[j] = '{' then begin
        inc(codelist[0]);
        codelist[codelist[0]] := myval(copy(s,j+1,3));
      end;
    with tCodes do begin
      bAge := false;
      bSex := false;
      bDoc := false;
      for j := 1 to codelist[0] do begin
        if FindKey([codelist[j]]) then begin
          bAge := bAge or fieldbyname('Age').asboolean;
          bSex := bSex or fieldbyname('Sex').asboolean;
          bDoc := bDoc or fieldbyname('Doctor').asboolean;
        end;
      end;
      if bAge and bSex then begin
        personalize(s,'Adult','Male  ','Doctor');
        personalize(s,'Adult','Female','Doctor');
        personalize(s,'Minor','Male  ','Doctor');
        personalize(s,'Minor','Female','Doctor');
      end else begin
        if bAge then begin
          personalize(s,'Adult','Male  ','Doctor');
          personalize(s,'Minor','Male  ','Doctor');
        end;
        if bSex then begin
          personalize(s,'Adult','Male  ','Doctor');
          personalize(s,'Adult','Female','Doctor');
        end;
      end;
      if (not bAge) and (not bSex) then
        personalize(s,'Adult','Male  ','Doctor');
    end;
  end;
end;

procedure dave;
var s : string;
  i : integer;
  fs : tFontStyles;
  procedure myproc(fs1,fs2:tFontStyles;attrib:tfontstyle;TurnOn,TurnOff:string);
  begin
    if (attrib in fs1) and (not (attrib in fs2)) then
      s := s + TurnOff;
    if (not (attrib in fs1)) and (attrib in fs2) then
      s := s + TurnOn;
  end;
begin
  s := '';
  with frmPersRpt.clDBRichEdit1 do begin
    selectAll;
    if [caBold, caItalic, caUnderline] <= selAttributes.consistentattributes then begin
      s := text;
      selLength := 0;
    end else begin
      if not ([caBold, caItalic, caUnderline] <= selAttributes.consistentattributes) then begin
        fs := [];
        for i := 0 to length(text) do begin
          selStart := i;
          selLength := 1;
          if fs <> selAttributes.style then begin
            myproc(fs,selAttributes.style,fsBold,#27+'(s3B',#27+'(s0B');
            myproc(fs,selAttributes.style,fsItalic,#27+'(s1S',#27+'(s0S');
            myproc(fs,selAttributes.style,fsUnderline,#27+'&d0D',#27+'&d@');
            fs := selAttributes.style;
          end;
          s := s + selText;
        end;
        if fs <> [] then s := s + #27+'(s0b0S' + #27 + '&d@';
      end;
    end;
    frmPersRpt.listbox1.items.clear;
    if pos('{',s) > 0 then
      Personalization(s)
    else
      frmPersRpt.listbox1.items.add('All: '+s);
  end;
end;

procedure TfrmPersRpt.DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
begin
  dave;
end;

procedure TfrmPersRpt.Button1Click(Sender: TObject);
var f,g : textfile;
    y,I:integer;
    s : string;
begin
  assignfile(f,'c:\qstns.pcl');
  rewrite(f);
  if fileexists('ini-11.bin') then begin
    assignfile(g,'ini-11.bin');
    reset(g);
    while not eof(g) do begin
      s := 'x';
      while s <> '' do begin
        read(g,s);
        write(f,s);
      end;
      readln(g);
      if not eof(g) then writeln(f);
    end;
    closefile(g);
  end;
  writeln(f,#27+'(19U'+#27+'(s4148t0b0s9v1P');
  with tQstnText do begin
    y := 0;
    while not eof do begin
      dave;
      if listbox1.items.count > 1 then begin
        y := y + 150;
        if y > 5500 then begin
          writeln(f,#12);
          y := 150;
        end;
        writeln(f,#27+'*p0x'+inttostr(y)+'Y'+#27+'(s3B'+fieldbyname('Core').text+#27+'(s0B');
        for i := 0 to listbox1.items.count-1 do begin
          y := y + 100;
          writeln(f,#27+'*p0x'+inttostr(y)+'Y'+listbox1.items[i]);
        end;
      end;
      next;
    end;
  end;
  writeln(f,#27+'&f6X'+#27+'*c0F'+#27+'E');
  closefile(f);
end;

procedure TfrmPersRpt.FormCreate(Sender: TObject);
begin
  tQstnText.Findkey([modLibrary.wtblQuestionCore.text]);
end;

end.
