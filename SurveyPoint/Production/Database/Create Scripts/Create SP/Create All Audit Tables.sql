USE [QMS]
GO
/****** Object:  Table [dbo].[Audit_DeleteBatch]    Script Date: 01/10/2008 09:25:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Audit_DeleteBatch](
	[Audit_DeleteBatchID] [int] IDENTITY(1,1) NOT NULL,
	[BatchStartTime] [datetime] NULL,
	[BatchEndTime] [datetime] NULL,
 CONSTRAINT [PK_Audit_DeleteBatch] PRIMARY KEY CLUSTERED 
(
	[Audit_DeleteBatchID] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Audit_MonthlyArchive]    Script Date: 01/10/2008 09:25:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Audit_MonthlyArchive](
	[AuditDeleteID] [int] IDENTITY(1,1) NOT NULL,
	[Audit_DeleteBatchID] [int] NULL,
	[DeleteDate] [datetime] NOT NULL CONSTRAINT [DF_Audit_MonthlyArchive_DeleteDate]  DEFAULT (getdate()),
	[TableName] [varchar](200) NULL,
	[RowsDeleted] [int] NULL,
	[RespondentIDMonthsPast] [int] NULL,
	[NonRespondentEventLogPast] [int] NULL,
 CONSTRAINT [PK_Audit_MonthlyArchive] PRIMARY KEY CLUSTERED 
(
	[AuditDeleteID] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Audit_QueryTime]    Script Date: 01/10/2008 09:25:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Audit_QueryTime](
	[AuditQueryTimeID] [int] IDENTITY(1,1) NOT NULL,
	[Audit_DeleteBatchID] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[DateDiffInSeconds] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Audit_SpaceUsed]    Script Date: 01/10/2008 09:25:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Audit_SpaceUsed](
	[AuditSpaceUsedID] [int] IDENTITY(1,1) NOT NULL,
	[Audit_DeleteBatchID] [int] NULL,
	[AuditCaptureDate] [datetime] NULL CONSTRAINT [DF_Audit_SpaceUsed_AuditCaptureDate]  DEFAULT (getdate()),
	[BeforeAfter] [int] NULL,
	[DatabaseName] [varchar](100) NULL,
	[DatabaseSize] [decimal](15, 2) NULL,
	[LogSize] [decimal](15, 2) NULL,
	[UnAllocatedSpace] [decimal](15, 2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Audit_MonthlyArchive]  WITH CHECK ADD  CONSTRAINT [FK_Audit_MonthlyArchive_Audit_DeleteBatch] FOREIGN KEY([Audit_DeleteBatchID])
REFERENCES [dbo].[Audit_DeleteBatch] ([Audit_DeleteBatchID])
GO
ALTER TABLE [dbo].[Audit_MonthlyArchive] CHECK CONSTRAINT [FK_Audit_MonthlyArchive_Audit_DeleteBatch]
GO
ALTER TABLE [dbo].[Audit_QueryTime]  WITH CHECK ADD  CONSTRAINT [FK_Audit_QueryTime_Audit_DeleteBatch] FOREIGN KEY([Audit_DeleteBatchID])
REFERENCES [dbo].[Audit_DeleteBatch] ([Audit_DeleteBatchID])
GO
ALTER TABLE [dbo].[Audit_QueryTime] CHECK CONSTRAINT [FK_Audit_QueryTime_Audit_DeleteBatch]
GO
ALTER TABLE [dbo].[Audit_SpaceUsed]  WITH CHECK ADD  CONSTRAINT [FK_Audit_SpaceUsed_Audit_DeleteBatch] FOREIGN KEY([Audit_DeleteBatchID])
REFERENCES [dbo].[Audit_DeleteBatch] ([Audit_DeleteBatchID])
GO
ALTER TABLE [dbo].[Audit_SpaceUsed] CHECK CONSTRAINT [FK_Audit_SpaceUsed_Audit_DeleteBatch]