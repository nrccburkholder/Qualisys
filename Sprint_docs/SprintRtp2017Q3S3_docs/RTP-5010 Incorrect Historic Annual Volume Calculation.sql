/*
	RTP-5010 Incorrect Historic Annual Volume Calculation.sql
	Jing Fu, 10/5/2017

	Modified Stored Procedure:
		- Modify QCL_PropSamp_GetHistoricalAnnualVolume

*/
USE [QP_Prod]
GO

PRINT 'Begin stored procedure changes'
GO

/*                  
Business Purpose:                   
This procedure is used to support the Qualisys Class Library.    
It will take a medicare number and calculate the annual HCAHPS volume   
using the period dates (rolling 1 year from last complete quarter)               
  
logic for Finding Historic annual HCAHPS volume is used in   
HCAHPS proportional Sampling to create the proportional sample percentage  
                  
Created: 8/11/2008 by MB              
			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table 
			2/02/2017 TSB: S68 ATL-1402 HCAHPS Calculate Proportion & Outgo Using Distinct Pops   
             
*/  
ALTER PROCEDURE [dbo].[QCL_PropSamp_GetHistoricalAnnualVolume]
	@MedicareNumber		VARCHAR(20), 
	@PeriodDate					DATETIME, 
	@SurveyType_id			INT
AS  
BEGIN
	DECLARE @EncDateStart DATETIME, @EncDateEnd DATETIME  
	EXEC QCL_CreateCAHPSRollingYear @PeriodDate, @SurveyType_id, @EncDateStart OUTPUT, @EncDateEnd OUTPUT  
	 
	 /*
	 HCAPS: the date range is one year, just return the total. Also different visits at different months all contribute to the volume
	 HHCAPS/OASCAHPS: the date range is 5 months, so need to return total*2. Also, differnt visits at different months are also considered one to the volume
	 */
	IF @SurveyType_id = 2 
	BEGIN
		SELECT DATEPART(MONTH, pd1.datExpectedEncStart) AS encmonth, 
			DATEPART(YEAR, pd1.datExpectedEncStart) AS encyear,
			COUNT(DISTINCT he.pop_id) AS countpops  --was count(he.enc_ID) 
		INTO #countsbymonth
		FROM dbo.medicarelookup ml 
			INNER JOIN sufacility sf ON ml.medicareNumber = sf.MedicareNumber 
			INNER JOIN sampleunit su ON sf.SUFacility_ID = su.SuFacility_ID  
			INNER JOIN EligibleEncLog he ON su.Sampleunit_ID = he.sampleunit_ID 
			INNER JOIN periodDates pd2 ON pd2.sampleset_ID = he.sampleset_ID 
			INNER JOIN periodDef pd1 ON pd1.periodDef_Id = pd2.PeriodDef_ID 
		WHERE 
			pd1.datExpectedEncStart >= @EncDateStart 
			AND pd1.datExpectedEncEnd <= @EncDateEnd 
			AND ml.medicareNumber = @MedicareNumber  
			AND he.SurveyType_id = @SurveyType_id
		GROUP BY DATEPART(MONTH, pd1.datExpectedEncStart), DATEPART(YEAR, pd1.datExpectedEncStart)

	    SELECT ISNULL(SUM(countpops),0) AS countpops FROM #countsbymonth
	
		DROP TABLE #countsbymonth
	END
	ELSE
	BEGIN
		SELECT 
			ISNULL(COUNT(DISTINCT he.pop_id),0) *2 AS countpops 
		FROM dbo.medicarelookup ml 
			INNER JOIN sufacility sf ON ml.medicareNumber = sf.MedicareNumber 
			INNER JOIN sampleunit su ON sf.SUFacility_ID = su.SuFacility_ID  
			INNER JOIN EligibleEncLog he ON su.Sampleunit_ID = he.sampleunit_ID 
		WHERE 
			he.SampleEncounterDate >= @EncDateStart 
			AND he.SampleEncounterDate <= @EncDateEnd 
			AND ml.medicareNumber = @MedicareNumber  
			AND he.SurveyType_id=@SurveyType_id
		END

END

GO

PRINT 'End stored procedure changes'
GO




