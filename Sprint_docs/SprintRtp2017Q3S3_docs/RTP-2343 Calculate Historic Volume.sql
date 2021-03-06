/*
	RTP-2343 Calculate Historic Volume.sql

	Chris Burkholder

	ALTER PROCEDURE [dbo].[QCL_PropSamp_GetHistoricalAnnualVolume]
	ALTER Procedure [dbo].[QCL_PropSamp_CheckRollingOneYearSamples]
*/

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_PropSamp_GetHistoricalAnnualVolume]    Script Date: 8/15/2017 1:40:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	 HHCAPS/OASCAHPS: the date range is 6 months, so need to return total*2. Also, differnt visits at different months are also considered one to the volume
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


USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[QCL_PropSamp_CheckRollingOneYearSamples]    Script Date: 8/15/2017 2:31:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*                  
Business Purpose:                   
This procedure is used to support the Qualisys Class Library.    
It will take a medicare number and period Date to check if a full   
years worth of sampling exists for the given medicare number  
  
this check is used in HCAHPS proportional Sampling to create   
the proportional sample percentage  
                  
Created: 8/11/2008 by MB   
modified: 4/17/09 by MB:  Added bitHCAHPS = 1 to facility check b/c we only care about data for HCAHPS units           
			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table    
  
Test Code:  
  
--QCL_PropSamp_CheckRollingOneYearSamples 'T00001', '2008-08-11 00:00:00'   
--QCL_PropSamp_CheckRollingOneYearSamples '03002', '2008-08-11 00:00:00'            
*/  
ALTER Procedure [dbo].[QCL_PropSamp_CheckRollingOneYearSamples](@MedicareNumber varchar(20), @SurveyType_id integer, @PeriodDate datetime = null)  
as  
  
begin  
 declare @EncDateStart datetime, @EncDateEnd datetime  
 declare @Count int, @ContinueCheck tinyint  
 declare @SUFacility_ID int, @Sampleunit_ID int  
  
 declare @indebug int, @HasRollingYear int  
  
 set @indebug = 0  
  
 if @PeriodDate is null  
  begin  
  
   select @PeriodDate = max(pd1.datExpectedEncStart)  
   from medicarelookup ml, sufacility sf, sampleunit su, EligibleEncLog hE , periodDef pd1, periodDates pd2  
   where ml.medicareNumber = sf.MedicareNumber and  
     sf.SUFacility_ID = su.SuFacility_ID and  
     su.Sampleunit_ID = he.sampleunit_ID and  
        
     pd1.periodDef_Id = pd2.PeriodDef_ID and  
     pd2.sampleset_ID = he.sampleset_ID and  
     ml.medicareNumber = @MedicareNumber  
  end  
  
-- exec QCL_CreateHCHAPSRollingYear @PeriodDate, @EncDateStart OUTPUT, @EncDateEnd OUTPUT  
 exec QCL_CreateCAHPSRollingYear @PeriodDate, @SurveyType_id, @EncDateStart OUTPUT, @EncDateEnd OUTPUT  
  
 if @indebug = 1  
 begin  
  print '@EncDateStart'  
  print convert(varchar, @EncDateStart,120)  
  print '@EncDateEnd'  
  print convert(varchar, @EncDateEnd,120)  
 end  
  
 select distinct sf.SUfacility_ID, su.sampleunit_ID  
 into	#Facilities  
 from	sufacility sf, sampleunit su  
 where	sf.SUFacility_ID = su.SuFacility_ID and  
		su.CAHPSType_id = @SurveyType_id and
		medicareNumber = @MedicareNumber  
     
 if @indebug = 1  
  select '#Facilities' as [#Facilities], * from #Facilities  
  
 --default to 1 to trip loop the first time thru  
 set @ContinueCheck = 1  
  
 --set @HasRollingYear = 0 so if no facilities are found it will fail the loop and exit correctly.  
 set @HasRollingYear = 0  
  
 if @surveyType_id=2 -- HCAHPS 	-- for HCAHPS we just test to see if there is one or more eligible encounters prior to @EncStartDate, presumably under the assumption that once we start sampling for a CCN, we don't stop.
								-- also, each unit associated with the CCN must meet this test.
 BEGIN
	select top 1 @SUFacility_ID =SUfacility_ID, @Sampleunit_ID =  sampleunit_ID   
	from #Facilities  
	  
	while @@rowcount > 0 and @ContinueCheck = 1  
	  begin  
		if (  
			select top 1 he.enc_ID  
			from medicarelookup ml, sufacility sf, sampleunit su, EligibleEncLog hE , periodDef pd1, periodDates pd2  
			where ml.medicareNumber = sf.MedicareNumber and  
			sf.SUFacility_ID = su.SuFacility_ID and  
			su.Sampleunit_ID = he.sampleunit_ID and  

			pd1.periodDef_Id = pd2.PeriodDef_ID and  
			pd2.sampleset_ID = he.sampleset_ID and  
			pd1.datExpectedEncStart <= @EncDateStart and  
			ml.medicareNumber = @MedicareNumber and  
			sf.SUFacility_ID = @SUFacility_ID and   
			su.Sampleunit_ID =  @sampleunit_ID   
			) > 0  
		begin  
			--continue checking next loop  
			print 'continue check = 1'  
			set @ContinueCheck = 1  
			set @HasRollingYear = 1  
		end  

		else  
		begin  
			--set to false  this sampleunit does not have a years worth of data  
			print 'continue check = 0'      
			print '@MedicareNumber = ' + cast(@MedicareNumber as varchar(100))
			print '@SUFacility_ID = ' + cast(@SUFacility_ID as varchar(100))
			print '@sampleunit_ID = ' + cast(@sampleunit_ID as varchar(100))     
			print '@EncDateStart = ' + convert(varchar, @EncDateStart, 120)

			set @ContinueCheck = 0  
			set @HasRollingYear = 0  

		end  
  
		--delete the record we just processed    
		delete from #Facilities where @SUFacility_ID =SUfacility_ID and @Sampleunit_ID =  sampleunit_ID  

		--now see if there is another record to select  
		select top 1 @SUFacility_ID =SUfacility_ID, @Sampleunit_ID =  sampleunit_ID   
		from #Facilities  
  
	  end  
 END
 ELSE -- @surveytype_id <> 2 -- non HCAHPS -- for other CAHPS we want to make sure they have at least one eligible encounter per month for the CCN, regardless of which sampleunit the encounter is associated with
 BEGIN
	if (
		select count(distinct left(convert(varchar,pd1.datExpectedEncStart,2),5))
		from medicarelookup ml, sufacility sf, sampleunit su, EligibleEncLog hE , periodDef pd1, periodDates pd2, #Facilities f
		where ml.medicareNumber = sf.MedicareNumber and  
		sf.SUFacility_ID = su.SuFacility_ID and  
		su.Sampleunit_ID = he.sampleunit_ID and  
		pd1.periodDef_Id = pd2.PeriodDef_ID and  
		pd2.sampleset_ID = he.sampleset_ID and  
		sf.SUFacility_ID = f.SUFacility_ID and   
		su.Sampleunit_ID = f.sampleunit_ID and 
		pd1.datExpectedEncStart between @EncDateStart and @EncDateEnd and
		ml.medicareNumber = @MedicareNumber
		) = (1+datediff(month,@EncDateStart,@EncDateEnd))
	begin
		set @HasRollingYear = 1
	end

 END
	  
  
 if @HasRollingYear = 1  
  select 1  
 else  
  select 0  
end


GO

