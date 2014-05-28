CREATE TABLE [dbo].[SamplePopTemp](
	[ExtractFileID] [int] NOT NULL,
	[SAMPLESET_ID] [int] NULL,
	[STUDY_ID] [int] NULL,
	[SAMPLEPOP_ID] [int] NULL,
	[POP_ID] [int] NULL,
	[ENC_ID] [int] NULL,
	[firstName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lastName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[province] [nchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[postalCode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[language] [nchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[age] [int] NULL,
	[isMale] [bit] NULL,
	[admitDate] [datetime] NULL,
	[serviceDate] [datetime] NULL,
	[dischargeDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL CONSTRAINT [DF_SamplePopTemp_IsDeleted]  DEFAULT ((0)),
	[drNPI] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[clinicNPI] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


