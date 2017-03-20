/*

S69 RTP-1472 modify FormGen for DGSolutions.sql

Dave Gilsdorf

DROP/CREATE PROCEDURE [dbo].[SP_FG_OutreachVendorGen]

*/
use qp_prod
go
if object_id('[dbo].[SP_FG_OutreachVendorGen]') is not null
	DROP PROCEDURE [dbo].[SP_FG_OutreachVendorGen]
go
if not exists (select * from FormGenErrorType where FGErrorType_id=44)
	insert into FormGenErrorType (FGErrorType_id, FGErrorType_dsc) values (44, 'Can''t find PatientBK(pop_mtch) or EncounterBK(enc_mtch)')

go
if not exists (select * from sys.tables st join sys.columns sc on sc.object_id=st.object_id where st.schema_id=1 and st.name='languages' and sc.name='ISO639')
	alter table Languages add ISO639 varchar(10)

update Languages set ISO639 = 
case langid
	when 1 then 'eng' --English
	when 2 then 'spa' --Spanish
	when 5 then 'spa.mex' --Mexican Spanish
	when 6 then 'fra' --French
	when 7 then 'spa' --VA Spanish
	when 8 then 'spa' --PEP-C Spanish
	when 9 then 'spa.har' --Harris Co. Spanish
	when 10 then 'fra.que' --Quebeqor
	when 11 then 'eng+fra' --English+Francophone
	when 12 then 'fra.ont' --Francophone
	when 13 then 'ita' --Italian
	when 14 then 'por' --Portuguese
	when 15 then 'hmn' --Hmong
	when 16 then 'som' --Somali
	when 17 then 'eng+ont' --English+Ontario
	when 18 then 'spa.mag' --MAGNUS Spanish
	when 19 then 'spa' --HCAHPS Spanish
	when 20 then 'spa' --Sodexho Spanish
	when 21 then 'pol' --Polish
	when 22 then 'fra.mnt' --Montfort French
	when 23 then 'ara' --Arabic
	when 24 then 'arm' --Armenian
	when 25 then 'bos' --Bosnian
	when 26 then 'khm' --Cambodian (Khmer)
	when 27 then 'chi' --Chinese
	when 28 then 'kor' --Korean
	when 29 then 'rus' --Russian
	when 30 then 'vie' --Vietnamese
	when 31 then 'per' --Persian
	when 32 then 'pan' --Punjabi
end

go
CREATE PROCEDURE [dbo].[SP_FG_OutreachVendorGen]
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
go
--Modified 11/17/3 BD Generate up to 1500 of the study that contains the top priority_flg, survey_id          
/*        
 Modified 1/23/04 SS         
 FG_MailingWork changed to #FG_MailngWork.        
 Added bitMockup = NULL column to #FG_MailingWork for compatability with FormGen_Sub         
 Added @bitTP = 0 to SP_FG_FormGen_Sub parameter list.        
 Modified 8/10/04 SS - Added sp_fg_NonMailingGen step (Generates records that will not be printed (phone/web) that need to be populated into sentmail, questionform, etc, without having to be PCL'd, bundled, etc...)         
 Mod 8/18/04 SS -- Added "IF Exists" to check for work first        
 Mod 1/4/05 BD -- Added 'update statistics SentMailing' if the last pass thru the sub routine did not run it.        
 Mod 5/20/10 DRM -- Added check for scientific notation for zip5.  
 Mod 7/08/10 DRM -- Expanded check on period in zip5 to be a "like" rather than "=".  
 Mod 6/22/2014 TSB -- Added QuestionnaireType_ID to #FG_MailingWork - AllCahps Sprint2, R3.5
 mod 10/7/2014 DBG -- added call to sp_fg_CoverVariationErrorChecking
 mod 11/15/2016 TSB -- modify TOCL disposition to use disposition_id for "TOCL during Generation" for ACO and PQRS S62 ATL-1103
*/
ALTER PROCEDURE [dbo].[SP_FG_FormGen]
  @BatchSize INT
AS
    DECLARE @Study  INT,
            @Survey INT,
			@TOCLDispositionID INT, --S62 ATL-1103
			@ACOSurveyTypeID int, --S62 ATL-1103
	        @PQRSSurveyTypeID int --S62 ATL-1103


select @ACOSurveyTypeID = SurveyType_id from dbo.SurveyType where SurveyType_dsc = 'ACOCAHPS'

select @PQRSSurveyTypeID = SurveyType_id from dbo.SurveyType where SurveyType_dsc = 'PQRS CAHPS'

    SET NOCOUNT ON;

	SELECT @TOCLDispositionID = Disposition_ID FROM dbo.Disposition where [strDispositionLabel] = 'TOCL During Generation'

    EXEC dbo.SP_FG_Fix_RespCol

    EXEC dbo.sp_FG_FormGen_Pop_PreMailingWork

	EXEC dbo.sp_fg_CoverVariationErrorChecking


    INSERT INTO dbo.FormGenLog
                (Survey_id,
                 strSampleSurvey_nm,
                 MailingStep_id,
                 intSequence,
                 datGenerated,
                 Quantity)
    SELECT pm.Survey_id,
           ss.strSampleSurvey_nm,
           pm.MailingStep_id,
           ms.intSequence,
           GETDATE(),
           COUNT(*)
    FROM   dbo.fg_preMailingWork pm,
           dbo.MailingStep ms,
           dbo.SampleSet ss
    WHERE  pm.MailingStep_id = ms.MailingStep_id
           AND pm.SampleSet_id = ss.SampleSet_id
    GROUP  BY pm.Survey_id,
              ss.strSampleSurvey_nm,
              pm.MailingStep_id,
              ms.intSequence

    -- Added 8/10/04 SS         
    -- Process any non-mail generations first, then resume processing normal mail generations.        
    -- NOTE: This procedure uses some of the same code found within sp_fg_Formgen as well as sp_fg_formgen_sub,  
    --       changes to the "shared" code should be reviewed with this in mind.        
    -- Mod 8/18/04 SS -- Added "IF Exists" to check for NonMailGen work first.        
    IF EXISTS (SELECT scheduledmailing_id
               FROM   dbo.fg_premailingwork m,
                      dbo.mailingstep ms,
                      dbo.mailingstepmethod msm
               WHERE  m.mailingstep_id = ms.mailingstep_id
                      AND ms.mailingstepmethod_id = msm.mailingstepmethod_id
                      AND msm.isNonMailgeneration = 1)
      BEGIN
		  EXEC dbo.SP_FG_OutreachVendorGen
          EXEC dbo.SP_FG_NonMailGen
      END

    -- MOD 1/20/04 SS (Changed FG_MailingWork from permanent tbl to #tbl)            
    CREATE TABLE #FG_MailingWork (study_id            INT,
                                  survey_id           INT,
                                  samplepop_id        INT,
                                  sampleset_id        INT,
                                  pop_id              INT,
                                  scheduledmailing_id INT,
                              mailingstep_id      INT,
                                  methodology_id      INT,
                                  overrideitem_id     INT,
                                  poptable_nm         CHAR(20),
                                  zipfield_nm         CHAR(20),
                                  langfield_nm        CHAR(20),
                                  zip3_cd             CHAR(3),
                                  langid              INT,
                                  selcover_id         INT,
								  bitsurveyinline     BIT,
                                  intintervaldays     INT,
                                  bitthankyouitem     BIT,
                                  bitfirstsurvey      BIT,
                                  bitsendsurvey       BIT,
                                  nextmailingstep_id  INT,
                                  intoffsetdays       INT,
                                  sentmail_id         INT,
                                  questionform_id     INT,
                                  batch_id            INT,
                                  bitDone             BIT DEFAULT 0,
                                  Priority_Flg        TINYINT,
                                  zip5                INT,
                                  zip4                INT,
                                  bitMockup           BIT DEFAULT NULL,
								  QuestionnaireType_ID INT,
								  SurveyType_id INT)   --S62 ATL-1103

    WHILE (SELECT COUNT(*)
           FROM   dbo.FG_PreMailingWork) > 0
      BEGIN
          SELECT TOP 1 @Survey = Survey_id
          FROM   dbo.FG_PreMailingWork
          ORDER  BY priority_flg,
                    Survey_id

          SELECT @Study = Study_id
          FROM   dbo.Survey_def
          WHERE  Survey_id = @Survey

          -- print 'beginning batch ' + convert(varchar,@BatchSize) + '   ' + convert(varchar,GETDATE(),113)            
          -- INSERT INTO formgenerror (ScheduledMailing_id,datgenerated,fgerrortype_id) values (@BatchSize,GETDATE(),1)            
          -- MOD 1/20/04 SS (Changed FG_MailingWork reference from permanent tbl to #tbl)            
          TRUNCATE TABLE #FG_MailingWork

          SET ROWCOUNT @BatchSize

          INSERT INTO #FG_MailingWork
                      (Study_id,
                       Survey_id,
                       SamplePop_id,
                       SampleSet_id,
                       Pop_id,
                       ScheduledMailing_id,
                       MailingStep_id,
                       Methodology_id,
                       OverrideItem_id,
                       bitSurveyInLine,
                       bitThankYouItem,
                       bitFirstSurvey,
                       bitSendSurvey,
                       intOffsetDays,
                       Priority_Flg,
                       Zip5,
                       Zip4,
					   QuestionnaireType_ID,
					   SurveyType_id) --S62 ATL-1103
          SELECT PM.Study_id,
                 PM.Survey_id,
                 PM.SamplePop_id,
                 PM.SampleSet_id,
                 PM.Pop_id,
                 PM.ScheduledMailing_id,
                 PM.MailingStep_id,
                 PM.Methodology_id,
                 PM.OverrideItem_id,
                 0,
                 0,
                 0,
                 0,
                 0,
                 PM.Priority_Flg,
                 --CASE WHEN ISNUMERIC(PM.Zip5)=0 OR PM.Zip5 = '.' THEN '99999' ELSE PM.zip5 END, PM.Zip4   
                 --DRM added check for scientific notation  
                 --DRM changed "=" to "like" for period check on zip5
                 CASE
                   WHEN ISNUMERIC(PM.Zip5) = 0
                         OR patindex('%e%', zip5) > 0
                         OR PM.Zip5 LIKE '%.%' THEN 99999
                   ELSE PM.zip5
               END,
                 PM.Zip4,
				 PM.QuestionnaireType_ID,
				 sd.SurveyType_id --S62 ATL-1103
          --     PM.Methodology_id, PM.OverrideItem_id, 0, 0, 0, 0, 0, PM.Priority_Flg, PM.Zip5, PM.Zip4            
          FROM   dbo.FG_PreMailingWork PM
		  INNER JOIN dbo.Survey_Def sd on sd.Survey_id = PM.Survey_id --S62 ATL-1103
          WHERE  PM.Study_id = @Study  
          -- AND   PM.Survey_id=@Survey            
          ORDER  BY PM.Priority_flg,
                    PM.Survey_id,
                    PM.Zip5,
                    PM.Zip4,
                    SamplePop_id

          SET ROWCOUNT 0

          UPDATE STATISTICS #FG_MailingWork

          DELETE FG_PreMailingWork
          FROM   #FG_MailingWork mw,
                 dbo.FG_PreMailingWork pm
          WHERE  pm.ScheduledMailing_id = mw.ScheduledMailing_id

     -- Delete the People on the 'Take Off Call List FROM #FG_MailingWork            
          -- We will first set the sentmail_id to -1 for the ScheduledMailing record            
          UPDATE SCHM
          SET    SentMail_ID = -1
          FROM   dbo.ScheduledMailing SCHM,
                 #FG_MailingWork M,
                 dbo.TOCL
          WHERE  TOCL.Pop_id = M.Pop_id
                 AND TOCL.Study_id = M.Study_id
                 AND M.ScheduledMailing_ID = SCHM.ScheduledMailing_ID

          --
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
                 'SP_FG_FormGen' [LoggedBy],
                 0 [DaysFromCurrent],
                 0 [DaysFromFirst]
          FROM   dbo.ScheduledMailing SCHM,
                 #FG_MailingWork M,
                 dbo.TOCL
          WHERE  TOCL.Pop_id = M.Pop_id
                 AND TOCL.Study_id = M.Study_id
                 AND M.ScheduledMailing_ID = SCHM.ScheduledMailing_ID

          DELETE FROM #FG_MailingWork
          FROM   #FG_MailingWork M,
                 dbo.TOCL
          WHERE  TOCL.Pop_id = M.Pop_id
                 AND TOCL.Study_id = M.Study_id

          IF (SELECT COUNT(*)
              FROM   #FG_MailingWork) = 0
            GOTO Completed

          -- Update the #FG_MailingWork with the rest of the attributes necessary to Form Gen            
          -- Call GetMailingAttributes(cn)            
          UPDATE #FG_MailingWork
          SET    SelCover_id = MS1.SelCover_id,
                 bitSendSurvey = MS1.bitSendSurvey--,             
          FROM   dbo.MailingStep MS1
          WHERE  #FG_MailingWork.MailingStep_id = MS1.MailingStep_id

          UPDATE #FG_MailingWork
          SET    NextMailingStep_id = MS2.MailingStep_id
          FROM   dbo.MailingStep MS1,
                 dbo.MailingStep MS2
          WHERE  #FG_MailingWork.MailingStep_id = MS1.MailingStep_id
                 AND MS1.Methodology_id = MS2.Methodology_id
                 AND MS1.intSequence
                     + 1 = MS2.intSequence

          EXEC dbo.SP_FG_FormGen_Sub
            @Study,
            @Survey,
            0

          -- "0" Indicates that Production FormGen is calling the subroutine, NOT FormGen_TP which passes "1" as the bitTP parameter.          
          -- Call AddPCLNeeded(cn)            
          EXEC dbo.SP_FG_Insert_PCLNeeded
      -- print 'ending batch    ' + convert(varchar,@BatchSize) + '   ' + convert(varchar,GETDATE(),113)            
      -- INSERT INTO formgenerror (ScheduledMailing_id,datgenerated,fgerrortype_id) values (@BatchSize,GETDATE(),2)            
      END

    COMPLETED:

    -- Added 1/20/04 ss            
    DROP TABLE #FG_MailingWork

    -- If the last pass of formgen did not update statistics, then we will do it here.          
    IF @Survey%10 <> 0
      UPDATE STATISTICS SentMailing
      -- Added 8/19/2 BD  With the ability to generate multiple MailingSteps in a single night of generation,             
      --  it is possible for the SamplePop to exist in multiple batches.            
      -- This procedure moves them to the lowest batch_id for each SamplePop_id that is duplicated.            
      EXEC dbo.SP_FG_Allign_PCLNeeded_Batches
go