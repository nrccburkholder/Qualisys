CREATE TABLE [dbo].[QDEForm](
	[Form_id] [int] IDENTITY(1,1) NOT NULL,
	[strLithoCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SentMail_id] [int] NOT NULL,
	[QuestionForm_id] [int] NOT NULL,
	[Batch_id] [int] NULL,
	[Survey_id] [int] NULL,
	[strTemplateCode] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LangID] [int] NULL,
	[bitLocked] [bit] NOT NULL CONSTRAINT [DF_QDEDataEntry_bitLocked]  DEFAULT (0),
	[strTemplateName]  AS (convert(varchar,[Survey_id]) + [strTemplateCode] + case when (len(convert(varchar,[LangID])) < 2) then ('0' + convert(varchar,[LangID])) else (convert(varchar,[LangID])) end),
 CONSTRAINT [PK_QDEDataEntry] PRIMARY KEY CLUSTERED 
(
	[Form_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


