CREATE TABLE [dbo].[MktGuide_PlanType](
	[mktguideplantype_id] [int] IDENTITY(1,1) NOT NULL,
	[strmktguide_plantype] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[mktguideplantype_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


