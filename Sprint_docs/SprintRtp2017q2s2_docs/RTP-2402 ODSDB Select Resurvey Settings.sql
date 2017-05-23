/*
	RTP-2402 ODSDB Select Resurvey Settings

	Chris Burkhodler

	5/15/2017

	INSERT into QUALPRO_PARAMS

	select * from qualpro_params where strparam_grp = 'SamplingTool'
	select * from qualpro_params where strparam_nm like '%resurvey%' order by strparam_nm
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

--ED
if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyMethodDefault - ED')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: ResurveyMethodDefault - ED','S','SurveyRules','NumberOfDays',1,NULL,'ED has Resurvey method NumberOfDays default')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyExclusionPeriodsNumericDefault - ED')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: ResurveyExclusionPeriodsNumericDefault - ED','N','SurveyRules',NULL,365,NULL,'ED has Resurvey 365 Days default')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - ED')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - ED','S','SurveyRules','1',NULL,NULL,'ED has Resurvey Numeric disabled')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyMethodDisabled - ED')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: IsResurveyMethodDisabled - ED','S','SurveyRules','1',NULL,NULL,'ED has Resurvey method disabled')

--IP
if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyMethodDefault - IP')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: ResurveyMethodDefault - IP','S','SurveyRules','NumberOfDays',1,NULL,'IP has Resurvey method NumberOfDays default')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyExclusionPeriodsNumericDefault - IP')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: ResurveyExclusionPeriodsNumericDefault - IP','N','SurveyRules',NULL,365,NULL,'IP has Resurvey 365 Days default')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - IP')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - IP','S','SurveyRules','1',NULL,NULL,'IP has Resurvey Numeric disabled')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyMethodDisabled - IP')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: IsResurveyMethodDisabled - IP','S','SurveyRules','1',NULL,NULL,'IP has Resurvey method disabled')

GO