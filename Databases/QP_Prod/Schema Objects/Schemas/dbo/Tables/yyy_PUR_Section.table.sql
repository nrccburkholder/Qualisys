CREATE TABLE [dbo].[yyy_PUR_Section](
	[PUReport_ID] [int] NOT NULL,
	[Section_ID] [smallint] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[Skip] [bit] NOT NULL,
	[Title] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Format] [tinyint] NULL,
	[Content] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Copy] [bit] NOT NULL,
	[PrevRptSection_ID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


