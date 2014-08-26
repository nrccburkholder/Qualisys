USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_HH_CAHPS_DQRules]    Script Date: 8/13/2014 1:40:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SV_CAHPS_HH_CAHPS_DQRules]
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

--get Encounter MetaTable_ID this is so we can check for field existance before we check for
		--DQ rules.  If the field is not in the data structure we do not want to check for the error.
		SELECT @EncTable_ID = mt.Table_id
		FROM dbo.MetaTable mt
		WHERE mt.strTable_nm = 'ENCOUNTER'
		  AND mt.Study_id = @Study_id


		--check for DQ_Payer Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Payer'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Payer rule (HHPay_Mcare <> ''1'' AND HHPay_Mcaid <> ''1'').'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ_Payer rule (HHPay_Mcare <> ''1'' AND HHPay_Mcaid <> ''1'').'


		 --Check for DQ_visMo rules
		IF EXISTS (SELECT BusinessRule_id
			 FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
			 WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
			AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
			AND cc.Field_id = mf.Field_id
			AND cc.intOperator = op.Operator_Num
			AND mf.strField_Nm = 'HHVisitCnt'
			AND op.strOperator = '<'
			AND cc.strLowValue = '1'
			AND br.Survey_id = @Survey_id
		   )

		 INSERT INTO #M (Error, strMessage)
		 SELECT 0,'Survey has DQ_VisMo rule (HHVisitCnt < 1).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ_VisMo rule (HHVisitCnt < 1).'

		 --Check for DQ_Hospc rules
		 IF EXISTS (SELECT Field_id
			   FROM dbo.MetaData_View
			   WHERE Table_id = @EncTable_ID
		   AND Study_id = @Study_id
		   AND strField_nm = 'HHHospice')
		BEGIN
		 IF EXISTS (SELECT BusinessRule_id
			  FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
			  WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
			 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
			 AND cc.Field_id = mf.Field_id
			 AND cc.intOperator = op.Operator_Num
			 AND mf.strField_Nm = 'HHHospice'
			 AND op.strOperator = '='
			 AND cc.strLowValue = 'Y'
			 AND br.Survey_id = @Survey_id
			)

		  INSERT INTO #M (Error, strMessage)
		  SELECT 0,'Survey has DQ_Hospc rule (ENCOUNTERHHHospice = "Y").'
		 ELSE
		  INSERT INTO #M (Error, strMessage)
		  SELECT 1,'Survey does not have DQ_Hospc rule (ENCOUNTERHHHospice = "Y").'

		END

		 --Check for DQ_VisLk rules
		if exists ( SELECT BusinessRule_id
					FROM BusinessRule br
					inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
					inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
					inner join MetaField mf on cc.Field_id = mf.Field_id
					inner join Operator op on cc.intOperator = op.Operator_Num
					inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
					WHERE mf.strField_Nm = 'HHLookBackCnt'
					AND op.strOperator = 'IN'
					AND br.Survey_id = @Survey_id
					group by BusinessRule_id
					having count(*)=2 and min(strListValue) = '0' and max(strListValue)= '1'
					)
		INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_VisLk rule (ENCOUNTERHHLookbackCnt IN (0,1) ).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_VisLk rule (ENCOUNTERHHLookbackCnt IN (0,1) ).'

		--Check for DQ_Age rules
		IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'HHEOMAge'
					 AND op.strOperator = '<'
					 AND cc.strLowValue = '18'
		   AND br.Survey_id = @Survey_id
		   )

			INSERT INTO #M (Error, strMessage)
		SELECT 0,'Survey has DQ_Age rule (ENCOUNTERHHEOMAge < 18).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Age rule (ENCOUNTERHHEOMAge < 18).'


		--Check for DQ_Mat rules
		 IF EXISTS (SELECT Field_id
			   FROM dbo.MetaData_View
			   WHERE Table_id = @EncTable_ID
		   AND Study_id = @Study_id
		   AND strField_nm = 'HHMaternity')
		BEGIN
			IF EXISTS (SELECT BusinessRule_id
				FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
				AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
				AND cc.Field_id = mf.Field_id
				AND cc.intOperator = op.Operator_Num
				AND mf.strField_Nm = 'HHMaternity'
				AND op.strOperator = '='
				AND cc.strLowValue = 'Y'
				AND br.Survey_id = @Survey_id
			)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Mat rule (ENCOUNTERHHMaternity = "Y").'
			ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Mat rule (ENCOUNTERHHMaternity = "Y").'
		END

		IF EXISTS (SELECT Field_id
           FROM dbo.MetaData_View
           WHERE Table_id = @EncTable_ID
			AND Study_id = @Study_id
			AND strField_nm = 'HHNoPub')
		BEGIN
		   --Check for DQ_NoPub rules
			 IF EXISTS (SELECT BusinessRule_id
				  FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				  WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
				 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
				 AND cc.Field_id = mf.Field_id
				 AND cc.intOperator = op.Operator_Num
				 AND mf.strField_Nm = 'HHNoPub'
				 AND op.strOperator = '='
				 AND cc.strLowValue = 'Y'
				 AND br.Survey_id = @Survey_id
				)

			  INSERT INTO #M (Error, strMessage)
			  SELECT 0,'Survey has DQ_NoPub rule (ENCOUNTERHHNoPub = "Y").'
			 ELSE
			  INSERT INTO #M (Error, strMessage)
			  SELECT 1,'Survey does not have DQ_NoPub rule (ENCOUNTERHHNoPub = "Y").'

		END
		-- Check for DQ_Dead
		IF EXISTS (SELECT Field_id
			   FROM dbo.MetaData_View
			   WHERE Table_id = @EncTable_ID
		   AND Study_id = @Study_id
		   AND strField_nm = 'HHDeceased')
		BEGIN
		 IF EXISTS (SELECT BusinessRule_id
			  FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
			  WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
			 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
			 AND cc.Field_id = mf.Field_id
			 AND cc.intOperator = op.Operator_Num
			 AND mf.strField_Nm = 'HHDeceased'
			 AND op.strOperator = '='
			 AND cc.strLowValue = 'Y'
			 AND br.Survey_id = @Survey_id
			)

		  INSERT INTO #M (Error, strMessage)
		  SELECT 0,'Survey has DQ_Dead rule (ENCOUNTERHHDeceased = "Y").'
		 ELSE
		  INSERT INTO #M (Error, strMessage)
		  SELECT 1,'Survey does not have DQ_Dead rule (ENCOUNTERHHDeceased = "Y").'
		END

SELECT * FROM #M

DROP TABLE #M
GO


