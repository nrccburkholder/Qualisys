/*                  
Business Purpose:                   
This procedure is used to support the Qualisys Class Library.    
It will take a medicare number and period Date to check if a full   
years worth of sampling exists for the given medicare number  
  
this check is used in HCAHPS proportional Sampling to create   
the proportional sample percentage  
                  
Created: 8/11/2008 by MB   
modified: 4/17/09 by MB:  Added bitHCAHPS = 1 to facility check b/c we only care about data for HCAHPS units           
  
Test Code:  
  
--QCL_PropSamp_CheckRollingOneYearSamples 'T00001', '2008-08-11 00:00:00'   
--QCL_PropSamp_CheckRollingOneYearSamples '03002', '2008-08-11 00:00:00'            
*/  
CREATE Procedure QCL_PropSamp_CheckRollingOneYearSamples(@MedicareNumber varchar(20), @PeriodDate datetime = null)  
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
   from medicarelookup ml, sufacility sf, sampleunit su, HCAHPSEligibleEncLog hE , periodDef pd1, periodDates pd2  
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
   from medicarelookup ml, sufacility sf, sampleunit su, HCAHPSEligibleEncLog hE , periodDef pd1, periodDates pd2  
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


