/*
S20 US17 T2 Hospice CAHPS remove SV question 52366

3/11/2015 Chris Burkholder

Adjust for Optional Survey Section	Adjust the Survey Validation for Hospice CAHPS to take the Optional Survey section modules into account	Must be completed in this sprint	
17.1	Dana will check to see if it's needed
17.2	If needed, figure something out. 

From Dana:
Josh and I were talking the other day about the survey validation issue caused by the rearrangement of the questions on the hospice CAHPS survey. 
I checked w/ Compliance and Research and they are in favor of removing the consent to share question from the list of required questions for survey validation.  

*/



-- !!!!!!!!!! This was run in PROD 03/27/2015 in response to a message from Adam Harris  TSB

Use [QP_Prod]

delete 
--select *
from SurveyTypeQuestionMappings where qstncore=52366 and SurveyType_id = 11

