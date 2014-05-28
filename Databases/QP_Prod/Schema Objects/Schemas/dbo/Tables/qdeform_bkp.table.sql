CREATE TABLE [dbo].[qdeform_bkp](
	[Form_id] [int] IDENTITY(1,1) NOT NULL,
	[strLithoCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SentMail_id] [int] NOT NULL,
	[QuestionForm_id] [int] NOT NULL,
	[Batch_id] [int] NULL,
	[Survey_id] [int] NULL,
	[strTemplateCode] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LangID] [int] NULL,
	[bitLocked] [bit] NOT NULL,
	[strTemplateName] [varchar](62) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


