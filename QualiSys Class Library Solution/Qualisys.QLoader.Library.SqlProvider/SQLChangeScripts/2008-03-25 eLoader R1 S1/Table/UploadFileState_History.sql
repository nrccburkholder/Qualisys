USE [QP_Load]
GO
/****** Object:  Table [dbo].[UploadFileState_History]    Script Date: 03/28/2008 15:36:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UploadFileState_History](
	[UploadFileState_id] [int] NOT NULL,
	[UploadFile_id] [int] NOT NULL,
	[UploadState_id] [int] NOT NULL,
	[datOccurred] [datetime] NOT NULL,
	[StateParameter] [varchar](2000) NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_UploadFileState] ON [dbo].[UploadFileState_History] (UploadFile_id, UploadState_id, datOccurred)
GO
SET ANSI_PADDING OFF