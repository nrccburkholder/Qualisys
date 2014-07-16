unit Sort;

{ dialog for seting the index on the question table }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, DB,
  StdCtrls, Buttons, ExtCtrls, DBTables, Wwtable;

type
  TfrmSort = class(TForm)
    cmbSort: TComboBox;
    lblSort: TLabel;
    lbxFields: TListBox;
    lbxSort: TListBox;
    GroupBox1: TGroupBox;
    chkCase: TCheckBox;
    chkOrder: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    btnAdd: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    btnDown: TSpeedButton;
    btnLeft: TSpeedButton;
    btnUp: TSpeedButton;
    btnRight: TSpeedButton;
    wwTable: TwwTable;
    procedure CancelClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FieldsClick(Sender: TObject);
    procedure SortClick(Sender: TObject);
    procedure RightClick(Sender: TObject);
    procedure UpClick(Sender: TObject);
    procedure DownClick(Sender: TObject);
    procedure LeftClick(Sender: TObject);
    procedure UpdateButtons;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  cOpenHeight = 87;     // default height of dialog (sort combo box only)
  cAddHeight = 282;     // height with create index options open

var
  frmSort: TfrmSort;
  flagAdd : Boolean;

implementation

{$R *.DFM}

{ since a table needs to be opened EXCLUSIVELY in order to set an index on it,
  and do so would lock other users out of that table, the create index functionality
  has been disable }

{ ACTIVATION }

{ loads all indexs into the sort combo box and loads all field names into the fields list }

procedure TfrmSort.FormShow(Sender: TObject);
begin
  Height := cOpenHeight;
  flagAdd := False;
  with wwTable do
  begin
    GetIndexNames( cmbSort.Items );
    cmbSort.Sorted := true;
    cmbSort.sorted := false;
    cmbSort.Items.Insert( 0, 'DefaultIndex' );
    if IndexName = '' then
      cmbSort.ItemIndex := 0
    else
      cmbSort.ItemIndex := cmbSort.Items.IndexOf( IndexName );
    GetFieldNames( lbxFields.Items );
  end;
end;

{ BUTTON METHODS }

{ shows the additional create index functionality }

procedure TfrmSort.AddClick(Sender: TObject);
begin
  flagAdd := True;
  Height := cAddHeight;
  lblSort.Caption := 'Sort Name';
  cmbSort.Style := csSimple;
  cmbSort.Text := '';
  btnAdd.Visible := False;
end;

{ either changes index or creates a new one, depending on settings }

procedure TfrmSort.OKClick(Sender: TObject);
var
  i : Integer;
  vFields : string;
  vOptions : TIndexOptions;

  procedure changeindex(newindex:string);
  begin
    with wwTable do begin
      //close;
      indexname := newindex;
      //open;
    end;
  end;

begin
  if flagAdd then
  begin
    with lbxSort do
    begin
      if cmbSort.Text = '' then
      begin
        cmbSort.SetFocus;
        MessageDlg( 'Enter a name for the sort order.', mtError, [ mbOK ], 0 );
        Exit;
      end;
      if Items.Count > 0 then
      begin
        vFields := Items[ 0 ];
        for i := 1 to Pred( Items.Count ) do vFields := vFields + ';' + Items[ i ];
        if not chkCase.Checked then Include( vOptions, ixCaseInsensitive );
        if chkOrder.Checked then Include( vOptions, ixDescending );
        with wwTable do
        begin
          Close;
          {AddIndex( cmbSort.Text, vFields, vOptions );}
          TIndexDef.Create( IndexDefs, cmbSort.Text, vFields, vOptions );
          Open;
        end;
      end
      else
      begin
        lbxFields.SetFocus;
        MessageDlg( 'A sort order must be composed of one or more fields.',
            mtError, [ mbOK ], 0 );
        Exit;
      end;
    end;
  end;
  if cmbSort.Text = 'DefaultIndex' then begin
    if wwTable.IndexName <> '' then changeindex('');
  end else
    if wwTable.IndexName <> cmbSort.Text then changeindex(cmbSort.Text);
  Close;
end;

procedure TfrmSort.CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSort.FieldsClick(Sender: TObject);
begin
  btnRight.Enabled := ( lbxFields.SelCount > 0 );
end;

procedure TfrmSort.SortClick(Sender: TObject);
begin
  UpdateButtons;
end;

{ moves selected fields over into the index fields list }

procedure TfrmSort.RightClick(Sender: TObject);
var
  i : Integer;
begin
  btnRight.Enabled := False;
  with lbxFields do
  begin
    i := 0;
    while SelCount > 0 do
      if Selected[ i ] then
      begin
        lbxSort.Items.Add( Items[ i ] );
        Items.Delete( i );
      end
      else
        Inc( i );
  end;
end;

{ moves the selected field up in the index fields list }

procedure TfrmSort.UpClick(Sender: TObject);
var
  vIndex : Integer;
begin
  with lbxSort do
  begin
    vIndex := ItemIndex;
    Items.Move( vIndex, Pred( vIndex ));
    ItemIndex := Pred( vIndex );
  end;
  UpdateButtons;
end;

{ moves the selected field down in thg index fields list }

procedure TfrmSort.DownClick(Sender: TObject);
var
  vIndex : Integer;
begin
  with lbxSort do
  begin
    vIndex := ItemIndex;
    Items.Move( vIndex, Succ( vIndex ));
    ItemIndex := Succ( vIndex );
  end;
  UpdateButtons;
end;

{ moves the selected index fields back into the fields list }

procedure TfrmSort.LeftClick(Sender: TObject);
var
  vIndex : Integer;
begin
  with lbxSort do
  begin
    vIndex := ItemIndex;
    lbxFields.Items.Add( Items[ vIndex ]);
    Items.Delete( vIndex );
    if vIndex = Items.Count then
      ItemIndex := Pred( vIndex )
    else
      ItemIndex := vIndex;
  end;
  UpdateButtons;
end;

{ GENERAL METHODS }

{ resets button states }

procedure TfrmSort.UpdateButtons;
begin
  with lbxSort do
  begin
    btnLeft.Enabled := ( ItemIndex > -1 );
    btnUp.Enabled := ( ItemIndex > 0 );
    btnDown.Enabled := ( ItemIndex <> Pred( Items.Count ));
  end;
end;

end.
