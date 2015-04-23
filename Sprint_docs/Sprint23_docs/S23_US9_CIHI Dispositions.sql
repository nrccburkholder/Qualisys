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

SELECT * INTO #STD
FROM (
SELECT N'8' AS [Disposition_ID], N'03' AS [Value], 1 AS [Hierarchy], N'Not in Eligible Population' AS [Desc], N'0' AS [ExportReportResponses], NULL AS [ReceiptType_ID], N'12' AS [SurveyType_ID] UNION ALL
SELECT N'3' AS [Disposition_ID], N'02' AS [Value], 2 AS [Hierarchy], N'Ineligible - Deceased' AS [Desc], N'0' AS [ExportReportResponses], NULL AS [ReceiptType_ID], N'12' AS [SurveyType_ID] UNION ALL
SELECT N'13' AS [Disposition_ID], N'01' AS [Value], 3 AS [Hierarchy], N'Complete and Valid Survey' AS [Desc], N'1' AS [ExportReportResponses], NULL AS [ReceiptType_ID], N'12' AS [SurveyType_ID] UNION ALL
SELECT N'11' AS [Disposition_ID], N'06' AS [Value], 4 AS [Hierarchy], N'Mail/Phone or IVR is not complete' AS [Desc], N'0' AS [ExportReportResponses], NULL AS [ReceiptType_ID], N'12' AS [SurveyType_ID] UNION ALL
SELECT N'10' AS [Disposition_ID], N'04' AS [Value], 5 AS [Hierarchy], N'Language Barrier' AS [Desc], N'0' AS [ExportReportResponses], NULL AS [ReceiptType_ID], N'12' AS [SurveyType_ID] UNION ALL
SELECT N'4' AS [Disposition_ID], N'05' AS [Value], 6 AS [Hierarchy], N'Mental/Physical Incapacitation' AS [Desc], N'0' AS [ExportReportResponses], NULL AS [ReceiptType_ID], N'12' AS [SurveyType_ID] UNION ALL
SELECT N'14' AS [Disposition_ID], N'10' AS [Value], 7 AS [Hierarchy], N'Non Response Bad Phone' AS [Desc], N'0' AS [ExportReportResponses], NULL AS [ReceiptType_ID], N'12' AS [SurveyType_ID] UNION ALL
SELECT N'16' AS [Disposition_ID], N'10' AS [Value], 8 AS [Hierarchy], N'Non Response Bad Phone' AS [Desc], N'0' AS [ExportReportResponses], NULL AS [ReceiptType_ID], N'12' AS [SurveyType_ID] UNION ALL
SELECT N'5' AS [Disposition_ID], N'09' AS [Value], 9 AS [Hierarchy], N'Non Response Bad Address' AS [Desc], N'0' AS [ExportReportResponses], NULL AS [ReceiptType_ID], N'12' AS [SurveyType_ID] UNION ALL
SELECT N'2' AS [Disposition_ID], N'07' AS [Value], 10 AS [Hierarchy], N'Patient Refused' AS [Desc], N'0' AS [ExportReportResponses], NULL AS [ReceiptType_ID], N'12' AS [SurveyType_ID] UNION ALL
SELECT N'15' AS [Disposition_ID], N'08' AS [Value], 11 AS [Hierarchy], N'CAHPS Mailed Late' AS [Desc], N'0' AS [ExportReportResponses], NULL AS [ReceiptType_ID], N'12' AS [SurveyType_ID] UNION ALL
SELECT N'12' AS [Disposition_ID], N'08' AS [Value], 12 AS [Hierarchy], N'Maximum Attempts on Phone or Mail' AS [Desc], N'0' AS [ExportReportResponses], NULL AS [ReceiptType_ID], N'12' AS [SurveyType_ID]) t;


delete t 
--SELECT t.[Disposition_ID], t.[Value], t.[Hierarchy], t.[Desc], t.[ExportReportResponses], t.[ReceiptType_ID], t.[SurveyType_ID]
FROM #STD t
inner join SurveyTypeDispositions p on t.[Disposition_ID]=p.[Disposition_ID] and t.[SurveyType_ID]=p.[SurveyType_ID]

insert into SurveyTypeDispositions ([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])
select [Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID]
from #STD
order by [Hierarchy], [Value]

DROP TABLE #STD
GO

