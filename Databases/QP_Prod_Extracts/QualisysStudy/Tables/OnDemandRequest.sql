CREATE TABLE [QualisysStudy].[OnDemandRequest] (
    [OnDemandRequestID]       INT  IDENTITY (1, 1) NOT NULL,
    [ExtractClientStudyID]    INT  NOT NULL,
    [Study_ID]                INT  NULL,
    [ScheduleID]              INT  NULL,
    [ReportingPeriodConfigID] INT  NULL,
    [CustomStartDate]         DATE NULL,
    [CustomEndDate]           DATE NULL,
    [Processed]               BIT  CONSTRAINT [DF_OnDemandRequest_Processed] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_OnDemandRun] PRIMARY KEY CLUSTERED ([OnDemandRequestID] ASC)
);

