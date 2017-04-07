





CREATE VIEW [dbo].[v_CurrentArchiveRun]
AS
SELECT        ar.ArchiveRunID, s.[State], ar.EndDateTime, ar.StartDateTime
				,DATEDIFF(MILLISECOND, ar.StartDateTime, ar.EndDateTime) AS 'RunDuration (MS)'
				, ar.TaskCompleteTime
				, t.TaskCode, t.Task, pt.TaskCode AS PrevTaskCode, pt.Task AS PrevTask
FROM            ETL.ArchiveRun ar 
INNER JOIN		ETL.ArchiveState s ON ar.ArchiveStateID = s.ArchiveStateID 
LEFT JOIN		ETL.ArchiveTask t ON ar.ArchiveTaskID = t.ArchiveTaskID AND t.[Type]='A'
LEFT JOIN		ETL.ArchiveTask pt ON t.ParentTask = pt.ArchiveTaskID  AND pt.[Type]='A'
WHERE ar.ArchiveRunID = (SELECT Max(ArchiveRunID) FROM [ETL].[ArchiveRun] WHERE [Type]='A')








