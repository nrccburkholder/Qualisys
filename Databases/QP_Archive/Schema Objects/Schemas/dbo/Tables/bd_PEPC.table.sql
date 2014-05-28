CREATE TABLE [dbo].[bd_PEPC](
	[study_id] [int] NULL,
	[drg] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[serviceind_32] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[enc_id] [int] NULL,
	[pop_id] [int] NULL,
	[Survey_id] [int] NULL,
	[sampled] [bit] NULL,
	[samplepop] [int] NULL,
	[datreturned] [datetime] NULL,
	[removed] [bit] NULL
) ON [PRIMARY]


