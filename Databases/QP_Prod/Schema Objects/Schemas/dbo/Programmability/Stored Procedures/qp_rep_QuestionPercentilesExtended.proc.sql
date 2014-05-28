﻿CREATE procedure qp_rep_QuestionPercentilesExtended
@QstnCore int,
@BeginDate datetime,
@EndDate datetime,
@MinimumNSize int
as
set transaction isolation level read uncommitted
create table #rank (rank_id int identity(0,1), Client char(40), Study char(10), Survey char(10),
SampleUnit char(42), Study_id int, Survey_id int, SampleUnit_id int, Qstncore int, Mean float, NSize int, Percentile float)

insert into #rank (Client) 
  select convert(varchar,@BeginDate,101)+'-'+convert(varchar,@EndDate,101)

insert into #rank (Client, Study, Survey, SampleUnit, Study_id, Survey_id, SampleUnit_id, Qstncore, Mean, NSize)
  select c.strclient_Nm, s.strstudy_nm, sd.strsurvey_nm, su.strsampleunit_nm, s.Study_id, sd.Survey_id, 
    n.SampleUnit_id, n.QstnCore, sum(intresponseval*nsize)/sum(nsize+0.0) as Mean, sum(nsize) as NSize
  from NRCNormExtended_view n, sampleunit su, sampleplan sp, survey_def sd, study s, client c
  where n.qstncore=@Qstncore
    and n.datreturned between @BeginDate and @EndDate
    and n.sampleunit_id=su.sampleunit_id
    and su.sampleplan_id=sp.sampleplan_id
    and sp.survey_id=sd.survey_id
    and sd.study_id=s.study_id
    and s.client_id=c.client_id
--  Added 6/25/01 BD
--    and n.intresponseval > -1
-- added 7/23/01 DG
    and n.bitMissing=0
  group by c.strclient_Nm, s.strstudy_nm, sd.strsurvey_nm, su.strsampleunit_nm, s.study_id, sd.survey_id, n.sampleunit_id, n.qstncore
  having sum(Nsize)>=@MinimumNSize
  order by sum(intresponseval*nsize)/sum(nsize+0.0) desc

update #rank
set Percentile=((select max(rank_id) from #rank)-Rank_id)/(select max(rank_id/100.0) from #rank)
where rank_id>0

select Rank_id as Rank, Client, Study, Survey, SampleUnit, Study_id, Survey_id, SampleUnit_id, Qstncore, Mean, NSize, Percentile 
from #rank
order by rank_id

set transaction isolation level read committed


