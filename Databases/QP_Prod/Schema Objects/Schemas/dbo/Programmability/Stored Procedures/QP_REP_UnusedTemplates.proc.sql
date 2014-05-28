CREATE PROCEDURE QP_REP_UnusedTemplates @BeginDate DATETIME  
AS  
  
IF @BeginDate > DATEADD(DAY,-75,GETDATE())  
BEGIN  
 CREATE TABLE #Display (NoData VARCHAR(200))  
 INSERT INTO #Display SELECT 'The date has to be at least 75 days in the past.'  
 SELECT * FROM #Display  
 DROP TABLE #Display  
 RETURN  
END  
  
DECLARE @sql VARCHAR(8000)  
  
SET @SQL = 'SELECT strClient_nm, c.Client_id, strStudy_nm, s.Study_id, strSurvey_nm, sd.Survey_id, LastReturn  ' + CHAR(10) +  
 ' FROM Client c (NOLOCK), Study s (NOLOCK), Survey_Def sd (NOLOCK), (  ' + CHAR(10) +  
  ' SELECT Survey_id, MAX(datResultsImported) LastReturn  ' + CHAR(10) +  
  ' FROM QuestionForm (NOLOCK)  ' + CHAR(10) +  
  ' WHERE datResultsImported > ''' + CONVERT(VARCHAR(10),@BeginDate,120) + '''' + CHAR(10) +  
  ' GROUP BY Survey_id) o  ' + CHAR(10) +  
 ' WHERE o.LastReturn < DATEADD(DAY,-75,GETDATE()) ' + CHAR(10) +  
 ' AND o.Survey_id = sd.Survey_id  ' + CHAR(10) +  
 ' AND sd.Study_id = s.Study_id  ' + CHAR(10) +  
 ' AND s.Client_id = c.Client_id ' + CHAR(10) +  
 ' ORDER BY 1,3,5 '  
  
EXEC (@sql)


