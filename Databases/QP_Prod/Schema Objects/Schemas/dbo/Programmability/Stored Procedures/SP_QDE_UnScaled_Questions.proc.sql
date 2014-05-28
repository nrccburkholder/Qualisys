CREATE PROCEDURE SP_QDE_UnScaled_Questions @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

CREATE TABLE #Unscaled_Questions (Survey_id INT,QstnCore INT,Label VARCHAR(60),strCmntorhand CHAR(1))  
  
INSERT INTO #Unscaled_Questions (Survey_id,QstnCore,Label,strCmntorhand)  
SELECT Survey_id,QstnCore,questionLabel,strCmntorhand  
FROM Comments_Unscaled_Questions_View
WHERE Survey_id=@Survey_id  
  
UPDATE u  
SET u.Label=t.Label,u.strCmntorhand=t.strCmntorhand  
FROM #Unscaled_Questions t,Unscaled_Questions u  
WHERE t.Survey_id=u.Survey_id  
AND t.QstnCore=u.QstnCore  
  
DELETE t  
FROM #Unscaled_Questions t,Unscaled_Questions u  
WHERE t.Survey_id=u.Survey_id  
AND t.QstnCore=u.QstnCore  
  
INSERT INTO Unscaled_Questions (Survey_id,QstnCore,Label,strCmntorhand)  
SELECT Survey_id,QstnCore,Label,strCmntorhand  
FROM #Unscaled_Questions  
  
DROP TABLE #Unscaled_Questions  

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


