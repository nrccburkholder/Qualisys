CREATE PROCEDURE [dbo].[qp_rep_people_sampled_Phone]      
 @Associate VARCHAR(50),      
 @Client VARCHAR(50),      
 @Study VARCHAR(50),      
 @Survey VARCHAR(50),      
 @FirstSampleSet DATETIME,      
 @LastSampleSet DATETIME,    
 @inDebug bit = 0      
AS      
      
    
    
-- Modified 5/6/05 SJS : Added @ordername to fix DSQL because previous code failed when the study did not have a FName and LName column (ie. DrFirstName, DrLastName....)      
-- Modified 11/09/06 GN: Added WAC      
-- Created New proc based off of qp_rep_people_sampled2    
    
--EXEC master.dbo.xp_sendmail @recipients='bdohmen', @subject='qp_rep_people_sampled', @message=@Associate      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
DECLARE @Study_id INT, @Survey_id INT, @sql VARCHAR(900), @ordername VARCHAR(30)      
      
    
-- MODIFIED to not use clientstudysurvey_view since that view doesn't include surveys that don't have a methodology set up      
--SELECT TOP 1 @Survey_id=Survey_id, @Study_id=Study_id, @Ordername = '' FROM ClientStudySurvey_view WHERE strClient_nm=@Client AND strStudy_nm=@Study AND strSurvey_nm=@Survey      
SELECT TOP 1 @Survey_id=Survey_id, @Study_id=st.Study_id, @Ordername = ''       
FROM client c, study st, survey_def sd       
WHERE strClient_nm=@Client       
 AND strStudy_nm=@Study       
 AND strSurvey_nm=@Survey      
 AND c.client_id=st.client_id      
 AND st.study_id=sd.study_id      
      
if @inDebug = 1    
 begin      
  print '@Study_id ' + cast(@Study_id as varchar(100))    
  print '@Survey_id ' + cast(@Survey_id as varchar(100))    
  print '@FirstSampleSet ' + cast(@FirstSampleSet as varchar(100))    
  print '@LastSampleSet ' + cast(@LastSampleSet as varchar(100))    
    
 end    
    
SELECT SampleSet_id, CONVERT(VARCHAR(19),datSampleCreate_dt,120) AS 'Date Sampled', survey_ID      
INTO #Sampleset      
FROM SampleSet      
WHERE Survey_id=@Survey_id      
AND CONVERT(VARCHAR,datSampleCreate_dt,120) BETWEEN CONVERT(VARCHAR,@FirstSampleSet,120) AND CONVERT(VARCHAR,@LastSampleSet,120)      
      
if @inDebug = 1    
 select '#Sampleset' as [#Sampleset], * from #Sampleset    
    
SELECT sp.SamplePop_id, ISNULL(MIN(strLithoCode),'NotPrinted') Litho, [Date Sampled], ss.survey_ID      
INTO #SamplePop       
FROM #SampleSet ss, SamplePop sp LEFT OUTER JOIN ScheduledMailing schm ON sp.SamplePop_id=schm.SamplePop_id      
 LEFT OUTER JOIN SentMailing sm ON schm.SentMail_id=sm.SentMail_id      
WHERE ss.SampleSet_id=sp.SampleSet_id      
GROUP BY sp.SamplePop_id, [Date Sampled],ss.survey_ID       
      
if @inDebug = 1    
 select '#SamplePop' as [#Sampleset], * from #SamplePop    
    
    
/*      
field_id    strfield_nm                
----------- --------------------       
137         AreaCode      
76          Phone     
6   LName    
7   FName    
9           Addr      
10          City      
11          ST      
12          ZIP5     
54    DischargeDate    
26    LangID     
64    DischargeUnit    
149   ServiceIndicator    
174   ServiceInd_10    
1179  ServiceInd_100    
    
NOTE: area code and Phone are missing from this list because they have to be combined together     
down below it is known that if these fields do not exist the report will blow up.    
    
*/      
    
------SELECT strField_nm      
------INTO #Fields      
------FROM MetaData_View      
------WHERE Field_id IN (6,7,9,10,11,12,54,26,64,149,174)      
------AND Study_id=@Study_ID    
------      
------SET @SQL=''      
------    
------SELECT @SQL=@SQL+','+strField_nm      
------FROM #Fields      
      
SET @SQL=''    
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 137) and    
   exists (select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 76)    
begin    
 set @SQL = @SQL + ', ISNULL(LTRIM(RTRIM(LEFT(AreaCode,3))),'''')+LTRIM(RTRIM(Phone)) as Phone '    
end    
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 7)    
 set @SQL = @SQL + ', FName '    
else    
 set @SQL = @SQL + ', '''' as FName '   
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 6)    
 set @SQL = @SQL + ', LName '    
else    
 set @SQL = @SQL + ', '''' as LName '    
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 9)    
 set @SQL = @SQL + ', Addr '    
else    
 set @SQL = @SQL + ', '''' as Addr '    
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 10)    
 set @SQL = @SQL + ', City '    
else    
 set @SQL = @SQL + ', '''' as City '    
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 11)    
 set @SQL = @SQL + ', St '    
else    
 set @SQL = @SQL + ', '''' as St '    
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 12)    
 set @SQL = @SQL + ', Zip5 '    
else    
 set @SQL = @SQL + ', '''' as Zip5 '    
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 54)    
 set @SQL = @SQL + ', DischargeDate '    
else    
 set @SQL = @SQL + ', '''' as DischargeDate '    
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 26)    
 set @SQL = @SQL + ', LangID '    
else    
 set @SQL = @SQL + ', '''' as LangID '    
    
--hard coded for now until we start doing telematch in house    
set @SQL = @SQL + ', '''' as [Telematch #]'    
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 64)    
 set @SQL = @SQL + ', DischargeUnit '    
else    
 set @SQL = @SQL + ', '''' as DischargeUnit '    
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 149)    
 set @SQL = @SQL + ', ServiceIndicator '    
else    
 set @SQL = @SQL + ', '''' as ServiceIndicator '    
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 174)    
 set @SQL = @SQL + ', ServiceInd_10 '    
else    
 set @SQL = @SQL + ', '''' as ServiceInd_10 '    
    
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 208)    
 set @SQL = @SQL + ', ServiceInd_19 '    
else    
 set @SQL = @SQL + ', '''' as ServiceInd_19 '    
  
if exists(select 'x' from MetaData_View where study_ID = @Study_ID and field_ID = 1179)    
 set @SQL = @SQL + ', Serviceind_100 '    
else    
 set @SQL = @SQL + ', '''' as Serviceind_100 '    
  
    
if @inDebug = 1    
 print @SQL    
    
IF EXISTS (SELECT * FROM METADATA_VIEW WHERE STUDY_iD = @study_id AND strField_Nm IN ('FName','LName'))      
 SET @ordername = ' LName, FName '      
      
IF EXISTS(SELECT strTable_nm FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')      
SET @SQL='SELECT DISTINCT Litho, Survey_ID '+@SQL+' '+CHAR(10)+      
'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, #SamplePop t, SelectedSample sel, S'+CONVERT(VARCHAR,@Study_id)+'.Encounter e'+CHAR(10)+      
'WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+      
'AND sp.Pop_id=p.Pop_id'+CHAR(10)+      
'AND sp.Pop_id=sel.Pop_id'+CHAR(10)+      
'AND sp.SampleSet_id=sel.SampleSet_id'+CHAR(10)+      
'AND sel.Enc_id=e.Enc_id'+CHAR(10)+      
'ORDER BY ' + @Ordername      
ELSE      
SET @SQL='SELECT DISTINCT Litho, Survey_ID '+@SQL+' '+CHAR(10)+      
'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, #SamplePop t'+CHAR(10)+      
'WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+      
'AND sp.Pop_id=p.Pop_id'+CHAR(10)+      
'ORDER BY ' + @Ordername      
      
if @inDebug = 1    
 print @sql      
    
EXEC (@sql)      
      
DROP TABLE #SAMPLESET      
DROP TABLE #SAMPLEPOP


