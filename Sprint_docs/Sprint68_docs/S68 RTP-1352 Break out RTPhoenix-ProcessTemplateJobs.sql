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

	select @TemplateLogEntryInfo = TemplateLogEntryType_ID 
	from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'INFORMATIONAL'

	select @TemplateLogEntryWarning = TemplateLogEntryType_ID 
	from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'WARNING'

	select @TemplateLogEntryError = TemplateLogEntryType_ID 
	from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'ERROR'

	declare @TemplateJob_ID int = 0

	--Select top job and execute corresponding process for each job
	while 1=1
	begin
		select @TemplateJob_ID = Min(TemplateJob_ID)
		from RTPhoenix.TemplateJob
		where CompletedAt is null

		if @TemplateJob_ID is null
			break

		declare @Template_ID int
		declare @user nvarchar(40)
		declare @TemplateJobType_ID int

		select @Template_ID = Template_id,
			@user = LoggedBy,
			@TemplateJobType_ID = TemplateJobType_id
		from RTPhoenix.TemplateJob
		where TemplateJob_ID = @TemplateJob_ID

		if @TemplateJobType_ID = 1 
		begin
			Exec RTPhoenix.MakeStudyFromTemplate @TemplateJob_id

			INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
				VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'RTPhoenix.MakeStudyFromTemplate ' + convert(varchar, @TemplateJob_id), @user, GetDate())
		end
		else
		if @TemplateJobType_ID = 2 
		begin
			Exec RTPhoenix.MakeSurveysFromTemplate @TemplateJob_id

			INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
				VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'RTPhoenix.MakeSurveysFromTemplate ' + convert(varchar, @TemplateJob_id), @user, GetDate())
		end
		else 
		if @TemplateJobType_ID = 3 
		begin
			Exec RTPhoenix.MakeSampleUnitsFromTemplate @TemplateJob_id

			INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
				VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'RTPhoenix.MakeSampleUnitsFromTemplate ' + convert(varchar, @TemplateJob_id), @user, GetDate())
		end
		else
		if @TemplateJobType_ID = 4 
		begin
			Exec RTPhoenix.ProcessStudyOwnedTables @TemplateJob_id

			INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
				VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'RTPhoenix.ProcessStudyOwnedTables ' + convert(varchar, @TemplateJob_id), @user, GetDate())
		end
		Else
			INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
				VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryError, 'Unknown Template Job Type ', @user, GetDate())
	end
	
end
