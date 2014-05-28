CREATE TABLE [dbo].[QSIDataForm](
	[Form_ID] [int] IDENTITY(1,1) NOT NULL,
	[Batch_ID] [int] NOT NULL,
	[LithoCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SentMail_ID] [int] NOT NULL,
	[QuestionForm_ID] [int] NOT NULL,
	[Survey_ID] [int] NOT NULL,
	[TemplateCode] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LangID] [int] NOT NULL,
	[TemplateName]  AS ((CONVERT([varchar],[Survey_ID],0)+[TemplateCode])+case when len(CONVERT([varchar],[LangID],0))<(2) then '0'+CONVERT([varchar],[LangID],0) when len(CONVERT([varchar],[LangID],0))>(2) then substring(CONVERT([varchar],[LangID],0),len(CONVERT([varchar],[LangID],0))-(1),(2)) else CONVERT([varchar],[LangID],0) end),
	[DateKeyed] [datetime] NULL,
	[KeyedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateVerified] [datetime] NULL,
	[VerifiedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED 
(
	[Form_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


