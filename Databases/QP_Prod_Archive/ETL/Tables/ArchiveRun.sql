CREATE TABLE [ETL].[ArchiveRun] (
    [ArchiveRunID]     INT      IDENTITY (1, 1) NOT NULL,
    [StartDateTime]    DATETIME NULL,
    [EndDateTime]      DATETIME NULL,
    [ArchiveStateID]   INT      NULL,
    [ArchiveTaskID]    INT      NULL,
    [TaskCompleteTime] DATETIME NULL,
    [Type]             CHAR (1) CONSTRAINT [DF_ArchiveRun_Type] DEFAULT ('A') NULL,
    CONSTRAINT [PK_ArchiveRun] PRIMARY KEY CLUSTERED ([ArchiveRunID] ASC) WITH (FILLFACTOR = 90)
);

