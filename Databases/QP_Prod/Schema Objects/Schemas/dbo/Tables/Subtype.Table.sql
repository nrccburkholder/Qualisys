USE [QP_Prod]
GO
/****** Object:  Table [dbo].[Subtype]    Script Date: 09/18/2014 15:04:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Subtype](
	[Subtype_id] [int] IDENTITY(1,1) NOT NULL,
	[Subtype_nm] [varchar](50) NULL,
	[SubtypeCategory_id] [int] NULL,
	[bitRuleOverride] [bit] NULL,
 CONSTRAINT [pk_Subtype] PRIMARY KEY CLUSTERED 
(
	[Subtype_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Subtype]  WITH CHECK ADD  CONSTRAINT [fk_Subtype_SubtypeCategory] FOREIGN KEY([SubtypeCategory_id])
REFERENCES [dbo].[SubtypeCategory] ([SubtypeCategory_id])
GO
ALTER TABLE [dbo].[Subtype] CHECK CONSTRAINT [fk_Subtype_SubtypeCategory]
GO
