CREATE TABLE [dbo].[DefaultCriteriaStmt](
	[DefaultCriteriaStmt_id] INT NOT NULL IDENTITY(1,1),
	[strCriteriaStmt_nm] CHAR(8) NULL,
	[strCriteriaString] VARCHAR(7000) NULL,
	[BusRule_cd] CHAR(1) NULL
) ON [PRIMARY] 