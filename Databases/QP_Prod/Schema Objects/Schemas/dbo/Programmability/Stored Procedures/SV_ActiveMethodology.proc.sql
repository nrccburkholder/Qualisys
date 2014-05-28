CREATE PROCEDURE SV_ActiveMethodology
@Survey_id INT
AS

CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(100))

IF (SELECT COUNT(*) FROM MailingMethodology WHERE Survey_id=@Survey_id AND bitActiveMethodology=1)<>1
INSERT INTO #M (Error, strMessage)
SELECT 1 Error,'There is not an active methodology.'
ELSE
INSERT INTO #M (Error, strMessage)
SELECT 0 Error,'There is ONE active methodology.'

SELECT * FROM #M

DROP TABLE #M


