/****** Object:  Table [dbo].[USPS_ACS_ExtractFile]    Script Date: 9/23/2014 10:38:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING OFF
GO

CREATE TABLE [dbo].[USPS_ACS_ExtractFile](
	[USPS_ACS_ExtractFile_ID] [int] IDENTITY(1,1) NOT NULL,
	[USPS_ACS_ExtractFileLog_ID] [int] NULL,
	[RecordText] [varchar](8000) NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[DateCreated] [datetime] NULL,
	[DateModified] [datetime] NULL,
	[IsNotified] [bit] NOT NULL,
 CONSTRAINT [PK_USPS_ACS_ExtractFile] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_ExtractFile_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[USPS_ACS_ExtractFile] ADD  DEFAULT ((0)) FOR [IsNotified]
GO

