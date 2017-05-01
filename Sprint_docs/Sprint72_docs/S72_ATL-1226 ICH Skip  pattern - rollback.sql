use NRC_DataMart_ETL;
go
-- 11/30/12 DRM - Added changes to properly evaluate nested skip questions. 
-- i.e. when a gateway question is a skip question for a previous gateway question. 
-- Modified 05/13/2013 DBG - added survey_id in the link between questionformtemp and skipidentifier in two places
-- Modified 05/14/2013 DBG - modifications to account for overlapping skips
-- Modified 04/04/2014 CBC - Modified for ACO project.  Added logic to handle new phone survey responses.
-- Modified 12/17/2014 DBG - Differentiate between "not answered" (-9) and "appropriately skipped" (-4)
-- Modified 01/21/2015 DRH - two new indexes for #work
-- Modified 11/03/2016 CJB - S61 ATL-962 Modify ICH Submission Skip Coding

ALTER PROCEDURE [dbo].[csp_ProcessSkipPatterns] 
@ExtractFileID INT 

WITH RECOMPILE
AS 

    SET nocount ON 

	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT;

    -- declare @ExtractFileID int  
    -- set @ExtractFileID = 20  
    CREATE TABLE #work 
      (  questionform_id INT, 
         sampleunit_id   INT, 
         skip_id         INT, 
         survey_id       INT,
         bitFlag         BIT
      ) 

    DECLARE @qf INT, @su INT, @sk INT, @svy INT, @bitUpdate BIT

    SET @bitUpdate = 1 

    -- Identify the first skip pattern that needs to be enforced for a questionform_id  
    INSERT INTO #work (questionform_id, sampleunit_id, skip_id, survey_id, bitFlag) 
    SELECT qr.questionform_id, qr.sampleunit_id, si.skip_id, sd.survey_id, 0
    FROM   bubbletemp qr  
           INNER JOIN questionformtemp qf           ON qf.questionform_id = qr.questionform_id 
           INNER JOIN qp_prod.dbo.skipidentifier si ON qf.survey_id = si.survey_id
                                                       AND qf.datgenerated = si.datgenerated 
                                                       AND qr.nrcquestioncore = si.qstncore 
                                                       AND (qr.responseval = si.intresponseval 
															OR (qr.responseval IN ( -8, -9))
															OR (qr.responseval IN (-5, -6)  AND NOT qr.nrcquestioncore = 50218) ) -- Modified 04/04/2014 CBC
           INNER JOIN qp_prod.dbo.survey_def sd     ON si.survey_id = sd.survey_id 
    WHERE  sd.bitenforceskip <> 0 
           AND qf.extractfileid = @ExtractFileID 
           AND qr.extractfileid = @ExtractFileID 


    --  DRM 11/30/2012 Combined two UNION queries into one query (above)  
    --SELECT qf.QuestionForm_id, qr.SampleUnit_id, si.Skip_id, si.Survey_id  
    --FROM QuestionFormTemp qf With (NOLOCK)  
    --   INNER JOIN BubbleTemp qr With (NOLOCK)  
    --   on qf.QuestionForm_id = qr.QuestionForm_id  
    --   INNER JOIN qp_prod.dbo.SkipIdentifier si With (NOLOCK)  
    --   ON qf.datGenerated = si.datGenerated AND qr.nrcQuestionCore = si.QstnCore AND qr.responseVal = si.intResponseVal 
    --   INNER JOIN qp_prod.dbo.survey_def sd With (NOLOCK)  
    --   ON si.survey_id = sd.survey_id  
    -- WHERE sd.bitEnforceSkip <> 0  
    -- AND qf.ExtractFileID = @ExtractFileID AND qr.ExtractFileID = @ExtractFileID  
    -- UNION  
    --SELECT qf.QuestionForm_id, qr.SampleUnit_id, si.Skip_id, si.Survey_id  
    --FROM QuestionFormTemp qf With (NOLOCK)  
    --   INNER JOIN BubbleTemp qr With (NOLOCK)  
    --   on qf.QuestionForm_id = qr.QuestionForm_id  
    --   INNER JOIN qp_prod.dbo.SkipIdentifier si With (NOLOCK)  
    --   ON qf.datGenerated = si.datGenerated AND qr.nrcQuestionCore = si.QstnCore AND qr.responseVal IN (-8,-9) 
    --   INNER JOIN qp_prod.dbo.survey_def sd With (NOLOCK)  
    --   ON si.survey_id = sd.survey_id  
    -- WHERE sd.bitEnforceSkip <> 0  
    -- AND qf.ExtractFileID = @ExtractFileID AND qr.ExtractFileID = @ExtractFileID  
    --work need index on questionform_id, sampleunit_id, skip_id  
    CREATE NONCLUSTERED INDEX idx_w ON #work (questionform_id ASC, sampleunit_id ASC, skip_id ASC ) 

-- DRH 01/21/2015 ... two new indexes for #work
CREATE NONCLUSTERED INDEX idx2_w ON #work (bitFlag ASC)
CREATE NONCLUSTERED INDEX idx4_w ON #work (bitFlag ASC, questionform_id ASC, sampleunit_id ASC, skip_id ASC) INCLUDE (survey_id)

    SELECT TOP 1 @qf = questionform_id, 
                 @su = sampleunit_id, 
                 @sk = skip_id, 
                 @svy = survey_id 
    FROM   #work 
    WHERE  bitFlag = 0
    ORDER  BY questionform_id, 
              sampleunit_id, 
              skip_id 

    --  DRM 11/30/2012 No need for this snapshot of the data.  
    --select qr.Questionform_id,qr.sampleunit_id ,si.skip_id  
    -- into #validskippattern  
    -- FROM BubbleTemp qr With (NOLOCK)   
    --   INNER JOIN QuestionFormTemp qf With (NOLOCK)  
    --   on qf.QuestionForm_id = qr.QuestionForm_id  
    --   INNER JOIN QP_PROD.dbo.SkipIdentifier si With (NOLOCK)  
    --   ON qf.datGenerated = si.datGenerated AND qr.nrcQuestionCore = si.QstnCore  
    -- AND (qr.responseVal = si.intResponseVal OR qr.responseVal IN (-8,-9))  
    --where qf.ExtractFileID = @ExtractFileID and qr.ExtractFileID = @ExtractFileID  
    -- CREATE NONCLUSTERED INDEX idx_v on #validskippattern (questionform_id asc,sampleunit_id asc, skip_id asc ) 
    -- --need index vsp.Questionform_id  
    --   AND vsp.sampleunit_id  
    --   AND vsp.skip_id  
    --  
    -- select *  
    --   from #WORK  
    --  
    -- select *  
    -- from BubbleTemp qr, QP_Prod.dbo.Skipqstns sq  
    -- where sq.QstnCore = qr.nrcQuestionCore  
    -- Update skipped qstncores while we have work to process  
    WHILE (SELECT Count(1) FROM #work WHERE bitflag = 0) > 0 
      BEGIN 
          --SkipPatternWork:  
          IF @bitUpdate = 1 
            UPDATE qr 
            SET    responseVal = responseVal + 10000 
            -- SET Val = VAL + 10000  
            FROM   bubbletemp qr, 
                   qp_prod.dbo.skipqstns sq 
            WHERE  qr.extractfileid = @ExtractFileID 
                   AND @qf = qr.questionform_id 
                   AND @su = qr.sampleunit_id 
                   AND @sk = Skip_id 
                   AND sq.qstncore = qr.nrcquestioncore 
--dbg 5/14/13      AND responseVal NOT IN ( -9, -8 ) 
                   AND responseVal < 9000 

          -- Identify the NEXT skip pattern that needs to be enforced for a questionform_id  
          UPDATE #work 
          SET    bitflag = 1
          WHERE  @qf = questionform_id 
                 AND @su = sampleunit_id 
                 AND @sk = skip_id 
                 AND @svy = survey_id 

          SELECT TOP 1 @qf = questionform_id, 
                       @su = sampleunit_id, 
                       @sk = skip_id, 
                       @svy = survey_id 
          FROM   #work 
          WHERE  bitflag = 0
          ORDER  BY questionform_id, 
                    sampleunit_id, 
                    skip_id 

          -- Check to see if next skip pattern gateway still qualifies as a  
          -- valid skip pattern gateway after last Update loop  
          IF ( 
             --   SELECT COUNT(1)  
             --   FROM BubbleTemp qr   
             --   INNER JOIN QuestionFormTemp qf With (NOLOCK)  
             --   on qf.QuestionForm_id = qr.QuestionForm_id  
             --   INNER JOIN QP_PROD.dbo.SkipIdentifier si With (NOLOCK)  
             --   ON qf.generatedDate = si.datGenerated AND qr.nrcQuestionCore = si.QstnCore 
             -- AND (qr.responseVal = si.intResponseVal OR qr.responseVal IN (-8,-9))  
             -- FROM #validskippattern vsp With (NOLOCK)  
             --WHERE vsp.Questionform_id = @qf  
             -- AND vsp.sampleunit_id = @su  
             -- AND vsp.skip_id = @sk  
             -- DRM 11/30/2012 Modified this query to evaluate if the current gateway question is itself  
             --   a skip question from a previous gateway question.  
             SELECT Count(*) 
              FROM   bubbletemp qr 
                     INNER JOIN questionformtemp qf            ON qf.questionform_id = qr.questionform_id 
                     INNER JOIN qp_prod.dbo.skipidentifier si  ON qf.survey_id = si.survey_id
                                                                  AND qf.datgenerated = si.datgenerated 
                                                                  AND qr.nrcquestioncore = si.qstncore
                                                       AND (qr.responseval = si.intresponseval 
															OR (qr.responseval IN ( -8, -9))
															OR (qr.responseval IN (-5, -6)  AND NOT qr.nrcquestioncore = 50218) ) -- Modified 04/04/2014 CBC
                     INNER JOIN qp_prod.dbo.survey_def sd      ON si.survey_id = sd.survey_id 
                     INNER JOIN qp_prod.dbo.skipqstns sq       ON si.skip_id = sq.skip_id 
                     INNER JOIN qp_prod.dbo.skipidentifier si2 ON sq.qstncore = si2.qstncore 
                                                                  AND si2.skip_id = @sk 
              WHERE  sd.bitenforceskip <> 0 
                     AND qr.questionform_id = @qf 
                     AND qf.extractfileid = @ExtractFileID 
                     AND qr.extractfileid = @ExtractFileID) > 0 
					 
            SET @bitUpdate = 0 
          ELSE 
            SET @bitUpdate = 1 
      END 

      --dbg 5/14/13-- -8's and -9's are now being offset, but we don't really want them to be. So we're now offsetting them back.
	  -- Modified 04/04/2014 CBC - Adjusts skipped question response values if values equals -5 or -6 by substracting 10000.
	  -- Modified 12/17/2014 DBG - Differentiate between "not answered" (-9) and "appropriately skipped" (-4)	  
      UPDATE bt 
      SET    responseVal = case when bt.responseval in (9991,9992) then -4 else responseVal - 10000 end	-- 9991 is -9 (not answered) and 9992 is -8 (single respone question with multiple marks) 
																										-- both with the +10000 offset. Both of these should be set to -4 (appropriately skipped)
      FROM   bubbletemp bt 
             INNER JOIN qp_prod.dbo.skipqstns sq ON sq.qstncore = bt.nrcquestioncore 
             INNER JOIN #work w                  ON bt.questionform_id = w.questionform_id 
                                                    AND bt.sampleunit_id = w.sampleunit_id 
                                                    AND sq.skip_id = w.skip_id 
      WHERE  bt.responseval IN ( 9992, 9991, 9995, 9994 ) 
             AND bt.extractfileid = @ExtractFileID ;

---- ATL-962 Modify ICH Submission Skip Coding -------------- BEGIN

	with Skip_CTE as (
			   select distinct bt.Questionform_id, bt.nrcQuestionCore as gateQstn, bt.responseVal as gateResponse, case when bt.responseVal % 10000=skipinfo.invokeResponse or bt.responseVal < 0 then 1 else 0 end as gateInvoked
					  , skipinfo.skippedQstn, stqm.isIgnoredIfCloserNestingExists 
			   from BubbleTemp bt
			   INNER JOIN questionformtemp qf ON qf.questionform_id = bt.questionform_id and bt.ExtractFileID=qf.ExtractFileID
			   inner join (select si.survey_id, si.datGenerated, si.qstncore as [gate], si.intResponseval as [invokeResponse], sq.QstnCore as [skippedQstn]
								   from qp_prod.dbo.SkipIdentifier si
								   INNER JOIN qp_prod.dbo.SkipQstns sq on sq.Skip_id = si.Skip_id) as skipinfo 
					  on bt.nrcQuestionCore=skipinfo.gate and qf.survey_id=skipinfo.survey_id and qf.DatGenerated=skipinfo.datGenerated
			   INNER JOIN qp_prod.dbo.SurveyTypeQuestionMappings stqm
					  on stqm.SurveyType_id = qf.SurveyType_id and stqm.QstnCore = bt.nrcQuestionCore
			   where bt.ExtractFileID = @ExtractFileID
		)
		update bt set responseVal = -9
		from BubbleTemp bt
		inner join Skip_CTE cteP --P means Parent
			   on bt.nrcQuestionCore = cteP.skippedQstn and bt.QUESTIONFORM_ID = cteP.QuestionForm_id
		inner join Skip_CTE cteGP --GP means Grandparent
			   on cteP.gateQstn = cteGP.skippedQstn and cteP.QuestionForm_id = cteGP.QuestionForm_id
		where bt.ExtractFileID = @ExtractFileID 
			   --and cteP.isIgnoredIfCloserNestingExists = 0   --> we don't care whether the closest skip should be ignored if a closer skip exists or not (because there is no closer skip) 
			   and cteGP.isIgnoredIfCloserNestingExists = 1    --> we only care if the outer skip should be ignored if a closer skip exists
			   and bt.responseVal = -4
			   and cteGP.gateInvoked = 1 -- the outer skip was invoked
			   and cteP.gateInvoked = 0 -- but the closer skip was not 

---- ATL-962 Modify ICH Submission Skip Coding -------------- END

    DROP TABLE #work 

    -- drop table #validskippattern  
    EXEC dbo.Csp_processskippatterns_hhcahps @ExtractFileID 


	

	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2

    RETURN
GO