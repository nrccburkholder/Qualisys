CREATE TABLE [dbo].[mb_Paradox_LocalSelPCL](
	[Survey_ID] [int] NULL,
	[QPC_ID] [int] NULL,
	[Language] [int] NULL,
	[CoverID] [int] NULL,
	[Type] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[Width] [int] NULL,
	[Height] [int] NULL,
	[KnownDimensions] [bit] NOT NULL
) ON [PRIMARY]


