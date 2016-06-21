

/*
	S37 US7	Hospice CAHPS missing caregiver name	
	
	As an authorized Hospice CAHPS vendor, we need to disposition a record 3 - "not in eligible population" when the caregiver name is missing, so that we comply with updated protocols.

	T7.1 create a new NRC disposition and insert into the Hospice CAHPS heirarchy in both QP_Prod and NRC_datamart 

Tim Butler

QP_Prod:
INSERT INTO dbo.Disposition
UPDATE/INSERT INTO SurveyTypeDispositions 

*/
use qp_prod


go

begin tran



DECLARE @SurveyType_ID int
select @SurveyType_ID = SurveyType_ID from SurveyType where SurveyType_dsc = 'Hospice CAHPS'
declare @disposition_id int
declare @CMSdispositionCode int
declare @hierarchy int = 1

select @disposition_id = max(disposition_id) + 1
from Disposition


/* create new disposition code -- Incomplete Caregiver */
if not exists (select * from disposition where strDispositionLabel='Missing Caregiver')
begin
	SET IDENTITY_INSERT disposition ON
	insert into disposition (disposition_id,strDispositionLabel,Action_id,strReportLabel,MustHaveResults) 
	values (@disposition_id,'Missing Caregiver',0,'Missing Caregiver',0)
	SET IDENTITY_INSERT disposition OFF
end


if not exists (select * from SurveyTypeDispositions where [desc]='Missing Caregiver' and SurveyType_id=@SurveyType_ID)
begin

	SET @CMSdispositionCode = 3

	insert into SurveyTypeDispositions (Disposition_ID,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
	select Disposition_id, @CMSdispositionCode as Value, @hierarchy as Hierarchy, strDispositionLabel as [Desc],0 as ExportReportResponses,null as ReceiptType_ID,@SurveyType_ID as SurveyType_ID
	from Disposition 
	where strDispositionLabel='Missing Caregiver'

end


commit tran


select *
from Disposition

select *
from SurveyTypeDispositions
where surveytype_id = 11

select *
from SurveyTypeDispositions
where SurveyType_ID = @SurveyType_ID

GO
