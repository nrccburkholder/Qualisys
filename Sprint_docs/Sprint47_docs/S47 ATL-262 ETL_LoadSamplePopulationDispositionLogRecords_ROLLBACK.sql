/*
	S47 ATL-259 Fix Catalyst ETL so that final disposition conforms to the number of questions answered
	Complete / Incomplete dispos match between data already in Catalyst and the disposition (Final disposition doesn't agree with the number of questions answered)
	
	ATL-262 Review SP ETL_LoadSamplePopulationDispositionLogRecords
	
*/
use NRC_DataMart
go
alter PROCEDURE [dbo].[etl_LoadQuestionFormRecords]
@DataFileID INT, @DataSourceID INT, @ProcessDeletes BIT--, @ReturnMessage NVARCHAR (500) OUTPUT

/*
declare @rc int,@ReturnMessage NVARCHAR (500)
 exec @rc = etl_LoadQuestionFormRecords 9,1,0,@ReturnMessage
select @rc,@ReturnMessage
*/

AS
BEGIN

/*
	S42 US13 OAS: Language in which Survey Completed As an OAS-CAHPS vendor, we need to report the language in which the survey was completed, so we follow submission file specs. 02/04/2016 TSB
*/

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
        ,MailedDate,DatMailed,DatExpire,DatGenerated,DatPrinted,DatBundled,DatUndeliverable,DatFirstMailed
		,[LangID]) --S42 US13
		SELECT DISTINCT QuestionFormID, SamplePopulationID, IsComplete, 0, CONVERT(DATE,ReturnDate), ReceiptTypeID
        ,CONVERT(DATE,DatMailed),DatMailed,DatExpire,DatGenerated,DatPrinted,DatBundled,DatUndeliverable,DatFirstMailed
		,[LangID] --S42 US13
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
        ,MailedDate,DatMailed,DatExpire,DatGenerated,DatPrinted,DatBundled,DatUndeliverable,DatFirstMailed
		,[LangID])
	SELECT DISTINCT ltqf.QuestionFormID, ltqf.SamplePopulationID, 0, 0, NULL, ltqf.ReceiptTypeID
        ,CONVERT(DATE,ltqf.DatMailed),ltqf.DatMailed,ltqf.DatExpire,ltqf.DatGenerated
        ,ltqf.DatPrinted,ltqf.DatBundled,ltqf.DatUndeliverable,ltqf.DatFirstMailed
		,ltqf.[LangID] --S42 US13
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
			IsActive = CONVERT(BIT,CASE WHEN lt.ReturnDate IS NOT NULL THEN 1 ELSE 0 END),
			[LangID] = lt.[LangID] --S42 US13
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
	   SET IsActive = (CASE WHEN p.ReturnDate = t.MinReturnDate THEN 1 ELSE 0 END)
	  FROM dbo.QuestionForm p WITH (NOLOCK)  
		INNER JOIN #ttt t ON t.SamplePopulationID = p.SamplePopulationID AND t.MinReturnDate = p.ReturnDate

	DROP TABLE #ttt
	--------------------------------------------------------------------------------------
	-- Error records
	--------------------------------------------------------------------------------------
	INSERT INTO LOAD_TABLES.QuestionFormError ([DataFileID],[id],[samplepop_id],[IsComplete],[ReturnDate],[ReceiptTypeID]
       ,[QuestionFormID],[SamplePopulationID],[isInsert],[isDelete],[DatBundled],[DatExpire],[DatGenerated],[DatMailed]
       ,[DatPrinted],[DatUndeliverable],[MailedDate],[DatFirstMailed],[ErrorDescription]
	   ,[LangID]) --S42 US13
    SELECT [DataFileID],[id],[samplepop_id],[IsComplete],[ReturnDate],[ReceiptTypeID]
       ,[QuestionFormID],[SamplePopulationID],[isInsert],[isDelete],[DatBundled],[DatExpire],[DatGenerated],[DatMailed]
       ,[DatPrinted],[DatUndeliverable],[MailedDate],[DatFirstMailed]
        ,CASE WHEN SamplePopulationID IS NULL THEN 'SamplePopulationID Is NULL'
              ELSE 'Unknow Error'
         END
		,[LangID] --S42 US13
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
go
use NRC_DataMart
go
alter PROCEDURE [dbo].[etl_LoadSamplePopulationDispositionLogRecords]
	@DataFileID int,
	@DataSourceID int,
    @ProcessDeletes bit
    --,@ReturnMessage As NVarChar(500) Output
AS 
BEGIN
	
   --exec etl_LoadSamplePopulationDispositionLogRecords 2144,1,1
   SET NOCOUNT ON 


  	DECLARE @oImportRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [ETL].[InsertImportRunLog] @DataFileID, @TaskName, @currDateTime1, @ImportRunLogID = @oImportRunLogID OUTPUT

	DECLARE @icnt INT, @ucnt INT, @dcnt INT, @ecnt INT, @EntityTypeID INT
	
	SET @EntityTypeID = 7 -- SamplePopulation
	
	--DECLARE @DataSourceID INT
 --   SET @DataSourceID = 1--QPUS

	--DECLARE @DataFileID INT
 --   SET @DataFileID = 876
    
    
	--DECLARE @ProcessDeletes  INT
 --   SET @ProcessDeletes  = 0

 
		--------------------------------------------------------------------------------------
		-- Find ID's for existing records
		--------------------------------------------------------------------------------------
		UPDATE LOAD_TABLES.SamplePopulationDispositionLog
		   SET SamplePopulationID = dsk.DataSourceKeyID
		  FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) on dsk.DataSourceKey = lt.SamplePop_id
		 WHERE lt.DataFileID = @DataFileID
		   AND dsk.DataSourceID = @DataSourceID
		   AND dsk.EntityTypeID = @EntityTypeID	  

        IF @ProcessDeletes = 1 
			BEGIN
			
				UPDATE LOAD_TABLES.SamplePopulationDispositionLog
				 SET isInsert = 0
				   ,isDelete = 1			         
				 FROM LOAD_TABLES.SamplePopulation ltsp WITH (NOLOCK)
				  INNER JOIN LOAD_TABLES.SamplePopulationDispositionLog ltspdl WITH (NOLOCK)
			   			ON ltsp.id = ltspdl.SamplePop_id
				  WHERE ltsp.isDelete = 1

				 SET @dcnt = @@ROWCOUNT 

			END
        ELSE SET @dcnt = 0

        UPDATE LOAD_TABLES.SamplePopulationDispositionLog
         SET CahpsTypeID  = v.CahpsTypeID
         ,StudyNum = 's' + Cast(v.Study_ID AS NVARCHAR)
		 FROM LOAD_TABLES.SamplePopulationDispositionLog sp WITH (NOLOCK) 
		  INNER JOIN (SELECT SamplePopulationID,MAX(SampleUnitID) AS SampleUnitID FROM SelectedSample WITH (NOLOCK) GROUP BY SamplePopulationID) ss
		   ON ss.SamplePopulationID = sp.SamplePopulationID
		  INNER JOIN v_ClientStudySurveySampleUnit v WITH (NOLOCK) ON ss.SampleUnitID = v.SampleUnitID				
		 WHERE sp.DataFileID = @DataFileID AND sp.isDelete = 0

        UPDATE LOAD_TABLES.SamplePopulationDispositionLog
		  SET DispositionID = Disposition.DispositionID
		 FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
			INNER JOIN Disposition WITH (NOLOCK) ON Disposition.DispositionID = lt.Disposition_id
		 WHERE lt.DataFileID = @DataFileID
        
        UPDATE LOAD_TABLES.SamplePopulationDispositionLog
		  SET ReceiptTypeID = ReceiptType.ReceiptTypeID
		 FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
			INNER JOIN dbo.ReceiptType WITH (NOLOCK) ON ReceiptType.ReceiptTypeID = lt.ReceiptType_id
		 WHERE lt.DataFileID = @DataFileID		 
		 	
		 --DECLARE @datLogged DATETIME
	  --   SET @datLogged = ( SELECT FileDateTime FROM ETL.DataFile WHERE datafileid = @DataFileID )  	      		
			
        --NEED TO INSERT ROWS FOR NEW CAHPS QUESTION FORMS only - only if the question form has responses
        --COMPLETE
        INSERT INTO LOAD_TABLES.SamplePopulationDispositionLog
        SELECT DISTINCT lt.DataFileID,lt.Samplepop_id,Mapping.DispositionID,lt.ReceiptTypeID,IsNull(lt.ReturnDate,GETDATE()),'NRC_DataMart Nightly ETL'
		,CASE WHEN ISNULL(DATEDIFF(dd,lt.DatMailed,lt.ReturnDate),0) < 0 THEN 0 ELSE ISNULL(DATEDIFF(dd,IsNull(lt.DatFirstMailed,0),lt.ReturnDate),0) END
		,CASE WHEN ISNULL(DATEDIFF(dd,lt.DatMailed,lt.ReturnDate),0) < 0 THEN 0 ELSE ISNULL(DATEDIFF(dd,IsNull(lt.DatFirstMailed,0),lt.ReturnDate),0) END
		,lt.SamplePopulationID,Mapping.DispositionID,lt.ReceiptTypeID,Survey.CahpsTypeID,'s' + Cast(Survey.Study_ID AS NVARCHAR),1,0 
		--select *
		FROM LOAD_TABLES.QuestionForm lt
		INNER JOIN ( SELECT SamplePopulationID,MAX(SampleUnitID) AS SampleUnitID FROM SelectedSample WITH (NOLOCK) GROUP BY SamplePopulationID) ss
		 ON lt.SamplePopulationID = ss.SamplePopulationID
		INNER JOIN SampleUnit su WITH (NOLOCK) ON ss.SampleUnitID = su.SampleUnitID
		INNER JOIN (SELECT SurveyID,CahpsTypeID,Study_ID FROM v_ClientStudySurvey WITH (NOLOCK) WHERE CahpsTypeID > 0) Survey  ON su.SurveyID = Survey.SurveyID
		INNER JOIN (SELECT CahpsTypeID,CahpsDispositionID 
		            From CahpsDisposition WITH (NOLOCK)
		            WHERE CahpsDisposition.IsCahpsDispositionComplete = 1 ) CahpsDisposition 
		  ON Survey.CahpsTypeID = CahpsDisposition.CahpsTypeID
		INNER JOIN CahpsDispositionMapping Mapping WITH (NOLOCK) 		 
		   ON CahpsDisposition.CahpsTypeID = Mapping.CahpsTypeID 
		     AND CahpsDisposition.CahpsDispositionID = Mapping.CahpsDispositionID AND 
		     CASE WHEN Mapping.ReceiptTypeID = -1 THEN -1 
		      ELSE lt.ReceiptTypeID  END  = Mapping.ReceiptTypeID 
		 LEFT JOIN  LOAD_TABLES.SamplePopulationDispositionLog ltsapd 
		  ON lt.DataFileID = ltsapd.DataFileID AND lt.SamplePopulationID = ltsapd.SamplePopulationID 
		    AND Mapping.DispositionID = ltsapd.DispositionID AND lt.ReturnDate = ltsapd.datLogged
		  LEFT JOIN LOAD_TABLES.ResponseBubble ltrb ON lt.QuestionFormID = ltrb.QuestionFormID AND ltrb.responseValue>=0 AND ltrb.DataFileID =  @DataFileID
		  LEFT JOIN LOAD_TABLES.ResponseComment ltrc ON lt.QuestionFormID = ltrc.QuestionFormID AND ltrc.DataFileID =  @DataFileID
		WHERE lt.DataFileID = @DataFileID AND lt.isDelete = 0--lt.isInsert = 1 
		AND lt.QuestionFormID IS NOT NULL AND lt.IsComplete = 1 
		AND ltsapd.SamplePopulationID IS NULL--Eliminates dups
	    AND (ltrb.QuestionFormID IS NOT NULL OR ltrc.QuestionFormID IS NOT NULl) -- WE NEED Responses
        UNION ALL--327
       --INCOMPLETE
		 SELECT DISTINCT lt.DataFileID,lt.Samplepop_id,Mapping.DispositionID,lt.ReceiptTypeID,IsNull(lt.ReturnDate,GETDATE()),'NRC_DataMart Nightly ETL'
		,CASE WHEN ISNULL(DATEDIFF(dd,lt.DatMailed,lt.ReturnDate),0) < 0 THEN 0 ELSE ISNULL(DATEDIFF(dd,IsNull(lt.DatFirstMailed,0),lt.ReturnDate),0) END
		,CASE WHEN ISNULL(DATEDIFF(dd,lt.DatMailed,lt.ReturnDate),0)< 0 THEN 0 ELSE ISNULL(DATEDIFF(dd,IsNull(lt.DatFirstMailed,0),lt.ReturnDate),0) END
		,lt.SamplePopulationID,Mapping.DispositionID,lt.ReceiptTypeID,Survey.CahpsTypeID,'s' + Cast(Survey.Study_ID AS NVARCHAR),1,0
		--select *
		FROM LOAD_TABLES.QuestionForm lt
		INNER JOIN ( SELECT SamplePopulationID,MAX(SampleUnitID) AS SampleUnitID FROM SelectedSample WITH (NOLOCK) GROUP BY SamplePopulationID) ss
		 ON lt.SamplePopulationID = ss.SamplePopulationID
		INNER JOIN SampleUnit su WITH (NOLOCK) ON ss.SampleUnitID = su.SampleUnitID
		INNER JOIN (SELECT SurveyID,CahpsTypeID,Study_ID FROM v_ClientStudySurvey WITH (NOLOCK) WHERE CahpsTypeID > 0) Survey  ON su.SurveyID = Survey.SurveyID
		INNER JOIN (SELECT CahpsTypeID,CahpsDispositionID 
		            From CahpsDisposition WITH (NOLOCK)
		            WHERE CahpsDisposition.IsCahpsDispositionInComplete = 1 ) CahpsDisposition 
		  ON Survey.CahpsTypeID = CahpsDisposition.CahpsTypeID
		INNER JOIN CahpsDispositionMapping Mapping WITH (NOLOCK) 		 
		   ON CahpsDisposition.CahpsTypeID = Mapping.CahpsTypeID 
		     AND CahpsDisposition.CahpsDispositionID = Mapping.CahpsDispositionID AND 
		     CASE WHEN Mapping.ReceiptTypeID = -1 THEN -1 --RECEIPTTYPE IS NOT RE
		      ELSE lt.ReceiptTypeID  END  = Mapping.ReceiptTypeID
		 LEFT JOIN LOAD_TABLES.SamplePopulationDispositionLog ltsapd 
		  ON lt.DataFileID = ltsapd.DataFileID AND lt.SamplePopulationID = ltsapd.SamplePopulationID 
		    AND Mapping.DispositionID = ltsapd.DispositionID AND lt.ReturnDate = ltsapd.datLogged    
		  LEFT JOIN LOAD_TABLES.ResponseBubble ltrb ON lt.QuestionFormID = ltrb.QuestionFormID AND ltrb.responseValue>=0 AND ltrb.DataFileID =  @DataFileID
		  LEFT JOIN LOAD_TABLES.ResponseComment ltrc ON lt.QuestionFormID = ltrc.QuestionFormID AND ltrc.DataFileID =  @DataFileID  
		WHERE lt.DataFileID = @DataFileID AND lt.isDelete = 0--lt.isInsert = 1  
		AND lt.QuestionFormID IS NOT NULL AND lt.IsComplete = 0
		AND ltsapd.SamplePopulationID IS NULL--Eliminates dups
		AND (ltrb.QuestionFormID IS NOT NULL OR ltrc.QuestionFormID IS NOT NULl) -- WE NEED Responses
		
		--Special HHCAHPS final disposition logic for question forms where QuestionCore 38694 has a response of 'NO'
		UPDATE spdlt
		SET DispositionID = (SELECT MAX(DispositionID) FROM CahpsDispositionMapping WHERE CahpsTypeID = 2 AND CahpsDispositionID = 220 )
	    --SELECT *
		FROM LOAD_TABLES.SamplePopulationDispositionLog spdlt
		INNER JOIN CahpsDispositionMapping map ON spdlt.DispositionID = map.DispositionID 
		INNER JOIN LOAD_TABLES.QuestionForm qflt ON spdlt.SamplePopulationID = qflt.SamplePopulationID
		INNER JOIN LOAD_TABLES.ResponseBubble rblt ON qflt.QuestionFormID = rblt.QuestionFormID
		WHERE spdlt.DataFileID = @DataFileID AND map.CahpsTypeID = 2 AND map.CahpsDispositionID = 310--Breakoff 
		   AND qflt.DataFileID = @DataFileID AND rblt.DataFileID = @DataFileID
		   AND rblt.nrcQuestionCore = 38694 AND rblt.responseValue <> 1--NO
		   
		--Special MNCMCAHPS final disposition logic for question forms where QuestionCore 39113 has a response of 'NO'   
		UPDATE spdlt
		SET DispositionID = (SELECT MAX(DispositionID) FROM CahpsDispositionMapping WHERE CahpsTypeID = 3 AND CahpsDispositionID = 32 )
	    --SELECT *
		FROM LOAD_TABLES.SamplePopulationDispositionLog spdlt
		INNER JOIN CahpsDispositionMapping map ON spdlt.DispositionID = map.DispositionID 
		INNER JOIN LOAD_TABLES.QuestionForm qflt ON spdlt.SamplePopulationID = qflt.SamplePopulationID
		INNER JOIN LOAD_TABLES.ResponseBubble rblt ON qflt.QuestionFormID = rblt.QuestionFormID
		WHERE spdlt.DataFileID = @DataFileID AND map.CahpsTypeID = 3 AND map.CahpsDispositionID IN (11,12,21,22)--both completed and not completed 
		   AND qflt.DataFileID = @DataFileID AND rblt.DataFileID = @DataFileID
		   AND rblt.nrcQuestionCore = 39113 AND rblt.responseValue <> 1--NO   
		
		INSERT INTO SamplePopulationDispositionLog (SamplePopulationID,DispositionID,LoggedDate,ReceiptTypeID,LoggedBy,DaysFromCurrent,DaysFromFirst,CahpsTypeID)	
		 SELECT DISTINCT lt.SamplePopulationID,lt.DispositionID,lt.datLogged,IsNull(lt.ReceiptTypeID,0),Max(lt.LoggedBy),Max(IsNull(lt.DaysFromCurrent,0))
		 ,Max(IsNull(lt.DaysFromFirst,0)),Max(lt.CahpsTypeID)
		  FROM LOAD_TABLES.SamplePopulationDispositionLog lt WITH (NOLOCK)
           LEFT JOIN SamplePopulationDispositionLog spdl WITH (NOLOCK) --CAN'T INSERT A DUP
            ON lt.SamplePopulationID = spdl.SamplePopulationID AND lt.DispositionID = spdl.DispositionID AND lt.datLogged = spdl.LoggedDate 
		  WHERE lt.DataFileID = @DataFileID 
		  AND lt.isDelete = 0 AND spdl.SamplePopulationID IS NULL
            AND lt.SamplePopulationID IS NOT NULL AND lt.DispositionID IS NOT NULL --AND lt.ReceiptTypeID IS NOT NULL   
          GROUP BY lt.SamplePopulationID,lt.DispositionID,lt.datLogged,lt.ReceiptTypeID
  

		SET @icnt = @@ROWCOUNT

        INSERT INTO LOAD_TABLES.SamplePopulationDispositionLogError
         SELECT *,'Required Field Is NULL'
          FROM LOAD_TABLES.SamplePopulationDispositionLog WITH (NOLOCK)
         WHERE DataFileID = @DataFileID AND isDelete = 0
              AND ( SamplePopulationID IS NULL OR DispositionID IS NULL  OR CahpsTypeID IS NULL OR StudyNum IS NULL) --OR ReceiptTypeID IS NULL
    		       
       	SET @ecnt = @@ROWCOUNT	
      
      --------------------------------------------------------------------------------------
	  -- UPDATE SamplePopulation Counts
	   --------------------------------------------------------------------------------------	
		UPDATE ETL.DataFileCounts
		   SET Inserts = @icnt,
			   Updates = 0,
			   Deletes = @dcnt,
               Errors = @ecnt
		  WHERE DataFileID = @DataFileID
			AND Entity = 'SamplePopulationDispositionLog'
			
			--DECLARE @DataFileID INT
			--SET @DataFileID = 708	
	


  	SET @currDateTime2 = GETDATE();
	--SELECT @oImportRunLogID,@currDateTime2,@TaskName
	EXEC [ETL].[UpdateImportRunLog] @oImportRunLogID, @currDateTime2 
    
   SET NOCOUNT OFF
END
go