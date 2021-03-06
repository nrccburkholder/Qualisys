/*
	THIS IS TESTING AND PROOF OF CONCEPT ONLY
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


SELECT @QuestionFormID =210441364, @Q1=1,@Q2=1,@Q20=-9,@Q21=-9,@Q37=-9,@Q38=-9


IF OBJECT_ID('tempdb..#BubbleTemp') IS NOT NULL DROP TABLE #BubbleTemp
IF OBJECT_ID('tempdb..#QuestionFormTemp') IS NOT NULL DROP TABLE #QuestionFormTemp
IF OBJECT_ID('tempdb..#Work') IS NOT NULL DROP TABLE #Work
IF OBJECT_ID('tempdb..#SkipIdentifier') IS NOT NULL DROP TABLE #SkipIdentifier
IF OBJECT_ID('tempdb..#cte1') IS NOT NULL DROP TABLE #cte1
IF OBJECT_ID('tempdb..#cte2') IS NOT NULL DROP TABLE #cte2
IF OBJECT_ID('tempdb..#cte') IS NOT NULL DROP TABLE #cte
IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp

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





      --dbg 5/14/13-- -8's and -9's are now being offset, but we don't really want them to be. So we're now offsetting them back.
	  -- Modified 04/04/2014 CBC - Adjusts skipped question response values if values equals -5 or -6 by substracting 10000.
	  -- Modified 12/17/2014 DBG - Differentiate between "not answered" (-9) and "appropriately skipped" (-4)	
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
	  

		 select distinct'cte', bt.Questionform_id, bt.nrcQuestionCore as gateQstn, bt.responseVal as gateResponse
			   , case 
					when bt.responseVal % 10000=skipinfo.invokeResponse or bt.responseVal < 0 then 1 
			    else 0 end as gateInvoked
			   , skipinfo.skippedQstn, stqm.isIgnoredIfCloserNestingExists 
			   from #BubbleTemp bt
			   INNER JOIN #questionformtemp qf ON qf.questionform_id = bt.questionform_id 
										       and bt.ExtractFileID=qf.ExtractFileID
			   inner join (select si.survey_id, si.datGenerated, si.qstncore as [gate], si.intResponseval as [invokeResponse], sq.QstnCore as [skippedQstn]
								   from #SkipIdentifier si
								   INNER JOIN qp_prod.dbo.SkipQstns sq on sq.Skip_id = si.Skip_id) as skipinfo 
					  on bt.nrcQuestionCore=skipinfo.gate 
					  and qf.survey_id=skipinfo.survey_id 
					  and qf.DatGenerated=skipinfo.datGenerated
			   INNER JOIN qp_prod.dbo.SurveyTypeQuestionMappings stqm
					  on stqm.SurveyType_id = qf.SurveyType_id 
					  and stqm.QstnCore = bt.nrcQuestionCore
			   where bt.ExtractFileID = @ExtractFileID
			   and skipinfo.skippedQstn in (47176,47177)
				;


		with Skip_CTE as (
			   select distinct bt.Questionform_id, bt.nrcQuestionCore as gateQstn, bt.responseVal as gateResponse
			   , case 
					when bt.responseVal % 10000=skipinfo.invokeResponse or bt.responseVal < 0  then 1 
			    else 0 end as gateInvoked
			   , skipinfo.skippedQstn, stqm.isIgnoredIfCloserNestingExists 
			   from #BubbleTemp bt
			   INNER JOIN #questionformtemp qf ON qf.questionform_id = bt.questionform_id and bt.ExtractFileID=qf.ExtractFileID
			   inner join (select si.survey_id, si.datGenerated, si.qstncore as [gate], si.intResponseval as [invokeResponse], sq.QstnCore as [skippedQstn]
								   from #SkipIdentifier si
								   INNER JOIN qp_prod.dbo.SkipQstns sq on sq.Skip_id = si.Skip_id) as skipinfo 
					  on bt.nrcQuestionCore=skipinfo.gate 
					  and qf.survey_id=skipinfo.survey_id 
					  and qf.DatGenerated=skipinfo.datGenerated
			   INNER JOIN qp_prod.dbo.SurveyTypeQuestionMappings stqm
					  on stqm.SurveyType_id = qf.SurveyType_id and stqm.QstnCore = bt.nrcQuestionCore
			   where bt.ExtractFileID = @ExtractFileID
		)
		select 'update with cte', bt.*, cteP.*, cteGP.*, cteGP.*
		from #BubbleTemp bt
		inner join Skip_CTE cteP --P means Parent
			   on bt.nrcQuestionCore = cteP.skippedQstn and bt.QUESTIONFORM_ID = cteP.QuestionForm_id 
		inner join Skip_CTE cteGP --GP means Grandparent
			   on cteP.gateQstn = cteGP.skippedQstn and cteP.QuestionForm_id = cteGP.QuestionForm_id
		left join Skip_CTE cteGP2 --GP2 means 2nd Grandparent
			   on cteP.gateQstn = cteGP2.skippedQstn and cteP.QuestionForm_id = cteGP2.QuestionForm_id
		where bt.ExtractFileID = @ExtractFileID 
			   --and cteP.isIgnoredIfCloserNestingExists = 0   --> we don't care whether the closest skip should be ignored if a closer skip exists or not (because there is no closer skip) 
			   and cteGP.isIgnoredIfCloserNestingExists = 1    --> we only care if the outer skip should be ignored if a closer skip exists
			   and bt.responseVal = -4
			   and cteGP.gateInvoked = 1 -- the outer skip was invoked
			   and cteP.gateInvoked = 0 -- but the closer skip was not 
			   ;

	with Skip_CTE as (
			   select distinct bt.Questionform_id, bt.nrcQuestionCore as gateQstn, bt.responseVal as gateResponse
			   , case when bt.responseVal % 10000=skipinfo.invokeResponse or bt.responseVal < 0  then 1 else 0 end as gateInvoked
			   , skipinfo.skippedQstn, stqm.isIgnoredIfCloserNestingExists 
			   from #BubbleTemp bt
			   INNER JOIN #questionformtemp qf ON qf.questionform_id = bt.questionform_id and bt.ExtractFileID=qf.ExtractFileID
			   inner join (select si.survey_id, si.datGenerated, si.qstncore as [gate], si.intResponseval as [invokeResponse], sq.QstnCore as [skippedQstn]
								   from #SkipIdentifier si
								   INNER JOIN qp_prod.dbo.SkipQstns sq on sq.Skip_id = si.Skip_id) as skipinfo 
					  on bt.nrcQuestionCore=skipinfo.gate 
					  and qf.survey_id=skipinfo.survey_id 
					  and qf.DatGenerated=skipinfo.datGenerated
			   INNER JOIN qp_prod.dbo.SurveyTypeQuestionMappings stqm
					  on stqm.SurveyType_id = qf.SurveyType_id and stqm.QstnCore = bt.nrcQuestionCore
			   where bt.ExtractFileID = @ExtractFileID
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
			   and cteGP.gateInvoked = 1 -- the outer skip was invoked
			   and cteP.gateInvoked = 0 -- but the closer skip was not 


select @name, *, @Q1 as 'Q1(51198)', @Q2 as 'Q2(51199)', @Q20 as 'Q20(47176)', @Q21 as 'Q21(47177)', @Q37 as 'Q37(47193)', @Q38 as 'Q21(47194)' 
from #BubbleTemp 
WHERE nrcQuestionCore IN (51198,51199)

select @name, *, @Q1 as 'Q1(51198)', @Q2 as 'Q2(51199)', @Q20 as 'Q20(47176)', @Q21 as 'Q21(47177)', @Q37 as 'Q37(47193)', @Q38 as 'Q21(47194)' 
from #BubbleTemp 
WHERE nrcQuestionCore IN (47176,47177,47193,47194)
---- ATL-962 Modify ICH Submission Skip Coding -------------- END


    RETURN

GO