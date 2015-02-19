CREATE PROCEDURE [dbo].[QP_REP_People_Sampled_HCAHPS]  
 @Associate VARCHAR(50),  
 @Client VARCHAR(50),  
 @Study VARCHAR(50),  
 @Survey VARCHAR(50),  
 @FirstSampleSet DATETIME,  
 @LastSampleSet DATETIME  

AS  

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @Study_id INT, @Survey_id INT, @sql VARCHAR(1000), @ordername VARCHAR(30)

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
SET @SQL='SELECT DISTINCT ''THIS IS A TEST REPORT'' [THIS IS A TEST REPORT],'+char(10)+
'sp.SampleSet_id AS ''Sample Set'', Litho, CASE WHEN ISNUMERIC(Litho)=1 THEN DBO.LITHOTOWAC (Litho) ELSE Litho END WAC, CASE WHEN ISNUMERIC(Litho)=1 THEN dbo.LithoToBarCode(Litho,1) ELSE Litho END BarCode,'+CHAR(10)+
'[Date Sampled], p.*, e.*'+CHAR(10)+
'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p'+char(10)+
'inner join samplepop sp on (sp.pop_id=p.pop_id)'+char(10)+
'inner join #samplepop t on (t.samplepop_id=sp.samplepop_id)'+char(10)+
'inner join selectedsample sel on (sel.sampleset_id=sp.sampleset_id and sel.pop_id=sp.pop_id)'+char(10)+
'inner join s'+CONVERT(VARCHAR,@Study_id)+'.Encounter e on (e.enc_id=sel.enc_id)'+CHAR(10)+
'inner join sampleunit su on (sel.sampleunit_id=su.sampleunit_id)'+char(10)+
'left outer join EligibleEncLog he (nolock)'+CHAR(10)+
	'on ((he.sampleset_id=sp.sampleset_id) and (he.pop_id=p.pop_id) and (he.enc_id=e.enc_id))'+char(10)+
'where su.bithcahps=1'+char(10)+
'and (he.enc_id+he.pop_id is not null)'+char(10)+
'ORDER BY sp.SampleSet_id, [Date Sampled]' + @Ordername
ELSE
SET @sql='SELECT DISTINCT sp.SampleSet_id AS ''Sample Set'', Litho, CASE WHEN ISNUMERIC(Litho)=1 THEN DBO.LITHOTOWAC (Litho) ELSE Litho END WAC, CASE WHEN ISNUMERIC(Litho)=1 THEN dbo.LithoToBarCode(Litho,1) ELSE Litho END BarCode,'+CHAR(10)+
'[Date Sampled], p.*'+CHAR(10)+
'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, #SamplePop t'+CHAR(10)+
'WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+
'AND sp.Pop_id=p.Pop_id'+CHAR(10)+
'ORDER BY sp.SampleSet_id, [Date Sampled]' + @Ordername

EXEC (@sql)

DROP TABLE #SAMPLESET
DROP TABLE #SAMPLEPOP

