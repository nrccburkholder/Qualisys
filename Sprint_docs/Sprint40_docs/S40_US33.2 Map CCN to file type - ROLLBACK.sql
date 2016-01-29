/*
S40_US33.2 Map CCN to file type

user story 33:
As an HHImporter I want to lookup the client CCN in a database and find the file type to use so that we can process their files.

Brendan Goble

Task 33.2 Add a database table for the client lookup, put in test data

ROLLBACK

*/
use QP_DataLoad
go

IF EXISTS (SELECT 1 FROM sys.tables WHERE NAME = N'ClientFormat')
BEGIN
	drop table [dbo].[ClientFormat]
END
go