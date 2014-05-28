CREATE PROCEDURE [dbo].[csp_GetClientContactExtractData] 
	@ExtractFileID int
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 2 -- Client Contact Entity

	select CONTACT_ID as id, 
			STRCONTACTNAME as name,
			STRCONTACTPHONE as phone,
			STRCONTACTFAX as fax,
			STRCONTACTTITLE as title,
			STRCONTACTADDR1 as addr1,
			STRCONTACTADDR2 as addr2,
			STRCONTACTCITY as city,
			STRCONTACTSTATE as state,
			STRCONTACTZIP as zip,
			STRCONTACTEMAIL as email,
			CLIENT_ID as clientid,
			'false' as deleteEntity		
	  from QP_PROD.dbo.CLIENT_CONTACT clientContact with (NOLOCK)
			inner join (select distinct PKey1 
                        from ExtractHistory  with (NOLOCK) 
                         where ExtractFileID = @ExtractFileID
	                     and EntityTypeID = @EntityTypeID
	                     and IsDeleted = 0 ) eh on clientContact.CONTACT_ID = eh.PKey1
   	union all
	select distinct PKey1 as id, 
			NULL as name,
			NULL as phone,
			NULL as fax,
			NULL as title,
			NULL as addr1,
			NULL as addr2,
			NULL as city,
			NULL as state,
			NULL as zip,
			NULL as email,
			NULL as clientid,
			'true' as deleteEntity
	  from ExtractHistory clientContact with (NOLOCK)
	 where clientContact.ExtractFileID = @ExtractFileID
	   and clientContact.EntityTypeID = @EntityTypeID
	   and clientContact.IsDeleted <> 0
	for xml auto


