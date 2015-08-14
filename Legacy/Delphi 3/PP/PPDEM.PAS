unit Ppdem;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls, Tabs,
  Buttons, ExtCtrls, Ppmain, Ppext, Grids, Outline, TabNotBk, FileCtrl,
  Ppdb, sysutils, DBCtrls, DBGrids, DB, DBTables, dialogs, Menus{$ifdef win32}, ComCtrls{$endif};

type
  TMultPageDlg = class(TForm)
    PowerPanel1: TPowerPanel;
    PPCap1: TPPCap;
    Notebook: TNotebook;
    TabSet: TTabSet;
    PowerPanel2: TPowerPanel;
    PowerPanel3: TPowerPanel;
    PowerPanel4: TPowerPanel;
    PPStatus1: TPPStatus;
    PowerPanel5: TPowerPanel;
    PPCap2: TPPCap;
    PowerPanel7: TPowerPanel;
    PPCap3: TPPCap;
    PowerPanel8: TPowerPanel;
    PPCap4: TPPCap;
    PowerPanel9: TPowerPanel;
    PowerPanel10: TPowerPanel;
    ListBox1: TListBox;
    PPListBox1: TPPListBox;
    PowerPanel11: TPowerPanel;
    Memo1: TMemo;
    PPMemo1: TPPMemo;
    PowerPanel12: TPowerPanel;
    Outline1: TOutline;
    PPOutLine1: TPPOutLine;
    PowerPanel13: TPowerPanel;
    TabbedNotebook1: TTabbedNotebook;
    PPTabbedNB1: TPPTabbedNB;
    PowerPanel14: TPowerPanel;
    StringGrid1: TStringGrid;
    PPStringGrid1: TPPStringGrid;
    PowerPanel15: TPowerPanel;
    DrawGrid1: TDrawGrid;
    PPDrawGrid1: TPPDrawGrid;
    PowerPanel16: TPowerPanel;
    Label1: TLabel;
    PPLabel1: TPPLabel;
    DriveBoxAligned1: TDriveBoxAligned;
    PPDrive1: TPPDrive;
    DirectoryListBox1: TDirectoryListBox;
    PPDirList1: TPPDirList;
    EditAligned1: TEditAligned;
    PPEdit1: TPPEdit;
    FilterBoxAligned1: TFilterBoxAligned;
    PPFilter1: TPPFilter;
    FileListBox1: TFileListBox;
    PPFileList1: TPPFileList;
    PPFileManager1: TPPFileManager;
    Table1: TTable;
    DataSource1: TDataSource;
    Button1: TButton;
    PowerPanel17: TPowerPanel;
    DBGrid1: TDBGrid;
    PPDBGrid1: TPPDBGrid;
    DBNavigator1: TDBNavigator;
    PPDBNav1: TPPDBNav;
    DBNavigator4: TDBNavigator;
    PPDBNavLeft2: TPPDBNavLeft;
    DBNavigator5: TDBNavigator;
    PPDBNavRight2: TPPDBNavRight;
    PowerPanel22: TPowerPanel;
    PowerPanel23: TPowerPanel;
    PowerPanel24: TPowerPanel;
    PPStatus3: TPPStatus;
    PPDBNavSplit2: TPPDBNavSplit;
    GlobalAttributes1: TGlobalAttributes;
    PowerPanel6: TPowerPanel;
    PowerPanel29: TPowerPanel;
    PowerPanel18: TPowerPanel;
    DBNavigator2: TDBNavigator;
    PPDBNavLeft1: TPPDBNavLeft;
    DBNavigator3: TDBNavigator;
    PPDBNavRight1: TPPDBNavRight;
    PowerPanel19: TPowerPanel;
    PowerPanel20: TPowerPanel;
    PowerPanel21: TPowerPanel;
    PPStatus2: TPPStatus;
    PPDBNavSplit1: TPPDBNavSplit;
    DBGrid2: TDBGrid;
    PPDBGridAccess1: TPPDBGridAccess;
    PowerPanel26: TPowerPanel;
    Panel1: TPanel;
    PowerPanel25: TPowerPanel;
    procedure FormCreate(Sender: TObject);
    procedure TabSetClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TabSetChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MultPageDlg: TMultPageDlg;

implementation

{$R *.DFM}
uses Ppabout;
procedure TMultPageDlg.FormCreate(Sender: TObject);
begin
  { make the number of Tabs = number of Pages,
    and have the same names }
  TabSet.Tabs := Notebook.Pages;
  outline1.fullexpand;
end;

procedure TMultPageDlg.TabSetClick(Sender: TObject);
begin
  { set visible Page to which Tab was clicked }
  Notebook.PageIndex := TabSet.TabIndex;
end;

procedure TMultPageDlg.Button1Click(Sender: TObject);
begin
table1.open;
end;

procedure TMultPageDlg.TabSetChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var about: TPowerPanelAboutBox;
begin
   if newtab = 4 then
      begin
          allowchange := false;
          about := tpowerpanelAboutbox.create(application);
          about.showmodal;
          about.free;
      end;
end;

end.
