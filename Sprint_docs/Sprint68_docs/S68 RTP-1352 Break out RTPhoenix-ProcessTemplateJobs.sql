/*
S68 RTP-1352 Break out RTPhoenix-ProcessTemplateJobs.sql

Chris Burkholder

2/14/2017

CREATE PROCEDURE RTPhoenix.ProcessTemplateJobs
--DROP PROCEDURE RTPhoenix.ProcessTemplateJobs
*/
Use [QP_Prod]
GO

CREATE PROCEDURE [RTPhoenix].[ProcessTemplateJobs]
AS
begin

	declare @TemplateLogEntryInfo int
	declare @TemplateLogEntryWarning int
	declare @TemplateLogEntryError int

	select @TemplateLogEntryInfo = TemplateLogEntryTypeID 
	from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'INFORMATIONAL'

	select @TemplateLogEntryWarning = TemplateLogEntryTypeID 
	from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'WARNING'

	select @TemplateLogEntryError = TemplateLogEntryTypeID 
	from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'ERROR'

	declare @TemplateJob_ID int = 0

	--Select top job and execute corresponding process for each job
	while 1=1
	begin
		select @TemplateJob_ID = Min([TemplateJobID])
		from [RTPhoenix].[TemplateJob]
		where [CompletedAt] is null

		if @TemplateJob_ID is null
			break

		declare @Template_ID int
		declare @user nvarchar(40)
		declare @TemplateJobType_ID int

		select @Template_ID = [TemplateID],
			@user = [LoggedBy],
			@TemplateJobType_ID = [TemplateJobTypeID]
		from [RTPhoenix].[TemplateJob]
		where [TemplateJobID] = @TemplateJob_ID

		if @TemplateJobType_ID = 1 
		begin
			Exec [RTPhoenix].[MakeStudyFromTemplate] @TemplateJob_id

			INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
				VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'RTPhoenix.MakeStudyFromTemplate ' + convert(varchar, @TemplateJob_id), @user, GetDate())
		end
		else
		if @TemplateJobType_ID = 2 
		begin
			Exec [RTPhoenix].[MakeSurveysFromTemplate] @TemplateJob_id

			INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
				VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'RTPhoenix.MakeSurveysFromTemplate ' + convert(varchar, @TemplateJob_id), @user, GetDate())
		end
		else 
		if @TemplateJobType_ID = 3 
		begin
			Exec [RTPhoenix].[MakeSampleUnitsFromTemplate] @TemplateJob_id

			INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
				VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'RTPhoenix.MakeSampleUnitsFromTemplate ' + convert(varchar, @TemplateJob_id), @user, GetDate())
		end
		else
		if @TemplateJobType_ID = 4 
		begin
			Exec [RTPhoenix].[ProcessStudyOwnedTables] @TemplateJob_id

			INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
				VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'RTPhoenix.ProcessStudyOwnedTables ' + convert(varchar, @TemplateJob_id), @user, GetDate())
		end
		Else
		begin
			update [RTPhoenix].[TemplateJob] set
				[CompletedNotes] = 'Unknown Template Job Type: '+ convert(varchar, @TemplateJobType_ID),
				[CompletedAt] = GetDate()
			where [TemplateJobID] = @TemplateJob_ID

			INSERT INTO [RTPhoenix].[TemplateLog]([TemplateID], [TemplateJobID], [TemplateLogEntryTypeID], [Message] ,[LoggedBy] ,[LoggedAt])
				VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryError, 'Unknown Template Job Type ', @user, GetDate())
		end

		if exists(select * from [RTPhoenix].[TemplateJob] 
				where [TemplateJobID] = @TemplateJob_ID and
					[CompletedAt] is null)
			update [RTPhoenix].[TemplateJob] set
				[CompletedNotes] = 'Unknown Template Job Flow Error',
				[CompletedAt] = GetDate()
			where [TemplateJobID] = @TemplateJob_ID
			
	end
	
end
