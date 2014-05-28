create procedure sp_Norms_AllNorms 
@NRCNormTable varchar(20), 
@AllNormTable varchar(20)
as
declare @SQL varchar(2000)

create table #user (qstncore int, intresponseval int, UWNsize int, wNsize float)

set @SQL = 'insert into #user' +char(10)+
'select qstncore,intresponseval,sum(NSize),sum(nsize)' +char(10)+
'from ' + @NRCNormTable +char(10)+
'where bitMissing = 0' +char(10)+
'group by qstncore,intresponseval' 
exec(@SQL)
 
insert into #user
  select qstncore, response, sum(uwNSize), sum(wNSize)
  from HCMGNorm N, HCMGQuestionEquivalent QE
  where N.HCMGYear=QE.HCMGYear and N.HCMGQNmbr=QE.HCMGQNmbr 
  group by qstncore, response

select qstncore,intresponseval,sum(uwNSize) as uwNSize, sum(wNSize) as wNSize
  into #all
  from #user
  group by qstncore,intresponseval
 
set @SQL = 'create table ' + @AllNormTable + ' (qstncore int, intresponseval int, uwnsize int)'
exec(@SQL)

set @SQL = 'insert into ' + @AllNormTable + ' (qstncore, intresponseval, uwnsize)' +char(10)+
'select qstncore,intresponseval, sum(uwNSize)' +char(10)+
'from #all' +char(10)+
'where intresponseval > -8' +char(10)+
'group by qstncore, intresponseval'
exec(@SQL)

create table #unitcores (sampleunit_id int, qstncore int, client_id int)

set @SQL = 'insert into #unitcores (sampleunit_id, qstncore)' +char(10)+
'select distinct sampleunit_id, qstncore' +char(10)+
'from ' + @NRCNormTable +char(10)+
'where bitMissing = 0'
exec(@SQL)

update u
set u.client_id = s.client_id
from #unitcores u, sampleunit su, sampleplan sp, survey_def sd, study s
where u.sampleunit_id = su.sampleunit_id
and su.sampleplan_id = sp.sampleplan_id
and sp.survey_id = sd.survey_id
and sd.study_id = s.study_id

select distinct client_id, qstncore
into #clientcores
from #unitcores

set @SQL = 'delete ' + @AllNormTable +char(10)+
'where qstncore not in (' +char(10)+
'select qstncore' +char(10)+
'from #clientcores' +char(10)+
'group by qstncore' +char(10)+
'having count(*) > 1)'
exec(@SQL)

drop table #clientcores
drop table #unitcores


