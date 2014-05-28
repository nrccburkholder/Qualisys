/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It determines
which records should be DQ'd because of resurvey exclusion

Created:  02/28/2006 by DC

Modified:
03/01/2006 BY Brian Dohmen  Incorporated Calendar Month as a resurvey method.
*/  
CREATE PROCEDURE [dbo].[QCL_SampleSetResurveyExclusion]
 @Study_id INT,
 @ReSurveyMethod_id INT,
 @ReSurvey_Excl_Period INT,
 @SamplingAlgorithmID INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

IF @ReSurveyMethod_id=1
BEGIN

 SELECT DISTINCT sp.Pop_id
 INTO #Remove_Pops
 FROM SamplePop sp, SampleSet ss
 WHERE Study_id=@Study_id AND
	sp.SampleSet_id=ss.SampleSet_id AND
	(DATEDIFF(day,ss.datLastMailed,GETDATE())<@Resurvey_Excl_Period
			OR ss.datLastMailed IS NULL)	

 --Removed Rule value of 1 means it is resurvey exclusion.  This is not a bit field.
 UPDATE #SampleUnit_Universe
  SET Removed_Rule = 1  
  FROM #SampleUnit_Universe U, #Remove_Pops MM
  WHERE U.Pop_id=MM.Pop_id AND
		Removed_Rule=0

 DROP TABLE #Remove_Pops

END
ELSE IF @ReSurveyMethod_id=2
BEGIN

 DECLARE @minDate DATETIME, @maxDate DATETIME, @sql VARCHAR(200)

 SELECT @minDate=MIN(EncDate), @maxDate=MAX(EncDate) FROM #SampleUnit_Universe

 SELECT @minDate=dbo.FirstDayOfMonth(@minDate)
 SELECT @maxDate=DATEADD(SECOND,-1,DATEADD(MONTH,1,dbo.FirstDayOfMonth(@maxDate)))

 UPDATE #SampleUnit_Universe SET ReSurveyDate=dbo.FirstDayOfMonth(EncDate) 

 --Get the distinct months of the reportdate for each pop_id
 SELECT a.Pop_id, dbo.FirstDayOfMonth(sampleEncounterDate) ReSurveyDate
 INTO #ReSurvey
 FROM (
      --Get all the reportdates for all the eligible records for sample
      SELECT t.Pop_id, sampleEncounterDate 
      FROM SelectedSample ss, #SampleUnit_Universe t
      WHERE t.Pop_id=ss.Pop_id
      AND ss.Study_id=@Study_id
      AND sampleEncounterDate BETWEEN @minDate AND @maxDate) a 
 GROUP BY a.Pop_id, dbo.FirstDayOfMonth(sampleEncounterDate)

 CREATE INDEX tmpIndex ON #ReSurvey (Pop_id)

 UPDATE u
  SET Removed_Rule=1  
  FROM #SampleUnit_Universe U, #ReSurvey MM
  WHERE U.Pop_id=MM.Pop_id 
  AND U.ReSurveyDate=MM.ReSurveyDate
  AND Removed_Rule=0

 DROP TABLE #ReSurvey

END

IF @SamplingAlgorithmID=3
BEGIN
	--Now to remove everyone in the household if anyone in the household is removed
	DECLARE @sel varchar(500)
	SET @sel='UPDATE t
	SET t.Removed_Rule=1
	FROM #SampleUnit_Universe t, (
				 SELECT ISNULL(HouseHold_id,id_num) HouseHold_id
				 FROM #SampleUnit_Universe 
				 WHERE Removed_Rule=1 
				 GROUP BY ISNULL(HouseHold_id,id_num)) a
	WHERE a.HouseHold_id=ISNULL(t.HouseHold_id,id_num)'

	EXEC (@sel)
END


