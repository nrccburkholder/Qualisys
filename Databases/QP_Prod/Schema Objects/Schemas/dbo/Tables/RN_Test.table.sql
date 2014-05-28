CREATE TABLE [dbo].[RN_Test](
	[SentMail_id] [int] IDENTITY(1,1) NOT NULL,
	[StrPostalBundle] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strGroupDest] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datBundled] [datetime] NULL
) ON [PRIMARY]


