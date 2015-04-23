USE [NRC_Datamart]
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
		   AND p.SAMPLEUNITID IS NULL

	SET @icnt = @@ROWCOUNT

	--------------------------------------------------------------------------------------
	-- Update Existing records
	--------------------------------------------------------------------------------------
	UPDATE dbo.SampleUnitBySampleSet
	   SET NumPatInFile = lt.NumPatInFile
	 FROM LOAD_TABLES.SampleUnitBySampleSet lt WITH (NOLOCK)
		 INNER JOIN dbo.SampleUnitBySampleSet p WITH (NOLOCK) on p.SAMPLESETID = lt.SAMPLESETID and p.SAMPLEUNITID = lt.SAMPLEUNITID
		 WHERE DataFileID = @DataFileID
		   AND p.SAMPLEUNITID IS NOT NULL

	SET @ucnt = @@ROWCOUNT			

    INSERT INTO LOAD_TABLES.SampleUnitBySampleSetError
	SELECT [DataFileID]
      ,[SAMPLESET_ID]
      ,[SAMPLEUNIT_ID]
      ,[SAMPLESETID]
      ,[SAMPLEUNITID]
      ,[NumPatInfFile]
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
      ,[NumPatInfFile]
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
