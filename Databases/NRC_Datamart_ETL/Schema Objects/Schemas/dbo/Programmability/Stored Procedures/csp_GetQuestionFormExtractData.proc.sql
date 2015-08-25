CREATE PROCEDURE [dbo].[etl_LoadQuestionFormRecords]
@DataFileID INT, @DataSourceID INT, @ProcessDeletes BIT--, @ReturnMessage NVARCHAR (500) OUTPUT

/*
declare @rc int,@ReturnMessage NVARCHAR (500)
 exec @rc = etl_LoadQuestionFormRecords 9,1,0,@ReturnMessage
select @rc,@ReturnMessage
*/

AS
BEGIN

	SET NOCOUNT ON 

  	DECLARE @oImportRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [ETL].[InsertImportRunLog] @DataFileID, @TaskName, @currDateTime1, @ImportRunLogID = @oImportRunLogID OUTPUT

	DECLARE @icnt INT, @ucnt INT, @dcnt INT, @ecnt INT, @dskdcnt INT, @EntityTypeID INT

    SET @EntityTypeID = 11 -- QuestionForm

    /* - testing only
	declare @DataSourceID  int
	set @DataSourceID = 1--QPUS    

	declare @DataFileID int
	set @DataFileID = 1
   */   

	--------------------------------------------------------------------------------------
	-- Find ID's for existing records
	--------------------------------------------------------------------------------------
	UPDATE LOAD_TABLES.QuestionForm 
	   SET SamplePopulationID = dsk.DataSourceKeyID         
	  FROM LOAD_TABLES.QuestionForm lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK)
				ON dsk.DataSourceKey = lt.samplepop_id  
	 WHERE lt.DataFileID = @DataFileID 
	   AND dsk.EntityTypeID = 7-- SamplePop
	   AND  dsk.DataSourceID = @DataSourceID
	   
	   
	UPDATE LOAD_TABLES.QuestionForm 
	   SET QuestionFormID = dsk.DataSourceKeyID,
		   isInsert = 0              
	  FROM LOAD_TABLES.QuestionForm lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK)
				ON dsk.DataSourceKey = lt.id 
	 WHERE lt.DataFileID = @DataFileID      
	   AND dsk.EntityTypeID = @EntityTypeID
	   AND dsk.DataSourceID = @DataSourceID
	 
	--------------------------------------------------------------------------------------
	-- Cleanup Child Records
	--------------------------------------------------------------------------------------
	DELETE dbo.ResponseBubble
	  FROM LOAD_TABLES.QuestionForm lt WITH (NOLOCK)
			INNER JOIN dbo.ResponseBubble rs WITH (NOLOCK)
				ON rs.QuestionFormID = lt.QuestionFormID 
	 WHERE lt.DataFileID = @DataFileID
      AND IsDelete = 0--deletes are handled below  

    SET @dcnt = @@ROWCOUNT

    UPDATE ETL.DataFileCounts
	  SET Deletes = @dcnt + ISNULL(Deletes,0)
	 WHERE DataFileID = @DataFileID
	 AND Entity = 'ResponseBubble'

	DELETE dbo.ResponseCommentCommentCode
	  FROM LOAD_TABLES.QuestionForm lt WITH (NOLOCK)
			INNER JOIN dbo.ResponseComment rc WITH (NOLOCK)
				ON lt.QuestionFormID = rc.QuestionFormID
	 		INNER JOIN dbo.ResponseCommentCommentCode rccc WITH (NOLOCK)
				ON rc.ResponseCommentID = rccc.ResponseCommentID
	 WHERE lt.DataFileID = @DataFileID
       AND IsDelete = 0    

	SET @dcnt = @@ROWCOUNT

    UPDATE ETL.DataFileCounts
	  SET Deletes = @dcnt + ISNULL(Deletes,0)
	 WHERE DataFileID = @DataFileID
	AND Entity = 'ResponseCommentCommentCode'

   	--note - correspoding datasourcekey row is deleted via a trigger on the ResponseComment table
	DELETE dbo.ResponseComment--       
	  FROM  LOAD_TABLES.QuestionForm lt WITH (NOLOCK)
			INNER JOIN dbo.ResponseComment rs WITH (NOLOCK)
				ON rs.QuestionFormID = lt.QuestionFormID 
	 WHERE lt.DataFileID = @DataFileID
       AND IsDelete = 0 

	SET @dcnt = @@ROWCOUNT

    UPDATE ETL.DataFileCounts
	SET Deletes = @dcnt + ISNULL(Deletes,0)
	WHERE DataFileID = @DataFileID
	AND Entity = 'ResponseComment'

	--------------------------------------------------------------------------------------
	-- Insert new records 
	--------------------------------------------------------------------------------------
	INSERT ETL.DataSourceKey (DataSourceID, EntityTypeID, DataSourceKey)
		SELECT DISTINCT @DataSourceID, @EntityTypeID, id
		--select *           
		  FROM LOAD_TABLES.QuestionForm WITH (NOLOCK)            
		 WHERE DataFileID = @DataFileID
		   AND isInsert = 1
		   AND isDelete = 0
		   AND ReturnDate IS NOT null--null return date rows will be used to update samplepop undeliverable daTE 
           AND SamplePopulationID IS NOT NULL         
          
	UPDATE LOAD_TABLES.QuestionForm 
	   SET QuestionFormID = dsk.DataSourceKeyID
	  FROM LOAD_TABLES.QuestionForm lt WITH (NOLOCK)  
		INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON dsk.DataSourceKey = lt.id 
	 WHERE dsk.DataSourceID = @DataSourceID
	   AND dsk.EntityTypeID = @EntityTypeID
	   AND lt.DataFileID = @DataFileID
	   AND ReturnDate IS NOT NULL
	   AND lt.isInsert = 1
	   AND lt.isDelete = 0

	INSERT dbo.QuestionForm
		(QuestionFormID, SamplePopulationID, IsCahpsComplete, IsActive, ReturnDate, ReceiptTypeID
        ,MailedDate,DatMailed,DatExpire,DatGenerated,DatPrinted,DatBundled,DatUndeliverable,DatFirstMailed)
		SELECT DISTINCT QuestionFormID, SamplePopulationID, IsComplete, 0, CONVERT(DATE,ReturnDate), ReceiptTypeID
        ,CONVERT(DATE,DatMailed),DatMailed,DatExpire,DatGenerated,DatPrinted,DatBundled,DatUndeliverable,DatFirstMailed
		  FROM LOAD_TABLES.QuestionForm WITH (NOLOCK)  
		 WHERE DataFileID = @DataFileID
		   AND isInsert <> 0
		   AND isDelete = 0
		   AND ReturnDate IS NOT NULL --null return date rows will be used to update samplepop undeliverable date 
           AND SamplePopulationID IS NOT NULL
         --  and ReceiptTypeID Is NOT NULL

	SET @icnt = @@ROWCOUNT
	
	--insert question forms that are needed for comments
	INSERT ETL.DataSourceKey (DataSourceID, EntityTypeID, DataSourceKey)
		SELECT DISTINCT @DataSourceID, @EntityTypeID, id
		--select *           
		  FROM LOAD_TABLES.QuestionForm ltqf WITH (NOLOCK)  
	      INNER JOIN LOAD_TABLES.ResponseComment ltrc WITH (NOLOCK)ON ltqf.id = ltrc.questionform_id
		 WHERE ltqf.DataFileID = @DataFileID
		   AND ltqf.DataFileID = ltrc.DataFileID
		   AND ltqf.QuestionFormID IS NULL
		   AND ( isDelete = 1 OR ReturnDate IS NULL)
		   --and ReturnDate is NOT null --null return date rows will be used to update samplepop undeliverable date 
           AND SamplePopulationID IS NOT NULL     
            
	UPDATE LOAD_TABLES.QuestionForm 
	   SET QuestionFormID = dsk.DataSourceKeyID
	  FROM LOAD_TABLES.QuestionForm ltqf WITH (NOLOCK)  
	  INNER JOIN LOAD_TABLES.ResponseComment ltrc WITH (NOLOCK) ON ltqf.id = ltrc.questionform_id
		INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON dsk.DataSourceKey = ltqf.id 
	 WHERE dsk.DataSourceID = @DataSourceID
	   AND dsk.EntityTypeID = @EntityTypeID
	   AND ltqf.DataFileID = @DataFileID
	   AND ltqf.DataFileID = ltrc.DataFileID
	   AND ltqf.QuestionFormID IS NULL
	   AND (isDelete = 1 OR ReturnDate IS NULL)
	   
	INSERT dbo.QuestionForm
		(QuestionFormID, SamplePopulationID, IsCahpsComplete, IsActive, ReturnDate, ReceiptTypeID
        ,MailedDate,DatMailed,DatExpire,DatGenerated,DatPrinted,DatBundled,DatUndeliverable,DatFirstMailed)
	SELECT DISTINCT ltqf.QuestionFormID, ltqf.SamplePopulationID, 0, 0, NULL, ltqf.ReceiptTypeID
        ,CONVERT(DATE,ltqf.DatMailed),ltqf.DatMailed,ltqf.DatExpire,ltqf.DatGenerated
        ,ltqf.DatPrinted,ltqf.DatBundled,ltqf.DatUndeliverable,ltqf.DatFirstMailed
	 FROM LOAD_TABLES.QuestionForm ltqf WITH (NOLOCK)  
	  INNER JOIN LOAD_TABLES.ResponseComment ltrc WITH (NOLOCK) ON ltqf.id = ltrc.questionform_id
	  LEFT JOIN dbo.QuestionForm qf ON ltqf.QuestionFormID = qf.QuestionFormID
		 WHERE ltqf.DataFileID = @DataFileID
		   AND ltqf.DataFileID = ltrc.DataFileID
		   AND ( ltqf.isDelete = 1 OR ltqf.ReturnDate IS NULL)
		   AND qf.QuestionFormID IS NULL			   
           AND ltqf.SamplePopulationID IS NOT NULL
	
    SET @icnt = @@ROWCOUNT + @icnt
	
	UPDATE ETL.DataFileCounts
	   SET Inserts = @icnt
	  WHERE DataFileID = @DataFileID
		AND Entity = 'QuestionForm'

    --------------------------------------------------------------------------------------
	-- Update Existing records
	--------------------------------------------------------------------------------------
	UPDATE dbo.QuestionForm 
	   SET SamplePopulationID = lt.SamplePopulationID,
			IsCahpsComplete = lt.IsComplete, 
			ReturnDate = CONVERT(DATE,lt.ReturnDate),
			ReceiptTypeID = lt.ReceiptTypeID,
            MailedDate = CONVERT(DATE,lt.DatMailed),
            DatMailed = lt.DatMailed,
            DatExpire = lt.DatExpire,
            DatGenerated = lt.DatGenerated,
            DatPrinted = lt.DatPrinted,
            DatBundled = lt.DatBundled,
            DatUndeliverable = lt.DatUndeliverable,
            DatFirstMailed = lt.DatFirstMailed,
			IsActive = CONVERT(BIT,CASE WHEN lt.ReturnDate IS NOT NULL THEN 1 ELSE 0 END)
	  FROM LOAD_TABLES.QuestionForm lt WITH (NOLOCK)  
			INNER JOIN dbo.QuestionForm p WITH (NOLOCK)  ON p.QuestionFormID = lt.QuestionFormID
	 WHERE lt.DataFileID = @DataFileID
	   AND isInsert = 0
	   AND isDelete = 0
       AND lt.SamplePopulationID IS NOT NULL
     --  and lt.ReceiptTypeID Is NOT NULL

	SET @ucnt = @@ROWCOUNT		
	
	UPDATE ETL.DataFileCounts
	   SET Updates = @ucnt
	  WHERE DataFileID = @DataFileID
		AND Entity = 'QuestionForm'

    --------------------------------------------------------------------------------------
	-- Update SampleSet DatMature and IsMature columns based on QuestinForm data
	--- The updated SampleSets for the nightly run are written to a table that will be used by the 
	--- NRC_Requests.dbo.etl_UpdateCachedRequest SP which called by the nightly ETL
	--------------------------------------------------------------------------------------
	DELETE FROM  [LOAD_TABLES].[SampleSetChangeRows]
	
	--Mature sample sets for inactive/non Catalyst clients or sample sets over 6 months old
	UPDATE SampleSet
	SET DatMature = GETDATE(),
	IsMature = 1 
	OUTPUT inserted.SampleSetID,deleted.IsMature,inserted.IsMature
    INTO [LOAD_TABLES].[SampleSetChangeRows]
	--SELECT *--COUNT(*)
	FROM SampleSet ss WITH (NOLOCK)
	INNER JOIN Client c WITH (NOLOCK) ON ss.ClientID = c.ClientID
	WHERE ( DatMature IS NULL AND ( SampleDate < DATEADD(DAY,-180,GETDATE())
	OR c.IsActive = 0 OR IsCatalystClient = 0 ) )		
	
    UPDATE SampleSet
	SET DatMature = x.datExpire,
	IsMature = CASE WHEN x.datExpire < GETDATE() THEN 1 ELSE 0 END
	OUTPUT inserted.SampleSetID,deleted.IsMature,inserted.IsMature
    INTO [LOAD_TABLES].[SampleSetChangeRows]
    --select *
	FROM (SELECT MAX(QuestionForm.datExpire) AS datExpire, SamplePopulation.SampleSetID
		  FROM QuestionForm (NOLOCK)
		   INNER JOIN SamplePopulation (NOLOCK) ON QuestionForm.SamplePopulationID = SamplePopulation.SamplePopulationID 
           INNER JOIN SampleSet (NOLOCK) ON SamplePopulation.SampleSetID =  SampleSet.SampleSetID
		  WHERE QuestionForm.DatExpire IS NOT NULL AND QuestionForm.IsActive = 1 AND SampleSet.IsMature = 0
		  GROUP BY SamplePopulation.SampleSetID 
          )  x  
    INNER JOIN SampleSet (NOLOCK) ON x.SampleSetID = SampleSet.SampleSetID
	WHERE SampleSet.IsMature = 0		
	
	--------------------------------------------------------------------------------------
	-- Update SamplePopulation.UndeliverableDate column based on QuestinForm data
	-- Also check that a sample pop doesn't have a new return that nullifies the SamplePopulation.UndeliverableDate column
	 -------------------------------------------------------------------------------------	
    UPDATE sp
	SET UndeliverableDate = qf.DatUndeliverable
	--select *
	FROM LOAD_TABLES.QuestionForm qf WITH (NOLOCK)
	INNER JOIN dbo.SamplePopulation sp WITH (NOLOCK) ON qf.SamplePopulationID = sp.SamplePopulationID		
   	WHERE qf.DataFileID = @DataFileID 
   	  AND qf.ReturnDate IS NULL AND qf.DatUndeliverable IS NOT NULL AND qf.isDelete = 0
   	       	
   	UPDATE sp
	SET UndeliverableDate = NULL
	--select *
	FROM LOAD_TABLES.QuestionForm qf WITH (NOLOCK)
	INNER JOIN dbo.SamplePopulation sp WITH (NOLOCK) ON qf.SamplePopulationID = sp.SamplePopulationID		
   	WHERE qf.DataFileID = @DataFileID 
   	AND qf.ReturnDate IS NOT NULL AND qf.isDelete = 0 AND sp.UndeliverableDate IS NOT NULL

	--------------------------------------------------------------------------------------
	-- Set active flags
	--------------------------------------------------------------------------------------
	SELECT p.SamplePopulationID, MIN(p.ReturnDate) AS MinReturnDate
	  INTO #ttt
	  FROM dbo.QuestionForm p WITH (NOLOCK)  
		INNER JOIN LOAD_TABLES.QuestionForm lt WITH (NOLOCK) ON p.SamplePopulationID = lt.SamplePopulationID 
	   WHERE lt.DataFileID = @DataFileID 
	 GROUP BY p.SamplePopulationID

	UPDATE dbo.QuestionForm
	   SET IsActive = (CASE WHEN p.ReturnDate = #ttt.MinReturnDate THEN 1 ELSE 0 END)
	  FROM dbo.QuestionForm p WITH (NOLOCK)  
		INNER JOIN #ttt ON #ttt.SamplePopulationID = p.SamplePopulationID

	DROP TABLE #ttt
	--------------------------------------------------------------------------------------
	-- Error records
	--------------------------------------------------------------------------------------
	INSERT INTO LOAD_TABLES.QuestionFormError ([DataFileID],[id],[samplepop_id],[IsComplete],[ReturnDate],[ReceiptTypeID]
       ,[QuestionFormID],[SamplePopulationID],[isInsert],[isDelete],[DatBundled],[DatExpire],[DatGenerated],[DatMailed]
       ,[DatPrinted],[DatUndeliverable],[MailedDate],[DatFirstMailed],[ErrorDescription])
    SELECT [DataFileID],[id],[samplepop_id],[IsComplete],[ReturnDate],[ReceiptTypeID]
       ,[QuestionFormID],[SamplePopulationID],[isInsert],[isDelete],[DatBundled],[DatExpire],[DatGenerated],[DatMailed]
       ,[DatPrinted],[DatUndeliverable],[MailedDate],[DatFirstMailed]
        ,CASE WHEN SamplePopulationID IS NULL THEN 'SamplePopulationID Is NULL'
              ELSE 'Unknow Error'
         END
    FROM LOAD_TABLES.QuestionForm WITH (NOLOCK)
    WHERE SamplePopulationID IS NULL AND isDelete = 0  AND DataFileID = @DataFileID

	SET @ecnt = @@ROWCOUNT 
       	
   	UPDATE ETL.DataFileCounts
	   SET Errors = @ecnt
	  WHERE DataFileID = @DataFileID
		AND Entity = 'QuestionForm'
		
    SET @dcnt = 0       
    
   IF @ProcessDeletes = 1
    BEGIN	   	
		--------------------------------------------------------------------------------------
		-- Delete child records
 		--------------------------------------------------------------------------------------
        --find all the question form child rows to delete
		SELECT lt.QuestionFormID		
		 INTO #temp           
		 FROM LOAD_TABLES.QuestionForm lt WITH (NOLOCK)			
			--left join ResponseComment with (NOLOCK) on  lt.QuestionFormID = ResponseComment.QuestionFormID			
		 WHERE lt.DataFileID = @DataFileID
		 AND isDelete = 1

--      --NOTE - oomments are not deleted
		
		DELETE dbo.ResponseBubble
--          select *
		  FROM #temp temp WITH (NOLOCK)
 			INNER JOIN dbo.ResponseBubble rb WITH (NOLOCK) ON temp.QuestionFormID = rb.QuestionFormID

		SET @dcnt = @@ROWCOUNT

		--------------------------------------------------------------------------------------
		-- Update Counts
		--------------------------------------------------------------------------------------	
		UPDATE ETL.DataFileCounts
		   SET Deletes = @dcnt + ISNULL(Deletes,0)
		  WHERE DataFileID = @DataFileID
			AND Entity = 'ResponseBubble'		
			
		DELETE dbo.ResponseBubbleSet
		  --select *
		  FROM #temp temp WITH (NOLOCK)
			INNER JOIN dbo.ResponseBubbleSet rbs WITH (NOLOCK) ON temp.QuestionFormID = rbs.QuestionFormID
 	      
		UPDATE qf
		SET ReturnDate = NULL
		  ,IsActive = 0
--          select *
		FROM #temp temp WITH (NOLOCK)
		  INNER JOIN dbo.QuestionForm qf WITH (NOLOCK) ON temp.QuestionFormID = qf.QuestionFormID

		SET @dcnt = @@ROWCOUNT
               
        DROP TABLE #temp 

	END

    --------------------------------------------------------------------------------------
	-- Update Counts
	--------------------------------------------------------------------------------------	
	
		UPDATE ETL.DataFileCounts
		   SET Deletes = @dcnt + ISNULL(Deletes,0)
		  WHERE DataFileID = @DataFileID
			AND Entity = 'QuestionForm'
   	
		
	--------------------------------------------------------------------------------------
	-- Update SamplePopulation.ReportDate column
	--- Note sample pops with a ReportDateTypeID = 5 (return date) are updated where 
	---so if a question form's return date is update, the change is handled.
	----All other ReportDateTypeIDs are handled in the etl_LoadSelectedSampleRecords sproc
	--------------------------------------------------------------------------------------		
	BEGIN TRANSACTION   
		UPDATE sp
		SET sp.ReportDate = lt.ReturnDate
  		--SELECT DISTINCT lt.SamplePopulationID,sv.ReportDateTypeID
  		 --INTO #temp
		  FROM LOAD_TABLES.QuestionForm lt WITH (NOLOCK)
			   INNER JOIN dbo.SelectedSample ss WITH (NOLOCK) on lt.SamplePopulationID = ss.SamplePopulationID
			   INNER JOIN dbo.SampleUnit su WITH (NOLOCK) on ss.SampleUnitID = su.SampleUnitID
			   INNER join dbo.Survey sv WITH (NOLOCK) on su.SurveyID = sv.SurveyID		
			   INNER JOIN dbo.SamplePopulation sp WITH (NOLOCK) on lt.SamplePopulationID = sp.SamplePopulationID
		  WHERE lt.SamplePopulationID IS NOT NULL AND lt.ReturnDate IS NOT NULL AND sv.ReportDateTypeID = 5		 
				AND DataFileID = @DataFileID          
                      
	COMMIT 		


  	SET @currDateTime2 = GETDATE();
	SELECT @oImportRunLogID,@currDateTime2,@TaskName
	EXEC [ETL].[UpdateImportRunLog] @oImportRunLogID, @currDateTime2 
      
   SET NOCOUNT OFF

END

GO


