
CREATE TABLE SurveyValidationFields 
(SurveyValidationFields_ID int IDENTITY(1,1) NOT NULL
,SurveyType_Id int
, ColumnName varchar(50)
, TableName varchar(50)
, bitActive bit
)

