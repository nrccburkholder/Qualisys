/*

	S62 ATL-1103
	Disposition TOCLs for ACO & PQRS

	As an authorized vendor for ACO & PQRS, we need to disposition records that didn't generate due to TOCL as "40 - excluded from survey", so that we submit accurate data.

	Tim Butler

	Insert new 'TOCL during Generation' disposition and SurveyTypeDispositions.


*/

USE [QP_Prod]
GO


begin tran

DECLARE @Disposition_id int
DECLARE @label varchar(100) = 'TOCL During Generation'


IF NOT EXISTS (SELECT 1 FROM [dbo].[Disposition] WHERE [strDispositionLabel] = @label)
BEGIN

	INSERT INTO [dbo].[Disposition]
			   ([strDispositionLabel]
			   ,[Action_id]
			   ,[strReportLabel]
			   ,[MustHaveResults])
		 VALUES
			   (@label
			   ,0
			   ,@label
			   ,0)

	SET @Disposition_id = SCOPE_IDENTITY()
	
END
ELSE SELECT @Disposition_id = Disposition_id FROM [dbo].[Disposition] WHERE [strDispositionLabel] = @label




DECLARE @Surveytype_id int

SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'ACOCAHPS'


if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id)
begin

		insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
		SELECT top 1 @Disposition_id, Value,Hierarchy,@label,ExportReportResponses,ReceiptType_ID,SurveyType_ID 
		FROM SurveyTypeDispositions WHERE SurveyType_ID = @Surveytype_id and Value = 40

end


SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'PQRS CAHPS'


if not exists(select 1 from SurveyTypeDispositions where SurveyType_ID = @surveytype_id and Disposition_ID = @Disposition_id)
begin

		insert into SurveyTypeDispositions (Disposition_ID, Value, Hierarchy, [Desc], ExportReportResponses, ReceiptType_ID, SurveyType_ID)
		SELECT top 1 @Disposition_id, Value,Hierarchy,@label,ExportReportResponses,ReceiptType_ID,SurveyType_ID 
		FROM SurveyTypeDispositions WHERE SurveyType_ID = @Surveytype_id and Value = 40

end

commit tran


select * from dbo.SurveyTypeDispositions
where surveytype_id in (10,13)
order by SurveyType_ID, Hierarchy



SELECT *
FROM [dbo].[Disposition] 

go
