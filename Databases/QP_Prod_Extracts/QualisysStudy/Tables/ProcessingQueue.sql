CREATE TABLE [QualisysStudy].[ProcessingQueue] (
    [ProcessingQueueID]    INT      IDENTITY (1, 1) NOT NULL,
    [QueueID]              INT      NULL,
    [QueueLogID]           INT      NULL,
    [ExtractClientStudyID] INT      NULL,
    [Study_ID]             INT      NULL,
    [RunTypeID]            INT      NULL,
    [StartDate]            DATE     NULL,
    [EndDate]              DATE     NULL,
    [Processed]            BIT      NULL,
    [CreateDate]           DATETIME NULL,
    [ProcessedDate]        DATETIME NULL,
    CONSTRAINT [PK_ProcessingQueue] PRIMARY KEY CLUSTERED ([ProcessingQueueID] ASC)
);

