/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S62 ATL-1103
	Disposition TOCLs for ACO & PQRS

	As an authorized vendor for ACO & PQRS, we need to disposition records that didn't generate due to TOCL as "40 - excluded from survey", so that we submit accurate data.

	ATL-1119 Create NRC disposition "TOCL during Generation" (QP_Prod & Catalyst)

	Tim Butler

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
		
	delete from CahpsDispositionMapping where CahpsTypeID = @ACOCahpsTypeID and DispositionID = @newDispositionID

	delete from CahpsDispositionMapping where CahpsTypeID = @PQRSCahpsTypeID and DispositionID = @newDispositionID

	DELETE FROM [dbo].[Disposition] where DispositionID = @newDispositionID

commit tran

GO





