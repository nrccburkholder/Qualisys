/***********************************************************************************************************************************
SP Name: sp_Samp_DeDupUnitUnivStaticV2 
Part of:  Sampling Tool
Purpose:  This stored procedure randomly eliminates duplicates encounters from the Root Unit of the
  #SampleUnit_Universe table, and then eliminates the eliminated Root encounters from the
  rest of the #SampleUnit_Universe..
Input:  Data contained on #SampleUnit_Universe
 
Output:  Updated #SampleUnit_Universe table
Creation Date: 02/05/2004
Author(s): DC 
Revision: First build - 02/05/2004
	  9/29/05 DC - Added code to undup all encounters when we do census sampling

***********************************************************************************************************************************/
CREATE                    PROCEDURE sp_Samp_DeDupUnitUnivStaticV2
	@seed as int
AS
	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_DeDupUnitUnivStaticV2', getdate())
	

  /* creating the temporary tables used within this SP */
 CREATE TABLE #Dup_GroupedSampleUnitPop
  (Pop_id INT)
 CREATE TABLE #Dup_SampleUnit_Pop
  (id_num INT Identity,
  Pop_id INT, 
  Enc_id INT)
 CREATE TABLE #Dup_SampleUnit_Pop2
  (id_num INT Identity,
  Pop_id INT, 
  Enc_id INT,
  numRandom int, 
  bitKeep bit)
 CREATE INDEX idxSamplePop
  ON #Dup_SampleUnit_Pop(Pop_id)
 /*Identify the Root Sample Unit*/
  SELECT distinct SUU.SampleUnit_id
	into #roots
  FROM #SampleUnit_Universe SUU, dbo.SampleUnit SU
  WHERE SUU.SampleUnit_id = SU.SampleUnit_id
   AND SU.ParentSampleUnit_id IS NULL

 /* Identifies the duplicate records from the sampleUnit Universe */
 /* Only look at targetted units so when we do the random sample we don't*/
 /* accidentally pick an encounter that isn't eligible for any targeted units*/
 /* Identifies the duplicate records from the sampleUnit Universe */
 INSERT INTO #Dup_GroupedSampleUnitPop
  SELECT Pop_id
   FROM #SampleUnit_Universe
   WHERE (Removed_Rule IS NULL
    OR Removed_Rule = 0)
    AND SampleUnit_id in (select sampleunit_id
			from #roots)
   GROUP BY Pop_id
   HAVING COUNT(distinct enc_id) > 1

 /* Determine what the sampling methodology is */
 declare @survey_id int, @strsamplingmethod_nm varchar(100)
 set @strsamplingmethod_nm=''
 select top 1 @survey_id=survey_id
 from sampleunit s, #roots r, sampleplan sp
 where s.sampleunit_id=r.sampleunit_id and
	s.sampleplan_id=sp.sampleplan_id
	
 if @survey_id is not null exec SP_Period_GetCurrentSamplingMethodOutputParam @survey_id, @strsamplingmethod_nm output
 
 /* Indentifies each record that is part of a duplicate record grouping in order to use a 
 random algorithm to keep only one record per duplicate record grouping.
 Make sure we only keep encounters from units with targets.  We had a problem
 before where the encounter kept didn't qualify for any targeted units.  This
 caused that pop_id to essentially be excluded from sampling*/
 if @strsamplingmethod_nm<>'CENSUS'
 Begin
  INSERT INTO #Dup_SampleUnit_Pop
  SELECT DISTINCT SUU.Pop_id, SUU.Enc_id /*, NULL, 0*/
   FROM #SampleUnit_Universe SUU, #Dup_GroupedSampleUnitPop DGSUP, dbo.sampleunit s
   WHERE DGSUP.Pop_id = SUU.Pop_id
    AND SUU.SampleUnit_id = s.sampleunit_id
    AND s.inttargetreturn > 0
 End
 Else
 Begin
  INSERT INTO #Dup_SampleUnit_Pop
  SELECT DISTINCT SUU.Pop_id, SUU.Enc_id /*, NULL, 0*/
   FROM #SampleUnit_Universe SUU, #Dup_GroupedSampleUnitPop DGSUP, dbo.sampleunit s
   WHERE DGSUP.Pop_id = SUU.Pop_id
    AND SUU.SampleUnit_id = s.sampleunit_id
 End
 /* Assigning a random number to all duplicate records */

 INSERT INTO #Dup_SampleUnit_Pop2 
 SELECT Pop_id, Enc_id, numrandom, 0
 FROM #Dup_SampleUnit_Pop dsp, random_numbers rn
 WHERE ((dsp.id_num+@Seed)%1000000)=rn.random_id
 ORDER BY Pop_id, numrandom


 /* Keeps one record per groupings of duplicate records (the one that has been assigned the lowest random number for the grouping) */

 UPDATE #Dup_SampleUnit_Pop2
  SET bitKeep = 1
  FROM (SELECT Pop_id, MIN(id_num) AS id_num 
        FROM #Dup_SampleUnit_Pop2 
        GROUP BY Pop_id) DDSUP, #Dup_SampleUnit_Pop2 DDSUP2
   WHERE DDSUP2.id_num=DDSUP.id_num

 /* Updates #SampleUnit_Universe with the removed_rule flag set to 5 */
 UPDATE #SampleUnit_Universe
  SET Removed_Rule = 5
   FROM #SampleUnit_Universe SUU, #Dup_SampleUnit_Pop2 DSUP
   WHERE SUU.Pop_id = DSUP.Pop_id and
		 SUU.Removed_Rule=0

 UPDATE #SampleUnit_Universe
  SET Removed_Rule = 0
   FROM #SampleUnit_Universe SUU, #Dup_SampleUnit_Pop2 DSUP
   WHERE SUU.Pop_id = DSUP.Pop_id
    AND SUU.Enc_id = DSUP.Enc_id
    AND DSUP.bitKeep = 1
    AND SUU.Removed_Rule=5
 /* dropping local temporary tables */
 DROP TABLE #Dup_SampleUnit_Pop
 DROP TABLE #Dup_SampleUnit_Pop2
 DROP TABLE #Dup_GroupedSampleUnitPop
 DROP TABLE #Roots


