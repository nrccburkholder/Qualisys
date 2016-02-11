/*

Sprint 41 User Story 16: OCS HH Process Update Files.
Task 4: Create a table to store records that have been parsed, but not yet transformed.

Brendan Goble

ROLLBACK

*/

use QP_DataLoad
go

if exists (select * from sys.tables where name = 'MergeRecord' and schema_id = SCHEMA_ID('dbo'))
	drop table dbo.MergeRecord;
go

if exists (select * from sys.procedures where name = 'UpdateMergeRecords' and schema_id = SCHEMA_ID('dbo'))
	drop procedure dbo.UpdateMergeRecords;
go