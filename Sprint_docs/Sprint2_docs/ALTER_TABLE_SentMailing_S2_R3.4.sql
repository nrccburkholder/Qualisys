USE QP_PROD


-- add QuestionaireType_ID to SentMaILING
ALTER TABLE SentMailing
ADD QuestionnaireType_ID int NULL

-- add QuestionaireType_ID to fg_preMailingWork
ALTER TABLE fg_preMailingWork
ADD QuestionnaireType_ID int NULL

-- add QuestionaireType_ID to fg_preMailingWork_TP
ALTER TABLE fg_preMailingWork_TP
ADD QuestionnaireType_ID int NULL

