







CREATE VIEW [dbo].[v_ArchiveRunDetails]
AS
SELECT DISTINCT 
t.ArchiveTaskID, t.Task, t.TaskCode
			,d.StartDateTime AS TaskStartTime, d.EndDateTime AS TaskEndTime
			,DATEDIFF(MILLISECOND, d.StartDateTime, d.EndDateTime) AS 'TaskDuration (MS)'
			, d.TaskCount
			,ar.ArchiveRunID,  ar.StartDateTime AS ArchiveStartTime, ar.EndDateTime AS ArchiveEndTime
			,DATEDIFF(MILLISECOND, ar.StartDateTime, ar.EndDateTime) AS 'RunDuration (MS)'
			, ar.[State]
			, d.[ArchiveRunDetailsID]
FROM           dbo.v_ArchiveRun ar 
INNER JOIN		[ETL].[ArchiveRunDetails] d ON ar.ArchiveRunID = d.ArchiveRunID
INNER JOIN		[ETL].[ArchiveTask] t ON d.ArchiveTaskID = t.ArchiveTaskID AND t.[Type] = 'A'












