-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetQualisysMetrics]
	-- Add the parameters for the stored procedure here
		@MinDate datetime,
		@MaxDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

set @MinDate = cast(convert(varchar, @MinDate, 101) as datetime)
set @MaxDate = dateadd(d, 1, cast(convert(varchar, @MaxDate, 101) as datetime))

select sam.sampleset_id, sam.sampleunit_id, 0 as study_id, 0 as survey_id, 0 as employee_id, 0 as client_id
 into #tmp
from sampleset ss inner join selectedsample sam
 on ss.sampleset_id = sam.sampleset_id
where ss.datsamplecreate_dt between @MinDate and @MaxDate
group by sam.sampleset_id, sam.sampleunit_id


update t 
set survey_id = su.survey_id
from #tmp t inner join datamart.qp_comments.dbo.sampleunit su
 on t.sampleunit_id = su.sampleunit_id

update t 
set study_id = sd.study_id
from #tmp t inner join survey_def sd
 on t.survey_id = sd.survey_id

update t 
set employee_id = s.ademployee_id,
	client_id = s.client_id
from #tmp t inner join study s
 on t.study_id = s.study_id

select distinct e.employee_id, e.stremployee_last_nm, e.stremployee_first_nm, t.client_id, 0 as num_units, 0 as num_surveys, 0 as num_samples
 into #tmp2
from employee e inner join #tmp t
 on e.employee_id = t.employee_id

select employee_id, client_id, count(*) tot into #tmp_units from (select distinct employee_id, client_id, sampleunit_id from #tmp) a group by employee_id, client_id
select employee_id, client_id, count(*) tot into #tmp_surveys from (select distinct employee_id, client_id, survey_id from #tmp) a group by employee_id, client_id
select employee_id, client_id, count(*) tot into #tmp_samples from (select distinct employee_id, client_id, sampleset_id from #tmp) a group by employee_id, client_id

update t2
set num_units = t3.tot
from #tmp2 t2 inner join #tmp_units t3
 on t2.employee_id = t3.employee_id
 and t2.client_id = t3.client_id

update t2
set num_surveys = t3.tot
from #tmp2 t2 inner join #tmp_surveys t3
 on t2.employee_id = t3.employee_id
 and t2.client_id = t3.client_id

update t2
set num_samples = t3.tot
from #tmp2 t2 inner join #tmp_samples t3
 on t2.employee_id = t3.employee_id
 and t2.client_id = t3.client_id

select t2.employee_id, t2.stremployee_last_nm, t2.stremployee_first_nm, c.strclient_nm, t2.num_units, t2.num_surveys, t2.num_samples
from #tmp2 t2 inner join client c
 on t2.client_id = c.client_id
order by t2.stremployee_first_nm

drop table #tmp
drop table #tmp2
drop table #tmp_units
drop table #tmp_surveys
drop table #tmp_samples


END


