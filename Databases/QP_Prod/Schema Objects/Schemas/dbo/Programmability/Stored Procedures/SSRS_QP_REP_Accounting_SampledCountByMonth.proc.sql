CREATE proc SSRS_QP_REP_Accounting_SampledCountByMonth (@StartDate datetime = null, @Enddate Datetime = null)          
as          
begin          
--           
-- --Debug Code          
-- declare @StartDate datetime, @Enddate Datetime          
-- set @StartDate = '2008-01-01 00:00:00'          
-- set @Enddate = '2009-04-01 00:00:00'       
--      
if @StartDate is null          
 set @startDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, GetDate()), 0)          
          
if @EndDate is null          
 set @EndDate = dateadd(month,1, @StartDate)          
      
      
select sd.contract, ss.Sampleset_ID, ss.datDateRange_FromDate, ss.datDateRange_ToDate, count(distinct ss.Sampleset_ID) as NumberOfSamplesets, count(qf.questionForm_ID) as NumberofPeopleSampled      
from survey_Def sd, Sampleset ss, questionform qf, samplepop sp      
where ss.survey_Id = sd.survey_ID and      
  qf.survey_Id = sd.survey_ID and      
  sp.sampleset_Id = ss.sampleset_ID and      
  sp.samplepop_ID = qf.samplepop_ID and       
  DATEADD(dd, DATEDIFF(dd, 0, ss.datDateRange_FromDate), 0) between @StartDate and @Enddate      
group by  sd.contract, ss.Sampleset_ID, ss.datDateRange_FromDate, ss.datDateRange_ToDate        
      
end


