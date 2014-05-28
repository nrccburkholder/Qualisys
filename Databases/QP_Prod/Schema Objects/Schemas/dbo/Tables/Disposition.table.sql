CREATE TABLE [dbo].[Disposition](
	[Disposition_id] [int] IDENTITY(18,1) NOT NULL,
	[strDispositionLabel] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Action_id] [int] NOT NULL CONSTRAINT [DF_Disposition_Action_id]  DEFAULT (0),
	[strReportLabel] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MustHaveResults] [bit] NULL CONSTRAINT [DF_Disposition_MustHaveResults]  DEFAULT (0),
 CONSTRAINT [PK_Disposition] PRIMARY KEY CLUSTERED 
(
	[Disposition_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


