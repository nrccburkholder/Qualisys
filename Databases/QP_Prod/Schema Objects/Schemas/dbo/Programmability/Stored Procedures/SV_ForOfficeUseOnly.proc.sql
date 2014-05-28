CREATE PROCEDURE dbo.SV_ForOfficeUseOnly
@Survey_id INT
AS
SELECT DISTINCT 1 bitError, '"For Office Use Only" NOT personalized exclusively using POPULATION table' strMessage
FROM   SEL_Qstns SQ, CodeQstns CQ, Codes CD, CodesText CT, CodeTextTag CTT, Tag TG, TagField TF, 
       MetaTable MT, Survey_def sd 
WHERE sq.Survey_id=@Survey_id
AND sq.Subtype IN (5,6) 
AND sq.SelQstns_id=cq.SelQstns_id 
AND sq.Survey_id=cq.Survey_id 
AND sq.Language=cq.Language 
AND sq.Survey_id=sd.Survey_id 
AND sd.Study_id=tf.Study_id 
AND cq.Code=cd.Code 
AND cd.Code=ct.Code 
AND ct.CodeText_id=ctt.CodeText_id 
AND ctt.Tag_id=tg.Tag_id 
AND tg.Tag_id=tf.Tag_id 
AND tf.Table_id=mt.Table_id 
AND mt.Table_id NOT IN ( 
  SELECT mt.Table_id 
  FROM MetaTable mt, Study s 
  WHERE mt.Study_id=sd.Study_id 
  AND mt.Study_id=s.Study_id 
  AND sd.Survey_id=@Survey_id)
IF @@ROWCOUNT=0
SELECT 0 bitError, '"For Office Use Only" validation' strMessage


