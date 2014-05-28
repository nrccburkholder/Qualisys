CREATE PROCEDURE [dbo].[csp_GetSampleUnitExtractData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 6 -- SampleUnit'
	
	--declare @ExtractFileID int
	--set @ExtractFileID = 1 -- SampleUnit

	select  distinct 1  as Tag
	,NULL  as Parent
	,sampleUnit.SAMPLEUNIT_ID as [sampleUnit!1!id]
	,sp.SURVEY_ID as [sampleUnit!1!surveyid]
	,sampleUnit.strSampleUnit_NM as  [sampleUnit!1!name]
	,Case When IsNull(sampleUnit.bitHCAHPS,0) = 0 And IsNull(SampleUnit.bitHHCAHPS,0) = 0 Then 0 Else 1 End  as [sampleUnit!1!isCahps]
	,sampleUnit.bitSuppress as [sampleUnit!1!isSuppressedOnWeb]
	,sampleUnit.PARENTSAMPLEUNIT_ID as [sampleUnit!1!parentUnitID]
	,'false' as [sampleUnit!1!deleteEntity]
	  from QP_PROD.dbo.SAMPLEUNIT sampleUnit with (NOLOCK)
			inner join (select distinct PKey1 
                        from ExtractHistory  with (NOLOCK) 
                         where ExtractFileID = @ExtractFileID
	                     and EntityTypeID = @EntityTypeID
	                     and IsDeleted = 0 ) eh on sampleUnit.SAMPLEUNIT_ID = eh.PKey1
			inner join QP_Prod.dbo.SAMPLEPLAN sp with (NOLOCK) on sampleUnit.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID	 
	union all
	select distinct 1  as Tag
	,NULL  as Parent
	,sampleUnit.PKey1 as id
	,null as surveyid
	,null as name
	,null as isHcaphs
	,null as isSuppressedOnWeb
	,null as parentUnitID
	,'true' as deleteEntity
	  from ExtractHistory sampleUnit with (NOLOCK)
	 where sampleUnit.ExtractFileID = @ExtractFileID
	   and sampleUnit.EntityTypeID = @EntityTypeID
	   and sampleUnit.IsDeleted <> 0
	for XML EXPLICIT


