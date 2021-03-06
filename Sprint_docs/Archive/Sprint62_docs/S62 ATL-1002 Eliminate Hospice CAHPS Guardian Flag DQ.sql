/*

S62 ATL-1002 Eliminate Hospice CAHPS Guardian Flag DQ

As Corporate Compliance, we need to no longer DQ records based on the guardian flag value, so that we comply with an on-site visit action item.

Tim Butler

ALTER PROCEDURE [dbo].[SV_CAHPS_Hospice_CAHPS_DQRules]


*/

use QP_Prod
GO



if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'MetaField_Removed' 
					   AND sc.NAME = 'bitPII' )
BEGIN

			ALTER TABLE [dbo].[MetaField_Removed] 
				ADD [bitPII] bit NOT NULL CONSTRAINT [DF_bitPII]  DEFAULT ((0))
END
GO


IF NOT Exists (SELECT 1 FROM [dbo].[METAFIELD_Removed] where STRFIELD_NM =  'hsp_guardflg')
BEGIN
	INSERT INTO dbo.MetaField_Removed
	SELECT [FIELD_ID]
		  ,[STRFIELD_NM]
		  ,[STRFIELD_DSC]
		  ,[FIELDGROUP_ID]
		  ,[STRFIELDDATATYPE]
		  ,[INTFIELDLENGTH]
		  ,[STRFIELDEDITMASK]
		  ,[INTSPECIALFIELD_CD]
		  ,[STRFIELDSHORT_NM]
		  ,[BITSYSKEY]
		  ,[bitPhase1Field]
		  ,[intAddrCleanCode]
		  ,[intAddrCleanGroup]
		  ,[bitPII]
	  FROM [dbo].[METAFIELD]
	  where STRFIELD_NM =  'hsp_guardflg'
END
GO

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'METASTRUCTURE_Removed'))
BEGIN
	CREATE TABLE [dbo].[METASTRUCTURE_Removed](
		[TABLE_ID] [int] NOT NULL,
		[FIELD_ID] [int] NOT NULL,
		[BITKEYFIELD_FLG] [bit] NOT NULL,
		[BITUSERFIELD_FLG] [bit] NOT NULL,
		[BITMATCHFIELD_FLG] [bit] NOT NULL,
		[BITPOSTEDFIELD_FLG] [bit] NOT NULL,
		[bitPII] [bit] NULL,
		[bitAllowUS] [bit] NULL)
END

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'SurveyTypeDefaultCriteria_Removed'))
BEGIN
    CREATE TABLE [dbo].[SurveyTypeDefaultCriteria_Removed](
	[SurveyTypeDefaultCriteria] [int] NOT NULL,
	[SurveyType_id] [int] NULL,
	[Country_id] [int] NULL,
	[DefaultCriteriaStmt_id] [int] NULL
	) 
END

IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'DefaultCriteriaClause_Removed'))
BEGIN
    CREATE TABLE [dbo].[DefaultCriteriaClause_Removed](
	[DefaultCriteriaClause_id] [int] NOT NULL,
	[DefaultCriteriaStmt_id] [int] NULL,
	[CriteriaPhrase_id] [int] NULL,
	[strTable_nm] [varchar](20) NULL,
	[Field_id] [int] NULL,
	[intOperator] [int] NULL,
	[strLowValue] [varchar](42) NULL,
	[strHighValue] [varchar](42) NULL
	)
END


IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'DefaultCriteriaStmt_Removed'))
BEGIN
    CREATE TABLE [dbo].[DefaultCriteriaStmt_Removed](
	[DefaultCriteriaStmt_id] [int] NOT NULL,
	[strCriteriaStmt_nm] [char](8) NULL,
	[strCriteriaString] [varchar](7000) NULL,
	[BusRule_cd] [char](1) NULL
	)
END



IF (NOT EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'temp_DQ_GuarSurveys'))
BEGIN
    CREATE TABLE [dbo].[temp_DQ_GuarSurveys](
	[Survey_id] [int] NULL
	)
END

declare @dq_nm varchar(20) = 'DQ_Guar'

IF NOT Exists (SELECT 1 from dbo.SurveyTypeDefaultCriteria_Removed s
	 inner join DefaultCriteriaStmt d on s.DefaultCriteriaStmt_id = d.DefaultCriteriaStmt_id
	 where strCriteriaStmt_nm = @dq_nm)
 BEGIN
	 
	 INSERT INTO dbo.SurveyTypeDefaultCriteria_Removed
	 select s.* 
	 from SurveyTypeDefaultCriteria s
	 inner join DefaultCriteriaStmt d on s.DefaultCriteriaStmt_id = d.DefaultCriteriaStmt_id
	 where strCriteriaStmt_nm = @dq_nm
END


 IF NOT Exists (SELECT 1 FROM [dbo].[DefaultCriteriaClause_Removed] dcc
  inner join dbo.DefaultCriteriaStmt dcs on dcs.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
  where dcs.strCriteriaStmt_nm = @dq_nm)
BEGIN
	 INSERT INTO [dbo].[DefaultCriteriaClause_Removed]
	 SELECT dcc.*
	  FROM [dbo].[DefaultCriteriaClause] dcc
	  inner join dbo.DefaultCriteriaStmt dcs on dcs.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
	  where dcs.strCriteriaStmt_nm = @dq_nm
END


IF NOT Exists (SELECT 1 FROM [dbo].[DefaultCriteriaStmt_Removed]  where strCriteriaStmt_nm = @dq_nm)
BEGIN
	 INSERT INTO [dbo].[DefaultCriteriaStmt_Removed]
	 select * 
	 from DefaultCriteriaStmt
	 where strCriteriaStmt_nm = @dq_nm

END

IF NOT Exists (SELECT 1 FROM [dbo].[METASTRUCTURE_Removed] ms
				INNER JOIN [dbo].[METAFIELD] mf on mf.FIELD_ID = ms.Field_ID
				where mf.STRFIELD_NM =  'hsp_guardflg')
BEGIN
	INSERT INTO dbo.MetaStructure_Removed
	SELECT ms.*
	FROM [dbo].[METASTRUCTURE] ms
	INNER JOIN [dbo].[METAFIELD] mf on mf.FIELD_ID = ms.Field_ID
	where mf.STRFIELD_NM =  'hsp_guardflg'
END


 --select s.* 
 delete s
 from SurveyTypeDefaultCriteria s
 inner join DefaultCriteriaStmt d on s.DefaultCriteriaStmt_id = d.DefaultCriteriaStmt_id
 where strCriteriaStmt_nm = @dq_nm


--SELECT dcc.*
delete dcc
FROM [dbo].[DefaultCriteriaClause] dcc
inner join dbo.DefaultCriteriaStmt dcs on dcs.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
where dcs.strCriteriaStmt_nm = @dq_nm

--select * 
delete
from DefaultCriteriaStmt
where strCriteriaStmt_nm = @dq_nm


 GO

use QP_Prod

declare @hospiceId int
select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

declare @dq_nm varchar(20) = 'DQ_Guar'

SELECT distinct sd.SURVEY_ID, sd.STUDY_ID
into #Surveys
from Survey_DEF sd
inner join BusinessRule br on br.Survey_Id = sd.Survey_id
inner join CRITERIASTMT cs on br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
where SurveyType_id = @hospiceId
and br.BUSRULE_CD = 'Q'


/* process each survey, one at a time */
declare @survey_id int, @study_id int
select top 1 @survey_id = survey_id, @study_id = study_id from #Surveys
while @@rowcount>0
begin

	-- Remove DQ_Guar rule from existing surveys
	declare @criteriastmt_id int
	declare @businessrule_id int
	if exists (	select 1 
				from CriteriaStmt cs
				inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
				where cs.study_id=@study_id
				and cs.strCriteriaStmt_nm=@dq_nm
				and br.survey_id=@survey_id)
	begin
		print '"DQ_Guar" exists for study ' + convert(varchar,@study_id)+' survey '+convert(varchar,@survey_id)+'. removing...'

				select @businessrule_id = br.BUSINESSRULE_ID, @criteriastmt_id = cs.CRITERIASTMT_ID 
				from CriteriaStmt cs
				inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
				where cs.study_id=@study_id
				and cs.strCriteriaStmt_nm=@dq_nm
				and br.survey_id=@survey_id

				delete from BusinessRule
				--select * from BUSINESSRULE
				where BUSINESSRULE_ID = @businessrule_id

				delete from CRITERIASTMT
				--select * from CRITERIASTMT
				where CRITERIASTMT_ID = @criteriastmt_id

				delete from CRITERIACLAUSE
				--select * from CRITERIACLAUSE
				where CRITERIASTMT_ID = @criteriastmt_id

				if not exists (SELECT 1 from dbo.temp_DQ_GuarSurveys where Survey_id = @survey_id)
					INSERT INTO dbo.temp_DQ_GuarSurveys SELECT @survey_id
	end

	delete from #Surveys where survey_id=@survey_id and STUDY_ID = @study_id
	select top 1 @survey_id = survey_id, @study_id = study_id from #Surveys
end

select * from dbo.temp_DQ_GuarSurveys order by Survey_id

drop table #Surveys

GO


--select *
Delete ms
FROM [dbo].[METASTRUCTURE] ms
INNER JOIN [dbo].[METAFIELD] mf on mf.FIELD_ID = ms.Field_ID
where mf.STRFIELD_NM =  'hsp_guardflg'

 --SELECT *
 delete 
 FROM [QP_Prod].[dbo].[METAFIELD] 
 where STRFIELD_NM =  'hsp_guardflg'

 GO


 USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Hospice_CAHPS_DQRules]    Script Date: 12/9/2016 2:11:50 PM ******/
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

		----check for DQ_Guar Rule
		--If exists  (select BusinessRule_id
		-- from BUSINESSRULE br, CRITERIASTMT cs
		-- where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		-- and cs.STRCRITERIASTMT_NM = 'DQ_Guar'
		-- and br.SURVEY_ID = @Survey_id)

		--	INSERT INTO #M (Error, strMessage)
		--	SELECT 0,'Survey has DQ rule (HSP_GuardFlg = 1).'
		--ELSE
		-- INSERT INTO #M (Error, strMessage)
		-- SELECT 1,'Survey does not have DQ rule (HSP_GuardFlg = 1).'

SELECT * FROM #M

DROP TABLE #M

GO