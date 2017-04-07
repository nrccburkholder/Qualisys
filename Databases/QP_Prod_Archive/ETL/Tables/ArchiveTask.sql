CREATE TABLE [ETL].[ArchiveTask] (
    [ArchiveTaskID] INT           NOT NULL,
    [TaskCode]      VARCHAR (10)  NULL,
    [Task]          VARCHAR (100) NULL,
    [TaskGroup]     VARCHAR (100) NULL,
    [ParentTask]    INT           NULL,
    [TaskSproc]     VARCHAR (100) NULL,
    [Active]        BIT           CONSTRAINT [DF_ArchiveTask_Active] DEFAULT ((1)) NULL,
    [Type]          CHAR (1)      NULL,
    CONSTRAINT [PK_ArchiveTask] PRIMARY KEY CLUSTERED ([ArchiveTaskID] ASC) WITH (FILLFACTOR = 90)
);

