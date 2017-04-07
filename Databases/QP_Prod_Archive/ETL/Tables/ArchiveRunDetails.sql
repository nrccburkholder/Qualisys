CREATE TABLE [ETL].[ArchiveRunDetails] (
    [ArchiveRunDetailsID] INT           IDENTITY (1, 1) NOT NULL,
    [ArchiveRunID]        INT           NULL,
    [ArchiveTaskID]       VARCHAR (100) NULL,
    [StartDateTime]       DATETIME      NULL,
    [EndDateTime]         DATETIME      NULL,
    [TaskCount]           INT           NULL,
    CONSTRAINT [PK_ArchiveRunDetails] PRIMARY KEY CLUSTERED ([ArchiveRunDetailsID] ASC) WITH (FILLFACTOR = 90)
);

