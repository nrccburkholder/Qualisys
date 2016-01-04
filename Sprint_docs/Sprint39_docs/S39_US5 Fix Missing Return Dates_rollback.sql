/*
S39_US5 Fix Missing Return Dates.sql

user story 5 Fix Missing Return Dates
As the Director of Research, I want the issue with missing return dates identified and resolved, so that we capture results from all returns.

Dave Gilsdorf

QP_Prod:
CREATE TABLE dbo.Questionform_Missing_datReturned 
CREATE TRIGGER [dbo].[trg_QuestionForm_temp_MissingReturnDates] 

*/
use QP_Prod
go
if exists (select * from sys.tables where name = 'Questionform_Missing_datReturned')
	DROP TABLE dbo.Questionform_Missing_datReturned 
go
if exists (select * from sys.objects where name = 'trg_QuestionForm_temp_MissingReturnDates' and type='tr')
	drop trigger [dbo].[trg_QuestionForm_temp_MissingReturnDates] 
go