CREATE PROCEDURE QP_Rep_ProWest_Extract
   @Associate varchar(50),
   @Client varchar(50),
   @Study varchar(50),
   @Survey varchar(50),
   @SampleSet varchar(50),
   @MailingStep varchar(50),
   @Bundled varchar(50)
As
set transaction isolation level read uncommitted
Declare @intSurvey_id int, @intSampleSet_id int, @intMailingStep_id int, @intStudy_id int, @strsql varchar(8000)

select @intSurvey_id=sd.survey_id, @intStudy_id=s.study_id  
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @intSampleSet_id=sampleset_id
from sampleset 
where survey_id=@intsurvey_id
and datediff(second,@sampleset,datsamplecreate_dt) < 1

select @intMailingStep_id=mailingstep_id
from mailingstep
where survey_id=@intSurvey_id
and strmailingstep_nm=@MailingStep

set @strsql = 'select distinct strlithocode, clienttype, visittype, memberid, ' +
	' ltrim(rtrim(left(areacode,3)))+ltrim(rtrim(right(phone,7))) as Phone, FName, LName, Age, Sex,  Addr, City, St, Zip5, Zip4, del_pt, ' +
	' LangID, p.Pop_id from s' + ltrim(rtrim(convert(char(10),@intstudy_id))) + '.population p,' +
	' selectedsample ss, sampleunit su, sampleset sset, sentmailing sm, scheduledmailing schm, samplepop sp ' +
	' where p.pop_id = ss.pop_id ' +
	' and ss.study_id = ' + ltrim(rtrim(convert(char(10),@intstudy_id))) +
	' and ss.sampleunit_id = su.sampleunit_id ' +
	' and ss.sampleset_id = sset.sampleset_id ' +
	' and ss.sampleset_id = ' + convert(varchar,@intsampleset_id) +
	' and sset.survey_id = ' + ltrim(rtrim(convert(char(10),@intsurvey_id))) +
	' and ss.pop_id = sp.pop_id ' +
	' and ss.sampleset_id = sp.sampleset_id ' +
	' and sp.samplepop_id = schm.samplepop_id ' +
	' and schm.sentmail_id = sm.sentmail_id ' +
	' and sm.datprinted is not null ' +
	' and datediff(second,''' + convert(varchar,@Bundled) + ''',datbundled) < 1 ' +
	' and schm.mailingstep_id = ' + convert(varchar,@intMailingStep_id) +
	' and p.pop_id not in ( ' +
	'   select distinct sp.pop_id ' +
	'   from samplepop sp, questionform qf ' +
	'   where sp.study_id = ' + ltrim(rtrim(convert(char(10),@intstudy_id))) +
	'   and sp.samplepop_id = qf.samplepop_id ' +
	'   and qf.survey_id = ' + ltrim(rtrim(convert(char(10),@intsurvey_id))) +
	'   and qf.datreturned is not null ) ' +
	' and p.pop_id not in ( ' +
	'   select pop_id from tocl where study_id = ' + ltrim(rtrim(convert(char(10),@intstudy_id))) + ' ) '

--print @strsql

exec(@strsql)

set transaction isolation level read committed


