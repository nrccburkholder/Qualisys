/*
	THIS IS TESTING AND PROOF OF CONCEPT ONLY
	 

	There are two areas where refactors were done.

	One refactor is where responseVal is set to -4 (appropriately skipped).

	The other is where we evaluate the parent and grandparent response to determine whether it should remain appropriately skipped or set to missing.

	There might be more efficient and elegant ways to accomplish this, but the results match Dana's test cases. 


*/
USE [QP_Prod]
GO

DECLARE @ExtractFileID INT 
DECLARE @QuestionFormID INT
DECLARE @name varchar(50)


SET @ExtractFileID = 1


DECLARE @Q1 int  
DECLARE @Q2 int 
DECLARE @Q20 int
DECLARE @Q21 int
DECLARE @Q37 int
DECLARE @Q38 int



-- Dana's test cases
SELECT @QuestionFormID =210441364, @Q1=1,@Q2=1,@Q20=-9,@Q21=-9,@Q37=-9,@Q38=-9
--SELECT @QuestionFormID =210441366, @Q1=1,@Q2=1,@Q20=3,@Q21=-9,@Q37=1,@Q38=-9
--SELECT @QuestionFormID =210441367, @Q1=1,@Q2=1,@Q20=1,@Q21=-9,@Q37=2,@Q38=-9
--SELECT @QuestionFormID =210441368, @Q1=1,@Q2=2,@Q20=-9,@Q21=-9,@Q37=-9,@Q38=1
--SELECT @QuestionFormID =210441369, @Q1=1,@Q2=2,@Q20=3,@Q21=-9,@Q37=3,@Q38=1
--SELECT @QuestionFormID =210441370, @Q1=1,@Q2=2,@Q20=1,@Q21=-9,@Q37=2,@Q38=1
--SELECT @QuestionFormID =210441371, @Q1=2,@Q2=1,@Q20=-9,@Q21=-9,@Q37=-9,@Q38=-9
--SELECT @QuestionFormID =210441372, @Q1=2,@Q2=1,@Q20=3,@Q21=-9,@Q37=1,@Q38=1
--SELECT @QuestionFormID =210441373, @Q1=2,@Q2=1,@Q20=1,@Q21=-9,@Q37=2,@Q38=1
--SELECT @QuestionFormID =210441374, @Q1=2,@Q2=2,@Q20=-9,@Q21=-9,@Q37=-9,@Q38=-9
--SELECT @QuestionFormID =210441376, @Q1=2,@Q2=2,@Q20=3,@Q21=-9,@Q37=1,@Q38=1
--SELECT @QuestionFormID =210441377, @Q1=2,@Q2=2,@Q20=1,@Q21=-9,@Q37=2,@Q38=1
--SELECT @QuestionFormID =210441378, @Q1=-9,@Q2=5,@Q20=-9,@Q21=-9,@Q37=-9,@Q38=-9
--SELECT @QuestionFormID =210441379, @Q1=-9,@Q2=5,@Q20=3,@Q21=-9,@Q37=1,@Q38=1
--SELECT @QuestionFormID =210441380, @Q1=-9,@Q2=5,@Q20=2,@Q21=-9,@Q37=2,@Q38=1
--SELECT @QuestionFormID =210441381, @Q1=-9,@Q2=2,@Q20=-9,@Q21=-9,@Q37=-9,@Q38=-9
--SELECT @QuestionFormID =210441382, @Q1=-9,@Q2=2,@Q20=1,@Q21=-9,@Q37=1,@Q38=1
--SELECT @QuestionFormID =210441383, @Q1=-9,@Q2=2,@Q20=1,@Q21=-9,@Q37=2,@Q38=1
--SELECT @QuestionFormID =210441384, @Q1=-9,@Q2=-9,@Q20=-9,@Q21=-9,@Q37=-9,@Q38=-9
--SELECT @QuestionFormID =210441385, @Q1=-9,@Q2=-9,@Q20=3,@Q21=-9,@Q37=3,@Q38=1
--SELECT @QuestionFormID =210441386, @Q1=-9,@Q2=-9,@Q20=1,@Q21=-9,@Q37=2,@Q38=1
--SELECT @QuestionFormID =210441387, @Q1=3,@Q2=-9,@Q20=-9,@Q21=-9,@Q37=-9,@Q38=-9
--SELECT @QuestionFormID =210441388, @Q1=3,@Q2=-9,@Q20=3,@Q21=-9,@Q37=1,@Q38=1
--SELECT @QuestionFormID =210441414, @Q1=1,@Q2=-9,@Q20=1,@Q21=-9,@Q37=2,@Q38=1
--SELECT @QuestionFormID =210441415, @Q1=2,@Q2=-9,@Q20=1,@Q21=-9,@Q37=2,@Q38=1
--SELECT @QuestionFormID =210441416, @Q1=2,@Q2=-9,@Q20=1,@Q21=-9,@Q37=2,@Q38=1
--SELECT @QuestionFormID =210441417, @Q1=2,@Q2=-9,@Q20=-9,@Q21=-9,@Q37=-9,@Q38=1


IF OBJECT_ID('tempdb..#BubbleTemp') IS NOT NULL DROP TABLE #BubbleTemp
IF OBJECT_ID('tempdb..#QuestionFormTemp') IS NOT NULL DROP TABLE #QuestionFormTemp
IF OBJECT_ID('tempdb..#Work') IS NOT NULL DROP TABLE #Work
IF OBJECT_ID('tempdb..#SkipIdentifier') IS NOT NULL DROP TABLE #SkipIdentifier
IF OBJECT_ID('tempdb..#cte1') IS NOT NULL DROP TABLE #cte1
IF OBJECT_ID('tempdb..#cte2') IS NOT NULL DROP TABLE #cte2
IF OBJECT_ID('tempdb..#cte') IS NOT NULL DROP TABLE #cte
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
IF OBJECT_ID('tempdb..#temp2') IS NOT NULL DROP TABLE #temp2
IF OBJECT_ID('tempdb..#temp3') IS NOT NULL DROP TABLE #temp3

CREATE TABLE [#BubbleTemp](
	[ExtractFileID] [int] NOT NULL,
	[LithoCode] [int] NOT NULL,
	[SAMPLEUNIT_ID] [int] NULL,
	[nrcQuestionCore] [int] NOT NULL,
	[responseVal] [int] NOT NULL,
	[QUESTIONFORM_ID] [int] NOT NULL
) ON [PRIMARY]


INSERT INTO [#BubbleTemp]
           ([ExtractFileID]
           ,[LithoCode]
           ,[SAMPLEUNIT_ID]
           ,[nrcQuestionCore]
           ,[responseVal]
           ,[QUESTIONFORM_ID])
SELECT @ExtractFileID, sm.STRLITHOCODE, ss.SAMPLEUNIT_ID,qr.QSTNCORE,qr.INTRESPONSEVAL, qf.QUESTIONFORM_ID
FROM QP_Prod.dbo.QUESTIONRESULt qr
INNER JOIN dbo.QUESTIONFORM qf on qf.QUESTIONFORM_ID = qr.QUESTIONFORM_ID
INNER JOIN dbo.SAMPLEPOP sp on qf.SAMPLEPOP_ID = sp.SAMPLEPOP_ID
INNER JOIN QP_PROD.dbo.SENTMailing sm on sm.SENTMAIL_ID = qf.SENTMAIL_ID
INNER JOIN dbo.SELECTEDSAMPLE ss on (ss.SAMPLESET_ID = sp.SAMPLESET_ID and ss.POP_ID = sp.POP_ID)
where qf.QUESTIONFORM_ID = @QuestionFormID


CREATE TABLE [#QuestionFormTemp](
	[ExtractFileID] [int] NOT NULL,
	[QUESTIONFORM_ID] [int] NOT NULL,
	[SAMPLEPOP_ID] [int] NOT NULL,
	[strLithoCode] [nvarchar](100) NOT NULL,
	[isComplete] [nvarchar](5) NULL,
	[RECEIPTTYPE_ID] [int] NULL,
	[returnDate] [datetime] NULL,
	[DatMailed] [datetime] NULL,
	[DatExpire] [datetime] NULL,
	[DatGenerated] [datetime] NULL,
	[DatPrinted] [datetime] NULL,
	[DatBundled] [datetime] NULL,
	[DatUndeliverable] [datetime] NULL,
	[DatFirstMailed] [datetime] NULL,
	[DaysFromFirstMailing] [int] NULL,
	[DaysFromCurrentMailing] [int] NULL,
	[SURVEY_ID] [int] NULL,
	[SurveyType_id] [int] NULL,
	[IsDeleted] [bit] NULL,
	[LangID] [int] NULL
) 

INSERT INTO [#QuestionFormTemp]
           ([ExtractFileID]
           ,[QUESTIONFORM_ID]
           ,[SAMPLEPOP_ID]
           ,[strLithoCode]
		   ,[DatGenerated]
           ,[SURVEY_ID]
           ,[SurveyType_id])
SELECT @ExtractFileID, qf.QUESTIONFORM_ID, qf.SAMPLEPOP_ID,sm.STRLITHOCODE, sm.DATGENERATED, qf.SURVEY_ID, 8
FROM dbo.QUESTIONFORM qf
INNER JOIN dbo.SENTMailing sm on sm.SENTMAIL_ID = qf.SENTMAIL_ID
where qf.QUESTIONFORM_ID = @QuestionFormID




update bt
	SET bt.responseVal = @Q1
from #BubbleTemp bt where nrcQuestionCore = 51198 -- Q1

update bt
	SET bt.responseVal = @Q2
from #BubbleTemp bt where nrcQuestionCore = 51199 -- Q2


update bt
	SET bt.responseVal = @Q20
from #BubbleTemp bt where nrcQuestionCore = 47176 -- Q20

update bt
	SET bt.responseVal = @Q21
from #BubbleTemp bt where nrcQuestionCore = 47177 -- Q21


update bt
	SET bt.responseVal = @Q37
from #BubbleTemp bt where nrcQuestionCore = 47193 -- Q37

update bt
	SET bt.responseVal = @Q38
from #BubbleTemp bt where nrcQuestionCore = 47194 -- Q38



select *
	INTO #SkipIdentifier
from qp_prod.dbo.SkipIdentifier
where Survey_id = 20732


--select 'skipidentifier',* from #skipIdentifier

	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);


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
    FROM   #bubbletemp qr  
           INNER JOIN #questionformtemp qf           ON qf.questionform_id = qr.questionform_id 
           INNER JOIN #skipidentifier si ON qf.survey_id = si.survey_id
                                                       AND qf.datgenerated = si.datgenerated 
                                                       AND qr.nrcquestioncore = si.qstncore 
                                                       AND (qr.responseval = si.intresponseval 
															OR (qr.responseval IN ( -8, -9))
															OR (qr.responseval IN (-5, -6)  AND NOT qr.nrcquestioncore = 50218) ) -- Modified 04/04/2014 CBC
           INNER JOIN qp_prod.dbo.survey_def sd     ON si.survey_id = sd.survey_id 
    WHERE  sd.bitenforceskip <> 0 
           AND qf.extractfileid = @ExtractFileID 
           AND qr.extractfileid = @ExtractFileID 



print 'creating indexes on #work'

    CREATE NONCLUSTERED INDEX idx_w ON #work (questionform_id ASC, sampleunit_id ASC, skip_id ASC ) 

-- DRH 01/21/2015 ... two new indexes for #work
CREATE NONCLUSTERED INDEX idx2_w ON #work (bitFlag ASC)
CREATE NONCLUSTERED INDEX idx4_w ON #work (bitFlag ASC, questionform_id ASC, sampleunit_id ASC, skip_id ASC) INCLUDE (survey_id)

print 'indexes created on #work'

	--SELECT 'work',* FROM #work

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
            FROM   #bubbletemp qr, 
                   qp_prod.dbo.skipqstns sq 
            WHERE  qr.extractfileid = @ExtractFileID 
                   AND @qf = qr.questionform_id 
                   AND @su = qr.sampleunit_id 
                   AND @sk = Skip_id 
                   AND sq.qstncore = qr.nrcquestioncore 
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

          -- valid skip pattern gateway after last Update loop  
          IF ( 
  
             SELECT Count(*) 
              FROM   #bubbletemp qr 
                     INNER JOIN #questionformtemp qf            ON qf.questionform_id = qr.questionform_id 
                     INNER JOIN #skipidentifier si  ON qf.survey_id = si.survey_id
                                                                  AND qf.datgenerated = si.datgenerated 
                                                                  AND qr.nrcquestioncore = si.qstncore
                                                       AND (qr.responseval = si.intresponseval 
															OR (qr.responseval IN ( -8, -9))
															OR (qr.responseval IN (-5, -6)  AND NOT qr.nrcquestioncore = 50218) ) -- Modified 04/04/2014 CBC
                     INNER JOIN qp_prod.dbo.survey_def sd      ON si.survey_id = sd.survey_id 
                     INNER JOIN qp_prod.dbo.skipqstns sq       ON si.skip_id = sq.skip_id 
                     INNER JOIN #skipidentifier si2 ON sq.qstncore = si2.qstncore 
                                                                  AND si2.skip_id = @sk 
              WHERE  sd.bitenforceskip <> 0 
                     AND qr.questionform_id = @qf 
                     AND qf.extractfileid = @ExtractFileID 
                     AND qr.extractfileid = @ExtractFileID) > 0 
					 
            SET @bitUpdate = 0 
          ELSE 
            SET @bitUpdate = 1 
      END 

	  select 'non-refactored join',BT.nrcQuestionCore, bt.responseVal, bt.QUESTIONFORM_ID, sq.Skip_id, sq.QstnCore, p.nrcQuestionCore parentQstnCore, p.gateResponse parentGateResponse, p.Skip_id parentSkip_id, p.invokeResponse
		,case when bt.responseval in (9991,9992) then -- 9991 is -9 (not answered) and 9992 is -8 (single respone question with multiple marks)
								case when p.gateResponse = -9 then	-- both with the +10000 offset. Both of these should be set to -4 (appropriately skipped) *unless the gatequestion was left blank.
									bt.responseval - 10000
								else
									-4									
								end  
							else 
								responseVal - 10000
							end	as newResponseVal			
      FROM   #bubbletemp bt 
             INNER JOIN qp_prod.dbo.skipqstns sq ON sq.qstncore = bt.nrcquestioncore 
			 INNER JOIN (select bt1.questionform_id, bt1.sampleunit_id,bt1.nrcQuestionCore, bt1.responseVal as gateResponse, si.Skip_id, si.intResponseval invokeResponse
						  from #BubbleTemp bt1
						  inner join #skipidentifier si on si.qstncore = bt1.nrcquestioncore
						  ) p on p.Skip_id = sq.Skip_id
             INNER JOIN #work w                  ON bt.questionform_id = w.questionform_id 
                                                    AND bt.sampleunit_id = w.sampleunit_id 
                                                    AND sq.skip_id = w.skip_id 
      WHERE  bt.responseval IN ( 9992, 9991, 9995, 9994 ) 
             AND bt.extractfileid = @ExtractFileID 
	order by nrcQuestionCore;

	/* begin refactor part 1 */

	/*

	  This is the original UPDATE that would replace 9991 and 9992 values with -4. 

	  UPDATE bt 
      SET    responseVal = case when bt.responseval in (9991,9992) then -4 else responseVal - 10000 end	-- 9991 is -9 (not answered) and 9992 is -8 (single respone question with multiple marks) 
																										-- both with the +10000 offset. Both of these should be set to -4 (appropriately skipped)
      FROM   #bubbletemp bt 
             INNER JOIN qp_prod.dbo.skipqstns sq ON sq.qstncore = bt.nrcquestioncore 
             INNER JOIN #work w                  ON bt.questionform_id = w.questionform_id 
                                                    AND bt.sampleunit_id = w.sampleunit_id 
                                                    AND sq.skip_id = w.skip_id 
      WHERE  bt.responseval IN ( 9992, 9991, 9995, 9994 ) 
             AND bt.extractfileid = @ExtractFileID ;


	*/

	/*
		Two modifications to this section.

		The first was to look at the responseVal of the gate question.  If the gate question was left blank, then -4 (appropriately skipped) doesn't apply, so we just keep the value and don't update it.
		For a lot of the test cases it didn't make a difference, but when -9 is the answer to a gate question, it would try to treat it as appropriately skipped, which it technically isn't. 

		The second was to separate the join with bubbletemp into two cases: 
			1) where the parent's invoke response was the same as the parent's gate response. 
			2) where the gate response was -9

		A side-effect of checking the gate response of the parent was a join that included multiple records for each qstncore (one for each parent and each parent's invokeResponse). 
		
		As an example, we'll use QuestionForm_ID 210441378   

		The responses were: 
		Q1  = -9  (51198)
		Q2  =  5  (51199)
		Q20	= -9  (47176)
		Q21 = -9  (47177)


		QstnCore	parentQstnCore	parentGateResponse	parentSkip_id	invokeResponse	newResponseVal
		47177			51198				-9				9848173			1				-9
		47177			51198				-9				9848174			3				-9
		47177			51199				10005			9848176			5				-4
		47177			47176				9991			9848177			3				-4
		47177			47176				9991			9848178			4				-4

		So this is showing us all the potential updates that could be made to the responseVal for 47177.  But since this is an update that's joined on qstncore, we have no guarantee
		that the correct value is going to find its way back into BubbleTemp. 

		As a matter of fact, if we just did the Update based on these records above, the responseVal for 47177 would become -9, when it should actually be -4.

		The only answer above which invoked a skip was for 51199 (Q2).  The answer to 51198 (Q1) was -9, which does not invoke the skip.  The answer to 47176 (Q20) was also -9 (represented
		by 9991), so it did not invoke the skip either.  So the nearest question that invoked the skip was 51199.  

		So, to avoid erroneous updates, we break the SELECT into pieces, selecting into a temp table only those qstncores where their parents' responses invoked the skip.

		Then we select into a 2nd temp table those qstncores where their parents' responses were -9.

		We join those into a 3rd temp table where we have only one record for each nrcQuestionCore. Ultimately temp3 contains all records from temp1 plus records from temp2 that don't have a matching qstncore in temp1.

		Finally, we join that with BubbleTemp and update the responseVal.


		 
	*/

	select BT.nrcQuestionCore, bt.responseVal, bt.QUESTIONFORM_ID, sq.Skip_id, sq.QstnCore, p.nrcQuestionCore parentQstnCore, p.gateResponse parentGateResponse, p.Skip_id parentSkip_id, p.invokeResponse
		,case when bt.responseval in (9991,9992) then -- 9991 is -9 (not answered) and 9992 is -8 (single respone question with multiple marks)
								case when p.gateResponse = -9 then	-- both with the +10000 offset. Both of these should be set to -4 (appropriately skipped) *unless the gatequestion was left blank.
									bt.responseval - 10000
								else
									-4									
								end  
							else 
								responseVal - 10000
							end	as newResponseVal			
	into #temp
	FROM   #bubbletemp bt 
             INNER JOIN qp_prod.dbo.skipqstns sq ON sq.qstncore = bt.nrcquestioncore 
			 INNER JOIN (select bt1.questionform_id, bt1.sampleunit_id,bt1.nrcQuestionCore, bt1.responseVal as gateResponse, si.Skip_id, si.intResponseval invokeResponse
						  from #BubbleTemp bt1
						  inner join #skipidentifier si on si.qstncore = bt1.nrcquestioncore
						  ) p on p.Skip_id = sq.Skip_id
             INNER JOIN #work w                  ON bt.questionform_id = w.questionform_id 
                                                    AND bt.sampleunit_id = w.sampleunit_id 
                                                    AND sq.skip_id = w.skip_id 
      WHERE  bt.responseval IN ( 9992, 9991, 9995, 9994 ) 
             AND bt.extractfileid = @ExtractFileID
			 and (p.invokeResponse = p.gateResponse % 10000)

	select 't1',* from #temp order by nrcQuestionCore

	select BT.nrcQuestionCore, bt.responseVal, bt.QUESTIONFORM_ID, sq.Skip_id, sq.QstnCore, p.nrcQuestionCore parentQstnCore, p.gateResponse parentGateResponse, p.Skip_id parentSkip_id, p.invokeResponse
		,case when bt.responseval in (9991,9992) then -- 9991 is -9 (not answered) and 9992 is -8 (single respone question with multiple marks)
								case when p.gateResponse = -9 then	-- both with the +10000 offset. Both of these should be set to -4 (appropriately skipped) *unless the gatequestion was left blank.
									bt.responseval - 10000
								else
									-4									
								end  
							else 
								responseVal - 10000
							end	as newResponseVal			
	into #temp2
	FROM   #bubbletemp bt 
             INNER JOIN qp_prod.dbo.skipqstns sq ON sq.qstncore = bt.nrcquestioncore 
			 INNER JOIN (select bt1.questionform_id, bt1.sampleunit_id,bt1.nrcQuestionCore, bt1.responseVal as gateResponse, si.Skip_id, si.intResponseval invokeResponse
						  from #BubbleTemp bt1
						  inner join #skipidentifier si on si.qstncore = bt1.nrcquestioncore
						  ) p on p.Skip_id = sq.Skip_id
             INNER JOIN #work w                  ON bt.questionform_id = w.questionform_id 
                                                    AND bt.sampleunit_id = w.sampleunit_id 
                                                    AND sq.skip_id = w.skip_id 
      WHERE  bt.responseval IN ( 9992, 9991, 9995, 9994 ) 
             AND bt.extractfileid = @ExtractFileID
			 and p.gateResponse = -9


	select 't2',* from #temp2 order by nrcQuestionCore

		select *
		into #temp3
		from #temp t1
		union 
		select * 
		from (select t2.*
		 from #temp2 t2
		 LEFT JOIN #temp t1 on (t2.QUESTIONFORM_ID = t1.QUESTIONFORM_ID and t2.nrcQuestionCore = t1.nrcQuestionCore and t2.responseVal = t1.responseVal and t2.QstnCore = t1.QstnCore 
		 )
		 WHERE t1.nrcQuestionCore is null) t2

	select 't3',* from #temp3 order by nrcQuestionCore


	  UPDATE  bt
	  SET    bt.responseVal = t.newResponseVal																					
	  FROM  #bubbletemp bt
	  INNER JOIN #temp3 t on (t.nrcQuestionCore = bt.nrcQuestionCore and t.QUESTIONFORM_ID = bt.QUESTIONFORM_ID and t.responseVal = bt.responseVal)

	  /* end refactor part 1 */



	 select 'after refactor1 update', bt1.*
	 from #BubbleTemp bt1
	 order by nrcQuestionCore
	 
	 /* begin refactor part 2 */

	 /*
		This refactor in this section is similar to the first refactor in that the original CTE would result in multiple records for a qstncore.

		Using Qquestionform_id 210441378 as an example.

		The WHERE clause in the join was as follows:
		and cteGP.isIgnoredIfCloserNestingExists = 1    --> we only care if the outer skip should be ignored if a closer skip exists
	    and bt.responseVal = -4
		and cteGP.gateInvoked = 1 -- the outer skip was invoked
		and cteP.gateInvoked = 0 -- but the closer skip was not 

		However, because there were mutliple records for a qstncore in the CTE (because some questions have multiple skip responses), sometimes the wrong record was being joined with these criteria.  
		Or a match was found that really wasn't applicable. (un-refactored-cte).  In this case, gateQstn 51199 gateResponse 10005 shows two records.  One where gateInvoked = 1, the other where gateInvoked = 0.  
		The two records are appearing because there are two responses that would invoke the skip for 51199.

		So again, we break it into pieces and to ensure we only have one qstncore with the appropriate gateResponse and gateInvoked values.
		
		First, we get only those records that match this condition:		(bt.responseVal % 10000 = skipinfo.invokeResponse or bt.responseVal < 0)  

		This will return all -9,-4,-8 plus all those records where the responseVal would invoke the skip (cte1)

		Then we get those that match this condition:					(bt.responseVal % 10000 <> skipinfo.invokeResponse or bt.responseVal < 0)

		This will return all -9,-4,-8 plus all those records where the responseVal DOES NOT invoke the skip. (cte2)

		We then UNION the 1st set of results with a left join between the 2nd set and 1st set (in which we eliminate matches from the 1st set).   (cte)

		 

	 */

	 select distinct 'un-refactored-cte', bt.Questionform_id
						  , bt.nrcQuestionCore as gateQstn
						  , bt.responseVal as gateResponse
						 , case 
								when bt.responseVal % 10000=skipinfo.invokeResponse then 1 
							else 0 end as gateInvoked
					     , skipinfo.skippedQstn
						 --, skipinfo.invokeResponse
						 , stqm.isIgnoredIfCloserNestingExists
			   from #BubbleTemp bt
			   INNER JOIN #questionformtemp qf ON qf.questionform_id = bt.questionform_id and bt.ExtractFileID=qf.ExtractFileID
			   inner join (select si.survey_id, si.datGenerated, si.qstncore as [gate], si.intResponseval as [invokeResponse], sq.QstnCore as [skippedQstn], si.Skip_id
								   from #SkipIdentifier si
								   INNER JOIN qp_prod.dbo.SkipQstns sq on sq.Skip_id = si.Skip_id) as skipinfo on bt.nrcQuestionCore=skipinfo.gate 
																												  and qf.survey_id=skipinfo.survey_id 
																												  and qf.DatGenerated=skipinfo.datGenerated
			   INNER JOIN qp_prod.dbo.SurveyTypeQuestionMappings stqm
					  on stqm.SurveyType_id = qf.SurveyType_id and stqm.QstnCore = bt.nrcQuestionCore
			   where bt.ExtractFileID = @ExtractFileID
			   and skippedQstn in (47177);


	 select distinct bt.Questionform_id
						  , bt.nrcQuestionCore as gateQstn
						  , bt.responseVal as gateResponse
						 , case 
								when bt.responseVal % 10000=skipinfo.invokeResponse then 1 
							else 0 end as gateInvoked
					     , skipinfo.skippedQstn
						 --, skipinfo.invokeResponse
						 , stqm.isIgnoredIfCloserNestingExists
			   into #cte1
			   from #BubbleTemp bt
			   INNER JOIN #questionformtemp qf ON qf.questionform_id = bt.questionform_id and bt.ExtractFileID=qf.ExtractFileID
			   inner join (select si.survey_id, si.datGenerated, si.qstncore as [gate], si.intResponseval as [invokeResponse], sq.QstnCore as [skippedQstn], si.Skip_id
								   from #SkipIdentifier si
								   INNER JOIN qp_prod.dbo.SkipQstns sq on sq.Skip_id = si.Skip_id) as skipinfo on bt.nrcQuestionCore=skipinfo.gate 
																												  and qf.survey_id=skipinfo.survey_id 
																												  and qf.DatGenerated=skipinfo.datGenerated
																												  and (bt.responseVal % 10000=skipinfo.invokeResponse or bt.responseVal < 0)
			   INNER JOIN qp_prod.dbo.SurveyTypeQuestionMappings stqm
					  on stqm.SurveyType_id = qf.SurveyType_id and stqm.QstnCore = bt.nrcQuestionCore
			   where bt.ExtractFileID = @ExtractFileID

	select 'cte1',* from #cte1 where skippedQstn in (47177);

	select distinct bt.Questionform_id
						  , bt.nrcQuestionCore as gateQstn
						  , bt.responseVal as gateResponse
						 , case 
								when bt.responseVal % 10000=skipinfo.invokeResponse then 1 
							else 0 end as gateInvoked
					     , skipinfo.skippedQstn
						 , stqm.isIgnoredIfCloserNestingExists
			   into #cte2
			   from #BubbleTemp bt
			   INNER JOIN #questionformtemp qf ON qf.questionform_id = bt.questionform_id and bt.ExtractFileID=qf.ExtractFileID
			   inner join (select si.survey_id, si.datGenerated, si.qstncore as [gate], si.intResponseval as [invokeResponse], sq.QstnCore as [skippedQstn], si.Skip_id
								   from #SkipIdentifier si
								   INNER JOIN qp_prod.dbo.SkipQstns sq on sq.Skip_id = si.Skip_id) as skipinfo on bt.nrcQuestionCore=skipinfo.gate 
																												  and qf.survey_id=skipinfo.survey_id 
																												  and qf.DatGenerated=skipinfo.datGenerated
																												  and (bt.responseVal % 10000<>skipinfo.invokeResponse or bt.responseVal < 0)
			   INNER JOIN qp_prod.dbo.SurveyTypeQuestionMappings stqm
					  on stqm.SurveyType_id = qf.SurveyType_id and stqm.QstnCore = bt.nrcQuestionCore
			   where bt.ExtractFileID = @ExtractFileID

		select 'cte2',* from #cte2 where skippedQstn in (47177);

		select *
		into #cte
		from #cte1 cte1
		union 
		select * from (select cte2.*
		 from #cte2 cte2
		 LEFT JOIN #cte1 cte1 on (cte2.QUESTIONFORM_ID = cte1.QUESTIONFORM_ID and cte2.gateResponse = cte1.gateResponse and cte2.skippedQstn = cte1.skippedQstn 
			and cte2.gateQstn = cte1.gateQstn 
		 )
		 WHERE cte1.gateQstn is null) cte2;
		
		select 'cte',* from #cte 
		where skippedQstn in (47177);

		/*
	    with Skip_CTE2 as (
			   select *
			   from #cte
		)
		select bt.*, 'cteP',cteP.*, 'cteGP',cteGP.*
		from #BubbleTemp bt
		inner join Skip_CTE2 cteP --P means Parent
			   on bt.nrcQuestionCore = cteP.skippedQstn and bt.QUESTIONFORM_ID = cteP.QuestionForm_id 
		inner join Skip_CTE2 cteGP --GP means Grandparent
			   on cteP.gateQstn = cteGP.skippedQstn and cteP.QuestionForm_id = cteGP.QuestionForm_id 
		where bt.ExtractFileID = @ExtractFileID
			   --and cteP.isIgnoredIfCloserNestingExists = 0   --> we don't care whether the closest skip should be ignored if a closer skip exists or not (because there is no closer skip) 
			   and cteGP.isIgnoredIfCloserNestingExists = 1    --> we only care if the outer skip should be ignored if a closer skip exists
			   and bt.responseVal = -4
			   and cteP.gateResponse <> -4
			   and cteGP.gateInvoked = 1 -- the outer skip was invoked
			   and cteP.gateInvoked = 0 -- but the closer skip was not   
			   ; 
	*/

	 with Skip_CTE as (
			   select *
			   from #cte
		)
		update bt set responseVal = -9
		from #BubbleTemp bt
		inner join Skip_CTE cteP --P means Parent
			   on bt.nrcQuestionCore = cteP.skippedQstn and bt.QUESTIONFORM_ID = cteP.QuestionForm_id 
		inner join Skip_CTE cteGP --GP means Grandparent
			   on cteP.gateQstn = cteGP.skippedQstn and cteP.QuestionForm_id = cteGP.QuestionForm_id 
		where bt.ExtractFileID = @ExtractFileID
			   --and cteP.isIgnoredIfCloserNestingExists = 0   --> we don't care whether the closest skip should be ignored if a closer skip exists or not (because there is no closer skip) 
			   and cteGP.isIgnoredIfCloserNestingExists = 1    --> we only care if the outer skip should be ignored if a closer skip exists
			   and bt.responseVal = -4
			   and cteP.gateResponse <> -4
			   and cteGP.gateInvoked = 1 -- the outer skip was invoked
			   and cteP.gateInvoked = 0 -- but the closer skip was not 

	/* end refactor part 2 */


select bt.QUESTIONFORM_ID, bt.nrcQuestionCore, bt.responseVal -- Q1 & Q2
from #BubbleTemp bt 
WHERE nrcQuestionCore IN (51198,51199)

select bt.QUESTIONFORM_ID, bt.nrcQuestionCore, bt.responseVal -- Q20, Q21, Q37, Q38
from #BubbleTemp bt
WHERE nrcQuestionCore IN (47176,47177,47193,47194)


RETURN

GO