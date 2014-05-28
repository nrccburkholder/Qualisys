CREATE PROCEDURE sp_qp_Create_POPQSTNS
AS
 create table #dt1 (
  study_id int, pop_id int, sampleset_id int, langid int, sampleunit_id int
 )
 
 insert into #dt1
 select distinct mw.study_id, mw.pop_id, mw.sampleset_id, mw.langid,
    ss.sampleunit_id
 from dbo.mailingwork mw, dbo.selectedsample ss
 where mw.sampleset_id = ss.sampleset_id
 and mw.study_id = ss.study_id
 and mw.pop_id = ss.pop_id
 create index idx_tmp on #dt1 (sampleunit_id, langid, study_id, pop_id, sampleset_id)
  with fillfactor = 100
 create table #dt2 (
  sampleunit_id int, language int, survey_id int, section_id int,
  selqstns_id int, scaleid int
 )
 insert into #dt2
 select distinct sus.sampleunit_id, sq.language, sq.survey_id, sq.section_id,
  sq.selqstns_id, sq.scaleid
 from dbo.sampleunitsection sus, dbo.sel_qstns sq
 where sus.selqstnssurvey_id = sq.survey_id
 and sus.selqstnssection = sq.section_id
 create index idx_tmp on #dt2 (sampleunit_id, language, survey_id, section_id,
  selqstns_id, scaleid)
  with fillfactor = 100
 INSERT INTO dbo.popqstns (
  sampleset_id, study_id, pop_id,
  sampleunit_id, survey_id, selqstns_id, langid,
  section_id, scaleid
 ) select distinct
  mw.sampleset_id, mw.study_id, mw.pop_id, 
  sus.sampleunit_id, sus.survey_id, sus.selqstns_id, mw.langid, 
  sus.section_id, sus.scaleid
 from #dt1 as mw,
  #dt2 as sus
 where mw.sampleunit_id = sus.sampleunit_id
 and sus.language = mw.langid
 UPDATE STATISTICS dbo.popqstns
 drop table #dt1
 drop table #dt2


