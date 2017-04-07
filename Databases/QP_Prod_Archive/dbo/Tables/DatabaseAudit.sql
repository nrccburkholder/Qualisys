CREATE TABLE [dbo].[DatabaseAudit] (
    [AuditDate]    DATETIME      NOT NULL,
    [LoginName]    [sysname]     NOT NULL,
    [EventType]    [sysname]     NOT NULL,
    [SchemaName]   [sysname]     NULL,
    [ObjectName]   [sysname]     NULL,
    [TSQLCommand]  VARCHAR (MAX) NULL,
    [XMLEventData] XML           NOT NULL
) TEXTIMAGE_ON [PRIMARY];


GO
CREATE CLUSTERED INDEX [DatabaseAudit_IX_AuditDate]
    ON [dbo].[DatabaseAudit]([AuditDate] DESC) WITH (FILLFACTOR = 90)
    ON [PRIMARY];

