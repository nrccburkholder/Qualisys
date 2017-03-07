/*
S70 RTP-1677 Create OutreachRequest tables.sql

Lanny Boswell

3/2/2017

Create Table OutreachVendor
Insert OutreachVendor 'DG Solutions'
Create Table OutreachRequest

*/
USE [QP_Prod]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RTPhoenix].[OutreachVendor]') AND type in (N'U'))
BEGIN
CREATE TABLE [RTPhoenix].[OutreachVendor](
	[OutreachVendorID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_OutreachVendor] PRIMARY KEY CLUSTERED 
(
	[OutreachVendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM [RTPhoenix].[OutreachVendor] WHERE [OutreachVendorID] = 1)
BEGIN
	INSERT [RTPhoenix].[OutreachVendor] ([OutreachVendorID], [Name]) VALUES (1, 'DG Solutions')
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RTPhoenix].[OutreachRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [RTPhoenix].[OutreachRequest](
	[OutreachRequestID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NOT NULL,
	[MailingID] [varchar](10) NOT NULL,
	[OutreachVendorID] [int] NOT NULL,
	[PatientBK] [varchar](42) NOT NULL,
	[EncounterBK] [varchar](42) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[Attempt] [int] NOT NULL,
	[Language] [varchar](10) NOT NULL,
	[RequestedAt] [datetime] NULL,
	[MailedAt] [datetime] NULL,
	[RespondedAt] [datetime] NULL,
	[WorkingDispo] [varchar](10) NULL,
	[BlockFurtherAttempts] [bit] NOT NULL,
 CONSTRAINT [PK_OutreachRequest] PRIMARY KEY CLUSTERED 
(
	[OutreachRequestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

SET ANSI_PADDING ON

GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[RTPhoenix].[OutreachRequest]') AND name = N'IX_OutreachRequest')
CREATE UNIQUE NONCLUSTERED INDEX [IX_OutreachRequest] ON [RTPhoenix].[OutreachRequest]
(
	[PatientID] ASC,
	[MailingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RTPhoenix].[DF_OutreachRequest_BlockFurtherAttempts]') AND type = 'D')
BEGIN
ALTER TABLE [RTPhoenix].[OutreachRequest] ADD  CONSTRAINT [DF_OutreachRequest_BlockFurtherAttempts]  DEFAULT ((0)) FOR [BlockFurtherAttempts]
END

GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[RTPhoenix].[FK_OutreachRequest_OutreachVendor]') AND parent_object_id = OBJECT_ID(N'[RTPhoenix].[OutreachRequest]'))
ALTER TABLE [RTPhoenix].[OutreachRequest]  WITH CHECK ADD  CONSTRAINT [FK_OutreachRequest_OutreachVendor] FOREIGN KEY([OutreachVendorID])
REFERENCES [RTPhoenix].[OutreachVendor] ([OutreachVendorID])
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[RTPhoenix].[FK_OutreachRequest_OutreachVendor]') AND parent_object_id = OBJECT_ID(N'[RTPhoenix].[OutreachRequest]'))
ALTER TABLE [RTPhoenix].[OutreachRequest] CHECK CONSTRAINT [FK_OutreachRequest_OutreachVendor]
GO

