CREATE TABLE [dbo].[DispositionLogTemp](
	[ExtractFileID] [int] NOT NULL,
	[SamplePop_id] [int] NOT NULL,
	[Disposition_id] [int] NOT NULL,
	[ReceiptType_id] [int] NULL,
	[datLogged] [datetime] NOT NULL,
	[LoggedBy] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DaysFromCurrent] [int] NULL,
	[DaysFromFirst] [int] NULL
) ON [PRIMARY]


