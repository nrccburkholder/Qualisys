/*

	S58 ATL-772 Add DRG Update Rollback to QLoader Rollbacks Tab

	As the Manager of Client Operations, I want to be able to initiate a DRG update rollback from the rollbacks tab in QLoader, so that I can roll back bad updates.

	Tim Butler

	CREATE PROCEDURE [dbo].[LD_SelectDRGUpdates]


*/

USE QP_Prod

GO

if exists (select * from sys.procedures where name = 'LD_SelectDRGUpdates')
	drop procedure LD_SelectDRGUpdates

GO

-- =============================================
-- Author:		Tim Butler
-- Create date: 2016.09.15
-- Description:	Returns a list of DRG updates that are not yet past the CMS submission date
-- =============================================
CREATE PROCEDURE [dbo].[LD_SelectDRGUpdates] @Study_ID int
AS
BEGIN


CREATE TABLE #Work (Study_id int, DataFile_id int, MinEncounterDate datetime, MaxEncounterDate datetime, bitRollback bit)

INSERT #Work
	SELECT ss.STUDY_ID, h.DataFile_ID, MIN(ss.SampleEncounterDate) as MinEncounterDate,  MAX(ss.SampleEncounterDate) as MaxEncounterDate, MAX(CONVERT(int,h.bitRollback))
		FROM dbo.HCAHPSUpdateLog h
		INNER JOIN SamplePop sp on h.samplepop_id = sp.SAMPLEPOP_ID
		INNER JOIN SELECTEDSAMPLE ss on ss.Sampleset_id = sp.Sampleset_id and ss.Pop_id = sp.Pop_id 
		INNER JOIN SampleUnit su on su.SampleUnit_id = ss.SampleUnit_id 
		where ISNULL(h.old_value,'NULL') <> ISNULL(h.new_value,'NULL')
		and h.DataFile_ID is not null
		and ss.STUDY_ID = @Study_ID
		GROUP BY ss.Study_id,h.DataFile_id


SELECT df.[DataFile_id]
		  ,df.[strOrigFile_nm] 
		  ,dfs.[StateDescription]
		  ,dfs.[Member_id]
		  ,dfs.StateParameter
		  ,CASE WHEN LEN(dfs.StateParameter) > 0 THEN dfs.StateParameter ELSE dfsh.[StateParameter] END LoadedBy
		  ,w.Study_id
		  ,w.MinEncounterDate
		  ,w.MaxEncounterDate
		  ,w.bitRollback
	  INTO #datafiles
	  FROM QLoader.QP_Load.[dbo].[DataFile] df
	  INNER JOIN #Work w on w.DataFile_id = df.DataFile_id
	  INNER JOIN QLoader.QP_Load.[dbo].[DataFileState] dfs on dfs.DataFile_id = df.DataFile_id
	  INNER JOIN QLoader.QP_Load.[dbo].[DataFileState_History] dfsh on dfsh.DataFile_id = df.DataFile_id and dfsh.State_id = 0
	  where ISDRGUpdate = 1
	  and dfs.StateDescription in ('DRGApplied','DRGRolledBack')

	DELETE df
	FROM #datafiles df
	INNER JOIN dbo.CMSDataSubmissionSchedule sub on sub.[month] = DATEPART(month,df.MinEncounterDate) and sub.[year] = DATEPART(year,df.MinEncounterDate) and sub.SurveyType_ID = 2
	WHERE sub.SubmissionDateClose < GETDATE()

	select Study_id, DataFile_id, MinEncounterDate, MaxEncounterDate,strOrigFile_nm, LoadedBy,  bitRollback, StateDescription as Status  from #datafiles

	IF OBJECT_ID('tempdb..#Work') IS NOT NULL DROP TABLE #Work 
	IF OBJECT_ID('tempdb..#datafiles') IS NOT NULL DROP TABLE #datafiles

END

GO



if exists (select * from sys.procedures where name = 'LD_UpdateFileStateDRG')
	drop procedure LD_UpdateFileStateDRG

GO


CREATE PROCEDURE [dbo].[LD_UpdateFileStateDRG] 
@DataFile_id INT,  
@State_id INT,  
@StateParameter VARCHAR(2000),  
@StateDescription VARCHAR(200),
@Member_ID INT  
AS
BEGIN

SET NOCOUNT ON
EXEC QLOADER.QP_LOAD.DBO.LD_UpdateFileStateDRG @DataFile_id,  @State_id,  @StateParameter,  @StateDescription, @Member_ID 


END

GO

