--Returns a list of survey types for the Sample Status Report.
--DRM 07/27/2011

create procedure SSRS_SR_GetSurveyTypes as
select surveytype_id, surveytype_dsc from surveytype


