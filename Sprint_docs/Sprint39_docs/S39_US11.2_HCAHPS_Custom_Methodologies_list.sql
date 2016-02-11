/*

S39 US11 HCAHPS No Custom Methoodologies 

As a Corporate Compliance Analyst, I would like the HCAHPS methodologies to be restricted to only the standard methodologies so that custom methodologies are unavailable for users to select.



Tim Butler

Task 2 - Create a query that identifies any HCAHPS surveys that use custom methoodologies and tell QS & Adam H.



*/


use qp_prod
go

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int
declare @StandardMethodology_nm varchar(50)
declare @MethodologyType varchar(30)

SET @StandardMethodology_nm = 'Custom'
SET @MethodologyType = 'Exception'
SET @SurveyType_desc = 'HCAHPS IP'


select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = @SurveyType_desc

select sd.survey_id, sd.strSurvey_nm, st.[STRSTUDY_NM], c.STRCLIENT_NM, mm.methodology_id,mm.strMethodology_nm, sm.strStandardMethodology_nm
from Survey_def sd
inner join study st on st.study_id = sd.study_id
inner join client c on c.client_id = st.CLIENT_ID
inner join [dbo].[MAILINGMETHODOLOGY] mm on mm.[SURVEY_ID] = sd.[SURVEY_ID]
inner join standardmethodology sm on sm.[StandardMethodologyID] = mm.[StandardMethodologyID]
where sd.surveytype_id = @surveytype_id
and sm.strStandardMethodology_nm = @StandardMethodology_nm
and sm.MethodologyType = @MethodologyType
and sd.Active = 1 and c.Active = 1 and st.Active = 1
and SUBSTRING(st.STRSTUDY_NM,1,1) <> 'x'
and SUBSTRING(sd.STRSURVEY_NM,1,1) <> 'x'
