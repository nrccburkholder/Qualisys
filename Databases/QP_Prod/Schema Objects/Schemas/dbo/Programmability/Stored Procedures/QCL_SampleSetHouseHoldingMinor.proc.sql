/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It checks to
see if minor householing rules have been violated.

Created:  02/28/2006 by DC

Modified:

*/ 
CREATE       PROCEDURE [dbo].[QCL_SampleSetHouseHoldingMinor]
 @Study_id     INT,   /* Study Identifier */
 @strHouseholdField_CreateTable  VARCHAR(8000), /* List of fields and type that are used for HouseHolding criteria */
 @strHouseholdField_Select   VARCHAR(8000), /* List of fields that are used for HouseHolding criteria */
 @strHousehold_Join    VARCHAR(8000), /* Join criteria that are used for HouseHolding */
 @lngReSurveyEx_Period   INT,   /* Survey exclusion period (in days) */
 @strMinorException_Where   VARCHAR(8000)=NULL, /* Minor exclusion criteria (used in where clause) */
 @seed int /*Seed for joining to random number table*/
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

 DECLARE @HHRemoveRule  TINYINT 
 DECLARE @strSQL  VARCHAR(8000)
 /* sets variable @HHRemoveRule with appropriate code for Removed_Rule field of #SampleUnit_Universe 
  for Adult Householding */
 SET @HHRemoveRule = 6

/***********************************************************
 Creation of local temporary tables
***********************************************************/
 CREATE TABLE #Random_Pop 
  (id_num int identity, Pop_id INT, numRandom FLOAT(24))
/**************************************************************************************
 (a1) Compare Householding between Minors in the Sample Unit Universe with 
   Minors in other Sample Sets.
**************************************************************************************/
 /* (a1b) Insert everyone who is < 18 into #Minor_Universe, de-duped from #SampleUnit_Universe. */
 SELECT @strSQL = 
  'INSERT INTO #Minor_Universe
   SELECT DISTINCT X.Pop_id, ' + @strHouseholdField_Select + ', NULL, NULL, 0
    FROM #SampleUnit_Universe X
    WHERE X.Age < 18
     AND X.Removed_Rule = 0'
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (a1c) Retrieve the Minor Exception rule into strMinorException_Where. */
 /*
  Use the method FetchWhereClause_BV from the MTS object "CriteriaEditorMTS.cDataAccess" 
   passing in m_intMinorExcept_CritID to assign strMinorException_Where.
 */
 /* (a1d) Mark any minor that meets the Minor Exception Rule. */
 IF @strMinorException_Where IS NOT NULL
 BEGIN
  SELECT @strSQL = 
   'UPDATE #Minor_Universe
    SET intMinorException = 1
    FROM #Minor_Universe MU, S' + CONVERT(VARCHAR, @Study_id) + '.Big_View BV
     WHERE MU.Pop_id = BV.POPULATIONPop_id
      AND ' + @strMinorException_Where
  --PRINT @strSQL
  EXECUTE (@strSQL)
 END
 /* (a1f) From each sample set on the study, insert into #Minor_Exclude everyone 
  who's Age < 18, who has a Non-Thank You mailing item that has not been mailed, 
  and has the same Householding Fields as a minor in #Minor_Universe. */

 SELECT @strSQL = 
  'INSERT INTO #Minor_Exclude
   SELECT Y.Pop_id, ' + @strHouseholdField_Select + ', 0
   FROM #Minor_Universe X, 
    S' + CONVERT(VARCHAR, @Study_id) + '.Population Y, 
    dbo.SamplePop SP, 
    dbo.ScheduledMailing SchM, 
    dbo.MailingStep MS
   WHERE Y.Pop_id = SP.Pop_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.MailingStep_id = MS.MailingStep_id
    AND ' + @strHousehold_Join + '
    AND SchM.SentMail_id IS NULL
    AND SP.Study_id = ' + CONVERT(VARCHAR, @Study_id) + '
    AND Y.Age < 18
    AND X.intMinorException <> 1
    AND MS.bitThankYouItem = 0'
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (a1g) Mark anybody from #Minor_Exclude that meets the Minor Exception Rule. */
 IF @strMinorException_Where IS NOT NULL
 BEGIN
  SELECT @strSQL = 
   'UPDATE #Minor_Exclude
    SET intMinorException = 1
    FROM #Minor_Exclude ME, S' + CONVERT(VARCHAR, @Study_id) + '.Big_View BV
    WHERE ME.Pop_id = BV.POPULATIONPop_id
     AND ' + @strMinorException_Where
  --PRINT @strSQL
  EXECUTE (@strSQL)
 END
 /* (a1h) Update the "intRemove" field to 1 on any minor in the #Minor_Universe table 
  that has the same household fields as someone in #Minor_Exclude. */
 SELECT @strSQL = 
  'UPDATE #Minor_Universe
   SET intRemove = 1
   FROM #Minor_Universe X, #Minor_Exclude Y
   WHERE ' + @strHousehold_Join + '
    AND X.intMinorException <> 1
    AND Y.intMinorException <> 1'
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (a1j) Insert into #Max_MailingDate all Household field records and the most 
  recent mailing item date of any minor on the study who matches an 
  Household field records of a minor in #Minor_Universe. */
 SELECT @strSQL = 
  'INSERT INTO #Max_MailingDate
   SELECT ' + @strHouseholdField_Select + ', MAX(SM.datMailed)
    FROM #Minor_Universe X, 
     S' + CONVERT(VARCHAR, @Study_id) + '.Population Y, 
     dbo.SamplePop SP, 
     dbo.ScheduledMailing SchM, 
     dbo.SentMailing SM, 
     dbo.MailingStep MS
    WHERE Y. Pop_id = SP.Pop_id
     AND SP.SamplePop_id = SchM.SamplePop_id
     AND SchM.ScheduledMailing_id = SM.ScheduledMailing_id
     AND SchM.MailingStep_id = MS.MailingStep_id
     AND ' + @strHousehold_Join + '
     AND SP.Study_id = ' + CONVERT(VARCHAR, @Study_id) + '
     AND Y.Age < 18
     AND X.intMinorException <> 1
     AND X.intRemove <> 1
     AND MS.bitThankYouItem = 0 
    GROUP BY ' + @strHouseholdField_Select
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (a1k) Insert into #Minor_Exclude anybody who has the same Household fields and 
  mailing date in #Max_MailingDate and where the mailing date is less than 
  m_lngReSurveyEx_Period from today. */
 SELECT @strSQL = 
  'INSERT INTO #Minor_Exclude
   SELECT X.Pop_id, ' + @strHouseholdField_Select + ', 0
   FROM S' + CONVERT(VARCHAR, @Study_id) + '.POPULATION X, #Max_MailingDate Y, dbo.SamplePop SP, 
    dbo.ScheduledMailing SchM, dbo.SentMailing SM
   WHERE ' + @strHousehold_Join + '
    AND X.Pop_id = SP.Pop_id
    AND SP.SamplePop_id = SchM.SamplePop_id
    AND SchM.ScheduledMailing_id = SM.ScheduledMailing_id
    AND SM.datMailed = Y.datMailed
    AND DATEDIFF(day, Y.datMailed, GETDATE()) < ' + CONVERT(VARCHAR, @lngReSurveyEx_Period)
 --PRINT @strSQL
 EXECUTE (@strSQL)
 
 /* (a1m) Mark anybody from #Minor_Exclude that meets the Minor Exception Rule and is 
  not already excluded. */
 IF @strMinorException_Where IS NOT NULL
 BEGIN
  SELECT @strSQL = 
   'UPDATE #Minor_Exclude
    SET intMinorException = 1
    FROM #Minor_Exclude ME, S' + CONVERT(VARCHAR, @Study_id) + '.Big_View BV
    WHERE ME.Pop_id = BV.POPULATIONPop_id
     AND ' + @strMinorException_Where + '
     AND intMinorException <> 1'
  --PRINT @strSQL
  EXECUTE (@strSQL)
 END
 /* (a1n) Update the "intRemove" field to 1 on any minor in the #Minor_Universe that has 
  the same household fields as someone in #Minor_Exclude and is not already remed */
 SELECT @strSQL = 
  'UPDATE #Minor_Universe
   SET intRemove = 1
   FROM #Minor_Universe X, #Minor_Exclude Y
   WHERE ' + @strHousehold_Join + '
    AND X.intMinorException <> 1
    AND X.intRemove <> 1
    AND Y.intMinorException <> 1'
 --PRINT @strSQL
 EXECUTE (@strSQL)
/**************************************************************************************
 (a2) Compare Householding of Minors in the Universe among themselves 
**************************************************************************************/
 /* (a2b) Insert the Household fields (m_strHouseholdField_Select) of any duplicate 
  Household fields from #Minor_Universe  (ignoring those with "intRemove" = 1 
  and "intMinorException" = 1) into #Household_Dups. */
 SELECT @strSQL = 
  'INSERT INTO #Household_Dups
   SELECT ' + @strHouseholdField_Select + '
    FROM #Minor_Universe X
    WHERE intRemove <> 1
     AND intMinorException <> 1
    GROUP BY ' + @strHouseholdField_Select + '
    HAVING COUNT(*) > 1'
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /* (a2c) Assign a random number ("numRandom") to all people in #Minor_Universe that 
  matches the Household fields in #Household_Dups (excluding those with "intRemove" = 1 
  and "intMinorException" = 1). 
 */
 /* flagging the dupped records in #Minor_Universe in order to randomize them */
 SELECT @strSQL = 
  'UPDATE X
   SET intShouldBeRand = 1
   FROM #Minor_Universe X, #Household_Dups Y
   WHERE intRemove <> 1
    AND intMinorException <> 1
    AND ' + @strHousehold_Join
 --PRINT @strSQL
 EXECUTE (@strSQL)
 /*Assign a Random number to each duped record of the #Minor_Universe */

 INSERT INTO #Random_Pop 
 SELECT Pop_id, numrandom
 FROM #Minor_Universe dp, random_numbers rn
 WHERE intShouldBeRand = 1 and 
	((dp.id_num+@Seed)%1000000)=rn.random_id
 ORDER BY numrandom
 
 /* (a2f) Set "intRemove" = 0 on #Minor_Universe the records that match the 
  "numRandom" values in #Minor_Keep. */
 SELECT @strSQL =  
	'UPDATE #Minor_Universe
  SET intRemove = 0
  FROM #Minor_Universe MU, (
		SELECT ' + @strHouseholdField_Select + ', MIN(Y.id_num) as id_num
    	FROM #Minor_Universe X, #Random_Pop Y
    	WHERE numRandom IS NOT NULL
     		AND X.Pop_id = Y.Pop_id
    	GROUP BY ' + @strHouseholdField_Select +' ) MK, #Random_Pop RP
  WHERE MU.Pop_id = RP.Pop_id
   AND RP.id_num = MK.id_num'

 EXECUTE (@strSQL)
 /* (a2g) Update "intRemove" = 1 where "intRemove" <> 0 and "numRandom" IS NOT NULL 
  in #Minor_Universe. */
 UPDATE #Minor_Universe
  SET intRemove = 1
  WHERE intShouldBeRand IS NOT NULL
   AND intRemove <> 0
 /* (a2h) Update the "strRemove_Rule" field on #SampleUnit_Universe = "H" on anybody  in 
  #Minor_Universe with "intRemove" = 1. */
 UPDATE #SampleUnit_Universe
  SET Removed_Rule = @HHRemoveRule 
  FROM #SampleUnit_Universe U, #Minor_Universe MU
  WHERE U. Pop_id = MU.Pop_id
   AND MU.intRemove = 1
 /* drop temp tables */
 --DROP TABLE #Minor_Keep
 DROP TABLE #Random_Pop



  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


