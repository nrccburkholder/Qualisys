/*
S36_US11 CAHPS Hospice exclude caregiverresponse section.sql

user story 11 
Hospice -- CEM- Hospice File Results Section------ 
As an authorized Hospice CAHPS Vendor, we are only to include the survey results section in the submission file when the final disposition is 1, 6, or 7, so that our files are accepted.	
NOTES: See email from RJ 10/07/2015

Dave Gilsdorf

NRC_DataMart_Extracts:
update cem.DispositionProcess

*/
use NRC_DataMart_Extracts
go

update dp
set recodeValue='M'
from cem.DispositionProcess dp
where dp.RecodeValue=' '
and dp.DispositionProcessID=(
	select top 1 DispositionProcessID 
	from cem.ExportTemplate_view 
	where ExportTemplateName='CAHPS Hospice' 
	and ExportTemplateVersionMajor='1.1'
	and ExportTemplateVersionMinor=2
	and ExportTemplateSectionName='caregiverresponse'
	and DispositionProcessID is not null)
