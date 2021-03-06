/****** Object:  Table [dbo].[AnswerCategories_jn]    Script Date: 08/08/2006 15:04:54 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[AnswerCategories_jn]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[AnswerCategories_jn]
GO
/****** Object:  Table [dbo].[AnswerCategories_jn]    Script Date: 08/08/2006 15:04:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[AnswerCategories_jn]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
CREATE TABLE [dbo].[AnswerCategories_jn](
	[jn_operation] [varchar](1) NOT NULL,
	[jn_user] [varchar](100) NOT NULL,
	[jn_datetime] [datetime] NOT NULL,
	[jn_endtime] [datetime] NOT NULL,
	[jn_notes] [varchar](240) NULL,
	[jn_appln] [varchar](30) NULL,
	[jn_session] [smallint] NULL,
	[AnswerCategoryID] [int] NOT NULL,
	[QuestionID] [int] NOT NULL,
	[AnswerValue] [int] NOT NULL,
	[AnswerText] [varchar](1000) NOT NULL,
	[AnswerCategoryTypeID] [int] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/****** Object:  Index [AnswerCategories_JE]    Script Date: 08/08/2006 15:04:55 ******/
IF NOT EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[dbo].[AnswerCategories_jn]') AND name = N'AnswerCategories_JE')
CREATE UNIQUE NONCLUSTERED INDEX [AnswerCategories_JE] ON [dbo].[AnswerCategories_jn] 
(
	[AnswerCategoryID] ASC,
	[jn_endtime] ASC
) ON [PRIMARY]
GO

/****** Object:  Index [AnswerCategories_JK]    Script Date: 08/08/2006 15:04:55 ******/
IF NOT EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[dbo].[AnswerCategories_jn]') AND name = N'AnswerCategories_JK')
CREATE NONCLUSTERED INDEX [AnswerCategories_JK] ON [dbo].[AnswerCategories_jn] 
(
	[jn_datetime] ASC
) ON [PRIMARY]
GO

/****** Object:  Index [AnswerCategories_JX]    Script Date: 08/08/2006 15:04:55 ******/
IF NOT EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[dbo].[AnswerCategories_jn]') AND name = N'AnswerCategories_JX')
CREATE UNIQUE NONCLUSTERED INDEX [AnswerCategories_JX] ON [dbo].[AnswerCategories_jn] 
(
	[AnswerCategoryID] ASC,
	[jn_datetime] ASC
) ON [PRIMARY]
GO

/****** Object:  Index [IX_AnswerCategories_jn]    Script Date: 08/08/2006 15:04:55 ******/
IF NOT EXISTS (SELECT * FROM dbo.sysindexes WHERE id = OBJECT_ID(N'[dbo].[AnswerCategories_jn]') AND name = N'IX_AnswerCategories_jn')
CREATE NONCLUSTERED INDEX [IX_AnswerCategories_jn] ON [dbo].[AnswerCategories_jn] 
(
	[QuestionID] ASC,
	[AnswerValue] ASC
) ON [PRIMARY]
GO
