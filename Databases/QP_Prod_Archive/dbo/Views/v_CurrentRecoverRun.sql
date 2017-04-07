




CREATE VIEW [dbo].[v_CurrentRecoverRun]
AS
SELECT        ar.ArchiveRunID, ar.EndDateTime, ar.StartDateTime, ar.TaskCompleteTime, s.[State], t.TaskCode, t.Task, pt.TaskCode AS PrevTaskCode, pt.Task AS PrevTask
FROM            ETL.ArchiveRun ar 
INNER JOIN		ETL.ArchiveState s ON ar.ArchiveStateID = s.ArchiveStateID 
LEFT JOIN		ETL.ArchiveTask t ON ar.ArchiveTaskID = t.ArchiveTaskID AND t.[Type]='R'
LEFT JOIN		ETL.ArchiveTask pt ON t.ParentTask = pt.ArchiveTaskID AND pt.[Type]='R'
WHERE ar.ArchiveRunID = (SELECT Max(ArchiveRunID) FROM [ETL].[ArchiveRun] WHERE [Type]='R')
	AND ar.[Type] = 'R'







