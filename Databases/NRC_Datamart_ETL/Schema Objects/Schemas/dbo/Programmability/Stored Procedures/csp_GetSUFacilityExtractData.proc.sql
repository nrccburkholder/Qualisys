CREATE PROCEDURE [dbo].[csp_GetSUFacilityExtractData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 6 -- SampleUnit

	select convert(varchar,su.SAMPLEUNIT_ID) as sampleunitid,
		   facilityAttrs.strFacility_nm as name,
		   facilityAttrs.MedicareNumber as MedicareNumber,
		   facilityAttrs.AHA_id as AHAIdent,
		   facilityAttrs.city as city,
		   facilityAttrs.state as state,
		   (select strregion_nm from QP_Prod.dbo.Region r where r.region_id = facilityAttrs.region_id) as region,
		   facilityAttrs.admitNumber as admitNumber,
		   facilityAttrs.country as country,
		   facilityAttrs.bedsize as bedSize,
		   facilityAttrs.bitFreeStanding as isFreeStanding,
		   facilityAttrs.bitPicker       as isPicker,
		   facilityAttrs.bitPeds         as isPeds,
		   facilityAttrs.bitRural        as isRural,
		   facilityAttrs.bitCancerCenter as isCancerCenter,
		   facilityAttrs.bitReligious    as isReligious,
		   facilityAttrs.bitTeaching     as isTeaching,
		   facilityAttrs.bitRehab        as isRehab,
		   facilityAttrs.bitGovernment   as isGovernment,
		   facilityAttrs.bitForProfit    as isForProfit,
		   facilityAttrs.bitTrauma       as isTrauma
	  from QP_Prod.dbo.SUFacility facilityAttrs with (NOLOCK)
			inner join QP_PROD.dbo.SAMPLEUNIT su with (NOLOCK) on facilityAttrs.SUFacility_ID = su.SUFacility_ID
			inner join (select distinct PKey1 
                        from ExtractHistory with (NOLOCK)
                        where ExtractFileID = @ExtractFileID
						and EntityTypeID = @EntityTypeID
						and IsDeleted = 0 ) eh  on su.SAMPLEUNIT_ID = eh.PKey1
	 
	for xml auto


