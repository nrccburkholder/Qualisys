CREATE TABLE [dbo].[HCAHPSDispositions](
	[HCAHPSDispositionID] [int] IDENTITY(1,1) NOT NULL,
	[Disposition_ID] [int] NULL,
	[HCAHPSValue] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HCAHPSHierarchy] [int] NULL,
	[HCAHPSDesc] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExportReportResponses] [bit] NULL CONSTRAINT [DF_HCAHPSDispositions_ExportReportResponses]  DEFAULT ((0)),
 CONSTRAINT [PK_HCAHPSDispositions] PRIMARY KEY CLUSTERED 
(
	[HCAHPSDispositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


