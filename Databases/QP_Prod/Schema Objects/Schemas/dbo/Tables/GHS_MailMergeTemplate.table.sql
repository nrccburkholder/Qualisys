CREATE TABLE [dbo].[GHS_MailMergeTemplate](
	[Template_ID] [int] NOT NULL,
	[TemplateName] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[strClient_NM] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [varchar](7500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Template_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


