/*
Business Purpose: 

This procedure is used to support the Qualisys Class Library.  It returns a single
dataset representing fields that exist in the specifed study data table

Created:  10/17/2005 by Joe Camp

Modified:
01/25/2006 by Joe Camp - Added Field_id to retunset
*/    
ALTER PROCEDURE QCL_SelectStudyTableColumns  
@StudyId INT,  
@TableId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
IF @TableId=0  
BEGIN  
 SELECT NULL Field_id, Column_Name strField_nm,   
                CASE Data_Type WHEN 'varchar' THEN 'S'   
                               WHEN 'int' THEN 'I'   
                               WHEN 'datetime' THEN 'D'   
                               END strFieldDataType,   
                0 bitKeyField_Flg, '' strField_Dsc, Character_Maximum_Length intFieldLength  
 FROM Information_Schema.Columns  
 WHERE Table_Schema='s'+CONVERT(VARCHAR,@StudyId)  
 AND Table_Name='Big_View'  
 ORDER BY Column_Name  
END  
ELSE  
BEGIN  
 SELECT Field_id, strField_nm, strFieldDataType, bitKeyField_FLG, strField_DSC, intFieldLength  
 FROM MetaData_View  
 WHERE Study_id=@StudyId  
 AND Table_id=@TableId  
 ORDER BY bitKeyField_FLG DESC, strField_nm  
END  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF   
GO 
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 

This procedure is used to support the Qualisys Class Library.  It returns three
datasets.  The first is a list of all client names an employee has rights to.  The second 
selects all of the study names and client_ids the employee has rights to.  The third selects  
all of the survey names and study_ids the employee has rights to. 


Created:  11/03/2005 by Joe Camp

Modified:
01/25/2006 by Joe Camp - Added CutoffTable_id and CutoffField_id to survey selection
*/
ALTER PROCEDURE dbo.QCL_SelectClientsStudiesAndSurveysByUser      
    @UserName VARCHAR(42)      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
SET NOCOUNT ON      
      
--Need a temp table to hold the ids the user has rights to      
CREATE TABLE #EmpStudy (      
     Client_id INT,      
     Study_id INT,      
     strStudy_nm VARCHAR(10),      
     strStudy_dsc VARCHAR(255)      
)      
      
--Populate the temp table with the studies they have rights to.      
INSERT INTO #EmpStudy (Client_id, Study_id, strStudy_nm, strStudy_dsc)      
SELECT s.Client_id, s.Study_id, s.strStudy_nm, s.strStudy_dsc      
FROM Employee e, Study_Employee se, Study s      
WHERE e.strNTLogin_nm=@UserName      
AND e.Employee_id=se.Employee_id      
AND se.Study_id=s.Study_id      
AND s.datArchived IS NULL      
      
CREATE INDEX tmpIndex ON #EmpStudy (Client_id)      
      
--First recordset.  List of clients they have rights to.      
SELECT c.Client_id, c.strClient_nm      
FROM #EmpStudy t, Client c      
WHERE t.Client_id=c.Client_id      
GROUP BY c.Client_id, c.strClient_nm      
ORDER BY c.strClient_nm      
      
--Second recordset.  List of studies they have rights to      
SELECT Client_id, Study_id, strStudy_nm, strStudy_dsc      
FROM #EmpStudy      
ORDER BY strStudy_nm      
      
--Third recordset.  List of surveys they have rights to      
SELECT s.Survey_id, s.strSurvey_nm, s.strSurvey_dsc, s.Study_id, s.strCutoffResponse_cd, s.CutoffTable_id, s.CutoffField_id
FROM #EmpStudy t, Survey_def s      
WHERE t.Study_id=s.Study_id      
ORDER BY s.strSurvey_nm      
      
--Cleanup temp table      
DROP TABLE #EmpStudy      
      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
SET NOCOUNT OFF      
GO
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It returns a single
record representing survey data for the ID specified

Created:  10/17/2005 by Joe Camp

Modified:
01/25/2006 by Joe Camp - Added CutoffTable_id and CutoffField_id to survey selection

*/    
ALTER PROCEDURE QCL_SelectSurvey  
@SurveyId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
SELECT Survey_id, strSurvey_nm, strSurvey_dsc, Study_id, strCutoffResponse_cd, CutoffTable_id, CutoffField_id
FROM Survey_Def   
WHERE Survey_id=@SurveyId  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF    
GO
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 

This procedure is used to display a grid of information about existing sample sets.  Since this dataset joins 
information from so many entities it is not used to populate the Class Library but is just for display purposes

Created:  01/26/2006 by Joe Camp

Modified:

*/
CREATE PROCEDURE DBO.QCL_SelectExistingSampleSetsBySurvey
@SurveyId INT,
@StartDate DATETIME,
@EndDate DATETIME,
@ShowOnlyUnscheduled BIT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SET @StartDate = ISNULL(@StartDate, '1/1/1900')
SET @EndDate = ISNULL(@EndDate, '1/1/3000')

IF @ShowOnlyUnscheduled = 0
BEGIN
	SELECT s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, e.strNTLogin_nm, ss.datScheduled
	FROM SampleSet ss, PeriodDates pd, PeriodDef p, Survey_def sd, Study s, Employee e
	WHERE ss.SampleSet_id = pd.SampleSet_id
	AND pd.PeriodDef_id = p.PeriodDef_id
	AND ss.Survey_id = sd.Survey_id
	AND sd.Study_id = s.Study_id
	AND ss.Employee_id = e.Employee_id
	AND sd.Survey_id = @SurveyId
	AND ss.datSampleCreate_dt > @StartDate
	AND ss.datSampleCreate_dt < DATEADD(DAY, 1, @EndDate)
	ORDER BY ss.datSampleCreate_dt DESC
END
ELSE
BEGIN
	SELECT s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, e.strNTLogin_nm, ss.datScheduled
	FROM SampleSet ss, PeriodDates pd, PeriodDef p, Survey_def sd, Study s, Employee e
	WHERE ss.SampleSet_id = pd.SampleSet_id
	AND pd.PeriodDef_id = p.PeriodDef_id
	AND ss.Survey_id = sd.Survey_id
	AND sd.Study_id = s.Study_id
	AND ss.Employee_id = e.Employee_id
	AND sd.Survey_id = @SurveyId
	AND ss.datSampleCreate_dt > @StartDate
	AND ss.datSampleCreate_dt < DATEADD(DAY, 1, @EndDate)
	AND ss.datScheduled IS NULL
	ORDER BY ss.datSampleCreate_dt DESC
END
GO
-----------------------------------------------------------------------------------------------
GO
CREATE TABLE dbo.SamplingAlgorithm
	(
	SamplingAlgorithmId int NOT NULL IDENTITY (1, 1),
	AlgorithmName varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.SamplingAlgorithm ADD CONSTRAINT
	PK_Table_1 PRIMARY KEY CLUSTERED 
	(
	SamplingAlgorithmId
	) ON [PRIMARY]

GO
INSERT INTO SamplingAlgorithm (AlgorithmName) VALUES ('Static')
INSERT INTO SamplingAlgorithm (AlgorithmName) VALUES ('Dynamic')
GO
-----------------------------------------------------------------------------------------------
GO
ALTER TABLE SampleSet ADD datScheduled DATETIME, SamplingAlgorithmId INT
GO
-----------------------------------------------------------------------------------------------
GO
UPDATE SampleSet SET datScheduled = a.datGenerate
FROM (
	SELECT ss.SampleSet_id, MIN(datGenerate) datGenerate
	FROM SampleSet ss, SamplePop sp, ScheduledMailing sm
	WHERE ss.SampleSet_id = sp.SampleSet_id
	AND sp.SamplePop_id = sm.SamplePop_id
	GROUP BY ss.SampleSet_id
) a
WHERE SampleSet.SampleSet_id = a.SampleSet_id
GO
-----------------------------------------------------------------------------------------------
GO
UPDATE SampleSet SET SamplingAlgorithmId = CASE bitDynamic WHEN 1 THEN 2 WHEN 0 THEN 1 ELSE 0 END
GO
-----------------------------------------------------------------------------------------------
GO
ALTER TABLE SampleSet DROP COLUMN bitDyanmic
GO
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 

This procedure is used to select the list of parameters for a stored procedure.

Created:  01/27/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].QCL_SelectStoredProcedureParameters
	@StoredProcedureName varchar(50)
as
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT sc.name as paramName, st.name as paramType 
FROM sysobjects so, syscolumns sc, systypes st 
WHERE so.name =@StoredProcedureName 
AND so.id=sc.id 
AND sc.xtype = st.xtype
ORDER BY sc.colorder
GO
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 

This procedure is used to select the active period for a survey.

Created:  01/27/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectActivePeriodbySurveyId]
	@survey_id int
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

CREATE TABLE #periods (periodDef_id int, ActivePeriod bit default 0)

--Get a list of all periods for this survey
INSERT INTO #periods (periodDef_id)
SELECT periodDef_id
FROM perioddef
WHERE survey_id=@survey_id

--Get a list of all periods that have not completed sampling
SELECT distinct pd.PeriodDef_id
INTO #temp
FROM perioddef p, perioddates pd
WHERE p.perioddef_id=pd.perioddef_id AND
		survey_id=@survey_id AND
	  	datsampleCREATE_dt is null

--Find the active Period.  It is either a period that hasn't completed sampling
--or a period that hasn't started but has the most recent first scheduled date 
--If no unfinished periods exist, set active period to the period with the most
--recently completed sample 

IF EXISTS (SELECT top 1 *
			FROM #temp)
BEGIN
	
	DECLARE @UnfinishedPeriod int
	
	SELECT @UnfinishedPeriod=pd.perioddef_id
	FROM perioddates pd, #temp t
	WHERE pd.perioddef_id=t.perioddef_id AND
		  	pd.samplenumber=1 AND
			pd.datsampleCREATE_dt is not null
	
	IF @UnfinishedPeriod is not null
	BEGIN
		--There is a period that is partially finished, so set it to be active
		UPDATE #periods
		SET ActivePeriod=1
		WHERE perioddef_id = @UnfinishedPeriod
	END
	ELSE
	BEGIN
		--There is no period that is partially finished, so set the unstarted period
		--with the earliest scheduled sample date to be active
		UPDATE #periods
		SET ActivePeriod=1
		WHERE perioddef_id =
			(SELECT top 1 pd.perioddef_id
			 FROM perioddates pd, #temp t
			 WHERE pd.perioddef_id=t.perioddef_id AND
				  	pd.samplenumber=1
			 ORDER BY datscheduledsample_dt)
	END
END
ELSE
BEGIN
	--No unfinished periods exist, so we will set the active to be the most recently
	--finished
	UPDATE #periods
	SET ActivePeriod=1
	WHERE perioddef_id =
		(SELECT top 1 p.perioddef_id
		 FROM perioddates pd, perioddef p
		 WHERE p.survey_id=@survey_id AND
				pd.perioddef_id=p.perioddef_id
		 GROUP BY p.perioddef_id
		 ORDER BY Max(datsampleCREATE_dt) desc)
END

SELECT *
FROM #periods
WHERE ActivePeriod=1

DROP TABLE #temp
DROP TABLE #periods


GO
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 

This procedure will return the period data for a period ID.

Created:  01/27/2006 by Dan Christensen

Modified:

*/
CREATE   PROCEDURE [dbo].[QCL_SelectSamplePeriod]
	@period_id int
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

--This recordSethas the Period Properties information
SELECT PeriodDef_id, Survey_id, Employee_id, datAdded, strPeriodDef_nm,
    intExpectedSamples, datExpectedEncStart, datExpectedEncEND,
    SamplingMethod_id
INTO #periods
FROM PeriodDef
WHERE perioddef_id =@period_id

CREATE table #activePeriods (periodDef_id int, ActivePeriod bit default 0)

DECLARE @survey_id int
SELECT @survey_id=survey_id
FROM #periods

IF  @survey_id IS NOT NULL
BEGIN
	INSERT INTO #activePeriods
	EXEC [dbo].[QCL_SELECTActivePeriodbySurveyId] @survey_id
END

SELECT p.PeriodDef_id, Survey_id, Employee_id, datAdded, strPeriodDef_nm,
    intExpectedSamples, datExpectedEncStart, datExpectedEncEND,
    SamplingMethod_id, coalesce(a.ActivePeriod,0) as ActivePeriod
FROM #periods p LEFT JOIN #activePeriods a
ON p.perioddef_id=a.perioddef_id 
GO
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 

This procedure will return the period data for all periods for a survey.

Created:  01/27/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectSamplePeriodsBySurvey]
	@survey_id int
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
CREATE TABLE #activePeriods (periodDef_id int, ActivePeriod bit default 0)

INSERT INTO #activePeriods
EXEC [dbo].[QCL_SelectActivePeriodbySurveyId] @survey_id

SELECT p.PeriodDef_id, Survey_id, Employee_id, datAdded, strPeriodDef_nm,
    intExpectedSamples, datExpectedEncStart, datExpectedEncEnd,
    SamplingMethod_id, coalesce(a.ActivePeriod,0) as ActivePeriod
FROM PeriodDef p LEFT JOIN #activePeriods a
ON p.perioddef_id=a.perioddef_id 
WHERE p.survey_id =@survey_id
GO
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 

This procedure will return the study dataset data for all datasets within the specified
date range for the study specified.  If no dates are specified, then all datasets for the study
will be returned.
Created:  01/27/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectStudyDatasetsByStudy]
 @intStudy_id int,
 @dtFrom_Date datetime,
 @dtTo_Date datetime
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
CREATE TABLE #Temp_DataSetRecs
  (study_id int, Date_Imported datetime, Records int, Sampled bit, DataSet_id int,
	MinEncDate datetime, MaxEncDate datetime)
 
IF @dtFrom_Date is not null
BEGIN
 INSERT INTO #Temp_DataSetRecs (study_id, date_imported, records, sampled, dataset_id)
  SELECT @intStudy_id, datLoad_dt, RecordCount, 0, DataSet_id
   FROM dbo.Data_Set
   WHERE Study_id = @intStudy_id
    AND datLoad_dt BETWEEN @dtFrom_Date AND @dtTo_Date
   ORDER BY datLoad_dt DESC
END 
ELSE
BEGIN
 INSERT INTO #Temp_DataSetRecs (study_id, date_imported, records, sampled, dataset_id)
  SELECT @intStudy_id, datLoad_dt, RecordCount, 0, DataSet_id
   FROM dbo.Data_Set
   WHERE Study_id = @intStudy_id
   ORDER BY datLoad_dt DESC
END
 
 UPDATE TDSR
  SET Sampled = 1
  FROM #Temp_DataSetRecs TDSR, dbo.SampleDataSet SDS
   WHERE TDSR.DataSet_id = SDS.DataSet_id
 
 SELECT * 
  FROM #Temp_DataSetRecs 
  
 SELECT dr.Dataset_id, Table_id, Field_id, MinDate, MaxDate
 FROM DatasetDateRange dr, #Temp_DataSetRecs ds
 WHERE dr.Dataset_id = ds.Dataset_id

 DROP TABLE #Temp_DataSetRecs
GO
-----------------------------------------------------------------------------------------------
GO


/*********************************************************************************************************/  
/*                       										 */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns a single  */ 
/*   		     record of employee data associated with the given NT Login Name				 */
/*                       										 */  
/* Date Created:  1/27/2006                  								 */  
/*                       										 */  
/* Created by:  Dan Christensen                   								 */  
/*                       										 */  
/*********************************************************************************************************/  
CREATE PROCEDURE [dbo].[QCL_SelectEmployeeByLoginName]
@LoginName varchar(100)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT Employee_id, strEmployee_First_nm, strEmployee_Last_nm, strEmployee_Title, strNTLogin_nm, strEmail
FROM Employee
WHERE strNTLogin_nm = @LoginName

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  
GO
-----------------------------------------------------------------------------------------------
GO

/*
Business Purpose: 

This procedure is used to get information about a sample set.  

Created:  01/30/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectSampleSet]
@SampleSet_Id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, ss.Employee_Id,
	p.datExpectedEncStart, p.datExpectedEncEnd, ss.SamplePlan_Id, ss.intSample_Seed,
	tiNewPeriod_flag, tiOversample_flag, datScheduled, SamplingAlgorithmId
FROM SampleSet ss, PeriodDates pd, PeriodDef p, Survey_def sd, Study s
WHERE ss.SampleSet_id=@SampleSet_id
AND ss.SampleSet_id = pd.SampleSet_id
AND pd.PeriodDef_id = p.PeriodDef_id
AND ss.Survey_id = sd.Survey_id
AND sd.Study_id = s.Study_id
AND sd.Survey_id = ss.Survey_id
ORDER BY ss.datSampleCreate_dt
GO
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 

This procedure is used to get information about all sample sets for a period.  

Created:  01/30/2006 by Dan Christensen

Modified:

*/
CREATE PROCEDURE [dbo].[QCL_SelectSampleSetsByPeriod]
@PeriodDef_id INT
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

SELECT s.Client_id, s.Study_id, sd.Survey_id, sd.strSurvey_nm, p.PeriodDef_id, p.strPeriodDef_nm, ss.SampleSet_id, ss.datSampleCreate_dt, ss.Employee_Id,
	p.datExpectedEncStart, p.datExpectedEncEnd, ss.SamplePlan_Id, ss.intSample_Seed,
	tiNewPeriod_flag, tiOversample_flag, datScheduled, SamplingAlgorithmId
FROM SampleSet ss, PeriodDates pd, PeriodDef p, Survey_def sd, Study s
WHERE pd.PeriodDef_id=@PeriodDef_id
AND ss.SampleSet_id = pd.SampleSet_id
AND pd.PeriodDef_id = p.PeriodDef_id
AND ss.Survey_id = sd.Survey_id
AND sd.Study_id = s.Study_id
AND sd.Survey_id = ss.Survey_id
ORDER BY ss.datSampleCreate_dt
GO
-----------------------------------------------------------------------------------------------
GO
/***********************************************************************************************************************************
SP Name: sp_Samp_AddSampleSetV2 
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 02/01/2004
Author(s): DC 
Revision: First build - 02/01/2004
	05-28-2004 DC 
		Added a check to catch when the period selected is for a different survey
		then we are supposed to be sampling.
	01-30-2006 DC 
		Added code to populate the samplingAlgorithm field in sampleset
***********************************************************************************************************************************/
ALTER          PROCEDURE [dbo].[sp_Samp_AddSampleSetV2] 
 @intSurvey_id INT,
 @intEmployee_id INT,
 @vcDateRange_FromDate VARCHAR(24) = NULL,
 @vcDateRange_ToDate VARCHAR(24) = NULL,
 @tiOverSample_flag bit,
 @tiNewPeriod_flag bit,
 @intPeriodDef_id int
AS
 DECLARE @intSamplePlan_id INT, @intSampleSet_id int
 DECLARE @strSurvey_nm VARCHAR(10), @intDateRange_Table_id int, 
		@intDateRange_Field_id int, @sql varchar(5000), @SamplingAlgorithmId int


	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_AddSampleSetV2', getdate())

 IF NOT (@vcDateRange_FromDate is null or @vcDateRange_FromDate='')
BEGIN

	CREATE TABLE #DATEFIELD (table_id int, field_id int)
	
	SET @SQL = 'INSERT INTO #DATEFIELD' +
	   ' SELECT ms.Table_id, ms.Field_id' +
	   ' FROM Survey_def sd, MetaStructure ms, MetaTable mt, MetaField mf' +
	   ' WHERE sd.Study_id = mt.Study_id' +
	   ' AND ms.Table_id = mt.Table_id' +
	   ' AND ms.table_id=sd.cutofftable_id' +
	   ' AND ms.field_id=sd.cutofffield_id' +
	   ' AND ms.Field_id = mf.Field_id' +
	   ' AND mf.strFieldDataType = ''D''' +
	   ' AND sd.Survey_id = '  + CONVERT(VARCHAR,@intSurvey_id)

	EXECUTE (@SQL)

	SELECT @intDateRange_Table_id=Table_id,
			@intDateRange_Field_id=Field_id
	FROM #DATEFIELD

	DROP TABLE #DATEFIELD
END

 SELECT @strSurvey_nm = strSurvey_nm,
		@SamplingAlgorithmId=case
								when bitdynamic=0 then 1
								when bitdynamic=1 then 2
								else 0
							 end
  FROM Survey_def 
  WHERE Survey_id = @intSurvey_id

 SELECT @intSamplePlan_id = SamplePlan_id 
  FROM dbo.SamplePlan
  WHERE Survey_id = @intSurvey_id

 INSERT INTO dbo.SampleSet
  (SamplePlan_id, Survey_id, Employee_id, datSampleCreate_dt, 
   intDateRange_Table_id, intDateRange_Field_id, datDateRange_FromDate, 
   datDateRange_ToDate, tiOverSample_flag, tiNewPeriod_flag, strSampleSurvey_nm,
	SamplingAlgorithmId)
 VALUES
  (@intSamplePlan_id, @intSurvey_id, @intEmployee_id, GETDATE(), 
   @intDateRange_Table_id, @intDateRange_Field_id, @vcDateRange_FromDate, 
   @vcDateRange_ToDate, @tiOverSample_flag, @tiNewPeriod_flag, @strSurvey_nm,
	@SamplingAlgorithmId)
                                                                                                                                                                        
-- SELECT @@IDENTITY as intSampleSet_id
 SELECT @intSampleSet_id = @@IDENTITY 
-- SELECT @intSampleSet_id = SCOPE_IDENTITY()

 --Check for Cases where a period for the wrong survey is passed in
 IF EXISTS (select s.sampleset_id
			from sampleset s, perioddef pd
			where s.sampleset_id=@intSampleSet_id and
				  pd.perioddef_id=@intPeriodDef_id and
				  s.survey_id <> pd.survey_id)
BEGIN
	RAISERROR ('Error: Invalid Period.  Please delete this sample, close sampling tool, and then try sampling again.  If this error happens again, please sumbit a helpdesk ticket.', 18, 1)
	Return
END
ELSE
BEGIN
	
	--Insert into SamplePlanWorkSheet table
	INSERT INTO SamplePlanWorkSheet (SampleSet_id, SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, intPeriodReturnTarget, 
		numDefaultResponseRate, intSamplesInPeriod)
	SELECT @intSampleSet_id, SampleUnit_id, strSampleUnit_nm, ParentSampleUnit_id, intTargetReturn, 
		numInitResponseRate, intExpectedSamples
	FROM SampleUnit su, SamplePlan sp, Survey_def sd, Perioddef p
	WHERE sp.Survey_id = @intSurvey_id
	AND sp.SamplePlan_id = su.SamplePlan_id
	AND sp.Survey_id = sd.Survey_id 
	AND sd.survey_id=p.survey_Id
	AND p.periodDef_id=@intPeriodDef_id
END

SELECT @intSampleSet_id AS intSampleSet_id
GO
-----------------------------------------------------------------------------------------------
GO
ALTER TABLE Data_Set ADD RecordCount INT
GO
UPDATE Data_Set SET RecordCount = ds.cnt
FROM (
	SELECT Dataset_id, COUNT(*) cnt
	FROM DatasetMember
	GROUP BY Dataset_id
) ds
WHERE Data_Set.Dataset_id = ds.Dataset_id
GO
UPDATE Data_Set SET RecordCount = 0 WHERE RecordCount IS NULL
GO
-----------------------------------------------------------------------------------------------
GO
CREATE TABLE dbo.DatasetDateRange
	(
	Dataset_id int NOT NULL,
	Table_id int NOT NULL,
	Field_id int NOT NULL,
	MinDate datetime NOT NULL,
	MaxDate datetime NOT NULL
	)  ON [PRIMARY]
GO
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 

This procedure is used to Remove a sampleset.  This can only be executed IF the sample
has not been scheduled.

Created:  1/30/2006 BY Dan Christensen

Modified:

*/   
CREATE     PROCEDURE [dbo].[QCL_DeleteSampleSet]
 @intSampleSet_id int
AS
DECLARE @intStudy_id int
DECLARE @vcSQL varchar(8000)
DECLARE @intSurvey_ID int
DECLARE @intNotRollbackSampleSet_id int

SELECT @intStudy_id = SD.Study_id
FROM dbo.Survey_def SD, dbo.SampleSet SS
WHERE SD.Survey_id = SS.Survey_id
AND SS.SampleSet_id = @intSampleSet_id

IF exists (SELECT schm.*
FROM samplepop sp, scheduledmailing schm
WHERE sp.samplepop_id = schm.samplepop_id
AND study_id = @intstudy_id
AND sampleset_id = @intsampleset_id)

BEGIN 
	RAISERROR ('This sample set is scheduled and cannot be deleted.', 16, 1)
	RETURN
END

SET @vcSQL = 'DELETE
FROM S' + CONVERT(varchar, @intStudy_id) + '.Unikeys
WHERE SampleSet_id = ' + CONVERT(varchar, @intSampleSet_id)
EXECUTE (@vcSQL)

INSERT into rollbacks (survey_id, study_id, datrollback_dt, rollbacktype, cnt, datSampleCreate_dt)
SELECT ss.survey_id, sp.study_id, getdate(), 'Sampling' , count(*), datSampleCreate_dt
FROM sampleset ss, samplepop sp
WHERE ss.sampleset_id = @intsampleset_id
AND ss.sampleset_id = sp.sampleset_id
GROUP BY ss.survey_id, sp.study_id, ss.datSampleCreate_dt

/* 
* Update TeamStatus_SampleInfo
*/
SELECT @intSurvey_ID = Survey_id
FROM dbo.SampleSet
WHERE SampleSet_id = @intSampleSet_id
       
UPDATE dbo.TeamStatus_SampleInfo
SET Rolledback = 1
WHERE SampleSet_id = @intSampleSet_id

UPDATE dbo.TeamStatus_SampleInfo
SET SamplesPulled = SamplesPulled - 1
WHERE Survey_id = @intSurvey_ID
AND SampleSet_id > @intSampleSet_id

SELECT @intNotRollbackSampleSet_id = MIN(SampleSet_id)
FROM dbo.TeamStatus_SampleInfo
WHERE Survey_id = @intSurvey_ID
AND SampleSet_id > @intSampleSet_id
AND RolledBack = 0

IF (@intNotRollbackSampleSet_id IS NULL)
 UPDATE dbo.TeamStatus_SampleInfo
    SET TotalRolledBack = TotalRolledBack + 1
  WHERE Survey_id = @intSurvey_ID
    AND SampleSet_id > @intSampleSet_id
ELSE
 UPDATE dbo.TeamStatus_SampleInfo
    SET TotalRolledBack = TotalRolledBack + 1
  WHERE Survey_id = @intSurvey_ID
    AND SampleSet_id > @intSampleSet_id
    AND SampleSet_id <= @intNotRollbackSampleSet_id

        
DELETE FROM dbo.SampleDataSet
WHERE SampleSet_id = @intSampleSet_id
DELETE FROM dbo.SELECTedSample
WHERE SampleSet_id = @intSampleSet_id
DELETE FROM dbo.SamplePop
WHERE SampleSet_id = @intSampleSet_id
DELETE FROM dbo.SampleSet
WHERE SampleSet_id = @intSampleSet_id
DELETE FROM dbo.SamplePlanWorkSheet
WHERE SampleSet_id = @intSampleSet_id
DELETE FROM dbo.SPWDQCounts
WHERE SampleSet_id = @intSampleSet_id

--update the info in PeriodDates IF it's not an oversample
--IF this is an oversample, we want to delete the whole record
IF EXISTS (SELECT SampleNumber
   FROM perioddates pds, perioddef pd
   WHERE pds.sampleset_id=@intSampleSet_id and
		 pds.perioddef_id=pd.perioddef_id and
		 pd.intexpectedsamples < sampleNumber)
BEGIN
DELETE
FROM perioddates
WHERE sampleset_id=@intSampleSet_id
END
ELSE 
BEGIN
UPDATE dbo.PeriodDates
SET sampleset_id=null,
	datsamplecreate_dt=null
WHERE SampleSet_id = @intSampleSet_id	
END
GO
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 

This procedure schedules a sample set for survey generation.

Created:  1/31/2006 By Brian Dohmen

Modified:

*/   
CREATE PROCEDURE QCL_Samp_ScheduleSampleSetGeneration  
@SampleSetId INT,  
@GenerationDate DATETIME  
AS  
   
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
   
IF EXISTS (SELECT *   
           FROM SamplePop sp, ScheduledMailing schm   
           WHERE sp.SampleSet_id=@SampleSetID   
           AND sp.SamplePop_id=schm.SamplePop_id)  
BEGIN  
   
   RAISERROR ('This sample set has already been scheduled.', 18, 1)  
   RETURN  
   
END  
   
BEGIN TRANSACTION  
   
INSERT INTO ScheduledMailing (MailingStep_id,SamplePop_id,OverRideItem_id,SentMail_id,Methodology_id,datGenerate)  
SELECT ms.MailingStep_id,sp.SamplePop_id,NULL,NULL,ms.Methodology_id,@GenerationDate  
FROM SampleSet ss, SamplePop sp, MailingStep ms, MailingMethodology mm  
WHERE ss.SampleSet_id=@SampleSetID  
AND ss.SampleSet_id=sp.SampleSet_id  
AND ss.Survey_id=mm.Survey_id  
AND mm.bitActiveMethodology=1  
AND mm.Methodology_id=ms.Methodology_id  
and ms.intSequence=1  
   
IF @@ERROR<>0  
BEGIN  
   ROLLBACK TRANSACTION  
   RAISERROR ('A database error occurred while scheduling the sample set.  The sample set has not been scheduled.', 18, 1)  
   RETURN  
END  
   
UPDATE SampleSet   
SET datScheduled=@GenerationDate  
WHERE SampleSet_id=@SampleSetID  
   
IF @@ERROR<>0  
BEGIN  
   ROLLBACK TRANSACTION  
   RAISERROR ('A database error occurred while scheduling the sample set.  The sample set has not been scheduled.', 18, 1)  
   RETURN  
END  
   
COMMIT TRANSACTION  
   
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  
GO
-----------------------------------------------------------------------------------------------
GO
/*
Business Purpose: 

This procedure unschedules a sample set for survey generation.

Created:  1/31/2006 By Brian Dohmen

Modified:

*/   
CREATE PROCEDURE QCL_Samp_UnscheduleSampleSetGeneration
@SampleSetId INT
AS
 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON
 
IF EXISTS (SELECT * FROM SamplePop sp, ScheduledMailing schm
WHERE sp.SampleSet_id=@SampleSetID
AND sp.SamplePop_id=schm.SamplePop_id
AND schm.SentMail_id IS NOT NULL)
 
BEGIN
 
   RAISERROR ('This sample set cannot be unscheduled because it has already been generated.', 18, 1)
   RETURN
 
END
 
BEGIN TRANSACTION
 
DELETE schm
FROM SamplePop sp, ScheduledMailing schm
WHERE sp.SampleSet_id=@SampleSetID
AND sp.SamplePop_id=schm.SamplePop_id
AND schm.SentMail_id IS NULL
 
IF @@ERROR<>0
BEGIN
   ROLLBACK TRANSACTION
   RAISERROR ('A database error occurred while attempting to unschedule the sample set.  The sampleset was not unscheduled.', 18, 1)
   RETURN
END
 
UPDATE SampleSet
SET datScheduled=NULL
WHERE SampleSet_id=@SampleSetID
 
IF @@ERROR<>0
BEGIN
   ROLLBACK TRANSACTION
   RAISERROR ('A database error occurred while attempting to unschedule the sample set.  The sampleset was not unscheduled.', 18, 1)
   RETURN
END
 
COMMIT TRANSACTION
 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


