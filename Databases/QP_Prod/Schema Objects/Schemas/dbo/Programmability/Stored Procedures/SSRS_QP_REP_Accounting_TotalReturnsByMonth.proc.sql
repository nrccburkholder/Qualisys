CREATE proc [dbo].[SSRS_QP_REP_Accounting_TotalReturnsByMonth] (@StartDate datetime = null, @Enddate Datetime = null)        
as        
begin        
--         
-- --Debug Code        
-- declare @StartDate datetime, @Enddate Datetime        
-- set @StartDate = '2008-01-01 00:00:00'        
-- set @Enddate = '2009-04-01 00:00:00'     
    
if @StartDate is null        
 set @startDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GetDate()), 0)        
        
if @EndDate is null        
 set @EndDate = dateadd(month,1, @StartDate)        
    
    
select sd.contract, count(qf.datreturned) as Counts    
from survey_Def sd, questionform qf    
where qf.survey_Id = sd.survey_ID and    
  DATEADD(dd, DATEDIFF(dd, 0, qf.datreturned), 0)  between @StartDate and @Enddate    
group by  sd.contract       
order by  sd.contract
    
end


