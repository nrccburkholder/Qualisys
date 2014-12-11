USE [QP_Prod]
GO

/****** Object:  Table [dbo].[USPS_ACS_DownloadLog]    Script Date: 12/10/2014 12:20:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[USPS_ACS_DownloadLog](
	[USPS_ACS_DownloadLog_ID] [int] IDENTITY(1,1) NOT NULL,
	[Key] [varchar](20) NOT NULL,
	[FileId] [varchar](20) NOT NULL,
	[FileName] [varchar](255) NOT NULL,
	[Size] [varchar](20) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[Name] [varchar](50) NOT NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[USPS_ACS_DownloadLog] ADD [FulfilledDate] [varchar](10) NULL
ALTER TABLE [dbo].[USPS_ACS_DownloadLog] ADD [ModifiedDate] [varchar](10) NULL
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[USPS_ACS_DownloadLog] ADD [URL] [varchar](255) NOT NULL
ALTER TABLE [dbo].[USPS_ACS_DownloadLog] ADD [Status] [varchar](20) NOT NULL
ALTER TABLE [dbo].[USPS_ACS_DownloadLog] ADD [DateCreated] [datetime] NULL
ALTER TABLE [dbo].[USPS_ACS_DownloadLog] ADD [DateModified] [datetime] NULL
 CONSTRAINT [PK_USPS_ACS_DownloadLog] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_DownloadLog_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


