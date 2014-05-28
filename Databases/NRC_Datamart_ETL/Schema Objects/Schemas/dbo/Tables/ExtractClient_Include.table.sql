CREATE TABLE [dbo].[ExtractClient_Include](
	[Client_ID] [int] NOT NULL,
	[Created] [datetime] NOT NULL CONSTRAINT [DF_ExtractClient_Include_Created]  DEFAULT (getdate()),
	[IsActive] [bit] NOT NULL CONSTRAINT [DF_ExtractClient_Include_IsInactive]  DEFAULT (1),
 CONSTRAINT [PK_ExtractIncludeClient_Include] PRIMARY KEY CLUSTERED 
(
	[Client_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


