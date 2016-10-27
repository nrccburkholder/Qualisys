CREATE TABLE [QualisysStudy].[IncludedColumns] (
    [IncludedColumnsID]       INT            IDENTITY (1, 1) NOT NULL,
    [ExtractClientStudyID]    INT            NOT NULL,
    [ColumnName]              NVARCHAR (75)  NOT NULL,
    [ColumnCustomDescription] NVARCHAR (100) NOT NULL,
    [ColumnFormula]           NVARCHAR (MAX) NULL,
    [ColumnSequence]          SMALLINT       NOT NULL,
    [TableAlias]              VARCHAR (4)    NULL,
    [Source]                  NVARCHAR (50)  NULL,
    [CreateDate]              DATETIME       CONSTRAINT [DF_IncludedColumns_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]               NVARCHAR (50)  NOT NULL,
    [InactivatedDate]         DATETIME       NULL,
    [InactivatedBy]           NVARCHAR (50)  NULL,
    CONSTRAINT [PK_IncludedColumns] PRIMARY KEY CLUSTERED ([IncludedColumnsID] ASC)
);

