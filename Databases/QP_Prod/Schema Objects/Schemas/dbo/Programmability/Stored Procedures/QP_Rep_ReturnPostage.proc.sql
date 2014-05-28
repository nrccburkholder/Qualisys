CREATE PROCEDURE QP_Rep_ReturnPostage       
@associate varchar(50),      
@startdate datetime,      
@enddate datetime      
AS      
  
-- =======================================================    
-- Revision    
-- MWB - 1/15/09  Added ContractNumber to report for   
-- SalesLogix integration  
--
-- MWB - 3/10/09  Added AND qf.strSTRBatchNumber 
--				  not in ('OffTR', 'NewOffTr')
-- as part of new Scanner interface logic  

-- =======================================================    
  
  
set transaction isolation level read uncommitted      
declare @procedurebegin datetime      
set @procedurebegin = getdate()      
set @enddate = @enddate + '23:59:59.997'    
    
-- Mod 6/7/07 -Steve Spicka - Added "and qf.strstrbatchnumber <> 'OffTR'" to where clause to exclude Offline Transfer records from counts.     
      
insert into dashboardlog (report, associate, startdate, enddate, procedurebegin) select 'Return Postage Counts', @associate, @startdate, @enddate, @procedurebegin      
    
--SELECT @StartDate AS BegDate, @EndDate AS EndDate    
      
SELECT isnull(sd.contract, 'Missing') as 'Contract Number', left(strsamplesurvey_nm,4) as 'Project Number', count(*) as 'Questionnaires Scanned'      
from questionform qf, samplepop sp, sampleset ss, survey_def sd      
where datreturned is not null      
and datreturned >= @startdate      
and datreturned <= @enddate      
and qf.samplepop_id = sp.samplepop_id      
and sp.sampleset_id = ss.sampleset_id      
and ss.survey_ID = sd.survey_ID   
and qf.strstrbatchnumber not in ('OffTR', 'NewOffTr')    
group by isnull(sd.contract, 'Missing'),left(strsamplesurvey_nm,4)      
order by isnull(sd.contract, 'Missing'), left(strsamplesurvey_nm,4)      
      
update dashboardlog      
set procedureend = getdate()      
where report = 'Return Postage Counts'      
and associate = @associate      
and startdate = @startdate      
and enddate = @enddate      
and procedurebegin = @procedurebegin      
and procedureend is null      
      
set transaction isolation level read committed


