CREATE TABLE [dbo].[DL_QuestionResults](
	[DL_QuestionResult_ID] [int] IDENTITY(1,1) NOT NULL,
	[DL_LithoCode_ID] [int] NULL,
	[DL_Error_ID] [int] NULL,
	[QstnCore] [int] NULL,
	[ResponseVal] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MultipleResponse] [bit] NULL CONSTRAINT [DF_DL_QuestionResults_MultipleResponse]  DEFAULT (0),
	[DateCreated] [datetime] NULL CONSTRAINT [DF__DL_Questi__DateC__3337F91F]  DEFAULT (getdate()),
 CONSTRAINT [PK_DL_QuestionResults] PRIMARY KEY CLUSTERED 
(
	[DL_QuestionResult_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


