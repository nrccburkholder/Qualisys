--select * from qualpro_params where strparam_grp like '%SurveyRule%'

if not exists (select 1 from qualpro_params where STRPARAM_NM = 'SurveyRule: SamplingToolPriority')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS)
values ('SurveyRule: SamplingToolPriority', 'N', 'SurveyRules', 99, 'Default Sampling Tool Priority is lower than any other value')

if not exists (select 1 from qualpro_params where STRPARAM_NM = 'SurveyRule: SamplingToolPriority - HCAHPS IP')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS)
values ('SurveyRule: SamplingToolPriority - HCAHPS IP', 'N', 'SurveyRules', 1, 'HCAHPS Sampling Tool Priority is 1')

if not exists (select 1 from qualpro_params where STRPARAM_NM = 'SurveyRule: SamplingToolPriority - Home Health CAHPS')
insert into qualpro_params (STRPARAM_NM, STRPARAM_TYPE, STRPARAM_GRP, NUMPARAM_VALUE, COMMENTS)
values ('SurveyRule: SamplingToolPriority - Home Health CAHPS', 'N', 'SurveyRules', 2, 'HHCAHPS Sampling Tool Priority is 1')

--update qualpro_params set numparam_value = 2 where strparam_nm = 'SurveyRule: SamplingToolPriority - Home Health CAHPS'

