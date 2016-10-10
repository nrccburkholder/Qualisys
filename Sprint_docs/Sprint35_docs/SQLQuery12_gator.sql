
select *
from client
where client_id in (

	select CLIENT_ID
	from study
	where study_id in (

		select STUDY_ID
		from survey_def
		where SURVEY_ID = 15908

	)

)


select *
from study
where study_id in (

	select STUDY_ID
	from survey_def
	where SURVEY_ID = 15908

)


select *
from survey_def
where SURVEY_ID = 15908

select *
from sampleset ss
where ss.SURVEY_ID in (
			13245,
12421,
10344,
10844,
15211,
10909,
10770,
14010,
13790,
10729
)
order by SAMPLESET_ID


select *
from sampleUnit su
where su.SAMPLEPLAN_ID in (

	select SAMPLEPLAN_ID
	from sampleset ss
	where ss.SURVEY_ID in (
				13245,
12421,
10344,
10844,
15211,
10909,
10770,
14010,
13790,
10729
	)
)

select cast(sp.SAMPLEPOP_ID as varchar) + ',',*
from samplepop sp
where sp.SAMPLESET_ID in (
	select SAMPLESET_ID
	from sampleset ss
	where ss.SURVEY_ID in (
	15908
	)
)


select *
	FROM samplepop sp
where sp.SAMPLESET_ID in (
	select SAMPLESET_ID
	from sampleset ss
		where ss.sampleset_ID in (
		1534680
	)
)

/*

use QP_Prod



update sp
	set bitBadAddress = bitBadAddress
	FROM samplepop sp
where sp.SAMPLESET_ID in (
	select SAMPLESET_ID
	from sampleset ss
		where ss.sampleset_ID in (
		1534677
	)
)



update ss
	SET ss.strSampleSurvey_nm = ss.strSampleSurvey_nm
from sampleset ss
where ss.sampleset_ID in (
1534677
)



update su
	SET STRSAMPLEUNIT_NM = STRSAMPLEUNIT_NM
from sampleunit su
where sampleunit_id in (

	select SAMPLEUNIT_ID
	from sampleUnit su
	where su.SAMPLEPLAN_ID in (

		select SAMPLEPLAN_ID
		from sampleset ss
		where ss.sampleset_ID in (
1534677 
		)
	)
)

*/

select *
from NRC_DataMart_ETL.dbo.SampleUnitTemp
where isCensus is not null