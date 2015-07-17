

/*
	S29.US29	Hospice CAHPS missing caregiver name	
	
	As an authorized Hospice CAHPS vendor, we need to implement a process so we don't generate surveys with missing caregiver 
	names or missing decedent names (capture and disposition appropriately before generation)



	T29.1	add 2 dispositions; partial missing decedent name, partial missing caregiver name

Tim Butler

QP_Prod:
INSERT INTO dbo.Disposition
UPDATE/INSERT INTO SurveyTypeDispositions 

*/
use qp_prod


go

begin tran

declare @hospiceId int
declare @CMSdispositionCode int
declare @hierarchy int

select @hospiceId = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

SET @hierarchy = 12

/* create new disposition code -- Incomplete Caregiver */
if not exists (select * from disposition where strDispositionLabel='Incomplete Caregiver')
	insert into disposition (strDispositionLabel,Action_id,strReportLabel,MustHaveResults) 
	values ('Incomplete Caregiver',0,'Incomplete Caregiver',0)

-- add to the bottom of the hierarchy
if not exists (select * from SurveyTypeDispositions where [desc]='Incomplete Caregiver' and SurveyType_id=@hospiceId)
begin

	SET @CMSdispositionCode = 12

	insert into SurveyTypeDispositions (Disposition_ID,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
	select Disposition_id, @CMSdispositionCode as Value, @hierarchy as Hierarchy, strDispositionLabel as [Desc],0 as ExportReportResponses,null as ReceiptType_ID,@hospiceId as SurveyType_ID
	from Disposition 
	where strDispositionLabel='Incomplete Caregiver'
end


/* create new disposition code -- Incomplete Decedent */
if not exists (select * from disposition where strDispositionLabel='Incomplete Decedent')
	insert into disposition (strDispositionLabel,Action_id,strReportLabel,MustHaveResults) 
	values ('Incomplete Decedent',0,'Incomplete Decedent',0)


-- add to the bottom of the hierarchy
if not exists (select * from SurveyTypeDispositions where [desc]='Incomplete Decedent' and SurveyType_id=@hospiceId)
begin

	SET @CMSdispositionCode = 13

-- using same hierarchy value as assigned above
	insert into SurveyTypeDispositions (Disposition_ID,Value,Hierarchy,[Desc],ExportReportResponses,ReceiptType_ID,SurveyType_ID)
	select Disposition_id, @CMSdispositionCode as Value, @hierarchy as Hierarchy, strDispositionLabel as [Desc],0 as ExportReportResponses,null as ReceiptType_ID,@hospiceId as SurveyType_ID
	from Disposition 
	where strDispositionLabel='Incomplete Decedent'
end


-- Update Hierarchy for the dispositions so our new dispositions rank higher than these


Update SurveyTypeDispositions
	SET Hierarchy = @hierarchy + 1
where [desc] = 'Non-response: Unused Bad Address'
and SurveyType_ID =  @hospiceId

Update SurveyTypeDispositions
	SET Hierarchy = @hierarchy + 1
where [desc] = 'Non-response: Unused Bad/No Telephone Number'
and SurveyType_ID =  @hospiceId

-- this one needs to be last
Update SurveyTypeDispositions
	SET Hierarchy = @hierarchy + 2
where [desc] = 'Non-response: Non-response after max attempts'
and SurveyType_ID =  @hospiceId


commit tran


select *
from Disposition

select *
from SurveyTypeDispositions
where SurveyType_ID = @hospiceId

GO
