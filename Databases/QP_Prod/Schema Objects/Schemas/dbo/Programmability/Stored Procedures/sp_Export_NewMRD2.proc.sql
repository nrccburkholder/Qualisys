CREATE procedure sp_Export_NewMRD2
@cutoff_id integer, @ReturnsOnly bit = 0 
as
declare @study_id int, @sql varchar(1000), @datStartProc datetime

select @study_id=sd.study_id, @datStartProc=getdate()
from cutoff co, survey_def sd
where co.cutoff_id=@cutoff_id
  and co.survey_id=sd.survey_id

select @sql = 
'if exists (select * from sysobjects where id = object_id(N''[S'+convert(varchar,@study_id)+'].[MRD_'+convert(varchar,@cutoff_id)+']'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1) '+
'drop table [S'+convert(varchar,@study_id)+'].[MRD_'+convert(varchar,@cutoff_id)+']'
exec (@SQL)

select @sql = 
'create table s' + convert(varchar,@study_id)+'.MRD_'+convert(varchar,@cutoff_id)+
'  (SampSet integer,'+
'   Samp_dt datetime,'+
'   SampUnit integer,'+
'   Unit_nm char(42),'+
'   SampType char(1),'+
'   SampPop integer,'+
'   QstnForm integer,'+
'   lithocd char(10),'+
'   Rtrn_dt datetime,'+
'   Undel_dt datetime)'
exec (@sql)

exec sp_Export_NewMRD2_sub @cutoff_id, @ReturnsOnly

insert into DashboardLog (Report, Client, Study, Survey, Days, Status, ProcedureBegin, ProcedureEnd)
  select 'Export - get data', C.strClient_nm, S.strStudy_nm, SD.strSurvey_nm, @cutoff_id, case when @returnsOnly=1 then 'Rtrns only' else 'Everything' end, @datStartProc, getdate()
  from client c, study s, survey_def sd, cutoff co
  where c.client_id=s.client_id
  and s.study_id = sd.study_id
  and sd.survey_id=co.survey_id
  and co.cutoff_id=@cutoff_id


