CREATE PROCEDURE sp_dbm_CleanIndivTables AS
select * into #qi from qstns_individual where sentmail_id in (select sentmail_id from pclneeded)
select * into #si from scls_individual where questionform_id in (select questionform_id from pclneeded)
select * into #ti from textbox_individual where sentmail_id in (select sentmail_id from pclneeded)

truncate table qstns_individual
truncate table scls_individual
truncate table textbox_individual

insert into qstns_individual (SELQSTNS_ID,SURVEY_ID,QUESTIONFORM_ID,LANGUAGE,SAMPLEUNIT_ID,RICHTEXT,SCALEID,SAMPLEPOP_ID,sentmail_id)
  select SELQSTNS_ID,SURVEY_ID,QUESTIONFORM_ID,LANGUAGE,SAMPLEUNIT_ID,RICHTEXT,SCALEID,SAMPLEPOP_ID,sentmail_id from #qi
insert into scls_individual (QUESTIONFORM_ID,SURVEY_ID,QPC_ID,ITEM,LANGUAGE,RICHTEXT)
  select QUESTIONFORM_ID,SURVEY_ID,QPC_ID,ITEM,LANGUAGE,RICHTEXT from #si
insert into textbox_individual (SELTEXTBOX_ID,SURVEY_ID,LANGUAGE,SELCOVER_ID,SAMPLEPOP_ID,RICHTEXT,sentmail_id)
  select SELTEXTBOX_ID,SURVEY_ID,LANGUAGE,SELCOVER_ID,SAMPLEPOP_ID,RICHTEXT,sentmail_id from #ti

drop table #si
drop table #qi
drop table #ti


