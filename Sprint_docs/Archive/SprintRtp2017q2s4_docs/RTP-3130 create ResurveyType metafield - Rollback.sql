/*
	RTP-3130 create ResurveyType metafield - Rollback

	Chris Burkholder

	6/8/2017
*/



use qp_prod

GO

delete from dbo.METAFIELD where strfield_nm = 'ResurveyType'

DECLARE @id int

select @id = max(field_id) from dbo.METAFIELD 

DBCC CHECKIDENT ('dbo.METAFIELD', RESEED, @id) 


GO