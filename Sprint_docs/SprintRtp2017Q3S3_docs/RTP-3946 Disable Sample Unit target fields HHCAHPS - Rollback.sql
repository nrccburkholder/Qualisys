/*
	RTP-3946 Disable Sample Unit target fields HHCAHPS - Rollback.sql

	Chris Burkholder

	9/8/2017

	INSERT INTO QUALPRO_PARAMS

select * from qualpro_params where strparam_nm like '%surveyrule%HCAHPS%' order by strparam_nm
select * from qualpro_params where strparam_nm like '%surveyrule%OAS%' order by strparam_nm
select * from qualpro_params where strparam_nm like '%surveyrule%Home%' order by strparam_nm
select * from surveytype
*/

USE [QP_Prod]
GO

delete from qualpro_params where strparam_nm = 'SurveyRule: CompliesWithSwitchToPropSamplingDate - Home Health CAHPS'

delete from qualpro_params where strparam_nm = 'SurveyRule: BypassInitRespRateNumericEnforcement - Home Health CAHPS'

delete from qualpro_params where strparam_nm = 'SurveyRule: CheckMedicareProportion - Home Health CAHPS'

delete from qualpro_params where strparam_nm = 'SurveyRule: CheckMedicareProportion - OAS CAHPS'

delete from qualpro_params where strparam_nm = 'SurveyRule: MedicareProportionBySurveyType - Home Health CAHPS'

delete from qualpro_params where strparam_nm = 'SurveyRule: MedicareProportionBySurveyType - OAS CAHPS'

GO