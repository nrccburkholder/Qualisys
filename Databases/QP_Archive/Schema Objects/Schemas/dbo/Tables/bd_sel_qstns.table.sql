CREATE TABLE [dbo].[bd_sel_qstns](
	[selqstns_id] [int] NOT NULL,
	[survey_id] [int] NOT NULL,
	[richtext] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strfullquestion] [varchar](6000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


