USE [QP_Load]
GO
/****** Object:  Table [dbo].[UploadFile]    Script Date: 03/28/2008 15:26:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UploadFile](
	[UploadFile_id] [int] IDENTITY(1,1) NOT NULL,
	[OrigFile_Nm] [varchar](255) NOT NULL,
	[File_Nm] [varchar](255) NOT NULL,
	[FileSize] [int] NOT NULL,
	[UploadAction_id] [int] NOT NULL,
	[UserNotes] [varchar](1000) NOT NULL,
	[Member_id] [int] NOT NULL,
	[Group_id] [int] NOT NULL,
 CONSTRAINT [PK_Upload] PRIMARY KEY CLUSTERED 
(
	[UploadFile_id] ASC
)
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF