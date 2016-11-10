/*

S62 ATL-1002 Eliminate Hospice CAHPS Guardian Flag DQ

As Corporate Compliance, we need to no longer DQ records based on the guardian flag value, so that we comply with an on-site visit action item.

Tim Butler


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
