CREATE TABLE [dbo].[SampleUnitService](
	[SampleUnitService_id] [int] IDENTITY(1,1) NOT NULL,
	[SampleUnit_id] [int] NOT NULL,
	[Service_id] [int] NOT NULL,
	[strAltService_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datLastUpdated] [datetime] NULL
) ON [PRIMARY]


