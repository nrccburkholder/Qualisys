/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S57 ATL-744 OAS Proxy Surveys
	As an approved OAS CAHPS vendor, we need to exclude returns completed by proxies from submission, so that we comply with CAHPS requirements.

	ATL-777 Add logic to the catalyst etl OAS post-processing procedure


	Returned mail survey w/ Q37 = "answered for me" has proxy dispo in disposition logs.
	Response to Q36 (did someone help) has no impact.
	Neither complete nor partial dispositions should be final dispo.
	If no other dispos, final should be "refusal"
	If other dispos (e.g. incapacitated), the highest ranking should be final.

	Tim Butler


	insert into SurveyTypeDispositions

*/


USE QP_PROD
GO

declare @surveytype_id int 

SELECT @surveytype_id = SurveyType_id
FROM dbo.SurveyType
WHERE SurveyType_dsc = 'OAS CAHPS'

declare @proxyId int
select @proxyId = disposition_id from disposition where strdispositionlabel = 'Proxy Return'


if exists(select 1 from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @proxyId)
begin

	begin tran

		update t
		set hierarchy = hierarchy - 1
		from SurveyTypeDispositions t
		where t.SurveyType_ID = @SurveyType_ID
		and Hierarchy >= 7

		delete from dbo.SurveyTypeDispositions
		where Disposition_ID = @proxyId
		and SurveyType_ID = @surveytype_id

	commit tran

end

select *
from SurveyTypeDispositions
where SurveyType_ID = @surveytype_id
order by Hierarchy

GO