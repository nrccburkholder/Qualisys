--DRM 09/28/2011 Added check for positive pop_id values, i.e. filter out seed mailing data.
CREATE PROCEDURE [dbo].[qp_rep_people_sampled2]  
 @Associate VARCHAR(50),  
 @Client VARCHAR(50),  
 @Study VARCHAR(50),  
 @Survey VARCHAR(50),  
 @FirstSampleSet DATETIME,  
 @LastSampleSet DATETIME  
AS  
  
-- Modified 5/6/05 SJS : Added @ordername to fix DSQL because previous code failed when the study did not have a FName and LName column (ie. DrFirstName, DrLastName....)  
-- Modified 11/09/06 GN: Added WAC  
  
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
  
SELECT SampleSet_id, CONVERT(VARCHAR(19),datSampleCreate_dt,120) AS 'Date Sampled'  
INTO #Sampleset  
FROM SampleSet  
WHERE Survey_id=@Survey_id  
AND CONVERT(VARCHAR,datSampleCreate_dt,120) BETWEEN CONVERT(VARCHAR,@FirstSampleSet,120) AND CONVERT(VARCHAR,@LastSampleSet,120)  
  
SELECT sp.SamplePop_id, ISNULL(MIN(strLithoCode),'NotPrinted') Litho, [Date Sampled]  
INTO #SamplePop   
FROM #SampleSet ss, SamplePop sp LEFT OUTER JOIN ScheduledMailing schm ON sp.SamplePop_id=schm.SamplePop_id  
 LEFT OUTER JOIN SentMailing sm ON schm.SentMail_id=sm.SentMail_id  
WHERE ss.SampleSet_id=sp.SampleSet_id  
GROUP BY sp.SamplePop_id, [Date Sampled]  
  
IF EXISTS (SELECT * FROM METADATA_VIEW WHERE STUDY_iD = @study_id AND strField_Nm IN ('FName','LName'))  
 SET @ordername = ' , FName, LName'  
  
IF EXISTS(SELECT strTable_nm FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')  
SET @SQL='SELECT DISTINCT sp.SampleSet_id AS ''Sample Set'', Litho, CASE WHEN ISNUMERIC(Litho)=1 THEN DBO.LITHOTOWAC (Litho) ELSE Litho END WAC, CASE WHEN ISNUMERIC(Litho)=1 THEN dbo.LithoToBarCode(Litho,1) ELSE Litho END BarCode,'+CHAR(10)+  
'[Date Sampled], p.*, e.*'+CHAR(10)+  
'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, #SamplePop t, SelectedSample sel, S'+CONVERT(VARCHAR,@Study_id)+'.Encounter e'+CHAR(10)+  
'WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+  
'AND sp.Pop_id=p.Pop_id'+CHAR(10)+  
'AND sp.Pop_id=sel.Pop_id'+CHAR(10)+  
'AND sp.SampleSet_id=sel.SampleSet_id'+CHAR(10)+  
'AND sel.Enc_id=e.Enc_id'+CHAR(10)+  
'AND p.pop_id>0'+CHAR(10)+				--DRM 9/28/2011
'ORDER BY sp.SampleSet_id, [Date Sampled]' + @Ordername  
ELSE  
SET @sql='SELECT DISTINCT sp.SampleSet_id AS ''Sample Set'', Litho, CASE WHEN ISNUMERIC(Litho)=1 THEN DBO.LITHOTOWAC (Litho) ELSE Litho END WAC, CASE WHEN ISNUMERIC(Litho)=1 THEN dbo.LithoToBarCode(Litho,1) ELSE Litho END BarCode,'+CHAR(10)+  
'[Date Sampled], p.*'+CHAR(10)+  
'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, #SamplePop t'+CHAR(10)+  
'WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+  
'AND sp.Pop_id=p.Pop_id'+CHAR(10)+  
'AND p.pop_id>0'+CHAR(10)+				--DRM 9/28/2011
'ORDER BY sp.SampleSet_id, [Date Sampled]' + @Ordername  
  
--SELECT @sql  
EXEC (@sql)  
  
DROP TABLE #SAMPLESET  
DROP TABLE #SAMPLEPOP


