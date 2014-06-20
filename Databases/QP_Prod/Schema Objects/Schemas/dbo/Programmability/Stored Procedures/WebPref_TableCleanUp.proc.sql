﻿CREATE PROCEDURE WebPref_TableCleanUp 
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @DelDate DATETIME

SELECT @DelDate=CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),120))-7

SELECT BarCode, Litho
INTO #CleanUp
FROM WebSurveyQueue q, SentMailing sm
WHERE q.Litho=sm.strLithoCode
AND datMailed<@DelDate

CREATE INDEX tmpIndex ON #CleanUp (BarCode)
CREATE INDEX tmpIndex2 ON #CleanUp (Litho)

DELETE v
FROM WebSurveyValues v, #CleanUp t
WHERE t.BarCode=v.BarCode

DELETE q
FROM WebSurveyQueue q, #CleanUp t
WHERE t.Litho=q.Litho

DROP TABLE #CleanUp

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF

