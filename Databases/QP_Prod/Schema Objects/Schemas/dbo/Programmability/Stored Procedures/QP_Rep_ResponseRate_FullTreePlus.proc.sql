--==================================================

  
  
-- ======================================================  
-- Author:   Hui Holay  
-- Create date: 12-12-2006  
-- Description:    
-- =======================================================  
-- Revision  
-- MWB - 1/15/09  Added ContractNumber to report for 
-- SalesLogix integration
-- =======================================================  
CREATE PROCEDURE dbo.QP_Rep_ResponseRate_FullTreePlus  
  @Associate VARCHAR(20),  
  @FirstDay DATETIME,  
  @LastDay DATETIME,  
  @Client VARCHAR(50),  
  @Study VARCHAR(50) = '_ALL',  
  @Survey VARCHAR(50) = '_ALL'  
AS  
BEGIN  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 SET NOCOUNT ON;  
  
 IF @FirstDay = @LastDay  
  SET @FirstDay = DATEADD(DAY, -45, @FirstDay)  
  
 SELECT @LastDay=DATEADD(DAY,1,@LastDay)  
  
 -- Create tables that contain studies and surveys  
 CREATE TABLE #StudyList (  
  StudyID INT,   
  StudyName VARCHAR(10))  
  
 CREATE TABLE #SurveyList (  
  SurveyID INT,   
  SurveyName VARCHAR(10))  
  
 CREATE TABLE #Display (  
  StudyOrder INT,  
  SurveyOrder INT,  
  StudyID INT,  
  SurveyID INT,  
  StudyName VARCHAR(50),  
  SurveyName VARCHAR(50),
  ContractNumber varchar(9),  
  SampleUnit VARCHAR(250),   
  [Unit ID] INT,   
  DummyOrder INT,   
  Sampled INT,   
  Nondel INT,   
  Returned INT,   
  Target INT,   
  [Current RespRate] FLOAT,  
  [N-D] FLOAT)  
  
 CREATE TABLE #UnitDisplay (  
  StudyOrder INT,  
  SurveyOrder INT,  
  StudyID INT,  
  SurveyID INT,  
  StudyName VARCHAR(50),  
  SurveyName VARCHAR(50), 
  ContractNumber varchar(9),   
  SampleUnit VARCHAR(250),   
  [Unit ID] INT,   
  DummyOrder INT,   
  Sampled INT,   
  Nondel INT,   
  Returned INT,   
  Target INT,   
  [Current RespRate] FLOAT,  
  [N-D] FLOAT)  
  
 CREATE TABLE #RR (  
  Sampleset_id INT,   
  Sampleunit_id INT,   
  intSampled INT,   
  intUD INT,   
  intReturned INT)  
   
 CREATE TABLE #SampleUnits (  
  SampleUnit_id INT,  
  strSampleUnit_nm VARCHAR(255),  
  intTier INT,  
  intTreeOrder INT,  
  intTargetReturn INT)  
  
 CREATE TABLE #SampleSets (SampleSet_id INT)  
  
 IF @Study = '_ALL'  
  BEGIN  
   SET @Survey = '_ALL'  
  
   INSERT INTO #StudyList  
   SELECT s.Study_id, strStudy_nm  
   FROM Client c WITH (NOLOCK) INNER JOIN Study s  WITH (NOLOCK) ON c.Client_id = s.Client_id  
   INNER JOIN Study_Employee x WITH (NOLOCK) ON s.Study_id = x.Study_id  
   INNER JOIN Employee e WITH (NOLOCK) ON x.Employee_id = e.Employee_id  
   WHERE c.strClient_nm = @Client   
   AND e.strNTLogin_nm = @Associate   
   ORDER BY strStudy_nm  
  END  
 ELSE  
  BEGIN  
   INSERT INTO #StudyList  
   SELECT Study_id, strStudy_nm  
   FROM Client c WITH (NOLOCK) INNER JOIN Study s WITH (NOLOCK) ON c.Client_id = s.Client_id  
   WHERE c.strClient_nm = @Client  
   AND strStudy_nm = @Study  
  END  
  
 DECLARE @intSamplePlan_id INT, @StudyOrder INT, @SurveyOrder INT  
 DECLARE @TempStudy INT, @TempStudyName VARCHAR(10)  
 DECLARE @TempSurvey INT, @TempSurveyName VARCHAR(10)  
  
 SET @StudyOrder = 0  
   
 -- Loop thru all the selected studies  
 SELECT TOP 1 @TempStudy = StudyID, @TempStudyName = StudyName FROM #StudyList  
 WHILE @@ROWCOUNT > 0  
  BEGIN     
   SET @StudyOrder = @StudyOrder + 1  
   SET @SurveyOrder = 0  
  
   -- Delete from the Survey list  
   TRUNCATE TABLE #SurveyList  
   IF @Survey = '_ALL'  
    BEGIN  
     INSERT INTO #SurveyList  
     SELECT Survey_id, strSurvey_nm   
     FROM Client c INNER JOIN Study s ON c.Client_id = s.Client_id  
     INNER JOIN Survey_Def sd ON s.Study_id = sd.Study_id  
     WHERE c.strClient_nm =  @Client   
     AND s.Study_id =  @TempStudy  
     ORDER BY strSurvey_nm  
    END  
   ELSE  
    BEGIN  
     INSERT INTO #SurveyList  
     SELECT Survey_id, strSurvey_nm  
     FROM Client c INNER JOIN Study s ON c.Client_id = s.Client_id  
     INNER JOIN Survey_Def sd ON s.Study_id = sd.Study_id  
     WHERE c.strClient_nm = @Client  
     AND s.Study_id = @TempStudy  
     AND sd.strSurvey_nm = @Survey  
    END  
     
   -- Loop thru surevy list of selected study  
   SELECT TOP 1 @TempSurvey = SurveyID, @TempSurveyName = SurveyName FROM #SurveyList  
   WHILE @@ROWCOUNT > 0  
    BEGIN        
     SET @SurveyOrder = @SurveyOrder + 1  
    
     -- Truncate #RR, #SampleUnits, #UnitDisplay, #SampleSets for each survey  
     TRUNCATE TABLE #RR  
     TRUNCATE TABLE #SampleUnits  
     TRUNCATE TABLE #UnitDisplay  
     TRUNCATE TABLE #SampleSets  
  
     INSERT INTO #SampleSets  
--     SELECT ss.SampleSet_id FROM SampleSet ss INNER JOIN SamplePop sp  
--     ON ss.SampleSet_id = sp.SampleSet_id  
--     WHERE Survey_id = @TempSurvey  
--     AND datDateRange_FromDate >= @FirstDay   
--     AND datDateRange_ToDate <= @LastDay  
     SELECT SampleSet_id FROM SampleSet  
     WHERE Survey_id = @TempSurvey  
     AND datSampleCreate_Dt BETWEEN @FirstDay AND @LastDay  
  
     INSERT INTO #RR  
     SELECT Sampleset_id, Sampleunit_id, intSampled, intUD, intReturned  
     FROM Datamart.QP_Comments.dbo.RespRateCount  
     WHERE Survey_id = @TempSurvey  
     AND Sampleset_id IN (SELECT SampleSet_id FROM #SampleSets)  
  
     SELECT @intSamplePlan_id=SamplePlan_id   
     FROM SamplePlan WITH (NOLOCK)   
     WHERE Survey_id=@TempSurvey  
       
     EXEC sp_SampleUnits @intSamplePlan_id  
  
     UPDATE su SET intTargetReturn = s.intTargetReturn  
     FROM #Sampleunits su INNER JOIN Sampleunit s ON su.Sampleunit_id = s.Sampleunit_id  
  
     SELECT '''' + ISNULL(CONVERT(VARCHAR(250),strSampleUnit_nm),'Total outgo') AS SampleUnit,  
       #RR.Sampleunit_id AS [Unit ID],  
       ISNULL(su.intTreeOrder,0) AS DummyOrder,  
       SUM(intSampled) AS Sampled,   
       SUM(intUD) AS Nondel,   
       SUM(intReturned) AS Returned,  
       su.inttargetreturn AS Target,  
       SUM(intReturned)/CONVERT(FLOAT,SUM(intSampled-intUD)) AS 'Current RespRate'  
     INTO #a  
     FROM #RR LEFT OUTER JOIN #Sampleunits su ON #RR.Sampleunit_id=su.Sampleunit_id  
     GROUP BY strSampleUnit_nm, #RR.SampleUnit_id, su.inttargetreturn, su.intTreeOrder  
     HAVING SUM(intSampled)-SUM(intUD)>0  
     UNION  
     SELECT ''''+ISNULL(CONVERT(VARCHAR(250),strSampleUnit_nm),'Total outgo') AS SampleUnit,  
       #RR.Sampleunit_id AS [Unit ID],  
       su.intTreeOrder AS dummyOrder,  
       SUM(intSampled) AS Sampled,   
       SUM(intUD) AS Nondel,   
       SUM(intReturned) AS Returned,  
       su.inttargetreturn AS Target,  
       CONVERT(INT,null) AS 'Current RespRate'  
     FROM #RR LEFT OUTER JOIN #Sampleunits su ON #RR.Sampleunit_id=su.Sampleunit_id  
     GROUP BY strSampleUnit_nm, #RR.SampleUnit_id, su.inttargetreturn, su.intTreeOrder  
     HAVING SUM(intSampled)-SUM(intUD)=0  
  
     INSERT INTO #UnitDisplay (StudyOrder, SurveyOrder, StudyID, SurveyID, ContractNumber, StudyName, SurveyName, SampleUnit, [Unit ID],   
      DummyOrder, Sampled, NonDel, Returned, [Current RespRate])  
     SELECT @StudyOrder, @SurveyOrder, @TempStudy, @TempSurvey, null as ContractNumber, '''' + @TempStudyName, '''' + @TempSurveyName,   
      '''' + 'Total Outgo', 0, -1, SUM(intSampled), SUM(intUD), SUM(intReturned),   
      (SUM(intReturned)*1.0)/(SUM(intSampled)-SUM(intUD))  
     FROM Datamart.QP_Comments.dbo.RespRateCOUNT  
     WHERE Survey_id = @TempSurvey  
     AND Sampleset_id IN (SELECT SampleSet_id FROM #SampleSets)  
  
     INSERT INTO #UnitDisplay (StudyOrder, SurveyOrder, StudyID, SurveyID, ContractNumber, StudyName, SurveyName, SampleUnit, [Unit ID], DummyOrder)  
     SELECT  @StudyOrder, @SurveyOrder, @TempStudy, @TempSurvey, null as ContractNumber, '''' + @TempStudyName, '''' + @TempSurveyName,    
      '''' + strSampleUnit_nm, SampleUnit_id, intTreeOrder  
     FROM #SampleUnits  
     ORDER BY intTreeOrder  
  
     UPDATE d  
     SET d.[Unit ID] = a.[Unit ID],   
      d.DummyOrder = a.DummyOrder,   
      d.Sampled = a.Sampled,   
      d.Nondel = a.Nondel,   
      d.Returned = a.Returned,   
      d.Target = a.Target,   
      d.[Current Resprate] = a.[Current RespRate]  
     FROM #UnitDisplay d INNER JOIN #a a ON d.[Unit ID] = a.[Unit ID]  
  
     UPDATE d  
     SET d.Target = su.intTargetReturn  
     FROM #UnitDisplay d INNER JOIN SampleUnit su ON d.[unit id] = su.SampleUnit_id  
     WHERE Target IS NULL  
  
     UPDATE #UnitDisplay  
     SET [N-D] = ROUND((Nondel/(Sampled * 1.0)) * 100, 2)  
     WHERE [Unit ID] = 0  
  
     INSERT INTO #Display  
     SELECT * FROM #UnitDisplay  
  
     DROP TABLE #a  
  
     DELETE FROM #SurveyList WHERE SurveyID = @TempSurvey  
     SELECT TOP 1 @TempSurvey = SurveyID, @TempSurveyname = SurveyName FROM #SurveyList  
    END  
  
   -- Roll up all the surveys for the study  
   INSERT INTO #Display (StudyOrder, SurveyOrder, StudyID, SurveyID, StudyName, SurveyName, SampleUnit, [Unit ID],   
    DummyOrder, Sampled, NonDel, Returned, [Current RespRate], [N-D])  
   SELECT @StudyOrder, 0, @TempStudy, @TempSurvey, '''' + @TempStudyName, '''' + @TempSurveyName,   
    '''' + 'Total Outgo', -1, -2, SUM(Sampled), SUM(NonDel), SUM(Returned),   
    (SUM(Returned)*1.0)/(SUM(Sampled)-SUM(NonDel)),  
    ROUND((SUM(NonDel)/(SUM(Sampled) * 1.0)) * 100, 2)  
   FROM #Display  
   WHERE StudyID = @TempStudy AND [Unit ID] = 0  
  
   DELETE FROM #StudyList WHERE StudyID = @TempStudy  
   SELECT TOP 1 @TempStudy = StudyID, @TempStudyname = StudyName FROM #StudyList  
  END  

  --Update ContractNumber
  update d
  set d.ContractNumber = isnull(sd.Contract, 'Missing')
  from Survey_def sd, #Display d
  where sd.Survey_ID = d.SurveyID
  
 IF @Study = '_ALL'  
  BEGIN  
   -- Roll up all the studies for the client.  
   INSERT INTO #Display (StudyOrder, SurveyOrder, StudyID, SurveyID, ContractNumber, StudyName, SurveyName, SampleUnit, [Unit ID],   
    DummyOrder, Sampled, NonDel, Returned, [Current RespRate], [N-D])  
   SELECT 0, 0, @TempStudy, @TempSurvey, '' as ContractNumber, '''' + @TempStudyName, '''' + @TempSurveyName,   
    '''' + 'Total Outgo', -2, -3, SUM(Sampled), SUM(NonDel), SUM(Returned),   
    (SUM(Returned)*1.0)/(SUM(Sampled)-SUM(NonDel)),  
    ROUND((SUM(NonDel)/(SUM(Sampled) * 1.0)) * 100, 2)  
   FROM #Display  
   WHERE [Unit ID] = -1  
  
   SELECT   
    CASE   
     WHEN [Unit ID] = -2 THEN '''All Studies'  
     WHEN [Unit ID] = -1 THEN RTRIM(StudyName) + '(' + CONVERT(VARCHAR, StudyID) + ')'   
     ELSE '' END AS Study,   
    CASE   
     WHEN [Unit ID] = -1 THEN '''All Surveys'  
     WHEN [Unit ID] = 0 THEN RTRIM(SurveyName) + '(' + CONVERT(VARCHAR, SurveyID) + ')'   
     ELSE '' END AS Survey,  
    ContractNumber, 
    SampleUnit,   
    CASE   
     WHEN [Unit ID] < 0 THEN 0   
     ELSE [Unit ID] END AS [Unit ID],   
    Sampled, Nondel, Returned, Target,   
    ROUND(([Current RespRate] * 100), 2) AS [Current RespRate],  
    [N-D]  
   FROM #Display ORDER BY StudyOrder, SurveyOrder, DummyOrder  
  END  
 ELSE IF @Survey = '_ALL'  
  BEGIN  
   SELECT   
    CASE   
     WHEN [Unit ID] = -1 THEN '''All Surveys'  
     WHEN [Unit ID] = 0 THEN RTRIM(SurveyName) + '(' + CONVERT(VARCHAR, SurveyID) + ')'   
     ELSE '' END AS Survey,
    ContractNumber,    
    SampleUnit,   
    CASE  
     WHEN [Unit ID] < 0 THEN 0  
     ELSE [Unit ID] END AS [Unit ID],   
    Sampled, Nondel, Returned, Target,   
    ROUND(([Current RespRate] * 100), 2) AS [Current RespRate],  
    [N-D]  
   FROM #Display ORDER BY SurveyOrder, DummyOrder  
  END  
 ELSE  
  BEGIN  
   SELECT SampleUnit, [Unit ID], Sampled, Nondel, Returned, Target,   
   ROUND(([Current RespRate] * 100), 2) AS [Current RespRate], [N-D]  
   FROM #Display WHERE [Unit ID] >= 0  
   ORDER BY DummyOrder  
  END  
  
 DROP TABLE #RR  
 DROP TABLE #Sampleunits  
 DROP TABLE #StudyList  
 DROP TABLE #SurveyList  
 DROP TABLE #UnitDisplay  
 DROP TABLE #Display  
 DROP TABLE #SampleSets  
  
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
END


