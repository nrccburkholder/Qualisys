
use nrc_datamart
go



declare @hospiceId int
declare @cahpsdispositionid varchar(3)
declare @CMSdispositionCode int
declare @dispositionid int
declare @label varchar(100)

select @hospiceId = CahpsTypeId from [dbo].[CahpsType] where label = 'Hospice CAHPS'


SET @label = 'Ineligible: Institutionalized'
SET @CMSdispositionCode = 14

SET @cahpsdispositionid = CAST(@hospiceId as varchar(1)) + cast(@CMSdispositionCode as varchar)


begin tran

	insert into cahpsdisposition (CahpsDispositionID, CahpsTypeID, Label, IsCahpsDispositionComplete, IsCahpsDispositionInComplete)
	values (@cahpsdispositionid, @hospiceId, @label, 0, 0)

SELECT [CahpsDispositionID]
      ,[CahpsTypeID]
      ,[Label]
      ,[IsCahpsDispositionComplete]
      ,[IsCahpsDispositionInComplete]
  FROM [dbo].[CahpsDisposition]
where cahpstypeid=@hospiceId


commit tran

SET @dispositionid  = 24 /* get the disposition id from QP_Prod.Disposition -- the one we just added */

begin tran


update t
set Cahpshierarchy = Cahpshierarchy + 1
from cahpsdispositionmapping t
where CahpsTypeID =  @hospiceId
and CahpsHierarchy >= 10



SELECT [CahpsTypeID]
      ,[DispositionID]
      ,[ReceiptTypeID]
      ,[Label]
      ,[CahpsDispositionID]
      ,[CahpsHierarchy]
      ,[IsDefaultDisposition]
  FROM [dbo].[CahpsDispositionMapping]
  where cahpstypeid=@hospiceId
  order by cahpshierarchy,CahpsDispositionID

commit tran

--rollback tran


begin tran

	insert into cahpsdispositionmapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
	values (@hospiceId, 24 , -1, @label, @cahpsdispositionid, 10, 0)


SELECT [CahpsTypeID]
      ,[DispositionID]
      ,[ReceiptTypeID]
      ,[Label]
      ,[CahpsDispositionID]
      ,[CahpsHierarchy]
      ,[IsDefaultDisposition]
  FROM [dbo].[CahpsDispositionMapping]
  where cahpstypeid=@hospiceId


commit tran

--rollback tran


--select *
--from cahpsdisposition
--where CahpsTypeID = @hospiceId


--select *
--from cahpsdispositionmapping
--where CahpsTypeID = @hospiceId
--order by CahpsHierarchy desc, Label

go