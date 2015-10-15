/*

	S36 US17 Hospice - Disavowal Disposition	As an authorized Hospice CAHPS vendor, we need to add a new disposition for Hospice Disavowal, so that we can assign & report it when appropriate.

	Tim Butler

	insert into disposition
	update hierarchies in SurveyTypeDispositions
	insert into SurveyTypeDispositions
	INSERT INTO [dbo].[DispositionListDef] -- this adds the disposition to the dropdown in Qualisys Explorer

*/

use qp_prod

go

begin tran

DECLARE @SurveyType_ID int
select @SurveyType_ID = SurveyType_ID from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

declare @disposition_id int = 52

/* create new disposition code -- Disavowal */
if not exists (select * from disposition where strReportLabel='Facility Disavowal')
begin
	SET IDENTITY_INSERT disposition ON
	insert into disposition (disposition_id,strDispositionLabel,Action_id,strReportLabel,MustHaveResults) 
	values (@disposition_id,'Recipient disavows knowledge or use of facility',5,'Facility Disavowal',0)
	SET IDENTITY_INSERT disposition OFF
end

if not exists (select * from SurveyTypeDispositions where Disposition_ID = @disposition_id)
begin

	update t
	set hierarchy = hierarchy + 1
	from SurveyTypeDispositions t
	where t.SurveyType_ID = @SurveyType_ID
	and Hierarchy >= 3

	insert into SurveyTypeDispositions (disposition_id, value, hierarchy, [desc], ExportReportResponses, surveytype_id)
	values (@disposition_id, 15, 3, 'Non-Response: Hospice Disavowal', 0, @SurveyType_ID)

end


IF NOT EXISTS (SELECT 1 FROM [dbo].[DispositionListDef] WHERE [DispositionList_id] = 1 AND [Disposition_id] = @Disposition_id)
BEGIN

	INSERT INTO [dbo].[DispositionListDef]
			   ([DispositionList_id]
			   ,[Disposition_id]
			   ,[Author]
			   ,[datOccurred])
		 VALUES
			   (1
			   ,@disposition_id
			   ,948
			   ,getDate())

END

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
