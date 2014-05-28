CREATE TABLE [dbo].[mb_Paradox_LocalSelQstns](
	[Survey_ID] [int] NULL,
	[SelQstns_ID] [int] NULL,
	[Language] [int] NULL,
	[Section_ID] [int] NULL,
	[Type] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Label] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PlusMinus] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subsection] [int] NULL,
	[Item] [int] NULL,
	[Subtype] [int] NULL,
	[ScaleID] [int] NULL,
	[Width] [int] NULL,
	[Height] [int] NULL,
	[QstnCore] [int] NULL,
	[ScalePos] [int] NULL,
	[bitLangReview] [bit] NOT NULL,
	[bitMeanable] [bit] NOT NULL,
	[numMarkCount] [int] NULL,
	[numBubbleCount] [int] NULL,
	[ScaleFlipped] [int] NULL,
	[SampleUnit_id] [int] NULL,
	[SAMPLEUNITSECTION_ID] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


