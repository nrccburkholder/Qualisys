use nrc_datamart
if object_id('tempdb..#s') is not null drop table #s
if object_id('tempdb..#ACOSurveys') is not null drop table #ACOSurveys
go
select s.surveyID, s.SurveyTypeID, s.SurveyName, s.CAHPSTypeID, sd.survey_id, sd.strSurvey_nm, st.subtype_id, st.subtype_nm
into #s
from survey s
inner join etl.DataSourceKey dsk on s.surveyid=dsk.DataSourceKeyID
inner join qualisys.qp_prod.dbo.survey_def sd on dsk.DataSourceKey=sd.survey_id
left join qualisys.qp_prod.dbo.surveysubtype sst on sd.survey_id=sst.survey_id
left join qualisys.qp_prod.dbo.subtype st on sst.subtype_id=st.subtype_id
where s.CAHPSTypeID in (4,8)

select distinct s.*, ss.SampleDate
into #ACOSurveys
from NRC_Datamart.dbo.samplepopulation sp 
inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
inner join NRC_Datamart.dbo.selectedsample sel on sp.SamplePopulationID=sel.SamplePopulationID
inner join NRC_Datamart.dbo.sampleunit su on sel.sampleunitid=su.sampleunitid
left join NRC_Datamart.dbo.SampleUnitFacilityAttributes sufa on sel.sampleunitid=sufa.sampleunitid
left join NRC_Datamart.dbo.questionform qf on sp.SamplePopulationID=qf.SamplePopulationID and qf.isActive=1
inner join #s s on su.surveyid=s.surveyID
where ss.SampleDate between '2015-09-01' and '2222-12-31' 
order by 2


use nrc_datamart_extracts
declare @EQid int
insert into cem.ExportQueue (ExportTemplateName,ExportTemplateVersionMajor,ExportTemplateVersionMinor,ExportDateStart,ExportDateEnd,ReturnsOnly,RequestDate)
select ExportTemplateName, ExportTemplateVersionMajor,ExportTemplateVersionMinor,'9/1/15','11/30/15',0,getdate()
from cem.ExportTemplate
where ExportTemplateName='ACO CAHPS'
and ExportTemplateVersionMajor='ACO-12'
and ExportTemplateVersionMinor=1
set @EQid=SCOPE_IDENTITY()

insert into cem.ExportQueueSurvey (ExportQueueID, SurveyID)
select distinct @EQid, surveyid 
from #ACOSurveys
where subtype_nm='ACO-12'

insert into cem.ExportQueue (ExportTemplateName,ExportTemplateVersionMajor,ExportTemplateVersionMinor,ExportDateStart,ExportDateEnd,ReturnsOnly,RequestDate)
select ExportTemplateName, ExportTemplateVersionMajor,ExportTemplateVersionMinor,'9/1/15','11/30/15',0,getdate()
from cem.ExportTemplate
where ExportTemplateName='ACO CAHPS'
and ExportTemplateVersionMajor='ACO-9'
and ExportTemplateVersionMinor=1
set @EQid=SCOPE_IDENTITY()

insert into cem.ExportQueueSurvey (ExportQueueID, SurveyID)
select distinct @EQid, surveyid 
from #ACOSurveys
where subtype_nm='ACO-9'

-- declare @EQid int
insert into cem.ExportQueue (ExportTemplateName,ExportTemplateVersionMajor,ExportTemplateVersionMinor,ExportDateStart,ExportDateEnd,ReturnsOnly,RequestDate)
select ExportTemplateName, ExportTemplateVersionMajor,ExportTemplateVersionMinor,'7/1/15','11/30/15',0,getdate()
from cem.ExportTemplate
where ExportTemplateName='PQRS CAHPS'
and ExportTemplateVersionMajor='1.0'
and ExportTemplateVersionMinor=1
set @EQid=SCOPE_IDENTITY()

insert into cem.ExportQueueSurvey (ExportQueueID, SurveyID)
select distinct @EQid, surveyid 
from #ACOSurveys
where CAHPSTypeID=8

if exists (select * from sys.tables where name = 'ExportDataset00000004')
	drop table CEM.ExportDataset00000004
if object_id('tempdb..#results') is not null
	drop table #results
update cem.exportqueue set pulldate=null where exportqueueid=55
go
create table #results (ResultsID int identity(1,1), ExportQueueID int, ExportTemplateID int, SamplePopulationID int, QuestionFormID int, FileMakerName varchar(200))
exec cem.PullExportData @ExportQueueID=55, @doRecode=1, @doDispositionProc=1, @doPostProcess=1

/*
select [ResultsID],[ExportQueueID],[ExportTemplateID],[SamplePopulationID],[QuestionFormID],[FileMakerName],[submission.FINDER],[submission.ACO_ID],[submission.DISPOSITN],[submission.MODE],[submission.DISPO_LANG],[submission.RECEIVED]
,[submission.FOCALTYPE],[submission.PRTITLE],[submission.PRFNAME],[submission.PRLNAME],[submission.VERSION]
,[submission.Q01],[submission.Q02],[submission.Q03],[submission.Q04],[submission.Q05],[submission.Q06],[submission.Q07],[submission.Q08],[submission.Q09],[submission.Q10],[submission.Q11],[submission.Q12]
,[submission.Q13],[submission.Q14],[submission.Q15],[submission.Q16],[submission.Q17],[submission.Q18],[submission.Q19],[submission.Q20],[submission.Q21],[submission.Q22],[submission.Q23],[submission.Q24]
,[submission.Q25],[submission.Q26],[submission.Q27],[submission.Q28],[submission.Q29],[submission.Q30],[submission.Q31],[submission.Q32],[submission.Q33],[submission.Q34],[submission.Q35],[submission.Q36]
,[submission.Q37],[submission.Q38],[submission.Q39],[submission.Q40],[submission.Q41],[submission.Q42],[submission.Q43],[submission.Q44],[submission.Q45],[submission.Q46],[submission.Q47],[submission.Q48]
,[submission.Q49],[submission.Q50],[submission.Q51],[submission.Q52],[submission.Q53],[submission.Q54],[submission.Q55],[submission.Q56],[submission.Q57],[submission.Q58],[submission.Q59],[submission.Q60]
,[submission.Q61],[submission.Q62],[submission.Q63],[submission.Q64],[submission.Q65],[submission.Q66],[submission.Q67],[submission.Q68],[submission.Q69],[submission.Q70],[submission.Q71],[submission.Q72]
,[submission.Q73],[submission.Q74],[submission.Q75],[submission.Q76],[submission.Q77],[submission.Q78a],[submission.Q78b],[submission.Q78c],[submission.Q78d],[submission.Q78d1],[submission.Q78d2],[submission.Q78d3]
,[submission.Q78d4],[submission.Q78d5],[submission.Q78d6],[submission.Q78d7],[submission.Q78e],[submission.Q78e1],[submission.Q78e2],[submission.Q78e3],[submission.Q78e4],[submission.Q79],[submission.Q80a],[submission.Q80b]
,[submission.Q80c],[submission.Q80d],[submission.Q80e],[support.SUBYR],[support.SUBMN],[support.SUBDY],[support.SUBNUM],[support.FIELDDATE],[support.Q78a-mail],[support.Q78b-mail],[support.Q78c-mail]
,[support.Q78d1-mail],[support.Q78d2-mail],[support.Q78d3-mail],[support.Q78d4-mail],[support.Q78d5-mail],[support.Q78d6-mail],[support.Q78d7-mail],[support.Q78e1-mail],[support.Q78e2-mail],[support.Q78e3-mail]
,[support.Q78e4-mail]
from CEM.ExportDataset00000004
*/
where [submission.dispositn] not in ('33','433')


go
if exists (select * from sys.tables where name = 'ExportDataset00000006')
	drop table CEM.ExportDataset00000006
if object_id('tempdb..#results') is not null
	drop table #results

update cem.exportqueue set pulldate=null where exportqueueid=56
go
create table #results (ResultsID int identity(1,1), ExportQueueID int, ExportTemplateID int, SamplePopulationID int, QuestionFormID int, FileMakerName varchar(200))
exec cem.PullExportData @ExportQueueID=56, @dorecode=1, @dodispositionproc=1, @dopostprocess=1

/*
select [ResultsID],[ExportQueueID],[ExportTemplateID],[SamplePopulationID],[QuestionFormID],[FileMakerName],[submission.FINDER],[submission.ACO_ID],[submission.DISPOSITN],[submission.MODE],[submission.DISPO_LANG],[submission.RECEIVED]
,[submission.FOCALTYPE],[submission.PRTITLE],[submission.PRFNAME],[submission.PRLNAME]
,[submission.Q01],[submission.Q02],[submission.Q03],[submission.Q04],[submission.Q05],[submission.Q06],[submission.Q07],[submission.Q08],[submission.Q09],[submission.Q10],[submission.Q11],[submission.Q12]
,[submission.Q13],[submission.Q14],[submission.Q15],[submission.Q16],[submission.Q17],[submission.Q18],[submission.Q19],[submission.Q20],[submission.Q21],[submission.Q22],[submission.Q23],[submission.Q24]
,[submission.Q25],[submission.Q26],[submission.Q27],[submission.Q28],[submission.Q29],[submission.Q30],[submission.Q31],[submission.Q32],[submission.Q33],[submission.Q34],[submission.Q35],[submission.Q36]
,[submission.Q37],[submission.Q38],[submission.Q39],[submission.Q40],[submission.Q41],[submission.Q42],[submission.Q43],[submission.Q44],[submission.Q45],[submission.Q46],[submission.Q47],[submission.Q48]
,[submission.Q49],[submission.Q50],[submission.Q51],[submission.Q52],[submission.Q53],[submission.Q54],[submission.Q55],[submission.Q56],[submission.Q57],[submission.Q58],[submission.Q59],[submission.Q60]
,[submission.Q61],[submission.Q62],[submission.Q63],[submission.Q64],[submission.Q65],[submission.Q66],[submission.Q67],[submission.Q68],[submission.Q69],[submission.Q70],[submission.Q71],[submission.Q72]
,[submission.Q73],[submission.Q74],[submission.Q75],[submission.Q76],[submission.Q77],[submission.Q78a],[submission.Q78b],[submission.Q78c],[submission.Q78d],[submission.Q78d1],[submission.Q78d2],[submission.Q78d3]
,[submission.Q78d4],[submission.Q78d5],[submission.Q78d6],[submission.Q78d7],[submission.Q78e],[submission.Q78e1],[submission.Q78e2],[submission.Q78e3],[submission.Q78e4],[submission.Q79],[submission.Q80a],[submission.Q80b]
,[submission.Q80c],[submission.Q80d],[submission.Q80e],[support.SUBYR],[support.SUBMN],[support.SUBDY],[support.SUBNUM],[support.FIELDDATE],[support.Q78a-mail],[support.Q78b-mail],[support.Q78c-mail]
,[support.Q78d1-mail],[support.Q78d2-mail],[support.Q78d3-mail],[support.Q78d4-mail],[support.Q78d5-mail],[support.Q78d6-mail],[support.Q78d7-mail],[support.Q78e1-mail],[support.Q78e2-mail],[support.Q78e3-mail]
,[support.Q78e4-mail]
from CEM.ExportDataset00000006
*/



insert into cem.ExportQueueFile (ExportQueueID,FileState,FileMakerType,FileMakerName)
select distinct ExportQueueID,0 as FileState,2 as FileMakerType,FileMakerName
from CEM.ExportDataset00000004
union select distinct ExportQueueID,0 as FileState,2 as FileMakerType,FileMakerName
from CEM.ExportDataset00000006

