
USE QP_PROD

GO


DECLARE
      @Survey_id INT
      ,@PaperConfig_id INT
      ,@MailingDate DATETIME
      ,@BundleDate DATETIME
      ,@PostalBundle VARCHAR(10) = NULL
      ,@startLitho VARCHAR(10) = NULL
      ,@endLitho VARCHAR(10) = NULL

  SET @Survey_id = 16159
  SET @PaperConfig_id = 2
  SET @MailingDate = '2016-10-11 11:00:00.000'
  SET @BundleDate = '2016-10-11 15:31:01.100'
  SET @PostalBundle = 'PVEND'
  SET @startLitho = '158246473'
  SET @endLitho = '158246492'

DECLARE @rc INT, @err INT
DECLARE @MailingDateMidnight DATETIME
SELECT @MailingDateMidnight = DATEADD(ms, - DATEPART(ms, @MailingDate), @MailingDate)
SELECT @MailingDateMidnight = DATEADD(ss, - DATEPART(ss, @MailingDate), @MailingDateMidnight)
SELECT @MailingDateMidnight = DATEADD(mi, - DATEPART(mi, @MailingDate), @MailingDateMidnight)
SELECT @MailingDateMidnight = DATEADD(hh, - DATEPART(hh, @MailingDate), @MailingDateMidnight)

 IF OBJECT_ID('tempdb..#SentMailing') IS NOT NULL
                        DROP TABLE #SentMailing

 IF OBJECT_ID('tempdb..#MailingCount') IS NOT NULL
                        DROP TABLE #MailingCount

/* Determine the SentMailings based on the litho range passed */
CREATE TABLE #SentMailing (
      SentMail_ID INT
      ,INTPAGES INT
      ,Methodology_ID INT
      ,SCHEDULEDMailing_ID INT
      ,DATMailED DATETIME
      ,Survey_id INT
      )

IF @@ERROR <> 0
BEGIN
      SET TRANSACTION ISOLATION LEVEL READ COMMITTED --DIRTY READ OFF     
      RETURN
END

/* Temp table for saving Mailing count */
CREATE TABLE #MailingCount (
      DATMailED DATETIME
      ,Survey_ID INT
      ,INTPAGES INT
      ,MailCOUNT INT
      ,MailingStep_ID INT
      ,SampleSet_ID INT
      )

IF @@ERROR <> 0
BEGIN
      SET TRANSACTION ISOLATION LEVEL READ COMMITTED --DIRTY READ OFF     
      RETURN
END

IF @PostalBundle = 'GP'
BEGIN
print 'sentmailing 0'
      INSERT INTO #SentMailing (
            SentMail_ID
            ,INTPAGES
            ,Methodology_ID
            ,SCHEDULEDMailing_ID
            ,DATMailED
            ,Survey_id
            )
      SELECT sm.SentMail_id
            ,sm.INTPAGES
            ,sm.Methodology_ID
            ,sm.SCHEDULEDMailing_ID
            ,CONVERT(CHAR, @MailingDate, 102)
            ,mm.Survey_id
      FROM dbo.SentMailing sm, dbo.MailingMethodology mm, dbo.GroupedPrint gp
      WHERE sm.Methodology_id = mm.Methodology_id
            AND mm.Survey_id = gp.Survey_id
            AND sm.PaperConfig_id = gp.PaperConfig_id
            AND sm.datPrinted = gp.datPrinted
            AND sm.datBundled = gp.datBundled
            AND sm.datPrinted < '4000'
            AND abs(Datediff(second, sm.datPrinted, @BundleDate)) <= 1
            AND sm.strPostalBundle IS NOT NULL
            AND isnull(sm.datMailed, '4000') = '4000'
            AND sm.PaperConfig_id = @PaperConfig_id

      SELECT @rc = @@rowcount, @err = @@error
END
ELSE
      IF @PostalBundle IS NULL
      BEGIN
	  print 'sentmailing 1'
            INSERT INTO #SentMailing (
                  SentMail_ID
                  ,INTPAGES
                  ,Methodology_ID
                  ,SCHEDULEDMailing_ID
                  ,DATMailED
                  ,Survey_id
                  )
            SELECT sm.SentMail_id
                  ,sm.INTPAGES
                  ,sm.Methodology_ID
                  ,sm.SCHEDULEDMailing_ID
                  ,CONVERT(CHAR, @MailingDate, 102)
                  ,@Survey_id
            FROM dbo.SentMailing sm, dbo.MailingMethodology mm
            WHERE sm.Methodology_id = mm.Methodology_id
                  AND mm.Survey_id = @Survey_id
                  AND abs(Datediff(second, sm.datBundled, @BundleDate)) <= 1
                  AND sm.strPostalBundle IS NOT NULL
                  AND sm.datMailed IS NULL
                  AND sm.PaperConfig_id = @PaperConfig_id

            SELECT @rc = @@rowcount, @err = @@error
      END
      ELSE
      BEGIN
            IF @startLitho IS NULL OR @endLitho IS NULL
            BEGIN

				print 'sentmailing 2'
                  INSERT INTO #SentMailing (
                        SentMail_ID
                        ,INTPAGES
                        ,Methodology_ID
                        ,SCHEDULEDMailing_ID
                        ,DATMailED
                        ,Survey_id
                        )
                  SELECT sm.SentMail_id
                        ,sm.INTPAGES
                        ,sm.Methodology_ID
                        ,sm.SCHEDULEDMailing_ID
                        ,CONVERT(CHAR, @MailingDate, 102)
                        ,@Survey_id
                  FROM dbo.SentMailing sm, dbo.MailingMethodology mm
                  WHERE sm.Methodology_id = mm.Methodology_id
                        AND mm.Survey_id = @Survey_id
                        AND abs(Datediff(second, sm.datBundled, @BundleDate)) <= 1
                        AND sm.strPostalBundle = @PostalBundle
                        AND sm.datMailed IS NULL
                        AND sm.PaperConfig_id = @PaperConfig_id

                  SELECT @rc = @@rowcount, @err = @@error
            END
            ELSE
            BEGIN
				print 'sentmailing 3'


				SELECT sm.SentMail_id
                        ,sm.INTPAGES
                        ,sm.Methodology_ID
                        ,sm.SCHEDULEDMailing_ID
                        ,CONVERT(CHAR, @MailingDate, 102)
                        ,@Survey_id
						,abs(Datediff(second, sm.datBundled, @BundleDate))
                  FROM dbo.SentMailing sm, dbo.MailingMethodology mm
                  WHERE sm.Methodology_id = mm.Methodology_id
                        AND mm.Survey_id = @Survey_id
                        --AND abs(Datediff(second, sm.datBundled, @BundleDate)) <= 1
                        AND sm.strPostalBundle = @PostalBundle
                        AND sm.datMailed IS NULL
                        AND sm.PaperConfig_id = @PaperConfig_id
                        AND sm.strLithoCode BETWEEN @startLitho AND @endLitho

                  INSERT INTO #SentMailing (
                        SentMail_ID
                        ,INTPAGES
                        ,Methodology_ID
                        ,SCHEDULEDMailing_ID
                        ,DATMailED
                        ,Survey_id
                        )
                  SELECT sm.SentMail_id
                        ,sm.INTPAGES
                        ,sm.Methodology_ID
                        ,sm.SCHEDULEDMailing_ID
                        ,CONVERT(CHAR, @MailingDate, 102)
                        ,@Survey_id
                  FROM dbo.SentMailing sm, dbo.MailingMethodology mm
                  WHERE sm.Methodology_id = mm.Methodology_id
                        AND mm.Survey_id = @Survey_id
                        AND abs(Datediff(second, sm.datBundled, @BundleDate)) <= 1
                        AND sm.strPostalBundle = @PostalBundle
                        AND sm.datMailed IS NULL
                        AND sm.PaperConfig_id = @PaperConfig_id
                        AND sm.strLithoCode BETWEEN @startLitho AND @endLitho

                  SELECT @rc = @@rowcount, @err = @@error
            END
      END

IF @err <> 0
BEGIN
      SET TRANSACTION ISOLATION LEVEL READ COMMITTED --DIRTY READ OFF     
      RETURN
END


SELECT '#SentMailing', * from #SentMailing

IF @rc > 0
BEGIN
      BEGIN TRANSACTION

      /* Next, upDate the SentMailing with the Mailing Date */
      UPDATE dbo.SentMailing
      SET datMailed = @MailingDate
      FROM dbo.SentMailing sm, #SentMailing tsm
      WHERE sm.SentMail_id = tsm.SentMail_id



      IF @@ERROR <> 0
      BEGIN
            ROLLBACK TRANSACTION
            SET TRANSACTION ISOLATION LEVEL READ COMMITTED --dirty read off     
            RETURN
      END

      /* Next, upDate the NPSentMailing with the Mailing Date */
      UPDATE dbo.NPSentMailing
      SET datMailed = @MailingDate
      FROM dbo.NPSentMailing sm, #SentMailing tsm
      WHERE sm.SentMail_id = tsm.SentMail_id

      IF @@ERROR <> 0
      BEGIN
            ROLLBACK TRANSACTION
            SET TRANSACTION ISOLATION LEVEL READ COMMITTED --dirty read off     
            RETURN
      END

      /* Next, queue up the expiration information */
      INSERT INTO SetExpiration_Queue (
            SentMail_id
            ,SamplePop_id
            ,MailingStep_id
            ,ExpireInDays
            ,ExpireFromStep
            )
      SELECT t.SentMail_id
            ,schm.SamplePop_id
            ,schm.MailingStep_id
            ,ms.ExpireInDays
            ,ms.ExpireFromStep
      FROM #SentMailing t(NOLOCK), ScheduledMailing schm(NOLOCK), MailingStep ms(NOLOCK)
      WHERE t.SentMail_id = schm.SentMail_id
            AND schm.MailingStep_id = ms.MailingStep_id

      IF @@ERROR <> 0
      BEGIN
            ROLLBACK TRANSACTION
            SET TRANSACTION ISOLATION LEVEL READ COMMITTED --dirty read off       
            RETURN
      END

      /* Next, queue up the Web Surveys*/
      IF EXISTS (
                  SELECT *
                  FROM WebSurveyGUID
                  WHERE Survey_id IN (
                              SELECT Survey_id
                              FROM #SentMailing
                              )
                  )
            INSERT INTO WebSurveyQueue (
                  Survey_id
                  ,Litho
                  ,bitPopulatedValues
                  ,bitProcessed
                  )
            SELECT Survey_id
                  ,strLithoCode
                  ,0
                  ,0
            FROM #SentMailing t(NOLOCK), SentMailing sm(NOLOCK)
            WHERE t.SentMail_id = sm.SentMail_id

      IF @@ERROR <> 0
      BEGIN
            ROLLBACK TRANSACTION
            SET TRANSACTION ISOLATION LEVEL READ COMMITTED --dirty read off       
            RETURN
      END

      /* Next, save the summary of Mailing count to temp table*/
      INSERT INTO #MailingCount (
            DATMailED
            ,Survey_ID
            ,INTPAGES
            ,MailCOUNT
            ,MailingStep_ID
            ,SampleSet_ID
            )
      SELECT sm.DATMailED
            ,sd.Survey_ID
            ,sm.INTPAGES
            ,COUNT(*) AS MailCOUNT
            ,sc.MailingStep_ID
            ,sp.SampleSet_ID
      FROM #SentMailing sm, dbo.MailingMethodology mm, dbo.Survey_DEF sd, dbo.SCHEDULEDMailing sc, dbo.SamplePop sp
      WHERE sm.Methodology_ID = mm.Methodology_ID
            AND mm.Survey_ID = sd.Survey_ID
            AND sm.SCHEDULEDMailing_ID = sc.SCHEDULEDMailing_ID
            AND sc.SamplePop_ID = sp.SamplePop_ID
      GROUP BY sm.DATMailED, sd.Survey_ID, sm.INTPAGES, sc.MailingStep_ID, sp.SampleSet_ID

      IF @@ERROR <> 0
      BEGIN
            ROLLBACK TRANSACTION
            SET TRANSACTION ISOLATION LEVEL READ COMMITTED --dirty read off     
            RETURN
      END

      /* Next, upDate the MailingSummary with the Mailing count */
      UPDATE sm
      SET sm.MailCOUNT = sm.MailCOUNT + cn.MailCOUNT
      FROM dbo.MailingSUMMARY sm, #MailingCount cn
      WHERE sm.DATMailED = cn.DATMailED
            AND sm.Survey_ID = cn.Survey_ID
            AND sm.INTPAGES = cn.INTPAGES
            AND sm.MailingStep_ID = cn.MailingStep_ID
            AND sm.SampleSet_ID = cn.SampleSet_ID

      IF @@ERROR <> 0
      BEGIN
            ROLLBACK TRANSACTION
            SET TRANSACTION ISOLATION LEVEL READ COMMITTED --dirty read off     
            RETURN
      END

      /* Next, insert the MailingSummary with new Mailing count */
      INSERT INTO dbo.MailingSUMMARY (
            DATMailED
            ,Survey_ID
            ,INTPAGES
            ,MailingStep_ID
            ,SampleSet_ID
            ,MailCOUNT
            )
      SELECT cn.DATMailED
            ,cn.Survey_ID
            ,cn.INTPAGES
            ,cn.MailingStep_ID
            ,cn.SampleSet_ID
            ,cn.MailCOUNT
      FROM #MailingCount cn
            LEFT JOIN dbo.MailingSUMMARY sm ON (
                  cn.DATMailED = sm.DATMailED
                  AND cn.Survey_ID = sm.Survey_ID
                  AND cn.INTPAGES = sm.INTPAGES
                  AND cn.MailingStep_ID = sm.MailingStep_ID
                  AND cn.SampleSet_ID = sm.SampleSet_ID
                  )
      WHERE sm.Survey_ID IS NULL

      IF @@ERROR <> 0
      BEGIN
            ROLLBACK TRANSACTION
            SET TRANSACTION ISOLATION LEVEL READ COMMITTED --dirty read off     
            RETURN
      --END

      COMMIT TRANSACTION
END


/*******************************************************************************/
/*******************************************************************************/
--is null check is to make sure we are calling this from queue manager and not from FormGen.  
--we do not want to generate the web data file if this is form gen.  
--IF OBJECT_ID('tempdb..#FG_NonMailingWork') IS NULL
--BEGIN
      --MWB 7/20/09  
      -- If mail/web step we need to create the web data now.  
      --select distinct SampleSet_ID, MailingStep_ID   
      --into #GenerateWebFile  
      --from #MailingCount mc, MailingStep ms  
      --where mc.MailingStep_Id = ms.MailingStep_ID and  
      --  ms.MailingStepMethod_ID in (2,4,9)   

	   IF OBJECT_ID('tempdb..#GenerateWebFile') IS NOT NULL
                        DROP TABLE #GenerateWebFile
      --  
      DECLARE @MailingStepMethod_ID INT, @SampleSet_ID INT, @MailingStep_ID INT, @VendorFile_ID INT

      SELECT DISTINCT sp.SampleSet_ID, scm.MailingStep_ID
      INTO #GenerateWebFile
      FROM #SentMailing t(NOLOCK), SentMailing sm(NOLOCK), scheduledmailing scm, SamplePop sp
      WHERE t.SentMail_id = sm.SentMail_id
            AND sm.SentMail_ID = scm.SentMail_ID
            AND scm.SamplePop_ID = sp.SamplePop_ID


	select *
	from #GenerateWebFile

      WHILE (     SELECT count(*)
                  FROM #GenerateWebFile
                  ) > 0
      BEGIN
            SELECT TOP 1 @SampleSet_ID = SampleSet_ID, @MailingStep_ID = MailingStep_ID
            FROM #GenerateWebFile

            SELECT @MailingStepMethod_ID = ms.MailingStepMethod_ID
            FROM MailingStep ms
            WHERE ms.MailingStep_ID = @MailingStep_ID

            IF @MailingStepMethod_ID IN (2,4,9)
            BEGIN
                  --IF NOT EXISTS (
                  --            SELECT TOP 1 *
                  --            FROM VendorFileCreationQueue
                  --            WHERE SampleSet_ID = @SampleSet_ID
                  --                  AND MailingStep_id = @MailingStep_id
                  --            )
                  --BEGIN
                  --      INSERT INTO VendorFileCreationQueue (SampleSet_ID, MailingStep_ID, VendorFileStatus_ID)
                  --      SELECT @SampleSet_ID AS SampleSet_ID
                  --            ,@MailingStep_ID AS MailingStep_ID
                  --            ,1 AS VendorFileStatus_ID

                  --      SELECT @VendorFile_ID = Scope_identity()
                  --END
                  --ELSE
                  --BEGIN
                  --      SELECT TOP 1 @VendorFile_ID = VendorFile_ID
                  --      FROM VendorFileCreationQueue
                  --      WHERE SampleSet_ID = @SampleSet_ID
                  --            AND MailingStep_id = @MailingStep_id
                  --END

                  IF OBJECT_ID('tempdb..#FG_NonMailingWork') IS NOT NULL
                        DROP TABLE #FG_NonMailingWork

                  --need to create fake work table so we get only those that generated this time.  
                  SELECT DISTINCT sp.SamplePop_ID, g.MailingStep_ID	
				  -- COULD THESE ADDITIONAL FIELDS CREATE MULTIPLE SamplePop_id/mailingStep_id records  
				  , scm.SCHEDULEDMAILING_ID, ss.SURVEY_ID, 0 as LangID, ss.SAMPLESET_ID, sp.STUDY_ID, sp.POP_ID -- S59 ATL-628 adding additional columns to #FG_NonMailingWork
                  INTO #FG_NonMailingWork
                  FROM #GenerateWebFile G, SampleSet ss, scheduledmailing scm, SamplePop sp
                  WHERE g.SampleSet_ID = ss.SampleSet_ID
                        AND scm.MailingStep_Id = g.MailingStep_Id
                        AND g.SampleSet_ID = sp.SampleSet_ID
                        AND scm.SamplePop_ID = sp.SamplePop_ID
                        AND g.SampleSet_ID = @SampleSet_ID
                        AND g.MailingStep_Id = @MailingStep_ID

                  --EXEC QSL_SelectWebVendorSampleSetFileData @SampleSet_ID, 1, 0, @VendorFile_ID, 1, 0

				  select * from #FG_NonMailingWork

				--BEGIN S59 ATL-628 insert records to QDEForm and QDEComments
				DECLARE @mailstepmethodidlist varchar(20)
				if exists (select 1 from qualpro_params where STRPARAM_NM ='MailingStepMethodIDs' and STRPARAM_GRP = 'SP_Queue_SetNextMailing')
					SELECT @mailstepmethodidlist = strParam_Value from qualpro_params where STRPARAM_NM ='MailingStepMethodIDs' and STRPARAM_GRP = 'SP_Queue_SetNextMailing'
				else SET @mailstepmethodidlist = '9' -- defaults to Letter-Web
				 				
				IF EXISTS (SELECT items FROM dbo.split(@mailstepmethodidlist,',') where items=@MailingStepMethod_ID)
				BEGIN
					--Update the langID
					DECLARE @study   INT,
							@sql     VARCHAR(max)

					set @sql=''
					select @sql = @sql + 'UPDATE nmw SET LangID = ISNULL(p.LangID, 1) FROM #fg_nonmailingwork nmw, samplepop sp,  s'
									 + LTRIM(STR(sub.study_id))
									 + '.Population p WHERE nmw.samplepop_id = sp.samplepop_id AND sp.pop_id = p.pop_id;' + char(13)
					from (SELECT DISTINCT
						   study_id
						FROM   #FG_NonMailingWork) sub
					exec (@sql)


					  -- POPULATE QDEFORM FOR WHAT WE HAVE PROCESSED: from SP_FG_NonMailGen
					  --INSERT INTO dbo.QDEForm
							--	  (strLithoCode,
							--	   SentMail_id,
							--	   QuestionForm_id,
							--	   Survey_id,
							--	   strTemplateCode,
							--	   LangID,
							--	   bitLocked)
					  SELECT DISTINCT
							 SM.strLithoCode,
							 SM.SentMail_id,
							 QF.QuestionForm_id,
							 qf.Survey_id,
							 strTemplateCode,
							 SM.LangID,
							 0
					  FROM   #FG_NonMailingWork NMW,
							 dbo.SentMailing SM,
							 dbo.QuestionForm QF,
							 dbo.PaperConfigSheet PCS,
							 dbo.PaperSize PS,
							 dbo.Survey_def SD,
							 dbo.Study ST,
							 dbo.Client CL
					  WHERE  NMW.ScheduledMailing_id = SM.ScheduledMailing_id
							 AND SM.SentMail_id = QF.SentMail_id
							 AND SM.PaperConfig_id = PCS.PaperConfig_id
							 AND PCS.PaperSize_id = PS.PaperSize_id
							 AND QF.Survey_id = SD.Survey_id
							 AND SD.Study_id = ST.Study_id
							 AND ST.Client_id = CL.Client_id


					  -- POPULATE QDECOMMENTS  FOR WHAT WE HAVE PROCESSED : from SP_FG_NonMailGen
					  --INSERT INTO dbo.QDEComments
							--	  (Form_id,
							--	   SampleUnit_id,
							--	   QstnCore,
							--	   bitIgnore)
					  SELECT     DISTINCT
								 qdf.form_id,
								 sus.sampleunit_id,
								 sq.qstncore,
								 0
					  FROM       #FG_NonMailingWork nmw
					  INNER JOIN dbo.sentmailing sm
							  ON nmw.scheduledmailing_id = sm.scheduledmailing_id
					  INNER JOIN dbo.sel_qstns sq
							  ON nmw.survey_id = sq.survey_id
								 AND sq.language = (CASE nmw.langid
													  WHEN 99999 THEN 1
													  ELSE sq.language
													END)
								 AND sq.subtype = 4
								 AND sq.height > 0
					  INNER JOIN dbo.selectedsample ss
							  ON nmw.sampleset_id = ss.sampleset_id
								 AND nmw.study_id = ss.study_id
								 AND nmw.pop_id = ss.pop_id
					  INNER JOIN dbo.sampleunitsection sus
							  ON ss.sampleunit_id = sus.sampleunit_id
								 AND sq.survey_id = sus.selqstnssurvey_id
								 AND sq. section_id = sus.selqstnssection
					  INNER JOIN dbo.qdeform qdf
							  ON sm.sentmail_id = qdf.sentmail_id
				END
				--END S59 ATL-628 insert records to QDEForm and QDEComments
            END

            DELETE
            FROM #GenerateWebFile
            WHERE SampleSet_ID = @SampleSet_ID
                  AND MailingStep_ID = @MailingStep_ID

            SELECT TOP 1 @SampleSet_ID = SampleSet_ID, @MailingStep_ID = MailingStep_ID
            FROM #GenerateWebFile
      END
--END

/*******************************************************************************/
/*******************************************************************************/
/*******************************************************************************/
/*******************************************************************************/
/*Creating the queue for setting the next generation (datgenerate) id needed.    
 Added by Ron Niewohner 2/16/2002    
*/
BEGIN TRANSACTION

INSERT INTO NextMailingStep (
      NextscheduledMailing_id
      ,SamplePop_id
      ,MailingStep_id
      ,Methodology_id
      ,SentMail_id
      )
SELECT schm1.SCHEDULEDMailing_ID
      ,schm.SamplePop_id
      ,MIN(ms1.MailingStep_id)
      ,schm.Methodology_id
      ,sm.SentMail_id
FROM ScheduledMailing schm, #SentMailing sm, MailingStep ms, MailingStep ms1, ScheduledMailing schm1
WHERE sm.SentMail_id = schm.SentMail_id
      AND ms.Survey_id = sm.Survey_id
      AND ms1.Survey_id = ms.Survey_id
      AND schm.Methodology_id = ms.Methodology_id
      AND schm.MailingStep_id = ms.MailingStep_id
      AND schm.Methodology_id = ms1.Methodology_id
      AND ms.MailingStep_id < ms1.MailingStep_id
      AND schm.SamplePop_id = schm1.SamplePop_id --Self joining back to scheduled Mailing to get the next id    
      AND schm1.SentMail_id IS NULL --This should only insert if there is a next Mailing    
GROUP BY schm1.SCHEDULEDMailing_ID, schm.SamplePop_id, schm.Methodology_id, sm.SentMail_id

-- Mod 8/17/04 SJS - Needed to break @@error and @@rowcount apart in the following "IF" statements due to the incorporation of NonMail Generations    
SELECT @rc = @@rowcount, @err = @@error

IF @err <> 0
BEGIN
      ROLLBACK TRANSACTION
      SET TRANSACTION ISOLATION LEVEL READ COMMITTED --dirty read off     
      RETURN
END

COMMIT TRANSACTION

/* The follow Step is done now to avoid something getting changed between the time the MailDate is set and when the     
 ** batch for setting the next datgenerate is ran.    
 */
IF @rc > 0
BEGIN
      BEGIN TRANSACTION

      UPDATE nms
      SET nms.intIntervaldays = ms.intIntervalDays
            ,nms.nextdatgenerate = DATEADD(dd, ms.intIntervaldays, @MailingDateMidnight)
      FROM NextMailingStep nms, MailingStep ms
      WHERE nms.MailingStep_id = ms.MailingStep_id
            AND nms.intIntervaldays IS NULL --So only newly added records are upDated.    

      IF @@ERROR <> 0
      BEGIN
            ROLLBACK TRANSACTION
            SET TRANSACTION ISOLATION LEVEL READ COMMITTED --dirty read off     
            RETURN
      END

      COMMIT TRANSACTION
END

END
