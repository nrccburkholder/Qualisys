/*
	S20.US12 HHCAHPS Q1 Check for Dispo
		As an Authorized Vendor for HHCAHPS, we want to assign the correct disposition based on the response to Q1, so that we are submitting correct data

	T12.2	Modify the ???? SP in Medusa ETL

Dave Gilsdorf

NRC_DataMart_ETL:
ALTER PROCEDURE [dbo].[csp_GetQuestionFormExtractData]

*/
USE NRC_DataMart_ETL
GO
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