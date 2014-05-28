CREATE PROCEDURE dbo.sp_SI_HandwrittenEntryInfo
    @strLithoCode varchar(20), 
    @QstnCore     int, 
    @BubbleID     int,
    @LineID       int, 
    @SampleUnitID int

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Get the handwritten entry location information for this questionform_id
DECLARE @tbl TABLE (
	SentMail_id 		INT, 
	Questionform_id 	INT, 
	UnusedReturn_id 	INT,
	Study_id			INT,
	Pop_id				INT,
	SamplePop_id		INT,
	Survey_id			INT,
	strField_nm			VARCHAR(42),
	Country_id			INT
)

--Get the info from qp_prod
INSERT INTO @tbl
SELECT sm.SentMail_id, qf.QuestionForm_id, qf.UnusedReturn_id, sd.Study_id, 
       sp.Pop_id, sp.SamplePop_id, qf.Survey_id, NULL, sm.Country_id
FROM QP_Prod.dbo.SentMailing sm(NOLOCK), QP_Prod.dbo.QuestionForm qf(NOLOCK), 
     QP_Prod.dbo.Survey_Def sd(NOLOCK), QP_Prod.dbo.SamplePop sp(NOLOCK)
WHERE sm.strLithocode=@strLithocode
  AND sm.SentMail_id = qf.SentMail_id
  AND qf.Survey_id = sd.Survey_id
  AND qf.SamplePop_id = sp.SamplePop_id

DECLARE @FieldName VARCHAR(42), @Survey INT

SELECT TOP 1 @Survey=Survey_id FROM @tbl

--Get the fieldname
SELECT @FieldName=strField_nm
 FROM QP_Prod.dbo.MetaField mf(NOLOCK), HandWrittenField hf(NOLOCK)
  WHERE hf.Survey_id=@Survey
  AND hf.Field_id = mf.Field_id
  AND hf.QstnCore = @QstnCore
  AND hf.Item = @BubbleID
  AND hf.Line_id = @LineID
  AND hf.SampleUnit_id = @SampleUnitID

UPDATE @tbl SET strField_nm=@FieldName

SELECT SentMail_id, Questionform_id, UnusedReturn_id,Study_id,Pop_id,SamplePop_id,strField_nm, Country_id
FROM @tbl
	
--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


