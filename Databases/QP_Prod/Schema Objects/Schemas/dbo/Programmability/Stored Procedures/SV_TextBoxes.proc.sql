CREATE PROCEDURE dbo.SV_TextBoxes
@Survey_id INT
AS
SELECT DISTINCT 1 bitError, 'Cover letter text boxes NOT personalized exclusively using POPULATION table' strMessage
FROM   CodeTxtBox ctb, CodesText ct, CodeTextTag ctt, TagField tf, Survey_def sd 
WHERE  ctb.Survey_id=@Survey_ID
AND ctb.Code=ct.Code 
AND ct.CodeText_id=ctt.CodeText_id 
AND ctt.Tag_id=tf.Tag_id 
AND ctb.Survey_id=sd.Survey_id 
AND sd.Study_id=tf.Study_id 
AND tf.Table_id NOT IN (
   SELECT mt.Table_id 
   FROM MetaTable mt, Study s 
   WHERE sd.Survey_id=@Survey_ID
   AND mt.Study_id=sd.Study_id 
   AND mt.Study_id=s.Study_id)
IF @@ROWCOUNT=0
SELECT 0 bitError, 'Cover letter text boxes personalization validation' strMessage


