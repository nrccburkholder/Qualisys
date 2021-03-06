/*

	S62 ATL-1103
	Disposition TOCLs for ACO & PQRS

	As an authorized vendor for ACO & PQRS, we need to disposition records that didn't generate due to TOCL as "40 - excluded from survey", so that we submit accurate data.

	ATL-1119 Create NRC disposition "TOCL during Generation" (QP_Prod & Catalyst)

	Tim Butle

*/

use NRC_Datamart

DECLARE @newDispositionID int
DECLARE @label varchar(100) = 'TOCL During Generation'

SELECT @newDispositionID = Disposition_id
from Qualisys.qp_prod.dbo.Disposition
where strDispositionLabel =  @label


DECLARE @ACOCahpsTypeID int

SELECT @ACOCahpsTypeID = [CahpsTypeID]
  FROM [dbo].[CahpsType]
  WHERE [Label] = 'ACOCAHPS'

DECLARE @PQRSCahpsTypeID int

SELECT @PQRSCahpsTypeID = [CahpsTypeID]
  FROM [dbo].[CahpsType]
  WHERE [Label] = 'PQRS CAHPS'


begin tran

if not exists (select 1 from dbo.Disposition where Label =  @label)
begin

	INSERT INTO [dbo].[Disposition]([DispositionID],[Label])VALUES(@newDispositionID, @label)

end

if not exists (select 1 from CahpsDispositionMapping where CahpsTypeID = @ACOCahpsTypeID and DispositionID = @newDispositionID)
begin

	insert into CahpsDispositionMapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
	select @ACOCahpsTypeID,@newDispositionID,ReceiptTypeID,@label,CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition 
	from CahpsDispositionMapping where CahpsTypeID =  @ACOCahpsTypeID and CahpsDispositionID =  CONVERT(INT,CONVERT(VARCHAR,@ACOCahpsTypeID) + '40')

end


if not exists (select 1 from CahpsDispositionMapping where CahpsTypeID = @PQRSCahpsTypeID and DispositionID = @newDispositionID)
begin

	insert into CahpsDispositionMapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
	select @PQRSCahpsTypeID,@newDispositionID,ReceiptTypeID,@label,CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition 
	from CahpsDispositionMapping where CahpsTypeID =  @PQRSCahpsTypeID and CahpsDispositionID =  CONVERT(INT,CONVERT(VARCHAR,@PQRSCahpsTypeID) + '40')
end

commit tran

GO

