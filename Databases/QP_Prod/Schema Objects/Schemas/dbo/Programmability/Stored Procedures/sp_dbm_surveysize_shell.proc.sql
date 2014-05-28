create procedure sp_dbm_surveysize_shell
as
declare @month int, @year int

set @month = datepart(month,getdate())
set @year = datepart(year,getdate())

declare @month1 int, @year1 int

set @month1 = case when datepart(month,getdate()) = 1 then 12 
	else datepart(month, dateadd(month , -1 , getdate())) end
set @year1 = datepart(year, dateadd(month, -1, getdate()))

declare @month2 int, @year2 int

set @month2 = case when datepart(month,getdate()) = 2 then 12 
	when datepart(month,getdate()) = 1 then 11 
	else datepart(month, dateadd(month , -2 , getdate())) end
set @year2 = datepart(year, dateadd(month, -2, getdate()))

declare @month3 int, @year3 int

set @month3 = case when datepart(month,getdate()) = 1 then 10 
	when datepart(month,getdate()) = 2 then 11 
	when datepart(month,getdate()) = 3 then 12 
	else datepart(month, dateadd(month , -3 , getdate())) end
set @year3 = datepart(year, dateadd(month, -3, getdate()))

create table #s (m int, y int, d bit)

insert into #s
select @month, @year, 0
insert into #s
select @month1, @year1, 0
insert into #s
select @month2, @year2, 0
insert into #s
select @month3, @year3, 0

declare @m int, @y int
declare s cursor for
select m,y from #s 

open s

fetch next from s into @m, @y
while @@fetch_status = 0

begin

print 'Working on ' + convert(varchar,@m) + '/' + convert(varchar,@y)

exec sp_dbm_surveysize @m, @y

fetch next from s into @m, @y

end

close s
deallocate s

drop table #s


