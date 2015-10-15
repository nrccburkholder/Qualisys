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
set ExportTemplateVersionMajor='1.3', ExportTemplateVersionMinor=1
where ExportTemplateName='CAHPS Hospice' 
and ExportTemplateVersionMajor='1.1'
and ExportTemplateVersionMinor=2

update cem.exportqueue
set ExportTemplateVersionMajor='1.3', ExportTemplateVersionMinor=1
where ExportTemplateName='CAHPS Hospice' 
and ExportTemplateVersionMajor='1.1'
and ExportTemplateVersionMinor=2


--Hospice Data section
--•	NPI is now alpha-numeric to allow for “M” value for missing
--> all CEM exported columns are varchars, regardless of expected contents

--•	Survey-mode – added “8 – not applicable (no decedents in the sampled month)”
insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
select distinct ExportTemplateColumnID, 8, null, '8', 'not applicable (no decedents in the sampled month)'
from cem.ExportTemplate_view 
where ExportColumnName='survey-mode' 
and ExportTemplateID = (select ExportTemplateID from cem.ExportTemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2)


--•	Total-decedents – added “M – missing” and changed type to alpha-numeric
--> all CEM exported columns are varchars, regardless of expected contents

--•	Live-discharges - added “M – missing” and changed type to alpha-numeric
--> all CEM exported columns are varchars, regardless of expected contents

--•	No-publicity - added “M – missing” and changed type to alpha-numeric
--> all CEM exported columns are varchars, regardless of expected contents

--•	Sample-type – added “8 – not applicable (no decedents in the sampled month)”
insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
select distinct ExportTemplateColumnID, 8, null, '8', 'not applicable (no decedents in the sampled month)'
from cem.ExportTemplate_view 
where ExportColumnName='sample-type' 
and ExportTemplateID = (select ExportTemplateID from cem.ExportTemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2)


--Decedent Level Data section
--•	Admission-year – added “8888” for missing. Now indicates “2009 or later”, but discussion during on-site visit indicated this was not intended to exclude patients w/ earlier admissions. They also indicated they would discuss further w/ CMS.
update etcr 
set RecodeValue='8888', ResponseLabel = '2009 or later'
from cem.ExportTemplateColumnResponse etcr
where RawValue=2009
and ExportTemplateColumnID in (
	select ExportTemplateColumnID
	from cem.ExportTemplate_view 
	where ExportColumnName = 'admission-yr'
	and ExportTemplateID = (select ExportTemplateID from cem.ExportTemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2)
	)

insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
select distinct ExportTemplateColumnID, yr, null, '8888', '2009 or later'
from cem.ExportTemplate_view, (select 2008 as yr union select 2007 union select 2006 union select 2005 union select 2004 union select 2003 union select 2002 union select 2001 union select 0) y
where ExportColumnName = 'admission-yr'
and ExportTemplateID = (select ExportTemplateID from cem.ExportTemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2)
order by yr desc

--•	Admission-month – added “88” for missing.
insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
select distinct ExportTemplateColumnID, 0, null, '88', 'missing'
from cem.ExportTemplate_view
where ExportColumnName = 'admission-month'
and ExportTemplateID = (select ExportTemplateID from cem.ExportTemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2)

--•	Admission-day – added “88” for missing.
insert into cem.ExportTemplateColumnResponse (ExportTemplateColumnID, RawValue, ExportColumnName, RecodeValue, ResponseLabel)
select distinct ExportTemplateColumnID, 0, null, '88', 'missing'
from cem.ExportTemplate_view
where ExportColumnName = 'admission-day'
and ExportTemplateID = (select ExportTemplateID from cem.ExportTemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2)

--•	Survey-status – value 10 changed from “bad address” to “bad/no address”
update etcr 
set ResponseLabel = 'Non-response: Bad/No Address'
from cem.ExportTemplateColumnResponse etcr
where ExportTemplateColumnResponseID in (
	select ExportTemplateColumnResponseID
	from cem.ExportTemplate_view 
	where ExportColumnName = 'survey-status'
	and RecodeValue='10'
	and ExportTemplateID = (select ExportTemplateID from cem.ExportTemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2)
	)
