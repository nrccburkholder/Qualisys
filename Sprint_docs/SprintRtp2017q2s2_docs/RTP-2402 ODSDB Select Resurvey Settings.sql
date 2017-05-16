/*
	RTP-2402 ODSDB Select Resurvey Settings

	Chris Burkhodler

	5/15/2017

	INSERT into QUALPRO_PARAMS

	select * from qualpro_params where strparam_grp = 'SamplingTool'
	select * from qualpro_params where strparam_nm like '%resurvey%' order by strparam_nm
	select * from qualpro_params where strparam_nm like '%- RT%'
*/
Use [QP_Prod]
GO

if not exists (select * from QualPro_Params where strparam_nm = 'MasterSurveyTypeForODSDB')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('MasterSurveyTypeForODSDB','S','SamplingTool','13',NULL,NULL,'Legacy Connect Survey Type needed to read CustomerSurveyConfig')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyMethodDefault - RT')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: ResurveyMethodDefault - RT','S','SurveyRules','NumberOfDays',1,NULL,'RT has Resurvey method NumberOfDays default')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyExclusionPeriodsNumericDefault - RT')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: ResurveyExclusionPeriodsNumericDefault - RT','N','SurveyRules',NULL,365,NULL,'RT has Resurvey 365 Days default')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - RT')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - RT','S','SurveyRules','1',NULL,NULL,'RT has Resurvey Numeric disabled')

if not exists (select * from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyMethodDisabled - RT')
	insert into QualPro_Params(STRPARAM_NM,STRPARAM_TYPE,STRPARAM_GRP,STRPARAM_VALUE,NUMPARAM_VALUE,DATPARAM_VALUE,COMMENTS)
	values ('SurveyRule: IsResurveyMethodDisabled - RT','S','SurveyRules','1',NULL,NULL,'RT has Resurvey method disabled')

GO