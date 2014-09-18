unit fQstnProperties;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Grids, DBGrids, ComCtrls, DBCtrls, Mask, DBCGrids,
  wwdbedit, Wwdotdot, Wwdbcomb, Wwdbigrd, Wwdbgrid, Db, DBTables, Wwtable,
  Wwdatsrc, Buttons;

type
  TfrmQstnProperties = class(TForm)
    CancelBtn: TButton;
    OKbtn: TButton;
    lblName: TLabel;
    editName: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    rgScalePosition: TRadioGroup;
    pnlScaleBelow: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Shape16: TShape;
    Label12: TLabel;
    Shape17: TShape;
    Label15: TLabel;
    Shape18: TShape;
    Label16: TLabel;
    Label17: TLabel;
    Shape19: TShape;
    Label19: TLabel;
    Shape20: TShape;
    Label18: TLabel;
    Label20: TLabel;
    Shape21: TShape;
    Label23: TLabel;
    Shape24: TShape;
    Shape25: TShape;
    Label24: TLabel;
    pnlScaleRight: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape6: TShape;
    Shape5: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Label11: TLabel;
    pnlScaleMixed: TPanel;
    dsSkip: TDataSource;
    tSkip: TTable;
    tSkipSurvey_ID: TIntegerField;
    tSkipSelQstns_ID: TIntegerField;
    tSkipSelScls_ID: TIntegerField;
    tSkipScaleItem: TIntegerField;
    tSkipType: TStringField;
    tSkipnumSkip: TIntegerField;
    tSkipnumSkipType: TIntegerField;
    dsScls: TDataSource;
    tScls: TTable;
    tSkipLabel: TStringField;
    DBCtrlGrid1: TDBCtrlGrid;
    DBEdit1: TDBEdit;
    HeaderControl1: THeaderControl;
    DBComboBox1: TDBComboBox;
    DBEdit2: TDBEdit;
    pnlScaleBelow2: TPanel;
    Label21: TLabel;
    Shape22: TShape;
    Label29: TLabel;
    Label30: TLabel;
    Label22: TLabel;
    Shape28: TShape;
    Label31: TLabel;
    Label32: TLabel;
    Shape29: TShape;
    Label25: TLabel;
    Shape23: TShape;
    Label26: TLabel;
    Label27: TLabel;
    Shape26: TShape;
    Shape27: TShape;
    Label28: TLabel;
    Label33: TLabel;
    Shape30: TShape;
    Shape31: TShape;
    Label34: TLabel;
    Label35: TLabel;
    Shape32: TShape;
    Shape33: TShape;
    Label36: TLabel;
    Label37: TLabel;
    Shape34: TShape;
    Shape35: TShape;
    Label38: TLabel;
    Label39: TLabel;
    pnlScaleBelowLeft: TPanel;
    Label46: TLabel;
    Shape40: TShape;
    Label47: TLabel;
    Label48: TLabel;
    Shape41: TShape;
    Label49: TLabel;
    Shape42: TShape;
    Shape43: TShape;
    Label50: TLabel;
    tsProblemScores: TTabSheet;
    DBGrid1: TDBGrid;
    procedure rgScalePositionClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tSkipLabelGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure tSkipnumSkipTypeGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure tSkipnumSkipTypeSetText(Sender: TField; const Text: String);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowName(const Show:boolean);
    procedure ShowSkips(const show:boolean);
  end;

var
  frmQstnProperties: TfrmQstnProperties;

implementation

uses dOpenQ,common;

{$R *.DFM}

procedure TfrmQstnProperties.rgScalePositionClick(Sender: TObject);
begin
  case rgScalePosition.Itemindex of
    0 : pnlScaleRight.BringToFront;
    1 : pnlScaleBelow.BringtoFront;
    2 : pnlScaleBelow2.BringtoFront;
    3 : pnlScaleBelowLeft.BringtoFront;
  end;
end;

procedure TfrmQstnProperties.ShowSkips(const show:boolean);
begin
  tabSheet2.TabVisible := show;
  tsProblemScores.TabVisible := show;
end;

procedure TfrmQstnProperties.ShowName(const Show:boolean);
begin
  lblName.visible := show;
  editName.visible := show;
  if show then begin
    PageControl1.Top := 31;
    PageControl1.Height := 150;
  end else begin
    PageControl1.Top := 0;
    PageControl1.Height := 181;
  end;
end;

procedure TfrmQstnProperties.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  vType,vNum:integer;
  anyskips:boolean;
  function TypeMatch:integer;
  begin
    case vType of
      skSection: result := 1;
      skSubsection, skQuestion: if vNum>0 then result := vNum else result := 1;
      else result := 0;
    end;
  end;
begin
  anyskips := false;
  if (caption='Question Properties') and tskip.active then
    with tskip do begin
      first;
      while not eof do
        if fieldbyname('numSkipType').asinteger=skNone then
          delete
        else begin
          anyskips := true;
          vNum := fieldbyname('numSkip').asInteger;
          vType := fieldbyname('numSkipType').asinteger;
          if vNum <> typeMatch then begin
            edit;
            fieldbyname('numSkip').value := typeMatch;
            post;
          end;
          next;
        end;
    end;
  if anyskips and (rgScalePosition.itemindex=0) then begin
    messagedlg('Any question that has a skip pattern defined must have the '+
        'scale below the question.  This question''s scale position has been '+
        'changed.',mtinformation,[mbok],0);
    rgScalePosition.itemindex := 1;
  end;
  if (modalresult=mrOK) and (caption='Subsection Properties') and (trim(editName.text)='') then begin
    messagedlg('Subsection Name cannot be blank.',mterror,[mbok],0);
    Action := caNone;
  end else begin
    tSkip.close;
    tScls.close;
    Action := caHide;
  end;                                   
  dmOpenq.wwT_ProblemScores.Filtered := false;
  dmOpenq.wwT_ProblemScores.Filter := '';
end;

procedure TfrmQstnProperties.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
  tScls.IndexFieldNames := qpc_id+';Item';
  ShowSkips(dmOpenQ.wwt_QstnsSubType.value=1);
  ShowName(dmOpenQ.wwt_QstnsItem.value=0);
  dmOpenq.wwT_ProblemScores.Filter := 'Core='+dmopenq.wwT_QstnsQstnCore.AsString;
  dmOpenq.wwT_ProblemScores.Filtered := true;
  if dmOpenQ.wwt_QstnsItem.value>0 then begin
    tScls.open;
    tSkip.open;
    with dmOpenq, wwt_Scls do begin
      indexFieldNames := 'Survey_ID;'+qpc_ID;
      if findkey([glbSurveyID,wwt_QstnsScaleID.value]) then begin
        while (not wwt_Scls.eof) and (wwt_SclsID.value=wwt_QstnsScaleID.value) do begin
          if not tSkip.findkey([glbSurveyID,
                                   wwt_QstnsID.value,
                                   wwt_SclsID.value,
                                   wwt_sclsItem.value]) then begin
            tSkip.AppendRecord([glbSurveyID,
                                wwt_QstnsID.value,
                                wwt_SclsID.value,
                                wwt_sclsItem.value,
                                'Skip',null,0,skNone]);
          end;
          wwt_scls.next;
        end;
        tSkip.filter := 'SelQstns_ID='+dmopenQ.wwt_QstnsID.asstring;
        tSkip.filtered := true;
        tSkip.first;
      end;
    end;
  end;
end;

procedure TfrmQstnProperties.FormShow(Sender: TObject);
begin
  rgScalePositionClick(Sender);
end;

procedure TfrmQstnProperties.tSkipLabelGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  with tScls do
    if findkey([tSkipSelScls_ID.value,tSkipScaleItem.value]) then
      text := fieldbyname('Label').text
    else
      text := 'Error - Can''t find scale '+tSkipSelScls_ID.asString+'.'+tSkipScaleItem.asstring;
end;

procedure TfrmQstnProperties.tSkipnumSkipTypeGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if sender.asInteger = skQuestion        then text := 'Next Question'
  else if sender.asInteger = skSubsection then text := 'Next Subsection'
  else if sender.asInteger = skSection    then text := 'Next Section'
  else text := 'No skip';
end;

procedure TfrmQstnProperties.tSkipnumSkipTypeSetText(Sender: TField;
  const Text: String);
begin
  if lowercase(Text) = 'next question' then Sender.value := skQuestion
  else if lowercase(Text) = 'next subsection' then Sender.value := skSubsection
  else if lowercase(Text) = 'next section' then Sender.value := skSection
  else Sender.value := skNone;
end;

end.
