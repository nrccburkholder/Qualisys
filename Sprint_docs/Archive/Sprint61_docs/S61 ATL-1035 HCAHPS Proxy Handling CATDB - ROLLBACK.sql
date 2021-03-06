/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S61 ATL-1035 HCAHPS Proxy Handling

	As an authorized HCAHPS vendor, we need to disposition proxy surveys as refusals, so that we comply with protocols.

	Tim Butler

	Link proxy dispo to HCAHPS survey type in SurveyTypeDispositions & connect to HCAHPS refusal disposition value.

*/

use NRC_Datamart


select *
FROM [dbo].[CahpsType]

select * from dbo.Disposition

DECLARE @CahpsTypeID int

SELECT @CahpsTypeID = [CahpsTypeID]
  FROM [dbo].[CahpsType]
  WHERE [Label] = 'HCAHPS Inpatient'




	DECLARE @DispositionID int

	SELECT @DispositionID = DispositionID
	from dbo.Disposition where Label = 'Proxy Return'

	begin tran

	if exists (select 1 from CahpsDispositionMapping where CahpsTypeID = @ACOCahpsTypeID and DispositionID = @DispositionID)
	begin

		delete from CahpsDispositionMapping where CahpsTypeID = @ACOCahpsTypeID and DispositionID = @DispositionID

		update t
			set Cahpshierarchy = 11
		from cahpsdispositionmapping t
		where CahpsTypeID =   @CahpsTypeID
		and DispositionID in (5,14,16)		
	end

	commit tran



select *
from dbo.Disposition

GO

