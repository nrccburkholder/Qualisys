/***********************************************************************************************************************************
SP Name: sp_Samp_DeDupUnitUniverseV2
Part of:  Sampling Tool
Purpose:  This stored procedure randomly eliminates duplicates from the #SampleUnit_Universe table.
Input:  Data contained on #SampleUnit_UnivDyn
 
Output:  Updated #SampleUnit_Universe table
Creation Date: 02/05/2004
Author(s): DC 
Revision: First build - 02/05/2004

***********************************************************************************************************************************/
CREATE           PROCEDURE sp_Samp_DeDupUnitUnivDynV2
	@seed as int
AS

	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_DeDupUnitUnivDynV2', getdate())

 /* creating the temporary tables used within this SP */
 CREATE TABLE #Dup_GroupedSampleUnitPop
  (SampleUnit_id INT, 
  Pop_id INT)
 /*CREATE TABLE #Dup_SampleUnit_Pop
  (SampleUnit_id INT, 
  Pop_id INT, 
  Enc_id INT,
  numRandom FLOAT(24), 
  bitKeep bit)*/
 CREATE TABLE #Dup_SampleUnit_Pop
  (id_num INT Identity,
	SampleUnit_id INT, 
  	Pop_id INT, 
  	Enc_id INT)
 CREATE TABLE #Dup_SampleUnit_Pop2
  (id_num INT Identity,
  SampleUnit_id INT, 
  Pop_id INT, 
  Enc_id INT,
  numRandom int, 
  bitKeep bit)
 CREATE INDEX idxSamplePop
  ON #Dup_SampleUnit_Pop2(SampleUnit_id, Pop_id)

 /* Identifies the duplicate records from the sampleUnit Universe */
 INSERT INTO #Dup_GroupedSampleUnitPop
  SELECT SampleUnit_id, Pop_id
   FROM #SampleUnit_Universe
   WHERE Removed_Rule IS NULL
    OR Removed_Rule = 0
   GROUP BY SampleUnit_id, Pop_id
   HAVING COUNT(*) > 1
 /* Indentifies each record that is part of a duplicate record grouping in order to use a 
 random algorithm to keep only one record per duplicate record grouping */
 INSERT INTO #Dup_SampleUnit_Pop
  SELECT SUU.SampleUnit_id, SUU.Pop_id, SUU.Enc_id /*, NULL, 0*/
   FROM #SampleUnit_Universe SUU, #Dup_GroupedSampleUnitPop DGSUP
   WHERE DGSUP.Pop_id = SUU.Pop_id
    AND DGSUP.SampleUnit_id = SUU.SampleUnit_id
	AND (Removed_Rule IS NULL
    OR Removed_Rule = 0)
 /* Assigning a random number to all duplicate records */

 INSERT INTO #Dup_SampleUnit_Pop2 
 SELECT sampleunit_id, Pop_id, Enc_id, numrandom, 0
 FROM #Dup_SampleUnit_Pop dsp, random_numbers rn
 WHERE ((dsp.id_num+@Seed)%1000000)=rn.random_id
 ORDER BY sampleunit_id, Pop_id, numrandom

 /* Keeps one record per groupings of duplicate records (the one that has been assigned the lowest random number for the grouping) */

 UPDATE #Dup_SampleUnit_Pop2
  SET bitKeep = 1
  FROM #Dup_SampleUnit_Pop2 DSUP, 
       (SELECT Pop_id, SampleUnit_id, min(id_num) as id_num 
        FROM #Dup_SampleUnit_Pop2 
        GROUP BY Pop_id, SampleUnit_id) DDSUP
  WHERE DSUP.id_num = DDSUP.id_num

 /* Updates #SampleUnit_Universe with the removed_rule flag set to 5 */
 UPDATE #SampleUnit_Universe
  SET Removed_Rule = 5
   FROM #SampleUnit_Universe SUU, #Dup_SampleUnit_Pop2 DSUP
   WHERE SUU.SampleUnit_id = DSUP.sampleUnit_id
    AND SUU.Pop_id = DSUP.Pop_id
    AND SUU.Enc_id = DSUP.Enc_id
    AND DSUP.bitKeep = 0
 /* dropping local temporary tables */
 DROP TABLE #Dup_SampleUnit_Pop
 DROP TABLE #Dup_GroupedSampleUnitPop
 DROP TABLE #Dup_SampleUnit_Pop2


