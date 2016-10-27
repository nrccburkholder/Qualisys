CREATE PROCEDURE [QualisysStudy].[AddClientToProcessingQueue]
	@ExtractClientStudyID INT, @RunTypeID INT, @StartDate VARCHAR(20), @EndDate VARCHAR(20), @OnDemandRequestID INT, @Study_ID INT

AS
BEGIN
	DECLARE @QID INT;

	WITH qID AS
	(

		SELECT q.QueueID, ISNULL(COUNT(ProcessingQueueID),0) QueueCount
		FROM [QualisysStudy].[Queue] q
		LEFT JOIN [QualisysStudy].[ProcessingQueue] pq ON q.QueueID = pq.QueueID
		WHERE pq.Processed = 0
		GROUP By q.QueueID HAVING COUNT(pq.ProcessingQueueID) > 1
	), tQ AS
	(
		SELECT q.QueueID, ISNULL(QueueCount,0) AS QueueCount
		FROM [QualisysStudy].[Queue] q
		LEFT JOIN qID t ON q.QueueID = t.QueueID
		--WHERE t.QueueID IS NULL
	)

	SELECT TOP 1 @QID = QueueID
	FROM tQ
	ORDER BY QueueCount ASC, QueueID ASC


	SELECT @QID = ISNULL(@QID,0)

	IF @QID != 0
	BEGIN
		WITH x AS
		(
			SELECT @QID [QueueID]
			, NULL [QueueLogID]
			, @ExtractClientStudyID [ExtractClientStudyID]
			, @Study_ID [Study_ID]
			, @RunTypeID [RunTypeID]
			, @StartDate [StartDate]
			, @EndDate [EndDate]
			, 0 [Processed]
			, GETDATE() [CreateDate]
		)

		INSERT INTO [QualisysStudy].[ProcessingQueue]
           ([QueueID],[QueueLogID],[ExtractClientStudyID], [Study_ID], [RunTypeID], [StartDate], [EndDate], [Processed], [CreateDate])
		SELECT x.[QueueID]
			, x.[QueueLogID]
			, x.[ExtractClientStudyID]
			, x.[Study_ID]
			, x.[RunTypeID]
			, x.[StartDate]
			, x.[EndDate]
			, x.[Processed]
			, x.[CreateDate]
		FROM x
		LEFT JOIN [QualisysStudy].[ProcessingQueue] pq ON x.ExtractClientStudyID = pq.ExtractClientStudyID AND x.Processed = pq.Processed
		WHERE pq.ProcessingQueueID IS NULL

		UPDATE [QualisysStudy].[OnDemandRequest]
		   SET [Processed] = 1
		 WHERE OnDemandRequestID = @OnDemandRequestID

	END

END
