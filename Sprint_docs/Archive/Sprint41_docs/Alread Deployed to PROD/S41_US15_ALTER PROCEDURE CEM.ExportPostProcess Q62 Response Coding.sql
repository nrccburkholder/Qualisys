USE [NRC_DataMart_Extracts]
GO
/****** Object:  StoredProcedure [CEM].[ExportPostProcess00000002]    Script Date: 1/26/2016 9:12:14 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [CEM].[ExportPostProcess00000002]
@ExportQueueID int
as
update CEM.ExportDataset00000002
set [patientresponse.race-white-phone]='M', [patientresponse.race-african-amer-phone]='M', [patientresponse.race-amer-indian-phone]='M', [patientresponse.race-asian-phone]='M', 
	[patientresponse.race-nativehawaiian-pacific-phone]='M', [patientresponse.race-noneofabove-phone]='M' 
where len([patientresponse.race-white-phone]+[patientresponse.race-african-amer-phone]+[patientresponse.race-amer-indian-phone]+[patientresponse.race-asian-phone]
	+[patientresponse.race-nativehawaiian-pacific-phone]+[patientresponse.race-noneofabove-phone])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.race-asian-indian-phone]='M', [patientresponse.race-chinese-phone]='M', [patientresponse.race-filipino-phone]='M', [patientresponse.race-japanese-phone]='M', 
	[patientresponse.race-korean-phone]='M', [patientresponse.race-vietnamese-phone]='M', [patientresponse.race-otherasian-phone]='M', [patientresponse.race-noneofabove-asian-phone]='M'
where len([patientresponse.race-asian-indian-phone]+[patientresponse.race-chinese-phone]+[patientresponse.race-filipino-phone]+[patientresponse.race-japanese-phone]
	+[patientresponse.race-korean-phone]+[patientresponse.race-vietnamese-phone]+[patientresponse.race-otherasian-phone]+[patientresponse.race-noneofabove-asian-phone])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.race-nativehawaiian-phone]='M', [patientresponse.race-guam-chamarro-phone]='M', [patientresponse.race-samoan-phone]='M', [patientresponse.race-otherpacificislander-phone]='M',
	[patientresponse.race-noneofabove-pacific-phone]='M'
where len([patientresponse.race-nativehawaiian-phone]+[patientresponse.race-guam-chamarro-phone]+[patientresponse.race-samoan-phone]+[patientresponse.race-otherpacificislander-phone]
	+[patientresponse.race-noneofabove-pacific-phone])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.race-white-mail]='M', [patientresponse.race-african-amer-mail]='M', [patientresponse.race-amer-indian-mail]='M', [patientresponse.race-asian-indian-mail]='M', 
	[patientresponse.race-chinese-mail]='M', [patientresponse.race-filipino-mail]='M', [patientresponse.race-japanese-mail]='M', [patientresponse.race-korean-mail]='M', 
	[patientresponse.race-vietnamese-mail]='M', [patientresponse.race-otherasian-mail]='M', [patientresponse.race-nativehawaiian-mail]='M', [patientresponse.race-guamanian-chamorro-mail]='M', 
	[patientresponse.race-samoan-mail]='M', [patientresponse.race-other-pacificislander-mail]='M'

where len([patientresponse.race-white-mail]+[patientresponse.race-african-amer-mail]+[patientresponse.race-amer-indian-mail]+[patientresponse.race-asian-indian-mail]
	+[patientresponse.race-chinese-mail]+[patientresponse.race-filipino-mail]+[patientresponse.race-japanese-mail]+[patientresponse.race-korean-mail]+[patientresponse.race-vietnamese-mail]
	+[patientresponse.race-otherasian-mail]+[patientresponse.race-nativehawaiian-mail]+[patientresponse.race-guamanian-chamorro-mail]+[patientresponse.race-samoan-mail]
	+[patientresponse.race-other-pacificislander-mail])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

--update CEM.ExportDataset00000002
--set [patientresponse.help-answer]='M', [patientresponse.help-other]='M', [patientresponse.help-read]='M', [patientresponse.help-translate]='M', [patientresponse.help-wrote]='M'
--where len([patientresponse.help-answer]+[patientresponse.help-other]+[patientresponse.help-read]+[patientresponse.help-translate]+[patientresponse.help-wrote])=0
--and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
--and [administration.survey-mode]<>'X'
--and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.help-answer]='X', [patientresponse.help-other]='X', [patientresponse.help-read]='X', [patientresponse.help-translate]='X', [patientresponse.help-wrote]='X'
where len([patientresponse.help-answer]+[patientresponse.help-other]+[patientresponse.help-read]+[patientresponse.help-translate]+[patientresponse.help-wrote])=0
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=@ExportQueueID

update CEM.ExportDataset00000002
set [patientresponse.who-helped]='X'
where [patientresponse.who-helped]='M'
and [administration.final-status] in ('110','120','130','140','150','160','190','199','210')
and [administration.survey-mode]<>'X'
and ExportQueueID=67


-- update CEM.ExportDataset00000002
-- set [header.dcstart-date]='20150324'
-- where [header.dcstart-date]=''
-- and ExportQueueID=@ExportQueueID

-- update CEM.ExportDataset00000002
-- set [header.dcend-date]='20150714'
-- where [header.dcend-date]=''
-- and ExportQueueID=@ExportQueueID

-- These fields will be blank for surveys that have zero returns - the CEM template gets the values from QuestionForm's datFirstMailed and datExpire fields, and catalyst only has 
-- questionform fields for returned forms. So we're reaching back into Qualisys for any records where [header.dcstart-date]='' and [header.dcend-date]=''
update eds 
set [header.dcstart-date]=DCStart, [header.dcend-date]=DCEnd
from CEM.ExportDataset00000002 eds
inner join (select eds.[header.facility-id], convert(varchar,min(sm.datMailed),112) as DCStart, convert(varchar,max(sm.datExpire),112) as DCEnd
			from CEM.ExportDataset00000002 eds
			inner join NRC_Datamart.etl.DataSourceKey dsk on eds.samplepopulationID=dsk.datasourcekeyid
			inner join qualisys.qp_prod.dbo.scheduledmailing scm on dsk.datasourcekey=scm.samplepop_id
			inner join qualisys.qp_prod.dbo.sentmailing sm on scm.sentmail_id=sm.sentmail_id
			where [header.dcstart-date]='' and [header.dcend-date]=''
			and ExportQueueID=@ExportQueueID
			group by eds.[header.facility-id]) q
	on eds.[header.facility-id]=q.[header.facility-id]
where [header.dcstart-date]='' and [header.dcend-date]=''