

select distinct su.SurveyID, ss.samplesetid, 0 as survey_id, 0 as sampleset_id 
into #suss
from NRC_Datamart.dbo.SamplePopulation sp 
inner join NRC_Datamart.dbo.SampleSet ss on sp.SampleSetID=ss.SampleSetID
inner join NRC_Datamart.dbo.SelectedSample sel on sp.SamplePopulationID=sel.SamplePopulationID
inner join NRC_Datamart.dbo.SampleUnit su on sel.sampleunitid=su.sampleunitid
inner join nrc_datamart.dbo.survey s on su.SurveyID=s.surveyid
where surveytypeid=3
and servicedate>='2015-01-01'




update s set survey_id=dsk.DataSourceKey
from #suss s
inner join nrc_datamart.etl.datasourcekey dsk on s.surveyid=dsk.DataSourceKeyID

update s set sampleset_id=dsk.DataSourceKey
from #suss s
inner join nrc_datamart.etl.datasourcekey dsk on s.SampleSetID=dsk.DataSourceKeyID

select cast(sampleset_id as varchar) + ',' as ssid, cast(survey_id as varchar) + ',' as sid,* from #suss 


drop table #suss


