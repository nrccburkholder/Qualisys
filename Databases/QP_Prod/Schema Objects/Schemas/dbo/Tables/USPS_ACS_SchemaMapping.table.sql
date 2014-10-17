/****** Object:  Table [dbo].[USPS_ACS_SchemaMapping]    Script Date: 8/21/2014 10:55:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[USPS_ACS_SchemaMapping](
	[USPS_ACS_SchemaMapping_ID] [int] IDENTITY(1,1) NOT NULL,
	[USPS_ACS_Schema_ID] [int] NOT NULL,
	[RecordType] [varchar](1) NOT NULL,
	[DataType] [varchar](10) NOT NULL,
	[ColumnName] [varchar](255) NOT NULL,
	[ColumnStart] [int] NOT NULL,
	[ColumnWidth] [int] NOT NULL
 CONSTRAINT [PK_USPS_ACS_SchemaMapping] PRIMARY KEY CLUSTERED 
(
	[USPS_ACS_SchemaMapping_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO