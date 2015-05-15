/*
	S25.US10	de-duplication at CCN level
		dev work:  as a HCAHPS vendor we must do resurvey exclusion and householding at the CCN level
		
	T10.1	modify the HCAHPS survey validation to check if any CCN's associated with survey are linked to HCAHPS units in other studies 
			to warn IUHealth and to error out all others.  Add qualpro param.

Dave Gilsdorf

QP_Prod:
INSERT INTO Qualpro_params
ALTER PROCEDURE [dbo].[SV_CAHPS_MedicareNumber]

*/
USE QP_PROD
GO
declare @clientlist varchar(250)=''
select @clientlist=@clientlist+convert(varchar,client_id)+','
from client 
where strclient_nm in ('Indiana University Health','JWilley_Test','JWilley_Catalyst_Client','VRuenprom_Test')

INSERT INTO Qualpro_params ([STRPARAM_NM], [STRPARAM_TYPE], [STRPARAM_GRP], [STRPARAM_VALUE], [NUMPARAM_VALUE], [DATPARAM_VALUE], [COMMENTS])
SELECT N'SV_CCN_Exceptions' AS [STRPARAM_NM]
	, N'S' AS [STRPARAM_TYPE]
	, N'ConfigurationManager' AS [STRPARAM_GRP]
	, @clientlist AS [STRPARAM_VALUE]
	, NULL AS [NUMPARAM_VALUE]
	, '10/1/2015' AS [DATPARAM_VALUE]
	, 'The list of clients that are allowed to have CCNs span HCAHPS surveys in multiple studies, '
		+'but only if the survey is being validated before [datParam_value]' AS [COMMENTS]

GO
ALTER PROCEDURE [dbo].[SV_CAHPS_MedicareNumber]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @HCAHPS int
SELECT @HCAHPS = surveytype_id
from SurveyType
where SurveyType_dsc='HCAHPS IP'

declare @surveyType_id int

SELECT @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Make sure the Medicare number is populated.
INSERT INTO #M (Error, strMessage)
SELECT 1, 'Medicare number is not populated.' 
FROM   sampleplan sp, 
       sampleunit su 
       LEFT JOIN sufacility suf ON su.sufacility_id = suf.sufacility_id 
WHERE  sp.survey_id = @Survey_id 
       AND sp.sampleplan_id = su.sampleplan_id 
       AND su.cahpstype_id = @surveyType_id 
       AND ( suf.medicarenumber IS NULL 
              OR Ltrim(Rtrim(suf.medicarenumber)) = '' ) 

IF @@ROWCOUNT = 0 
  INSERT INTO #M (Error, strMessage)
  SELECT 0,'Medicare number is populated'

--make sure the Medicare number is active
INSERT INTO #M (Error, strMessage)
SELECT 1, 'Medicare number is not Active' 
FROM   sampleplan sp, 
       sampleunit su, 
       sufacility suf, 
       medicarelookup ml 
WHERE  sp.survey_id = @Survey_id 
       AND su.sufacility_id = suf.sufacility_id 
       AND sp.sampleplan_id = su.sampleplan_id 
       AND ml.medicarenumber = suf.medicarenumber 
       AND su.cahpstype_id = @surveyType_id 
       AND ml.active = 0 

IF @@ROWCOUNT = 0 
  INSERT INTO #m (error, strmessage) 
  SELECT 0, 'Medicare number is Active' 

IF @surveyType_id=@HCAHPS
BEGIN
	DECLARE @CCNList TABLE (MedicareNumber varchar(20))
	INSERT INTO @CCNList (MedicareNumber)
	SELECT DISTINCT suf.MedicareNumber
	FROM dbo.SamplePlan sp
	INNER JOIN dbo.SampleUnit su on sp.SamplePlan_id = su.SamplePlan_id
	INNER JOIN dbo.SUFacility suf on su.SUFacility_id = suf.SUFacility_id
	INNER JOIN dbo.MedicareLookup ml on SUF.MedicareNumber = ml.MedicareNumber
	WHERE sp.Survey_id = @Survey_id
	and ml.Active=1
	
END

SELECT * FROM #M

DROP TABLE #M
go