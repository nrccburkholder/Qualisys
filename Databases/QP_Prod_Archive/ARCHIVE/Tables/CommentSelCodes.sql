CREATE TABLE [ARCHIVE].[CommentSelCodes] (
    [Cmnt_id]      INT NOT NULL,
    [CmntCode_id]  INT NOT NULL,
    [ArchiveRunID] INT NULL,
    CONSTRAINT [PK_CommentSelCodes] PRIMARY KEY NONCLUSTERED ([Cmnt_id] ASC, [CmntCode_id] ASC) WITH (FILLFACTOR = 90)
);

