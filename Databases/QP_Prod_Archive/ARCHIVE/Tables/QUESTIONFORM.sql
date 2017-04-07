CREATE TABLE [ARCHIVE].[QUESTIONFORM] (
    [QUESTIONFORM_ID]      INT           NOT NULL,
    [SENTMAIL_ID]          INT           NULL,
    [SAMPLEPOP_ID]         INT           NULL,
    [CUTOFF_ID]            INT           NULL,
    [DATRETURNED]          DATETIME      NULL,
    [SURVEY_ID]            INT           NULL,
    [UnusedReturn_id]      INT           NULL,
    [datUnusedReturn]      DATETIME      NULL,
    [datResultsImported]   DATETIME      NULL,
    [strSTRBatchNumber]    VARCHAR (8)   NULL,
    [intSTRLineNumber]     INT           NULL,
    [intPhoneAttempts]     INT           NULL,
    [bitComplete]          BIT           NULL,
    [ReceiptType_id]       INT           NULL,
    [strScanBatch]         VARCHAR (100) NULL,
    [BubbleCnt]            INT           NULL,
    [QstnCoreCnt]          INT           NULL,
    [bitExported]          BIT           NULL,
    [numCAHPSSupplemental] SMALLINT      NULL,
    [ArchiveRunID]         INT           NULL,
    CONSTRAINT [PK_QUESTIONFORM] PRIMARY KEY CLUSTERED ([QUESTIONFORM_ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_aQuestionForm_SPID]
    ON [ARCHIVE].[QUESTIONFORM]([SAMPLEPOP_ID] ASC)
    INCLUDE([QUESTIONFORM_ID]) WITH (FILLFACTOR = 90);

