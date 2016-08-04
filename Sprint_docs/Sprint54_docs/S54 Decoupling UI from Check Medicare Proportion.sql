/*
S54 Decoupling UI from Check Medicare Proportion

Chris Burkholder

UPDATE QUALPRO_PARAMS
INSERT INTO QUALPRO_PARAMS

*/


update qualpro_params set strparam_value = 1
--select * from qualpro_params 
where strparam_nm = 'SurveyRule: CompliesWithSwitchToPropSamplingDate - OAS CAHPS'

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
select replace(strparam_nm, 'CompliesWithSwitchToPropSamplingDate', 'AllowOverSample'), STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, 'Allow Oversample for HCAHPS IP' from qualpro_params
where strparam_nm = 'SurveyRule: CompliesWithSwitchToPropSamplingDate - HCAHPS IP'

insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, COMMENTS)
select replace(strparam_nm, 'CompliesWithSwitchToPropSamplingDate', 'CheckMedicareProportion'), STRPARAM_TYPE, STRPARAM_GRP, STRPARAM_VALUE, 'Check Medicare Proportion for HCAHPS IP' from qualpro_params
where strparam_nm = 'SurveyRule: CompliesWithSwitchToPropSamplingDate - HCAHPS IP'
