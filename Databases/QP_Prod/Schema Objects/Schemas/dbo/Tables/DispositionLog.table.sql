CREATE TABLE [dbo].[DispositionLog](
	[SentMail_id] [int] NULL,
	[SamplePop_id] [int] NULL,
	[Disposition_id] [int] NULL,
	[ReceiptType_id] [int] NULL,
	[datLogged] [datetime] NULL,
	[LoggedBy] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DaysFromCurrent] [int] NULL,
	[DaysFromFirst] [int] NULL,
	[bitExtracted] [bit] NULL
) ON [PRIMARY]


