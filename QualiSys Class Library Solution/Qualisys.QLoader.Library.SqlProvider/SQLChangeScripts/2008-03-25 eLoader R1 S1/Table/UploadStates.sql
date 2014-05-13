USE [QP_Load]
GO
/****** Object:  Table [dbo].[UploadStates]    Script Date: 03/28/2008 15:41:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UploadStates](
	[UploadState_id] [int] IDENTITY(1,1) NOT NULL,
	[UploadState_Nm] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UploadStates] PRIMARY KEY CLUSTERED ([UploadState_id] ASC)
)

GO
SET ANSI_PADDING OFF