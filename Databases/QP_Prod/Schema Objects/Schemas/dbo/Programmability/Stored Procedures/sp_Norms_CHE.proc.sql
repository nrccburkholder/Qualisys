create procedure sp_Norms_CHE
@NRCNormTable varchar(20),
@CHENormTable varchar(20),
@BeginDate datetime,
@EndDate datetime
as
set nocount on
declare @SQL varchar(800)
set @SQL = 'create table ' + @CHENormTable + ' (qstncore int, intresponseval int, uwnsize int) '
exec(@SQL)
create table #CHECoreNorms (qstncore int, intresponseval int, uwnsize int) 
create table #CHECores (qstncore int, client_id int) 

set @SQL = 'insert into #CHECoreNorms' + char(10)+
  'select qstncore, intresponseval, sum(NSize)' +char(10)+
  'from ' + @NRCNormTable + char(10)+
  'where datreturned between ''' + convert(varchar(10),@BeginDate,120) + ''' and ''' + convert(varchar(10),@EndDate,120) + '''' +char(10)+
  'and bitMissing = 0' + char(10)+
  'group by qstncore, intresponseval'
exec(@SQL)

set @SQL = 'insert into #CHECores' +char(10)+
  'select distinct qstncore, s.client_id' +char(10)+
  'from study s, survey_def sd, sampleplan sp, sampleunit su, ' + @NRCNormTable + ' n' +char(10)+ 
  'where datreturned between ''' + convert(varchar(10),@BeginDate,120) + ''' and ''' + convert(varchar(10),@EndDate,120) + '''' +char(10)+
  'and bitMissing = 0' +char(10)+
  'and n.sampleunit_id = su.sampleunit_id' +char(10)+
  'and su.sampleplan_id = sp.sampleplan_id' +char(10)+
  'and sp.survey_id = sd.survey_id' +char(10)+
  'and sd.study_id = s.study_id'
exec(@SQL)

delete u1 
from #CHECores u1 left outer join (select qstncore from #CHECores where client_id = 63) u2 
on u1.qstncore=u2.qstncore
where u2.qstncore is null

declare @Qstncore int
declare RCursor cursor for 
select distinct qstncore from JC_CHE_Recodes
open RCursor
fetch next from RCursor into @Qstncore
while @@fetch_status = 0
begin
if (select count(*) from #CHECores where qstncore in (select qstncore from JC_CHE_Recodes where recode_id = (select recode_id from JC_CHE_Recodes where qstncore = @qstncore)) and client_id <>63) >0
begin  
  set @SQL = 'insert into ' + @CHENormTable + ' select ' + convert(varchar(10),@qstncore)+', intresponseval, sum(uwnsize) from #CHECoreNorms where qstncore in (select qstncore from JC_CHE_Recodes where recode_id = (select recode_id from JC_CHE_Recodes where qstncore = '+convert(varchar(10),@qstncore)+')) group by intresponseval'
  exec(@SQL)
end
fetch next from RCursor into @Qstncore
end
close RCursor
deallocate RCursor

delete t1
from #CHECoreNorms t1 left outer join (select qstncore from #CHECores group by qstncore having count(*) > 1) t2
on t1.qstncore = t2.qstncore
where t2.qstncore is null

set @SQL = 'insert into ' + @CHENormTable + char(10)+
  'select * ' +char(10)+
  'from #CHECoreNorms' +char(10)+
  'where qstncore not in (select qstncore from ' + @CHENormTable + ')'
exec(@SQL)

drop table #CHECores
drop table #CHECoreNorms
set nocount off
set @SQL = 'select count(*) from '+@CHENormTable
exec(@SQL)


