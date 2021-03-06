/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S53 ATL-564 Add Hospital CCN Field to Practice Site Table & UI

	As a Research Associate, I want a column added to the Practice Site table for Affiliated Hospital CCN, so that I can link practices to Billians data for relevant benchmarks.

	Tim Butler

	NRC_Datamart
		
		Add MedicareNumber column to dbo.PracticeSite, Load_Tables.PracticeSite and Load_Tables.PracticeSiteError tables
		ALTER PROCEDURE [dbo].[etl_LoadPracticeSiteRecords]


*/

use [NRC_DataMart]
go

begin tran
go
if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'PracticeSite' 
					   AND sc.NAME = 'MedicareNumber' )

	alter table [dbo].[PracticeSite] drop column MedicareNumber 

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
				WHERE  st.schema_id =  @schema_id 
					   AND st.NAME = 'PracticeSite' 
					   AND sc.NAME = 'MedicareNumber' )

	alter table [Load_Tables].[PracticeSite] drop column MedicareNumber 

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
				WHERE  st.schema_id =  @schema_id 
					   AND st.NAME = 'PracticeSiteError' 
					   AND sc.NAME = 'MedicareNumber' )

	alter table [Load_Tables].[PracticeSiteError] drop column MedicareNumber 

go

commit tran
go

USE [NRC_Datamart]
GO


ALTER PROCEDURE [dbo].[etl_LoadPracticeSiteRecords]
	@DataFileID INT,
	@DataSourceID INT
	--,@ReturnMessage AS NVARCHAR(500) OUTPUT
AS
	SET NOCOUNT ON	

	DECLARE @oImportRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [ETL].[InsertImportRunLog] @DataFileID, @TaskName, @currDateTime1, @ImportRunLogID = @oImportRunLogID OUTPUT
	
	DECLARE @icnt INT, @ucnt INT, @dcnt INT, @ecnt INT,@stcnt INT,@EntityTypeID INT
	
	SET @EntityTypeID = 6 -- SampleUnit
	set @dcnt = 0
	set @ucnt = 0
	set @ecnt = 0
   

		--------------------------------------------------------------------------------------
		-- Cleanup PracticeSite records
		--------------------------------------------------------------------------------------
		--DELETE dbo.PracticeSite
		--FROM dbo.PracticeSite ps WITH (NOLOCK)
		-- INNER JOIN (SELECT lt.PracticeSite_ID, dsk.DataSourceKeyID
		--	 FROM LOAD_TABLES.PracticeSite lt WITH (NOLOCK)
		--	 INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON dsk.DataSourceKey = lt.SampleUnit_id 
		--	 WHERE dsk.DataSourceID = @DataSourceID
		--		AND dsk.EntityTypeID = @EntityTypeID
		--		AND lt.DataFileID = @DataFileID) lt ON lt.PracticeSite_ID = ps.PracticeSiteID and lt.DataSourceKeyID = ps.SampleUnitid

		 SET @dcnt = @@ROWCOUNT

		UPDATE LOAD_TABLES.PracticeSite
			SET SampleUnitID = dsk.DataSourceKeyID
			FROM LOAD_TABLES.PracticeSite lt WITH (NOLOCK)
				INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON dsk.DataSourceKey = lt.SampleUnit_id 
			WHERE dsk.DataSourceID = @DataSourceID
			AND dsk.EntityTypeID = @EntityTypeID
			AND lt.DataFileID = @DataFileID		

		--------------------------------------------------------------------------------------
		-- Remove PracticeSite records that have the same SampleUnitId as the new record
		--------------------------------------------------------------------------------------
		DELETE dbo.PracticeSite
		  FROM dbo.PracticeSite ps WITH (NOLOCK)
				INNER JOIN LOAD_TABLES.SampleUnit lt WITH (NOLOCK) ON lt.SampleUnitid = ps.SampleUnitid 
		 WHERE lt.DataFileID = @DataFileID

		 SET @dcnt = @@ROWCOUNT + @dcnt

		INSERT [dbo].[PracticeSite]
			   ([PracticeSiteID]
			   ,[AssignedID]
			   ,[SiteGroupID]
			   ,[PracticeName]
			   ,[Addr1]
			   ,[Addr2]
			   ,[City]
			   ,[ST]
			   ,[Zip5]
			   ,[Phone]
			   ,[PracticeOwnership]
			   ,[PatVisitsWeek]
			   ,[ProvWorkWeek]
			   ,[PracticeContactName]
			   ,[PracticeContactPhone]
			   ,[PracticeContactEmail]
			   ,[SampleUnitid]
			   ,[bitActive])
		 SELECT PracticeSite_ID
				,AssignedID
				,SiteGroup_ID
				,PracticeName
				,Addr1
				,Addr2
				,City
				,ST
				,Zip5
				,Phone
				,PracticeOwnership
				,PatVisitsWeek
				,ProvWorkWeek
				,PracticeContactName
				,PracticeContactPhone
				,PracticeContactEmail
				,SampleUnitid
				,bitActive
		 FROM [LOAD_TABLES].PracticeSite WITH (NOLOCK)
		 WHERE SampleUnitID IS NOT NULL
		 AND DataFileID = @DataFileID


		SET @icnt = @@ROWCOUNT

	--------------------------------------------------------------------------------------
	-- Update Counts
	--------------------------------------------------------------------------------------	
	UPDATE ETL.DataFileCounts
	   SET Inserts = @icnt,
		   Updates = @ucnt,
		   Deletes = @dcnt,
           Errors = @ecnt
	  WHERE DataFileID = @DataFileID
		AND Entity = 'PracticeSite'

GO