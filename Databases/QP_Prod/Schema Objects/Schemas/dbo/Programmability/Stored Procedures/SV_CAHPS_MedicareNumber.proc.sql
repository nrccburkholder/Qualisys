

ALTER PROCEDURE [dbo].[SV_CAHPS_MedicareNumber]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @HCAHPS int
SELECT @HCAHPS = surveytype_id
from SurveyType
where SurveyType_dsc='HCAHPS IP'

declare @surveyType_id int, @Study_id int

SELECT @surveyType_id = SurveyType_id, @Study_id = Study_id
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

IF @surveyType_id = @HCAHPS
BEGIN
	DECLARE @CCNList TABLE (MedicareNumber varchar(20))
	INSERT INTO @CCNList (MedicareNumber)
	SELECT DISTINCT suf.MedicareNumber
	FROM dbo.SamplePlan sp
	INNER JOIN dbo.SampleUnit su on sp.SamplePlan_id = su.SamplePlan_id
	INNER JOIN dbo.SUFacility suf on su.SUFacility_id = suf.SUFacility_id
	INNER JOIN dbo.MedicareLookup ml on SUF.MedicareNumber = ml.MedicareNumber
	WHERE sp.Survey_id = @Survey_id
	and ml.Active = 1
	and su.bitHCAHPS = 1
	and su.DontSampleUnit = 0

	INSERT INTO #M (Error, strMessage)
	SELECT distinct 1, 'CCN "'+ccn.MedicareNumber+'" is also used in study ' + convert(varchar,sd.Study_id) + ', survey ' + convert(varchar, sd.Survey_id)
	FROM @CCNList ccn
	INNER JOIN dbo.SUFacility suf on ccn.MedicareNumber = suf.MedicareNumber
	INNER JOIN dbo.MedicareLookup ml on SUF.MedicareNumber = ml.MedicareNumber
	INNER JOIN dbo.SampleUnit su on suf.SUFacility_id = su.SUFacility_id
	INNER JOIN dbo.SamplePlan sp on su.SamplePlan_id=sp.SamplePlan_id
	INNER JOIN dbo.Survey_def sd on sp.Survey_id = sd.Survey_id
	WHERE ml.Active = 1
	AND sd.Study_id <> @Study_id
	and su.bitHCAHPS = 1
	and su.DontSampleUnit = 0
	
	IF @@ROWCOUNT=0
	BEGIN
		INSERT INTO #m (error, strmessage) 
		SELECT 0, 'All CCNs are unique to this study' 
	END
	ELSE
	BEGIN
		DECLARE @Client_id int, @ClientExceptionList VARCHAR(100)
		SELECT @Client_id=client_id
		from dbo.Study
		where Study_id=@Study_id
		
		SELECT @ClientExceptionList = strParam_Value
		FROM dbo.Qualpro_params
		WHERE STRPARAM_NM = 'SV_CCN_Exceptions' 
		AND strParam_Grp = 'ConfigurationManager' 
		AND datParam_Value > getdate()
		
		IF EXISTS (SELECT items FROM dbo.split(@ClientExceptionList,',') where items=@Client_id)
			UPDATE #M
			SET Error = 2
			where strMessage like 'CCN%'
	END	
END

SELECT * FROM #M

DROP TABLE #M