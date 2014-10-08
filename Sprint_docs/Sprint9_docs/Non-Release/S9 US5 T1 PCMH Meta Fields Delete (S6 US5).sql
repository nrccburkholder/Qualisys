use [qp_prod]

--select * from metafieldgroupdef where STRFIELDGROUP_NM = 'PCMH'
--select * from metafield where fieldgroup_id = 20


declare @PCMHid int = 20
select @PCMHid = IsNULL(FieldGroup_ID,@PCMHid) from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'PCMH'

if (@PCMHId >= 0)
BEGIN
	delete from CRITERIACLAUSE where field_id in (select field_id from metafield where fieldgroup_id = @PCMHid)

	delete from TAGFIELD where field_id in (select field_id from metafield where fieldgroup_id = @PCMHid)
	
	update survey_def set cutofffield_id = null where cutofffield_id in (select field_id from metafield where fieldgroup_id = @PCMHid)

	update survey_def set sampleencounterfield_id = null where sampleencounterfield_id in (select field_id from metafield where fieldgroup_id = @PCMHid)

	delete  from METASTRUCTURE where field_id in (select field_id from metafield where fieldgroup_id = @PCMHid)

	delete from METAFIELD where fieldGroup_id = @PCMHid

	delete from METAFIELDGROUPDEF where fieldGroup_id = @PCMHid

	--NOTE: MosRecVisDate will be left in because it is not in the PCMH METAFIELDGROUPDEF
END
/*
if not exists(select 1 from METAFIELD where strField_nm = 'PCMH_PracName')
insert into METAFIELD (strField_nm,	strField_dsc, fieldGroup_id, strFieldDataType, intFieldLength, strFieldEditMask, intSpecialField_cd, strFieldShort_nm, bitSysKey, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('PCMH_PracName','PCMH Practice Name', @PCMHid,'S',60,NULL,NULL,'PCMHPrac',0,0,NULL,NULL,0)

if not exists(select 1 from METAFIELD where strField_nm = 'MosRecVisDate')
insert into METAFIELD (strField_nm,	strField_dsc, fieldGroup_id, strFieldDataType, strFieldEditMask, intSpecialField_cd, strFieldShort_nm, bitSysKey, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('MosRecVisDate','Date of most recent visit',NULL,'D',NULL,NULL,'MRVisDt',0,0,NULL,NULL,0)

if not exists(select 1 from METAFIELD where strField_nm = 'PCMH_VisCnt')
insert into METAFIELD (strField_nm,	strField_dsc, fieldGroup_id, strFieldDataType, strFieldEditMask, intSpecialField_cd, strFieldShort_nm, bitSysKey, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('PCMH_VisCnt','PCMH count of visits in past 12 months',@PCMHid,'I',NULL,NULL,'PCMHVCnt',0,0,NULL,NULL,0)

if not exists(select 1 from METAFIELD where strField_nm = 'PCMH_FileDate')
insert into METAFIELD (strField_nm,	strField_dsc, fieldGroup_id, strFieldDataType, strFieldEditMask, intSpecialField_cd, strFieldShort_nm, bitSysKey, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('PCMH_FileDate','Date practice created PCMH file',@PCMHid,'D',NULL,NULL,'PCMHFiDt',0,0,NULL,NULL,0)

if not exists(select 1 from METAFIELD where strField_nm = 'PCMH_Age')
insert into METAFIELD (strField_nm,	strField_dsc, fieldGroup_id, strFieldDataType, strFieldEditMask, intSpecialField_cd, strFieldShort_nm, bitSysKey, bitPhase1Field, intAddrCleanCode, intAddrCleanGroup, bitPII)
values ('PCMH_Age','Patient age on last day of measurement period',@PCMHid,'I',NULL,NULL,'PCMHAge',0,0,NULL,NULL,0)
*/

/*
if not exists(select 1 from METAFIELDGROUPDEF where STRFIELDGROUP_NM = 'PCMH')
insert into METAFIELDGROUPDEF (STRFIELDGROUP_NM, strAddrCleanType,  bitAddrCleanDefault)
values ('PCMH','N',0)
*/



delete
--select * 
from qualpro_params where strparam_nm like '%PCMH Distinction'

/*
if not exists(select 1 from QUALPRO_PARAMS where STRPARAM_NM = 'SurveyRule: ResurveyExclusionPeriodsNumericDefault - PCMH Distinction')
insert into QUALPRO_PARAMS (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
values ('SurveyRule: ResurveyExclusionPeriodsNumericDefault - PCMH Distinction', 'N', 'SurveyRules', NULL, 365, NULL, 'PCMH Resurvey Exclusion Days default for Config Man')

if not exists(select 1 from QUALPRO_PARAMS where STRPARAM_NM = 'SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - PCMH Distinction')
insert into QUALPRO_PARAMS (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
values ('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - PCMH Distinction', 'S', 'SurveyRules', 1, NULL, NULL, 'PCMH Resurvey Exclusion Days disabled for Config Man')

if not exists(select 1 from QUALPRO_PARAMS where STRPARAM_NM = 'SurveyRule: SamplingMethodDefault - PCMH Distinction')
insert into QUALPRO_PARAMS (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
values ('SurveyRule: SamplingMethodDefault - PCMH Distinction', 'S', 'SurveyRules', 'Specify Outgo', NULL, NULL, 'Rule to set default sampling method for Config Man')

if not exists(select 1 from QUALPRO_PARAMS where STRPARAM_NM = 'SurveyRule: IsSamplingMethodDisabled - PCMH Distinction')
insert into QUALPRO_PARAMS (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
values ('SurveyRule: IsSamplingMethodDisabled - PCMH Distinction', 'S', 'SurveyRules', '1', NULL, NULL, 'Rule to determine if sampling method is enabled for Config Man')

if not exists(select 1 from QUALPRO_PARAMS where STRPARAM_NM = 'SurveyRule: SkipEnforcementRequired - PCMH Distinction')
insert into QUALPRO_PARAMS (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, NUMPARAM_VALUE, DATPARAM_VALUE, COMMENTS)
values ('SurveyRule: SkipEnforcementRequired - PCMH Distinction', 'S', 'SurveyRules', '1', NULL, NULL, 'Skip Enforcement is required and controls are not enabled in Config Man')
*/

