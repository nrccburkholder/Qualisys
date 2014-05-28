CREATE TABLE [dbo].[PUR_Section](
	[PUReport_ID] [int] NOT NULL,
	[Section_ID] [smallint] NOT NULL,
	[Type] [tinyint] NOT NULL,
	[Skip] [bit] NOT NULL CONSTRAINT [DF__PUR_Sectio__Skip__2B5F6B28]  DEFAULT (0),
	[Title] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Format] [tinyint] NULL CONSTRAINT [DF_PUR_Section_Format]  DEFAULT (1),
	[Content] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Copy] [bit] NOT NULL CONSTRAINT [DF_PUR_Section_Copy]  DEFAULT (0),
	[PrevRptSection_ID] [int] NULL,
 CONSTRAINT [PK_PUR_Section] PRIMARY KEY CLUSTERED 
(
	[PUReport_ID] ASC,
	[Section_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


