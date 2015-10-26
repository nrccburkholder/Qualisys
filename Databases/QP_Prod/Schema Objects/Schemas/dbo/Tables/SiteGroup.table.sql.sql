USE [QP_Prod]
GO
/****** Object:  Table [dbo].[SiteGroup]    Script Date: 10/26/2015 3:47:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SiteGroup](
	[SiteGroup_ID] [int] IDENTITY(1,1) NOT NULL,
	[AssignedID] [nvarchar](20) NULL,
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
	[bitActive] [bit] NOT NULL,
 CONSTRAINT [PK_SiteGroup] PRIMARY KEY CLUSTERED 
(
	[SiteGroup_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[SiteGroup] ADD  DEFAULT ((1)) FOR [bitActive]
