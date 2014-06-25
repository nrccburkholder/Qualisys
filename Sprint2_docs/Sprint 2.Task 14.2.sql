/*
Story 14: As an Authorized Vendor, we want to calculate if a returned survey is complete per the ICH-CAHPS definition, so that we 
can correctly report the final disposition
Task 14.2: Refactor the procedure in the Medusa etl that uses the function so the function can be dropped.
*/
use qp_prod
go
if exists (select * from sys.objects where name = 'ACOCAHPSCompleteness' and type='FN')
	exec sp_rename ACOCAHPSCompleteness, ACOCAHPSCompleteness_fn
go
if exists (select * from sys.objects where name = 'ACOCAHPSCompleteness' and type='P')
	drop procedure [dbo].[ACOCAHPSCompleteness] 
go
create procedure [dbo].[ACOCAHPSCompleteness] 
AS
BEGIN
	-- assumes an #ACOQF table already exists and has the following columns:
	-- questionform_id int
	-- ATAcnt tinyint
	-- ATAcomplete bit
	-- MeasureCnt tinyint
	-- MeasureComplete bit
	-- Disposition tinyint 
	

	create table #QR (Questionform_id int, qstncore int, intResponseVal int)
	insert into #QR (questionform_id, qstncore, intResponseVal)
			select qr.questionform_id, QstnCore,intResponseVal from QuestionResult qr, #ACOQF qf where qr.QuestionForm_id=qf.QuestionForm_id
			union all select qr.questionform_id, QstnCore,intResponseVal from QuestionResult2 qr, #ACOQF qf where qr.QuestionForm_id=qf.QuestionForm_id
	
	update #ACOQF set ATAcnt=0, ATAcomplete=0, MeasureCnt=0, MeasureComplete=0, Disposition=0

	update #ACOQF set disposition=255
	from #ACOQF qf
	left join #QR qr on qf.questionform_id=qr.questionform_id
	where qr.questionform_id is null
		
	-- if Q1 invokes the skip, ignore questions 5 through 43
	delete q2_43 
	from #QR q1
	inner join #QR q2_43 on q1.questionform_id=q2_43.questionform_id	
	where q1.qstncore=50175 and q1.intresponseval in (2,-5,-6,-8,-9)
	and q2_43.qstncore in (
						50176, --02		Q2. Is this the provider you usually see if you need a check-up want advice about a health problem or get sick or hurt?
						50177, --03		Q3. How long have you been going to this provider?
						50178, --04		Q4. In the last 6 months how many times did you visit this provider to get care for yourself? 
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
	where q4.qstncore=50178 and q4.intresponseval in (0,-5,-6,-8,-9)
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
	-- the flu shot questions are a series of three yes/no questions, but they only count as a single question for completeness.					
	update #QR set qstncore=50231 where qstncore in (50232,50233)
	
	-- the race question on the phone survey is a series of 16 yes/no questions, but they only count as a single question for completeness.					
	update #QR set qstncore=50725 where qstncore between 50726 and 50740
	
	update qf
	set ATAcnt=sub.cnt, ATAcomplete=case when sub.cnt >= (53 * 0.50) then 1 else 0 end
	from #ACOQF qf
	inner join (SELECT questionform_id, COUNT(distinct qstncore) as cnt
				FROM #QR 
				where intResponseVal>=0
				AND QstnCore IN (
					50175, --01	Q1. Our records show that you visited the provider named below in the last 6 months. Is that right?
					50176, --02		Q2. Is this the provider you usually see if you need a check-up want advice about a health problem or get sick or hurt?
					50177, --03		Q3. How long have you been going to this provider?
					50178, --04		Q4. In the last 6 months how many times did you visit this provider to get care for yourself? 
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
					50217, --25		Q43. In the last 6 months how often did clerks and receptionists at this providers office treat you with courtesy and respect?
					50218, --26		Q44. Specialists are doctors like surgeons heart doctors allergy doctors skin doctors and other doctors who specialize in one area of health care. Is the provider named in Question 1 of this Survey a specialist?
					50222, --27		Q48. Your health care team includes all the doctors nurses and other people you see for health care. In the last 6 months did you and anyone on your health care team talk about specific things you could do to prevent illness?
					50223, --28		Q49. In the last 6 months did you and anyone on your health care team talk about a healthy diet and healthy eating habits?
					50224, --29		Q50. In the last 6 months did you and anyone on your health care team talk about the exercise or physical activity you get?
					50225, --30		Q51. In the last 6 months did anyone on your health care team talk with you about specific goals for your health?
					50226, --31		Q52. In the last 6 months did you take any prescription medicine?
					50229, --32		Q55. In the last 6 months did anyone on your health care team ask you if there was a period of time when you felt sad empty or depressed?
					50230, --33		Q56. In the last 6 months did you and anyone on your health care team talk about things in your life that worry you or cause you stress?
					50231, --34		Q57A – 57C*. Since August 1 2013 did anyone on your health care team… -- these three questions are treated as a single question
					50234, --35		Q58. In general how would you rate your overall health?
					50235, --36		Q59. In general how would you rate your overall mental or emotional health?
					50236, --37		Q60. In the last 12 months have you seen a doctor or other health provider 3 or more times for the same condition or problem?
					50238, --38		Q62. Do you now need or take medicine prescribed by a doctor?
					50240, --39		Q64. During the last 4 weeks how much of the time did your physical health interfere with your social activities (like visiting with friends relatives etc.)?
					50241, --40		Q65. What is your age?
					50699, --41		Q66. Are you male or female?
					50243, --42		Q67. What is the highest grade or level of school that you have completed?
					50700, --43		Q68. How well do you speak English?
					50245, --44		Q69. Do you speak a language other than English at home?
					50247, --45		Q71. Are you deaf or do you have serious difficulty hearing?
					50248, --46		Q72. Are you blind or do you have serious difficulty seeing even when wearing glasses?
					50249, --47		Q73. Because of a physical mental or emotional condition do you have serious difficulty concentrating remembering or making decisions?
					50250, --48		Q74. Do you have serious difficulty walking or climbing stairs?
					50251, --49		Q75. Do you have difficulty dressing or bathing?
					50252, --50		Q76. Because of a physical mental or emotional condition do you have difficulty doing errands alone such as visiting a doctors office or shopping?
					50253, --51		Q77. Are you of Hispanic Latino or Spanish origin?
					50255, --52		Q79A – 79E4*. What is your race? (mail Survey)
					50725, --52		Q79A – 79E4*. What is your race? (phone Survey)	-- phone race question dealt with in the below IF EXISTS() query.
					50256  --53		Q80. Did someone help you complete this Survey?
					)
				group by questionform_id) sub
		on qf.questionform_id=sub.questionform_id

	update qf
	set MeasureCnt=sub.cnt, MeasureComplete=case when sub.cnt >= 1 then 1 else 0 end
	from #ACOQF qf
	inner join (SELECT questionform_id, COUNT(distinct qstncore) as cnt
				FROM #QR
				WHERE intResponseVal >= 0
				AND QstnCore IN (
					50180, -- Q6. In the last 6 months when you phoned this providers office to get an appointment for care you needed right away how often did you get an appointment as soon as you needed?
					50182, -- Q8. In the last 6 months when you made an appointment for a check-up or routine care with this provider how often did you get an appointment as soon as you needed?
					50184, -- Q10. In the last 6 months when you phoned this providers office during regular office hours how often did you get an answer to your medical question that same day?
					50186, -- Q12. In the last 6 months when you phoned this providers office after regular office hours how often did you get an answer to your medical question as soon as you needed?
					50189, -- Q15. Wait time includes time spent in the waiting room and exam room. In the last 6 months how often did you see this provider within 15 minutes of your appointment time?
					50190, -- Q16. In the last 6 months how often did this provider explain things in a way that was easy to understand?
					50191, -- Q17. In the last 6 months how often did this provider listen carefully to you?
					50193, -- Q19. In the last 6 months how often did this provider give you easy to understand information about these health questions or concerns?
					50194, -- Q20. In the last 6 months how often did this provider seem to know the important information about your medical history?
					50196, -- Q22. In the last 6 months how often did this provider show respect for what you had to say?
					50197, -- Q23. In the last 6 months how often did this provider spend enough time with you?
					50201, -- Q27. Did you and this provider talk about the reasons you might want to take a medicine?
					50202, -- Q28. Did you and this provider talk about the reasons you might not want to take a medicine?
					50203, -- Q29. When you and this provider talked about starting or stopping a prescription medicine did this provider ask what you thought was best for you?
					50210, -- Q36. Did you and this provider talk about the reasons you might want to have the surgery or procedure?
					50211, -- Q37. Did you and this provider talk about the reasons you might not want to have the surgery or procedure?
					50212, -- Q38. When you and this provider talked about having surgery or a procedure did this provider ask what you thought was best for you?
					50213, -- Q39. In the last 6 months did you and this provider talk about how much of your personal health information you wanted shared with your family or friends?
					50214, -- Q40. In the last 6 months did this provider respect your wishes about how much of your personal health information to share with your family or friends?
					50215, -- Q41. Using any number from 0 to 10 where 0 is the worst provider possible and 10 is the best provider possible what number would you use to rate this provider?
					50220, -- Q46. In the last 6 months how often was it easy to get appointments with specialists?
					50221, -- Q47. In the last 6 months how often did the specialist you saw most seem to know the important information about your medical history?
					50222, -- Q48. Your health care team includes all the doctors nurses and other people you see for health care. In the last 6 months did you and anyone on your health care team talk about specific things you could do to prevent illness?
					50223, -- Q49. In the last 6 months did you and anyone on your health care team talk about a healthy diet and healthy eating habits?
					50224, -- Q50. In the last 6 months did you and anyone on your health care team talk about the exercise or physical activity you get?
					50225, -- Q51. In the last 6 months did anyone on your health care team talk with you about specific goals for your health?
					50229, -- Q55. In the last 6 months did anyone on your health care team ask you if there was a period of time when you felt sad empty or depressed?
					50230, -- Q56. In the last 6 months did you and anyone on your health care team talk about things in your life that worry you or cause you stress?
					50234, -- Q58. In general how would you rate your overall health?
					50235, -- Q59. In general how would you rate your overall mental or emotional health?
					50237, -- Q61. Is this a condition or problem that has lasted for at least 3 months?
					50239, -- Q63. Is this medicine to treat a condition that has lasted for at least 3 months?
					50240, -- Q64. During the last 4 weeks how much of the time did your physical health interfere with your social activities (like visiting with friends relatives etc.)?
					50249, -- Q73. Because of a physical mental or emotional condition do you have serious difficulty concentrating remembering or making decisions?
					50250, -- Q74. Do you have serious difficulty walking or climbing stairs?
					50251, -- Q75. Do you have difficulty dressing or bathing?
					50252  -- Q76. Because of a physical mental or emotional condition do you have difficulty doing errands alone such as visiting a doctors office or shopping?
					)
				group by questionform_id) sub
		on qf.questionform_id=sub.questionform_id

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
-- Modified 7/28/04 SJS (skip pattern recode) 
-- Modified 11/2/05 BGD Removed skip pattern enforcement. Now in the SP_Extract_BubbleData procedure 
-- Modified 11/16/05 BGD Calculate completeness for HCAHPS Surveys 
-- Modified 2/22/06 BGD Also enforce skip if question is left blank or has an invalid response. 
-- Modified 3/7/06 BGD Calculate the number of days since first and current mailing. 
-- Modified 3/16/06 BGD Add 10000 to answers that should have been skipped instead of recoding to -7 
-- Modified 5/2/06 BGD Populating the strUnitSelectType column in the Extract_Web_QuestionForm table 
-- Modified 5/22/06 BGD Bring over the langid from SentMailing to populate Big_Table_XXXX_X.LangID 
-- Modified 8/31/07 SJS Changed "INSERT INTO Extract_Web_QuestionForm" to use datReturned rather than datResultsImported data. 
-- Modified 9/19/09 MWB Added initial HHCAHPS Logic 
-- added #b (HHCAHPS completeness check) and final Disposition logic. 
-- added ReceiptType_ID to Extract_Web_QuestionForm insert 
-- Modified 11/2/09 added extra skip logic for qstncore 38694. 
-- HHCAHPS guidelines require all questions to be 
-- skipped if 38694 is not answered as 1 
-- Modified 4/5/2010 MWB Added SurveyType 4 (MNCM) Disposition logic. 
-- added #c (completeness check) and MNCM completeness check. 
-- Modified 5/27/10 MWB changed Disposition table insert from convert 110 to 120 to add time. 
-- this will avoid PK errors in the extract 
-- Modified 11/30/12 DRM Added changes to properly evaluate nested skip questions. 
-- i.e. when a gateway question is a skip question for a previous gateway question. 
-- Modified 12/28/2012 MWB added a bunch of debug writes to drm_tracktimes around skip patten  
-- logic to help identify why Survey's are taking so long    
-- Modified 01/03/2013 DRH changed @work to #work plus index
-- Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question
-- Modified 05/13/2013 DBG - added Survey_id in the link between cmnt_QuestionResult_work and skipidentifier in four places
-- Modified 05/14/2013 DBG - modifications to account for overlapping skips
-- Modified 01/14/2014 DBG - added check for ACO CAHPS usable partials and ACOCahps completeness check 
-- Modified 02/27/2014 CB - added -5 and -6 as non-response codes. Phone surveys can code -5 as "Refused" and -6 as "Don't Know"
-- Modified 06/18/2014 DBG - refactored ACOCAHPSCompleteness as a procedure instead of a function.

alter PROCEDURE [dbo].[sp_phase3_questionresult_for_extract] 
AS 
    SET TRANSACTION isolation level READ uncommitted 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Begin SP_Phase3_QuestionResult_For_Extract' 

    --The Cmnt_QuestionResult_work table should be able to be removed.  
    TRUNCATE TABLE cmnt_QuestionResult_work 
    TRUNCATE TABLE extract_web_QuestionForm 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'H get hcahps records and index' 

    --Get the records that are HCAHPS so we can compute completeness  
    SELECT e.QuestionForm_id, CONVERT(INT, NULL) Complete 
    INTO   #a 
    FROM   QuestionForm_extract e, 
           QuestionForm qf, 
           Survey_def sd 
    WHERE  e.study_id IS NOT NULL 
           AND e.tiextracted = 0 
           AND datextracted_dt IS NULL 
           AND e.QuestionForm_id = qf.QuestionForm_id 
           AND qf.Survey_id = sd.Survey_id 
           AND Surveytype_id = 2 
    GROUP  BY e.QuestionForm_id 

    CREATE INDEX tmpindex ON #a (QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'H update tmp table with function call' 

    UPDATE #a 
	SET    complete = dbo.Hcahpscompleteness(QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'H update QuestionForm' 

    UPDATE qf 
    SET    bitComplete = Complete 
    FROM   QuestionForm qf, #a t 
    WHERE  t.QuestionForm_id = qf.QuestionForm_id 

    DROP TABLE #a 

    --END: Get the records that are HCAHPS so we can compute completeness  
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'HH get hcahps records and index' 

    --Get the records that are HHCAHPS so we can compute completeness  
    SELECT e.QuestionForm_id, CONVERT(INT, NULL) Complete 
    INTO   #b 
    FROM   QuestionForm_extract e, 
           QuestionForm qf, 
           Survey_def sd 
    WHERE  e.study_id IS NOT NULL 
           AND e.tiextracted = 0 
           AND datextracted_dt IS NULL 
           AND e.QuestionForm_id = qf.QuestionForm_id 
           AND qf.Survey_id = sd.Survey_id 
           AND Surveytype_id = 3 
    GROUP  BY e.QuestionForm_id 

    --*******************************************************************   
    --**  DRM 12/30/2012  Temp hack to allow hcahps only   
    --*******************************************************************   
    --delete #b   
    --*******************************************************************   
    --**  end hack   
    --*******************************************************************   
    CREATE INDEX tmpindex ON #b (QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'HH update tmp table with function call' 

    UPDATE #b 
	SET    complete = dbo.Hhcahpscompleteness(QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'HH update QuestionForm' 

    UPDATE qf 
    SET    bitComplete = Complete 
    FROM   QuestionForm qf, #b t 
    WHERE  t.QuestionForm_id = qf.QuestionForm_id 

    DROP TABLE #b 

    --END: Get the records that are HHCAHPS so we can compute completeness  
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'MNCM get hcahps records and index' 

    --Get the records that are MNCM so we can compute completeness  
    SELECT e.QuestionForm_id, CONVERT(INT, NULL) Complete 
    INTO   #c 
    FROM   QuestionForm_extract e, 
           QuestionForm qf, 
           Survey_def sd 
    WHERE  e.study_id IS NOT NULL 
           AND e.tiextracted = 0 
           AND datextracted_dt IS NULL 
           AND e.QuestionForm_id = qf.QuestionForm_id 
           AND qf.Survey_id = sd.Survey_id 
           AND Surveytype_id = 4 
    GROUP  BY e.QuestionForm_id 

    --*******************************************************************   
    --**  DRM 12/30/2012  Temp hack to allow hcahps only   
    --*******************************************************************   
    --delete #c   
    --*******************************************************************   
    --**  end hack   
    --*******************************************************************   
    CREATE INDEX tmpindex ON #c (QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'MNCM update tmp table with function call' 

    UPDATE #c 
	SET    complete = dbo.Mncmcompleteness(QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'MNCM update QuestionForm' 

    UPDATE qf 
    SET    bitComplete = Complete 
    FROM   QuestionForm qf, 
           #c t 
    WHERE  t.QuestionForm_id = qf.QuestionForm_id 

    DROP TABLE #c 

	-------------------------------------------------------------------
	-- ccaouette 2014/04: Commented out and moved to Catalyst ETL
	-------------------------------------------------------------------
    --END: Get the records that are MNCM so we can compute completeness  

 --   INSERT INTO drm_tracktimes 
 --   SELECT Getdate(), 'exec CheckForACOCAHPSUsablePartials' 

	--exec dbo.CheckForACOCAHPSUsablePartials

 --   INSERT INTO drm_tracktimes 
 --   SELECT Getdate(), 'exec CheckForACOCAHPSIncompletes' 

	--exec dbo.CheckForACOCAHPSIncompletes
 --   --END: Get the records that are ACO so we can compute completeness  

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'populate Cmnt_QuestionResult_Work' 

    INSERT INTO cmnt_QuestionResult_work 
                (QuestionForm_id, 
                 strlithocode, 
                 SamplePop_id, 
                 val, 
                 sampleunit_id, 
                 qstncore, 
                 datmailed, 
                 datimported, 
                 study_id, 
            datGenerated, 
                 qf.Survey_id, 
                 receipttype_id, 
                 Surveytype_id, 
                 bitcomplete) 
    SELECT qf.QuestionForm_id, 
           strlithocode, 
           qf.SamplePop_id, 
           intresponseval, 
           sampleunit_id, 
        qstncore, 
           datmailed, 
           datResultsImported, 
           qfe.study_id, 
           datGenerated, 
           qf.Survey_id, 
           Isnull(qf.receipttype_id, 17), 
           sd.Surveytype_id, 
           qf.bitcomplete 
    FROM   (SELECT DISTINCT QuestionForm_id, study_id 
            FROM   QuestionForm_extract 
            WHERE  study_id IS NOT NULL 
                   AND tiextracted = 0 
                   AND datextracted_dt IS NULL) qfe, 
           QuestionForm qf, 
           SentMailing sm, 
           QuestionResult qr, 
           Survey_def sd 
    WHERE  qfe.QuestionForm_id = qf.QuestionForm_id 
           AND qf.QuestionForm_id = qr.QuestionForm_id 
           AND qf.SentMail_id = sm.SentMail_id 
           AND qf.Survey_id = sd.Survey_id 

    --*******************************************************************   
    --**  DRM 12/30/2012  Temp hack to allow hcahps only   
    --*******************************************************************   
    --and sd.SurveyType_id=2   
    --*******************************************************************   
    --**  end hack   
    --*******************************************************************   
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'populate Extract_Web_QuestionForm' 

    --*******************************************************************   
    --**  DRM 12/30/2012  Temp hack to allow hcahps only   
    --*******************************************************************   
    INSERT INTO extract_web_QuestionForm 
                (study_id, 
                 Survey_id, 
                 QuestionForm_id, 
                 SamplePop_id, 
                 sampleunit_id, 
                 strlithocode, 
                 sampleset_id, 
                 datReturned, 
                 bitcomplete, 
                 strunitselecttype, 
                 langid, 
                 receipttype_id) 
    SELECT sp.study_id, 
           qf.Survey_id, 
           qf.QuestionForm_id, 
           qf.SamplePop_id, 
           sampleunit_id, 
           strlithocode, 
           sp.sampleset_id, 
           qf.datReturned, 
           qf.bitcomplete, 
           ss.strunitselecttype, 
           langid, 
           qf.receipttype_id 
    FROM   (SELECT DISTINCT QuestionForm_id, study_id 
            FROM   cmnt_QuestionResult_work) qfe, 
           QuestionForm qf, 
           SentMailing sm, 
           SamplePop sp, 
           selectedsample ss 
    WHERE  qfe.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = sm.SentMail_id 
           AND qf.SamplePop_id = sp.SamplePop_id 
           AND sp.sampleset_id = ss.sampleset_id 
           AND sp.pop_id = ss.pop_id 

    --INSERT INTO Extract_Web_QuestionForm (sp.Study_id, qf.Survey_ID, QuestionForm_id, SamplePop_id, SampleUnit_id,                   
    -- strLithoCode, Sampleset_id, datReturned, bitComplete, strUnitSelectType, LangID, receiptType_ID)                  
    --SELECT sp.Study_id, qf.Survey_ID, qf.QuestionForm_id, qf.SamplePop_id, SampleUnit_id, strLithoCode,                   
    -- sp.SampleSet_id, qf.datReturned, qf.bitComplete, ss.strUnitSelectType, LangID, qf.ReceiptType_id                
    --FROM (SELECT DISTINCT QuestionForm_id, Study_id                 
    --  FROM Cmnt_QuestionResult_work) qfe,                 
    -- QuestionForm qf, SentMailing sm, SamplePop sp, selectedSample ss                   
    --, Survey_def sd   
    --WHERE qfe.QuestionForm_id=qf.QuestionForm_id                    
    --AND qf.SentMail_id=sm.SentMail_id               
    --AND qf.SamplePop_id=sp.SamplePop_id                   
    --AND sp.Sampleset_id=ss.Sampleset_id                   
    --AND sp.Pop_id=ss.Pop_id              
    --and qf.Survey_id = sd.Survey_id      
    --and sd.Surveytype_id = 2   
    --*******************************************************************   
    --**  end hack   
    --*******************************************************************   
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Calc days from first mailing' 

    -- Add code to determine days from first mailing as well as days from current mailing until the return 
    -- Get all of the maildates for the SamplePops were are extracting  
    SELECT e.SamplePop_id, 
           strlithocode, 
           MailingStep_id, 
           CONVERT(DATETIME, CONVERT(VARCHAR(10), Isnull(datmailed, datprinted), 120 )) 
           datMailed 
    INTO   #mail 
    FROM   (SELECT SamplePop_id 
            FROM   extract_web_QuestionForm 
            GROUP  BY SamplePop_id) e, 
           ScheduledMailing schm, 
           SentMailing sm 
    WHERE  e.SamplePop_id = schm.SamplePop_id 
           AND schm.SentMail_id = sm.SentMail_id 

    CREATE INDEX tempindex ON #mail (SamplePop_id, strlithocode) 

    -- Update the work table with the actual number of days  
    UPDATE ewq 
    SET    DaysFromFirstMailing = Datediff(day, firstmail, datReturned), 
           DaysFromCurrentMailing = Datediff(day, c.datmailed, datReturned) 
    FROM   extract_web_QuestionForm ewq, 
           (SELECT SamplePop_id, Min(datmailed) FirstMail 
            FROM   #mail 
            GROUP  BY SamplePop_id) t, 
           #mail c 
    WHERE  ewq.SamplePop_id = t.SamplePop_id 
           AND ewq.SamplePop_id = c.SamplePop_id 
           AND ewq.strlithocode = c.strlithocode 

    -- Make sure there are no negative days.  
    UPDATE extract_web_QuestionForm 
    SET    daysfromfirstmailing = 0 
    WHERE  daysfromfirstmailing < 0 

    UPDATE extract_web_QuestionForm 
    SET    daysfromcurrentmailing = 0 
    WHERE  daysfromcurrentmailing < 0 

    DROP TABLE #mail 

    -- Modification 7/28/04 SJS -- Replaced code for skip pattern recode so that nested skip patterns are handled correctly 
	-- Modified 8/27/2013 CBC -- Removed explicit Primary Key constraint name 
    --SET NOCOUNT ON  
    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    --DECLARE @work TABLE (QuestionForm_id INT, SampleUnit_id INT, Skip_id INT, Survey_id INT)                
    --CREATE TABLE #work 
    --  (  workident       INT IDENTITY (1, 1) CONSTRAINT pk_work_workident_a PRIMARY KEY, 
    --     QuestionForm_id INT, 
    --     sampleunit_id   INT, 
    --     skip_id         INT, 
    --     Survey_id       INT 
    --  )
	 
	CREATE TABLE #work 
      (  workident       INT IDENTITY (1, 1) PRIMARY KEY, 
         QuestionForm_id INT, 
         sampleunit_id   INT, 
         skip_id         INT, 
         Survey_id       INT 
      ) 


    DECLARE @qf INT, @su INT, @sk INT, @svy INT, @bitUpdate BIT  

    SET @bitUpdate = 1 

    --Now to recode Skip pattern results  
    --If we have a valid answer, we will add 10000 to the responsevalue  
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Skip patterns' 

    -- Identify the first skip pattern that needs to be enforced for a QuestionForm_id  
    DECLARE @rowcount INT 

    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    --INSERT INTO @work (QuestionForm_id, SampleUnit_id, Skip_id, si.Survey_id)                 
    INSERT INTO #work (QuestionForm_id, sampleunit_id, skip_id, Survey_id) 
    SELECT QuestionForm_id, sampleunit_id, skip_id, si.Survey_id 
    FROM   cmnt_QuestionResult_work qr 
           INNER JOIN skipidentifier si  ON qr.Survey_id = si.Survey_id
                                           AND qr.datGenerated = si.datGenerated 
                                AND qr.qstncore = si.qstncore 
                                           AND qr.val = si.intresponseval 
           INNER JOIN Survey_def sd      ON si.Survey_id = sd.Survey_id 
    WHERE  sd.bitenforceskip <> 0 
    UNION 
    SELECT QuestionForm_id, sampleunit_id, skip_id, si.Survey_id 
    FROM   cmnt_QuestionResult_work qr 
           INNER JOIN skipidentifier si ON qr.Survey_id = si.Survey_id
                                           AND qr.datGenerated = si.datGenerated 
                                           AND qr.qstncore = si.qstncore 
                                           AND qr.val IN ( -8, -9, -6, -5 ) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
           INNER JOIN Survey_def sd     ON si.Survey_id = sd.Survey_id 
    WHERE  sd.bitenforceskip <> 0 
    UNION 
    SELECT QuestionForm_id, sampleunit_id, -1 Skip_id, q.Survey_id 
    FROM   cmnt_QuestionResult_work q, Survey_def sd 
    WHERE  qstncore = 38694 
           AND val <> 1 
           AND sd.Survey_id = q.Survey_id 
           AND sd.Surveytype_id = 3 
    UNION 
    SELECT QuestionForm_id, sampleunit_id, -2 Skip_id, q.Survey_id 
    FROM   cmnt_QuestionResult_work q, Survey_def sd 
    WHERE  qstncore = 38726 
           AND val <> 1 
           AND sd.Survey_id = q.Survey_id 
           AND sd.Surveytype_id = 3 
    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    ORDER  BY 1, 2, 3, 4 

    CREATE INDEX tmpwork_index ON #work (QuestionForm_id, sampleunit_id, skip_id, Survey_id) 

    SELECT @rowcount = @@rowcount 

    PRINT 'After insert into #work: ' + Cast(@rowcount AS VARCHAR) 

/*************************************************************************************************/
    --Assign Final Dispositions for HCAHPS and HHCAHPS  
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Final Dispositions' 

    --HCAHPS DispositionS  
    UPDATE cqw 
    SET    FinalDisposition = '01' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 2 
           AND bitcomplete = 1 

    UPDATE cqw 
    SET    FinalDisposition = '06' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 2 
           AND bitcomplete = 0 

    --HHCAHPS DispositionS  
    UPDATE cqw 
    SET    FinalDisposition = '110' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 3 
           AND bitcomplete = 1 
           AND ReceiptType_ID = 17 

    UPDATE cqw 
    SET    FinalDisposition = '120' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 3 
           AND bitcomplete = 1 
           AND ReceiptType_ID = 12 

    SELECT q.QuestionForm_id 
    INTO   #hhcahps_invalidDisposition 
    FROM   cmnt_QuestionResult_work q, 
           Survey_def sd 
    WHERE  qstncore = 38694 
           AND val <> 1 
           AND sd.Survey_id = q.Survey_id 
           AND sd.Surveytype_id = 3 
           AND bitcomplete = 0 

    UPDATE cqw 
    SET    FinalDisposition = '220' 
    FROM   cmnt_QuestionResult_work cqw, 
           #hhcahps_invalidDisposition i 
    WHERE  i.QuestionForm_id = cqw.QuestionForm_id 

    SELECT q.QuestionForm_id 
    INTO   #hhcahps_validDisposition 
    FROM   cmnt_QuestionResult_work q, 
           Survey_def sd 
    WHERE  qstncore = 38694 
           AND val = 1 
           AND sd.Survey_id = q.Survey_id 
           AND sd.Surveytype_id = 3 
           AND bitcomplete = 0 

    UPDATE cqw 
    SET    FinalDisposition = '310' 
    FROM   cmnt_QuestionResult_work cqw, 
           #hhcahps_validDisposition i 
    WHERE  i.QuestionForm_id = cqw.QuestionForm_id 

    --MNCM DispositionS  
    UPDATE cqw 
    SET    FinalDisposition = '21' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 4 
           AND bitcomplete = 0 
           AND ReceiptType_ID = 17 

    UPDATE cqw 
    SET    FinalDisposition = '22' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 4 
           AND bitcomplete = 0 
           AND ReceiptType_ID = 12 

    UPDATE cqw 
    SET    FinalDisposition = '11' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 4 
           AND bitcomplete = 1 
           AND ReceiptType_ID = 17 

    UPDATE cqw 
	SET    FinalDisposition = '12' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 4 
           AND bitcomplete = 1 
           AND ReceiptType_ID = 12 

    SELECT q.QuestionForm_id 
    INTO   #mncm_negrespscreenqstn 
    FROM   cmnt_QuestionResult_work q, 
           Survey_def sd 
    WHERE  qstncore = 39113 
           AND val <> 1 
           AND sd.Survey_id = q.Survey_id 
           AND sd.Surveytype_id = 4 
           AND bitcomplete = 0 

    UPDATE cqw 
    SET    FinalDisposition = '38' 
    FROM   cmnt_QuestionResult_work cqw, 
    #mncm_negrespscreenqstn i 
    WHERE  i.QuestionForm_id = cqw.QuestionForm_id 

    --ACO CAHPS Dispositions
    select cqw.questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasureComplete, 0 as Disposition
    into #ACOQF
    FROM   cmnt_QuestionResult_work cqw 
    inner join Surveytype st on cqw.Surveytype_id=st.Surveytype_id
    WHERE  st.SurveyType_dsc = 'ACOCAHPS'
    
    exec dbo.ACOCAHPSCompleteness
        
    UPDATE cqw 
    SET    FinalDisposition = qf.Disposition
    FROM   cmnt_QuestionResult_work cqw 
    inner join #ACOQF qf on cqw.questionform_id=qf.questionform_id
    WHERE  qf.disposition <> 255

	drop table #ACOQF

/*************************************************************************************************/
    /************************************************************************************************/
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Find ineligible hcahps' 

    --round up all the HHCHAPS Surveys that were not eligible (qstncore 38694 <> 1) and set an inelig. Disposition. 
    DECLARE @InEligDispo INT, @SQL VARCHAR(8000) 

    SELECT @InEligDispo = d.Disposition_id 
    FROM   Disposition d, 
           hhcahpsDispositions hd 
    WHERE  d.Disposition_id = hd.Disposition_id 
           AND hd.hhcahpsvalue = '220' 

    --SELECT q.QuestionForm_id  
    --into #updateDisposition  
    --FROM Cmnt_QuestionResult_Work q, Survey_DEF sd  
    --WHERE qstncore = 38694 AND val <> 1 AND sd.Survey_ID = q.Survey_id AND sd.SurveyType_id = 3  
    CREATE TABLE #updatedispsql (a INT IDENTITY (1, 1), strsql VARCHAR(8000))  

    --HCHAPS  
    INSERT INTO #updatedispsql 
    SELECT DISTINCT 'Exec QCL_LogDisposition ' 
                    + Cast(scm.SentMail_id AS VARCHAR(100)) + ', ' 
                    + Cast(scm.SamplePop_id AS VARCHAR(100)) + ', ' 
                    + Cast(dv.Disposition_id AS VARCHAR(100)) + ', ' 
                    + Cast(qf.receipttype_id AS VARCHAR(100)) + ', ' 
                    + '''#nrcsql''' + ', ' 
                    + '''' + CONVERT(VARCHAR, Getdate(), 120) + '''' AS strSQL 
    FROM   cmnt_QuestionResult_work cqw, 
           QuestionForm qf, 
           ScheduledMailing scm, 
           Dispositions_view dv 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.hcahpsvalue = cqw.finalDisposition 
           AND cqw.Surveytype_id = 2 

    --HHCAHPS  
    INSERT INTO #updatedispsql 
                (strsql) 
    SELECT DISTINCT 'Exec QCL_LogDisposition ' 
                    + Cast(scm.SentMail_id AS VARCHAR(100)) + ', ' 
                    + Cast(scm.SamplePop_id AS VARCHAR(100)) + ', ' 
                    + Cast(dv.Disposition_id AS VARCHAR(100)) + ', ' 
                    + Cast(qf.receipttype_id AS VARCHAR(100)) + ', ' 
                    + '''#nrcsql''' + ', ' 
                    + '''' + CONVERT(VARCHAR, Getdate(), 120) + '''' AS strSQL 
    FROM   cmnt_QuestionResult_work cqw, 
           QuestionForm qf, 
           ScheduledMailing scm, 
           Dispositions_view dv 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.hhcahpsvalue = cqw.finalDisposition 
      AND cqw.Surveytype_id = 3 

    --MNCM  
    INSERT INTO #updatedispsql (strsql) 
    SELECT DISTINCT 'Exec QCL_LogDisposition ' 
                    + Cast(scm.SentMail_id AS VARCHAR(100)) + ', ' 
                    + Cast(scm.SamplePop_id AS VARCHAR(100)) + ', ' 
                    + Cast(dv.Disposition_id AS VARCHAR(100)) + ', ' 
                    + Cast(qf.receipttype_id AS VARCHAR(100)) + ', ' 
                    + '''#nrcsql''' + ', ' 
                    + '''' + CONVERT(VARCHAR, Getdate(), 120) + '''' AS strSQL 
    FROM   cmnt_QuestionResult_work cqw, 
           QuestionForm qf, 
           ScheduledMailing scm, 
           Dispositions_view dv 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.mncmvalue = cqw.finalDisposition 
           AND cqw.Surveytype_id = 4 

    --ACO
    INSERT INTO #updatedispsql (strsql) 
    SELECT DISTINCT 'Exec QCL_LogDisposition ' 
                    + Cast(scm.SentMail_id AS VARCHAR(100)) + ', ' 
                    + Cast(scm.SamplePop_id AS VARCHAR(100)) + ', ' 
                    + Cast(dv.Disposition_id AS VARCHAR(100)) + ', ' 
                    + Cast(qf.receipttype_id AS VARCHAR(100)) + ', ' 
                    + '''#nrcsql''' + ', ' 
                    + '''' + CONVERT(VARCHAR, Getdate(), 120) + '''' AS strSQL 
    FROM   cmnt_QuestionResult_work cqw, 
           QuestionForm qf, 
           ScheduledMailing scm, 
           Dispositions_view dv 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.acocahpsvalue = cqw.finalDisposition 
           AND cqw.Surveytype_id = 10

    WHILE (SELECT Count(*) FROM #updatedispsql) > 0 
BEGIN 
          SELECT TOP 1 @SQL = strsql FROM #updatedispsql 
          EXEC (@SQL) 

          DELETE FROM #updatedispsql WHERE strsql = @SQL 
      END 

    /************************************************************************************************/
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Update skip questions' 

    DECLARE @loopcnt INT 
    SET @loopcnt = 0 

    --Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
    DECLARE @invskipcnt INT 
    SET @invskipcnt = 0 

    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    SELECT TOP 1 @qf = QuestionForm_id, 
                 @su = sampleunit_id, 
                 @sk = skip_id, 
                 @svy = Survey_id 
    --FROM @WORK              
    FROM   #work 
    ORDER  BY QuestionForm_id, 
              sampleunit_id, 
              skip_id 

    -- Update skipped qstncores while we have work to process  
    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    --WHILE (SELECT COUNT(*) FROM @work) > 0                 
    WHILE (SELECT Count(*) FROM #work) > 0 
      BEGIN 
          SET @loopcnt = @loopcnt + 1 

          --print 'QuestionForm_ID = ' + cast(@qf as varchar(10))  
          --print 'Sampleunit_ID = ' + cast(@su as varchar(10))  
          --print '@skip = ' + cast(@sk as varchar(10))  
          --print '@svy = ' + cast(@svy as varchar(10))  
          --print '@bitUpdate = ' + cast(@bitUpdate as varchar(10))  
          --SkipPatternWork:  
          IF @bitUpdate = 1 
            BEGIN 
                --print 'standard skip update'  
                UPDATE qr 
                -- SET Val=-7  
                SET    Val = VAL + 10000 
                FROM   cmnt_QuestionResult_work qr, 
                       skipqstns sq 
                WHERE  @qf = qr.QuestionForm_id 
                       AND @su = qr.sampleunit_id 
                       AND @sk = Skip_id 
                       AND sq.qstncore = qr.qstncore 
                       --dbg 5/14/13--AND Val NOT IN (-9,-8,-6,-5)  --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                       AND Val < 9000 

                IF @loopcnt < 25 
                  BEGIN 
                      INSERT INTO drm_tracktimes 
                      SELECT Getdate(), 'Start HHCAHPS qstncore 38694 skip update' 
                  END 

                --print 'HHCAHPS qstncore 38694 skip update'  
                UPDATE qr 
                -- SET Val=-7  
                SET    Val = VAL + 10000 
                FROM   cmnt_QuestionResult_work qr, 
                       Survey_def sd, 
                       (SELECT DISTINCT qstncore 
                        FROM   sel_qstns 
                        WHERE  Survey_id = @svy 
                               AND qstncore <> 38694 
                               AND nummarkcount > 0) a 
                WHERE  @qf = qr.QuestionForm_id 
                       AND @su = qr.sampleunit_id 
                       AND @sk = -1 
                       AND a.qstncore = qr.qstncore 
                       AND sd.Survey_id = @svy 
                       --dbg 5/14/13--AND Val NOT IN (-9,-8,-6,-5)  --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                       AND Val < 9000 
                       AND sd.Surveytype_id = 3 

                IF @loopcnt < 25 
                  BEGIN 
                      INSERT INTO drm_tracktimes 
                      SELECT Getdate(), 'End HHCAHPS qstncore 38694 skip update' 
                  END 

                IF @loopcnt < 25 
                  BEGIN 
                      INSERT INTO drm_tracktimes 
      SELECT Getdate(), 'Start HHCAHPS qstncore 38726 skip update' 
                  END 

                --print 'HHCAHPS qstncore 38726 skip update'  
                UPDATE qr 
                -- SET Val=-7  
                SET    Val = VAL + 10000 
          FROM   cmnt_QuestionResult_work qr, 
                       Survey_def sd 
                WHERE  @qf = qr.QuestionForm_id 
                       AND @su = qr.sampleunit_id 
                       AND @sk = -2 
                       AND qr.qstncore = 38727 
                       AND sd.Survey_id = @svy 
                       --dbg 5/14/13--AND Val NOT IN (-9,-8,-6,-5)  --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                       AND Val < 9000 
                       AND sd.Surveytype_id = 3 

                IF @loopcnt < 25 
                  BEGIN 
                      INSERT INTO drm_tracktimes 
                      SELECT Getdate(), 'End HHCAHPS qstncore 38726 skip update' 
                  END 
            END 

          -- Identify the NEXT skip pattern that needs to be enforced for a QuestionForm_id  
          -- Modified 01/03/2013 DRH changed @work to #work plus index 
          --DELETE FROM @work WHERE @qf=QuestionForm_id AND  @su=SampleUnit_id AND  @sk=Skip_id AND  @svy=Survey_id    
          DELETE FROM #work 
          WHERE  @qf = QuestionForm_id 
                 AND @su = sampleunit_id 
                 AND @sk = skip_id 
                 AND @svy = Survey_id 

          --SELECT TOP 1 @qf=QuestionForm_id, @su=SampleUnit_id, @sk=Skip_id, @svy=Survey_id  FROM @WORK ORDER BY QuestionForm_id, sampleunit_id, skip_id     
          SELECT TOP 1 @qf = QuestionForm_id, 
                       @su = sampleunit_id, 
                       @sk = skip_id, 
                       @svy = Survey_id 
          FROM   #work 
          ORDER  BY QuestionForm_id, 
                    sampleunit_id, 
                    skip_id 

          IF @loopcnt < 25 
            BEGIN 
                INSERT INTO drm_tracktimes 
                SELECT Getdate(), 'Start Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop'
            END 

          --Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
          SELECT @invskipcnt = Count(*) 
          FROM   cmnt_QuestionResult_work qr 
                 INNER JOIN skipidentifier si  ON qr.Survey_id = si.Survey_id
                                                  AND qr.datGenerated = si.datGenerated 
                                                  AND qr.qstncore = si.qstncore 
                                                  AND ( qr.val = si.intresponseval OR qr.val IN ( -8, -9, -6, -5 ) ) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                 INNER JOIN Survey_def sd      ON si.Survey_id = sd.Survey_id 
                 INNER JOIN skipqstns sq       ON si.skip_id = sq.skip_id 
                 INNER JOIN skipidentifier si2 ON sq.qstncore = si2.qstncore 
                                                  AND si2.skip_id = @sk 
          WHERE  sd.bitenforceskip <> 0 
                 AND qr.QuestionForm_id = @qf 

          -- Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop 
          IF (SELECT Count(*) 
              FROM   cmnt_QuestionResult_work qr 
                     INNER JOIN skipidentifier si ON qr.QuestionForm_id = @qf 
                                                     AND qr.sampleunit_id = @su  
                                                     AND qr.Survey_id = si.Survey_id
                                                     AND qr.datGenerated = si.datGenerated 
                                                     AND qr.qstncore = si.qstncore 
                                                     AND ( qr.val = si.intresponseval OR qr.val IN ( -8, -9, -6, -5 ) ) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                                     AND si.skip_id = @sk 
                                                     --Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
                                                     AND @invskipcnt = 0 
             -- 11/30/12 DRM -- Nested skip questions  
             -- If any previous gateway questions include the current gateway as a skip question,  
             --  and if the previous gateway was answered so as to skip the current gateway,  
             -- then don't enforce skip logic on the current gateway question.  
             --select count(*)  
             --FROM Cmnt_QuestionResult_Work qr  
             --INNER JOIN SkipIdentifier si ON qr.datGenerated=si.datGenerated AND qr.QstnCore=si.QstnCore AND (qr.Val=si.intResponseVal OR qr.Val IN (-8,-9,-6,-5)) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
             --INNER JOIN Survey_def sd ON si.Survey_id = sd.Survey_id  
             --inner join SkipQstns sq on si.Skip_id = sq.Skip_id  
             --inner join skipidentifier si2 on sq.QstnCore = si2.QstnCore and si2.Skip_id = @sk  
             --WHERE sd.bitEnforceSkip <> 0  
             --and qr.QuestionForm_id = @qf  
             ) > 0 
              OR (SELECT count(*)
                  FROM   cmnt_QuestionResult_work qr, 
                         Survey_def sd 
                  WHERE  qr.QuestionForm_id = @qf 
                         AND qr.sampleunit_id = @su 
                         AND qstncore = 38694 
                         AND val <> 1 
                         AND @sk = -1 
                         AND sd.Survey_id = qr.Survey_id 
                         AND sd.Surveytype_id = 3) > 0 
              OR (SELECT count(*)
                  FROM   cmnt_QuestionResult_work qr, 
                         Survey_def sd 
                  WHERE  qr.QuestionForm_id = @qf 
                         AND qr.sampleunit_id = @su 
                         AND qstncore = 38726 
     AND val <> 1 
                         AND @sk = -2 
                         AND sd.Survey_id = qr.Survey_id 
                         AND sd.Surveytype_id = 3) > 0 
            SET @bitUpdate = 1 
          ELSE 
            SET @bitUpdate = 0 

          IF @loopcnt < 25 
            BEGIN 
                INSERT INTO drm_tracktimes 
                SELECT Getdate(), 'End Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop'
            END 
      END 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'End SP_Phase3_QuestionResult_For_Extract' 

    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    DROP TABLE #work 

	--dbg 5/14/13-- -8's and -9's are now being offset, but we don't really want them to be. So we're now offsetting them back.
    UPDATE cmnt_QuestionResult_work 
    SET    val = val - 10000 
    WHERE  val IN ( 9991, 9992, 9995, 9994 ) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know

    SET nocount OFF 
    SET TRANSACTION isolation level READ committed
go
alter procedure [dbo].[CheckForACOCAHPSUsablePartials]
as
-- created 1/30/2014 DBG
-- After ACO CAHPS Surveys expire, we want to see if there were any blank/incomplete or partial returns that we initially ignored.
-- If so, and no other MailingSteps resulted in a complete Survey, we want to go ahead and use the blank/incomplete or partial return

-- list of all the returned QuestionForm records for SamplePop's that have at least one blank/incomplete or partial return (unusedreturn_id=5)
-- and the sampleset has expired.

-- Modified 06/18/2014 DBG - refactored ACOCAHPSCompleteness as a procedure instead of a function.

select qf.SamplePop_id, qf.QuestionForm_id, qf.unusedreturn_id, qf.datUnusedReturn, convert(bit,NULL) as bitUse, 0 as ACODisposition
into #partials
from QuestionForm qf
inner join SentMailing sm on qf.SentMail_id=sm.SentMail_id
where qf.SamplePop_id in (select SamplePop_id from QuestionForm where unusedreturn_id=5)
and (qf.datReturned is not null or unusedreturn_id=5)
and isnull(sm.datexpire,getdate())<getdate()

if @@rowcount=0
	RETURN
	
-- if there's any other MailingStep with unusedreturn_id<>5, we're not going to use the blank/incomplete or partial
update #partials
set bitUse=0
where SamplePop_id in (	select SamplePop_id
						from #partials
						group by SamplePop_id
						having count(distinct isnull(unusedreturn_id,0)) > 1)

select questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasureComplete, 0 as Disposition
into #ACOQF
from #partials
where unusedreturn_id=5
and bitUse is null

exec dbo.ACOCAHPSCompleteness

update p
set ACODisposition=qf.Disposition
from #partials p
inner join #ACOQF qf on p.questionform_id=qf.questionform_id
-- ACO Disposition 10 = complete
-- ACO Disposition 31 = partial
-- ACO Disposition 34 = blank/incomplete


-- If all of the MailingSteps are blank/incomplete or partial, use the partial that was returned first. 
update p
set bitUse=1
from #partials p
inner join (select SamplePop_id, ACODisposition, min(datUnusedReturn) as firstreturned
			from #partials
			where SamplePop_id in (	select SamplePop_id
									from #partials
									group by SamplePop_id
									having count(distinct isnull(unusedreturn_id,0)) = 1)
			and ACODisposition=31
			group by SamplePop_id, ACODisposition) fr
		on p.SamplePop_id=fr.SamplePop_id and p.ACODisposition=fr.ACODisposition and p.datUnusedReturn=fr.firstreturned
where p.unusedreturn_id=5
and p.bitUse is null

-- and don't use anything else
update p
set bitUse=0
from #partials p
inner join (select SamplePop_id
			from #partials p
			where acoDisposition=31 
			and bitUse=1) U
	on p.SamplePop_id=u.SamplePop_id
where p.unusedreturn_id=5
and p.bitUse is null

-- If they were all blank/incomplete, use the blank/incomplete that was returned first.
update p
set bitUse=1
from #partials p
inner join (select SamplePop_id, ACODisposition, min(datUnusedReturn) as firstreturned
			from #partials
			where SamplePop_id in (	select SamplePop_id
									from #partials
									group by SamplePop_id
									having count(distinct isnull(unusedreturn_id,0)) = 1)
			and ACODisposition=34
			group by SamplePop_id, ACODisposition) fr
		on p.SamplePop_id=fr.SamplePop_id and p.ACODisposition=fr.ACODisposition and p.datUnusedReturn=fr.firstreturned
where p.unusedreturn_id=5
and p.bitUse is null

-- and don't use anything else
update p
set bitUse=0
from #partials p
inner join (select SamplePop_id
			from #partials p
			where bitUse=1) U
	on p.SamplePop_id=u.SamplePop_id
where p.unusedreturn_id=5
and p.bitUse is null

-- update unusedreturn_id=6 for those blank/incomplete or partials that we're not going to use
update qf
set unusedreturn_id=6
from QuestionForm qf
inner join #partials p on qf.QuestionForm_id=p.QuestionForm_id
where p.unusedreturn_id=5
and p.bitUse=0

-- update datReturned, datResultsImported, datUnusedReturn and UnusedReturn_id for those blank/incomplete or partials that we are going to use
update qf
set datReturned=qf.datUnusedReturn, datResultsImported=qf.datUnusedReturn, datUnusedReturn=NULL, UnusedReturn_id=0
from QuestionForm qf
inner join #partials p on qf.QuestionForm_id=p.QuestionForm_id
where p.unusedreturn_id=5
and p.bitUse=1

-- move the results for blank/incomplete or partials we've decided to use into QuestionResult
insert into QuestionResult (QuestionForm_ID,SampleUnit_ID,QstnCore,intResponseVal)
select qr2.QuestionForm_ID,qr2.SampleUnit_ID,qr2.QstnCore,qr2.intResponseVal
from QuestionResult2 qr2
inner join #partials p on qr2.QuestionForm_id=p.QuestionForm_id
where p.unusedreturn_id=5
and p.bitUse=1

delete qr2
from QuestionResult2 qr2
inner join #partials p on qr2.QuestionForm_id=p.QuestionForm_id
where p.unusedreturn_id=5
and p.bitUse=1

-- put the blank/incomplete or partials we've decided to use into the ETL queue
-- This is not really needed, since a trigger on QuestionForm will populate the QuestionForm_Extract table.
--insert into QuestionForm_extract (QuestionForm_id)
--select p.QuestionForm_id
--from #partials p
--where p.unusedreturn_id=5
--and p.bitUse=1

drop table #partials
go
ALTER PROCEDURE [dbo].[CheckForACOCAHPSIncompletes]
AS
-- =============================================
-- Author:	Dave Gilsdorf
-- Procedure Name: CheckForACOCAHPSIncompletes
-- Create date: 1/2014 
-- Description:	Stored Procedure that extracts question form data from QP_Prod
-- History: 1.0  1/2014  by Dave Gilsdorf
--			1.1  5/27/2014 by C Caouette: Integrate logic into Catalyst ETL.
--          1.2  6/18/2014 by D Gilsdorf: Refactored ACOCAHPSCompleteness as a procedure instead of a function.
-- =============================================


/* PART 1 -- find people who are going through the ETL tonight and check their completeness. If their survey was partial or incomplete, reschedule their next mailstep. */

DECLARE @MinDate DATE;
SET @MinDate = DATEADD(DAY, -2, GETDATE());


-- v1.1  5/27/2014 by C Caouette
WITH CTE_Returns AS
(
	SELECT DISTINCT PKey1 
	FROM NRC_DataMart_ETL.dbo.ExtractQueue eq
	WHERE eq.ExtractFileID IS NULL AND eq.EntityTypeID = 11 AND eq.Created > @MinDate
)

--SELECT * FROM CTE_Returns
-- list of everybody who returned an ACOCAHPS Survey today
select qf.datReturned, qf.datResultsImported, sd.Survey_id, st.Surveytype_id, st.Surveytype_dsc, ms.intSequence
, scm.*, qf.QuestionForm_id, sm.datExpire, convert(tinyint,null) as ACODisposition, convert(varchar(15),'') as DispositionAction
into #TodaysReturns
from CTE_Returns eq
inner join QuestionForm qf on qf.QuestionForm_id=eq.PKey1 
inner join SentMailing sm on qf.SentMail_id=sm.SentMail_id
inner join ScheduledMailing scm on sm.ScheduledMailing_id=scm.ScheduledMailing_id
inner join Survey_def sd on qf.Survey_id=sd.Survey_id
inner join SurveyType st on sd.Surveytype_id=st.Surveytype_id
inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
where qf.datResultsImported is not null
and st.Surveytype_dsc='ACOCAHPS'
and sm.datExpire > getdate()
order by qf.datResultsImported desc

select questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasureComplete, 0 as Disposition
into #ACOQF
from #TodaysReturns

exec dbo.ACOCAHPSCompleteness

update tr
set ACODisposition=qf.disposition
from #TodaysReturns tr
inner join #ACOQF qf on tr.questionform_id=qf.questionform_id

--select * from #todaysreturns
-- ACO Disposition 10 = complete
-- ACO Disposition 31 = partial
-- ACO Disposition 34 = blank/incomplete

-- for complete survyes, set QuestionForm.bitComplete=1
update qf 
set bitComplete = 1
from #TodaysReturns tr
inner join QuestionForm qf on qf.QuestionForm_id=tr.QuestionForm_id
where ACODisposition = 10 

-- for blank/incomplete or partial Surveys, set bitComplete=0, move datReturned to datUnusedReturn, blank out datResultsImported,
-- and set UnusedReturn_id=5, which means a partial return that isn't used for now (it might be used later if it ends up being the only return we ever get)
-- fyi: UnusedReturn_id=6 means a partial return whose fate we have decided (either we ignored it because a better return came in or we used it because it's the best we got.)
update qf 
set bitComplete = 0, datReturned=null, UnusedReturn_id=5, datUnusedReturn=qf.datReturned, datResultsImported = NULL
from #TodaysReturns tr
inner join QuestionForm qf on qf.QuestionForm_id=tr.QuestionForm_id
where ACODisposition <> 10 

-- move blank/incomplete and partial results into QuestionResult2
insert into QuestionResult2 (QuestionForm_ID,SampleUnit_ID,QstnCore,intResponseVal)
select qr.QuestionForm_ID,qr.SampleUnit_ID,qr.QstnCore,qr.intResponseVal
from QuestionResult qr
inner join #TodaysReturns tr on qr.QuestionForm_id=tr.QuestionForm_id
where ACODisposition <> 10 

-- delete blank/incomplete and partial results from QuestionResult
delete qr
from QuestionResult qr
inner join #TodaysReturns tr on qr.QuestionForm_id=tr.QuestionForm_id
where ACODisposition <> 10 

-- remove blank/incomplete and partial Surveys from the ETL queue
delete qre
from QuestionForm_extract qre
inner join #TodaysReturns tr on qre.QuestionForm_id=tr.QuestionForm_id
where ACODisposition <> 10 

/* ----------------------------------------------------------------------------------------
--	v1.1  5/2014 by C Caouette:	Modified to logically remove partial and incomplete questionforms from
								the Catalyst ExtractQueue table. 
 ---------------------------------------------------------------------------------------- */
--UPDATE eq
--SET ExtractFileID = -1
----DELETE eq
----SELECT *
--FROM NRC_DataMart_ETL.dbo.ExtractQueue eq
--	INNER JOIN #TodaysReturns tr ON eq.PKey1=tr.QuestionForm_id AND eq.EntityTypeID = 11 AND eq.ExtractFileID IS NULL
--WHERE ACODisposition <> 10 

/*
select unusedreturn_ID,count(*)
FROM QuestionForm
group by unusedreturn_ID

unusedreturn_ID	(No column name)
NULL			1200636
0				119186736
1				310857		Another Mailstep already returned
2				464039		Expired
3				141751		This barcode previously scanned
4				16307		Results already in QuestionResults2
88				1457
*/


delete from #TodaysReturns where ACODisposition = 10 

-- remove anybody who has one of the following Dispositions
delete tr
from #TodaysReturns tr
inner join DispositionLog dl on tr.SamplePop_id=dl.SamplePop_id
inner join Disposition d on dl.Disposition_id=d.Disposition_id
where dl.Disposition_id in (
		  2 --	I do not wish to participate in this Survey
		, 3 --	The intended respondent has passed on
		, 4 --	The intended respondent is incapacitated and cannot participate in this Survey
		, 8 --	The Survey is not applicable to me
		,10--	Language Barrier
		,24 --	The intended respondent is institutionalized
		)

-- identify respondents who have Methodology-specific Dispositions
update tr set DispositionAction='No Mail '
from #TodaysReturns tr
inner join DispositionLog dl on tr.SamplePop_id=dl.SamplePop_id
inner join Disposition d on dl.Disposition_id=d.Disposition_id
where dl.Disposition_id=5 --	The intended respondent is not at this address

update tr set DispositionAction=DispositionAction+'No Phone'
from #TodaysReturns tr
inner join DispositionLog dl on tr.SamplePop_id=dl.SamplePop_id
inner join Disposition d on dl.Disposition_id=d.Disposition_id
where dl.Disposition_id in ( 14 --	The intended respondent is not at this phone
							,16 --	Bad/Missing/Wrong phone number
							)

-- grab mailing step info 
select distinct mm.Methodology_id, ms.intSequence, ms.MailingStep_id, ms.intIntervalDays, msm.MailingStepMethod_nm
into #ms
from mailingMethodology mm
inner join MailingStep ms on mm.Methodology_id=ms.Methodology_id
inner join MailingStepMethod msm on ms.MailingStepMethod_id=msm.MailingStepMethod_id
inner join #TodaysReturns tr on mm.Methodology_id=tr.Methodology_id
order by 1,2

declare @maxint int
set @maxint = 2147483647
insert into #ms 
select Methodology_id, max(intSequence)+1,@maxint,-1,'<no next step>'
from #ms 
group by Methodology_id

-- delete from #TodaysReturns where the next mailing has already been generated.
while @@rowcount>0
	update tr
	set intSequence=ms.intSequence
		, MailingStep_id=ms.MailingStep_id
		,ScheduledMailing_id=scm.ScheduledMailing_id
		,SentMail_id=scm.SentMail_id
		,datGenerate=scm.datGenerate
		,QuestionForm_id=0
	from #TodaysReturns tr
	inner join ScheduledMailing scm on tr.SamplePop_id=scm.SamplePop_id
	inner join MailingStep ms on scm.MailingStep_id=ms.MailingStep_id
	where tr.intSequence+1 = ms.intSequence

delete from #TodaysReturns where MailingStep_id=@maxint

-- list of ScheduledMailing records that need to be re-created
select ms.MailingStep_id, tr.SamplePop_id, null as OverrideItem_id, NULL as SentMail_id, tr.Methodology_id, convert(datetime,null) as datGenerate, ms.intSequence, ms.intIntervalDays, tr.DispositionAction
--, tr.*, ms.intSequence, ms.STRMailingStep_NM
into #NewScheduledMailing 
from #TodaysReturns tr
inner join #ms ms on tr.Methodology_id=ms.Methodology_id and tr.intSequence=ms.intSequence-1
where ms.Mailingstep_id <> @maxint
order by tr.SamplePop_id, ms.intSequence

-- remove respondents with Methodology-specific Dispositions
delete nsm
from #NewScheduledMailing nsm
inner join #ms ms on nsm.MailingStep_id=ms.MailingStep_id
where nsm.DispositionAction like '%No Mail%'
and ms.MailingStepMethod_nm='Mail'

delete nsm
from #NewScheduledMailing nsm
inner join #ms ms on nsm.MailingStep_id=ms.MailingStep_id
where nsm.DispositionAction like '%No Phone%'
and ms.MailingStepMethod_nm='Phone'

update nsm set datGenerate=dateadd(day,nsm.intIntervalDays,convert(datetime,floor(convert(float,sm.datMailed))))
--select scm.*, ms.*, sm.datMailed, nsm.intIntervalDays, dateadd(day,nsm.intIntervalDays,sm.datMailed)
from #NewScheduledMailing nsm
inner join ScheduledMailing scm on nsm.SamplePop_id=scm.SamplePop_id 
inner join #ms ms on scm.MailingStep_id=ms.MailingStep_id
inner join SentMailing sm on scm.SentMail_id=sm.SentMail_id
where ms.intSequence=nsm.intSequence-1

-- if the previous MailingStep hasn't mailed yet, the next mailing step will be scheduled when it mails, so we don't have to do anything
delete #NewScheduledMailing where datGenerate is NULL 

-- anything that should have already generated, generate it tonight.
-- it should be within the last few days? should we check that it's not older than that?
update #NewScheduledMailing 
set datGenerate = convert(datetime,ceiling(convert(float,getdate()))) 
where datGenerate<getdate()

insert into ScheduledMailing (OverrideItem_id, Methodology_ID, MailingStep_ID, SamplePop_ID, SentMail_ID, datGenerate)
select OverrideItem_id, Methodology_ID, MailingStep_ID, SamplePop_ID, SentMail_ID, datGenerate
from #NewScheduledMailing

drop table #NewScheduledMailing
drop table #ms
drop table #TodaysReturns



/* PART 2  Now we want to look at the sampleset/mailing steps that are being generated tonight, and check to see if there 
   is anyone in the sampleset who should be getting generated tonight, but isn't in ScheduledMailing for whatever reason
   (e.g. they had a bad address disposition, but we're generating a phone step. Or their litho got reset but never rescanned.
     or who knows?)
*/

if object_id('tempdb..#ACOMailingSteps') is not null
	drop table #ACOMailingSteps

if object_id('tempdb..#ACOEverybody') is not null
	drop table #ACOEverybody

-- list of acocahps steps that are getting generated today
SELECT SD.Study_id, SD.Survey_id, SP.SampleSet_id, SM.MailingStep_id, SM.Methodology_id, ms.MailingStepMethod_id, SM.datGenerate, count(*) as cnt
into #ACOMailingSteps
FROM   Survey_def SD
inner join surveytype st on sd.surveytype_id=st.surveytype_id
inner join MailingMethodology MM on MM.Survey_id = SD.Survey_id
inner join ScheduledMailing SM on MM.Methodology_id = SM.Methodology_id 
inner join MailingStep MS on SM.MailingStep_id=MS.MailingStep_id
inner join SamplePop SP on SP.SamplePop_id = SM.SamplePop_id 
left join FormGenError FGE on SM.ScheduledMailing_id = FGE.ScheduledMailing_id 
WHERE  ST.surveytype_dsc = 'ACOCAHPS' AND
       SM.SentMail_id IS NULL AND
       SM.datGenerate <= DATEADD(HOUR,6,GETDATE()) AND
       SD.bitFormGenRelease = 1 AND
       FGE.ScheduledMailing_id is NULL
GROUP BY SD.Study_id, SD.Survey_id, SP.SampleSet_id, SM.MailingStep_id, SM.Methodology_id, ms.MailingStepMethod_id, SM.datGenerate

-- list of everybody who was sampled in the same sampleset(s)
select distinct ams.Study_id, ams.Survey_id, ams.SampleSet_id, ams.MailingStep_id, ams.Methodology_id, ams.MailingStepMethod_id, sp.samplepop_id
into #ACOEverybody
from #ACOMailingSteps ams
inner join samplepop sp on ams.sampleset_id=sp.sampleset_id

-- delete people who have already returned the survey:
delete ae
from #ACOEverybody ae
inner join questionform qf on ae.samplepop_id=qf.samplepop_id
where qf.datReturned is not null

-- delete people with terminating dispositions
delete ae
from #ACOEverybody ae
inner join dispositionlog dl on ae.samplepop_id=dl.samplepop_id
where dl.Disposition_id in (
			  2 --	I do not wish to participate in this Survey
			, 3 --	The intended respondent has passed on
			, 4 --	The intended respondent is incapacitated and cannot participate in this Survey
			, 8 --	The Survey is not applicable to me
			,10 --	Language Barrier
			,13 --	Complete and Valid Survey
			,19 --	Complete and Valid Survey by Mail
			,20 --	Complete and Valid Survey by Phone
			,24 --	The intended respondent is institutionalized
			)

-- if this is a mail step, "Non Response Bad Address" is a terminating disposition
delete ae
from #ACOEverybody ae
inner join MailingStepMethod msm on ae.MailingStepMethod_id=msm.MailingStepMethod_id
inner join dispositionlog dl on ae.samplepop_id=dl.samplepop_id
where msm.MailingStepMethod_nm = 'Mail' and dl.disposition_id=5

-- if this is a phone step, "Non Response Bad Phone" is a terminating disposition
delete ae
from #ACOEverybody ae
inner join MailingStepMethod msm on ae.MailingStepMethod_id=msm.MailingStepMethod_id
inner join dispositionlog dl on ae.samplepop_id=dl.samplepop_id
where msm.MailingStepMethod_nm = 'Phone' and dl.disposition_id in (14,16)


-- of the people who are scheduled to generate, we want to find the datGenerate that most of them use
delete ams
from #ACOMailingSteps ams
inner join (select sampleset_id, mailingstep_id, max(cnt) as maxcnt 
			from #ACOMailingSteps 
			group by sampleset_id, mailingstep_id) mx 
		on ams.mailingstep_id=mx.mailingstep_id and ams.sampleset_id=mx.sampleset_id
where ams.cnt <> mx.maxcnt

-- delete people who already have the mailing step scheduled (whether that be tonight or some other time)
delete ae
from #ACOEverybody ae
inner join scheduledmailing schm on ae.samplepop_id=schm.samplepop_id and ae.mailingstep_id=schm.mailingstep_id

-- throw the rest of these bad boys into scheduled mailing
insert into scheduledmailing (MAILINGSTEP_ID,SAMPLEPOP_ID,SENTMAIL_ID,METHODOLOGY_ID,DATGENERATE)
select ae.MAILINGSTEP_ID,ae.SAMPLEPOP_ID,NULL,ae.METHODOLOGY_ID,min(ams.DATGENERATE)
from #ACOEverybody ae
inner join #ACOMailingSteps ams on ams.mailingstep_id=ae.mailingstep_id and ams.sampleset_id=ae.sampleset_id
group by ae.MAILINGSTEP_ID,ae.SAMPLEPOP_ID,ae.METHODOLOGY_ID
go