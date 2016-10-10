
--select top 100 *
--from QP_Prod.dbo.SAMPLEPOP
--order by SAMPLESET_ID desc


use NRC_DataMart_ETL

SELECT sp.SAMPLEPOP_ID, ss.SAMPLESET_ID, ss.SURVEY_ID
	INTO #SamplePopTemp
FROM QP_Prod.dbo.SAMPLEPOP sp
inner join QP_Prod.dbo.SAMPLESET ss on ss.SAMPLESET_ID = sp.SAMPLESET_ID
where sp.SAMPLESET_ID in
( 
1218428,
1218410,
1218626,
1218629,
1218627,
1218434,
1218470,
1218469,
1218458,
1218391
)


SELECT *
from #SamplePopTemp

DECLARE @ExtractFileID int = 1234

truncate table SampleSetTemp 

insert SampleSetTemp 
			(ExtractFileID,SAMPLESET_ID, CLIENT_ID,STUDY_ID, SURVEY_ID, SAMPLEDATE,IsDeleted, StandardMethodologyID, IneligibleCount, SamplingMethodID )
		select distinct @ExtractFileID,eh.SAMPLESET_ID,study.client_id,study.study_id, survey.survey_id, ss.DATSAMPLECREATE_DT,0,
			mm.StandardMethodologyID, -- S15 US11
			ISNULL(ss.IneligibleCount,0), -- S18 US 16
			pdef.SamplingMethod_id -- S20 US9
		 from #SamplePopTemp eh		  
		  left join QP_Prod.dbo.SAMPLESET ss with (NOLOCK) on ss.sampleset_id = eh.SAMPLESET_ID
          left join QP_Prod.dbo.SURVEY_DEF survey with (NOLOCK) on eh.SURVEY_ID = survey.survey_id
          left join QP_Prod.dbo.STUDY study with (NOLOCK) on survey.study_id = study.study_id
		  left join QP_Prod.dbo.MAILINGMETHODOLOGY mm with (NOLOCK) on mm.SURVEY_ID = survey.SURVEY_ID and mm.BITACTIVEMETHODOLOGY = 1-- S15 US11
		  left join QP_Prod.dbo.PeriodDates pdates with (NOLOCK) on pdates.SampleSet_id = ss.SAMPLESET_ID -- S20 US9
		  left join QP_Prod.dbo.PeriodDef pdef on pdef.PeriodDef_id = pdates.PeriodDef_id -- S20 US9

	SELECT *
	FROM SampleSetTemp sst;
	/*
	SELECT sst.SAMPLESET_ID, max (DATMAILED) datMailed
	INTO #Mailings
	FROM SampleSetTemp sst
	INNER JOIN QP_Prod.dbo.SAMPLESET ss with (NOLOCK) on ss.sampleset_id = sst.SAMPLESET_ID
	INNER JOIN QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on sp.SAMPLESET_ID = ss.SAMPLESET_ID
	inner join QP_Prod.[dbo].[SCHEDULEDMAILING] smg on smg.SAMPLEPOP_ID = sp.SAMPLEPOP_ID
	inner join QP_Prod.[dbo].[SENTMAILING] sm on sm.SCHEDULEDMAILING_ID = smg.SCHEDULEDMAILING_ID
	where sm.DATMAILED is not null
	group by sst.SAMPLESET_ID

	select *
	from #Mailings

	update sst
		SET datFirstMailed = datMailed
	FROM SampleSetTemp sst
	INNER JOIN #Mailings m1 on m1.SAMPLESET_ID = sst.SAMPLESET_ID

	drop table #Mailings
	*/

	WITH Mailings_CTE(SampleSet_id, datMailed)
	AS
	(
		SELECT sst.SAMPLESET_ID, max (DATMAILED) datMailed
		FROM SampleSetTemp sst
		INNER JOIN QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on sp.SAMPLESET_ID = sst.SAMPLESET_ID
		inner join QP_Prod.[dbo].[SCHEDULEDMAILING] smg on smg.SAMPLEPOP_ID = sp.SAMPLEPOP_ID
		inner join QP_Prod.[dbo].[SENTMAILING] sm on sm.SCHEDULEDMAILING_ID = smg.SCHEDULEDMAILING_ID
		inner join QP_Prod.[dbo].[MAILINGSTEP] ms on ms.MAILINGSTEP_ID = smg.MAILINGSTEP_ID
		where sm.DATMAILED is not null 
		AND ms.INTSEQUENCE = 1
		group by sst.SAMPLESET_ID
	)

	update sst
		SET datFirstMailed = datMailed
	FROM SampleSetTemp sst
	INNER JOIN Mailings_CTE m1 on m1.SAMPLESET_ID = sst.SAMPLESET_ID



	SELECT *
	FROM SampleSetTemp sst

	drop table #SamplePopTemp
	