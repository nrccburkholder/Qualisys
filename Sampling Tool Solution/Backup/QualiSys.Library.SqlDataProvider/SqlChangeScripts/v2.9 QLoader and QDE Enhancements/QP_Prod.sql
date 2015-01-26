CREATE PROCEDURE DBO.QCL_DeleteDataset
@DatasetId INT
AS
/************/
-- Date: 	7/10/2006
-- Author: 	Steve Spicka
-- Purpose:	Peforms an datafile apply rollback, utilized via QLoader functionality.


/************/
-- First check if the dataset has been sampled.


IF (SELECT COUNT(*) FROM sampleset WHERE sampleset_id IN (SELECT sampleset_id FROM sampledataset WHERE dataset_id IN (@DatasetID))) > 0
  BEGIN
	RAISERROR ('The dataset cannot be deleted because it has already been sampled', 18, 1)
	RETURN
  END

/************/


DECLARE @StudyID INT
DECLARE @Sql VARCHAR(250)

-- Get the study for the dataset
SET @StudyID = (SELECT study_id from Data_Set WHERE dataset_id = @DatasetID)

-- Collect the pop_ids for the dataset to process.
SELECT pop_id INTO #pops FROM datasetmember WHERE dataset_id = @DatasetID 


-- Check if encounter and  population or just poplation table exist and need to be processed.
IF EXISTS (SELECT * FROM metatable WHERE study_id=@StudyID AND strtable_nm='encounter')

  -- Population and Encounter tbl(s)
  BEGIN

	SELECT enc_id INTO #encs FROM datasetmember WHERE dataset_id = @DatasetID 
	
	INSERT INTO rollbacks (survey_id, study_id, datrollback_dt, rollbacktype, cnt)
	SELECT NULL, ds.study_id, GETDATE(), 'Apply', COUNT(*)
	FROM datasetmember dsm, data_set ds
	WHERE dsm.dataset_id = @DatasetID
	AND dsm.dataset_id = ds.dataset_id
	GROUP BY ds.study_id
	
	DELETE #pops WHERE pop_id in (
	SELECT p.pop_id FROM datasetmember dsm, data_set ds, #pops p
	WHERE study_id = @StudyID
	AND ds.dataset_id = dsm.dataset_id
	AND dsm.pop_id = p.pop_id
	AND dsm.dataset_id <> @DatasetID )
	
	DELETE #encs WHERE enc_id in (
	SELECT e.enc_id FROM datasetmember dsm, data_set ds, #encs e
	WHERE study_id = @StudyID
	AND ds.dataset_id = dsm.dataset_id
	AND dsm.enc_id = e.enc_id
	AND dsm.dataset_id <> @DatasetID)
	
	DELETE datasetmember WHERE dataset_id = @DatasetID
	DELETE data_set WHERE dataset_id = @DatasetID
	
	SET @Sql = 'DELETE s' + LTRIM(RTRIM(CONVERT(CHAR(10),@StudyID))) + 
	           '.population WHERE pop_id in (
	            SELECT pop_id FROM #pops)'
	EXEC(@Sql)
	
	SET @Sql = 'DELETE s' + LTRIM(RTRIM(CONVERT(CHAR(10),@StudyID))) + 
	           '.encounter WHERE enc_id IN (
	           SELECT enc_id FROM #encs)'
	EXEC(@Sql)
	
	DROP TABLE #encs
	
  END
ELSE
  -- Just population tbl
  BEGIN

	INSERT INTO rollbacks (survey_id, study_id, datrollback_dt, rollbacktype, cnt)
	SELECT NULL, ds.study_id, GETDATE(), 'Apply', COUNT(*)
	FROM datasetmember dsm, data_set ds
	WHERE dsm.dataset_id = @DatasetID
	AND dsm.dataset_id = ds.dataset_id
	GROUP BY ds.study_id
	
	DELETE #pops WHERE pop_id IN (
	SELECT p.pop_id FROM datasetmember dsm, data_set ds, #pops p
	WHERE study_id = @StudyID
	AND ds.dataset_id = dsm.dataset_id
	AND dsm.pop_id = p.pop_id
	AND dsm.dataset_id <> @DatasetID )
	
	DELETE datasetmember WHERE dataset_id = @DatasetID
	DELETE data_set WHERE dataset_id = @DatasetID
	
	SET @Sql = 'DELETE s' + LTRIM(RTRIM(CONVERT(CHAR(10),@StudyID))) + 
	           '.population WHERE pop_id IN (
	            SELECT pop_id FROM #pops)'
	exec(@Sql)
	
  END

DROP TABLE #pops
/************/
