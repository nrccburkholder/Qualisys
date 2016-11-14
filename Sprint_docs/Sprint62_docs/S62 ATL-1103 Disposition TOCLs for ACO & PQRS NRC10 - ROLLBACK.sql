/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S62 ATL-1103
	Disposition TOCLs for ACO & PQRS

	As an authorized vendor for ACO & PQRS, we need to disposition records that didn't generate due to TOCL as "40 - excluded from survey", so that we submit accurate data.

	Tim Butler

	Insert new 'TOCL during Generation' disposition and SurveyTypeDispositions.


*/

USE [QP_Prod]
GO


DECLARE @Disposition_id int
DECLARE @label varchar(100) = 'TOCL During Generation'


SELECT @Disposition_id = Disposition_id FROM [dbo].[Disposition] WHERE [strDispositionLabel] = @label


DECLARE @Surveytype_id int

SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'ACOCAHPS'


if exists(select 1 from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id)
begin
		DELETE from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id
end


SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'PQRS CAHPS'


if exists(select 1 from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id)
begin
	DELETE from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id
end


IF EXISTS (SELECT 1 FROM [dbo].[Disposition] WHERE [Disposition_id] = @Disposition_id)
BEGIN

	DELETE FROM [dbo].[Disposition] WHERE [Disposition_id] = @Disposition_id
	
END




select * from dbo.SurveyTypeDispositions

where surveytype_id in (10,13)
order by SurveyType_ID, Hierarchy


SELECT *
FROM [dbo].[Disposition] 


go


DECLARE @Disposition_id int

select @Disposition_id = max(disposition_id)  FROM [dbo].[Disposition]

DBCC CHECKIDENT ('dbo.Disposition', RESEED, @Disposition_id)