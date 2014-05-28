CREATE procedure QP_Rep_ResponseRateRange_HealthSouth
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @FirstSampleSet varchar(50),
 @LastSampleSet varchar(50)
AS
set transaction isolation level read uncommitted
declare @procedurebegin datetime
set @procedurebegin = getdate()

-- insert into dashboardlog (report, associate, client, study, survey, firstsampleset, lastsampleset, procedurebegin) 
-- select 'Response Rate', @associate, @client, @study, @survey, @firstsampleset, @lastsampleset, @procedurebegin

select 1 as dummyord, 'First Sample: ' + @firstSampleSet as [Sample Range]
union select 2 as dummyord, 'Last Sample: ' + @lastSampleSet as [Sample Range]
order by dummyord

set transaction isolation level read committed


