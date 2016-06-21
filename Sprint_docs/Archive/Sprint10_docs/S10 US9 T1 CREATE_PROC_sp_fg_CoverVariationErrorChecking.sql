/*
S10.US9	Change to Formgen
		As a Client Services team member I want to be able to label text boxes in formlayout so that I can map text boxes to sample units. 

T9.1	Identify error conditions and logging

Dave Gilsdorf

CREATE PROCEDURE dbo.sp_fg_CoverVariationErrorChecking
ALTER PROCEDURE [dbo].[SP_FG_FormGen]
INSERT INTO FormGenErrorType 
*/
use qp_prod
go
begin tran
if exists (select * from sys.procedures where schema_id=1 and name = 'sp_fg_CoverVariationErrorChecking')
	drop procedure dbo.sp_fg_CoverVariationErrorChecking
go
if not exists (select * from FormGenErrorType where FGErrorType_id=41)
	insert into FormGenErrorType (FGErrorType_id,FGErrorType_dsc) values (41,'One or more of the named cover letter items or artifacts don''t exist')
if not exists (select * from FormGenErrorType where FGErrorType_id=42)
	insert into FormGenErrorType (FGErrorType_id,FGErrorType_dsc) values (42,'One or more of the named cover letter items are mapped to different artifacts')
if not exists (select * from FormGenErrorType where FGErrorType_id=43)
	insert into FormGenErrorType (FGErrorType_id,FGErrorType_dsc) values (43,'Can''t generate the survey because others in the survey had FGErrorType_id=42')
go
CREATE PROCEDURE dbo.sp_fg_CoverVariationErrorChecking
as

if object_id('CoverVariationLog_spCoverVariation') is NOT NULL
	delete from CoverVariationLog_spCoverVariation where CV_RunDate < dateadd(month,-3,getdate())
if object_id('CoverVariationLog_SurveyCoverVariation') is NOT NULL
	delete from CoverVariationLog_SurveyCoverVariation where CV_RunDate < dateadd(month,-3,getdate())

SELECT DISTINCT Survey_id
INTO #Survey
FROM FG_PreMailingWork

create table #CoverVariation (CoverVariation_id int identity(101,1), survey_id int, cover_id int)
create table #SurveyCoverVariation (SurveyCoverVariation_id int identity(1,1), CoverVariation_id int, survey_id int, cover_id int)
CREATE TABLE #CoverLetterItemArtifactUnitMapping (
	[Survey_id] [int] NULL,
	[SampleUnit_id] [int] NULL,
	[CoverLetterItemType_id] [tinyint] NULL,
	[CoverLetter_dsc] [varchar](60) NULL,
	[CoverLetterItem_label] [varchar](60) NULL,
	[Artifact_dsc] [varchar](60) NULL,
	[ArtifactItem_label] [varchar](60) NULL,
	[Cover_id] [int] NULL,
	[CoverItem_id] [int] NULL,
	[ArtifactPage_id] [int] NULL,
	[Artifact_id] [int] NULL
)

-- get the list of all possible cover letter variations by calling CoverVariationList for each survey's Cover Letters 
--   that have one or more items mapped to an artifact	
declare @Survey int, @cover_id int

SELECT TOP 1 @Survey=Survey_id FROM #Survey
WHILE @@ROWCOUNT>0
BEGIN
	-- get a list of the survey's current mappings. CoverVariationGetMap adds current Cover_IDs and QPC_IDs (textbox_IDs)	
	exec dbo.CoverVariationGetMap @survey

	truncate table #CoverVariation
	set @cover_id=0
	while @cover_id is not null
	begin
		select @cover_id=min(selcover_id) 
		from sel_cover
		where survey_id=@survey
		and PageType <> 4
		and SelCover_id not in (select Cover_id from #CoverVariation)
		and SelCover_id in (select Cover_id from #CoverLetterItemArtifactUnitMapping where survey_id=@survey)

		if @Cover_id is not null
			exec dbo.CoverVariationList @survey, @cover_id
	end
	insert into #SurveyCoverVariation 
	select *
	from #CoverVariation
	order by CoverVariation_id

	DELETE #Survey WHERE Survey_id=@Survey
	SELECT TOP 1 @Survey=Survey_id FROM #Survey
END

if exists (select * from #CoverLetterItemArtifactUnitMapping where coverItem_id=-1 or Artifact_id=-1 or ArtifactPage_id=-1)
begin
	-- FGErrorType_id=41 --> One or more of the named cover letter items or artifacts don't exist
    INSERT INTO formgenerror (scheduledmailing_id, datgenerated, fgerrortype_id) 
    SELECT scheduledmailing_id, Getdate(), 41
    FROM   FG_PreMailingWork mw
    where mw.survey_id in (select survey_id from #CoverLetterItemArtifactUnitMapping where coverItem_id=-1 or Artifact_id=-1 or ArtifactPage_id=-1)

    delete mw
    from FG_PreMailingWork mw
	where mw.survey_id in (select survey_id from #CoverLetterItemArtifactUnitMapping where coverItem_id=-1 or Artifact_id=-1 or ArtifactPage_id=-1)
end

/*
select * from #CoverVariation 
select * from #SurveyCoverVariation 
select * from #CoverLetterItemArtifactUnitMapping
*/

-- figure out which cover letter variation each samplepop in FG_PreMailingWork should get
-- get the list off samplepops being generated 
select distinct mw.survey_id, mw.samplepop_id, 0 as CoverVariation_id, ms.selcover_id, 0 as intFlag
into #spCoverVariation
from FG_PreMailingWork mw
inner join mailingstep ms on mw.mailingstep_id=ms.mailingstep_id

-- get the list of all the items on the cover letter(s) we're examining
select distinct st.survey_id, st.coverid, st.qpc_id --> list of all textboxes on all the cover letters
into #CoverLetterTextboxes
from sel_textbox st
inner join (select distinct survey_id, selcover_id from #spCoverVariation) mc on st.survey_id=mc.survey_id and st.coverid=mc.selcover_id


-- cycle through each item on the cover letters and determine which (if any) artifact each samplepop should use instead.
select mw.samplepop_id, map.Survey_id, map.SampleUnit_id, map.CoverLetterItemType_id
	, ms.selcover_id as CoverID, map.CoverLetter_dsc, map.CoverItem_id, map.CoverLetterItem_label
	, map.ArtifactPage_id, map.Artifact_dsc, map.Artifact_id, map.ArtifactItem_label
into #spCoverMap
from fg_Premailingwork mw
inner join mailingstep ms on mw.mailingstep_id=ms.mailingstep_id
inner join samplepop sp on mw.samplepop_id=sp.samplepop_id
inner join selectedsample ss on sp.sampleset_id=ss.sampleset_id and sp.pop_id=ss.pop_id
inner join #CoverLetterItemArtifactUnitMapping map on ss.sampleunit_id=map.sampleunit_id and ms.selcover_id=map.Cover_ID

if exists (	select survey_id, samplepop_id, coverID, CoverItem_id, count(distinct artifact_id) 
			from #spcovermap
			group by survey_id, samplepop_id, coverID, CoverItem_id
			having count(distinct artifact_id)>1 )
begin
	-- FGErrorType_id=42 --> One or more of the named cover letter items are mapped to different artifacts for this samplepop's sampled units.
	-- FGErrorType_id=43 --> Can't generate the survey because others in the survey had FGErrorType_id=42
	
	declare @ErroredSurveys table (survey_id int)
	insert into @ErroredSurveys (survey_id)
	select distinct survey_id
	from (	select survey_id, samplepop_id, coverID, CoverItem_id
			from #spcovermap
			group by survey_id, samplepop_id, coverID, CoverItem_id
			having count(distinct artifact_id)>1 ) x
	
	declare @FormGenError table (scheduledmailing_id int, fgerrortype_id int)
	-- these are the samplepops we actually have a problem with
    INSERT INTO @formgenerror (scheduledmailing_id, fgerrortype_id) 
    SELECT distinct scheduledmailing_id, 42
    FROM   fg_premailingwork mw
    inner join (select survey_id, samplepop_id, coverID, CoverItem_id
			from #spcovermap
			group by survey_id, samplepop_id, coverID, CoverItem_id
			having count(distinct artifact_id)>1 ) es on mw.survey_id=es.survey_id and mw.samplepop_id=es.samplepop_id
			
	-- these are the samplepops that have the same survey_id as people we have a problem with (we don't want to generate them either, cuz we'd just have to roll them back.)
	INSERT INTO @formgenerror (scheduledmailing_id, fgerrortype_id) 
    SELECT distinct scheduledmailing_id, 43
    FROM   fg_premailingwork mw
    inner join @erroredSurveys es on mw.survey_id=es.survey_id 
    where scheduledmailing_id not in (select scheduledmailing_id from @formgenerror)
    
    insert into FormGenError (scheduledmailing_id, datGenerated, fgerrortype_id)
    select scheduledmailing_id, getdate(), fgerrortype_id
    from @FormGenError

	delete pmw
	from FG_PreMailingWork pmw
    inner join @ErroredSurveys es on pmw.survey_id=es.survey_id
	
end

drop table #Survey
drop table #CoverVariation 
drop table #SurveyCoverVariation 
drop table #spCoverVariation
drop TABLE #CoverLetterItemArtifactUnitMapping 
drop table #spcovermap
drop table #CoverLetterTextboxes
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
*/
ALTER PROCEDURE [dbo].[SP_FG_FormGen]
  @BatchSize INT
AS
    DECLARE @Study  INT,
            @Survey INT

    SET NOCOUNT ON;

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
								  QuestionnaireType_ID INT)

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
					   QuestionnaireType_ID)
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
				 PM.QuestionnaireType_ID
          --     PM.Methodology_id, PM.OverrideItem_id, 0, 0, 0, 0, 0, PM.Priority_Flg, PM.Zip5, PM.Zip4            
          FROM   dbo.FG_PreMailingWork PM
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
                 8 [Disposition_id],
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
commit tran