/*
       S57 ATL-194 Sampling Householding
       
       As the Data Management Supervisor, I want householding to give preference to HCAHPS-eligible 
	   encounters, so that we follow protocols requiring prioritization of HCAHPS over other samples.
       
	   ATL-786 Modify stored procedure with Acceptance Criteria specs

		QCL_SampleSetPerformHousehold

		QA Notes:
		H, HH, CG CAHPS
		Multiple sampleunits vs single sampleunit setup
		Householding is at the CCN level for HCAHPS
       
       Chris Burkholder
       9/1/2016
       
       ALTER PROCEDURE [dbo].[QCL_SampleSetPerformHousehold]    
*/

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SampleSetPerformHousehold]    Script Date: 9/1/2016 2:23:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SampleSetPerformHousehold]    
    @Survey_ID INT,     
    @SampleSet_ID INT    
AS    
    
--Setup environment    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
--Create required temporary tables    
CREATE TABLE #HouseHold (id_num INT, HouseHold_id INT, EncDate DATETIME, CAHPSType_id INT, Enc_id INT)    
CREATE TABLE #MostRecent (id_num INT, HouseHold_id INT, EncDate DATETIME)    
    
--Select all of the records that are part of a household    
INSERT INTO #HouseHold (id_num, HouseHold_id, EncDate, CAHPSType_id, Enc_id)    
SELECT suu.id_num, suu.HouseHold_id, suu.EncDate, su.CAHPSType_id, suu.Enc_id    
FROM #SampleUnit_Universe suu
inner join sampleunit su on suu.sampleunit_id = su.sampleunit_id
WHERE Removed_Rule = 0    
  AND HouseHold_id IS NOT NULL    

--9/1/2016 C.Burkholder CAHPS eligible encounters trump non-CAHPS so Max(EncDate) 
--below will choose them, having been moved forward 4 years (to account for 2/29)
UPDATE #Household set EncDate = DateAdd(Year, 4, EncDate)
where IsNull(CAHPSType_id,0) > 0 
    
--Add all Encounters on the Max Date for any Households having any CAHPS Encounter
INSERT INTO #MostRecent (id_num, HouseHold_id, EncDate)    
SELECT hh.id_num, hh.HouseHold_id, hh.EncDate    
FROM #HouseHold hh INNER JOIN    
     (SELECT MAX(EncDate) AS EncDate, HouseHold_id     
      FROM #HouseHold     
      GROUP BY HouseHold_id    
	  having max(IsNull(CAHPSType_id,0)) > 0 
     ) mr ON day(hh.EncDate) = day(mr.EncDate) AND
			month(hh.EncDate) = month(mr.EncDate) AND --need to account for adding the year above
			hh.HouseHold_id = mr.HouseHold_id    

--Remove any Encounters within those added which have no CAHPS Encounter
--These would be non-CAHPS encounters that happened on the same day as the CAHPS Encounter for that household
DELETE FROM #MostRecent where id_num in
	(Select id_num from #HouseHold where Enc_id in 
		(Select enc_id from #HouseHold 
		group by Enc_id 
		having max(IsNull(CAHPSType_id,0)) = 0 ))

--Select only the most recent encounter for each household    NON-CAHPS only
INSERT INTO #MostRecent (id_num, HouseHold_id, EncDate)    
SELECT hh.id_num, hh.HouseHold_id, hh.EncDate    
FROM #HouseHold hh INNER JOIN    
     (SELECT MAX(EncDate) AS EncDate, HouseHold_id     
      FROM #HouseHold     
      GROUP BY HouseHold_id    
	  having max(IsNull(CAHPSType_id,0)) = 0
     ) mr ON hh.EncDate = mr.EncDate AND hh.HouseHold_id = mr.HouseHold_id    
  
--Delete the most recent encounters from the #HouseHold table    
DELETE hh    
FROM #HouseHold hh INNER JOIN #MostRecent mr ON hh.id_num = mr.id_num    
    
--Mark the householded records as such    
UPDATE su    
SET Removed_Rule = 7    
FROM #SampleUnit_Universe su INNER JOIN #HouseHold hh ON su.id_num = hh.id_num    
    
--Insert the excluded records into the exclusion log    
INSERT INTO Sampling_ExclusionLog (Survey_ID, Sampleset_ID, SampleUnit_ID, Pop_ID, Enc_ID, SamplingExclusionType_ID, DQ_BusRule_ID)    
SELECT CONVERT(VARCHAR, @Survey_ID), CONVERT(VARCHAR, @SampleSet_ID), su.Sampleunit_ID, su.Pop_ID, su.Enc_ID, 7, Null    
FROM #SampleUnit_Universe su INNER JOIN #HouseHold hh ON su.id_num = hh.id_num    
    
--Cleanup temp tables    
DROP TABLE #HouseHold    
DROP TABLE #MostRecent    
    
--Reset the environment    
SET NOCOUNT OFF    
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
