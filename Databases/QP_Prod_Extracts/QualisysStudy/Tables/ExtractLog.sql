CREATE TABLE [QualisysStudy].[ExtractLog] (
    [ExtractLogID]         INT           IDENTITY (1, 1) NOT NULL,
    [ProcessingQueueID]    INT           NOT NULL,
    [ExtractClientStudyID] INT           NOT NULL,
    [Study_ID]             INT           NOT NULL,
    [RunTypeID]            INT           NULL,
    [SamplePopCount]       INT           NULL,
    [ResponseDataCount]    INT           NULL,
    [StartDate]            DATE          NULL,
    [EndDate]              DATE          NULL,
    [ProcessingStartDT]    DATETIME      CONSTRAINT [DF_ExtractLog_ProcessingStartDT] DEFAULT (getdate()) NOT NULL,
    [ProcessingEndDT]      DATETIME      NULL,
    [Success]              BIT           CONSTRAINT [DF_ExtractLog_Success] DEFAULT ((0)) NOT NULL,
    [ErrorMsg]             VARCHAR (200) NULL,
    CONSTRAINT [PK_ExtractLog] PRIMARY KEY CLUSTERED ([ExtractLogID] ASC)
);

