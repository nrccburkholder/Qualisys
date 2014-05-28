CREATE PROCEDURE dbo.SV_TagReplacements  
@Survey_id INT  
AS  

CREATE TABLE #Tags (Tag INT)

INSERT INTO #Tags
SELECT Tag_id FROM CodeTextTag ctt WHERE CodeText_id IN  
(SELECT CodeText_id FROM Codestext WHERE Code IN  
(SELECT Code FROM Codeqstns WHERE Survey_id=@Survey_id
 UNION SELECT Code FROM Codescls WHERE Survey_id=@Survey_id  
 UNION SELECT Code FROM Codetxtbox WHERE Survey_id=@Survey_id))
GROUP BY Tag_id

SELECT DISTINCT 1 bitError, 'Tags exist that are not mapped to a Field or Literal Value' strMessage  
FROM #Tags t LEFT OUTER JOIN (
     SELECT tf.Tag_id, Table_id, Field_id, strReplaceLiteral 
     FROM Survey_Def sd, TagField tf  
WHERE sd.Study_id=tf.Study_id  
AND Survey_id=@Survey_id) a
ON t.Tag=a.Tag_id
WHERE Table_id IS NULL  
AND Field_id IS NULL  
AND strReplaceLiteral IS NULL  
IF @@ROWCOUNT=0  
SELECT 0 bitError, 'All tags are mapped to a field or literal value' strMessage  
  
DROP TABLE #Tags


