/*
S40_US33.5 Map CCN to file type

user story 33:
As an HHImporter I want to lookup the client CCN in a database and find the file type to use so that we can process their files.

Brendan Goble

Task 33.5 Generate script to populate ClientFormat table with data from Seattle

ROLLBACK

*/
use QP_DataLoad
go

delete from dbo.ClientFormat
go