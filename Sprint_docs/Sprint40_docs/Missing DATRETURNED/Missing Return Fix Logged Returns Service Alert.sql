USE [QP_Prod]
GO


IF OBJECT_ID('tempdb..#QF') IS NOT NULL DROP TABLE #QF


--select distinct st.SurveyType_dsc,sd.study_id,sd.SURVEY_ID,qf.QUESTIONFORM_ID, qfmr.SamplePop_id, qfmr.DATRETURNED, sm.strlithocode,ss.SampleEncounterDate
select distinct st.SurveyType_dsc,sd.study_id,sd.SURVEY_ID,qf.QUESTIONFORM_ID, qf.SamplePop_id, qf.strScanBatch, qf.strSTRBatchNumber, sm.strlithocode,ss.SampleEncounterDate
into #QF
from Questionform_Missing_datReturned qfmr
inner join QuestionForm qf on qf.questionform_id = qfmr.questionform_ID
inner join sentmailing sm on qf.sentmail_id=sm.sentmail_id
left join scanningresets sr on sr.strLithoCode = sm.strLithocode
inner join Survey_def sd on qf.Survey_id=sd.Survey_id
inner join SurveyType st on sd.Surveytype_id=st.Surveytype_id
inner join SAMPLEPOP sp on sp.SAMPLEPOP_ID = qf.SAMPLEPOP_ID
inner join SELECTEDSAMPLE ss on ss.SAMPLESET_ID = sp.SAMPLESET_ID and ss.pop_id = sp.pop_id
where st.Surveytype_dsc in ('ICHCAHPS','Home Health CAHPS')
and program_name='SQLAgent - TSQL JobStep (Job 0x40D7E91D87EAD544B986C72062EBD847 : Step 7)'
and len(notes) = 0
and qfmr.DATRETURNED is not null
and qf.DATRETURNED is null
and qf.UnusedReturn_id <> 6
and sr.strLithoCode is null
and ss.SampleEncounterDate between '2015-07-01' and '2015-12-31' -- 3rd and 4th quarter
and sm.datExpire < GetDATE()



select *
from #QF
order by SamplePop_id

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



select * 
from temp_MissingDatreturnedServiceAlert
where CmntType_id in (2,3)

begin tran
update c
set CmntType_id = 1
from Comments c
inner join temp_MissingDatreturnedServiceAlert t on c.questionform_id = t.questionform_id
where t.cmnttype_id in (2,3)

select c.*
from Comments c
inner join temp_MissingDatreturnedServiceAlert t on c.questionform_id = t.questionform_id
where t.cmnttype_id in (2,3)

commit tran

rollback tran