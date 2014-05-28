CREATE TABLE [dbo].[CommentSubHeaders](
	[CmntSubHeader_id] [int] IDENTITY(1,1) NOT NULL,
	[CmntHeader_id] [int] NOT NULL,
	[strCmntSubHeader_Nm] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[bitRetired] [bit] NOT NULL CONSTRAINT [DF_CommentSubHeaders_bitRetired]  DEFAULT (0),
	[strModifiedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datModified] [datetime] NULL,
	[intOrder] [int] NULL,
 CONSTRAINT [PK_CommentSubHeaders] PRIMARY KEY NONCLUSTERED 
(
	[CmntSubHeader_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


