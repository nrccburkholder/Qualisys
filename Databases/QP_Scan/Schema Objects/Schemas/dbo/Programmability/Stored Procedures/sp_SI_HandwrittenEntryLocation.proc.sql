CREATE PROCEDURE dbo.sp_SI_HandwrittenEntryLocation
    @Survey_id       int,
    @QuestionForm_id int

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare the required variables
DECLARE @intOCRType    int
DECLARE @intOCRPreProc int

--Get the OCR Settings from QualPro_Params
SELECT @intOCRType = Convert(int, strParam_Value)
FROM QP_Prod.dbo.QualPro_Params (NOLOCK)
WHERE strParam_Grp = 'Scanner'
  AND strParam_Nm = 'ScanExportOCRType'

SELECT @intOCRPreProc = Convert(int, strParam_Value)
FROM QP_Prod.dbo.QualPro_Params (NOLOCK)
WHERE strParam_Grp = 'Scanner'
  AND strParam_Nm = 'ScanExportOCRPreProc'

--Get the handwritten entry location information for this questionform_id
SELECT hp.QstnCore, hp.Item, hp.Line_id, hp.intPage_Num, hp.SampleUnit_id, 
       hp.X_Pos AS X1, hp.Y_Pos - 27 AS Y1, hp.X_Pos + hp.intWidth AS X2, hp.Y_Pos AS Y2, 
       mf.strFieldDataType, mf.intFieldLength, @intOCRType AS intOCRType, @intOCRPreProc AS intOCRPreProc
FROM HandWrittenField hf (NOLOCK), HandWrittenPos hp (NOLOCK), QP_Prod.dbo.MetaField mf (NOLOCK)
WHERE hf.QstnCore = hp.QstnCore
  AND hf.Item = hp.Item
  AND hf.SampleUnit_id = hp.SampleUnit_id
  AND hf.Line_id = hp.Line_id
  AND hf.Field_id = mf.Field_id
  AND hf.Survey_id = @Survey_id
  AND hp.QuestionForm_id = @QuestionForm_id
ORDER BY hp.intPage_Num, hp.QstnCore, hp.Item, hp.SampleUnit_id, hp.Line_id

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


