/*
S23_US9	dispositions (fielding)	
	as a CIHI vendor we need to store dispositions for proper data submission

Dave Gilsdorf

T1 check for tables; confirm exist and create and populate as needed
	INSERT INTO SurveyTypeDispositions

T2 modify ETL
	ALTER PROCEDURE [dbo].[csp_CAHPSProcesses] 	
	CREATE PROCEDURE [dbo].[CIHICompleteness]

*/
USE [QP_Prod]
go
delete from SurveyTypeDispositions 
where [SurveyType_ID]=12
GO
if exists (select * from sys.procedures where schema_id=1 and name = 'CIHICompleteness')
	DROP PROCEDURE [dbo].[CIHICompleteness]
go
use [NRC_Datamart_ETL]
go
alter PROCEDURE [dbo].[csp_CAHPSProcesses] 
AS
-- this code was previously in NRC_Datamart_ETL.dbo.csp_CAHPSProcesses. We're putting it in its own proc so that 
-- it can be called at the beginning of the ETL, instead of in the middle.

	DECLARE @country VARCHAR(10)
	SELECT @country = [STRPARAM_VALUE] FROM [QP_Prod].[dbo].[qualpro_params] WHERE STRPARAM_NM = 'Country'
	select @country
	IF @country = 'US'
	BEGIN
		EXEC [QP_Prod].[dbo].[CheckForCAHPSIncompletes] 
		EXEC [QP_Prod].[dbo].[CheckForACOCAHPSUsablePartials]
		EXEC [QP_Prod].[dbo].[CheckForMostCompleteUsablePartials] -- HHCAHPS and ICHCAHPS
		EXEC [QP_Prod].[dbo].[CheckHospiceCAHPSDispositions]
	END
go