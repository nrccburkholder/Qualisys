USE [QP_Load]
GO
/****** Object:  Table [dbo].[UploadFileState]    Script Date: 03/28/2008 15:29:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UploadFileState](
	[UploadFileState_id] [int] IDENTITY(1,1) NOT NULL,
	[UploadFile_id] [int] NOT NULL,
	[UploadState_id] [int] NOT NULL,
	[datOccurred] [datetime] NOT NULL,
	[StateParameter] [varchar](2000) NULL,
 CONSTRAINT [PK_UploadFileState] PRIMARY KEY CLUSTERED ([UploadFileState_id] ASC)
)
GO
CREATE NONCLUSTERED INDEX [IX_UploadFileState] ON [dbo].[UploadFileState] (UploadFile_id)
SET ANSI_PADDING OFF