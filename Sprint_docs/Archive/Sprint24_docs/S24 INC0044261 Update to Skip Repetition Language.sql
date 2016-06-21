USE QP_Prod
/*


S24 INC0044261 Update to Skip Repetition Language

Chris Burkholder

I'd like to request to have the survey type 'CGCAHPS' added to the code in the database for the skip repetition language. 
Similar to what was done for CAHPS Hospice, we are working on a CG project where we would like to have this language in place as well. 
If there are any questions or if you need any further information, please let me know. 

select * from surveytype

*/

update surveytype set SkipRepeatsScaleText = 1 where SurveyType_dsc = 'CGCAHPS' and SkipRepeatsScaleText <> 1