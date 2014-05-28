CREATE PROCEDURE [dbo].[QSL_SelectDataEntryNavigatorTree]
    @UserName VARCHAR(50)
AS

--Setup environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Create temp tables
CREATE TABLE #Templates (Batch_ID INT, TemplateName VARCHAR(62), Qty INT, QtyKeyed INT, QtyVerified INT)

--Get the Template names and keyed and verified counts
IF (SELECT numParam_Value FROM QualPro_Params WHERE strParam_Nm = 'QSIDataEntryAllowSameUserForVerify') = 0
BEGIN
    --Do not allow the same user to enter and verify
    INSERT INTO #Templates (Batch_ID, TemplateName, Qty, QtyKeyed, QtyVerified)
    SELECT db.Batch_ID, df.TemplateName, COUNT(*), 
           SUM(CASE WHEN df.DateKeyed IS NULL THEN 0 ELSE 1 END), 
           SUM(CASE WHEN df.DateVerified IS NULL THEN 0 ELSE 1 END)
    FROM QSIDataBatch db INNER JOIN QSIDataForm df ON db.Batch_ID = df.Batch_ID
    WHERE db.DateFinalized IS NULL
      AND (df.KeyedBy IS NULL OR df.KeyedBy <> @UserName)
    GROUP BY db.Batch_ID, df.TemplateName
END
ELSE
BEGIN
    --Allow the same user to enter and verify
    INSERT INTO #Templates (Batch_ID, TemplateName, Qty, QtyKeyed, QtyVerified)
    SELECT db.Batch_ID, df.TemplateName, COUNT(*), 
           SUM(CASE WHEN df.DateKeyed IS NULL THEN 0 ELSE 1 END), 
           SUM(CASE WHEN df.DateVerified IS NULL THEN 0 ELSE 1 END)
    FROM QSIDataBatch db INNER JOIN QSIDataForm df ON db.Batch_ID = df.Batch_ID
    WHERE db.DateFinalized IS NULL
    GROUP BY db.Batch_ID, df.TemplateName
END

--Get the resultset
SELECT db.Batch_ID, db.BatchName, tp.TemplateName, tp.Qty, tp.QtyKeyed, tp.QtyVerified, 
       CASE WHEN tp.Qty = tp.QtyKeyed THEN 1 ELSE 0 END AS DataEntryMode, db.Locked
FROM QSIDataBatch db INNER JOIN #Templates tp ON db.Batch_ID = tp.Batch_ID
WHERE db.DateFinalized IS NULL
ORDER BY db.BatchName, tp.TemplateName

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


