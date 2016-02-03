/*
S40_US10_OAS_SurveyType_QualPro_Params.sql

Chris Burkholder

1/8/2016

*/
--select * from surveytype

/* PROD
SurveyType_ID	SurveyType_dsc
1	NRC/Picker
2	HCAHPS IP
3	Home Health CAHPS
4	CGCAHPS
5	Physician
6	Employee
7	NRC Canada
8	ICHCAHPS
9	MDPDPCAHPS <- not in TEST
10	ACOCAHPS
11	Hospice CAHPS
12	CIHI CPES-IC
13	PQRS CAHPS
STAGE ADDITIONS
14	PostAcuteFam
15	PostAcuteRes
*/

SET IDENTITY_INSERT surveytype ON    

/*
if not exists(select * from surveytype where surveytype_id = 9)
insert surveytype (SurveyType_ID,	SurveyType_dsc,	CAHPSType_id,	SeedMailings,	SeedSurveyPercent,	SeedUnitField,	SkipRepeatsScaleText,	UsePoundSignForSkipInstructions)
values(9,	'MDPDPCAHPS',NULL,0,NULL,NULL,0,0)
if not exists(select * from surveytype where surveytype_id = 14)
insert surveytype (SurveyType_ID,	SurveyType_dsc,	CAHPSType_id,	SeedMailings,	SeedSurveyPercent,	SeedUnitField,	SkipRepeatsScaleText,	UsePoundSignForSkipInstructions)
values(14,	'PostAcuteFam',	NULL,	0,	NULL,	NULL,	0,	0)
if not exists(select * from surveytype where surveytype_id = 15)
insert surveytype (SurveyType_ID,	SurveyType_dsc,	CAHPSType_id,	SeedMailings,	SeedSurveyPercent,	SeedUnitField,	SkipRepeatsScaleText,	UsePoundSignForSkipInstructions)
values(15,	'PostAcuteRes',	NULL,	0,	NULL,	NULL,	0,	0)
*/
if not exists(select * from surveytype where surveytype_id = 16)
insert surveytype (SurveyType_ID,	SurveyType_dsc,	CAHPSType_id,	SeedMailings,	SeedSurveyPercent,	SeedUnitField,	SkipRepeatsScaleText,	UsePoundSignForSkipInstructions)
values(16,	'OAS CAHPS',	16,	0,	NULL,	NULL,	0,	0)

SET IDENTITY_INSERT surveytype OFF

--select * from qualpro_params where strparam_nm like 'survey% HCAHPS%'
if not exists (select 1 from qualpro_params where strparam_nm = 'SurveyRule: IsCAHPS - OAS CAHPS')
insert QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
values('SurveyRule: IsCAHPS - OAS CAHPS','S','SurveyRules',1,NULL,NULL,'Rule to determine if this is a CAHPS survey type for Config Man')

if not exists (select 1 from qualpro_params where strparam_nm = 'SurveyRule: IsMonthlyOnly - OAS CAHPS')
insert QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
values('SurveyRule: IsMonthlyOnly - OAS CAHPS','S','SurveyRules',1,NULL,NULL,'Rule to determine if survey type is Monthly only for Config Man')

if not exists (select 1 from qualpro_params where strparam_nm = 'SurveyRule: SkipEnforcementRequired - OAS CAHPS')
insert QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
values('SurveyRule: SkipEnforcementRequired - OAS CAHPS','S','SurveyRules',1,NULL,NULL,'Skip Enforcement is required and controls are not enabled in Config Man')

if not exists (select 1 from qualpro_params where strparam_nm = 'SurveyRule: ResurveyMethodDefault - OAS CAHPS')
insert QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
values('SurveyRule: ResurveyMethodDefault - OAS CAHPS','S','SurveyRules','CalendarMonths',2,NULL,'OAS CAHPS Resurvey method default for Config Man')

if not exists (select 1 from qualpro_params where strparam_nm = 'SurveyRule: ResurveyExclusionPeriodsNumericDefault - OAS CAHPS')
insert QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
values('SurveyRule: ResurveyExclusionPeriodsNumericDefault - OAS CAHPS','N','SurveyRules',NULL,6,NULL,'HCAHPS Resurvey Exclusion Days default for Config Man')
--select * from qualpro_params where strparam_nm like 'survey% OAS CAHPS%'

/* Rollback
delete from surveytype where surveytype_dsc = 'OASCAHPS'
delete from qualpro_params where strparam_nm in ('SurveyRule: ResurveyMethodDefault - OAS CAHPS')
*/