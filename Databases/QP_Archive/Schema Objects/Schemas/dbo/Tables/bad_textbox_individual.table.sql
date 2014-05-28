CREATE TABLE [dbo].[bad_textbox_individual](
	[IndivTextBox_id] [int] NULL,
	[SelTextBox_id] [int] NULL,
	[Survey_id] [int] NULL,
	[Language] [int] NULL,
	[SelCover_id] [int] NULL,
	[SamplePop_id] [int] NULL,
	[RichText] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


