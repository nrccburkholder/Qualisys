CREATE PROCEDURE [dbo].[csp_GetSurveyExtractData] 
	@ExtractFileID int
AS
BEGIN
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 3 -- Survey Entity
	
	---------------------------------------------------------------------------------------
	-- Formmats data for XML export
	-- Changed on 2009.11.09 by kmn to export SurveyType_ID instead of SurveyType description
	---------------------------------------------------------------------------------------
  
	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT;

    select  distinct 1  as Tag
	,NULL  as Parent
	,SURVEY_ID as [survey!1!id]
	,rtrim(replace(isnull(strclientfacingName,STRSURVEY_NM), '''', '')) as [survey!1!name]
	--,rtrim(study.strstudy_nm) as [survey!1!studyName] 
	,survey.STUDY_ID as [survey!1!studyNum] 
	,survey.SurveyType_ID as [survey!1!surveyType]
	,mf.STRFIELD_NM as [survey!1!SampleEncounterField]
	,case survey.strCutoffResponse_cd
		when 0 then 'Sample Date'
		when 2 then dbo.fn_ReportDateType(SURVEY_ID)				
		else 'Return Date'
	end as [survey!1!reportDateType] 
	,case when survey.survey_id >= 26000 then 'Canada' else 'US' end as [survey!1!country] 
	--,CLIENT_ID as [survey!1!clientid]
	,survey.Active as [survey!1!activeFlag]
	,'false' as [survey!1!deleteEntity]
	from QP_PROD.dbo.SURVEY_DEF survey with (NOLOCK)
	--inner join QP_PROD.dbo.STUDY study with (NOLOCK) on survey.STUDY_ID = study.STUDY_ID
	inner join (select distinct PKey1 
                from ExtractHistory  with (NOLOCK) 
                where ExtractFileID = @ExtractFileID
	            and EntityTypeID = @EntityTypeID
	            and IsDeleted = 0 ) eh on survey.Survey_ID = eh.PKey1	
	left join QP_PROD.dbo.metafield as mf on survey.sampleencounterfield_id = mf.field_id 
	union all
	select distinct 1 as Tag,
	NULL  as Parent,survey.PKey1 as id, null as name--, null as studnName, 
	,null as studynum, null as surveytype, NULL as [survey!1!SampleEncounterField], null as reportdatetype, null as country, null as activeFlag, 'true' as deleteEntity
	from ExtractHistory survey with (NOLOCK)
	where survey.ExtractFileID = @ExtractFileID
	and survey.EntityTypeID = @EntityTypeID
	and survey.IsDeleted <> 0
	for XML EXPLICIT

	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2

END
