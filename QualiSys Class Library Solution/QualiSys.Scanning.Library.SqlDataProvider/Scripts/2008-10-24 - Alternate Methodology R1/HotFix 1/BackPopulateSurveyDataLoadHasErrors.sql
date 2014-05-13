CREATE TABLE #Results (SurveyDataLoad_ID INT, MaxErrorID INT)

INSERT INTO #Results (SurveyDataLoad_ID, MaxErrorID)
SELECT SurveyDataLoad_ID, MAX(ISNULL(DL_Error_ID, 0))
FROM DL_LithoCodes
GROUP BY SurveyDataLoad_ID
HAVING MAX(ISNULL(DL_Error_ID, 0)) > 0

INSERT INTO #Results (SurveyDataLoad_ID, MaxErrorID)
SELECT lc.SurveyDataLoad_ID, MAX(ISNULL(qr.DL_Error_ID, 0)) 
FROM DL_LithoCodes lc, DL_QuestionResults qr
WHERE lc.DL_LithoCode_ID = qr.DL_LithoCode_ID
GROUP BY lc.SurveyDataLoad_ID
HAVING MAX(ISNULL(qr.DL_Error_ID, 0)) > 0
ORDER BY lc.SurveyDataLoad_ID

INSERT INTO #Results (SurveyDataLoad_ID, MaxErrorID)
SELECT lc.SurveyDataLoad_ID, MAX(ISNULL(cm.DL_Error_ID, 0)) 
FROM DL_LithoCodes lc, DL_Comments cm
WHERE lc.DL_LithoCode_ID = cm.DL_LithoCode_ID
GROUP BY lc.SurveyDataLoad_ID
HAVING MAX(ISNULL(cm.DL_Error_ID, 0)) > 0
ORDER BY lc.SurveyDataLoad_ID

INSERT INTO #Results (SurveyDataLoad_ID, MaxErrorID)
SELECT lc.SurveyDataLoad_ID, MAX(ISNULL(he.DL_Error_ID, 0)) 
FROM DL_LithoCodes lc, DL_HandEntry he
WHERE lc.DL_LithoCode_ID = he.DL_LithoCode_ID
GROUP BY lc.SurveyDataLoad_ID
HAVING MAX(ISNULL(he.DL_Error_ID, 0)) > 0
ORDER BY lc.SurveyDataLoad_ID

INSERT INTO #Results (SurveyDataLoad_ID, MaxErrorID)
SELECT lc.SurveyDataLoad_ID, MAX(ISNULL(dp.DL_Error_ID, 0)) 
FROM DL_LithoCodes lc, DL_Dispositions dp
WHERE lc.DL_LithoCode_ID = dp.DL_LithoCode_ID
GROUP BY lc.SurveyDataLoad_ID
HAVING MAX(ISNULL(dp.DL_Error_ID, 0)) > 0
ORDER BY lc.SurveyDataLoad_ID

CREATE TABLE #SDLErrors (SurveyDataLoad_ID INT)

INSERT INTO #SDLErrors (SurveyDataLOad_ID)
SELECT DISTINCT SurveyDataLoad_ID
FROM #Results

--Do the Update
UPDATE sd
SET sd.bitHasErrors = 1
FROM DL_SurveyDataLoad sd, #SDLErrors se
WHERE sd.SurveyDataLoad_ID = se.SurveyDataLoad_ID
