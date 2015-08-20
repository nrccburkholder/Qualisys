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
			select qr.questionform_id, QstnCore,intResponseVal from QuestionResult qr, #ACOQF qf where qr.QuestionForm_id=qf.QuestionForm_id and qf.surveytype_id in (10,14)
			union all select qr.questionform_id, QstnCore,intResponseVal from QuestionResult2 qr, #ACOQF qf where qr.QuestionForm_id=qf.QuestionForm_id and qf.surveytype_id in (10,14)
	
	update #ACOQF set ATAcnt=0, ATAcomplete=0, MeasureCnt=0, MeasureComplete=0, Disposition=0 where surveytype_id in (10,14)

	update #ACOQF set disposition=255
	from #ACOQF qf
	left join #QR qr on qf.questionform_id=qr.questionform_id
	where qr.questionform_id is null
	and qf.surveytype_id in (10,14)

	-- if Q1 invokes the skip, ignore questions 5 through 43
	delete q2_43 
	from #QR q1
	inner join #QR q2_43 on q1.questionform_id=q2_43.questionform_id	
	where q1.qstncore=50175 and q1.intresponseval in (2,-5,-6) -- 2.0  
	and q2_43.qstncore in (
						50176, --02		Q2. Is this the provider you usually see if you need a check-up want advice about a health problem or get sick or hurt?
						50177, --03		Q3. How long have you been going to this provider?
						51426, --04		Q4. In the last 6 months how many times did you visit this provider to get care for yourself? 
						50179, --05		Q5. In the last 6 months did you phone this providers office to get an appointment for an illness injury or condition that needed care right away? 
						50181, --06		Q7. In the last 6 months did you make any appointments for a check-up or routine care with this provider?
						50183, --07		Q9. In the last 6 months did you phone this providers office with a medical question during regular office hours?
						50185, --08		Q11. In the last 6 months did you phone this providers office with a medical question after regular office hours?
						50187, --09		Q13. Some offices remind patients about tests treatment or appointments in between their visits. In the last 6 months did you get any reminders from this providers office between visits?
						50189, --10		Q15. Wait time includes time spent in the waiting room and exam room. In the last 6 months how often did you see this provider within 15 minutes of your appointment time?
						50190, --11		Q16. In the last 6 months how often did this provider explain things in a way that was easy to understand?
						50191, --12		Q17. In the last 6 months how often did this provider listen carefully to you?
						50192, --13		Q18. In the last 6 months did you talk with this provider about any health questions or concerns?
						50194, --14		Q20. In the last 6 months how often did this provider seem to know the important information about your medical history?
						50195, --15		Q21. When you visited this provider in the last 6 months how often did he or she have your medical records?
						50196, --16		Q22. In the last 6 months how often did this provider show respect for what you had to say?
						50197, --17		Q23. In the last 6 months how often did this provider spend enough time with you?
						50198, --18		Q24. In the last 6 months did this provider order a blood test x-ray or other test for you?
						50200, --19		Q26. In the last 6 months did you and this provider talk about starting or stopping a prescription medicine?
						50209, --20		Q35. In the last 6 months did you and this provider talk about having surgery or any type of procedure?
						50213, --21		Q39. In the last 6 months did you and this provider talk about how much of your personal health information you wanted shared with your family or friends?
						50214, --22		Q40. In the last 6 months did this provider respect your wishes about how much of your personal health information to share with your family or friends?
						50215, --23		Q41. Using any number from 0 to 10 where 0 is the worst provider possible and 10 is the best provider possible what number would you use to rate this provider?
						50216, --24		Q42. In the last 6 months how often were clerks and receptionists at this providers office as helpful as you thought they should be?
						50217  --25		Q43. In the last 6 months how often did clerks and receptionists at this providers office treat you with courtesy and respect?
						)
						
	-- if Q4 invokes the skip, ignore questions 5 through 43
	delete q5_43
	from #QR q4
	inner join #QR q5_43 on q4.questionform_id=q5_43.questionform_id	
	where q4.qstncore=51426 and q4.intresponseval in (0,-5,-6) -- 2.0
 	and q5_43.qstncore in (
						50179, --05		Q5. In the last 6 months did you phone this providers office to get an appointment for an illness injury or condition that needed care right away? 
						50181, --06		Q7. In the last 6 months did you make any appointments for a check-up or routine care with this provider?
						50183, --07		Q9. In the last 6 months did you phone this providers office with a medical question during regular office hours?
						50185, --08		Q11. In the last 6 months did you phone this providers office with a medical question after regular office hours?
						50187, --09		Q13. Some offices remind patients about tests treatment or appointments in between their visits. In the last 6 months did you get any reminders from this providers office between visits?
						50189, --10		Q15. Wait time includes time spent in the waiting room and exam room. In the last 6 months how often did you see this provider within 15 minutes of your appointment time?
						50190, --11		Q16. In the last 6 months how often did this provider explain things in a way that was easy to understand?
						50191, --12		Q17. In the last 6 months how often did this provider listen carefully to you?
						50192, --13		Q18. In the last 6 months did you talk with this provider about any health questions or concerns?
						50194, --14		Q20. In the last 6 months how often did this provider seem to know the important information about your medical history?
						50195, --15		Q21. When you visited this provider in the last 6 months how often did he or she have your medical records?
						50196, --16		Q22. In the last 6 months how often did this provider show respect for what you had to say?
						50197, --17		Q23. In the last 6 months how often did this provider spend enough time with you?
						50198, --18		Q24. In the last 6 months did this provider order a blood test x-ray or other test for you?
						50200, --19		Q26. In the last 6 months did you and this provider talk about starting or stopping a prescription medicine?
						50209, --20		Q35. In the last 6 months did you and this provider talk about having surgery or any type of procedure?
						50213, --21		Q39. In the last 6 months did you and this provider talk about how much of your personal health information you wanted shared with your family or friends?
						50214, --22		Q40. In the last 6 months did this provider respect your wishes about how much of your personal health information to share with your family or friends?
						50215, --23		Q41. Using any number from 0 to 10 where 0 is the worst provider possible and 10 is the best provider possible what number would you use to rate this provider?
						50216, --24		Q42. In the last 6 months how often were clerks and receptionists at this providers office as helpful as you thought they should be?
						50217  --25		Q43. In the last 6 months how often did clerks and receptionists at this providers office treat you with courtesy and respect?
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
	left join subtype st on stqm.subtype_id=st.subtype_id
	where stqm.SurveyType_id in (10,14)
	and stqm.isATA=1
	group by stqm.surveytype_id, st.subtype_nm

	--> new: 1.1
	-- for ACO questionnaire types
	update qf
	set ATAcnt=sub.cnt
		, ATAcomplete=case when sub.cnt >= (ata.totalATAcnt * 0.50) then 1 else 0 end
	from #ACOQF qf
	inner join @ATA ata on qf.subtype_nm=ata.SubType_nm
	inner join (SELECT st.subtype_nm,stqm.surveytype_id, qr.questionform_id, COUNT(distinct qr.QstnCore) as cnt
				FROM #QR qr
				inner join SurveyTypeQuestionMappings stqm on qr.QstnCore=stqm.QstnCore
				left join subtype st on stqm.subtype_id=st.subtype_id
				where qr.intResponseVal>=0
				and stqm.SurveyType_id in (10,14)
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
				inner join subtype st on stqm.subtype_id=st.subtype_id
				WHERE qr.intResponseVal >= 0
				and stqm.SurveyType_id in (10,14)
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