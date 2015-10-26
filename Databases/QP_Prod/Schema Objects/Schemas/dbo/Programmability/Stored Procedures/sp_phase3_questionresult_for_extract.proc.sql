USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[sp_phase3_questionresult_for_extract]    Script Date: 12/3/2014 1:55:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
-- Modified 10/29/2014 DBG - added Subtype_nm to temp table because ACOCAHPSCompleteness now needs it
-- Modified 03/27/2015 TSB -- modified #HHQF to include STRMAILINGSTEP_NM
CREATE PROCEDURE [dbo].[sp_phase3_questionresult_for_extract] 
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

    ----Get the records that are HHCAHPS so we can compute completeness  
    --SELECT e.QuestionForm_id, CONVERT(INT, NULL) Complete, convert(int,null) ATACnt, convert(int,null) Q1, convert(int,null) numAnswersAfterQ1
    --INTO   #HHQF 
    --FROM   QuestionForm_extract e, 
    --       QuestionForm qf, 
    --       Survey_def sd
    --WHERE  e.study_id IS NOT NULL 
    --       AND e.tiextracted = 0 
    --       AND datextracted_dt IS NULL 
    --       AND e.QuestionForm_id = qf.QuestionForm_id 
    --       AND qf.Survey_id = sd.Survey_id 
    --       AND Surveytype_id = 3 
    --GROUP  BY e.QuestionForm_id 

	--Modified 03/27/2015 TSB
	select e.QuestionForm_id, CONVERT(INT, NULL) Complete, convert(int,null) ATACnt, convert(int,null) Q1, convert(int,null) numAnswersAfterQ1, ms.STRMAILINGSTEP_NM
	into #HHQF
	from QuestionForm_extract e
	inner join QuestionForm qf on e.QuestionForm_id = qf.QuestionForm_id 
	inner join survey_def sd on qf.survey_id=sd.survey_id
	inner join SENTMAILING sm on sm.SENTMAIL_ID = qf.SENTMAIL_ID
	inner join SCHEDULEDMAILING scm on scm.scheduledmailing_id = sm.scheduledmailing_id
	inner join MAILINGSTEP ms on ms.MAILINGSTEP_ID = scm.mailingstep_id
	where e.study_id IS NOT NULL 
           AND e.tiextracted = 0
		   AND sd.surveytype_id=3
	GROUP  BY e.QuestionForm_id, ms.STRMAILINGSTEP_NM


    CREATE INDEX tmpindex ON #HHQF (QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'HH update tmp table with procedure call' 

--	UPDATE #HHQF
--	SET    complete = dbo.Hhcahpscompleteness(QuestionForm_id) 
	exec dbo.HHCAHPSCompleteness

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'HH update QuestionForm' 

    UPDATE qf 
    SET    bitComplete = Complete 
    FROM   QuestionForm qf, #HHQF t 
    WHERE  t.QuestionForm_id = qf.QuestionForm_id 

--	DROP TABLE #HHQF --> we're using this later, so don't drop it yet.

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
    -- if more than half of the ATA questions have been answered, bitComplete=1 and it's coded as a Complete
    UPDATE cqw 
    SET    FinalDisposition = '110' -- Completed Mail Survey
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 3 
           AND bitcomplete = 1 
           AND ReceiptType_ID = 17 

    UPDATE cqw 
    SET    FinalDisposition = '120' -- Completed Phone Interview
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 3 
           AND bitcomplete = 1 
           AND ReceiptType_ID = 12 

    --SELECT q.QuestionForm_id 
    --INTO   #hhcahps_invalidDisposition 
    --FROM   cmnt_QuestionResult_work q, 
  --       Survey_def sd 
    --WHERE  qstncore = 38694 
    --       AND val <> 1 
    --       AND sd.Survey_id = q.Survey_id 
    --       AND sd.Surveytype_id = 3 
    --       AND bitcomplete = 0 

	-- if incomplete and Q1=No and they didn't answer any other questions, they're ineligible
    UPDATE cqw 
    SET    FinalDisposition = '220' -- Ineligible: Does not meet eligible Population criteria
    FROM   cmnt_QuestionResult_work cqw 
           inner join #HHQF hh on  hh.QuestionForm_id = cqw.QuestionForm_id 
    WHERE  hh.Q1 = 2
           AND hh.complete = 0
           AND hh.numAnswersAfterQ1 = 0

    --SELECT q.QuestionForm_id 
    --INTO   #hhcahps_validDisposition 
    --FROM   cmnt_QuestionResult_work q, 
    --       Survey_def sd 
    --WHERE  qstncore = 38694 
    --       AND val = 1 
    --       AND sd.Survey_id = q.Survey_id 
    --       AND sd.Surveytype_id = 3 
    --       AND bitcomplete = 0 

	-- if incomplete and Q1=Yes or they answered questions after Q1, it's a breakoff
    UPDATE cqw 
    SET    FinalDisposition = '310' -- Breakoff
    FROM   cmnt_QuestionResult_work cqw 
           inner join #HHQF hh on hh.QuestionForm_id = cqw.QuestionForm_id 
    WHERE  hh.complete=0
           AND (hh.numAnswersAfterQ1 > 0 or hh.Q1=1)
           
	-- if incomplete and Q1 isn't answered and they didn't answer anything else either, it's just a blank survey.
	-- Modified 03/27/2015 TSB  to only look at 2ndSurvey
    UPDATE cqw 
    SET    FinalDisposition = '320' -- Refusal
    FROM   cmnt_QuestionResult_work cqw 
           inner join #HHQF hh on hh.QuestionForm_id = cqw.QuestionForm_id 
    WHERE  hh.complete=0
           AND hh.numAnswersAfterQ1=0 
           AND hh.Q1=-9
		   AND hh.STRMAILINGSTEP_NM = '2nd Survey'

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
    select cqw.questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasureComplete, 0 as Disposition, Subtype_nm, st.SurveyType_ID
    into #ACOQF
    FROM   cmnt_QuestionResult_work cqw 
    inner join Surveytype st on cqw.Surveytype_id=st.Surveytype_id
	left join (select sst.Survey_id, sst.Subtype_id, st.Subtype_nm 
				from [dbo].[SurveySubtype] sst 
				INNER JOIN [dbo].[Subtype] st on (st.Subtype_id = sst.Subtype_id)
				) sst on sst.Survey_id = cqw.SURVEY_ID 
    WHERE  st.SurveyType_dsc in ('ACOCAHPS','PQRS CAHPS')
    
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
           Dispositions_view dv,
		   surveytype st 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.acocahpsvalue = cqw.finalDisposition 
           AND cqw.Surveytype_id = st.SurveyType_ID
		   and st.SurveyType_dsc in ('ACOCAHPS','PQRS CAHPS')

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
GO
