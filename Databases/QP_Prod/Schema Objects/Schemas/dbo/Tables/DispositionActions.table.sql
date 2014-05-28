CREATE TABLE [dbo].[DispositionActions](
	[ActionID] [int] IDENTITY(0,1) NOT NULL,
	[ActionText] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_DispositionActions_DateCreated]  DEFAULT (getdate()),
 CONSTRAINT [PK_DispositionActions] PRIMARY KEY CLUSTERED 
(
	[ActionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


