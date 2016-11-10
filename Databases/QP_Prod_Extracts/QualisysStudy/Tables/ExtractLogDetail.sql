CREATE TABLE [QualisysStudy].[ExtractLogDetail] (
    [ExtractLogDetailID]   INT           IDENTITY (1, 1) NOT NULL,
    [ExtractLogID]         INT           NULL,
    [ExtractClientStudyID] INT           NOT NULL,
    [Study_ID]             NVARCHAR (50) NOT NULL,
    [StudyName]            NVARCHAR (50) NOT NULL,
    [ExtractRowCount]      INT           NOT NULL,
    [MinReturnDate]        DATE          NOT NULL,
    [MaxReturnDate]        DATE          NOT NULL,
    [CreateDate]           DATETIME      CONSTRAINT [DF_ExtractLogDetail_CreateDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_ExtractLogDetail] PRIMARY KEY CLUSTERED ([ExtractLogDetailID] ASC)
);

