/*

	S18 US17 As an authorized Hospice CAHPS vendor, we need to count the number of supplemental questions for each sampled patient, so that we can report the data to CMS.

	Tim Butler

	BACKOUT

	alter table [dbo].[SamplePopulation]
	alter table [LOAD_TABLES].[SamplePopulation]
	alter table [LOAD_TABLES].[SamplePopulationError]
	alter table [LOAD_TABLES].[SamplePopulationNPIError]
	ALTER PROCEDURE [dbo].[etl_LoadSamplePopRecords]
	
*/

use [NRC_DataMart]
go
begin tran
go
if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SamplePopulation' 
					   AND sc.NAME = 'SupplementalQuestionCount' )

	alter table [dbo].[SamplePopulation] drop column SupplementalQuestionCount 

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
					   AND st.NAME = 'SamplePopulation' 
					   AND sc.NAME = 'SupplementalQuestionCount' )

	alter table [LOAD_TABLES].[SamplePopulation] drop column SupplementalQuestionCount

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
					   AND st.NAME = 'SamplePopulationError' 
					   AND sc.NAME = 'SupplementalQuestionCount' )

	alter table [LOAD_TABLES].[SamplePopulationError] drop column SupplementalQuestionCount

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
					   AND st.NAME = 'SamplePopulationNPIError' 
					   AND sc.NAME = 'SupplementalQuestionCount' )

	alter table [LOAD_TABLES].[SamplePopulationNPIError] drop column SupplementalQuestionCount

go

commit tran
go


USE [NRC_Datamart]
GO

/****** Object:  StoredProcedure [dbo].[etl_LoadSamplePopulationRecords]    Script Date: 2/12/2015 3:26:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ccaouette: Modified to handle data moves/copies (2014/05)
ALTER PROCEDURE [dbo].[etl_LoadSamplePopulationRecords] @DataFileID INT
	,@DataSourceID INT
	,@ProcessDeletes BIT
	--,@ReturnMessage As NVarChar(500) Output  
	--exec [etl_LoadSamplePopulationRecords] 9,1,1,''  
AS
BEGIN

		SET NOCOUNT ON

  	DECLARE @oImportRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [ETL].[InsertImportRunLog] @DataFileID, @TaskName, @currDateTime1, @ImportRunLogID = @oImportRunLogID OUTPUT

		DECLARE @icnt INT
			,@ucnt INT
			,@dcnt INT
			,@ecnt INT
			,@EntityTypeID INT

		SET @EntityTypeID = 7 -- SamplePopulation  
			/*  
		declare @RetunCode int,@ReturnMessage As NVarChar(500)  
  
		exec @RetunCode = etl_LoadSamplePopulationRecords 4,1,0,@ReturnMessage Output  
  
		Select @ReturnMessage,@RetunCode  
  
		*/

		--------------------------------------------------------------------------------------  
		-- Find ID's for existing records  
		--------------------------------------------------------------------------------------  
		BEGIN TRANSACTION

			UPDATE LOAD_TABLES.SamplePopulation
			SET SampleSetID = dsk.DataSourceKeyID
			FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON dsk.DataSourceKey = lt.sampleset_id
			WHERE dsk.DataSourceID = @DataSourceID
				AND dsk.EntityTypeID = 8 -- SampleSet  
				AND lt.DataFileID = @DataFileID

		COMMIT

		BEGIN TRANSACTION

			UPDATE LOAD_TABLES.SamplePopulation
			SET SamplePopulationID = dsk.DataSourceKeyID
				,DispositionID = sp.DispositionID
				,CahpsDispositionID_initial = sp.CahpsDispositionID
				,isInsert = 0
			--select *              
			FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON dsk.DataSourceKey = lt.id
			INNER JOIN SamplePopulation sp ON dsk.DataSourceKeyID = sp.SamplePopulationID
			WHERE dsk.DataSourceID = @DataSourceID
				AND dsk.EntityTypeID = @EntityTypeID
				AND lt.DataFileID = @DataFileID

		COMMIT


		BEGIN TRANSACTION;
		 

			--WITH cte_SSM AS
			--(
			--	SELECT DISTINCT dsk_OLDSU.DataSourceKeyID As OLDSampleUnitID
			--			, dsk_NEWSU.DataSourceKeyID AS NewSampleUnitID
			--			, dsk_SP.DataSourceKeyID AS SamplePopulationID

			--	FROM 
			--		(SELECT DISTINCT CAST(OldSampleUnit_id AS VARCHAR(200)) AS OldSampleUnit_id
			--						, CAST(NewSampleUnit_id AS VARCHAR(200)) AS NewSampleUnit_id
			--						, CAST(SamplePop_ID AS VARCHAR(200)) AS SamplePop_ID
			--						, MAX(DateMoved) as MaxDateMoved
			--			FROM LOAD_TABLES.SelectedSampleMoves
			--			GROUP BY OldSampleUnit_id, NewSampleUnit_id, SamplePop_ID) AS ssm
			--	INNER JOIN ETL.DataSourceKey dsk_SP ON ssm.SamplePop_ID = dsk_SP.DataSourceKey AND dsk_SP.EntityTypeID = 7
			--	INNER JOIN ETL.DataSourceKey dsk_OLDSU ON ssm.OldSampleUnit_id = dsk_OLDSU.DataSourceKey AND dsk_OLDSU.EntityTypeID = 6
			--	INNER JOIN ETL.DataSourceKey dsk_NEWSU ON ssm.NewSampleUnit_id = dsk_NEWSU.DataSourceKey AND dsk_NEWSU.EntityTypeID = 6
			--)

			--------------------------------------------------------------------------------------  
		-- 05/2014 Dicussion with Don lead to removal SelectedSample deletion altogether.
		-- 10/2014  This appears to have been the incorrect decision
		--------------------------------------------------------------------------------------   
			DELETE spsu
			FROM dbo.SelectedSample spsu WITH (NOLOCK)
			INNER JOIN LOAD_TABLES.SamplePopulation lt WITH (NOLOCK) ON lt.SamplePopulationID = spsu.SamplePopulationID
			--LEFT JOIN cte_SSM t ON lt.SamplePopulationID = t.SamplePopulationID
			WHERE lt.DataFileID = @DataFileID --AND t.SamplePopulationID IS NULL
				AND IsDelete = 0 --deletes are handled below  

			SET @dcnt = @@ROWCOUNT

			UPDATE ETL.DataFileCounts
			SET Deletes = @dcnt + ISNULL(Deletes, 0)
			WHERE DataFileID = @DataFileID
				AND Entity = 'SelectedSample'

		COMMIT

		BEGIN TRANSACTION

			DELETE dbo.SamplePopulationBackgroundField
			FROM dbo.SamplePopulationBackgroundField spsu WITH (NOLOCK)
			INNER JOIN LOAD_TABLES.SamplePopulation lt WITH (NOLOCK) ON lt.SamplePopulationID = spsu.SamplePopulationID
			WHERE lt.DataFileID = @DataFileID
				AND IsDelete = 0 --deletes are handled below  

			SET @dcnt = @@ROWCOUNT

			UPDATE ETL.DataFileCounts
			SET Deletes = @dcnt + ISNULL(Deletes, 0)
			WHERE DataFileID = @DataFileID
				AND Entity = 'SamplePopulationBackgroundField'

		COMMIT

		BEGIN TRANSACTION

			DELETE dbo.SamplePopulationBackgroundFieldInternalOnly
			FROM dbo.SamplePopulationBackgroundFieldInternalOnly spsu WITH (NOLOCK)
			INNER JOIN LOAD_TABLES.SamplePopulation lt WITH (NOLOCK) ON lt.SamplePopulationID = spsu.SamplePopulationID
			WHERE lt.DataFileID = @DataFileID
				AND IsDelete = 0 --deletes are handled below  

			SET @dcnt = @@ROWCOUNT

			UPDATE ETL.DataFileCounts
			SET Deletes = @dcnt + ISNULL(Deletes, 0)
			FROM ETL.DataFileCounts
			WHERE DataFileID = @DataFileID
				AND Entity = 'SelectedSampleBackgroundFieldInternalOnly'

		COMMIT

		BEGIN TRANSACTION

			DELETE spsu
			FROM dbo.SamplePopulationBackgroundFieldSelectedOnly spsu WITH (NOLOCK)
			INNER JOIN LOAD_TABLES.SamplePopulation lt WITH (NOLOCK) ON lt.SamplePopulationID = spsu.SamplePopulationID
			WHERE lt.DataFileID = @DataFileID
				AND IsDelete = 0 --deletes are handled below  

			SET @dcnt = @@ROWCOUNT

			UPDATE ETL.DataFileCounts
			SET Deletes = @dcnt + ISNULL(Deletes, 0)
			FROM ETL.DataFileCounts
			WHERE DataFileID = @DataFileID
				AND Entity = 'SelectedSampleBackgroundFieldSelectedOnly'

		COMMIT

		--------------------------------------------------------------------------------------  
		-- Insert new records   
		--------------------------------------------------------------------------------------  
		BEGIN TRANSACTION

			INSERT INTO LOAD_TABLES.SamplePopulationNPIError
			SELECT *
				,'NPI is not valid'
			FROM LOAD_TABLES.SamplePopulation WITH (NOLOCK)
			WHERE DataFileID = @DataFileID
				AND (
					(
						DrNPI IS NOT NULL
						AND (
							LEN(DrNPI) <> 10
							OR PATINDEX('%[^0-9]%', DrNPI) > 0
							)
						)
					OR (
						ClinicNPI IS NOT NULL
						AND (
							LEN(ClinicNPI) <> 10
							OR PATINDEX('%[^0-9]%', ClinicNPI) > 0
							)
						)
					)

			INSERT INTO ETL.DataFileCounts (
				DataFileID
				,Entity
				,Updates
				,Deletes
				,Errors
				)
			SELECT @DataFileID
				,'SamplePopulationNPIError'
				,Updates = 0
				,Deletes = 0
				,Errors = @@ROWCOUNT

		COMMIT

		BEGIN TRANSACTION

			INSERT INTO LOAD_TABLES.SamplePopulationError
			SELECT *
				,CASE 
					WHEN SamplePopulationID IS NULL
						THEN 'SamplePopulationID Is NULL'
					WHEN SampleSetID IS NULL
						THEN 'SampleSetID Is NULL'
					ELSE 'Unknown'
					END
			FROM LOAD_TABLES.SamplePopulation WITH (NOLOCK)
			WHERE DataFileID = @DataFileID
				AND isDelete = 0
				AND SampleSetID IS NULL

			SET @ecnt = @@ROWCOUNT

		COMMIT

		BEGIN TRANSACTION

			INSERT ETL.DataSourceKey (
				DataSourceID
				,EntityTypeID
				,DataSourceKey
				)
			SELECT DISTINCT @DataSourceID
				,@EntityTypeID
				,lt.id
			FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
			LEFT JOIN LOAD_TABLES.SamplePopulationError lte WITH (NOLOCK) ON lt.id = lte.id
				AND lte.DataFileID = @DataFileID
			WHERE lt.DataFileID = @DataFileID
				AND lt.isInsert <> 0
				AND lt.isDelete = 0
				AND lte.id IS NULL

		COMMIT

			UPDATE LOAD_TABLES.SamplePopulation
			SET SamplePopulationID = dsk.DataSourceKeyID
			FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
			INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON dsk.DataSourceKey = lt.id
			WHERE dsk.DataSourceID = @DataSourceID
				AND dsk.EntityTypeID = @EntityTypeID
				AND lt.DataFileID = @DataFileID
				AND lt.isInsert <> 0
				AND lt.isDelete = 0

		BEGIN TRANSACTION

			INSERT dbo.SamplePopulation (
				SamplePopulationID
				,SampleSetID
				,DispositionID
				,CahpsDispositionID
				,FirstName
				,LastName
				,City
				,Province
				,PostalCode
				,IsMale
				,Age
				,DrNPI
				,ClinicNPI
				,LanguageID
				,AdmitDate
				,ServiceDate
				,DischargeDate
				,DrNPI_Initial
				,ClinicNPI_Initial
				)
			SELECT DISTINCT lt.SamplePopulationID
				,lt.SampleSetID
				,0
				,0
				,lt.FirstName
				,lt.LastName
				,lt.City
				,lt.Province
				,lt.PostalCode
				,lt.IsMale
				,lt.Age
				,CASE 
					WHEN PATINDEX('%[^0-9]%', lt.DrNPI) = 0
						THEN lt.DrNPI
					ELSE NULL
					END
				,CASE 
					WHEN PATINDEX('%[^0-9]%', lt.ClinicNPI) = 0
						THEN lt.ClinicNPI
					ELSE NULL
					END
				,lt.LanguageID
				,CAST(lt.AdmitDate AS DATE)
				,CAST(lt.ServiceDate AS DATE)
				,CAST(lt.DischargeDate AS DATE)
				,lt.DrNPI
				,lt.ClinicNPI
			FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
			LEFT JOIN LOAD_TABLES.SamplePopulationError lte WITH (NOLOCK) ON lte.DataFileID = @DataFileID
				AND lt.id = lte.id
			WHERE lt.DataFileID = @DataFileID
				AND lt.isInsert <> 0
				AND lt.isDelete = 0
				AND lte.id IS NULL

			SET @icnt = @@ROWCOUNT

		COMMIT

		--------------------------------------------------------------------------------------  
		-- Update Existing records  
		--------------------------------------------------------------------------------------  
		BEGIN TRANSACTION

			UPDATE dbo.SamplePopulation
			SET SampleSetID = lt.SampleSetID
				,FirstName = lt.FirstName
				,LastName = lt.LastName
				,City = lt.City
				,Province = lt.Province
				,PostalCode = lt.PostalCode
				,IsMale = lt.IsMale
				,Age = lt.Age
				,DrNPI = CASE 
					WHEN PATINDEX('%[^0-9]%', lt.DrNPI) = 0
						THEN lt.DrNPI
					ELSE NULL
					END
				,ClinicNPI = CASE 
					WHEN PATINDEX('%[^0-9]%', lt.ClinicNPI) = 0
						THEN lt.ClinicNPI
					ELSE NULL
					END
				,LanguageID = lt.LanguageID
				,AdmitDate = CAST(lt.AdmitDate AS DATE)
				,ServiceDate = CAST(lt.ServiceDate AS DATE)
				,DischargeDate = CAST(lt.DischargeDate AS DATE)
				,DrNPI_Initial = lt.DrNPI
				,ClinicNPI_Initial = lt.ClinicNPI
			FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
			INNER JOIN dbo.SamplePopulation WITH (NOLOCK) ON SamplePopulation.SamplePopulationID = lt.SamplePopulationID
			LEFT JOIN LOAD_TABLES.SamplePopulationError lte WITH (NOLOCK) ON lte.DataFileID = @DataFileID
				AND lt.id = lte.id
			WHERE lt.DataFileID = @DataFileID
				AND lt.isInsert = 0
				AND lt.isDelete = 0
				AND lte.id IS NULL

			SET @ucnt = @@ROWCOUNT

		COMMIT

		IF @ProcessDeletes = 1
		BEGIN
			BEGIN TRANSACTION

				--------------------------------------------------------------------------------------  
				-- Delete old records  
				--------------------------------------------------------------------------------------  
				--find all the sample pop child rows to delete  
				SELECT lt.SamplePopulationID
					,QuestionForm.QuestionFormID
					,ResponseComment.ResponseCommentID -- *    
				INTO #temp
				FROM LOAD_TABLES.SamplePopulation lt WITH (NOLOCK)
				LEFT JOIN QuestionForm WITH (NOLOCK) ON lt.SamplePopulationID = QuestionForm.SamplePopulationID
				LEFT JOIN ResponseComment WITH (NOLOCK) ON QuestionForm.QuestionFormID = ResponseComment.QuestionFormID
				WHERE lt.DataFileID = @DataFileID
					AND isDelete = 1

				DELETE dbo.ResponseCommentCommentCode
				--          select *  
				FROM #temp TEMP
				WITH (NOLOCK)
				INNER JOIN dbo.ResponseCommentCommentCode rc WITH (NOLOCK) ON TEMP.ResponseCommentID = rc.ResponseCommentID

				SET @dcnt = @@ROWCOUNT

				--------------------------------------------------------------------------------------  
				-- Update Counts  
				--------------------------------------------------------------------------------------   
				UPDATE ETL.DataFileCounts
				SET Deletes = @dcnt + ISNULL(Deletes, 0)
				WHERE DataFileID = @DataFileID
					AND Entity = 'ResponseCommentCommentCode'

				--note - correspoding datasourcekey row is deleted via a trigger on the ResponseComment table   
				DELETE dbo.ResponseComment
				OUTPUT DELETED.ResponseCommentID
					,@DataFileID
					,dsk.DataSourceID
					,dsk.EntityTypeID
					,dsk.DataSourceKey
					,GETDATE()
					,'etl_LoadSamplePopulationRecords'
				INTO [ETL].[DataSourceKeyDelete]
				--         select *  
				FROM #temp TEMP
				WITH (NOLOCK)
				INNER JOIN dbo.ResponseComment rc WITH (NOLOCK) ON TEMP.ResponseCommentID = rc.ResponseCommentID
				INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON rc.ResponseCommentID = dsk.DataSourceKeyID

				SET @dcnt = @@ROWCOUNT

				--------------------------------------------------------------------------------------  
				-- Update Counts  
				--------------------------------------------------------------------------------------   
				UPDATE ETL.DataFileCounts
				SET Deletes = @dcnt + ISNULL(Deletes, 0)
				WHERE DataFileID = @DataFileID
					AND Entity = 'ResponseComment'

				--note - correspoding datasourcekey row is deleted via a trigger on the ResponseBubble table  
				DELETE dbo.ResponseBubbleSet
				--          select *  
				FROM #temp TEMP
				WITH (NOLOCK)
				INNER JOIN dbo.ResponseBubbleSet rb WITH (NOLOCK) ON TEMP.QuestionFormID = rb.QuestionFormID

				--note - correspoding datasourcekey row is deleted via a trigger on the ResponseBubble table  
				DELETE dbo.ResponseBubble
				--          select *  
				FROM #temp TEMP
				WITH (NOLOCK)
				INNER JOIN dbo.ResponseBubble rb WITH (NOLOCK) ON TEMP.QuestionFormID = rb.QuestionFormID

				SET @dcnt = @@ROWCOUNT

				--------------------------------------------------------------------------------------  
				-- Update Counts  
				--------------------------------------------------------------------------------------   
				UPDATE ETL.DataFileCounts
				SET Deletes = @dcnt + ISNULL(Deletes, 0)
				WHERE DataFileID = @DataFileID
					AND Entity = 'ResponseBubble'

				--note - correspoding datasourcekey row is deleted via a trigger on the QuestionForm table  
				DELETE dbo.QuestionForm
				OUTPUT DELETED.QuestionFormID
					,@DataFileID
					,dsk.DataSourceID
					,dsk.EntityTypeID
					,dsk.DataSourceKey
					,GETDATE()
					,'etl_LoadSamplePopulationRecords'
				INTO [ETL].[DataSourceKeyDelete]
				--          select *  
				FROM #temp TEMP
				WITH (NOLOCK)
				INNER JOIN dbo.QuestionForm qf WITH (NOLOCK) ON TEMP.QuestionFormID = qf.QuestionFormID
				INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON qf.QuestionFormID = dsk.DataSourceKeyID

				SET @dcnt = @@ROWCOUNT

				--------------------------------------------------------------------------------------  
				-- Update Counts  
				--------------------------------------------------------------------------------------   
				UPDATE ETL.DataFileCounts
				SET Deletes = @dcnt + ISNULL(Deletes, 0)
				WHERE DataFileID = @DataFileID
					AND Entity = 'QuestionForm'

				DELETE dbo.SamplePopulationBackgroundField
				--          select *  
				FROM #temp TEMP
				WITH (NOLOCK)
				INNER JOIN dbo.SamplePopulationBackgroundField ss WITH (NOLOCK) ON TEMP.SamplePopulationID = ss.SamplePopulationID

				SET @dcnt = @@ROWCOUNT

				--------------------------------------------------------------------------------------  
				-- Update Counts  
				--------------------------------------------------------------------------------------   
				UPDATE ETL.DataFileCounts
				SET Deletes = @dcnt + ISNULL(Deletes, 0)
				FROM ETL.DataFileCounts
				WHERE DataFileID = @DataFileID
					AND Entity = 'SamplePopulationBackgroundField'

				DELETE dbo.SamplePopulationBackgroundFieldInternalOnly
				--          select *  
				FROM #temp TEMP
				WITH (NOLOCK)
				INNER JOIN dbo.SamplePopulationBackgroundFieldInternalOnly ss WITH (NOLOCK) ON TEMP.SamplePopulationID = ss.SamplePopulationID

				SET @dcnt = @@ROWCOUNT

				--------------------------------------------------------------------------------------  
				-- Update Counts  
				--------------------------------------------------------------------------------------   
				UPDATE ETL.DataFileCounts
				SET Deletes = @dcnt + ISNULL(Deletes, 0)
				FROM ETL.DataFileCounts
				WHERE DataFileID = @DataFileID
					AND Entity = 'SamplePopulationBackgroundFieldInternalOnly'

				DELETE dbo.SamplePopulationBackgroundFieldSelectedOnly
				--          select *  
				FROM #temp TEMP
				WITH (NOLOCK)
				INNER JOIN dbo.SamplePopulationBackgroundFieldSelectedOnly ss WITH (NOLOCK) ON TEMP.SamplePopulationID = ss.SamplePopulationID

				SET @dcnt = @@ROWCOUNT

				--------------------------------------------------------------------------------------  
				-- Update Counts  
				--------------------------------------------------------------------------------------   
				UPDATE ETL.DataFileCounts
				SET Deletes = @dcnt + ISNULL(Deletes, 0)
				FROM ETL.DataFileCounts
				WHERE DataFileID = @DataFileID
					AND Entity = 'SamplePopulationBackgroundFieldSelectedOnly'

				DELETE dbo.SelectedSample
				--          select *  
				FROM #temp TEMP
				WITH (NOLOCK)
				INNER JOIN dbo.SelectedSample ss WITH (NOLOCK) ON TEMP.SamplePopulationID = ss.SamplePopulationID

				SET @dcnt = @@ROWCOUNT

				--------------------------------------------------------------------------------------  
				-- Update Counts  
				--------------------------------------------------------------------------------------   
				UPDATE ETL.DataFileCounts
				SET Deletes = @dcnt + ISNULL(Deletes, 0)
				FROM ETL.DataFileCounts
				WHERE DataFileID = @DataFileID
					AND Entity = 'SelectedSample'

				DELETE dbo.SamplePopulationDispositionLog
				--          select *  
				FROM #temp TEMP
				WITH (NOLOCK)
				INNER JOIN dbo.SamplePopulationDispositionLog ss WITH (NOLOCK) ON TEMP.SamplePopulationID = ss.SamplePopulationID

				SET @dcnt = @@ROWCOUNT

				--------------------------------------------------------------------------------------  
				-- Update Counts  
				--------------------------------------------------------------------------------------   
				UPDATE ETL.DataFileCounts
				SET Deletes = @dcnt + ISNULL(Deletes, 0)
				FROM ETL.DataFileCounts
				WHERE DataFileID = @DataFileID
					AND Entity = 'SamplePopulationDispositionLog'

				--note - correspoding datasourcekey row is deleted via a trigger on the SamplePopulation table  
				DELETE dbo.SamplePopulation
				OUTPUT DELETED.SamplePopulationID
					,@DataFileID
					,dsk.DataSourceID
					,dsk.EntityTypeID
					,dsk.DataSourceKey
					,GETDATE()
					,'etl_LoadSamplePopulationRecords'
				INTO [ETL].[DataSourceKeyDelete]
				--select *  
				FROM #temp TEMP
				WITH (NOLOCK)
				INNER JOIN dbo.SamplePopulation sp WITH (NOLOCK) ON TEMP.SamplePopulationID = sp.SamplePopulationID
				INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON sp.SamplePopulationID = dsk.DataSourceKeyID

				SET @dcnt = @@ROWCOUNT

				COMMIT

				DROP TABLE #temp
					--ALTER TABLE SamplePopulation CHECK CONSTRAINT ALL   
		END

			--------------------------------------------------------------------------------------  
			-- Update SamplePopulation Counts  
			--------------------------------------------------------------------------------------   
			BEGIN TRANSACTION

			UPDATE ETL.DataFileCounts
			SET Inserts = @icnt
				,Updates = @ucnt
				,Deletes = @dcnt + ISNULL(Deletes, 0)
				,Errors = @ecnt
			WHERE DataFileID = @DataFileID
				AND Entity = 'SamplePopulation'

			COMMIT


  			SET @currDateTime2 = GETDATE();
			--SELECT @oImportRunLogID,@currDateTime2,@TaskName
			EXEC [ETL].[UpdateImportRunLog] @oImportRunLogID, @currDateTime2 	

			SET NOCOUNT OFF


END

GO


