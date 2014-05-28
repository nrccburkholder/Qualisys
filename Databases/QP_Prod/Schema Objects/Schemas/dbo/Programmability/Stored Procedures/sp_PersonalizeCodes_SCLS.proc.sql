/****** Object:  Stored Procedure dbo.sp_PersonalizeCodes_SCLS    Script Date: 3/31/99 1:03:01 PM ******/
/****** Object:  Stored Procedure dbo.sp_PersonalizeCodes_SCLS    Script Date: 3/12/99 4:16:08 PM ******/
/****** Object:  Stored Procedure dbo.sp_PersonalizeCodes_SCLS    Script Date: 1/27/99 10:13:09 AM ******/
/* This procedure personalizes all the entries in Scls_individual */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
/* DV 8/25/1999 - Added WITH LOG to UPDATETEXT so we can run with transaction logging */
/* DV 9/22/1999 - Changed to use a tmp table with VC(8000), no more cursor loop. */
/* 9/30/1999 DV - Removed check for NULL richtext fields, we get the same answer either way. */
/* And this is a bit faster. */
CREATE PROCEDURE sp_PersonalizeCodes_SCLS
AS
/* Create out temp table VCText field */
 CREATE TABLE #scls_individual (
  QuestionForm_id int,
  Survey_id int,
  QPC_ID int,
  Item int,
  Language int,
  VCText varchar(8000)
 )
 CREATE TABLE #PopCodeS2Max (
  QuestionForm_id int,
  Survey_id int,
  QPC_ID int,
  Item int,
  Language int,
  intStartPos int
 )
/* Populate out table with the Qstns that we will be personalizing */
 INSERT INTO #scls_individual (
  QuestionForm_id, Survey_id, QPC_ID, Item, Language, VCText
 ) SELECT
  si.QuestionForm_id, si.Survey_id, si.QPC_ID, si.Item, si.Language, si.richtext
 FROM dbo.Scls_Individual si,
  (SELECT DISTINCT QuestionForm_id, Survey_id, QPC_ID, Item, Language
   FROM dbo.PopCodeS2) pcs2
 WHERE pcs2.QuestionForm_id = si.QuestionForm_id
 AND pcs2.Survey_id = si.Survey_id
 AND pcs2.QPC_ID = si.QPC_ID
 AND pcs2.Item = si.Item
 AND pcs2.Language = si.Language
 IF @@ROWCOUNT > 0
 BEGIN
/* Starting from the end, get the maximum length out of PopCodeQ2 and Stuff that into
** the Varchar field. In the stuff, we need the +1 because UPDATETEXT was 0 based, STUFF is
** 1 based on the character strings. */
  INSERT INTO #PopCodeS2Max (
   QuestionForm_id, Survey_id, QPC_ID, Item, Language, intStartPos
  ) SELECT QuestionForm_id, Survey_id, QPC_ID, Item, Language, MAX(intStartPos)
  FROM dbo.PopCodeS2
  GROUP BY QuestionForm_id, Survey_id, QPC_ID, Item, Language
  WHILE @@ROWCOUNT > 0
  BEGIN
   UPDATE #Scls_Individual
   SET VCText = STUFF(si.VCText, pcs2.intstartpos + 1, pcs2.intlength, ltrim(rtrim(pcs2.strCodeValue)))
   FROM #Scls_Individual si, dbo.PopCodeS2 pcs2, #PopCodeS2Max pcs2m
   WHERE pcs2m.QuestionForm_id = pcs2.QuestionForm_id
   AND pcs2m.Survey_id = pcs2.Survey_id
   AND pcs2m.QPC_ID = pcs2.QPC_ID
   AND pcs2m.Item = pcs2.Item
   AND pcs2m.Language = pcs2.Language
   AND pcs2m.intStartPos = pcs2.intStartPos
   AND pcs2.QuestionForm_id = si.QuestionForm_id
   AND pcs2.Survey_id = si.Survey_id
   AND pcs2.QPC_ID = si.QPC_ID
   AND pcs2.Item = si.Item
   AND pcs2.Language = si.Language
 
   DELETE dbo.PopCodeS2
   FROM #PopCodeS2Max
   WHERE #PopCodeS2Max.QuestionForm_id = dbo.PopCodeS2.QuestionForm_id
   AND #PopCodeS2Max.Survey_id = dbo.PopCodeS2.Survey_id
   AND #PopCodeS2Max.QPC_ID = dbo.PopCodeS2.QPC_ID
   AND #PopCodeS2Max.Item = dbo.PopCodeS2.Item
   AND #PopCodeS2Max.Language = dbo.PopCodeS2.Language
   AND #PopCodeS2Max.intStartPos = dbo.PopCodeS2.intStartPos
 
   TRUNCATE TABLE #PopCodeS2Max
 
   INSERT INTO #PopCodeS2Max (
    QuestionForm_id, Survey_id, QPC_ID, Item, Language, intStartPos
   ) SELECT QuestionForm_id, Survey_id, QPC_ID, Item, Language, MAX(intStartPos)
   FROM dbo.PopCodeS2
   GROUP BY QuestionForm_id, Survey_id, QPC_ID, Item, Language
  END
/* Finally, push the new varchar back into the Text field. */
  UPDATE dbo.Scls_Individual
  SET RichText = #scls_individual.VCText
  FROM #scls_individual
  WITH (NOLOCK)
  WHERE #scls_individual.QuestionForm_id = dbo.Scls_Individual.QuestionForm_id
  AND #scls_individual.Survey_id = dbo.Scls_Individual.Survey_id
  AND #scls_individual.QPC_ID = dbo.Scls_Individual.QPC_ID
  AND #scls_individual.Item = dbo.Scls_Individual.Item
  AND #scls_individual.Language = dbo.Scls_Individual.Language
 END
 DROP TABLE #scls_individual
 DROP TABLE #PopCodeS2Max


