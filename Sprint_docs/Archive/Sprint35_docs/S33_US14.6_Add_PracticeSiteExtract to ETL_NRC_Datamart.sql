/*

S33 US14 CG SUFacility Update	As a Research Associate, I want the SUFacility field populated for all CG-CAHPS units, so that the data is available for benchmarks. notes: Populate based on sampleunit in Medusa practice table where available. Depending on volume of remaining unmapped units, may want a mass update/bulk insert.

TASK 14.6	Cue the PracticeSite table to be sent in the Catalyst ETL for hook-up alongside SUFacility

Tim Butler

CREATE TABLE [LOAD_TABLES].[PracticeSite]
CREATE TABLE [LOAD_TABLES].[PracticeSiteError]
CREATE TABLE [LOAD_TABLES].[GroupSite]
CREATE TABLE [LOAD_TABLES].[GroupSiteError]
ALTER PROCEDURE [dbo].[etl_ClearLoadTables]
CREATE PROCEDURE [dbo].[etl_LoadPracticeSiteRecords]
CREATE PROCEDURE [dbo].[etl_LoadSiteGroupRecords]

*/


/* LOAD_TABLES */
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
					   AND st.NAME = 'PracticeSite')

		DROP TABLE [LOAD_TABLES].[PracticeSite]

GO


DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'

if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'PracticeSite')

			CREATE TABLE [LOAD_TABLES].[PracticeSite](
			[DataFileID] [int] NOT NULL,
			[PracticeSite_ID] [int] NOT NULL, -- Qualisys PracticeSite_ID
			[AssignedID] [nvarchar](20) NULL,
			[SiteGroup_ID] [int] NULL,	-- Qualisys SiteGroup_ID
			[PracticeName] [nvarchar](255) NULL,
			[Addr1] [nvarchar](255) NULL,
			[Addr2] [nvarchar](42) NULL,
			[City] [nvarchar](42) NULL,
			[ST] [nvarchar](2) NULL,
			[Zip5] [nvarchar](10) NULL,
			[Phone] [nvarchar](20) NULL,
			[PracticeOwnership] [nvarchar](2) NULL,
			[PatVisitsWeek] [int] NULL,
			[ProvWorkWeek] [int] NULL,
			[PracticeContactName] [nvarchar](255) NULL,
			[PracticeContactPhone] [nvarchar](10) NULL,
			[PracticeContactEmail] [nvarchar](255) NULL,
			[SampleUnit_id] [nvarchar](200) NULL,  -- Qualisys SampleUnit_id
			[SampleUnitid] [nvarchar](200) NULL,
			[bitActive] [bit] NOT NULL DEFAULT ((1)),
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
					   AND st.NAME = 'SiteGroup')

		DROP TABLE [LOAD_TABLES].[SiteGroup]

GO


DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'

if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'SiteGroup')

				CREATE TABLE [LOAD_TABLES].[SiteGroup](
				[DataFileID] [int] NOT NULL,
				[SiteGroup_ID] [int] NULL, --Qualisys SiteGroup_ID
				[AssignedID] [nvarchar](20) NULL,
				[GroupName] [nvarchar](50) NULL,
				[Addr1] [nvarchar](100) NULL,
				[Addr2] [nvarchar](42) NULL,
				[City] [nvarchar](42) NULL,
				[ST] [nvarchar](2) NULL,
				[Zip5] [nvarchar](10) NULL,
				[Phone] [nvarchar](20) NULL,
				[GroupOwnership] [nvarchar](2) NULL,
				[GroupContactName] [nvarchar](50) NULL,
				[GroupContactPhone] [nvarchar](10) NULL,
				[GroupContactEmail] [nvarchar](50) NULL,
				[MasterGroupID] [int] NULL,
				[MasterGroupName] [nvarchar](50) NULL,
				[bitActive] [bit] NOT NULL ,
			) ON [PRIMARY]

GO


/* LOAD_TABLES - ERROR */

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
					   AND st.NAME = 'PracticeSiteError')

		DROP TABLE [LOAD_TABLES].[PracticeSiteError]

GO


DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'

if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'PracticeSiteError')

			CREATE TABLE [LOAD_TABLES].[PracticeSiteError](
			[DataFileID] [int] NOT NULL,
			[PracticeSite_ID] [int] NOT NULL, -- Qualisys PracticeSite_ID
			[AssignedID] [nvarchar](20) NULL,
			[SiteGroup_ID] [int] NULL,	-- Qualisys SiteGroup_ID
			[PracticeName] [nvarchar](255) NULL,
			[Addr1] [nvarchar](255) NULL,
			[Addr2] [nvarchar](42) NULL,
			[City] [nvarchar](42) NULL,
			[ST] [nvarchar](2) NULL,
			[Zip5] [nvarchar](10) NULL,
			[Phone] [nvarchar](20) NULL,
			[PracticeOwnership] [nvarchar](2) NULL,
			[PatVisitsWeek] [int] NULL,
			[ProvWorkWeek] [int] NULL,
			[PracticeContactName] [nvarchar](255) NULL,
			[PracticeContactPhone] [nvarchar](10) NULL,
			[PracticeContactEmail] [nvarchar](255) NULL,
			[SampleUnit_id] [int] NULL,  -- Qualisys SampleUnit_id
			[SampleUnitid] [int] NULL,
			[bitActive] [bit] NOT NULL DEFAULT ((1)),
			[ErrorDescription] [nvarchar](1000) NOT NULL,
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
					   AND st.NAME = 'SiteGroupError')

		DROP TABLE [LOAD_TABLES].[SiteGroupError]

GO


DECLARE @schema_id int

select @schema_id = schema_id
from sys.schemas
WHERE name = 'LOAD_TABLES'

if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = @schema_id 
					   AND st.NAME = 'SiteGroupError')

				CREATE TABLE [LOAD_TABLES].[SiteGroupError](
				[DataFileID] [int] NOT NULL,
				[SiteGroup_ID] [int] NULL, --Qualisys SiteGroup_ID
				[AssignedID] [nvarchar](20) NULL,
				[GroupName] [nvarchar](50) NULL,
				[Addr1] [nvarchar](100) NULL,
				[Addr2] [nvarchar](42) NULL,
				[City] [nvarchar](42) NULL,
				[ST] [nvarchar](2) NULL,
				[Zip5] [nvarchar](10) NULL,
				[Phone] [nvarchar](20) NULL,
				[GroupOwnership] [nvarchar](2) NULL,
				[GroupContactName] [nvarchar](50) NULL,
				[GroupContactPhone] [nvarchar](10) NULL,
				[GroupContactEmail] [nvarchar](50) NULL,
				[MasterGroupID] [int] NULL,
				[MasterGroupName] [nvarchar](50) NULL,
				[bitActive] [bit] NOT NULL ,
				[ErrorDescription] [nvarchar](1000) NOT NULL,
			) ON [PRIMARY]

GO



/* DBO TABLES */

use [NRC_DataMart]
go



if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'PracticeSite')

		DROP TABLE [dbo].[PracticeSite]

GO


if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'PracticeSite')

		CREATE TABLE [dbo].[PracticeSite](
			[PracticeSiteID] [int] NOT NULL,
			[AssignedID] [nvarchar](20) NULL,
			[SiteGroupID] [int] NULL,
			[PracticeName] [nvarchar](255) NULL,
			[Addr1] [nvarchar](255) NULL,
			[Addr2] [nvarchar](42) NULL,
			[City] [nvarchar](42) NULL,
			[ST] [nvarchar](2) NULL,
			[Zip5] [nvarchar](10) NULL,
			[Phone] [nvarchar](20) NULL,
			[PracticeOwnership] [nvarchar](2) NULL,
			[PatVisitsWeek] [int] NULL,
			[ProvWorkWeek] [int] NULL,
			[PracticeContactName] [nvarchar](255) NULL,
			[PracticeContactPhone] [nvarchar](10) NULL,
			[PracticeContactEmail] [nvarchar](255) NULL,
			[SampleUnitid] [int] NULL,
			[bitActive] [bit] NOT NULL DEFAULT ((1)),
		) ON [PRIMARY]

GO

use [NRC_DataMart]
go

if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SiteGroup')

		DROP TABLE [dbo].[SiteGroup]

GO



if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SiteGroup')

		CREATE TABLE [dbo].[SiteGroup](
		[SiteGroupID] [int] NOT NULL,
		[AssignedID] [nvarchar](20) NULL,
		[GroupName] [nvarchar](50) NULL,
		[Addr1] [nvarchar](100) NULL,
		[Addr2] [nvarchar](42) NULL,
		[City] [nvarchar](42) NULL,
		[ST] [nvarchar](2) NULL,
		[Zip5] [nvarchar](10) NULL,
		[Phone] [nvarchar](20) NULL,
		[GroupOwnership] [nvarchar](2) NULL,
		[GroupContactName] [nvarchar](50) NULL,
		[GroupContactPhone] [nvarchar](10) NULL,
		[GroupContactEmail] [nvarchar](50) NULL,
		[MasterGroupID] [int] NULL,
		[MasterGroupName] [nvarchar](50) NULL,
		[bitActive] [bit] NOT NULL ,
		) ON [PRIMARY]

GO


GO


/* procs */

USE [NRC_Datamart]
GO
/****** Object:  StoredProcedure [dbo].[etl_ClearLoadTables]    Script Date: 9/15/2015 8:31:20 AM ******/
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
--			S33 US14.6	Add LOAD_Tables.PracticeSite	TSB
--			S33 US14.6	Add LOAD_Tables.SiteGroup	TSB
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
				delete lt from LOAD_TABLES.PracticeSite lt with (NOLOCK) where DataFileID = @DataFileID
				delete lt from LOAD_TABLES.SiteGroup lt with (NOLOCK) where DataFileID = @DataFileID
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
				delete lt from LOAD_TABLES.PracticeSite lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
				delete lt from LOAD_TABLES.SiteGroup lt with (NOLOCK) where DataFileID in (@DataFileID,@PrevDataFileID)
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
			delete lt from LOAD_TABLES.PracticeSiteError lt with (NOLOCK) where DataFileID = @DataFileID
			delete lt from LOAD_TABLES.SiteGroupError lt with (NOLOCK) where DataFileID = @DataFileID

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

			ALTER INDEX ALL ON LOAD_TABLES.PracticeSite REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.PracticeSiteError REBUILD

			ALTER INDEX ALL ON LOAD_TABLES.SiteGroup REBUILD
			ALTER INDEX ALL ON LOAD_TABLES.SiteGroupError REBUILD
             
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

USE [NRC_Datamart]

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'etl_LoadPracticeSiteRecords')
	DROP PROCEDURE [dbo].[etl_LoadPracticeSiteRecords]
GO


USE [NRC_Datamart]
GO

CREATE PROCEDURE [dbo].[etl_LoadPracticeSiteRecords]
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
		DELETE dbo.PracticeSite
		FROM dbo.PracticeSite ps WITH (NOLOCK)
		 INNER JOIN (SELECT lt.PracticeSite_ID, dsk.DataSourceKeyID
			 FROM LOAD_TABLES.PracticeSite lt WITH (NOLOCK)
			 INNER JOIN ETL.DataSourceKey dsk WITH (NOLOCK) ON dsk.DataSourceKey = lt.SampleUnit_id 
			 WHERE dsk.DataSourceID = 1
				AND dsk.EntityTypeID = 6
				AND lt.DataFileID = @DataFileID) lt ON lt.PracticeSite_ID = ps.PracticeSiteID and lt.DataSourceKeyID = ps.SampleUnitid

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
				INNER JOIN LOAD_TABLES.PracticeSite lt WITH (NOLOCK) ON lt.SampleUnitid = ps.SampleUnitid 
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


USE [NRC_Datamart]

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'etl_LoadSiteGroupRecords')
	DROP PROCEDURE [dbo].[etl_LoadSiteGroupRecords]
GO


USE [NRC_Datamart]
GO

CREATE PROCEDURE [dbo].[etl_LoadSiteGroupRecords]
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
	
	DECLARE @icnt INT, @ucnt INT, @dcnt INT, @ecnt INT
	
	set @dcnt = 0
	set @ucnt = 0
	set @ecnt = 0
   

		--------------------------------------------------------------------------------------
		-- Cleanup SiteGroup records
		--------------------------------------------------------------------------------------
		DELETE dbo.SiteGroup
		  FROM dbo.SiteGroup ps WITH (NOLOCK)
				INNER JOIN LOAD_TABLES.SiteGroup lt WITH (NOLOCK)
					ON lt.SiteGroup_ID = ps.SiteGroupID
		 WHERE lt.DataFileID = @DataFileID

		 SET @dcnt = @@ROWCOUNT

			INSERT [dbo].[SiteGroup]
					   ([SiteGroupID]
					   ,[AssignedID]
					   ,[GroupName]
					   ,[Addr1]
					   ,[Addr2]
					   ,[City]
					   ,[ST]
					   ,[Zip5]
					   ,[Phone]
					   ,[GroupOwnership]
					   ,[GroupContactName]
					   ,[GroupContactPhone]
					   ,[GroupContactEmail]
					   ,[MasterGroupID]
					   ,[MasterGroupName]
					   ,[bitActive])
				 SELECT SiteGroup_ID
						,AssignedID
						,GroupName
						,Addr1
						,Addr2
						,City
						,ST
						,Zip5
						,Phone
						,GroupOwnership
					    ,GroupContactName
					    ,GroupContactPhone
					    ,GroupContactEmail
					    ,MasterGroupID
					    ,MasterGroupName
					    ,bitActive
				 FROM [LOAD_TABLES].SiteGroup WITH (NOLOCK)
				 WHERE DataFileID = @DataFileID

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
		AND Entity = 'SiteGroup'

GO