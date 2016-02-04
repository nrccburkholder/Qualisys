USE [QMS_Restore]
GO
/****** Object:  Table [dbo].[Audit_MonthlyArchive]    Script Date: 11/15/2007 14:57:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Audit_MonthlyArchive](
	[AuditDeleteID] [int] IDENTITY(1,1) NOT NULL,
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

--===========================================================================================

USE [qms]
GO
/****** Object:  Table [dbo].[SPU_UpdateTypes]    Script Date: 11/14/2007 10:29:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SPU_UpdateTypes](
	[UpdateTypeID] [int] IDENTITY(1,1) NOT NULL,
	[UpdateName] [varchar](200) NULL,
	[intOrder] [int] NULL CONSTRAINT [DF_SPU_UpdateTypes_intOrder]  DEFAULT (0),
 CONSTRAINT [PK_SPU_UpdateTypes] PRIMARY KEY CLUSTERED 
(
	[UpdateTypeID] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

--===========================================================================================

USE [qms]
GO
/****** Object:  Table [dbo].[SPU_UpdateMappings]    Script Date: 11/14/2007 10:28:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SPU_UpdateMappings](
	[UpdateMappingID] [int] IDENTITY(1,1) NOT NULL,
	[UpdateTypeID] [int] NULL,
	[OldEventID] [int] NULL,
	[NewEventID] [int] NULL,
	[intOrder] [int] NULL CONSTRAINT [DF_SPU_UpdateMappings_intOrder]  DEFAULT (0),
	[bitComplete] [smallint] NULL,
 CONSTRAINT [PK_SPU_UpdateMappings] PRIMARY KEY CLUSTERED 
(
	[UpdateMappingID] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[SPU_UpdateMappings]  WITH NOCHECK ADD  CONSTRAINT [FK_SPU_UpdateMappings_SPU_UpdateTypes] FOREIGN KEY([UpdateTypeID])
REFERENCES [dbo].[SPU_UpdateTypes] ([UpdateTypeID])
GO
ALTER TABLE [dbo].[SPU_UpdateMappings] CHECK CONSTRAINT [FK_SPU_UpdateMappings_SPU_UpdateTypes]

--===========================================================================================

USE [QMS]
GO
/****** Object:  Table [dbo].[SPU_FileTrackingLog]    Script Date: 11/28/2007 15:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SPU_FileTrackingLog](
	[FileLogID] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [varchar](500) NULL,
	[DatFileLoaded] [datetime] NULL CONSTRAINT [DF_SPU_FileTrackingLog_DatFileLoaded]  DEFAULT (getdate()),
	[UserID] [int] NULL,
	[UserName] [varchar](50) NULL,
	[NumRecordsInFile] [int] NULL,
	[NumRecordsUpdated] [int] NULL,
	[NumMissingEventCodes] [int] NULL,
	[UpdateTypeID] [int] NULL,
 CONSTRAINT [PK_SPU_FileTrackingLog] PRIMARY KEY CLUSTERED 
(
	[FileLogID] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[SPU_FileTrackingLog]  WITH NOCHECK ADD  CONSTRAINT [FK_SPU_FileTrackingLog_SPU_UpdateTypes] FOREIGN KEY([UpdateTypeID])
REFERENCES [dbo].[SPU_UpdateTypes] ([UpdateTypeID])
GO
ALTER TABLE [dbo].[SPU_FileTrackingLog] CHECK CONSTRAINT [FK_SPU_FileTrackingLog_SPU_UpdateTypes]

--======

--Populate SPU_UpdateTypes table

Insert into SPU_UpdateTypes Select 'None (No Conversion Needed)' as UpdateName, '1' as intOrder
Insert into SPU_UpdateTypes Select 'From Mail to Web' as UpdateName, '2' as intOrder
Insert into SPU_UpdateTypes Select 'From Mail to Inbound Phone' as UpdateName, '3' as intOrder
Insert into SPU_UpdateTypes Select 'From Mail to Outbound Phone' as UpdateName, '4' as intOrder
Insert into SPU_UpdateTypes Select 'From Web to Mail' as UpdateName, '5' as intOrder
Insert into SPU_UpdateTypes Select 'From Web to Inbound Phone' as UpdateName, '6' as intOrder
Insert into SPU_UpdateTypes Select 'From Web to Outbound Phone' as UpdateName, '7' as intOrder
Insert into SPU_UpdateTypes Select 'From Inbound Phone to Web' as UpdateName, '8' as intOrder
Insert into SPU_UpdateTypes Select 'From Inbound Phone to Mail' as UpdateName, '9' as intOrder
Insert into SPU_UpdateTypes Select 'From Inbound Phone to Outbound' as UpdateName, '10' as intOrder
Insert into SPU_UpdateTypes Select 'From Outbound Phone to Web' as UpdateName, '11' as intOrder
Insert into SPU_UpdateTypes Select 'From Outbound Phone to Mail' as UpdateName, '12' as intOrder
Insert into SPU_UpdateTypes Select 'From Outbound Phone to Inbound' as UpdateName, '13' as intOrder


--======
 
--Populate SPU_UpdateMappings table


Insert into SPU_UpdateMappings Select '2' as UpdateTypeID, '3010' as OldEventID, '3036' as NewEventID, '1' as intOrder, '0' as bitComplete
Insert into SPU_UpdateMappings Select '2' as UpdateTypeID, '3012' as OldEventID, '3038' as NewEventID, '2' as intOrder, '1' as bitComplete
Insert into SPU_UpdateMappings Select '3' as UpdateTypeID, '3010' as OldEventID, '3033' as NewEventID, '3' as intOrder, '0' as bitComplete
Insert into SPU_UpdateMappings Select '3' as UpdateTypeID, '3012' as OldEventID, '3035' as NewEventID, '4' as intOrder, '1' as bitComplete
Insert into SPU_UpdateMappings Select '4' as UpdateTypeID, '3010' as OldEventID, '3020' as NewEventID, '5' as intOrder, '0' as bitComplete
Insert into SPU_UpdateMappings Select '4' as UpdateTypeID, '3012' as OldEventID, '3022' as NewEventID, '6' as intOrder, '1' as bitComplete
Insert into SPU_UpdateMappings Select '5' as UpdateTypeID, '3036' as OldEventID, '3010' as NewEventID, '7' as intOrder, '0' as bitComplete
Insert into SPU_UpdateMappings Select '5' as UpdateTypeID, '3038' as OldEventID, '3012' as NewEventID, '8' as intOrder, '1' as bitComplete
Insert into SPU_UpdateMappings Select '6' as UpdateTypeID, '3036' as OldEventID, '3033' as NewEventID, '9' as intOrder, '0' as bitComplete
Insert into SPU_UpdateMappings Select '6' as UpdateTypeID, '3038' as OldEventID, '3035' as NewEventID, '10' as intOrder, '1' as bitComplete
Insert into SPU_UpdateMappings Select '7' as UpdateTypeID, '3036' as OldEventID, '3020' as NewEventID, '11' as intOrder, '0' as bitComplete
Insert into SPU_UpdateMappings Select '7' as UpdateTypeID, '3038' as OldEventID, '3022' as NewEventID, '12' as intOrder, '1' as bitComplete
Insert into SPU_UpdateMappings Select '8' as UpdateTypeID, '3033' as OldEventID, '3036' as NewEventID, '13' as intOrder, '0' as bitComplete
Insert into SPU_UpdateMappings Select '8' as UpdateTypeID, '3035' as OldEventID, '3038' as NewEventID, '14' as intOrder, '1' as bitComplete
Insert into SPU_UpdateMappings Select '9' as UpdateTypeID, '3033' as OldEventID, '3010' as NewEventID, '15' as intOrder, '0' as bitComplete
Insert into SPU_UpdateMappings Select '9' as UpdateTypeID, '3035' as OldEventID, '3012' as NewEventID, '16' as intOrder, '1' as bitComplete
Insert into SPU_UpdateMappings Select '10' as UpdateTypeID, '3033' as OldEventID, '3020' as NewEventID, '17' as intOrder, '0' as bitComplete
Insert into SPU_UpdateMappings Select '10' as UpdateTypeID, '3035' as OldEventID, '3022' as NewEventID, '18' as intOrder, '1' as bitComplete
Insert into SPU_UpdateMappings Select '11' as UpdateTypeID, '3020' as OldEventID, '3036' as NewEventID, '19' as intOrder, '0' as bitComplete
Insert into SPU_UpdateMappings Select '11' as UpdateTypeID, '3022' as OldEventID, '3038' as NewEventID, '20' as intOrder, '1' as bitComplete
Insert into SPU_UpdateMappings Select '12' as UpdateTypeID, '3020' as OldEventID, '3010' as NewEventID, '21' as intOrder, '0' as bitComplete
Insert into SPU_UpdateMappings Select '12' as UpdateTypeID, '3022' as OldEventID, '3012' as NewEventID, '22' as intOrder, '1' as bitComplete
Insert into SPU_UpdateMappings Select '13' as UpdateTypeID, '3020' as OldEventID, '3033' as NewEventID, '23' as intOrder, '0' as bitComplete
Insert into SPU_UpdateMappings Select '13' as UpdateTypeID, '3022' as OldEventID, '3035' as NewEventID, '24' as intOrder, '1' as bitComplete
