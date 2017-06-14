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

--Connect
delete from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyMethodDefault - Connect'
delete from QualPro_Params where strparam_nm = 'SurveyRule: ResurveyExclusionPeriodsNumericDefault - Connect'
delete from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyExclusionPeriodsNumericDisabled - Connect'
delete from QualPro_Params where strparam_nm = 'SurveyRule: IsResurveyMethodDisabled - Connect'

GO