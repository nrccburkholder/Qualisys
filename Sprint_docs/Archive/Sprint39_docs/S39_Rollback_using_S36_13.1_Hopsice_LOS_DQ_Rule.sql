/*

S39_Rollback_using_S36_13.1_Hopsice_LOS_DQ_Rule.sql

-->S36 US11 Hospice LOS DQ	As an authorized Hospice CAHPS Vendor, we want to remove the "is null" clause from the LOS DQ rule, so that we do not DQ decedents w/ missing admit dates. NOTES: Admit Date can now be missing.

Task 11.1	execute the rollback script from sprint 32 task 14.1

Tim Butler


modify DQ_LOS
update SV_CAHPS_Hospice_CAHPS_DQRules

*/

use qp_prod


go



declare @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'
declare @DCStmtId int, @FieldId int
declare @dq_name varchar(20) = 'DQ_LOS'

SELECT * 
FROM DefaultCriteriaStmt
where strCriteriaStmt_nm = @dq_name

select *
from DefaultCriteriaClause
WHERE DefaultCriteriaStmt_id in (SELECT DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @dq_name)

select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @dq_name

begin tran

UPDATE DefaultCriteriaStmt
	SET strCriteriaString = '(ENCOUNTERLengthOfStay < 2)'
WHERE DefaultCriteriaStmt_id = @DCStmtId

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'LengthOfStay'
DELETE DefaultCriteriaClause 
WHERE DefaultCriteriaStmt_id = @DCStmtId
AND CriteriaPhrase_id = 2
AND strTable_nm = 'ENCOUNTER'
and Field_id = @FieldId

commit tran


SELECT * 
FROM DefaultCriteriaStmt
where strCriteriaStmt_nm = @dq_name

select *
from DefaultCriteriaClause
WHERE DefaultCriteriaStmt_id in (SELECT DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = @dq_name)


GO

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Hospice_CAHPS_DQRules]    Script Date: 9/18/2015 12:11:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SV_CAHPS_Hospice_CAHPS_DQRules]
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

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
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


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--get Encounter MetaTable_ID this is so we can check for field existance before we check for
		--DQ rules.  If the field is not in the data structure we do not want to check for the error.
		SELECT @EncTable_ID = mt.Table_id
		FROM dbo.MetaTable mt
		WHERE mt.strTable_nm = 'ENCOUNTER'
		  AND mt.Study_id = @Study_id


		--check for DQ_L NM Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_NCG'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (LName IS NULL AND FName IS NULL AND ADDR IS NULL AND HSP_CaregiverRel IS NULL).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (LName IS NULL AND FName IS NULL AND ADDR IS NULL AND HSP_CaregiverRel IS NULL).'


				--check for DQ_MDFA Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_MDFA'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (AddrErr = ''FO'').'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (AddrErr = ''FO'').'


		--check for DQ_Age Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Age'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (HSP_DecdAge < 18).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (HSP_DecdAge < 18).'

		--check for DQ_LOS Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_LOS'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (LengthOfStay < 2).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (LengthOfStay < 2).'

		--check for DQ_Rel Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Rel'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (HSP_CaregiverRel=6).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (HSP_CaregiverRel=6).'

		--check for DQ_Guar Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Guar'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (HSP_GuardFlg = 1).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ rule (HSP_GuardFlg = 1).'

SELECT * FROM #M

DROP TABLE #M



