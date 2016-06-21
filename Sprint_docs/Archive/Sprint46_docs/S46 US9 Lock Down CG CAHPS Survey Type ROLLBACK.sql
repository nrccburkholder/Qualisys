/*

ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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

USE QP_Prod

DELETE
from dbo.QUALPRO_PARAMS
where STRPARAM_GRP = 'SurveyRules'
and STRPARAM_NM = 'SurveyRule: NotEditableIfSampled - CGCAHPS'

GO


USE [QP_Prod]
GO
    

if exists (select * from sys.procedures where name = 'QCL_HasFacilityMapping')
	drop procedure QCL_HasFacilityMapping


GO



USE [QP_Prod]
GO
    

if exists (select * from sys.tables where name = 'SAMPLEUNIT_FACILITYMAPPING_ARCHIVE')
	drop table [dbo].[SAMPLEUNIT_FACILITYMAPPING_ARCHIVE]

GO

if exists (select * from sys.procedures where name = 'QCL_ClearSurveyFacilityMappings')
	drop procedure QCL_ClearSurveyFacilityMappings


GO

