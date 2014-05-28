CREATE TABLE [dbo].[hchs_selectedsample](
	[SelectedSample_id] [int] NULL,
	[SampleSet_id] [int] NULL,
	[Study_id] [int] NULL,
	[Pop_id] [int] NULL,
	[SampleUnit_id] [int] NULL,
	[strUnitSelectType] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intExtracted_flg] [int] NULL,
	[Enc_id] [int] NULL
) ON [PRIMARY]


