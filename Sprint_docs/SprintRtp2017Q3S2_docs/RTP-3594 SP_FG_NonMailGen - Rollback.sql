/*
	RTP-3594 SP_FG_NonMailGen - Rollback.sql

	Lanny Boswell

	8/21/2017

	ALTER PROCEDURE SP_FG_NonMailGen

*/

USE [QP_PROD]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
	Modified 8/04/2016 TSB S55 ATL-180  Modified to not schedule phone for seeded mailing recipients
	Modified 11/15/2016 TSB -- modify TOCL disposition to use disposition_id for "TOCL during Generation" for ACO and PQRS S62 ATL-1103
*/
ALTER PROCEDURE [dbo].[SP_FG_NonMailGen]
AS
    SET NOCOUNT ON

    DECLARE @study   INT,
            @sql     VARCHAR(500),
            @GetDate DATETIME,
            @QFMax   INT
    DECLARE @studies TABLE ( study_id INT)
    DECLARE @Sampleset                  INT,
            @mailingstep_id             INT,
            @VendorFileID               INT,
            @CreateDataFileAtGeneration INT,
			@TOCLDispositionID INT, --S62 ATL-1103
			@ACOSurveyTypeID int, --S62 ATL-1103
	        @PQRSSurveyTypeID int --S62 ATL-1103

	select @ACOSurveyTypeID = SurveyType_id from dbo.SurveyType where SurveyType_dsc = 'ACOCAHPS'
	select @PQRSSurveyTypeID = SurveyType_id from dbo.SurveyType where SurveyType_dsc = 'PQRS CAHPS'
	SELECT @TOCLDispositionID = Disposition_ID FROM dbo.Disposition where [strDispositionLabel] = 'TOCL During Generation'

    SELECT @GetDate = CONVERT(VARCHAR, GETDATE(), 110)

    ------------------  ------------------ ------------------ ------------------ ------------------ ------------------ ------------------
    -- Gather all non-mailing work into a #tbl
    SELECT m.study_id,
           m.survey_id,
           m.samplepop_id,
           m.scheduledmailing_id,
           m.priority_flg,
           m.zip5,
           m.zip4,
           m.sampleset_id,
           m.pop_id,
           m.mailingstep_id,
           m.methodology_id,
           m.overrideitem_id,
           ms.mailingstepmethod_id,
           NULL AS NextMailingStep_id,
           0 AS bitSendSurvey,
           0 AS LangID,
		   sd.SurveyType_id
    INTO   #FG_NonMailingWork
    FROM   dbo.fg_premailingwork m,
           dbo.mailingstep ms,
           dbo.MailingStepMethod MSM,
		   dbo.Survey_Def sd -- S62 ATL-1103
    WHERE  m.mailingstep_id = ms.mailingstep_id
           AND ms.mailingstepmethod_id = MSM.mailingstepmethod_id
           AND MSM.IsNonMailGeneration = 1
		   AND sd.Survey_id = m.Survey_id --S62 ATL-1103

    -- Remove from source table the records we have moved into our work table.
    DELETE pw
    FROM   dbo.FG_PreMailingWork pw,
           #FG_NonMailingWork mw
    WHERE  pw.ScheduledMailing_id = mw.ScheduledMailing_id

    ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
/************/
    -- The following code also occurs in sp_fg_formgen for records that will be printed/mailed.
/************/
    -- Delete the People on the 'Take Off Call List FROM #FG_NonMailingWork
    -- We will first set the sentmail_id to -1 for the ScheduledMailing record
    UPDATE SCHM
    SET    SentMail_ID = -1
    FROM   dbo.ScheduledMailing SCHM,
           #FG_NonMailingWork M,
           dbo.TOCL
    WHERE  TOCL.Pop_id = M.Pop_id
           AND TOCL.Study_id = M.Study_id
           AND M.ScheduledMailing_ID = SCHM.ScheduledMailing_ID

    --
    --TR#14 HCAHPS 2012 Audit project.  Add insert to dispositionlog after update, but before delete
    --from #FG_MailingWork below.  Parameters are: disposition_id = 8, receipttype_id = 0,
    --sentmail_id = -1, loggedby = 'SP_FG_FormGen', daysfromcurrent = null,
    --daysfromfirst = 1, datlogged = getdate()
    --Lee Kohrs 2013-05-22 Added the following insert statement
    INSERT INTO [QP_Prod].[dbo].[DispositionLog]
                ([SentMail_id],
                 [SamplePop_id],
                 [Disposition_id],
                 [ReceiptType_id],
                 [datLogged],
                 [LoggedBy],
                 [DaysFromCurrent],
                 [DaysFromFirst])
    SELECT -1 [SentMail_id],
           M.[SamplePop_id],
            CASE 
				WHEN M.SurveyType_ID IN (@ACOSurveyTypeID,@PQRSSurveyTypeID) then @TOCLDispositionID -- S62 ATL-1103  ACO & PQRS
				ELSE 8
				END [Disposition_id], -- ATL-1103
           0 [ReceiptType_id],
           getdate() [datLogged],
           'SP_FG_NonMailGen' [LoggedBy],
           0 [DaysFromCurrent],
           0 [DaysFromFirst]
    FROM   dbo.ScheduledMailing SCHM,
           #FG_NonMailingWork M,
           dbo.TOCL
    WHERE  TOCL.Pop_id = M.Pop_id
           AND TOCL.Study_id = M.Study_id
           AND M.ScheduledMailing_ID = SCHM.ScheduledMailing_ID

    DELETE M
    FROM   #FG_NonMailingWork M,
           dbo.TOCL
    WHERE  TOCL.Pop_id = M.Pop_id
           AND TOCL.Study_id = M.Study_id

    -- If no work left we can skip to the end
    IF (SELECT COUNT(*)
        FROM   #FG_NonMailingWork) = 0
      GOTO Completed

    ------------------  ------------------ ------------------ ------------------ ------------------ ------------------ ------------------
    -- Else .....
    -- Update the #FG_MailingWork with the rest of the attributes necessary to Generate
    -- Update bitSendSurvey
    UPDATE #FG_NonMailingWork
    SET    bitSendSurvey = MS1.bitSendSurvey
    FROM   dbo.MailingStep MS1
    WHERE  #FG_NonMailingWork.MailingStep_id = MS1.MailingStep_id

    -- Update NextMailinStep_id
    UPDATE #FG_NonMailingWork
    SET    NextMailingStep_id = MS2.MailingStep_id
    FROM   dbo.MailingStep MS1,
           dbo.MailingStep MS2
    WHERE  #FG_NonMailingWork.MailingStep_id = MS1.MailingStep_id
           AND MS1.Methodology_id = MS2.Methodology_id
           AND MS1.intSequence
               + 1 = MS2.intSequence

    ------------------  ------------------ ------------------ ------------------ ------------------ ------------------ ------------------
    -- Loop by study to update the langid field
    INSERT INTO @studies
                (study_id)
    SELECT DISTINCT
           study_id
    FROM   #FG_NonMailingWork

    WHILE (SELECT COUNT(*)
           FROM   @studies) > 0
      BEGIN
          SELECT TOP 1 @study = study_id
          FROM   @studies

          SET @sql = 'UPDATE nmw SET LangID = ISNULL(p.LangID, 1) FROM #fg_nonmailingwork nmw, samplepop sp,  s'
                     + LTRIM(STR( @study))
                     + '.Population p WHERE nmw.samplepop_id = sp.samplepop_id AND sp.pop_id = p.pop_id'

          EXEC (@sql)

          DELETE FROM @studies
          WHERE  study_id = @study

          SELECT TOP 1 @study = study_id
          FROM   @studies
      END

    ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
    -- NOW LETS POULATE THE TABLES IN A TRANSACTION SO WE CAN ROLLBACK IF IT ERRORS.
    ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
/************/
    -- The following code also occurs in sp_fg_formgen_sub for records that printed/mailed.
    /************/
    BEGIN TRANSACTION

  BEGIN
      ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
      -- INSERT INTO SENTMAILING
      INSERT INTO SentMailing
                  (datGenerated,
                   Methodology_id,
                   ScheduledMailing_id,
                   Langid,
                   paperconfig_id,
                   intReprinted,
                   strPostalBundle,
                   IntPages,
                   datBundled)
      SELECT @GetDate,
             Methodology_id,
             ScheduledMailing_id,
             Langid,
             -1 AS paperconfig_id,
             0 AS intReprinted,
             'Non-Mail' AS strPostalBundle,
             0 AS IntPages,
             @GetDate AS datBundled
      FROM   #FG_NonMailingWork

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION

            INSERT INTO dbo.FormGenError
                        (ScheduledMailing_id,
                         datGenerated,
                         FGErrorType_id)
            SELECT ScheduledMailing_id,
                   GETDATE(),
                   3
            FROM   #FG_NonMailingWork

            TRUNCATE TABLE #FG_NonMailingWork

            RETURN
        END

      ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
      -- LETS  SET LITHO
      DECLARE @survey          INT,
              @strPostalBundle VARCHAR(10),
              @paperconfig_id  INT,
              @reprint         TINYINT,
              @datBundled      DATETIME
      DECLARE @surveywork TABLE ( survey_id INT)
      DECLARE @setlithowork TABLE ( survey_id       INT,
                           strPostalBundle VARCHAR(10),
                           paperconfig_id  INT,
                           intReprinted    TINYINT,
                           datBundled      DATETIME)

      -- Get work
      INSERT INTO @surveywork
                  (survey_id)
      SELECT DISTINCT
             Survey_id
      FROM   #FG_NonMailingWork

      WHILE (SELECT COUNT(*)
             FROM   @surveywork) > 0
        BEGIN
            SELECT TOP 1 @survey = survey_id
            FROM   @surveywork

            INSERT INTO @setlithowork
                        (survey_id,
                         strPostalBundle,
                         paperconfig_id,
                         intReprinted,
                         datBundled)
            SELECT     DISTINCT
                       mw.survey_Id,
                       sm.strPostalBundle,
                       sm.paperconfig_id,
                       sm.intReprinted,
                       sm.datBundled
            FROM       #FG_NonMailingWork mw
            INNER JOIN dbo.Sentmailing sm
                    ON mw.scheduledmailing_id = sm.scheduledmailing_id
            WHERE      mw.survey_id = @survey

            -- Loop through @ survey level
            WHILE (SELECT COUNT(*)
                   FROM   @SetLithoWork) > 0
              BEGIN
                  SELECT TOP 1 @survey = survey_id,
                               @strPostalBundle = strPostalBundle,
                               @paperconfig_id = paperconfig_id,
                               @Reprint = intReprinted,
                               @datBundled = datBundled
                  FROM   @SetLithoWork

                  -- Set the LItho
                  SET QUOTED_IDENTIFIER ON;

                  EXEC dbo.sp_queue_setLitho
                    @survey_id = @survey,
                    @strPostalBundle_id = @strPostalBundle,
                    @paperconfig_id = @paperconfig_id,
                    @reprint = @Reprint,
                    @datBundled = @datBundled

                  -- If the returning sub-proc performed a rollback, it will have rolled back the transaction here,
                  --so the @@trancount will be 0 and we will want to error out of this procedure.
                  IF @@TRANCOUNT = 0
                    BEGIN
                        INSERT INTO dbo.FormGenError
                                    (ScheduledMailing_id,
                                     datGenerated,
                                     FGErrorType_id)
                        SELECT ScheduledMailing_id,
                               GETDATE(),
                               3
                        FROM   #FG_NonMailingWork

                        TRUNCATE TABLE #FG_NonMailingWork

                        RETURN
                    END

                  SET QUOTED_IDENTIFIER OFF

                  DELETE FROM @SetLithoWork
                  WHERE  @survey = survey_id
                         AND @strPostalBundle = strPostalBundle
                         AND @paperconfig_id = paperconfig_id
                         AND @Reprint = intReprinted
                         AND @datBundled = datBundled

                  SELECT TOP 1 @survey = survey_id,
                               @strPostalBundle = strPostalBundle,
                               @paperconfig_id = paperconfig_id,
                               @Reprint = intReprinted,
                               @datBundled = datBundled
                  FROM   @SetLithoWork
              END

            DELETE FROM @surveywork
            WHERE  survey_id = @survey

            SELECT TOP 1 @survey = survey_id
            FROM   @surveywork
        END

      -- Now update the DATPRINTED date after the LItho has been set
      UPDATE SM
      SET    datPrinted = @GetDate
      FROM   dbo.SentMailing SM,
             #FG_NonMailingWork MW
      WHERE  SM.scheduledmailing_id = mw.scheduledmailing_id

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION

            INSERT INTO dbo.FormGenError
                        (ScheduledMailing_id,
                         datGenerated,
                         FGErrorType_id)
            SELECT ScheduledMailing_id,
                   GETDATE(),
                   3
            FROM   #FG_NonMailingWork

            TRUNCATE TABLE #FG_NonMailingWork

            RETURN
        END

      ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
      -- SKIP PATTERN INFORMATION
      -- Make sure the work table is empty
      DELETE FROM @surveywork

      INSERT INTO @surveywork
                  (survey_id)
      SELECT DISTINCT
             Survey_id
      FROM   #FG_NonMailingWork

      SELECT TOP 1 @Survey = Survey_id
      FROM   @surveywork

      WHILE @@ROWCOUNT > 0
        BEGIN
            --We will generate the skip pattern information for all outgo, even postcards because of Canada.
            EXEC dbo.SP_FG_PopulateSkipPatterns
              @Survey,
              @GetDate

            IF @@ERROR <> 0
              BEGIN
                  ROLLBACK TRANSACTION

                  INSERT INTO dbo.FormGenError
                              (ScheduledMailing_id,
                               datGenerated,
                               FGErrorType_id)
                  SELECT ScheduledMailing_id,
                         GETDATE(),
                         3
                  FROM   #FG_NonMailingWork

                  TRUNCATE TABLE #FG_NonMailingWork

                  RETURN
              END

            DELETE FROM @surveywork
            WHERE  Survey_id = @Survey

            SELECT TOP 1 @Survey = Survey_id
            FROM   @surveywork
        END

      ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
      -- UPDATE SCHEDULEDMAILING WITH NEW SENTMAIL_ID'S
      UPDATE dbo.ScheduledMailing
      SET    SentMail_id = SM.SentMail_id
      FROM   dbo.SentMailing SM,
             dbo.ScheduledMailing SC
      WHERE  SM.ScheduledMailing_id = SC.ScheduledMailing_id
             AND SC.SentMail_id IS NULL

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION

            INSERT INTO dbo.FormGenError
                        (ScheduledMailing_id,
                         datGenerated,
                         FGErrorType_id)
            SELECT ScheduledMailing_id,
                   GETDATE(),
                   3
            FROM   #FG_NonMailingWork

            TRUNCATE TABLE #FG_NonMailingWork

            RETURN
        END

      ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
      -- ADD TO QUESTIONFORM
      select @QFMax = max(questionform_id)
      from dbo.QuestionForm

      INSERT INTO dbo.QuestionForm
                  (SentMail_id,
                   SamplePop_id,
                   Survey_id)
      SELECT SC.SentMail_id,
             SC.SamplePop_id,
             MW.Survey_id
      FROM   dbo.ScheduledMailing SC,
             #FG_NonMailingWork MW
      WHERE  SC.ScheduledMailing_id = MW.ScheduledMailing_id

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION

            INSERT INTO dbo.FormGenError
                        (ScheduledMailing_id,
                         datGenerated,
                         FGErrorType_id)
            SELECT ScheduledMailing_id,
                   GETDATE(),
                   3
            FROM   #FG_NonMailingWork

            TRUNCATE TABLE #FG_NonMailingWork

            RETURN
        END

      exec dbo.CalcCAHPSSupplemental @QFMax

      ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
      --SCHEDULE THE NEXT UNGENERATED RECORD
      -- Only want to schedule the next ungenerated record - exclude seeded recipients on non-mail
      INSERT INTO dbo.ScheduledMailing
                  (MailingStep_id,
                   SamplePop_id,
                   Methodology_id,
                   datGenerate)
      SELECT          mw.NextMailingStep_id,
                      mw.SamplePop_id,
                      mw.Methodology_id,
                      '12/31/4172'
      FROM            #FG_NonMailingWork mw
	  inner join Mailingstep ms(NOLOCK) on mw.nextMailingStep_id = ms.MailingStep_id --S55 ATL-180
      LEFT OUTER JOIN #FG_NonMailingWork mw2
                   ON mw.NextMailingStep_id = mw2.MailingStep_id
                      AND mw.SamplePop_id = mw2.SamplePop_id
      WHERE           mw.NextMailingStep_id IS NOT NULL
                      AND mw.OverrideItem_id IS NULL
                      AND mw2.MailingStep_id IS NULL
					  and (mw.Pop_id > 0	or ms.MailingStepMethod_id in (0,10))	--S55 ATL-180



      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION

            INSERT INTO dbo.FormGenError
                        (ScheduledMailing_id,
                         datGenerated,
                         FGErrorType_id)
            SELECT ScheduledMailing_id,
                   GETDATE(),
                   3
            FROM   #FG_NonMailingWork

            TRUNCATE TABLE #FG_NonMailingWork

            RETURN
        END

      -- Now lets SET DATMAILED and prepare NEXTMAILINGSTEP table so the next FormGen batch
      --can set datGenerate on the newly scheduled records.
      DELETE FROM @surveywork

      INSERT INTO @surveywork
                  (survey_id)
      SELECT DISTINCT
             Survey_id
      FROM   #FG_NonMailingWork

      SELECT TOP 1 @Survey = Survey_id
      FROM   @surveywork

      WHILE @@ROWCOUNT > 0
        BEGIN
            EXEC dbo.sp_Queue_SetNextMailing
              @survey_id = @survey,
              @paperconfig_id = -1,
              @mailingdate = @getdate,
              @bundledate = @getdate

            -- If the returning sub-proc performed a rollback, it will have rolled back the transaction here,
            --so the @@trancount will be 0 and we will want to error out of this procedure.
            IF @@TRANCOUNT = 0
              BEGIN
                  INSERT INTO dbo.FormGenError
                              (ScheduledMailing_id,
                               datGenerated,
                               FGErrorType_id)
                  SELECT ScheduledMailing_id,
                         GETDATE(),
                         3
                  FROM   #FG_NonMailingWork

                  TRUNCATE TABLE #FG_NonMailingWork

                  RETURN
              END

            DELETE FROM @surveywork
            WHERE  Survey_id = @Survey

            SELECT TOP 1 @Survey = Survey_id
            FROM   @surveywork
        END

      ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
      -- POPULATE QDEFORM FOR WHAT WE HAVE PROCESSED
      INSERT INTO dbo.QDEForm
                  (strLithoCode,
                   SentMail_id,
                   QuestionForm_id,
                   Survey_id,
                   strTemplateCode,
                   LangID,
                   bitLocked)
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

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION

            INSERT INTO dbo.FormGenError
                        (ScheduledMailing_id,
                         datGenerated,
                         FGErrorType_id)
            SELECT ScheduledMailing_id,
                   GETDATE(),
                   3
            FROM   #FG_NonMailingWork

            TRUNCATE TABLE #FG_NonMailingWork

            RETURN
        END

      ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
      --MWB 9-23-08 added case logic for sq.language
      -- POPULATE QDECOMMENTS  FOR WHAT WE HAVE PROCESSED
      INSERT INTO dbo.QDEComments
                  (Form_id,
                   SampleUnit_id,
                   QstnCore,
                   bitIgnore)
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

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION

            INSERT INTO dbo.FormGenError
                        (ScheduledMailing_id,
                         datGenerated,
                         FGErrorType_id)
            SELECT ScheduledMailing_id,
                   GETDATE(),
                   3
            FROM   #FG_NonMailingWork

            TRUNCATE TABLE #FG_NonMailingWork

            RETURN
        END
  ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
  END

    COMMIT TRANSACTION

    ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
    -- -- Now lets notify the approriate authorities......
    DECLARE @strClient_Nm VARCHAR(40),
            @strStudy_Nm  VARCHAR(10),
            @strSurvey_Nm VARCHAR(10),
            @PieceCnt     INT,
            @notify_id    INT,
            @client       INT,
            @SentFlg      TINYINT,
            @err          INT
    DECLARE @NotifyEmail   VARCHAR(100),
            @NotifySubject VARCHAR(100),
            @NotifyMessage VARCHAR(500),
            @NotifyQuery   VARCHAR(1000),
            @TotalCnt      INT
    DECLARE @notifywork TABLE ( survey_id      INT,
                       sampleset_id   INT,
                       methodology_id INT,
                       mailingstep_id INT)

    -- Get a Distinct list of surveys to process
    INSERT INTO @notifywork
                (survey_id,
                 sampleset_id,
                 methodology_id,
                 mailingstep_id)
    SELECT DISTINCT
           survey_id,
           sampleset_id,
           methodology_id,
           mailingstep_id
    FROM   #FG_NonMailingWork

    -- Add the AD for the study/survey into the notification List
    INSERT INTO dbo.NonMailGen_NotifyLog
                (survey_id,
                 sampleset_id,
                 mailingstep_id,
                 ademployee_id,
                 notify_dt,
                 piececnt,
                 SentFlg)
    SELECT nw.survey_id,
           nw.sampleset_id,
           nw.mailingstep_id,
           s.ademployee_id,
           NULL Notify_dt,
           NULL PieceCnt,
           0 SentFlg
    FROM   dbo.Study s,
           dbo.ClientStudySurvey_View cssv,
           dbo.employee e,
           @notifywork nw
    WHERE  s.study_id = cssv.study_Id
           AND s.ademployee_id IS NOT NULL
           AND cssv.survey_id = nw.survey_id
           AND cssv.methodology_id = nw.methodology_id
           AND s.ademployee_id = e.employee_id

    -- Update the piece count for all survey/sampleset/mailingstep
    UPDATE nl
    SET    PieceCnt = pc.PieceCnt
    FROM   (SELECT mw.sampleset_id,
                   mw.mailingstep_id,
                   COUNT(*) AS PieceCnt
            FROM   #fg_nonmailingwork mw,
                   dbo.sampleset ss,
                   dbo.ClientStudySurvey_View c,
                   dbo.mailingstep ms
            WHERE  mw.sampleset_id = ss.sampleset_id
                   AND mw.survey_id = c.survey_id
                   AND mw.methodology_id = c.methodology_id
                   AND mw.mailingstep_id = ms.mailingstep_id
            GROUP  BY c.strClient_Nm,
                      c.strStudy_Nm,
                      c.strSurvey_Nm,
                      ms.strMailingStep_Nm,
                      ss.datSampleCreate_dt,
                      c.client_id,
                      mw.study_id,
                      mw.survey_id,
                      mw.sampleset_id,
                      mw.mailingstep_id) pc,
           NonMailGen_NotifyLog nl
    WHERE  pc.sampleset_id = nl.sampleset_id
           AND pc.mailingstep_id = nl.mailingstep_id
           AND SentFlg = 0

    -- Get the first survey to work on.
    SELECT DISTINCT TOP 1
           @survey = survey_id
    FROM   @notifywork

    WHILE @@ROWCOUNT > 0
      BEGIN
      /*
      --MWB 7/7/09 we no longer send e-mails when generation completes, but instead have an application to
      --generate this file.

        -- Assemble and Email the information
        SELECT DISTINCT TOP 1 @strClient_Nm = css.strClient_Nm, @strStudy_Nm = css.strStudy_nm, @strSurvey_Nm = css.strSurvey_nm, @NotifyEmail = e.strEmail,
            @survey = css.survey_id, @notify_id = notify_id, @client = css.client_id, @study = css.study_id
        FROM NonMailGen_Notifylog nl, ClientStudySurvey_View css, Study s, employee e
        WHERE s.study_id = css.study_Id AND s.ademployee_id IS NOT NULL AND css.survey_id = nl.survey_id AND s.ademployee_id = e.employee_id
        AND nl.survey_id = @survey and SentFlg = 0

        SELECT @TotalCnt = SUM(PieceCnt) FROM NonMailGen_NotifyLog WHERE survey_id = @survey AND SentFlg = 0

        SET @NotifySubject = 'Non-mail generation has completed for survey [' + @strSurvey_Nm + '].'
        SET @NotifyMessage = 'Non-mail generation has completed for Client: [' + @strClient_Nm + '], Study: [' + @strStudy_Nm + '], Survey: [' + @strSurvey_Nm + ']. There were '
             + LTRIM(STR(@TotalCnt)) + ' pieces generated. The data can now be exported via DashBoard, under the Project Reports /
               Phone Extract menu selection. See the attched report for additional details. '
      --  +  @notifyemail        -- Testing (remove when in production)
      --  SET @notifyemail = 'sspicka@nationalresearch.com' -- Testing (remove when in production)


        SET @NotifyQuery =
        'SELECT ' + '''' + @strClient_Nm + '''' + ' ClientNm, ' + '''' + @strStudy_Nm + '''' + ' StudyNm, ' + '''' +  @strSurvey_Nm + ''''
        + ' SurveyNm, ss.datSampleCreate_dt SampleDate, ms.strMailingStep_Nm MailStepNM, PieceCnt, ' + '''' +  LTRIM(STR(@client)) + '''' + ' client, '
        + '''' + LTRIM(STR(@study)) + ''''
        + ' study, nl.survey_id survey, nl.sampleset_id sampleset, nl.mailingstep_id mailstep '
        + 'FROM nonmailgen_notifylog nl, sampleset ss, mailingstep ms WHERE nl.sampleset_id = ss.sampleset_id AND nl.mailingstep_id = ms.mailingstep_id '
        + 'AND nl.survey_id = ' + LTRIM(STR(@survey)) + ' AND SentFlg = 0'

      --  SELECT @NOTIFYEMAIL, @NOTIFYSUBJECT, @NOTIFYMESSAGE, @NOTIFYQUERY

      --  EXEC master.dbo.xp_sendmail @recipients = @NotifyEmail, @copy_recipients = 'sspicka@nationalresearch.com',
      --   @subject = @NotifySubject, @message = @NotifyMessage, @dbuse = 'QP_Prod', @query = @NotifyQuery, @width = 150, @attach_results = 'TRUE'

      EXEC @err = master.dbo.xp_sendmail @recipients = @NotifyEmail, @copy_recipients = 'nonmailgen@nationalresearch.com',
           @subject = @NotifySubject, @message = @NotifyMessage, @dbuse = 'QP_Prod', @query = @NotifyQuery, @width =   150, @attach_results = 'TRUE'
      IF @err = 0
       SET @SentFlg = 1
      ELSE
       SET @SentFlg = 9
      */
          --MWB 7/7/09 hardcoded to 0 b/c e-mail is no longer sent from here.
          SET @SentFlg = 0

          UPDATE dbo.NonMailGen_NotifyLog
          SET    SentFlg = @SentFlg,
         Notify_dt = GETDATE()
          WHERE  survey_id = @survey
                 AND SentFlg = 0

          SELECT DISTINCT TOP 1
                 @strClient_Nm = css.strClient_Nm,
                 @strStudy_Nm = css.strStudy_nm,
                 @strSurvey_Nm = css.strSurvey_nm,
                 @NotifyEmail = e.strEmail,
                 @survey = css.survey_id,
                 @notify_id = notify_id,
                 @client = css.client_id,
                 @study = css.study_id
          FROM   dbo.NonMailGen_Notifylog nl,
                 dbo.ClientStudySurvey_View css,
                 dbo.Study s,
                 dbo.employee e
          WHERE  s.study_id = css.study_Id
                 AND s.ademployee_id IS NOT NULL
                 AND css.survey_id = nl.survey_id
                 AND s.ademployee_id = e.employee_id
                 AND nl.survey_id = @survey
                 AND SentFlg = 0

          DELETE FROM @notifywork
          WHERE  survey_id = @survey

          SELECT TOP 1 @survey = survey_id
          FROM   @notifywork
      END

    ------------------  ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------
    UPDATE STATISTICS SentMailing

    --MB 11/19/08
    --Update Dataload tables for validation.
    --these tables hold a snapshot of what sel_qstns and sel_scles looks like when the survey is generated
    PRINT 'Before DL_SEL inserts'

    SELECT DISTINCT
           Survey_id,
           Sampleset_ID,
           mailingstep_id
    INTO   #SurveySSet
    FROM   #FG_NonMailingWork

    SELECT TOP 1 @Survey = Survey_id,
                 @SampleSet = SampleSet_ID,
                 @mailingstep_id = mailingstep_id
    FROM   #SurveySSet

    WHILE @@ROWCOUNT > 0
      BEGIN
          IF NOT EXISTS (SELECT TOP 1 *
                         FROM   dbo.DL_SEL_QSTNS_BySampleSet
                         WHERE  Survey_id = @Survey
                                AND SampleSet_ID = @Sampleset)
            BEGIN
                INSERT INTO dbo.DL_SEL_QSTNS_BySampleSet
                            (Sampleset_ID,
                             SelQstns_ID,
                             Survey_ID,
                             Language,
                             ScaleID,
                             Section_ID,
                             LABEL,
                             PLUSMINUS,
                             SUBSection,
                             ITEM,
                             SubType,
                             WIDTH,
                             HEIGHT,
                             RICHTEXT,
                             ScalePOS,
                             ScaleFLIPPED,
                             NUMMARKCOUNT,
                             BITMEANABLE,
                             NUMBUBBLECOUNT,
                             QSTNCORE,
                             BITLANGREVIEW,
                             STRFULLQUESTION)
                SELECT @Sampleset AS Sampleset_ID,
                       SelQstns_ID,
                       Survey_ID,
                       Language,
                       ScaleID,
                       Section_ID,
                       LABEL,
                       PLUSMINUS,
                       SUBSection,
                       ITEM,
                       SubType,
                       WIDTH,
                       HEIGHT,
                       RICHTEXT,
                       ScalePOS,
                       ScaleFLIPPED,
                       NUMMARKCOUNT,
                       BITMEANABLE,
                       NUMBUBBLECOUNT,
                       QSTNCORE,
                       BITLANGREVIEW,
                       STRFULLQUESTION
                FROM   dbo.Sel_Qstns
               WHERE  Survey_id = @Survey
            END

          IF NOT EXISTS (SELECT TOP 1 *
                         FROM   dbo.DL_SEL_SCLS_BySampleSet
                         WHERE  Survey_id = @Survey
                                AND SampleSet_ID = @Sampleset)
            BEGIN
                INSERT INTO dbo.DL_SEL_SCLS_BySampleSet
                            (Sampleset_ID,
                             Survey_ID,
                             QPC_ID,
                             ITEM,
                             Language,
                             VAL,
                             LABEL,
                             RICHTEXT,
                             MISSING,
                             CHARSET,
                             ScaleORDER,
                             INTRESPTYPE)
                SELECT @Sampleset AS Sampleset_ID,
                       Survey_ID,
                       QPC_ID,
                       ITEM,
                       Language,
                       VAL,
                       LABEL,
                       RICHTEXT,
                       MISSING,
                       CHARSET,
                       ScaleORDER,
                       INTRESPTYPE
                FROM   dbo.Sel_Scls
                WHERE  Survey_id = @Survey
            END

          IF NOT EXISTS (SELECT TOP 1 *
                         FROM   dbo.DL_SampleUnitSection_BySampleset
                         WHERE  SELQSTNSSURVEY_ID = @Survey
                                AND SampleSet_ID = @Sampleset)
            BEGIN
                INSERT INTO dbo.DL_SampleUnitSection_BySampleset
                            (SampleSet_ID,
                             SAMPLEUNITSECTION_ID,
                             SAMPLEUNIT_ID,
                             SELQSTNSSECTION,
                             SELQSTNSSURVEY_ID)
                SELECT @Sampleset AS Sampleset_ID,
                       SAMPLEUNITSECTION_ID,
                       SAMPLEUNIT_ID,
                       SELQSTNSSECTION,
                       SELQSTNSSURVEY_ID
                FROM   dbo.SampleUnitSection
                WHERE  SELQSTNSSURVEY_ID = @Survey
            END

          IF NOT EXISTS (SELECT TOP 1 *
                         FROM   dbo.VendorFileCreationQueue
                         WHERE  SampleSet_ID = @Sampleset
                                AND mailingstep_id = @mailingstep_id)
            BEGIN
                INSERT INTO dbo.VendorFileCreationQueue
                            (Sampleset_ID,
                             MailingStep_ID,
                             VendorFileStatus_ID)
                SELECT @Sampleset AS Sampleset_ID,
                       @MailingStep_ID AS MailingStep_ID,
                       1 AS VendorFileStatus_ID
            END

          SELECT TOP 1 @VendorFileID = VendorFile_ID
          FROM   dbo.VendorFileCreationQueue
          WHERE  sampleset_ID = @Sampleset
                 AND mailingstep_ID = @MailingStep_ID

          SELECT TOP 1 @CreateDataFileAtGeneration = CreateDataFileAtGeneration
          FROM   dbo.mailingStep ms,
                 dbo.mailingstepMethod msm
          WHERE  msm.mailingstepmethod_ID = ms.mailingstepmethod_ID
                 AND mailingStep_ID = @mailingstep_id

          --this will save off the file data into VendorFile_data for later retrieval
          IF @CreateDataFileAtGeneration = 1
            BEGIN
                EXEC dbo.QSL_SelectVendorSampleSetFileData
                  @Sampleset,
                  1,
                  0,
                  @VendorFileID,
                  1,
                  0
            END

          DELETE #SurveySSet
          WHERE  Survey_id = @Survey
                 AND SampleSet_ID = @Sampleset
                 AND mailingstep_id = @mailingstep_id

          SELECT TOP 1 @Survey = Survey_id,
                       @SampleSet = SampleSet_ID,
                       @mailingstep_id = mailingstep_id
          FROM   #SurveySSet
      END

/************/
    -- Proceed to this section if all work is done, or there is not work to process.
    COMPLETED:

    /************/
    DROP TABLE #FG_NonMailingWork

    SET NOCOUNT OFF

    RETURN
------------------  ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------



GO

