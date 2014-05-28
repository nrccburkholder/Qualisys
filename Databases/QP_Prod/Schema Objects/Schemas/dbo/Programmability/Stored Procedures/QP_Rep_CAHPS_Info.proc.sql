CREATE PROCEDURE QP_Rep_CAHPS_Info
   @Associate varchar(50),
   @Client varchar(50),
   @Study varchar(50),
   @Survey varchar(50),
   @FirstSampleSet varchar(50),
   @LastSampleSet varchar(50)
AS
set transaction isolation level read uncommitted

declare @procedurebegin datetime
set @procedurebegin = getdate()

insert into dashboardlog (report, associate, client, study, survey, procedurebegin) select 'Information for CAHPS', @associate, @client, @study, @survey, @procedurebegin

declare @intsampleset_id1 int, @intsampleset_id2 int

Declare @Survey_id int
declare @Study_id int
declare @sqlstr varchar(8000)

select @Survey_id=sd.survey_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @Study_id=s.study_id 
from study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and c.client_id=s.client_id

select @intSampleSet_id1=SampleSet_id
from SampleSet
where Survey_id=@Survey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@FirstSampleSet)))<=1

select @intSampleSet_id2=SampleSet_id
from SampleSet
where Survey_id=@Survey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@LastSampleSet)))<=1

set @sqlstr = 'select "A" + p.memberid as memid, p.visittype, ms.strmailingstep_nm as mailingstep, sm.strlithocode as lithocode' +
--set @sqlstr = 'select p.memberid as memid, p.visittype, ms.strmailingstep_nm as mailingstep, sm.strlithocode as lithocode' +
	' , sm.datundeliverable as dateundeliverable ' +
	' from s' + ltrim(rtrim(convert(char(10),@study_id))) + '.population p, ' +
	' sentmailing sm, scheduledmailing schm, samplepop sp, mailingstep ms ' +
	' where p.pop_id = sp.pop_id ' +
	' and sp.sampleset_id between ' + convert(varchar,@intsampleset_id1) + ' and ' + convert(varchar,@intsampleset_id2) + 
	' and ms.survey_id = ' + ltrim(rtrim(convert(char(10),@survey_id)))  +
	' and schm.samplepop_id = sp.samplepop_id ' +
	' and schm.sentmail_id = sm.sentmail_id ' +
	' and schm.mailingstep_id = ms.mailingstep_id order by memberid, intsequence'

exec(@sqlstr)

update dashboardlog 
set procedureend = getdate()
where report = 'Information for CAHPS'
and associate = @associate
and client = @client
and study = @study
and survey = @survey
and procedurebegin = @procedurebegin
and procedureend is null

set transaction isolation level read committed


