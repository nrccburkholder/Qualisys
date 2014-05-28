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


