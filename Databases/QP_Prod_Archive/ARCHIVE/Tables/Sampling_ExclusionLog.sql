CREATE TABLE [ARCHIVE].[Sampling_ExclusionLog] (
    [SamplingExlusionLog_ID]   INT      NOT NULL,
    [Survey_ID]                INT      NULL,
    [Sampleset_ID]             INT      NULL,
    [Sampleunit_ID]            INT      NULL,
    [Pop_ID]                   INT      NULL,
    [Enc_ID]                   INT      NULL,
    [SamplingExclusionType_ID] INT      NULL,
    [DQ_BusRule_ID]            INT      NULL,
    [DateCreated]              DATETIME NULL,
    [ArchiveRunID]             INT      NULL,
    CONSTRAINT [PK_Sampling_ExclusionLog] PRIMARY KEY CLUSTERED ([SamplingExlusionLog_ID] ASC) WITH (FILLFACTOR = 90)
);

