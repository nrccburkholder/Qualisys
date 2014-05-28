/*
Business Purpose: 
This is a modification of QCL_CalcResponseRates for analysis of proposed changes to the time period for
response rate calculations. Instead of updating the sampleunit table, it is writing to a perma-temp table
that is only for this analysis.

Created 12/06/2012 by dmp
Original proc Created:  02/24/2006 by DC


Modified:
03/15/2006 Brian Dohmen	  Made the datamart location a variable so it will work in Canada.
			  I also incorporated the HCAHPS 6 week cutoff
*/  
CREATE PROCEDURE [dbo].[dmp_QCL_CalcResponseRates_SurvVolTest_24]
 @Survey_id INT

AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @sql VARCHAR(8000), @DataMart VARCHAR(50), @ResponseRate_Recalc_Period int

SELECT @DataMart=strParam_Value FROM QualPro_Params WHERE strParam_nm='DataMart'

 /* Fetch the Response Rate Recalculation Period */
 SELECT @ResponseRate_Recalc_Period=intResponse_Recalc_Period
  FROM Survey_def
  WHERE Survey_id=@Survey_id

CREATE TABLE #SampleSets (SampleSet_id INT, datsamplecreate_dt datetime)
 /* Mark the Sample Sets that have completed the collection methodology */
 INSERT INTO #SampleSets
 SELECT SampleSet_id, datsamplecreate_dt
  FROM SampleSet
  WHERE datLastMailed IS NOT NULL
   AND DATEDIFF(DAY, datLastMailed, GETDATE())>@ResponseRate_Recalc_Period
   --is datLastMailed within the past 24 months? 
   and datediff(month, dateadd(month, -24, getdate()),datlastmailed) >= 0
   AND Survey_id=@Survey_id
   
--create table temp_dmp_rrcheck_samplesets (sampleset_id int, datsamplecreate_dt datetime)

insert into temp_dmp_rrcheck_samplesets
select * from #samplesets

CREATE TABLE #r (SampleUnit_id INT, intSampled INT, intReturned INT, bitHCAHPS BIT)
CREATE TABLE #rr (sampleset_id INT, sampleunit_id INT, intreturned INT, intsampled INT, intUD INT)

SELECT @sql='insert into #rr 
			Exec '+@DataMart+'.qp_comments.dbo.QCL_SelectRespRateInfoBySurveyId ' + convert(varchar,@Survey_id) 
EXEC (@sql)

--SELECT SampleUnit_id, ((SUM(intReturned)*1.0)/(SUM(intSampled)-SUM(intUD))*100) AS RespRate
SELECT @sql='INSERT INTO #r (SampleUnit_id, intSampled, intReturned, bitHCAHPS)
SELECT SampleUnit_id, SUM(intSampled), SUM(intReturned), 0
FROM #rr rrc, #SampleSets ss
WHERE rrc.SampleSet_id=ss.SampleSet_id
GROUP BY SampleUnit_id'
EXEC (@sql)

--Identify HCAHPS units
UPDATE t
SET bitHCAHPS=1
FROM #r t, SampleUnit su
WHERE t.SampleUnit_id=su.SampleUnit_id
AND su.bitHCAHPS=1

IF @@ROWCOUNT>0
BEGIN

CREATE TABLE #Update (SampleUnit_id INT, intReturned INT)
CREATE TABLE #rrDays (sampleset_id INT, sampleunit_id INT, intreturned INT)

SELECT @sql='insert into #rrDays 
			Exec '+@DataMart+'.qp_comments.dbo.QCL_SelectHCAHPSRespRateByDaysInfoBySurveyId ' + convert(varchar,@Survey_id) 
EXEC (@sql)

 --Update the response rate for the HCAHPS unit(s)
 SELECT @sql='INSERT INTO #Update (SampleUnit_id, intReturned)
 SELECT a.SampleUnit_id, a.intReturned
 FROM (SELECT tt.SampleUnit_id, SUM(r2.intReturned) intReturned
       FROM #rr rrc, 
       #rrDays r2, 
       #SampleSets ss, #r tt
  WHERE rrc.SampleSet_id=ss.SampleSet_id
  AND r2.sampleset_id=ss.sampleset_id
  AND tt.SampleUnit_id=rrc.SampleUnit_id
  AND tt.bitHCAHPS=1
  AND tt.SampleUnit_id=r2.SampleUnit_id
  AND ss.datSampleCreate_dt>''4/10/6''
  GROUP BY tt.SampleUnit_id) a, #r t
  WHERE a.SampleUnit_id=t.SampleUnit_id

 INSERT INTO #Update (SampleUnit_id, intReturned)
 SELECT a.SampleUnit_id, a.intReturned
 FROM (SELECT tt.SampleUnit_id, SUM(rrc.intReturned) intReturned
       FROM #rr rrc, 
       #SampleSets ss, #r tt
  WHERE rrc.SampleSet_id=ss.SampleSet_id
  AND tt.SampleUnit_id=rrc.SampleUnit_id
  AND tt.bitHCAHPS=1
  AND ss.datSampleCreate_dt<''4/10/6''
  GROUP BY tt.SampleUnit_id) a, #r t
  WHERE a.SampleUnit_id=t.SampleUnit_id'

 EXEC (@sql)

 UPDATE t
 SET intReturned=u.intReturned
 FROM #r t, (SELECT SampleUnit_id, SUM(intReturned) intReturned
 FROM #Update
 GROUP BY SampleUnit_id) u
 WHERE t.SampleUnit_id=u.SampleUnit_id

 DROP TABLE #Update

END

/** don't want to update real sampleunit data
UPDATE su
SET numResponseRate=RespRate
FROM SampleUnit su, (SELECT SampleUnit_id, ((intReturned*1.0)/(intSampled)*100) RespRate
FROM #r) a
WHERE su.SampleUnit_id=a.SampleUnit_id


UPDATE su
SET numResponseRate=numInitResponseRate
FROM SampleUnit su, (
         SELECT SampleUnit_id 
         FROM SampleUnit s, SamplePlan sp 
         WHERE sp.Survey_id=@Survey_id
         AND sp.SamplePlan_id=s.SamplePlan_id) a LEFT JOIN #r t
ON a.SampleUnit_id=t.SampleUnit_id
WHERE t.SampleUnit_id IS NULL
AND a.SampleUnit_id=su.SampleUnit_id
**/

-- create a table to hold results
--create table dbo.temp_dmp_RRAnalysis (sampleunit_id int, RR float, RR12 float, RR18 float, RR24 float)
--drop table dbo.temp_dmp_RRAnalysis



update rra
set RR24 = resprate
FROM dbo.temp_dmp_RRAnalysis rra, SampleUnit su, (SELECT SampleUnit_id, ((intReturned*1.0)/(intSampled)*100) RespRate
FROM #r) a
WHERE rra.sampleunit_id = su.sampleunit_id
and rra.sampleunit_id = a.sampleunit_id
and su.SampleUnit_id=a.SampleUnit_id

DROP TABLE #r

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


