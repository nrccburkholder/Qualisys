/*

	S61 ATL-1035 HCAHPS Proxy Handling

	As an authorized HCAHPS vendor, we need to disposition proxy surveys as refusals, so that we comply with protocols.

	Tim Butler

	Link proxy dispo to HCAHPS survey type in SurveyTypeDispositions & connect to HCAHPS refusal disposition value.


*/

USE [QP_Prod]
GO


DECLARE @Disposition_id int

SELECT @Disposition_id = Disposition_id FROM [dbo].[Disposition] WHERE [strDispositionLabel] = 'Proxy Return'


DECLARE @Surveytype_id int

SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'HCAHPS IP'


if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id)
begin

		update t
		set hierarchy = 13
		from SurveyTypeDispositions t
		where t.SurveyType_ID = @SurveyType_ID
		and Hierarchy = 12
	
		insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
		values (@Disposition_id, '07', 12,'Proxy Return',0,NULL, @surveytype_id)

end

GO


select * from dbo.SurveyTypeDispositions
where surveytype_id = 2
order by Hierarchy

GO


