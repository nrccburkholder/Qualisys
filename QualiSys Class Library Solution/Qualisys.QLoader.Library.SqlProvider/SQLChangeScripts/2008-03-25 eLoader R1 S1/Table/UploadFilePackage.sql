USE [QP_Load]
GO
/****** Object:  Table [dbo].[UploadFilePackage]    Script Date: 05/01/2008 16:05:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UploadFilePackage](
	[UploadFilePackage_ID] [int] IDENTITY(1,1) NOT NULL,
	[UploadFile_id] [int] NOT NULL,
	[Package_id] [int] NOT NULL,
 CONSTRAINT [PK_UploadFilePackage] PRIMARY KEY CLUSTERED ([UploadFilePackage_ID] ASC)
) 