USE [QP_Load]
GO
/****** Object:  Table [dbo].[UploadActions]    Script Date: 03/28/2008 15:41:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UploadActions](
	[UploadAction_id] [int] IDENTITY(1,1) NOT NULL,
	[UploadAction_Nm] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UploadActions] PRIMARY KEY CLUSTERED ([UploadAction_id] ASC)
)

GO
SET ANSI_PADDING OFF