CREATE TABLE [ARCHIVE].[SELECTEDSAMPLE] (
    [SELECTEDSAMPLE_ID]   INT      NOT NULL,
    [SAMPLESET_ID]        INT      NOT NULL,
    [STUDY_ID]            INT      NULL,
    [POP_ID]              INT      NOT NULL,
    [SAMPLEUNIT_ID]       INT      NOT NULL,
    [STRUNITSELECTTYPE]   CHAR (1) NOT NULL,
    [intExtracted_flg]    INT      NULL,
    [enc_id]              INT      NULL,
    [ReportDate]          DATETIME NULL,
    [SampleEncounterDate] DATETIME NULL,
    [ArchiveRunID]        INT      NULL,
    CONSTRAINT [PK_SELECTEDSAMPLE] PRIMARY KEY CLUSTERED ([SELECTEDSAMPLE_ID] ASC) WITH (FILLFACTOR = 90)
);

