CREATE TABLE [dbo].[ClientGroups](
	[ClientGroup_ID] [int] IDENTITY(1,1) NOT NULL,
	[ClientGroup_nm] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientGroupReporting_nm] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Active] [bit] NULL,
	[DateCreated] [datetime] NULL CONSTRAINT [DF_ClientGroups_DateCreated]  DEFAULT (getdate()),
 CONSTRAINT [PK_ClientGroups] PRIMARY KEY CLUSTERED 
(
	[ClientGroup_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


