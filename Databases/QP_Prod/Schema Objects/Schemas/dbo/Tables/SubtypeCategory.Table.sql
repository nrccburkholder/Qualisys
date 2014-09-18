USE [QP_Prod]
GO
/****** Object:  Table [dbo].[SubtypeCategory]    Script Date: 09/18/2014 15:04:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SubtypeCategory](
	[SubtypeCategory_id] [int] IDENTITY(1,1) NOT NULL,
	[SubtypeCategory_nm] [varchar](50) NULL,
	[bitMultiSelect] [bit] NULL,
 CONSTRAINT [pk_SubtypeCategory] PRIMARY KEY CLUSTERED 
(
	[SubtypeCategory_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
