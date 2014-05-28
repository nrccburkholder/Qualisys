CREATE TABLE [dbo].[HHCAHPSDispositions](
	[HHCAHPSDispositionID] [int] IDENTITY(1,1) NOT NULL,
	[Disposition_ID] [int] NULL,
	[HHCAHPSValue] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HHCAHPSHierarchy] [int] NULL,
	[HHCAHPSDesc] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReceiptType_ID] [int] NULL,
	[ExportReportResponses] [bit] NULL CONSTRAINT [DF_HHCAHPSDispositions_ExportReportResponses]  DEFAULT ((0)),
 CONSTRAINT [PK_HHCAHPSDispositions] PRIMARY KEY CLUSTERED 
(
	[HHCAHPSDispositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


