CREATE procedure sp_phase1_background
as

declare @end binary(8), @start binary(8)

insert into dw_date (dwrundate)
select getdate()

set @end = (select max(qpc_timestamp) from dw_date)
set @start = (select max(qpc_timestamp) from dw_date where qpc_timestamp < @end)

truncate table phase1_extract_questionforms
--exec nrc14.ideas_v1.dbo.sp_phase1_truncate_tables

insert into phase1_extract_questionforms
select distinct questionform_id
from questionresult
where qpc_timestamp between @start and @end

/*
insert into nrc14.ideas_v1.dbo.client
select * from phase1_client_view

insert into nrc14.ideas_v1.dbo.clntstdy
select * from phase1_clntstdy_view

insert into nrc14.ideas_v1.dbo.clstdsrv
select * from phase1_clstdsrv_view

insert into nrc14.ideas_v1.dbo.phase1_dattypedt
select * from phase1_dattypedt_view

insert into nrc14.ideas_v1.dbo.phase1_qstns
select * from phase1_qstns_view2

insert into nrc14.ideas_v1.dbo.phase1_questionform
select * from phase1_questionform_view2

insert into nrc14.ideas_v1.dbo.phase1_questionresult
select * from phase1_questionresult_view2

insert into nrc14.ideas_v1.dbo.phase1_sampleunit
select * from phase1_sampleunit_view2

insert into nrc14.ideas_v1.dbo.phase1_scales
select * from phase1_scales_view2
*/


