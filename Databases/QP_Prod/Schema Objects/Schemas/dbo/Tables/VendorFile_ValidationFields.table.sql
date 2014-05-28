CREATE TABLE [dbo].[VendorFile_ValidationFields](
	[VendorFile_ValidationField_ID] [int] IDENTITY(1,1) NOT NULL,
	[strDescription] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Field_ID] [int] NULL,
	[strField_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strFormula] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitUseGroupBy] [bit] NULL,
	[GroupByLowLimit] [int] NULL CONSTRAINT [DF_VendorFile_ValidationFields_GroupByLowLimit]  DEFAULT (0),
	[bitNullCount] [bit] NULL,
	[bitFreqLimit] [bit] NULL,
	[bitUseThreshold] [bit] NULL,
	[ThresholdPct] [int] NULL,
	[bitPhone] [bit] NULL CONSTRAINT [DF_VendorFile_ValidationFields_bitPhone]  DEFAULT (0),
	[bitWeb] [bit] NULL CONSTRAINT [DF_VendorFile_ValidationFields_bitWeb]  DEFAULT (0),
 CONSTRAINT [PK_VendorFile_ValidationFields] PRIMARY KEY CLUSTERED 
(
	[VendorFile_ValidationField_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


