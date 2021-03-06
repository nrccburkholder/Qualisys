/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

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

IF EXISTS (SELECT 1 FROM [dbo].[Disposition] WHERE [strDispositionLabel] = 'Bad address and bad phone')
BEGIN

	SELECT @Disposition_id = Disposition_id FROM [dbo].[Disposition] WHERE [strDispositionLabel] = 'Bad address and bad phone'

	DECLARE @Surveytype_id int

	SELECT @Surveytype_id = SurveyType_id
	from SurveyType
	WHERE SurveyType_dsc = 'ACOCAHPS'


	if exists(select 1 from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id)
	begin

		update t
		set hierarchy = hierarchy - 1
		from SurveyTypeDispositions t
		where t.SurveyType_ID = @SurveyType_ID
		and Hierarchy = 13
	
		delete from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id


	end


	SELECT @Surveytype_id = SurveyType_id
	from SurveyType
	WHERE SurveyType_dsc = 'PQRS CAHPS'


	if exists(select 1 from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id)
	begin

		update t
		set hierarchy = 11
		from SurveyTypeDispositions t
		where t.SurveyType_ID = @SurveyType_ID
		and Hierarchy = 13
	
		delete from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id

	end


	DELETE FROM [dbo].[Disposition] WHERE [strDispositionLabel] = 'Bad address and bad phone'

	declare @maxID int
	select @maxID=max(Disposition_id) from dbo.Disposition 
	DBCC CHECKIDENT ('Disposition', RESEED, @maxID)

END



GO

select * from dbo.SurveyTypeDispositions
where surveytype_id in (10,13)
order by SurveyType_ID, Hierarchy

GO

SELECT *
FROM [dbo].[Disposition] 

GO


