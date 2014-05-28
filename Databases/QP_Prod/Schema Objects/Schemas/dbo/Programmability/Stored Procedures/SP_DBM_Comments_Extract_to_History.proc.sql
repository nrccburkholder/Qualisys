--Created 10/25/2 BD Move the extracted records to historical tables.
CREATE PROCEDURE SP_DBM_Comments_Extract_to_History
AS

BEGIN TRANSACTION

SELECT cmntextract_id
INTO #c
FROM comments_extract
WHERE datextracted_dt is not null

IF @@ERROR <> 0
BEGIN
   ROLLBACK TRANSACTION
   RETURN
END

INSERT INTO comments_extract_history
SELECT ce.*
FROM comments_extract ce, #c c
WHERE c.cmntextract_id = ce.cmntextract_id

IF @@ERROR <> 0
BEGIN
   ROLLBACK TRANSACTION
   RETURN
END

DELETE ce
FROM comments_extract ce, #c c
WHERE c.cmntextract_id = ce.cmntextract_id

IF @@ERROR <> 0
BEGIN
   ROLLBACK TRANSACTION
   RETURN
END

DROP TABLE #c

IF @@ERROR <> 0
BEGIN
   ROLLBACK TRANSACTION
   RETURN
END

SELECT qfextract_id
INTO #q
FROM QuestionForm_Extract
WHERE datextracted_dt is not null

IF @@ERROR <> 0
BEGIN
   ROLLBACK TRANSACTION
   RETURN
END

INSERT INTO QuestionForm_Extract_history
SELECT qe.*
FROM QuestionForm_Extract qe, #q q
WHERE q.qfextract_id = qe.qfextract_id

IF @@ERROR <> 0
BEGIN
   ROLLBACK TRANSACTION
   RETURN
END

DELETE qe
FROM QuestionForm_Extract qe, #q q
WHERE q.qfextract_id = qe.qfextract_id

IF @@ERROR <> 0
BEGIN
   ROLLBACK TRANSACTION
   RETURN
END

DROP TABLE #q

IF @@ERROR <> 0
BEGIN
   ROLLBACK TRANSACTION
   RETURN
END

COMMIT TRANSACTION


