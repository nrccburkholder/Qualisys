create procedure dbo.qp_rep_ActionPlanReportLog
@Associate varchar(50)
as
select procedurebegin as RanOn,report, associate, client, StartDate as ModifiedSince 
from dashboardlog
where report like '%actionplan%'
order by procedurebegin desc


