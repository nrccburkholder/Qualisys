/*
S40_US34.2 OCS HH: process update files

user story 34:
As a company, we want to process update files received from OCS HHCAHPS clients so that we provide complete data to CMS on behalf of the clients.

Brendan Goble

Task 34.2 Determine if an uploaded file is an update file.

ROLLBACK

*/
use QP_DataLoad
go

if OBJECT_ID('dbo.StudyHasAppliedData', 'P') is not null
	drop procedure dbo.StudyHasAppliedData
go