/*

	S18 US16 As an authorized Hospice CAHPS vendor, we need to retain counts of ineligible records by category to comply with a CMS mandate


	Tim Butler

	alter table [dbo].[SampleSet]
	alter table [LOAD_TABLES].[SampleSet]
	alter table [LOAD_TABLES].[SampleSetError]
	ALTER PROCEDURE [dbo].[etl_LoadSampleSetRecords]
	
*/

use [NRC_DataMart]
go
begin tran
go
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SampleSet' 
					   AND sc.NAME = 'IneligibleCount' )

	alter table [dbo].[SampleSet] add IneligibleCount int NULL 

go

commit tran
go

begin tran
go

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'


if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'SampleSet' 
					   AND sc.NAME = 'IneligibleCount' )

	alter table [LOAD_TABLES].[SampleSet] add IneligibleCount int NULL

go

commit tran
go

begin tran
go

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'


if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'SampleSetError' 
					   AND sc.NAME = 'IneligibleCount' )

	alter table [LOAD_TABLES].[SampleSetError] add IneligibleCount int NULL

go

commit tran
go


USE [NRC_Datamart]
GO
/****** Object:  StoredProcedure [dbo].[etl_LoadSampleSetRecords]    Script Date: 1/6/2015 10:18:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[etl_LoadSampleSetRecords]
	@DataFileID INT,
	@DataSourceID INT,
    @ProcessDeletes BIT
    --,@ReturnMessage AS NVARCHAR(500) OUTPUT
    
    --exec [dbo].[etl_LoadSampleSetRecords] 9,1,1,''
AS
-- =============================================
-- Procedure Name: etl_LoadSampleSetRecords
-- History: 1.0  Original as of 2015.01.06
--			2.0  Tim Butler - S15 US11 Add StandardMethodologyID column to SampleSet
--			3.0  Tim Butler - S18 US17 Add IneligibleCount column to SampleSet
-- =============================================
	SET NOCOUNT ON 

	DECLARE @icnt INT, @ucnt INT, @dcnt INT, @ecnt INT,@EntityTypeID INT
	
	SET @EntityTypeID = 8 -- SampleSet
    --testing vars
	/*
	declare @DataSourceID  int
    set @DataSourceID = 1--QPUS

	declare @DataFileID int
    set @DataFileID = 2

    declare @ProcessDeletes int
    set @ProcessDeletes = 1
    */
  
	--------------------------------------------------------------------------------------
	-- Find ID's for existing records
	--------------------------------------------------------------------------------------
	UPDATE LOAD_TABLES.SampleSet 
	   SET ClientID = dsk.DataSourceKeyID
	  FROM LOAD_TABLES.SampleSet lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK)
				ON dsk.DataSourceKey = lt.client_id  
	 WHERE dsk.DataSourceID = @DataSourceID
	   AND dsk.EntityTypeID = 1 -- Client
	   AND lt.DataFileID = @DataFileID
	
	UPDATE LOAD_TABLES.SampleSet 
	   SET SampleSetID = dsk.DataSourceKeyID,
		   isInsert = 0
	  FROM LOAD_TABLES.SampleSet lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK)
				ON dsk.DataSourceKey = lt.id 
	 WHERE dsk.DataSourceID = @DataSourceID
	   AND dsk.EntityTypeID = @EntityTypeID
	   AND lt.DataFileID = @DataFileID
	
	--------------------------------------------------------------------------------------
	-- Insert new records 
	--------------------------------------------------------------------------------------
	INSERT ETL.DataSourceKey (DataSourceID, EntityTypeID, DataSourceKey)
		SELECT @DataSourceID, @EntityTypeID, id
		  FROM LOAD_TABLES.SampleSet WITH (NOLOCK)
		 WHERE DataFileID = @DataFileID
		   AND isInsert <> 0 AND isDelete = 0 AND ClientID IS NOT NULL

	UPDATE LOAD_TABLES.SampleSet 
	   SET SampleSetID = dsk.DataSourceKeyID
	  FROM LOAD_TABLES.SampleSet lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK)
				ON dsk.DataSourceKey = lt.id 
	 WHERE dsk.DataSourceID = @DataSourceID
	   AND dsk.EntityTypeID = @EntityTypeID
	   AND lt.DataFileID = @DataFileID
	   AND lt.isInsert <> 0 AND isDelete = 0

	INSERT dbo.SampleSet
		(SampleSetID, ClientID, SampleDate,StandardMethodologyID, IneligibleCount)
		SELECT SampleSetID, ClientID, CONVERT(DATE,SampleDate)
		,StandardMethodologyID -- 2.0
		,IneligibleCount  -- 3.0
		  FROM LOAD_TABLES.SampleSet WITH (NOLOCK)
		 WHERE DataFileID = @DataFileID
		   AND isInsert <> 0 AND isDelete = 0 AND ClientID IS NOT NULL

	SET @icnt = @@ROWCOUNT

	--------------------------------------------------------------------------------------
	-- Update Existing records
	--------------------------------------------------------------------------------------
	UPDATE dbo.SampleSet 
	   SET ClientID = lt.ClientID, 
		   SampleDate = CONVERT(DATE,lt.SampleDate),
		   StandardMethodologyID = lt.StandardMethodologyID, -- 2.0
		   IneligibleCount = lt.IneligibleCount -- 3.0
	  FROM LOAD_TABLES.SampleSet lt WITH (NOLOCK)
			INNER JOIN dbo.SampleSet p WITH (NOLOCK) ON p.SampleSetID = lt.SampleSetID
	 WHERE lt.DataFileID = @DataFileID
	   AND isInsert = 0  AND isdelete = 0 AND lt.ClientID IS NOT NULL

	SET @ucnt = @@ROWCOUNT			

    INSERT INTO LOAD_TABLES.SampleSetError
	SELECT [DataFileID]  -- 2.0  replaced SELECT * with column names
      ,[id]
      ,[client_id]
      ,[sampleDate]
      ,[SampleSetID]
      ,[ClientID]
      ,[isInsert]
      ,[isDelete]
      ,'ClientID Is NULL' 
      ,[StandardMethodologyID]  --2.0
	  ,[IneligibleCount]   -- 3.0
    FROM LOAD_TABLES.SampleSet WITH (NOLOCK)
    WHERE ClientID IS NULL AND isDelete = 0 AND DataFileID = @DataFileID

    SET @ecnt = @@ROWCOUNT     

--      insert into LOAD_TABLES.SampleSetError
--      select *,'SampleSetID Is NULL - Can''t Delete'
--      from LOAD_TABLES.SampleSet with (NOLOCK)
--      where SampleSetID Is NULL and isDelete = 1 and DataFileID = @DataFileID

	--set @ecnt = @ecnt + @@ROWCOUNT      
    SET @dcnt = 0 
    
    IF @ProcessDeletes = 1
    BEGIN	 

        --find all the sample set child rows to delete
		SELECT lt.SampleSetID,SamplePopulation.SamplePopulationID,QuestionForm.QuestionFormID,ResponseComment.ResponseCommentID-- *		
		 INTO #temp
		 FROM LOAD_TABLES.SampleSet lt WITH (NOLOCK)
			LEFT JOIN SamplePopulation WITH (NOLOCK) ON lt.SampleSetID = SamplePopulation.SampleSetID
            LEFT JOIN QuestionForm WITH (NOLOCK) ON SamplePopulation.SamplePopulationID = QuestionForm.SamplePopulationID
			LEFT JOIN ResponseComment WITH (NOLOCK) ON QuestionForm.QuestionFormID = ResponseComment.QuestionFormID			
		 WHERE lt.DataFileID = @DataFileID
		 AND lt.isDelete <> 0

       DELETE dbo.ResponseCommentCommentCode
--          select *
		  FROM #temp temp WITH (NOLOCK)
 			INNER JOIN dbo.ResponseCommentCommentCode rc WITH (NOLOCK) ON temp.ResponseCommentID = rc.ResponseCommentID

		SET @dcnt = @@ROWCOUNT
		--------------------------------------------------------------------------------------
		-- Update Counts
		--------------------------------------------------------------------------------------	
		UPDATE ETL.DataFileCounts
		   SET Deletes = @dcnt + ISNULL(Deletes,0)
		  WHERE DataFileID = @DataFileID
			AND Entity = 'ResponseCommentCommentCode'

		--note - correspoding datasourcekey row is deleted via a trigger on the ResponseComment table	
		DELETE dbo.ResponseComment
		OUTPUT DELETED.ResponseCommentID,@DataFileID
		 ,dsk.DataSourceID,dsk.EntityTypeID,dsk.DataSourceKey,GETDATE(),'etl_LoadSampleSetRecords'
		 INTO [ETL].[DataSourceKeyDelete]	 
--         select *
		  FROM #temp temp WITH (NOLOCK)
 			INNER JOIN dbo.ResponseComment rc WITH (NOLOCK) ON temp.ResponseCommentID = rc.ResponseCommentID
 			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON rc.ResponseCommentID = dsk.DataSourceKeyID
 	    
 	    SET @dcnt = @@ROWCOUNT

        --------------------------------------------------------------------------------------
		-- Update Counts
		--------------------------------------------------------------------------------------	
		UPDATE ETL.DataFileCounts
		   SET Deletes = @dcnt + ISNULL(Deletes,0)
		  WHERE DataFileID = @DataFileID
			AND Entity = 'ResponseComment'

		--note - correspoding datasourcekey row is deleted via a trigger on the ResponseBubble table
		DELETE dbo.ResponseBubbleSet
--          select *
		  FROM #temp temp WITH (NOLOCK)
 			INNER JOIN dbo.ResponseBubbleSet rb WITH (NOLOCK) ON temp.QuestionFormID = rb.QuestionFormID			
			
		--note - correspoding datasourcekey row is deleted via a trigger on the ResponseBubble table
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

		--note - correspoding datasourcekey row is deleted via a trigger on the QuestionForm table
		DELETE dbo.QuestionForm
		 OUTPUT DELETED.QuestionFormID,@DataFileID
		 ,dsk.DataSourceID,dsk.EntityTypeID,dsk.DataSourceKey,GETDATE(),'etl_LoadSampleSetRecords'
		 INTO [ETL].[DataSourceKeyDelete]	
--          select *
		  FROM #temp temp WITH (NOLOCK)
 			INNER JOIN dbo.QuestionForm qf WITH (NOLOCK) ON temp.QuestionFormID = qf.QuestionFormID
 			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON qf.QuestionFormID = dsk.DataSourceKeyID
	
		SET @dcnt = @@ROWCOUNT

        --------------------------------------------------------------------------------------
		-- Update Counts
		--------------------------------------------------------------------------------------	
		UPDATE ETL.DataFileCounts
		   SET Deletes = @dcnt + ISNULL(Deletes,0)
		  WHERE DataFileID = @DataFileID
			AND Entity = 'QuestionForm'

		DELETE spbf
--          select *
		  FROM #temp temp WITH (NOLOCK)
 			INNER JOIN dbo.SamplePopulationBackgroundField spbf WITH (NOLOCK) ON temp.SamplePopulationID = spbf.SamplePopulationID
	
		SET @dcnt = @@ROWCOUNT

        --------------------------------------------------------------------------------------
		-- Update Counts
		--------------------------------------------------------------------------------------	
		UPDATE ETL.DataFileCounts
		   SET Deletes = @dcnt + ISNULL(Deletes,0)
          FROM ETL.DataFileCounts
		  WHERE DataFileID = @DataFileID
			AND Entity = 'SamplePopulationBackgroundField'	
			
		DELETE spbf
--          select *
		  FROM #temp temp WITH (NOLOCK)
 			INNER JOIN dbo.SamplePopulationBackgroundFieldInternalOnly spbf WITH (NOLOCK) ON temp.SamplePopulationID = spbf.SamplePopulationID
	
		SET @dcnt = @@ROWCOUNT

        --------------------------------------------------------------------------------------
		-- Update Counts
		--------------------------------------------------------------------------------------	
		
		INSERT INTO ETL.DataFileCounts (DataFileID,Entity,Updates,Deletes, Errors)
		 SELECT @DataFileID,'SamplePopulationBackgroundFieldInternalOnly'
		 ,Updates = 0
		 ,Deletes = ISNULL(@dcnt,0)
		 ,Errors = 0    
							
		DELETE spbf
--          select *
		  FROM #temp temp WITH (NOLOCK)
 			INNER JOIN dbo.SamplePopulationBackgroundFieldSelectedOnly spbf WITH (NOLOCK) ON temp.SamplePopulationID = spbf.SamplePopulationID
	
		SET @dcnt = @@ROWCOUNT

        --------------------------------------------------------------------------------------
		-- Update Counts
		--------------------------------------------------------------------------------------	
					
	   INSERT INTO ETL.DataFileCounts (DataFileID,Entity,Updates,Deletes, Errors)
		 SELECT @DataFileID,'SamplePopulationBackgroundFieldSelectedOnly'
		 ,Updates = 0
		 ,Deletes = ISNULL(@dcnt,0)
		 ,Errors = 0    					
		
		DELETE dbo.SelectedSample
--          select *
		  FROM #temp temp WITH (NOLOCK)
 			INNER JOIN dbo.SelectedSample ss WITH (NOLOCK) ON temp.SamplePopulationID = ss.SamplePopulationID
	
		SET @dcnt = @@ROWCOUNT

        --------------------------------------------------------------------------------------
		-- Update Counts
		--------------------------------------------------------------------------------------	
		UPDATE ETL.DataFileCounts
		   SET Deletes = @dcnt + ISNULL(Deletes,0)
           FROM ETL.DataFileCounts
		  WHERE DataFileID = @DataFileID
			AND Entity = 'SelectedSample'
					
		DELETE dbo.SamplePopulationDispositionLog
--          select *
		  FROM #temp temp WITH (NOLOCK)
 			INNER JOIN dbo.SamplePopulationDispositionLog ss WITH (NOLOCK) ON temp.SamplePopulationID = ss.SamplePopulationID
	
		SET @dcnt = @@ROWCOUNT

        --------------------------------------------------------------------------------------
		-- Update Counts
		--------------------------------------------------------------------------------------	
		UPDATE ETL.DataFileCounts
		   SET Deletes = @dcnt + ISNULL(Deletes,0)
           FROM ETL.DataFileCounts
		  WHERE DataFileID = @DataFileID
			AND Entity = 'SamplePopulationDispositionLog'
			
			
		 --note - correspoding datasourcekey row is deleted via a trigger on the SamplePopulation table
		 DELETE dbo.SamplePopulation
		  OUTPUT DELETED.SamplePopulationID,@DataFileID
		 ,dsk.DataSourceID,dsk.EntityTypeID,dsk.DataSourceKey,GETDATE(),'etl_LoadSampleSetRecords'
		 INTO [ETL].[DataSourceKeyDelete]	
         --select *
		  FROM #temp temp WITH (NOLOCK)
 			INNER JOIN dbo.SamplePopulation sp WITH (NOLOCK) ON temp.SamplePopulationID = sp.SamplePopulationID
 			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON sp.SamplePopulationID = dsk.DataSourceKeyID
	
		SET @dcnt = @@ROWCOUNT

        --------------------------------------------------------------------------------------
		-- Update Counts
		--------------------------------------------------------------------------------------	
		UPDATE ETL.DataFileCounts
		   SET Deletes = @dcnt + ISNULL(Deletes,0)
		  WHERE DataFileID = @DataFileID
		  AND Entity = 'SamplePopulation' 	


         --note - correspoding datasourcekey row is deleted via a trigger on the SampleSet table
		 DELETE dbo.SampleSet
		   OUTPUT DELETED.SampleSetID,@DataFileID
		 ,dsk.DataSourceID,dsk.EntityTypeID,dsk.DataSourceKey,GETDATE(),'etl_LoadSampleSetRecords'
		 INTO [ETL].[DataSourceKeyDelete]	
         --select *
		  FROM #temp temp WITH (NOLOCK)
 			INNER JOIN dbo.SampleSet st WITH (NOLOCK) ON temp.SampleSetID = st.SampleSetID
 			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON st.SampleSetID = dsk.DataSourceKeyID
	
		SET @dcnt = @@ROWCOUNT		

		DROP TABLE #temp
		       
    END   	
	----------------------------------------------------------------------------------
	 --Update Counts--
	----------------------------------------------------------------------------------	
	UPDATE ETL.DataFileCounts
	   SET Inserts = @icnt + ISNULL(Inserts,0),
		   Updates = @ucnt + ISNULL(Updates,0),
		   Deletes = @dcnt + ISNULL(Deletes,0),
           Errors = @ecnt
	  WHERE DataFileID = @DataFileID
		AND Entity = 'SampleSet'
  
	

   SET NOCOUNT OFF
GO