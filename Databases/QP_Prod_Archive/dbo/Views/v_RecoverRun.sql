


CREATE VIEW [dbo].[v_RecoverRun]
AS
SELECT       rr.ArchiveRunID, rr.EndDateTime, rr.StartDateTime
			,DATEDIFF(MILLISECOND, rr.StartDateTime, rr.EndDateTime) AS 'RunDuration (MS)'
			, rr.TaskCompleteTime, ast.[State], at.TaskCode, at.Task
FROM            ETL.ArchiveRun rr
INNER JOIN		ETL.ArchiveState ast ON rr.ArchiveStateID = ast.ArchiveStateID 
INNER JOIN	    ETL.ArchiveTask at ON rr.ArchiveTaskID = at.ArchiveTaskID AND at.[Type]='R'
WHERE rr.[Type] = 'R'





