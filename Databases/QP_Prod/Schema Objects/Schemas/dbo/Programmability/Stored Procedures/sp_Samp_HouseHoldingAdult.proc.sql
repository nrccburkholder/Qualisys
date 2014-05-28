/****** Object:  Stored Procedure dbo.sp_Samp_HouseHoldingAdult    Script Date: 9/28/99 2:57:15 PM ******/
/***********************************************************************************************************************************
SP Name: sp_Samp_HouseHoldingAdult
Part of:  Sampling Tool
Purpose:  Householding algorithm for householding option: All
  1. Compare Householding between all people in the Universe with all 
   people in other Sample Sets
  2. Compare Householding of all people in the Universe among themselves
Input:  
  #SampleUnit_Universe   Temp table containing the universe for each sample units
  @Study_id     Study Identifier 
  @strHouseholdField_CreateTable  List of fields and type that are used for HouseHolding criteria 
  @strHouseholdField_Select   List of fields that are used for HouseHolding criteria 
  @strHousehold_Join    Join criteria that are used for HouseHolding 
  @lngReSurveyEx_Period   Survey exclusion period (in days) 
 
Output:  
  #SampleUnit_Universe   Temp table containing the universe for each sample units
Creation Date: 09/15/1999
Author(s): DA, RC 
Revision: First build - 09/15/1999
v2.0.1 - 3/3/2000 - Dave Gilsdorf
removed @strMinorException_Where parameter - it wasn't used anyway
v2.0.2 - 3/10/2004 - DC
	Modified to use the random number table.
***********************************************************************************************************************************/
CREATE     PROCEDURE sp_Samp_HouseHoldingAdult
 @Study_id     INT,   /* Study Identifier */
 @strHouseholdField_CreateTable  VARCHAR(8000), /* List of fields and type that are used for HouseHolding criteria */
 @strHouseholdField_Select   VARCHAR(8000), /* List of fields that are used for HouseHolding criteria */
 @strHousehold_Join    VARCHAR(8000), /* Join criteria that are used for HouseHolding */
 @lngReSurveyEx_Period   INT ,  /* Survey exclusion period (in days) */
 @seed int /*The random number seed*/
AS
 DECLARE @HHRemoveRule  TINYINT 
 DECLARE @strSQL  VARCHAR(8000)
 /* sets variable @HHRemoveRule with appropriate code for Removed_Rule field of 
  #SampleUnit_Universe for Adult Householding*/
 SET @HHRemoveRule = 7

	--insert into dc_temp_timer (sp, starttime)
	--values ('sp_Samp_HouseHoldingAdult', getdate())
/***********************************************************
 Creation of local temporary tables
***********************************************************/
 CREATE TABLE #Random_Pop
  (ID_num int identity,
  Pop_id INT, 
  numRandom FLOAT(24))
/**************************************************************************************
  (b1) Compare Householding between all people in the Universe with all 
 people in other Sample Sets
**************************************************************************************/
 /* (b1a) Set "#SampleUnit_Universe.bitRemove" = 1 on those people who have the same 
  address as somebody in any other sample set on the study who has not 
  completed a mailing methodology. */
 SELECT @strSQL = 
  'UPDATE #SampleUnit_Universe
   SET Removed_Rule = ' + CONVERT(VARCHAR, @HHRemoveRule) + '
   FROM #SampleUnit_Universe Y, 
    S' + CONVERT(VARCHAR, @Study_id) + '.Population X, 
    dbo.SamplePop SP, 
    dbo.ScheduledMailing SchM, 
    dbo.MailingStep MS
   WHERE Y.Pop_id = SP.Pop_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.MailingStep_id = MS.MailingStep_id
    AND SchM.SentMail_id IS NULL
    AND ' + @strHousehold_Join + '
    AND SP.Study_id = ' + CONVERT(VARCHAR, @Study_id) + '
    AND MS.bitThankYouItem = 0
    AND Y.Removed_Rule = 0'
 -- PRINT @strSQL
 EXECUTE (@strSQL)
 /* (b1c) Insert the Householding fields and mailing date of the last mailing item 
  sent for any houshold represented in #SampleUnit_Universe table. */
 SELECT @strSQL = 
  'INSERT INTO #Max_MailingDate
   SELECT ' + @strHouseholdField_Select + ', MAX (SM.datMailed)
    FROM #SampleUnit_Universe X, 
     S' + CONVERT(VARCHAR, @Study_id) + '.Population Y, 
     dbo.SamplePop SP, 
     dbo.ScheduledMailing SchM, 
     dbo.SentMailing SM, 
     dbo.MailingStep MS
    WHERE Y.Pop_id = SP.Pop_id
     AND SP.SamplePop_id = SchM.SamplePop_id
     AND SchM.ScheduledMailing_id = SM.ScheduledMailing_id
     AND SchM.MailingStep_id = MS.MailingStep_id
     AND ' + @strHousehold_Join + '
     AND SP.Study_id = ' + CONVERT(VARCHAR, @Study_id) + '
     AND X.Removed_Rule = 0
     AND MS.bitThankYouItem = 0
    GROUP BY ' + @strHouseholdField_Select
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (b1d) Set "#SampleUnit_Universe.bitRemove" = 1 if a record matches the householding 
  fields of the #Max_Mailing table, and the "#Max_Mailing.datMailed" is within the 
  Re-Survey exclusion number of days from the current date. */
 SELECT @strSQL = 
  'UPDATE #SampleUnit_Universe
   SET Removed_Rule = ' + CONVERT(VARCHAR, @HHRemoveRule) + '
   FROM #SampleUnit_Universe X, 
    #Max_MailingDate Y
   WHERE ' + @strHousehold_Join + '
    AND X.Removed_Rule = 0
    AND DATEDIFF(day, Y.datMailed, GETDATE()) < ' 
     + CONVERT(VARCHAR, @lngReSurveyEx_Period)
 --PRINT @strSQL
 EXECUTE (@strSQL)
  
/**************************************************************************************
  (b2) Compare Householding of all people in the Universe among themselves
**************************************************************************************/
 /* (b2b) Insert the Householding fields from #SampleUnit_Universe into #HH_Dup_Fields where 
  more than one person in #SampleUnit_Universe has the sample Householding fields.  
  Do not include anybody where "SampleUnit_Universe.bitHousehold_Remove" = 1. */
 SELECT @strSQL = 
  'INSERT INTO #HH_Dup_Fields
   SELECT ' + @strHouseholdField_Select + '
    FROM #SampleUnit_Universe X
    WHERE Removed_Rule = 0
    GROUP BY ' + @strHouseholdField_Select + '
    HAVING COUNT(*) > 1'
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (b2d) Insert the distinct Pop_id and Householding Fields of the people from 
  #SampleUnit_Universe into #HH_Dup_People whose Householding fields are the same as 
  the Householding fields in #HH_Dup_Fields. */
 SELECT @strSQL = 
  'INSERT INTO #HH_Dup_People
   SELECT DISTINCT Pop_id, ' + @strHouseholdField_Select + ', 0
    FROM #HH_Dup_Fields X, 
     S' + CONVERT(VARCHAR, @Study_id) + '.Population Y
    WHERE ' + @strHousehold_Join
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (b2f) Assign a random number to each record in #HH_Dup_Fields. */
 /* (b2g) Update the "bitKeep" field = 1 in #HH_Dup_Fields for each Householding fields record 
  that has the smallest "numRandom" value. */
 /* Assign a Random number to each duped record of the #Minor_Universe */
 
 INSERT INTO #Random_Pop 
 SELECT Pop_id, numrandom
 FROM #HH_Dup_People dp, random_numbers rn
 WHERE ((dp.id_num+@Seed)%1000000)=rn.random_id
 ORDER BY numrandom

 /* (b2g) Update the "bitKeep" field = 1 in #HH_Dup_Fields for each Householding fields record 
  that has the smallest "numRandom" value. */
 SELECT @strSQL = 'UPDATE #HH_Dup_People
   SET bitKeep = 1
   FROM #HH_Dup_People HHDP, #Random_Pop Y, 
		(SELECT ' + @strHouseholdField_Select + ', MIN(Y.id_num) as id_num
    	FROM #HH_Dup_People X, #Random_Pop Y
    	WHERE X.Pop_id = Y.Pop_id
    	GROUP BY ' + @strHouseholdField_Select + ') AK
    WHERE HHDP.Pop_id = Y.Pop_id
     AND Y.id_num = AK.id_num'
 EXECUTE (@strSQL)
 /* (b2h) Set "#SampleUnit_Universe.bitHousehold_Remove" = 1 where a person has a 
  "#HH_Dup_Fields.bitKeep" = 0. */
 UPDATE #SampleUnit_Universe
  SET Removed_Rule = @HHRemoveRule
  FROM #SampleUnit_Universe SU, #HH_Dup_People HH
  WHERE SU.Pop_id = HH.Pop_id
   AND HH.bitKeep = 0
 /* Drop temporary tables. */
 --DROP TABLE #Adult_Keep
 DROP TABLE #Random_Pop


