CREATE TABLE [dbo].[PCLQuestionForm](
	[QuestionForm_id] [int] NOT NULL,
	[Batch_id] [int] NOT NULL,
	[Survey_id] [int] NOT NULL,
	[paper_type] [int] NOT NULL,
	[language] [int] NULL,
	[bitIsProcessed] [bit] NULL,
 CONSTRAINT [PK_PCLQuestionForm] PRIMARY KEY CLUSTERED 
(
	[QuestionForm_id] ASC,
	[Batch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


