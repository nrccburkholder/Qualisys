/*

	S36 US17 Hospice - Disavowal Disposition	As an authorized Hospice CAHPS vendor, we need to add a new disposition for Hospice Disavowal, so that we can assign & report it when appropriate.

	Tim Butler

	insert into disposition
	update hierarchies in SurveyTypeDispositions
	insert into SurveyTypeDispositions
	INSERT INTO [dbo].[DispositionListDef] -- this adds the disposition to the dropdown in Qualisys Explorer

	ROLLBACK

*/

use qp_prod

go

begin tran

DECLARE @SurveyType_ID int
select @SurveyType_ID = SurveyType_ID from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

declare @disposition_id int = 52

if exists (select * from SurveyTypeDispositions where Disposition_ID = @disposition_id)
begin
	update t
	set hierarchy = hierarchy - 1
	from SurveyTypeDispositions t
	where t.SurveyType_ID = @SurveyType_ID
	and Hierarchy >= 4

	select * from SurveyTypeDispositions where Disposition_ID = @disposition_id
end

delete from [dbo].[DispositionListDef]
where disposition_id = @disposition_id


delete from disposition 
where disposition_id = @disposition_id

commit tran

select *
from Disposition where Disposition_id = @disposition_id

select *
from SurveyTypeDispositions
where surveytype_id = @SurveyType_ID
order by Hierarchy

SELECT dld.*, d.*
FROM [QP_Prod].[dbo].[DispositionListDef] dld
inner join [QP_Prod].DBO.Disposition d on (d.Disposition_id = dld.Disposition_id)
where DispositionList_id = 1



GO
