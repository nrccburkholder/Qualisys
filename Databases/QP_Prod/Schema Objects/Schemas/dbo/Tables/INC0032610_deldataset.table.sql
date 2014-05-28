CREATE TABLE [dbo].[INC0032610_deldataset](
	[DATASET_QUEUE_ID] [int] IDENTITY(1,1) NOT NULL,
	[DATASET_ID] [int] NOT NULL,
	[strSTATE] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[datSTART_DT] [datetime] NULL,
	[datEND_DT] [datetime] NULL
) ON [PRIMARY]


