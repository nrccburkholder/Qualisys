CREATE FUNCTION [dbo].[MNCMCompleteness] (@QuestionForm_id INT)      
RETURNS BIT      
AS      
BEGIN      
  

DECLARE @Adult_Visit int 
SET @Adult_Visit = 39113

DECLARE @Adult_12MonthVisit int 
SET @Adult_12MonthVisit = 46385

DECLARE @Adult_12MonthVisit_PCMH int
SET @Adult_12MonthVisit_PCMH = 44121

DECLARE @Child_12MonthVisit_PCMH int
SET @Child_12MonthVisit_PCMH = 46265

DECLARE @Cnt INT, @Complete BIT  


IF @Adult_Visit  = (select distinct QstnCore from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore =39113)
BEGIN
SELECT @Cnt=COUNT(distinct qr.QstnCore)      
FROM QuestionResult qr, QuestionForm qf, Sel_Qstns sq, Sel_Scls ss      
WHERE qr.QuestionForm_id=@QuestionForm_id      
AND qr.QstnCore IN   
	(39113,39114,39115,39116,39117,39119,39121,39123,39125,39126,39127,39130,
	 39131,39132,39134,39135,39136,39128,39137,39138,39139,39140,39151,46688,
	 39156,39157,39158,39159,39160,40716)  
AND qr.QuestionForm_id=qf.QuestionForm_id      
AND qf.Survey_id=sq.Survey_id      
AND qr.QstnCore=sq.QstnCore      
AND sq.subType=1      
AND sq.Language=1      
AND sq.Scaleid=ss.Qpc_id      
AND sq.Survey_id=ss.Survey_id      
AND ss.Language=1      
AND qr.intResponseVal=ss.Val      
      
--must answer 15 out of 30 questions      
IF @cnt>=15      
SELECT @Complete=1      
ELSE       
SELECT @Complete=0      
END   




ELSE IF @Adult_12MonthVisit = (select distinct QstnCore from  QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore =46385)
BEGIN
SELECT @Cnt=COUNT(distinct qr.QstnCore)      
FROM QuestionResult qr, QuestionForm qf, Sel_Qstns sq, Sel_Scls ss      
WHERE qr.QuestionForm_id=@QuestionForm_id      
AND qr.QstnCore IN   
	(46385,44423,44424,44425,44426,44428,44430,44432,44434,44435,
	 44436,44437,44439,44440,44441,44442,44444,44445,44446,44447,
	 46689,44452,44453,44454,44455,44456,44457
	)	  
AND qr.QuestionForm_id=qf.QuestionForm_id      
AND qf.Survey_id=sq.Survey_id      
AND qr.QstnCore=sq.QstnCore      
AND sq.subType=1      
AND sq.Language=1      
AND sq.Scaleid=ss.Qpc_id      
AND sq.Survey_id=ss.Survey_id      
AND ss.Language=1      
AND qr.intResponseVal=ss.Val     

--must answer 14 out of 27 questions   
IF @cnt>=14     
SELECT @Complete=1      
ELSE       
SELECT @Complete=0      
END  

ELSE IF @Adult_12MonthVisit_PCMH = (select distinct QstnCore from  QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore =44121)
BEGIN
SELECT @Cnt=COUNT(distinct qr.QstnCore)      
FROM QuestionResult qr, QuestionForm qf, Sel_Qstns sq, Sel_Scls ss      
WHERE qr.QuestionForm_id=@QuestionForm_id      
AND qr.QstnCore IN   
	(44121,44122,44123,44124,44125,44129,44139,44141,44148,44150,
	 44152,44155,44158,44161,44162,44168,44181,44201,44202,44203,
	 44204,44226,44227,44228,44229,44230,44234,48664
	)	  
AND qr.QuestionForm_id=qf.QuestionForm_id      
AND qf.Survey_id=sq.Survey_id      
AND qr.QstnCore=sq.QstnCore      
AND sq.subType=1      
AND sq.Language=1      
AND sq.Scaleid=ss.Qpc_id      
AND sq.Survey_id=ss.Survey_id      
AND ss.Language=1      
AND qr.intResponseVal=ss.Val     


--must answer 14 out of 27 questions 
IF @cnt>=14     
SELECT @Complete=1      
ELSE       
SELECT @Complete=0      
END


ELSE IF @Child_12MonthVisit_PCMH = (select distinct QstnCore from  QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore =46265)
BEGIN
SELECT @Cnt=COUNT(distinct qr.QstnCore)      
FROM QuestionResult qr, QuestionForm qf, Sel_Qstns sq, Sel_Scls ss      
WHERE qr.QuestionForm_id=@QuestionForm_id      
AND qr.QstnCore IN   
	(46265,46266,46267,46268,46269,46274,46276,46279,46284,46286,
	 46289,46290,46291,46292,46294,46295,46296,46297,46299,46302,
	 46303,46304,46305,46306,46307,46308,46309,46310,46311,46312,
	 46317,46318,46319,46320,46321,46322,46323,46324,46325,46326,
	 46327,46328,46329,48856,48666,48667
	)	  
AND qr.QuestionForm_id=qf.QuestionForm_id      
AND qf.Survey_id=sq.Survey_id      
AND qr.QstnCore=sq.QstnCore      
AND sq.subType=1      
AND sq.Language=1      
AND sq.Scaleid=ss.Qpc_id      
AND sq.Survey_id=ss.Survey_id      
AND ss.Language=1      
AND qr.intResponseVal=ss.Val     

--must answer 22 out of 43 questions 
IF @cnt>=22  
SELECT @Complete=1      
ELSE       
SELECT @Complete=0      
END


 
ELSE  
SELECT @Complete=0



RETURN @Complete      
      
END


