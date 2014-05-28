--6/1/1 BD modified procedure to allow user to name the output table
CREATE procedure sp_Export_NewMRD3
@cutoff_id integer, @ReturnsOnly bit = 0, @DirectOnly bit = 1, @tablename varchar(50) = null
as
RETURN

declare @study_id int, @survey_id int, @sql varchar(1000), @datStartProc datetime, @tableexists varchar(50)

select @study_id=sd.study_id, @survey_id=sd.survey_id, @datStartProc=getdate()
from cutoff co, survey_def sd
where co.cutoff_id=@cutoff_id
  and co.survey_id=sd.survey_id

update cutoff
 set bitExecutingCutoff = case cutoff_id when @Cutoff_id then 1 else 0 end
where survey_id = @survey_id

select cutoff_id, count(*) cnt
into #count
from questionform
where cutoff_id = @cutoff_id
group by cutoff_id

update c
 set ExportCount = cnt
from #count t, cutoff c
where t.cutoff_id = c.cutoff_id

drop table #count

if @tablename is null
begin
set @tablename = 's'+convert(varchar,@study_id)+'.MRD_'+convert(varchar,@cutoff_id)
set @tableexists = '[s'+convert(varchar,@study_id)+'].[MRD_'+convert(varchar,@cutoff_id)+']'
end
else
begin
set @tableexists = '[s'+convert(varchar,@study_id)+'].['+@tablename+']'
set @tablename = 's'+convert(varchar,@study_id)+'.'+@tablename
end
/*
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

exec sp_Export_NewMRD3_sub @cutoff_id, @ReturnsOnly, @DirectOnly
*/
select @sql = 
'if not exists (select * from sysobjects where id = object_id(N'''+@tableexists+''') and OBJECTPROPERTY(id, N''IsUserTable'') = 1) 
begin
create table '+@tablename+
'  (SampSet integer,'+
'   Samp_dt datetime,'+
'   SampUnit integer,'+
'   Unit_nm char(42),'+
'   SampType char(1),'+
'   SampPop integer,'+
'   QstnForm integer,'+
'   lithocd char(10),'+
'   Rtrn_dt datetime,'+
'   Undel_dt datetime)
exec sp_Export_NewMRD3_sub '+convert(varchar,@cutoff_id)+', '+convert(varchar,@ReturnsOnly)+', '+convert(varchar,@DirectOnly)+', '''+@tablename+'''
end'

exec (@SQL)

insert into DashboardLog (Report, Client, Study, Survey, Days, Status, ProcedureBegin, ProcedureEnd)
  select 'Export - get data', C.strClient_nm, S.strStudy_nm, SD.strSurvey_nm, @cutoff_id, case when @returnsOnly=1 then 'Rtrns only' else 'Everything' end, @datStartProc, getdate()
  from client c, study s, survey_def sd, cutoff co
  where c.client_id=s.client_id
  and s.study_id = sd.study_id
  and sd.survey_id=co.survey_id
  and co.cutoff_id=@cutoff_id


