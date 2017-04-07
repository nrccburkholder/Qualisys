CREATE TABLE [ARCHIVE].[SENTMAILING] (
    [SENTMAIL_ID]          INT          NOT NULL,
    [SCHEDULEDMAILING_ID]  INT          NULL,
    [DATGENERATED]         DATETIME     NULL,
    [DATPRINTED]           DATETIME     NULL,
    [DATMAILED]            DATETIME     NULL,
    [METHODOLOGY_ID]       INT          NULL,
    [PAPERCONFIG_ID]       INT          NULL,
    [STRLITHOCODE]         VARCHAR (10) NULL,
    [STRPOSTALBUNDLE]      VARCHAR (10) NULL,
    [INTPAGES]             INT          NULL,
    [DATUNDELIVERABLE]     DATETIME     NULL,
    [INTRESPONSESHAPE]     INT          NULL,
    [STRGROUPDEST]         VARCHAR (9)  NULL,
    [datDeleted]           DATETIME     NULL,
    [datBundled]           DATETIME     NULL,
    [intReprinted]         INT          NULL,
    [datReprinted]         DATETIME     NULL,
    [LangID]               INT          NULL,
    [datExpire]            DATETIME     NULL,
    [Country_id]           INT          NOT NULL,
    [bitExported]          BIT          NULL,
    [QuestionnaireType_ID] INT          NULL,
    [ArchiveRunID]         INT          NULL,
    CONSTRAINT [PK_SENTMAILING] PRIMARY KEY CLUSTERED ([SENTMAIL_ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ix_SENTMAILING_SCHEDULEDMAILING_ID]
    ON [ARCHIVE].[SENTMAILING]([SCHEDULEDMAILING_ID] ASC) WITH (FILLFACTOR = 90);

