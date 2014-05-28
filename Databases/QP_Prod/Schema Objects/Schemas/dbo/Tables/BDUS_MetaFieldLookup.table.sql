CREATE TABLE [dbo].[BDUS_MetaFieldLookup](
	[Survey_id] [int] NOT NULL,
	[Field_id] [int] NOT NULL,
	[intOrder] [int] NOT NULL,
	[strValidValues] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitRequired] [bit] NOT NULL CONSTRAINT [DF_BDUS_MetaFieldLookup_bitRequired]  DEFAULT (0)
) ON [PRIMARY]


