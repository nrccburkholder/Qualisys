use QP_Prod


--truncate table  [dbo].SurveyTypeDispositions
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
      ,[ExportReportResponses]
	  ,NULL
	  ,10
  FROM [dbo].[ACOCAHPSDispositions]

INSERT INTO [dbo].SurveyTypeDispositions
SELECT [Disposition_ID]
      ,[HCAHPSValue]
      ,[HCAHPSHierarchy]
	  ,[HCAHPSDesc]    
      ,[ExportReportResponses]
	  ,NULL
	  ,2
  FROM [dbo].[HCAHPSDispositions]

INSERT INTO [dbo].SurveyTypeDispositions
SELECT [Disposition_ID]
      ,[HHCAHPSValue]
      ,[HHCAHPSHierarchy]
      ,[HHCAHPSDesc]  
      ,[ExportReportResponses]
	  ,[ReceiptType_ID]
	  ,3
  FROM [dbo].[HHCAHPSDispositions]

  INSERT INTO [dbo].SurveyTypeDispositions
SELECT [Disposition_ID]
      ,[MNCMValue]
      ,[MNCMHierarchy]
      ,[MNCMDesc]	  
      ,[ExportReportResponses]
	  ,[ReceiptType_ID]
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