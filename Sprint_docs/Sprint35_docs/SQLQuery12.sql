
select *
from client
where client_id in (

	select CLIENT_ID
	from study
	where study_id in (

		select STUDY_ID
		from survey_def
		where SURVEY_ID = 18226

	)

)


select *
from study
where study_id in (

	select STUDY_ID
	from survey_def
	where SURVEY_ID = 18226

)


select *
from survey_def
where SURVEY_ID = 18226

select *
from sampleset ss
where ss.SURVEY_ID in (
18225
)
order by SAMPLESET_ID


select *
from sampleUnit su
where su.SAMPLEPLAN_ID in (

	select SAMPLEPLAN_ID
	from sampleset ss
	where ss.SURVEY_ID in (
18226
	)
)

select cast(sp.SAMPLEPOP_ID as varchar) + ',',*
from samplepop sp
where sp.SAMPLESET_ID in (
	select SAMPLESET_ID
	from sampleset ss
	where ss.SURVEY_ID in (
	18226
	)
)

/*

declare @survey_id int

set @survey_id = 18226


update su
	SET STRSAMPLEUNIT_NM = STRSAMPLEUNIT_NM
from sampleunit su
where sampleunit_id in (

select SAMPLEUNIT_ID
from sampleUnit su
where su.SAMPLEPLAN_ID in (

	select SAMPLEPLAN_ID
	from sampleset ss
	where ss.SURVEY_ID in (
		@survey_id
	)
)

)


update sp
	set bitBadAddress = bitBadAddress
	FROM samplepop sp
where sp.SAMPLESET_ID in (
	select SAMPLESET_ID
	from sampleset ss
	where ss.SURVEY_ID in (
	@survey_id
	)
)


update ss
	SET ss.strSampleSurvey_nm = ss.strSampleSurvey_nm
from sampleset ss
where ss.SURVEY_ID in (
@survey_id
)


use QP_Prod
update su
	SET STRSAMPLEUNIT_NM = STRSAMPLEUNIT_NM
from sampleunit su
where sampleunit_id in (

select SAMPLEUNIT_ID
from sampleUnit su
where su.SAMPLEPLAN_ID in (

	select SAMPLEPLAN_ID
	from sampleset ss
	where ss.SURVEY_ID in (
@survey_id
	)
)

)

*/

