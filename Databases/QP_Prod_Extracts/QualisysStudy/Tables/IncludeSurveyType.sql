CREATE TABLE [QualisysStudy].[IncludeSurveyType] (
    [IncludeSurveyTypeID] INT           NOT NULL,
    [SurveyTypeID]        INT           NOT NULL,
    [CreateDate]          DATETIME      NOT NULL,
    [CreatedBy]           NVARCHAR (50) NOT NULL,
    [InactivatedDate]     DATETIME      NULL,
    [InactivatedBy]       NVARCHAR (50) NULL
);

