/****** Object:  Table [dbo].[USPS_ACS_ExtractFileLog]    Script Date: 8/21/2014 10:55:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO




CREATE TABLE [dbo].[USPS_ACS_ExtractFileLog](
	[USPS_ACS_ExtractFileLog_ID] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [varchar](255) NOT NULL,
	[FilePath] [varchar](255) NOT NULL,
	[Version] [varchar](2) NOT NULL,
	[DetailRecordIndicator] [varchar](1) NOT NULL,
	[CustomerID] [varchar](6) NOT NULL,
	[RecordCount] [varchar](9) NOT NULL,
	[HeaderDate] [varchar](8) NOT NULL,
	[HeaderText] [varchar](1000) NOT NULL,
	[ZipFileName] [varchar](255) NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[DateCreated] DateTime,
	[DateModified] DateTime
 CONSTRAINT [PK_USPS_ACS_ExtractFileLog] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_ExtractFileLog_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO