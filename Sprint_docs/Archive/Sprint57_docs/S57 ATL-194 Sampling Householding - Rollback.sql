/*
       S57 ATL-194 Sampling Householding - Rollback
       
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
CREATE TABLE #HouseHold (id_num INT, HouseHold_id INT, EncDate DATETIME)    
CREATE TABLE #MostRecent (id_num INT, HouseHold_id INT, EncDate DATETIME)    
    
--Select all of the records that are part of a household    
INSERT INTO #HouseHold (id_num, HouseHold_id, EncDate)    
SELECT id_num, HouseHold_id, EncDate    
FROM #SampleUnit_Universe    
WHERE Removed_Rule = 0    
  AND HouseHold_id IS NOT NULL    
    
--Select only the most recent encounter for each household    
INSERT INTO #MostRecent (id_num, HouseHold_id, EncDate)    
SELECT hh.id_num, hh.HouseHold_id, hh.EncDate    
FROM #HouseHold hh INNER JOIN    
     (SELECT MAX(EncDate) AS EncDate, HouseHold_id     
      FROM #HouseHold     
      GROUP BY HouseHold_id    
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

