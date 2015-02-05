USE [QP_Prod]
GO

/******* Insert E501 rule for all HCAHPS surveys *****************************************/
DECLARE @Survey_id int

CREATE TABLE #Surveys (Survey_id int)

INSERT INTO #Surveys (Survey_id)
SELECT Survey_id FROM Survey_Def
WHERE SurveyType_id = 2

SELECT TOP 1 @Survey_id = Survey_id FROM #Surveys

WHILE @@RowCount > 0
BEGIN
	--PRINT 'Checking Rule for Survey ' + Convert(varchar, @Survey_id)

	IF EXISTS (SELECT mf.Field_id 
			   FROM Survey_Def sd, MetaTable mt, MetaField mf, MetaStructure ms
			   WHERE sd.Study_id = mt.Study_id
			     AND mt.Table_id = ms.Table_id
			     AND ms.Field_id = mf.Field_id
			     AND mt.strTable_Nm = 'POPULATION'
			     AND mf.strField_Nm = 'ADDRERR'
			     AND ms.bitPostedField_Flg = 1
			     AND sd.Survey_id = @Survey_id
	   )
	   AND
	   NOT EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'AddrErr'
					 AND op.strOperator = '='
					 AND cc.strLowValue = 'E501'
					 AND br.Survey_id = @Survey_id
	   )
	   AND
	   NOT EXISTS (SELECT BusinessRule_id 
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, CriteriaInList ci, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.CriteriaClause_id = ci.CriteriaClause_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'AddrErr'
					 AND op.strOperator = 'IN'
					 AND ci.strListValue = 'E501'
					 AND br.Survey_id = @Survey_id
	   )
	BEGIN
		--Add the rule to this survey
		--PRINT 'Adding Rule For Survey ' + Convert(varchar, @Survey_id)
		EXEC dbo.QCL_InsertHCAHPSDQRules @Survey_id
	END

	--Prepare for next pass
	DELETE #Surveys WHERE Survey_id = @Survey_id
	SELECT TOP 1 @Survey_id = Survey_id FROM #Surveys
END

--Cleanup
DROP TABLE #Surveys




/*
select * from Survey_Def
where SurveyType_id = 2

select top 10 * from Survey_Def
select * from SurveyType

sp_helptext QCL_InsertBusinessRule

		EXEC dbo.QCL_InsertHCAHPSDQRules 6989

SELECT Study_id
FROM dbo.Survey_def
WHERE Survey_id = 6989

SELECT mt.Table_id	
FROM dbo.MetaTable mt
WHERE mt.strTable_nm = 'POPULATION'
  AND mt.Study_id = 1712

SELECT Field_id 
FROM dbo.MetaData_View 
WHERE Table_id = 3231 
  AND Study_id = 1712
  AND strField_nm = 'ADDRERR'

SELECT * 
FROM Survey_Def sd, MetaTable mt, MetaField mf, MetaStructure ms
WHERE sd.Study_id = mt.Study_id
  AND mt.strTable_Nm = 'POPULATION'
  AND mt.Table_id = ms.Table_id
  AND ms.Field_id = mf.Field_id
  AND mf.strField_Nm = 'ADDRERR'
  AND sd.Survey_id = 7134
  AND ms.bitPostedField_Flg = 1

SELECT * 
FROM MetaTable mt, MetaField mf, MetaStructure ms
WHERE mt.strTable_Nm = 'POPULATION'
  AND mt.Table_id = ms.Table_id
  AND ms.Field_id = mf.Field_id
  AND mf.strField_Nm = 'ADDRERR'
  AND mt.Study_id = 1712

6989
7098
7122
7123
7124
7125

7134 (Good)

sp_helptext MetaData_View
*/