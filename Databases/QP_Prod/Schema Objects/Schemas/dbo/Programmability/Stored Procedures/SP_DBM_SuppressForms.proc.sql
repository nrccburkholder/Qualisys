CREATE PROCEDURE SP_DBM_SuppressForms 
AS

DECLARE @SuppressDate DATETIME

SET @SuppressDate = GETDATE()

CREATE TABLE #qfs (QuestionForm_id INT)

UPDATE s
SET s.datReturned = qf.datReturned, s.datResultsImported = qf.datResultsImported
FROM SuppressForms s, QuestionForm qf
WHERE s.QuestionForm_id = qf.QuestionForm_id

WHILE (SELECT COUNT(*) FROM SuppressForms WHERE datReturned IS NULL AND datResultsImported IS NULL) > 0
BEGIN

TRUNCATE TABLE #qfs

INSERT INTO #qfs
SELECT TOP 100 QuestionForm_id
FROM SuppressForms
WHERE datReturned IS NULL 
AND datResultsImported IS NULL

BEGIN TRAN

DELETE b
FROM qp_scan.dbo.bubbleloc b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

DELETE b
FROM qp_scan.dbo.commentloc b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

DELETE b
FROM qp_scan.dbo.bubblepos b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

DELETE b
FROM qp_scan.dbo.pclquestionform b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

DELETE b
FROM qp_scan.dbo.pclresults b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

DELETE b
FROM qp_scan.dbo.bubbleitempos b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

DELETE b
FROM qp_scan.dbo.commentpos b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

DELETE b
FROM qp_scan.dbo.commentlinepos b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

INSERT INTO SuppressedForms
SELECT t.QuestionForm_id, Survey_id, SamplePop_id, datReturned, datResultsImported, @suppressdate
FROM SuppressForms s, #qfs t
WHERE t.QuestionForm_id = s.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

DELETE s
FROM SuppressForms s, #qfs t
WHERE t.QuestionForm_id = s.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

COMMIT TRAN

END


WHILE (SELECT COUNT(*) FROM SuppressForms WHERE datReturned IS NOT NULL AND datResultsImported IS NOT NULL) > 0
BEGIN

TRUNCATE TABLE #qfs

INSERT INTO #qfs
SELECT TOP 100 QuestionForm_id
FROM suppressforms
WHERE datReturned IS NOT NULL 
AND datResultsImported IS NOT NULL

BEGIN TRAN

DELETE b
FROM qp_scan.dbo.bubbleloc b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

DELETE b
FROM qp_scan.dbo.commentloc b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

DELETE b
FROM qp_scan.dbo.bubblepos b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END


DELETE b
FROM qp_scan.dbo.pclquestionform b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END


DELETE b
FROM qp_scan.dbo.pclresults b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END


DELETE b
FROM qp_scan.dbo.bubbleitempos b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END


DELETE b
FROM qp_scan.dbo.commentpos b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END


DELETE b
FROM qp_scan.dbo.commentlinepos b, #qfs t
WHERE t.QuestionForm_id = b.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

INSERT INTO SuppressedForms
SELECT t.QuestionForm_id, Survey_id, SamplePop_id, datReturned, datResultsImported, @SuppressDate
FROM SuppressForms s, #qfs t
WHERE t.QuestionForm_id = s.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

DELETE s
FROM SuppressForms s, #qfs t
WHERE t.QuestionForm_id = s.QuestionForm_id

IF @@ERROR <> 0
BEGIN
	ROLLBACK TRAN
	RETURN
END

COMMIT TRAN

END


