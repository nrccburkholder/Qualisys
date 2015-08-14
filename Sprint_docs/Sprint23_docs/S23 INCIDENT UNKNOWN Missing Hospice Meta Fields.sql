/*
S23 INCIDENT UNKNOWN Missing Hospice Meta Fields.sql

for Related Hand Entry and Location Hand Entry

Adam Harris:
The first two questions on the CAHPS Hospice survey have handentry options (51574 and 51575) 
however I do not see that handentry metafields were created for these.  Can we please create 
metafields for those as soon as possible?  We’re unable to import the data for the mixed-mode 
and phone surveys until we have a metafield to put the data.   

*/


declare @PopId int, @EncId int, @CaseId int

select @PopId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'Hospice CAHPS Pop'
select @EncId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'Hospice CAHPS Enc'
select @CaseId = Fieldgroup_ID from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'Case Manager Name'

insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_RelatedHandE','How related hand entry',@PopId,'S',	NULL, NULL,'HspRelHE',0,0,NULL,NULL,0)
insert into MetaField (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('HSP_LocHandE','Location hand entry',@PopId,'S',NULL,NULL,'HspLocHE',0,0,NULL,NULL,0)

update metafield set intFieldLength = 100 where STRFIELDSHORT_NM = 'HspRelHE'
update metafield set intFieldLength = 100 where STRFIELDSHORT_NM = 'HspLocHE'


--select * from metafield where strfield_nm like 'HSP%'