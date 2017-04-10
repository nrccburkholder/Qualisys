/*
S72_ATL-1429 Update OAS CPT Code Exclusions [QP_Load].sql

Lanny Boswell

4/6/2017

CREATE TABLE [dbo].[OasExcludedCptCode]
INSERT INTO [dbo].[OasExcludedCptCode]

*/

USE [QP_Load]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OasExcludedCptCode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[OasExcludedCptCode](
	[CptCode] [int] NOT NULL,
	[AddedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_OasExcludedCptCode] PRIMARY KEY CLUSTERED 
(
	[CptCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_OasExcludedCptCode_AddedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[OasExcludedCptCode] ADD  CONSTRAINT [DF_OasExcludedCptCode_AddedDate]  DEFAULT (getdate()) FOR [AddedDate]
END
GO

IF NOT EXISTS (SELECT * FROM [dbo].[OasExcludedCptCode])
BEGIN
INSERT INTO [dbo].[OasExcludedCptCode](CptCode) VALUES
	(11042), (11045), (16020), (16025), (16030), (29000), (29010), (29015), (29020), 
	(29025), (29035), (29040), (29044), (29046), (29049), (29055), (29058), (29065), 
	(29075), (29085), (29086), (29105), (29125), (29126), (29200), (29240), (29260), 
	(29280), (29305), (29325), (29345), (29355), (29358), (29365), (29405), (29425), 
	(29435), (29440), (29445), (29450), (29505), (29515), (29520), (29530), (29540), 
	(29550), (29580), (29581), (29582), (36400), (36405), (36406), (36415), (36416), 
	(36420), (36425), (36440), (36450), (36455), (36460), (36468), (36469), (36470), 
	(36471), (36600), (36620), (36625), (36660), (51701), (51702), (59020), (59025)
END