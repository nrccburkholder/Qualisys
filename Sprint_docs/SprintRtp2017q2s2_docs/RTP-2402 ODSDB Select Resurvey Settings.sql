/*
	RTP-2402 ODSDB Select Resurvey Settings

	Chris Burkhodler

	5/15/2017

	INSERT into QUALPRO_PARAMS

	select * from qualpro_params where strparam_grp = 'SamplingTool'
	select * from qualpro_params where strparam_nm like '%resurvey%' order by strparam_nm
	select * from qualpro_params where strparam_nm like '%- Connect%'
	select * from qualpro_params where strparam_nm like '%- ED%'
	select * from qualpro_params where strparam_nm like '%- IP%'
	select * from subtype where subtype_NM IN ('ED','IP')
*/
Use [QP_Prod]
GO

if not exists (select * from QualPro_Params where strparam_nm = 'MasterSurveyTypeForODSDB')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('MasterSurveyTypeForODSDB','S','SamplingTool','13',NULL,NULL,'Legacy Connect Survey Type needed to read CustomerSurveyConfig')

--subtype
update subtype set bitRuleOverride = 1
where subtype_NM in ('ED','IP')
and bitRuleOverride = 0

--Connect
if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyMethodDefault - Connect')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: ResurveyMethodDefault - Connect','S','SurveyRules','NumberOfDays',1,NULL,'Connect has Resurvey method NumberOfDays default')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyExclusionPeriodsNumericDefault - Connect')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: ResurveyExclusionPeriodsNumericDefault - Connect','N','SurveyRules',NULL,4,NULL,'Connect has Resurvey 4 Days default')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - Connect')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - Connect','S','SurveyRules','1',NULL,NULL,'Connect has Resurvey Numeric disabled')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyMethodDisabled - Connect')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: IsResurveyMethodDisabled - Connect','S','SurveyRules','1',NULL,NULL,'Connect has Resurvey method disabled')

GO