USE [QP_PROD]
GO

/****** Object:  Table [dbo].[PracticeSite]    Script Date: 7/15/2015 11:04:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[PracticeSite](
	[PracticeSite_ID] [int] IDENTITY(1,1) NOT NULL,
	[AssignedID] [int] NULL,
	[SiteGroup_ID] [int] NULL,
	[PracticeName] [nvarchar](50) NULL,
	[Addr1] [nvarchar](60) NULL,
	[Addr2] [nvarchar](42) NULL,
	[City] [nvarchar](42) NULL,
	[ST] [nvarchar](2) NULL,
	[Zip5] [nvarchar](5) NULL,
	[Phone] [nvarchar](10) NULL,
	[PracticeOwnership] [nvarchar](2) NULL,
	[PatVisitsWeek] [int] NULL,
	[ProvWorkWeek] [int] NULL,
	[PracticeContactName] [nvarchar](50) NULL,
	[PracticeContactPhone] [nvarchar](10) NULL,
	[PracticeContactEmail] [nvarchar](50) NULL,
	[SampleUnit_id] [int] NULL,
	[bitActive] [bit] NOT NULL DEFAULT 1
 CONSTRAINT [PK_PracticeSite] PRIMARY KEY CLUSTERED 
(
	[PracticeSite_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


