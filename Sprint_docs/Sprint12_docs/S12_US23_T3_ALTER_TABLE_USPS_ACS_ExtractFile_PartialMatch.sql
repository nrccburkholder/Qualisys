/*
S12.US23 USPS Partial and multiple match resolution
		 USPS Partial and multiple match resolution in Qualisys Explorer rather than emailing 

	Add UpdateStatus and DateUpdated columns to USPS_ACS_ExtractFile_PartialMatch

Tim Butler

alter table [dbo].[USPS_ACS_ExtractFile_PartialMatch]

*/
use qp_prod
go
begin tran
go
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'USPS_ACS_ExtractFile_PartialMatch' 
					   AND sc.NAME = 'UpdateStatus' )

	alter table [dbo].[USPS_ACS_ExtractFile_PartialMatch] add UpdateStatus tinyint NOT NULL default(0)
go

if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'USPS_ACS_ExtractFile_PartialMatch' 
					   AND sc.NAME = 'DateUpdated' )

	alter table [dbo].[USPS_ACS_ExtractFile_PartialMatch] add DateUpdated datetime
go
commit tran

