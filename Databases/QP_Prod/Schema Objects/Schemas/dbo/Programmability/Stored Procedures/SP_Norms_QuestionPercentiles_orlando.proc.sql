create procedure SP_Norms_QuestionPercentiles_orlando
@strTable_NM varchar(42), @NormTable varchar(42)
as
declare @strsql varchar(8000)

create table #cores (qstncore int)

set @strsql = 'create table ' + @strtable_nm + ' (rank int, Client char(40), Study char(10), Survey char(10), ' + char(10) +
	' SampleUnit char(42), Study_id int, Survey_id int, SampleUnit_id int, Qstncore int, Mean float, NSize int, Percentile float) ' + char(10) +
	' select distinct qstncore from study s, survey_def sd, sel_qstns sq where s.client_id = 503 and s.study_id = sd.study_id ' +
	' and sd.survey_id = sq.survey_id '


exec (@strsql)

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
	'   group by c.strclient_Nm, s.strstudy_nm, sd.strsurvey_nm, su.strsampleunit_nm, s.study_id, sd.survey_id, n.sampleunit_id, n.qstncore ' + char(10) +
	'   having sum(Nsize)>=30 ' + char(10) +
	'   order by sum(intresponseval*nsize)/sum(nsize+0.0) desc ' + char(10) +

	' update #rank ' + char(10) +
	' set Percentile=((select max(rank_id) from #rank)-Rank_id)/(select max(rank_id/100.0) from #rank) ' + char(10) +
	' where rank_id>0 ' + char(10) +

	' insert into ' + @strtable_nm + ' select Rank_id, Client, Study, Survey, SampleUnit, Study_id, Survey_id, SampleUnit_id, Qstncore, Mean, NSize, Percentile  ' + char(10) +
	' from #rank ' + char(10) +
	' where percentile >= 90.000  ' + char(10) +
	' order by rank_id ' + char(10) +

	' drop table #rank ' + char(10)

--print @strsql
exec (@strsql)

fetch next from question into @question
end

close question
deallocate question

drop table #cores


