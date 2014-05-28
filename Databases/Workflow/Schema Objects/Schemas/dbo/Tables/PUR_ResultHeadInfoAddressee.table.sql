CREATE TABLE [dbo].[PUR_ResultHeadInfoAddressee](
	[PUReport_ID] [int] NOT NULL,
	[AddrType] [tinyint] NOT NULL,
	[SeqNum] [tinyint] NOT NULL,
	[Name] [varchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_PUR_ResultHeadInfoAddressee] PRIMARY KEY CLUSTERED 
(
	[PUReport_ID] ASC,
	[AddrType] ASC,
	[SeqNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


