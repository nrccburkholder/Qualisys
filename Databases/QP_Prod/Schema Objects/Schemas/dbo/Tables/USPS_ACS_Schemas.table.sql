/****** Object:  Table [dbo].[USPS_ACS_Schemas]    Script Date: 8/21/2014 11:01:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[USPS_ACS_Schemas](
	[USPS_ACS_Schema_ID] [int] IDENTITY(1,1) NOT NULL,
	[SchemaName] [varchar](255) NOT NULL,
	[FileVersion] [varchar](2) NULL,
	[DetailRecordIndicator] [varchar](1) NOT NULL,
	[RecordLength] [int] NOT NULL,
	[ExpiryDate] DateTime NULL
 CONSTRAINT [PK_USPS_ACS_Schemas] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_Schema_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO