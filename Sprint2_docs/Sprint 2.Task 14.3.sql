use qp_prod
go
if exists (select * from sys.objects where name = 'ICHCAHPSCompleteness' and type='P')
	drop procedure [dbo].[ICHCAHPSCompleteness] 
go
create procedure [dbo].[ICHCAHPSCompleteness] 
AS
BEGIN
	-- assumes an #ICHQF table already exists and has the following columns:
	-- questionform_id int
	-- ATAcnt tinyint
	-- ATAcomplete bit
	-- Disposition tinyint 

	create table #QR (Questionform_id int, qstncore int, intResponseVal int)
	insert into #QR (questionform_id, qstncore, intResponseVal)
			select qr.questionform_id, QstnCore,intResponseVal from QuestionResult qr, #ICHQF qf where qr.QuestionForm_id=qf.QuestionForm_id
			union all select qr.questionform_id, QstnCore,intResponseVal from QuestionResult2 qr, #ICHQF qf where qr.QuestionForm_id=qf.QuestionForm_id
	
	update #ICHQF set ATAcnt=0, ATAcomplete=0, Disposition=0

	update #ICHQF set disposition=255
	from #ICHQF qf
	left join #QR qr on qf.questionform_id=qr.questionform_id
	where qr.questionform_id is null

	update qf
	set ATAcnt=sub.cnt, ATAcomplete=case when sub.cnt >= (38 * 0.50) then 1 else 0 end
	from #ICHQF qf
	inner join (SELECT questionform_id, COUNT(distinct qstncore) as cnt
				FROM #QR 
				where intResponseVal>=0
				AND QstnCore IN (
						51198,	--01	Q1. Where do you get your dialysis treatments?
						51199,	--02	Q2. How long have you been getting dialysis at [SAMPLE FACILITY NAME]?
						47159,	--03	Q3. In the last 3 months, how often did your kidney doctors listen carefully to you?
						47160,	--04	Q4. In the last 3 months, how often did your kidney doctors explain things in a way that was easy for you to understand?
						47161,	--05	Q5. In the last 3 months, how often did your kidney doctors show respect for what you had to say?
						47162,	--06	Q6. In the last 3 months, how often did your kidney doctors spend enough time with you?
						47163,	--07	Q7. In the last 3 months, how often did you feel your kidney doctors really cared about you as a person?
						47164,	--08	Q8. Using any number from 0 to 10 where 0 is the worst kidney doctors possible and 10 is the best kidney doctors possible, what number would you use to rate the kidney doctors you have now?
						47165,	--09	Q9. Do your kidney doctors seem informed and up to date about the health care you receive from other doctors?
						47166,	--10	Q10. In the last 3 months, how often did the dialysis center staff listen carefully to you?
						47167,	--11	Q11. In the last 3 months, how often did the dialysis center staff explain things in a way that was easy for you to understand?
						47168,	--12	Q12. In the last 3 months, how often did the dialysis center staff show respect for what you had to say?
						47169,	--13	Q13. In the last 3 months, how often did the dialysis center staff spend enough time with you?
						47170,	--14	Q14. In the last 3 months, how often did you feel the dialysis center staff really cared about you as a person?
						47171,	--15	Q15. In the last 3 months, how often did dialysis center staff make you as comfortable as possible during dialysis?
						47172,	--16	Q16. In the last 3 months, did dialysis center staff keep information about you and your health as private as possible from other patients?
						47173,	--17	Q17. In the last 3 months, did you feel comfortable asking the dialysis center staff everything you wanted about dialysis care?
						47174,	--18	Q18. In the last 3 months, has anyone on the dialysis center staff asked you about how your kidney disease affects other parts of your life?
						47175,	--19	Q19. The dialysis center staff can connect you to the dialysis machine through a graft, fistula, or catheter. Do you know how to take care of your graft, fistula, or catheter?
						47176,	--20	Q20. In the last 3 months, which one did they use most often to connect you to the dialysis machine?
						47178,	--21	Q22. In the last 3 months, how often did dialysis center staff check you as closely as you wanted while you were on the dialysis machine?
						47179,	--22	Q23. In the last 3 months, did any problems occur during your dialysis?
						47181,	--23	Q25. In the last 3 months, how often did dialysis center staff behave in a professional manner?
						47182,	--24	Q26. In the last 3 months, did dialysis center staff talk to you about what you should eat and drink?
						47183,	--25	Q27. In the last 3 months, how often did dialysis center staff explain blood test results in a way that was easy to understand?
						47184,	--26	Q28. As a patient you have certain rights. For example, you have the right to be treated with respect and the right to privacy. Did this dialysis center ever give you any written information about your rights as a patient?
						47185,	--27	Q29. Did dialysis center staff at this center ever review your rights as a patient with you?
						47186,	--28	Q30. Have dialysis center staff ever told you what to do if you experience a health problem at home?
						47187,	--29	Q31. Have any dialysis center staff ever told you how to get off the machine if there is an emergency at the center?
						47188,	--30	Q32. Using any number from 0 to 10 where 0 is the worst dialysis center staff possible and 10 is the best dialysis center staff possible, what number would you use to rate your dialysis center staff?
						47189,	--31	Q33. In the last 3 months, when you arrived on time, how often did you get put on the dialysis machine within 15 minutes of your appointment or shift time?
						47190,	--32	Q34. In the last 3 months, how often was the dialysis center as clean as it could be?
						47191,	--33	Q35. Using any number from 0 to 10, where 0 is the worst dialysis center possible and 10 is the best dialysis center possible, what number would you use to rate this dialysis center?
						47192,	--34	Q36. You can treat kidney disease with dialysis, kidney transplant, or with dialysis at home. In the last 12 months, did your kidney doctors or dialysis center staff talk to you as much as you wanted about which treatment is right for you?
						47193,	--35	Q37. Are you eligible for a kidney transplant?
						47195,	--36	Q39. Peritoneal dialysis is dialysis given through the belly and is usually done at home. In the last 12 months, did either your kidney doctors or dialysis center staff talk to you about peritoneal dialysis?
						47196,	--37	Q40. In the last 12 months, were you as involved as much as you wanted in choosing the treatment that is right for you?
						47197	--38	Q41. In the last 12 months, were you ever unhappy with the care you received at the dialysis center or from your kidney doctors?
					)
				group by questionform_id) sub
		on qf.questionform_id=sub.questionform_id

	update #ICHQF 
	set Disposition=
		case when ATAComplete=1 
			then 110 -- complete (110 is "Completed Mail Questionnaire" - which may or may not be the case here. This gets updated to 120 (phone) or 130 (Completed Mail Questionnaire—Survey Eligibility Unknown) below
		when ATACnt>=1
			then 210 -- Breakoff
		else
			34? -- blank/incomplete
		end
	where Disposition=0

	-- phone completes
	update ich
	set Disposition=120
	from #ICHQF ich
	inner join questionform qf on ich.questionform_id=qf.questionform_id
	inner join scheduledmailing scm on qf.sentmail_id=scm.sentmail_id
	inner join mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
	inner join mailingstepmethod msm on ms.mailingstepmethod_id=msm.mailingstepmethod_id
	where ich.disposition=110

	-- Completed Mail Questionnaire—Survey Eligibility Unknown
	update ich
	set disposition=130
	from #ICHQF ich
	inner join (SELECT questionform_id
				FROM #QR Q1
				where QstnCore=51198 -- ICH: Location of dialysis treatments
				AND q1.intResponseVal=1 -- At home
				) sub
			on ich.questionform_id=sub.questionform_id
	where ich.disposition=110
	and ATAcnt>2

	update ich
	set disposition=130
	from #ICHQF ich
	inner join (SELECT questionform_id
				FROM #QR Q2
				where q2.QstnCore=51199 -- How long have you been getting dialysis at [SAMPLE FACILITY NAME]?
				AND q2.intResponseVal in (1,5) -- Less than 3 months / I do not currently receive dialysis at this dialysis center
				) sub
			on ich.questionform_id=sub.questionform_id
	where ich.disposition=110
	and ATAcnt>2
				
select * from sel_qstns where survey_id=15715 and qstncore>100 order by section_id

	select * from sel_qstns where QstnCore=51198
	select * from sel_scls where qpc_id=8544
	select * from sel_skip where survey_id=15715 and selqstns_id=622
	
	select * from sel_qstns where QstnCore=51199
	select * from sel_scls where qpc_id=8545
	select * from sel_skip where survey_id=15715 and selqstns_id=623
	
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
--                           handles ICH CAHPS, too

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

    --END: Get the records that are MNCM so we can compute completeness  

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'exec CheckForACOCAHPSUsablePartials' 

	exec dbo.CheckForACOCAHPSUsablePartials

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'exec CheckForACOCAHPSInComplete' 

	exec dbo.CheckForACOCAHPSInComplete
    --END: Get the records that are ACO so we can compute completeness  

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
    select cqw.questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasuresComplete, 0 as Disposition
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
	
    --ICH CAHPS Dispositions
    select cqw.questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as Disposition
    into #ICHQF
    FROM   cmnt_QuestionResult_work cqw 
    inner join Surveytype st on cqw.Surveytype_id=st.Surveytype_id
    WHERE  st.SurveyType_dsc = 'ICHCAHPS'
    
    exec dbo.ICHCAHPSCompleteness
        
    UPDATE cqw 
    SET    FinalDisposition = qf.Disposition
    FROM   cmnt_QuestionResult_work cqw 
    inner join #ICHQF qf on cqw.questionform_id=qf.questionform_id
    WHERE  qf.disposition <> 255

	drop table #ICHQF	
	

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
--                           handles ICH CAHPS, too

select qf.Survey_id, qf.SamplePop_id, qf.QuestionForm_id, qf.unusedreturn_id, qf.datUnusedReturn, convert(bit,NULL) as bitUse, 0 as Disposition
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

-- ACO CAHPS
select p.questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasuresComplete, 0 as Disposition
into #ACOQF
from #partials p
inner join survey_def sd on p.survey_id=sd.survey_id
where unusedreturn_id=5
and bitUse is null
and sd.surveytype_id=10

exec dbo.ACOCAHPSCompleteness

update p
set Disposition=qf.Disposition
from #partials p
inner join #ACOQF qf on p.questionform_id=qf.questionform_id
-- ACO Disposition 10 = complete
-- ACO Disposition 31 = partial
-- ACO Disposition 34 = blank/incomplete

-- ICH CAHPS
select p.questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as Disposition
into #ICHQF
from #partials p
inner join survey_def sd on p.survey_id=sd.survey_id
where unusedreturn_id=5
and bitUse is null
and sd.surveytype_id=8

exec dbo.ICHCAHPSCompleteness

update p
set Disposition=qf.Disposition
from #partials p
inner join #ICHQF qf on p.questionform_id=qf.questionform_id
?-- ICH Disposition 10 = complete 
?-- ICH Disposition 31 = partial
?-- ICH Disposition 34 = blank/incomplete


-- If all of the MailingSteps are blank/incomplete or partial, use the partial that was returned first. 
update p
set bitUse=1
from #partials p
inner join (select SamplePop_id, Disposition, min(datUnusedReturn) as firstreturned
			from #partials
			where SamplePop_id in (	select SamplePop_id
									from #partials
									group by SamplePop_id
									having count(distinct isnull(unusedreturn_id,0)) = 1)
			and Disposition=31?
			group by SamplePop_id, Disposition) fr
		on p.SamplePop_id=fr.SamplePop_id and p.Disposition=fr.Disposition and p.datUnusedReturn=fr.firstreturned
where p.unusedreturn_id=5
and p.bitUse is null

-- and don't use anything else
update p
set bitUse=0
from #partials p
inner join (select SamplePop_id
			from #partials p
			where Disposition=31?
			and bitUse=1) U
	on p.SamplePop_id=u.SamplePop_id
where p.unusedreturn_id=5
and p.bitUse is null

-- If they were all blank/incomplete, use the blank/incomplete that was returned first.
update p
set bitUse=1
from #partials p
inner join (select SamplePop_id, Disposition, min(datUnusedReturn) as firstreturned
			from #partials
			where SamplePop_id in (	select SamplePop_id
									from #partials
									group by SamplePop_id
									having count(distinct isnull(unusedreturn_id,0)) = 1)
			and Disposition=34?
			group by SamplePop_id, Disposition) fr
		on p.SamplePop_id=fr.SamplePop_id and p.Disposition=fr.Disposition and p.datUnusedReturn=fr.firstreturned
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
alter PROCEDURE [dbo].[CheckForACOCAHPSIncomplete]
AS

-- Modified 06/18/2014 DBG - refactored ACOCAHPSCompleteness as a procedure instead of a function.
--                           handles ICH CAHPS, too

/* PART 1 -- find people who are going through the ETL tonight and check their completeness. If their survey was partial or incomplete, reschedule their next mailstep. */

-- list of everybody who returned an ACOCAHPS Survey today
select qf.datReturned, qf.datResultsImported, sd.Survey_id, st.Surveytype_id, st.Surveytype_dsc, ms.intSequence
, scm.*, qf.QuestionForm_id, sm.datExpire, convert(tinyint,null) as Disposition, convert(varchar(15),'') as DispositionAction
into #TodaysReturns
from QuestionForm_extract qfe
inner join QuestionForm qf on qf.QuestionForm_id=qfe.QuestionForm_id
inner join SentMailing sm on qf.SentMail_id=sm.SentMail_id
inner join ScheduledMailing scm on sm.ScheduledMailing_id=scm.ScheduledMailing_id
inner join Survey_def sd on qf.Survey_id=sd.Survey_id
inner join SurveyType st on sd.Surveytype_id=st.Surveytype_id
inner join MailingStep ms on scm.Methodology_id=ms.Methodology_id and scm.MailingStep_id=ms.MailingStep_id
where qf.datResultsImported is not null
and st.Surveytype_dsc in ('ACOCAHPS', 'ICHCAHPS')
and sm.datExpire > getdate()
order by qf.datResultsImported desc

-- ACO CAHPS completeness
select questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasuresComplete, 0 as Disposition
into #ACOQF
from #TodaysReturns
where Surveytype_dsc='ACOCAHPS'

exec dbo.ACOCAHPSCompleteness

update tr
set Disposition=qf.disposition
from #TodaysReturns tr
inner join #ACOQF qf on tr.questionform_id=qf.questionform_id

-- ICH CAHPS completeness
select p.questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as Disposition
into #ICHQF
from #TodaysReturns
where Surveytype_dsc='ICHCAHPS'

exec dbo.ICHCAHPSCompleteness

update tr
set Disposition=qf.disposition
from #TodaysReturns tr
inner join #ICHQF qf on tr.questionform_id=qf.questionform_id


select * from #todaysreturns
-- ACO Disposition 10 = complete
-- ACO Disposition 31 = partial
-- ACO Disposition 34 = blank/incomplete
-- ICH Disposition ? = complete
-- ICH Disposition ? = partial
-- ICH Disposition ? = blank/incomplete

-- for complete survyes, set QuestionForm.bitComplete=1
update qf 
set bitComplete = 1
from #TodaysReturns tr
inner join QuestionForm qf on qf.QuestionForm_id=tr.QuestionForm_id
where Disposition = 10?

-- for blank/incomplete or partial Surveys, set bitComplete=0, move datReturned to datUnusedReturn, blank out datResultsImported,
-- and set UnusedReturn_id=5, which means a partial return that isn't used for now (it might be used later if it ends up being the only return we ever get)
-- fyi: UnusedReturn_id=6 means a partial return whose fate we have decided (either we ignored it because a better return came in or we used it because it's the best we got.)
update qf 
set bitComplete = 0, datReturned=null, UnusedReturn_id=5, datUnusedReturn=qf.datReturned, datResultsImported = NULL
from #TodaysReturns tr
inner join QuestionForm qf on qf.QuestionForm_id=tr.QuestionForm_id
where Disposition <> 10?

-- move blank/incomplete and partial results into QuestionResult2
insert into QuestionResult2 (QuestionForm_ID,SampleUnit_ID,QstnCore,intResponseVal)
select qr.QuestionForm_ID,qr.SampleUnit_ID,qr.QstnCore,qr.intResponseVal
from QuestionResult qr
inner join #TodaysReturns tr on qr.QuestionForm_id=tr.QuestionForm_id
where Disposition <> 10?

-- delete blank/incomplete and partial results from QuestionResult
delete qr
from QuestionResult qr
inner join #TodaysReturns tr on qr.QuestionForm_id=tr.QuestionForm_id
where Disposition <> 10?

-- remove blank/incomplete and partial Surveys from the ETL queue
delete qre
from QuestionForm_extract qre
inner join #TodaysReturns tr on qre.QuestionForm_id=tr.QuestionForm_id
where Disposition <> 10?

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


delete from #TodaysReturns where Disposition <> 10?

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

if object_id('tempdb..#CAHPSMailingSteps') is not null
	drop table #CAHPSMailingSteps

if object_id('tempdb..#CAHPSEverybody') is not null
	drop table #CAHPSEverybody

-- list of acocahps steps that are getting generated today
SELECT SD.Study_id, SD.Survey_id, SP.SampleSet_id, SM.MailingStep_id, SM.Methodology_id, ms.MailingStepMethod_id, SM.datGenerate, count(*) as cnt
into #CAHPSMailingSteps
FROM   Survey_def SD
inner join surveytype st on sd.surveytype_id=st.surveytype_id
inner join MailingMethodology MM on MM.Survey_id = SD.Survey_id
inner join ScheduledMailing SM on MM.Methodology_id = SM.Methodology_id 
inner join MailingStep MS on SM.MailingStep_id=MS.MailingStep_id
inner join SamplePop SP on SP.SamplePop_id = SM.SamplePop_id 
left join FormGenError FGE on SM.ScheduledMailing_id = FGE.ScheduledMailing_id 
WHERE  ST.surveytype_dsc in ('ACOCAHPS','ICHCAHPS') AND
       SM.SentMail_id IS NULL AND
       SM.datGenerate <= DATEADD(HOUR,6,GETDATE()) AND
       SD.bitFormGenRelease = 1 AND
       FGE.ScheduledMailing_id is NULL
GROUP BY SD.Study_id, SD.Survey_id, SP.SampleSet_id, SM.MailingStep_id, SM.Methodology_id, ms.MailingStepMethod_id, SM.datGenerate

-- list of everybody who was sampled in the same sampleset(s)
select distinct cms.Study_id, cms.Survey_id, cms.SampleSet_id, cms.MailingStep_id, cms.Methodology_id, cms.MailingStepMethod_id, sp.samplepop_id
into #CAHPSEverybody
from #CAHPSMailingSteps cms
inner join samplepop sp on cms.sampleset_id=sp.sampleset_id

-- delete people who have already returned the survey:
delete ce
from #CAHPSEverybody ce
inner join questionform qf on ce.samplepop_id=qf.samplepop_id
where qf.datReturned is not null

-- delete people with terminating dispositions
delete ce
from #CAHPSEverybody ce
inner join dispositionlog dl on ce.samplepop_id=dl.samplepop_id
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
delete ce
from #CAHPSEverybody ce
inner join MailingStepMethod msm on ce.MailingStepMethod_id=msm.MailingStepMethod_id
inner join dispositionlog dl on ce.samplepop_id=dl.samplepop_id
where msm.MailingStepMethod_nm = 'Mail' and dl.disposition_id=5

-- if this is a phone step, "Non Response Bad Phone" is a terminating disposition
delete ce
from #CAHPSEverybody ce
inner join MailingStepMethod msm on ce.MailingStepMethod_id=msm.MailingStepMethod_id
inner join dispositionlog dl on ce.samplepop_id=dl.samplepop_id
where msm.MailingStepMethod_nm = 'Phone' and dl.disposition_id in (14,16)


-- of the people who are scheduled to generate, we want to find the datGenerate that most of them use
delete cms
from #CAHPSMailingSteps cms
inner join (select sampleset_id, mailingstep_id, max(cnt) as maxcnt 
			from #CAHPSMailingSteps 
			group by sampleset_id, mailingstep_id) mx 
		on cms.mailingstep_id=mx.mailingstep_id and cms.sampleset_id=mx.sampleset_id
where cms.cnt <> mx.maxcnt

-- delete people who already have the mailing step scheduled (whether that be tonight or some other time)
delete ce
from #CAHPSEverybody ce
inner join scheduledmailing schm on ce.samplepop_id=schm.samplepop_id and ce.mailingstep_id=schm.mailingstep_id

-- throw the rest of these bad boys into scheduled mailing
insert into scheduledmailing (MAILINGSTEP_ID,SAMPLEPOP_ID,SENTMAIL_ID,METHODOLOGY_ID,DATGENERATE)
select ce.MAILINGSTEP_ID,ce.SAMPLEPOP_ID,NULL,ce.METHODOLOGY_ID,min(cms.DATGENERATE)
from #CAHPSEverybody ce
inner join #CAHPSMailingSteps cms on cms.mailingstep_id=ce.mailingstep_id and cms.sampleset_id=ce.sampleset_id
group by ce.MAILINGSTEP_ID,ce.SAMPLEPOP_ID,ce.METHODOLOGY_ID
go