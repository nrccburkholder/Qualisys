/*
	RTP-3594 SP_FG_OutreachVendorGen - Rollback.sql

	Lanny Boswell

	8/21/2017

	ALTER PROCEDURE SP_FG_OutreachVendorGen

*/

USE [QP_PROD]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_FG_OutreachVendorGen]
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
    -- Gather all outreach work into a #tbl
    SELECT m.study_id,
           m.survey_id,
           m.samplepop_id,
		   convert(varchar(42),null) as PatientBK,
		   convert(varchar(42),null) as EncounterBK,
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
           convert(int,NULL) AS NextMailingStep_id,
           0 AS bitSendSurvey,
           0 AS LangID,
		   sd.SurveyType_id
    INTO   #FG_OutreachWork
    FROM   dbo.fg_premailingwork m,
           dbo.mailingstep ms,
           dbo.MailingStepMethod MSM,
		   dbo.Survey_Def sd, -- S62 ATL-1103
		   dbo.SurveySubtype sst,
		   dbo.Subtype st,
		   dbo.SurveyTypeSubType stst 
    WHERE  m.mailingstep_id = ms.mailingstep_id
           AND ms.mailingstepmethod_id = MSM.mailingstepmethod_id
           AND MSM.IsNonMailGeneration = 1
		   AND sd.Survey_id = m.Survey_id --S62 ATL-1103
		   AND sd.Survey_id=sst.Survey_id 
		   AND sst.Subtype_id=st.SubType_ID
		   AND st.Subtype_id = stst.Subtype_id
		   AND st.SubType_NM = 'RT'
		   and stst.SurveyType_id = 2
		   
    IF (SELECT COUNT(*)
        FROM   #FG_OutreachWork) = 0
      GOTO Completed

    -- Remove from source table the records we have moved into our work table.
    DELETE pw
    FROM   dbo.FG_PreMailingWork pw,
           #FG_OutreachWork mw
    WHERE  pw.ScheduledMailing_id = mw.ScheduledMailing_id

    ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
/************/
    -- The following code also occurs in sp_fg_formgen for records that will be printed/mailed.
/************/
    -- Delete the People on the 'Take Off Call List FROM #FG_OutreachWork
    -- We will first set the sentmail_id to -1 for the ScheduledMailing record
    UPDATE SCHM
    SET    SentMail_ID = -1
    FROM   dbo.ScheduledMailing SCHM,
           #FG_OutreachWork M,
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
           'SP_FG_OutreachVendor' [LoggedBy],
           0 [DaysFromCurrent],
           0 [DaysFromFirst]
    FROM   dbo.ScheduledMailing SCHM,
           #FG_OutreachWork M,
           dbo.TOCL
    WHERE  TOCL.Pop_id = M.Pop_id
           AND TOCL.Study_id = M.Study_id
           AND M.ScheduledMailing_ID = SCHM.ScheduledMailing_ID

    DELETE M
    FROM   #FG_OutreachWork M,
           dbo.TOCL
    WHERE  TOCL.Pop_id = M.Pop_id
           AND TOCL.Study_id = M.Study_id

    -- If no work left we can skip to the end
    IF (SELECT COUNT(*)
        FROM   #FG_OutreachWork) = 0
      GOTO Completed

    ------------------  ------------------ ------------------ ------------------ ------------------ ------------------ ------------------
    -- Else .....
    -- Update the #FG_MailingWork with the rest of the attributes necessary to Generate
    -- Update bitSendSurvey
    UPDATE #FG_OutreachWork
    SET    bitSendSurvey = MS1.bitSendSurvey
    FROM   dbo.MailingStep MS1
    WHERE  #FG_OutreachWork.MailingStep_id = MS1.MailingStep_id

    -- Update NextMailinStep_id
    UPDATE #FG_OutreachWork
    SET    NextMailingStep_id = MS2.MailingStep_id
    FROM   dbo.MailingStep MS1,
           dbo.MailingStep MS2
    WHERE  #FG_OutreachWork.MailingStep_id = MS1.MailingStep_id
           AND MS1.Methodology_id = MS2.Methodology_id
           AND MS1.intSequence
               + 1 = MS2.intSequence

    ------------------  ------------------ ------------------ ------------------ ------------------ ------------------ ------------------
    -- Loop by study to update the langid field
    INSERT INTO @studies
                (study_id)
    SELECT DISTINCT
           study_id
    FROM   #FG_OutreachWork

    WHILE (SELECT COUNT(*)
           FROM   @studies) > 0
      BEGIN
          SELECT TOP 1 @study = study_id
          FROM   @studies

          SET @sql = 'UPDATE nmw SET LangID = ISNULL(p.LangID, 1), PatientBK = p.Pop_mtch FROM #FG_OutreachWork nmw, samplepop sp,  s'
                     + LTRIM(STR( @study))
                     + '.Population p WHERE nmw.samplepop_id = sp.samplepop_id AND sp.pop_id = p.pop_id'
          EXEC (@sql)

		  if object_ID('s' + LTRIM(STR( @study)) + '.Encounter') IS NOT NULL
		  BEGIN
			  set @sql = 'update ow ' + 
						'set EncounterBK = e.Enc_mtch ' + 
						'from #FG_OutreachWork ow ' + 
						'join selectedSample ss on ow.sampleset_id=ss.sampleset_id and ow.pop_id=ss.pop_id and ss.STRUNITSELECTTYPE=''D'' ' + 
						'join s' + LTRIM(STR( @study)) + '.Encounter e on ss.pop_id=e.pop_id and ss.enc_id=e.enc_id'
			  EXEC (@sql)
		  END

          DELETE FROM @studies
          WHERE  study_id = @study

          SELECT TOP 1 @study = study_id
          FROM   @studies
      END

	if exists (select 1 from #FG_OutreachWork where PatientBK is null or EncounterBK is null)
	begin
		insert into FormGenError (ScheduledMailing_id, datGenerated, FGErrorType_id)
		select ScheduledMailing_id, getdate(), 44
		from #FG_OutreachWork
		where PatientBK is null or EncounterBK is null
		
		delete from #FG_OutreachWork 
		where PatientBK is null or EncounterBK is null
	end

	-- If no work left we can skip to the end
    IF (SELECT COUNT(*)
        FROM   #FG_OutreachWork) = 0
      GOTO Completed

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
             'Outreach' AS strPostalBundle,
             0 AS IntPages,
             @GetDate AS datBundled
      FROM   #FG_OutreachWork

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
            FROM   #FG_OutreachWork

            TRUNCATE TABLE #FG_OutreachWork

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
      FROM   #FG_OutreachWork

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
            FROM       #FG_OutreachWork mw
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
                        FROM   #FG_OutreachWork

                        TRUNCATE TABLE #FG_OutreachWork

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
             #FG_OutreachWork MW
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
            FROM   #FG_OutreachWork

            TRUNCATE TABLE #FG_OutreachWork

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
      FROM   #FG_OutreachWork

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
                  FROM   #FG_OutreachWork

                  TRUNCATE TABLE #FG_OutreachWork

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
            FROM   #FG_OutreachWork

            TRUNCATE TABLE #FG_OutreachWork

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
             #FG_OutreachWork MW
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
            FROM   #FG_OutreachWork

            TRUNCATE TABLE #FG_OutreachWork

            RETURN
        END

      exec dbo.CalcCAHPSSupplemental @QFMax

      ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
      --SCHEDULE THE NEXT UNGENERATED RECORD
      -- Only want to schedule the next ungenerated record - include seeded recipients only on mail steps
      INSERT INTO dbo.ScheduledMailing
                  (MailingStep_id,
                   SamplePop_id,
                   Methodology_id,
                   datGenerate)
      SELECT          mw.NextMailingStep_id,
                      mw.SamplePop_id,
                      mw.Methodology_id,
                      '12/31/4172'
      FROM            #FG_OutreachWork mw
	  inner join Mailingstep ms(NOLOCK) on mw.nextMailingStep_id = ms.MailingStep_id --S55 ATL-180
      LEFT OUTER JOIN #FG_OutreachWork mw2
                   ON mw.NextMailingStep_id = mw2.MailingStep_id
                      AND mw.SamplePop_id = mw2.SamplePop_id
      WHERE           mw.NextMailingStep_id IS NOT NULL
                      AND mw.OverrideItem_id IS NULL
                      AND mw2.MailingStep_id IS NULL
					  and (mw.Pop_id > 0	or ms.MailingStepMethod_id in (0,10,11))	--S55 ATL-180

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
            FROM   #FG_OutreachWork

            TRUNCATE TABLE #FG_OutreachWork

            RETURN
        END

      -- Now lets SET DATMAILED and prepare NEXTMAILINGSTEP table so the next FormGen batch
      --can set datGenerate on the newly scheduled records.
      DELETE FROM @surveywork

      INSERT INTO @surveywork
                  (survey_id)
      SELECT DISTINCT
             Survey_id
      FROM   #FG_OutreachWork

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
                  FROM   #FG_OutreachWork

                  TRUNCATE TABLE #FG_OutreachWork

                  RETURN
              END

            DELETE FROM @surveywork
            WHERE  Survey_id = @Survey

            SELECT TOP 1 @Survey = Survey_id
            FROM   @surveywork
        END

      ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
      -- POPULATE OutreachRequest FOR WHAT WE HAVE PROCESSED
	  declare @OutreachVendorID int
	  select @OutreachVendorID = OutreachVendorID from RTPhoenix.OutreachVendor where name = 'DG Solutions'
	  
      INSERT INTO RTPhoenix.OutreachRequest 
			(PatientID, MailingID, OutreachVendorID, PatientBK, EncounterBK, CustomerID, Attempt, Language, BlockFurtherAttempts)
      SELECT DISTINCT
			QF.Samplepop_id as PatientID, 
			SM.strLithoCode as MailingID,
			@OutreachVendorID as OutreachVendorID,
			ow.PatientBK,
			ow.EncounterBK,
			st.CLIENT_ID	as CustomerID,
			MS.INTSEQUENCE	as Attempt,
			L.ISO639		as Language,
			0				as BlockFurtherAttempts
      FROM #FG_OutreachWork ow
      JOIN dbo.SentMailing SM on ow.ScheduledMailing_id = SM.ScheduledMailing_id
	  JOIN dbo.ScheduledMailing SCM on ow.ScheduledMailing_id = SCM.ScheduledMailing_id
	  JOIN dbo.MailingStep MS on SCM.MAILINGSTEP_ID = MS.MAILINGSTEP_ID
      JOIN dbo.QuestionForm QF on SM.SentMail_id = QF.SentMail_id
      JOIN dbo.Survey_def SD on QF.Survey_id = SD.Survey_id
      JOIN dbo.Study ST on SD.Study_id = ST.Study_id
	  JOIN dbo.Languages L on ow.langid=l.LangID

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
            FROM   #FG_OutreachWork

            TRUNCATE TABLE #FG_OutreachWork

            RETURN
        END
  ------------------  ------------------ ------------------ ------------------ ------------------ ------------------
  END

    COMMIT TRANSACTION

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
    FROM   #FG_OutreachWork

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
    DROP TABLE #FG_OutreachWork

    SET NOCOUNT OFF

    RETURN
------------------  ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------

GO

