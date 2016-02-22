unit fPCLGen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, ExtCtrls, DBTables, Buttons, FileUtil;

type
  TfrmPCLGeneration = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    btnErrorLog: TButton;
    Timer: TTimer;
    txtSurvey_id: TEdit;
    lblSurvey_id: TLabel;
    SpeedButton1: TSpeedButton;
    procedure progressreport(s:string; const s_id,sm_id:string);
    procedure btnErrorLogClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CompName : string;
    Version : string;
  end;

var
  frmPCLGeneration: TfrmPCLGeneration;

const
ServiceName = 'PCLGenService';
ServiceDisplayName = 'PCL Gen Service';
SERVICE_WIN32_OWN_PROCESS = $00000010;
SERVICE_DEMAND_START = $00000003;
SERVICE_ERROR_NORMAL = $00000001;
EVENTLOG_ERROR_TYPE = $0001;

implementation

uses dPCLGen, common, DOpenQ, log4Pascal;

{$R *.DFM}

procedure AddToMessageLog(sMsg: string);
var
   sString: array[0..1] of string;
   hEventSource: THandle;
begin
   hEventSource := RegisterEventSource(nil, ServiceName);

   if hEventSource > 0 then
      begin
         sString[0] := ServiceName + ' error: ';
         sString[1] := sMsg;
         ReportEvent(hEventSource, EVENTLOG_ERROR_TYPE, 0, 0, nil, 2, 0, @sString, nil);
         DeregisterEventSource(hEventSource);
      end;
end;

procedure TfrmPCLGeneration.progressreport(s:string; const s_id,sm_id:string); far;
var qry : string;
begin
//  AddToMessageLog(s);
  while memo1.lines.count > 100 do
    memo1.lines.delete(0);
  if (dmPCLGen = NIL) or (dmPCLGen.currentrun <= 0) then begin
//    memo1.lines.add(TimeToStr(Time) + ' ' + s + ' (not logged to PCLGenLog table)');
    Logger.Info(s);
  end else begin
//    memo1.lines.add(TimeToStr(Time) + ' ('+inttostr(dmPCLGen.currentrun)+') ' + s);
    Logger.Info(s +' ('+inttostr(dmPCLGen.currentrun)+') ');
  end;
  memo1.update;


  if (dmPCLGen <> NIL) and (dmPCLGen.currentrun > 0) then begin
    qry := 'execute sp_PCL_LogEntry ' + inttostr(dmPCLGen.currentrun)+', '+dmOpenq.sqlstring(s,false)+', ';

    if strtointdef(s_id,0)=0
    then qry := qry + 'null, '
    else qry := qry + s_id + ', ';

    if strtointdef(sm_id,0)=0
    then qry := qry + 'null'
    else qry := qry + sm_id;

    with dmPCLGen.wwq_Log do begin
      sql.clear;
      sql.add(qry);
      execSQL;
    end;
  end;

end;

procedure TfrmPCLGeneration.btnErrorLogClick(Sender: TObject);
begin
  dmPCLGen.ShowErrorLog;
end;

procedure TfrmPCLGeneration.FormCreate(Sender: TObject);
var dummy, suffix : string;
begin
  suffix := '';
  if uppercase(ExtractFileName(Application.ExeName)) <> 'PCLGEN.EXE' then
    suffix := '-' + Copy(Application.ExeName, length(Application.ExeName)-4, 1);
  CompName := ComputerName + suffix;
  dummy := GetFileVersion(application.exename, Version);
  if paramstr(4)='/C' then timer.interval := 1000;
  timer.enabled := true;
  memo1.Lines.Add('Log file in C:\NRC\Logs\'+ExtractFileName(Application.ExeName)+'\');
end;

procedure TfrmPCLGeneration.TimerTimer(Sender: TObject);
var zExeName : array[0..79] of char;
begin
  timer.enabled := false;
  DMPCLGen := TDMPCLGen.Create( Self );
  if dmPCLGen.createOK and fileexists(dmopenq.tempdir+'\LocalSelTextBox.db') then
    dmPCLGen.PCLGeneration
  else
    progressreport('forms weren''t created properly ... trying again','','');
  if (not dmPCLGen.timer.enabled) then begin
    MessageBeep(0);  MessageBeep(0);  MessageBeep(0);
    btnErrorLog.Enabled := true;
    {if dmopenq.createok and dmPCLGen.createok then} begin
      frmPCLGeneration.progressreport('Relaunching PCLGen (from fPCLGen)','','');
      winExec(strpcopy(zExeName,application.exename+' /2 '+paramstr(2)+' '+paramstr(3)),sw_shownormal)
    end;
    sleep(2000);
    frmPCLGeneration.close;
  end;
end;

procedure TfrmPCLGeneration.FormDestroy(Sender: TObject);
begin
  dmPCLGen.free;
end;

end.


