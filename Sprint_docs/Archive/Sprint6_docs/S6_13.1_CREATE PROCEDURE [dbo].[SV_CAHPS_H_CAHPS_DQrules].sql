USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_H_CAHPS_DQrules]    Script Date: 8/13/2014 1:39:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SV_CAHPS_H_CAHPS_DQrules]
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

--check for DQ_Law rule
		IF EXISTS (	select *
					from (SELECT BusinessRule_id, cc.CriteriaPhrase_id
						   FROM BusinessRule br
						   inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
						   inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
						   inner join MetaField mf on cc.Field_id = mf.Field_id
						   inner join Operator op on cc.intOperator = op.Operator_Num
						   WHERE mf.strField_Nm = 'HAdmissionSource'
							 AND op.strOperator = '='
							 AND cc.strLowValue = '8'
							 AND br.Survey_id = @Survey_id
							) admit
					inner join (SELECT BusinessRule_id, cc.criteriaphrase_id
							   FROM BusinessRule br
							   inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
							   inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
							   inner join MetaField mf on cc.Field_id = mf.Field_id
							   inner join Operator op on cc.intOperator = op.Operator_Num
							   inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
							   WHERE mf.strField_Nm = 'HDischargeStatus'
								 AND op.strOperator = 'IN'
								 AND br.Survey_id = @Survey_id
							   group by BusinessRule_id, cc.criteriaclause_id, cc.criteriaphrase_id
							   having count(*)=2 and min(strListValue) = '21' and max(strListValue)= '87'
							   ) dischg
					 on admit.BusinessRule_id=dischg.BusinessRule_id 
						and admit.CriteriaPhrase_id <> dischg.CriteriaPhrase_id --> different CriteriaPhrase_id's means they have an OR relationship.
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Law rule (ENCOUNTERHAdmissionSource = 8 OR ENCOUNTERHDischargeStatus in ("21", "87")).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Law rule (ENCOUNTERHAdmissionSource = 8 OR ENCOUNTERHDischargeStatus in ("21", "87")).'


		--check for DQ_SNF rule
		IF EXISTS
		(
		 SELECT br.BUSINESSRULE_ID--, cs.strCriteriaStmt_nm, count(*), min(strListValue),max(strListValue),round(stdev(convert(int,strlistvalue)),6)
		  FROM BusinessRule br
		  inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
		  inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
		  inner join CriteriaInList ci on cc.CriteriaClause_id = ci.CriteriaClause_id
		  inner join MetaField mf on cc.Field_id = mf.Field_id
		  inner join Operator op on cc.intOperator = op.Operator_Num
		  WHERE mf.strField_Nm = 'HDischargeStatus'
		   AND op.strOperator = 'IN'
		   AND br.Survey_id = @Survey_id
		  GROUP BY br.BUSINESSRULE_ID
		  having count(*)=6 and min(strListValue) = '03' and max(strListValue)= '92' and round(stdev(convert(int,strlistvalue)),6)=38.940981
		  -- the STDEV of (3, 3, 61, 64, 83, 92) is 38.940981. Another combination of 6 integers with 3 as the min and 92 as the max would come up with a different STDEV
		)
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_SNF rule (ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_SNF rule (ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")).'


		--check for DQ_Hospc rule
		if exists
			(SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, CriteriaInList ci, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.CriteriaClause_id = ci.CriteriaClause_id
					 AND cc.Field_id = mf.Field_id
			  AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'HDischargeStatus'
					 AND op.strOperator = 'IN'
					 AND ci.strListValue = '50'
					 AND br.Survey_id = @Survey_id
		   )
		AND exists
			(SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, CriteriaInList ci, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.CriteriaClause_id = ci.CriteriaClause_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'HDischargeStatus'
					 AND op.strOperator = 'IN'
					 AND ci.strListValue = '51'
					 AND br.Survey_id = @Survey_id
		   )

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Hospc rule (ENCOUNTERHDischargeStatus in ("50", "51")).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Hospc rule (ENCOUNTERHDischargeStatus in ("50", "51")).'


		--check for DQ_Dead rule
		if exists
			(SELECT BusinessRule_id
				   FROM BusinessRule br
				   inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
				   inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
				   inner join CriteriaInList ci on cc.CriteriaClause_id = ci.CriteriaClause_id
				   inner join MetaField mf on cc.Field_id = mf.Field_id
				   inner join Operator op on cc.intOperator = op.Operator_Num
				   WHERE mf.strField_Nm = 'HDischargeStatus'
					 AND op.strOperator = 'IN'
					 AND br.Survey_id = @Survey_id
				   group by BusinessRule_id, cc.criteriaclause_id
				   having count(*)=4 and min(strListValue) = '20' and max(strListValue)= '42' and round(stdev(convert(int,strlistvalue)),6)=10.531698
				   -- the STDEV of (20, 40, 41, 42) is 10.531698. Another combination of 4 integers that has 20 as the min and 40 as the max would come up with a different STDEV
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Dead rule (ENCOUNTERHDischargeStatus in ("20", "40", "41", "42")).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Dead rule (ENCOUNTERHDischargeStatus in ("20", "40", "41", "42")).'



SELECT * FROM #M

DROP TABLE #M
GO


