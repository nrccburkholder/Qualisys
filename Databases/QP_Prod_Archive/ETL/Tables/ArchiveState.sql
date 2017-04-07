CREATE TABLE [ETL].[ArchiveState] (
    [ArchiveStateID] INT           NOT NULL,
    [State]          VARCHAR (50)  NULL,
    [Details]        VARCHAR (200) NULL,
    [Category]       VARCHAR (50)  NULL,
    [AlertTaskID]    INT           NULL,
    CONSTRAINT [PK_ArchiveState] PRIMARY KEY CLUSTERED ([ArchiveStateID] ASC) WITH (FILLFACTOR = 90)
);

