CREATE TABLE [dbo].[ExtractClient_Exclude](
	[Client_ID] [int] NOT NULL,
	[Created] [datetime] NOT NULL CONSTRAINT [DF_ExtractClient_Exclude_Created]  DEFAULT (getdate()),
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_ExtractClient_Exclude_IsInactive]  DEFAULT (1),
 CONSTRAINT [PK_ExtractClient_Exclude] PRIMARY KEY CLUSTERED 
(
	[Client_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


