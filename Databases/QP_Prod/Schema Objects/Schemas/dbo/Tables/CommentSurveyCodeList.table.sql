CREATE TABLE [dbo].[CommentSurveyCodeList](
	[Survey_id] [int] NOT NULL,
	[CmntSubHeader_id] [int] NOT NULL,
	[strModifiedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datModified] [datetime] NULL,
 CONSTRAINT [PK_CommentSurveyCodeList] PRIMARY KEY CLUSTERED 
(
	[Survey_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


