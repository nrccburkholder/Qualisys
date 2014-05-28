CREATE TABLE [dbo].[OCSLoadToLive_DupKeysFound_log](
	[batch_id] [int] NULL,
	[datafile_id] [int] NULL,
	[study_id] [int] NULL,
	[enc_mtch] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datFound] [datetime] NULL
) ON [PRIMARY]


