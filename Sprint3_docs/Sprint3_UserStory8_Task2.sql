use [QP_Prod]

--select * from METAFIELDGROUPDEF

if not exists(select fieldGroup_id from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'ICH CAHPS')
insert into metafieldgroupdef (STRFIELDGROUP_NM, strAddrCleanType, bitAddrCleanDefault) values
('ICH CAHPS', 'N', 0)

declare @FieldGroupId int
select @FieldGroupId = fieldGroup_id from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'ICH CAHPS'

--select * from metafield
if not exists(select 1 from metafield where strfield_nm= 'ICH_FacilityName')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_FacilityName','ICH facility name from CMS',@FieldGroupId,'S',64,NULL,NULL,'ICHFcNm',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_FacilityAddr')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_FacilityAddr','ICH facility address from CMS',@FieldGroupId,'S',64,NULL,NULL,'ICHFcAdd',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_FacilityAddr2')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_FacilityAddr2','ICH facility secondary address from CMS',@FieldGroupId,'S',64,NULL,NULL,'ICHFcAd2',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_FacilityCity')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_FacilityCity','ICH facility city from CMS',@FieldGroupId,'S',64,NULL,NULL,'ICHFcCit',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_FacilityST')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_FacilityST','ICH facility state from CMS',@FieldGroupId,'S',2,NULL,NULL,'ICHFcST',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_FieldDate')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_FieldDate','First day of month of survey administration',@FieldGroupId,'D',NULL,NULL,NULL,'ICHFldDt',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_SID')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_SID','ICH samples patient ID from CMS',NULL,'S',8,NULL,NULL,'ICHSID',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_HE_Lang')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_HE_Lang','ICH language speak hand entry',NULL,'S',42,NULL,NULL,'ICHLang',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_HE_WhoHelp')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_HE_WhoHelp','ICH who helped hand entry',NULL,'S',99,NULL,NULL,'ICHWho',0,0,NULL,NULL,0)

if not exists(select 1 from metafield where strfield_nm= 'ICH_HE_HowHelp')
insert into metafield (STRFIELD_NM, STRFIELD_DSC, FIELDGROUP_ID, STRFIELDDATATYPE, INTFIELDLENGTH, STRFIELDEDITMASK, INTSPECIALFIELD_CD, STRFIELDSHORT_NM, BITSYSKEY, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('ICH_HE_HowHelp','ICH how helped hand entry',NULL,'S',99,NULL,NULL,'ICHHow',0,0,NULL,NULL,0)
