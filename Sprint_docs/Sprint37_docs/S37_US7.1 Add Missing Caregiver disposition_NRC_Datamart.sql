

/*
	S37 US7	Hospice CAHPS missing caregiver name	
		
	As an authorized Hospice CAHPS vendor, we need to disposition a record 3 - "not in eligible population" when the caregiver name is missing, so that we comply with updated protocols.

	T7.1	create a new NRC disposition and insert into the Hospice CAHPS heirarchy in both QP_Prod and NRC_datamart

Tim Butler

NRC_Datamart:
INSERT INTO dbo.cahpsdisposition
INSERT INTO dbo.disposition 
UPDATE/INSERT INTO cahpsdispositionmapping 
*/
use nrc_datamart
go


begin tran

declare @surveytype_id int
declare @cahpsdispositionid varchar(3)
declare @CMSdispositionCode  varchar(3)
declare @dispositionid int
declare @hierarchy int
declare @label varchar(100)

select @surveytype_id = CahpsTypeId from [dbo].[CahpsType] where label = 'Hospice CAHPS'

SET @hierarchy = 1

SET @label = 'Missing Caregiver'
SET @CMSdispositionCode = '03'

SET @cahpsdispositionid = CAST(@surveytype_id as varchar(1)) + @CMSdispositionCode

if not exists (select * from cahpsdisposition where cahpsdispositionid = @cahpsdispositionid)
	insert into cahpsdisposition (CahpsDispositionID, CahpsTypeID, Label, IsCahpsDispositionComplete, IsCahpsDispositionInComplete)
	values (@cahpsdispositionid, @surveytype_id, @label, 0, 0)

SET @dispositionid  = 53 /* get the missing caregiver disposition id from QP_Prod.Disposition -- the one we just added */

if not exists (select * from disposition where label = @label)
	insert into disposition (DispositionID, label) values (@dispositionid, @label)
	
if not exists (select * from cahpsdispositionmapping where cahpstypeid=@surveytype_id and label = @label)
begin

	insert into cahpsdispositionmapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
	values (@surveytype_id, @dispositionid , -1, @label, @cahpsdispositionid, @hierarchy, 0)
end


commit tran



select *
from cahpsdisposition
where CahpsTypeID = @surveytype_id


select *
from cahpsdispositionmapping
where CahpsTypeID = @surveytype_id
order by CahpsHierarchy desc, Label

--rollback tran

go