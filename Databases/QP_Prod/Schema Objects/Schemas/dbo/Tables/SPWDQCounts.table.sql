CREATE TABLE [dbo].[SPWDQCounts](
	[SPWDQCounts_id] [int] IDENTITY(1,1) NOT NULL,
	[Sampleset_id] [int] NOT NULL,
	[Sampleunit_id] [int] NOT NULL,
	[DQ] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[N] [int] NOT NULL
) ON [PRIMARY]


