CREATE PROCEDURE [dbo].[sp_SI_CommentInfo] 
    @LithoCode   varchar(10),
    @QstnCore    int,
    @CmntOrHand  varchar(1)

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Create the temp table
CREATE TABLE #CmntData (SentMail_id int, QuestionForm_id int, UnusedReturn_id int, SampleUnit_id int, SamplePop_id int, Found bit, Country_id INT)

--Get the data
IF @CmntOrHand = 'C'
BEGIN
    --This is a normal comment
    INSERT INTO #CmntData (SentMail_id, QuestionForm_id, UnusedReturn_id, SampleUnit_id, SamplePop_id, Found, Country_id)
    SELECT IsNull(SM.SentMail_id, -1), IsNull(QF.QuestionForm_id, -1), IsNull(QF.UnusedReturn_id, 0), 
           IsNull(CP.SampleUnit_id, -1), IsNull(QF.SamplePop_id, -1), 1 , sm.Country_id
    FROM (SentMailing SM LEFT JOIN QuestionForm QF 
                                ON SM.SentMail_id = QF.SentMail_id) 
                         LEFT JOIN QP_Scan.dbo.CommentPos CP
                                ON QF.QuestionForm_id = CP.QuestionForm_id
    WHERE SM.strLithoCode = @LithoCode
      AND CP.CmntBox_id = @QstnCore
END
ELSE
BEGIN
    --This is an attached comment
    INSERT INTO #CmntData (SentMail_id, QuestionForm_id, UnusedReturn_id, SampleUnit_id, SamplePop_id, Found, Country_id)
    SELECT IsNull(SM.SentMail_id, -1), IsNull(QF.QuestionForm_id, -1), IsNull(QF.UnusedReturn_id, 0), 
           IsNull(SU.SampleUnit_id, -1), IsNull(QF.SamplePop_id, -1), 1, sm.Country_id 
    FROM ((SentMailing SM LEFT JOIN QuestionForm QF 
                                 ON SM.SentMail_id = QF.SentMail_id) 
                          LEFT JOIN SamplePlan SP 
                                 ON QF.Survey_id = SP.Survey_id) 
                          LEFT JOIN SampleUnit SU 
                                 ON SP.SamplePlan_id = SU.SamplePlan_id 
    WHERE SU.ParentSampleUnit_id IS NULL 
      AND SM.strLithoCode = @LithoCode
END

--If we do not have a record check the QDE Tables
IF (SELECT Count(*) FROM #CmntData) = 0
BEGIN
    --No records exist so try to find it in QDE
    /*
    INSERT INTO #CmntData (SentMail_id, QuestionForm_id, UnusedReturn_id, SampleUnit_id, Found, Country_id)
    SELECT IsNull(Q1.SentMail_id, -1), IsNull(Q1.QuestionForm_id, -1), IsNull(QF.UnusedReturn_id, 0), 
           IsNull(Q2.SampleUnit_id, -1), 1, sm.Country_id 
    FROM (QDEForm Q1 LEFT JOIN QDEComments Q2
                            ON Q1.Form_id = Q2.Form_id)
                     LEFT JOIN QuestionForm QF
                            ON Q1.QuestionForm_id = QF.QuestionForm_id
    WHERE Q1.strLithoCode = @LithoCode
      AND Q2.QstnCore = @QstnCore
    */
    INSERT INTO #CmntData (SentMail_id, QuestionForm_id, UnusedReturn_id, SampleUnit_id, SamplePop_id, Found, Country_id)
    SELECT IsNull(Q1.SentMail_id, -1), IsNull(Q1.QuestionForm_id, -1), IsNull(QF.UnusedReturn_id, 0), 
           IsNull(Q2.SampleUnit_id, -1), IsNull(QF.SamplePop_id, -1), 1, sm.Country_id 
    FROM ((SentMailing SM LEFT JOIN QDEForm Q1 
                                 ON SM.SentMail_id = Q1.SentMail_id)
                          LEFT JOIN QDEComments Q2
                                 ON Q1.Form_id = Q2.Form_id)
                          LEFT JOIN QuestionForm QF
                                 ON Q1.QuestionForm_id = QF.QuestionForm_id
    WHERE Q1.strLithoCode = @LithoCode
      AND Q2.QstnCore = @QstnCore
END

--Check to see if we still do not have a record
IF (SELECT Count(*) FROM #CmntData) = 0
BEGIN
    --No records were found
    INSERT INTO #CmntData (SentMail_id, QuestionForm_id, UnusedReturn_id, SampleUnit_id, SamplePop_id, Found, Country_id)
    SELECT IsNull(SM.SentMail_id, -1), IsNull(QF.QuestionForm_id, -1), IsNull(QF.UnusedReturn_id, 0), -1, IsNull(QF.SamplePop_id, -1), 0, sm.Country_id 
    FROM SentMailing SM LEFT JOIN QuestionForm QF 
                               ON SM.SentMail_id = QF.SentMail_id 
    WHERE SM.strLithoCode = @LithoCode
END

--Select the result set
SELECT SentMail_id, QuestionForm_id, UnusedReturn_id, SampleUnit_id, SamplePop_id, Found, Country_id
FROM #CmntData

--Cleanup
DROP TABLE #CmntData

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


