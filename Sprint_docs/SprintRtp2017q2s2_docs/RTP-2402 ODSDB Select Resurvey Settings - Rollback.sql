/*
	RTP-2402 ODSDB Select Resurvey Settings - Rollback.sql

	Chris Burkhodler

	5/15/2017

	INSERT into QUALPRO_PARAMS

	select * from qualpro_params where strparam_grp = 'SamplingTool'
	select * from qualpro_params where strparam_nm like '%resurvey%' order by strparam_nm
	select * from qualpro_params where strparam_nm like '%- RT%'
*/
Use [QP_Prod]
GO

delete from QualPro_Params where strparam_nm = 'MasterSurveyTypeForODSDB'
delete from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyMethodDefault - RT'
delete from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyExclusionPeriodsNumericDefault - RT'
delete from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - RT'
delete from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyMethodDisabled - RT'

GO