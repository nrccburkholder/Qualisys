
CREATE PROCEDURE [ETL].[CheckArchiveState]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	DECLARE @ArchiveState VARCHAR(50) = '0';
	DECLARE @TaskCode VARCHAR(50) = '0';
	DECLARE @ArchiveRunID INT = 0;

	SELECT	  @ArchiveState = s.[State]
			, @TaskCode = nt.[TaskCode]
			, @ArchiveRunID = r.ArchiveRunID
	FROM [ETL].[ArchiveRun] r
	INNER JOIN [ETL].[ArchiveState] s ON r.ArchiveStateID = s.ArchiveStateID 
	INNER JOIN [ETL].ArchiveTask ct ON ct.ArchiveTaskID = r.ArchiveTaskID AND ct.[Type] = 'A'
	INNER JOIN [ETL].ArchiveTask nt ON ct.ArchiveTaskID = nt.ParentTask AND nt.[Type] = 'A'
	WHERE r.ArchiveRunID = (SELECT Max(ArchiveRunID) FROM [ETL].[ArchiveRun] WHERE [Type] = 'A' AND [EndDateTime] IS NULL AND ArchiveStateID NOT IN (3,5)) --(Error,Invalid Run)
		AND r.[Type] = 'A'

	IF @ArchiveState = '0'
	BEGIN

		/****** Script for SelectTopNRows command from SSMS  ******/
	SELECT @ArchiveState = [State]
			, @TaskCode = ''
			, @ArchiveRunID = r.ArchiveRunID
		FROM [ETL].[ArchiveRun] r
		INNER JOIN [ETL].[ArchiveState] s ON r.ArchiveStateID = s.ArchiveStateID
		WHERE r.ArchiveRunID = (SELECT Max(ArchiveRunID) FROM [ETL].[ArchiveRun] WHERE [Type] = 'A' )
			AND [Type] = 'A'
	END


	SELECT @ArchiveState AS ArchiveState, @TaskCode AS TaskCode, @ArchiveRunID AS ArchiveRunID
END
