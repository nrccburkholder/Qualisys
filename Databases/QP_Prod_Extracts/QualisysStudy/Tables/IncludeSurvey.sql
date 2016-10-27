CREATE TABLE [QualisysStudy].[IncludeSurvey] (
    [IncludeSurveyID]      INT           IDENTITY (1, 1) NOT NULL,
    [ExtractClientStudyID] INT           NOT NULL,
    [Survey_ID]            INT           NOT NULL,
    [SurveyAlias]          NVARCHAR (50) NOT NULL,
    [Division]             NVARCHAR (50) NOT NULL,
    [Study_ID]             INT           NOT NULL,
    [StudyName]            NVARCHAR (50) NOT NULL,
    [CreateDate]           DATETIME      CONSTRAINT [DF_IncludeSurvey_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            NVARCHAR (50) NOT NULL,
    [InactivatedDate]      DATETIME      NULL,
    [InactivatedBy]        NVARCHAR (50) NULL,
    CONSTRAINT [PK_IncludeSurvey] PRIMARY KEY CLUSTERED ([IncludeSurveyID] ASC),
    CONSTRAINT [FK_IncludeSurvey_ExtractClientStudy] FOREIGN KEY ([ExtractClientStudyID]) REFERENCES [QualisysStudy].[ExtractClientStudy] ([ExtractClientStudyID])
);

