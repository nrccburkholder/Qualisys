/***********************************************************************************************************************************
SP Name: sp_Samp_CalcResponseRates
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
Modified 7/7/3 BD Calculate the ResponseRate from the RespRateCount table.  This is a summary table of 
   current response rates as of current day.  
Modified 7/7/3 BD Only use SampleSets from the last 18 months.
Modified 8/24/2006 DC  Call SP in datamart to get back temp table of resprate information
   
***********************************************************************************************************************************/
CREATE PROCEDURE [dbo].[sp_Samp_CalcResponseRates]
 @intSurvey_id INT
AS
 DECLARE @ResponseRate_Recalc_Period INT
 
 --insert into dc_temp_timer (sp, starttime)
 --values ('sp_Samp_CalcResponseRates', getdate())
 
 /* Fetch the Response Rate Recalculation Period */
 SELECT @ResponseRate_Recalc_Period = intResponse_Recalc_Period
  FROM Survey_def
  WHERE Survey_id = @intSurvey_id
 
CREATE TABLE #SampleSets (SampleSet_id INT)
 /* Mark the Sample Sets that have completed the collection methodology */
 INSERT INTO #SampleSets
 SELECT SampleSet_id
  FROM SampleSet
  WHERE datLastMailed IS NOT NULL
   AND DATEDIFF(DAY, datLastMailed, GETDATE()) > @ResponseRate_Recalc_Period
   AND Survey_id = @intSurvey_id
--Added 7/3/3 BD Only keep samplesets from the last 18 months.
   --AND datSampleCreate_dt > DATEADD(MONTH,-12,GETDATE())
 
DECLARE @sql VARCHAR(2000), @Server VARCHAR(50)
 
SELECT @Server=strParam_Value FROM QualPro_Params WHERE strParam_nm='DataMart'
 
CREATE TABLE #r (SampleUnit_id INT, RespRate FLOAT)
CREATE TABLE #rr (sampleset_id INT, sampleunit_id INT, intreturned INT, intsampled INT, intUD INT)
 
--SELECT SampleUnit_id, ((SUM(intReturned)*1.0)/(SUM(intSampled)-SUM(intUD))*100) AS RespRate
SELECT @sql='insert into #rr
			Exec '+@Server+'.qp_comments.dbo.QCL_SelectRespRateInfoBySurveyId ' + convert(varchar,@intSurvey_id) 
EXEC (@sql)

INSERT INTO #r 
SELECT SampleUnit_id, ((SUM(intReturned)*1.0)/(SUM(intSampled))*100) AS RespRate
FROM #rr rrc, #SampleSets ss
WHERE rrc.SampleSet_id = ss.SampleSet_id
GROUP BY SampleUnit_id
 
UPDATE SampleUnit
SET numResponseRate = RespRate
FROM #r
WHERE SampleUnit.SampleUnit_id = #r.SampleUnit_id
 
DROP TABLE #r


