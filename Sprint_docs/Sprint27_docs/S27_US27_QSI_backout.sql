/*
	S27.US27	QSI
		As a Client Support Manager working with phone vendor data, I want QSI to import results when a breakoff disposition is not the final disposition 
		from the phone vendor, so that I do not have to manually manipulate the vendor files and reimport data prior to CMS submissions.

	T27.3	Scenario 2: Breakoff disposition with all missing responses
		•	An interviewer begins the survey, but the respondent answers “I don’t know” or something similar to all of the questions. These are marked with 
			the appropriate value for “missing”. After several questions, the interviewer gives up and ends the call with a breakoff disposition.
		•	The data from the vendor is brought into the DL_ tables. Since the responses are all “M”, they are recoded to -9 and brought into Qualisys 
			QuestionResult. The breakoff disposition is logged in disposition log.

		For the desired future functionality, I believe we discussed changing this to a “no response” disposition. 
		
		I noticed there is a “blank phone survey” disposition available (disposition_id = 27), but most CAHPS don’t have a disposition mapping to this.
		
		We could assign that dispo and add records in SurveyTypeDispositions to map that disposition_id to the appropriate CAHPS disposition for “no response”.

Dave Gilsdorf

NRC_DataMart_ETL:
ALTER PROCEDURE [dbo].[csp_CAHPSProcesses] 

QP_Prod:
CREATE PROCEDURE [dbo].[CheckForBlankBreakoffs]
insert into Disposition (Disposition_id,action_id,strReportLabel,MustHaveResults)
update/insert into SurveyTypeDispositions 

***************************************************************
**************** ALSO UPDATE THE FORMGEN JOB!!! ***************
***************************************************************
Manually change the CAHPS Pre-processing step:
1. change the name from CAHPS Pre-processing to CheckForCAHPSIncompletes
2. change the command from [exec dbo.sp_FG_CAHPSPreProcessing] to [exec dbo.CheckForCAHPSIncompletes]

go
*/
use NRC_DataMart_ETL
go
ALTER PROCEDURE [dbo].[csp_CAHPSProcesses] 
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
	ELSE
	IF @country = 'CA'
	BEGIN
		EXEC [QP_Prod].[dbo].[CIHICompleteness]
	END
go
use QP_Prod
go
if EXISTS (select * from sys.procedures where schema_id=1 and name = 'CheckForBlankBreakoffs')
	DROP PROCEDURE [dbo].[CheckForBlankBreakoffs]
go
DELETE FROM Disposition where Disposition_id=49
DELETE FROM SurveyTypeDispositions where Disposition_id=49
