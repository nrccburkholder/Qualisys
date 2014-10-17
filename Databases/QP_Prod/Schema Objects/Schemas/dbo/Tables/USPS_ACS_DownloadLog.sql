
/****** Object:  Table [dbo].[USPS_ACS_DownloadLog]    Script Date: 8/21/2014 10:55:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO


CREATE TABLE [dbo].[USPS_ACS_DownloadLog](
	[USPS_ACS_DownloadLog_ID] [int] IDENTITY(1,1) NOT NULL,
	[Key] [varchar](20) NOT NULL,
	[FileId] [varchar](20) NOT NULL,
	[FileName] [varchar](255) NOT NULL,
	[Size] [varchar](20) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[FulfilledDate] [varchar](8) NOT NULL,
	[ModifiedDate] [varchar](8) NOT NULL,
	[URL] [varchar](255) NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[DateCreated] DateTime,
	[DateModified] DateTime
 CONSTRAINT [PK_USPS_ACS_DownloadLog] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_DownloadLog_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO