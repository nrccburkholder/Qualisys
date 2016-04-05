/*


	S46 US9 Lock Down CG CAHPS Survey Type 
	As a survey manager I want the survey type to be locked down if CG CAHPS is chosen so that we don't cause data issues by changing types.

	Task 1 - Analysis of current rules & validations around changing survey types
	Task 2 - Refactor survey type change rules to depend on field in SurveyType table or qualpro_params
	Task 3 - Add "are you sure?" dialog when changing type to CG, w/ warning about facility mappings (only if mapped facilities)
	Task 4 - If facility mappings exist on the original survey and we are changing type to/from CG, delete & archive when "OK" on Survey Properties
	
	CREATE PROCEDURE [dbo].[QCL_HasFacilityMapping]
	CREATE TABLE [dbo].[SAMPLEUNIT_FACILITYMAPPING_ARCHIVE]
	CREATE PROCEDURE [dbo].[QCL_ClearSurveyFacilityMappings]
	
	Tim Butler 

*/


use qp_prod

DECLARE @strParam_Grp as varchar(50) = 'SurveyRules'
DECLARE @strParam_nm as varchar(100) = 'SurveyRule: NotEditableIfSampled - CGCAHPS'

if not exists (select 1
from dbo.QUALPRO_PARAMS
where STRPARAM_GRP = @strParam_Grp 
and STRPARAM_NM = @strParam_nm )
	INSERT INTO [dbo].[QUALPRO_PARAMS]
			   ([STRPARAM_NM]
			   ,[STRPARAM_TYPE]
			   ,[STRPARAM_GRP]
			   ,[STRPARAM_VALUE]
			   ,[NUMPARAM_VALUE]
			   ,[DATPARAM_VALUE]
			   ,[COMMENTS])
		 VALUES
			   (@strParam_nm
			   ,'S'
			   ,@strParam_Grp
			   ,1
			   ,NULL
			   ,NULL
			   ,'CGCAHPS not editable if sampled for Config Man'
			   )


select *
from dbo.QUALPRO_PARAMS
where STRPARAM_GRP = @strParam_Grp
and STRPARAM_NM = @strParam_nm

go


USE [QP_Prod]
GO
    

if exists (select * from sys.procedures where name = 'QCL_HasFacilityMapping')
	drop procedure QCL_HasFacilityMapping


GO

CREATE PROCEDURE [dbo].[QCL_HasFacilityMapping]
@Survey_id INT
AS

/*  
Business Purpose:   
  
This procedure is used to support the Qualisys Class Library.  It indicates if 
a survey has a facility mapping.  
  
Created:  03/01/2016 by Tim Butler  
  
Modified:  
*/  



declare @SurveyType_Id int
SELECT  @SurveyType_Id = SurveyType_id
from Survey_Def
where Survey_id = @Survey_id


SELECT CASE WHEN EXISTS 
			(
				Select 1
				from dbo.SAMPLEPLAN sp 
				inner join dbo.SAMPLEUNIT su on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID
				where sp.SURVEY_ID = @Survey_id
				and su.SUFacility_id > 0
			) 
	THEN CONVERT(BIT,1) ELSE CONVERT(BIT,0) END bitHasFacilityMapping

GO

USE [QP_Prod]
GO
    

if exists (select * from sys.tables where name = 'SAMPLEUNIT_FACILITYMAPPING_ARCHIVE')
	drop table [dbo].[SAMPLEUNIT_FACILITYMAPPING_ARCHIVE]


CREATE TABLE [dbo].[SAMPLEUNIT_FACILITYMAPPING_ARCHIVE](
	[SAMPLEUNIT_ID] [int] NOT NULL,
	[SAMPLEPLAN_ID] [int] NOT NULL,
	[STRSAMPLEUNIT_NM] [varchar](42) NULL,
	[SUFacility_id] [int] NULL,
	[DateArchived] [DateTime] NULL
	)

GO

if exists (select * from sys.procedures where name = 'QCL_ClearSurveyFacilityMappings')
	drop procedure QCL_ClearSurveyFacilityMappings


GO

CREATE PROCEDURE [dbo].[QCL_ClearSurveyFacilityMappings]
@Survey_id INT
AS

	declare @SurveyType_Id int
	SELECT  @SurveyType_Id = SurveyType_id
	from Survey_Def
	where Survey_id = @Survey_id

	/*
		Create Archive of mappings cleared
	*/
	INSERT INTO [dbo].[SAMPLEUNIT_FACILITYMAPPING_ARCHIVE]
	Select su.SAMPLEUNIT_ID, sp.SAMPLEPLAN_ID, su.STRSAMPLEUNIT_NM, su.SUFacility_id, GETDATE()
	from dbo.SAMPLEPLAN sp 
	inner join dbo.SAMPLEUNIT su on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID
	where sp.SURVEY_ID = @Survey_id
	and su.SUFacility_id > 0


	UPDATE su
		SET su.SUFacility_id = 0
	from dbo.SAMPLEPLAN sp 
	inner join dbo.SAMPLEUNIT su on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID
	where sp.SURVEY_ID = @Survey_id
	and su.SUFacility_id > 0



GO