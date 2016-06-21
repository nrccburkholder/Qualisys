/*

S23 US8  As an ATLAS team we want to refactor number of patients in file to be at the sample unit level for all CAHPS

Tim Butler

	alter table [dbo].[SampleSet] drop column NumPatInFile
	alter table [LOAD_TABLES].[SampleSet] drop column NumPatInFile
	alter table [LOAD_TABLES].[SampleSetError] drop column NumPatInFile
	CREATE TABLE [LOAD_TABLES].[SampleUnitBySampleSet]
	CREATE TABLE [dbo].[SampleUnitBySampleSet]
	ALTER PROCEDURE [dbo].[etl_LoadSampleSetRecords]
	ALTER PROCEDURE [dbo].[etl_ClearEventLoadTables]
	ALTER PROCEDURE [dbo].[etl_ClearLoadTables]
*/

use [NRC_DataMart]
go
begin tran
go
if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SampleSet' 
					   AND sc.NAME = 'NumPatInFile' )

	alter table [dbo].[SampleSet] drop column NumPatInFile

go

commit tran
go

begin tran
go

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'

if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'SampleSet' 
					   AND sc.NAME = 'NumPatInFile' )

	alter table [LOAD_TABLES].[SampleSet] drop column NumPatInFile


go

commit tran
go

begin tran
go

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'


if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'SampleSetError' 
					   AND sc.NAME = 'NumPatInFile' )

	alter table [LOAD_TABLES].[SampleSetError] drop column NumPatInFile


go

commit tran
go


use [NRC_DataMart]
go

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'

if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'SampleUnitBySampleSet')

		DROP TABLE [LOAD_TABLES].[SampleUnitBySampleSet]

GO


DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'

if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'SampleUnitBySampleSet')

			CREATE TABLE [LOAD_TABLES].[SampleUnitBySampleSet](
				[DataFileID] [int] NOT NULL,
				[SAMPLESET_ID] [int] NOT NULL,  --Qualisys SampleSet_ID
				[SAMPLEUNIT_ID] [int] NOT NULL, --Qualisys SampleUnit_ID
				[SAMPLESETID] [int] NULL,
				[SAMPLEUNITID] [int] NULL,
				[NumPatInFile] [int] NULL
			) ON [PRIMARY]

GO



use [NRC_DataMart]
go

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'

if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'SampleUnitBySampleSetError')
DROP TABLE [LOAD_TABLES].[SampleUnitBySampleSetError]

GO

DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'

if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'SampleUnitBySampleSetError')

			CREATE TABLE [LOAD_TABLES].[SampleUnitBySampleSetError](
				[DataFileID] [int] NOT NULL,
				[SAMPLESET_ID] [int] NOT NULL,  --Qualisys SampleSet_ID
				[SAMPLEUNIT_ID] [int] NOT NULL, --Qualisys SampleUnit_ID
				[SAMPLESETID] [int] NULL,
				[SAMPLEUNITID] [int] NULL,
				[NumPatInFile] [int] NULL,
				[ErrorDescription] [nvarchar](1000) NOT NULL
			) ON [PRIMARY]

GO


use [NRC_DataMart]
go


if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1
					   AND st.NAME = 'SampleUnitBySampleSet')

	DROP TABLE [dbo].[SampleUnitBySampleSet]

GO

use [NRC_DataMart]
go

if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1
					   AND st.NAME = 'SampleUnitBySampleSet')

			CREATE TABLE [dbo].[SampleUnitBySampleSet](
				[SAMPLESETID] [int] NOT NULL, 
				[SAMPLEUNITID] [int] NOT NULL, 
				[NumPatInFile] [int] NULL,
				primary key ([SAMPLESETID], [SAMPLEUNITID])
			) ON [PRIMARY]

GO


USE [NRC_DataMart]
GO

IF not exists (SELECT 1 FROM [ETL].[ImportTaskLinkToDataFileCounts]
			   WHERE task = 'etl_LoadSampleUnitBySampleSetRecords'
			   and Entity = 'SampleUnitBySampleSet')
BEGIN

	DECLARE @ID INT

	SELECT @ID = MAX(ID) + 1
	FROM [ETL].[ImportTaskLinkToDataFileCounts]

	SELECT @ID 

	INSERT INTO [ETL].[ImportTaskLinkToDataFileCounts]
			   ([ID]
			   ,[Task]
			   ,[Entity]
			   ,[DisplayTasksName]
			   ,[DisplayTaskSequence])
		 VALUES
			   (@ID
			   ,'etl_LoadSampleUnitBySampleSetRecords'
			   ,'SampleUnitBySampleSet'
			   ,'SampleSet Load'
			   ,2)
END
GO

USE [NRC_Datamart]

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'etl_LoadSampleUnitBySampleSetRecords')
	DROP PROCEDURE [dbo].[etl_LoadSampleUnitBySampleSetRecords]
GO


GO
/****** Object:  StoredProcedure [dbo].[etl_LoadSampleUnitBySampleSetRecords]    Script Date: 4/17/2015 8:17:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[etl_LoadSampleUnitBySampleSetRecords]
	@DataFileID INT,
	@DataSourceID INT,
    @ProcessDeletes BIT
    --,@ReturnMessage AS NVARCHAR(500) OUTPUT
    
    --exec [dbo].[etl_LoadSampleUnitBySampleSetRecords] 9,1,1,''
AS
-- =============================================
-- Procedure Name: etl_LoadSampleUnitBySampleSetRecords
-- History: 1.0  Original Tim Butler 04/17/2015
-- =============================================
	SET NOCOUNT ON 

	DECLARE @oImportRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [ETL].[InsertImportRunLog] @DataFileID, @TaskName, @currDateTime1, @ImportRunLogID = @oImportRunLogID OUTPUT

	DECLARE @icnt INT, @ucnt INT, @dcnt INT, @ecnt1 INT,@ecnt2 INT, @EntityTypeID INT
	
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
	
	UPDATE LOAD_TABLES.SampleUnitBySampleSet 
	   SET SampleSetID = dsk.DataSourceKeyID
	  FROM LOAD_TABLES.SampleUnitBySampleSet lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON dsk.DataSourceKey = lt.SAMPLESET_ID
	 WHERE dsk.DataSourceID = @DataSourceID
	   AND dsk.EntityTypeID = 8 -- SampleSet
	   AND lt.DataFileID = @DataFileID

	UPDATE LOAD_TABLES.SampleUnitBySampleSet 
	   SET SampleUnitID = dsk.DataSourceKeyID
	  FROM LOAD_TABLES.SampleUnitBySampleSet lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON dsk.DataSourceKey = lt.SAMPLEUNIT_ID
	 WHERE dsk.DataSourceID = @DataSourceID
	   AND dsk.EntityTypeID = 6 -- SampleUnit
	   AND lt.DataFileID = @DataFileID
	
	--------------------------------------------------------------------------------------
	-- Insert new records 
	--------------------------------------------------------------------------------------
	
	INSERT dbo.SampleUnitBySampleSet
		(SampleSetID, SAMPLEUNITID, NumPatInFile)
		SELECT lt.SampleSetID, lt.SampleUnitID ,lt.NumPatInFile
		  FROM LOAD_TABLES.SampleUnitBySampleSet lt WITH (NOLOCK)
		  LEFT JOIN dbo.SampleUnitBySampleSet p WITH (NOLOCK) on p.SAMPLESETID = lt.SAMPLESETID and p.SAMPLEUNITID = lt.SAMPLEUNITID
		 WHERE DataFileID = @DataFileID
		   AND (p.SAMPLEUNITID IS NULL AND p.SAMPLESETID IS NULL)
		   AND lt.SAMPLESETID IS NOT NULL and lt.SAMPLEUNITID is NOT NULL

	SET @icnt = @@ROWCOUNT

	--------------------------------------------------------------------------------------
	-- Update Existing records
	--------------------------------------------------------------------------------------
	UPDATE dbo.SampleUnitBySampleSet
	   SET NumPatInFile = lt.NumPatInFile
	 FROM LOAD_TABLES.SampleUnitBySampleSet lt WITH (NOLOCK)
		 INNER JOIN dbo.SampleUnitBySampleSet p WITH (NOLOCK) on p.SAMPLESETID = lt.SAMPLESETID and p.SAMPLEUNITID = lt.SAMPLEUNITID
		 WHERE DataFileID = @DataFileID
		   AND p.SAMPLEUNITID IS NOT NULL AND p.SAMPLEUNITID IS NOT NULL

	SET @ucnt = @@ROWCOUNT			

    INSERT INTO LOAD_TABLES.SampleUnitBySampleSetError
	SELECT [DataFileID]
      ,[SAMPLESET_ID]
      ,[SAMPLEUNIT_ID]
      ,[SAMPLESETID]
      ,[SAMPLEUNITID]
      ,[NumPatInFile]
      ,'SampleSetID is null'
	FROM [LOAD_TABLES].[SampleUnitBySampleSet]
    WHERE SAMPLESETID IS NULL

    SET @ecnt1 = @@ROWCOUNT   
	
	INSERT INTO LOAD_TABLES.SampleUnitBySampleSetError
	SELECT [DataFileID]
      ,[SAMPLESET_ID]
      ,[SAMPLEUNIT_ID]
      ,[SAMPLESETID]
      ,[SAMPLEUNITID]
      ,[NumPatInFile]
      ,'SampleUnitID is null'
	FROM [LOAD_TABLES].[SampleUnitBySampleSet]
    WHERE SAMPLESETID IS NOT NULL  AND SAMPLEUNITID IS NULL

	SET @ecnt2 = @@ROWCOUNT  
    
    SET @dcnt = 0 
    
	----------------------------------------------------------------------------------
	 --Update Counts--
	----------------------------------------------------------------------------------	
	UPDATE ETL.DataFileCounts
	   SET Inserts = @icnt + ISNULL(Inserts,0),
		   Updates = @ucnt + ISNULL(Updates,0),
		   Deletes = @dcnt + ISNULL(Deletes,0),
           Errors = @ecnt1 + @ecnt2
	  WHERE DataFileID = @DataFileID
		AND Entity = 'SampleUnitBySampleSet'
  
	  SET @currDateTime2 = GETDATE();
	SELECT @oImportRunLogID,@currDateTime2,@TaskName
	EXEC [ETL].[UpdateImportRunLog] @oImportRunLogID, @currDateTime2 

   SET NOCOUNT OFF
GO

USE [NRC_Datamart]
GO
/****** Object:  StoredProcedure [dbo].[etl_LoadSampleSetRecords]    Script Date: 4/17/2015 9:09:10 AM ******/
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
--			S20 US9  Add SamplingMethodID  Tim Butler
-- =============================================
	SET NOCOUNT ON 

	DECLARE @oImportRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [ETL].[InsertImportRunLog] @DataFileID, @TaskName, @currDateTime1, @ImportRunLogID = @oImportRunLogID OUTPUT

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
		(SampleSetID, ClientID, SampleDate,StandardMethodologyID, IneligibleCount, SamplingMethodID)
		SELECT SampleSetID, ClientID, CONVERT(DATE,SampleDate)
		,StandardMethodologyID -- 2.0
		,IneligibleCount  -- 3.0
		,SamplingMethodID -- S20 US9
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
		   IneligibleCount = lt.IneligibleCount, -- 3.0
		   SamplingMethodID = lt.SamplingMethodID -- S20 US9
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
	  ,[SamplingMethodID] -- S20 US9
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
  
	  SET @currDateTime2 = GETDATE();
	SELECT @oImportRunLogID,@currDateTime2,@TaskName
	EXEC [ETL].[UpdateImportRunLog] @oImportRunLogID, @currDateTime2 

   SET NOCOUNT OFF

GO

USE [NRC_Datamart]
GO
/****** Object:  StoredProcedure [dbo].[etl_ClearEventLoadTables]    Script Date: 4/22/2015 10:15:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[etl_ClearEventLoadTables]
	@DataFileID int,
    @RetainLoadData bit,
    @RetainLoadErrorData bit
as
-- =============================================
-- Procedure Name: etl_ClearEventLoadTables
-- History: 1.0  Original as of 2015.04.21
--			S23 US8  Add LOAD_TABLES.SampleUnitBySampleSet  Tim Butler
-- =============================================

	if @RetainLoadData = 0
	  begin	    	
		delete LOAD_TABLES.SampleSet where DataFileID = @DataFileID      
		delete LOAD_TABLES.SamplePopulation where DataFileID = @DataFileID    
  		delete LOAD_TABLES.SelectedSample where DataFileID = @DataFileID      
		delete LOAD_TABLES.BackgroundFields where DataFileID = @DataFileID   	
		delete LOAD_TABLES.QuestionForm where DataFileID = @DataFileID    	
		delete LOAD_TABLES.ResponseBubble where DataFileID = @DataFileID  
		delete LOAD_TABLES.ResponseComment where DataFileID = @DataFileID    	
		delete LOAD_TABLES.ResponseCommentCommentCode where DataFileID = @DataFileID
        delete LOAD_TABLES.SamplePopulationDispositionLog where DataFileID = @DataFileID
        delete LOAD_TABLES.ResponseBubbleOBMappingLog where DataFileID = @DataFileID
		delete LOAD_TABLES.SampleUnitBySampleSet where DataFileID = @DataFileID --			S23 US8
     end
   

	if @RetainLoadErrorData = 0
	  begin	
		delete LOAD_TABLES.SampleSetError where DataFileID = @DataFileID
		delete LOAD_TABLES.SamplePopulationError where DataFileID = @DataFileID 
		delete LOAD_TABLES.SamplePopulationNPIError where DataFileID = @DataFileID 
		delete LOAD_TABLES.SelectedSampleError where DataFileID = @DataFileID
		delete LOAD_TABLES.BackgroundFieldsError where DataFileID = @DataFileID
		delete LOAD_TABLES.QuestionFormError where DataFileID = @DataFileID
		delete LOAD_TABLES.ResponseBubbleError where DataFileID = @DataFileID
		delete LOAD_TABLES.ResponseCommentError where DataFileID = @DataFileID
		delete LOAD_TABLES.ResponseCommentCommentCodeError where DataFileID = @DataFileID        
   	    delete LOAD_TABLES.CommentAlertError where DataFileID = @DataFileID
        delete LOAD_TABLES.SamplePopulationDispositionLogError where DataFileID = @DataFileID
        delete LOAD_TABLES.ResponseBubbleOBMappingLog where DataFileID = @DataFileID
		delete LOAD_TABLES.SampleUnitBySampleSetError where DataFileID = @DataFileID --			S23 US8
	 end


     ALTER INDEX ALL ON LOAD_TABLES.SampleSet REBUILD
	 ALTER INDEX ALL ON LOAD_TABLES.SampleSetError REBUILD

	ALTER INDEX ALL ON LOAD_TABLES.SamplePopulation REBUILD
	ALTER INDEX ALL ON LOAD_TABLES.SamplePopulationError REBUILD
	ALTER INDEX ALL ON LOAD_TABLES.SamplePopulationNPIError REBUILD
	
	ALTER INDEX ALL ON LOAD_TABLES.SamplePopulationDispositionLog REBUILD
	ALTER INDEX ALL ON LOAD_TABLES.SamplePopulationDispositionLogError REBUILD
	 
	ALTER INDEX ALL ON LOAD_TABLES.SelectedSample REBUILD
	ALTER INDEX ALL ON LOAD_TABLES.SelectedSampleError REBUILD
	
	ALTER INDEX ALL ON LOAD_TABLES.BackgroundFields REBUILD
	ALTER INDEX ALL ON LOAD_TABLES.BackgroundFieldsError REBUILD

	ALTER INDEX ALL ON LOAD_TABLES.QuestionForm REBUILD
	ALTER INDEX ALL ON LOAD_TABLES.QuestionFormError REBUILD
		
	ALTER INDEX ALL ON LOAD_TABLES.ResponseBubble REBUILD
	ALTER INDEX ALL ON LOAD_TABLES.ResponseBubbleError REBUILD

	ALTER INDEX ALL ON LOAD_TABLES.ResponseComment REBUILD
	ALTER INDEX ALL ON LOAD_TABLES.ResponseCommentError REBUILD

	ALTER INDEX ALL ON LOAD_TABLES.ResponseCommentCommentCode REBUILD
	ALTER INDEX ALL ON LOAD_TABLES.ResponseCommentCommentCodeError REBUILD

	ALTER INDEX ALL ON LOAD_TABLES.CommentAlertError REBUILD

	ALTER INDEX ALL ON LOAD_TABLES.SampleUnitBySampleSet REBUILD --			S23 US8
	ALTER INDEX ALL ON LOAD_TABLES.SampleUnitBySampleSetError REBUILD --			S23 US8

GO

USE [NRC_Datamart]
GO
/****** Object:  StoredProcedure [dbo].[etl_ClearLoadTables]    Script Date: 4/22/2015 10:26:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[etl_ClearLoadTables]
	@DataFileID int,@RetainLoadData bit
	--exec [dbo].[etl_ClearLoadTables] 3366,0
as

   --deletes rows for current datafile,including error rows, in case being rerun 
   --in addition, deletes rows of previous night's load, assuming RetainLoadData parameter is set to true, 
   --if not, data will be deleted in etl_ClearEventLoadTables sp
   ---assumes only one file is being processed nightly for a datasource and filename where the same
   --NOTE - error rows are never deleted for previous night's data!!!!
   -- =============================================
-- Procedure Name: etl_ClearEventLoadTables
-- History: 1.0  Original as of 2015.04.21
--			S23 US8  Add LOAD_TABLES.SampleUnitBySampleSet  Tim Butler
-- =============================================

  SET NOCOUNT ON
  

  	DECLARE @oImportRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [ETL].[InsertImportRunLog] @DataFileID, @TaskName, @currDateTime1, @ImportRunLogID = @oImportRunLogID OUTPUT

  Declare @IsEventLoad int

  Set @IsEventLoad = (Select Count(1)
                      From ETL.DataFile with (NOLOCK)
                      Where DataFileID = @DataFileID 
                      And FileName Like '%Event%')
--
--  Select @IsEventLoad
  
   Declare @PrevDataFileID Int
	--   Declare @DataFileID Int
	--   set @DataFileID = 490

   Set @PrevDataFileID = (Select Max(DataFile.DataFileID) As DataFileID
                          From ETL.DataFile DataFile with (NOLOCK)
                          Inner Join (Select FileName,DataSourceID
                                      From ETL.DataFile with (NOLOCK)
                                      Where  DataFileID = @DataFileID ) x  
                           On DataFile.FileName = x.FileName And DataFile.DataSourceID = x.DataSourceID
                           Where DataFileID < @DataFileID
                        )

--    select  @PrevDataFileID

   if @IsEventLoad = 0 
	  begin	   
			
			if @RetainLoadData = 1
			begin
				delete lt from LOAD_TABLES.Client lt with (NOLOCK) where DataFileID = @DataFileID
				delete  lt from  LOAD_TABLES.ClientGroup lt with (NOLOCK) where DataFileID = @DataFileID
				delete lt from LOAD_TABLES.ClientContact lt with (NOLOCK) where DataFileID = @DataFileID		
				delete lt from LOAD_TABLES.Study lt with (NOLOCK) where DataFileID = @DataFileID
				delete lt from LOAD_TABLES.StudyMetadata lt with (NOLOCK) where DataFileID = @DataFileID
				delete lt from LOAD_TABLES.Survey lt with (NOLOCK) where DataFileID = @DataFileID
				delete lt from LOAD_TABLES.SurveyQuestion lt with (NOLOCK) where DataFileID = @DataFileID			
				delete lt from LOAD_TABLES.ScaleItem lt with (NOLOCK) where DataFileID = @DataFileID		
				delete lt from LOAD_TABLES.SampleUnit lt with (NOLOCK) where DataFileID = @DataFileID			
				delete lt from LOAD_TABLES.SampleUnitFacilityAttributes lt with (NOLOCK) where DataFileID = @DataFileID			
				delete lt from LOAD_TABLES.SampleUnitServiceType lt with (NOLOCK) where DataFileID = @DataFileID					
				delete lt from LOAD_TABLES.LocalizedText lt with (NOLOCK) where DataFileID = @DataFileID
			end
			
			else
			begin
				delete lt from LOAD_TABLES.ClientGroup lt with (NOLOCK) where DataFileID in (@DataFileID	,@PrevDataFileID)								
				delete lt from LOAD_TABLES.Client lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.ClientContact lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.Study lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.StudyMetadata lt with (NOLOCK) where DataFileID = @DataFileID
				delete lt from LOAD_TABLES.Survey lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.SurveyQuestion lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.ScaleItem lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.SampleUnit lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.SampleUnitFacilityAttributes lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.SampleUnitServiceType lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.LocalizedText lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
			 end
			 
			delete lt from LOAD_TABLES.ClientContactError lt with (NOLOCK) where DataFileID in (@DataFileID)	
			delete lt from LOAD_TABLES.StudyError lt with (NOLOCK) where DataFileID in (@DataFileID)
			delete lt from LOAD_TABLES.StudyMetadataError lt with (NOLOCK) where DataFileID = @DataFileID
			delete lt from LOAD_TABLES.SurveyError lt with (NOLOCK) where DataFileID in (@DataFileID)	
			delete lt from LOAD_TABLES.SurveyQuestionError lt with (NOLOCK) where DataFileID in (@DataFileID)				
			delete lt from LOAD_TABLES.ScaleItemError lt with (NOLOCK) where DataFileID in (@DataFileID)				
			delete lt from LOAD_TABLES.SampleUnitError lt with (NOLOCK) where DataFileID in (@DataFileID)				
			delete lt from LOAD_TABLES.SampleUnitFacilityAttributesError lt with (NOLOCK) where DataFileID in (@DataFileID)				
			delete lt from LOAD_TABLES.SampleUnitServiceTypeError lt with (NOLOCK) where DataFileID in (@DataFileID)			
			delete lt from LOAD_TABLES.LocalizedTextError lt with (NOLOCK) where DataFileID in (@DataFileID)	
		    delete lt from LOAD_TABLES.ClientGroupError lt with (NOLOCK) where DataFileID in (@DataFileID)
			delete lt from LOAD_TABLES.ClientError lt with (NOLOCK) where DataFileID in (@DataFileID)

            ALTER INDEX ALL ON LOAD_TABLES.ClientGroup REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.ClientGroupError REBUILD
			
			ALTER INDEX ALL ON LOAD_TABLES.Client REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.ClientError REBUILD

			ALTER INDEX ALL ON LOAD_TABLES.ClientContact REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.ClientContactError REBUILD
						
			ALTER INDEX ALL ON LOAD_TABLES.Study REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.StudyError REBUILD 
			
			ALTER INDEX ALL ON LOAD_TABLES.StudyMetadata REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.StudyMetadataError REBUILD  
			
			ALTER INDEX ALL ON LOAD_TABLES.Survey REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.SurveyError REBUILD

			ALTER INDEX ALL ON LOAD_TABLES.SurveyQuestion REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.SurveyQuestionError REBUILD

			ALTER INDEX ALL ON LOAD_TABLES.ScaleItem REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.ScaleItemError REBUILD

			ALTER INDEX ALL ON LOAD_TABLES.SampleUnit REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.SampleUnitError REBUILD

			ALTER INDEX ALL ON LOAD_TABLES.SampleUnitFacilityAttributes REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.SampleUnitFacilityAttributesError REBUILD

			ALTER INDEX ALL ON  LOAD_TABLES.SampleUnitServiceType REBUILD
			ALTER INDEX ALL ON  LOAD_TABLES.SampleUnitServiceTypeError REBUILD
				
			ALTER INDEX ALL ON LOAD_TABLES.LocalizedText REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.LocalizedTextError REBUILD 
             
		end

 if @IsEventLoad = 1
  begin	  
  
	  if @RetainLoadData = 1
			begin
				--deletes rows if reloading a file, or rerunning something in eror
				delete lt from LOAD_TABLES.SampleSet lt with (NOLOCK) where DataFileID = @DataFileID  
				delete lt from LOAD_TABLES.SamplePopulation lt with (NOLOCK) where DataFileID = @DataFileID
				delete lt from LOAD_TABLES.SamplePopulation_Cumulative lt with (NOLOCK) where DataFileID = @DataFileID
				delete lt from LOAD_TABLES.SamplePopulationDispositionLog lt with (NOLOCK) where DataFileID = @DataFileID
				delete lt from LOAD_TABLES.SamplePopulationDispositionLog_Cumulative lt with (NOLOCK) where DataFileID = @DataFileID
				delete lt from LOAD_TABLES.SelectedSample lt with (NOLOCK) where DataFileID = @DataFileID  
				delete lt from LOAD_TABLES.BackgroundFields lt with (NOLOCK) where DataFileID = @DataFileID
				delete lt from LOAD_TABLES.QuestionForm lt with (NOLOCK) where DataFileID = @DataFileID   
				delete lt from LOAD_TABLES.ResponseBubble lt with (NOLOCK) where DataFileID = @DataFileID      
				delete lt from LOAD_TABLES.ResponseBubbleOBMappingLog lt with (NOLOCK) where DataFileID = @DataFileID
				delete lt from LOAD_TABLES.ResponseComment lt with (NOLOCK) where DataFileID = @DataFileID     
				delete lt from LOAD_TABLES.ResponseCommentCommentCode lt with (NOLOCK) where DataFileID = @DataFileID 
				delete lt from LOAD_TABLES.SampleUnitBySampleSet lt where DataFileID = @DataFileID --			S23 US8 
			end
			
			else
			begin
				delete lt from LOAD_TABLES.SampleSet  lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.SamplePopulation  lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)		 
				delete lt from LOAD_TABLES.SelectedSample lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)			
				delete lt from LOAD_TABLES.BackgroundFields  lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.QuestionForm  lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)		
				delete lt from LOAD_TABLES.ResponseBubble lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)		
				delete lt from LOAD_TABLES.ResponseComment lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.ResponseCommentCommentCode  lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.SamplePopulationDispositionLog lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.SampleUnitBySampleSet lt where DataFileID in (@DataFileID,@PrevDataFileID) --			S23 US8 
			end
			
			delete lt from LOAD_TABLES.SampleSetError lt with (NOLOCK) where DataFileID = @DataFileID				
			delete lt from LOAD_TABLES.SamplePopulationError lt with (NOLOCK) where DataFileID = @DataFileID 
			delete lt from LOAD_TABLES.SamplePopulationNPIError lt with (NOLOCK) where DataFileID = @DataFileID 		
			delete lt from LOAD_TABLES.SamplePopulationDispositionLogError lt with (NOLOCK) where DataFileID = @DataFileID 	
		  	delete lt from LOAD_TABLES.SelectedSampleError lt with (NOLOCK) where DataFileID = @DataFileID				
			delete lt from LOAD_TABLES.BackgroundFieldsError lt with (NOLOCK) where DataFileID = @DataFileID				
			delete lt from LOAD_TABLES.QuestionFormError lt with (NOLOCK) where DataFileID = @DataFileID		
			delete lt from LOAD_TABLES.ResponseBubbleError lt with (NOLOCK) where DataFileID = @DataFileID						
			delete lt from LOAD_TABLES.ResponseCommentError lt with (NOLOCK) where DataFileID = @DataFileID				
			delete lt from LOAD_TABLES.ResponseCommentCommentCodeError lt with (NOLOCK) where DataFileID = @DataFileID
			delete lt from LOAD_TABLES.CommentAlertError lt with (NOLOCK) where DataFileID = @DataFileID  
			delete lt from LOAD_TABLES.SampleUnitBySampleSetError lt where DataFileID = @DataFileID --			S23 US8   
--   
   			ALTER INDEX ALL ON LOAD_TABLES.SampleSet REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.SampleSetError REBUILD

			ALTER INDEX ALL ON LOAD_TABLES.SamplePopulation REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.SamplePopulationError REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.SamplePopulationNPIError REBUILD
			
			ALTER INDEX ALL ON LOAD_TABLES.SamplePopulationDispositionLog REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.SamplePopulationDispositionLogError REBUILD
			 
			ALTER INDEX ALL ON LOAD_TABLES.SelectedSample REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.SelectedSampleError REBUILD
			
			ALTER INDEX ALL ON LOAD_TABLES.BackgroundFields REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.BackgroundFieldsError REBUILD

			ALTER INDEX ALL ON LOAD_TABLES.QuestionForm REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.QuestionFormError REBUILD
				
			ALTER INDEX ALL ON LOAD_TABLES.ResponseBubble REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.ResponseBubbleError REBUILD

			ALTER INDEX ALL ON LOAD_TABLES.ResponseComment REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.ResponseCommentError REBUILD

			ALTER INDEX ALL ON LOAD_TABLES.ResponseCommentCommentCode REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.ResponseCommentCommentCodeError REBUILD

   			ALTER INDEX ALL ON LOAD_TABLES.CommentAlertError REBUILD


  	SET @currDateTime2 = GETDATE();
	SELECT @oImportRunLogID,@currDateTime2,@TaskName
	EXEC [ETL].[UpdateImportRunLog] @oImportRunLogID, @currDateTime2 

 
   end
GO
