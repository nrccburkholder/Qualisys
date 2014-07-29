


USE [QP_Comments]
GO

/****** Object:  Table [dbo].[SurveyTypeDispositions]    Script Date: 6/13/2014 2:08:35 PM ******/
SET ANSI_NULLS ON
GO



SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SurveyTypeDispositions](
	[SurveyTypeDispositionID] [int] NOT NULL,
	[Disposition_ID] [int] NULL,
	[Value] [varchar](5) NULL,
	[Hierarchy] [int] NULL,
	[Desc] [varchar](100) NULL,
	[ExportReportResponses] [bit] NULL,
	[ReceiptType_ID] [int] NULL,
	[SurveyType_ID] int NOT NULL
	) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SurveyTypeDispositions] ADD  CONSTRAINT [DF_SurveyTypeDispositions_ExportReportResponses]  DEFAULT (0) FOR [ExportReportResponses]
GO

ALTER TABLE [dbo].[SurveyTypeDispositions]  WITH CHECK ADD  CONSTRAINT [FK_SurveyTypeDispositions_Disposition] FOREIGN KEY([Disposition_ID])
REFERENCES [dbo].[Disposition] ([Disposition_id])
GO

ALTER TABLE [dbo].[SurveyTypeDispositions] CHECK CONSTRAINT [FK_SurveyTypeDispositions_Disposition]
GO

