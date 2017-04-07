
CREATE PROCEDURE [ETL].[CheckRecoverState]
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
	INNER JOIN [ETL].ArchiveTask ct ON ct.ArchiveTaskID = r.ArchiveTaskID AND ct.[Type] = 'R'
	INNER JOIN [ETL].ArchiveTask nt ON ct.ArchiveTaskID = nt.ParentTask AND nt.[Type] = 'R'
	WHERE r.ArchiveRunID = (SELECT Max(ArchiveRunID) FROM [ETL].[ArchiveRun] WHERE [Type] = 'R' AND [EndDateTime] IS NULL AND ArchiveStateID NOT IN (3,5)) --(Error,Invalid Run)
		AND r.[Type] = 'R'

	IF @ArchiveState = '0'
	BEGIN

		/****** Script for SelectTopNRows command from SSMS  ******/
	SELECT @ArchiveState = [State]
			, @TaskCode = ''
			, @ArchiveRunID = r.ArchiveRunID
		FROM [ETL].[ArchiveRun] r
		INNER JOIN [ETL].[ArchiveState] s ON r.ArchiveStateID = s.ArchiveStateID
		WHERE r.ArchiveRunID = (SELECT Max(ArchiveRunID) FROM [ETL].[ArchiveRun] WHERE [Type] = 'R' )
			AND [Type] = 'R'
	END


	SELECT @ArchiveState AS ArchiveState, @TaskCode AS TaskCode, @ArchiveRunID AS ArchiveRunID
END

