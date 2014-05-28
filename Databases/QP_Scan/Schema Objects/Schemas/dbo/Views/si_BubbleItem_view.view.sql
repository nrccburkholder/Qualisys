CREATE VIEW dbo.si_BubbleItem_view
AS
 
SELECT BIP.QuestionForm_Id, BIP.intPage_Num, BIP.SampleUnit_id, BIP.QstnCore, BIP.Item,
     case when BIP.intPage_num=2 and BIP.survey_id in (296,337,338,1019,1020,1021,1483,1485,1486,1492,1494,1493) then BIP.x_pos - 5100 else BIP.x_pos end as x_pos,
     BIP.y_pos, BIP.Val, BP.intBegColumn
 FROM BubbleItemPos BIP, BubblePos BP
 WHERE BP.intPage_Num = BIP.intPage_Num
   AND BP.QuestionForm_Id = BIP.QuestionForm_Id
   AND BP.SampleUnit_ID = BIP.SampleUnit_ID
   AND BP.QstnCore = BIP.QstnCore
   AND BP.ReadMethod_Id > 0


