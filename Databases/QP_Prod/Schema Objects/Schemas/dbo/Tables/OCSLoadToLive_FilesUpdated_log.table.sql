CREATE TABLE [dbo].[OCSLoadToLive_FilesUpdated_log](
	[batch_id] [int] NULL,
	[datafile_id] [int] NULL,
	[study_id] [int] NULL,
	[totalupdated_nrc10] [int] NULL,
	[datUpdated_nrc10] [datetime] NULL,
	[totalupdated_medusa] [int] NULL,
	[datUpdated_medusa] [datetime] NULL,
	[dupkeysfound] [int] NULL,
	[datMinEncounterDate] [datetime] NULL,
	[datMaxEncounterDate] [datetime] NULL
) ON [PRIMARY]


