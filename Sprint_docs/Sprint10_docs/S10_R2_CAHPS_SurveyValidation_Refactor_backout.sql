/*

****THIS IS THE BACKOUT SCRIPT ************
S10.R2	Refactor SP's

		As an ALLCAHPS developer I would like to refactor SP's to remove redundancies, hardcoding, etc. to have more maintainable code.

Tim Butler

ALTER TABLE [dbo].[SurveyValidationProcs]
ALTER VIEW [dbo].[SurveyValidationProcs_view]
INSERT New Proc INTO SurveyValidationProcs and SurveyValidationProcsBySurveyType
ALTER PROCEDURE [dbo].[SV_CAHPS_AddrErrorDQ]
CREATE PROCEDURE [dbo].[SV_CAHPS_DQrules]

*/

USE QP_PROD
GO
begin tran

GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[SurveyValidationProcs_view]'))
DROP VIEW [dbo].[SurveyValidationProcs_view]

GO

declare @constraint_name sysname, @sql nvarchar(max)

select @constraint_name = name 
from sys.default_constraints 
where parent_object_id = object_id('SurveyValidationProcs')
AND type = 'D'
AND parent_column_id = (
    select column_id 
    from sys.columns 
    where object_id = object_id('SurveyValidationProcs')
    and name = 'Active'
    )

set @sql = N'alter table SurveyValidationProcs drop constraint ' + @constraint_name
exec sp_executesql @sql
GO

ALTER TABLE [dbo].[SurveyValidationProcs]
	DROP Column Active 
 GO

 CREATE VIEW [dbo].[SurveyValidationProcs_view]      
AS      
	SELECT svp.SurveyValidationProcs_id, svp.ProcedureName, svp.intOrder, svpst.CAHPSType_ID, svpst.SubType_ID
	FROM SurveyValidationProcs svp
	LEFT JOIN SurveyValidationProcsBySurveyType svpst on (svpst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id)
	WHERE svpst.CAHPSType_Id is null
	UNION
	select svp.SurveyValidationProcs_id, svp.ProcedureName, svp.intOrder, svpst.CAHPSType_ID, svpst.SubType_ID
	from SurveyValidationProcsBySurveyType svpst
	INNER JOIN SurveyValidationProcs svp ON (svp.SurveyValidationProcs_id = svpst.SurveyValidationProcs_id)

GO

/*
INSERT New Proc INTO SurveyValidationProcs and SurveyValidationProcsBySurveyType
*/

DECLARE @SurveyValidationProcs_id int

SELECT @SurveyValidationProcs_id = SurveyValidationProcs_id
FROM [dbo].[SurveyValidationProcs]
where ProcedureName = 'SV_CAHPS_DQRules'

DELETE [QP_Prod].[dbo].[SurveyValidationProcsBySurveyType]
where SurveyValidationProcs_id = @SurveyValidationProcs_id

DELETE [dbo].[SurveyValidationProcs]
where SurveyValidationProcs_id = @SurveyValidationProcs_id

GO


ALTER PROCEDURE [dbo].[SV_CAHPS_AddrErrorDQ]
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
GO

if exists (select * from sys.procedures where name = 'SV_CAHPS_DQrules')
	drop procedure dbo.SV_CAHPS_DQrules

GO
commit tran
GO