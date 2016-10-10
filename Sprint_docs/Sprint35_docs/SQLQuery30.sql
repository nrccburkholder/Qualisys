
use NRC_DataMart_ETL

/*
select *
from QP_Prod.dbo.SAMPLEPOP
where SAMPLEpop_ID in (
	115473094

)
*/

/*

select top 100 *
	from qp_prod.dbo.samplepop spt
	inner join QP_Prod.[dbo].[SCHEDULEDMAILING] smg on smg.SAMPLEPOP_ID = spt.SAMPLEPOP_ID
	inner join QP_Prod.[dbo].[SENTMAILING] sm on sm.SCHEDULEDMAILING_ID = smg.SCHEDULEDMAILING_ID
	inner join QP_Prod.[dbo].[MAILINGSTEP] ms on ms.MAILINGSTEP_ID = smg.MAILINGSTEP_ID
	inner join QP_Prod.[dbo].[MAILINGMETHODOLOGY] mmg on mmg.METHODOLOGY_ID = ms.METHODOLOGY_ID and mmg.SURVEY_ID = ms.SURVEY_ID
	inner join QP_Prod.[dbo].[StandardMethodology] stmg on stmg.StandardMethodologyID = mmg.StandardMethodologyID
	where sm.DATMAILED is not null
	and smg.OVERRIDEITEM_ID is null
	and stmg.MethodologyType = 'Mail Only'
order by SAMPLESET_ID desc

*/




select distinct SAMPLEPOP_ID,sp.SAMPLESET_ID, 0 as NumberOfMailAttempts
into #SamplePopTemp
from qp_prod.dbo.samplepop sp
where sp.SAMPLEpop_ID in (
	select SAMPLEPOP_ID
	from qp_prod.dbo.samplepop
	where SAMPLESET_ID = 1504167

)


	select smg.SAMPLEPOP_ID , sm.SENTMAIL_ID, sm.DATUNDELIVERABLE,  ms.INTSEQUENCE, qf.datReturned, dlog.Disposition_id, min(std.Hierarchy) heirarchy
	INTO #Mailings
	FROM #SamplePopTemp spt
	inner join QP_Prod.[dbo].[SCHEDULEDMAILING] smg on smg.SAMPLEPOP_ID = spt.SAMPLEPOP_ID
	inner join QP_Prod.[dbo].[SENTMAILING] sm on sm.SCHEDULEDMAILING_ID = smg.SCHEDULEDMAILING_ID
	inner join QP_Prod.[dbo].[MAILINGSTEP] ms on ms.MAILINGSTEP_ID = smg.MAILINGSTEP_ID
	inner join QP_Prod.[dbo].[MAILINGMETHODOLOGY] mmg on mmg.METHODOLOGY_ID = ms.METHODOLOGY_ID and mmg.SURVEY_ID = ms.SURVEY_ID
	inner join QP_Prod.[dbo].[StandardMethodology] stmg on stmg.StandardMethodologyID = mmg.StandardMethodologyID
	inner join QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.SAMPLEPOP_ID = smg.SAMPLEPOP_ID and qf.SENTMAIL_ID = sm.SENTMAIL_ID
	inner join QP_Prod.[dbo].SURVEY_DEF sd on sd.survey_id = qf.survey_id
	inner join QP_Prod.[dbo].SurveyType st on st.SurveyType_id = sd.surveytype_id
	left join QP_Prod.[dbo].[DispositionLog] dlog on dlog.SamplePop_id = smg.SAMPLEPOP_ID and dlog.SentMail_id = sm.SENTMAIL_ID
	left join QP_Prod.[dbo].[Disposition] d on d.Disposition_id = dlog.Disposition_id
	left join QP_Prod.dbo.SurveyTypeDispositions std on std.Disposition_ID = d.Disposition_id and std.SurveyType_ID = st.SurveyType_ID
	where smg.OVERRIDEITEM_ID is null
	and stmg.MethodologyType = 'Mail Only'
	group by smg.SAMPLEPOP_ID , sm.SENTMAIL_ID, sm.DATUNDELIVERABLE,  ms.INTSEQUENCE, qf.datReturned, dlog.Disposition_id


	select *
	from #Mailings

	--SELECT spt.SamplePop_id,
	--	CASE 
	--		WHEN m1.DATRETURNED is NOT NULL and (m1.Disposition_id IN (3,13,19,11,21,45)) THEN m1.INTSEQUENCE
	--		WHEN m1.DATUNDELIVERABLE is NOT NULL and m1.Disposition_id = 5 THEN m1.INTSEQUENCE
	--		ELSE (SELECT MAX(INTSEQUENCE) FROM #Mailings m WHERE m.SAMPLEPOP_ID = spt.SAMPLEPOP_ID)
	--	END as NumberOfMailAttempts, m1.Disposition_id, m1.heirarchy
	--FROM #SamplePopTemp spt
	--left join #Mailings m1 on m1.SAMPLEPOP_ID = spt.SAMPLEPOP_ID 
	--and m1.heirarchy = (SELECT min(heirarchy) FROM #Mailings m WHERE m.SAMPLEPOP_ID = spt.SAMPLEPOP_ID)

	--update spt
	--SET NumberOfMailAttempts = 
	--	CASE 
	--		WHEN m1.DATRETURNED is NOT NULL and (m1.Disposition_id IN (3,13,19,11,21,45)) THEN m1.INTSEQUENCE
	--		WHEN m1.DATUNDELIVERABLE is NOT NULL and m1.Disposition_id = 5 THEN m1.INTSEQUENCE
	--		ELSE (SELECT MAX(INTSEQUENCE) FROM #Mailings m WHERE m.SAMPLEPOP_ID = spt.SAMPLEPOP_ID)
	--	END
	--FROM #SamplePopTemp spt
	--left join #Mailings m1 on m1.SAMPLEPOP_ID = spt.SAMPLEPOP_ID 
	--and m1.heirarchy = (SELECT min(heirarchy) FROM #Mailings m WHERE m.SAMPLEPOP_ID = spt.SAMPLEPOP_ID) 


	--select *
	--from #SamplePopTemp


	drop table #Mailings
	drop table #SamplePopTemp