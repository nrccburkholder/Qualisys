/*
	S45 US 7 Nightly Hospice File Extract 
	As a developer, I need to create a sql agent job on CatDB2 that creates a Hospice CAHPS extract every night so that we have a mechanism for identifying incorrect data well before its time to submit it
	
	7.1 - Write query to return all survey_ids that relate to the current template (all active hospice)
	
*/
use NRC_Datamart_Extracts
go
select et.exportTemplateID, s.SurveyID, s.SurveyTypeID, s.CahpsTypeID, min(sp.servicedate) as minServicedate, max(sp.servicedate) as maxServicedate, count(*) as cnt
from cem.exporttemplate et 
inner join NRC_Datamart.dbo.survey s on s.SurveyTypeID=et.SurveyTypeID
inner join NRC_Datamart.dbo.sampleunit su on su.surveyid=s.surveyid
inner join NRC_Datamart.dbo.selectedsample sel on sel.sampleunitid=su.sampleunitid
inner join NRC_Datamart.dbo.samplepopulation sp on sp.SamplePopulationID=sel.SamplePopulationID and sp.servicedate between et.ValidStartDate and et.ValidEndDate
where et.ExportTemplateName='CAHPS Hospice'
and et.SurveyTypeID=11
and et.ExportTemplateVersionMajor='2.1.2'
group by et.exportTemplateID, s.SurveyID, s.SurveyTypeID, s.CahpsTypeID


