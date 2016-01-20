/*
S40_US34.2 OCS HH: process update files

user story 34:
As a company, we want to process update files received from OCS HHCAHPS clients so that we provide complete data to CMS on behalf of the clients.

Brendan Goble

Task 34.2 Determine if an uploaded file is an update file.

*/
use QP_DataLoad
go

if OBJECT_ID('dbo.StudyHasAppliedData', 'P') is not null
	drop procedure dbo.StudyHasAppliedData
go
create procedure dbo.StudyHasAppliedData
	@StudyId int,
	@SampleMonth int,
	@SampleYear int
as
begin
	set nocount on;

	declare @StudySchema varchar(13) = 'S' + cast(@StudyId as varchar(12));

	declare @sql varchar(1000) = 
	'
	if exists (
		select top 1 1
		from Qualisys.QP_Prod.' + @StudySchema + '.ENCOUNTER
		where
			HHSampleYear = ' + cast(@SampleYear as varchar(4)) + '
			and HHSampleMonth = ' + cast(@SampleMonth as varchar(2)) + '
	) select 1 else select 0';

	declare @Results table(result int);

	insert into @Results
	exec(@sql);
	
	declare @result int
	select @result = result from @Results;

	return @result;
end
go