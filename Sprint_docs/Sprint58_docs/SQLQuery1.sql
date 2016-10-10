

USE QP_Prod

GO

IF OBJECT_ID('tempdb..#datafiles') IS NOT NULL DROP TABLE #datafiles
GO

--SELECT df.[DataFile_id]
--		  ,[strOrigFile_nm] 
--		  ,[IsDRGUpdate]
--		  ,[IsLoadToLive]
--		  ,dfs.[StateDescription]
--		  ,dfs.[Member_id]
--		  ,dfs.StateParameter
--		  ,CASE WHEN LEN(dfs.StateParameter) > 0 THEN dfs.StateParameter ELSE dfsh.[StateParameter] END LoadedBy
--	  INTO #datafiles
--	  FROM QLoader.QP_Load.[dbo].[DataFile] df
--	  INNER JOIN QLoader.QP_Load.[dbo].[DataFileState] dfs on dfs.DataFile_id = df.DataFile_id
--	  INNER JOIN QLoader.QP_Load.[dbo].[DataFileState_History] dfsh on dfsh.DataFile_id = df.DataFile_id and dfsh.State_id = 0
--	  where ISDRGUpdate = 1
--	  and dfs.StateDescription in ('DRGApplied','DRGRolledBack')

--GO

--select * from #datafiles

--GO

IF OBJECT_ID('tempdb..#Work') IS NOT NULL DROP TABLE #Work 

GO

CREATE TABLE #Work (Study_id int, DataFile_id int, MinEncounterDate datetime, MaxEncounterDate datetime, bitRollback bit)

--CREATE TABLE #Work (Study_id int, DataFile_id int, MinEncounterDate datetime, MaxEncounterDate datetime, origFileName varchar(100), LoadedBy varchar(100), bitRollback bit, StateDescription varchar(100))
GO

/*
delete h
--select top 100  *
FROM dbo.HCAHPSUpdateLog h
order by change_date desc
where h.Datafile_id = 3410
and bitRollback = 1

*/

DECLARE @Study_ID int = 4883

/*
update ss
SET SampleEncounterDate = '2016-04-30 00:00:00.000'
--select *
from dbo.SELECTEDSAMPLE ss
INNER JOIN SamplePop sp on ss.SAMPLESET_ID = sp.SAMPLESET_ID
where ss.study_id = 4886
and sp.SAMPLEPOP_ID = 100535091
and ss.Pop_id = sp.Pop_id 


select *
from dbo.SELECTEDSAMPLE ss
--INNER JOIN SamplePop sp on ss.SAMPLESET_ID = sp.SAMPLESET_ID
where ss.study_id = 4886

*/

--SELECT ss.STUDY_ID, h.DataFile_ID, ss.SampleEncounterDate , h.bitRollback, h.samplepop_id
--	--SELECT ss.STUDY_ID, h.DataFile_ID, MIN(ss.SampleEncounterDate) as MinEncounterDate,  MAX(ss.SampleEncounterDate) as MaxEncounterDate, df.strOrigFile_nm, df.LoadedBy, MAX(CONVERT(int,h.bitRollback)),df.StateDescription
--		FROM dbo.HCAHPSUpdateLog h
--		INNER JOIN SamplePop sp on h.samplepop_id = sp.SAMPLEPOP_ID
--		INNER JOIN SELECTEDSAMPLE ss on ss.Sampleset_id = sp.Sampleset_id and ss.Pop_id = sp.Pop_id 
--		INNER JOIN SampleUnit su on su.SampleUnit_id = ss.SampleUnit_id 
--		where ss.STUDY_ID = @Study_ID
--		and ISNULL(h.old_value,'NULL') <> ISNULL(h.new_value,'NULL')
--		--and h.DataFile_ID is not null
--		--and ss.SampleEncounterDate <> '2016-04-01 00:00:00.000'


--DECLARE @hasDischargeDate bit = 0
--DECLARE @hasServiceDate bit = 0
--DECLARE @Owner varchar(10)

--SET @Owner = 'S'+RTRIM(LTRIM(STR(@Study_ID)))  

---- check to see if the dischargedate column exists in the encounter table for this study
--IF EXISTS (select 1
--	from QP_PROD.information_schema.columns c
--	where table_schema = @Owner and table_name = 'encounter' and
--			column_name = 'DischargeDate')
--BEGIN
--	SET @hasDischargeDate = 1
--END    

---- check to see if the servicedate column exists in the encounter table for this study
--IF EXISTS (select 1
--	from QP_PROD.information_schema.columns c
--	where table_schema = @Owner and table_name = 'encounter' and
--			column_name = 'ServiceDate')
--BEGIN
--	SET @hasServiceDate = 1
--END        

--DECLARE @Sql varchar(8000)  

--SET @Sql = '
--INSERT #Work
--	SELECT ' + RTRIM(LTRIM(STR(@Study_ID))) + ', h.DataFile_ID, ISNULL(h.bitRollback,0)' 

--	if @hasDischargeDate = 1 SET @Sql = @Sql + ',E.DischargeDate' ELSE SET @Sql = @Sql + ', NULL '
--	if @hasServiceDate = 1 SET @Sql = @Sql + ', E.ServiceDate' ELSE SET @Sql = @Sql + ', NULL '

 
--	SET @Sql = @Sql +'
--		FROM dbo.HCAHPSUpdateLog h
--		INNER JOIN SamplePop sp on h.samplepop_id = sp.SAMPLEPOP_ID
--		INNER JOIN ' + @Owner + '.ENCOUNTER E on E.enc_id = sp.POP_ID and E.Pop_id = sp.Pop_id 
--		where h.DataFile_ID is not null
--		and ISNULL(h.old_value,''NULL'') <> ISNULL(h.new_value,''NULL'')'


--		print @Sql
		
--		EXEC (@Sql)	  

INSERT #Work
	SELECT ss.STUDY_ID, h.DataFile_ID, MIN(ss.SampleEncounterDate) as MinEncounterDate,  MAX(ss.SampleEncounterDate) as MaxEncounterDate, MAX(CONVERT(int,ISNULL(h.bitRollback,0)))
	--SELECT ss.STUDY_ID, h.DataFile_ID, MIN(ss.SampleEncounterDate) as MinEncounterDate,  MAX(ss.SampleEncounterDate) as MaxEncounterDate, df.strOrigFile_nm, df.LoadedBy, MAX(CONVERT(int,h.bitRollback)),df.StateDescription
		FROM dbo.HCAHPSUpdateLog h
		INNER JOIN SamplePop sp on h.samplepop_id = sp.SAMPLEPOP_ID
		INNER JOIN SELECTEDSAMPLE ss on ss.Sampleset_id = sp.Sampleset_id and ss.Pop_id = sp.Pop_id 
		INNER JOIN SampleUnit su on su.SampleUnit_id = ss.SampleUnit_id 
		where ss.STUDY_ID = @Study_ID
		and ISNULL(h.old_value,'NULL') <> ISNULL(h.new_value,'NULL')
		--and h.DataFile_ID is not null
		GROUP BY ss.Study_id,h.DataFile_id --, df.strOrigFile_nm, df.LoadedBy,df.StateDescription

	select * from #Work
	--where DataFile_id = 3411

	SELECT df.[DataFile_id]
		  ,df.[strOrigFile_nm] origFileName
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

	  select * from #datafiles

	 SELECT df.*, sub.SubmissionDateClose FROM #datafiles df
	INNER JOIN dbo.CMSDataSubmissionSchedule sub on sub.[month] = DATEPART(month,df.MinEncounterDate) and sub.[year] = DATEPART(year,df.MinEncounterDate) and sub.SurveyType_ID = 2
	--WHERE sub.SubmissionDateClose < GETDATE()


	DELETE df
	FROM #datafiles df
	INNER JOIN dbo.CMSDataSubmissionSchedule sub on sub.[month] = DATEPART(month,df.MinEncounterDate) and sub.[year] = DATEPART(year,df.MinEncounterDate) and sub.SurveyType_ID = 2
	WHERE sub.SubmissionDateClose < GETDATE()

	--select Study_id, DataFile_id, MinEncounterDate, MaxEncounterDate, origFileName, LoadedBy,  bitRollback, CASE bitRollback WHEN 1 THEN 'DRG Update Rolled Back' ELSE StateDescription end as Status  from #work
	select Study_id, DataFile_id, MinEncounterDate, MaxEncounterDate,origFileName, LoadedBy, Member_id, bitRollback, StateDescription as Status  from #datafiles
--GO
--IF OBJECT_ID('tempdb..#Work') IS NOT NULL DROP TABLE #Work 
--GO
--CREATE TABLE #Work (SamplePop_id int, Study_id int, Pop_id int,  Enc_id int, DataFile_id int, Change_Date datetime, EncounterDate datetime)

--INSERT #Work
--SELECT distinct h.samplepop_id, ss.STUDY_ID, ss.POP_ID, ss.enc_id, h.DataFile_ID, h.Change_Date, ss.SampleEncounterDate
--	FROM dbo.HCAHPSUpdateLog h
--	LEFT JOIN dbo.HCAHPSUpdateLog h1 on h1.samplepop_id = h.samplepop_id and h1.field_name = h.field_name and h1.DataFile_id = h.DataFile_id and h1.bitRollback = 1
--	INNER JOIN SamplePop sp on h.samplepop_id = sp.SAMPLEPOP_ID
--	INNER JOIN SELECTEDSAMPLE ss on ss.Sampleset_id = sp.Sampleset_id and ss.Pop_id = sp.Pop_id 
--	INNER JOIN SampleUnit su on su.SampleUnit_id = ss.SampleUnit_id  
--	INNER JOIN dbo.CMSDataSubmissionSchedule sub on sub.[month] = DATEPART(month,ss.SampleEncounterDate) and sub.[year] = DATEPART(year,ss.SampleEncounterDate) and sub.SurveyType_ID = 2
--	where ISNULL(h.old_value,'NULL') <> ISNULL(h.new_value,'NULL')
--	and h1.DataFile_ID is null -- if it has NOT already been rolledback
--	and h.DataFile_ID is not null
--	--and sub.SubmissionDateClose >= GETDATE()

--	select * from #work order by EncounterDate

--	--UPDATE w 
--	--SET bitPastSubmissionDate = 1 
--	--FROM #Work w
--	--INNER JOIN dbo.CMSDataSubmissionSchedule sub on sub.[month] = DATEPART(month,w.EncounterDate) and sub.[year] = DATEPART(year,w.EncounterDate) and sub.SurveyType_ID = 2
--	--WHERE sub.SubmissionDateClose < GETDATE()

--SELECT w.Study_id,w.DataFile_id, MIN(w.EncounterDate)
--FROM #Work w
--GROUP BY w.Study_id,w.DataFile_id


----SELECT w.Study_id,w.DataFile_id, w.EncounterDate, sub.SubmissionDateClose
----FROM #Work w
----LEFT JOIN dbo.CMSDataSubmissionSchedule sub on sub.[month] = DATEPART(month,w.EncounterDate) and sub.[year] = DATEPART(year,w.EncounterDate) and sub.SurveyType_ID = 2
----WHERE sub.SubmissionDateClose is not null
----AND sub.SubmissionDateClose > w.EncounterDate

----SELECT *
----FROM [dbo].[CMSDataSubmissionSchedule]


----INSERT INTO [dbo].[CMSDataSubmissionSchedule]([SurveyType_ID],[Month],[Year],[SubmissionDateOpen],[SubmissionDateClose])
----VALUES(2,12,2013,NULL,'04/05/2014')


--select * from dbo.CMSDataSubmissionSchedule