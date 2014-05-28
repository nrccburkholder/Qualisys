CREATE TABLE [dbo].[CommentHeaders](
	[CmntHeader_id] [int] IDENTITY(1,1) NOT NULL,
	[strCmntHeader_Nm] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[bitRetired] [bit] NOT NULL CONSTRAINT [DF_CommentHeaders_bitRetired]  DEFAULT (0),
	[strModifiedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datModified] [datetime] NULL,
	[intOrder] [int] NULL,
 CONSTRAINT [PK_CommentHeaders] PRIMARY KEY NONCLUSTERED 
(
	[CmntHeader_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


