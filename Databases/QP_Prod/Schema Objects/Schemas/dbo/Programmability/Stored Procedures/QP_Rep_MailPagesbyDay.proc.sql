CREATE PROCEDURE QP_Rep_MailPagesbyDay @BeginDate DATETIME, @EndDate DATETIME
AS

SET NOCOUNT ON

CREATE TABLE #Display (
	Dummy_id			INT IDENTITY(1,1),
	Descript			VARCHAR(42),
	Value				VARCHAR(42)
)
/*
	MailDate 			VARCHAR(25), 
	Letter 				INT, 
	Legal 				INT, 
	[1 Ledger] 			INT, 
	[2 Ledger] 			INT,
	[3 Ledger] 			INT, 
	[4 or more Ledger] 		INT,
	[Match Letter] 			INT, 
	[Match Legal] 			INT, 
	[Match 1 Ledger] 		INT, 
	[Match 2 Ledger] 		INT, 
	[Match 3 Ledger] 		INT, 
	[Match 4 or more Ledger] 	INT
)
*/

SELECT CASE WHEN PaperConfig_id IN (30,2,40) THEN 'Letter'
		WHEN PaperConfig_id IN (36,32,1,14,35) THEN 'Legal'
		WHEN PaperConfig_id IN (15,4) THEN '1 Ledger'
		WHEN PaperConfig_id IN (31,17,39) THEN '2 Ledger'
		WHEN PaperConfig_id IN (37,18,38) THEN '3 Ledger'
		WHEN PaperConfig_id IN (33,44) THEN '4 or more Ledger'
		ELSE CONVERT(VARCHAR,PaperConfig_id) END PaperConfig_id
		, Match, SUM(cnt) Total
INTO #work
FROM MailPagesbyDay
WHERE datMailed BETWEEN @BeginDate AND @EndDate
GROUP BY CASE WHEN PaperConfig_id IN (30,2,40) THEN 'Letter'
		WHEN PaperConfig_id IN (36,32,1,14,35) THEN 'Legal'
		WHEN PaperConfig_id IN (15,4) THEN '1 Ledger'
		WHEN PaperConfig_id IN (31,17,39) THEN '2 Ledger'
		WHEN PaperConfig_id IN (37,18,38) THEN '3 Ledger'
		WHEN PaperConfig_id IN (33,44) THEN '4 or more Ledger'
		ELSE CONVERT(VARCHAR,PaperConfig_id) END, Match

INSERT INTO #Display (Descript, Value)
SELECT 'MailDate' , CONVERT(VARCHAR(12),@BeginDate,107)+'-'+CONVERT(VARCHAR(12),@EndDate,107)

INSERT INTO #Display
SELECT PaperConfig_id, Total
FROM #work
WHERE PaperConfig_id = 'Letter'
AND Match = 1

INSERT INTO #Display
SELECT PaperConfig_id, Total
FROM #work
WHERE PaperConfig_id = 'Legal'
AND Match = 1

INSERT INTO #Display
SELECT PaperConfig_id, Total
FROM #work
WHERE PaperConfig_id = '1 Ledger'
AND Match = 1

INSERT INTO #Display
SELECT PaperConfig_id, Total
FROM #work
WHERE PaperConfig_id = '2 Ledger'
AND Match = 1

INSERT INTO #Display
SELECT PaperConfig_id, Total
FROM #work
WHERE PaperConfig_id = '3 Ledger'
AND Match = 1

INSERT INTO #Display
SELECT PaperConfig_id, Total
FROM #work
WHERE PaperConfig_id = '4 or more Ledger'
AND Match = 1

INSERT INTO #Display
SELECT 'Match '+PaperConfig_id, Total
FROM #work
WHERE PaperConfig_id = 'Letter'
AND Match = 0

INSERT INTO #Display
SELECT 'Match '+PaperConfig_id, Total
FROM #work
WHERE PaperConfig_id = 'Legal'
AND Match = 0

INSERT INTO #Display
SELECT 'Match '+PaperConfig_id, Total
FROM #work
WHERE PaperConfig_id = '1 Ledger'
AND Match = 0

INSERT INTO #Display
SELECT 'Match '+PaperConfig_id, Total
FROM #work
WHERE PaperConfig_id = '2 Ledger'
AND Match = 0

INSERT INTO #Display
SELECT 'Match '+PaperConfig_id, Total
FROM #work
WHERE PaperConfig_id = '3 Ledger'
AND Match = 0

INSERT INTO #Display
SELECT 'Match '+PaperConfig_id, Total
FROM #work
WHERE PaperConfig_id = '4 or more Ledger'
AND Match = 0

/*
UPDATE t
SET t.Letter = Total
FROM #Display t, #work w
WHERE w.PaperConfig_id = 2
AND Match = 1

UPDATE t
SET t.[Match Letter] = Total
FROM #Display t, #work w
WHERE w.PaperConfig_id = 2
AND Match = 0

UPDATE t
SET t.Legal = Total
FROM #Display t, #work w
WHERE w.PaperConfig_id = 1
AND Match = 1

UPDATE t
SET t.[Match Legal] = Total
FROM #Display t, #work w
WHERE w.PaperConfig_id = 1
AND Match = 0

UPDATE t
SET t.[1 Ledger] = Total
FROM #Display t, #work w
WHERE w.PaperConfig_id = 4
AND Match = 1

UPDATE t
SET t.[Match 1 Ledger] = Total
FROM #Display t, #work w
WHERE w.PaperConfig_id = 4
AND Match = 0

UPDATE t
SET t.[2 Ledger] = Total
FROM #Display t, #work w
WHERE w.PaperConfig_id = 17
AND Match = 1

UPDATE t
SET t.[Match 2 Ledger] = Total
FROM #Display t, #work w
WHERE w.PaperConfig_id = 17
AND Match = 0

UPDATE t
SET t.[3 Ledger] = Total
FROM #Display t, #work w
WHERE w.PaperConfig_id = 18
AND Match = 1

UPDATE t
SET t.[Match 3 Ledger] = Total
FROM #Display t, #work w
WHERE w.PaperConfig_id = 18
AND Match = 0

UPDATE t
SET t.[4 or more Ledger] = Total
FROM #Display t, #work w
WHERE w.PaperConfig_id = 33
AND Match = 1

UPDATE t
SET t.[Match 4 or more Ledger] = Total
FROM #Display t, #work w
WHERE w.PaperConfig_id = 33
AND Match = 0
*/

SELECT * FROM #Display ORDER BY Dummy_id

DROP TABLE #work
DROP TABLE #Display

SET NOCOUNT OFF


