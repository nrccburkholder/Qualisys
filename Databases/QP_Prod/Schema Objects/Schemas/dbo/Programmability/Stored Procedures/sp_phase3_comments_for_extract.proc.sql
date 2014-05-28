CREATE procedure sp_phase3_comments_for_extract
as
declare @strsql varchar(2000), @study int

truncate table comments_for_extract

select distinct study_id
into #s
from comments_extract
where datextracted_dt is null
and tiextracted = 0
and study_id is not null

while (select count(*) from #s) > 0
begin

set @study = (select top 1 study_id from #s)

/*
set @strsql = 'insert into comments_for_extract (cmnt_id, questionform_id, strlithocode, strcmnttext, study_id, survey_id, datreported, ' +
	' cmnttype_id, cmntvalence_id, qstncore, strsampleunit_nm, sampleunit_id, actualsampleunit_id, strcmntorhand, cutofffield, strcmnttextum) ' +
	' select cmnt_id, questionform_id, strlithocode, strcmnttext, study_id, ' +
	' survey_id, datreported, cmnttype_id, cmntvalence_id, qstncore, strsampleunit_nm, ' +
	' sampleunit_id, actualsampleunit_id, strcmntorhand, cutofffield, strcmnttextum ' +
	' from comments_extract_view ' +
	' where study_id = ' + convert(varchar,@study)

--To be used when the extract is on a mailed sampleset basis.
*/
set @strsql = 'insert into comments_for_extract (cmnt_id, Questionform_id, samplepop_id, strlithocode, strcmnttext, study_id, survey_id, datreported, ' +
	' cmnttype_id, cmntvalence_id, qstncore, strsampleunit_nm, sampleunit_id, actualsampleunit_id, strcmntorhand, datsamplecreate_dt, datreturned, cutofffield, strcmnttextum) ' +
	' select cmnt_id, Questionform_id, samplepop_id, strlithocode, strcmnttext, study_id, ' +
	' survey_id, datreported, cmnttype_id, cmntvalence_id, qstncore, strsampleunit_nm, ' +
	' sampleunit_id, actualsampleunit_id, strcmntorhand, datsamplecreate_dt, datreturned, cutofffield, strcmnttextum ' +
	' from comments_extract_view ' +
	' where study_id = ' + convert(varchar,@study)

--print @strsql
exec (@strsql)

delete #s where study_id = @study

end


