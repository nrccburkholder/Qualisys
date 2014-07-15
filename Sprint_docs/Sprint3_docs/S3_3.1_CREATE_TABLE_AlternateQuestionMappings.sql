

CREATE TABLE AlternateQuestionMappings
(AlternateQuestionMapping_ID int IDENTITY(1,1) NOT NULL,
  SurveyType_Id int,
  QstnCore int,
  AltQstnCore int,
  bitActive bit
)

