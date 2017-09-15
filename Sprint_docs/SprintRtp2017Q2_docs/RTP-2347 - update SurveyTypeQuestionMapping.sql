use qp_prod

-- RTP-3171 - verify contents of SurveyTypeQuestionMappings 

update qm
set isATA=0
from SurveyTypeQuestionMappings qm
where surveytype_id=16 

update qm
set isATA=1
from SurveyTypeQuestionMappings qm
where surveytype_id=16 
and qm.qstncore in (54086,54087,54088,54089,54090,54091,54092,54093,54094,54095,54098,54099,54100,54101,54102,54103,54104,54105,54106,54107,54108,54109) 

GO