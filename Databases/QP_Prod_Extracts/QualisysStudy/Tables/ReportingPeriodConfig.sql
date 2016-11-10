CREATE TABLE [QualisysStudy].[ReportingPeriodConfig] (
    [ReportingPeriodConfigID] INT          IDENTITY (1, 1) NOT NULL,
    [ConfigName]              VARCHAR (50) NULL,
    [Frequency]               VARCHAR (50) NULL,
    [StartDateOffSetDatePart] VARCHAR (50) NULL,
    [StartDateOffSetInc]      INT          NULL,
    [EndDateOffSetDatePart]   VARCHAR (50) NULL,
    [EndDateOffSetInc]        INT          NULL,
    CONSTRAINT [PK_ReportingPeriodConfig] PRIMARY KEY CLUSTERED ([ReportingPeriodConfigID] ASC)
);

