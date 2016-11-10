CREATE TABLE [QualisysStudy].[ExtractClientStudy] (
    [ExtractClientStudyID]    INT           IDENTITY (1, 1) NOT NULL,
    [Client_ID]               INT           NULL,
    [Study_ID]                INT           NULL,
    [FileType]                VARCHAR (20)  NULL,
    [ClientFileName]          VARCHAR (100) NULL,
    [AuxFileName]             VARCHAR (100) NULL,
    [FolderPath]              VARCHAR (255) NULL,
    [FTPPath]                 VARCHAR (255) NULL,
    [ScheduleID]              INT           NOT NULL,
    [ReportingPeriodConfigID] INT           NOT NULL,
    [DefaultColumns]          BIT           CONSTRAINT [DF_ExtractClientStudy_DefaultColumns] DEFAULT ((1)) NOT NULL,
    [IsActive]                BIT           CONSTRAINT [DF_ExtractClientStudy_IsActive] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_ExtractClientStudy] PRIMARY KEY CLUSTERED ([ExtractClientStudyID] ASC),
    CONSTRAINT [FK_ExtractClientStudy_ReportingPeriodConfig] FOREIGN KEY ([ReportingPeriodConfigID]) REFERENCES [QualisysStudy].[ReportingPeriodConfig] ([ReportingPeriodConfigID]),
    CONSTRAINT [FK_ExtractClientStudy_ScheduleID] FOREIGN KEY ([ScheduleID]) REFERENCES [QualisysStudy].[Schedule] ([ScheduleID])
);

