/****** Object:  Table [dbo].[AnswerCategoryTypes]    Script Date: 08/08/2006 15:12:30 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[AnswerCategoryTypes]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[AnswerCategoryTypes]
GO
/****** Object:  Table [dbo].[AnswerCategoryTypes]    Script Date: 08/08/2006 15:12:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[AnswerCategoryTypes]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[AnswerCategoryTypes](
	[AnswerCategoryTypeID] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [AnswerCategoryTypes_pk] PRIMARY KEY CLUSTERED 
(
	[AnswerCategoryTypeID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
