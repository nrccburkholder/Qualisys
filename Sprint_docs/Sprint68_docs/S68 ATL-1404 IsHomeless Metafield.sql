/*

	S68 ATL-1404 Create isHomeless metafield

	Tim Butler
*/

/*
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('IsHomeless','Is the individual homeless',NULL,'I',NULL,NULL,'HOMELESS',0,0,NULL,NULL,0)
*/

use qp_prod



if not exists (select 1 from dbo.METAFIELD where strfield_nm = 'IsHomeless')
begin

	begin tran

		insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, bitPII)
		values ('IsHomeless','Is the individual homeless',NULL,'S',1,'HOMELESS',0,0,0)

	commit tran
end



select * from dbo.METAFIELD order by FIELD_ID desc

GO