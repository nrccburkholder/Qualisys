/****** Object:  Stored Procedure dbo.sp_Samp_ExecuteSampling    Script Date: 9/28/99 2:57:13 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_ExecuteSampling
Part of:  Sampling Tool
Purpose:  
Input:  
 
Output:  
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
10/26/1999 - DG: "SET ROWCOUNT = @intOutgo" would cause everybody to be sampled if @intOutgo=0.  
Put "IF @intOutGo>0" before BEGIN..END block.
***********************************************************************************************************************************/
CREATE PROCEDURE sp_Samp_ExecuteSampling
 @intSampleUnit_id int,
 @intSampleSet_id int
AS 
 DECLARE @intOutgo int
 DECLARE @numRand float(24)
 DECLARE @Pop_id int
 DECLARE @intStudy_id int
 /*Fetch the Study id*/
 SELECT @intStudy_id = SD.Study_id
  FROM dbo.Survey_def SD, dbo.SampleSet SS
  WHERE SD.Survey_id = SS.Survey_id
   AND SS.SampleSet_id = @intSampleSet_id
 /*Calculate the outgo*/
 EXECUTE dbo.sp_Samp_CalcOutgo @intSampleUnit_id, @intSampleSet_id, @intOutgo OUTPUT
 select @intOutgo
 IF @intOutgo > 0 
 BEGIN
  SET NOCOUNT ON
 
  CREATE TABLE #Random_Pop 
   (Pop_id int, numRandom float(24))
 
  CREATE TABLE #Sampled_Pop 
   (Pop_id int)
 
  /*Assign a Random number to each record in the Sample Unit Universe 
    on the current Sample Unit*/
  DECLARE curSampleUnit_Univ CURSOR
   FOR SELECT Pop_id
    FROM #SampleUnit_Universe 
    WHERE SampleUnit_id = @intSampleUnit_id
     AND Removed_Rule = 0
     AND strUnitSelectType = 'N'
  --BEGIN TRANSACTION
   OPEN curSampleUnit_Univ 
  
   FETCH NEXT FROM curSampleUnit_Univ INTO @Pop_id
   
   WHILE @@FETCH_STATUS = 0
   BEGIN
    INSERT INTO #Random_Pop (Pop_id, numRandom)
     VALUES (@Pop_id, RAND())
    FETCH NEXT FROM curSampleUnit_Univ INTO @Pop_id
   END
  --COMMIT TRANSACTION
 
  CLOSE curSampleUnit_Univ 
  DEALLOCATE curSampleUnit_Univ 
 
  SET NOCOUNT OFF
  /*In numRandom order, take the first @intOutgo number of records
    and add them to the Selected Sample Table*/
  SET ROWCOUNT @intOutgo
 
  /* Directly Sample the first @intOutgo Sample Unit Univers records for the Sample Unit, in ascending order by the random number*/
  
  INSERT INTO #Sampled_Pop
   SELECT Pop_id
   FROM #Random_Pop
    ORDER BY numRandom ASC
  SET ROWCOUNT 0
  UPDATE #SampleUnit_Universe
   SET strUnitSelectType = 'D'
   FROM #Sampled_Pop SP
   WHERE #SampleUnit_Universe.Pop_id = SP.Pop_id
    AND #SampleUnit_Universe.SampleUnit_id = @intSampleUnit_id
    AND #SampleUnit_Universe.Removed_Rule = 0
  DROP TABLE #Random_Pop
  DROP TABLE #Sampled_Pop
 END


