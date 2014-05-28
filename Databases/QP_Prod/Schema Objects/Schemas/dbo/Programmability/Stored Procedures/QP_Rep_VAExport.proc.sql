CREATE proc QP_Rep_VAExport  
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @cutoff varchar(25)
AS
set transaction isolation level read uncommitted
declare @procedurebegin datetime, @cutoff_id int
set @procedurebegin = getdate()

Declare @intSurvey_id int, @intstudy_id int
select @intSurvey_id=sd.survey_id, @intstudy_id=sd.study_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @cutoff_id = cutoff_id
from cutoff
where survey_id = @intsurvey_id
  and datediff(ss,@cutoff,datcutoffdate) < 1
  and datediff(ss,@cutoff,datcutoffdate) > -1

exec sp_Export_NewMRD3_VA_First @cutoff_id, 0, 0

insert into dashboardlog (report, associate, client, study, survey, procedurebegin, procedureend) select 'VA Export', @associate, @client, @study, @survey, @procedurebegin, getdate()

--create table #display (txt varchar(800))

declare @sql varchar(800)

--set @sql = 'insert into #display select "The following tables have been created:  s' + convert(varchar,@intstudy_id) + '.MRD1_' + convert(varchar,@cutoff_id) +
--   ' and s' + convert(varchar,@intstudy_id) + '.MRD2_' + convert(varchar,@cutoff_id) + '."'

set @sql = ' delete from s' + convert(varchar,@intstudy_id) + '.MRD1_' + convert(varchar,@cutoff_id) +
           ' where lithocd is null ' +
	   ' delete from s' + convert(varchar,@intstudy_id) + '.MRD2_' + convert(varchar,@cutoff_id) +
           ' where lithocd is null '
exec (@sql)

--select * from #display
set transaction isolation level read committed


