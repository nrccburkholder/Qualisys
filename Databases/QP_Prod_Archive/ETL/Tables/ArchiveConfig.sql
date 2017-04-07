CREATE TABLE [ETL].[ArchiveConfig] (
    [ArchiveConfigID] INT           IDENTITY (1, 1) NOT NULL,
    [ConfigItem]      VARCHAR (100) NULL,
    [ConfigValue]     VARCHAR (50)  NULL,
    [Active]          BIT           NULL,
    CONSTRAINT [PK_ArchiveConfig] PRIMARY KEY CLUSTERED ([ArchiveConfigID] ASC) WITH (FILLFACTOR = 90)
);

