USE QP_PROD


-- add QuestionnaireType_ID to SURVEY_DEF
ALTER TABLE SURVEY_DEF
ADD QuestionnaireType_ID int NULL
