/*

S39 US11 HCAHPS No Custom Methoodologies 

As a Corporate Compliance Analyst, I would like the HCAHPS methodologies to be restricted to only the standard methodologies so that custom methodologies are unavailable for users to select.



Tim Butler

Task 1 - Update record in survey type methodology hash table to set bitExpired



*/



use qp_prod
go

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int

SET @SurveyType_desc = 'HCAHPS IP'

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = @SurveyType_desc

begin tran

declare @StandardMethodology_nm varchar(50)
declare @MethodologyType varchar(30)

SET @StandardMethodology_nm = 'Custom'
SET @MethodologyType = 'Exception'

update smst
	SET bitExpired = 1
from StandardMethodologyBySurveyType smst
inner join StandardMethodology sm on sm.StandardMethodologyID = smst.StandardMethodologyID
where SurveyType_id = @SurveyType_ID
and sm.strStandardMethodology_nm = @StandardMethodology_nm
and sm.MethodologyType = @MethodologyType

commit tran


select *
from StandardMethodologyBySurveyType smst
inner join StandardMethodology sm on sm.StandardMethodologyID = smst.StandardMethodologyID
where SurveyType_id = @SurveyType_ID



go


