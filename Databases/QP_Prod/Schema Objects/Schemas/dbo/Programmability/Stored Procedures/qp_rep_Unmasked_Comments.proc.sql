CREATE PROCEDURE qp_rep_Unmasked_Comments
 @Associate VARCHAR(50),
 @LithoCode VARCHAR(3000)
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
DECLARE @SQL VARCHAR(500), @Litho VARCHAR(10), @Litho2 VARCHAR(5000)

CREATE TABLE #Lithos (Litho VARCHAR(10), QuestionForm_id INT)

SET @Litho2 = REPLACE(@LithoCode,',',''',''')

SET @SQL = 'INSERT INTO #Lithos
SELECT strLithoCode, qf.QuestionForm_id
FROM SentMailing sm, QuestionForm qf
WHERE sm.SentMail_id = qf.SentMail_id
AND sm.strLithoCode in (''' + @Litho2 + ''')'

EXEC (@SQL)

CREATE TABLE #Results (Litho VARCHAR(10), Length INT, [OPEN With] VARCHAR(10), [Type] VARCHAR(10), Comment TEXT)
DECLARE LithoCur CURSOR FOR SELECT Litho FROM #Lithos
OPEN LithoCur
FETCH NEXT FROM LithoCur INTO @Litho

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO #Results
 SELECT Litho, DATALENGTH(strCmntTEXTum), CASE WHEN DATALENGTH(strCmntTEXTum) > 1820 THEN 'TEXT File' ELSE 'Excel' END, 'Unmasked', isNULL(strCmntTEXTum,'No Unmasked Comment Available')
 FROM Comments c, #Lithos l
 WHERE c.QuestionForm_id = l.QuestionForm_id
 AND l.Litho = @Litho

 INSERT INTO #Results
 SELECT '', NULL, '', 'Masked',  strCmntTEXT
 FROM Comments c, #Lithos l
 WHERE c.QuestionForm_id = l.QuestionForm_id
 AND l.Litho = @Litho

FETCH NEXT FROM LithoCur INTO @Litho
END

SELECT * FROM #Results
CLOSE LithoCur
DEALLOCATE LithoCur
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


