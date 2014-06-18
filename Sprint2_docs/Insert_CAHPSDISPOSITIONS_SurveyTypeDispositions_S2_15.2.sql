use QP_Prod

/*

1	NRC/Picker
2	HCAHPS IP
3	Home Health CAHPS
4	CGCAHPS
5	Physician
6	Employee
10	ACOCAHPS

*/

BEGIN Transaction T1


INSERT INTO [dbo].SurveyTypeDispositions
SELECT [Disposition_ID]
      ,[ACOCAHPSValue] 
      ,[ACOCAHPSHierarchy]
      ,[ACOCAHPSDesc] 
	  ,NULL
      ,[ExportReportResponses]
	  ,10
  FROM [dbo].[ACOCAHPSDispositions]

INSERT INTO [dbo].SurveyTypeDispositions
SELECT [Disposition_ID]
      ,[HCAHPSValue]
      ,[HCAHPSHierarchy]
	  ,[HCAHPSDesc]
      ,NULL
      ,[ExportReportResponses]
	  ,2
  FROM [dbo].[HCAHPSDispositions]

INSERT INTO [dbo].SurveyTypeDispositions
SELECT [Disposition_ID]
      ,[HHCAHPSValue]
      ,[HHCAHPSHierarchy]
      ,[HHCAHPSDesc]
	  ,[ReceiptType_ID]
      ,[ExportReportResponses]
	  ,3
  FROM [dbo].[HHCAHPSDispositions]

  INSERT INTO [dbo].SurveyTypeDispositions
SELECT [Disposition_ID]
      ,[MNCMValue]
      ,[MNCMHierarchy]
      ,[MNCMDesc]
	  ,[ReceiptType_ID]
      ,[ExportReportResponses]
	  ,4
  FROM [dbo].[MNCMDispositions]


SELECT *
FROM [dbo].SurveyTypeDispositions
order by surveytype_id, hierarchy

/*

rollback transaction T1

*/

/*

Commit Transaction T1

*/