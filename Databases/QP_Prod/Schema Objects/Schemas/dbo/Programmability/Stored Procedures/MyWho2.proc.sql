CREATE PROCEDURE dbo.MyWho2
AS 

-- IF EXISTS (SELECT * FROM TEMPDB.DBO.SYSOBJECTS WHERE NAME LIKE '#MYWHO2%')
-- TRUNCATE TABLE #mywho2
-- ELSE 
create table #mywho2 (spid int, status varchar(100), login varchar(100), hostname varchar(100), blkby varchar(100), dbname varchar(100), command varchar(100), cputime int, diskio int, lastbatch varchar(30), programname varchar(100), spid2 int)

insert into #mywho2 exec sp_who2 

select * from #mywho2 where programname <> '' 
and status = 'runnable'
order by /*programname,*/ cputime desc
	
drop table #mywho2


