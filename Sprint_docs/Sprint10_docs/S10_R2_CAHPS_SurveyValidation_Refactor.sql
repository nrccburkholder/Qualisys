/*
S10.R2	Change to TestPrints
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
go

ALTER TABLE [dbo].[SurveyValidationProcs]
	add bitActive bit NOT NULL DEFAULT(1)
 
 GO


ALTER VIEW [dbo].[SurveyValidationProcs_view]      
AS      
	SELECT svp.SurveyValidationProcs_id, svp.ProcedureName, svp.intOrder, svpst.CAHPSType_ID, svpst.SubType_ID
	FROM SurveyValidationProcs svp
	LEFT JOIN SurveyValidationProcsBySurveyType svpst on (svpst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id)
	WHERE svpst.CAHPSType_Id is null and svp.bitActive = 1
	UNION
	select svp.SurveyValidationProcs_id, svp.ProcedureName, svp.intOrder, svpst.CAHPSType_ID, svpst.SubType_ID
	from SurveyValidationProcsBySurveyType svpst
	INNER JOIN SurveyValidationProcs svp ON (svp.SurveyValidationProcs_id = svpst.SurveyValidationProcs_id)
	WHERE svp.bitActive = 1

GO


/*
INSERT New Proc INTO SurveyValidationProcs and SurveyValidationProcsBySurveyType
*/

declare @svpid int
declare @intOrder int

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


Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

SELECT @svpid = SurveyValidationProcs_id FROM SurveyValidationProcs WHERE ProcedureName = 'SV_CAHPS_DQRules'
IF @@ROWCOUNT = 0	
BEGIN
	INSERT INTO [dbo].[SurveyValidationProcs]([ProcedureName],[ValidMessage],[intOrder]) VALUES('SV_CAHPS_DQRules','Check DQ Rules',@intOrder)
	set @svpid=scope_identity()	
END
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HCAHPS)
INSERT INTO [dbo].[SurveyValidationProcsBySurveyType]([SurveyValidationProcs_id],[CAHPSType_ID])VALUES(@svpid,@HHCAHPS)
Select @intOrder = Max(intOrder) + 1 from SurveyValidationProcs

update [dbo].[SurveyValidationProcs]
	set bitActive = 0
where ProcedureName in (
'SV_CAHPS_HH_CAHPS_DQRules'
,'SV_CAHPS_H_CAHPS_DQRules'
,'SV_CAHPS_PCMH_CAHPS_DQRules'
)
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

DECLARE @ErrorValue1 as int
DECLARE @ErrorValue2 as int

-- Default values used for HCAHPS
SET @ErrorValue1 = 0
SET @ErrorValue2 = 1

IF @surveyType_id in (@HHCAHPS)
BEGIN
	SET @ErrorValue1 = 1
	SET @ErrorValue2 = 0
END

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
	SELECT @ErrorValue1,'Survey has DQ rule (AddrErr = "FO").'
ELSE
	INSERT INTO #M (Error, strMessage)
	SELECT @ErrorValue2,'Survey does not have DQ rule (AddrErr = "FO").'


SELECT * FROM #M

DROP TABLE #M
GO

if exists (select * from sys.procedures where name = 'SV_CAHPS_DQrules')
	drop procedure dbo.SV_CAHPS_DQrules
go

CREATE PROCEDURE [dbo].[SV_CAHPS_DQrules]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON


/*Get the Study_id for this Survey*/
declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id
IF @Study_id IS NULL
	RETURN

/*Get the surveytype_id*/
declare @surveyType_id int
SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
	RETURN

/*Get the Country_id from the QualPro_Params*/
DECLARE @Country_id INT
SELECT @Country_id=numParam_Value
FROM QualPro_Params
WHERE strParam_nm='Country'

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

  --Create a Temp table of the DQ rules for this survey type
create table #DefaultCriteriaStmt (DefaultCriteriaStmt_id int, strCriteriaStmt_nm char(8), strCriteriaString varchar(7000))
create table #DefaultCriteriaClause 
   (DefaultDQ_id int
   ,DefaultCriteriaClause_id int 
	, CriteriaPhrase_id int
	, strTable_nm varchar(20)
	, Table_id int
	, Field_id int
	, Field_nm varchar(100)
	, intOperator int
	, Operator_nm varchar(8)
	, strLowValue varchar(42)
	, strHighValue varchar(42)
	, bitFieldExistsInStudy bit
	, CriteriaClause_id int
	)

/* list all the DQ Rules for this surveytype/country */
if exists (	select * 
			from dbo.subtype st
			inner join dbo.surveysubtype sst on st.subtype_id=sst.subtype_id
			where st.bitRuleOverRide=1
			and sst.survey_id=@Survey_id)
	-- if any one of the survey's subtype's has bitOverride=1, only use that subtype's default DQ rules
	-- (BTW: there shouldn't be more than one subtype that has bitOverride=1 for any given survey_id. Config Mgr interface enforces this.)
	insert into #DefaultCriteriaStmt (DefaultCriteriaStmt_id,strCriteriaStmt_nm, strCriteriaString)
	select distinct dc.DefaultCriteriaStmt_id,strCriteriaStmt_nm,strCriteriaString
	from dbo.SurveyTypeDefaultCriteria dc
	inner join dbo.DefaultCriteriaStmt cs on dc.DefaultCriteriaStmt_id = cs.DefaultCriteriaStmt_id
	where dc.SurveyType_id=@SurveyType_ID
	and dc.country_id=@Country_id
	and dc.Subtype_id=(	select st.subtype_id
						from dbo.subtype st
						inner join dbo.surveysubtype sst on st.subtype_id=sst.subtype_id
						where st.bitRuleOverRide=1
						and sst.survey_id=@Survey_id)
else
	-- if none of the survey's subtype's has bitOveride=1, use all of the default DQ rules for the survey type and all the subtype(s)
	insert into #DefaultCriteriaStmt (DefaultCriteriaStmt_id,strCriteriaStmt_nm, strCriteriaString)
	select distinct dc.DefaultCriteriaStmt_id,strCriteriaStmt_nm,strCriteriaString
	from dbo.SurveyTypeDefaultCriteria dc
	inner join dbo.DefaultCriteriaStmt cs on dc.DefaultCriteriaStmt_id = cs.DefaultCriteriaStmt_id
	where dc.SurveyType_id=@SurveyType_ID
	and dc.country_id=@Country_id
	and (dc.Subtype_id=0
		or dc.subtype_id in (	select st.subtype_id 
								from dbo.subtype st
								inner join dbo.surveysubtype sst on st.subtype_id=sst.subtype_id
								where sst.survey_id=@Survey_id )
		)

/* process each rule, one at a time */
declare @DefaultDQ_id int, @Crit_nm char(8), @strCriteriaString varchar(7000), @Error smallint
select top 1 @DefaultDQ_id=DefaultCriteriaStmt_id, @Crit_nm=strCriteriaStmt_nm, @strCriteriaString = strCriteriaString from #DefaultCriteriaStmt
while @@rowcount>0
begin
	
		/* put all criteria clauses in a temp table. If one or more of them don't check out, we'll roll back the transaction and the DQ rule won't get applied */
		insert into #DefaultCriteriaClause (DefaultDQ_id, DefaultCriteriaClause_id, CriteriaPhrase_id, strTable_nm, Field_id, Field_nm, intOperator, Operator_nm, strLowValue, strHighValue, bitFieldExistsInStudy)
		select @DefaultDQ_id, DefaultCriteriaClause_id, CriteriaPhrase_id, strTable_nm, dcc.Field_id, mf.STRFIELD_NM, intOperator, op.strOperator, strLowValue, strHighValue, 0
		from dbo.DefaultCriteriaClause dcc
		inner join MetaField mf on dcc.Field_id = mf.Field_id
		inner join Operator op on dcc.intOperator = op.Operator_Num
		where DefaultCriteriaStmt_id=@DefaultDQ_id

		/* make sure the needed table exists. If it doesn't Table_id will remain NULL */
		update dcc
		set Table_id=mt.table_id
		from #DefaultCriteriaClause dcc
		inner join metatable mt on dcc.strTable_nm=mt.strTable_nm and mt.study_id=@study_id
		
		/* Make sure the needed field exists. If it doesn't, bitFieldExistsInStudy will remain 0 */
		update dcc
		set bitFieldExistsInStudy=1
		from #DefaultCriteriaClause dcc
		inner join metastructure ms on dcc.table_id=ms.table_id and dcc.field_id=ms.field_id

		SET @Error = -1 

		declare @DefaultCriteriaClause_id int, @CriteriaPhrase_id int, @Field_nm varchar(100), @Operator_nm varchar(8), @strLowValue varchar(42), @strHighValue varchar(42)
		select top 1 @DefaultCriteriaClause_id=DefaultCriteriaClause_id, @CriteriaPhrase_id = CriteriaPhrase_id, @Field_nm=Field_nm, @Operator_nm = Operator_nm, @strLowValue = strLowValue, @strHighValue = strHighValue from #DefaultCriteriaClause WHERE table_id is not null AND bitFieldExistsInStudy = 1
		while @@rowcount>0
		begin

			if @Operator_nm = 'IN'
			begin

				declare @inListCount int, @inListMin varchar(42), @inListMax varchar(42), @stdev float
				select @inListCount = count(*), @inListMin= min(strlistvalue), @inListMax = max(strlistvalue), @stdev = round(stdev(convert(int,strlistvalue)),6)
				from [dbo].[DefaultCriteriaInList] dcil
				WHERE dcil.DefaultCriteriaClause_id = @DefaultCriteriaClause_id

				IF EXISTS
				(
				 SELECT br.BUSINESSRULE_ID
				  FROM BusinessRule br
				  inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
				  inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
				  inner join CriteriaInList ci on cc.CriteriaClause_id = ci.CriteriaClause_id
				  inner join MetaField mf on cc.Field_id = mf.Field_id
				  inner join Operator op on cc.intOperator = op.Operator_Num
				  WHERE br.SURVEY_ID = @survey_id
						AND mf.strField_Nm = @Field_nm
						AND op.strOperator = @Operator_nm
				  GROUP BY br.BUSINESSRULE_ID
				  having count(*)=@inListCount and min(strListValue) = @inListMin and max(strListValue)= @inListMax and round(stdev(convert(int,strlistvalue)),6)= @stdev
				  -- Another combination of @inListCount integers with @inListMin as the min and @inListMax as the max would come up with a different STDEV
				) SET @Error = 0
				ELSE SET @Error = 1

			end
			else
			begin
				-- here, we check for non-IN operators
					if exists
					(SELECT BusinessRule_id
						FROM BusinessRule br
						inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
						inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
						inner join MetaField mf on cc.Field_id = mf.Field_id
						inner join Operator op on cc.intOperator = op.Operator_Num
						WHERE br.SURVEY_ID = @survey_id
						AND mf.strField_Nm = @Field_nm
						AND op.strOperator = @Operator_nm
						AND cc.strLowValue = @strLowValue
						AND ISNULL(cc.STRHIGHVALUE,'') = ISNULL(@strHighValue,'')
					) SET @Error = 0
					ELSE SET @Error = 1
			end

			delete from #DefaultCriteriaClause where DefaultCriteriaClause_id=@DefaultCriteriaClause_id
			select top 1 @DefaultCriteriaClause_id=DefaultCriteriaClause_id, @CriteriaPhrase_id = CriteriaPhrase_id, @Field_nm=Field_nm, @Operator_nm = Operator_nm, @strLowValue = strLowValue, @strHighValue = strHighValue from #DefaultCriteriaClause WHERE table_id is not null AND bitFieldExistsInStudy = 1
		end

		If @Error = 0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has valid ' +  LTRIM(RTRIM(@Crit_nm)) + ' rule ('+ @strCriteriaString + ').'
		ELSE If @Error = 1
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have valid ' + LTRIM(RTRIM(@Crit_nm)) + ' rule ('+ @strCriteriaString + ').'
	
	delete from #DefaultCriteriaClause 
	delete from #DefaultCriteriaStmt where DefaultCriteriaStmt_id=@DefaultDQ_id
	select top 1 @DefaultDQ_id=DefaultCriteriaStmt_id, @Crit_nm=strCriteriaStmt_nm, @strCriteriaString = strCriteriaString from #DefaultCriteriaStmt
end

drop table #DefaultCriteriaClause 
drop table #DefaultCriteriaStmt


SELECT * FROM #M

DROP TABLE #M

GO
commit tran