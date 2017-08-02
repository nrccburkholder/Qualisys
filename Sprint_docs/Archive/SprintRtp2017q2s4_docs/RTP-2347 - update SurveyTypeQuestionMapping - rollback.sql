use qp_prod

-- RTP-3171 - verify contents of SurveyTypeQuestionMappings 

update qm
set isATA=NULL
from SurveyTypeQuestionMappings qm
where surveytype_id=16 
