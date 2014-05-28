CREATE procedure dbo.sp_Queue_AddToGroupedPrint
@survey_id int, @paperconfig_id int, @datBundled datetime
as
if not exists (	select * from dbo.GroupedPrint
		where survey_id=@survey_id
		and paperconfig_id=@paperconfig_id
		and datBundled=@datBundled
		and datPrinted is NULL)
	insert into dbo.GroupedPrint (survey_id, paperconfig_id, datBundled) 
	values (@survey_id, @paperconfig_id, @datBundled)


