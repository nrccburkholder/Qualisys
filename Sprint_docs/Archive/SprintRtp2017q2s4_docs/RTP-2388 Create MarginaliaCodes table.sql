/*
	RTP-2388 Create MarginaliaCodes table.sql

	Lanny Boswell

	6/9/2017
*/

USE [QP_Prod]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarginaliaCodes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MarginaliaCodes](
                [Marginalia_id] [int] NOT NULL,
                [CmntCode_id] [int] NOT NULL,
CONSTRAINT [PK_MarginaliaCodes] PRIMARY KEY CLUSTERED 
(
                [Marginalia_id] ASC,
				[CmntCode_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
