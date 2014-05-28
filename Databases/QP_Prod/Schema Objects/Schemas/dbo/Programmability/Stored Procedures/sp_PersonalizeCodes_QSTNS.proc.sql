/****** Object:  Stored Procedure dbo.sp_PersonalizeCodes_QSTNS    Script Date: 3/31/99 1:03:01 PM ******/
/****** Object:  Stored Procedure dbo.sp_PersonalizeCodes_QSTNS    Script Date: 3/12/99 4:16:08 PM ******/
/****** Object:  Stored Procedure dbo.sp_PersonalizeCodes_QSTNS    Script Date: 1/27/99 10:13:09 AM ******/
/* This procedure personalizes all the entries in Qstns_individual */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
/* DV 8/25/1999 - Added WITH LOG to UPDATETEXT so we can run with transaction logging */
/* DV 9/22/1999 - Changed to use a tmp table with VC(8000), no more cursor loop. */
/* 9/30/1999 DV - Removed check for NULL richtext fields, we get the same answer either way. */
/* And this is a bit faster. */
CREATE PROCEDURE sp_PersonalizeCodes_QSTNS
AS
/* Create out temp table with the IndivQstns_id and a VCText field */
 CREATE TABLE #qstns_individual (
  indivqstns_id int,
  VCText varchar(8000)
 )
 CREATE TABLE #PopCodeQ2Max (
  IndivQstns_id int,
  intStartPos int
 )
/* Populate out table with the Qstns that we will be personalizing */
 INSERT INTO #qstns_individual (
  indivqstns_id, VCText
 ) SELECT
  qi.indivqstns_id, qi.richtext
 FROM dbo.Qstns_Individual qi,
  (SELECT DISTINCT IndivQstns_id FROM dbo.PopCodeQ2) pcq2
 WHERE qi.indivqstns_id = pcq2.indivqstns_id
 IF @@ROWCOUNT > 0
 BEGIN
/* Starting from the end, get the maximum length out of PopCodeQ2 and Stuff that into
** the Varchar field. In the stuff, we need the +1 because UPDATETEXT was 0 based, STUFF is
** 1 based on the character strings. */
  INSERT INTO #PopCodeQ2Max (
   Indivqstns_id, intStartPos
  ) SELECT IndivQstns_id, MAX(intStartPos)
  FROM dbo.PopCodeQ2
  GROUP BY IndivQstns_id
  WHILE @@ROWCOUNT > 0
  BEGIN
   UPDATE #Qstns_Individual
   SET VCText = STUFF(qi.VCText, pcq2.intstartpos + 1, pcq2.intlength, ltrim(rtrim(pcq2.strCodeValue)))
   FROM #Qstns_Individual qi, dbo.PopCodeQ2 pcq2, #PopCodeQ2Max pcq2m
   WHERE pcq2m.IndivQstns_id = pcq2.IndivQstns_id
   AND pcq2m.intStartPos = pcq2.intStartPos
   AND pcq2.IndivQstns_id = qi.IndivQstns_id
 
   DELETE dbo.PopCodeQ2
   FROM #PopCodeQ2Max
   WHERE dbo.PopCodeQ2.IndivQstns_id = #PopCodeQ2Max.IndivQstns_id
   AND dbo.PopCodeQ2.intStartPos = #PopCOdeQ2Max.intStartPos
 
   TRUNCATE TABLE #PopCodeQ2Max
 
   INSERT INTO #PopCodeQ2Max (
    Indivqstns_id, intStartPos
   ) SELECT IndivQstns_id, MAX(intStartPos)
   FROM dbo.PopCodeQ2
   GROUP BY IndivQstns_id
  END
/* Finally, push the new varchar back into the Text field. */
  UPDATE dbo.Qstns_Individual
  SET RichText = #qstns_individual.VCText
  FROM #qstns_individual
  WHERE #qstns_individual.indivqstns_id = dbo.Qstns_individual.indivqstns_id
 END
 DROP TABLE #qstns_individual
 DROP TABLE #PopCodeQ2Max


