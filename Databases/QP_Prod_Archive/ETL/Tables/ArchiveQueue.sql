CREATE TABLE [ETL].[ArchiveQueue] (
    [ArchiveQueueID] INT      IDENTITY (1, 1) NOT NULL,
    [ArchiveRunID]   INT      NULL,
    [CreateDate]     DATETIME NULL,
    [PKey1]          INT      NULL,
    [EntityTypeID]   INT      NULL,
    [Processed]      BIT      CONSTRAINT [DF_ArchiveQueue_Processed] DEFAULT ((0)) NULL,
    [ProcessedDate]  DATETIME NULL,
    CONSTRAINT [PK_ArchiveQueue] PRIMARY KEY CLUSTERED ([ArchiveQueueID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_ArchiveQueue_ArchiveRunID]
    ON [ETL].[ArchiveQueue]([ArchiveRunID] ASC, [EntityTypeID] ASC)
    INCLUDE([PKey1]) WITH (FILLFACTOR = 90);

