CREATE TABLE [ARCHIVE].[EligibleEncLog] (
    [sampleset_id]        INT      NOT NULL,
    [sampleunit_id]       INT      NOT NULL,
    [pop_id]              INT      NOT NULL,
    [enc_id]              INT      NULL,
    [SampleEncounterDate] DATETIME NOT NULL,
    [SurveyType_id]       INT      NOT NULL,
    [ArchiveRunID]        INT      NULL
);

