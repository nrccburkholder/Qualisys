/*
	S32 US15	ACO Completeness
				As a Service Associate, I want survey validation question core checks updated to match current NRC templates, so that I can ensure surveys are correctly set up.


	15.2	modify ACO CAHPScompleteness stored procedure to make use of data from 15.1

Dave Gilsdorf

QP_Prod:
ALTER procedure [dbo].[ACOCAHPSCompleteness] 
ALTER FUNCTION [dbo].[ACOCAHPSCompleteness] (@QuestionForm_id INT)
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
	-- Subtype_nm

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
	
	--> new: 1.1
	-- for questionnaire type ACO-8
	update qf
	set ATAcnt=sub.cnt
		, ATAcomplete=case when sub.cnt >= (29 * 0.50) then 1 else 0 end
	from #ACOQF qf
	inner join (SELECT questionform_id, COUNT(distinct qstncore) as cnt
				FROM #QR 
				where intResponseVal>=0
				AND QstnCore IN (
					50175,  --01     Q1.   Saw provider                                     
					51426,  --02     Q4.   Number of times visited this provider            
					50218,  --03     Q36.   Provider is specialist                           
					50222,  --04     Q40.   Care team talked about things to prevent illness 
					50223,  --05     Q41.   Care team talked about healthy diet and eating ha
					50224,  --06     Q42.   Care team talked about exercise/physical activity
					50225,  --07     Q43.   Care team talked about specific goals for health 
					50229,  --08     Q44.   Care team asked if felt sad, empty or depressed  
					50230,  --09     Q45.   Care team talked about things that worry/cause st
					50234,  --10     Q46.   Rate health                                      
					50235,  --11     Q47.   Rate mental/emotional health                     
					50236,  --12     Q48.   Saw provider 3 or more times for same condition  
					50238,  --13     Q50.   Take prescription medicine                       
					50240,  --14     Q52.   Physical health interfered with social activities
					50241,  --15     Q53.    Age                                             
					50699,  --16     Q54.   Gender                                           
					50243,  --17     Q55.   Education level                                  
					50700,  --18     Q56.   English fluency                                  
					50245,  --19     Q57.   Speak another language at home                   
					50247,  --20     Q59.   Deaf or hearing impaired                         
					50248,  --21     Q60.   Blind or vision imparied                         
					50249,  --22     Q61.   Difficulty concentrating/remembering/making decis
					50250,  --23     Q62.   Difficulty walking or climbing stairs            
					50251,  --24     Q63.   Difficulty dressing or bathing                   
					50252,  --25     Q64.   Difficulty doing errands alone                   
					50253,  --26     Q65.   Of Hispanic/Latino origin/descent                
					50255,  --27     Q67.   Race (mail)                                            
					50725,  --28     Q68.   Race (phone)                                   
					50256   --29     Q84.   Had help completing survey
					)
				group by questionform_id) sub
		on qf.questionform_id=sub.questionform_id
		WHERE qf.Subtype_nm = 'ACO-8'


	--> new: 1.1 
	--for questionnaire type AC0-12
	update qf
	set ATAcnt=sub.cnt
		, ATAcomplete=case when sub.cnt >= (30 * 0.50) then 1 else 0 end
	from #ACOQF qf
	inner join (SELECT questionform_id, COUNT(distinct qstncore) as cnt
				FROM #QR 
				where intResponseVal>=0
				AND QstnCore IN (
					50175,  --01     Q1.   Saw provider                                     
					51426,  --02     Q4.   Number of times visited this provider            
					50218,  --03     Q44.   Provider is specialist                    
					50222,  --04     Q48.   Care team talked about things to prevent illness 
					50223,  --05     Q49.   Care team talked about healthy diet and eating ha
					50224,  --06     Q50.   Care team talked about exercise/physical activity
					50225,  --07     Q51.   Care team talked about specific goals for health 
					50226,  --08     Q52.   Took prescription medicine                       
					50229,  --09     Q55.   Care team asked if felt sad, empty or depressed  
					50230,  --10     Q56.   Care team talked about things that worry/cause st
					50234,  --11     Q57.   Rate health                                      
					50235,  --12     Q58.   Rate mental/emotional health                     
					50236,  --13     Q59.   Saw provider 3 or more times for same condition  
					50238,  --14     Q61.   Take prescription medicine                       
					50240,  --15     Q63.   Physical health interfered with social activities
					50241,  --16     Q64.    Age                                             
					50699,  --17     Q65.   Gender                                           
					50243,  --18     Q66.   Education level                                  
					50700,  --19     Q67.   English fluency                                  
					50245,  --20     Q68.   Speak another language at home                   
					50247,  --21     Q70.   Deaf or hearing impaired                         
					50248,  --22     Q71.   Blind or vision imparied                         
					50249,  --23     Q72.   Difficulty concentrating/remembering/making decis
					50250,  --24     Q73.   Difficulty walking or climbing stairs            
					50251,  --25     Q74.   Difficulty dressing or bathing                   
					50252,  --26     Q75.   Difficulty doing errands alone                   
					50253,  --27     Q76.   Of Hispanic/Latino origin/descent                
					50255,  --28     Q78.   Race (mail)                                            
					50725,  --29     Q79.   Race (phone)                                            
					50256   --30     Q95.   Had help completing survey 
					)
				group by questionform_id) sub
		on qf.questionform_id=sub.questionform_id
		WHERE qf.Subtype_nm = 'ACO-12'

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
CREATE FUNCTION [dbo].[ACOCAHPSCompleteness] (@QuestionForm_id INT)
RETURNS tinyint
AS
BEGIN

	DECLARE @Cnt INT, @Disposition tinyint, @ATAComplete bit, @MeasuresComplete bit

	declare @QR table (qstncore int, intResponseVal int)
	insert into @QR (qstncore, intResponseVal)
			select QstnCore,intResponseVal from QuestionResult where QuestionForm_id=@QuestionForm_id
			union all select QstnCore,intResponseVal from QuestionResult2 where QuestionForm_id=@QuestionForm_id
	
	declare @Q1 int, @Q4 int
	select @Q1=intResponseVal from @QR where qstncore=50175 
	if @Q1 is null set @Q1 = -9
	if @Q1 in (2,-5,-6,-8,-9) -- if Q1 invokes the skip, ignore questions 5 through 43
		delete from @QR where qstncore in (
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
	else
	begin
		select @Q4=intResponseVal from @QR where qstncore=50178 
		if @Q4 is null set @Q4 = -9
		if @Q4 in (0,-5,-6,-8,-9) -- if Q4 invokes the skip, ignore questions 5 through 43
				delete from @QR where qstncore in (
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
	end
			
	SELECT @Cnt=COUNT(distinct qstncore)
	FROM @QR 
	where intResponseVal>=0
	AND QstnCore IN (50175, --01		Q1. Our records show that you visited the provider named below in the last 6 months. Is that right?
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
					--1727,--34		Q57A – 57C*. Since August 1 2013 did anyone on your health care team… -- these three questions are treated as a single question
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
					--50715, 52		Q79A – 79E4*. What is your race? (phone Survey)	-- phone race question dealt with in the below IF EXISTS() query.
					50256  --53		Q80. Did someone help you complete this Survey?
					)
	
	-- the flu shot questions are a series of three yes/no questions, but they only count as a single question for completeness.					
	IF EXISTS (SELECT 1
				FROM @QR
				WHERE intResponseVal >= 0
				AND QstnCore between 50231 and 50233)
		set @cnt=@cnt+1

	-- the race question on the phone survey is a series of 16 yes/no questions, but they only count as a single question for completeness.					
	IF EXISTS (SELECT 1
				FROM @QR
				WHERE intResponseVal >= 0
				AND QstnCore between 50725 and 50740)
		set @cnt=@cnt+1

	IF @cnt >= (53 * 0.50)
		SET @ATAComplete=1
	ELSE 
		SET @ATAComplete=0

	SELECT @Cnt=COUNT(distinct qstncore)
	FROM @QR
	WHERE intResponseVal >= 0
	AND QstnCore IN (50180, -- Q6. In the last 6 months when you phoned this providers office to get an appointment for care you needed right away how often did you get an appointment as soon as you needed?
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

	IF @cnt >= 1
		SET @MeasuresComplete=1
	ELSE 
		SET @MeasuresComplete=0

	if @ATAComplete=1 and @MeasuresComplete=1
		set @Disposition=10 -- complete
	else if @ATAComplete=0 and @MeasuresComplete=1
		set @Disposition=31 -- partial
	else
		set @Disposition=34 -- blank/incomplete
		
	RETURN @Disposition

END
go