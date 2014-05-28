create procedure SP_Norms_QuestionPercentilesNew
@str90thTable_NM varchar(42), @strtop10table_nm varchar(42), @NormTable varchar(42), @Percentile int
as
declare @strsql varchar(8000)

create table #cores (qstncore int)

create table #coreunit (qstncore int, sampleunit int)

set @strsql = 'create table ' + @str90thTable_NM + '2 (rank int, Client char(40), Study char(10), Survey char(10), ' + char(10) +
	' SampleUnit char(42), Study_id int, Survey_id int, SampleUnit_id int, Qstncore int, Mean float, NSize int, Percentile float) ' + char(10) +
	' insert into #coreunit select distinct qstncore, sampleunit_id from ' + @normtable + char(10) +
	' insert into #cores select distinct qstncore from #coreunit'

exec (@strsql)

create table #lessthan10units (qstncore int)

insert into #lessthan10units 
select qstncore 
from #coreunit 
group by qstncore 
having count(*) < 10 

delete c
from #cores c, #lessthan10units u 
where c.qstncore = u.qstncore 

drop table #lessthan10units 

delete c
from #cores c, sel_qstns sq
where c.qstncore = sq.qstncore
and bitmeanable = 0
and sq.subtype = 1 
and sq.language = 1

create table #clientsbyquestion (client_id int, qstncore int)

insert into #clientsbyquestion
select distinct client_id, c.qstncore
from #coreunit c, sampleunit su, clientstudysurvey_view css
where c.sampleunit = su.sampleunit_id
and su.sampleplan_id = css.sampleplan_id

delete #cores
where qstncore in (select qstncore
		from #clientsbyquestion	
		group by qstncore
		having count(*) < 2)

drop table #clientsbyquestion

declare @question int

declare question cursor for
select distinct qstncore
from #cores

open question

fetch next from question into @question
while @@fetch_status = 0

begin

set @strsql = 'create table #rank (rank_id int identity(1,1), Client char(40), Study char(10), Survey char(10), ' + char(10) +
	' SampleUnit char(42), Study_id int, Survey_id int, SampleUnit_id int, Qstncore int, Mean float, NSize int, Percentile float) ' + char(10) +

	' insert into #rank (Client, Study, Survey, SampleUnit, Study_id, Survey_id, SampleUnit_id, Qstncore, Mean, NSize) ' + char(10) +
	'   select c.strclient_Nm, s.strstudy_nm, sd.strsurvey_nm, su.strsampleunit_nm, s.Study_id, sd.Survey_id,  ' + char(10) +
	'     n.SampleUnit_id, n.QstnCore, sum(intresponseval*nsize)/sum(nsize+0.0) as Mean, sum(nsize) as NSize ' + char(10) +
	'   from ' + @normtable + ' n, sampleunit su, sampleplan sp, survey_def sd, study s, client c ' + char(10) +
	'   where qstncore = ' + convert(varchar,@question) + char(10) +
	'     and n.sampleunit_id=su.sampleunit_id ' + char(10) +
	'     and su.sampleplan_id=sp.sampleplan_id ' + char(10) +
	'     and sp.survey_id=sd.survey_id ' + char(10) +
	'     and sd.study_id=s.study_id ' + char(10) +
	'     and s.client_id=c.client_id ' + char(10) +
	'     and n.bitMissing=0 ' + char(10) +
	'   group by c.strclient_Nm, s.strstudy_nm, sd.strsurvey_nm, su.strsampleunit_nm, s.study_id, sd.survey_id, ' + char(10) +
	'     n.sampleunit_id, n.qstncore ' + char(10) +
	'   having sum(Nsize)>=30 ' + char(10) +
	'   order by sum(intresponseval*nsize)/sum(nsize+0.0) desc ' + char(10) +

	' update #rank ' + char(10) +
	' set Percentile=((select max(rank_id) from #rank)-Rank_id)/(select max(rank_id/100.0) from #rank) ' + char(10) +
	' where rank_id>0 ' + char(10) +

	' insert into ' + @str90thTable_NM + '2 select Rank_id, Client, Study, Survey, SampleUnit, Study_id, Survey_id, ' + char(10) +
	' SampleUnit_id, Qstncore, Mean, NSize, Percentile  ' + char(10) +
	' from #rank ' + char(10) +
	' where percentile >= '+convert(varchar,@Percentile)+ char(10) +
	' order by rank_id ' + char(10) +

	' drop table #rank ' + char(10)

--print @strsql
exec (@strsql)

fetch next from question into @question
end

close question
deallocate question

set @strsql = 'create table ' + @strtop10table_nm + char(10) +
	' (QstnCore int, intResponseVal int, UWNSize float) ' + char(10) +
	' insert into ' + @strtop10table_nm + char(10) +
	' select n.qstncore, intresponseval, sum(n.nsize) ' + char(10) +
	' from ' + @str90thTable_NM + '2 s, ' + @normtable + ' n' + char(10) +
	' where s.qstncore = n.qstncore ' + char(10) + 
	' and s.sampleunit_id = n.sampleunit_id ' + Char(10) +
	' and intresponseval > -1 ' + char(10) +
	' group by n.qstncore, intresponseval ' + char(10) +
	' order by n.qstncore, intresponseval ' + char(10) +
	' create table ' + @str90thTable_NM + char(10) +
	' (QstnCore int, [90thMean] float) ' + char(10) +
	' insert into ' + @str90thTable_NM + char(10) +
	' select qstncore, min(mean) ' + char(10) +
	' from ' + @str90thTable_NM + '2' + char(10) +
	' group by qstncore ' + char(10) +
	' order by qstncore '

exec (@strsql)
set @strsql = 'drop table ' + @str90thTable_NM + '2'
exec (@strsql)

drop table #cores
drop table #coreunit


