CREATE PROCEDURE [QualisysStudy].[GetAllRequests]
--EXEC [QualisysStudy].[GetAllRequests]
AS
BEGIN

	DECLARE @RunTypeID1 INT;
	SELECT @RunTypeID1 = RunTypeID FROM [QP_PROD_Extracts].[QualisysStudy].[RunType] rt WHERE rt.TypeName = 'Scheduled';
	DECLARE @RunTypeID2 INT;
	SELECT @RunTypeID2 = RunTypeID FROM [QP_PROD_Extracts].[QualisysStudy].[RunType] rt WHERE rt.TypeName = 'OnDemandRequest';




	WITH requests AS
	(
		SELECT odr.ExtractClientStudyID, ISNULL(c.Study_ID, -1) AS Study_ID, @RunTypeID2 AS RunTypeID, odr.CustomStartDate AS StartDate, odr.CustomEndDate AS EndDate, odr.OnDemandRequestID
		FROM [QP_PROD_Extracts].[QualisysStudy].[OnDemandRequest] odr
		INNER JOIN [QP_PROD_Extracts].[QualisysStudy].[ExtractClientStudy] c ON odr.ExtractClientStudyID = c.ExtractClientStudyID
		WHERE odr.Processed = 0 AND odr.ScheduleID IS NULL
		UNION
		SELECT odr.ExtractClientStudyID, ISNULL(c.Study_ID, -1) AS Study_ID, @RunTypeID2 AS RunTypeID, d2.StartDate, d2.EndDate, odr.OnDemandRequestID
		FROM [QP_PROD_Extracts].[QualisysStudy].[OnDemandRequest] odr
		INNER JOIN [QP_PROD_Extracts].[QualisysStudy].[ExtractClientStudy] c ON odr.ExtractClientStudyID = c.ExtractClientStudyID AND c.IsActive = 1
		INNER JOIN  [QP_PROD_Extracts].[QualisysStudy].[Schedule] s ON odr.[ScheduleID] = s.[ScheduleID]
		CROSS APPLY [QP_PROD_Extracts].[QualisysStudy].[fn_GetDateRange](s.Frequency, s.DatePartIncrement,s.DateOffSet, s.DateHour) d1
		INNER JOIN  [QP_PROD_Extracts].[QualisysStudy].[ReportingPeriodConfig] rpc ON odr.[ReportingPeriodConfigID] = rpc.[ReportingPeriodConfigID]
		CROSS APPLY [QP_PROD_Extracts].[QualisysStudy].[fn_FindStartEndDates](rpc.Frequency, rpc.StartDateOffSetDatePart, rpc.StartDateOffSetInc, rpc.EndDateOffSetDatePart, rpc.EndDateOffSetInc) d2
		WHERE odr.Processed = 0 AND odr.ScheduleID IS NOT NULL 
		UNION
		SELECT a.ExtractClientStudyID, ISNULL(a.Study_ID, -1) AS Study_ID, a.RunTypeID, a.StartDate, a.EndDate, -1 AS OnDemandRequestID
		FROM (SELECT c.ExtractClientStudyID, c.Study_ID, @RunTypeID1 AS RunTypeID, d2.StartDate, d2.EndDate --, d.CurrentDate, d.RunDate 
				FROM [QP_PROD_Extracts].[QualisysStudy].[ExtractClientStudy] c
				INNER JOIN  [QP_PROD_Extracts].[QualisysStudy].[Schedule] s ON c.[ScheduleID] = s.[ScheduleID]
				CROSS APPLY [QP_PROD_Extracts].[QualisysStudy].[fn_GetDateRange](s.Frequency, s.DatePartIncrement,s.DateOffSet, s.DateHour) d
				INNER JOIN  [QP_PROD_Extracts].[QualisysStudy].[ReportingPeriodConfig] rpc ON c.[ReportingPeriodConfigID] = rpc.[ReportingPeriodConfigID]
				CROSS APPLY [QP_PROD_Extracts].[QualisysStudy].[fn_FindStartEndDates](rpc.Frequency, rpc.StartDateOffSetDatePart, rpc.StartDateOffSetInc, rpc.EndDateOffSetDatePart, rpc.EndDateOffSetInc) d2
				WHERE CAST(d.CurrentDate AS DATE) = CAST(d.RunDate AS DATE) AND CAST(d.CurrentDate AS DATETIME) >= CAST(d.RunDate AS DATETIME) AND c.IsActive = 1) a
		LEFT JOIN [QP_PROD_Extracts].[QualisysStudy].[ExtractLog] el ON el.ExtractClientStudyID = a.ExtractClientStudyID AND CAST(el.ProcessingEndDT AS DATE) = CAST(GETDATE() AS DATE)
		LEFT JOIN (SELECT ExtractClientStudyID FROM [QP_PROD_Extracts].[QualisysStudy].[ProcessingQueue] WHERE Processed = 0) pq ON pq.ExtractClientStudyID = a.ExtractClientStudyID
		WHERE el.ExtractClientStudyID IS NULL AND pq.ExtractClientStudyID IS NULL 
	)


	SELECT ExtractClientStudyID, Study_ID, RunTypeID, CAST(StartDate AS VARCHAR(20)) AS StartDate, CAST(EndDate AS VARCHAR(20)) AS EndDate, OnDemandRequestID
	FROM requests

END
