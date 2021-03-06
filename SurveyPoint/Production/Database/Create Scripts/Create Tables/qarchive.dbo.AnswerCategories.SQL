/****** Object:  Table [dbo].[AnswerCategories]    Script Date: 08/08/2006 14:48:34 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[AnswerCategories]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[AnswerCategories]
GO
/****** Object:  Table [dbo].[AnswerCategories]    Script Date: 08/08/2006 14:48:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[AnswerCategories]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[AnswerCategories](
	[AnswerCategoryID] [int] NOT NULL,
	[QuestionID] [int] NOT NULL,
	[AnswerValue] [int] NOT NULL,
	[AnswerText] [varchar](1000) NOT NULL,
	[AnswerCategoryTypeID] [int] NOT NULL,
 CONSTRAINT [AnswerCategories_pk] PRIMARY KEY CLUSTERED 
(
	[AnswerCategoryID] ASC
) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Index [IX_AnswerCategories]    Script Date: 08/08/2006 14:48:35 ******/
IF NOT EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[dbo].[AnswerCategories]') AND name = N'IX_AnswerCategories')
CREATE NONCLUSTERED INDEX [IX_AnswerCategories] ON [dbo].[AnswerCategories] 
(
	[QuestionID] ASC,
	[AnswerValue] ASC
) ON [PRIMARY]
GO
