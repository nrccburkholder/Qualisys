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

-- ATL-1226 - ICH Skip pattern for questions with multiple gate responses
	if object_id('tempdb..#ICHwork') is not null drop table #ICHwork

	CREATE TABLE #ICHwork
		(  work_id int identity(1,1),
			questionform_id INT, 
			sampleunit_id   INT, 
			skip_id         INT, 
			survey_id       INT,
			bitFlag         INT,
			GateQstn        INT,
			bitUndo         INT
		) 

	if object_id('tempdb..#QuestionFormTemp') is not null drop table #QuestionFormTemp

	select qf.* 
	into #QuestionFormTemp 
	from QuestionFormTemp qf
	join qp_prod.dbo.survey_def sd on qf.SURVEY_ID=sd.survey_id
	where sd.surveytype_id=8
	and sd.bitenforceskip <> 0 
	and qf.extractfileid = @ExtractFileID 

	if object_id('tempdb..#bubbletemp') is not null drop table #bubbletemp

	select bt.*, sq.NUMMARKCOUNT
	into #bubbletemp
	from bubbletemp bt
	join #QuestionFormTemp qf on bt.ExtractFileID=qf.ExtractFileID and bt.QUESTIONFORM_ID=qf.QUESTIONFORM_ID
	left join qp_prod.dbo.SEL_QSTNS sq on qf.survey_id=sq.survey_id and sq.language=1 and bt.nrcQuestionCore=sq.qstncore and sq.subtype=1

	-- if questions have been removed from the form, some numMarkCount values will be NULL, so we grab them from the sampleset-specific copy of sel_qstns
	update bt set NUMMARKCOUNT=sq.NUMMARKCOUNT
	from #bubbletemp bt
	join #QuestionFormTemp qf on bt.ExtractFileID=qf.ExtractFileID and bt.QUESTIONFORM_ID=qf.QUESTIONFORM_ID
	join qp_prod.dbo.questionform pqf on qf.questionform_id=pqf.questionform_id
	join qp_prod.dbo.samplepop sp on pqf.samplepop_id=sp.samplepop_id
	join qp_prod.dbo.DL_SEL_QSTNS_BySampleSet sq on qf.survey_id=sq.survey_id and sp.sampleset_id=sq.sampleset_id and sq.language=1 and bt.nrcQuestionCore=sq.qstncore and sq.subtype=1
	where bt.numMarkCount is null

	if exists (select * from #bubbletemp)
	BEGIN
		-- undo whatever recoding happened above
		update #bubbletemp set responseVal = -9 where responseVal = -4
		update #bubbletemp set responseval = responseval-10000 where responseval >= 9000  -- there's an ICH question with a responseVal=-89, and its offset value would be 9911

		-- insert into #ICHWork any gate question that was answered in such a way as to invoke to skip
		INSERT INTO #ICHwork (questionform_id, sampleunit_id, skip_id, survey_id, bitFlag, GateQstn, bitUndo) 
		SELECT qr.questionform_id, qr.sampleunit_id, si.skip_id, si.survey_id, 0, si.QstnCore, 0
		FROM   #bubbletemp qr  
			   INNER JOIN #questionformtemp qf          ON qf.questionform_id = qr.questionform_id 
			   INNER JOIN qp_prod.dbo.skipidentifier si ON qf.survey_id = si.survey_id
														   AND qf.datgenerated = si.datgenerated 
														   AND qr.nrcquestioncore = si.qstncore 
														   AND (qr.responseval = si.intresponseval 
																/*   -- unanswered questions should not invoke the skip, which is different from when #Work is populated above
																OR (qr.responseval IN ( -8, -9))
																OR (qr.responseval IN (-5, -6)  AND NOT qr.nrcquestioncore = 50218) 
																*/
																) 

		-- we'll be cycling through #ICHwork by looking at one skip_id at a time.
		-- records are added to qp_prod.dbo.skipidentifier in the order the questions appear on the survey
		-- so processing questions in skip_id order allows us to follow the order the questions appear on the survey.
		declare @iteration int=0
		declare @skip int = 0
		while exists (select * from #ICHwork where bitflag=0) 
		begin
			select @skip = min(skip_id) from #ICHwork where bitflag=0
			set @iteration=@iteration+1

			/*
			-- these two SELECTS mirror the logic of the next two UPDATES and are useful for debugging
			select w.questionform_id, w.sampleunit_id, w.skip_id,sq.QstnCore,bt.nrcQuestionCore, bt.responseVal, bt.responseVal+10000, @iteration as iteration 
			from #ICHwork w
			join qp_prod.dbo.SkipQstns sq on w.skip_id=sq.Skip_id
			join #bubbletemp bt on w.questionform_id=bt.questionform_id and w.sampleunit_id=bt.sampleunit_id and sq.QstnCore=bt.nrcQuestionCore
			where w.skip_id = @skip
			and w.bitUndo = 0
			and bt.responseVal < 9000
			--and sq.qstncore in (51199,47176,47177,47193,47194)
			order by 1,2,3,charindex(convert(varchar,sq.qstncore),'51199,47176,47177,47193,47194')

			select w.questionform_id, w.sampleunit_id, w.skip_id,sq.QstnCore,bt.nrcQuestionCore, bt.responseVal, bt.responseVal-10000, @iteration as iteration
			from #ICHwork w
			join qp_prod.dbo.SkipQstns sq on w.skip_id=sq.Skip_id
			join #bubbletemp bt on w.questionform_id=bt.questionform_id and w.sampleunit_id=bt.sampleunit_id and sq.QstnCore=bt.nrcQuestionCore
			where w.skip_id = @skip
			and w.bitUndo = 1
			and bt.responseVal > 9000
			--and sq.qstncore in (51199,47176,47177,47193,47194)
			order by 1,2,3,charindex(convert(varchar,sq.qstncore),'51199,47176,47177,47193,47194')
			*/
	
			-- add a 10000 offset to any response to a question that should have been skipped.
			-- in the case of unanswered questions, -9, -8, -6 and -5 will be recoded to 9991, 9992, 9994 and 9995	
			update bt set responseVal=ResponseVal + 10000
			from #ICHwork w
			join qp_prod.dbo.SkipQstns sq on w.skip_id=sq.Skip_id
			join #bubbletemp bt on w.questionform_id=bt.questionform_id and w.sampleunit_id=bt.sampleunit_id and sq.QstnCore=bt.nrcQuestionCore
			where w.skip_id = @skip
			and w.bitUndo = 0
			and bt.responseVal < 9000 -- if the response has already been offset because of a prior skip, we don't want to offset it again.
			--and sq.qstncore in (51199,47176,47177,47193,47194)	
	
			-- subtract a 10000 offset from any response to a question that was previously identified as should have been skipped, but needs to be changed to should not have been skipped due to a closer gateway 
			-- this happens in the case of nested skips
			-- in the case of unanswered questions, 9991, 9992, 9994 and 9995 will be recoded back to -9, -8, -6 and -5
			update bt set responseVal=ResponseVal - 10000
			from #ICHwork w
			join qp_prod.dbo.SkipQstns sq on w.skip_id=sq.Skip_id
			join #bubbletemp bt on w.questionform_id=bt.questionform_id and w.sampleunit_id=bt.sampleunit_id and sq.QstnCore=bt.nrcQuestionCore
			where w.skip_id = @skip
			and w.bitUndo = 1
			and bt.responseVal > 9000
			--and sq.qstncore in (51199,47176,47177,47193,47194)

			-- we need to remove work that is no longer relevant.
			-- it's no longer relevant when we code a gateway non-response to should not have been skipped (via bitUndo = 1)
			update w2 set questionform_id=-abs(w2.questionform_id)
			from #ICHwork w
			join qp_prod.dbo.SkipQstns sq on w.skip_id=sq.Skip_id
			join #bubbletemp bt on w.questionform_id=bt.questionform_id and w.sampleunit_id=bt.sampleunit_id and sq.QstnCore=bt.nrcQuestionCore
			join #questionformtemp qf ON qf.questionform_id = bt.questionform_id 
			JOIN qp_prod.dbo.skipidentifier si ON qf.survey_id = si.survey_id
												  AND qf.datgenerated = si.datgenerated 
												  AND bt.nrcquestioncore = si.qstncore  --> the skipped question we just updated is also a gate question 
												  and bt.responseVal between -9 and -5 --> and it was changed back to inappropriately skipped
			JOIN qp_prod.dbo.survey_def sd ON si.survey_id = sd.survey_id 
			join #ICHwork w2 on w.questionform_id=w2.questionform_id and w.sampleunit_id=w2.sampleunit_id and sq.QstnCore=w2.gateQstn
			WHERE sd.bitenforceskip <> 0 
			and w.skip_id = @skip 
			--and sq.qstncore in (51199,47176,47177,47193,47194)

			-- #ICHwork originally contains cases in which the gate is explicitly invoked. That is, the respondent answered the gate question with a response that instructed them to skip some questions
			-- now we need to add cases to #ICHwork in which the gate is implicitly invoked. That is, when the gate questions were appropriately skipped.
			-- so if any of the values we just updated are (1) themselves gate questions and (2) are unanswered, we should add new records to #ICHwork
			insert into #ICHwork
			select bt.questionform_id, bt.sampleunit_id, min(si.skip_id) as skip_id, sd.survey_id, 0 as bitFlag, bt.nrcQuestionCore, 0 as bitUndo
				--, min(bt.responseVal)
			from #ICHwork w
			join qp_prod.dbo.SkipQstns sq on w.skip_id=sq.Skip_id
			join #bubbletemp bt on w.questionform_id=bt.questionform_id and w.sampleunit_id=bt.sampleunit_id and sq.QstnCore=bt.nrcQuestionCore
			join #questionformtemp qf ON qf.questionform_id = bt.questionform_id 
			JOIN qp_prod.dbo.skipidentifier si ON qf.survey_id = si.survey_id
												  AND qf.datgenerated = si.datgenerated 
												  AND bt.nrcquestioncore = si.qstncore  --> the skipped question we just updated is also a gate question 
												  and bt.responseVal between 9090 and 9999 --> and it was unanswered (the -9 was changed to 9991, -8 was changed to 9992, etc.)
			JOIN qp_prod.dbo.survey_def sd ON si.survey_id = sd.survey_id 
			WHERE sd.bitenforceskip <> 0 
			and w.skip_id = @skip
			--and sq.qstncore in (51199,47176,47177,47193,47194)
			group by bt.questionform_id, bt.sampleunit_id, sd.survey_id, bt.nrcQuestionCore
			order by 1,2,3--,charindex(convert(varchar,sq.qstncore),'51199,47176,47177,47193,47194')

			-- we also need to add cases to work in which a nested gate is NOT invoked because it was inappropriately answered 
			-- so if any of the values we just updated are (1) themselves gate questions and (2) are answered in such a way that does NOT invoke the skip 
			-- these are cases in which we need to undo the previously executed offset (that is, SUBTRACT 10000 from the response) 
			insert into #ICHwork
			select bt.questionform_id, bt.sampleunit_id, min(si.skip_id) as skip_id, sd.survey_id, 0 as bitFlag, bt.nrcQuestionCore, 1 as bitUndo
				--, min(bt.responseVal), min(qf.DatGenerated)
			from #ICHwork w
			join qp_prod.dbo.SkipQstns sq on w.skip_id=sq.Skip_id
			join #bubbletemp bt on w.questionform_id=bt.questionform_id and w.sampleunit_id=bt.sampleunit_id and sq.QstnCore=bt.nrcQuestionCore
			join #questionformtemp qf ON qf.questionform_id = bt.questionform_id 
			JOIN qp_prod.dbo.skipidentifier si ON qf.survey_id = si.survey_id
												  AND qf.datgenerated = si.datgenerated 
												  AND bt.nrcquestioncore = si.qstncore  --> the skipped question we just updated is also a gate question 										  
			left join qp_prod.dbo.skipidentifier si2 on si2.Survey_id=si.Survey_id and si2.datGenerated=si.datGenerated and si2.qstncore=si.qstncore and bt.responseval-10000=si2.intResponseval
			JOIN qp_prod.dbo.survey_def sd ON si.survey_id = sd.survey_id 
			WHERE sd.bitenforceskip <> 0 
			and w.skip_id = @skip
			--and sq.qstncore in (51199,47176,47177,47193,47194)
			and bt.responseVal >= 10000 --> and the skipped question that is also a gate question was answered (it was answered and skipped over, so it has the 10000 offset) 										  
			and si2.intResponseval is NULL --> but it does not invoke the skip 
			group by bt.questionform_id, bt.sampleunit_id, sd.survey_id, bt.nrcQuestionCore
			order by 1,2,3--,charindex(convert(varchar,sq.qstncore),'51199,47176,47177,47193,47194')

			update #ICHwork set bitflag=@iteration where skip_id = @skip
		end

		update #bubbletemp set responseval = -4 where responseVal between 9991 and 9999
		UPDATE P set responseVal = t.responseVal
		from #bubbletemp t
		join bubbletemp p on t.QUESTIONFORM_ID=p.QUESTIONFORM_ID and t.SAMPLEUNIT_ID=p.SAMPLEUNIT_ID and t.nrcQuestionCore=p.nrcQuestionCore and t.ExtractFileID=p.ExtractFileID


	END -- if @@rowcount>0 (i.e. if #bubbletemp had any records in it)

	DROP TABLE #ICHwork 
	DROP TABLE #bubbletemp
	DROP TABLE #QuestionFormTemp

    -- drop table #validskippattern  
    EXEC dbo.Csp_processskippatterns_hhcahps @ExtractFileID 


	

	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2

    RETURN
GO