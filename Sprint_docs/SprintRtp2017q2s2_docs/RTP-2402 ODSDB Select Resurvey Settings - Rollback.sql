/*
	RTP-2402 ODSDB Select Resurvey Settings - Rollback.sql

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

delete from QualPro_Params where strparam_nm = 'MasterSurveyTypeForODSDB'

--subtype
update subtype set bitRuleOverride = 0
where subtype_NM in ('ED','IP')
and bitRuleOverride = 1

--ED
delete from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyMethodDefault - ED'
delete from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyExclusionPeriodsNumericDefault - ED'
delete from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - ED'
delete from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyMethodDisabled - ED'

--IP
delete from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyMethodDefault - IP'
delete from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyExclusionPeriodsNumericDefault - IP'
delete from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - IP'
delete from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyMethodDisabled - IP'

GO