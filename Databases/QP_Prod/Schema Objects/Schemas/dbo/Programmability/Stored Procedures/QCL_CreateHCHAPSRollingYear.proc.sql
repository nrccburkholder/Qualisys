/*                            
Business Purpose:                             
This procedure is used to support the Qualisys Class Library.              
It will take a date find the previous calander quarter and output the starting and ending date to create a rolling year.                        
            
logic for Finding year block for rolling HCAHPS year is used in             
HCAHPS proportional Sampling to create the proportional sample percentage            
                            
Created: 8/11/2008 by MB                        
      
      
     
--To Test this proc Test proc      
      
declare @outStart datetime, @outEnd Datetime      
exec QCL_CreateHCHAPSRollingYear '2004-8-01 1:00:00', @outStart OUTPUT, @outEnd OUTPUT      
      
print '@outStart called'      
print convert(varchar, @outStart,120)      
print '@outEnd called'      
print convert(varchar, @outEnd,120)      
                 
*/            
CREATE Proc QCL_CreateHCHAPSRollingYear(@PeriodDate datetime, @StartDateOut datetime output, @EndDateOut datetime output)            
as            
        
            
 declare @inDebug bit        
 declare @EncDateStart datetime, @EncDateEnd datetime            
 declare @Qtr int, @StartYear int, @EndYear int            
 declare @StartDate varchar(100), @EndDate varchar(100)            
            
set @inDebug = 1        
        
 if @PeriodDate is null          
 select @PeriodDate = getDate()          
          
            
 SELECT @EncDateStart = DATEADD(MONTH, DATEDIFF(MONTH, 0, @PeriodDate) - 4, 0),             
   @EncDateEnd = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, @EncDateStart) - 12, 0))            
        
if @inDebug =1        
 begin        
   print '@PeriodDate'            
   print convert(varchar, @PeriodDate,120)            
   print '@EncDateStart'            
   print convert(varchar, @EncDateStart,120)            
   print '@EncDateEnd'            
   print convert(varchar, @EncDateEnd,120)            
    end        
        
 select @Qtr = case month(@EncDateStart)             
     when 1 then 1            
     when 2 then 1            
     when 3 then 1            
     when 4 then 2            
     when 5 then 2            
     when 6 then 2            
     when 7 then 3            
     when 8 then 3            
     when 9 then 3            
     when 10 then 4            
     when 11 then 4            
     when 12 then 4            
      end             
  
  
 select @EndDate = case @Qtr            
        when 1 then '01-01 00:00:00'            
        when 2 then '04-01 00:00:00'            
        when 3 then '07-01 00:00:00'            
        when 4 then '10-01 00:00:00'            
      end            
  
  
if @inDebug =1        
 begin      
 print '@StartDate'  
 print @StartDate    
 end  
        
--        
-- select @Startyear = case              
--        when month(@EncDateStart) < 4 then year(@EncDateStart)             
--        else year(dateadd(year, -1, @EncDateStart))            
--      end            
            

  select @Startyear = year(dateadd(year, -1, @EncDateStart)) 
            
        
if @inDebug =1        
 begin          
   print '@Qtr'            
   print @Qtr            
   print '@Startyear'            
   print @Startyear            
   print '@Endyear'            
   print @Endyear            
    end        
        
        
select @StartDateOut = cast(@Startyear as varchar(100)) + '-' + cast(@EndDate as varchar(100))            
select @EndDateOut = dateAdd(day, -1, dateadd(year,1,@StartDateOut))            
            
        
if @inDebug =1        
 begin        
   print '@StartDateOut'            
   print @StartDateOut            
   print '@EndDateOut'            
   print @EndDateOut         
 end


