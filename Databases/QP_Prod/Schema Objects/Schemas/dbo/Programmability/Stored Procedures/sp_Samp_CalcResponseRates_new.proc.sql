/****** Object:  Stored Procedure dbo.sp_Samp_CalcResponseRates    Script Date: 9/28/99 2:57:11 PM ******/
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
			
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_CalcResponseRates_new
 @intSurvey_id INT
AS
 DECLARE @ResponseRate_Recalc_Period INT
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
   AND datSampleCreate_dt > DATEADD(MONTH,-18,GETDATE())

SELECT SampleUnit_id, ((SUM(intReturned)*1.0)/(SUM(intSampled)-SUM(intUD))*100) AS RespRate
INTO #r
FROM RespRateCount rrc, #SampleSets ss
WHERE SampleUnit_id <> 0
AND rrc.SampleSet_id = ss.SampleSet_id
GROUP BY SampleUnit_id

UPDATE SampleUnit
SET numResponseRate = RespRate
FROM #r
WHERE SampleUnit.SampleUnit_id = #r.SampleUnit_id

DROP TABLE #r
DROP TABLE #max


