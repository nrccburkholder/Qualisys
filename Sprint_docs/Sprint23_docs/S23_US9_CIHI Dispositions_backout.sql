/*
S23_US9	dispositions (fielding)	
	as a CIHI vendor we need to store dispositions for proper data submission

Dave Gilsdorf

T1 check for tables; confirm exist and create and populate as needed
	INSERT INTO SurveyTypeDispositions

T2 modify ETL
	alter table [dbo].[Subtype] add bitQuestionnaireRequired bit NOT NULL DEFAULT(0)
	UPDATE [dbo].[Subtype] bitQuestionnaireRequired value for PCMH Distinction


*/
USE [QP_Prod]
go
delete from SurveyTypeDispositions ([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])
select [Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID]
from #STD
order by [Hierarchy], [Value]

DROP TABLE #STD
GO

