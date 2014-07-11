USE QP_PROD

-- add QuestionaireType_ID to SURVEY_DEF
ALTER TABLE SURVEY_DEF
ADD QuestionnaireType_ID int NULL
