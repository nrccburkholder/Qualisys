/*

S40_US10_OAS_Methodologies_update - Rollback.sql

10 OAS: New Survey Type
As an Implementation Associate, I want a new survey type w/ appropriate settings for OAS CAHPS, so that I can set up surveys compliantly.
Survey type, no subtypes, DQ rules, monthly sample periods, 3 std methodologies, add survey type to catalyst database 



Chris Burkholder

Task 2 - Update old scripts where we've done this before; make sure goes into Catalyst

ALTER PROCEDURE [dbo].[SV_CAHPS_ActiveMethodology]
ALTER PROCEDURE [dbo].[SV_CAHPS_RequiredPopulationFields]
ALTER PROCEDURE [dbo].[SV_CAHPS_RequiredEncounterFields]
ALTER PROCEDURE [dbo].[SV_CAHPS_SkipPatterns]
ALTER PROCEDURE [dbo].[SV_CAHPS_Householding]
ALTER PROCEDURE [dbo].[SV_CAHPS_ReportingDate]
ALTER PROCEDURE [dbo].[SV_CAHPS_SamplingAlgorithm]
ALTER PROCEDURE [dbo].[SV_CAHPS_FormQuestions]
ALTER PROCEDURE [dbo].[SV_CAHPS_EnglishOrSpanish]
ALTER PROCEDURE [dbo].[SV_CAHPS_HasDQRule]
CREATE PROCEDURE [dbo].[SV_CAHPS_SupplementalQuestionCount]
*/




use qp_prod
go

DECLARE @SurveyType_ID int

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = 'OAS CAHPS'

begin tran



declare @SMid int, @SMSid int
declare @StandardMethodology_nm varchar(50)
declare @MethodologyType varchar(30)

SET @StandardMethodology_nm = 'OAS Mixed Mail-Phone'
SET @MethodologyType = 'Mixed Mail-Phone'
																													
	select @SMid= StandardMethodologyId from StandardMethodology where strStandardMethodology_nm = @StandardMethodology_nm and MethodologyType = @MethodologyType	
	delete from StandardMethodologyBySurveyType where StandardMethodologyID = @SMid
	delete from StandardMailingStep where StandardMethodologyID = @SMid																													

delete from StandardMethodology where strStandardMethodology_nm = @StandardMethodology_nm and MethodologyType = @MethodologyType

SET @StandardMethodology_nm = 'OAS Mail Only'
SET @MethodologyType = 'Mail Only'
																													
	select @SMid= StandardMethodologyId from StandardMethodology where strStandardMethodology_nm = @StandardMethodology_nm and MethodologyType = @MethodologyType	
	delete from StandardMethodologyBySurveyType where StandardMethodologyID = @SMid
	delete from StandardMailingStep where StandardMethodologyID = @SMid																													

delete from StandardMethodology where strStandardMethodology_nm = @StandardMethodology_nm and MethodologyType = @MethodologyType


SET @StandardMethodology_nm = 'OAS Phone Only'
SET @MethodologyType = 'Phone Only'
																													
	select @SMid= StandardMethodologyId from StandardMethodology where strStandardMethodology_nm = @StandardMethodology_nm and MethodologyType = @MethodologyType	
	delete from StandardMethodologyBySurveyType where StandardMethodologyID = @SMid
	delete from StandardMailingStep where StandardMethodologyID = @SMid																													

delete from StandardMethodology where strStandardMethodology_nm = @StandardMethodology_nm and MethodologyType = @MethodologyType

--rollback tran	
--update standardmailingstep set ExpireInDays = 42, intIntervalDays = 0 where standardmailingstepid = 138


go



select *
from StandardMethodology where strStandardMethodology_nm like 'OAS%'

select *
from StandardMailingStep where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'OAS%'
)


select *
from StandardMethodologyBySurveyType where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'OAS%'
)

go


--select * from metafieldgroupdef select * from metafield

declare @OASId int

select @OASId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'OAS CAHPS'

delete from Metafield where strfield_NM = 'OAS_LocationID'
delete from Metafield where strfield_NM = 'OAS_LocationName'
delete from Metafield where strfield_NM = 'OAS_PatServed'
delete from Metafield where strfield_NM = 'OAS_VisitAge'
delete from Metafield where strfield_NM = 'HCPCSLvl2Cd'
delete from Metafield where strfield_NM = 'HCPCSLvl2Cd_2'
delete from Metafield where strfield_NM = 'HCPCSLvl2Cd_3'
delete from Metafield where strfield_NM = 'OAS_HE_Lang'
delete from Metafield where strfield_NM = 'OAS_HE_HowHelp'
delete from Metafield where strfield_NM = 'OAS_FacilityType'

delete from metafieldgroupdef where strfieldgroup_nm = 'OAS CAHPS'

GO

declare @OAScahpsId int

select @OAScahpsId = SurveyType_Id from SurveyType where SurveyType_dsc = 'OAS CAHPS'

--select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = 16
--select * from SurveyValidationProcs
/*
select * from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on  svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id 
where cahpstype_id = 16 and ProcedureName = 'SV_CAHPS_HasDQRule'
*/
--delete from SurveyValidationProcsBySurveyType where SurveyValidationProcsToSurveyType_id = 143

delete svp from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_SupplementalQuestionCount'
delete from SurveyValidationProcs where ProcedureName = 'SV_CAHPS_SupplementalQuestionCount'

delete svp from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_SampleUnit'
delete svp from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_ActiveMethodology'
delete svp from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_RequiredPopulationFields'
delete svp from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_RequiredEncounterFields'
delete svp from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_SkipPatterns'
delete svp from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_Householding'
delete svp from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_ReportingDate'
delete svp from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_SamplingAlgorithm'
delete svp from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_FormQuestions'
delete svp from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_EnglishOrSpanish'
delete svp from SurveyValidationProcs svp inner join SurveyValidationProcsBySurveyType svpbst on svp.surveyvalidationprocs_id = svpbst.surveyvalidationprocs_id where CAHPSType_id = @OAScahpsId and ProcedureName = 'SV_CAHPS_SupplementalQuestionCount'

--declare @OAScahpsId int
select @OAScahpsId = SurveyType_Id from SurveyType where SurveyType_dsc = 'OAS CAHPS'
declare @cpt1 int, @cpt2 int, @cpt3 int

select @cpt1 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and intoperator = 7 and CriteriaPhrase_id = 1

select @cpt2 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and intoperator = 7 and CriteriaPhrase_id = 2

select @cpt3 = defaultcriteriaclause_id from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = @OAScahpsId and intoperator = 7 and CriteriaPhrase_id = 3

delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt1 and strListValue = '16020'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt1 and strListValue = '16025'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt1 and strListValue = '16030'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt1 and strListValue = '29581'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt1 and strListValue = '36600'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt1 and strListValue = '36415'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt1 and strListValue = '36416'

delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = '16020'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = '16025'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = '16030'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = '29581'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = '36600'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = '36415'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt2 and strListValue = '36416'

delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = '16020'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = '16025'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = '16030'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = '29581'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = '36600'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = '36415'
delete from DefaultCriteriaInList where DefaultCriteriaClause_id = @cpt3 and strListValue = '36416'

--declare @OAScahpsId int
select @OAScahpsId = SurveyType_Id from SurveyType where SurveyType_dsc = 'OAS CAHPS'
declare @DCStmtId int, @FieldId int

--select * from surveytypedefaultcriteria select * from defaultcriteriastmt select * from DefaultCriteriaClause select * from DefaultCriteriaInList
----------------------
select @DCStmtId = DefaultCriteriaStmt_id from DefaultCriteriaStmt where strCriteriaStmt_nm = 'DQ_MDFA' and strCriteriaString = '(POPULATIONAddrErr=''FO'')'
delete from SurveyTypeDefaultCriteria 
				where SurveyType_id = @OAScahpsId and Country_id = 1 and DefaultCriteriaStmt_id = @DCStmtId
----------------------
select @DCStmtId = DefaultCriteriaStmt_Id from DefaultCriteriaStmt 
				where strCriteriaStmt_nm = 'DQ_Age' and strCriteriaString = '(ENCOUNTEROAS_VisitAge < 18)' and BusRule_cd = 'Q'

delete from SurveyTypeDefaultCriteria 
				where SurveyType_id = @OAScahpsId and Country_id = 1 and DefaultCriteriaStmt_id = @DCStmtId

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'OAS_VisitAge'
delete from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and CriteriaPhrase_id = 1 and Field_id = @FieldId

delete from DefaultCriteriaStmt 
				where (strCriteriaStmt_nm = 'DQ_Age' and strCriteriaString = '(ENCOUNTEROAS_VisitAge < 18)' and BusRule_cd = 'Q')
----------------------

select @DCStmtId = DefaultCriteriaStmt_Id from DefaultCriteriaStmt 
				where strCriteriaStmt_nm = 'DQ_SrgCd' and strCriteriaString = 'CPT4 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'') OR CPT4_2 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'') OR CPT4_3 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'')' and BusRule_cd = 'Q'
select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'CPT4'
delete from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and CriteriaPhrase_id = 1

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'CPT4_2'
delete from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and CriteriaPhrase_id = 2

select @Fieldid = Field_id from MetaField where STRFIELD_NM = 'CPT4_3'
delete from DefaultCriteriaClause where DefaultCriteriaStmt_id = @DCStmtId and CriteriaPhrase_id = 3

delete from SurveyTypeDefaultCriteria 
				where (SurveyType_id = @OAScahpsId and Country_id = 1 and DefaultCriteriaStmt_id = @DCStmtId)
delete from DefaultCriteriaStmt 
				where strCriteriaStmt_nm = 'DQ_SrgCd' and strCriteriaString = 'CPT4 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'') OR CPT4_2 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'') OR CPT4_3 in (''16020'', ''16025'', ''16030'', ''29581'', ''36600'', ''36415'', ''36416'')' and BusRule_cd = 'Q'
----------------------

--select * from SurveyTypeDefaultCriteria dc inner join DefaultCriteriaStmt cs on dc.DefaultCriteriaStmt_id = cs.DefaultCriteriaStmt_id where SurveyType_id = 16
--update surveytypedefaultcriteria set DefaultCriteriaStmt_id = 49 where SurveyType_id = 16 and DefaultCriteriaStmt_id = 64
--delete from defaultcriteriaclause where defaultcriteriaclause_id in (65,69)

/*
select * from defaultcriteriainlist dcil inner join defaultcriteriaclause dcc on dcil.DefaultCriteriaClause_id = dcc.DefaultCriteriaClause_id
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = 16

select * from defaultcriteriaclause dcc 
inner join defaultcriteriastmt dcis on dcis.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
inner join surveytypedefaultcriteria stdc on stdc.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where surveytype_id = 16
and intoperator = 7
*/


go

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_ActiveMethodology]    Script Date: 1/20/2016 12:31:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SV_CAHPS_ActiveMethodology]
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
SELECT @CGCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'CGCAHPS'

declare @HCAHPS int
SELECT @HCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'HCAHPS IP'

declare @HHCAHPS int
SELECT @HHCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'Home Health CAHPS'

declare @ACOCAHPS int
SELECT @ACOCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'ACOCAHPS'

declare @ICHCAHPS int
SELECT @ICHCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'ICHCAHPS'

declare @hospiceCAHPS int
SELECT @hospiceCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

declare @PCMHSubType int
SELECT @PCMHSubType = 9

declare @CIHI int
select @CIHI = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

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

IF @subtype_id is null
	SET @subtype_id = 0

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Check the active methodology  (ALL CAHPS)
CREATE TABLE #ActiveMethodology (standardmethodologyid INT, bitExpired bit)

INSERT INTO #ActiveMethodology
SELECT mm.StandardMethodologyId, smst.bitExpired
FROM MailingMethodology mm (NOLOCK)
INNER JOIN StandardMethodology sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
INNER JOIN StandardMethodologyBySurveyType smst ON smst.StandardMethodologyID=sm.StandardMethodologyID
WHERE mm.Survey_id=@Survey_id
AND mm.bitActiveMethodology=1
and smst.SurveyType_id = @surveyType_id

IF @@ROWCOUNT<>1
 INSERT INTO #M (Error, strMessage)
 SELECT 1,'Survey must have exactly one active methodology.'
ELSE
BEGIN

	 IF EXISTS(SELECT * FROM #ActiveMethodology WHERE standardmethodologyid = 5 and bitExpired = 0) -- 5 is custom methodology
	  INSERT INTO #M (Error, strMessage)
	  SELECT 2,'Survey uses a custom methodology.'         -- a warning

	 ELSE IF EXISTS(SELECT * FROM #ActiveMethodology WHERE bitExpired = 1) -- 
	  INSERT INTO #M (Error, strMessage)
	  SELECT 1,'Survey uses an expired methodology.'         -- an error

	 ELSE IF EXISTS(SELECT * FROM #ActiveMethodology
	   WHERE standardmethodologyid in (select StandardMethodologyID
		 from StandardMethodologyBySurveyType where SurveyType_id = @surveyType_id and SubType_ID = @subtype_id
		)
	   )
	  INSERT INTO #M (Error, strMessage)
	  SELECT 0,'Survey uses a standard ' + @SurveyTypeDescription + ' methodology.'

	 ELSE
	  INSERT INTO #M (Error, strMessage)
	  SELECT 1,'Survey does not use a standard ' + @SurveyTypeDescription + ' methodology.'   -- a warning     

END

DROP TABLE #ActiveMethodology

SELECT * FROM #M

DROP TABLE #M
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_RequiredPopulationFields]    Script Date: 1/20/2016 12:31:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SV_CAHPS_RequiredPopulationFields]
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

--Make sure the required fields are a part of the study (Population Fields)
INSERT INTO #M (Error, strMessage)
SELECT 1,a.strField_nm+' is not a Population field in the data structure.'
FROM (SELECT Field_id, strField_nm
		FROM MetaField
		WHERE strField_nm IN (SELECT [ColumnName] 
							FROM SurveyValidationFields
							WHERE SurveyType_Id = @surveyType_id
							AND TableName = 'POPULATION'
							AND bitActive = 1)) a
LEFT JOIN ( SELECT strField_nm 
			FROM MetaData_View m, Survey_def sd
			WHERE sd.Survey_id=@Survey_id
			AND sd.Study_id=m.Study_id
			AND m.strTable_nm = 'POPULATION') b
ON a.strField_nm=b.strField_nm
WHERE b.strField_nm IS NULL

IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'All Population ' + @SurveyTypeDescription + ' fields are in the data structure'


SELECT * FROM #M

DROP TABLE #M

GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_RequiredEncounterFields]    Script Date: 1/20/2016 12:32:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SV_CAHPS_RequiredEncounterFields]
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


--Make sure required fields are a part of the study (Encounter Fields)
	INSERT INTO #M (Error, strMessage)
	SELECT 1,a.strField_nm+' is not an Encounter field in the data structure.'
	FROM (SELECT Field_id, strField_nm
		  FROM MetaField
		  WHERE strField_nm IN (SELECT [ColumnName] 
								FROM SurveyValidationFields
								WHERE SurveyType_Id = @surveyType_id
								AND TableName = 'ENCOUNTER'
								AND bitActive = 1)) a
		  LEFT JOIN (SELECT strField_nm FROM MetaData_View m, Survey_def sd
					 WHERE sd.Survey_id=@Survey_id
					 AND sd.Study_id=m.Study_id
	   AND m.strTable_nm = 'ENCOUNTER') b
	ON a.strField_nm=b.strField_nm
	WHERE b.strField_nm IS NULL
	IF @@ROWCOUNT=0
	INSERT INTO #M (Error, strMessage)
	SELECT 0,'All Encounter ' + @SurveyTypeDescription + ' fields are in the data structure'

SELECT * FROM #M

DROP TABLE #M


GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SkipPatterns]    Script Date: 1/20/2016 12:33:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SV_CAHPS_SkipPatterns]
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

	--Make sure skip patterns are enforced.
	INSERT INTO #M (Error, strMessage)
	SELECT 1,'Skip Patterns are not enforced.'
	FROM Survey_def
	WHERE Survey_id=@Survey_id
	AND bitEnforceSkip=0
	IF @@ROWCOUNT=0
	INSERT INTO #M (Error, strMessage)
	SELECT 0,'Skip Patterns are enforced'

SELECT * FROM #M

DROP TABLE #M

GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Householding]    Script Date: 1/20/2016 12:33:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SV_CAHPS_Householding]
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

declare @PCMHSubType int
SET @PCMHSubType = 9

declare @hospiceCAHPS int
select @hospiceCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

declare @pqrsCAHPS int
select @pqrsCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'PQRS CAHPS'

declare @CIHI int
select @CIHI = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

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

IF @surveyType_id in (@HCAHPS) or (@surveyType_id in (@CGCAHPS) and @subtype_id = @PCMHSubType)
	BEGIN
		-- Check for Householding
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Householding is not defined.'
		FROM Survey_def sd LEFT JOIN HouseHoldRule hhr
		ON sd.Survey_id=hhr.Survey_id
		WHERE sd.Survey_id=@Survey_id
		AND hhr.Survey_id IS NULL

		--Check to make sure Addr, Addr2, City, St, Zip5 are householding columns
		INSERT INTO #M (Error, strMessage)
		SELECT 1,strField_nm+' is not a householding column.'
		FROM (Select strField_nm, Field_id FROM MetaField WHERE strField_nm IN ('Addr','Addr2','City','ST','Zip5')) a
		  LEFT JOIN HouseHoldRule hhr
		ON a.Field_id=hhr.Field_id
		AND hhr.Survey_id=@Survey_id
		WHERE hhr.Field_id IS NULL

END

IF @surveyType_id in (@ACOCAHPS, @ICHCAHPS, @hospiceCAHPS, @CIHI, @pqrsCAHPS)
	BEGIN

		-- Check for Householding
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Householding is defined and should not be.'
		FROM HouseHoldRule hhr
		WHERE hhr.Survey_id=@Survey_id
END

SELECT * FROM #M

DROP TABLE #M




GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_ReportingDate]    Script Date: 1/20/2016 12:33:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SV_CAHPS_ReportingDate]
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

declare @hospiceCAHPS int
select @hospiceCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

declare @pqrsCAHPS int
select @pqrsCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'PQRS CAHPS'

declare @CIHI int
select @CIHI = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

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

IF @surveyType_id in (@ACOCAHPS)
	BEGIN
		--Make sure the reporting date is ACO_FieldDate                                      
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ACO_FieldDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ACO_FieldDate from the Encounter table.'
			FROM Survey_def sd, MetaTable mt
		 WHERE sd.sampleEncounterTable_id=mt.Table_id
			  AND  sd.Survey_id=@Survey_id
			  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'ACO_FieldDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to ACO_FieldDate.'
	END

	IF @surveyType_id in (@ICHCAHPS)
	BEGIN
		--Make sure the reporting date is ICH_FieldDate                                      
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ICH_FieldDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ICH_FieldDate from the Encounter table.'
				 FROM Survey_def sd, MetaTable mt
				 WHERE sd.sampleEncounterTable_id=mt.Table_id
					  AND  sd.Survey_id=@Survey_id
					  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'ICH_FieldDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to ICH_FieldDate.'
	END

	IF @surveyType_id in (@hospiceCAHPS, @pqrsCAHPS)
	BEGIN
		--Make sure the reporting date is ICH_FieldDate                                      
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ServiceDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ServiceDate from the Encounter table.'
				 FROM Survey_def sd, MetaTable mt
				 WHERE sd.sampleEncounterTable_id=mt.Table_id
					  AND  sd.Survey_id=@Survey_id
					  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'ServiceDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to ServiceDate.'
	END

	IF @surveyType_id in (@CIHI)
	BEGIN
		--Make sure the reporting date is DischargeDate                                     
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be DischargeDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be DischargeDate from the Encounter table.'
				 FROM Survey_def sd, MetaTable mt
				 WHERE sd.sampleEncounterTable_id=mt.Table_id
					  AND  sd.Survey_id=@Survey_id
					  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'DischargeDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to DischargeDate.'
	END

SELECT * FROM #M

DROP TABLE #M




GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SamplingAlgorithm]    Script Date: 1/20/2016 12:34:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SV_CAHPS_SamplingAlgorithm]
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

--What is the sampling algorithm
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Your sampling algorithm is not StaticPlus.'
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND SamplingAlgorithmID<>3

SELECT * FROM #M

DROP TABLE #M

GO


-------------------------------------------------------------
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_FormQuestions]    Script Date: 1/20/2016 12:34:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SV_CAHPS_FormQuestions]
    @Survey_id INT
AS
/*
	8/28/2014 -- CJB Introduced into "not mapped to sampleunit" where clause criteria to prevent errors about phone section questions if
				no phone maling step is present, and about mail section questions if no 1st survey mailing step is present, 
				and about dummy section questions
	02/25/2015 -- TSB:  modified the select into #CAHPS_SurveyTypeQuestionMappings to only include Questions whose datEncounterEnd_dt is 
				greater than today's date. This is related to S19 US19 which deactivated five question cores and added a new one.

	04/30/2015 -- TSB: modified CAHPS Type variables to come from SELECT from SurveyType to ensure Id consistency.  Changed @PCHMSubType to read from
				SubType table with name "PCMH Distinction".  S24 US13.1
*/

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

declare @CGCAHPS int
SELECT  @CGCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'

declare @HCAHPS int
SELECT  @HCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'HCAHPS IP'

declare @HHCAHPS int
SELECT  @HHCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'Home Health CAHPS'

declare @ACOCAHPS int
SELECT  @ACOCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'ACOCAHPS'

declare @ICHCAHPS int
SELECT  @ICHCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'ICHCAHPS'

declare @hospiceCAHPS int
SELECT @hospiceCAHPS = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'Hospice CAHPS'

declare @PCMHSubType int
SELECT @PCMHSubType = [Subtype_id]
FROM [dbo].[Subtype]
where [Subtype_nm] = 'PCMH Distinction'


declare @CIHI int
select @CIHI = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

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

DECLARE @questionnaireType_id int

-- get any associated subtype_id that is has questionnaire category type
select  @questionnaireType_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 2

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Make sure all of the CAHPS questions are on the form and in the correct location.
	CREATE TABLE #CurrentForm (
		Order_id INT IDENTITY(1,1),
		QstnCore INT,
		Section_id INT,
		Subsection INT,
		Item INT
	)

	--Get the questions currently on the form
	INSERT INTO #CurrentForm (QstnCore, Section_id, Subsection, Item)
	SELECT QstnCore, Section_id, Subsection, Item
	FROM Sel_Qstns
	WHERE Survey_id=@Survey_id
	  AND SubType in (1,4)
	  AND Language=1
	  AND (Height>0 OR Height IS NULL)
	ORDER BY Section_id, Subsection, Item

	--Check for expanded questions
	--If they exist on survey, then pull question list that includes expanded questions (bitExpanded = 1)
	declare @bitExpanded int

	CREATE TABLE #CAHPS_SurveyTypeQuestionMappings(
	[SurveyType_id] [int] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[intOrder] [int] NULL,
	[bitFirstOnForm] [bit] NULL,
	[SubType_id] [INT] NOT NULL)

	IF @surveyType_id in (@HCAHPS)
	BEGIN

		select @bitExpanded = isnull((select top 1 1 from #currentform where qstncore in (46863,46864,46865,46866,46867)),0) 

	--If active sample period is after 1/1/2013, then the survey should be using expanded questions (bitExpanded = 1)
	--**************************************************
	--** Code from QCL_SelectActivePeriodbySurveyId
	--**************************************************
		create table #periods (perioddef_id int, activeperiod bit)

		--Get a list of all periods for this survey
		INSERT INTO #periods (periodDef_id)
		SELECT periodDef_id
		FROM perioddef
		WHERE survey_id=@survey_id

		--Get a list of all periods that have not completed sampling
		SELECT distinct pd.PeriodDef_id
		INTO #temp
		FROM perioddef p, perioddates pd
		WHERE p.perioddef_id=pd.perioddef_id AND
				survey_id=@survey_id AND
	  			datsampleCREATE_dt is null

		--Find the active Period.  It is either a period that hasn't completed sampling
		--or a period that hasn't started but has the most recent first scheduled date
		--If no unfinished periods exist, set active period to the period with the most
		--recently completed sample

		IF EXISTS (SELECT top 1 *
					FROM #temp)
		BEGIN

			DECLARE @UnfinishedPeriod int

			SELECT @UnfinishedPeriod=pd.perioddef_id
			FROM perioddates pd, #temp t
			WHERE pd.perioddef_id=t.perioddef_id AND
		  			pd.samplenumber=1 AND
					pd.datsampleCREATE_dt is not null

			IF @UnfinishedPeriod is not null
			BEGIN
				--There is a period that is partially finished, so set it to be active
				UPDATE #periods
				SET ActivePeriod=1
				WHERE perioddef_id = @UnfinishedPeriod
			END
			ELSE
			BEGIN
				--There is no period that is partially finished, so set the unstarted period
				--with the earliest scheduled sample date to be active
				UPDATE #periods
				SET ActivePeriod=1
				WHERE perioddef_id =
					(SELECT top 1 pd.perioddef_id
					 FROM perioddates pd, #temp t
					 WHERE pd.perioddef_id=t.perioddef_id AND
				  			pd.samplenumber=1
					 ORDER BY datscheduledsample_dt)
			END
		END
		ELSE
		BEGIN
			--No unfinished periods exist, so we will set the active to be the most recently
			--finished
			UPDATE #periods
			SET ActivePeriod=1
			WHERE perioddef_id =
				(SELECT top 1 p.perioddef_id
				 FROM perioddates pd, perioddef p
				 WHERE p.survey_id=@survey_id AND
						pd.perioddef_id=p.perioddef_id
				 GROUP BY p.perioddef_id
				 ORDER BY Max(datsampleCREATE_dt) desc)
		END

		IF @surveyType_id in (@HCAHPS)
		BEGIN
			if (select datExpectedEncStart from perioddef where perioddef_id = (select top 1 perioddef_id from #periods where activeperiod = 1 order by 1 desc)) >= '1/1/2013'
				select @bitExpanded = 1 ---(HCAHPS specific)
		END

		drop table #periods
		drop table #temp

		--Create subset SurveyTypeQuestionMappings looking at only surveyType
		INSERT INTO #CAHPS_SurveyTypeQuestionMappings
		Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
		from SurveyTypeQuestionMappings
		where SurveyType_id = @surveyType_id 
		and bitExpanded = @bitExpanded
		and [datEncounterEnd_dt] >= GETDATE()

	END
	ELSE
	BEGIN

		IF @questionnaireType_id is null
		BEGIN

			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id
			and [datEncounterEnd_dt] >= GETDATE()

		END
		ELSE
		BEGIN
			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id
			and SubType_ID = @questionnaireType_id
			and [datEncounterEnd_dt] >= GETDATE()

		END

	END

	--Look for questions missing from the form.
/*	IF @surveyType_id IN (@ACOCAHPS)
	BEGIN

		DECLARE @cnt50715 INT
		DECLARE @cnt50255 INT

		SELECT
		 @cnt50715 = SUM( CASE s.QstnCore WHEN 50715 THEN 1 ELSE 0 END),
		 @cnt50255 = SUM( CASE s.QstnCore WHEN 50255 THEN 1 ELSE 0 END)
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		   AND t.QstnCore IS NOT NULL

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		  AND t.QstnCore IS NULL and s.QstnCore NOT IN (50715,50255)

	END
*/
	IF @surveyType_id IN (@HCAHPS)
	BEGIN

		DECLARE @cnt43350 INT
		DECLARE @cnt50860 INT
		SELECT
		 @cnt43350 = SUM( CASE s.QstnCore WHEN 43350 THEN 1 ELSE 0 END),
		 @cnt50860 = SUM( CASE s.QstnCore WHEN 50860 THEN 1 ELSE 0 END)
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		   AND t.QstnCore IS NOT NULL

		IF @cnt43350 = 0 AND @cnt50860 = 0
		BEGIN
		 INSERT INTO #M VALUES (1, 'QstnCore 43350 and 50860 are both missing.  You must have either 43350 or 50860, but not both.')
		END
		IF @cnt43350 > 0 AND @cnt50860 > 0
		BEGIN
		 INSERT INTO #M VALUES (1, 'QstnCore 43350 and 50860 are both assigned.  You must have either 43350 or 50860, but not both.')
		END

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		AND t.QstnCore IS NULL and s.QstnCore NOT IN (43350,50860)

	END

	IF (@surveyType_id = @HHCAHPS) OR (@SurveyType_id = @hospiceCAHPS) OR (@SurveyType_id = @CIHI)
	BEGIN

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		  AND t.QstnCore IS NULL
	END

	--OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
	CREATE TABLE #OrderCheck(
		OverAllOrder INT IDENTITY(1,1),
		QstnCore INT,
		TemplateOrder INT,
		FormOrder INT,
		OrderDiff INT
	)

	IF (@surveyType_id in (@CGCAHPS) AND @subtype_id = @PCMHSubType) OR (@SurveyType_id = @ACOCAHPS)
	BEGIN

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		and s.SubType_id = @questionnaireType_id
		AND t.QstnCore IS NULL

		--Look for questions that are out of order.
		--First the questions that have to be at the beginning of the form.
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		AND s.intOrder=t.Order_id
		AND s.SurveyType_id= @surveyType_id
		and s.SubType_id = @questionnaireType_id
		WHERE bitFirstOnForm=1
		AND t.QstnCore IS NULL

		--Now the questions that are at the end of the form.
		INSERT INTO #OrderCheck 
		SELECT qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
		from #CAHPS_SurveyTypeQuestionMappings qm 
		INNER JOIN #CurrentForm t ON qm.SurveyType_id = @surveyType_id
		WHERE qm.SubType_id = @questionnaireType_id
		AND bitFirstOnForm=0
		AND qm.QstnCore=t.QstnCore
	END
	ELSE
	BEGIN
		--Look for questions that are out of order.
		--First the questions that have to be at the beginning of the form.
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		AND s.intOrder=t.Order_id
		AND s.SurveyType_id= @surveyType_id
		WHERE bitFirstOnForm=1
		AND t.QstnCore IS NULL

		--Now the questions that are at the end of the form.
		INSERT INTO #OrderCheck
		SELECT qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff

		from #CAHPS_SurveyTypeQuestionMappings qm, #CurrentForm t
		WHERE qm.SurveyType_id = @surveyType_id
		AND bitFirstOnForm=0
		AND qm.QstnCore=t.QstnCore
	END


	DECLARE @OrderDifference INT

	SELECT @OrderDifference=OrderDiff
	FROM #OrderCheck
	WHERE OverAllOrder=1

	INSERT INTO #M (Error, strMessage)
	SELECT 1,'QstnCore '+LTRIM(STR(QstnCore))+' is out of order on the form.'
	FROM #OrderCheck
	WHERE OrderDiff<>@OrderDifference

	DROP TABLE #OrderCheck
	
	DROP TABLE #CurrentForm

	IF (SELECT COUNT(*) FROM #M WHERE strMessage LIKE '%QstnCore%')=0
	BEGIN
	 INSERT INTO #M (Error, strMessage)
	 SELECT 0,'All ' + @SurveyTypeDescription + ' Questions are on the form in the correct order.'

	 --IF all cores or on the survey, then check that the questions are mapped
	 --in a manner that ensures someone sampled at the units will get all of them
	 SELECT sampleunit_id
	 into #CAHPSUnits
	 FROM SampleUnit su, SamplePlan sp
	 WHERE sp.Survey_id=@Survey_id
	 AND sp.SamplePlan_id=su.SamplePlan_id
	 AND CAHPSType_id = @surveyType_id

	 DECLARE @sampleunit_id int

	 SELECT TOP 1 @sampleunit_id=sampleunit_id
	 FROM #CAHPSUnits

	 WHILE @@rowcount>0
	 BEGIN

		INSERT INTO #M (Error, strMessage)
		 SELECT 1,'QstnCore '+LTRIM(STR(a.QSTNCORE))+' is not mapped to Sampleunit ' + convert(varchar,@sampleunit_id) +' or one of its ancestor units.'
		 from
		 (
		  SELECT stqm.QstnCore, intOrder
		  FROM
		  (
		   SELECT sq.Qstncore
		   FROM SAMPLEUNITTREEINDEX si JOIN sampleunitsection su
			ON si.sampleunit_id=@sampleunit_id
			 AND si.ancestorunit_id=su.sampleunit_id
			JOIN sel_qstns sq
			ON sq.Survey_id=@Survey_id
			 AND SubType in (1,4)
			 AND Language=1
			 AND (Height>0 OR Height IS NULL)
			 AND su.selqstnssection=sq.section_id
			 AND sq.survey_id=su.selqstnssurvey_id
		   union
		   SELECT sq.Qstncore
		   FROM sampleunitsection su JOIN sel_qstns sq
			ON su.sampleunit_id=@sampleunit_id
			 AND sq.Survey_id=@Survey_id
			 AND SubType in (1,4)
			 AND Language=1
			 AND (Height>0 OR Height IS NULL)
			 AND su.selqstnssection=sq.section_id
			 AND sq.survey_id=su.selqstnssurvey_id
		  ) as Q  RIGHT JOIN #CAHPS_SurveyTypeQuestionMappings stqm
		  ON Q.QstnCore=stqm.QstnCore
		  WHERE stqm.SurveyType_id=@surveyType_id AND Q.QstnCore IS NULL
		  AND (not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%phone%') 
			OR exists (select 1 from mailingstepmethod msm inner join mailingstep ms on ms.MailingStepMethod_id = msm.MailingStepMethod_id 
					where survey_id = @survey_id and msm.mailingstepmethod_nm = 'Phone'))
		  AND (not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%mail%') 
			OR exists (select 1 from mailingstepmethod msm inner join mailingstep ms on ms.MailingStepMethod_id = msm.MailingStepMethod_id 
					where survey_id = @survey_id and msm.mailingstepmethod_nm = 'Mail'))
		  AND not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%dummy%') 
		 ) AS a
		 LEFT JOIN AlternateQuestionMappings AS b ON a.QstnCore=b.QstnCore where b.QstnCore is null

		  IF @@ROWCOUNT=0
		   INSERT INTO #M (Error, strMessage)
		   SELECT 0,'All Questions are mapped properly for Sampleunit ' + convert(varchar,@sampleunit_id)

		  DELETE
		  FROM #CAHPSUnits
		  WHERE sampleunit_Id=@sampleunit_id

		  SELECT TOP 1 @sampleunit_id=sampleunit_id
		  FROM #CAHPSUnits

	 END

	 DROP TABLE #CAHPSUnits
	 

	END
	--End of Question checking

	DROP TABLE #CAHPS_SurveyTypeQuestionMappings

ENDOFPROC:

SELECT * FROM #M

DROP TABLE #M


GO


-------------------------------------------------------------
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_EnglishOrSpanish]    Script Date: 1/20/2016 12:34:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SV_CAHPS_EnglishOrSpanish]
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
/*
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
*/
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

--check to make sure only english or hcahps spanish is used on HHACAHPS survey
		INSERT INTO #M (Error, strMessage)
		SELECT 1, l.Language + ' is not a valid Language for this CAHPS survey'
		FROM Languages l, SEL_QSTNS sq
		WHERE l.LangID = sq.LANGUAGE and
		  sq.SURVEY_ID = @Survey_id and
		  l.LangID not in (1,19)

SELECT * FROM #M

DROP TABLE #M


GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_CAHPS_HasDQRule]    Script Date: 1/20/2016 12:35:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SV_CAHPS_HasDQRule]
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

	IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br
					 WHERE br.Survey_id = @Survey_id
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey has a DQ or other Business Rule and should not.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey does not have DQ rule.'

SELECT * FROM #M

DROP TABLE #M

GO



/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SupplementalQuestionCount]    Script Date: 1/13/2016 4:23:52 PM ******/
IF OBJECT_ID('SV_CAHPS_SupplementalQuestionCount', 'P') IS NOT NULL
DROP PROCEDURE [dbo].[SV_CAHPS_SupplementalQuestionCount]
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @SurveyType_ID int
select @SurveyType_ID = SurveyType_ID from SurveyType where SurveyType_dsc = 'OAS CAHPS'

--select * from surveyvalidationfields where surveytype_id = 16

delete from SurveyValidationFields where ColumnName = 'OAS_HE_HowHelp' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'OAS_HE_Lang' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'OAS_LocationID' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'OAS_LocationName' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'OAS_PatServed' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'OAS_FacilityType' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'HCPCSLvl2Cd' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'HCPCSLvl2Cd_2' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'HCPCSLvl2Cd_3' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'CPT4' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'CPT4_2' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'CPT4_3' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'FacilityName' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'CCN' and SurveyType_id = @SurveyType_ID
delete from SurveyValidationFields where ColumnName = 'ServiceDate' and SurveyType_id = @SurveyType_ID

GO

--select * from SurveyTypeQuestionMappings where surveytype_id in (13,16) order by surveytype_id,intorder

DECLARE @SurveyType_ID int
select @SurveyType_ID = SurveyType_ID from SurveyType where SurveyType_dsc = 'OAS CAHPS'

delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54086
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54087
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54088
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54089
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54090
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54091
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54092
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54093
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54094
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54095
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54096
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54097
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54098
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54099
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54100
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54101
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54102
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54103
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54104
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54105
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54106
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54107
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54108
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54109
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54110
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54111
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54112
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54113
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54114
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54115
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54116
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54117
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54181
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54182
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54183
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54118
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54119
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54120
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54121
delete from SurveyTypeQuestionMappings where SurveyType_id = @SurveyType_id and QstnCore = 54122


--rollback tran	
commit tran


GO
