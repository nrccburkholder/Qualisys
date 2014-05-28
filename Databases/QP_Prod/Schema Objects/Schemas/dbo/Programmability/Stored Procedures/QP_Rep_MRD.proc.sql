CREATE PROCEDURE QP_Rep_MRD
	@Associate varchar(50), 
	@client varchar(80),
	@study varchar(20), 
	@survey varchar(20),
	@firstdate datetime, 
	@lastdate datetime
AS

--Need to change this to not use Unikeys.
--Also, dashboard can only return 30 columns of data.
RETURN

set transaction isolation level read uncommitted
Declare @intSurvey_id int
declare @intStudy_id int
declare @strsql varchar(8000)

select @intSurvey_id=sd.survey_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @intStudy_id=s.study_id 
from study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and c.client_id=s.client_id

--if exists(select table_id from metatable where strtable_nm = 'ENCOUNTER' and study_id = @intstudy_id)
--begin
   set @strsql = 'select pop_id, keyvalue as enc_id into #encids ' +
                     'from s' + ltrim(rtrim(convert(varchar(5),@intstudy_id))) + '.unikeys u, metatable mt ' +
                     'where u.table_id = mt.table_id ' + 
                     'and mt.study_id = ' + ltrim(rtrim(convert(varchar(5),@intstudy_id))) +
	       'and mt.strtable_nm = "ENCOUNTER"'
   exec(@strsql)
--end
print 'step one is complete'

set @strsql = 'select datundeliverable, sset.datsamplecreate_dt, sset.sampleset_id, su.sampleunit_id, '+
	' su.strsampleunit_nm, bv.* '+
	' from s' + ltrim(rtrim(convert(varchar(5),@intstudy_id))) + '.big_view bv, #encids e '+
	' selectedsample ss, sampleset sset, sampleunit su, samplepop sp '+
	'    left outer join '+
	'    (select samplepop_id, datreturned, datundeliverable, strlithocode '+
	'    from sentmailing sm, questionform qf '+
	'    where sm.sentmail_id = qf.sentmail_id '+
	'    and (datreturned is not null or datundeliverable is not null)) as r '+
	' on sp.samplepop_id = r.samplepop_id '+
	' where bv.POPULATIONpop_id = sp.pop_id '+
	' and bv.ENCOUNTERenc_id = e.enc_id '+
	' and sp.study_id = ' + ltrim(rtrim(convert(varchar(5),@intstudy_id)))  +
	' and sp.pop_id = ss.pop_id '+
	' and ss.study_id = ' + ltrim(rtrim(convert(varchar(5),@intstudy_id))) +
	' and sset.survey_id = ' + ltrim(rtrim(convert(varchar(5),@intsurvey_id))) +
	' and ss.strUnitSelectType = "D" '+
	' and sp.sampleset_id = sset.sampleset_id '+
	' and ss.sampleunit_id = su.sampleunit_id '+
	' and dateadd(day,-1,sset.datsamplecreate_dt) <= "' + ltrim(rtrim(convert(datetime,@lastdate))) + '" '+
	' and sset.datsamplecreate_dt >= "' + ltrim(rtrim(convert(datetime,@firstdate))) + '" '+
	' order by sset.datsamplecreate_dt, ss.sampleset_id, bv.populationlname, bv.populationfname'
PRINT @strsql
EXEC(@strsql)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


