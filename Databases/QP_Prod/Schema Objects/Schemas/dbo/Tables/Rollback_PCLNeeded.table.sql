CREATE TABLE [dbo].[Rollback_PCLNeeded](
	[Rollback_id] [int] NOT NULL,
	[SamplePop_id] [int] NULL,
	[Survey_id] [int] NULL,
	[SelCover_id] [int] NULL,
	[Language] [int] NULL,
	[SentMail_id] [int] NULL,
	[QuestionForm_id] [int] NULL,
	[Batch_id] [int] NULL,
	[bitDone] [bit] NOT NULL,
	[Priority_Flg] [tinyint] NULL
) ON [PRIMARY]


