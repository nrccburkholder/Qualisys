CREATE TABLE [dbo].[HandEntry_Log](
	[HandEntry_Log_id] [int] IDENTITY(1,1) NOT NULL,
	[QuestionForm_id] [int] NULL,
	[Field_id] [int] NULL,
	[intProgram] [int] NULL,
	[datEntered] [datetime] NULL
) ON [PRIMARY]


