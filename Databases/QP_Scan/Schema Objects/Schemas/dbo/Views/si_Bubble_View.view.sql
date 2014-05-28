﻿CREATE VIEW dbo.si_Bubble_View
AS

SELECT BP.QUESTIONFORM_ID, BP.INTPAGE_NUM, BP.QSTNCORE, BP.READMETHOD_ID, BP.INTBEGCOLUMN, BP.INTRESPCOL, BP.SAMPLEUNIT_ID, COUNT(*) AS NumberOfBubbles
FROM dbo.BUBBLEPOS BP INNER JOIN dbo.BUBBLEITEMPOS BIP 
                              ON BP.INTPAGE_NUM = BIP.INTPAGE_NUM 
                             AND BP.QUESTIONFORM_ID = BIP.QUESTIONFORM_ID 
                             AND BP.SAMPLEUNIT_ID = BIP.SAMPLEUNIT_ID 
                             AND BP.QSTNCORE = BIP.QSTNCORE
WHERE (BP.READMETHOD_ID > 0)
GROUP BY BP.QUESTIONFORM_ID, BP.INTPAGE_NUM, BP.QSTNCORE, BP.READMETHOD_ID, BP.INTBEGCOLUMN, BP.INTRESPCOL, BP.SAMPLEUNIT_ID


