/*

	S61 ATL-1035 HCAHPS Proxy Handling

	As an authorized HCAHPS vendor, we need to disposition proxy surveys as refusals, so that we comply with protocols.

	Tim Butler

	Link proxy dispo to HCAHPS survey type in SurveyTypeDispositions & connect to HCAHPS refusal disposition value.

*/

use NRC_Datamart


DECLARE @CahpsTypeID int

SELECT @CahpsTypeID = [CahpsTypeID]
FROM [dbo].[CahpsType]
WHERE [Label] = 'HCAHPS Inpatient'

DECLARE @DispositionID int

SELECT @DispositionID = DispositionID
from dbo.Disposition where Label = 'Proxy Return'

declare @cahpsdispositionid varchar(3)
declare @label varchar(100)

select @cahpsdispositionid = cahpsdispositionid from cahpsdisposition where cahpstypeid=@CahpsTypeID and label ='Patient Refused'

begin tran

	if not exists (select 1 from CahpsDispositionMapping where CahpsTypeID = @CahpsTypeID and DispositionID = @DispositionID)
	begin

		update t
		set Cahpshierarchy = 12
		from cahpsdispositionmapping t
		where CahpsTypeID =   @CahpsTypeID
		and DispositionID = 12


		insert into CahpsDispositionMapping (CahpsTypeID, DispositionID, ReceiptTypeID, Label, CahpsDispositionID, CahpsHierarchy, IsDefaultDisposition)
		Select  @CahpsTypeID,@DispositionID,-1,'Proxy Return',@cahpsdispositionid,11,0
	end

commit tran


select *
from CahpsDispositionMapping
where CahpsTypeID = @cahpsTypeID
order by CahpsHierarchy

GO

