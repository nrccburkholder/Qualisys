CREATE procedure QP_Rep_CATI_Extract
   @Associate varchar(50),
   @Client varchar(50),
   @Study varchar(50),
   @Survey varchar(50),
   @FirstSampleSet varchar(50),
   @LastSampleSet varchar(50)

as
set transaction isolation level read uncommitted
declare @procedurebegin datetime
set @procedurebegin = getdate()

insert into dashboardlog (report, associate, client, study, survey, procedurebegin) 
select 'Extract for CATI', @associate, @client, @study, @survey, @procedurebegin

declare @intsampleset_id1 int, @intsampleset_id2 int

Declare @Survey_id int
declare @Study_id int
declare @strsql varchar(8000)

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

if (select bitdynamic from survey_def where survey_id = @survey_id) = 1

goto display

else 

goto list

Display:
  
  create table #display (message varchar(70))

  insert into #display
	select 'This is a dynamic survey and cannot be extracted for CATI'

  select * from #display

drop table #display

goto completed

list:

select @intSampleSet_id1=SampleSet_id
from SampleSet
where Survey_id=@Survey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@FirstSampleSet)))<=1

select @intSampleSet_id2=SampleSet_id
from SampleSet
where Survey_id=@Survey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@LastSampleSet)))<=1

if @survey_id in (217,218,219,220,223,227,228,230,480,481,482,307,308,305,306,303,320,300,178,179,180,341,817)

  begin

set @strsql = 'select distinct FName, LName, Age, Sex, AreaCode, Phone, ServiceInd_2, ServiceInd_3, Addr, City, St, Zip5, Zip4, LangID, MemberID, VisitType, DOB, ' 

   goto query

  end

else

if @survey_id in (278)

  begin

set @strsql = 'select distinct FName, LName, Age, Sex, AreaCode, Phone, Addr, City, St, Zip5, Zip4, LangID, DOB, ' 

   goto query

  end

else

if @survey_id in (793)

  begin

set @strsql = 'select distinct DRFirstName, DRLastName, Age, Sex, AreaCode, Phone, Addr, City, St, Zip5, Zip4, LangID, ' 

   goto query

  end

else

set @strsql = 'select distinct FName, LName, Age, Sex, AreaCode, Phone, Addr, City, St, Zip5, Zip4, LangID, MemberID, VisitType, DOB, ' 

query:

set @strsql = @strsql + ' p.Pop_id, ss. sampleset_id, su.sampleunit_ID, strSampleUnit_nm ' +
	' into #info ' +
	' from s' + ltrim(rtrim(convert(char(10),@study_id))) + '.population p, selectedsample ss, sampleunit su, sampleset sset ' +
	' where p.pop_id = ss.pop_id ' +
	' and ss.study_id = ' + ltrim(rtrim(convert(char(10),@study_id))) +
	' and ss.sampleunit_id = su.sampleunit_id ' +
	' and ss.sampleset_id = sset.sampleset_id ' +
	' and sset.sampleset_id between ' + convert(varchar,@intsampleset_id1) + ' and ' + convert(varchar,@intsampleset_id2) +
	' and sset.survey_id = ' + ltrim(rtrim(convert(char(10),@survey_id))) +
	' and p.pop_id not in ( ' +
	'   select distinct sp.pop_id ' +
	'   from samplepop sp, questionform qf ' +
	'   where sp.study_id = ' + ltrim(rtrim(convert(char(10),@study_id))) +
	'   and sp.samplepop_id = qf.samplepop_id ' +
	'   and qf.survey_id = ' + ltrim(rtrim(convert(char(10),@survey_id))) +
	'   and qf.datreturned is not null ) ' +
	' and p.pop_id not in ( ' +
	'   select pop_id from tocl where study_id = ' + ltrim(rtrim(convert(char(10),@study_id))) + ' ) ' +
	' alter table #info add litho varchar(10) ' +
	' select i.pop_id, max(strlithocode) as strlithocode into #litho ' +
	' from #info i, samplepop sp, scheduledmailing schm, sentmailing sm ' +
	' where i.sampleset_id = sp.sampleset_id ' +
	' and i.pop_id = sp.pop_id ' +
	' and sp.samplepop_id = schm.samplepop_id ' +
	' and schm.sentmail_id = sm.sentmail_id ' +
	' group by i.pop_id ' + 
	' update i set i.litho = l.strlithocode ' +
	' from #info i, #litho l ' +
	' where i.pop_id = l.pop_id ' +
	' select * from #info ' +
	' drop table #info ' +
	' drop table #litho'

exec(@strsql)

completed:

update dashboardlog 
set procedureend = getdate()
where report = 'Extract for CATI'
and associate = @associate
and client = @client
and study = @study
and survey = @survey
and procedurebegin = @procedurebegin
and procedureend is null

set transaction isolation level read committed


