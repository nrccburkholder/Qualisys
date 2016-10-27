CREATE PROCEDURE [QualisysStudy].[GetExtractLogDetailSummary]
	@ExtractLogID INT
  --EXEC [QualisysStudy].[GetExtractLogDetailSummary]

AS
 SET NOCOUNT ON
 
  BEGIN 
		
	SELECT DISTINCT 
		
		 c.[ClientFileName]
		, d.Study_ID
		, AuxFileName AS [Name]
		, CAST(d.SamplePopCount AS VARCHAR(20)) AS [SamplePopCount]
		, CAST(d.ResponseDataCount  AS VARCHAR(20)) AS [SResponseDataCount]
		, CAST(d.StartDate AS VARCHAR(20)) AS [StartDate]
		, CAST(d.EndDate AS VARCHAR(20)) AS [EndDate]
		, CAST(ProcessingEndDT  AS VARCHAR(30)) AS [CreateDate]
		,d.ExtractLogID
	FROM [QualisysStudy].[ExtractLog] d
	INNER JOIN [QP_PROD_Extracts].[QualisysStudy].[ExtractClientStudy] c ON d.ExtractClientStudyID = c.ExtractClientStudyID
	WHERE d.ExtractLogID =  @ExtractLogID

	--SELECT N'ClientFileName,Study_ID,FileName,SamplePopCount,ResponseDataCount,StartDate,EndDate,CreateDate,ExtractLogID-' + CAST(@ExtractLogID AS nVARCHAR(10))
	--UNION 
	--SELECT DISTINCT 
	--	 CAST(c.[ClientFileName] AS nVARCHAR(20)) + ',' +
	--	 CAST(d.Study_ID AS nVARCHAR(20)) + ',' +
	--	 CAST(AuxFileName AS nVARCHAR(20)) + ',' +
	--	 CAST(d.SamplePopCount AS nVARCHAR(20)) + ',' + 
	--	 CAST(d.ResponseDataCount AS nVARCHAR(20))  + ',' +
	--	 CAST(d.StartDate AS nVARCHAR(20)) + ',' +
	--	 CAST(d.EndDate AS nVARCHAR(20)) + ',' +
	--	 CAST(ProcessingEndDT  AS nVARCHAR(30)) + ',' +
	--	 CAST(d.ExtractLogID AS nVARCHAR(20))
	--FROM [QualisysStudy].[ExtractLog] d
	--INNER JOIN [QP_PROD_Extracts].[QualisysStudy].[ExtractClientStudy] c ON d.ExtractClientStudyID = c.ExtractClientStudyID
	--WHERE d.ExtractLogID =  @ExtractLogID
	

 END
--EXEC [QualisysStudy].[GetExtractLogDetailSummary] 64
