CREATE PROCEDURE QP_Rep_SampleUnitCounts 

  @Associate varchar(50), 
  @client varchar(80), 
  @study varchar(20), 
  @survey varchar(50),
  @dataset datetime
AS
set transaction isolation level read uncommitted
declare @procedurebegin datetime
set @procedurebegin = getdate()

insert into dashboardlog (report, associate, client, study, survey, sampleset, procedurebegin) 
select 'Sample Unit Counts', @associate, @client, @study, @survey, @dataset, @procedurebegin

declare  @intstudy int, @intdataset int, @intsurvey int, @strsql varchar(8000), @intclient int

create table #ss (strsampleunit_nm varchar(42))
create table #s (facilitynum varchar(42), cnt int)

select @intclient = client_id from client where strclient_nm = @client
select @intstudy = study_id from study where strstudy_nm = @study and client_id = @intclient
select @intdataset = dataset_id from data_set where study_id = @intstudy and @dataset = datload_dt
select @intsurvey = survey_id from survey_def where strsurvey_nm = @survey

insert into #ss select strsampleunit_nm 
from sampleplan sp, sampleunit su
where survey_id = @intsurvey
and sp.sampleplan_id = su.sampleplan_id
and inttargetreturn > 0

set @strsql = 'insert into #s select facilitynum, count(*) ' +
	' from s' + convert(varchar(5),@intstudy) + '.encounter e, datasetmember d ' +
	' where d.dataset_id = ' + convert(varchar(5),@intdataset) + 
	' and d.enc_id = e.enc_id ' +
	' group by facilitynum '

exec(@strsql)

select strsampleunit_nm, cnt from #ss left join #s
on facilitynum = strsampleunit_nm
where (cnt <= 10 or cnt is null)

drop table #s
drop table #ss

update dashboardlog 
set procedureend = getdate()
where report = 'Sample Unit Counts'
and associate = @associate
and client = @client
and study = @study
and sampleset = @dataset
and procedurebegin = @procedurebegin

set transaction isolation level read committed


