USE [QP_Prod]
GO

/****** Object:  Table [dbo].[SubtypeSubtypeMapping]    Script Date: 6/12/2015 12:00:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SubtypeSubtypeMapping](
	[SubtypeSubtypeMapping_id] [int] IDENTITY(1,1) NOT NULL,
	[ParentSubtype_id] [int] NOT NULL,
	[ChildSubtype_id] [int] NOT NULL
) ON [PRIMARY]

GO


