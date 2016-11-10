CREATE PROCEDURE [QualisysStudy].[GetRequestsByQueue]
	@QueueID INT
AS
BEGIN


	SELECT DISTINCT pq.[ProcessingQueueID]
			  ,pq.[ExtractClientStudyID]
			  ,pq.[RunTypeID]
			  ,CAST(pq.[StartDate] AS VARCHAR(20)) [StartDate]
			  ,CAST(pq.[EndDate] AS VARCHAR(20)) [EndDate]
			  ,c.FolderPath
			  ,c.ClientFileName
			  ,c.AuxFileName
			  ,c.DefaultColumns
			  ,CAST(ISNULL(v.Client_ID, -1) AS VARCHAR(20)) AS Client_ID
			  ,CAST(pq.[Study_ID] AS VARCHAR(20)) [Study_ID]
			  ,c.FTPPath
	FROM [QP_PROD_Extracts].[QualisysStudy].[ProcessingQueue] pq
	INNER JOIN [QP_PROD_Extracts].[QualisysStudy].[ExtractClientStudy] c ON pq.ExtractClientStudyID = c.ExtractClientStudyID
	LEFT JOIN [QP_PROD].[dbo].[ClientStudySurvey_view] v ON c.Client_ID = v.Client_ID AND c.Study_ID = v.Study_ID
	WHERE QueueID =@QueueID AND Processed = 0


END
