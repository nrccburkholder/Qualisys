CREATE procedure qp_rep_CommentsTransferred
@Associate varchar(50),
@StartDate datetime,
@EndDate datetime
as
set transaction isolation level read uncommitted
declare @SQL varchar(1000)

create table #results (Date_Transferred varchar(10), Date_Returned varchar(10), CmntCount int)

set @SQL = 'insert into #results' +char(10)+
'select convert(varchar(10),c.datentered,120), convert(varchar(10),qf.datreturned,120), count(*)' +char(10)+
'from comments c, questionform qf' +char(10)+
'where c.questionform_id = qf.questionform_id' +char(10)+
'and convert(varchar(10),c.datentered,120) between ''' + convert(varchar(10),@StartDate,120) + ''' and ''' + convert(varchar(10),@EndDate,120) + '''' +char(10)+
'group by convert(varchar(10),c.datentered,120), convert(varchar(10),qf.datreturned,120)' +char(10)+
'order by convert(varchar(10),c.datentered,120), convert(varchar(10),qf.datreturned,120)'
exec(@SQL)

set @SQL = 'insert into #results' +char(10)+
'select '''',''Total'', count(*)' +char(10)+
'from comments c, questionform qf' +char(10)+
'where c.questionform_id = qf.questionform_id' +char(10)+
'and convert(varchar(10),c.datentered,120) between ''' + convert(varchar(10),@StartDate,120) + ''' and ''' + convert(varchar(10),@EndDate,120) + ''''
exec(@SQL)

select * from #results
drop table #results

set transaction isolation level read committed


