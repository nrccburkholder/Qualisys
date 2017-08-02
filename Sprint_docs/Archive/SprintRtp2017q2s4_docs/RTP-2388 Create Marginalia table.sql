/*
	RTP-2388 Create Marginalia table.sql

	Lanny Boswell

	6/9/2017
*/

USE [QP_Prod]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Marginalia]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Marginalia](
                [Marginalia_id] [int] IDENTITY(1,1) NOT NULL,
                [QuestionForm_id] [int] NULL,
                [strCmntText] [text] NULL,
                [datEntered] [datetime] NULL,
                [CmntType_id] [int] NULL,
                [CmntValence_id] [int] NULL,
CONSTRAINT [PK_Marginalia] PRIMARY KEY CLUSTERED 
(
                [Marginalia_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
