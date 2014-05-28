CREATE TABLE [dbo].[OCSLoadToLive_PopsUpdated_log](
	[batch_id] [int] NULL,
	[datafile_id] [int] NULL,
	[study_id] [int] NULL,
	[pop_id] [int] NULL,
	[enc_id] [int] NULL,
	[enc_mtch] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datUpdated] [datetime] NULL
) ON [PRIMARY]


