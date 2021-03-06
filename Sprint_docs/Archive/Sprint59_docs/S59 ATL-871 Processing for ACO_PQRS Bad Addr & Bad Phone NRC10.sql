/*

	S59 ATL-871
	Processing for ACO/PQRS Bad Addr & Bad Phone

	As an authorized vendor, we need to update disposition processing for ACO & PQRS so the disposition 35 -
	Bad Address and Bad Phone is only assigned when we have both a bad address AND a bad phone, so that we comply with updated requirements.

	Tim Butler

	Insert new 'Bad address and bad phone' disposition


*/

USE [QP_Prod]
GO


DECLARE @Disposition_id int

SELECT @Disposition_id = Disposition_id FROM [dbo].[Disposition] WHERE [strDispositionLabel] = 'Bad address and bad phone'


IF NOT EXISTS (SELECT 1 FROM [dbo].[Disposition] WHERE [strDispositionLabel] = 'Bad address and bad phone')
BEGIN

	INSERT INTO [dbo].[Disposition]
			   ([strDispositionLabel]
			   ,[Action_id]
			   ,[strReportLabel]
			   ,[MustHaveResults])
		 VALUES
			   ('Bad address and bad phone'
			   ,0
			   ,'Bad address and bad phone'
			   ,0)

	SET @Disposition_id = SCOPE_IDENTITY()
	
END
ELSE SELECT @Disposition_id = Disposition_id FROM [dbo].[Disposition] WHERE [strDispositionLabel] = 'Bad address and bad phone'




DECLARE @Surveytype_id int

SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'ACOCAHPS'


if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id)
begin

		update t
		set hierarchy = 13
		from SurveyTypeDispositions t
		where t.SurveyType_ID = @SurveyType_ID
		and Hierarchy = 11
	

		insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
		values (@Disposition_id, 35, 11,'Bad address and bad phone',0,NULL, @surveytype_id)

end


SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'PQRS CAHPS'


if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id)
begin

		update t
		set hierarchy = 13
		from SurveyTypeDispositions t
		where t.SurveyType_ID = @SurveyType_ID
		and Hierarchy = 11

		insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
		values (@Disposition_id, 35, 11,'Bad address and bad phone',0,NULL, @surveytype_id)

end

GO


select * from dbo.SurveyTypeDispositions
where surveytype_id in (10,13)
order by SurveyType_ID, Hierarchy

GO

SELECT *
FROM [dbo].[Disposition] 

GO