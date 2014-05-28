CREATE PROCEDURE [dbo].[QP_Rep_ResponseRateRange_ByDate]
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @MinDate datetime,
 @MaxDate datetime,
 @DateType varchar(10)

AS
set transaction isolation level read uncommitted
declare @procedurebegin datetime
set @procedurebegin = getdate()

insert into dashboardlog (report, associate, client, study, survey, startdate, enddate, status, procedurebegin) 
select 'Response Rate by Date', @associate, @client, @study, @survey, @MinDate, @MaxDate, @DateType, @procedurebegin

select 1 as dummyord, 'Minimum Date: ' + convert(varchar,@MinDate,101) as [Date Range]
union 
select 2 as dummyord, 'Maximum Date: ' + convert(varchar,@MaxDate,101) as [Date Range]
order by dummyord

set transaction isolation level read committed


