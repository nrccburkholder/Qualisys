
CREATE TABLE SurveyValidationFields 
(   [SurveyValidationFields_ID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyType_Id] [int] NULL,
	[ColumnName] [varchar](50) NULL,
	[TableName] [varchar](50) NULL,
	[bitActive] [bit] NULL,
	[SubType_ID] [int] NULL
)

