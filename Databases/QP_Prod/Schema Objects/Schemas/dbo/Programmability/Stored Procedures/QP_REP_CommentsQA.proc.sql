CREATE PROCEDURE QP_REP_CommentsQA
 @Associate VARCHAR(50),
 @LithoCode VARCHAR(2000)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--DECLARE @LithoCode VARCHAR(2000)
DECLARE @SQL VARCHAR(5000), @Litho2 VARCHAR(4000)
--SET @LithoCode = '17994249,17994271,17994295,17994281,17994287,18013903,18013900,18014019'

SET @Litho2 = REPLACE(@LithoCode,',',''',''')

CREATE TABLE #QFList (strLithoCode VARCHAR(10), QuestionForm_id INT, Cmnt_id INT, bitDone BIT)
CREATE TABLE #Results (LithoCode VARCHAR(10), CmntType VARCHAR(15), CmntValence VARCHAR(10), CmntCode VARCHAR(50), CmntTEXT TEXT, CmntTEXTUM TEXT)
SET @sql = 'INSERT INTO #QFList' +CHAR(10)+
'SELECT sm.strLithoCode, qf.QuestionForm_id, c.Cmnt_id, 0'+CHAR(10)+
'FROM Comments c, QuestionForm qf, SentMailing sm'+CHAR(10)+
'WHERE c.QuestionForm_id = qf.QuestionForm_id'+CHAR(10)+
'AND qf.SentMail_id = sm.SentMail_id'+CHAR(10)+
'AND sm.strLithoCode in (''' + @Litho2 + ''')'
EXEC (@SQL)

DECLARE @QFID INT, @Cmnt_id int
WHILE (SELECT COUNT(*) FROM #QFList WHERE bitDone = 0) > 0
begin
SET @qfid = (SELECT top 1 QuestionForm_id FROM #QFList WHERE bitDone=0)
SET @Cmnt_id = (SELECT top 1 Cmnt_id FROM #QFList WHERE bitDone=0)

INSERT INTO #Results 
SELECT q.strLithoCode, ct.strCmntType_nm, cv.strCmntValence_nm, '', c.strCmntTEXT, c.strCmntTEXTUM
FROM #QFlist q, Comments c, CommentValences cv, CommentTypes ct
WHERE q.QuestionForm_id = c.QuestionForm_id
AND q.Cmnt_id = c.Cmnt_id
AND c.CmntValence_id = cv.CmntValence_id
AND c.CmntType_id = ct.CmntType_id
AND c.QuestionForm_id = @qfid
AND c.Cmnt_id = @Cmnt_id

INSERT INTO #Results 
SELECT '','','', cc.strCmntCode_nm, '',''
FROM Comments c, Commentcodes cc, Commentselcodes cs
WHERE c.Cmnt_id = cs.Cmnt_id
AND cs.Cmntcode_id = cc.Cmntcode_id
AND c.QuestionForm_id = @qfid
AND c.Cmnt_id = @Cmnt_id

UPDATE #QFList SET bitDone = 1 WHERE QuestionForm_id = @qfid AND Cmnt_id = @Cmnt_id
END

SELECT * FROM #Results

DROP TABLE #Results
DROP TABLE #qflist

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


