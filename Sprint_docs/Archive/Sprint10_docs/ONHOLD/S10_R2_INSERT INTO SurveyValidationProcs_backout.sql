
/*
Inserts new SurveyValidationProcs records 
and the SurveyValidationProcsBySurveyType mappings 

*/


begin tran


update [dbo].[SurveyValidationProcs]
	set bitActive = 1
where ProcedureName in (
'SV_CAHPS_HH_CAHPS_DQRules'
,'SV_CAHPS_H_CAHPS_DQRules'
,'SV_CAHPS_PCMH_CAHPS_DQRules'
)

update [dbo].[SurveyValidationProcs]
	set bitActive = 0
where ProcedureName in (
'SV_CAHPS_DQRules'
)

select *
from SurveyValidationProcs_view


commit tran

 GO
