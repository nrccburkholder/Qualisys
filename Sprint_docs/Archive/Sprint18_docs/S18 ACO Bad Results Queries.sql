--Dave Gilsdorf's updates for the two ACODisposition 10 cases, each of which had
--issues getting results across
use [qp_prod]
go

select * from questionform where samplepop_id=107469234
select * from survey_def where survey_id=16831

select * from questionresult where questionform_id=148507469
select * from datamart.qp_comments.s4879.Study_Results_Vertical_2014_4 where samplepop_id=107469234


select qf.samplepop_id, qf.datreturned, qr.*, srv.datreturned, srv.intResponseVal
from questionform qf
inner join questionresult qr on qf.questionform_id=qr.questionform_id
left join datamart.qp_comments.s4879.Study_Results_Vertical_2014_4 srv on qr.sampleunit_id=srv.sampleunit_id and qr.qstncore=srv.qstncore and srv.samplepop_id=qf.samplepop_id
where qr.questionform_id=148507469

select * from datamart.qp_comments.s4879.big_table_2014_4 where SamplePop_id=107469234
begin tran
update questionform set datreturned=null,datResultsImported=null where QUESTIONFORM_ID=148507469
update questionform set DATRETURNED='2014-12-29 12:37:50.897', datResultsImported='2014-12-29 16:02:40.077' where QUESTIONFORM_ID=148507469
select * from questionform_extract where QUESTIONFORM_ID=148507469
commit tran

delete from datamart.qp_comments.s4879.Study_Results_2014_4 where SamplePop_id=107469234
delete from datamart.qp_comments.s4879.Study_Results_Vertical_2014_4 where SamplePop_id=107469234

------------------------------

select * from questionform where samplepop_id=107467701
select * from survey_def where survey_id=16830 -- s4878

select *
from questionresult
where questionform_id=146809743
order by qstncore

select distinct qstncore
from datamart.qp_comments.s4878.Study_Results_Vertical_2014_4
where samplepop_id=107467701

select qstncore,max(intresponseval) as intResponseVal, 0 as QUESTIONRESULT_ID
into #qr
from questionresult
where questionform_id=146809743
group by qstncore

select * from #qr

update #qr set QUESTIONRESULT_ID=sub.QUESTIONRESULT_ID
from (select t.qstncore, min(p.QUESTIONRESULT_ID) as QUESTIONRESULT_ID
from questionresult p
inner join #qr t on p.qstncore=t.qstncore and p.intResponseVal=t.intResponseVal
where p.questionform_id=146809743
group by t.qstncore) sub
where #qr.qstncore=sub.qstncore


begin tran
insert into questionresult2 (QuestionForm_ID,SampleUnit_ID,QstnCore,intResponseVal)
select p.QuestionForm_ID,p.SampleUnit_ID,p.QstnCore,p.intResponseVal
from questionresult p
left join #qr t on p.QUESTIONRESULT_ID=t.QUESTIONRESULT_ID
where p.questionform_id=146809743
and t.qstncore is null
order by p.qstncore, 1

delete p
from questionresult p
left join #qr t on p.QUESTIONRESULT_ID=t.QUESTIONRESULT_ID
where p.questionform_id=146809743
and t.qstncore is null

update questionform set datreturned=null,datResultsImported=null where QUESTIONFORM_ID=146809743
update questionform set DATRETURNED='2014-12-29 12:37:50.897', datResultsImported='2014-12-29 16:02:40.077'
where QUESTIONFORM_ID=146809743

select *
from questionresult
where questionform_id=146809743

select * from questionform_extract where QUESTIONFORM_ID=146809743
rollback tran

commit tran

delete from datamart.qp_comments.s4878.Study_Results_2014_4 where SamplePop_id=107467701
delete from datamart.qp_comments.s4878.Study_Results_Vertical_2014_4 where SamplePop_id=107467701 
