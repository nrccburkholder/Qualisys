USE [QP_PROD]
GO

DROP TABLE [dbo].[SiteGroup]

/****** Object:  Table [dbo].[Group]    Script Date: 7/15/2015 11:07:37 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE TABLE [dbo].[SiteGroup](
	[SiteGroup_ID] [int] IDENTITY(1,1) NOT NULL,
	[AssignedID] [int] NULL,
	[GroupName] [nvarchar](50) NULL,
	[Addr1] [nvarchar](60) NULL,
	[Addr2] [nvarchar](42) NULL,
	[City] [nvarchar](42) NULL,
	[ST] [nvarchar](2) NULL,
	[Zip5] [nvarchar](5) NULL,
	[Phone] [nvarchar](13) NULL,
	[GroupOwnership] [nvarchar](2) NULL,
	[GroupContactName] [nvarchar](50) NULL,
	[GroupContactPhone] [nvarchar](10) NULL,
	[GroupContactEmail] [nvarchar](50) NULL,
	[MasterGroupID] [int] NULL,
	[MasterGroupName] [varchar](50) NULL,
	[bitActive] [bit] NOT NULL DEFAULT 1,
 CONSTRAINT [PK_SiteGroup] PRIMARY KEY CLUSTERED 
(
	[SiteGroup_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


