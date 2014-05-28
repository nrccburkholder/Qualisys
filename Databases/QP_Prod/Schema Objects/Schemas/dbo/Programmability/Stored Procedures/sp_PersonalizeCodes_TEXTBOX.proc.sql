/****** Object:  Stored Procedure dbo.sp_PersonalizeCodes_TEXTBOX    Script Date: 3/31/99 1:03:01 PM ******/
/****** Object:  Stored Procedure dbo.sp_PersonalizeCodes_TEXTBOX    Script Date: 3/12/99 4:16:08 PM ******/
/****** Object:  Stored Procedure dbo.sp_PersonalizeCodes_TEXTBOX    Script Date: 1/27/99 10:13:09 AM ******/
/* This procedure personalizes all the entries in TextBox_individual */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
/* DV 8/25/1999 - Added WITH LOG to UPDATETEXT so we can run with transaction logging */
/* DV 9/22/1999 - Changed to use a tmp table with VC(8000), no more cursor loop. */
/* 9/30/1999 DV - Removed check for NULL richtext fields, we get the same answer either way. */
/* And this is a bit faster. */
CREATE PROCEDURE sp_PersonalizeCodes_TEXTBOX
AS
/* Create out temp table with VCText field */
 CREATE TABLE #textbox_individual (
  IndivTextBox_id int,
  VCText varchar(8000)
 )
 CREATE TABLE #PopCodeTBMax (
  IndivTextBox_id int,
  intStartPos int
 )
/* Populate out table with the Qstns that we will be personalizing */
 INSERT INTO #textbox_individual (
  IndivTextBox_id, VCText
 ) SELECT
  ti.IndivTextBox_id, ti.richtext
 FROM dbo.TextBox_Individual ti,
  (SELECT DISTINCT IndivTextBox_id FROM dbo.PopCodeTextBox) pctb
 WHERE ti.IndivTextBox_id = pctb.IndivTextBox_id
 IF @@ROWCOUNT > 0
 BEGIN
/* Starting from the end, get the maximum length out of PopCodeQ2 and Stuff that into
** the Varchar field. In the stuff, we need the +1 because UPDATETEXT was 0 based, STUFF is
** 1 based on the character strings. */
  INSERT INTO #PopCodeTBMax (
   IndivTextBox_id, intStartPos
  ) SELECT IndivTextBox_id, MAX(intStartPos)
  FROM dbo.PopCodeTextBox
  GROUP BY IndivTextBox_id
  WHILE @@ROWCOUNT > 0
  BEGIN
   UPDATE #TextBox_Individual
   SET VCText = STUFF(ti.VCText, pctb.intstartpos + 1, pctb.intlength, ltrim(rtrim(pctb.strCodeValue)))
   FROM #TextBox_Individual ti, dbo.PopCodeTextBox pctb, #PopCodeTBMax pctbm
   WHERE pctbm.IndivTextBox_id = pctb.IndivTextBox_id
   AND pctbm.intStartPos = pctb.intStartPos
   AND pctb.IndivTextBox_id = ti.IndivTextBox_id
 
   DELETE dbo.PopCodeTextBox
   FROM #PopCodeTBMax
   WHERE dbo.PopCodeTextBox.IndivTextBox_id = #PopCodeTBMax.IndivTextBox_id
   AND dbo.PopCodeTextBox.intStartPos = #PopCodeTBMax.intStartPos
 
   TRUNCATE TABLE #PopCodeTBMax
 
   INSERT INTO #PopCodeTBMax (
    IndivTextBox_id, intStartPos 
   ) SELECT IndivTextBox_id, MAX(intStartPos)
   FROM dbo.PopCodeTextBox
   GROUP BY IndivTextBox_id
  END
/* Finally, push the new varchar back into the Text field. */
  UPDATE dbo.TextBox_Individual
  SET RichText = #TextBox_individual.VCText
  FROM #TextBox_individual
  WHERE #TextBox_individual.IndivTextBox_id = dbo.TextBox_individual.IndivTextBox_id
 END
 DROP TABLE #Textbox_individual
 DROP TABLE #PopCodeTBMax


