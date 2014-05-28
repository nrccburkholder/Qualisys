CREATE TABLE [dbo].[DC_PEPCIIIPOPDATA](
	[study_id] [int] NULL,
	[survey_id] [int] NULL,
	[sampleunit_Id] [int] NULL,
	[populationpop_id] [int] NULL,
	[ENCOUNTERenc_id] [int] NULL,
	[populationage] [int] NULL,
	[populationsex] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ENCOUNTERserviceind_32] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ENCOUNTERDRG] [int] NULL,
	[bitSampled] [bit] NULL,
	[bitMistake] [bit] NULL,
	[Bitreturned] [int] NULL
) ON [PRIMARY]


