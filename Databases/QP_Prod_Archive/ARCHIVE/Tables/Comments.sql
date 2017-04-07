CREATE TABLE [ARCHIVE].[Comments] (
    [Cmnt_id]            INT          NOT NULL,
    [strCmntText]        TEXT         NULL,
    [datEntered]         DATETIME     NULL,
    [datReported]        DATETIME     NULL,
    [bitSuppressed]      BIT          NULL,
    [CmntType_id]        INT          NULL,
    [CmntValence_id]     INT          NULL,
    [QuestionForm_id]    INT          NULL,
    [SampleUnit_id]      INT          NULL,
    [QstnCore]           INT          NULL,
    [strVSTRBatchNumber] VARCHAR (40) NULL,
    [intVSTRLineNumber]  INT          NULL,
    [strCmntOrHand]      CHAR (1)     NULL,
    [strCmntTextUM]      TEXT         NULL,
    [ArchiveRunID]       INT          NULL,
    CONSTRAINT [PK__comments] PRIMARY KEY CLUSTERED ([Cmnt_id] ASC) WITH (FILLFACTOR = 90)
);

