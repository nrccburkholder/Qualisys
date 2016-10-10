
declare @survey_id int

set @survey_id = 18226

select *
from client
where client_id in (

	select CLIENT_ID
	from study
	where study_id in (

		select STUDY_ID
		from survey_def
		where SURVEY_ID in (
@survey_id
		)

	)

)


select *
from study
where study_id in (

	select STUDY_ID
	from survey_def
	where SURVEY_ID in (

@survey_id
	)

)


select *
from survey_def
where SURVEY_ID = @survey_id

select *
from sampleset ss
where ss.SURVEY_ID in (
@survey_id
)
order by SAMPLESET_ID


select *
from sampleUnit su
where su.SAMPLEPLAN_ID in (

	select SAMPLEPLAN_ID
	from sampleset ss
	where ss.SURVEY_ID in (
@survey_id
	)
)

select cast(sp.SAMPLEPOP_ID as varchar) + ',',*
from samplepop sp
where sp.SAMPLESET_ID in (
	select SAMPLESET_ID
	from sampleset ss
	where ss.SURVEY_ID in (
@survey_id
	)
)

GO

declare @survey_id int

set @survey_id = 18226

update c
	set c.STRCLIENT_NM = c.STRCLIENT_NM
from client c
where client_id in (

	select CLIENT_ID
	from study
	where study_id in (

		select STUDY_ID
		from survey_def
		where SURVEY_ID in (
@survey_id
		)

	)

)

update s
	set s.STRSTUDY_NM = s.STRSTUDY_NM
from study s
where study_id in (

	select STUDY_ID
	from survey_def
	where SURVEY_ID in (
@survey_id
	)

)



update sd
	set sd.STRSURVEY_NM = sd.STRSURVEY_NM
from survey_def sd
where SURVEY_ID in (
@survey_id

 )

 
update ss
	SET ss.strSampleSurvey_nm = ss.strSampleSurvey_nm
from sampleset ss
where ss.SURVEY_ID in (
@survey_id
)


update su
	SET STRSAMPLEUNIT_NM = STRSAMPLEUNIT_NM
from sampleunit su
where sampleunit_id in 
(
	select SAMPLEUNIT_ID
	from sampleUnit su
	where su.SAMPLEPLAN_ID in 
	(
		select SAMPLEPLAN_ID
		from sampleset ss
		where ss.SURVEY_ID in 
		(
@survey_id
		)
	)
)

GO






