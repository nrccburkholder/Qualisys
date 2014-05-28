/****** Object:  Stored Procedure dbo.sp_Samp_DeDupUnitUnivStatic    Script Date: 9/28/99 2:57:12 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_DeDupUnitUnivStatic 
Part of:  Sampling Tool
Purpose:  This stored procedure randomly eliminates duplicates encounters from the Root Unit of the
  #SampleUnit_Universe table, and then eliminates the eliminated Root encounters from the
  rest of the #SampleUnit_Universe..
Input:  Data contained on #SampleUnit_Universe
 
Output:  Updated #SampleUnit_Universe table
Creation Date: 09/08/1999
Author(s): DA, RC 
Revision: First build - 09/08/1999
v2.0.1 - 2/3/2000 Dave Gilsdorf
   duplicate random numbers in #Dup_SampleUnit_Pop caused primary key violation in UniKeys
   It took three f***in' weeks to figure this out!
v2.0.2 - 2/29/2000 Dave Gilsdorf
   Changed the way random numbers were assigned so it doesn't have to use an UPDATE cursor
 v2.0.3 - 2-3-2004 DC
	Changed the random number generation to use an insert into a new table instead of
	updating the original table.
 V2.0.4 - 2-4-2004
	Changed code to use a table with random numbers.
***********************************************************************************************************************************/
CREATE      PROCEDURE sp_Samp_DeDupUnitUnivStatic
AS
	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_DeDupUnitUnivStatic', getdate())

 DECLARE @intRootSampleUnit_id int
 /* creating the temporary tables used within this SP */
 CREATE TABLE #Dup_GroupedSampleUnitPop
  (Pop_id INT)
 CREATE TABLE #Dup_SampleUnit_Pop
  (id_num INT Identity,
  Pop_id INT, 
  Enc_id INT)
 CREATE TABLE #Dup_SampleUnit_Pop2
  (Pop_id INT, 
  Enc_id INT,
  numRandom int, 
  bitKeep bit)
 CREATE INDEX idxSamplePop
  ON #Dup_SampleUnit_Pop(Pop_id)
 /*Identify the Root Sample Unit*/
 SELECT @intRootSampleUnit_id = SUU.SampleUnit_id
  FROM #SampleUnit_Universe SUU, dbo.SampleUnit SU
  WHERE SUU.SampleUnit_id = SU.SampleUnit_id
   AND SU.ParentSampleUnit_id IS NULL
 /* Identifies the duplicate records from the sampleUnit Universe */
 INSERT INTO #Dup_GroupedSampleUnitPop
  SELECT Pop_id
   FROM #SampleUnit_Universe
   WHERE (Removed_Rule IS NULL
    OR Removed_Rule = 0)
    AND SampleUnit_id = @intRootSampleUnit_id
   GROUP BY Pop_id
   HAVING COUNT(*) > 1
 /* Indentifies each record that is part of a duplicate record grouping in order to use a 
 random algorithm to keep only one record per duplicate record grouping */
 INSERT INTO #Dup_SampleUnit_Pop
  SELECT SUU.Pop_id, SUU.Enc_id /*, NULL, 0*/
   FROM #SampleUnit_Universe SUU, #Dup_GroupedSampleUnitPop DGSUP
   WHERE DGSUP.Pop_id = SUU.Pop_id
    AND SUU.SampleUnit_id = @intRootSampleUnit_id
 /* Assigning a random number to all duplicate records */
 /*declare @intPop_id int, @intEnc_id int
 DECLARE curDupPop CURSOR FORWARD_ONLY 
  FOR SELECT pop_id,enc_id FROM #Dup_SampleUnit_Pop
 OPEN curDupPop 
 FETCH NEXT FROM curDupPop into @intPop_id, @intEnc_id
 WHILE @@FETCH_STATUS = 0
 BEGIN
  UPDATE #Dup_SampleUnit_Pop
   SET numRandom = RAND() 
   WHERE Pop_id=@intPop_id and Enc_id=@intEnc_id
  FETCH NEXT FROM curDupPop into @intPop_id, @intEnc_id
 END
 CLOSE curDupPop 
 DEALLOCATE curDupPop*/ 

 /*declare @intPop_id int, @intEnc_id int
 DECLARE curDupPop CURSOR FORWARD_ONLY 
  FOR SELECT pop_id, enc_id FROM #Dup_SampleUnit_Pop
 OPEN curDupPop 
 FETCH NEXT FROM curDupPop into @intPop_id, @intEnc_id
 WHILE @@FETCH_STATUS = 0
 BEGIN
  Insert into #Dup_SampleUnit_Pop2 (pop_id, enc_id, numrandom, bitkeep)
   values (@intPop_id, @intEnc_id, RAND(),0) 
  FETCH NEXT FROM curDupPop into @intPop_id, @intEnc_id
 END
 CLOSE curDupPop 
 DEALLOCATE curDupPop */

DECLARE @seed int
 SELECT @Seed=round(rand()*1000000,0)

 INSERT INTO #Dup_SampleUnit_Pop2 
 SELECT Pop_id, Enc_id, numrandom, 0
 FROM #Dup_SampleUnit_Pop dsp, random_numbers rn
 WHERE ((dsp.id_num+@Seed)%1000000)=rn.random_id

--We need to check for the rare possibility that 2 encounters for the same person
--get the same random number.  If found, we need to assign new random numbers to all
--encounters for that unit.  If we only assign new random numbers to the records
--with duplicates random numbers, we may introduce a bias.
 SELECT Pop_id, numrandom
 INTO #DupRandom
 FROM #Dup_SampleUnit_Pop2
 GROUP BY Pop_id, numrandom
 HAVING COUNT(*)>1

 declare @intPop_id int, @intEnc_id int
 DECLARE curDupPop CURSOR FORWARD_ONLY 
  FOR SELECT dsp.pop_id, dsp.enc_id 
		FROM #Dup_SampleUnit_Pop2 dsp, #DupRandom dr
		WHERE dsp.pop_id=dr.pop_id
 OPEN curDupPop 
 FETCH NEXT FROM curDupPop into @intPop_id, @intEnc_id
 WHILE @@FETCH_STATUS = 0
 BEGIN
  UPDATE #Dup_SampleUnit_Pop2
   SET numRandom = RAND() 
   WHERE Pop_id=@intPop_id and Enc_id=@intEnc_id
  FETCH NEXT FROM curDupPop into @intPop_id, @intEnc_id
 END
 CLOSE curDupPop 
 DEALLOCATE curDupPop 
 /* Keeps one record per groupings of duplicate records (the one that has been assigned the lowest random number for the grouping) */
 /* UPDATE #Dup_SampleUnit_Pop      *
  *  SET bitKeep = 1                *
  *   WHERE numRandom IN            *
  *    (SELECT MIN(numRandom)       *
  *     FROM #Dup_SampleUnit_Pop    *
  *     GROUP BY Pop_id)            */
 UPDATE #Dup_SampleUnit_Pop2
  SET bitKeep = 1
  FROM #Dup_SampleUnit_Pop DSUP, 
       (SELECT Pop_id, MIN(numRandom) AS numRandom 
        FROM #Dup_SampleUnit_Pop2 
        GROUP BY Pop_id) DDSUP
   WHERE DSUP.numRandom = DDSUP.numRandom
     AND DSUP.Pop_id = DDSUP.Pop_id
 /* Updates #SampleUnit_Universe with the removed_rule flag set to 5 */
 UPDATE #SampleUnit_Universe
  SET Removed_Rule = 5
   FROM #SampleUnit_Universe SUU, #Dup_SampleUnit_Pop2 DSUP
   WHERE SUU.Pop_id = DSUP.Pop_id
    AND SUU.Enc_id = DSUP.Enc_id
    AND DSUP.bitKeep = 0
 /* dropping local temporary tables */
 DROP TABLE #Dup_SampleUnit_Pop
 DROP TABLE #Dup_SampleUnit_Pop2
 DROP TABLE #Dup_GroupedSampleUnitPop


