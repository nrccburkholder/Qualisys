-- PQRS/ACO extract
-- not for deployment!

-- interim submission ExportQueueIDs:
--	64	ACO CAHPS	ACO-12	ExportTemplateID=4
--	65	ACO CAHPS	ACO-9	ExportTemplateID=5
--	66	PQRS CAHPS	1.0 	ExportTemplateID=6

select * 
from cem.exportqueue 
where exportqueueid between 64 and 66

select * from cem.exporttemplate where exporttemplatename in ('ACO CAHPS','ACO CAHPS','PQRS CAHPS')

go
-- interim submission ExportQueueIDs:
--	64	ACO CAHPS	ACO-12	ExportTemplateID=4
declare @eqid int
insert into cem.exportqueue (ExportTemplateName,ExportTemplateVersionMajor,ExportTemplateVersionMinor,ExportDateStart,ExportDateEnd,ReturnsOnly,RequestDate)
select ExportTemplateName,ExportTemplateVersionMajor,ExportTemplateVersionMinor,ExportDateStart,ExportDateEnd,ReturnsOnly,getdate() as RequestDate
from cem.exportqueue 
where exportqueueid = 64
set @eqid=SCOPE_IDENTITY()

insert into cem.exportqueuesurvey (ExportQueueID, SurveyID)
select @eqid, SurveyID
from cem.exportqueuesurvey 
where exportqueueid = 64 

select * from cem.exportqueue order by 1 desc
-- declare @eqid int = 83  delete from cem.exportdataset00000004 where exportqueueid=@eqid
exec cem.PullExportData @eqid 

declare @subnum int 
select @subnum=max([support.subnum]) 
from cem.ExportDataset00000004 eds 
inner join cem.exportqueuefile eqf on eds.exportqueueid=eqf.exportqueueid and eds.filemakername=eqf.filemakername
where [support.SUBYR]='16'
and [support.SUBMN]='02'
and [support.SUBDY]=right('0'+convert(varchar,datepart(day,getdate())),2)
and eqf.SubmissionDate is not null
and eds.exportqueueid<@eqid

update cem.ExportDataset00000004 
set  [support.SUBYR]='16'
	,[support.SUBMN]='02'
	,[support.SUBDY]=right('0'+convert(varchar,datepart(day,getdate())),2)
	,[support.SUBNUM]=isnull(@subnum,0)+1
where exportqueueid=@eqid

update cem.ExportDataset00000004 
set filemakername='ACO12.NationalResearchCorp.submission'+[support.SUBNUM]+'.'+[support.SUBMN]+[support.SUBDY]+[support.SUBYR] 
where exportqueueid=@eqid

insert into cem.exportqueuefile (ExportQueueID,FileState,FileMakerType,FileMakerName)
select distinct exportqueueid, 0, 2, FileMakerName
from cem.ExportDataset00000004 
where exportqueueid=@eqid


go
-- interim submission ExportQueueIDs:
--	65	ACO CAHPS	ACO-9	ExportTemplateID=5
declare @eqid int
insert into cem.exportqueue (ExportTemplateName,ExportTemplateVersionMajor,ExportTemplateVersionMinor,ExportDateStart,ExportDateEnd,ReturnsOnly,RequestDate)
select ExportTemplateName,ExportTemplateVersionMajor,ExportTemplateVersionMinor,ExportDateStart,ExportDateEnd,ReturnsOnly,getdate() as RequestDate
from cem.exportqueue 
where exportqueueid = 65
set @eqid=SCOPE_IDENTITY()

insert into cem.exportqueuesurvey (ExportQueueID, SurveyID)
select @eqid, SurveyID
from cem.exportqueuesurvey 
where exportqueueid = 65 

-- declare @eqid int = 84  delete from cem.exportdataset00000005 where exportqueueid=@eqid
exec cem.PullExportData @eqid

declare @subnum int 
select @subnum=max([support.subnum]) 
from cem.ExportDataset00000005 eds 
inner join cem.exportqueuefile eqf on eds.exportqueueid=eqf.exportqueueid and eds.filemakername=eqf.filemakername
where [support.SUBYR]='16'
and [support.SUBMN]='02'
and [support.SUBDY]=right('0'+convert(varchar,datepart(day,getdate())),2)
and eqf.SubmissionDate is not null
and eds.exportqueueid<@eqid

update cem.ExportDataset00000005
set  [support.SUBYR]='16'
	,[support.SUBMN]='02'
	,[support.SUBDY]=right('0'+convert(varchar,datepart(day,getdate())),2)
	,[support.SUBNUM]=isnull(@subnum,0)+1
where exportqueueid=@eqid

update cem.ExportDataset00000005 
set filemakername='ACO9.NationalResearchCorp.submission'+[support.SUBNUM]+'.'+[support.SUBMN]+[support.SUBDY]+[support.SUBYR] 
where exportqueueid=@eqid

insert into cem.exportqueuefile (ExportQueueID,FileState,FileMakerType,FileMakerName)
select distinct exportqueueid, 0, 2, FileMakerName
from cem.ExportDataset00000005
where exportqueueid=@eqid

go
-- interim submission ExportQueueIDs:
--	66	PQRS CAHPS	1.0 	ExportTemplateID=6
declare @eqid int
insert into cem.exportqueue (ExportTemplateName,ExportTemplateVersionMajor,ExportTemplateVersionMinor,ExportDateStart,ExportDateEnd,ReturnsOnly,RequestDate)
select ExportTemplateName,ExportTemplateVersionMajor,ExportTemplateVersionMinor,ExportDateStart,ExportDateEnd,ReturnsOnly,getdate() as RequestDate
from cem.exportqueue 
where exportqueueid = 66
set @eqid=SCOPE_IDENTITY()

insert into cem.exportqueuesurvey (ExportQueueID, SurveyID)
select @eqid, SurveyID
from cem.exportqueuesurvey 
where exportqueueid = 66

-- declare @eqid int = 85  delete from cem.exportdataset00000006 where exportqueueid=@eqid
exec cem.PullExportData @eqid

declare @subnum int 
select @subnum=max([support.subnum]) 
from cem.ExportDataset00000006 eds 
inner join cem.exportqueuefile eqf on eds.exportqueueid=eqf.exportqueueid and eds.filemakername=eqf.filemakername
where [support.SUBYR]='16'
and [support.SUBMN]='02'
and [support.SUBDY]=right('0'+convert(varchar,datepart(day,getdate())),2)
and eqf.SubmissionDate is not null
and eds.exportqueueid<@eqid

update cem.ExportDataset00000006
set  [support.SUBYR]='16'
	,[support.SUBMN]='02'
	,[support.SUBDY]=right('0'+convert(varchar,datepart(day,getdate())),2)
	,[support.SUBNUM]=isnull(@subnum,0)+1
where exportqueueid=@eqid

update cem.ExportDataset00000006 
set filemakername='PQRS.NationalResearchCorp.submission'+[support.SUBNUM]+'.'+[support.SUBMN]+[support.SUBDY]+[support.SUBYR] 
where exportqueueid=@eqid

insert into cem.exportqueuefile (ExportQueueID,FileState,FileMakerType,FileMakerName)
select distinct exportqueueid, 0, 2, FileMakerName
from cem.ExportDataset00000006
where exportqueueid=@eqid
