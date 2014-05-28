CREATE PROCEDURE [dbo].[qp_rep_People_Undeliverable]
 @Associate VARCHAR(50),
 @Client VARCHAR(50),
 @Study VARCHAR(50),
 @Survey VARCHAR(50),
 @FirstSampleSet DATETIME,
 @LastSampleSet DATETIME
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @Study_id INT, @Survey_id INT, @sql VARCHAR(900)
-- MODIFIED to not use clientstudysurvey_view since that view doesn't include surveys that don't have a methodology set up
--SELECT TOP 1 @Survey_id=Survey_id, @Study_id=Study_id FROM ClientStudySurvey_view WHERE strClient_nm=@Client AND strStudy_nm=@Study AND strSurvey_nm=@Survey
SELECT TOP 1 @Survey_id=Survey_id, @Study_id=st.Study_id 
FROM client c, study st, survey_def sd 
WHERE strClient_nm=@Client 
	AND strStudy_nm=@Study 
	AND strSurvey_nm=@Survey
	AND c.client_id=st.client_id
	AND st.study_id=sd.study_id
/*
field_id    strfield_nm          
----------- -------------------- 
9           Addr
10          City
11          ST
12          ZIP5
23          Zip4
76          Phone
*/
SELECT strField_nm
INTO #Fields
FROM MetaData_View
WHERE Field_id IN (9,10,11,12,23,76)
AND Study_id=@Study_id

SET @SQL=''

SELECT @SQL=@SQL+','+strField_nm
FROM #Fields

IF EXISTS(SELECT strTable_nm FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')
SET @SQL='SELECT DISTINCT p.FName, p.LName, p.Age, p.Sex'+@sql+CHAR(10)+
'FROM s'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, SampleSet ss, SelectedSample sel, s'+CONVERT(VARCHAR,@Study_id)+'.Encounter e, ScheduledMailing um, SentMailing sm '+CHAR(10)+
'WHERE p.Pop_id=sp.Pop_id'+CHAR(10)+
'AND sp.SampleSet_id=ss.SampleSet_id'+CHAR(10)+
'AND ss.Survey_id='+CONVERT(VARCHAR,@Survey_id)+CHAR(10)+
'AND sp.Pop_id=sel.Pop_id'+CHAR(10)+
'AND ss.SampleSet_id=sel.SampleSet_id '+CHAR(10)+
'AND CONVERT(VARCHAR,ss.datSampleCreate_dt,120) BETWEEN '''+CONVERT(VARCHAR,@FirstSampleSet,120)+''' AND '''+CONVERT(VARCHAR,@LastSampleSet,120)+''''+CHAR(10)+
'AND sel.Enc_id=e.Enc_id '+CHAR(10)+
'AND sp.SamplePop_id = um.SamplePop_id ' +CHAR(10)+
'AND um.SentMail_id = sm.SentMail_id ' +CHAR(10)+
'AND sm.datUndeliverable is not null ' +CHAR(10)+
'ORDER BY p.LName, p.FName'
ELSE
SET @sql='SELECT DISTINCT p.FName, p.LName, p.Age, p.Sex '+@sql +CHAR(10)+
'FROM s'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, SampleSet ss, ScheduledMailing um, SentMailing sm '+CHAR(10)+
'WHERE ss.Survey_id='+CONVERT(VARCHAR,@Survey_id)+CHAR(10)+
'AND sp.Pop_id=p.Pop_id'+CHAR(10)+
'AND sp.SampleSet_id=ss.SampleSet_id'+CHAR(10)+
'AND CONVERT(VARCHAR,ss.datSampleCreate_dt,120) BETWEEN '''+CONVERT(VARCHAR,@FirstSampleSet,120)+''' AND '''+CONVERT(VARCHAR,@LastSampleSet,120)+''''+CHAR(10)+
'AND sp.SamplePop_id = um.SamplePop_id ' +CHAR(10)+
'AND um.SentMail_id = sm.SentMail_id ' +CHAR(10)+
'AND sm.datUndeliverable is not null ' +CHAR(10)+
'ORDER BY p.LName, p.FName'

--SELECT @sql
EXEC (@sql)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


