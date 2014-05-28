CREATE TABLE [dbo].[WebSurveyFields](
	[Survey_id] [int] NOT NULL,
	[Field_id] [int] NOT NULL,
	[strField_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MethodName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Table_id] [int] NOT NULL,
	[strTable_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_WebSurveyFields] PRIMARY KEY CLUSTERED 
(
	[Survey_id] ASC,
	[Field_id] ASC,
	[Table_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]


