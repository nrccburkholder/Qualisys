CREATE TABLE [ARCHIVE].[DispositionLog] (
    [SentMail_id]     INT          NULL,
    [SamplePop_id]    INT          NULL,
    [Disposition_id]  INT          NULL,
    [ReceiptType_id]  INT          NULL,
    [datLogged]       DATETIME     NULL,
    [LoggedBy]        VARCHAR (42) NULL,
    [DaysFromCurrent] INT          NULL,
    [DaysFromFirst]   INT          NULL,
    [bitExtracted]    BIT          CONSTRAINT [DF__DispositionLog__bitExtracted] DEFAULT ((0)) NULL,
    [ArchiveRunID]    INT          NULL
);

