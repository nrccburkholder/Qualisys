-- CAHPS Hospice Q3 Extract

use NRC_Datamart_Extracts
go
select s.surveyID, s.surveyName, sufa.MedicareNumber, ss.SampleSetID, ss.SampleDate, ss.DatMature, count(distinct sp.samplepopulationid) as numSampled
into #x
from NRC_Datamart.dbo.samplepopulation sp 
inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
inner join NRC_Datamart.dbo.selectedsample sel on sp.SamplePopulationID=sel.SamplePopulationID
inner join NRC_Datamart.dbo.sampleunit su on sel.sampleunitid=su.sampleunitid
inner join NRC_Datamart.dbo.survey s on su.surveyID=s.surveyID
left join NRC_Datamart.dbo.SampleUnitFacilityAttributes sufa on sel.sampleunitid=sufa.sampleunitid
where s.cahpstypeid=6
and sp.servicedate between '2015-07-01' and '2015-09-30'
and su.isCahps=1
group by s.surveyID, s.surveyName, sufa.MedicareNumber, s.isActive, ss.SampleSetID, ss.SampleDate, ss.DatMature
order by s.surveyID, ss.SampleSetID


select count(distinct surveyid) from #x
select count(distinct samplesetid) from #x
select count(distinct medicarenumber) from #x

declare @eqid int
insert into cem.exportqueue (ExportTemplateName,ExportTemplateVersionMajor,ExportTemplateVersionMinor,ExportDateStart,ExportDateEnd,ReturnsOnly,RequestDate)
select ExportTemplateName,ExportTemplateVersionMajor,ExportTemplateVersionMinor,'7/1/15','9/30/15',0 as ReturnsOnly,getdate() as RequestDate
from cem.exporttemplate
where ExportTemplateName='CAHPS Hospice'
and ExportTemplateVersionMajor='2.1.1'
and ExportTemplateVersionMinor=1
set @eqid=SCOPE_IDENTITY()

insert into cem.exportqueuesurvey (ExportQueueID, SurveyID)
select distinct @eqid, SurveyID
from #x

exec cem.PullExportData @eqid

declare @subnum int 
select @subnum=max([vendordata.file-submission-number]) 
from cem.ExportDataset00000009 eds 
inner join cem.exportqueuefile eqf on eds.exportqueueid=eqf.exportqueueid and eds.filemakername=eqf.filemakername
where [vendordata.file-submission-yr]='2016'
and [vendordata.file-submission-month]='02'
and [vendordata.file-submission-day]=right('0'+convert(varchar,datepart(day,getdate())),2)
and eqf.SubmissionDate is not null
and eds.exportqueueid<@eqid

update cem.ExportDataset00000009 
set  [vendordata.file-submission-yr]='2016'
	,[vendordata.file-submission-month]='02'
	,[vendordata.file-submission-day]=right('0'+convert(varchar,datepart(day,getdate())),2)
	,[vendordata.file-submission-number]=isnull(@subnum,0)+1
where exportqueueid=@eqid

update cem.ExportDataset00000009 
set filemakername=[vendordata.vendor-name]+'.'+[vendordata.file-submission-month]+[vendordata.file-submission-day]+[vendordata.file-submission-yr]+'.'+[vendordata.file-submission-number]
where exportqueueid=@eqid

insert into cem.exportqueuefile (ExportQueueID,FileState,FileMakerType,FileMakerName)
select distinct exportqueueid, 0, 1, FileMakerName
from cem.ExportDataset00000009 
where exportqueueid=@eqid

