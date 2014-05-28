CREATE PROCEDURE QP_REP_UnusedTemplates_Title @BeginDate DATETIME
AS

CREATE TABLE #Display (Label VARCHAR(200))

INSERT INTO #Display
SELECT 'Analysis of surveys with returns since ' + CONVERT(VARCHAR(11),@BeginDate,0)

SELECT * FROM #Display

DROP TABLE #Display


