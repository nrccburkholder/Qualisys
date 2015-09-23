/*
S34_US23 CopyExportTemplate.sql

As a compliance analyst I want the ACO submission file to be created in CEM using the newest version of submission file layout

23.1 - create a new template in CEM for ACO

Dave Gilsdorf

NRC_DataMart_Extracts:
CREATE PROCEDURE [CEM].[CopyExportTemplate]

*/
use NRC_DataMart_Extracts
go
if exists (select * from sys.procedures where name = 'CopyExportTemplate')
	drop PROCEDURE [CEM].[CopyExportTemplate]
