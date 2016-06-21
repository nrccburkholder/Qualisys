/*
S40_US33.2 Map CCN to file type

user story 33:
As an HHImporter I want to lookup the client CCN in a database and find the file type to use so that we can process their files.

Brendan Goble

Task 33.2 Add a database table for the client lookup, put in test data

*/
use QP_DataLoad
go

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE NAME = N'ClientFormat')
BEGIN
	CREATE TABLE [dbo].[ClientFormat]
	(
		CCN varchar(6) NOT NULL,
		Format varchar(20) NOT NULL,
		CreateDate DATETIME NOT NULL CONSTRAINT [DF_ClientFormat_CreateDate] DEFAULT GETDATE(),

		constraint PK_ClientFormat primary key clustered (CCN)
	)
END
go