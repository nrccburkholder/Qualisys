/*
	S47 ATL-259 Fix Catalyst ETL so that final disposition conforms to the number of questions answered
	Complete / Incomplete dispos match between data already in Catalyst and the disposition (Final disposition doesn't agree with the number of questions answered)
	
	ATL-259 Review CSP_GetQuestionFormExtractData procedure
	
*/
use NRC_DataMart_ETL
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
--          1.6 by dgilsdorf: changed call to HHCAHPSCompleteness from a function to a procedure
--			1.7 by ccaouette: check for duplicate questionform (same samplepop_id)
--			S42 US13 OAS: Language in which Survey Completed As an OAS-CAHPS vendor, we need to report the language in which the survey was completed, so we follow submission file specs. 02/04/2016 TSB
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
	DELETE QuestionFormTemp where ExtractFileID = @ExtractFileID;

	-- CTE finds duplicate questionforms in ExtractHistory table
	WITH cteEH AS
	(
				SELECT eh1.PKey1, eh1.Pkey2, eh1.EntityTypeID, eh1.IsDeleted, eh1.Created
				FROM ExtractHistory eh1
				INNER JOIN (SELECT DISTINCT PKey1, Pkey2, EntityTypeID
								FROM ExtractHistory  with (NOLOCK) 
									WHERE ExtractFileID = @ExtractFileID
									AND EntityTypeID = @EntityTypeID --and pkey2 = '186064012'
									GROUP BY PKey1, Pkey2,EntityTypeID
									having COUNT(*) > 1) eh2 ON eh1.PKey1 = eh2.PKey1 AND (eh1.PKey2 = eh2.Pkey2 OR eh1.PKey2 IS NULL) AND eh1.EntityTypeID = eh2.EntityTypeID
				WHERE ExtractFileID = @ExtractFileID								
	)


	INSERT INTO QuestionFormTemp 
			(ExtractFileID
			, QUESTIONFORM_ID
			, SURVEY_ID
			, SurveyType_id
			, SAMPLEPOP_ID
			, strLithoCode
			, isComplete
			, ReceiptType_id
            , returnDate
			, DatMailed, DatExpire, DatGenerated, DatPrinted, DatBundled, DatUndeliverable
			,IsDeleted
			,[LangID])
	SELECT DISTINCT @ExtractFileID
						, qf.QUESTIONFORM_ID
						, qf.SURVEY_ID
						, sd.SurveyType_id
						, qf.SAMPLEPOP_ID
						, sm.strLithoCode
						, CASE WHEN qf.bitComplete <> 0 THEN 'true' ELSE 'false' END 
						, qf.ReceiptType_id
						, qf.datReturned 
						, sm.DatMailed, sm.DatExpire, sm.DatGenerated, sm.DatPrinted, sm.DatBundled, sm.DatUndeliverable
						, eh.IsDeleted
						, sm.[LangID]
		 FROM (SELECT  t1.PKey1, t1.Pkey2, t1.IsDeleted
					FROM cteEH t1 
					INNER JOIN cteEH t2 ON t1.PKey1 = t2.PKey1 AND (t1.PKey2 = t2.Pkey2 OR t2.PKey2 IS NULL) AND t1.EntityTypeID = t2.EntityTypeID
					WHERE t1.Created > t2.Created
					) eh --Find most recent duplicate ExtractHistory record
		INNER JOIN QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.QUESTIONFORM_ID = eh.PKey1
        INNER JOIN QP_Prod.dbo.SentMailing sm With (NOLOCK) on qf.SentMail_id = sm.SentMail_id   
        INNER JOIN QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on sp.samplepop_id = qf.SAMPLEPOP_ID	
        INNER JOIN QP_Prod.dbo.Survey_def sd With (NOLOCK) on qf.SURVEY_ID = sd.SURVEY_ID
        LEFT JOIN SampleSetTemp sst with (NOLOCK) on sp.sampleset_id = sst.sampleset_id 
                                     AND sst.ExtractFileID = @ExtractFileID and sst.IsDeleted = 1
	    WHERE (qf.DATRETURNED IS NOT NULL OR sm.DatUndeliverable IS NOT NULL ) 
	           AND sp.POP_ID > 0
	           AND sst.sampleset_id IS NULL; --excludes questionforms/sample pops that will be deleted due to sampleset deletes

	WITH cteEH AS
	(
				SELECT eh1.PKey1, eh1.Pkey2, eh1.EntityTypeID, eh1.IsDeleted, eh1.Created
				FROM ExtractHistory eh1
				INNER JOIN (SELECT DISTINCT PKey1, Pkey2, EntityTypeID
								FROM ExtractHistory  with (NOLOCK) 
									WHERE ExtractFileID = @ExtractFileID
									AND EntityTypeID = @EntityTypeID --and pkey2 = '186064012'
									GROUP BY PKey1, Pkey2,EntityTypeID
									having COUNT(*) = 1) eh2 ON eh1.PKey1 = eh2.PKey1 AND (eh1.PKey2 = eh2.Pkey2 OR eh1.PKey2 IS NULL) AND eh1.EntityTypeID = eh2.EntityTypeID
				WHERE ExtractFileID = @ExtractFileID
	)


	INSERT INTO QuestionFormTemp 
			(ExtractFileID
			, QUESTIONFORM_ID
			, SURVEY_ID
			, SurveyType_id
			, SAMPLEPOP_ID
			, strLithoCode
			, isComplete
			, ReceiptType_id
            , returnDate
			, DatMailed, DatExpire, DatGenerated, DatPrinted, DatBundled, DatUndeliverable
			,IsDeleted
			,[LangID])
	SELECT DISTINCT @ExtractFileID
						, qf.QUESTIONFORM_ID
						, qf.SURVEY_ID
						, sd.SurveyType_id
						, qf.SAMPLEPOP_ID
						, sm.strLithoCode
						, CASE WHEN qf.bitComplete <> 0 THEN 'true' ELSE 'false' END 
						, qf.ReceiptType_id
						, qf.datReturned 
						, sm.DatMailed, sm.DatExpire, sm.DatGenerated, sm.DatPrinted, sm.DatBundled, sm.DatUndeliverable
						, eh.IsDeleted
						, sm.[LangID]
		 FROM (SELECT  t1.PKey1, t1.Pkey2, t1.IsDeleted
					FROM cteEH t1 
					) eh 
		INNER JOIN QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) on qf.QUESTIONFORM_ID = eh.PKey1
        INNER JOIN QP_Prod.dbo.SentMailing sm With (NOLOCK) on qf.SentMail_id = sm.SentMail_id   
        INNER JOIN QP_Prod.dbo.SAMPLEPOP sp with (NOLOCK) on sp.samplepop_id = qf.SAMPLEPOP_ID	
        INNER JOIN QP_Prod.dbo.Survey_def sd With (NOLOCK) on qf.SURVEY_ID = sd.SURVEY_ID
        LEFT JOIN SampleSetTemp sst with (NOLOCK) on sp.sampleset_id = sst.sampleset_id 
                                     AND sst.ExtractFileID = @ExtractFileID and sst.IsDeleted = 1
	    WHERE (qf.DATRETURNED IS NOT NULL OR sm.DatUndeliverable IS NOT NULL ) 
	           AND sp.POP_ID > 0
	           AND sst.sampleset_id IS NULL;

		--Deal with multiple QuestionForms with same SamplePop.  Process earliest returndate by setting IsDelete=0, other matching records set to IsDeleted=1
		;WITH cleanQF AS
		(
			SELECT QuestionForm_ID, SamplePop_ID, returnDate FROM QuestionFormTemp
			WHERE returnDate IS NOT NULL AND SamplePop_ID IN (
			SELECT SamplePop_ID
			FROM QuestionFormTemp
			WHERE returnDate IS NOT NULL --AND IsDeleted = 0
			GROUP BY SamplePop_ID
			HAVING COUNT(DISTINCT QuestionForm_ID) > 1) --and samplepop_id =64511502
		) 

		UPDATE t
		SET IsDeleted = 1
		--SELECT c.*,t.QuestionForm_ID, t.SamplePop_ID, t.returnDate
		FROM QuestionFormTemp t
		LEFT JOIN cleanQF c ON c.SamplePop_ID = t.SamplePop_ID
		WHERE (c.returnDate < t.returnDate  AND c.QuestionForm_ID <> t.QuestionForm_ID)
			OR (c.returnDate = t.returnDate  AND c.QuestionForm_ID <> t.QuestionForm_ID AND c.QuestionForm_ID < t.QuestionForm_ID)
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
 -- Update bitComplete flag for CAHPS surveys
 ---------------------------------------------------------------------------------------
	-- HCAHPS
	UPDATE qft 
	SET isComplete=CASE WHEN QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID) <> 0 THEN 'true' ELSE 'false' END
	--SELECT *--isComplete=QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID),*
	FROM QuestionFormTemp qft 
    WHERE ExtractFileID = @ExtractFileID AND SurveyType_id=2
    
	-- Home Health HHCAHPS
    CREATE TABLE #HHQF (QuestionForm_id INT, Complete INT, ATACnt INT, Q1 INT, numAnswersAfterQ1 INT)
    INSERT INTO #HHQF (QuestionForm_id)
    select QuestionForm_id 
    from QuestionFormTemp 
    WHERE ExtractFileID = @ExtractFileID AND SurveyType_id=3
    
    exec QP_Prod.dbo.HHCAHPSCompleteness
    
    UPDATE qft 
	SET isComplete=CASE WHEN hh.Complete <> 0 THEN 'true' ELSE 'false' END
	--SELECT *
	FROM QuestionFormTemp qft 
	inner join #HHQF hh on qft.Questionform_id=hh.questionform_id
	
	DROP TABLE #HHQF
    
	-- CGCAHPS
    UPDATE qft 
	SET isComplete=CASE WHEN QP_Prod.dbo.MNCMCompleteness(QUESTIONFORM_ID) <> 0 THEN 'true' ELSE 'false' END
	--SELECT *--isComplete=QP_Prod.dbo.HCAHPSCompleteness(QUESTIONFORM_ID),*
	FROM QuestionFormTemp qft 
    WHERE ExtractFileID = @ExtractFileID AND SurveyType_id=4

	-- Hospice CAHPS
	-- ICH CAHPS
	-- ACO CAHPS
	-- CIHI
	-- OAS CAHPS

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