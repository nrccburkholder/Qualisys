CREATE TABLE [dbo].[ReportTest](
	[sampunit] [int] NULL,
	[qstncore] [int] NULL,
	[response] [int] NULL,
	[prev] [float] NULL,
	[prev_s] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[crnt] [float] NULL,
	[Exc] [float] NULL,
	[FP] [float] NULL,
	[Norm] [float] NULL,
	[norm_s] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[corrcoef] [float] NULL,
	[depvar] [int] NULL,
	[label] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Qstn] [varchar](22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


