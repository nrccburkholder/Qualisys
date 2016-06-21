/*
	S19.US14 Hospice CAHPS Dispositions
		As a Hospice CAHPS vendor, we need to be able to assign the appropriate final disposition so it can be reported to CMS.

	T14.2	For mixed mode, only add bad phone if both address and phone is bad. Testing will take place when testing Hospice CAHP completeness check. 

Dave Gilsdorf

qp_Prod:
INSERT INTO dbo.Disposition
INSERT INTO dbo.SurveyTypeDispositions
CREATE PROCEDURE [dbo].[CheckHospiceCAHPSDispositions]

NRC_Datamart_ETL:
CREATE PROCEDURE [dbo].[csp_CAHPSProcesses] 
ALTER PROCEDURE [dbo].[csp_GetQuestionFormExtractData] 

*/

/*	====================================================================
								MANUAL UPDATE
	====================================================================
Add a new step to catdb2's DatamartDailyLoad job, prior to the MetaDataExtract step
	Step Name: CAHPS pre-processing
	Type: Transact-SQL script
	Database: NRC_Datamart
	Command: exec Qualisys.NRC_Datamart_ETL.dbo.csp_CAHPSProcesses
	On success: Go to the next step
	On failure: Goto step [?] DataMartDailyLoad Failed Notification

NOTE: if the step you're adding is the new first step, be sure to change the designated Start step.

*/
use qp_prod
go
if not exists (select * from dbo.Disposition where strDispositionLabel='Unused Bad Address')
	insert into dbo.Disposition (strDispositionLabel,Action_id,strReportLabel,MustHaveResults)
	values ('Unused Bad Address', 0, 'Unused Non Response Bad Address', 0)

if not exists (select * from dbo.Disposition where strDispositionLabel='Unused Bad Phone')
	insert into dbo.Disposition (strDispositionLabel,Action_id,strReportLabel,MustHaveResults)
	values ('Unused Bad Phone', 0, 'Unused Non Response Bad Phone', 0)

if not exists (select * from dbo.Disposition where strDispositionLabel='Unused Bad Address' and Disposition_id=46)
	RAISERROR (N'Unused Bad Address was supposed to be Disposition_id=46!', 10, 1)

if not exists (select * from dbo.Disposition where strDispositionLabel='Unused Bad Phone' and Disposition_id=47)
	RAISERROR (N'Unused Bad Phone was supposed to be Disposition_id=47!', 10, 1)
           
go
if not exists (select * from dbo.SurveyTypeDispositions where [Desc]='Non-response: Unused Bad Address')
	insert into dbo.SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
	values (46, 9, 12, 'Non-response: Unused Bad Address', 0, NULL, 11)
	
if not exists (select * from dbo.SurveyTypeDispositions where [Desc]='Non-response: Unused Bad/No Telephone Number')	
	insert into dbo.SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
	values (47, 9, 12, 'Non-response: Unused Bad/No Telephone Number', 0, NULL, 11)
	
if exists (select * from dbo.SurveyTypeDispositions where Hierarchy=9 and [desc]='Non-response: Bad Address')
	update dbo.SurveyTypeDispositions set Hierarchy=10 where Hierarchy=9 and [desc]='Non-response: Bad Address'

if exists (select * from dbo.SurveyTypeDispositions where Hierarchy=10 and [desc]='Non-response: Bad/No Telephone Number')
	update dbo.SurveyTypeDispositions set Hierarchy=9 where Hierarchy=10 and [desc]='Non-response: Bad/No Telephone Number'
	
go
use nrc_datamart_etl
go
-- =============================================
-- Author:	Kathi Nussralalh
-- Procedure Name: csp_GetQuestionFormExtractData
-- Create date: 3/01/2009 
-- Description:	Stored Procedure that extracts question form data from QP_Prod
-- History: 1.0  3/01/2009  by Kathi Nussralalh
--          1.1 modifed logic to handle DatUndeliverable changes
--			1.2 by ccaouette: ACO CAHPS Project
--          1.3 by dgilsdorf: CheckForACOCAHPSIncompletes changed to CheckForCAHPSIncompletes
--          1.4 by dgilsdorf: added call to CheckForMostCompleteUsablePartials for HHCAHPS and ICHCAHPS processing
--          1.5 by dgilsdorf: moved CAHPS processing procs to earlier in the ETL
-- =============================================
ALTER PROCEDURE [dbo].[csp_GetQuestionFormExtractData] 
	@ExtractFileID int 
	
--exec [dbo].[csp_GetQuestionFormExtractData]  2238
AS
	SET NOCOUNT ON 

	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT;

	declare @EntityTypeID int
	set @EntityTypeID = 11 -- QuestionForm
--
 --   declare @ExtractFileID int
	--set @ExtractFileID = 539 -- 

	---------------------------------------------------------------------------------------
	-- ACO CAHPS Project
	-- ccaouette: 2014-05
	---------------------------------------------------------------------------------------
	--DECLARE @country VARCHAR(10)
	--SELECT @country = [STRPARAM_VALUE] FROM [QP_Prod].[dbo].[qualpro_params] WHERE STRPARAM_NM = 'Country'
	--select @country
	--IF @country = 'US'
	--BEGIN
	--	EXEC [QP_Prod].[dbo].[CheckForCAHPSIncompletes] 
	--	EXEC [QP_Prod].[dbo].[CheckForACOCAHPSUsablePartials]
	--	EXEC [QP_Prod].[dbo].[CheckForMostCompleteUsablePartials] -- HHCAHPS and ICHCAHPS
	--END	

	---------------------------------------------------------------------------------------
	-- Load records to Insert/Update into a temp table
	-- Changed 2009.11.09 to handle surveytypeid = 3 surveys by kmn
	---------------------------------------------------------------------------------------

	-- clean up any records that might be in the tables already
	delete QuestionFormTemp where ExtractFileID = @ExtractFileID

	insert QuestionFormTemp 
			(ExtractFileID, QUESTIONFORM_ID, SURVEY_ID,SurveyType_id,SAMPLEPOP_ID,strLithoCode, isComplete, ReceiptType_id
             , returnDate, DatMailed,DatExpire,DatGenerated,DatPrinted,DatBundled,DatUndeliverable,IsDeleted)
		select distinct @ExtractFileID, qf.QUESTIONFORM_ID, qf.SURVEY_ID,sd.SurveyType_id, qf.SAMPLEPOP_ID,sm.strLithoCode, 
			   case when qf.bitComplete <> 0 then 'true' else 'false' end, 
			   qf.ReceiptType_id,qf.datReturned , sm.DatMailed, sm.DatExpire, sm.DatGenerated, sm.DatPrinted, sm.DatBundled, sm.DatUndeliverable,0
  --      select *
		 from (select distinct PKey1 
                        from ExtractHistory  with (NOLOCK) 
                         where ExtractFileID = @ExtractFileID
	                     and EntityTypeID = @EntityTypeID
	                     and IsDeleted = 0 ) eh
				inner join QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.QUESTIONFORM_ID = eh.PKey1
               	inner join QP_Prod.dbo.SentMailing sm With (NOLOCK) on qf.SentMail_id = sm.SentMail_id   
                inner join QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on sp.samplepop_id = qf.SAMPLEPOP_ID	
                inner join QP_Prod.dbo.Survey_def sd With (NOLOCK) on qf.SURVEY_ID = sd.SURVEY_ID
                left join SampleSetTemp sst with (NOLOCK) on sp.sampleset_id = sst.sampleset_id 
                                     and sst.ExtractFileID = @ExtractFileID and sst.IsDeleted = 1
	    where (qf.DATRETURNED is not null OR sm.DatUndeliverable is not NULL ) 
	           and sp.POP_ID > 0
	           and sst.sampleset_id is NULL --excludes questionforms/sample pops that will be deleted due to sampleset deletes
	    
---------------------------------------------------------------------------------------	    
-- Add code to determine days from first mailing as well as days from current mailing until the return    
-- Get all of the maildates for the samplepops were are extracting    
---------------------------------------------------------------------------------------
	SELECT e.SamplePop_id, strLithoCode, MailingStep_id, CONVERT(DATETIME,CONVERT(VARCHAR(10),ISNULL(datMailed,datPrinted),120)) datMailed  
	INTO #Mail    
	FROM (SELECT SamplePop_id FROM QuestionFormTemp WITH (NOLOCK) WHERE ExtractFileID = @ExtractFileID GROUP BY SamplePop_id) e
	INNER JOIN QP_Prod.dbo.ScheduledMailing schm WITH (NOLOCK) ON e.SamplePop_id=schm.SamplePop_id  
	INNER JOIN QP_Prod.dbo.SentMailing sm WITH (NOLOCK) ON schm.SentMail_id=sm.SentMail_id  


	-- Update the work table with the actual number of days    
	UPDATE QuestionFormTemp
	SET datFirstMailed = FirstMail.datMailed
	,DaysFromFirstMailing=DATEDIFF(DAY,FirstMail.datMailed,returnDate)
	,DaysFromCurrentMailing=DATEDIFF(DAY,CurrentMail.datMailed,returnDate)  
	--SELECT *  
	FROM QuestionFormTemp qftemp WITH (NOLOCK)     
	INNER JOIN  (SELECT SamplePop_id, MIN(datMailed) datMailed FROM #Mail GROUP BY SamplePop_id) FirstMail ON qftemp.SamplePop_id=FirstMail.SamplePop_id  
	INNER JOIN #Mail CurrentMail ON qftemp.SamplePop_id = CurrentMail.SamplePop_id AND qftemp.strLithoCode=CurrentMail.strLithoCode      
	WHERE qftemp.ExtractFileID = @ExtractFileID 

	drop table #Mail  
	
	-- Make sure there are no negative days.    
	UPDATE QuestionFormTemp
	SET DaysFromFirstMailing = 0 
	--SELECT *  
	FROM QuestionFormTemp WITH (NOLOCK)  
	WHERE DaysFromFirstMailing < 0 AND ExtractFileID = @ExtractFileID 

	UPDATE QuestionFormTemp
	SET DaysFromCurrentMailing = 0 
	--SELECT *  
	FROM QuestionFormTemp WITH (NOLOCK)  
	WHERE DaysFromCurrentMailing < 0 AND ExtractFileID = @ExtractFileID    
  
 ---------------------------------------------------------------------------------------
 -- Update bitComplete flag for HCACHPS seurveys
 ---------------------------------------------------------------------------------------
	UPDATE qft 
	SET isComplete=CASE WHEN QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID) <> 0 THEN 'true' ELSE 'false' END
	--SELECT *--isComplete=QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID),*
	FROM QuestionFormTemp qft 
    WHERE ExtractFileID = @ExtractFileID AND SurveyType_id=2
    
    UPDATE qft 
	SET isComplete=CASE WHEN QP_Prod.dbo.HHCAHPSCompleteness(QUESTIONFORM_ID) <> 0 THEN 'true' ELSE 'false' END
	--SELECT *--isComplete=QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID),*
	FROM QuestionFormTemp qft 
    WHERE ExtractFileID = @ExtractFileID AND SurveyType_id=3
    
    UPDATE qft 
	SET isComplete=CASE WHEN QP_Prod.dbo.MNCMCompleteness(QUESTIONFORM_ID) <> 0 THEN 'true' ELSE 'false' END
	--SELECT *--isComplete=QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID),*
	FROM QuestionFormTemp qft 
    WHERE ExtractFileID = @ExtractFileID AND SurveyType_id=4

 ---------------------------------------------------------------------------------------
 -- Load records to deletes into a temp table
  ---------------------------------------------------------------------------------------
 insert QuestionFormTemp 
			(ExtractFileID, QUESTIONFORM_ID, SAMPLEPOP_ID,strLithoCode,IsDeleted )
		select distinct @ExtractFileID, IsNull(qf.QUESTIONFORM_ID,-1), IsNull(qf.SAMPLEPOP_ID,-1),IsNull(IsNull(eh.PKey2,sm.strLithoCode),-1),1 
  --      select *
		 from (select distinct PKey1 ,PKey2
                        from ExtractHistory  with (NOLOCK) 
                         where ExtractFileID = @ExtractFileID
	                     and EntityTypeID = @EntityTypeID
	                     and IsDeleted = 1 ) eh
				Left join QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.QUESTIONFORM_ID = eh.PKey1 AND qf.DATRETURNED IS NULL--if datReturned is not NULL it is not a delete
				Left join QP_Prod.dbo.SentMailing sm With (NOLOCK) on qf.SentMail_id = sm.SentMail_id

  	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2

go
use qp_Prod
go
if exists (select * from sys.procedures where schema_id=1 and name = 'CheckHospiceCAHPSDispositions')
	DROP PROCEDURE [dbo].[CheckHospiceCAHPSDispositions]
go
CREATE PROCEDURE [dbo].[CheckHospiceCAHPSDispositions]
as
-- created 3/1/2015 DBG
-- As a Hospice CAHPS vendor, we need to be able to assign the appropriate final disposition so it can be reported to CMS.
-- For mixed mode methodology, only add bad phone & address if both address and phone are bad. 

create table #EQ (
	[ExtractQueueID] [int] NOT NULL,
	[EntityTypeID] [int] NOT NULL,
	[PKey1] [int] NOT NULL,
	[PKey2] [int] NULL,
	[IsMetaData] [bit] NOT NULL,
	[ExtractFileID] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Source] [nvarchar](50) NOT NULL,
	[bitArchived] bit NOT NULL)

-- list of all ExtractQueue records for bad addr/phone dispositions that haven't been processed
insert into #EQ ([ExtractQueueID],[EntityTypeID],[PKey1],[PKey2],[IsMetaData],[ExtractFileID], [IsDeleted],[Created],[Source], [bitArchived])
select [ExtractQueueID],[EntityTypeID],[PKey1],[PKey2],[IsMetaData],[ExtractFileID], [IsDeleted],[Created],[Source], 0
from NRC_DataMart_ETL.dbo.ExtractQueue 
where entitytypeID=14 -- dispositionlog
and pkey2 in (5,14,16,46,47) -- disposition_id
and ExtractFileID is null 

-- remove non-hospice cahps surveys
delete eq
from #EQ eq
inner join dbo.samplepop sp on eq.PKey1=sp.samplepop_id
inner join dbo.sampleset ss on sp.sampleset_id=ss.sampleset_id
inner join dbo.survey_def sd on ss.survey_id=sd.survey_id
inner join dbo.Surveytype st on sd.Surveytype_id=st.Surveytype_id
WHERE st.SurveyType_dsc <> 'Hospice CAHPS'

-- remove non-mixed methodologies 
delete eq
from #EQ eq
inner join dbo.questionform qf on eq.PKey1=qf.samplepop_id
inner join dbo.sentmailing sm on qf.sentmail_id=sm.sentmail_id
inner join dbo.mailingmethodology mm on sm.methodology_id=mm.methodology_id
where mm.StandardMethodologyID<>26 -- Hospice Mixed Mail-Phone

if not exists (select * from #eq)
begin
	drop table #EQ
	return
end

-- if anyone is left in the table, add in any previously processed dispositions
insert into #EQ ([ExtractQueueID],[EntityTypeID],[PKey1],[PKey2],[IsMetaData],[ExtractFileID], [IsDeleted],[Created],[Source],[bitArchived])
select p.[ExtractQueueID],p.[EntityTypeID],p.[PKey1],p.[PKey2],p.[IsMetaData],p.[ExtractFileID], p.[IsDeleted],p.[Created],p.[Source], 0
from nrc_datamart_etl.dbo.ExtractQueue p
inner join (select distinct pkey1 from #eq) t on p.pkey1=t.pkey1
where p.entitytypeID=14 -- dispositionlog
and p.pkey2 in (5,14,16,46,47) -- disposition_id
and p.ExtractFileID is not null 

insert into #EQ ([ExtractQueueID],[EntityTypeID],[PKey1],[PKey2],[IsMetaData],[ExtractFileID], [IsDeleted],[Created],[Source],[bitArchived])
select p.[ExtractQueueArchiveID],p.[EntityTypeID],p.[PKey1],p.[PKey2],p.[IsMetaData],p.[ExtractFileID], p.[IsDeleted],p.[Created],p.[Source], 1
from nrc_datamart_etl.dbo.ExtractQueueArchive p
inner join (select distinct pkey1 from #eq) t on p.pkey1=t.pkey1
where p.entitytypeID=14 -- dispositionlog
and p.pkey2 in (5,14,16,46,47) -- disposition_id
and p.ExtractFileID is not null 

-- create a list of samplepop_id's with three bit fields: 
	-- have they ever had a bad address disp? 
	-- have they ever had a bad phone disp? 
	-- have they ever had an unused disp? 
select eq.pkey1 as samplepop_id 
	, max(case when eq.pkey2 in (5,46) then 1 else 0 end) as BadAddr
	, max(case when eq.pkey2 in (14,16,47) then 1 else 0 end) as BadPhone
	, max(case when eq.pkey2 in (46,47) then 1 else 0 end) as UnusedDisps
into #Hospice
FROM #EQ eq
group by eq.pkey1

if @@rowcount>0
begin
	-- if there's a bad address, but no bad phone - change the bad addr disposition(s) to "unused bad addr"
	-- remove "bad addr" from ExtractQueue
	update p set ExtractFileID = -1
	from #Hospice h
	inner join #eq t on h.samplepop_id=t.pkey1 
	inner join NRC_Datamart_etl.dbo.ExtractQueue p on t.ExtractQueueID=p.ExtractQueueID
	where h.BadAddr=1 and h.BadPhone=0 
	and t.bitArchived=0
	and t.ExtractFileID is null
	and t.pkey2 in (5)
	
	-- change bad addr to unused bad addr in dispositionlog. a trigger will insert unused bad addr to ExtractQueue
	update dl set disposition_id=46, LoggedBy = left(LoggedBy + ',CheckHospiceCAHPSDispositions',42)
	from #Hospice h
    inner join dbo.dispositionlog dl on h.samplepop_id=dl.samplepop_id
	where h.BadAddr=1 and h.BadPhone=0 and dl.disposition_id in (5)


	-- if there's a bad phone, but no bad addr - change the bad phone disposition(s) to "unused bad phone"
	-- remove "bad phone" from ExtractQueue
	update p set ExtractFileID = -1
	from #Hospice h
	inner join #eq t on h.samplepop_id=t.pkey1 
	inner join NRC_Datamart_etl.dbo.ExtractQueue p on t.ExtractQueueID=p.ExtractQueueID
	where h.BadAddr=0 and h.BadPhone=1 
	and t.bitArchived=0
	and t.ExtractFileID is null
	and t.pkey2 in (14,16)

	-- change bad phone to unused bad phone in dispositionlog. a trigger will insert unused bad phone to ExtractQueue
	update dl set disposition_id=47, LoggedBy = left(LoggedBy + ',CheckHospiceCAHPSDispositions',42)
	from #Hospice h
    inner join dbo.dispositionlog dl on h.samplepop_id=dl.samplepop_id
	where h.BadAddr=0 and h.BadPhone=1 and dl.disposition_id in (14,16)

	
	-- if there's both bad phone and bad addr - change any previously Unused dispositions back to used
	-- remove "unused bad phone" and "unused bad addr" from ExtractQueue
	update p set ExtractFileID = -1
	from #Hospice h
	inner join #eq t on h.samplepop_id=t.pkey1 
	inner join NRC_Datamart_etl.dbo.ExtractQueue p on t.ExtractQueueID=p.ExtractQueueID
	where h.BadAddr=1 and h.BadPhone=1 and h.UnusedDisps=1 
	and t.bitArchived=0
	and t.ExtractFileID is null
	and t.pkey2 in (46,47)
	
	-- change unused bad addr to bad addr and unused bad phone to bad phone in dispositionlog. a trigger will insert the appropriate record to ExtractQueue
	update dl set disposition_id=case when dl.disposition_id=46 then 5 else 14 end
	from #Hospice h
    inner join dbo.dispositionlog dl on h.samplepop_id=dl.samplepop_id
	where h.BadAddr=1 and h.BadPhone=1 and h.UnusedDisps=1 and dl.disposition_id in (46,47)
end
drop table #Hospice
go
use NRC_Datamart_ETL
go
if exists (select * from sys.procedures where schema_id=1 and name = 'csp_CAHPSProcesses')
	DROP PROCEDURE [dbo].[csp_CAHPSProcesses] 
go
CREATE PROCEDURE [dbo].[csp_CAHPSProcesses] 
AS
-- this code was previously in NRC_Datamart_ETL.dbo.csp_CAHPSProcesses. We're putting it in its own proc so that 
-- it can be called at the beginning of the ETL, instead of in the middle.

	DECLARE @country VARCHAR(10)
	SELECT @country = [STRPARAM_VALUE] FROM [QP_Prod].[dbo].[qualpro_params] WHERE STRPARAM_NM = 'Country'
	select @country
	IF @country = 'US'
	BEGIN
		EXEC [QP_Prod].[dbo].[CheckForCAHPSIncompletes] 
		EXEC [QP_Prod].[dbo].[CheckForACOCAHPSUsablePartials]
		EXEC [QP_Prod].[dbo].[CheckForMostCompleteUsablePartials] -- HHCAHPS and ICHCAHPS
		EXEC [QP_Prod].[dbo].[CheckHospiceCAHPSDispositions]
	END
go
