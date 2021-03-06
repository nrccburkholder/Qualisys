USE [QP_Comments]
GO
/****** Object:  Table [dbo].[OneClickTypes]    Script Date: 07/25/2006 15:37:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OneClickTypes](
	[OneClickType_id] [int] IDENTITY(1,1) NOT NULL,
	[strOneClickType_Nm] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_OneClickTypes] PRIMARY KEY CLUSTERED 
(
	[OneClickType_id] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[OneClickTypes]  WITH NOCHECK ADD  CONSTRAINT [FK_OneClickTypes_OneClickTypes] FOREIGN KEY([OneClickType_id])
REFERENCES [dbo].[OneClickTypes] ([OneClickType_id])
GO
ALTER TABLE [dbo].[OneClickTypes] CHECK CONSTRAINT [FK_OneClickTypes_OneClickTypes]
GO
/****** Object:  Table [dbo].[OneClickDefinitions]    Script Date: 07/25/2006 15:36:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OneClickDefinitions](
	[OneClickDefinition_id] [int] IDENTITY(1,1) NOT NULL,
	[OneClickType_id] [int] NOT NULL,
	[strCategory_Nm] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[strOneClickReport_Nm] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[strOneClickReport_Dsc] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Report_id] [int] NOT NULL,
	[intOrder] [int] NOT NULL,
 CONSTRAINT [PK_OneClickDefinitions] PRIMARY KEY CLUSTERED 
(
	[OneClickDefinition_id] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[OneClickDefinitions]  WITH NOCHECK ADD  CONSTRAINT [FK_OneClickDefinitions_OneClickTypes] FOREIGN KEY([OneClickType_id])
REFERENCES [dbo].[OneClickTypes] ([OneClickType_id])
GO
ALTER TABLE [dbo].[OneClickDefinitions] CHECK CONSTRAINT [FK_OneClickDefinitions_OneClickTypes]
GO
/**********************************************************************************/
GO

