CREATE TABLE [dbo].[ClinicTest](
	[CLINIC_id] [int] IDENTITY(1,1) NOT NULL,
	[NewRecordDate] [datetime] NULL,
	[UtilizationCode] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClinicName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewRecordFlag] [int] NULL,
	[ClinicNum] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


