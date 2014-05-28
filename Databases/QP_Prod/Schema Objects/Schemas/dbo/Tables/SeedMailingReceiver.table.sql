CREATE TABLE [dbo].[SeedMailingReceiver](
	[MailingReceiver_id] [int] IDENTITY(1,1) NOT NULL,
	[LName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FName] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Addr2] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ST] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZIP5] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip4] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Del_Pt] [varchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sex] [varchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[pop_id] [int] NULL,
	[Active] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[MailingReceiver_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


