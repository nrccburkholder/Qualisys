/*
S36_US12 CEM Hospice XML v 1.3.sql

user story 12 Hospice - CEM- Hospice XML v 1.3
As an authorized Hospice CAHPS vendor, we must follow the specs for XML file v 1.3, so that our submission data will be accepted.

Dave Gilsdorf

NRC_DataMart_Extracts:
update cem.DispositionProcess

*/
use NRC_DataMart_Extracts
go
-- XML File Version 1.3
update cem.ExportTemplate
set ExportTemplateVersionMajor='1.1', ExportTemplateVersionMinor=2
where ExportTemplateName='CAHPS Hospice' 
and ExportTemplateVersionMajor='1.3'
and ExportTemplateVersionMinor=1

update cem.exportqueue
set ExportTemplateVersionMajor='1.1', ExportTemplateVersionMinor=2
where ExportTemplateName='CAHPS Hospice' 
and ExportTemplateVersionMajor='1.3'
and ExportTemplateVersionMinor=1


--Hospice Data section
--•	NPI is now alpha-numeric to allow for “M” value for missing
--> all CEM exported columns are varchars, regardless of expected contents

--•	Survey-mode – added “8 – not applicable (no decedents in the sampled month)”
delete from cem.ExportTemplate_view where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2 and ExportColumnName='survey-mode' and recodevalue='8'


--•	Total-decedents – added “M – missing” and changed type to alpha-numeric
--> all CEM exported columns are varchars, regardless of expected contents

--•	Live-discharges - added “M – missing” and changed type to alpha-numeric
--> all CEM exported columns are varchars, regardless of expected contents

--•	No-publicity - added “M – missing” and changed type to alpha-numeric
--> all CEM exported columns are varchars, regardless of expected contents

--•	Sample-type – added “8 – not applicable (no decedents in the sampled month)”
delete from cem.ExportTemplate_view where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2 and ExportColumnName='sample-type' and recodevalue='8'


--Decedent Level Data section
--•	Admission-year – added “8888” for missing. Now indicates “2009 or later”, but discussion during on-site visit indicated this was not intended to exclude patients w/ earlier admissions. They also indicated they would discuss further w/ CMS.
if not exists (select * from cem.ExportTemplate_view where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2 and ExportColumnName='admission-yr' and RecodeValue='2009')
	update etcr 
	set RecodeValue='2009', ResponseLabel = '2009'
	from cem.ExportTemplateColumnResponse etcr
	where RawValue=2009
	and ExportTemplateColumnID in (
		select ExportTemplateColumnID
		from cem.ExportTemplate_view 
		where ExportColumnName = 'admission-yr'
		and ExportTemplateID = (select ExportTemplateID from cem.ExportTemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2)
		)

delete from cem.ExportTemplate_view where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2 and ExportColumnName='admission-yr' and RawValue between 0 and 2008

--•	Admission-month – added “88” for missing.
delete from cem.ExportTemplate_view where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2 and ExportColumnName='admission-month' and RecodeValue='88'

--•	Admission-day – added “88” for missing.
delete from cem.ExportTemplate_view where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2 and ExportColumnName='admission-day' and RecodeValue='88'

--•	Survey-status – value 10 changed from “bad address” to “bad/no address”
if not exists (select * from cem.ExportTemplate_view where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2 and ExportColumnName='survey-status' and ResponseLabel = 'Non-response: Bad Address')
	update etcr 
	set ResponseLabel = 'Non-response: Bad Address'
	from cem.ExportTemplateColumnResponse etcr
	where ExportTemplateColumnResponseID in (
		select ExportTemplateColumnResponseID
		from cem.ExportTemplate_view 
		where ExportColumnName = 'survey-status'
		and RecodeValue='10'
		and ExportTemplateID = (select ExportTemplateID from cem.ExportTemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2)
		)
