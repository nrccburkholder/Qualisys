/*

ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

S62 ATL-1002 Eliminate Hospice CAHPS Guardian Flag DQ

As Corporate Compliance, we need to no longer DQ records based on the guardian flag value, so that we comply with an on-site visit action item.

Tim Butler


*/

use QP_Prod
GO


IF NOT Exists (SELECT 1 FROM [dbo].[METAFIELD] where STRFIELD_NM =  'hsp_guardflg')
BEGIN

	SET IDENTITY_INSERT dbo.MetaField ON

	 INSERT INTO dbo.MetaField ([FIELD_ID]
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
		  ,[bitPII])
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
	  FROM [dbo].[METAFIELD_Removed]
	  where STRFIELD_NM =  'hsp_guardflg'

	  SET IDENTITY_INSERT dbo.MetaField OFF
END


IF NOT Exists (SELECT 1 FROM [dbo].[METASTRUCTURE] ms
				INNER JOIN [dbo].[METAFIELD] mf on mf.FIELD_ID = ms.Field_ID
				where mf.STRFIELD_NM =  'hsp_guardflg')
BEGIN


	INSERT INTO dbo.MetaStructure ([TABLE_ID]
      ,[FIELD_ID]
      ,[BITKEYFIELD_FLG]
      ,[BITUSERFIELD_FLG]
      ,[BITMATCHFIELD_FLG]
      ,[BITPOSTEDFIELD_FLG]
      ,[bitPII]
      ,[bitAllowUS])
	SELECT ms.[TABLE_ID]
      ,ms.[FIELD_ID]
      ,ms.[BITKEYFIELD_FLG]
      ,ms.[BITUSERFIELD_FLG]
      ,ms.[BITMATCHFIELD_FLG]
      ,ms.[BITPOSTEDFIELD_FLG]
      ,ms.[bitPII]
      ,ms.[bitAllowUS]
	FROM [dbo].[METASTRUCTURE_Removed] ms
	INNER JOIN [dbo].[METAFIELD_Removed] mf on mf.FIELD_ID = ms.Field_ID
	where mf.STRFIELD_NM =  'hsp_guardflg'


END

declare @dq_nm varchar(20) = 'DQ_Guar'


IF NOT Exists (SELECT 1 from dbo.SurveyTypeDefaultCriteria s
	 inner join DefaultCriteriaStmt d on s.DefaultCriteriaStmt_id = d.DefaultCriteriaStmt_id
	 where strCriteriaStmt_nm = @dq_nm)
 BEGIN
	 
	 SET IDENTITY_INSERT dbo.SurveyTypeDefaultCriteria ON

	 INSERT INTO dbo.SurveyTypeDefaultCriteria ( [SurveyTypeDefaultCriteria]
      ,[SurveyType_id]
      ,[Country_id]
      ,[DefaultCriteriaStmt_id])
	 select s.* 
	 from SurveyTypeDefaultCriteria_Removed s
	 inner join DefaultCriteriaStmt_Removed d on s.DefaultCriteriaStmt_id = d.DefaultCriteriaStmt_id
	 where strCriteriaStmt_nm = @dq_nm

	 SET IDENTITY_INSERT dbo.SurveyTypeDefaultCriteria OFF
END




 IF NOT Exists (SELECT 1 FROM [dbo].[DefaultCriteriaClause] dcc
  inner join dbo.DefaultCriteriaStmt dcs on dcs.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
  where dcs.strCriteriaStmt_nm = @dq_nm)
BEGIN

	SET IDENTITY_INSERT dbo.DefaultCriteriaClause ON

	 INSERT INTO [dbo].[DefaultCriteriaClause] ( [DefaultCriteriaClause_id]
      ,[DefaultCriteriaStmt_id]
      ,[CriteriaPhrase_id]
      ,[strTable_nm]
      ,[Field_id]
      ,[intOperator]
      ,[strLowValue]
      ,[strHighValue])
	 SELECT dcc.*
	  FROM [dbo].[DefaultCriteriaClause_Removed] dcc
	  inner join dbo.DefaultCriteriaStmt_Removed dcs on dcs.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
	  where dcs.strCriteriaStmt_nm = @dq_nm

	  SET IDENTITY_INSERT dbo.DefaultCriteriaClause OFF
END


IF NOT Exists (SELECT 1 FROM [dbo].[DefaultCriteriaStmt]  where strCriteriaStmt_nm = @dq_nm)
BEGIN

	SET IDENTITY_INSERT dbo.DefaultCriteriaStmt ON

	 INSERT INTO [dbo].[DefaultCriteriaStmt] ( [DefaultCriteriaStmt_id]
      ,[strCriteriaStmt_nm]
      ,[strCriteriaString]
      ,[BusRule_cd])
	 select * 
	 from DefaultCriteriaStmt_Removed
	 where strCriteriaStmt_nm = @dq_nm

	 SET IDENTITY_INSERT dbo.DefaultCriteriaStmt OFF

END

-- select s.* 
-- from SurveyTypeDefaultCriteria s
-- inner join DefaultCriteriaStmt d on s.DefaultCriteriaStmt_id = d.DefaultCriteriaStmt_id
-- where strCriteriaStmt_nm = @dq_nm


--SELECT dcc.*
--FROM [dbo].[DefaultCriteriaClause] dcc
--inner join dbo.DefaultCriteriaStmt dcs on dcs.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
--where dcs.strCriteriaStmt_nm = @dq_nm

--select * 
--from DefaultCriteriaStmt
--where strCriteriaStmt_nm = @dq_nm

--SELECT * FROM [dbo].[METASTRUCTURE] ms
--INNER JOIN [dbo].[METAFIELD] mf on mf.FIELD_ID = ms.Field_ID
--where mf.STRFIELD_NM =  'hsp_guardflg'

-- SELECT *
-- FROM [QP_Prod].[dbo].[METAFIELD] 
-- where STRFIELD_NM =  'hsp_guardflg'

-- GO



use QP_Prod

SELECT distinct SURVEY_ID
into #Surveys
from dbo.temp_DQ_GuarSurveys


/* process each survey, one at a time */
declare @survey_id int, @study_id int
select top 1 @survey_id = survey_id from #Surveys
while @@rowcount>0
begin
	
	---- we re-add the new rule.  It will skip the existing rules and add only new ones.
	exec QCL_InsertDefaultDQRules @survey_id

	delete from #Surveys where survey_id=@survey_id
	select top 1 @survey_id = survey_id from #Surveys
end

drop table #Surveys

GO

