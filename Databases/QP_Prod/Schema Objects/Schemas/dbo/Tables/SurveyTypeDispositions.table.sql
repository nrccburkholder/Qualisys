
/****** Object:  Table [dbo].[SurveyTypeDispositions]    Script Date: 6/12/2014 12:13:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SurveyTypeDispositions](
	[SurveyTypeDispositionID] [int] IDENTITY(1,1) NOT NULL,
	[Disposition_ID] [int] NULL,
	[Value] [varchar](5) NULL,
	[Hierarchy] [int] NULL,
	[Desc] [varchar](100) NULL,
	[ExportReportResponses] [bit] NULL,
	[ReceiptType_ID] [int] NULL,
	[SurveyType_ID] int NOT NULL
 CONSTRAINT [PK_SurveyTypeDispositions] PRIMARY KEY CLUSTERED 
(
	[SurveyTypeDispositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SurveyTypeDispositions] ADD  DEFAULT ((0)) FOR [ExportReportResponses]
GO

ALTER TABLE [dbo].[SurveyTypeDispositions]  WITH CHECK ADD  CONSTRAINT [FK_SurveyTypeDispositions_Disposition] FOREIGN KEY([Disposition_ID])
REFERENCES [dbo].[Disposition] ([Disposition_id])
GO

ALTER TABLE [dbo].[SurveyTypeDispositions] CHECK CONSTRAINT [FK_SurveyTypeDispositions_Disposition]
GO


