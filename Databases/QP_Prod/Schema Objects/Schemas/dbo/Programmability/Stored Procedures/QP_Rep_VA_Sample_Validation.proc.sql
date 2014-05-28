CREATE PROCEDURE QP_Rep_VA_Sample_Validation 
 @Associate VARCHAR(50),
 @Client VARCHAR(50),
 @Study VARCHAR(50),
 @Survey VARCHAR(50),
 @SampleSet VARCHAR(50)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @Survey_id INT, @SampleSet_id INT, @Study_id INT, @sql VARCHAR(8000)

SELECT @Survey_id=sd.Survey_id, @Study_id=s.Study_id
FROM Survey_def sd, Study s
WHERE s.strStudy_nm=@Study
  AND sd.strSurvey_nm=@Survey
  AND s.Study_id=sd.Study_id
  AND s.Client_id=794

SELECT @SampleSet_id=SampleSet_id
FROM SampleSet
WHERE Survey_id=@Survey_id
  AND ABS(DATEDIFF(SECOND,datSampleCreate_Dt,CONVERT(DATETIME,@sampleset)))<=1


CREATE TABLE #Freqs (Pop_id INT, SampleUnit_id INT, FacilityNum VARCHAR(42))

SET @sql='INSERT INTO #Freqs (Pop_id, SampleUnit_id, FacilityNum)'+CHAR(10)+
			'SELECT p.Pop_id, SampleUnit_id, FacilityNum'+CHAR(10)+
			'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p(NOLOCK), SelectedSample ss(NOLOCK)'+CHAR(10)+
			'WHERE ss.SampleSet_id='+CONVERT(VARCHAR,@SampleSet_id)+CHAR(10)+
			'AND ss.Pop_id=p.Pop_id'+CHAR(10)+
			'AND strUnitSelectType=''D'''

EXEC (@sql)

CREATE INDEX tmpIndex ON #Freqs (Pop_id, FacilityNum)

--Get the people that only have one sampleunit
SELECT strSampleUnit_nm, t.SampleUnit_id, t.FacilityNum, Count(*) CNT
FROM (SELECT Pop_id, FacilityNum FROM #Freqs GROUP BY Pop_id, FacilityNum HAVING COUNT(*)=1) a, #Freqs t, SampleUnit su
WHERE a.Pop_id=t.Pop_id
AND t.SampleUnit_id=su.SampleUnit_id
GROUP BY strSampleUnit_nm, t.SampleUnit_id, t.FacilityNum
UNION
--Get the people who are in multiple units, but only display the units without targets
SELECT strSampleUnit_nm, t.SampleUnit_id, t.FacilityNum, Count(*) CNT
FROM (SELECT Pop_id, FacilityNum FROM #Freqs GROUP BY Pop_id, FacilityNum HAVING COUNT(*)>1) a, #Freqs t, SampleUnit su
WHERE a.Pop_id=t.Pop_id
AND t.SampleUnit_id=su.SampleUnit_id
AND su.intTargetReturn=0
GROUP BY strSampleUnit_nm, t.SampleUnit_id, t.FacilityNum
ORDER BY t.FacilityNum
	
DROP TABLE #Freqs


