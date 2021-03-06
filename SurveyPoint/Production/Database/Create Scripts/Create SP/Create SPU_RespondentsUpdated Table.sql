USE [QMS]
GO
/****** Object:  Table [dbo].[SPU_RespondentsUpdated]    Script Date: 11/28/2007 15:20:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SPU_RespondentsUpdated](
	[SPURespondentUpdatedID] [int] IDENTITY(1,1) NOT NULL,
	[RespondentID] [int] NULL,
	[FileLogID] [int] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_SPU_RespondentsUpdated] PRIMARY KEY CLUSTERED 
(
	[SPURespondentUpdatedID] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[SPU_RespondentsUpdated]  WITH CHECK ADD  CONSTRAINT [FK_SPU_RespondentsUpdated_Respondents] FOREIGN KEY([RespondentID])
REFERENCES [dbo].[Respondents] ([RespondentID])
GO
ALTER TABLE [dbo].[SPU_RespondentsUpdated] CHECK CONSTRAINT [FK_SPU_RespondentsUpdated_Respondents]
GO
ALTER TABLE [dbo].[SPU_RespondentsUpdated]  WITH CHECK ADD  CONSTRAINT [FK_SPU_RespondentsUpdated_SPU_FileTrackingLog] FOREIGN KEY([FileLogID])
REFERENCES [dbo].[SPU_FileTrackingLog] ([FileLogID])
GO
ALTER TABLE [dbo].[SPU_RespondentsUpdated] CHECK CONSTRAINT [FK_SPU_RespondentsUpdated_SPU_FileTrackingLog]