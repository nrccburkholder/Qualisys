CREATE Proc QCL_ReturnMedicareFacilities (@SampleUnit_ID varchar(2000))  
as  
begin  
   
declare @SQL varchar(8000)  
  
set @SQL = '  
 select suF.suFacility_ID  
 from sampleunit su, suFacility suF  
 where su.suFacility_ID = suF.suFacility_ID and   
   su.sampleUnit_ID in (' + @SampleUnit_ID + ')'  
  
    --print @SQL  
 exec (@SQL)    
end


