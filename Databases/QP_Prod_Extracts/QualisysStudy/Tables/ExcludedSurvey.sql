CREATE TABLE [QualisysStudy].[ExcludedSurvey] (
    [ExtractClientStudyID] INT           NOT NULL,
    [Survey_ID]            INT           NOT NULL,
    [CreateDate]           DATETIME      CONSTRAINT [DF_ExcludedSurvey_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            NVARCHAR (50) NOT NULL,
    [InactivatedDate]      DATETIME      NULL,
    [InactivatedBy]        NVARCHAR (50) NULL,
    [IsActive]             BIT           NULL,
    CONSTRAINT [PK_ExcludedSurvey] PRIMARY KEY CLUSTERED ([ExtractClientStudyID] ASC, [Survey_ID] ASC)
);

