/*
	S32 US15	ACO Completeness
				As a Service Associate, I want survey validation question core checks updated to match current NRC templates, so that I can ensure surveys are correctly set up.


	15.2	modify ACO CAHPScompleteness stored procedure to make use of data from 15.1

Dave Gilsdorf

QP_Prod:
ALTER procedure [dbo].[ACOCAHPSCompleteness] 
DROP FUNCTION [dbo].[ACOCAHPSCompleteness_fn] 
*/
go
use QP_Prod
go
ALTER procedure [dbo].[ACOCAHPSCompleteness] 
AS
-- =============================================
-- Author:	Dave Gilsdorf
-- Procedure Name: ACOCAHPSCompleteness
-- Create date: 1/2014 
-- Description:	Stored Procedure that extracts question form data from QP_Prod
-- History: 1.0  1/2014  by Dave Gilsdorf
--			1.1  10/03/2014 by T. Butler: ACO CAHPS processing -- ATA questions by questionnaire type S10 US 11
--          2.0  02/04/2015 by T. Butler: modify so blank screener does not invoke skip S18 US 20
-- =============================================
BEGIN
	-- assumes an #ACOQF table already exists and has the following columns:
	-- questionform_id int
	-- ATAcnt tinyint
	-- ATAcomplete bit
	-- MeasureCnt tinyint
	-- MeasureComplete bit
	-- Disposition tinyint  
	-- Subtype_nm varchar(50)
	-- SurveyType_id int

	create table #QR (Questionform_id int, qstncore int, intResponseVal int)
	insert into #QR (questionform_id, qstncore, intResponseVal)
			select qr.questionform_id, QstnCore,intResponseVal 
				from QuestionResult qr, #ACOQF qf, SurveyType st 
				where qr.QuestionForm_id=qf.QuestionForm_id 
				and qf.surveytype_id = st.SurveyType_ID
				and st.surveytype_dsc in ('ACOCAHPS','PQRS CAHPS')
			union all 
				select qr.questionform_id, QstnCore,intResponseVal 
					from QuestionResult2 qr, #ACOQF qf, SurveyType st 
					where qr.QuestionForm_id=qf.QuestionForm_id 
					and qf.surveytype_id = st.SurveyType_ID
					and st.surveytype_dsc in ('ACOCAHPS','PQRS CAHPS')
	
	update #ACOQF set ATAcnt=0, ATAcomplete=0, MeasureCnt=0, MeasureComplete=0, Disposition=0 
	from #ACOQF qf
	inner join surveytype st on qf.surveytype_id = st.surveytype_id
	where st.surveytype_dsc in ('ACOCAHPS','PQRS CAHPS')

	update #ACOQF set disposition=255
	from #ACOQF qf
	inner join surveytype st on qf.surveytype_id = st.surveytype_id
	left join #QR qr on qf.questionform_id=qr.questionform_id
	where qr.questionform_id is null
	and st.surveytype_dsc in ('ACOCAHPS','PQRS CAHPS')

	-- if Q1 invokes the skip, ignore questions 5 through 43
	delete q2_43 
	from #QR q1
	inner join #QR q2_43 on q1.questionform_id=q2_43.questionform_id	
	where q1.qstncore=50175 and q1.intresponseval in (2,-5,-6) -- 2.0  
	and q2_43.qstncore in (
						-- all questions that are between Q2 and Q43 that are either a ATA or Measure (or both)
						51426,	-- CG6-A: Number of times visited this provider
						53422,	-- CG6-A: Got urgent care appt when needed
						50182,	-- CG6-A: Got appt for check-up/routine care when needed
						53424,	-- CG6-A: Got answer to medical questions same day
						53427,	-- CG6-A: Got answer to medical questions after hours
						53428,	-- CG6-A: Saw provider within 15 minutes of appt time
						50190,	-- CG6-A: Provider explained things understandably
						50191,	-- CG6-A: Provider listened carefully
						53429,	-- CG6-A: Easy to understand instructions about care
						53425,	-- CG6-A: Provider knew important info about medical history
						50196,	-- CG6-A: Provider showed respect for what patient said
						50197,	-- CG6-A: Provider spent enough time with patient
						50201,	-- CG6-A: Provider discussed reasons to take meds
						50202,	-- CG6-A: Provider discussed reasons not to take meds
						50203,	-- CG6-A: Provider asked about patient's opinion of meds
						50210,	-- CG6-A: Provider discussed reasons to have surgery
						50211,	-- CG6-A: Provider discussed reasons not to have surgery
						50212,	-- CG6-A: Provider asked about patient's opinion of surgery
						50213,	-- CG6-A: Provider discussed sharing health info w/family
						50214,	-- CG6-A: Provider respected wishes about sharing info w/family
						50215	-- CG6-A: Rate Provider
						)
						
	-- if Q4 invokes the skip, ignore questions 5 through 43
	delete q5_43
	from #QR q4
	inner join #QR q5_43 on q4.questionform_id=q5_43.questionform_id	
	where q4.qstncore=51426 and q4.intresponseval in (0,-5,-6) -- 2.0
 	and q5_43.qstncore in (
						-- all questions that are between Q5 and Q43 that are either a ATA or Measure (or both)
						53422,	-- CG6-A: Got urgent care appt when needed
						50182,	-- CG6-A: Got appt for check-up/routine care when needed
						53424,	-- CG6-A: Got answer to medical questions same day
						53427,	-- CG6-A: Got answer to medical questions after hours
						53428,	-- CG6-A: Saw provider within 15 minutes of appt time
						50190,	-- CG6-A: Provider explained things understandably
						50191,	-- CG6-A: Provider listened carefully
						53429,	-- CG6-A: Easy to understand instructions about care
						53425,	-- CG6-A: Provider knew important info about medical history
						50196,	-- CG6-A: Provider showed respect for what patient said
						50197,	-- CG6-A: Provider spent enough time with patient
						50201,	-- CG6-A: Provider discussed reasons to take meds
						50202,	-- CG6-A: Provider discussed reasons not to take meds
						50203,	-- CG6-A: Provider asked about patient's opinion of meds
						50210,	-- CG6-A: Provider discussed reasons to have surgery
						50211,	-- CG6-A: Provider discussed reasons not to have surgery
						50212,	-- CG6-A: Provider asked about patient's opinion of surgery
						50213,	-- CG6-A: Provider discussed sharing health info w/family
						50214,	-- CG6-A: Provider respected wishes about sharing info w/family
						50215	-- CG6-A: Rate Provider
						)

	--> removed flu shot questions: 1.1
	-- the flu shot questions are a series of three yes/no questions, but they only count as a single question for completeness.					
	--update #QR set qstncore=50231 where qstncore in (50232,50233)
	
	-- the race question on the phone survey is a series of 16 yes/no questions, but they only count as a single question for completeness.					
	update #QR set qstncore=50725 where qstncore between 50726 and 50740
	
	declare @ATA table (Surveytype_id int, SubType_nm varchar(50), totalATAcnt int)
	insert into @ATA
	select stqm.surveytype_id, st.subtype_nm, count(*) as totalATAcnt
	from SurveyTypeQuestionMappings stqm
	inner join SurveyType srt on stqm.SurveyType_id = srt.SurveyType_ID 
	left join subtype st on stqm.subtype_id=st.subtype_id
	where stqm.SurveyType_id = srt.SurveyType_ID 
	and srt.surveytype_dsc in ('ACOCAHPS','PQRS CAHPS')
	and stqm.isATA=1
	group by stqm.surveytype_id, st.subtype_nm

	--> new: 1.1
	-- for ACO questionnaire types
	update qf
	set ATAcnt=sub.cnt
		, ATAcomplete=case when sub.cnt >= (ata.totalATAcnt * 0.50) then 1 else 0 end
	from #ACOQF qf
	inner join @ATA ata on isnull(qf.subtype_nm,'null')=isnull(ata.SubType_nm,'null')
	inner join (SELECT st.subtype_nm,stqm.surveytype_id, qr.questionform_id, COUNT(distinct qr.QstnCore) as cnt
				FROM #QR qr
				inner join SurveyTypeQuestionMappings stqm on qr.QstnCore=stqm.QstnCore
				inner join SurveyType srt on stqm.SurveyType_id = srt.SurveyType_ID 
				left join subtype st on stqm.subtype_id=st.subtype_id
				where qr.intResponseVal>=0
				and stqm.SurveyType_id = srt.SurveyType_ID
				and srt.surveytype_dsc in ('ACOCAHPS','PQRS CAHPS')
				and stqm.isATA=1
				group by st.subtype_nm,stqm.surveytype_id, qr.questionform_id) sub
		on qf.questionform_id=sub.questionform_id
		WHERE qf.SurveyType_id=sub.surveytype_id 
		and isnull(qf.Subtype_nm,'null') = isnull(sub.Subtype_nm,'null')

	update qf
	set MeasureCnt=sub.cnt, MeasureComplete=case when sub.cnt >= 1 then 1 else 0 end
	from #ACOQF qf
	inner join (SELECT st.subtype_nm,stqm.surveytype_id, qr.questionform_id, COUNT(distinct qr.qstncore) as cnt
				FROM #QR qr
				inner join SurveyTypeQuestionMappings stqm on qr.QstnCore=stqm.QstnCore
				inner join SurveyType srt on stqm.SurveyType_id = srt.SurveyType_ID 
				left join subtype st on stqm.subtype_id=st.subtype_id
				WHERE qr.intResponseVal >= 0
				and stqm.SurveyType_id = srt.SurveyType_ID
				and srt.surveytype_dsc in ('ACOCAHPS','PQRS CAHPS')
				and stqm.isMeasure=1
				group by st.subtype_nm,stqm.surveytype_id, qr.questionform_id) sub
		on qf.questionform_id=sub.questionform_id
		WHERE qf.SurveyType_id=sub.surveytype_id 
		and isnull(qf.Subtype_nm,'null') = isnull(sub.Subtype_nm,'null')

	update #ACOQF 
	set Disposition=
		case when ATAComplete=1 and MeasureComplete=1
			then 10 -- complete
		when ATAComplete=0 and MeasureComplete=1
			then 31 -- partial
		else
			34 -- blank/incomplete
		end
	where Disposition=0

END
go
if exists (select * from sys.objects where name = 'ACOCAHPSCompleteness_FN')
	DROP FUNCTION [dbo].[ACOCAHPSCompleteness_FN]
go