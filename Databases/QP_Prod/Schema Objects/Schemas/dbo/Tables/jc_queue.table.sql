CREATE TABLE [dbo].[jc_queue](
	[priority_flg] [int] NULL,
	[client_id] [int] NULL,
	[strClient_nm] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Study_id] [int] NULL,
	[strStudy_nm] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Survey_id] [int] NULL,
	[strSurvey_nm] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strMailingStep_nm] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Quantity] [int] NULL,
	[Mailing Type] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


