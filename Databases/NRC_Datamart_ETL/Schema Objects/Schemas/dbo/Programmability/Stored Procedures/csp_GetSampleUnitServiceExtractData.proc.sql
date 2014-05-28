CREATE PROCEDURE [dbo].[csp_GetSampleUnitServiceExtractData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 6 -- SampleUnit

	select distinct sampleUnitService.SAMPLEUNIT_ID as sampleunitid,
		   isnull(sampleUnitService.strAltService_nm,s.strService_nm) as serviceName,		   
		   isnull(s.strService_nm, sampleUnitService.strAltService_nm) as serviceType
	  from QP_Prod.dbo.SampleUnitService sampleUnitService with (NOLOCK)
			inner join QP_PROD.dbo.Service s with (NOLOCK) on s.Service_id = sampleUnitService.Service_id
			inner join (select distinct PKey1 
                        from ExtractHistory  with (NOLOCK) 
                         where ExtractFileID = @ExtractFileID
	                     and EntityTypeID = @EntityTypeID
	                     and IsDeleted = 0 ) eh on sampleUnitService.SAMPLEUNIT_ID = eh.PKey1	
	for xml auto


