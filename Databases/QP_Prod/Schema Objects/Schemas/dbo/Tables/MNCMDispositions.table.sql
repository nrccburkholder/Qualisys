CREATE TABLE [dbo].[MNCMDispositions](
	[MNCMDispositionID] [int] IDENTITY(1,1) NOT NULL,
	[Disposition_ID] [int] NULL,
	[MNCMValue] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MNCMHierarchy] [int] NULL,
	[MNCMDesc] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReceiptType_ID] [int] NULL,
	[ExportReportResponses] [bit] NULL CONSTRAINT [DF_MNCMDispositions_ExportReportResponses]  DEFAULT ((0)),
 CONSTRAINT [PK_MNCMDispositions] PRIMARY KEY CLUSTERED 
(
	[MNCMDispositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


