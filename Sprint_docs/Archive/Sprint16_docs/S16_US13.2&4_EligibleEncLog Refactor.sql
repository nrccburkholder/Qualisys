/*
CJB 1/14/2015

Hospice CAHPS Eligible Enc Log	

As an authorized Hospice CAHPS vendor, we need to log patients who are eligible to be sampled, so that we can report the count to CMS.	 	3	
13.1	Create new table and populate the table from existing tables
13.2	Refactor sampling code to use new table
13.3	Refactor SPW to use new table (Ted Task??)
13.4	Refactor Medusa Export Manager to use new table (Depends on #14)

In order to complete the refactor, 13 stored procedures had to be modified to use the new table, so that the old tables could be dropped.

*/

USE [QP_Prod]

GO

begin tran

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'Export_HCAHPSSampleunitAvailableCount')
	DROP PROCEDURE dbo.Export_HCAHPSSampleunitAvailableCount
GO


/****** Object:  StoredProcedure [dbo].[Export_HCAHPSSampleunitAvailableCount]    Script Date: 1/14/2015 11:07:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*    
Business Purpose:     
This procedure is used to calculate the number of eligible discharges.  It    
is used IN the header record of the CMS export    
    
Created:	06/22/2006 by DC    
    
Modified:   
			4/15/2010 MWB: changed logic to count distinct pop_ID only instead of pop_ID,enc_ID 
			(which esentially counted distinct Enc_IDs) 
			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table    
    
    
*/      
    
CREATE PROCEDURE [dbo].[Export_HCAHPSSampleunitAvailableCount]    
 @Sampleunit_id INT,     
    @startDate DATETIME,     
    @EndDate DATETIME    
AS    

SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
select count(*)    
from (select distinct pop_id  
  from EligibleEncLog    
  where sampleunit_id=@sampleunit_id    
   and SampleEncounterDate between @startDate and dateadd(s,-1,dateadd(d,1,@EndDate))) p

GO
/*    
Business Purpose:     
This procedure is used to calculate the number of eligible discharges.  It    
is used IN the header record of the CMS export    
    
Created:	06/22/2006 by DC    
     
Modified:   
			4/15/2010 MWB: changed logic to count distinct pop_ID only instead of pop_ID,enc_ID 
			(which esentially counted distinct Enc_IDs)    
			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table    
    
    
*/      

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'Export_HHCAHPSSampleunitAvailableCount')
	DROP PROCEDURE dbo.Export_HHCAHPSSampleunitAvailableCount
GO


/****** Object:  StoredProcedure [dbo].[Export_HHCAHPSSampleunitAvailableCount]    Script Date: 1/14/2015 11:07:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Export_HHCAHPSSampleunitAvailableCount]    
 @Sampleunit_id INT,     
    @startDate DATETIME,     
    @EndDate DATETIME    
AS    
    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
    
select count(*)    
from (select distinct pop_id   
  from EligibleEncLog    
  where sampleunit_id=@sampleunit_id    
   and SampleEncounterDate between @startDate and dateadd(s,-1,dateadd(d,1,@EndDate))) p

GO


IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'GetHcahpsModeExperimentData')
	DROP PROCEDURE dbo.GetHcahpsModeExperimentData
GO


/****** Object:  StoredProcedure [dbo].[GetHcahpsModeExperimentData]    Script Date: 1/14/2015 11:07:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[GetHcahpsModeExperimentData] 
	@samplesets varchar(1000)
as

declare @sql varchar(8000)
declare @study varchar(10)

select @samplesets = replace(@samplesets,' ', '')
if isnumeric(replace(@samplesets, ',', '')) = 0 
begin
	print 'Input string has non-numeric characters.  Exiting...'
	return
end


create table #samplesets (
	sampleset_id int,
	sampleunit_id int,
	study_id int,
	medicarenumber varchar(20),
	strfacility_nm varchar(100)
)

select @sql = 'insert into #Samplesets
select sst.SAMPLESET_ID, su.SAMPLEUNIT_ID, sd.STUDY_ID, suf.MedicareNumber, suf.strFacility_nm 
from SAMPLESET sst, SURVEY_DEF sd, SAMPLEPLAN spl, SAMPLEUNIT su, SUFacility suf
where sst.SURVEY_ID = sd.SURVEY_ID
and sd.SURVEY_ID = spl.SURVEY_ID
and spl.SAMPLEPLAN_ID = su.SAMPLEPLAN_ID
and su.SUFacility_id = suf.SUFacility_id
and su.bitHCAHPS = 1
and sst.SAMPLESET_ID in (' + @samplesets + ')'

exec(@sql)

if (select count(distinct study_id) from #samplesets) > 1
begin
	print 'Input string has samplesets from more than one study.  Exiting...'
	return
end

select top 1 @study = cast(study_id as varchar) from #samplesets

select heel.pop_id, heel.enc_id, heel.sampleset_id, heel.sampleunit_id
into #EligibleEncs 
from #Samplesets tss
join EligibleEncLog heel
on tss.sampleset_id = heel.sampleset_id
and tss.sampleunit_id = heel.sampleunit_id
left outer join SAMPLEPOP sp
on sp.SAMPLESET_ID = tss.sampleset_id
and sp.SAMPLESET_ID = heel.sampleset_id
and sp.POP_ID = heel.pop_id
where sp.SAMPLEPOP_ID is null


select @sql = 
'select	
	left(isnull(MedicareNumber,'''')+space(6),6) +
	left(isnull(tss.strfacility_nm,'''')+space(100),100) +
	left(isnull(MRN,'''')+space(42),42) +
	left(isnull(FName,'''')+space(42),42) +
	left(isnull(LName,'''')+space(42),42) +
	left(isnull(Addr,'''')+space(60),60) +
	left(isnull(Addr2,'''')+space(42),42) +
	left(isnull(City,'''')+space(42),42) +
	left(isnull(ST,'''')+space(2),2) +
	left(isnull(Zip5,'''')+space(5),5) +
	left(isnull(Zip4,'''')+space(4),4) +
	left(isnull(Del_Pt,'''')+space(3),3) +
	left(isnull(AreaCode,'''')+space(3),3) +
	left(isnull(Phone,'''')+space(10),10) +
	case when isdate(DOB) = 0
		then space(10)
		else left(convert(varchar, DOB, 120), 10) 
	end +
	left(isnull(cast(HAdmitAge as varchar(3)),'''')+space(3),3) +
	left(isnull(HCatAge,'''')+space(2),2) +
	left(isnull(Sex,'''')+space(1),1) +
	left(isnull(VisitNum,'''')+space(42),42) +
	case when isdate(AdmitDate) = 0
		then space(10)
		else left(convert(varchar, AdmitDate, 120), 10) 
	end +
	case when isdate(DischargeDate) = 0
		then space(10)
		else left(convert(varchar, DischargeDate, 120), 10) 
	end +
	left(isnull(cast(LOSCheck as varchar(4)),'''')+space(4),4) +
	left(isnull(HAdmissionSource,'''')+space(2),2) +
	left(isnull(HDischargeStatus,'''')+space(2),2) +
	left(isnull(HServiceType,'''')+space(1),1) +
	left(isnull(MSDRG,'''')+space(3),3) +
	left(isnull(HServiceDes,'''')+space(1),1) 
from S' + @study + '.POPULATION p, S' + @study + '.ENCOUNTER e, #EligibleEncs tee, #Samplesets tss
where p.pop_id = e.pop_id
and p.pop_id = tee.pop_id
and e.enc_id = tee.enc_id
and tss.sampleset_id = tee.sampleset_id
and tss.sampleunit_id = tee.sampleunit_id'

exec(@sql)

drop table #Samplesets
drop table #EligibleEncs

GO

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'HHCAHPS_Visit_GetEligiblePatientAdminData')
	DROP PROCEDURE dbo.HHCAHPS_Visit_GetEligiblePatientAdminData
GO



/****** Object:  StoredProcedure [dbo].[HHCAHPS_Visit_GetEligiblePatientAdminData]    Script Date: 1/14/2015 11:07:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dana Petersen
-- Create date: 04/26/2013
-- Description:	For On-Site Visit data digging.
--				Get patient data for eligible patients from study-owned tables
--			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table    
-- =============================================
CREATE PROCEDURE [dbo].[HHCAHPS_Visit_GetEligiblePatientAdminData]

@visityear int,
@CCN varchar(6),
@sampmonth int,
@indebug bit = 0 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @sql varchar(8000)

declare @study_id int, @sampleset_id int

--get the study_id and sampleset_id for the specified CCN & month
select @study_id = study_id,
@sampleset_id = sampleset_id
from temp_dmp_HH_OnSite_CCNs t, temp_dmp_HH_OnSite_Samplesets s
where t.survey_id = s.survey_id
and t.visityear = @visityear
and t.ccn = @ccn
and s.SampleMonth = @sampmonth

if @indebug = 1 print @study_id
if @indebug = 1 print @sampleset_id

set @sql = '
select p.FName, p.LName, convert(date,p.dob,101) as "DOB", e.hhEOMAge, 
e.CCN, e.HHSampleMonth, e.HHSampleYear, e.HHCatAge, p.sex, 
e.hhVisitCnt, e.HHLookbackCnt, 
e.hhadm_hosp, e.hhadm_rehab, e.hhadm_snf, e.hhadm_OthLTC, e.hhadm_OthIP, e.hhadm_Comm,
e.hhpay_Mcare, e.hhpay_mcaid, e.hhpay_ins, e.hhpay_other,
e.HHHMO, e.HHdual, 
e.ICD9, e.ICD9_2, e.ICD9_3, e.ICD9_4, e.ICD9_5, e.ICD9_6,
e.HHSurg, e.hhESRD,
e.hhadl_deficit, hhadl_dressup, hhadl_dresslow, hhadl_bath, hhadl_toilet, hhadl_transfer, p.langid 
from eligibleenclog heel, s' + ltrim(cast(@study_id as varchar)) +
'.population p, s' + ltrim(cast(@study_id as varchar)) + '.encounter e
where heel.pop_id = p.pop_id
and heel.enc_id = e.enc_id
and e.pop_id = p.pop_id
and heel.sampleset_id = ' + ltrim(cast(@sampleset_id as varchar))

if @indebug = 1 print @sql

exec (@sql)


END

GO


IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_DeleteSampleSet')
	DROP PROCEDURE dbo.QCL_DeleteSampleSet
GO



/****** Object:  StoredProcedure [dbo].[QCL_DeleteSampleSet]    Script Date: 1/14/2015 11:07:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*    
Business Purpose:     
    
This procedure is used to Remove a SampleSet.  This can only be executed IF the sample    
has not been Scheduled.    
    
Created:  1/30/2006 BY Dan Christensen    
    
Modified:    
   4/13/2010     added logic to delete from HHCAHPS_PatinFileCnt table when sampleset is deleted  
   4/15/2010     added logic to delete from HHCAHPSEligEncLog table when sampleset is deleted  
   9/27/2011 DRM added code to delete seeded mailing info
   5/14/2013 DRM added check for existence of encounter table before deleting from it
*/       
CREATE PROCEDURE [dbo].[QCL_DeleteSampleSet]    
 @intSampleSet_id INT    
AS    
DECLARE @intStudy_id INT    
DECLARE @vcSQL VARCHAR(8000)    
DECLARE @intSurvey_ID INT    
DECLARE @intNotRollbackSampleSet_id INT    
    
SELECT @intStudy_id=SD.Study_id    
FROM dbo.Survey_def SD, dbo.SampleSet SS    
WHERE SD.Survey_id=SS.Survey_id    
AND SS.SampleSet_id=@intSampleSet_id    
    
IF EXISTS (SELECT schm.*    
FROM SamplePop sp, ScheduledMailing schm    
WHERE sp.SamplePop_id=schm.SamplePop_id    
AND Study_id=@intStudy_id    
AND SampleSet_id=@intSampleSet_id)    
    
BEGIN     
 RAISERROR ('This sample set is scheduled and cannot be deleted.', 16, 1)    
 RETURN    
END    
    
-- SET @vcSQL='DELETE    
-- FROM S' + CONVERT(varchar, @intStudy_id) + '.Unikeys    
-- WHERE SampleSet_id=' + CONVERT(varchar, @intSampleSet_id)    
-- EXECUTE (@vcSQL)    
    
INSERT INTO Rollbacks (Survey_id, Study_id, datRollback_dt, Rollbacktype, cnt, datSampleCreate_dt)    
SELECT ss.Survey_id, sp.Study_id, GETDATE(), 'Sampling' , COUNT(*), datSampleCreate_dt    
FROM SampleSet ss, SamplePop sp    
WHERE ss.SampleSet_id=@intSampleSet_id    
AND ss.SampleSet_id=sp.SampleSet_id    
GROUP BY ss.Survey_id, sp.Study_id, ss.datSampleCreate_dt    
    
IF @@ROWCOUNT=0 -- Implies there was nobody sampled    
    
INSERT INTO Rollbacks (Survey_id, Study_id, datRollback_dt, Rollbacktype, cnt, datSampleCreate_dt)    
SELECT ss.Survey_id, sd.Study_id, GETDATE(), 'Sampling' , 0, datSampleCreate_dt    
FROM SampleSet ss, Survey_def sd    
WHERE ss.SampleSet_id=@intSampleSet_id    
AND ss.Survey_id=sd.Survey_id    
    
/*     
* Update TeamStatus_SampleInfo    
*/    
SELECT @intSurvey_ID=Survey_id    
FROM dbo.SampleSet    
WHERE SampleSet_id=@intSampleSet_id    
           
UPDATE dbo.TeamStatus_SampleInfo    
SET Rolledback=1    
WHERE SampleSet_id=@intSampleSet_id    
    
UPDATE dbo.TeamStatus_SampleInfo    
SET SamplesPulled=SamplesPulled - 1    
WHERE Survey_id=@intSurvey_ID    
AND SampleSet_id>@intSampleSet_id    
    
SELECT @intNotRollbackSampleSet_id=MIN(SampleSet_id)    
FROM dbo.TeamStatus_SampleInfo    
WHERE Survey_id=@intSurvey_ID    
AND SampleSet_id>@intSampleSet_id    
AND RolledBack=0    
    
IF (@intNotRollbackSampleSet_id IS NULL)    
 UPDATE dbo.TeamStatus_SampleInfo    
    SET TotalRolledBack=TotalRolledBack+1    
  WHERE Survey_id=@intSurvey_ID    
    AND SampleSet_id>@intSampleSet_id    
ELSE    
 UPDATE dbo.TeamStatus_SampleInfo    
    SET TotalRolledBack=TotalRolledBack+1    
  WHERE Survey_id=@intSurvey_ID    
    AND SampleSet_id>@intSampleSet_id    
    AND SampleSet_id<=@intNotRollbackSampleSet_id    
    
--DRM 09/23/2011  Remove seeded mailing data if sampleset is rolled back.

--print 'sampleset_id = ' + cast(@intsampleset_id as varchar)
--print 'survey_id = ' + cast(@intsurvey_id as varchar)


select @vcSQL = 'delete s' + cast(@intStudy_id as varchar) + '.population
where pop_id in 
(select pop_id from samplepop 
where pop_id < 0 and sampleset_id = ' + cast(@intSampleSet_id as varchar) + ')'
--print @vcSQL
exec (@vcSQL)

--DRM 5/14/2013 Add check for existence of encounter table before deleting from it.
if exists (select 1 from sys.tables t inner join sys.schemas s on t.schema_id = s.schema_id where s.name = 's' + cast(@intStudy_id as varchar) and t.name = 'encounter')
begin
	select @vcSQL = 'delete s' + cast(@intStudy_id as varchar) + '.encounter
	where pop_id in 
	(select pop_id from samplepop 
	where pop_id < 0 and sampleset_id = ' + cast(@intSampleSet_id as varchar) + ')'
	--print @vcSQL
	exec (@vcSQL)
end

delete seedmailingsamplepop
where samplepop_id in 
(select samplepop_id from samplepop 
 where sampleset_id = @intSampleSet_id)


update tobeseeded set 
	isseeded = 0, 
	datseeded = null
where survey_id = @intSurvey_ID
and yearqtr = (select replace(dbo.yearqtr(isnull(datdaterange_fromdate,getdate())),'_','Q') from sampleset where sampleset_id = @intSampleSet_id)
and isseeded = 1

--End of add DRM


DELETE FROM dbo.SampleDataSet    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.SELECTedSample    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.SamplePop    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.SampleSet    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.SamplePlanWorkSheet    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.SPWDQCounts    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.EligibleEncLog    
WHERE SampleSet_id=@intSampleSet_id    
DELETE FROM dbo.HHCAHPS_PatInfileCount  
WHERE SampleSet_id = @intSampleSet_id     
    
    
--update the info in PeriodDates IF it's not an oversample    
--IF this is an oversample, we want to delete the whole record    
IF EXISTS (SELECT SampleNumber    
   FROM PeriodDates pds, PeriodDef pd    
   WHERE pds.SampleSet_id=@intSampleSet_id AND    
   pds.PeriodDef_id=pd.PeriodDef_id AND    
   pd.intExpectedSamples<SampleNumber)    
BEGIN    
DELETE    
FROM PeriodDates    
WHERE SampleSet_id=@intSampleSet_id    
END    
ELSE     
BEGIN    
UPDATE dbo.PeriodDates    
SET SampleSet_id=NULL,    
 datSampleCreate_dt=NULL    
WHERE SampleSet_id=@intSampleSet_id     
END

GO


IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_GetHCAHPSEligibleCount')
	DROP PROCEDURE dbo.QCL_GetHCAHPSEligibleCount
GO



/****** Object:  StoredProcedure [dbo].[QCL_GetHCAHPSEligibleCount]    Script Date: 1/14/2015 11:07:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
Created 8/29/08 MWB
Purpose:  This proc returns a count of the eligible HCAHPS encounters and is used for the Proportional Sampling 
		  calculation to update the HCAHPS unit target
			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table    
*/
CREATE proc [dbo].[QCL_GetHCAHPSEligibleCount] (@Sampleset_ID int, @SampleUnit_ID int)
as

begin

	Select count(enc_ID) from EligibleEncLog
	where Sampleset_ID = @Sampleset_ID and SampleUnit_ID = @SampleUnit_ID

end

GO


IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_PropSamp_CheckRollingOneYearSamples')
	DROP PROCEDURE dbo.QCL_PropSamp_CheckRollingOneYearSamples

GO

/****** Object:  StoredProcedure [dbo].[QCL_PropSamp_CheckRollingOneYearSamples]    Script Date: 1/14/2015 11:07:29 AM ******/
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
CREATE Procedure [dbo].[QCL_PropSamp_CheckRollingOneYearSamples](@MedicareNumber varchar(20), @PeriodDate datetime = null)  
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
  
 exec QCL_CreateHCHAPSRollingYear @PeriodDate, @EncDateStart OUTPUT, @EncDateEnd OUTPUT  
  
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
		su.bithCAHPS = 1 and
		medicareNumber = @MedicareNumber  
     
 if @indebug = 1  
  select '#Facilities' as [#Facilities], * from #Facilities  
  
 --default to 1 to trip loop the first time thru  
 set @ContinueCheck = 1  
  
 --set @HasRollingYear = 0 so if no facilities are found it will fail the loop and exit correctly.  
 set @HasRollingYear = 0  
  
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
  
  
 if @HasRollingYear = 1  
  select 1  
 else  
  select 0  
end

GO


IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_PropSamp_GetHistoricalAnnualVolume')
	DROP PROCEDURE dbo.QCL_PropSamp_GetHistoricalAnnualVolume

GO

/****** Object:  StoredProcedure [dbo].[QCL_PropSamp_GetHistoricalAnnualVolume]    Script Date: 1/14/2015 11:07:29 AM ******/
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
             
*/  
CREATE Procedure [dbo].[QCL_PropSamp_GetHistoricalAnnualVolume](@MedicareNumber varchar(20), @PeriodDate datetime)  
as  
  
begin
	declare @EncDateStart datetime, @EncDateEnd datetime  
	exec QCL_CreateHCHAPSRollingYear @PeriodDate, @EncDateStart OUTPUT, @EncDateEnd OUTPUT  
	  
	select count(he.enc_ID)  
	from medicarelookup ml, sufacility sf, sampleunit su, EligibleEncLog hE , periodDef pd1, periodDates pd2  
	where ml.medicareNumber = sf.MedicareNumber and  
	  sf.SUFacility_ID = su.SuFacility_ID and  
	  su.Sampleunit_ID = he.sampleunit_ID and  
	  pd1.periodDef_Id = pd2.PeriodDef_ID and  
	  pd2.sampleset_ID = he.sampleset_ID and  
	  pd1.datExpectedEncStart >= @EncDateStart and pd1.datExpectedEncEnd <= @EncDateEnd and   
	  ml.medicareNumber = @MedicareNumber  
end

GO



IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QCL_SampleSetHouseholdingExclusion')
	DROP PROCEDURE dbo.QCL_SampleSetHouseholdingExclusion

GO

/****** Object:  StoredProcedure [dbo].[QCL_SampleSetHouseholdingExclusion]    Script Date: 1/14/2015 11:07:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*                      
Created:  04/13/2012 Don Mayhew    

08/30/2013 Lee Kohrs
  Removed the following snippet to improve performance
  -- and not exists ( select ''x'' from dbo.vw_Billians_NursingHomeAssistedLiving v           
  --   where isnull(v.Street_Address, '''') = isnull(p.addr, '''') and          
  --     isnull(v.mail_Address, '''') = isnull(p.addr2, '''') and           
  --     isnull(v.city, '''') = isnull(p.city, '''') and          
  --     isnull(v.state, '''') = isnull(p.st, '''') and          
  --     isnull(substring(v.street_zip,1,5), '''') = isnull(p.zip5, '''') 
  Added the following to delete records matching the vw_Billians_NursingHomeAssistedLiving view
    DELETE #Distinct
    FROM   #Distinct d
       INNER JOIN vw_Billians_NursingHomeAssistedLiving v
               ON d.POPULATIONAddr = v.Street_Address
                  AND d.POPULATIONaddr2 = v.mail_Address
                  AND d.POPULATIONcity = v.city
                  AND d.POPULATIONst = v.state
                  AND d.POPULATIONzip5 = LEFT(v.street_zip, 5)                 

11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using 
													vw_Billians_NursingHomeAssistedLiving to be run in country=US only              
			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table    
*/
CREATE PROCEDURE [dbo].[QCL_SampleSetHouseholdingExclusion]
  @Study_id                      INT,
  @Survey_ID                     INT,
  @startDate                     DATETIME,
  @EndDate                       DATETIME,
  @strHouseholdField_CreateTable VARCHAR(8000),/* List of fields and type that are used for HouseHolding criteria */
  @strHouseholdField_Select      VARCHAR(8000),/* List of fields that are used for HouseHolding criteria */
  @strHousehold_Join             VARCHAR(8000),
  @HouseHoldingType              CHAR(1),
  @Sampleset_ID                  INT = 0,
  @indebug                       INT = 0
AS
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET NOCOUNT ON

  DECLARE @sql VARCHAR(8000)
  DECLARE @BOM DATETIME,
          @EOM DATETIME

  SET @BOM = dateadd(dd, -day(@startDate) + 1, @startDate)
  SET @EOM = dateadd(dd, -1, dateadd(mm, 1, @BOM))

  IF @HouseHoldingType = 'A'
    BEGIN
      SELECT @sql = 'CREATE TABLE #Distinct (a INT IDENTITY(-1,-1), '
                    + @strHouseHoldField_CreateTable
                    + ', pop_id int)                          
  INSERT INTO #Distinct ('
                    + @strHouseHoldField_Select
                    + ', pop_id)                          
  SELECT DISTINCT '
                    + SUBSTRING(REPLACE(REPLACE(REPLACE(@strHouseHoldField_Select, 'POPULATION', ''), 'x.', ',9999999),ISNULL('),
                    ', ,',
                    ','),
                           12, 2000)
                    + ',9999999), p.pop_id'
                    + '                          
  FROM sampleset ss, SampleUnit su, eligibleenclog h, survey_def sd, S'
                    + LTRIM(STR(@Study_id))
                    + '.Population p                      
  WHERE sd.Study_id='
                    + LTRIM(STR(@Study_id))
                    + '                      
  AND sampleEncounterDate BETWEEN '''
                    + CONVERT(VARCHAR, @BOM)
                    + ''' AND  '''
                    + CONVERT(VARCHAR, @EOM)
                    + '''                       
  AND h.Pop_id=p.Pop_id AND  h.sampleunit_id= su.sampleunit_Id and  su.bitHCAHPS = 1           
  and su.dontsampleunit = 0 and ss.sampleset_id = h.sampleset_id and sd.survey_id = ss.survey_id    

--11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using 
--													vw_Billians_NursingHomeAssistedLiving to be run in country=US only              
declare @country nvarchar(255)
declare @environment nvarchar(255)
exec dbo.sp_getcountryenvironment @ocountry=@country output, @oenvironment=@environment output
IF @country=''US''
    DELETE #Distinct
    FROM   #Distinct d
       INNER JOIN vw_Billians_NursingHomeAssistedLiving v
               ON d.POPULATIONAddr = v.Street_Address
                  AND d.POPULATIONaddr2 = v.mail_Address
                  AND d.POPULATIONcity = v.city
                  AND d.POPULATIONst = v.state
                  AND d.POPULATIONzip5 = LEFT(v.street_zip, 5)               
            
                              
  UPDATE x                          
  SET x.Removed_Rule=10  
  FROM #SampleUnit_Universe x, #Distinct y                   
  WHERE '
                    + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=')
                    + ' and isnull(x.removed_rule, 0) = 0  and x.pop_id = y.pop_id                        
            
  insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)            
  Select distinct '
                    + cast(@survey_ID AS VARCHAR(10))
                    + ' as Survey_ID, '
                    + cast(@Sampleset_ID AS VARCHAR(10))
                    + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, x.Enc_ID, 10 as SamplingExclusionType_ID, Null as DQ_BusRule_ID            
  FROM #SampleUnit_Universe x, #Distinct y                          
  WHERE '
                    + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=')
                    + ' and x.pop_id = y.pop_id and x.removed_rule = 10                    
  
  
  
  
  UPDATE x                          
  SET x.Removed_Rule=7                          
  FROM #SampleUnit_Universe x, #Distinct y                          
  WHERE '
                    + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=')
                    + ' and isnull(x.removed_rule, 0) = 0 and x.pop_id <> y.pop_id  
            
  insert into Sampling_ExclusionLog (Survey_ID,Sampleset_ID,Sampleunit_ID,Pop_ID,Enc_ID,SamplingExclusionType_ID,DQ_BusRule_ID)            
  Select distinct '
                    + cast(@survey_ID AS VARCHAR(10))
                    + ' as Survey_ID, '
                    + cast(@Sampleset_ID AS VARCHAR(10))
                    + ' as Sampleset_ID, x.Sampleunit_ID, x.Pop_ID, x.Enc_ID, 7 as SamplingExclusionType_ID, Null as DQ_BusRule_ID            
  FROM #SampleUnit_Universe x, #Distinct y                          
  WHERE '
                    + REPLACE(REPLACE(@strHouseHold_Join, 'x.', 'ISNULL(X.'), '=', ',9999999)=')
                    + ' and x.removed_rule = 7                     
            
--11/25/2013 Dave Hansen - CanadaQualisysUpgrade - DFCT0010966 - conditioned delete/update statements using 
--													vw_Billians_NursingHomeAssistedLiving to be run in country=US only              
IF @country=''US''
  UPDATE x                          
  SET x.Removed_Rule= -7                          
  FROM #SampleUnit_Universe x, S'
                    + LTRIM(STR(@Study_id))
                    + '.Population p             
  WHERE x.pop_ID = p.pop_ID and x.removed_rule = 0             
  and exists     ( select ''x''             
     from vw_Billians_NursingHomeAssistedLiving v             
     WHERE  isnull(p.addr, '''') = v.Street_Address
       AND isnull(p.addr2, '''') = v.mail_Address
       AND isnull(p.city, '''') = v.city
       AND isnull(p.st, '''') = v.state
       AND isnull(p.zip5, '''') = LEFT(v.street_zip, 5)           
     )            
                 
  DROP TABLE #Distinct'

      SELECT @sql = replace(@sql, 'DOB,9999999', 'DOB,''12/31/4000''')

      SELECT @sql = replace(@sql, 'Date,9999999', 'Date,''12/31/4000''')

      IF @indebug = 1
        PRINT @sql

      EXEC (@sql)
    END

GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectEncounterUnitEligibility_dmp_hheel_debug]    Script Date: 1/14/2015 11:07:29 AM ******/
IF object_id('QCL_SelectEncounterUnitEligibility_dmp_hheel_debug') IS NOT NULL
	Drop PROCEDURE [dbo].[QCL_SelectEncounterUnitEligibility_dmp_hheel_debug]

GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectEncounterUnitEligibility_hheel_debug]    Script Date: 1/14/2015 11:07:29 AM ******/
IF object_id('QCL_SelectEncounterUnitEligibility_hheel_debug') IS NOT NULL
DROP PROCEDURE [dbo].[QCL_SelectEncounterUnitEligibility_hheel_debug]

GO

IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'QP_REP_People_Sampled_HCAHPS')
	DROP PROCEDURE dbo.QP_REP_People_Sampled_HCAHPS

GO

/****** Object:  StoredProcedure [dbo].[QP_REP_People_Sampled_HCAHPS]    Script Date: 1/14/2015 11:07:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QP_REP_People_Sampled_HCAHPS]  
 @Associate VARCHAR(50),  
 @Client VARCHAR(50),  
 @Study VARCHAR(50),  
 @Survey VARCHAR(50),  
 @FirstSampleSet DATETIME,  
 @LastSampleSet DATETIME  

AS  

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @Study_id INT, @Survey_id INT, @sql VARCHAR(1000), @ordername VARCHAR(30)

SELECT TOP 1 @Survey_id=Survey_id, @Study_id=st.Study_id, @Ordername = '' 
FROM client c, study st, survey_def sd 
WHERE strClient_nm=@Client 
	AND strStudy_nm=@Study 
	AND strSurvey_nm=@Survey
	AND c.client_id=st.client_id
	AND st.study_id=sd.study_id

SELECT SampleSet_id, CONVERT(VARCHAR(19),datSampleCreate_dt,120) AS 'Date Sampled'
INTO #Sampleset
FROM SampleSet
WHERE Survey_id=@Survey_id
AND CONVERT(VARCHAR,datSampleCreate_dt,120) BETWEEN CONVERT(VARCHAR,@FirstSampleSet,120) AND CONVERT(VARCHAR,@LastSampleSet,120)

SELECT sp.SamplePop_id, ISNULL(MIN(strLithoCode),'NotPrinted') Litho, [Date Sampled]
INTO #SamplePop 
FROM #SampleSet ss, SamplePop sp LEFT OUTER JOIN ScheduledMailing schm ON sp.SamplePop_id=schm.SamplePop_id
	LEFT OUTER JOIN SentMailing sm ON schm.SentMail_id=sm.SentMail_id
WHERE ss.SampleSet_id=sp.SampleSet_id
GROUP BY sp.SamplePop_id, [Date Sampled]

IF EXISTS (SELECT * FROM METADATA_VIEW WHERE STUDY_iD = @study_id AND strField_Nm IN ('FName','LName'))
	SET @ordername = ' , FName, LName'

IF EXISTS(SELECT strTable_nm FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')
SET @SQL='SELECT DISTINCT ''THIS IS A TEST REPORT'' [THIS IS A TEST REPORT],'+char(10)+
'sp.SampleSet_id AS ''Sample Set'', Litho, CASE WHEN ISNUMERIC(Litho)=1 THEN DBO.LITHOTOWAC (Litho) ELSE Litho END WAC, CASE WHEN ISNUMERIC(Litho)=1 THEN dbo.LithoToBarCode(Litho,1) ELSE Litho END BarCode,'+CHAR(10)+
'[Date Sampled], p.*, e.*'+CHAR(10)+
'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p'+char(10)+
'inner join samplepop sp on (sp.pop_id=p.pop_id)'+char(10)+
'inner join #samplepop t on (t.samplepop_id=sp.samplepop_id)'+char(10)+
'inner join selectedsample sel on (sel.sampleset_id=sp.sampleset_id and sel.pop_id=sp.pop_id)'+char(10)+
'inner join s'+CONVERT(VARCHAR,@Study_id)+'.Encounter e on (e.enc_id=sel.enc_id)'+CHAR(10)+
'inner join sampleunit su on (sel.sampleunit_id=su.sampleunit_id)'+char(10)+
'left outer join EligibleEncLog he (nolock)'+CHAR(10)+
	'on ((he.sampleset_id=sp.sampleset_id) and (he.pop_id=p.pop_id) and (he.enc_id=e.enc_id))'+char(10)+
'where su.bithcahps=1'+char(10)+
'and (he.enc_id+he.pop_id is not null)'+char(10)+
'ORDER BY sp.SampleSet_id, [Date Sampled]' + @Ordername
ELSE
SET @sql='SELECT DISTINCT sp.SampleSet_id AS ''Sample Set'', Litho, CASE WHEN ISNUMERIC(Litho)=1 THEN DBO.LITHOTOWAC (Litho) ELSE Litho END WAC, CASE WHEN ISNUMERIC(Litho)=1 THEN dbo.LithoToBarCode(Litho,1) ELSE Litho END BarCode,'+CHAR(10)+
'[Date Sampled], p.*'+CHAR(10)+
'FROM S'+CONVERT(VARCHAR,@Study_id)+'.Population p, SamplePop sp, #SamplePop t'+CHAR(10)+
'WHERE t.SamplePop_id=sp.SamplePop_id'+CHAR(10)+
'AND sp.Pop_id=p.Pop_id'+CHAR(10)+
'ORDER BY sp.SampleSet_id, [Date Sampled]' + @Ordername

EXEC (@sql)

DROP TABLE #SAMPLESET
DROP TABLE #SAMPLEPOP

GO



IF EXISTS (SELECT * FROM sys.procedures where schema_id=1 and name = 'sp_Samp_RollbackSample')
	DROP PROCEDURE dbo.sp_Samp_RollbackSample
GO

/****** Object:  StoredProcedure [dbo].[sp_Samp_RollbackSample]    Script Date: 1/14/2015 11:07:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Samp_RollbackSample]    
 @intSampleSet_id int    
AS    
 DECLARE @intStudy_id int    
 DECLARE @vcSQL varchar(8000)    
 DECLARE @intSurvey_ID int    
 DECLARE @intNotRollbackSampleSet_id int    
     
 SELECT @intStudy_id = SD.Study_id    
  FROM dbo.Survey_def SD, dbo.SampleSet SS    
  WHERE SD.Survey_id = SS.Survey_id    
   AND SS.SampleSet_id = @intSampleSet_id    
    
if exists (select schm.*    
from samplepop sp, scheduledmailing schm    
where sp.samplepop_id = schm.samplepop_id    
and study_id = @intstudy_id    
and sampleset_id = @intsampleset_id)    
    
   begin     
 print 'This is still scheduled you big dummy.'    
 return    
   end    
    
--  SET @vcSQL = 'DELETE    
--     FROM S' + CONVERT(varchar, @intStudy_id) + '.Unikeys    
--     WHERE SampleSet_id = ' + CONVERT(varchar, @intSampleSet_id)    
--  EXECUTE (@vcSQL)    
    
insert into rollbacks (survey_id, study_id, datrollback_dt, rollbacktype, cnt, datSampleCreate_dt)    
select ss.survey_id, sp.study_id, getdate(), 'Sampling' , count(*), datSampleCreate_dt    
from sampleset ss, samplepop sp    
where ss.sampleset_id = @intsampleset_id    
and ss.sampleset_id = sp.sampleset_id    
group by ss.survey_id, sp.study_id, ss.datSampleCreate_dt    
    
 /*     
  * Add by BMao, 1/8/03    
  * Update TeamStatus_SampleInfo    
  */    
 SELECT @intSurvey_ID = Survey_id    
   FROM dbo.SampleSet    
  WHERE SampleSet_id = @intSampleSet_id    
               
 UPDATE dbo.TeamStatus_SampleInfo    
    SET Rolledback = 1    
  WHERE SampleSet_id = @intSampleSet_id    
      
 UPDATE dbo.TeamStatus_SampleInfo    
    SET SamplesPulled = SamplesPulled - 1    
  WHERE Survey_id = @intSurvey_ID    
    AND SampleSet_id > @intSampleSet_id    
    
 SELECT @intNotRollbackSampleSet_id = MIN(SampleSet_id)    
   FROM dbo.TeamStatus_SampleInfo    
  WHERE Survey_id = @intSurvey_ID    
    AND SampleSet_id > @intSampleSet_id    
    AND RolledBack = 0    
     
 IF (@intNotRollbackSampleSet_id IS NULL)    
     UPDATE dbo.TeamStatus_SampleInfo    
        SET TotalRolledBack = TotalRolledBack + 1    
      WHERE Survey_id = @intSurvey_ID    
        AND SampleSet_id > @intSampleSet_id    
 ELSE    
     UPDATE dbo.TeamStatus_SampleInfo    
        SET TotalRolledBack = TotalRolledBack + 1    
      WHERE Survey_id = @intSurvey_ID    
        AND SampleSet_id > @intSampleSet_id    
        AND SampleSet_id <= @intNotRollbackSampleSet_id    
     
 /* End of add by BMao */    
                
 DELETE FROM dbo.SampleDataSet    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.SelectedSample    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.SamplePop    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.SampleSet    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.SamplePlanWorkSheet    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.SPWDQCounts    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.Sampling_ExclusionLog    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.EligibleEncLog    
  WHERE SampleSet_id = @intSampleSet_id    
 DELETE FROM dbo.HHCAHPS_PatInfileCount
  WHERE SampleSet_id = @intSampleSet_id   
 
         
 --Added by DC 2-25-2004    
 --update the info in PeriodDates if it's not an oversample    
 --If this is an oversample, we want to delete the whole record    
IF EXISTS (SELECT SampleNumber    
    FROM perioddates pds, perioddef pd    
    WHERE pds.sampleset_id=@intSampleSet_id and    
    pds.perioddef_id=pd.perioddef_id and    
    pd.intexpectedsamples < sampleNumber)    
BEGIN    
 DELETE    
 FROM perioddates    
 WHERE sampleset_id=@intSampleSet_id    
END    
ELSE     
BEGIN    
  UPDATE dbo.PeriodDates    
  SET sampleset_id=null,    
  datsamplecreate_dt=null    
  WHERE SampleSet_id = @intSampleSet_id     
END    
 --End of Add DC

GO

USE [QP_Prod]
GO

/****** Object:  Table [dbo].[HCAHPSEligibleEncLog]    Script Date: 1/14/2015 11:22:21 AM ******/
IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'HCAHPSEligibleEncLog'))
DROP TABLE [dbo].[HCAHPSEligibleEncLog]
GO

USE [QP_Prod]
GO

/****** Object:  Table [dbo].[HHCAHPSEligibleEncLog]    Script Date: 1/14/2015 11:22:35 AM ******/
IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'HHCAHPSEligibleEncLog'))
DROP TABLE [dbo].[HHCAHPSEligibleEncLog]
GO


/****** Object:  Table [dbo].[HHCAHPSEligibleEncLog_bk_bf_SampSetAdjust]    Script Date: 1/14/2015 11:22:35 AM ******/
IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'HHCAHPSEligibleEncLog_bk_bf_SampSetAdjust'))
DROP TABLE [dbo].[HHCAHPSEligibleEncLog_bk_bf_SampSetAdjust]
GO

commit tran