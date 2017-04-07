



CREATE VIEW [dbo].[v_ArchiveRun]
AS
SELECT        r.ArchiveRunID, r.StartDateTime, r.EndDateTime
			,DATEDIFF(MILLISECOND, r.StartDateTime, r.EndDateTime) AS 'RunDuration (MS)'
			, r.TaskCompleteTime, s.[State], t.TaskCode, t.Task
FROM            ETL.ArchiveRun r
INNER JOIN	ETL.ArchiveState s ON r.ArchiveStateID = s.ArchiveStateID 
INNER JOIN	ETL.ArchiveTask t ON r.ArchiveTaskID = t.ArchiveTaskID AND t.[Type]='A'
WHERE r.[Type]='A'





