﻿CREATE PROCEDURE [dbo].[SV_CIHI_DQRules]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1


--If this is not an CIHI Survey, end the procedure                    
IF (@surveyType_id <> (SELECT SurveyType_ID FROM SurveyType WHERE SurveyType_dsc ='CIHI CPES-IC'))                 
BEGIN                    
    RETURN                    
END                    


DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END


declare @study_ID int --, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))


		--check for DQ_L NM Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_L NM'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (LName IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (LName IS NULL).'


		--check for DQ_F NM Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_F NM'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (FName IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (FName IS NULL).'


		--check for DQ_Addr Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Addr'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (Addr IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (Addr IS NULL).'


		--check for DQ_City Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_City'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (City IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (City IS NULL).'

		 --check for DQ_Prov Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_PROV'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (Province IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (Province IS NULL).'

		  --check for DQ_PstCd Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_PstCd'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (Postal_Code IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (PostalCode IS NULL).'

		--check for DQ_Age Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Age'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (Age IS NULL OR Age < 0).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (Age IS NULL OR Age < 0).'

		  --check for DQ_Sex Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Sex'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (Sex IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (Sex IS NULL).'

		  --check for DQ_LangI Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_LangI'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (LangID IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (LandID IS NULL).'

		  --check for DQ_MRN Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_MRN'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (MRN IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (MRN IS NULL).'

		--check for DQ_MDAE Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_MDAE'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (AddrErr IN (''NC'',''TL'',''FO'',''NU'')).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (AddrErr IN (''NC'',''TL'',''FO'',''NU'')).'

SELECT * FROM #M

DROP TABLE #M

