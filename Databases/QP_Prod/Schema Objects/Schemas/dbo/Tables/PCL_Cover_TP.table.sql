CREATE TABLE [dbo].[PCL_Cover_TP](
	[SelCover_id] [int] NOT NULL,
	[Survey_id] [int] NOT NULL,
	[PageType] [int] NULL,
	[Description] [char](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Integrated] [bit] NOT NULL,
	[bitLetterHead] [bit] NOT NULL,
	[datValidated] [datetime] NULL
) ON [PRIMARY]


