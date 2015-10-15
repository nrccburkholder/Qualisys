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
select distinct ExportTemplateColumnID, 0, null, '8', 'not applicable (no decedents in the sampled month)'
from cem.ExportTemplate_view 
where ExportColumnName='survey-mode' 
and ExportTemplateID = (select ExportTemplateID from cem.ExportTemplate where ExportTemplateName='CAHPS Hospice' and ExportTemplateVersionMajor='1.1' and ExportTemplateVersionMinor=2)


--•	Total-decedents – added “M – missing” and changed type to alpha-numeric
--•	Live-discharges - added “M – missing” and changed type to alpha-numeric
--•	No-publicity - added “M – missing” and changed type to alpha-numeric
--•	Sample-type – added “8 – not applicable (no decedents in the sampled month)”


--Decedent Level Data section
--•	Admission-year – added “8888” for missing. Now indicates “2009 or later”, but discussion during on-site visit indicated this was not intended to exclude patients w/ earlier admissions. They also indicated they would discuss further w/ CMS.
--•	Admission-month – added “88” for missing.
--•	Admission-day – added “88” for missing.
--•	Survey-status – value 10 changed from “bad address” to “bad/no address”
