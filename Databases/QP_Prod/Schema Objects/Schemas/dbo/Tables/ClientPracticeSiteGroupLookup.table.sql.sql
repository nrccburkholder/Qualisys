USE [QP_Prod]
GO
/****** Object:  Table [dbo].[ClientPracticeSiteGroupLookup]    Script Date: 10/26/2015 3:47:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientPracticeSiteGroupLookup](
	[Client_id] [int] NOT NULL,
	[SiteGroup_id] [int] NOT NULL,
 CONSTRAINT [PK_CPSG_ClientPracticeSite] PRIMARY KEY CLUSTERED 
(
	[Client_id] ASC,
	[SiteGroup_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientPracticeSiteGroupLookup]  WITH CHECK ADD  CONSTRAINT [FK_CPSG_Client] FOREIGN KEY([Client_id])
REFERENCES [dbo].[CLIENT] ([CLIENT_ID])
GO
ALTER TABLE [dbo].[ClientPracticeSiteGroupLookup] CHECK CONSTRAINT [FK_CPSG_Client]
GO
ALTER TABLE [dbo].[ClientPracticeSiteGroupLookup]  WITH CHECK ADD  CONSTRAINT [FK_CPSG_PracticeSiteGroup] FOREIGN KEY([SiteGroup_id])
REFERENCES [dbo].[SiteGroup] ([SiteGroup_ID])
GO
ALTER TABLE [dbo].[ClientPracticeSiteGroupLookup] CHECK CONSTRAINT [FK_CPSG_PracticeSiteGroup]
