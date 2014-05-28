CREATE proc SSRS_Accounting_GetDistinctContractNumber_ForSampled(@StartDate datetime = null, @Enddate Datetime = null)        
as        
begin        
--         
-- --Debug Code        
-- declare @StartDate datetime, @Enddate Datetime        
-- set @StartDate = '2008-01-01 00:00:00'        
-- set @Enddate = '2009-04-01 00:00:00'     
  
select distinct sd.contract  
from survey_Def sd, Sampleset ss, questionform qf, samplepop sp    
where ss.survey_Id = sd.survey_ID and    
  qf.survey_Id = sd.survey_ID and    
  sp.sampleset_Id = ss.sampleset_ID and    
  sp.samplepop_ID = qf.samplepop_ID and     
  ss.datDateRange_FromDate between @StartDate and @Enddate    
Order by contract  
  
end


