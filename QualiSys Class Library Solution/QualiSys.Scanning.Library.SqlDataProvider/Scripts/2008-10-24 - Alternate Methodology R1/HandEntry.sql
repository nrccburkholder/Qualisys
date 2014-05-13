---------------------------------------------------------------------------------------
--QSL_SelectHandEntry
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectHandEntry]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectHandEntry]
GO
CREATE PROCEDURE [dbo].[QSL_SelectHandEntry]
@DL_HandEntry_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DL_HandEntry_ID, DL_LithoCode_ID, DL_Error_ID, QstnCore, ItemNumber, LineNumber, HandEntryText
FROM [dbo].DL_HandEntry
WHERE DL_HandEntry_ID = @DL_HandEntry_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectAllHandEntries
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectAllHandEntries]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectAllHandEntries]
GO
---------------------------------------------------------------------------------------
--QSL_SelectHandEntriesByLithoCode_ID
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectHandEntriesByLithoCodeId]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectHandEntriesByLithoCodeId]
GO
CREATE PROCEDURE [dbo].[QSL_SelectHandEntriesByLithoCodeId]
@DL_LithoCode_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DL_HandEntry_ID, DL_LithoCode_ID, DL_Error_ID, QstnCore, ItemNumber, LineNumber, HandEntryText
FROM DL_HandEntry
WHERE DL_LithoCode_ID = @DL_LithoCode_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectHandEntryItemNumberFromResponseValue
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectHandEntryItemNumberFromResponseValue]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectHandEntryItemNumberFromResponseValue]
GO
CREATE PROCEDURE [dbo].[QSL_SelectHandEntryItemNumberFromResponseValue]
@strLithoCode VARCHAR(10),
@QstnCore INT,
@ResponseValue INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT sc.Item
FROM SamplePop sp, QuestionForm qf, SentMailing sm, DL_Sel_Qstns_BySampleSet sq, 
     DL_Sel_Scls_BySampleSet sc
WHERE sp.SamplePop_id = qf.SamplePop_id
  AND qf.SentMail_id = sm.SentMail_id
  AND sp.SampleSet_id = sq.SampleSet_id
  AND qf.Survey_id = sq.Survey_id
  AND sm.LangID = sq.Language
  AND sq.SampleSet_id = sc.SampleSet_id
  AND sq.Survey_id = sc.Survey_id
  AND sq.Language = sc.Language
  AND sq.ScaleID = sc.QPC_ID
  AND sm.strLithoCode = @strLithoCode
  AND sq.QstnCore = @QstnCore
  AND sc.Val = @ResponseValue

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
---------------------------------------------------------------------------------------
--QSL_SelectHandEntriesByError_ID
--Not used.  Drop if exists
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_SelectHandEntriesByErrorId]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_SelectHandEntriesByErrorId]
GO
---------------------------------------------------------------------------------------
--QSL_InsertHandEntry
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_InsertHandEntry]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_InsertHandEntry]
GO
CREATE PROCEDURE [dbo].[QSL_InsertHandEntry]
@DL_LithoCode_ID INT,
@DL_Error_ID INT,
@QstnCore INT,
@ItemNumber INT,
@LineNumber INT,
@HandEntryText VARCHAR(100)
AS

SET NOCOUNT ON

INSERT INTO [dbo].DL_HandEntry (DL_LithoCode_ID, DL_Error_ID, QstnCore, ItemNumber, LineNumber, HandEntryText)
VALUES (@DL_LithoCode_ID, @DL_Error_ID, @QstnCore, @ItemNumber, @LineNumber, @HandEntryText)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_UpdateHandEntry
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_UpdateHandEntry]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_UpdateHandEntry]
GO
CREATE PROCEDURE [dbo].[QSL_UpdateHandEntry]
@DL_HandEntry_ID INT,
@DL_LithoCode_ID INT,
@DL_Error_ID INT,
@QstnCore INT,
@ItemNumber INT,
@LineNumber INT,
@HandEntryText VARCHAR(100)
AS

SET NOCOUNT ON

UPDATE [dbo].DL_HandEntry SET
    DL_LithoCode_ID = @DL_LithoCode_ID,
    DL_Error_ID = @DL_Error_ID,
    QstnCore = @QstnCore,
    ItemNumber = @ItemNumber,
    LineNumber = @LineNumber,
    HandEntryText = @HandEntryText
WHERE DL_HandEntry_ID = @DL_HandEntry_ID

SET NOCOUNT OFF
GO
---------------------------------------------------------------------------------------
--QSL_DeleteHandEntry
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QSL_DeleteHandEntry]') IS NOT NULL 
    DROP PROCEDURE [dbo].[QSL_DeleteHandEntry]
GO
CREATE PROCEDURE [dbo].[QSL_DeleteHandEntry]
@DL_HandEntry_ID INT
AS

SET NOCOUNT ON

DELETE [dbo].DL_HandEntry
WHERE DL_HandEntry_ID = @DL_HandEntry_ID

SET NOCOUNT OFF
GO

