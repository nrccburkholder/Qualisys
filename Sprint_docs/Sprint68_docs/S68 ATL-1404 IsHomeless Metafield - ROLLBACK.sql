/*

	ROLlBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S68 ATL-1404 Create isHomeless metafield

	Tim Butler
*/



use qp_prod

delete from dbo.METAFIELD where strfield_nm = 'IsHomeless'

DECLARE @id int

select @id = max(field_id) from dbo.METAFIELD 

DBCC CHECKIDENT ('dbo.METAFIELD', RESEED, @id) 


GO