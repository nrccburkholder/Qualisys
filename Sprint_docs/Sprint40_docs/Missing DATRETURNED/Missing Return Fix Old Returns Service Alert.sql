USE [QP_Prod]
GO

IF OBJECT_ID('tempdb..#QF') IS NOT NULL DROP TABLE #QF

select distinct st.SurveyType_dsc,sd.study_id,sd.SURVEY_ID,qf.QUESTIONFORM_ID, qf.SamplePop_id, qf.strScanBatch, qf.strSTRBatchNumber, sm.strlithocode,ss.SampleEncounterDate
into #QF
from QuestionForm qf
inner join sentmailing sm on qf.sentmail_id=sm.sentmail_id
left join scanningresets sr on sr.strLithoCode = sm.strLithocode
left join Questionform_Missing_datReturned qfmr on qfmr.QuestionForm_id = qf.QuestionForm_id and qfmr.program_name='SQLAgent - TSQL JobStep (Job 0x40D7E91D87EAD544B986C72062EBD847 : Step 7)'
inner join Survey_def sd on qf.Survey_id=sd.Survey_id
inner join SurveyType st on sd.Surveytype_id=st.Surveytype_id
inner join SAMPLEPOP sp on sp.SAMPLEPOP_ID = qf.SAMPLEPOP_ID
inner join SELECTEDSAMPLE ss on ss.SAMPLESET_ID = sp.SAMPLESET_ID and ss.pop_id = sp.pop_id
where qf.DATRETURNED is null 
and qf.datUnusedReturn is null 
and qf.UnusedReturn_id <> 6
and (qf.strScanBatch is not null and LEN(qf.strScanBatch) > 0)
and st.Surveytype_dsc in ('ICHCAHPS','Home Health CAHPS')
and qfmr.QuestionForm_id is null -- excluding those problem questionforms captured in logging
and sr.strLithoCode is null
and ss.SampleEncounterDate between '2015-07-01' and '2015-12-31' -- 3rd & 4th quarter
and sm.datExpire < GetDATE()




select *
from #QF
order by SamplePop_id,strScanBatch

select qf.*, com.[QstnCore], com.[CmntType_id]
from #QF qf
left join [dbo].[Comments] com on com.QuestionForm_id = qf.QuestionForm_id
where com.CmntType_id in (2,3)

if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'temp_MissingDatreturnedServiceAlert')
begin	
	INSERT INTO temp_MissingDatreturnedServiceAlert
	select qf.*, com.[QstnCore], com.[CmntType_id]
	from #QF qf
	left join [dbo].[Comments] com on com.QuestionForm_id = qf.QuestionForm_id
end
else 
begin	
	select qf.*, com.[QstnCore], com.[CmntType_id]
	INTO temp_MissingDatreturnedServiceAlert
	from #QF qf
	left join [dbo].[Comments] com on com.QuestionForm_id = qf.QuestionForm_id
end


