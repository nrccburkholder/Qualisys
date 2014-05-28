CREATE PROCEDURE SP_Extract_SyncQuestionLabel
AS

UPDATE ql
SET ql.strQstnLabel=pq.Short
FROM QuestionLabel ql, ParadoxQuestions pq
WHERE ql.QstnCore=pq.Core
AND ql.strQstnLabel<>pq.Short

DELETE ql
FROM QuestionLabel ql, ParadoxQuestions pq
WHERE ql.QstnCore=pq.Core

INSERT INTO QuestionLabel (QstnCore, strQstnLabel)
SELECT Core, Short
FROM ParadoxQuestions


