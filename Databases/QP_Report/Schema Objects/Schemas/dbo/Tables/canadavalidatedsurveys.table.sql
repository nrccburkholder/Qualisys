CREATE TABLE [dbo].[canadavalidatedsurveys](
	[survey_id] [int] NOT NULL,
	[BITVALIDATED_FLG] [bit] NOT NULL,
	[DATVALIDATED] [datetime] NULL,
	[BITFORMGENRELEASE] [bit] NOT NULL,
	[BITLAYOUTVALID] [bit] NOT NULL
) ON [PRIMARY]


