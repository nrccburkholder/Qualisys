/*
	RTP-3594 SP_FG_FormGen.sql

	Lanny Boswell

	8/21/2017

	ALTER PROCEDURE SP_FG_FormGen

*/

USE [QP_PROD]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO

