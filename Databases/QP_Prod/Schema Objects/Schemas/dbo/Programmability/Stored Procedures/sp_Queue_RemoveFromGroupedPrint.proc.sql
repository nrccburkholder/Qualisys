CREATE procedure dbo.sp_Queue_RemoveFromGroupedPrint
@survey_id int, @paperconfig_id int, @datBundled datetime
as
delete from dbo.GroupedPrint
where survey_id=@survey_id
and paperconfig_id=@paperconfig_id
and datBundled=@datBundled
and datPrinted is NULL


