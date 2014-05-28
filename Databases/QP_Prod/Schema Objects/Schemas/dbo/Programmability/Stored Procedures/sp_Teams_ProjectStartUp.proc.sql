CREATE  PROCEDURE sp_Teams_ProjectStartUp @bitIncremental BIT = 0    
AS    
  
-- 1/14/2005     
-- Steve Spicka    
-- Uses teamstatus_workcompleted to populate a project_startup reporting table    
-- Called from sp_team_workcompleted @bitIncremental = 1 (for incremental updates using #Completed table from calling procedure)     
-- OR Can be run to repopulate the enitire set of data from the permanent table teamstaus_workcompleted    
--  
-- Modified 6/28/05 - SS -- Include all workcompleted in the output table, will use view to filter off single sample projects.  
-- Made changes to facilitate use of  project startup for project starup Exception Report  
    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
DECLARE @source_tbl VARCHAR(50), @sql VARCHAR(8000)  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
-- DECLARE @bitIncremental bit   
-- SET @bitincremental = 0  
  
--  drop table #survey  
SELECT wc.projectnumber, MIN(wc.surveyid) survey_id  
INTO #survey  
FROM teamstatus_workcompleted wc   
GROUP BY wc.projectnumber   
  
--  drop table #surveysampset  
SELECT wc.projectnumber, wc.surveyid survey_id, MIN(wc.sampleset) AS sampleset_id, CONVERT(INT,NULL) ExpectedSamples, CONVERT(CHAR(1),NULL) AS MonthWeek   
INTO #surveysampset  
FROM teamstatus_workcompleted wc, #survey svy WHERE wc.surveyid = svy.survey_id  
GROUP BY wc.projectnumber, wc.surveyid  
  
-- Identify samples per survey  
-- Drop table #sampcnt  
SELECT pd.survey_id, CONVERT(CHAR(1),NULL) MonthWeek, count(pds.perioddef_id) ExpectedSamples  
INTO #sampcnt  
FROM perioddef pd, perioddates pds, #surveysampset svs    
WHERE pd.perioddef_id = pds.perioddef_id AND pd.survey_id = svs.survey_id  
GROUP BY pd.survey_Id   
  
UPDATE sc SET sc.monthweek = pd.monthweek FROM perioddef pd, #sampcnt sc WHERE pd.survey_id = sc.survey_id AND EXISTS (SELECT * FROM (  
 SELECT SURVEY_ID, MAX(perioddef_id) perioddef_Id FROM PERIODDEF GROUP BY SURVEY_ID) pd2 WHERE pd.perioddef_id = pd2.perioddef_id)  
  
-- Update the expectes samples column  
UPDATE svs SET ExpectedSamples = sc.ExpectedSamples, svs.monthweek = sc.monthweek  FROM  #surveysampset svs, #sampcnt sc WHERE svs.survey_id = sc.survey_id  
  
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
--  DROP TABLE #FSS_FREQ    
-- SELECT svs.*, pd.MonthWeek     
-- INTO #fss_freq    
-- FROM #surveysampset svs, perioddef pd, perioddates pdt WHERE svs.survey_id = pd.survey_id and svs.sampleset_id = pdt.sampleset_id AND pd.perioddef_id = pdt.perioddef_id    
  
    
-- DROP TABLE #WC    
CREATE TABLE #wc (dummy_id int, Client varchar(40), ClientID varchar(5), AcctDir varchar(20), Study varchar(10), StudyID varchar(5), Survey varchar(10), SurveyID varchar(5), ProjectNumber varchar(4), MailFrequency varchar(9), monthweek char(1),   
mailfreqdays int, sampleset_id int, maildate varchar(32), ExpectedSamples INT)    
  
IF @bitIncremental = 1    
 SET @source_tbl = '#Completed'    
ELSE     
 BEGIN    
 SET @source_tbl = 'TeamStatus_WorkCompleted'    
 TRUNCATE TABLE Teamstatus_ProjectStartUp    
 END    
  
SET @SQL =     
 'INSERT INTO #wc (dummy_id, Client, ClientID, AcctDir, Study, StudyID, Survey, SurveyID, ProjectNumber, MailFrequency, monthweek, mailfreqdays, sampleset_id, maildate, ExpectedSamples)' + CHAR(10) +    
 'SELECT wc.dummy_id, wc.Client, wc.ClientID, wc.AcctDir, wc.Study, wc.StudyID, wc.Survey, wc.SurveyID, wc.ProjectNumber, wc.MailFrequency, svs.monthweek,' + CHAR(10) +     
 'CASE ' + CHAR(10) +     
 'WHEN svs.MonthWeek = ''Q'' THEN 91' + CHAR(10) +     
 'WHEN svs.MonthWeek = ''M'' THEN 30' + CHAR(10) +     
 'WHEN svs.MonthWeek = ''B''  THEN 14' + CHAR(10) +     
 'WHEN svs.MonthWeek = ''W''  THEN 7' + CHAR(10) +     
 'WHEN svs.MonthWeek = ''D''  THEN 1' + CHAR(10) +     
 'ELSE 0 END -- UNDEFINDED' + CHAR(10) +     
 'AS MailFreqDays,' + CHAR(10) +     
 'wc.SampleSet AS SampleSet_id, MIN(wc.MailDate) MailDate, ExpectedSamples' + CHAR(10) +     
    
 'FROM ' + @source_tbl + ' wc INNER JOIN #surveysampset svs ON wc.sampleset = svs.sampleset_id' + CHAR(10) +     
 'GROUP BY wc.dummy_id, wc.Client, wc.ClientID, wc.AcctDir, wc.Study, wc.StudyID, wc.Survey, wc.SurveyID, wc.ProjectNumber, wc.MailFrequency, svs.monthweek, wc.SampleSet, svs.ExpectedSamples'     
-- PRINT @SQL    
EXEC (@SQL)    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
DECLARE @wcs TABLE (sampleset_id INT)  
INSERT INTO @wcs SELECT DISTINCT sampleset_id FROM #WC  
  
DELETE ps  
FROM teamstatus_projectstartup ps, @wcs wcs  
WHERE ps.samplesetid = wcs.sampleset_id  
  
INSERT INTO TeamStatus_ProjectStartup (tswc_id, client, clientid, acctdir, study, studyid, survey, surveyid, projectnumber, taskspec_id, periodmailfreq, MailFreqDays, samplesetid, effective_dt, targetfirstmail_dt, firstmail_dt, Project_Startup_Days, ExpectedSamples)    
SELECT wc.dummy_id tswc_id, wc.Client, wc.ClientID, wc.AcctDir, wc.Study, wc.StudyID, wc.Survey, wc.SurveyID, wc.ProjectNumber, ts.taskspec_id, /*wc.MailFrequency,*/ wc.MonthWeek AS PeriodMailFreq ,wc.MailFreqDays,     
 wc.SampleSet_id AS SampleSetID,    
 ts.Effective_dt,     
 DATEADD(dd,MailFreqDays,ts.Effective_dt) TargetFirstMail_dt,    
 CONVERT(DATETIME,wc.MailDate) FirstMail_dt,     
 DATEDIFF(dd,DATEADD(dd,MailFreqDays,ts.Effective_dt),wc.MailDate)    
 AS Project_Startup_Days, wc.ExpectedSamples  
FROM #wc wc     
INNER JOIN #surveysampset svs ON wc.sampleset_id = svs.sampleset_id     
LEFT JOIN NRC32.CRIS_II.dbo.TaskSpec ts ON wc.projectnumber COLLATE DATABASE_DEFAULT = ts.projectnum COLLATE DATABASE_DEFAULT     
WHERE CLIENTID <> 443 AND ISNUMERIC(wc.PROJECTNUMBER) = 1    
    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
drop table #surveysampset    
drop table #survey  
drop table #wc    
drop table #sampcnt    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


