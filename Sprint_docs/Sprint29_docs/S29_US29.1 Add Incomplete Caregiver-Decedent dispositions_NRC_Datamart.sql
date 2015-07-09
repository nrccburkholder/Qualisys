

/*
	S29.US29	Hospice CAHPS missing caregiver name	
	
	As an authorized Hospice CAHPS vendor, we need to implement a process so we don't generate surveys with missing caregiver 
	names or missing decedent names (capture and disposition appropriately before generation)

	T29.1	add 2 dispositions; partial missing decedent name, partial missing caregiver name

Tim Butler

NRC_Datamart:
INSERT INTO dbo.cahpsdisposition
INSERT INTO dbo.disposition 
UPDATE/INSERT INTO cahpsdispositionmapping 
*/
use nrc_datamart
go


begin tran

declare @hospiceId int
declare @cahpsdispositionid varchar(3)
declare @CMSdispositionCode int
declare @dispositionid int
declare @hierarchy int
declare @label varchar(100)

select @hospiceId = CahpsTypeId from [dbo].[CahpsType] where label = 'Hospice CAHPS'

select @hierarchy = max(CahpsHierarchy) + 1
	from cahpsdispositionmapping
	where CahpsTypeID = @hospiceId

SET @label = 'Incomplete Caregiver'
SET @CMSdispositionCode = 12

SET @cahpsdispositionid = CAST(@hospiceId as varchar(1)) + cast(@CMSdispositionCode as varchar)

select @cahpsdispositionid

if not exists (select * from cahpsdisposition where cahpstypeid=@hospiceId and label = @label)
	insert into cahpsdisposition (CahpsDispositionID, CahpsTypeID, Label, IsCahpsDispositionComplete, IsCahpsDispositionInComplete)
	values (@cahpsdispositionid, @hospiceId, @label, 0, 0)

SET @dispositionid  = /* get the disposition id from QP_Prod.Disposition -- the one we just added */

if not exists (select * from disposition where label = @label)
	insert into disposition (DispositionID, label) values (@dispositionid, @label)
	
if not exists (select * from cahpsdispositionmapping where cahpstypeid=@hospiceId and label = @label)
begin

	insert into cahpsdispositionmapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
	values (@hospiceId, @dispositionid , -1, @label, @cahpsdispositionid, @hierarchy, 0)
end


select @hospiceId = CahpsTypeId from [dbo].[CahpsType] where label = 'Hospice CAHPS'

SET @label = 'Incomplete Decedent'
SET @CMSdispositionCode = 13

SET @cahpsdispositionid = CAST(@hospiceId as varchar(1)) + cast(@CMSdispositionCode as varchar)

select @cahpsdispositionid

if not exists (select * from cahpsdisposition where cahpstypeid=@hospiceId and label = @label)
	insert into cahpsdisposition (CahpsDispositionID, CahpsTypeID, Label, IsCahpsDispositionComplete, IsCahpsDispositionInComplete)
	values (@cahpsdispositionid, @hospiceId, @label, 0, 0)

SET @dispositionid  = /* get the disposition id from QP_Prod.Disposition -- the one we just added */

if not exists (select * from disposition where label = @label)
	insert into disposition (DispositionID, label) values (@dispositionid, @label)
	
if not exists (select * from cahpsdispositionmapping where cahpstypeid=@hospiceId and label = @label)
begin

	-- use the same hierarchy as assigned above
	insert into cahpsdispositionmapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
	values (@hospiceId, @dispositionid , -1, @label, @cahpsdispositionid, @hierarchy, 0)
end



commit tran
--rollback tran


select *
from cahpsdisposition
where CahpsTypeID =6

select *
from Disposition

select *
from cahpsdispositionmapping
where CahpsTypeID = 6

go