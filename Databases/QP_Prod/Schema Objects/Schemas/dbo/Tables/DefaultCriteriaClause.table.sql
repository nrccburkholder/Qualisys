CREATE TABLE [dbo].[DefaultCriteriaClause](
	[DefaultCriteriaClause_id] INT NOT NULL IDENTITY(1,1),
	[DefaultCriteriaStmt_id] INT NULL,
	[CriteriaPhrase_id] INT NULL,
	[strTable_nm] VARCHAR(20) NULL,
	[Field_id] INT NULL,
	[intOperator] INT NULL,
	[strLowValue] VARCHAR(42) NULL,
	[strHighValue] VARCHAR(42) NULL
) ON [PRIMARY]