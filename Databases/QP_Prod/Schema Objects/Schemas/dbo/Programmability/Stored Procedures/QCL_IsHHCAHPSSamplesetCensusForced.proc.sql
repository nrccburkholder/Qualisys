/**********************************************************************************************    
QCL_IsHHCAHPSSamplesetCensusForced  
Created by: Michael Beltz  
Date:  2/9/2010  
Purpose: Proc is used to return sampleset and Samplingmethod to be used by   
   DCL_ExportCreateFile to calculate SamplingMethod.  

10/26/2010 DRM Changed dynamic sql to insert into existing temp table rather than create a new one
			   and added select at the end so that results would be returned.
**********************************************************************************************/  
CREATE Proc QCL_IsHHCAHPSSamplesetCensusForced (@Samplesets varchar(2000), @indebug int = 0)    
as    
begin    
/*
declare @Samplesets varchar(2000), @indebug int
select @samplesets = 929
select @indebug = 0
*/
 declare @SQL varchar(8000)    
  
 Create table #Results (Sampleset_ID int, SamplingMethod_Id int)  
     
 set @SQL = 'insert into #Results  
  select pd.Sampleset_ID, isnull(p.SamplingMethod_ID,0) SamplingMethod_ID   
  from PeriodDef p, perioddates pd  
  where p.periodDef_Id = pd.periodDef_ID and  
   pd.sampleset_ID in (' + @Samplesets + ')'    
    
    if @indebug = 1 print @SQL    
 exec (@SQL)      

select * from #results
drop table #results
end


