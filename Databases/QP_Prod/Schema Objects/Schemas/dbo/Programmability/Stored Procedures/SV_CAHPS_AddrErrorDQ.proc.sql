USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_AddrErrorDQ]    Script Date: 8/13/2014 1:35:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_AddrErrorDQ]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
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

IF @surveyType_id in (@HCAHPS)
	BEGIN

		IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'AddrErr'
					 AND op.strOperator = '='
					 AND cc.strLowValue = 'FO'
					 AND br.Survey_id = @Survey_id
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (AddrErr = "FO").'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ rule (AddrErr = "FO").'
	END

IF @surveyType_id in (@HHCAHPS)
	BEGIN

		IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'AddrErr'
					 AND op.strOperator = '='
					 AND cc.strLowValue = 'FO'
					 AND br.Survey_id = @Survey_id
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey has DQ rule (AddrErr = "FO").'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey does not have DQ rule (AddrErr = "FO").'
	END

SELECT * FROM #M

DROP TABLE #M